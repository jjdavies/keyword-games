package game {
	
	import flash.display.*;
	import display.ImageWizard;
	import utils.GameEvent;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	public class BalloonGame extends MovieClip {
		
		private var loadedKeyData:Array;
		private var numberOfImages:int;
		private var gameData:Array;
		private var imageRefs:Array;
		private var images:Array;	
		private var uniqueInts:Array;
		private var reloadButton:ReloadButton;
		private var menuButton:MenuButton;
		private var gameOptions:GameOptions;
		
		private var imageWizard:ImageWizard;
		
		private var balloons:Balloons;
		private var balloonsArr:Array;
		private var gameBG:GameBG

		public function BalloonGame(loadedKeyData:Array) {
			imageWizard = new ImageWizard();
			gameBG = new GameBG();
			this.addChild (gameBG);
			this.loadedKeyData = loadedKeyData;
			var numberOfGames:int = loadedKeyData[2];
			for (var i:int = 0; i < numberOfGames; i++){
				if (loadedKeyData[4 + (2*i)] == 3){
					this.numberOfImages = loadedKeyData[5+(i*2)][0];
					gameData = loadedKeyData[5+(i*2)];
				}
			}
			uniqueInts = new Array();
			balloons = new Balloons();
			balloons.y = 220;
			this.addChild (balloons);
			with (balloons){
				balloonsArr = new Array (b1, b2, b3, b4, b5);
			}
			imageRefs = new Array();
			images = new Array();
			for (var j:int = 0; j < numberOfImages; j++){
				imageRefs.push (gameData[j+1]);
				var mc:MovieClip = imageWizard.mcMaker (loadedKeyData[3][gameData[j+1]], new Point (190, 190));
				images.push (mc);
			}
			resetAll();
			
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
		}
		
		private function resetAll():void{
			
			uniqueInts = uniqueIntGenerator();
			for (var k:int = 0; k < 5; k++){
				//images[uniqueInts[k]].x = -500 + (200*k) + ((200 - images[uniqueInts[k]].width)/2);
				images[uniqueInts[k]].x = balloonsArr[k].x;
				images[uniqueInts[k]].y = balloonsArr[k].y;
				images[uniqueInts[k]].rotation = 14;
				balloonsArr[k].placeholder.alpha = 0;
				balloons.addChild (images[uniqueInts[k]]);
				balloons.addChild (balloonsArr[k]);
				balloonsArr[k].addEventListener (MouseEvent.CLICK, balloonClick);
			}
		}
		
		private function reload(e:MouseEvent):void{
			uniqueInts.splice(0);
			for (var i:int = 0; i < images.length; i++){
				balloons.addChild (images[i]);
				balloons.removeChild (images[i]);
			}
			for (var j:int = 0; j < 5; j++){
				if (balloonsArr[j].alpha == 0){
					balloonsArr[j].alpha = 1;
				}
			}
			resetAll();
		}
		
		private function menu(e:MouseEvent):void{
			this.addChild (gameOptions);
		}
		
		private function endGame(e:MouseEvent):void{
			this.removeChild (gameOptions);
			dispatchEvent(new GameEvent(GameEvent.END_GAME));
		}
		
		private function balloonClick (e:MouseEvent):void{
			e.currentTarget.alpha = 0;
			var index:int = balloonsArr.indexOf (e.currentTarget);
			TweenLite.to (images[uniqueInts[index]], .5, {scaleX:1.1, scaleY:1.1, onComplete:reverseTween, onCompleteParams:[images[uniqueInts[index]]]});
		}
		
		private function reverseTween (mc:MovieClip):void{
			TweenLite.to (mc, .5, {scaleX:1, scaleY:1});
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
