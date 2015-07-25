package game.view.arena
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	
	import game.data.ArenaLevel;
	import game.data.ConfigData;
	import game.data.Robot;
	import game.dialog.ShowLoader;
	import game.manager.AssetMgr;
	import game.net.GameSocket;
	import game.net.data.c.CArena_chance;
	import game.net.data.c.CArena_refresh;
	import game.net.data.c.CArena_rivalInfo;
	import game.net.data.c.CCombat_box;
	import game.net.data.s.SArena_chance;
	import game.net.data.s.SArena_refresh;
	import game.net.data.s.SArena_rivalInfo;
	import game.net.data.s.SCombat_box;
	import game.net.data.vo.RefreshTarget;
	import game.net.data.vo.RivalInfo;
	import game.scene.arenaWorld.ArenaBattleLoader;
	import game.view.arena.base.DareBase;
	import game.view.loginReward.ResignDlg;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;

	/**
	 * 竞技场，挑战
	 * @author litao
	 * 
	 */	
	public class DareFace extends DareBase
	{
		
		private var _time:int = 0;
		public function DareFace()
		{
			super();
			
			
			
			cdTxt.width += 20;
			RefreshTxt.text = Langue.getLangue("RefreshTarget");
			dareNumberTxt.text = Langue.getLangue("dareNumber");
		
			ArenaDareData.instance.create("dare");
			orbBox1Button.name = "box1";
			orbBox2Button.name = "box2";
//			award1Image.touchable = false;
//			award2Image.touchable = false;
			var data:Object = ArenaDareData.instance.getData("dare") ;
			data.maxTime = ConfigData.instance.arenaCd;
			if(!data.isSend)
			{
				send();
			}
			else 
			{
				showRivalInfo(data);	
			}
			orbBox1Button.addEventListener(Event.TRIGGERED,openBox1);
			orbBox2Button.addEventListener(Event.TRIGGERED,openBox2);
		}
		private var type:int = 0;
		private function openBox1(e:Event):void
		{
			if(!receive1Txt.text)
			{
				RollTips.add(Langue.getLangue("notUse"));
			}
			else if((ArenaDareData.instance.getData("dare") as ArenaDareData).team1 == 1)
			{
				RollTips.add(Langue.getLangue("alreadyUse"));
			}
			else if((ArenaDareData.instance.getData("dare") as ArenaDareData).team1 == 2)
			{
				RollTips.add(Langue.getLangue("alreadyUse"));
			}
			else if((ArenaDareData.instance.getData("dare") as ArenaDareData).team1 == 0)
			{
				type = 1;
				var cmd:CCombat_box = new CCombat_box();
				cmd.type = 1;
				GameSocket.instance.sendData(cmd);
				ShowLoader.add();
			}
		}
		private function openBox2(e:Event):void
		{
			if(!receive2Txt.text)
			{
				RollTips.add(Langue.getLangue("notUse"));
			}
			else if((ArenaDareData.instance.getData("dare") as ArenaDareData).team2 == 1)
			{
				RollTips.add(Langue.getLangue("alreadyUse"));
			}
			else if((ArenaDareData.instance.getData("dare") as ArenaDareData).team2 == 2)
			{
				RollTips.add(Langue.getLangue("alreadyUse"));
			}
			else if((ArenaDareData.instance.getData("dare") as ArenaDareData).team2 == 0)
			{
				type = 2;
				var cmd:CCombat_box = new CCombat_box();
				cmd.type = 2;
				GameSocket.instance.sendData(cmd);
				ShowLoader.add();
			}
		}
		
		
		private function send():void
		{
			var cmd:CArena_rivalInfo = new CArena_rivalInfo;
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}
		
		
		
		override public function handleNotification(_arg1:INotification):void
		{
			if(_arg1.getName() == String(SArena_rivalInfo.CMD))
			{
				var info:SArena_rivalInfo = _arg1 as  SArena_rivalInfo;
				
				var data:Object = ArenaDareData.instance.getData("dare") ;
				data.time = info.cd;
				data.isSend = true;
				data.number = info.number;
				data.rivalList = info.targets;
				
				data.team1 = info.team1;
				data.team2 = info.team2;
				data.chance = info.chance;
				showRivalInfo(data);
			}
			
			else if(_arg1.getName() == String(SArena_chance.CMD))
			{
				var chance:SArena_chance = _arg1 as SArena_chance;
				if(chance.code == 0)
				{
					RollTips.add(Langue.getLangue("buySuccess"));
					(ArenaDareData.instance.getData("dare") as ArenaDareData).chance = chance.num;
				
					(ArenaDareData.instance.getData("dare") as ArenaDareData).number = ConfigData.instance.arenaBuy;
					dareTxt.text = (ArenaDareData.instance.getData("dare") as ArenaDareData).number+ "";
				}
				else if(chance.code == 1)
				{
					RollTips.add(Langue.getLangue("diamendNotEnough"));
				}
				else if(chance.code >= 127)
				{
					RollTips.add(Langue.getLangue("codeError")+chance.code);
				}
			}
			else if(_arg1.getName() == String(SArena_refresh.CMD))
			{
				var refresh:SArena_refresh = _arg1 as SArena_refresh;
				if(refresh.code == 0 )
				{
					RollTips.add(Langue.getLangue("refreshSuccess"));
					var d:Object = ArenaDareData.instance.getData("dare") ;
					
					d.time = refresh.time;
					d.isSend = true;
			
					d.team1 = refresh.team1;
					d.team2 = refresh.team2;
					d.rivalList = refresh.targets;
					showRivalInfo(d);
					
				}
				else if(refresh.code == 1)
				{
					RollTips.add(Langue.getLangue("diamendNotEnough"));
				}
				else if(refresh.code >=127)
				{
					RollTips.add(Langue.getLangue("codeError")+chance.code);
				}
			}
			else if(_arg1.getName() == String(SCombat_box.CMD))
			{
				var box:SCombat_box = _arg1 as SCombat_box;
				if(box.code == 0)
				{
					var arr:Array = Langue.getLans("arenaValue");
					var gold:String = arr[0]+":" + box.gold + ",";
					var honor:String = arr[2]+":" + box.honor + ",";
					var point:String  = arr[1] + ":" + box.point;
					RollTips.add(Langue.getLangue("obtain")+",:"  + gold + honor + point );
					var d1:ArenaDareData = ArenaDareData.instance.getData("dare")  as ArenaDareData;
					
					var p:int = box.point + d1.point;
					
					if(p < ArenaLevel.hash.getValue(d1.level).integral)
						d1.point += box.point;
					else 
					{
						d1.point = (d1.point+box.point) - ArenaLevel.hash.getValue(d1.level).integral;
						d1.level += 1;
					}
					
					d1.updatePross();
					
					if(type == 1)
					{
						if(receive1Txt.text != "")
						{
							receive1Txt.text = Langue.getLangue("alreadyUse");
							receive1Txt.color = 0xff0000;
							d1.team1 = 2;
//							if(d1.team2 == 2)d1.team1 = 0;
						}
					}
					else if(type == 2)
					{
						if(receive2Txt.text != "")
						{
							receive2Txt.text = Langue.getLangue("alreadyUse");
							receive2Txt.color = 0xff0000;
						}

						d1.team2 = 2;
//						if(d1.team1 == 2)d1.team2 = 0;
					}
				}
				else if(box.code == 1)
				{
					RollTips.add(Langue.getLangue("okUse"));
				}
				else if(box.code == 2)
				{
					RollTips.add(Langue.getLangue("notUse"));
				}
				else if(box.code >= 127)
				{
                    RollTips.add(Langue.getLangue("codeError")+box.code);
				}
			}
			ShowLoader.remove();
		}
	
		
		
		private function showRivalInfo(data:Object):void
		{
			dareTxt.text = data.number+ "";//挑战次数
			
			data.cdTime(cdTxt);
	
			var photo:Image;
			var one:int;
			var two:int;
			var team1:int;
			var team2:int;
            var len:int =    data.rivalList.length;
			for (var i:int = 0 ; i < len ; i ++)
			{
				var info:Object = data.rivalList[i] as RivalInfo;
				if(!info) info = data.rivalList[i] as RefreshTarget

				photo = new Image(AssetMgr.instance.getTexture("ui_pvp_renwutouxiang"+info.picture));
				
				this["targetPhoto" +(i+1)+"Button"].addChild(photo);
				photo.touchable = false;
				var arr:Array = (info.name as String).split(".");
				var name:String = arr[0] == "^" ? (Robot.hash.getValue(int(arr[1])) as Robot).name:info.name ;
				
				this["name" + (i+1)+"Txt"].text = name;
				this["name" + (i+1)+"Txt"].fontName = "方正综艺简体";
				this["targetPhoto" +(i+1)+"Button"].name = (i+1).toString();
				this["beat" + (i+1)+"Txt"].text = info.beat == 0 ? "" :Langue.getLangue("lose");
//                this["power" + (i+1)].text =   info.beat;

				if(i < 4)
				{
					if(info.beat != 0 )one ++  ;
				}
				else 
				{
					if(info.beat != 0 )two ++  ;
				}
			}
			//是否可以领取宝箱
			if(one == 4)team1 =2;
			if(two == 4)team2 =2;
			
			if(team1 == 2 && data.team1 == 0)
			{
				receive1Txt.text = Langue.getLangue("okUse");
				receive1Txt.color = 0x00ff00;
//				award1Image.visible = false;
			}
				
			else if(team1 == 2 && data.team1 == 1 || team1 == 2 && data.team1 == 2)
			{
				receive1Txt.text = Langue.getLangue("alreadyUse");
				receive1Txt.color = 0xff0000;
//				award1Image.visible = false;
			}
			else if(team1 != 2 )
			{
//				award1Image.visible = true;
				receive1Txt.text = "";
			}
			
			
			
			if(team2 == 2 && data.team2 == 0)
			{
				receive2Txt.text = Langue.getLangue("okUse");
				receive2Txt.color = 0x00ff00;
//				award2Image.visible = false;
			}
				
			else if(team2 == 2 && data.team2 == 1 || team2 == 2 && data.team2 == 2)
			{
				receive2Txt.text = Langue.getLangue("alreadyUse");
				receive2Txt.color = 0xff0000;
//				award2Image.visible = false;
			}
			else 	if(team2 != 2)
			{
//				award2Image.visible = true;
				receive2Txt.text = "";
			}

			
			
			
			if(!this.hasEventListener(Event.TRIGGERED))
				this.addEventListener(Event.TRIGGERED,onDareSelectRival);
		}
		
		public static var fightData:Array = [];
		private function onDareSelectRival(e:Event):void
		{
			var pos:int = int((e.target as Button).name);
			if(pos == 0 &&(e.target as Button).name != "box1" && (e.target as Button).name != "box2" )
			{
				if(ArenaDareData.instance.getData("dare").time > 0)
				{
					var cdTip:ResignDlg = DialogMgr.instance.open(ResignDlg) as ResignDlg;
					cdTip.text = Langue.getLangue("arenaBuy").replace("*",Math.ceil((ArenaDareData.instance.getData("dare").time/60)*ConfigData.instance.diamond_per_min));
					cdTip.btn_ok.addEventListener(Event.TRIGGERED,
						function cdokFun():void
						{
							var cmd:CArena_refresh = new CArena_refresh;
							GameSocket.instance.sendData(cmd);
							ShowLoader.add();
							
							cdTip.close(); 
						}
					);
				}
				else 
				{
					var cmd:CArena_refresh = new CArena_refresh;
					GameSocket.instance.sendData(cmd);
					ShowLoader.add();
				}
			}
			else if((e.target as Button).name != "box1" && (e.target as Button).name != "box2")
			{
				if( (ArenaDareData.instance.getData("dare") as ArenaDareData).number <= 0)
				{
					var dare:ArenaDareData = (ArenaDareData.instance.getData("dare") as ArenaDareData);
					var tip:ResignDlg = DialogMgr.instance.open(ResignDlg) as ResignDlg;
				
					tip.text = Langue.getLangue("arenaNumBuy").replace("*",dare.chance *15+dare.chance*dare.chance+5);
					
					tip.btn_ok.addEventListener(Event.TRIGGERED,
					function okFun():void
					{
						var cmd:CArena_chance = new CArena_chance;
						GameSocket.instance.sendData(cmd);
						ShowLoader.add();
						tip.close();
					});
			
				}
				else 
				{
					if((ArenaDareData.instance.getData("dare") as ArenaDareData).rivalList[pos - 1]["beat"] == 1)
					{
						RollTips.add(Langue.getLangue("arenaSuccess"));
						return;
					}
					var name:int = (ArenaDareData.instance.getData("dare") as ArenaDareData).rivalList[pos - 1]["name"].charAt(0) == "^" ? 0:1;
				
					(ArenaDareData.instance.getData("dare") as ArenaDareData).pos = pos;
					
					var data:ArenaDareData = (ArenaDareData.instance.getData("dare") as ArenaDareData);
					
					fightData = [data.rivalList[pos - 1]["id"],1,name];
					(new ArenaBattleLoader).load.apply(this, fightData);
				}
			}
			
		}
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String> = new Vector.<String>;
			vect.push(SArena_rivalInfo.CMD);
			vect.push(SArena_chance.CMD);
			vect.push(SArena_refresh.CMD);
			vect.push(SCombat_box.CMD);
			return vect;
		}
		
		override public function dispose():void
		{
			ArenaDareData.instance.getData("dare").dispose();
			super.dispose();
		}
	}
}