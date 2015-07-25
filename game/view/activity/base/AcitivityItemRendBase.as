package game.view.activity.base {
    import com.utils.Constants;

    import game.manager.AssetMgr;

    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class AcitivityItemRendBase extends Sprite {
        public var ckButton:Button;
        public var Image1Button:Button;

        public function AcitivityItemRendBase() {
            var ui_butten_activities_Package300Texture:Texture = AssetMgr.instance.getTexture('ui_butten_activities_Package3');
            var ui_butten_activities_Package300Image:Image = new Image(ui_butten_activities_Package300Texture);
            ui_butten_activities_Package300Image.x = 0;
            ui_butten_activities_Package300Image.y = 0;
            ui_butten_activities_Package300Image.width = 171;
            ui_butten_activities_Package300Image.height = 107;
            ui_butten_activities_Package300Image.smoothing = Constants.smoothing;
            ui_butten_activities_Package300Image.touchable = false;
            this.addQuiackChild(ui_butten_activities_Package300Image);
            var ckTexture:Texture = AssetMgr.instance.getTexture('ui_butten_activities_Package4');
            ckButton = new Button(ckTexture);
            ckButton.x = 7;
            ckButton.y = 6;
            this.addQuiackChild(ckButton);
            var Image1Texture:Texture = AssetMgr.instance.getTexture('ui_butten_activities_Package1');
            Image1Button = new Button(Image1Texture);
            Image1Button.x = 2;
            Image1Button.y = 6;
            ckButton.addQuiackChild(Image1Button);

        }

        override public function dispose():void {
            ckButton.dispose();
            Image1Button.dispose();
            super.dispose();

        }

    }
}