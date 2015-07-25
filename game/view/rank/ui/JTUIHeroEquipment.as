package game.view.rank.ui {
    import com.utils.Constants;

    import game.base.JTSprite;
    import game.manager.AssetMgr;

    import starling.display.Image;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class JTUIHeroEquipment extends JTSprite {
        public var bg:Image;
        public var box1:Image;
        public var par:Image;
        public var box3:Image;
        public var level_text:TextField;
        public var heroType:Image;
        public var hero_name:TextField;
        public var pinzhi:Image;
        public var box2:Image;
        public var box4:Image;
        public var Equip1:Image;
        public var Equip2:Image;
        public var Equip3:Image;
        public var Equip4:Image;
        public var sum1:Image;
        public var sum3:Image;
        public var sum4:Image;
        public var sum2:Image;
        public var level3:TextField;
        public var level4:TextField;
        public var level2:TextField;
        public var level1:TextField;
        public var rate:TextField;
        public var bgTexture:Texture;

        public function JTUIHeroEquipment() {
            bgTexture = AssetMgr.instance.getTexture('ui_yingxiong_beijing');
            bg = new Image(bgTexture);
            bg.x = 166;
            bg.y = 99;
            bg.width = 300;
            bg.height = 339;
            this.addQuiackChild(bg);

            var ui_gongyong_guaijiaoshitou2471127Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou2');
            var ui_gongyong_guaijiaoshitou2471127Image:Image = new Image(ui_gongyong_guaijiaoshitou2471127Texture);
            ui_gongyong_guaijiaoshitou2471127Image.x = 471;
            ui_gongyong_guaijiaoshitou2471127Image.y = 127;
            ui_gongyong_guaijiaoshitou2471127Image.width = 26;
            ui_gongyong_guaijiaoshitou2471127Image.height = 290;
            ui_gongyong_guaijiaoshitou2471127Image.scaleX = -1;
            ui_gongyong_guaijiaoshitou2471127Image.smoothing = Constants.smoothing;
            ui_gongyong_guaijiaoshitou2471127Image.touchable = false;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou2471127Image);

            var ui_gongyong_guaijiaoshitou2159124Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou2');
            var ui_gongyong_guaijiaoshitou2159124Image:Image = new Image(ui_gongyong_guaijiaoshitou2159124Texture);
            ui_gongyong_guaijiaoshitou2159124Image.x = 159;
            ui_gongyong_guaijiaoshitou2159124Image.y = 124;
            ui_gongyong_guaijiaoshitou2159124Image.width = 26;
            ui_gongyong_guaijiaoshitou2159124Image.height = 296;
            ui_gongyong_guaijiaoshitou2159124Image.touchable = false;
            ui_gongyong_guaijiaoshitou2159124Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou2159124Image);

            var ui_gongyong_guaijiaoshitou118896Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou1');
            var ui_gongyong_guaijiaoshitou118896Image:Image = new Image(ui_gongyong_guaijiaoshitou118896Texture);
            ui_gongyong_guaijiaoshitou118896Image.x = 188;
            ui_gongyong_guaijiaoshitou118896Image.y = 96;
            ui_gongyong_guaijiaoshitou118896Image.width = 257;
            ui_gongyong_guaijiaoshitou118896Image.touchable = false;
            ui_gongyong_guaijiaoshitou118896Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou118896Image);

            var ui_gongyong_guaijiaoshitou15595Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou');
            var ui_gongyong_guaijiaoshitou15595Image:Image = new Image(ui_gongyong_guaijiaoshitou15595Texture);
            ui_gongyong_guaijiaoshitou15595Image.x = 155;
            ui_gongyong_guaijiaoshitou15595Image.y = 95;
            ui_gongyong_guaijiaoshitou15595Image.touchable = false;
            ui_gongyong_guaijiaoshitou15595Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou15595Image);

            var ui_gongyong_guaijiaoshitou155450Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou');
            var ui_gongyong_guaijiaoshitou155450Image:Image = new Image(ui_gongyong_guaijiaoshitou155450Texture);
            ui_gongyong_guaijiaoshitou155450Image.x = 155;
            ui_gongyong_guaijiaoshitou155450Image.y = 450;
            ui_gongyong_guaijiaoshitou155450Image.scaleY = -1;
            ui_gongyong_guaijiaoshitou155450Image.touchable = false;
            ui_gongyong_guaijiaoshitou155450Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou155450Image);

            var ui_gongyong_guaijiaoshitou47595Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou');
            var ui_gongyong_guaijiaoshitou47595Image:Image = new Image(ui_gongyong_guaijiaoshitou47595Texture);
            ui_gongyong_guaijiaoshitou47595Image.x = 475;
            ui_gongyong_guaijiaoshitou47595Image.y = 95;
            ui_gongyong_guaijiaoshitou47595Image.scaleX = -1;
            ui_gongyong_guaijiaoshitou47595Image.touchable = false;
            ui_gongyong_guaijiaoshitou47595Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou47595Image);

            var ui_gongyong_guaijiaoshitou475450Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou');
            var ui_gongyong_guaijiaoshitou475450Image:Image = new Image(ui_gongyong_guaijiaoshitou475450Texture);
            ui_gongyong_guaijiaoshitou475450Image.x = 475;
            ui_gongyong_guaijiaoshitou475450Image.y = 450;
            ui_gongyong_guaijiaoshitou475450Image.scaleX = -1;
            ui_gongyong_guaijiaoshitou475450Image.scaleY = -1;
            ui_gongyong_guaijiaoshitou475450Image.touchable = false;
            ui_gongyong_guaijiaoshitou475450Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou475450Image);

            ui_gongyong_guaijiaoshitou2471127Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou2');
            ui_gongyong_guaijiaoshitou2471127Image = new Image(ui_gongyong_guaijiaoshitou2471127Texture);
            ui_gongyong_guaijiaoshitou2471127Image.x = 471;
            ui_gongyong_guaijiaoshitou2471127Image.y = 127;
            ui_gongyong_guaijiaoshitou2471127Image.scaleX = -1;
            ui_gongyong_guaijiaoshitou2471127Image.touchable = false;
            ui_gongyong_guaijiaoshitou2471127Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou2471127Image);

            var ui_gongyong_guaijiaoshitou1445452Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_guaijiaoshitou1');
            var ui_gongyong_guaijiaoshitou1445452Image:Image = new Image(ui_gongyong_guaijiaoshitou1445452Texture);
            ui_gongyong_guaijiaoshitou1445452Image.x = 445;
            ui_gongyong_guaijiaoshitou1445452Image.y = 452;
            ui_gongyong_guaijiaoshitou1445452Image.scaleX = -3.21331787109375;
            ui_gongyong_guaijiaoshitou1445452Image.scaleY = -1;
            ui_gongyong_guaijiaoshitou1445452Image.touchable = false;
            ui_gongyong_guaijiaoshitou1445452Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_guaijiaoshitou1445452Image);

            var ui_gongyong_jingyantiao_baidi181400Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_jingyantiao_baidi');
            var ui_gongyong_jingyantiao_baidi181400Image:Image = new Image(ui_gongyong_jingyantiao_baidi181400Texture);
            ui_gongyong_jingyantiao_baidi181400Image.x = 230;
            ui_gongyong_jingyantiao_baidi181400Image.y = 400;
            ui_gongyong_jingyantiao_baidi181400Image.touchable = false;
            ui_gongyong_jingyantiao_baidi181400Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_gongyong_jingyantiao_baidi181400Image);

            var parTexture:Texture = AssetMgr.instance.getTexture('ui_gongyong_jingyantiao_baidi1');
            par = new Image(parTexture);
            par.x = 245;
            par.y = 408;
            this.addQuiackChild(par);

            var boxDi1:Image = new Image(AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang'));
            this.addQuiackChild(boxDi1);
            boxDi1.x = 109;
            boxDi1.y = 170;
            boxDi1.width = 90;
            boxDi1.height = 90;

            var boxDi2:Image = new Image(AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang'));
            this.addQuiackChild(boxDi2);
            boxDi2.x = 427;
            boxDi2.y = 170;
            boxDi2.width = 90;
            boxDi2.height = 90;

            var boxDi3:Image = new Image(AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang'));
            this.addQuiackChild(boxDi3);
            boxDi3.x = 109;
            boxDi3.y = 278;
            boxDi3.width = 90;
            boxDi3.height = 90;

            var boxDi4:Image = new Image(AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang'));
            this.addQuiackChild(boxDi4);
            boxDi4.x = 426;
            boxDi4.y = 279;
            boxDi4.width = 90;
            boxDi4.height = 90;

            var Equip1Texture:Texture = AssetMgr.instance.getTexture('ui_yingxiongshengdian_wuqikuangbiaozhi1');
            Equip1 = new Image(Equip1Texture);
            Equip1.x = 126;
            Equip1.y = 180;
            this.addQuiackChild(Equip1);

            var Equip2Texture:Texture = AssetMgr.instance.getTexture('ui_yingxiongshengdian_wuqikuangbiaozhi13');
            Equip2 = new Image(Equip2Texture);
            Equip2.x = 444;
            Equip2.y = 185;
            this.addQuiackChild(Equip2);

            var Equip3Texture:Texture = AssetMgr.instance.getTexture('ui_yingxiongshengdian_wuqikuangbiaozhi14');
            Equip3 = new Image(Equip3Texture);
            Equip3.x = 131;
            Equip3.y = 289;
            this.addQuiackChild(Equip3);

            var Equip4Texture:Texture = AssetMgr.instance.getTexture('ui_yingxiongshengdian_wuqikuangbiaozhi15');
            Equip4 = new Image(Equip4Texture);
            Equip4.x = 444;
            Equip4.y = 294;
            this.addQuiackChild(Equip4);

            var box1Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang0');
            box1 = new Image(box1Texture);
            box1.x = 109;
            box1.y = 170;
            box1.width = 90;
            box1.height = 90;
            this.addQuiackChild(box1);

            var box2Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang0');
            box2 = new Image(box2Texture);
            box2.x = 427;
            box2.y = 170;
            box2.width = 90;
            box2.height = 90;
            this.addQuiackChild(box2);

            var box3Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang0');
            box3 = new Image(box3Texture);
            box3.x = 109;
            box3.y = 278;
            box3.width = 90
            box3.height = 90;
            this.addQuiackChild(box3);

            var box4Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_90wupingkuang0');
            box4 = new Image(box4Texture);
            box4.x = 426;
            box4.y = 279;
            box4.width = 90;
            box4.height = 90;
            this.addQuiackChild(box4);

            var ui_yongxiongdengji_di190360Texture:Texture = AssetMgr.instance.getTexture('ui_yongxiongdengji_di');
            var ui_yongxiongdengji_di190360Image:Image = new Image(ui_yongxiongdengji_di190360Texture);
            ui_yongxiongdengji_di190360Image.x = 180;
            ui_yongxiongdengji_di190360Image.y = 360;
            ui_yongxiongdengji_di190360Image.touchable = false;
            ui_yongxiongdengji_di190360Image.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_yongxiongdengji_di190360Image);

            level_text = new TextField(50, 37, '', '', 24, 0xFFFFFF, false);
            level_text.touchable = false;
            level_text.hAlign = 'center';
            level_text.x = 190;
            level_text.y = 370;
            this.addQuiackChild(level_text);

            var heroTypeTexture:Texture = AssetMgr.instance.getTexture('ui_gongyong_zheyetubiao2');
            heroType = new Image(heroTypeTexture);
            heroType.x = 402;
            heroType.y = 118;
            heroType.width = 46;
            heroType.height = 47;
            this.addQuiackChild(heroType);

            hero_name = new TextField(184, 32, '', '', 25, 0xFFFFFF, false);
            hero_name.touchable = false;
            hero_name.hAlign = 'center';
            hero_name.x = 224;
            hero_name.y = 126;
            this.addQuiackChild(hero_name);

            var pinzhiTexture:Texture = AssetMgr.instance.getTexture('ui_hero_yingxiongpinzhi_03');
            pinzhi = new Image(pinzhiTexture);
            pinzhi.x = 181;
            pinzhi.y = 117;
            pinzhi.width = 50;
            pinzhi.height = 50;
            this.addQuiackChild(pinzhi);

            var sum1Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_lvjiahao');
            sum1 = new Image(sum1Texture);
            sum1.x = 170;
            sum1.y = 227;
            sum1.width = 18;
            sum1.height = 20;
            this.addQuiackChild(sum1);

            var sum3Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_lvjiahao');
            sum3 = new Image(sum3Texture);
            sum3.x = 170;
            sum3.y = 337;
            sum3.width = 18;
            sum3.height = 20;
            this.addQuiackChild(sum3);

            var sum4Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_lvjiahao');
            sum4 = new Image(sum4Texture);
            sum4.x = 487;
            sum4.y = 336;
            sum4.width = 18;
            sum4.height = 20;
            this.addQuiackChild(sum4);

            var sum2Texture:Texture = AssetMgr.instance.getTexture('ui_gongyong_lvjiahao');
            sum2 = new Image(sum2Texture);
            sum2.x = 487;
            sum2.y = 227;
            sum2.width = 18;
            sum2.height = 20;
            this.addQuiackChild(sum2);

            level3 = new TextField(48, 28, '', '', 18, 0xFFFFFF, false);
            level3.touchable = false;
            level3.hAlign = 'left';
            level3.x = 117;
            level3.y = 338;
            this.addQuiackChild(level3);

            level4 = new TextField(48, 28, '', '', 18, 0xFFFFFF, false);
            level4.touchable = false;
            level4.hAlign = 'left';
            level4.x = 432;
            level4.y = 338;
            this.addQuiackChild(level4);

            level2 = new TextField(48, 28, '', '', 18, 0xFFFFFF, false);
            level2.touchable = false;
            level2.hAlign = 'left';
            level2.x = 432;
            level2.y = 228;
            this.addQuiackChild(level2);

            level1 = new TextField(48, 28, '', '', 18, 0xFFFFFF, false);
            level1.touchable = false;
            level1.hAlign = 'left';
            level1.x = 117;
            level1.y = 228;
            this.addQuiackChild(level1);

            var ui_yongxiongdengji_exp:Texture = AssetMgr.instance.getTexture('ui_yongxiongdengji_exp');
            var ui_yongxiongdengji_expImage:Image = new Image(ui_yongxiongdengji_exp);
            ui_yongxiongdengji_expImage.x = 260;
            ui_yongxiongdengji_expImage.y = 405;
            ui_yongxiongdengji_expImage.touchable = false;
            ui_yongxiongdengji_expImage.smoothing = Constants.smoothing;
            this.addQuiackChild(ui_yongxiongdengji_expImage);

            rate = new TextField(100, 35, '', '', 21, 0xFFFFFF, false);
            rate.touchable = false;
            rate.hAlign = 'center';
            rate.x = 305;
            rate.y = 400;
            this.addQuiackChild(rate);
        }

        override public function dispose():void {
            Equip1.dispose();
            Equip2.dispose();
            Equip3.dispose();
            Equip4.dispose();
            super.dispose();

        }

    }
}

