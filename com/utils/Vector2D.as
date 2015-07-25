package com.utils
{
	import flash.display.*;
	
	public class Vector2D
	{
		
		private var _x:Number;
		private var _y:Number;
		
		public function Vector2D(x:Number = 0, y:Number = 0)
		{
			super();
			this._x = x;
			this._y = y;
		}
		
		public static function angleBetween(v1:Vector2D, v2:Vector2D):Number
		{
			if (!(v1.isNormalized()))
			{
				v1 = v1.clone().normalize();
			}
			if (!(v2.isNormalized()))
			{
				v2 = v2.clone().normalize();
			}
			return (Math.acos(v1.dotProd(v2)));
		}
		
		public function draw(graphics:Graphics, color:uint = 0):void
		{
			graphics.lineStyle(0, color);
			graphics.moveTo(0, 0);
			graphics.lineTo(this._x, this._y);
		}
		
		public function clone():Vector2D
		{
			return (new Vector2D(this.x, this.y));
		}
		
		public function zero():Vector2D
		{
			this._x = 0;
			this._y = 0;
			return (this);
		}
		
		public function isZero():Boolean
		{
			return ((((this._x == 0)) && ((this._y == 0))));
		}
		
		public function set length(value:Number):void
		{
			var a:Number = this.angle;
			this._x = (Math.cos(a) * value);
			this._y = (Math.sin(a) * value);
		}
		
		public function get length():Number
		{
			return (Math.sqrt(this.lengthSQ));
		}
		
		public function get lengthSQ():Number
		{
			return (((this._x * this._x) + (this._y * this._y)));
		}
		
		public function set angle(value:Number):void
		{
			var len:Number = this.length;
			this._x = (Math.cos(value) * len);
			this._y = (Math.sin(value) * len);
		}
		
		public function get angle():Number
		{
			return (Math.atan2(this._y, this._x));
		}
		
		public function normalize():Vector2D
		{
			if (this.length == 0)
			{
				this._x = 1;
				return (this);
			}
			var len:Number = this.length;
			this._x = (this._x / len);
			this._y = (this._y / len);
			return (this);
		}
		
		public function truncate(max:Number):Vector2D
		{
			this.length = Math.min(max, this.length);
			return (this);
		}
		
		public function reverse():Vector2D
		{
			this._x = -(this._x);
			this._y = -(this._y);
			return (this);
		}
		
		public function isNormalized():Boolean
		{
			return ((this.length == 1));
		}
		
		public function dotProd(v2:Vector2D):Number
		{
			return (((this._x * v2.x) + (this._y * v2.y)));
		}
		
		public function crossProd(v2:Vector2D):Number
		{
			return (((this._x * v2.y) - (this._y * v2.x)));
		}
		
		public function sign(v2:Vector2D):int
		{
			return (((this.perp.dotProd(v2) < 0)) ? -1 : 1);
		}
		
		public function get perp():Vector2D
		{
			return (new Vector2D(-(this.y), this.x));
		}
		
		public function dist(v2:Vector2D):Number
		{
			return (Math.sqrt(this.distSQ(v2)));
		}
		
		public function distSQ(v2:Vector2D):Number
		{
			var dx:Number = (v2.x - this.x);
			var dy:Number = (v2.y - this.y);
			return (((dx * dx) + (dy * dy)));
		}
		
		public function add(v2:Vector2D):Vector2D
		{
			return (new Vector2D((this._x + v2.x), (this._y + v2.y)));
		}
		
		public function subtract(v2:Vector2D):Vector2D
		{
			return (new Vector2D((this._x - v2.x), (this._y - v2.y)));
		}
		
		public function multiply(value:Number):Vector2D
		{
			return (new Vector2D((this._x * value), (this._y * value)));
		}
		
		public function divide(value:Number):Vector2D
		{
			return (new Vector2D((this._x / value), (this._y / value)));
		}
		
		public function equals(v2:Vector2D):Boolean
		{
			return ((((this._x == v2.x)) && ((this._y == v2.y))));
		}
		
		public function set x(value:Number):void
		{
			this._x = value;
		}
		
		public function get x():Number
		{
			return (this._x);
		}
		
		public function set y(value:Number):void
		{
			this._y = value;
		}
		
		public function get y():Number
		{
			return (this._y);
		}
		
		public function toString():String
		{
			return ((((("[Vector2D (x:" + this._x) + ", y:") + this._y) + ")]"));
		}
	
	}
} //package com.utils 
