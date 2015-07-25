package game.view.loginReward.render
{
    import feathers.controls.renderers.DefaultListItemRenderer;

    import game.base.BaseIcon;
    import game.data.IconData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;

    import starling.core.Starling;
    import starling.events.Event;

    import treefortress.spriter.SpriterClip;

    /**
     * @author lfr
     * 2014 07 10
     */
    public class PlayersAwardList extends DefaultListItemRenderer
    {

        private var selectIco:SpriterClip=null;

        private var icon:BaseIcon=null;

        public function PlayersAwardList()
        {
            super();
        }

        override public function set data(value:Object):void
        {
            super.data=value;
            if (data != null)
            {
                if (icon == null)
                {
                    icon=new BaseIcon(data as IconData);
                    addQuiackChild(icon);
                }
                else
                {
                    icon.updata(data as IconData);
                }
            }
            else
            {
                dispose();
            }
        }

        override public function set isSelected(value:Boolean):void
        {
            super.isSelected=value;
            if (value)
            {
                if (selectIco == null)
                {
                    selectIco=AnimationCreator.instance.create("effect_012", AssetMgr.instance);
                    selectIco.play("effect_012");
                    selectIco.animation.looping=true;
                    Starling.juggler.add(selectIco);
                    addChild(selectIco);
                    selectIco.touchable=false;
                    selectIco.x=45;
                    selectIco.y=45;
                }
                owner && owner.dispatchEventWith(Event.SELECT, false, data);
            }
            else
            {
                if (selectIco != null)
                {
                    selectIco.stop();
                    Starling.juggler.remove(selectIco);
                    selectIco.removeFromParent();
                    selectIco=null;
                }
            }
        }

        override public function dispose():void
        {

            selectIco && selectIco.removeFromParent();
            selectIco=null;
            if (icon != null)
                icon.dispose();
            super.dispose();

        }
    }
}
