package game.manager
{
	import com.mobileLib.utils.ConverURL;
	import com.singleton.Singleton;

	import avmplus.getQualifiedClassName;

	import starling.utils.AssetManager;

	public class AssetMgr extends AssetManager
	{
		protected var _dict : Object = {}; // 去除重复加载

		public static function get instance() : AssetMgr
		{
			return Singleton.getInstance(AssetMgr) as AssetMgr;
		}


		public function AssetMgr() : void
		{
			_dict = {};
		}

		override public function enqueueWithName(asset : Object, name : String = null) : String
		{
			if (ConverURL.update_dic[asset.name] != null)
			{
				asset = ConverURL.update_dic[asset.name];
			}

			if (getQualifiedClassName(asset) == "flash.filesystem::File")
				asset = asset["url"];

			if (name == null)
				name = getName(asset);
			log("Enqueuing '" + name + "'");

			// 去除重复加载
			if (_dict[asset])
			{
				return null;
			}
			else
			{
				_dict[asset] = true;
			}

			mQueue.push({name: name, asset: asset});

			return name;
		}

		public function removeUi(name : String, home : String) : void
		{
			home += "/";
			delete _dict[ConverURL.conver(home + name + ".atf").url];
			delete _dict[ConverURL.conver(home + name + ".png").url];
			delete _dict[ConverURL.conver(home + name + ".xml").url];
			delete _dict[ConverURL.conver(home + name + ".axs").url];
			removeXml(name);
			removeByteArray(name);
			removeTexture(name);
			removeTextureAtlas(name);
		}
	}
}