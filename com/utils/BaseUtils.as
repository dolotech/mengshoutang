package com.utils
{
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.text.Font;
    import flash.text.TextField;
    import flash.text.TextFormat;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.RenderTexture;

    public class BaseUtils
    {

        public static const SECOND:int=1000;
        public static const MINUTE:int=60000;
        public static const HOUR:int=3600000;
        public static const DAY:int=86400000;

        public static var SECOND_STRING:String="";
        public static var MINUTE_STRING:String="";
        public static var HOUR_STRING:String="";
        public static var DAY_STRING:String="";

        public static function getDropShadowFilter(_arg1:uint):DropShadowFilter
        {
            var _local2:DropShadowFilter=new DropShadowFilter(1, 90, _arg1, 1, 5, 5, 10);
            return (_local2);
        }

        public static function getGlowFilter(_arg1:uint, _arg2:uint=5, _arg3:uint=5, _arg4:Number=20):GlowFilter
        {
            var _local5:GlowFilter=new GlowFilter(_arg1, 1, 5, 5, 20, 1, false, false);
            return (_local5);
        }

        public static function getNoColorFilter():ColorMatrixFilter
        {
            var _local1:ColorMatrixFilter=new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
            return (_local1);
        }

        /*  public static function getColorMatrixFilter(_arg1:Number):ColorMatrixFilter{
              var _local2:ColorMatrixFilter = ColorMatrixFilterProxy.createHueFilter(_arg1);
              return (_local2);
          }*/
        public static function getDateString(_arg1:Date):String
        {
            var _local2:int=_arg1.getFullYear();
            var _local3:int=(_arg1.getMonth() + 1);
            var _local4:int=_arg1.getDate();
            return (((((getNumberString(_local2) + "/") + getNumberString(_local3)) + "/") + getNumberString(_local4)));
        }

        private static function getNumberString(_arg1:int, _arg2:int=2):String
        {
            var _local3:int;
            if (_arg2 == 1)
            {
                return (("" + _arg1));
            }
            _local3=Math.pow(10, (_arg2 - 1));
            return ((("" + Math.floor((_arg1 / _local3))) + getNumberString((_arg1 % _local3), (_arg2 - 1))));
        }

        public static function getTimeString(_arg1:Number):String
        {
            if (_arg1 < 1000)
            {
                return ("00:00:00");
            }
            var _local2:String=String(Math.floor((_arg1 / DAY)));
            var _local3:String=String(Math.floor(((_arg1 % DAY) / HOUR)));
            var _local4:String=String(Math.floor(((_arg1 % HOUR) / MINUTE)));
            var _local5:String=String(Math.floor(((_arg1 % MINUTE) / SECOND)));
            if (_local3.length == 1)
            {
                _local3=("0" + _local3);
            }
            if (_local4.length == 1)
            {
                _local4=("0" + _local4);
            }
            if (_local5.length == 1)
            {
                _local5=("0" + _local5);
            }
            if (_local2 == "0")
            {
                return (((((_local3 + ":") + _local4) + ":") + _local5));
            }
            return (((((((_local2 + ":") + _local3) + ":") + _local4) + ":") + _local5));
        }

        public static function transformTimeString(_arg1:Number):String
        {
            if (_arg1 <= 1)
            {
                return ("");
            }
            var _local2:int=(_arg1 / DAY);
            var _local3:int=((_arg1 % DAY) / HOUR);
            var _local4:int=((_arg1 % HOUR) / MINUTE);
            var _local5:int=Math.floor(((_arg1 % MINUTE) / SECOND));
            if (_local2 == 0)
            {
                if (_local3 == 0)
                {
                    if (_local4 == 0)
                    {
                        return ((_local5 + SECOND_STRING));
                    }
                    return (((_local4 + MINUTE_STRING) + ((_local5 == 0)) ? "" : (_local5 + SECOND_STRING)));
                }
                return ((((_local3 + HOUR_STRING) + ((_local4 == 0)) ? "" : (_local4 + MINUTE_STRING)) + ((_local5 == 0)) ? "" : (_local5 + SECOND_STRING)));
            }
            return (((((_local2 + DAY_STRING) + ((_local3 == 0)) ? "" : (_local3 + HOUR_STRING)) + ((_local4 == 0)) ? "" : (_local4 + MINUTE_STRING)) + ((_local5 == 0)) ? "" : (_local5 + SECOND_STRING)));
        }

        public static function iTimeString(_arg1:Number):String
        {
            if (_arg1 <= 1)
            {
                return ("");
            }
            var _local2:int=(_arg1 / DAY);
            var _local3:int=((_arg1 % DAY) / HOUR);
            var _local4:int=((_arg1 % HOUR) / MINUTE);
            var _local5:int=Math.floor(((_arg1 % MINUTE) / SECOND));
            if (_local2 != 0)
            {
                if (_local3 == 0)
                {
                    return ((((_local2 / 1) * 24) + HOUR_STRING));
                }
                return ((_local2 + DAY_STRING));
            }
            if (_local3 != 0)
            {
                return ((_local3 + HOUR_STRING));
            }
            if (_local4 != 0)
            {
                return ((_local4 + MINUTE_STRING));
            }
            return ((_local5 + SECOND_STRING));
        }

        public static function timeStrToDate(_arg1:String, _arg2:int):Date
        {
            var _local7:int;
            var _local3:Array=_arg1.split(" ", 2);
            var _local4:Array=_local3[0].split("-", 3);
            var _local5:Array=_local3[1].split(":", 3);
            var _local6:int=((new Date().getTimezoneOffset() / 60) * -1);
            _local7=(_local6 - _arg2);
            return (new Date(Number(_local4[0]), (Number(_local4[1]) - 1), Number(_local4[2]), (Number(_local5[0]) + _local7), Number(_local5[1]), Number(_local5[2])));
        }

        public static function transDate(_arg1:Number):String
        {
            var _local2:Date=new Date(_arg1);
            return (((((_local2.fullYear + "-") + (_local2.month + 1)) + "-") + _local2.date));
        }

        public static function transDateInfo(_arg1:Number):String
        {
            var _local2:Date=new Date(_arg1);
            return ((((((((_local2.month + 1) + "-") + _local2.date) + "  ") + _local2.hours) + ":") + _local2.minutes));
        }

        public static function getPercentage(_arg1:Number):String
        {
            var _local2:String=((Math.round(((Number(_arg1) * 100) * 10000)) / 10000) + "%");
            return (_local2);
        }

        public static function getTextField(_arg1:String="left", _arg2:uint=12, _arg3:uint=0xFFFFFF, _arg4:Boolean=false, _arg5:Boolean=false, _arg6:Font=null, _arg7:String=" ", _arg8:Boolean=false):TextField
        {
            var _local9:TextField=new TextField();
            _local9.selectable=_arg4;
            _local9.textColor=_arg3;
            _local9.autoSize=_arg1;
            _local9.text=_arg7;
            var _local10:TextFormat=new TextFormat();
            _local10.size=_arg2;
            _local10.bold=_arg5;
            _local10.underline=_arg8;
            var _local11:Font=_arg6;
            if (_local11 != null)
            {
                _local9.embedFonts=true;
                _local10.font=_local11.fontName;
            }
            _local9.defaultTextFormat=_local10;
            return (_local9);
        }

        public static function getNpcDialogTextField(_arg1:Font=null):TextField
        {
            var _local2:TextField=new TextField();
            _local2.textColor=0xFFFFFF;
            _local2.selectable=false;
            _local2.width=290;
            _local2.wordWrap=true;
            _local2.multiline=true;
            var _local3:TextFormat=new TextFormat();
            _local3.size=16;
            var _local4:Font=_arg1;
            if (_local4 != null)
            {
                _local2.embedFonts=true;
                _local3.font=_local4.fontName;
            }
            _local2.defaultTextFormat=_local3;
            return (_local2);
        }

        public static function getNpcCheckTextField(_arg1:Font=null):TextField
        {
            var _local2:TextField=new TextField();
            _local2.textColor=0xFFFF00;
            _local2.selectable=false;
            _local2.height=25;
            var _local3:TextFormat=new TextFormat();
            _local3.size=14;
            var _local4:Font=_arg1;
            if (_local4 != null)
            {
                _local2.embedFonts=true;
                _local3.font=_local4.fontName;
            }
            _local2.defaultTextFormat=_local3;
            return (_local2);
        }

        public static function ScaleImg(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            var _local5:Number=(_arg1 / _arg3);
            var _local6:Number=(_arg2 / _arg4);
            var _local7:Number=Math.min(_local5, _local6);
            if (_local7 < 1)
            {
                return (_local7);
            }
            return (1);
        }

        public static function randRange(_arg1:Number, _arg2:Number):Number
        {
            var _local3:Number=(Math.floor((Math.random() * ((_arg2 - _arg1) + 1))) + _arg1);
            return (_local3);
        }

        public static function getDistance(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            var _local7:Number;
            var _local8:Number;
            var _local5:Number=(_arg1 - _arg3);
            var _local6:Number=(_arg2 - _arg4);
            if (_local5 < 0)
            {
                _local5=-(_local5);
            }
            if (_local6 < 0)
            {
                _local6=-(_local6);
            }
            if (_local5 < _local6)
            {
                _local7=_local5;
                _local8=_local6;
            }
            else
            {
                _local7=_local6;
                _local8=_local5;
            }
            return ((((((((((_local8 << 8) + (_local8 << 3)) - (_local8 << 4)) - (_local8 << 1)) + (_local7 << 7)) - (_local7 << 5)) + (_local7 << 3)) - (_local7 << 1)) >> 8));
        }

        public static function getNumberList(_arg1:Number, _arg2:int):Array
        {
            var _local7:int;
            var _local3:Array=new Array(_arg2);
            var _local4:int=1;
            var _local5:int=Math.ceil((_arg1 / _arg2));
            var _local6:int;
            while (_local6 < _local5)
            {
                _local7=0;
                while (_local7 < _local3.length)
                {
                    if (_local3[_local7] == null)
                    {
                        _local3[_local7]=0;
                    }
                    if (_arg1 < _local4)
                    {
                        _local3[_local7]=(_local3[_local7] + _arg1);
                        break;
                    }
                    _local3[_local7]=(_local3[_local7] + _local4);
                    _arg1=(_arg1 - _local4);
                    _local7++;
                }
                _local6++;
            }
            return (_local3);
        }

        public static function getCurrentFrames(_arg1:MovieClip, _arg2:Number, _arg3:Number):int
        {
            var _local4:int=_arg1.totalFrames;
            return (Math.floor(((_arg2 / _arg3) * _local4)));
        }

        public static function getNumberMCList(_arg1:int, _arg2:MovieClip):Array
        {
            var _local6:MovieClip;
            var _local3:Array=new Array();
            var _local4:String=_arg1.toString();
            var _local5:int;
            while (_local5 < _local4.length)
            {
                _local6=_arg2;
                _local6.gotoAndStop((int(_local4.slice(_local5, (_local5 + 1))) + 1));
                _local3.push(_local6);
                _local5++;
            }
            return (_local3);
        }

        public static function copyImagExtendTransparent(_arg1:BitmapData):Sprite
        {
            var _local6:uint;
            var _local7:uint;
            var _local2:uint=_arg1.width;
            var _local3:uint=_arg1.height;
            var _local4:Sprite=new Sprite();
            var _local5:uint;
            while (_local5 < _local2)
            {
                _local6=0;
                while (_local6 < _local3)
                {
                    if (_arg1.getPixel32(_local5, _local6))
                    {
                        _local7=((_arg1.getPixel32(_local5, _local6) >> 24) & 0xFF);
                        _local4.graphics.beginFill(_arg1.getPixel(_local5, _local6), (_local7 / 0xFF));
                        _local4.graphics.drawRect(_local5, _local6, 1, 1);
                        _local4.graphics.endFill();
                    }
                    _local6++;
                }
                _local5++;
            }
            return (_local4);
        }

        /**
         * 整型按位与运算(int 32位)
         * @param  int    需要按位与的总位数
         * @return Vector.<int>  按位与结果数组 (由低位到高位)
         */
        public static function IntegerBitwiseAnd(record:uint, bitAmount:int=0):Vector.<int>
        {
            if (bitAmount == 0)
            {
                bitAmount=32;
            }
            var res:Vector.<int>=new Vector.<int>;
            var tmp:int=0;
            for (var i:int=0; i < bitAmount; i++)
            {
                tmp=((record & Math.pow(2, i)) > 0) ? 1 : 0;
                res.push(tmp);
            }
            return res;
        }

        /**
         * 克隆可视对象到一个图片
         * @param target    可视目标对象
         * @param persistent    指明纹理在经过多次绘制之后是否是持久的
         * @return
         */
        public static function clone(target:DisplayObject, persistent:Boolean=false):Image
        {
            if (!target)
            {
                return null;
            }
            var texture:RenderTexture=new RenderTexture(target.width, target.height, persistent);
            if (target is DisplayObjectContainer)
            {
                texture.drawBundled(function():void
                {
                    var num:int=DisplayObjectContainer(target).numChildren;
                    for (var i:int=0; i < num; i++)
                    {
                        texture.draw(DisplayObjectContainer(target).getChildAt(i));
                    }
                });
            }
            else
            {
                texture.draw(target);
            }
            return new Image(texture);
        }


    }
}
