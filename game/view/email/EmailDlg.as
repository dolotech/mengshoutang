package game.view.email
{
    import flash.text.TextFormat;

    import feathers.controls.List;
    import feathers.controls.ScrollText;
    import feathers.controls.Scroller;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;

    import game.net.message.MailMessage;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.viewBase.EmailDlgBase;

    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    /**
     * 邮件系统
     * @author Administrator
     *
     */
    public class EmailDlg extends EmailDlgBase
    {
        private var emailId:int;
        private var list_mail:List;
        private var list_reward:Array=[];
        private const PAGE_COUNT:int=3;
        private var data:Object;
        private var scrollBar:ScrollText;

        public function EmailDlg()
        {
            super();
        }

        override protected function init():void
        {
            enableTween=true;
            btn_get.text=getLangue("getGoods"); //收取，按钮名字
            btn_get.fontColor=0xffffcc;
            btn_get.fontSize=30;
            //设置关闭按钮
            _closeButton=btn_close;

            scrollBar=new ScrollText();
            scrollBar.x=txt_des.x;
            scrollBar.y=txt_des.y;
            scrollBar.width=txt_des.width;
            scrollBar.height=txt_des.height;

            var textFormat:TextFormat=new TextFormat(txt_des.fontName, txt_des.fontSize, txt_des.color);
            scrollBar.textFormat=textFormat;
            addChild(scrollBar);
            txt_des.removeFromParent(true);

            const listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.gap=8;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_mail=new List();
            list_mail.x=45;
            list_mail.y=120;
            list_mail.width=331;
            list_mail.height=420;
            addChild(list_mail);
            list_mail.layout=listLayout;
            list_mail.paddingLeft=0;
            list_mail.horizontalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_mail.verticalScrollPolicy=Scroller.SCROLL_POLICY_ON;
            list_mail.itemRendererFactory=itemRendererFactory;

            function itemRendererFactory():IListItemRenderer
            {
                const renderer:EmailRenderItem=new EmailRenderItem();
                renderer.setSize(322, 115);
                return renderer;
            }

            var item:EmailReward;

            for (var i:int=1; i <= 3; i++)
            {
                item=new EmailReward(this["goods" + i]);
                addChild(item);
                list_reward.push(item);
            }
            clickBackroundClose();
        }

        override protected function addListenerHandler():void
        {
            super.addListenerHandler();
            this.addViewListener(btn_get, Event.TRIGGERED, onGetGoods);
            this.addViewListener(list_mail, Event.CHANGE, onChange);
            this.addViewListener(list_mail, Event.SCROLL, onScroll);
            this.addContextListener(MailMessage.UPDATE_MAIL_LIST, onUpdateList);
            this.addContextListener(MailMessage.SELECT_MAIL, onSelectMail);
        }

        override protected function openTweenComplete():void
        {
            setToCenter();
            this.updateMailInfo(null);
            //请求邮件
            MailMessage.sendMailList();
        }

        /**
         * 更新列表事件
         * @param evt
         *
         */
        private function onUpdateList(evt:Event):void
        {
            data=evt.data;
            updatePage();
        }

        /**
         * 根据当前页数刷新界面
         * @param tmp_page
         *
         */
        private function updatePage():void
        {
            var page:int=list_mail.horizontalPageIndex;
            list_mail.dataProvider=new ListCollection(data);
            list_mail.verticalScrollPosition=list_pos;
        }

        /**
         * 选择上一封邮件
         * @param evt
         *
         */
        private var selectIndex:int;
        private var list_pos:Number=0;

        private function onSelectMail(evt:Event):void
        {
            if (list_mail.dataProvider && list_mail.dataProvider.length > 0)
            {
                if (selectIndex >= data.length)
                    selectIndex=data.length - 1;
                list_mail.selectedIndex=selectIndex;
            }
        }

        /**
         * 领取邮件附件
         * @param e
         *
         */
        private function onGetGoods(e:Event):void
        {
            if (emailId == 0)
            {
                addTips("请选择邮件");
                return;
            }

            if (list_mail.selectedIndex != -1)
                selectIndex=list_mail.selectedIndex;

            if (btn_get.text == getLangue("getGoods"))
            {
                MailMessage.sendGetMailItmes(emailId);
            }
            else if (btn_get.text == getLangue("delete"))
            {
                MailMessage.sendDeleteMail(emailId);
            }
        }


        /**
         * 上一页
         * @param e
         *
         */
        private function onPrev(e:Event):void
        {
            if (list_mail.isScrolling)
                return;
            list_mail.throwToPage(list_mail.horizontalPageIndex - 1 < 0 ? 0 : list_mail.horizontalPageIndex - 1, -1, 0.3);
        }

        /**
         * 下一页
         * @param e
         *
         */
        private function onNext(e:Event):void
        {
            if (list_mail.isScrolling)
                return;
            list_mail.throwToPage(list_mail.horizontalPageIndex + 1 >= list_mail.horizontalPageCount ? list_mail.horizontalPageIndex : list_mail.horizontalPageIndex + 1, -1, 0.3);
        }

        /**
         * 选中邮件处理
         * @param e
         *
         */
        private function onChange(e:Event):void
        {
            updateMailInfo(list_mail.selectedItem as MailData);
        }

        private function onScroll(e:Event):void
        {
            list_pos=list_mail.verticalScrollPosition;
        }

        /**
         * 更新右边邮件详细信息
         * @param mail
         *
         */
        private function updateMailInfo(mail:MailData):void
        {
            emailId=mail ? mail.id : 0;
            scrollBar.text=mail ? mail.content : "";
            txt_sender.text=mail ? mail.from : "";
            txt_name.text=mail ? mail.from : "";

            var len:int=list_reward.length;
            var tmp_data:Object;
            var rewardCount:int=0;

            for (var i:int=0; i < len; i++)
            {
                tmp_data=(mail && mail.items.length - 1 >= i) ? mail.items[i] : null;
                list_reward[i].data=tmp_data;
                rewardCount+=tmp_data ? 1 : 0;
            }
            scrollBar.height=rewardCount > 0 ? 161 : 260;
            grid.visible=rewardCount > 0;
            btn_get.text=mail == null || mail.items.length == 0 ? getLangue("delete") : getLangue("getGoods");
        }

        override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
        {
            super.open(container, parameter, okFun, cancelFun);
        }

        override public function close():void
        {
            //智能判断是否删除功能开放提示图标（邮件）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep9);
            super.close();
        }

        override public function dispose():void
        {
            super.dispose();

            for each (var mailData:MailData in data)
            {
                if (mailData)
                    mailData.parent=null;
            }
            list_reward=null;
            data=null;
        }

    }
}
