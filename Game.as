package
{
    import com.dialog.DialogMgr;
    import com.langue.PlayerName;
    import com.langue.WordFilter;
    import com.mvc.interfaces.INotification;
    import com.scene.SceneMgr;
    import com.utils.Assets;
    import com.view.View;

    import flash.system.Capabilities;
    import flash.system.System;
    import flash.utils.ByteArray;

    import feathers.core.PopUpManager;

    import game.common.JTGlobalDef;
    import game.common.JTSession;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.WidgetData;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.managers.JTFunctionManager;
    import game.managers.JTSingleManager;
    import game.net.GlobalMessage;
    import game.net.data.AddCmd;
    import game.net.data.IData;
    import game.net.data.s.SAllgoods;
    import game.net.data.s.SDelGoods;
    import game.net.data.s.SDeletehero;
    import game.net.data.s.SGet_game_coin;
    import game.net.data.s.SGet_game_diamond;
    import game.net.data.s.SGet_game_honor;
    import game.net.data.s.SGet_game_luck;
    import game.net.data.s.SMsgCode;
    import game.net.data.s.SNewhero;
    import game.net.data.vo.DelGoodsVO;
    import game.net.data.vo.GoodsVO;
    import game.scene.LoginLoadingScene;
    import game.view.gameover.WinView;
    import game.view.msg.MsgTips;

    import starling.core.Starling;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    /**
     * This class is the primary Starling Sprite based class
     * that triggers the different screens.
     *
     * @author Michael
     *
     */
    public class Game extends View
    {
        public function Game()
        {
            super();
        }

        override protected function init():void
        {
        }

        override public function listNotificationName():Vector.<String>
        {
            var vector:Vector.<String>=new Vector.<String>();
            vector.push(SNewhero.CMD);
            vector.push(SGet_game_diamond.CMD);
            vector.push(SGet_game_coin.CMD);
            vector.push(SDelGoods.CMD);
            vector.push(SDeletehero.CMD);
            vector.push(SAllgoods.CMD);
            vector.push(SGet_game_honor.CMD);
            vector.push(SMsgCode.CMD);
            vector.push(SGet_game_luck.CMD);
            return vector;
        }

        override public function handleNotification(arg1:INotification):void
        {
            switch (arg1.getName())
            {
                //  更新物品堆叠数,pile=0时删除该物品，检索背包当id不存在时则添加
                case SAllgoods.CMD + "":
                    var data:SAllgoods=arg1 as SAllgoods;
                    if (data.type == 3)
                    {
                        var props:Vector.<IData>=data.props;
                        var len:int=props.length;
                        for (var i:int=0; i < len; i++)
                        {
                            var vo:GoodsVO=props[i] as GoodsVO;
                            if (vo.pile == 0)
                            {
                                WidgetData.hash.remove(vo.id);
                            }
                            else
                            {
                                var widgetData:WidgetData=WidgetData.hash.getValue(vo.id);
                                if (widgetData)
                                {
                                    widgetData.pile=vo.pile;
                                }
                                else
                                {
                                    var g:Goods=Goods.goods.getValue(vo.type);
                                    widgetData=new WidgetData(g);
                                    widgetData.id=vo.id;
                                    widgetData.type=vo.type;
                                    widgetData.pile=vo.pile;
                                    widgetData.level=vo.level;
                                    widgetData.exp=vo.exp;
                                    WidgetData.hash.put(widgetData.id, widgetData);
                                }
                            }
                        }
                        var equip:Vector.<IData>=data.equip;
                        WidgetData.createEquip(equip);
                    }
                    break;
                // 增加英雄
                case SNewhero.CMD + "":
                    var newhero:SNewhero=arg1 as SNewhero;
                    HeroDataMgr.instance.create(newhero);
                    //				trace(this,"updateHero");
                    break;
                // 删除英雄
                case SDeletehero.CMD + "":
                    var deleteC:SDeletehero=arg1 as SDeletehero;
                    var heros:Vector.<int>=deleteC.heroes;

                    var le:int=heros.length;
                    for (i=0; i < le; i++)
                    {
                        var id:int=heros[i];
                        HeroDataMgr.instance.hash.remove(id);
                    }
                    break;
                // 更新游戏钻石
                case SGet_game_diamond.CMD + "":
                    GameMgr.instance.diamond=(arg1 as SGet_game_diamond).diamond;
                    GameMgr.instance.updateMoney();
                    break;
                // 更新游戏金币
                case SGet_game_coin.CMD + "":
                    GameMgr.instance.coin=(arg1 as SGet_game_coin).coin;
                    GameMgr.instance.updateMoney();
                    break;
                //更新荣誉值
                case SGet_game_honor.CMD + "":
                    GameMgr.instance.honor=(arg1 as SGet_game_honor).honor;
                    GameMgr.instance.updateMoney();
                    JTFunctionManager.executeFunction(JTGlobalDef.PVP_REFRHES_HONOR, GameMgr.instance.honor);
                    break;
                case SGet_game_luck.CMD + "":
                    GameMgr.instance.star=(arg1 as SGet_game_luck).luck;
                    GameMgr.instance.updateMoney();
                    break;
                case SMsgCode.CMD + "":
                    var info:SMsgCode=arg1 as SMsgCode;
                    if (info.type == 1)
                    {
                        MsgTips.instance.tips(info.code);
                    }
                    else if (info.type == 2)
                    {
                        WinView.code=info.code;
                            //MsgTipsDlg.instance.tips(info.code);
                    }
                    break;
                // 删除玩家物品
                case SDelGoods.CMD + "":
                    var delGoods:SDelGoods=arg1 as SDelGoods;
                    props=delGoods.props;
                    len=props.length;
                    var values:Vector.<*>=HeroDataMgr.instance.hash.values();
                    for (i=0; i < len; i++)
                    {
                        var delGoodsVo:DelGoodsVO=props[i] as DelGoodsVO;
                        if (delGoodsVo.pile == 0)
                        {
                            for each (var heroData:HeroData in values)
                            {
                                if (delGoodsVo.id > 100000)
                                {
                                    heroData.seat1 == delGoodsVo.id ? heroData.seat1=0 : null;
                                    heroData.seat2 == delGoodsVo.id ? heroData.seat2=0 : null;
                                    heroData.seat3 == delGoodsVo.id ? heroData.seat3=0 : null;
                                    heroData.seat4 == delGoodsVo.id ? heroData.seat4=0 : null;
                                }
                            }
                            WidgetData.hash.remove(delGoodsVo.id);
                        }
                        else
                        {
                            widgetData=WidgetData.hash.getValue(delGoodsVo.id);
                            if (widgetData)
                                widgetData.pile=delGoodsVo.pile;
                        }
                    }
                    break;
                default:
                    break;
            }
        }

        public function start():void
        {
            //进度条解析
            PopUpManager.forStarling(Starling.current);
            JTSingleManager.initialize();
            var progressBar:ByteArray=new Assets.progressbar_data();
            decompress(progressBar);

            SceneMgr.instance.init(JTSession.layerSence);
            DialogMgr.instance.init(JTSession.layerPanel);
            PopUpManager.root=JTSession.layerPanel;
            GlobalMessage.getInstance();
            AddCmd.init();

            stage.alpha=0.999; // 优化
            stage.color=0x000002;

            var str:String=new String(new Assets.Dirtyword());
            WordFilter.instance.init(str);
            PlayerName.XML_CLASS=Assets.Username;
            stage.addChild(JTSession.layerSence);
            stage.addChild(JTSession.layerPanel);
            stage.addChild(JTSession.layerChat);
            stage.addChild(JTSession.layerGlobal);
            stage.addChild(JTSession.layerGuideGlobal);

            SceneMgr.instance.changeScene(LoginLoadingScene);
            //fps
            if (Capabilities.isDebugger)
            {
                Starling.current.showStatsAt("right", "top", 2);
            }
        }


        /**
         * 解析总配置文件
         * @param byteArray
         *
         */
        public function decompress(byteArray:ByteArray):void
        {
            byteArray.position=0;
            byteArray.uncompress();
            byteArray.position=0;
            var assetMgr:AssetMgr=AssetMgr.instance;
            while (byteArray.bytesAvailable)
            {
                var fullFileName:String=byteArray.readUTF();
                var len:int=byteArray.readUnsignedInt();
                var fileBytes:ByteArray=new ByteArray();
                byteArray.readBytes(fileBytes, 0, len);
                var fileNameList:Array=fullFileName.split(".");
                var name:String=fileNameList[0];
                switch (fileNameList[1])
                {
                    case "xml":
                        var texture:Texture;
                        var xml:XML=new XML(fileBytes);
                        var rootNode:String=xml.localName();
                        if (rootNode == "TextureAtlas")
                        {

                            texture=assetMgr.getTexture(name);

                            if (texture)
                            {
                                assetMgr.addTextureAtlas(name, new TextureAtlas(texture, xml));
                                assetMgr.removeTexture(name, false);
                            }
                            else
                                debug("Cannot create atlas: texture '" + name + "' is missing.");
                        }
                        System.disposeXML(xml);
                        break;
                    case "atf":
                        assetMgr.addAtfTexture(name, fileBytes);
                        break;
                    default:
                        assetMgr.addXml(name, new XML(fileBytes));
                        break;
                }
            }
            byteArray.clear();
        }
    }
}
