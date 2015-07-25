package com.mobileLib.io.file {
    import flash.utils.*;
    import flash.filesystem.*;

    public class SimpleFile {

        public static function writeStringToFile(_arg1:String, _arg2:String):Boolean{
            var path:* = _arg1;
            var str:* = _arg2;
            var myFile:* = File.applicationStorageDirectory.resolvePath(path);
            var myFileStream:* = new FileStream();
            try {
                myFileStream.open(myFile, FileMode.WRITE);
                myFileStream.writeUTFBytes(str);
                myFileStream.close();
            } catch(e) {
                return (false);
            }
            return (true);
        }
        public static function readStringFromFile(_arg1:String):String{
            var path:* = _arg1;
            var myFile:* = File.applicationStorageDirectory.resolvePath(path);
            var myFileStream:* = new FileStream();
            var str:* = "";
            try {
                myFileStream.open(myFile, FileMode.READ);
                str = myFileStream.readUTFBytes(myFileStream.bytesAvailable);
                myFileStream.close();
            } catch(e) {
                return ("");
            }
            return (str);
        }
        public static function saveBytesToFile(_arg1:String, _arg2:ByteArray):Boolean{
            var _local3:File = File.desktopDirectory.resolvePath(_arg1);
            var _local4:FileStream = new FileStream();
            _local4.open(_local3, FileMode.WRITE);
            _local4.writeBytes(_arg2);
            _local4.close();
            return (true);
        }
        public static function writeObjectToFile(_arg1:String, _arg2:Object):Boolean{
            var ba:* = null;
            var path:* = _arg1;
            var obj:* = _arg2;
            var myFile:* = File.applicationStorageDirectory.resolvePath(path);
            var myFileStream:* = new FileStream();
            try {
                myFileStream.open(myFile, FileMode.WRITE);
                ba = new ByteArray();
                ba.writeObject(obj);
                myFileStream.writeBytes(ba);
                myFileStream.close();
            } catch(e) {
                return (false);
            }
            return (true);
        }
        public static function readObjectFromFile(_arg1:String):Object{
            var obj:* = null;
            var ba:* = null;
            var path:* = _arg1;
            var myFile:* = File.applicationStorageDirectory.resolvePath(path);
            var myFileStream:* = new FileStream();
            try {
                myFileStream.open(myFile, FileMode.READ);
                ba = new ByteArray();
                myFileStream.readBytes(ba, 0, myFileStream.bytesAvailable);
                myFileStream.close();
                ba.position = 0;
                obj = ba.readObject();
            } catch(e) {
                return (null);
            }
            return (obj);
        }

    }
} 
