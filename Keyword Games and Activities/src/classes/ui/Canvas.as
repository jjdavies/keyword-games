package ui {
	
	import flash.display.*;
	import utils.GameEvent;
	import game.Coloring;
	
	public class Canvas extends MovieClip{
		
		private var transitioner:Transitioner;
		private var lessonContent:LessonContent;
		
		private var loadedKeyData:Array;
		
		//temp
		private var testLaunchURL:String = "C:/Users/1/Documents/GitHub/keyword-games/Keyword Games and Activities/aa.key";
		//

		public function Canvas(launchFileURL:String = null) {
			transitioner = new Transitioner();
			var defaultCanvasBG:CanvasBG = new CanvasBG();
			defaultCanvasBG.x = 540;
			defaultCanvasBG.y = 360;
			this.addChild (defaultCanvasBG);
			if (launchFileURL != null){
				lessonContent = new LessonContent(launchFileURL);
				transitioner.slide (defaultCanvasBG, lessonContent, "left");
			} else {
				lessonContent = new LessonContent(testLaunchURL);
				transitioner.slide (defaultCanvasBG, lessonContent, "left");
				
			}
		}
		
		public function updateLessonContent (loadedKeyData:Array):void{
			this.loadedKeyData = loadedKeyData;
			lessonContent.updateLessonContent (loadedKeyData);
			lessonContent.addEventListener (GameEvent.GAME_SELECTION, gameSelected);
		}
		
		private function gameSelected (e:GameEvent):void{
			var game:Coloring = new Coloring(loadedKeyData);
			transitioner.draw (lessonContent, game);
		}
		

	}
	
}
