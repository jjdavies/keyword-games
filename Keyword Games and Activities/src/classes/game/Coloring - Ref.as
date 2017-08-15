package game {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class Coloring extends MovieClip{
		
		private var topItems:Array;
		private var maskItems:Array;
		private var initPos:Array;
		private var targetPos:Array;
		private var initScale:Array;
		
		private var initImages:Array;
		
		

		public function Coloring(coloringData:Array, imgArr:Array) {
			topItems = new Array();
			maskItems = new Array();
			initPos = new Array();
			targetPos = new Array();
			initImages = new Array();
			var numOfImages:int = coloringData.length-1;
			for (var i:int = 1; i < numOfImages+1; i++){
				trace ('n', i);
				trace (imgArr[coloringData[i][0]].width);
				var mc:MovieClip = new MovieClip();//top
				mc.addChild (imgArr[coloringData[i][0]]);
				trace ('mc', mc.width);
				
				var mcm:MovieClip = new MovieClip();//mask
				mcm.addChild (imgArr[coloringData[i][1]]);
				var p:Point = new Point (coloringData[i][2].x, coloringData[i][2].y);
				trace ('p', p);
				var p2:Point = new Point (imgArr[coloringData[i][3]]);
				
				topItems.push (mc);
				maskItems.push (mcm);
				initPos.push (p);
				targetPos.push (p2);
			}
			prepareInitImages();
			
		}
		
		private function prepareInitImages():void{
			for (var i:int = 0; i < topItems.length; i++){
				trace (i);
				trace (topItems[0].width, topItems[0].height, true, 0x000000);
				var bd:BitmapData = new BitmapData(topItems[i].width, topItems[i].height, true, 0x00000000);
				var mat:Matrix = new Matrix();
				//mat.translate (topItems[i].width/2, topItems[i].height/2);
				mat.scale (.5, .5);
				bd.draw (topItems[i], mat);
				var bmp:Bitmap = new Bitmap(bd);
				var mc:MovieClip = new MovieClip();
				mc.addChild (bmp);
				mc.x = initPos[i].x;
				mc.y = initPos[i].y;
				mc.addEventListener (MouseEvent.CLICK, initImageClicked);
				this.addChild (mc);
				trace (mc.x, mc.y);
				initImages.push (mc);
			}
		}
		
		private function initImageClicked (e:MouseEvent):void{
			
		}

	}
	
}
