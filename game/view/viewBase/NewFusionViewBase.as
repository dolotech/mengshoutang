package game.view.viewBase {
    import com.utils.Constants;

    import feathers.controls.List;
    import feathers.controls.TextInput;

    import game.manager.AssetMgr;
    import game.view.blacksmith.render.NewEquipRender;
    import game.view.blacksmith.view.EquipViewBase;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class NewFusionViewBase extends EquipViewBase {
        public var fusion_equipGrid:NewEquipRender;
        public var list_equip:List;

        public function NewFusionViewBase() {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            fusion_equipGrid = new NewEquipRender();
            fusion_equipGrid.x = 155;
            fusion_equipGrid.y = 186;
            this.addQuiackChild(fusion_equipGrid);
            texture = assetMgr.getTexture('ui_background_intensify_indicate1');
            image = new Image(texture);
            image.x = 175;
            image.y = 112;
            image.width = 53;
            image.height = 61;
            image.touchable = false;
            image.smoothing = Constants.smoothing;
            this.addQuiackChild(image);
            list_equip = new List();
            list_equip.width = 425;
            list_equip.height = 127;
            this.addQuiackChild(list_equip);
            init();
        }

        override public function dispose():void {
            fusion_equipGrid.dispose();
            list_equip.dispose();
            super.dispose();

        }
    }
}
