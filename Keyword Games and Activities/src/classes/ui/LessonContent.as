package ui {
	
	import flash.display.MovieClip;
	import game.Coloring;
	import utils.GameEvent;
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
		

		public function LessonContent(launchFileURL:String = null) {
			lessonContentBG = new LessonContentBG();
			this.addChild (lessonContentBG);
			
			if (launchFileURL != null){
				
			}
			trace ('lesson content');
			
		}
		
		public function updateLessonContent(loadedKeyData:Array){
			
			trace ('activities available', loadedKeyData.length-1);
			
			for (var i:int = 0; i < loadedKeyData.length-1; i++){
				var s:Shape = new Shape ();
				s.graphics.lineStyle(2, 0xFF00FF);
				s.graphics.beginFill (0xDDDDDD);
				s.graphics.drawRect(0,0,100,50);
				s.graphics.endFill();
				var mc:MovieClip = new MovieClip();
				mc.addChild (s);
				this.addChild (mc);
				mc.addEventListener (MouseEvent.CLICK, gameClick);
			}
		}
		
		private function gameClick (e:MouseEvent):void{
			dispatchEvent (new GameEvent(GameEvent.GAME_SELECTION, "coloring"));
		}

	}
	
}
