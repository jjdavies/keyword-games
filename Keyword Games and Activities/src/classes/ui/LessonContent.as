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
		private var gameBubbles:Array;
		

		public function LessonContent(launchFileURL:String = null) {
			lessonContentBG = new LessonContentBG();
			gameBubbles = new Array();
			this.addChild (lessonContentBG);
			
			if (launchFileURL != null){
				
			}
			trace ('lesson content');
			
		}
		
		public function updateLessonContent(loadedKeyData:Array){
			
			trace ('activities available', loadedKeyData[2]);
			
			for (var i:int = 0; i < loadedKeyData[2]; i++){
				var bubble:BubbleForGame = new BubbleForGame();
				gameBubbles.push (bubble);
				bubble.x = -310 + ((bubble.width + 20)*i);
				bubble.y = 50;
				this.addChild (bubble);
				TweenLite.from (bubble, 3, {x:bubble.x - 250, y:bubble.y - 250});
				bubble.addEventListener (MouseEvent.CLICK, gameClick);
			}
			
			
		}
		
		private function gameClick (e:MouseEvent):void{
			dispatchEvent (new GameEvent(GameEvent.GAME_SELECTION, "coloring"));
		}
		
		private function gameClick2 (e:MouseEvent):void{
			dispatchEvent (new GameEvent(GameEvent.GAME_SELECTION, "spyglass"));
		}

	}
	
}
