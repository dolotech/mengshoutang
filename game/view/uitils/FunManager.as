package game.view.uitils
{
public class FunManager
{public static function coliseum_buys(X:*):Number
{return X*15+10*Math.pow(2,X)+20
}public static function power_buy(X:*):Number
{return 50+30*(X+1)
}public static function fb_buy1(X:*):Number
{return 5*Math.pow((X+1),2)
}public static function fb_buy2(X:*):Number
{return 10*Math.pow((X+1),2)
}public static function fb_buy3(X:*):Number
{return 20*Math.pow((X+1),2)
}public static function hero_dismissal(X:*,Lev:*):Number
{return X/100+5*Lev
}public static function jewelry_upgrade(X:*,N:*):Number
{return X*N*(1+N*0.1)
}
}
}