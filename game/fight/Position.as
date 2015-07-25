package game.fight {
    import com.utils.Constants;
    import flash.geom.Point;
    import game.data.Val;
    import starling.display.DisplayObject;
    import starling.display.Sprite;

    /**
     * 布阵位置
     * @author Michael
     */
    public class Position {
        private var _position:Vector.<DisplayObject> = new Vector.<DisplayObject>;
        private var _POSITIONS:Vector.<Point> = new Vector.<Point>;
        private static var _this:Position = null;

        public static function get instance():Position {
            if (_this == null) {
                _this = new Position();
            }
            return _this;
        }

        public function Position():void {
            _POSITIONS = new <Point>[new Point(371, 235), new Point(346, 325), new Point(321, 415), new Point(236, 235),
                                     new Point(206, 325), new Point(181, 415), new Point(96, 235), new Point(71, 325), new Point(43,
                                                                                                                                 415)];

            var pos:Vector.<Point> = new <Point>[new Point(96, 235), new Point(71, 325), new Point(43, 415), new Point(236,
                                                                                                                       235),
                                                 new Point(206, 325), new Point(181, 415), new Point(371, 235), new Point(346,
                                                                                                                          325),
                                                 new Point(321, 415)];
            var len:int = pos.length;
            var point:Point = null;
            var i:int = 0;
            for (i = 0; i < len; i++) {
                point = pos[i] as Point;
                point.x = (Constants.virtualWidth - Constants.virtualEmbattleWidth + point.x);
            }
            _POSITIONS = _POSITIONS.concat(pos);

            len = _POSITIONS.length;
            point = null;
            for (i = 0; i < len; i++) {
                var sp:Sprite = new Sprite();
                point = _POSITIONS[i];
                sp.x = point.x;
                sp.y = point.y;
                _position[i] = sp;
            }
        }

        public function seatTopos(seat:int):int {
            return seat >= 21 ? seat - 21 + Val.SEAT_COUNT : seat - 11;
        }

        public function posToSeat(pos:int):int {
            return pos >= Val.SEAT_COUNT ? 21 + pos : 11 + pos;
        }

        public function getPoint(seat:int):Point {
            var point:Point = _POSITIONS[seatTopos(seat)];
            var point1:Point = point.clone();
            return point1;
        }

        public function getPos(seat:int):DisplayObject {
            return _position[seatTopos(seat)];
        }

        public function dispose():void {
            var len:int = _position.length;
            for (var i:int = 0; i < len; i++) {
                _position[i].dispose();
            }
        }
    }

}
