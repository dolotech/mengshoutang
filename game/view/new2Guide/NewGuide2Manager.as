package game.view.new2Guide
{
	import com.dialog.DialogMgr;
	import com.scene.SceneMgr;
	import com.utils.Constants;

	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import game.common.JTSession;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.net.GameSocket;
	import game.net.data.c.CSetGrowth;
	import game.scene.BattleScene;
	import game.uils.Config;
	import game.view.embattle.EmBattleDlg;
	import game.view.new2Guide.data.NewDialogData;
	import game.view.new2Guide.data.NewGuideData;
	import game.view.new2Guide.data.NewGuideExcuteData;
	import game.view.new2Guide.interfaces.INewGuideView;
	import game.view.new2Guide.view.NewGuideGirl;
	import game.view.new2Guide.view.NewGuideMask;
	import game.view.new2Guide.view.NewGuideStory;

	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	import treefortress.spriter.SpriterClip;

	/**
	 * 新手引导管理器
	 * @author hyy
	 *
	 */
	public class NewGuide2Manager
	{
		public static var instance : NewGuide2Manager;
		public static var list_guide : Array = [];
		public static var list_excute : Dictionary;
		public static var isLoading : Boolean;
		/**
		 * 新手引导开始节奏
		 */
		private static var start_index : int;
		/**
		 * 是否正在对话
		 */
		public static var isDialog : Boolean;
		/**
		 * 服务器的索引
		 */
		private static var step_server : int;
		/**
		 * 客户端索引
		 */
		public static var step_client : int;
		/**
		 * 是否通过新手引导
		 */
		private static var isPassNewGuide : Boolean;
		private static var isPlayAnimation : Boolean;
		/**
		 * 新手数据
		 */
		private static var newGuideData : NewGuideData;

		private static function getInstance() : NewGuide2Manager
		{
			if (instance == null)
			{
				instance = new NewGuide2Manager();
				instance.init();
			}
			return instance;
		}

		/**
		 * 每一大步骤中得一步
		 */
		private var cur_step : int;

		private var cur_stepArr : Array;
		/**
		 * 遮罩
		 */
		private var mask : NewGuideMask;
		/**
		 * 反射
		 */
		private var dic_className : Dictionary;
		/**
		 * 当前容器
		 */
		private var container : DisplayObjectContainer;

		/**
		 * 当前新手场景
		 */
		private var curr_scene : INewGuideView;
		/**
		 * 当前新手dialog
		 */
		private var curr_view : INewGuideView;

		/**
		 * 对话列表
		 */
		private var curr_Dialoglist : Array = [];
		private var curr_dialog : NewGuideStory;
		private var curr_girlDialog : NewGuideGirl;

		/**
		 * 动画
		 */
		private var animation : SpriterClip;

		/**
		 * 手指动画
		 */
		private var btn_finger : SpriterClip;

		/**
		 * 跳过按钮
		 */
		private var btn_jump : Button;

		private function init() : void
		{
			dic_className = new Dictionary();
			dic_className["CityFace"] = "game.view.city";
			dic_className["NewMainWorld"] = "game.scene.world";
			dic_className["BattleScene"] = "game.scene";
			dic_className["EmBattleDlg"] = "game.view.embattle";
			dic_className["WinView"] = "game.view.gameover";
			dic_className["LoginRewardDlg"] = "game.view.loginReward.Dla";
			dic_className["AchievementDlg"] = "game.view.achievement.Dlg";
			dic_className["HeroDlg"] = "game.view.newhero";
			dic_className["BlacksmithDlg"] = "game.view.newhero";
			dic_className["JTGiftTollgateComponent"] = "game.scene.world";
			dic_className["PackDlg"] = "game.view.pack";

			container = JTSession.layerGuideGlobal;
			container.scaleX = container.scaleY = Constants.scale;
			container.touchable = true;

			mask = new NewGuideMask();

			btn_finger = AnimationCreator.instance.create("effect_bigfinger", AssetMgr.instance);
			btn_finger.play("zhiyin1");
			btn_finger.animation.looping = true;
			btn_finger.touchable = false;
			btn_finger.stop();

			var tag_passTexture : Texture = AssetMgr.instance.getTexture('ui_icon_newkip');
			btn_jump = new Button(tag_passTexture);
			btn_jump.x = 25;
			btn_jump.y = 35;

			btn_jump.addEventListener(Event.TRIGGERED, onJumpGuideClick);

			curr_dialog = new NewGuideStory();
			curr_girlDialog = new NewGuideGirl();
		}

		public static function gotoNext() : void
		{
			if (instance)
			{
				instance.endDialog();
				instance.next();
			}
		}

		public static function sendNextSeverStep() : void
		{
			if (newGuideData)
				sendToSeverStep(newGuideData.server_step);
		}

		private static function sendToSeverStep(step : int) : void
		{
			var cmd : CSetGrowth = new CSetGrowth();
			step_server = cmd.growth = step + 1;
			GameSocket.instance.sendData(cmd);
		}

		/**
		 * 开始新手引导
		 *
		 */
		public static function start() : void
		{
			if (GameMgr.instance.tollgateID > 5 || Config.isNewPass)
			{
				sendToSeverStep(2);
				instance && instance.dispose();
				return;
			}

			step_server = start_index;
			isPassNewGuide = true;
			isDialog = isLoading = isPlayAnimation = false;
			step_client = 0;
			var newGuideData : NewGuideData;

			for (var i : int = 0, len : int = list_guide.length; i < len; i++)
			{
				newGuideData = list_guide[i];

				if (newGuideData.client_step == start_index)
				{
					step_client = i;
					isPassNewGuide = false;
					break;
				}
			}

			if (!isPassNewGuide)
			{
				getInstance().next();
			}
			else
			{
				NewDialogData.removeAllRes(AssetMgr.instance);
			}
		}

		/**
		 * 同服务器同步新手步骤
		 * 根据服务器传来的step，找到客户端起始的step
		 * @param value
		 *
		 */
		public static function updateServerStep(value : int) : void
		{
			start_index = value;
		}

		private function clear() : void
		{
			mask.setMaskRect(0, 0, 0, 0);
			mask.removeFromParent();

			btn_jump.removeFromParent();

			if (animation)
			{
				animation.stop();
				animation.removeFromParent(true);
				animation = null;
			}

			if (btn_finger)
			{
				btn_finger.stop();
				Starling.juggler.remove(btn_finger);
				btn_finger.removeFromParent();
			}
		}

		public function next() : void
		{
			clear();

			//在加载或者战斗中不能实行下一步
			if (isLoading || isPassNewGuide || isDialog || isPlayAnimation)
				return;

			//先实行每一步里面的分步骤
			if (cur_stepArr && cur_stepArr.length > 0)
			{
				doStep(cur_stepArr.shift());
				return;
			}

			//大步骤
			newGuideData = list_guide[step_client++];
			touchable = true;

			if (newGuideData == null)
			{
				isPassNewGuide = true;
				dispose();
				trace("完成新手引导", step_client, step_server);
				return;
			}

			var dialogClass : Class;
			var sceneClass : Class = getClass(newGuideData.scene.split(",")[0]);

			if (newGuideData.view)
				dialogClass = getClass(newGuideData.view.split(",")[0]);

			if (sceneClass != null)
				curr_scene = SceneMgr.instance.changeScene(sceneClass);

			if (dialogClass != null)
			{
				var tmp_param : Object = null;

				if (newGuideData.viewData)
					tmp_param = newGuideData.viewData.split(",");

				if (newGuideData.viewData.indexOf("关卡") >= 0)
					tmp_param = newGuideData.viewData.split(",")[1];
				curr_view = DialogMgr.instance.open(dialogClass, tmp_param) as INewGuideView;
			}
			else
			{
				DialogMgr.instance.closeAllDialog();
			}

			cur_stepArr = [].concat(newGuideData.viewParam);

			next();
		}

		private function doStep(tmpStepData : String) : void
		{
			var param : NewGuideExcuteData = list_excute[tmpStepData];
			var view : INewGuideView = newGuideData.view != "" ? curr_view : curr_scene;

			touchable = true;

			//按钮指引
			if (param.guide != "")
				guideView(param);

			//对话
			if (param.dialog)
			{
				//告诉给服务器
				if (param.sendStep == 1)
					sendToSeverStep(newGuideData.server_step);
				createDialog(param.dialog.split("*"));
			}

			//函数实行
			if (param.excute != "")
			{
				if (view != null)
					view.executeGuideFun(param.excute);

				//加载关卡不需要下一步，因为加载关卡完会自动实行,防止多步操作
				if (param.excute.indexOf("加载关卡") == -1)
					next();
			}

			//动画
			if (param.animation)
			{
				var tmpArr : Array = param.animation.split("|");
				var tmpAni : Array = tmpArr[0].split(",");

				animation = AnimationCreator.instance.create(tmpAni[0], AssetMgr.instance);

				if (tmpArr.length > 1)
				{
					var tmpPos : Array = tmpArr[1].split(",");
					animation.x = tmpPos[0];
					animation.y = tmpPos[1];
				}

				//特殊处理
				if (tmpAni[0] == "effect_bigfinger")
				{
					var dialog : EmBattleDlg = DialogMgr.instance.getDlg(EmBattleDlg) as EmBattleDlg;
					animation.x = animation.x + dialog.x / Constants.scale;
					animation.y = animation.y + dialog.y / Constants.scale;
				}

				animation.visible = true;
				animation.play(tmpAni[1]);
				animation.animation.looping = true;

				if (tmpAni[2] == "true")
				{
					isPlayAnimation = true;
					animation.animationComplete.addOnce(animationComplete);
				}

				function animationComplete(sprite : SpriterClip) : void
				{
					isPlayAnimation = false;
					next();
				}
				container.addQuiackChildAt(mask, 0);
				container.addQuiackChild(animation);
			}


			/**
			 * 指引按钮
			 * @param view
			 * @param name
			 *
			 */
			function guideView(param : NewGuideExcuteData) : void
			{
				var guide_btn_name : String = param.guide.replace("nextFun", "");
				var child : DisplayObject = view.getGuideDisplay(guide_btn_name);
				var tmp_step : int = step_client;

				if (child == null)
				{
					trace("新手引导按钮找不到", guide_btn_name, view);
					next();
					return;
				}

				var tmp_width : int = 0, tmp_height : int = 0;
				var point : Point = child.localToGlobal(new Point());

				tmp_width = child.width;
				tmp_height = child.height;

				if (child is Button)
				{
					child.addEventListener(Event.TRIGGERED, onBtnHandler);

					function onBtnHandler() : void
					{
						child.removeEventListener(Event.TRIGGERED, onBtnHandler);

						if (instance == null)
							return;

						if (tmp_step != step_client)
							return;

						touchable = false;

						//告诉给服务器
						if (param.sendStep == 1)
							sendToSeverStep(newGuideData.server_step);

						endDialog();

						//打开背包的时候延迟处理
						if (step_client == 27)
							Starling.juggler.delayCall(next, 0.2);
						else
							next();
					}
				}

				if (child is Quad)
					child.removeFromParent(true);

				point.x = point.x / Constants.scale;
				point.y = point.y / Constants.scale;
				mask.setMaskRect(point.x, point.y, tmp_width, tmp_height);
				container.addChildAt(mask, 0);
				container.addChild(btn_jump);

				if (param.animation == "")
				{
					btn_finger.x = point.x + tmp_width * .5;
					btn_finger.y = point.y + tmp_height * .5;
					container.addQuiackChild(btn_finger);
					Starling.juggler.add(btn_finger);
					btn_finger.play("zhiyin1");
					btn_finger.animation.looping = true;
				}
			}
		}

		private function set touchable(value : Boolean) : void
		{
			if (curr_view != null)
				curr_view.touchable = value;

			if (curr_scene != null && !(curr_scene is BattleScene))
				curr_scene.touchable = value;
		}

		/**
		 * 开始创建对话
		 * @param ids
		 *
		 */
		private function createDialog(ids : Array) : void
		{
			isDialog = true;

			curr_Dialoglist.length = 0;
			var key : String;

			for (var i : int = 0, len : int = ids.length; i < len; i++)
			{
				key = ids[i];

				if (key == "jump")
					curr_Dialoglist.push("jump");
				else
					curr_Dialoglist.push(NewDialogData.list_dialog[key]);
			}
			nextDialog();
		}

		public function nextDialog() : void
		{
			if (curr_Dialoglist.length == 0)
			{
				isDialog = false;
				return;
			}
			var data : * = curr_Dialoglist.shift();

			if (data == "jump")
			{
				endDialog();
				next();
				return;
			}
			var curr_newDialog : NewDialogData = data;

			//场景对话
			if (curr_newDialog.type == 1)
			{
				if (curr_dialog)
				{
					curr_dialog.data(curr_newDialog);
					curr_dialog.addChildAt(mask, 0);
					container.addChildAt(curr_dialog, 0);
					container.addChild(btn_jump);
				}
			}
			//美女介绍
			else
			{
				if (curr_girlDialog)
				{
					curr_girlDialog.data(curr_newDialog);
					curr_girlDialog.addChildAt(mask, 0);
					container.addChildAt(curr_girlDialog, 0);
					container.addChild(btn_jump);
				}
			}
		}

		public function endDialog() : void
		{
			if (curr_dialog)
				curr_dialog.removeFromParent();

			if (curr_girlDialog)
				curr_girlDialog.removeFromParent();
			isDialog = false;
		}

		private function getClass(name : String) : Class
		{
			if (name == "")
				return null;
			return getDefinitionByName(dic_className[name] + "::" + name) as Class;
		}

		private function removeFinger() : void
		{
			if (btn_finger)
			{
				btn_finger.stop();
				Starling.juggler.remove(btn_finger);
				btn_finger.removeFromParent();
			}
		}

		private function onJumpGuideClick() : void
		{
			var tmp_tollgateId : int = GameMgr.instance.tollgateID;
			GameMgr.instance.tollgateID = 6;
			NewGuide2Manager.start();
			GameMgr.instance.tollgateID = tmp_tollgateId;
			Sprite(SceneMgr.instance.getCurScene()).touchable = true;
		}

		public function dispose() : void
		{
			NewDialogData.removeAllRes(AssetMgr.instance);
			mask && mask.removeFromParent(true);
			curr_girlDialog && curr_girlDialog.removeFromParent(true);
			curr_dialog && curr_dialog.removeFromParent(true);
			btn_finger && btn_finger.removeFromParent(true);
			animation && animation.removeFromParent(true);
			btn_jump.removeFromParent(true);
			mask = null;
			animation = null;
			btn_finger = null;
			curr_girlDialog = null;
			newGuideData = null;
			curr_scene = null;
			curr_view = null;
			curr_dialog = null;
			container = null;
			instance = null;
		}

	}
}