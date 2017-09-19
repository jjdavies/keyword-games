package game {
	
	import flash.display.*;
	import display.ImageWizard;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import utils.GameEvent;
	
	public class WolfGame extends MovieClip{
		
		private var loadedKeyData:Array;
		private var gameData:Array;
		private var numberOfGames:int;
		private var numberOfImages:int;
		private var imgRefInd:Array;
		private var tiles:Array;
		private var wolfArr:Array;
		private var wolfPosition:int;
		private var imageWizard:ImageWizard;
		private var wolfBG:GameBG;
		private var gameContentContainer:MovieClip;
		private var reloadButton:ReloadButton;
		private var menuButton:MenuButton;
		private var gameOptions:GameOptions;
		
		private var gameImages:Array;
		
		private var transitioner:Transitioner;

		public function WolfGame(loadedKeyData:Array) {
			imageWizard = new ImageWizard();
			transitioner = new Transitioner();
			wolfBG = new GameBG();
			this.addChild (wolfBG);
			this.loadedKeyData = loadedKeyData;
			this.numberOfGames = loadedKeyData[2];
			for (var i:int = 0; i < numberOfGames; i++){
				if (loadedKeyData[4 + (2*i)] == 2){
					trace ('wolf game is game number', i);
					this.numberOfImages = loadedKeyData[5+(i*2)][0];
					trace ('wolf images count ', numberOfImages);
					gameData = loadedKeyData[5+(i*2)];
					trace ('game data ', gameData);
				}
			}
			
			imgRefInd = new Array();
			gameImages = new Array();
			tiles = new Array();
			wolfArr = new Array();
			
			gameContentContainer = new MovieClip();
			this.addChild (gameContentContainer);
			
			reloadButton = new ReloadButton();
			menuButton = new MenuButton();
			reloadButton.x = -75;
			menuButton.x = 75;
			reloadButton.scaleX = .5;
			reloadButton.scaleY = .5;
			menuButton.scaleX = .5;
			menuButton.scaleY = .5;
			reloadButton.y = -250;
			menuButton.y = -250;
			this.addChild (reloadButton);
			this.addChild (menuButton);
			reloadButton.addEventListener (MouseEvent.CLICK, reload);
			menuButton.addEventListener (MouseEvent.CLICK, menu);
			
			gameOptions = new GameOptions();
			gameOptions.endButton.addEventListener (MouseEvent.CLICK, endGame);
			
			for (var i:int = 0; i < numberOfImages; i++){
				//prepare images
				var imgIndex:int = gameData[i+1];
				imgRefInd.push (imgIndex);
				trace('image index ',imgIndex);
				var mc:MovieClip = imageWizard.mcMaker (loadedKeyData[3][imgIndex], new Point (186, 186));
				gameImages.push (mc);
			}
			resetGame();
			
		
		}
		
		private function reload(e:MouseEvent):void{
			wolfPosition = -1;
			gameContentContainer.removeChild (wolfArr[0]);
			wolfArr.splice(0);
			for (var i:int = 0; i < gameImages.length; i++){
				gameContentContainer.addChild (gameImages[i]);
				gameContentContainer.removeChild (gameImages[i]);
			}
			for (var j:int = 0; j < tiles.length; j++){
				gameContentContainer.removeChild (tiles[j]);
			}
			
			tiles.splice (0);
			resetGame();
		}
		
		private function menu(e:MouseEvent):void{
			this.addChild (gameOptions);
		}
		
		private function endGame(e:MouseEvent):void{
			this.removeChild (gameOptions);
			dispatchEvent(new GameEvent(GameEvent.END_GAME));
		}
			
			private function resetGame():void{
				
				var wolfIndex:int = Math.random() * 5;
				wolfPosition = wolfIndex;
				var uniqueInts:Array = uniqueIntGenerator();
				for (var j:int = 0; j < 5; j++){
					if (j == wolfIndex){
						var wolf:Wolf = new Wolf();
						wolf.x = -472 + (j * 190);
						wolf.y = 100;
						wolf.alpha = 0;
						wolfArr.push (wolf);
						gameContentContainer.addChild (wolf);
						TweenLite.to (wolf, .5, {alpha:1, delay:1});
					} else {
						gameImages[j].x = -472 + (j * 190);
						gameImages[j].y = 100;
						gameImages[j].alpha = 0;
						gameContentContainer.addChild (gameImages[j]);
						TweenLite.to (gameImages[j], .5, {alpha:1, delay:1});
					}
					var tile:BlueTile = new BlueTile();
					tile.x = -472 + (j * 190);
					tile.y = 100;
					tiles.push (tile);
					tile.addEventListener (MouseEvent.CLICK, tileClick);
					gameContentContainer.addChild (tile);
				}
			
			
		}
		
		private function tileClick (e:MouseEvent):void{
			var index:int = tiles.indexOf (e.currentTarget);
			TweenLite.to (tiles[index], .5, {alpha:0});
			if (index == wolfPosition){
				gameContentContainer.addChild (wolfArr[0]);
				TweenLite.to(wolfArr[0], 3, {scaleX: 3, scaleY: 3, x: -250, y: -200});
			}
		}
		
		private function uniqueIntGenerator():Array{
			var arr:Array = new Array();
			for (var i:int = 0; i < 1; i=i){
				var r:int = Math.random() * numberOfImages;
				var index:int = arr.indexOf (r);
				if (index == -1){
					arr.push (r);
				}
				if (arr.length == 5){
					i=1;
				}
			}
			return arr;
		}
	}
}
