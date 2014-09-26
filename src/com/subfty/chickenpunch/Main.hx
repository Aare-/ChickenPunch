package com.subfty.chickenpunch;

import com.subfty.sub.display.ImgSprite;
import com.subfty.sub.helpers.FixedAspectRatio;
import nme.Assets;
import nme.display.Sprite;
import nme.display.Stage;
import nme.events.Event;
import nme.Lib;
import nme.media.Sound;

/**
 * ...
 * @author Filip Loster
 */

class Main extends Sprite {
	
	public static var STAGE_W:Int = 720;
	public static var STAGE_H:Int = 720;
	//public static var STAGE_W:Int = 768;
	//public static var STAGE_H:Int = 1280;
									
	public static var aspect:FixedAspectRatio;
	
  //TIMER
	private static var prevFrame:Int = -1;
	public static var delta:Int = 0;
	
  //SCENES
	var game:Game;
  
	public function new() {
		super();
		
		aspect = new FixedAspectRatio(this, STAGE_W, STAGE_H);		

		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
	  //INITIATION
		var stage:Stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		game = new Game(this);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, step);
	}
	
	static public function main() {
		Lib.current.addChild(new Main());
	}
	
	private function init(e) {
		aspect.fix(null);
	}
	
	function step(e:Event) {
	  //CALCULATING DELTA
		if (prevFrame < 0) prevFrame = Lib.getTimer();
		delta = Lib.getTimer() - prevFrame;
		prevFrame = Lib.getTimer();

		game.step();
	}
}