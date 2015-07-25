package game.view.pack {
    import game.manager.AssetMgr;
    import game.view.magicorbs.render.RockTween;

    import starling.display.Sprite;
    import starling.textures.Texture;

    public class PackGrids extends Sprite {
        public function PackGrids() {
            super();
            createGrids();
        }

        private function createGrids():void {
            var i:int = 1;
            var length:int = 24;
            var row:int = 1;
            var maxRow:int = 8;
            var initX:int = 47;
            var initY:int = 170;
            var ver:int = 1;
            var gap:int = 15;
            var gapY:int = 6;

            var texture:Texture = (AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang"));
            var grid:PackGrid;
            for (i; i <= length; i++) {
                if (row > maxRow) {
                    row = 1;
                    ver++;
                }
                grid = new PackGrid(texture);
                addChild(grid);
                grid.pivotX = grid.width / 2;
                grid.pivotY = grid.height / 2;
                if (row == 1)
                    grid.x = initX + gap + grid.pivotX;
                else
                    grid.x = initX + (row * gap) + (grid.width * (row - 1)) + grid.pivotX;

                if (ver == 1)
                    grid.y = initY + gapY + grid.pivotY;
                else
                    grid.y = initY + (ver * gapY) + (grid.height * (ver - 1)) + grid.pivotY;
                row++;
            }
        }

        public function addGoodIcon(dataList:Vector.<Object>, openGrid:int, pageIndex:int = 1):void {
            var qidian:int = (pageIndex - 1) * 24;
            var length:int = 24 * (pageIndex);
            var grid:PackGrid;

            for (var i:int = 0; i < numChildren; i++) {
                grid = getChildAt(i) as PackGrid;

                if (qidian < openGrid) {
                    grid.data = dataList[qidian];
                } else
                    grid.off();

                qidian++;
            }
        }
        private var tweenList:Array = [];

        public var isTween:Boolean;

        public function tween():void {
            var grid:PackGrid;
            for (var i:int = 0; i < numChildren; i++) {
                grid = getChildAt(i) as PackGrid;
                if (grid.data) {
                    tweenList.push(new RockTween(grid));
                }
            }
            isTween = true;
        }

        public function stopTween():void {
            var tw:RockTween;
            for (var i:int = 0; i < tweenList.length; i++) {
                tw = tweenList[i];
                tw.stop();
            }
            tweenList = [];
            isTween = false;
        }

        public function get tweenLength():int {
            return tweenList.length;
        }
    }
}
