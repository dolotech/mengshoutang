package game.view.battle
{
	import com.sound.SoundManager;
	
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
import game.manager.BattleAssets;

import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	import treefortress.spriter.SpriterClip;
	import com.utils.Constants;
	
	public class VSEntify
	{
		private var _clip:SpriterClip;
		private var _container:Sprite;
		public var onComplete:ISignal;
		
		public function VSEntify(container:Sprite)
		{
			onComplete = new Signal(VSEntify);
			_container = container;
			_clip = AnimationCreator.instance.create("effect_003",BattleAssets.instance);
			_clip.animationComplete.addOnce(complete);
			_clip.play("effect_003");
			_clip.animation.looping = false;
			Starling.juggler.add(_clip);
			
			Constants.setToStageCenter(_clip,0,0,false);
			SoundManager.instance.playSound("vs");
			_container.addChild(_clip);
		}
		
		private function complete(sp:SpriterClip):void
		{
            sp.stop();
            Starling.juggler.add(sp);
			_container.removeChild(sp);
			_clip.dispose();
			onComplete.dispatch(this);
		}
	}
}