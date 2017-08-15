package game {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import com.greensock.TweenLite;
	import flash.sampler.NewObjectSample;
	
	public class Coloring extends MovieClip{
		
		private var storedKeyData:Array;
		
		private var lessonCode:String;
		private var course:String;
		private var unit:int;
		private var lesson:int;
		
		private var numberOfImages:int;
		
		private var imageArr:Array;
		
		private var dataArr:Array;
		
		private var topImages:Array;
		private var topImagesGenerated:Array;
		private var maskImages:Array;
		private var maskImagesGenerated:Array;
		private var whichImageGenerated:Array;
		
		
		private var drawingLines:Array;
		private var drawingLayer:MovieClip;
		private var maskLayer:MovieClip;
		
		
		

		public function Coloring(keyData:Array) {
			topImages = new Array();
			topImagesGenerated = new Array();
			maskImages = new Array();
			maskImagesGenerated = new Array();
			drawingLines = new Array();
			whichImageGenerated = new Array();
			drawingLayer = new MovieClip();
			drawingLayer.cacheAsBitmap = true;
			maskLayer = new MovieClip();
			maskLayer.cacheAsBitmap = true;
			
			
			var bg:DrawingBG = new DrawingBG();
			this.addChild (bg);
			
			storedKeyData = keyData;
			lessonCode = storedKeyData[0];
			course = lessonCode.substring(0, 3);
			unit = int(lessonCode.substring(4, 5));
			lesson = int(lessonCode.substring(6,7));
			
			numberOfImages = storedKeyData[2];
			imageArr = new Array();
			for (var i:int = 0; i < numberOfImages; i++){
				imageArr.push (storedKeyData[3][i])
			}
			
			dataArr = storedKeyData[6];
			
			setInitialPositions();
		}
		
		private function setInitialPositions ():void{
			for (var i:int = 0; i < storedKeyData[5]; i++){
				var bmp:Bitmap = imageArr[dataArr[i][0]];
				var bmpM:Bitmap = imageArr[dataArr[i][1]];
				var bd:BitmapData = new BitmapData(bmp.width, bmp.height, true, 0x00000000);
				var bdM:BitmapData = new BitmapData(bmpM.width, bmpM.height, true, 0x00000000);
				bd.copyPixels (bmp.bitmapData, new Rectangle (0,0,bmp.width, bmp.height), new Point(0,0));
				bdM.copyPixels (bmpM.bitmapData, new Rectangle (0,0,bmpM.width, bmpM.height), new Point(0,0));
				var bmpTop:Bitmap = new Bitmap (bd);
				var bmpMask:Bitmap = new Bitmap (bdM);
				var mcTop:MovieClip = new MovieClip;
				var mcMask:MovieClip = new MovieClip;
				mcTop.addChild (bmpTop);
				mcMask.addChild (bmpMask);
				
				var origP:Point = new Point(dataArr[i][2].x - 540, dataArr[i][2].y - 360);
				var targP:Point = new Point(dataArr[i][3].x, dataArr[i][3].y);
				origP.x -= mcTop.width/2;
				origP.y -= mcTop.height/2;
				trace ('orig', origP, targP);
				
				mcTop.x = origP.x;
				mcTop.y = origP.y;
				mcMask.x = origP.x;
				mcMask.y = origP.y;
				mcTop.scaleX = dataArr[i][4];
				mcTop.scaleY = dataArr[i][4];
				mcMask.scaleX = dataArr[i][4];
				mcMask.scaleY = dataArr[i][4];
				
				topImages.push (mcTop);
				maskImages.push (mcMask);
				
				this.addChild (mcTop);
				
				mcTop.addEventListener (MouseEvent.CLICK, selectedImage);
				
				
			}
			
		}
		
		private function selectedImage(e:MouseEvent):void{
			trace ('position: ', e.currentTarget.x, e.currentTarget.y);
			var index:int = topImages.indexOf (e.currentTarget);
			generateNewImages (index);
			
		}
		
		private function generateNewImages (index:int){
			
			//preserve existing
			for (var i:int = 0; i < topImagesGenerated.length; i++){
				var pos:Point = new Point(topImagesGenerated[i].x, topImagesGenerated[i].y);
				var bdPreserve:BitmapData = new BitmapData (topImagesGenerated[i].width, topImagesGenerated[i].height, true, 0x00000000);
				var mat:Matrix = new Matrix();
				//mat.translate ((topImagesGenerated[i].x + 540)*-1, (topImagesGenerated[i].y + 360)*-1);
				var globPos:Point = this.localToGlobal (pos);
				var locPos:Point = maskLayer.globalToLocal(globPos);
				trace (pos);
				trace (globPos);
				trace (locPos);
				var tempMC:MovieClip = new MovieClip();
				tempMC.addChild (drawingLayer);
				tempMC.addChild (maskLayer);
				tempMC.addChild (topImagesGenerated[i]);
				this.addChild (tempMC);
				//mat.translate ((topImagesGenerated[i].x + 540)*-1, (topImagesGenerated[i].y + 360)*-1);
				bdPreserve.draw (tempMC, mat);
	
				
				var bmpPreserve:Bitmap = new Bitmap(bdPreserve);
				bmpPreserve.x = 300;
				this.addChild (bmpPreserve);
				
				if (whichImageGenerated[i] == index){
					// same image
				}
			}
			//
			
			
			var topIndex:int = index;
			
			
			var bmp:Bitmap = imageArr[dataArr[topIndex][0]];
			var bmpM:Bitmap = imageArr[dataArr[topIndex][1]];
			var bd:BitmapData = new BitmapData(bmp.width, bmp.height, true, 0x00000000);
			var bdM:BitmapData = new BitmapData(bmpM.width, bmpM.height, true, 0x00000000);
			bd.copyPixels (bmp.bitmapData, new Rectangle (0,0,bmp.width, bmp.height), new Point(0,0));
			bdM.copyPixels (bmpM.bitmapData, new Rectangle (0,0,bmpM.width, bmpM.height), new Point(0,0));
			var bmpTop:Bitmap = new Bitmap (bd);
			var bmpMask:Bitmap = new Bitmap (bdM);
			var mcTop:MovieClip = new MovieClip();
			var mcMask:MovieClip = new MovieClip();
			mcTop.cacheAsBitmap = true;
			mcMask.cacheAsBitmap = true;
			mcTop.addChild (bmpTop);
			mcMask.addChild (bmpMask);
			
			var origP:Point = new Point(dataArr[topIndex][2].x - 540, dataArr[topIndex][2].y - 360);
			var targP:Point = new Point(dataArr[topIndex][3].x - 540, dataArr[topIndex][3].y - 360);
			targP.x -= mcTop.width/2;
			targP.y -= mcTop.height/2;
			
			mcTop.x = origP.x/2;
			mcTop.y = origP.y/2;
			topImagesGenerated.push (mcTop);
			mcMask.x = origP.x/2;
			mcMask.y = origP.y/2;
			maskImagesGenerated.push (mcMask);
			whichImageGenerated.push (index);
			
			this.addChild (mcMask);
			maskLayer.addChild (mcMask);
			
			var s:Shape = new Shape();
			s.cacheAsBitmap = true;
			var g = s.graphics;
			g.lineStyle(50, 0xFF0000);
			
			drawingLines.push (s);
			drawingLayer.addChild (s);
			this.addChild (drawingLayer);
			this.addChild (maskLayer);
			this.addChild (mcTop);
			drawingLayer.mask = maskLayer;
			
			TweenLite.fromTo (mcMask, 2, {scaleX: dataArr[topIndex][4], scaleY: dataArr[topIndex][4]},{x: targP.x, y: targP.y, scaleX: 1, scaleY:1}); 
			TweenLite.fromTo (mcTop, 2, {scaleX: dataArr[topIndex][4], scaleY: dataArr[topIndex][4]},{x: targP.x, y: targP.y, scaleX: 1, scaleY:1, 
				onComplete: addComplete, onCompleteParams:[mcMask]});
				
			this.addEventListener (MouseEvent.MOUSE_DOWN, mouseDown);
			
		}
		
		private function addComplete (maskMC:MovieClip):void{
			
		}
		
		private function mouseDown (e:MouseEvent):void{
			drawingLines[drawingLines.length-1].graphics.moveTo (mouseX, mouseY);
			this.addEventListener (MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		private function mouseMove (e:MouseEvent):void{
			drawingLayer.mask = maskLayer;
			drawingLines[drawingLines.length-1].graphics.lineTo (mouseX, mouseY);
			
		}
		
		private function mouseUp(e:MouseEvent):void{
		
				this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				
			
		}
		
	}

}
