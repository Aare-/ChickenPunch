package com.subfty.chickenpunch;
import com.subfty.sub.display.ImgSprite;
import nme.Assets;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.Lib;
import nme.media.Sound;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * ...
 * @author Filip Loster
 */

class Game extends Sprite{

  //SPRITEs
	var container:Sprite;
	var background:ImgSprite;
	var fist:ImgSprite;
	var chicken:ImgSprite;
	var splash:ImgSprite;
	var powah:ImgSprite;
	var powahMeterImg:Sprite;
	var chickLife:ImgSprite;
	var chickLifeImg:Sprite;
	
  //SOUNDS
	var hitS:Sound;
	var levelUpS:Sound;
	var miss:Sound;
	var restartLevel:Sound;
	
  //GAME VARIABLES
    var level:Int;
	var chickenLife:Float;
	var chickenLifeMax:Float;
	var powahMeter:Float;
	
	var chickenVisible:Float;
	
	var loadPowah:Bool;
	
	var hitTime:Float;
	var hitted:Bool;
	
  //TEXT STUFF
	public var levelVal:TextField;
	public var timeVal:TextField;
	var font:Font;
	var format:TextFormat;
	
	private var time:Float;
	private var timeUpdateStep:Float;
	
	public function new(p:Sprite){
		super();
		
		p.addChild(this);
		
		hitS = Assets.getSound("sound/hit.wav");
		levelUpS = Assets.getSound("sound/levelUp.wav");
		miss = Assets.getSound("sound/miss.wav");
		restartLevel = Assets.getSound("sound/restartLevel.wav");

		container = new Sprite();
		container.x = 0;
		container.y = 0;
		container.width = Main.STAGE_W;
		container.height = Main.STAGE_H;
		container.mouseChildren = false;
		container.mouseEnabled = false;
		this.addChild(container);
		
		background = new ImgSprite(container);
		background.loadImage("img/bg.png");
		background.x = -200;
		background.y = -100;
		background.width = Main.STAGE_W+400;
		background.height = Main.STAGE_H+200;
		
	  //GAME TEXTS
		font = Assets.getFont("fonts/8bitlim.ttf");
		format = new TextFormat(font.fontName, 10, 0xffffff);
		
		timeVal = new TextField();
		timeVal.defaultTextFormat = format;
		timeVal.x = 160;
		timeVal.y = 400-130;
		timeVal.width = 512;
		timeVal.height = 200;
		timeVal.text = "";
		timeVal.alpha = 0.4;
		timeVal.selectable = false;
		timeVal.embedFonts = true;
		timeVal.scaleX = timeVal.scaleY = 25;
		timeVal.mouseEnabled = false;
		container.addChild(timeVal);
		
		levelVal = new TextField();
		levelVal.defaultTextFormat = format;
		levelVal.x = 220;
		levelVal.y = 320-130;
		levelVal.width = 512;
		levelVal.height = 200;
		levelVal.text = "level";
		levelVal.alpha = 0.4;
		levelVal.selectable = false;
		levelVal.embedFonts = true;
		levelVal.scaleX = levelVal.scaleY = 10;
		levelVal.mouseEnabled = false;
		container.addChild(levelVal);
		
		chicken = new ImgSprite(container);
		chicken.loadImage("img/chicken.png");
		chicken.width = Main.STAGE_W * 0.8;
		chicken.height = 162.0 / 93.0 * chicken.width;
		chicken.x = (Main.STAGE_W -chicken.width)/2;
		chicken.y = Main.STAGE_H+200;
		
		splash = new ImgSprite(container);
		splash.loadImage("img/splash.png");
		splash.width = Main.STAGE_W * 0.9;
		splash.height = 72.0 / 102.0 * splash.width;
		splash.x = (Main.STAGE_W - splash.width) / 2;
		splash.y = Main.STAGE_H - splash.height - 250;
		splash.visible = false;
		
		fist = new ImgSprite(container);
		fist.loadImage("img/fist.png");
		fist.width = Main.STAGE_W * 0.6;
		fist.height = 79 / 61 * fist.width;
		fist.x = Main.STAGE_W - fist.width + 170;
		fist.y = Main.STAGE_H - fist.height+100+380;
		
		
		chickLifeImg = new Sprite();
		container.addChild(chickLifeImg);
		chickLifeImg.graphics.clear();
		chickLifeImg.graphics.beginFill(0xf1eb4c);
		chickLifeImg.graphics.drawRect(0, 0, 10, 50);
		
		chickLife = new ImgSprite(container);
		chickLife.loadImage("img/chick_life.png");
		chickLife.width = Main.STAGE_W * 0.8;
		chickLife.height = 16.0 / 77.0 * chickLife.width;
		chickLife.x = (Main.STAGE_W - chickLife.width) / 2;
		chickLife.y = 25;
		
		chickLifeImg.x = chickLife.x+7;
		chickLifeImg.width = chickLife.width - 14;
		chickLifeImg.y = chickLife.y+5;
		chickLifeImg.height = chickLife.height-45;
		
		powahMeterImg = new Sprite();
		container.addChild(powahMeterImg);
		powahMeterImg.graphics.clear();
		powahMeterImg.graphics.beginFill(0xd544ff);
		powahMeterImg.graphics.drawRect(0, 0, 10, 50);
		
		powah = new ImgSprite(container);
		powah.loadImage("img/powah.png");
		powah.width = Main.STAGE_W * 0.9;
		powah.height = 24.0 / 106.0 * powah.width;
		powah.x = (Main.STAGE_W - powah.width) / 2;
		powah.y = Main.STAGE_H - powah.height - 25;
		
		powahMeterImg.x = powah.x+7;
		powahMeterImg.width = 0;
		powahMeterImg.y = powah.y+82;
		powahMeterImg.height = powah.height-82;
		
		level = 1;
		loadPowah = false;
		hitted = false;
		
		hitTime = 0;
		
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, touchBegin);
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, touchEnd);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, touchEnd);
		
		newGame();
	}
	
  //TOUCH EVENTS
	private function touchBegin(e) {
		loadPowah = true;
	}
	private function touchEnd(e) {
		loadPowah = false;
		
		hitTime = 300;		
		hitted = false;
			
		if(chicken.y < (Main.STAGE_H - chicken.height * 0.6+200)){
			chickenLife -= 50 * getPowahValue();		
			hitted = true;
			hitS.play();
		}else {
			miss.play();
		}
		powahMeter = 0.5;
	}
	
	public function newGame() {
		chickenLife = chickenLifeMax = 200 + level * 50;
		powahMeter = 0.5;
		chickenVisible = getChickenVisibleTime();
		timeUpdateStep = 1000;
		
		replayLevel();
	}
	private function levelUp() {
		level++;
		levelUpS.play();
		replayLevel();
	}
	private function replayLevel() {
		chickenLife = chickenLifeMax = 200 + level * 25;
		time = 1000 * 60;
		timeUpdateStep = 1000;
		timeVal.text = time / 1000 + "s.";
		levelVal.text = "level "+level;
	}
	
	private function getChickenVisibleTime():Float {
		return 500*Math.random() + 400;
	}
	private function getChickenHiddenTime():Float {
		return -800 - 2000 * Math.random();
	}
	
	private inline function getPowahValue():Float {
		return 1-Math.sin(Math.PI * (powahMeter));
	}
	
	public function step() {	
		if (hitTime > 0) {
			hitTime -= Main.delta;
			if(hitted)
				splash.visible = true;
			else
				splash.visible = false;
			fist.x = Main.STAGE_W - fist.width;
			fist.y = Main.STAGE_H - fist.height+100;
		}else{
			splash.visible = false;
			fist.x = Main.STAGE_W - fist.width + 170;
			fist.y = Main.STAGE_H - fist.height+100+380;
		}
		
		if (chickenVisible >= 0) {
			chickenVisible -= Main.delta;
			if (chickenVisible <= 0)
				chickenVisible = getChickenHiddenTime();
			
			chicken.y += ((Main.STAGE_H - chicken.height * 0.6) - chicken.y) * Main.delta * 0.01;
		}else {
			chickenVisible += Main.delta;
			if (chickenVisible >= 0)
				chickenVisible = getChickenVisibleTime();
			
			chicken.y += (Main.STAGE_H+200 - chicken.y) * Main.delta * 0.01;
		}
		
		chicken.y = Math.max(Math.min(chicken.y, Main.STAGE_H+200), Main.STAGE_H - chicken.height * 0.9);
		
		if (loadPowah) {
			powahMeter += Main.delta * 0.0003;
			if (powahMeter > 1)
				powahMeter = 0;
		}
		
		chickLifeImg.width = (chickLife.width - 14) * Math.max(0, (chickenLife / chickenLifeMax));
		if (chickLifeImg.width <= 0) 
			levelUp();
		
		powahMeterImg.width = (powah.width - 14) * getPowahValue();
		
		timeUpdateStep -= Main.delta;
		if (timeUpdateStep < 0) {
			timeUpdateStep += 1000;
			time -= 1000;
			timeVal.text = time/1000 + "s.";
			
			if (time < 0) {
				restartLevel.play();
				replayLevel();
			}
		}
	}
}