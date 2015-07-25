package game.view.uitils
{
	import com.data.HashMap;
	import com.singleton.Singleton;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.display.DisplayObject;
	/**
	 * 显示对象缓存
	 * @author litao
	 * 
	 */
	public class DisplayMemoryMrg
	{	
		private var mems:HashMap = new HashMap();
		public static function get instance():DisplayMemoryMrg
		{
			return Singleton.getInstance(DisplayMemoryMrg) as DisplayMemoryMrg;
		}
		
		public function getMemory(key:Object , display:Class,parameter:Object = null):DisplayObject
		{
			if(mems.getValue(key) == null)
			{
				if(parameter)
					mems.put(key,new display(parameter));
				else mems.put(key,new display());
			}
			return mems.getValue(key);
			
		}
		
		public function hasMemory(key:Object):Boolean
		{
			return mems.getValue(key) != null;
		}
		
		public function get hash():HashMap
		{
			return mems;
		}
		
		public function displayRemoveToParent(key:Object,dispose:Boolean = true):void
		{
			if(mems.getValue(key)) 
			if(mems.getValue(key).parent) 
			{
				(mems.getValue(key) as DisplayObject).removeFromParent(dispose);
			}
		}
		public function removeToMemory(key:Object):void
		{
			var display:DisplayObject = mems.getValue(key);
			if(display) display.dispose();
			mems.remove(key);
		}
		
		public function removeToFirstName(name:String , remove:Boolean = true):Vector.<Object>
		{
			var key:Vector.<*> = mems.keys();
			var nameKey:Vector.<Object> = new Vector.<Object>;
			for (var i:int = 0 ; i < key.length ; i++)
			{
				if(key[i].indexOf(name) != -1)
				{
					if(remove)
						DisplayMemoryMrg.instance.removeToMemory(key[i]);
					nameKey.push(key[i]);
				}
			}
			return nameKey;
		}
		
		public function getMemoryToFirstName(firstName:String,parameter:Object = null):DisplayObject
		{
			var vect:Vector.<Object> = removeToFirstName(firstName,false);
			var length:int = vect.length;
			
			for (var i:int = 0 ; i < length ; i ++)
			{
				if(mems.getValue(vect[i]) && ! (mems.getValue(vect[i]).parent) )
				{
					return mems.getValue(vect[i]);
				}
			}
			var display:DisplayObject = mems.getValue(vect[length - 1]);
			if(!display)return null;
			var c:Class = (getDefinitionByName(getQualifiedClassName(display))) as Class;
			return  getMemory(firstName + "" + (vect.length + 1),c,parameter);
		}
		
		
		public function createDisplay(firstName:String , className:Class , displayNum:int=10 , parameter:Object = null  ):void
		{
			for (displayNum ; displayNum >0 ; displayNum --)
			{
				if(!mems.getValue(firstName + "" + displayNum))
				{
					(getMemory(firstName + "" + displayNum, className,parameter));
				}
			}
		}
	}
}