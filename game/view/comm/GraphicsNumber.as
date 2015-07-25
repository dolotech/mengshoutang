package game.view.comm
{
    import com.singleton.Singleton;

    import game.manager.AssetMgr;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class GraphicsNumber
    {
        private static var numberList:Vector.<Texture> = new Vector.<Texture>;
        public function GraphicsNumber()
        {

        }

        public static function instance():GraphicsNumber
        {
            return Singleton.getInstance(GraphicsNumber) as GraphicsNumber;
        }

        private static function createNumber(index:int  = 0, textureFirstName:String = "ui_dengji" ):void
        {
            var texture:Texture = AssetMgr.instance.getTexture(textureFirstName+index);

            numberList.push(texture); 
            index ++;
            if(index < 10)createNumber(index,textureFirstName);
        }

        public function  getNumber(num:int,textureFirstName:String = "ui_dengji"):Sprite
        {

            numberList = new Vector.<Texture>;
            createNumber(0,textureFirstName);

            var sp:Sprite = new Sprite();
            var numStr:String = (num-1).toString();
            var width:int;
            var x:int;
            for (var i:int = 0 ; i < numStr.length ; i ++)
            {
                var numIndex:int = parseInt(numStr.charAt(i));
                var numImage:Image = new Image(numberList[numIndex]);
                sp.addChild(numImage);
                numImage.x = width > 0  ? (x + width -10):0;
                width  = numImage.width;
                x = numImage.x;
            }
            return sp;

        }
    }
}

