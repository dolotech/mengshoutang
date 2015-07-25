package game.view.chat.base
{
    import com.utils.Constants;

    import game.base.JTSprite;
    import game.manager.AssetMgr;

    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class JTUIMessageNotice extends JTSprite
    {
        public var txt_noticeTxt:TextField;

        public function JTUIMessageNotice()
        {
            var ui_chat_bottom11791Texture:Texture=AssetMgr.instance.getTexture('ui_chat_bottom');
            var ui_chat_bottom11791Image:Image=new Image(ui_chat_bottom11791Texture);
            ui_chat_bottom11791Image.width=723;
            ui_chat_bottom11791Image.height=38;
            ui_chat_bottom11791Image.x=(Constants.virtualWidth - 723) >> 1;
            ui_chat_bottom11791Image.y=91;
            ui_chat_bottom11791Image.touchable=false;
            this.addQuiackChild(ui_chat_bottom11791Image);
            txt_noticeTxt=new TextField(1200, 37, '');
            txt_noticeTxt.touchable=false;
            txt_noticeTxt.hAlign='left';
            txt_noticeTxt.x=0;
            txt_noticeTxt.y=92;
            this.addQuiackChild(txt_noticeTxt);

        }

    }
}
