package game.view.userLog
{
    import com.adobe.utils.crypto.MD5;
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.mvc.interfaces.INotification;

    import flash.events.Event;
    import flash.filesystem.FileStream;
    import flash.geom.Rectangle;

    import game.dialog.ShowLoader;
    import game.net.GameSocket;
    import game.net.data.c.CResetPassword;
    import game.net.data.c.CRetrieveAllData;
    import game.net.data.c.CXYLMLogin;
    import game.net.data.s.SResetPassword;
    import game.net.data.s.SXYLMLogin;
    import game.net.message.ConnectMessage;
    import game.uils.Config;
    import game.uils.LocalShareManager;

    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class ResetPasswordDlg extends ResetPasswordDlgBase
    {

        public function ResetPasswordDlg()
        {
            super();

            _closeButton=backButton;

            titleTxt.text=Langue.getLangue("resetPassword");
            inputTxt.text=Langue.getLangue("newPassword");
            reInputTxt.text=Langue.getLangue("reNewPassword");

            tipsTxt.text="";

            backButton.text=Langue.getLangue("quit");
            okButton.text=Langue.getLangue("noticeDlgClose");

            okButton.addEventListener(starling.events.Event.TRIGGERED, onNext);

            inputTxt.addEventListener("focusIn", onsecurityfocusIn);
            inputTxt.addEventListener("focusOut", onsecurityfocusOut);

            reInputTxt.addEventListener("focusIn", onreInputTxtIn);
            reInputTxt.addEventListener("focusOut", onreInputTxtOut);

//        background = new Image( AssetMgr.instance.getTexture("ui_denglubeijing"));
        }

        private var _verifyCode:int;
        private var _acount:String;

        override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
        {
            super.open(container, parameter, okFun, cancelFun);

            _verifyCode=parameter.verifyCode;
            _acount=parameter.acount;

            setToCenter();


            var stageTextViewPort:Rectangle=inputTxt.viewPort;
            stageTextViewPort.x+=this.x;
            stageTextViewPort.y+=this.y;
            inputTxt.viewPort=stageTextViewPort;


            stageTextViewPort=reInputTxt.viewPort;
            stageTextViewPort.x+=this.x;
            stageTextViewPort.y+=this.y;
            reInputTxt.viewPort=stageTextViewPort;
        }

        override public function handleNotification(_arg1:INotification):void
        {

            if (_arg1 is SXYLMLogin)
            {
                var info:SXYLMLogin=_arg1 as SXYLMLogin;
                if (info.status == 20)
                {
                    if (info.progress == 1)
                    {
                        GameSocket.instance.sendData(new CRetrieveAllData());
                        ConnectMessage.sendCreateRole();

                    }
                    else if (info.progress >= 2)
                    {
                        GameSocket.instance.sendData(new CRetrieveAllData());
                        DialogMgr.instance.closeAllDialog();
                    }
                }
            }

            if (_arg1 is SResetPassword)
            {
                var sResetPassword:SResetPassword=_arg1 as SResetPassword;
                /*         # 0=成功
                 # 1=帐号不存在
                 # 2=你的帐号不是11位数字的手机号码，请联系客服重置
                 # 3=验证码已失效，请重新获取
                 # 127=重置失败
                 */
                if (sResetPassword.code == 0)
                {
                    RollTips.add(Langue.getLangue("resetSuccess"));
                    var date:Date=new Date();
                    var rand:int=date.time / 1000;

                    var cmd:CXYLMLogin=new CXYLMLogin();
                    cmd.password=reInputTxt.text;
                    cmd.account=_acount;
                    cmd.platform=Config.device;
                    cmd.rand=rand;
                    cmd.sid=1;
                    cmd.type=2;
                    var key:String="23d7f859778d2093";
                    var md:String=cmd.sid + "" + rand + "" + key + "" + cmd.account;
                    cmd.signature=MD5.hash(md);
                    GameSocket.instance.sendData(cmd);
                    ShowLoader.add();

                    var file:FileStream=new FileStream();

//                var str:String = _acount + ":" + reInputTxt.text;
//				LocalShareManager.getInstance().save(LocalShareManager.USER_PWD,str);
                }
                else if (sResetPassword.code == 1)
                {
                    RollTips.add(Langue.getLangue("securityCodeNoAcount"));
                }
                else if (sResetPassword.code == 2)
                {
                    RollTips.add(Langue.getLangue("securityCodeNotPhoneNumber"));
                }
                else if (sResetPassword.code == 3)
                {
                    RollTips.add(Langue.getLangue("securityCodeTimeout"));
                }
                else if (sResetPassword.code == 4)
                {
                    RollTips.add(Langue.getLangue("securityCodeWrong"));
                }
                else if (sResetPassword.code >= 127)
                {
                    RollTips.add(Langue.getLangue("resetFail"));
                }

            }

            ShowLoader.remove();
        }

        override public function listNotificationName():Vector.<String>
        {
            return new <String>[String(SXYLMLogin.CMD), String(SResetPassword.CMD)];
        }

        private function onreInputTxtIn(event:flash.events.Event):void
        {

            if (reInputTxt.text == Langue.getLangue("reNewPassword"))
            {
                reInputTxt.text="";
            }
        }

        private function onreInputTxtOut(event:flash.events.Event):void
        {

            if (!reInputTxt.text)
            {
                reInputTxt.text=Langue.getLangue("reNewPassword");
            }
        }

        private function onsecurityfocusIn(event:flash.events.Event):void
        {

            if (inputTxt.text == Langue.getLangue("newPassword"))
            {
                inputTxt.text="";
            }
        }

        private function onsecurityfocusOut(event:flash.events.Event):void
        {

            if (!inputTxt.text)
            {
                inputTxt.text=Langue.getLangue("newPassword");
            }
        }

        private function onNext(e:starling.events.Event):void
        {

            var pwd1:String=inputTxt.text;
            var pwd2:String=reInputTxt.text;

            if (!pwd1 || !pwd2)
            {
                RollTips.add(Langue.getLangue("passwordNotNull"));
                return;
            }

            if (pwd1 != pwd2)
            {
                RollTips.add(Langue.getLangue("passwordNoMatch"));
                return;
            }


            if (!Verification.specialUnicodes(pwd1))
            {
                RollTips.add(Langue.getLangue("passwordRule1"));
                return;
            }


            /*
             *   # 玩家帐号，必段是符合以下条件才能获取：
             # 1、长度为11字节
             # 2、全部为数字
             # 3、开头两头必须是：13、14、15、18
             'account' => 'string',
             # 六位数字的验证码，10分钟内有效
             'verifyCode' => 'int32',
             # 新密码
             'password' => 'string',
             * */
            var cmd:CResetPassword=new CResetPassword();
            cmd.account=_acount;
            cmd.verifyCode=_verifyCode;
            cmd.password=pwd1;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }
    }
}
