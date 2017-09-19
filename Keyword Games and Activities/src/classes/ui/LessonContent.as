package ui {
	
	import flash.display.MovieClip;
	import game.Coloring;
	import utils.GameEvent;
	import com.greensock.TweenLite;
	import flash.filesystem.File;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.display.Shape;
	
	public class LessonContent extends MovieClip{
		
		private var lessonContentBG:LessonContentBG;
		private var classContentTitle:ScrollTitle;
		private var gameBubbles:Array;
		

		public function LessonContent(launchFileURL:String = null) {
			lessonContentBG = new LessonContentBG();
			gameBubbles = new Array();
			this.addChild (lessonContentBG);
			this.addEventListener (Event.ADDED_TO_STAGE, addedContent);
			classContentTitle = new ScrollTitle();
			var className:String = new String();
			var launchFileArr:Array = launchFileURL.split("\\");
			className = launchFileArr[launchFileArr.length-1];
			classContentTitle.className.text = className.substr(0, 7);
			classContentTitle.y = -200;
			this.addChild (classContentTitle);
			
			if (launchFileURL != null){
				
			}
			
		}
		
		private function addedContent (e:Event):void{
			this.removeEventListener (Event.ADDED_TO_STAGE, addedContent);
			this.addEventListener (Event.REMOVED_FROM_STAGE, removedContent);
			this.lessonContentBG.play();
		}
		
		private function removedContent (e:Event):void{
			this.addEventListener (Event.ADDED_TO_STAGE, addedContent);
			this.removeEventListener (Event.REMOVED_FROM_STAGE, removedContent);
			this.lessonContentBG.stop();
		}
		
		public function updateLessonContent(loadedKeyData:Array){
			
			for (var i:int = 0; i < loadedKeyData[2]; i++){
				var bubble:BubbleForGame = new BubbleForGame();
				var gameInt:int = loadedKeyData[4 + (i*2)];
				bubble.gotoAndStop(gameInt + 1);
				gameBubbles.push (bubble);
				bubble.x = -310 + ((bubble.width + 20)*i);
				bubble.y = 50;
				this.addChild (bubble);
				TweenLite.from (bubble, 3, {x:bubble.x - 250, y:bubble.y - 250});
				bubble.addEventListener (MouseEvent.CLICK, gameClick);
			}
			
		}
		
		private function gameClick (e:MouseEvent):void{
			switch (e.currentTarget.currentFrame){
				case 1:
					dispatchEvent (new GameEvent(GameEvent.GAME_SELECTION, "coloring"));
				break;
				case 2:
					dispatchEvent (new GameEvent(GameEvent.GAME_SELECTION, "angryBugsGame"));
				break;
				case 3:
					dispatchEvent (new GameEvent(GameEvent.GAME_SELECTION, "wolf-game"));
				break;
			}
			
		}

	}
	
}
