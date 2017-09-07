package game {
	
	import flash.display.*;
	import flash.geom.Point;
	import display.ImageWizard;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import utils.GameEvent;
	
	public class Coloring extends MovieClip{
		
		private var loadedKeyData:Array;
		private var numberOfGames:int;
		private var numberOfImages:int;
		private var imgRefInd:Array;
		private var imgMaskInd:Array;
		private var imageWizard:ImageWizard;
		private var drawingBG:GameBG;
		private var gameOptions:GameOptions;
		
		private var gameImages:Array;
		private var gameMasks:Array;
		private var shapes:Array;
		private var maskLayer:MovieClip;
		private var shapeLayer:MovieClip;
		
		private var crayons:Crayons;
		private var crayonsArr:Array;
		
		private var currentColor:uint;
		private var transitioner:Transitioner;
		
		private var reloadButton:ReloadButton;
		private var menuButton:MenuButton;

		public function Coloring(loadedKeyData:Array){
			transitioner = new Transitioner();
			drawingBG = new GameBG();
			this.addChild (drawingBG);
			this.loadedKeyData = loadedKeyData;
			this.numberOfGames = loadedKeyData[2];
			this.numberOfImages = loadedKeyData[5][0];
			currentColor = 0xFFFFFF;
			imgRefInd = new Array();
			imgMaskInd = new Array();
			
			gameImages = new Array();
			gameMasks = new Array();
			shapes = new Array();
			
			maskLayer = new MovieClip();
			maskLayer.cacheAsBitmap = true;
			shapeLayer = new MovieClip();
			shapeLayer.cacheAsBitmap = true;
			
			crayons = new Crayons();
			crayons.y = - crayons.height/2;
			this.addChild (crayons);
			
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
			reloadButton.addEventListener (MouseEvent.CLICK, reloadAll);
			menuButton.addEventListener (MouseEvent.CLICK, menu);
			
			gameOptions = new GameOptions();
			gameOptions.endButton.addEventListener (MouseEvent.CLICK, endGame);
			
			
			
			with (crayons){
				crayonsArr = new Array(red, yellow, blue, green, orange, purple, brown, pink, black, white);
			}
			TweenLite.to (crayonsArr[9], .5, {y: -30});
			for (var c:int = 0; c < crayonsArr.length; c++){
				crayonsArr[c].addEventListener (MouseEvent.CLICK, crayonClick);
			}
			
			for (var i:int = 0; i < numberOfImages; i++){
				var imgRef:int = loadedKeyData[5][i+1][0];
				var maskRef:int = loadedKeyData[5][i+1][1];
				trace (imgRef, maskRef);
				
				
				gameImages.push(loadedKeyData[3][imgRef]);
				
				gameMasks.push(loadedKeyData[3][maskRef]);
			}
			
			imageWizard = new ImageWizard();
			
			prepareImages();
			this.addEventListener (MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		private function reloadAll(e:MouseEvent):void{
			transitioner.draw (this, this);
			for (var i:int = 0; i < shapes.length; i++){
				shapes[i].graphics.clear();
			}
			
		}
		
		private function menu(e:MouseEvent):void{
			this.addChild (gameOptions);
		}
		
		private function endGame (e:MouseEvent):void{
			this.removeChild (gameOptions);
			dispatchEvent(new GameEvent(GameEvent.END_GAME));
		}
		
		private function crayonClick (e:MouseEvent):void{
			var index:int = crayonsArr.indexOf (e.currentTarget);
			for (var i:int = 0; i < crayonsArr.length; i++){
				if (i!=index){
					TweenLite.to (crayonsArr[i], .5, {y:0});
				} 
			}
			TweenLite.to (crayonsArr[index], .5, {y: -30});
			switch (index){
				case 0:
					currentColor = 0xFF0000;
				break;
				case 1:
					currentColor = 0xFCEE21;
				break;
				case 2:
					currentColor = 0x0071BC;
				break;
				case 3:
					currentColor = 0x009245;
				break;
				case 4:
					currentColor = 0xF7931E;
				break;
				case 5:
					currentColor = 0x7C3AB5;
				break;
				case 6:
					currentColor = 0xA67C52;
				break;
				case 7:
					currentColor = 0xFF7BAC;
				break;
				case 8:
					currentColor = 0x000000;
				break;
				case 9:
					currentColor = 0xFFFFFF;
				break;
				
			}
		}
		
		private function mouseDown (e:MouseEvent){
			if (mouseY > 0){
				var s:Shape = new Shape();
				s.cacheAsBitmap = true;
				s.graphics.lineStyle (50, currentColor);
				s.graphics.moveTo (mouseX, mouseY);
				shapeLayer.addChild (s);
				this.addChild (shapeLayer);
				this.addChild (maskLayer);
				shapeLayer.mask = maskLayer;
				for (var i:int = 0; i < numberOfImages; i++){
					this.addChild (gameImages[i]);
				}
				shapes.push (s);
				this.addEventListener (MouseEvent.MOUSE_MOVE, mouseMove);
				this.addEventListener (MouseEvent.MOUSE_UP, mouseUp);
			} 
		}
		
		private function mouseMove (e:MouseEvent):void{
			shapes[shapes.length-1].graphics.lineTo (mouseX, mouseY);
			trace (shapes.length);
		}
		
		private function mouseUp (e:MouseEvent):void{
			this.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		private function prepareImages():void{
			trace (numberOfImages);
			var imageDimensions:Point = new Point(0,0);
			switch (numberOfImages){
				case 1:
					imageDimensions.x = 270;
					imageDimensions.y = 270;
				break;
				case 2:
					imageDimensions.x = 270;
					imageDimensions.y = 270;
				break;
				case 3:
					imageDimensions.x = 270;
					imageDimensions.y = 270;
				break;
				case 4:
					imageDimensions.x = 270;
					imageDimensions.y = 270;
				break;
				case 5:
					imageDimensions.x = 270;
					imageDimensions.y = 270;
				break;
			}
			for (var i:int = 0; i < numberOfImages; i++){
				var mc:MovieClip = imageWizard.mcMaker(gameImages[i], imageDimensions);
				mc.cacheAsBitmap = true;
				var mc2:MovieClip = imageWizard.mcMaker(gameMasks[i], imageDimensions);
				mc2.cacheAsBitmap = true;
				gameImages[i] = mc;
				gameMasks[i] = mc2;
				var totalWidth:int = imageDimensions.x * numberOfImages;
				var divisions:int = numberOfImages + 1;
				var divWidth:int = (1080 - totalWidth)/divisions;
				gameImages[i].x = divWidth + (divWidth*i) + (imageDimensions.x*i) + ((imageDimensions.x - gameImages[i].width)/2) - 540;
				gameImages[i].y = ((imageDimensions.y - gameImages[i].height)/2);
				gameMasks[i].x = divWidth + (divWidth*i) + (imageDimensions.x*i) + ((imageDimensions.x - gameImages[i].width)/2) - 540;
				gameMasks[i].y = ((imageDimensions.y - gameImages[i].height)/2);
				this.addChild (gameImages[i]);
				maskLayer.addChild (gameMasks[i]);
			}
			
			
			
		}

	}
	
}
