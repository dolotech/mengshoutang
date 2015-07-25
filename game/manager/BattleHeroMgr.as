
package game.manager {
import com.data.HashMap;
import com.singleton.Singleton;

import game.data.HeroData;
import game.hero.Hero;

/**
 * 游戏内的英雄数据有，布阵位置索引
 * 战斗内英雄列表
 * @author Administrator
 *
 */
public class BattleHeroMgr {
    /**
     *
     * @return
     */
    public static function get instance():BattleHeroMgr {
        return Singleton.getInstance(BattleHeroMgr) as BattleHeroMgr;
    }

    /**
     *
     */
    public function BattleHeroMgr() {
        hash = new HashMap();
    }

    // 创建一个英雄
    /**
     * 游戏内的英雄数据有，布阵位置索引
     * @default
     */
    public var hash:HashMap;

    /**
     *
     * @param data
     * @return
     */
    public function createHero(data:HeroData,isSave:Boolean=true):Hero {
        var hero:Hero = new Hero(data);
		if(isSave)
       		 hash.put(hero.id, hero);
        return hero;
    }

	public function put(key:int, value:Hero):void
	{
		hash.put(key, value);
	}
    /**
     *
     */
    public function dispose():void {

        var temp:Vector.<*> = hash.values();
        var len:int = temp.length;
        for (var i:int = 0;i<len;i++)
        {
            var hero:Hero = temp[i];
            hero.removeFromParent(true);
        }
        hash.clear();
    }
}
}