package game.view.pack
{
    import game.manager.AssetMgr;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class PackTitle extends Sprite
    {
        public function PackTitle()
        {
            var ui_tongyong_shenminshangren_paiai15938Texture:Texture = AssetMgr.instance.getTexture('ui_tongyong_shenminshangren_paiai1');
            var ui_tongyong_shenminshangren_paiai15938Image:Image = new Image(ui_tongyong_shenminshangren_paiai15938Texture);
            ui_tongyong_shenminshangren_paiai15938Image.x = 593;
            ui_tongyong_shenminshangren_paiai15938Image.y = -8;
            ui_tongyong_shenminshangren_paiai15938Image.width = 36;
            ui_tongyong_shenminshangren_paiai15938Image.height = 122;
            ui_tongyong_shenminshangren_paiai15938Image.touchable = false;
            this.addChild(ui_tongyong_shenminshangren_paiai15938Image);
            var ui_tongyong_shenminshangren_paiai236719Texture:Texture = AssetMgr.instance.getTexture('ui_tongyong_shenminshangren_paiai2');
            var ui_tongyong_shenminshangren_paiai236719Image:Image = new Image(ui_tongyong_shenminshangren_paiai236719Texture);
            ui_tongyong_shenminshangren_paiai236719Image.x = 367;
            ui_tongyong_shenminshangren_paiai236719Image.y = 19;
            ui_tongyong_shenminshangren_paiai236719Image.width = 228;
            ui_tongyong_shenminshangren_paiai236719Image.height = 94;
            ui_tongyong_shenminshangren_paiai236719Image.touchable = false;
            this.addChild(ui_tongyong_shenminshangren_paiai236719Image);
            var ui_tongyong_shenminshangren_paiai13678Texture:Texture = AssetMgr.instance.getTexture('ui_tongyong_shenminshangren_paiai1');
            var ui_tongyong_shenminshangren_paiai13678Image:Image = new Image(ui_tongyong_shenminshangren_paiai13678Texture);
            ui_tongyong_shenminshangren_paiai13678Image.x = 367;
            ui_tongyong_shenminshangren_paiai13678Image.y = -8;
            ui_tongyong_shenminshangren_paiai13678Image.width = 36;
            ui_tongyong_shenminshangren_paiai13678Image.height = 122;
            ui_tongyong_shenminshangren_paiai13678Image.scaleX = -0.997650146484375;
            ui_tongyong_shenminshangren_paiai13678Image.touchable = false;
            this.addChild(ui_tongyong_shenminshangren_paiai13678Image);
            var ui_ziti_beibao40940Texture:Texture = AssetMgr.instance.getTexture('ui_ziti_beibao');
            var ui_ziti_beibao40940Image:Image = new Image(ui_ziti_beibao40940Texture);
            ui_ziti_beibao40940Image.x = 409;
            ui_ziti_beibao40940Image.y = 40;
            ui_ziti_beibao40940Image.width = 141;
            ui_ziti_beibao40940Image.height = 51;
            ui_ziti_beibao40940Image.touchable = false;
            this.addChild(ui_ziti_beibao40940Image);
        }
    }
}