package game.view.dispark
{
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.singleton.Singleton;

    import flash.utils.Dictionary;

    import game.data.DisparkData;
    import game.dialog.ShowLoader;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.data.IData;
    import game.net.data.c.CSetfunData;
    import game.net.data.vo.funData;
    import game.net.message.base.Message;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.dispark.render.DisparkRender;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;

    /**
     * 功能开放引导
     * @author Samuel
     *
     */
    public class DisparkControl
    {
        /**显示对象存储*/
        public static const dicDisplay:Dictionary=new Dictionary();
        /**提示渲染列表*/
        private static var _disparkList:Vector.<DisparkRender>=new Vector.<DisparkRender>;


        /**功能提示单例接口*/
        public static function get instance():DisparkControl
        {
            return Singleton.getInstance(DisparkControl) as DisparkControl;
        }

        /**改变状态列表*/
        public function changeStatues(statues:Vector.<IData>):void
        {
            var disparkData:DisparkData=null;
            if (statues != null && statues.length > 0)
            {
                var arr:Vector.<*>=DisparkData.hash.values();
                var fundata:funData=null;
                var len:int=statues.length;
                for (var i:int=0; i < len; i++)
                {
                    fundata=statues[i] as funData;
                    for each (disparkData in arr)
                    {
                        if (fundata.id == disparkData.id)
                        {
                            disparkData.statue=fundata.value;
                        }
                    }
                }
            }
            else
            { //防止注销情况
                _disparkList=new Vector.<DisparkRender>;
                for each (disparkData in DisparkData.hash.values())
                {
                    disparkData.statue=0;
                }
            }

        }

        /**获取开放功能列表id*/
        private function getOpenListId(type:uint):Vector.<int>
        {
            var vector:Vector.<int>=new Vector.<int>;
            var disparkData:DisparkData=null;
            var point:int=GameMgr.instance.tollgateID - 1;
            var maxlv:int=HeroDataMgr.instance.getHerosMaxLv();
            for each (disparkData in DisparkData.hash.values())
            {
                if (disparkData.statue == 0 && disparkData.type == type)
                {
                    if (disparkData.point != 0 && disparkData.level == 0) //只判断关卡
                    {
                        if (disparkData.point <= point)
                            vector.push(disparkData.id);
                    }
                    else if (disparkData.point == 0 && disparkData.level != 0) //只判断等级
                    {
                        if (disparkData.level <= maxlv)
                            vector.push(disparkData.id);
                    }
                    else if (disparkData.point != 0 && disparkData.level != 0) //判断关卡和等级
                    {
                        if (disparkData.point <= point && disparkData.level <= maxlv)
                            vector.push(disparkData.id);
                    }
                }
            }
            return vector;
        }


        /**通过id生成开放功能提示*/
        protected function getDisparkVector(obj:Object):Vector.<DisparkRender>
        {
            var vet:Vector.<DisparkRender>=new Vector.<DisparkRender>;
            var disparkData:DisparkData=null;
            var disparkRender:DisparkRender=null;
            var id:int=0;
            if (obj is int)
            {
                id=int(obj);
                disparkData=DisparkData.hash.getValue(obj);
                disparkData.callBack=callBackHandler
                disparkRender=new DisparkRender(disparkData);
                vet.push(disparkRender);
            }
            else if (obj is Vector.<int>)
            {
                for each (id in obj)
                {
                    disparkData=DisparkData.hash.getValue(id);
                    disparkRender=new DisparkRender(disparkData);
                    disparkData.callBack=callBackHandler;
                    vet.push(disparkRender);
                }

            }
            else if (obj is Array)
            {
                for each (id in obj)
                {
                    disparkData=DisparkData.hash.getValue(id);
                    disparkRender=new DisparkRender(disparkData);
                    disparkData.callBack=callBackHandler;
                    vet.push(disparkRender);
                }

            }
            return vet;
        }

        /**引导打开战斗结束可能是开放功能*/
        public function checkBattleOpen():void
        {
            var disparkData:DisparkData=null;
            for each (disparkData in DisparkData.hash.values())
            {
                if (disparkData.statue != 2 && disparkData.type == 1)
                {
                    addDisparkHandler(disparkData.id);
                }
            }
            var disparks:Vector.<int>=getOpenListId(1);
            if (disparks.length <= 0)
                return;
            DisparkControl.instance.disparkList=getDisparkVector(disparks);
            DialogMgr.instance.open(DisparkDialog, null, null, null, "translucence", 0x000000, 0.5);
        }



        /**引导打开主城可能是开放功能*/
        public function checkMajorOpen():void
        {
            var disparkData:DisparkData=null;
            for each (disparkData in DisparkData.hash.values())
            {
                if (disparkData.statue != 2 && disparkData.type == 0)
                {
                    addDisparkHandler(disparkData.id);
                }
            }
            var disparks:Vector.<int>=getOpenListId(0);
            if (disparks.length <= 0)
                return;
            DisparkControl.instance.disparkList=getDisparkVector(disparks);
            DialogMgr.instance.open(DisparkDialog, null, null, null, "translucence", 0x000000, 0.5);
        }


        /**判断是否开启*/
        public function isOpenHandler(id:uint):Boolean
        {
            var dispark:DisparkData=DisparkData.hash.getValue(id);
            if (dispark.statue == 1 || dispark.statue == 2)
                return true;
            var point:int=GameMgr.instance.tollgateID - 1;
            var maxlv:int=HeroDataMgr.instance.getHerosMaxLv();
            var msg:String="";
            var langs:Array=Langue.getLans("Open_Dispark_Tips");
            if (dispark.point != 0 && dispark.level == 0) //只判断关卡
            {
                if (dispark.point <= point)
                    return true;
                if (dispark.point > point)
                    msg=langs[0].replace("*", dispark.point);
            }
            else if (dispark.point == 0 && dispark.level != 0) //只判断等级
            {
                if (dispark.level <= maxlv)
                    return true;
                if (dispark.level > maxlv)
                    msg=langs[1].replace("*", dispark.level);
            }
            else if (dispark.point != 0 && dispark.level != 0) //判断关卡和等级
            {
                if (dispark.point <= point && dispark.level <= maxlv)
                    return true;
                if (dispark.point > point && dispark.level > maxlv)
                {
                    msg=langs[2].replace("*", dispark.point).replace("*", dispark.level);
                }
                else if (dispark.point > point)
                {
                    msg=langs[0].replace("*", dispark.point);
                }
                else if (dispark.level > maxlv)
                {
                    msg=langs[1].replace("*", dispark.level);
                }
            }
            RollTips.add(msg);
            return false;
        }

        /**自动判断添加提示New图标 */
        public function addDisparkHandler(id:uint):void
        {
            var bool:Boolean=false;
            var dispark:DisparkData=DisparkData.hash.getValue(id);
            var point:int=GameMgr.instance.tollgateID - 1;
            var maxlv:int=HeroDataMgr.instance.getHerosMaxLv();
            //判断是否可以设置new的图标
            if (dispark.statue != 2)
            {
                if (dispark.point != 0 && dispark.level == 0) //只判断关卡
                {
                    if (dispark.point <= point)
                        bool=true;
                }
                else if (dispark.point == 0 && dispark.level != 0) //只判断等级
                {
                    if (dispark.level <= maxlv)
                        bool=true;
                }
                else if (dispark.point != 0 && dispark.level != 0) //判断关卡和等级
                {
                    if (dispark.point <= point && dispark.level <= maxlv)
                        bool=true;
                }
            }
            if (!bool)
            {
                return;
            }
            var displayContainer:DisplayObjectContainer=null;
            var icon:DisplayObject=null;
            var offsetX:Number=0, offsetY:Number=0;
            switch (id)
            {

                case ConfigDisparkStep.DisparkStep2: //图鉴
                    displayContainer=DisparkControl.dicDisplay["btn_pic"] as DisplayObjectContainer;
                    offsetX=-35;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep3: //酒馆
                    displayContainer=DisparkControl.dicDisplay["tavern_table_0"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["house_label_7"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep4: //雇佣兵
                    displayContainer=DisparkControl.dicDisplay["tavern_table_1"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    setIconHandler(displayContainer);
                    displayContainer=DisparkControl.dicDisplay["house_label_7"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep21: //命运之轮
                    displayContainer=DisparkControl.dicDisplay["tavern_table_2"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    setIconHandler(displayContainer);
                    displayContainer=DisparkControl.dicDisplay["house_label_7"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep5: //幸运星
                    displayContainer=DisparkControl.dicDisplay["welfare_lucky"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, -30, -5);
                    displayContainer=DisparkControl.dicDisplay["btn_welfare"] as DisplayObjectContainer;
                    offsetX=-35;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep6: //聊天
                    displayContainer=DisparkControl.dicDisplay["btn_chat"] as DisplayObjectContainer;
                    offsetX=16;
                    offsetY=-10;
                    break;
                case ConfigDisparkStep.DisparkStep7: //角斗场
                    displayContainer=DisparkControl.dicDisplay["house_label_6"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep8: //副本
                    displayContainer=DisparkControl.dicDisplay["house_label_8"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep9: //邮件
                    displayContainer=DisparkControl.dicDisplay["btn_mail"] as DisplayObjectContainer;
                    offsetX=-50;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep10: //恶梦
                    displayContainer=DisparkControl.dicDisplay["tag_modle"] as DisplayObjectContainer;
                    offsetX=10;
                    offsetY=-10;
                    break;
                case ConfigDisparkStep.DisparkStep11: //商店  
                    displayContainer=DisparkControl.dicDisplay["house_label_0"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep12: //英雄进化
                    displayContainer=DisparkControl.dicDisplay["hero_table_2"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["house_label_5"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep13: //英雄升星
                    displayContainer=DisparkControl.dicDisplay["hero_table_1"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["house_label_5"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep16: //英雄分解
                    displayContainer=DisparkControl.dicDisplay["hero_fenjie"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 8, -20);
                    displayContainer=DisparkControl.dicDisplay["house_label_5"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep19: //经验药水
                    displayContainer=DisparkControl.dicDisplay["hero_table_3"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["house_label_5"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep1: //装备强化
                    displayContainer=DisparkControl.dicDisplay["equintment_table_2"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["hero_blacksmith"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 20, -15);
                    displayContainer=DisparkControl.dicDisplay["house_label_3"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep15: //装备合成
                    displayContainer=DisparkControl.dicDisplay["equintment_table_1"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["hero_blacksmith"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 20, -15);
                    displayContainer=DisparkControl.dicDisplay["house_label_3"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep17: //装备镶嵌
                    displayContainer=DisparkControl.dicDisplay["equintment_table_3"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["hero_blacksmith"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 23, -15);
                    displayContainer=DisparkControl.dicDisplay["house_label_3"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep14: //宝珠抽取
                    displayContainer=DisparkControl.dicDisplay["magic_table_0"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["house_label_2"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep18: //宝珠吞噬
                    displayContainer=DisparkControl.dicDisplay["magic_table_2"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["house_label_2"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                case ConfigDisparkStep.DisparkStep20: //宝珠合成
                    displayContainer=DisparkControl.dicDisplay["magic_table_1"] as DisplayObjectContainer;
                    setIconHandler(displayContainer, 0, -5);
                    displayContainer=DisparkControl.dicDisplay["house_label_2"] as DisplayObjectContainer;
                    offsetX=5;
                    offsetY=-5;
                    break;
                default:
                    break;
            }
            setIconHandler(displayContainer, offsetX, offsetY);

        }


        /**移除功能开放图标*/
        public function removeDisparkHandler(id:uint):void
        {
            var displayContainer:DisplayObjectContainer=null;
            switch (id)
            {

                case ConfigDisparkStep.DisparkStep1: //装备强化
                    displayContainer=DisparkControl.dicDisplay["equintment_table_2"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["hero_blacksmith"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_3"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep2: //图鉴
                    displayContainer=DisparkControl.dicDisplay["btn_pic"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, false);
                    break;
                case ConfigDisparkStep.DisparkStep3: //酒馆
                    displayContainer=DisparkControl.dicDisplay["tavern_table_0"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_7"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep4: //雇佣兵
                    displayContainer=DisparkControl.dicDisplay["tavern_table_1"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_7"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep21: //命运之轮
                    displayContainer=DisparkControl.dicDisplay["tavern_table_2"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_7"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep5: //幸运星
                    displayContainer=DisparkControl.dicDisplay["welfare_lucky"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["btn_welfare"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep6: //聊天
                    displayContainer=DisparkControl.dicDisplay["btn_chat"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, false);
                    break;
                case ConfigDisparkStep.DisparkStep7: //角斗场
                    displayContainer=DisparkControl.dicDisplay["house_label_6"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, false);
                    break;
                case ConfigDisparkStep.DisparkStep8: //副本
                    displayContainer=DisparkControl.dicDisplay["house_label_8"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, false);
                    break;
                case ConfigDisparkStep.DisparkStep9: //邮件
                    displayContainer=DisparkControl.dicDisplay["btn_mail"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, false);
                    break;
                case ConfigDisparkStep.DisparkStep10: //恶梦
                    displayContainer=DisparkControl.dicDisplay["tag_modle"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, false);
                    break;
                case ConfigDisparkStep.DisparkStep11: //商店  
                    displayContainer=DisparkControl.dicDisplay["house_label_0"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, false);
                    break;
                case ConfigDisparkStep.DisparkStep12: //英雄进化
                    displayContainer=DisparkControl.dicDisplay["hero_table_2"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_5"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep13: //英雄升星
                    displayContainer=DisparkControl.dicDisplay["hero_table_1"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_5"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep15: //装备合成
                    displayContainer=DisparkControl.dicDisplay["equintment_table_1"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["hero_blacksmith"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_3"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep16: //英雄分解
                    displayContainer=DisparkControl.dicDisplay["hero_fenjie"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_5"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep19: //经验药水
                    displayContainer=DisparkControl.dicDisplay["hero_table_3"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_5"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep17: //装备镶嵌
                    displayContainer=DisparkControl.dicDisplay["equintment_table_3"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["hero_blacksmith"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_3"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep14: //宝珠抽取
                    displayContainer=DisparkControl.dicDisplay["magic_table_0"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_2"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep18: //宝珠吞噬
                    displayContainer=DisparkControl.dicDisplay["magic_table_2"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_2"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                case ConfigDisparkStep.DisparkStep20: //宝珠合成
                    displayContainer=DisparkControl.dicDisplay["magic_table_1"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, id, true);
                    displayContainer=DisparkControl.dicDisplay["house_label_2"] as DisplayObjectContainer;
                    removeIconHandler(displayContainer, 0, true);
                    break;
                default:
                    break;
            }

        }


        /**设置图标*/
        private function setIconHandler(displayContainer:DisplayObjectContainer, offsetX:Number=0, offsetY:Number=0):void
        {
            var icon:DisplayObject=null;
            if (displayContainer && !displayContainer.getChildByName("hoseDisparkIcon"))
            {
                icon=getDisparkIcon(0) as DisplayObject;
                icon.x=displayContainer.width - icon.width + offsetX;
                icon.y=offsetY;
                icon.touchable=false;
                icon.name="hoseDisparkIcon";
                displayContainer.addChild(icon);
                displayContainer.setChildIndex(icon, displayContainer.numChildren - 1);
            }
        }

        /**删除图标*/
        private function removeIconHandler(displayContainer:DisplayObjectContainer, id:uint, hasChild:Boolean):void
        {
            var icon:DisplayObject=null;
            if (displayContainer != null)
            {
                icon=displayContainer.getChildByName("hoseDisparkIcon") as DisplayObject;
                if (icon != null)
                {
                    var dispark:DisparkData=DisparkData.hash.getValue(id);
                    if (!hasChild && id != 0) //没有二级new图标
                    {
                        dispark.statue=2;
                    }
                    else if (hasChild && id != 0)
                    { //有二级new图标
                        dispark.statue=2;
                    }

                    icon.removeFromParent(true);

                    if (id != 0)
                    {
                        var cmd:CSetfunData=new CSetfunData();
                        cmd.id=id;
                        cmd.value=2;
                        Message.sendMessage(cmd);
                        ShowLoader.remove();
                    }
                }
            }
        }

        /**获取功能开放图标*/
        public function getDisparkIcon(type:uint=0):Image
        {
            var image:Image=null;
            if (type == 0)
            {
                image=new Image(AssetMgr.instance.getTexture("ui_renwu_new1"));
                image.scaleX=0.7;
                image.scaleY=0.7;
            }
            return image;
        }

        /**回调函数生成功能图标*/
        protected function callBackHandler(disparkData:DisparkData):void
        {
            addDisparkHandler(disparkData.id);
        }

        public function get disparkList():Vector.<DisparkRender>
        {
            return _disparkList;
        }

        public function set disparkList(value:Vector.<DisparkRender>):void
        {
            _disparkList=value;
        }


    }
}
