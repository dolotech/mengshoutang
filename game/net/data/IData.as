package game.net.data
{
	import flash.utils.ByteArray;
	/**
	 * 
	 * @author Michael
	 * 
	 */
	public interface IData
	{
		function serialize() : ByteArray;
		function deSerialize(data : ByteArray) : void;
		function getCmd() : int;
	}
}