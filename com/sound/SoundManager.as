package com.sound
{

	import com.singleton.Singleton;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	import game.uils.LocalShareManager;

	import starling.core.Starling;

	public class SoundManager
	{

		private var _isMuted:Boolean=false; // When true, every change in volume for ALL sounds is ignored

		public var sounds:Dictionary; // contains all the sounds registered with the Sound Manager
		public var currPlayingSounds:Dictionary; // contains all the sounds that are currently playing

		public function SoundManager()
		{
			sounds=new Dictionary();
			currPlayingSounds=new Dictionary();
		}

		private var _currentPlayeing:Array=[];

		public function pauseSound():void
		{
			var i:int=0;

			for (var currID:String in currPlayingSounds)
			{
				var obj:Object=currPlayingSounds[currID];
				_currentPlayeing[i++]=obj;
				stopSound(currID);
			}
		}

		public function resumeSound():void
		{
			var len:int=_currentPlayeing.length;

			for (var i:int=0; i < len; i++)
			{
				var obj:Object=_currentPlayeing[i];
				playSound(obj.id, obj.stopSame, obj.volume, obj.repetitions);
			}
			_currentPlayeing.length=0;
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		public static function get instance():SoundManager
		{
			return Singleton.getInstance(SoundManager) as SoundManager;
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		public function dispose():void
		{
			sounds=null;
			currPlayingSounds=null;
		}

		// -------------------------------------------------------------------------------------------------------------------------			
		/** Add sounds to the sound dictionary */
		public function addSound(id:String, sound:Sound):void
		{
			sounds[id]=sound;
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Remove sounds from the sound manager */
		public function removeSound(id:String):void
		{
			if (soundIsAdded(id))
			{
				delete sounds[id];

				if (soundIsPlaying(id))
					delete currPlayingSounds[id];
			}
			else
			{
				throw Error("The sound you are trying to remove is not in the sound manager");
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Check if a sound is in the sound manager */
		public function soundIsAdded(id:String):Boolean
		{
			return Boolean(sounds[id]);
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Check if a sound is playing */
		public function soundIsPlaying(id:String):Boolean
		{
			return Boolean(currPlayingSounds[id]);
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		private function savePlayState():void
		{
			var str:String="_isEffectOn:" + (_isEffectOn ? 1 : 0) + "," + "_isMusicOn:" + (_isMusicOn ? 1 : 0);
			LocalShareManager.getInstance().save(LocalShareManager.SOUND, str, false);
		}

		private var _isEffectOn:Boolean=true;
		private var _isMusicOn:Boolean=true;

		public function initPlayState():void
		{

			var abc:String=LocalShareManager.getInstance().get(LocalShareManager.SOUND, false);

			if (abc != null)
			{
				_isEffectOn=Boolean(int((abc.split(",")[0].split(":"))[1]));
				_isMusicOn=Boolean(int((abc.split(",")[1].split(":"))[1]));
//				setEffectState(_isEffectOn);
//				setMusicState(_isMusicOn);
			}
		}

		public function getEffectState():Boolean
		{
			return _isEffectOn;
		}

		public function getMusicState():Boolean
		{
			return _isMusicOn;
		}

		public function setEffectState(value:Boolean):void
		{
			_isEffectOn=value;
			savePlayState();
		}

		public function setMusicState(value:Boolean):void
		{
			_isMusicOn=value;
			savePlayState();

			if (_isMusicOn)
			{
				SoundManager.instance.playSound("city_bgm", true, 0, 99999);
				SoundManager.instance.tweenVolume("city_bgm", 1.0, 2);
			}
			else
			{
				stopAllSounds();
			}
		}

		/** Play a sound */
		public function playSound(id:String, stopSame:Boolean=false, volume:Number=1.0, repetitions:int=1, panning:Number=0):void
		{

			//if(DeviceType.getType() == DeviceType.DESKTOP) return;

			if (!_isEffectOn && repetitions == 1)
			{
				return;
			}

			if (!_isMusicOn && repetitions == 99999)
			{
				return;
			}

			if (soundIsAdded(id))
			{
				if (soundIsPlaying(id))
				{
					if (stopSame)
					{
						stopSound(id);
					}
					Starling.juggler.removeTweens(currPlayingSounds[id]);
				}

				var soundObject:Sound=sounds[id];

				var channel:SoundChannel=new SoundChannel();

				channel=soundObject.play(0, repetitions);

				if (!channel)
					return;

				channel.addEventListener(Event.SOUND_COMPLETE, removeSoundFromDictionary);

				// if the sound manager is muted, set the sound's volume to zero
				var v:Number=(_isMuted) ? 0 : volume;
				var s:SoundTransform=new SoundTransform(v, panning);
				channel.soundTransform=s;

				currPlayingSounds[id]={stopSame: stopSame, id: id, channel: channel, sound: soundObject, volume: volume, repetitions: repetitions};
			}
			else
			{
				trace("The sound you are trying to play (" + id + ") is not in the Sound Manager. Try adding it to the Sound Manager first.");
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Remove a sound from the dictionary of the sounds that are currently playing */
		private function removeSoundFromDictionary(e:Event):void
		{

			for (var id:String in currPlayingSounds)
			{
				if (currPlayingSounds[id].channel == e.target)
					delete currPlayingSounds[id];
			}
			e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, removeSoundFromDictionary);
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Stop a sound */
		public function stopSound(id:String):void
		{
			if (soundIsPlaying(id))
			{
				SoundChannel(currPlayingSounds[id].channel).stop();
				delete currPlayingSounds[id];
			}
			else
			{
//				throw Error("The sound you are trying to stop ( " + id + " ) is not currently playing");
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------
		/** Stop all sounds that are currently playing */
		public function stopAllSounds():void
		{
			for (var currID:String in currPlayingSounds)
				stopSound(currID);
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Set a sound's volume */
		public function setVolume(id:String, volume:Number):void
		{
			if (soundIsPlaying(id))
			{
				var s:SoundTransform=new SoundTransform(volume);
				SoundChannel(currPlayingSounds[id].channel).soundTransform=s;
				currPlayingSounds[id].volume=volume;
			}
			else
			{
//				throw Error("This sound (id = " + id + " ) is not currently playing");
			}
		}


		public function tweenVolumeSmall(id:String, volume:Number=0.0, tweenDuration:Number=2):void
		{
			if (soundIsPlaying(id))
			{
				var s:SoundTransform=new SoundTransform();
				Starling.juggler.tween(currPlayingSounds[id], tweenDuration, {volume: volume, onUpdateArgs: [id], onUpdate: updateArgs, onComplete: complete, onCompleteArgs: [id]});
			}
			else
			{
//				throw Error("This sound (id = " + id + " ) is not currently playing");
			}

			function updateArgs(id:String):void
			{
				if (!_isMuted)
				{
					var obj:Object=currPlayingSounds[id];

					if (!obj)
					{
						return;
					}
					var s:SoundTransform=new SoundTransform();
					s.volume=obj.volume;
					SoundChannel(obj.channel).soundTransform=s;
				}
			}

			function complete(id:String):void
			{
				stopSound(id);
			}
		}


		// -------------------------------------------------------------------------------------------------------------------------
		/** Tween a sound's volume */
		public function tweenVolume(id:String, volume:Number=0, tweenDuration:Number=2):void
		{
			if (soundIsPlaying(id))
			{
				var s:SoundTransform=new SoundTransform();
				Starling.juggler.tween(currPlayingSounds[id], tweenDuration, {volume: volume, onUpdate: updateArgs, onUpdateArgs: [id]});
			}
			else
			{
//				throw Error("This sound (id = " + id + " ) is not currently playing");
			}


			function updateArgs(id:String):void
			{
				if (!_isMuted)
				{
					var obj:Object=currPlayingSounds[id];

					if (!obj)
					{
						return;
					}
					var s:SoundTransform=new SoundTransform();
					s.volume=obj.volume;
					SoundChannel(obj.channel).soundTransform=s;
				}
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Cross fade two sounds. N.B. The sounds that fades out must be already playing */
		public function crossFade(fadeOutId:String, fadeInId:String, tweenDuration:Number=2, fadeInVolume:Number=1, fadeInRepetitions:int=1):void
		{

			// If the fade-in sound is not already playing, start playing it
			if (!soundIsPlaying(fadeInId))
				playSound(fadeInId, true, 0, fadeInRepetitions);

			tweenVolume(fadeOutId, 0, tweenDuration);
			tweenVolume(fadeInId, fadeInVolume, tweenDuration);

			// If the fade-out sound is playing, stop it when its volume reaches zero
			if (soundIsPlaying(fadeOutId))
				Starling.juggler.delayCall(stopSound, tweenDuration, fadeOutId);
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Sets a new volume for all the sounds currently playing
		 *  @param volume the new volume value
		 */
		public function setGlobalVolume(volume:Number):void
		{
			var s:SoundTransform;

			for (var currID:String in currPlayingSounds)
			{
				s=new SoundTransform(volume);
				SoundChannel(currPlayingSounds[currID].channel).soundTransform=s;
				currPlayingSounds[currID].volume=volume;
			}
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		/** Mute all sounds currently playing.
		 *  @param mute a Boolean dictating whether all the sounds in the sound manager should be silenced (true) or restored to their original volume (false).
		 */
		public function muteAll(mute:Boolean=true):void
		{

			var s:SoundTransform;

			for (var currID:String in currPlayingSounds)
			{
				s=new SoundTransform(mute ? 0 : currPlayingSounds[currID].volume);
				SoundChannel(currPlayingSounds[currID].channel).soundTransform=s;
			}
			_isMuted=mute;
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		public function getSoundChannel(id:String):SoundChannel
		{
			if (soundIsPlaying(id))
				return SoundChannel(currPlayingSounds[id].channel);

			throw Error("You are trying to get a non-existent soundChannel. Play the sound first in order to assign a channel.");
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		public function getSoundTransform(id:String):SoundTransform
		{
			if (soundIsPlaying(id))
				return SoundChannel(currPlayingSounds[id].channel).soundTransform;

			throw Error("You are trying to get a non-existent soundTransform. Play the sound first in order to assign a transform.");
		}

		// -------------------------------------------------------------------------------------------------------------------------		
		public function getSoundVolume(id:String):Number
		{
			if (soundIsPlaying(id))
				return currPlayingSounds[id].volume;

			throw Error("You are trying to get a non-existent volume. Play the sound first in order to assign a volume.");
		}

		// --------------------------------------------------------------------------------------------------------------------------------------
		// SETTERS & GETTERS
		public function get isMuted():Boolean
		{
			return _isMuted;
		}
	}
}
