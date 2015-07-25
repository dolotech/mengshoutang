package game.view.userLog
{
import com.components.RollTips;
import com.dialog.DialogMgr;
import com.langue.Langue;
import com.mvc.interfaces.INotification;

import flash.events.Event;
import flash.geom.Rectangle;

import game.dialog.ShowLoader;
import game.net.GameSocket;
import game.net.data.c.CGetVerifyCode;
import game.net.data.s.SGetVerifyCode;

import starling.core.Starling;
import starling.display.DisplayObjectContainer;
import starling.events.Event;

	public class GetBackPasswordVerificationCodeDlg extends GetBackPasswordVerificationCodeDlgBase
	{
		public function GetBackPasswordVerificationCodeDlg()
		{
			super();
			
			_closeButton = backButton;
			okButton.addEventListener(starling.events.Event.TRIGGERED,onNext);
            securityCodeButton.addEventListener(starling.events.Event.TRIGGERED,onSecurityCode);
			okButton.text = Langue.getLangue("nextStep");
			backButton.text = Langue.getLangue("quit");
			titleTxt.text = Langue.getLangue("getBackPassword");
			
			phoneNumberTxt.text = Langue.getLangue("mustPhoneNumber");

			tips1Txt.text = Langue.getLangue("confirmPhoneNumber");
			//tips2Txt.text = Langue.getLangue("confirmPhoneNumber");

            securityCodeTxt.text =  Langue.getLangue("securityCode");

           phoneNumberTxt.addEventListener("focusIn",onfocusIn);
            phoneNumberTxt.addEventListener("focusOut",onfocusOut);
//            phoneNumberTxt.addEventListener("change",detelPhoneNumber);


            securityCodeTxt.addEventListener("focusIn",onsecurityfocusIn);
            securityCodeTxt.addEventListener("focusOut",onsecurityfocusOut);


//            background = new Image( AssetMgr.instance.getTexture("ui_denglubeijing"));
        }

        override  protected function oncancelBtn() : void
        {
            DialogMgr.instance.open(UserLoginDlg);
            super.oncancelBtn();
        }


        private function onSecurityCode(event:starling.events.Event):void {
            var key:String = phoneNumberTxt.text;
            const pattern : RegExp = /(13|14|15|18)\d{9}$/;
            if(!key.match(pattern))
            {
                RollTips.add(Langue.getLangue("securityCodeNotPhoneNumber"));
                return;
            }

            var cmd:CGetVerifyCode = new CGetVerifyCode();
            cmd.account = phoneNumberTxt.text;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }
		
		private function onNext(e:starling.events.Event):void
		{
			// TODO Auto Generated method stub
            var key:String = phoneNumberTxt.text;
            const pattern : RegExp = /(13|14|15|18)\d{9}$/;
            if(!key.match(pattern))
            {
                RollTips.add(Langue.getLangue("securityCodeNotPhoneNumber"));
                return;
            }

            if( !securityCodeTxt.text || securityCodeTxt.text ==  Langue.getLangue("securityCode")){
                RollTips.add(Langue.getLangue("securityCode"));
                return;
            }
			DialogMgr.instance.open(ResetPasswordDlg,{verifyCode:securityCodeTxt.text,acount:key},null,onCancel);
            phoneNumberTxt.stage = null;
            securityCodeTxt.stage = null;
		}

        private function onCancel(obj:Object):void
        {
            phoneNumberTxt.stage = Starling.current.nativeStage;
            securityCodeTxt.stage = Starling.current.nativeStage;
        }

        private function onsecurityfocusIn(event:flash.events.Event):void {

            if(securityCodeTxt.text == Langue.getLangue("securityCode"))
            {
                securityCodeTxt.text = "";
            }
        }

        private function onsecurityfocusOut(event:flash.events.Event):void {

            if(!securityCodeTxt.text)
            {
                securityCodeTxt.text = Langue.getLangue("securityCode");
            }
        }

        private function onfocusIn(event:flash.events.Event):void {

                   if(phoneNumberTxt.text == Langue.getLangue("mustPhoneNumber"))
                   {
                       phoneNumberTxt.text = "";
                   }
        }

        private function onfocusOut(event:flash.events.Event):void {

            if(!phoneNumberTxt.text)
            {
                phoneNumberTxt.text = Langue.getLangue("mustPhoneNumber");
            }

        }


        override public function handleNotification(_arg1:INotification):void
        {

            var info:SGetVerifyCode = _arg1 as SGetVerifyCode;

            if(info)
            {
     /*       # 0=成功
            # 1=帐号不存在
            # 2=你的帐号不是11位数字的手机号码，请联系客服重置
            # 3=请稍后再获取验证码 (5分钟倒计时不为0时收到了请求)
            # 127=获取失败*/
                    if(info.code == 0)
                    {
                        RollTips.add(Langue.getLangue("securityCodeSucess"));
                    }
                    else if(info.code == 1)
                    {
                        RollTips.add(Langue.getLangue("securityCodeNoAcount"));
                    }
                    else if(info.code == 2)
                    {
                        RollTips.add(Langue.getLangue("securityCodeNotPhoneNumber"));
                    }
                    else if(info.code == 3)
                    {
                        RollTips.add(Langue.getLangue("securityCodeWait"));
                    }
                    else if(info.code >= 127)
                    {
                        RollTips.add(Langue.getLangue("securityCodeFail"));
                    }

            }

            ShowLoader.remove();
        }

        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            super.open(container, parameter, okFun, cancelFun);
            setToCenter();



            var stageTextViewPort:Rectangle = phoneNumberTxt.viewPort;
            stageTextViewPort.x += this.x;
            stageTextViewPort.y +=   this.y;
            phoneNumberTxt.viewPort = stageTextViewPort;


            stageTextViewPort = securityCodeTxt.viewPort;
            stageTextViewPort.x += this.x;
            stageTextViewPort.y +=   this.y;
            securityCodeTxt.viewPort = stageTextViewPort;
        }

        override public function listNotificationName():Vector.<String>
        {
            var vect:Vector.<String> = new Vector.<String>;
            vect.push(SGetVerifyCode.CMD);
            return vect;
        }
    }
}