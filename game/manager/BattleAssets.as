/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-11-21
 * Time: 下午3:40
 * To change this template use File | Settings | File Templates.
 */
package game.manager
{
    import com.dialog.DialogMgr;
    import com.mobileLib.utils.ConverURL;
    import com.scene.IScene;
    import com.scene.SceneMgr;
    import com.singleton.Singleton;
    import com.sound.SoundManager;

    import flash.events.TimerEvent;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    import avmplus.getQualifiedClassName;

    import game.scene.BattleScene;
    import game.view.heroHall.HeroDialog;
    import game.view.tavern.TavernDialog;

    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.utils.AssetManager;

    public class BattleAssets extends AssetManager
    {
        /**
         * 3分钟销毁资源
         */

        public static function get instance():BattleAssets
        {
            return Singleton.getInstance(BattleAssets) as BattleAssets;
        }

        public function BattleAssets():void
        {
            _textureAtlasDic=new Dictionary();
            _texturesDic=new Dictionary();
            _soundDic=new Dictionary();
            _ByteArrDic=new Dictionary();

            _nameDic=new Dictionary();
            _timer=new Timer(1000);
            _timer.addEventListener(TimerEvent.TIMER, onTimer);
            super();
        }

        private function onTimer(e:TimerEvent):void
        {
            if (_timer.currentCount % 20 == 0)
            {
                var scene:IScene=SceneMgr.instance.getCurScene();
                var dialogMgr:DialogMgr=DialogMgr.instance;

                if (!(scene is BattleScene) && !dialogMgr.isShow(HeroDialog) && !dialogMgr.isShow(TavernDialog))
                {
                    checkDispose();
                }
            }
        }
        private var _timer:Timer;
        private var _textureAtlasDic:Dictionary;
        private var _texturesDic:Dictionary;
        private var _soundDic:Dictionary;
        private var _ByteArrDic:Dictionary;
        private var _nameDic:Dictionary;

        private static const DELAY_TIME:int=1000 * 60 * 3;

        override public function enqueueWithName(asset:Object, name:String=null):String
        {
            if (ConverURL.update_dic[asset.name] != null)
            {
                asset=ConverURL.update_dic[asset.name];
            }

            if (name == null)
                name=getName(asset);

            if (getQualifiedClassName(asset) == "flash.filesystem::File")
                asset=asset["url"];
            var extension:String=asset.split("?")[0].split(".").pop().toLowerCase();
            var allName:String=name + "." + extension;


            if (_nameDic[allName])
            {
                return name;
            }
            _nameDic[allName]=true;



            return super.enqueueWithName(asset, name);
        }

        override public function addSound(name:String, sound:Sound):void
        {
            SoundManager.instance.addSound(name, sound);
            mSounds[name]=sound;
            _soundDic[name]=getTimer();
        }

        override public function getSound(name:String):Sound
        {
            _soundDic[name]=getTimer();
            return mSounds[name];
        }

        override public function addTextureAtlas(name:String, atlas:TextureAtlas):void
        {
            mAtlases[name]=atlas;
            _textureAtlasDic[name]=getTimer();
        }

        override public function getTextureAtlas(name:String):TextureAtlas
        {
            _textureAtlasDic[name]=getTimer();
            return mAtlases[name] as TextureAtlas;
        }

        override public function addTexture(name:String, texture:Texture):void
        {
            _texturesDic[name]=getTimer();
            mTextures[name]=texture;
        }

        override public function getTexture(name:String):Texture
        {
            if (name in mTextures)
            {
                _texturesDic[name]=getTimer();
                return mTextures[name];
            }
            else
            {

                for (var n:String in mAtlases)
                {
                    var atlas:TextureAtlas=mAtlases[n];
                    var texture:Texture=atlas.getTexture(name);

                    if (texture)
                    {
                        _texturesDic[name]=getTimer();
                        _textureAtlasDic[n]=getTimer();
                        return texture;
                    }
                }
                return null;
            }
        }

        override public function addByteArray(name:String, byteArray:ByteArray):void
        {
            _ByteArrDic[name]=getTimer();
            mByteArrays[name]=byteArray;
        }

        override public function getByteArray(name:String):ByteArray
        {
            _ByteArrDic[name]=getTimer();
            return mByteArrays[name];
        }

        public function checkDispose():void
        {
            _timer.reset();
            _timer.start();
            var curr_time:int=getTimer();

            for (var n:String in _texturesDic)
            {
                var time:int=_texturesDic[n];

                if (curr_time - time > DELAY_TIME)
                {
                    removeTexture(n);
                    delete _nameDic[n + ".png"];
                    delete _nameDic[n + ".atf"];
                    delete _nameDic[n + ".axs"];
                    delete _texturesDic[n];
                }
            }

            for (n in _textureAtlasDic)
            {
                time=_textureAtlasDic[n];

                if (curr_time - time > DELAY_TIME)
                {
                    removeTextureAtlas(n);
                    removeXml(n);
                    removeByteArray(n);
                    delete _nameDic[n + ".png"];
                    delete _nameDic[n + ".atf"];
                    delete _nameDic[n + ".xml"];
                    delete _nameDic[n + ".scml"];
                    delete _nameDic[n + ".axs"];
                    delete _textureAtlasDic[n];
                }
            }

            for (n in _soundDic)
            {
                time=_soundDic[n];

                if (getTimer() - time > DELAY_TIME)
                {
                    removeSound(n);
                    delete _nameDic[n + ".mp3"];
                }
            }
        }
    }

}
