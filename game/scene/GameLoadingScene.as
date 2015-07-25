package game.scene
{
    import com.dialog.DialogMgr;
    import com.mobileLib.utils.ConverURL;
    import com.scene.BaseScene;
    import com.utils.ArrayUtil;
    import com.utils.Assets;
    import com.utils.Constants;
    import com.view.base.event.EventType;
    
    import flash.display.Bitmap;
    import flash.utils.getTimer;
    
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.net.data.c.CRetrieveAllData;
    import game.net.message.ConnectMessage;
    import game.net.message.GameMessage;
    import game.net.message.MailMessage;
    import game.net.message.RoleInfomationMessage;
    import game.uils.HttpServerList;
    import game.uils.LocalShareManager;
    import game.view.new2Guide.data.NewDialogData;
    
    import sdk.PushNotifications;
    import sdk.base.PhoneDevice;
    
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;
    
    import treefortress.spriter.SpriterClip;

    public class GameLoadingScene extends BaseScene
    {
        private var progressbar : SpriterClip;
        private var titleTxt : TextField;
        private var ratio : int;
        private var image : Image;

        public function GameLoadingScene(isAutoInit : int = -1)
        {
            super(isAutoInit);
        }

        override protected function init() : void
        {
            if (HttpServerList.list_login)
                LocalShareManager.getInstance().save(LocalShareManager.SERVER, ArrayUtil.change2Array(HttpServerList.list_login, "sid"), false);

            progressbar = AnimationCreator.instance.create("progressbar_home", AssetMgr.instance);

            titleTxt = new TextField(600, 40, '', '', 20, 0xffffff, false);
            titleTxt.touchable = false;
            titleTxt.hAlign = 'center';

            //推送
            PushNotifications.getInstance().start();
            addQuiackChild(progressbar);
            addQuiackChild(titleTxt);
            addBg(Assets.Logo_IMAGE);
            DialogMgr.instance.closeAllDialog();
            ShowLoader.remove();
            setRatio(1);
            delayCall(startLoader, 0.1);
        }

        override protected function addListenerHandler() : void
        {
            super.addListenerHandler();
            this.addContextListener(EventType.CONNNECT, onConnect);
        }

        /**
         * 加载背景资源
         * @param bitmap
         *
         */
        private var bg_height : int;

        public function addBg(bitmap : Bitmap) : void
        {
            image = new Image(Texture.fromBitmap(bitmap));
            addQuiackChild(image);

            image.x = bitmap.x / Constants.scale;
            image.y = bitmap.y / Constants.scale;

            bg_height = image.height;
            Constants.setToStageCenter(titleTxt);
            titleTxt.y = image.y + bg_height + 60 / Constants.scale;

            if (bitmap.parent)
                bitmap.parent.removeChild(bitmap);
        }

        /**
         * 开始加载
         *
         */
        public function startLoader() : void
        {
            var time : int = getTimer();
            ratio = 0;
            AssetMgr.instance.removeUi("ui", "loginUi/");
            NewDialogData.loadAllRes(AssetMgr.instance);
            AssetMgr.instance.enqueue(ConverURL.conver("voice/"), ConverURL.conver("home/"), ConverURL.conver("skill/skill_111"), ConverURL.conver("effect/effect_026"), ConverURL.conver("icon/"), ConverURL.conver("photo/"), ConverURL.conver("weapon/"), ConverURL.conver("effect/"), ConverURL.conver("ui/"), ConverURL.conver("fight/"));
            AssetMgr.instance.loadQueue(onComplete);

            function onComplete(tmp_ratio : Number) : void
            {
                setRatio(tmp_ratio * 100);

                if (tmp_ratio == 1.0)
                {
                    warn("加载耗时:" + (getTimer() - time));
                    ConnectMessage.isAutoLogin = true;
                    text = getLangue("login");
                    onConnect();
                }
            }
        }

        private function onConnect() : void
        {
            sendMessage(new CRetrieveAllData());
            //请求邮件列表
            MailMessage.sendMailList();
            //请求打过的副本
            //FBCDData.getPassFbList();
            //请求噩梦难度
            GameMessage.getFbNightmareInfo();
            //请求VIP信息
            RoleInfomationMessage.sendGetVipInfo();
            //双倍请求
            RoleInfomationMessage.sendDiamondDouble();

            ShowLoader.remove();
            //检测是否有充值信息没有提交
            checkCharge();
        }

        /**
         * 检测是否有充值信息没有提交
         *
         */
        private function checkCharge() : void
        {
            var chargeMsg : String = LocalShareManager.getInstance().get(LocalShareManager.CHARGE);

            if (chargeMsg == null)
                return;
            PhoneDevice.sendDiamondShop(chargeMsg)
        }

        private function setRatio(value : int) : void
        {
            if (value <= ratio)
                return;
            ratio = value;
            progressbar.play("progressbar_home");
            progressbar.update(progressbar.animation.length * (value - 1) / 100);
            progressbar.stop();
            text = getLangue("loader") + value + "%";
            Constants.setXToStageCenter(progressbar);
            progressbar.y = image.y + bg_height + 20 / Constants.scale;
        }

        public function set text(value : String) : void
        {
            titleTxt.text = value;
        }

        override public function dispose() : void
        {
            super.dispose();
            titleTxt.dispose();
            progressbar.dispose();
            image && image.texture.dispose();
            image.dispose();
        }
    }
}


