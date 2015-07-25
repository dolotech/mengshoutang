package game.view.viewBase {
    import com.view.View;

    import feathers.controls.List;

    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class VipInfoViewBase extends View {
        public var list_vip:List;
        public var btn_right:Button;
        public var btn_left:Button;

        public function VipInfoViewBase() {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            list_vip = new List();
            list_vip.x = 64;
            list_vip.width = 658;
            list_vip.height = 246;
            this.addQuiackChild(list_vip);
            texture = assetMgr.getTexture('ui_button_next');
            btn_right = new Button(texture);
            btn_right.name = 'btn_right';
            btn_right.x = 680;
            btn_right.y = 102;
            btn_right.width = 74;
            btn_right.height = 70;
            this.addQuiackChild(btn_right);
            texture = assetMgr.getTexture('ui_button_next');
            btn_left = new Button(texture);
            btn_left.name = 'btn_left';
            btn_left.x = 74;
            btn_left.y = 102;
            btn_left.width = 74;
            btn_left.height = 70;
            this.addQuiackChild(btn_left);
            init();
        }

        override public function dispose():void {
            list_vip.dispose();
            btn_right.dispose();
            btn_left.dispose();
            super.dispose();

        }
    }
}
