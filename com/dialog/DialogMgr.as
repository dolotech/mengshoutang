package com.dialog {
    import com.scene.SceneMgr;
    import com.singleton.Singleton;
    import com.utils.Assets;
    import com.utils.Constants;

    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getTimer;

    import avmplus.getQualifiedClassName;

    import feathers.core.PopUpManager;

    import game.common.JTGlobalDef;
    import game.managers.JTFunctionManager;
    import game.view.chat.component.JTChatControllerComponent;
    import game.view.city.CityFace;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    /***
     * 对话弹出层管理器
     *
     * ***/
    public class DialogMgr {

        private static var _cacheDlg:Dictionary;
        private static var _modalDic:Dictionary;
        private var _dialogList:Array = [];
        private var _container:DisplayObjectContainer;
        private var _oldTime:int;

        public function DialogMgr() {
            _cacheDlg = new Dictionary();
            _modalDic = new Dictionary();
        }

        public static function get instance():DialogMgr {
            return Singleton.getInstance(DialogMgr) as DialogMgr;
        }

        /**
         * 设置对话框遮罩
         * @param window
         * @param display
         * @param color
         * @param al
         * @return
         *
         */
        private function setmodal(window:Class, mode:String, color:int = 0x00000, al:Number = 0):DisplayObject {
            var key:String = getQualifiedClassName(window);
            var modal:DisplayObject = _modalDic[key];

            if (mode == Dialog.OPEN_MODE_NOTHING) {
                if (modal && _container.contains(modal)) {
                    _container.removeChild(modal);
                }
                delete _modalDic[key];
                return null;
            }

            if (!modal) {
                if (mode == Dialog.OPEN_MODE_TRANSLUCENCE) {
                    modal = Assets.getImage(Assets.Alpha_Backgroud);
                    modal.alpha = al;
                }
                modal.width = _container.stage.stageWidth;
                modal.height = _container.stage.stageHeight;
                _modalDic[key] = modal;
            }

            if (mode == Dialog.OPEN_MODE_TRANSLUCENCE) {
                modal.alpha = 0;
                Starling.juggler.tween(modal, 0.5, {alpha: al});
            }
            _container.addChild(modal);
            return modal;
        }

        public function init(_container:DisplayObjectContainer):void {
            this._container = _container;
        }

        public static function isEmpty():Boolean {
            return instance._dialogList.length > 0 ? false : true;
        }

        public function open(className:Class, parameter:Object = null, okFun:Function = null, cancelFun:Function = null,
                             mode:String = "translucence", color:uint = 0x000000, al:Number = 0.5):IDialog {
            if (SceneMgr.instance.isScene(CityFace) && isEmpty() && PopUpManager.isEmpty()) {
                JTChatControllerComponent.close();
            }

            if (isShow(className)) {
                return getDlg(className);
            }

            for each (var child:Dialog in _dialogList) {
                if (child && !child.isVisible)
                    child.visible = false;
            }

            var dialog:IDialog = getDlg(className);
            var dlg:DisplayObject = dialog as DisplayObject;
            dlg.scaleX = dlg.scaleY = Constants.isScaleWidth ? Constants.scale_x : Constants.scale;
            _dialogList.push(dialog);

            if ((dialog as Dialog).background) {
                var modeSp:DisplayObject = setBackground((dialog as Dialog));
            } else {
                modeSp = setmodal(className, mode, color, al);
            }

            dialog.open(_container, parameter, okFun, cancelFun);
            dlg.addEventListener(Dialog.CLOSE_CONTAINER, onCloseHandler);
            return dialog;
        }


        private function setBackground(dialog:Dialog):DisplayObject {
            var key:String = getQualifiedClassName(dialog);
            var sp:DisplayObject = dialog.background;
            sp.width = _container.stage.stageWidth;
            sp.height = _container.stage.stageHeight;
            _modalDic[key] = sp;
            _container.addChild(sp);
            return sp;
        }

        private function onStageTouch(event:TouchEvent):void {
            var mode:DisplayObject = event.currentTarget as DisplayObject;
            var touch:Touch = event.getTouch(mode);

            if (!touch)
                return;

            if (touch.phase == TouchPhase.BEGAN) {
                _oldTime = getTimer();
            } else if (touch.phase == TouchPhase.ENDED) {
                if (getTimer() - _oldTime < 1000) {
                    for (var key:String in _modalDic) {
                        if (_modalDic[key] == mode) {
                            deleteDlg(_cacheDlg[key] as IDialog);
                            break;
                        }
                    }
                }
            } else if (touch.phase == TouchPhase.MOVED) {

            }
        }

        private function onCloseHandler(evt:Event):void {
            var dialog:IDialog = evt.target as IDialog;
            deleteDlg(dialog);

            if (SceneMgr.instance.isScene(CityFace) && isEmpty() && PopUpManager.isEmpty() && JTChatControllerComponent.isShowCityIcon) //关闭聊天窗口
            {
                JTFunctionManager.executeFunction(JTGlobalDef.SHOW_CHAT_PANEL);
            }
        }

        public function getTopDialog():IDialog {
            var dialog:IDialog;

            if (_container.numChildren > 0) {
                dialog = _container.getChildAt(_container.numChildren - 1) as IDialog;
            }
            return dialog;
        }

        public function deleteDlgByClass(dlgClass:Class):void {
            var dialog:IDialog = getDlg(dlgClass);

            if (dialog)
                deleteDlg(dialog);
        }

        public function closeDialog(resClass:Class):void {
            var dialog:IDialog = getDlg(resClass);
            dialog && dialog.close();
        }

        /**
         * 删除对话框
         *
         * 根据类名或实例
         * @param dialog
         *
         */
        public function deleteDlg(dialog:*):void {
            var key:String = getQualifiedClassName(dialog);
            var dlg:DisplayObject = _cacheDlg[key] as DisplayObject;

            if (_dialogList.length > 0) {
                var index:int = _dialogList.indexOf(dlg);

                if (index != -1)
                    _dialogList.splice(index, 1);

                if (_dialogList.length)
                    _dialogList[_dialogList.length - 1].visible = true;
            }

            if (dlg) {
                dlg.removeEventListener(Dialog.CLOSE_CONTAINER, onCloseHandler);
                dlg.removeFromParent(true);
            }

            var modal:DisplayObject = _modalDic[key];

            if (modal) {
                modal.removeEventListener(TouchEvent.TOUCH, onStageTouch);
                Starling.juggler.removeTweens(modal);
                modal.removeFromParent(true);
            }

            _cacheDlg[key] = null;
            _modalDic[key] = null;
            delete _cacheDlg[key];
            delete _modalDic[key];
        }

        /**
         * 关闭所有打开对话框
         *
         */
        public function closeAllDialog():void {
            for each (var dilaog:IDialog in _cacheDlg) {
                deleteDlg(dilaog);
            }
            JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
        }

        public function getDlg(className:Class):IDialog {
            var key:String = getQualifiedClassName(className);
            var dialog:IDialog = _cacheDlg[key];

            if (!dialog) {
                dialog = new className();
                _cacheDlg[key] = dialog;
            }
            return dialog;
        }

        public function isShow(className:Class):Boolean {
            var bool:Boolean = false;
            var key:String = getQualifiedClassName(className);
            var dialog:IDialog = _cacheDlg[key];

            if (dialog) {
                if (DisplayObject(dialog).parent) {
                    bool = true;
                }
            }
            return bool;
        }

        public function get currScene():Class {
            return SceneMgr.instance.sceneClass;
        }

        public function get currDialogs():Array {
            var array:Array = [];

            var len:int = _dialogList.length;
            for (var i:int = 0; i < len; i++) {
                array.push(getDefinitionByName(getQualifiedClassName(_dialogList[i])));
            }
            return array;
        }

        public function get currDialogParams():Array {
            var array:Array = [];

            var len:int = _dialogList.length;
            for (var i:int = 0; i < len; i++) {
                array.push(Dialog(_dialogList[i]).backParam);
            }
            return array;
        }
    }
}
