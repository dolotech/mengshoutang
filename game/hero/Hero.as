package game.hero
{
    import com.sound.SoundManager;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import game.data.BuffData;
    import game.data.EffectSoundData;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.RoleShow;
    import game.data.SkillData;
    import game.data.Val;
    import game.data.WidgetData;
    import game.fight.Position;
    import game.hero.command.CommandMgr;
    import game.hero.command.IdleCommand;
    import game.manager.AssetMgr;
    import game.manager.BattleAssets;
    import game.net.data.vo.BattleVo;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    import treefortress.spriter.SpriterClip;

    /**
     * 英雄基类
     * @author Michael
     *
     */
    public class Hero extends MoveableEntity
    {

        /**
         * 添加buff
         * @param skillData
         *
         */
        private const HEIGHT_GAP:int=40;

        /**
         *
         * @param data
         */
        public function Hero(data:HeroData)
        {
            _data=data;
            onHPChange=new Signal(Hero);
            onHPChange.add(updateShowHp);
            onNextOne=new Signal(Hero);

            skillEffectComplete=new Signal(Hero);
            skillEffectCallback=new Signal(Hero);

            var roleShow:RoleShow=RoleShow.hash.getValue(_data.show) as RoleShow;
            speed=roleShow.moveSpeed / 100;

            this.touchable=false;

            _shadow=new Image(BattleAssets.instance.getTexture("shadow"));
            _shadow.x=-_shadow.width / 2;
            _shadow.y=-_shadow.height / 2;
            addChild(_shadow);

            buffLayer=new Sprite();
            effectLayer=new Sprite();
            ringLayer=new Sprite();
            hpLayer=new Sprite();
            this.addChild(ringLayer);
            this.addChild(hpLayer);

            _spriterClip=AnimationCreator.instance.create(roleShow.avatar, BattleAssets.instance);
            _spriterClip.scaleY=_data.size / Val.ROLE_ZISE;
            this.addChild(_spriterClip);
            this.addChild(buffLayer);
            this.addChild(effectLayer);

            reastPos();
            createHPBar();
            _buff={};
            _ring={};

            if (_data.skill1 > 0)
            {
                var skillData:SkillData=SkillData.getSkill(_data.skill1);
                if (skillData.ringEffect)
                {
                    addRingEffect(skillData.ringEffect);
                }
            }

            if (_data.skill2 > 0)
            {
                skillData=SkillData.getSkill(_data.skill2);
                if (skillData.ringEffect)
                {
                    addRingEffect(skillData.ringEffect);
                }
            }

            if (_data.skill3 > 0)
            {
                skillData=SkillData.getSkill(_data.skill3);
                if (skillData.ringEffect)
                {
                    addRingEffect(skillData.ringEffect);
                }
            }

            command=new CommandMgr(new IdleCommand(this));

            var bounds:Rectangle=getBounds(this);
            hitWidth=bounds.width;
            hitHeight=bounds.height;

            startAnimation();
            changeWeapon();
        }

        public function reastPos():void
        {
            var point:Point=Position.instance.getPoint(_data.seat);
            this.x=point.x;
            this.y=point.y;
        }

        public var command:CommandMgr;
        /**
         * 扣血成功后，启用下一轮攻击
         */
        public var onNextOne:ISignal;
        public var skillEffectComplete:ISignal;
        public var skillEffectCallback:ISignal;
        public var onHPChange:ISignal;
        /**
         * buff
         */
        protected var _buff:Object;
        /**
         * 光环
         */
        protected var _ring:Object;
        /**
         *
         * @default
         */
        protected var _hpBar:HPBar;
        private var buffLayer:Sprite;
        private var ringLayer:Sprite;
        private var effectLayer:Sprite;
        private var hpLayer:Sprite;
        /**
         *
         * @default
         */
        private var _shadow:Image;
        private var _spriterClip:SpriterClip;
        /**
         *
         * @default
         */

        /**
         *
         * @default
         */
        protected var _data:HeroData;

        /**
         *
         * @return
         */
        public function get data():HeroData
        {
            return _data;
        }

        /**
         *
         * @return
         */
        public function get id():int
        {
            return _data.id;
        }

        /**
         * 战斗结束销毁英雄显示数据
         *
         */
        override public function dispose():void
        {
            if (_hpBar)
                _hpBar.removeFromParent(true);
            onHPChange.removeAll();
            Starling.juggler.remove(_spriterClip);
            for each (var arr:Array in _ring)
            {
                for each (var sp:SpriterClip in arr)
                {
                    Starling.juggler.remove(sp);
                    sp.removeFromParent(true);
                    sp.animationComplete.removeAll();
                }
            }

            for each (sp in _buff)
            {
                Starling.juggler.remove(sp);
                sp.removeFromParent(true);
                sp.animationComplete.removeAll();
            }
            _buff={};
            _ring={};
            command.dispose();
            super.dispose();
        }

        public function getDis(target):int
        {
            var gap:int;
            if (this.data.team == HeroData.BLUE)
            {
                gap=-target.hitWidth / 4 - this.hitWidth / 4;
            }
            else
            {
                gap=target.hitWidth / 4 + this.hitWidth / 4;
            }
            return gap;
        }

        public function startAnimation():void
        {
            Starling.juggler.add(_spriterClip);
        }

        public function stopAnimation():void
        {
            Starling.juggler.remove(_spriterClip);
        }

        public function skill(command:BattleVo):void
        {

        }

        /**
         *播放英雄攻击动作
         * @param onComplete
         */
        public function playSkillAnimation():void
        {
            _spriterClip.play("attack");
            _spriterClip.animation.looping=false;
        }

        /**
         *播放攻击动画
         * @param onComplete
         */
        public function playAttackAnimation():void
        {
            _spriterClip.play("attack");
            _spriterClip.animation.looping=false;
            var roleShow:RoleShow=RoleShow.hash.getValue(_data.show) as RoleShow;
            _spriterClip.addCallback(attackCompelte, roleShow.attackTime, true);
        }

        private function attackCompelte():void
        {
            playAttackSound();
        }

        /**
         * 播放普通攻击声音
         * @param
         */
        public function playAttackSound():void
        {
            var heroShow:RoleShow=RoleShow.hash.getValue(data.show);
            if (heroShow.attackTime && heroShow.attackMusic && heroShow.attackMusic != "")
            {
                SoundManager.instance.playSound(heroShow.attackMusic);
            }
        }

        /**
         * 当前动作播放制定真回调，回调完成清除回调函数，即，对循环的动作只调用一次
         */
        public function addFrameCallback(onComplete:Function):void
        {
            var roleShow:RoleShow=RoleShow.hash.getValue(_data.show) as RoleShow;
            if (onComplete != null)
            {
                _spriterClip.addCallback(onComplete, roleShow.attackTime, true);
            }
        }

        /**
         *播放赢的动画
         */
        public function playWinAnimation():void
        {
            _spriterClip.play("win");
            _spriterClip.animation.looping=true;
        }

        /**
         * 行走动作
         */
        public function playMoveAnimation():void
        {
            if (_spriterClip.animation && _spriterClip.animation.name == "move")
            {
                return;
            }
            _spriterClip.play("move");
            _spriterClip.animation.looping=true;

            if (_target)
            {
                if (_target.x > this.x)
                {
                    this.turnRight();
                }
                else if (_target.x < this.x)
                {
                    this.turnLeft();
                }
            }
        }

        override public function advanceTime(time:Number):void
        {
            super.advanceTime(time);

            if (_target)
            {
                if (_target.x > this.x)
                {
                    this.turnRight();
                }
                else if (_target.x < this.x)
                {
                    this.turnLeft();
                }
            }
            else
            {
                if (_data.team == HeroData.BLUE)
                {
                    turnRight();
                }
                else
                {
                    turnLeft();
                }
            }
        }

        /**
         *  待机动作
         */
        public function playIdleAnimation():void
        {
            _spriterClip.play("idle");
            _spriterClip.animation.looping=true;

        /*  if (_target) {
              if (_target.x > this.x) {
                  this.turnRight();
              }
              else if (_target.x < this.x) {
                  this.turnLeft();
              }
          }
          else {
              if (_data.team == HeroData.BLUE) {
                  turnRight();
              }
              else {
                  turnLeft();
              }
          }*/
        }

        public function swapPieceByTex(piece:String, newTex:Texture):void
        {
            _spriterClip.swapPieceByTex(piece, newTex);
        }

        public function unswapPiece(piece:String):void
        {
            _spriterClip.unswapPiece(piece);
        }

        /**
         * 当前动作播放完成回调
         */
        public function onAnimationComplete(onComplete:Function):void
        {
            _spriterClip.animationComplete.removeAll();
            if (onComplete != null)
            {
                _spriterClip.animationComplete.add(onComplete);
            }
        }

        /**
         * 播放受击动作
         */
        public function playUnderAttackAnimation():void
        {
            _spriterClip.play("underattack");
            _spriterClip.animation.looping=false;
        }

        /**
         *
         */
        public function turnLeft():void
        {
            if (_spriterClip.scaleX != _data.size / Val.ROLE_ZISE)
            {
                _spriterClip.scaleX=_data.size / Val.ROLE_ZISE;
            }
        }

        /**
         *
         */
        public function turnRight():void
        {
            if (_spriterClip.scaleX != -1 * _data.size / Val.ROLE_ZISE)
            {
                _spriterClip.scaleX=-1 * _data.size / Val.ROLE_ZISE;
            }
        }

        public function updateBuff(buffs:Vector.<int>):void
        {
            for (var key:String in _buff)
            {
                if (buffs.indexOf(int(key)) == -1)
                {
                    removeBuffEffect(key);
                }
            }

            var len:int=buffs.length;
            for (var i:int=0; i < len; i++)
            {
                var buffid:int=buffs[i];
                var buffData:BuffData=BuffData.hash.getValue(buffid);
                if (!_buff[buffid])
                {
                    addBuffEffect(String(buffid));
                    var soundData:EffectSoundData=EffectSoundData.hash.getValue(buffData.buffEffect);
                    if (soundData && soundData.sound)
                    {
                        SoundManager.instance.playSound(soundData.sound);
                    }

                }
            }
        }

        public function addAnimation(sp:DisplayObject, x:int, y:int):void
        {
            effectLayer.addChild(sp);
            sp.x=x;
            sp.y=y;
        }

        /**
         1：播放1次
         2：播放至下一次状态改变
         */
        public function addEffect(skillData:SkillData):void
        {
            var effect:SpriterClip=AnimationCreator.instance.create(skillData.skillEffect, BattleAssets.instance, true);
            effect.scaleX=data.team == HeroData.BLUE ? -1 : 1;
            effect.play(skillData.skillEffect);
            playSound(skillData);
            /*1：角色中间
             2：角色脚底
             6：角色头顶*/
            switch (skillData.skillEffectPosition)
            {
                case 1:
                    effectLayer.addChild(effect);
                    effect.y=-HEIGHT_GAP;
                    break;
                case 2:
                    ringLayer.addChild(effect);
                    break;
                case 6:
                    effect.y=-_spriterClip.height / 2 - HEIGHT_GAP;
                    effectLayer.addChild(effect);
                    break;
                default:
                    break;
            }

            effect.animationComplete.addOnce(skillEffectCompleteHdr);
            effect.addCallback(skillEffectcallback, skillData.callbackFrame);
        }

        /**
         *
         */
        protected function createHPBar():void
        {
//			if (!this.data.isBoss) //BOOS小血条判断
//			{
            _hpBar=new HPBar();
            addChildAt(_hpBar, numChildren);
            _hpBar.progress=this.data.currenthp / this.data.hp;
            _hpBar.scaleX=_hpBar.scaleY=0.3;
            _hpBar.x=-_hpBar.width / 2;
            _hpBar.y=-115;
//			}
        }

        private function changeWeapon():void
        {
            // 换武器
            var weapon:int=data.seat1;
            if (weapon > 0)
            {
                var widget:WidgetData=WidgetData.hash.getValue(weapon);
                var goods:Goods=Goods.goods.getValue(weapon);

                if (widget && widget.avatar)
                {
                    _spriterClip.swapPieceByTex("role_weapon", AssetMgr.instance.getTexture(widget.avatar));
                }
                else if (goods && goods.avatar)
                {
                    _spriterClip.swapPieceByTex("role_weapon", AssetMgr.instance.getTexture(goods.avatar));
                }
            }
        }

        /**
         *
         */
        private function updateShowHp(hero:Hero):void
        {
            if (_hpBar)
                _hpBar.progress=this.data.currenthp / this.data.hp;
        }

        /**
         * 技能特效
         * @param skillData
         */
        private function playSound(skillData:SkillData):void
        {
            var sound:EffectSoundData=EffectSoundData.hash.getValue(skillData.skillEffect);
            if (sound && sound.name)
            {
                SoundManager.instance.playSound(sound.sound);
            }
        }

        private function skillEffectcallback():void
        {
            skillEffectCallback.dispatch(this);
        }

        private function skillEffectCompleteHdr(ani:SpriterClip):void
        {
            skillEffectComplete.dispatch(this);
        }

        /**
         * 添加光环
         * @param skillData
         */
        private function addRingEffect(effectName:String):void
        {
            var ringEffectList:Array=_ring[effectName];
            if (!ringEffectList)
            {
                ringEffectList=[];
                _ring[effectName]=ringEffectList;
            }

            var ringEffect:SpriterClip=AnimationCreator.instance.create(effectName, BattleAssets.instance);
            ringEffectList.push(ringEffect);
            ringEffect.play(effectName);
            ringEffect.animation.looping=true;
            ringEffect.scaleX=data.team == HeroData.BLUE ? 1 : -1;

            ringLayer.addChild(ringEffect);
            Starling.juggler.add(ringEffect);
        }

        private function addBuffEffect(buffid:String):void
        {
            var buffEffect:SpriterClip=_buff[buffid];
            if (!buffEffect)
            {
                var buffData:BuffData=BuffData.hash.getValue(buffid);
                buffEffect=AnimationCreator.instance.create(buffData.buffEffect, BattleAssets.instance);
                buffEffect.name=buffData.buffEffect;
                _buff[buffid]=buffEffect;
                buffEffect.scaleX=data.team == HeroData.BLUE ? 1 : -1;
                buffEffect.play(buffData.buffEffect);
                buffEffect.animation.looping=true;
                /*1：角色中间
                 2：角色脚底
                 6：角色头顶*/
//				阵型中间的特效→某列或者某排中间的特效（根据先后释放次序）→
//				英雄头上的特效→ 人物身上的特效→人物脚下的特效（根据特效的释放次序，最新释放的特效为最上层）→角色阴影→场景
                switch (buffData.position)
                {
                    case 1:
                        buffLayer.addChild(buffEffect);
                        buffLayer.y=-HEIGHT_GAP;
                        break;
                    case 2:
                        ringLayer.addChild(buffEffect);
                        break;
                    case 6:
                        buffEffect.y=-_spriterClip.height / 2 - HEIGHT_GAP;
                        buffLayer.addChild(buffEffect);
                        break;
                }

                Starling.juggler.add(buffEffect);

                /*1：播放1次
                 2：播放至下一回合
                 3：永久播放
                 */
                if (buffData.loop == 1)
                {
                    buffEffect.animationComplete.addOnce(animationComplete);
                }
            }

            function animationComplete(ani:SpriterClip):void
            {
                for (var key:String in _buff)
                {
                    if (_buff[key] == ani)
                    {
                        delete _buff[key];
                    }
                }
                ani.dispose();
            }
        }

        /**
         * 移除指定的 Buff特效
         * @param effectName
         */
        private function removeBuffEffect(buffid:String):void
        {
            var buffEffect:SpriterClip=_buff[buffid];
            if (buffEffect)
            {
                Starling.juggler.remove(buffEffect);
                buffEffect.removeFromParent();
                buffEffect.animationComplete.removeAll();
                delete _buff[buffid];
            }
        }
    }
}


