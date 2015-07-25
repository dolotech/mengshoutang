package game.hero {
import com.utils.Constants;
import com.utils.ObjectUtil;
import com.utils.Vector2D;

import flash.geom.Rectangle;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

import starling.animation.IAnimatable;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.Event;

/**
 *  游戏场景内可移动的物体
 * @author Michael
 */
public class MoveableEntity extends Sprite implements IAnimatable {
    /**
     *
     */
    public function MoveableEntity() {
        _vector2D = new Vector2D();
		_hitBounds = new Rectangle();
        moveComplete = new Signal(MoveableEntity);
		this.addEventListener(Event.ADDED_TO_STAGE,onAdd);
    }

    /**
     *
     * @default
     */
    public var isMove:Boolean = false;
    /**
     *
     * @default
     */
    public var speed:Number = 0.0;
    /**
     *
     * @default
     */
    public var moveComplete:ISignal;
    /**
     *
     * @default
     */
    protected var _target:DisplayObject;
    private var startX:Number;
    private var startY:Number;;
    private var _gapx:int;
    private var _gapy:int;

    private var _vector2D:Vector2D;
	private var _hitBounds:Rectangle;
	private var _originX:Number = 0;
	private var _originY:Number = 0;
	
    public function get vector2D():Vector2D {
        return _vector2D;
    }
	
	/**
	 * sets the hit bounds width
	 * @param	width
	 */
	public function set hitWidth(width:Number):void
	{
		var rect:Rectangle = getRect(this.x, this.y);
		rect.width = width;
		_hitBounds = rect;
	}
	
	/**
	 * sets the hit bounds height
	 * @param	width
	 */
	public function set hitHeight(height:Number):void
	{
		var rect:Rectangle = getRect(this.x, this.y);
		rect.height = height;
		_hitBounds = rect;
	}
	
	
	/**
	 * returns the width of the entities hit box
	 */
	public function get hitWidth():Number 
	{
		
		return _hitBounds.width;
	}
	
	/**
	 * returns the height of the entities hit box
	 */
	public function get hitHeight():Number 
	{
		return _hitBounds.height;
	}
	
	/**
	 * gets the correct rectange based of bounds of entity and pivot point
	 * @param	xOffset Virtual x position to place this Entity.
	 * @param	yOffset Virtual y position to place this Entity.
	 * @return
	 */
	public function getRect(xOffset:Number, yOffset:Number):Rectangle
	{
		if (_hitBounds.width == 0)
			_hitBounds.width = getBounds(this).width;
		if (_hitBounds.height == 0)
			_hitBounds.height = getBounds(this).height;
		
		_hitBounds.x = xOffset - pivotX - _originX;
		_hitBounds.y = yOffset - pivotY - _originY;
		
		return _hitBounds;
	}


    public  function advanceTime(time:Number):void{
        if (!isMove) {
            return;
        }

        var delay:int = (time*Constants.speed * 1000 + 0.5) >> 0;
        var disx:int = _target.x + _gapx - startX;
        var disy:int = _target.y + _gapy - startY;
        _vector2D.x = disx;
        _vector2D.y = disy;
        var dst:int = _vector2D.length;
        var moveDst:int = speed * delay;

        if (dst <= moveDst) {
            this.x = _target.x + _gapx;
            this.y = _target.y + _gapy;

//            this.x = _target.x ;
//            this.y = _target.y ;

            isMove = false;
            _target = null;

            var p:DisplayObjectContainer = this.parent;
            var len:int = p.numChildren;
            var arr:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            for(var i:int = 0;i<len;i++)
            {
                arr[i] = p.getChildAt(i);
            }

            ObjectUtil.sortBy(arr,"y");
            for(i = 0;i<len;i++)
            {
                var child:DisplayObject = arr[i];
                if(p.getChildIndex(child) != i)
                    p.setChildIndex(child,i);
            }

            moveComplete.dispatch(this);
        }
        else {
            _vector2D.length = moveDst;
            var dx:int = _vector2D.x + 0.5 >> 0;
            var dy:int = _vector2D.y + 0.5 >> 0;
            startX += dx;
            startY += dy;
            this.x = startX;
            this.y = startY;


            // 深度排序
            if (this.parent) {
                p = this.parent;
                var index:int = p.getChildIndex(this);
                len = p.numChildren;
                if (index == 0 || len == 0) {
                    return;
                }
                var a:DisplayObject = p.getChildAt(index - 1);
                if (a.y > this.y) {
                    if(p.getChildIndex(this) != index - 1)
                        p.setChildIndex(this,index - 1);
                }
                else if (index + 1 < len) {
                    var b:DisplayObject = p.getChildAt(index + 1);
                    if (b.y < this.y) {
                        if(p.getChildIndex(this) != index + 1)
                            p.setChildIndex(this,index + 1);
                    }
                }
            }
        }


    }

    protected function onAdd():void {
		Starling.juggler.add(this);
		var p:DisplayObjectContainer = this.parent;
		var len:int = p.numChildren;
		var arr:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		for(var i:int = 0;i<len;i++)
		{
			arr[i] = p.getChildAt(i);
		}
		
		ObjectUtil.sortBy(arr,"y");
		for(i = 0;i<len;i++)
		{
			var child:DisplayObject = arr[i];
			if(p.getChildIndex(child) != i)
				p.setChildIndex(child,i);
		}
      
    }

    override public function dispose():void {
		this.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
		Starling.juggler.remove(this);
        super.dispose();
    }

    /**
     *
     * @param target
     * @param gapx
     * @param gapy
     * @param parameter
     */
    public function moveto(target:DisplayObject, gapx:int, gapy:int):void {
        _gapx = gapx;
        _gapy = gapy;

        this.startX = this.x;
        this.startY = this.y;

        _target = target;
        isMove = true;
    }
}
}