package com.utils {

    public class Constants {

        // We chose this stage size because it is used by many mobile devices; 
        // it's e.g. the resolution of the iPhone (non-retina), which means that your game
        // will be displayed without any black bars on all iPhone models up to 4S.
        // 
        // To use landscape mode, exchange the values of width and height, and 
        // set the "aspectRatio" element in the config XML to "landscape". (You'll also have to
        // update the background, startup- and "Default" graphics accordingly.)

        public static var frameRate:int = 30;

        public static const standardWidth:int = 960;
        public static const standardHeight:int = 640;
        public static const virtualEmbattleWidth:int = 419;
        public static const virtualEmbattleHeight:int = 238;


        public static var FullScreenWidth:int = 0;
        public static var FullScreenHeight:int = 0;


        public static var virtualHeight:int = 0;
        public static var virtualWidth:int = 0;

        public static var isScaleWidth:Boolean;

        public static var scale:Number = 1.0;
        public static var scale_x:Number = 1.0;

        public static var iOS:Boolean;
        public static var WINDOWS:Boolean;
        public static var ANDROID:Boolean;

        /**
         * 用户名+密码MD5加密
         */
        public static var userPwdMd5:String;
        /**
         * 用户名账号密码
         */
        public static var username:String;
        public static var password:String;

        public static const smoothing:String = "bilinear";
        public static const NONE:String = "none";
        /**
         * 加速度
         */
        public static var speed:Number = 1;

        /**
         * 服务器IP和端口
         */
        public static var IP:String = "42.121.111.191";
        /**
         *
         * @default
         */
        public static var PORT:int = 8100;
        public static var SERVER_NAME:String = "";
        public static var SID:int;
        public static var UID:int;

        public static function setToStageCenter(target:*, gapX:int = 0, gapY:int = 0, bool:Boolean = true):void {
            target.x = (virtualWidth - (bool ? target.width : 0)) * .5 + gapX / scale;
            target.y = (virtualHeight - (bool ? target.height : 0)) * .5 + gapY / scale;
        }


        public static function setXToStageCenter(target:*, gapX:int = 0, bool:Boolean = true):void {
            target.x = (virtualWidth - (bool ? target.width : 0)) * .5 + gapX / scale;
        }
    }
}
