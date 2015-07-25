package game.scene
{
	import com.scene.BaseScene;
	import com.utils.Assets;
	
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	
	import starling.core.Starling;
	import starling.text.TextField;
	
	import treefortress.spriter.SpriterClip;
	import com.utils.Constants;
	
	/**
	 * 场景加载
	 * @author Administrator
	 * 
	 */	
	public class LoadingScene extends BaseScene
	{
		private  var logo:SpriterClip;
		private  var progressbar:SpriterClip;
		private var titleTxt:TextField;

		public function LoadingScene()
		{
			super();
			logo = AnimationCreator.instance.create("loader",AssetMgr.instance);
			logo.play("loader");
			logo.animation.looping = true;
			logo.scaleX = -1;
			Starling.juggler.add(logo);
			Constants.setToStageCenter(logo,0,50,false);
			addQuiackChild(logo);
			progressbar = AnimationCreator.instance.create("progressbar_home",AssetMgr.instance);
			progressbar.play("progressbar_home");
			progressbar.animation.looping = false;
			Starling.juggler.add(progressbar);
			Constants.setToStageCenter(progressbar,-this.progressbar.width / 2, 60,false);
			addQuiackChild(progressbar);

			if(!_xml)
			{
				_xml = XML(new Assets.TipsXML());
			}
			titleTxt = new TextField(600,40,'','',20,0xffffff,false);
			titleTxt.touchable = false;
			titleTxt.hAlign = 'center';
			Constants.setToStageCenter(titleTxt,0,120);
			titleTxt.fontName = "";
			this.addQuiackChild(titleTxt);
			titleTxt.text = _xml.children()[Math.random() * _xml.children().length() >>0].toString();
			
			Constants.setToStageCenter(titleTxt, 0, 125);
			Constants.setToStageCenter(progressbar, 0, 80);
		}
		
		private  static var _xml:XML;
		
		override public function dispose():void
		{
			logo.stop();
			Starling.juggler.remove(logo);
			logo.removeFromParent(true);
			
			progressbar.stop();
			Starling.juggler.remove(progressbar);
			progressbar.removeFromParent(true);
			super.dispose();
		}
	}
}