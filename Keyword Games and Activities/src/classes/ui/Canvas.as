package ui {
	
	import flash.display.*;
	import utils.GameEvent;
	import game.*;
	
	public class Canvas extends MovieClip{
		
		private var transitioner:Transitioner;
		private var lessonContent:LessonContent;
		
		private var loadedKeyData:Array;
		private var currentGame:Array;
		
		//temp
		private var testLaunchURL:String = "C:/Users/1/Documents/GitHub/keyword-games/Keyword Games and Activities/bin/key/BF2U1L1.key";
		//C:\Users\1\Documents\GitHub\keyword-games\Keyword Games and Activities\bin\key

		public function Canvas(launchFileURL:String = null) {
			trace ('1');
			transitioner = new Transitioner();
			var defaultCanvasBG:CanvasBG = new CanvasBG();
			currentGame = new Array();
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
			} else if (e.select == "coloring"){
				var game2:Coloring = new Coloring(loadedKeyData);
				transitioner.fade (lessonContent, game2, false);
				game2.addEventListener (GameEvent.END_GAME, endGame);
				currentGame.push (game2);
			} else if (e.select == "interactiveBody"){
				var interactiveBody:InteractiveBody = new InteractiveBody();
				transitioner.slide (lessonContent, interactiveBody, "left");
			} else if (e.select == "wolf-game"){
				var wolfGame:WolfGame = new WolfGame(loadedKeyData);
				transitioner.fade (lessonContent, wolfGame, false);
				wolfGame.addEventListener (GameEvent.END_GAME, endGame);
				currentGame.push (wolfGame);
			} else if (e.select == "angryBugsGame"){
				//var angryBugsGame:AngryBugsGame = new AngryBugsGame(loadedKeyData);
				//transitioner.fade (lessonContent, wolfGame, false);
				//angryBugsGame.addEventListener (GameEvent.END_GAME, endGame);
				//currentGame.push (wolfGame);
			} else if (e.select == "balloon-game"){
				var balloonGame:BalloonGame = new BalloonGame(loadedKeyData);
				transitioner.fade (lessonContent, balloonGame, false);
				balloonGame.addEventListener (GameEvent.END_GAME, endGame);
				currentGame.push (balloonGame);
			} else if (e.select == "missing-game"){
				var missingGame:MissingGame = new MissingGame(loadedKeyData);
				transitioner.fade (lessonContent, missingGame, false);
				missingGame.addEventListener (GameEvent.END_GAME, endGame);
				currentGame.push (missingGame);
			}
		}
		
		private function endGame (e:GameEvent):void{
			trace ('James rules');
			trace ('unique');
			var index:int = currentGame.indexOf (e.currentTarget);
			transitioner.slide (currentGame[index], lessonContent, "up");
			currentGame.slice (0);
		}
		

	}
	
}
