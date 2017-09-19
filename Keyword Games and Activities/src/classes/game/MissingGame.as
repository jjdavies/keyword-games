package game {
	
	import flash.display.*;
	import flash.geom.Point;
	import display.ImageWizard;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	
	public class MissingGame extends MovieClip{
		
		private var loadedKeyData:Array;
		private var numberOfGames:int;
		private var numberOfImages:int;
		
		private var gameBG:GameBG;
		private var missingButton:MissingButton;
		private var displayImages:int;
		private var imageWizard:ImageWizard;
		private var gameData:Array;
		private var imgRefInd:Array;
		private var buttonStage:int;
		
		private var gameImages:Array;
		private var uniqueInts:Array;

		public function MissingGame(loadedKeyData:Array) {
			gameBG = new GameBG();
			this.addChild (gameBG);
			
			missingButton = new MissingButton();
			missingButton.scaleX = .8;
			missingButton.scaleY = .8;
			this.addChild (missingButton);
			missingButton.gotoAndStop(1);
			missingButton.addEventListener (MouseEvent.CLICK, buttonClick);
			
			this.loadedKeyData = loadedKeyData;
			this.numberOfGames = loadedKeyData[2];
			imageWizard = new ImageWizard();
			gameImages = new Array();
			imgRefInd = new Array();
			uniqueInts = new Array();
			
			for (var i:int = 0; i < numberOfGames; i++){
				if (loadedKeyData[4 + (2*i)] == 4){
					trace ('missing game is game number', i);
					this.numberOfImages = loadedKeyData[5+(i*2)][0];
					trace ('missing images count ', numberOfImages);
					gameData = loadedKeyData[5+(i*2)];
					trace ('game data ', gameData);
				}
			}
			
			for (var i:int = 0; i < numberOfImages; i++){
				//prepare images
				var imgIndex:int = gameData[i+1];
				imgRefInd.push (imgIndex);
				trace('image index ',imgIndex);
				var mc:MovieClip = imageWizard.mcMaker (loadedKeyData[3][imgIndex], new Point (140, 140));
				mc.getChildAt(0).x -= mc.getChildAt(0).width/2;
				mc.getChildAt(0).y -= mc.getChildAt(0).height/2;
				gameImages.push (mc);
			}
			
			spreadOut(false);
		}
		
		private function spreadOut(hidden:Boolean):void{
			uniqueInts = uniqueIntGenerator(gameImages.length);
			
			if (hidden){
				uniqueInts.splice (uniqueInts.length-1, 1);
			}
			for (var i:int = 0; i < uniqueInts.length; i++){
				var angle:Number = 6.2 / 8;
				var len:int = 200;
				if (i > 7) len += 120;
				/*var angle:Number = 6.2;*/
				/*var s:Shape = new Shape();
				s.graphics.lineStyle (2, 0x000000);
				s.graphics.lineTo(Math.cos(angle*i) * 230, Math.sin(angle*i) * 230);
				this.addChild (s);*/
				gameImages[uniqueInts[i]].x = Math.cos(angle*i + (angle/2)) * len;
				gameImages[uniqueInts[i]].y = Math.sin(angle*i + (angle/2)) * len;
				this.addChild (gameImages[uniqueInts[i]]);
				TweenLite.from (gameImages[uniqueInts[i]], 1 + Math.random()* 2, {x:0, y:0});
				this.addChild (missingButton);
			}
			
		}
		
		private function buttonClick (e:MouseEvent):void{
			if (buttonStage == 0){
				buttonStage = 1;
				for (var i:int = 0; i < gameImages.length; i++){
					TweenLite.to (gameImages[i], .5, {x:0, y:0, delay: spreadOut(true)});
				}
				
			} else {
				buttonStage = 0;
				for (var i:int = 0; i < gameImages.length; i++){
					TweenLite.to (gameImages[i], .5, {x:0, y:0});
				}
				spreadOut(false);
			}
		}
		
		private function uniqueIntGenerator(num:int):Array{
			var arr:Array = new Array();
			for (var i:int = 0; i < 1; i=i){
				var r:int = Math.random() * numberOfImages;
				var index:int = arr.indexOf (r);
				if (index == -1){
					arr.push (r);
				}
				if (arr.length == num){
					i=1;
				}
			}
			return arr;
		}

	}
	
}
