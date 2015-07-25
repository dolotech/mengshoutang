package game.view.activity.activity {
    import com.components.RollTips;
    import com.data.HashMap;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.mvc.interfaces.INotification;
    import com.utils.ObjectUtil;

    import game.data.FirstPay;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.RoleShow;
    import game.dialog.ShowLoader;
    import game.manager.AssetMgr;
    import game.net.GameSocket;
    import game.net.data.c.CFirstPayPrize;
    import game.net.data.c.CFirstPayStart;
    import game.net.data.s.SFirstPayPrize;
    import game.net.data.s.SFirstPayStart;
    import game.view.activity.IActivity;
    import game.view.viewBase.FirstPayBase;
    import game.view.vip.VipDlg;

    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.textures.Texture;

    /**
     *
     * @author litao 首冲
     *
     */
    public class ActivityFirstPay extends FirstPayBase implements IActivity {
        //private var isShow:Boolean;
        private static var isReceive:Boolean;

        public function ActivityFirstPay() {
            super();

            Recharge.addEventListener(Event.TRIGGERED, onRecharge);
            Recharge.visible = false;
            send();
        }

        private function onRecharge(e:Event):void {
            if (!isReceive)
                DialogMgr.instance.open(VipDlg, VipDlg.CHARGE);
            else {
                receiveSend();
            }
        }

        private function receiveSend():void {
            var cmd:CFirstPayPrize = new CFirstPayPrize();
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        public function set data(data:Object):void {
            showGoods(data as HashMap);
        }

        private function get This():ActivityFirstPay {
            return this;
        }

        private function send():void {
            var cmd:CFirstPayStart = new CFirstPayStart();
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        private function showGoods(datas:HashMap):void {
            if (isShow)
                return;
            var icon:Image;
            var texture:Texture;
            var box:Button;
            var text:TextField;
            var numText:TextField;
            datas.eachValue(function(value:FirstPay):void {
                box = This["box" + value.id];
                box.touchable = false;
                box.downState = null;
                text = This["name_" + value.id];
                text.fontSize = 18;
                numText = This["values_" + value.id];
                if (value.tid == 1) {
                    texture = AssetMgr.instance.getTexture("ui_tubiao_jinbi_da");
                    icon = new Image(texture);
                    box.addQuiackChild(icon);
                    boxQuality(box, 0);
                    text.text = Langue.getLans("props")[2];
                } else if (value.tid == 2) {
                    texture = AssetMgr.instance.getTexture("ui_tubiao_zuanshi_da");
                    icon = new Image(texture);
                    boxQuality(box, 0);
                    box.addQuiackChild(icon);
                    text.text = Langue.getLangue("diamond");
                } else if (value.tid == 5) {
                    var heroData:HeroData = HeroData.hero.getValue(value.heroType) as HeroData;
                    var photo:String = (RoleShow.hash.getValue(heroData.show) as RoleShow).photo;
                    texture = AssetMgr.instance.getTexture(photo);
                    icon = new Image(texture);
                    var child:DisplayObject
                    child = box.getChildAt(0);
                    child.width = 100;
                    child.height = 100;
                    box.addQuiackChild(icon);
                    box.x -= 4;
                    box.y -= 5;
                    boxQuality(box, value.quality - 1, true);
                    box.downState = null;
                    ObjectUtil.setToCenter(box.getChildAt(0), icon);
                    icon.y += 3;
                    icon = null;
                    text.text = value.name;
                } else {
                    var widget:Goods = Goods.goods.getValue(value.tid);
                    texture = AssetMgr.instance.getTexture(widget.picture);
                    icon = new Image(texture);
                    box.addQuiackChildAt(icon, 0);
                    boxQuality(box, widget.quality - 1);
                    text.text = widget.name;
                }
                icon && ObjectUtil.setToCenter(box.getChildAt(0), icon);
                numText.text = "x" + value.num + "";
            });
            isShow = true;
        }

        private function boxQuality(box:Button, quality:int, isHero:Boolean = false):void {
            var texture:Texture;
            if (!isHero) {
                texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + quality);
                box.upState = texture;
            } else {
                var heroDi:Image = new Image(AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_kong1"));
                box.addQuiackChildAt(heroDi, 0);
                texture = AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + quality);
                box.upState = texture;
            }
        }

        override public function handleNotification(_arg1:INotification):void {
            if (_arg1.getName() == String(SFirstPayStart.CMD)) {
                var info:SFirstPayStart = _arg1 as SFirstPayStart;
                if (info.code == 0) {
                    isReceive = true;
//                    RollTips.add(Langue.getLangue("okUse")); //可领取
                    Recharge.visible = true;
                } else if (info.code == 1) {
                    isReceive = false;
//                    RollTips.add(Langue.getLangue("notUse")); //不可领取
                    Recharge.visible = true;
                } else if (info.code == 2) {
                    isReceive = false;
//                    RollTips.add(Langue.getLangue("alreadyUse")); //已经领取
                    Recharge.visible = true;
                } else {
                    RollTips.add(Langue.getLangue("codeError") + "," + info.code);
                }
            } else {
                var info1:SFirstPayPrize = _arg1 as SFirstPayPrize;
                if (info1.code == 0) {
                    RollTips.add(Langue.getLangue("signRewardSucceed")); //领取成功
                } else if (info1.code == 1) {
                    RollTips.add(Langue.getLangue("notReceive")); //未达到领取条件
                } else if (info1.code == 2) {
                    RollTips.add(Langue.getLangue("useReceive")); //您已经领取过
                } else if (info1.code == 3) {
                    RollTips.add(Langue.getLangue("packFulls")); //背包已满，物品已通过邮件发送
                } else if (info1.code >= 127) {
                    RollTips.add(Langue.getLangue("codeError") + info1.code);
                }
            }
            ShowLoader.remove();
        }

        override public function listNotificationName():Vector.<String> {
            var vect:Vector.<String> = new Vector.<String>;
            vect.push(SFirstPayStart.CMD, SFirstPayPrize.CMD);
            return vect;
        }

        public function set scrollToPageIndex(value:int):void {

        }
    }
}
