package  game.view.goodsGuide
{
    import game.manager.AssetMgr;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class ObainHeroEffectBase extends Sprite
    {
        public var backgroud:Image;
        public var front:Image;
        public var nameTxt:TextField;
        public var profession:Image;

        public function ObainHeroEffectBase()
        {
            var texture:Texture;
            var textField:TextField;
            var image:Image;
            var button:Button;;
            var assetMgr:AssetMgr = AssetMgr.instance;
            texture = assetMgr.getTexture('ui_denglu_jiaosekapai1')
            backgroud = new Image(texture);
            backgroud.width = 240;
            backgroud.height = 379;
            this.addQuiackChild(backgroud);
            backgroud.touchable = false;
            texture = assetMgr.getTexture('ui_denglu_jiaosekapai')
            front = new Image(texture);
            front.width = 240;
            front.height = 379;
            this.addQuiackChild(front);
            front.touchable = false;
            nameTxt = new TextField(126,28,'','',18,0xFFFFCC,false);
            nameTxt.touchable = false;
            nameTxt.hAlign= 'center';
            nameTxt.text= '';
            nameTxt.x = 58;
            nameTxt.y = 273;
            this.addQuiackChild(nameTxt);
            texture = assetMgr.getTexture('ui_gongyong_zheyetubiao3')
            profession = new Image(texture);
            profession.x = 96;
            profession.y = 320;
            profession.width = 50;
            profession.height = 50;
            this.addQuiackChild(profession);
            profession.touchable = false;
        }
    }
}
