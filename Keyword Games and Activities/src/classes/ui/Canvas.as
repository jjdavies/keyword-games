package ui {
	
	import flash.display.*;
	import utils.GameEvent;
	import game.*;
	
	public class Canvas extends MovieClip{
		
		private var transitioner:Transitioner;
		private var lessonContent:LessonContent;
		
		private var loadedKeyData:Array;
		
		//temp
		private var testLaunchURL:String = "C:/Users/1/Documents/GitHub/keyword-games/Keyword Games and Activities/bin/key/BF2U1L1.key";
		//C:\Users\1\Documents\GitHub\keyword-games\Keyword Games and Activities\bin\key

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
			if (e.select == "spyglass"){
				var spyglassGame:Spyglass = new Spyglass(loadedKeyData);
				transitioner.fade (lessonContent, spyglassGame, true, 0x00FF00);
			} else {
				var game2:Coloring = new Coloring(loadedKeyData);
				transitioner.draw (lessonContent, game2);
			}
			
		}
		

	}
	
}
