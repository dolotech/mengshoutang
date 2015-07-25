package game.view.comm.menu
{
	import org.osflash.signals.ISignal;
	
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class MenuButton extends Button
	{
		private  var onFocusOut:ISignal ;
		private var index:int = 0;
		public function MenuButton(upState:Texture,onFocusOut:ISignal, text:String="",  downState:Texture=null)
		{
			super(upState, text, downState);
			selectSkin = downState;
			noSelectSkin = upState;
			this.onFocusOut = onFocusOut;
			this.addEventListener(Event.TRIGGERED,onClick);
			
			onFocusOut.add(focusOut);
			downState = null;
		}
		
		private var selectSkin:Texture;
		private var noSelectSkin:Texture;;
		public function focusOut(target:MenuButton,e:Event = null):void
		{
			if(click && 
				this.upState != selectSkin &&target == this && e )
			{
				click.apply(this,[e]);
			}
			if(this.parent && target != this )
			{
				if(this.upState == selectSkin)
				{
					this.upState = noSelectSkin;
				}
				else if(selectSkin == null)
				{
					this.getChildAt(0).visible = true;
				}
			}
		}
		private var click:Function;
		public function set onTouchClick(click:Function):void
		{
			this.click = click;
		}
		
		public function select():void
		{
			if(selectSkin)
			{
				this.upState = selectSkin;
			}
			else this.getChildAt(0).visible = false;
			onFocusOut.dispatch(this);
		}
		
		public function onClick(e:Event):void
		{
			onFocusOut.dispatch(this,e);
			if(selectSkin)
				this.upState = selectSkin;
			else this.getChildAt(0).visible = false;
			
		}
		
		public function down():void
		{
			this.upState = selectSkin;
		}
		
		override public function dispose():void
		{
			super.dispose();
			onFocusOut.remove(focusOut);
			click = null;
			
//			trace(this,"menuButton dispose");
		}
	}
}