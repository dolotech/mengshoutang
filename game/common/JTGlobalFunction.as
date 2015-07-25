package game.common
{
	import com.utils.StringUtil;

	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;

	import game.data.Goods;
	import game.data.HeroData;
	import game.data.LuckyStarData;
	import game.net.data.IData;
	import game.view.luckyStar.StarData;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import com.utils.Constants;

	/**
	 * 全局函数
	 * @author CabbageWrom
	 *
	 */
	public class JTGlobalFunction
	{

		public static function converHeros(list : Object) : Vector.<HeroData>
		{
			var heros : Vector.<HeroData> = new Vector.<HeroData>();
			var i : int = 0;
			var l : int = list.length;

			for (i = 0; i < l; i++)
			{
				var hero : Object = list[i] as IData;
				var heroInfo : HeroData = HeroData.hero.getValue(hero.type) as HeroData;
				heroInfo = heroInfo.clone() as HeroData;
				heroInfo.copy(hero);
				heros.push(heroInfo);
			}
			return heros;
		}

		public static function filtratRobot(users : Vector.<IData>) : Vector.<IData>
		{
			var list : Vector.<IData> = new Vector.<IData>();
			var i : int = 0;
			var l : int = users.length;

			for (i = 0; i < l; i++)
			{
				var userInfo : Object = users[i] as IData;
				var robot : String = "^." + userInfo.rid + ".$"

				if (userInfo.name == robot)
				{
					continue;
				}
				list.push(userInfo);
			}
			return list;
		}


		/**
		 *
		 * @param str
		 * @return
		 *
		 */
		public static function parseStrToItem(str : String, isSystem : Boolean = false) : String
		{
			if (str.indexOf("[{equ,") != -1)
			{
				return replaceToItem("[{equ,", str, isSystem);
			}

			if (str.indexOf("[{hero,") != -1)
			{
				return replaceToItem("[{hero,", str, isSystem);
			}

			if (str.indexOf("[{prop,") != -1)
			{
				return replaceToItem("[{prop,", str, isSystem);
			}

			if (str.indexOf("[{luck,") != -1)
			{
				return replaceToItem("[{luck,", str, isSystem);
			}
			return str;
		}

		private static var cacheTF : TextField;

		public static function parseText(content : String, txt_width : int) : Array
		{
			if (cacheTF == null)
			{
				var textFormat : TextFormat = new TextFormat("Verdana", 24, 0xffffff,null,null,null,null,null,"left");
				textFormat.kerning = true;
				cacheTF = new TextField();
				cacheTF.defaultTextFormat = textFormat;
				cacheTF.antiAliasType = AntiAliasType.ADVANCED;
				cacheTF.multiline = false;
				cacheTF.selectable = false;
			}
			content = parseStrToItem(content);
			cacheTF.text = content;
			cacheTF.width = cacheTF.textWidth + 4;
			var len : int = content.length;
			var addLen : Number = 0;
			var index : int = 0;
			var tmp_list : Array = [];

			if (cacheTF.textWidth <= txt_width)
			{
				return [content];
			}

			for (var i : int = 0; i < len; i++)
			{
				cacheTF.text = content.substring(index, i);

				if (cacheTF.textWidth >= txt_width)
				{
					tmp_list.push(content.substring(index, i));
					index = i;
				}

				if (i == len - 1)
					tmp_list.push(content.substr(index, len));
			}
			return tmp_list;
		}

		/**
		 *
		 * @param str
		 * @return
		 *
		 */
		public static function toStringBytes(str : String) : ByteArray
		{
			var content : String = parseStrToItem(str);
			var buffers : ByteArray = new ByteArray();

			if (content)
			{
				buffers.writeUTF(content);
			}
			buffers.position = 0;
			return buffers;
		}

		/**
		 *
		 * @param bytes
		 * @param ROW_MAX_NUM
		 * @return
		 *
		 */
		public static function bytesToString(bytes : ByteArray, ROW_MAX_NUM : int) : Vector.<String>
		{
			var lines : Vector.<String> = new Vector.<String>();
			bytes.position = 0;
			var msg : String = bytes.readUTF();
			var i : int = 0;
			var l : int = msg.length;
			var length : int = 0;
			var line : String = "";

			for (i = 0; i < l; i++)
			{
				var str : String = msg.charAt(i)

				if (length < ROW_MAX_NUM)
				{
					if (StringUtil.isDoubleChar(str))
					{
						length += 2;
					}
					else
					{
						length += 1;
					}
					line += str;
				}

				if (length >= ROW_MAX_NUM || i == l - 1)
				{
					lines.push(line);
					line = "";
					length = 0;
				}
			}
			return lines;
		}

		/**
		 *
		 * @param keyword
		 * @param content
		 * @return
		 *
		 */
		public static function replaceToItem(keyword : String, content : String, isSystem : Boolean = false) : String
		{
			var lines : Array = content.split(keyword);
			var endLine : String = lines[1];
			var l : Array = endLine.split("}]");
			var id : String = l[0];
			var itemInfo : Object = null;

			switch (keyword)
			{
				case "[{equ,":
				{
					itemInfo = Goods.goods.getValue(int(id)) as Object;
					break;
				}
				case "[{hero,":
				{
					itemInfo = HeroData.hero.getValue(int(id)) as Object;
					break;
				}
				case "[{prop,":
				{
					itemInfo = Goods.goods.getValue(int(id)) as Object;
					break;
				}
				case "[{luck,":
				{
					var ids : Array = id.split(",");
					var real_type : int = ids[0];
					var real_position : int = ids[1];
					itemInfo = LuckyStarData.getLuckItemInfo(StarData.instance.id, real_type, real_position);
					break;
				}

                default :
                    break;
			}
			var str : String = null;

			if (isSystem)
			{
				if (itemInfo.hasOwnProperty("quality")) //:|表示装备的名字    _|表示品质    以后扩充写到一起.
				{
					str = lines[0] + ":|" + itemInfo.name + "_|" + itemInfo.quality + ":|" + l[1];
				}
				else
				{
					str = lines[0] + ":|" + itemInfo.name + ":|" + l[1];
				}
			}
			else
			{
				str = lines[0] + itemInfo.name + l[1];
			}
			return str;
		}

		/**
		 *
		 * @param color
		 * @param content
		 * @return
		 *
		 */
		public static function toHTMLStyle(color : String, content : String, size : int = 24) : String
		{
			return "<FONT COLOR='" + color + "'  SIZE='" + size + "'><B>" + content + "</B></FONT>";
		}



		public static function assemblySysMsgColor(content : String, name : String) : String
		{
			if (name == "")
			{
				JTLogger.error("[JTGlobalFunction.assemblyStringColor] Can't Find The User Name!");
			}
			var lines : Array = content.split(name);
			var endLine : String = lines[1] as String;
			var fullMsg : String = toHTMLStyle('#EC2B2B', lines[0]);
			fullMsg += toHTMLStyle('#33FCFC', name);
			return fullMsg + giveAddColor(endLine);
		}

		public static function giveAddColor(endLine : String) : String
		{
			if (!endLine || endLine.indexOf(":|") == -1)
				return endLine;
			var chats : Array = endLine.split(":|");
			var fullMsg : String = "";

			if (chats[1].indexOf("_|") != -1)
			{
				var itemNames : Array = chats[1].split("_|");
				var quality : int = itemNames[1];
				var itemName : String = itemNames[0];
				var color : String = getQualityColor(quality);
				fullMsg += toHTMLStyle('#EC2B2B', chats[0]);
				fullMsg += toHTMLStyle(color, itemName);
				fullMsg += toHTMLStyle('#EC2B2B', chats[2]);
			}
			else
			{
				fullMsg += toHTMLStyle('#EC2B2B', endLine);
			}
			return fullMsg;
		}

		public static function getQualityColor(quality : int) : String
		{
			var color : String = null;

			switch (quality)
			{
				case JTGlobalDef.QUALITY_ONE:
				{
					color = JTGlobalDef.COLOR_ONE;
					break;
				}
				case JTGlobalDef.QUALITY_TWO:
				{
					color = JTGlobalDef.COLOR_TWO;
					break;
				}
				case JTGlobalDef.QUALITY_THREE:
				{
					color = JTGlobalDef.COLOR_THREE;
					break;
				}
				case JTGlobalDef.QUALITY_FOUR:
				{
					color = JTGlobalDef.COLOR_FOUR;
					break;
				}
				case JTGlobalDef.QUALITY_FIVE:
				{
					color = JTGlobalDef.COLOR_FIVE;
					break;
				}
				case JTGlobalDef.QUALITY_SIX:
				{
					color = JTGlobalDef.COLOR_SIX;
					break;
				}
				case JTGlobalDef.QUALITY_SEVEN:
				{
					color = JTGlobalDef.COLOR_SEVEN;
					break;
				}
				default:
				{
					color = '#EC2B2B';
                    break;
				}
			}
			return color;
		}

		public static function autoAdaptiveSize(child : DisplayObject) : void
		{
			var applicationWidth : Number = Starling.current.nativeStage.stageWidth;
			var applicationHeight : Number = Starling.current.nativeStage.stageHeight;
			var reallyScale : Number = applicationWidth / applicationHeight;
			var nowScale : Number = Constants.standardWidth / Constants.standardHeight;

			if (reallyScale < nowScale)
			{
				child.scaleX = child.scaleY = applicationWidth / Constants.standardWidth;
			}
			else
			{
				child.scaleX = child.scaleY = Constants.scale;
			}
		}
	}
}