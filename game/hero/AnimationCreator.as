package game.hero
{
    import com.mobileLib.utils.ConverURL;
    import com.singleton.Singleton;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    import game.data.BuffData;
    import game.data.EffectSoundData;
    import game.data.HeroData;
    import game.data.MonsterData;
    import game.data.RoleShow;
    import game.data.SkillData;
    import game.data.TollgateData;
    import game.manager.HeroDataMgr;
    import game.view.city.House;

    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.textures.TextureAtlas;
    import starling.utils.AssetManager;

    import treefortress.spriter.AnimationSet;
    import treefortress.spriter.SpriterClip;

    /**
     * 战斗角色动画和特效管理器
     * 注意：
     * 1.角色动画和特效全部以骨骼动画实现
     * 2.每次进入战斗即时加载战斗角色及角色身上携带技能对应的特效
     * 3.独立的角色动画和特效资源管理器
     * 4.游戏运行周期缓存所以骨骼数据
     *
     * @author Michael
     */
    public class AnimationCreator
    {
        //游戏运行周期缓存所以骨骼数据
        public static var _poolData:Object={};

        //独立的角色动画和特效资源管理器

        /**
         *
         * @return
         */
        public static function get instance():AnimationCreator
        {
            return Singleton.getInstance(AnimationCreator) as AnimationCreator;
        }

        public function createSecneEffect(id:String, x:int, y:int, container:DisplayObjectContainer, assets:AssetManager=null, onComplement:Function=null):SpriterClip
        {
            var tmp_animation:SpriterClip=create(id, assets);
            tmp_animation.play(id);
            tmp_animation.animation.id=getTimer();
            tmp_animation.animation.looping=false;
            tmp_animation.animationComplete.addOnce(aniComplete);
            tmp_animation.x=x;
            tmp_animation.y=y;
            container.addChild(tmp_animation);
            Starling.juggler.add(tmp_animation);

            function aniComplete(sp:SpriterClip):void
            {
                if (onComplement != null)
                    onComplement();
                sp.removeFromParent(true);
            }
            return tmp_animation;
        }

        /**
         *
         *加载怪物
         *
         */
        public function loadMonsters(tollgate:TollgateData, callback:Function, assests:AssetManager):void
        {
            if (tollgate)
            {
                var monsters:Array=tollgate.monsters;
                var len:int=monsters.length;

                for (var i:int=0; i < len; i++)
                {
                    var type:int=monsters[i][0];
                    var monsterData:MonsterData=MonsterData.monster.getValue(type);
                    var role:RoleShow=RoleShow.hash.getValue(monsterData.show) as RoleShow;
                    var path:String=role.avatar;

                    if (monsterData.skill1 > 0)
                        loadSkillRes(assests, monsterData.skill1);

                    if (monsterData.skill2 > 0)
                        loadSkillRes(assests, monsterData.skill2);

                    if (monsterData.skill3 > 0)
                        loadSkillRes(assests, monsterData.skill3);
                    loadHeroEffect(assests, monsterData);
                    assests.enqueue(ConverURL.conver("role/" + path));
                }
            }
            assests.loadQueue(onComplete);

            function onComplete(ratio:Number):void
            {
                if (ratio == 1.0)
                {
                    if (callback != null)
                    {

                        callback();
                    }
                }

            }

        }

        /**
         *
         *
         * 加载对手
         *
         */
        public function loadRiv(callback:Function, assests:AssetManager):void
        {
            HeroDataMgr.instance.battleHeros.eachValue(eachValue);

            function eachValue(hero:Object):void
            {
                if (hero.team != HeroData.RED)
                    return;

                var avatar:String=(RoleShow.hash.getValue(hero.show) as RoleShow).avatar;

                var path:String="role/" + avatar;

                if (hero.skill1 > 0)
                    loadSkillRes(assests, hero.skill1);

                if (hero.skill2 > 0)
                    loadSkillRes(assests, hero.skill2);

                if (hero.skill3 > 0)
                    loadSkillRes(assests, hero.skill3);
                assests.enqueue(ConverURL.conver(path));

                loadHeroEffect(assests, hero as HeroData);
            }

            assests.loadQueue(onComplete);

            function onComplete(ratio:Number):void
            {
                if (ratio == 1.0)
                {
                    if (callback != null)
                    {
                        callback();
                    }
                }
            }
        }

        /**
         * 加载玩家已经上阵的英雄
         * @param assests
         *
         */
        public function loadMeSelfBattleHeros(list:Array, assests:AssetManager):void
        {
            var len:int=list.length
            var hero:HeroData;

            for (var i:int=0; i < len; i++)
            {
                hero=list[i];

                if (hero.seat > 0)
                {
                    loadHeroRes(hero, assests)
                    loadHeroSkillRes(hero, assests)
                }
            }
        }

        /**
         * 加载单个角色技能资源
         * @param hero
         * @param assests
         *
         */
        public function loadHeroSkillRes(hero:HeroData, assests:AssetManager):void
        {
            if (hero.skill1 > 0)
                loadSkillRes(assests, hero.skill1);

            if (hero.skill2 > 0)
                loadSkillRes(assests, hero.skill2);

            if (hero.skill3 > 0)
                loadSkillRes(assests, hero.skill3);
            loadHeroEffect(assests, hero)
        }

        /**
         * 加载单个角色资源
         * @param hero
         * @param assests
         *
         */
        public function loadHeroRes(hero:HeroData, assests:AssetManager):void
        {
            var avatar:String=(RoleShow.hash.getValue(hero.show) as RoleShow).avatar;
            var path:String="role/" + avatar;
            assests.enqueue(ConverURL.conver(path));
        }

        /**
         *
         *     创建一个骨骼动画
         *
         *
         * @param animationName    骨骼动画名字
         * @param assests          指定资源库
         *
         * @param autoRelease        是否自动回收资源
         * @return
         */
        public function create(animationName:String, assests:AssetManager, autoRelease:Boolean=false):SpriterClip
        {
            var spriterClip:SpriterClip;

            for (var sp:SpriterClip in pool)
            {
                if (sp.name == animationName)
                {
                    if (assests.getTextureAtlas(animationName) != sp.textureAtlas) // 纹理已经被销毁
                    {
                        sp.realDispose();
                        delete pool[sp];
                        continue;
                    }
                    else
                    {
                        spriterClip=sp;
                        delete pool[sp];
                        break;
                    }
                }
            }

            if (!spriterClip)
            {
                var atlas:TextureAtlas=assests.getTextureAtlas(animationName);
                spriterClip=new SpriterClip(getAnimationData(animationName, assests), atlas);
                spriterClip.name=animationName;
            }

            var t:int=getTimer();
            if (t - _lastDisposeTime > 3000)
            {
                checkAndDispose();
                _lastDisposeTime=t;
            }

            if (autoRelease)
            {
                spriterClip.animationComplete.addOnce(onComplete);
                spriterClip.name=animationName;
            }
            Starling.juggler.add(spriterClip);
            return spriterClip;
        }

        public function recycle(sp:SpriterClip):void
        {
            pool[sp]=getTimer();
        }

        private function checkAndDispose():void
        {
            for (var sp:SpriterClip in pool)
            {
                var timer:int=getTimer();
                if (timer - pool[sp] > DELAY)
                {
                    sp.realDispose();
                    delete pool[sp];
                }
            }
        }
        private var _lastDisposeTime:int;
        private static const DELAY:Number=1000 * 60 * 3;
        public var pool:Dictionary=new Dictionary();

        public function createHouse(animationName:String, assests:AssetManager):House
        {
            var atlas:TextureAtlas=assests.getTextureAtlas(animationName);

            if (!atlas)
            {
                atlas=assests.getTextureAtlas("town");
            }

            if (!atlas)
                return null;
            var spriterClip:House=new House(getAnimationData(animationName, assests), atlas, animationName);

            return spriterClip;
        }

        private function onComplete(sp:SpriterClip):void
        {
            sp.dispose();
        }

        private function getAnimationData(animationName:String, assests:AssetManager):Object
        {
            var ani:Object=_poolData[animationName];
            if (!ani)
            {
                ani=new AnimationSet(assests.getXml(animationName)).getAnimations();
                _poolData[animationName]=ani;
            }

            var time:int=getTimer();
            _poolTime[animationName]=time;
            var delay:int=1000 * 60 * 3;
            for (var key:String in _poolTime)
            {
                var t:int=_poolTime[key];
                if (time - t > delay)
                {
                    delete _poolTime[key];
                    delete _poolData[key];
                }
            }
            return ani;
        }
        private var _poolTime:Object={};

        private function loadHeroEffect(assets:AssetManager, heroData:HeroData):void
        {
            var role:RoleShow=RoleShow.hash.getValue(heroData.show);
            var skillWord:String=heroData.skillword;
            var effect:String=role.attackEffect;

            if (effect)
            {
                assets.enqueue(ConverURL.conver("skill/" + effect));
            }
            if (skillWord)
            {
                assets.enqueue(ConverURL.conver("word/" + skillWord));
            }

            effect=role.underAttackEffect;

            if (effect)
            {
                assets.enqueue(ConverURL.conver("skill/" + effect));
            }
        }

        /**
         *
         */
        public function dispose():void
        {
        }

        /**
         * 加载技能光环特效
         * @param assets
         * @param skill
         *
         */
        private function loadSkillRes(assets:AssetManager, skill:int):void
        {
            var skillData:SkillData=SkillData.getSkill(skill);
            var arr:Array=["ringEffect", "attackEffect", "underAttackEffect", "skillEffect", "fireEffect"];
            var sound:EffectSoundData=EffectSoundData.hash.getValue(skillData.skillEffect);

            var len:int=arr.length;

            for (var i:int=0; i < len; i++)
            {
                var key:String=arr[i];
                var effect:String=skillData[key];

                if (effect)
                {
                    assets.enqueue(ConverURL.conver("skill/" + effect));
                    sound && assets.enqueue(ConverURL.conver("skillAudio/" + sound.sound + ".mp3"));
                }
            }
            var cmd:String=skillData.cmd;

            if (cmd.indexOf("set_buff") != -1)
            {
                arr=cmd.split(",");
                var buffID:int=int(arr[arr.length - 2]);

                if (buffID > 0)
                {
                    var buffData:BuffData=BuffData.hash.getValue(buffID);
                    var sound1:EffectSoundData=EffectSoundData.hash.getValue(buffData.buffEffect);
                    var buffEffect:String=buffData.buffEffect;

                    if (buffEffect)
                    {
                        assets.enqueue(ConverURL.conver("skill/" + buffEffect));
                        sound1 && assets.enqueue(ConverURL.conver("skillAudio/" + sound1.sound + ".mp3"));
                    }
                }
            }
        }
    }
}
