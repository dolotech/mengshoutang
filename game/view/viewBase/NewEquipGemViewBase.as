package game.view.viewBase {
    import feathers.controls.TextInput;

    import game.manager.AssetMgr;
    import game.view.blacksmith.render.NewEquipGemRender;
    import game.view.blacksmith.render.NewEquipRender;
    import game.view.blacksmith.view.EquipViewBase;

    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class NewEquipGemViewBase extends EquipViewBase {
        public var ico_weapon:NewEquipRender;
        public var gem0:NewEquipGemRender;
        public var gem1:NewEquipGemRender;
        public var gem2:NewEquipGemRender;
        public var gem3:NewEquipGemRender;
        public var gem4:NewEquipGemRender;

        public function NewEquipGemViewBase() {
            super(false);
            var texture:Texture;
            var textField:TextField;
            var input_txt:TextInput;
            var image:Image;
            var button:Button;
            var assetMgr:AssetMgr = AssetMgr.instance;
            ico_weapon = new NewEquipRender();
            ico_weapon.x = 9;
            ico_weapon.y = 80;
            this.addQuiackChild(ico_weapon);
            gem0 = new NewEquipGemRender();
            gem0.x = 115;
            this.addQuiackChild(gem0);
            gem1 = new NewEquipGemRender();
            gem1.x = 115;
            gem1.y = 56;
            this.addQuiackChild(gem1);
            gem2 = new NewEquipGemRender();
            gem2.x = 115;
            gem2.y = 108;
            this.addQuiackChild(gem2);
            gem3 = new NewEquipGemRender();
            gem3.x = 115;
            gem3.y = 164;
            this.addQuiackChild(gem3);
            gem4 = new NewEquipGemRender();
            gem4.x = 115;
            gem4.y = 220;
            this.addQuiackChild(gem4);
            init();
        }

        override public function dispose():void {
            ico_weapon.dispose();
            gem0.dispose();
            gem1.dispose();
            gem2.dispose();
            gem3.dispose();
            gem4.dispose();
            super.dispose();

        }
    }
}
