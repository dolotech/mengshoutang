package game.fight
{
import com.utils.NumberDisplay;

import game.data.Val;
import game.manager.AssetMgr;
import game.net.data.vo.BattleTarget;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Sprite;
import starling.textures.Texture;

/**
	 * 战斗掉血&加血
	 * @author joy
	 */
	public class DropHPNumber extends Sprite
	{
		/**
		 * 
		 * @param power
		 * @param command
		 * @param hero  
		 * @param x
		 * @param y
		 * @param type
		 * @param mask
		 */
		public function DropHPNumber(power:String, command:BattleTarget,color:uint)
		{
			var fontSize:int=command.state & Val.BJ ? 50 : 30;
            var vector:Vector.<Texture> = new Vector.<Texture>();
            for (var i:int = 0;i<10;i++)
            {
                var str:String = power.charAt(0);
                str = str == "-"?"red":"green";
                var texture:Texture = AssetMgr.instance.getTexture(str + i);
                vector[i] = texture;
            }

            vector[10] =  AssetMgr.instance.getTexture("redSub");
            vector[11] =  AssetMgr.instance.getTexture("greenAdd");

            _number = new NumberDisplay(vector);
            command.state & Val.BJ?_number.scaleX=_number.scaleY=1.5:null;
            _number.number = power;
            _number.x=-_number.width / 2;
            _number.y=-_number.height / 2;
			this.addChild(_number);
            _number.scaleX = _number.scaleY = 0;
            Starling.juggler.tween(_number,0.3,{y:- 80,scaleX:1,scaleY:1,onComplete:onTweenComplete,transition:Transitions.EASE_IN})  ;
		}
        private var _number:NumberDisplay;

        private function onTweenComplete():void
        {
            Starling.juggler.delayCall(delay,0.5);

            function delay():void
            {
                Starling.juggler.tween(_number,0.3,{y:- 120,alpha:0,onComplete:remove,transition:Transitions.EASE_OUT})  ;
            }
        }

        private  function  remove():void
        {
            this.removeFromParent(true);
        }

        override  public function dispose():void
        {
            _number &&   Starling.juggler.removeTweens(_number);
			_number && _number.removeFromParent(true);
            super .dispose();
        }
	}
}
