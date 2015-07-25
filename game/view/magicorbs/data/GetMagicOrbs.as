package game.view.magicorbs.data {
    import game.net.data.s.SGetMagicOrbs;

    public class GetMagicOrbs extends SGetMagicOrbs {
        public var gridLock:Boolean = true;
        public var selected:Boolean = false;
        public var rock:Boolean = false;
        public var animation:Boolean = false;
        public var pile:int;
        public var exp:int;
        public var quality:int;
    }
}
