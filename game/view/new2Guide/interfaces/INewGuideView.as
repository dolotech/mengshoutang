package game.view.new2Guide.interfaces
{
	

	public interface INewGuideView
	{
		function getGuideDisplay(name : String) : *;
		function executeGuideFun(name : String) : void;
		function set touchable(value:Boolean):void;
	}
}