package display {
	
	import flash.display.*;
	import flash.geom.*;
	
	public class ImageWizard extends MovieClip{

		public function ImageWizard() {
			// constructor code
		}
		
		public function mcMaker(l:Loader, dim:Point):MovieClip{
			var loader:Loader = l;
			var dimensions:Point = dim;
			var scaleRatio:Number = ratioFinder(loader, dimensions);
			var bd:BitmapData = new BitmapData(loader.width * scaleRatio, loader.height * scaleRatio, true, 0x00000000);
			var mat:Matrix = new Matrix();
			mat.scale (scaleRatio, scaleRatio);
			bd.draw (l.content, mat);
			var bd2:BitmapData = new BitmapData(loader.width * scaleRatio, loader.height * scaleRatio, true, 0x00000000);
			bd2.copyPixels (bd, new Rectangle (0,0,loader.width * scaleRatio, loader.height * scaleRatio), new Point(0,0));
			var bmp:Bitmap = new Bitmap (bd2, "auto", true);
			var mc:MovieClip = new MovieClip();
			mc.cacheAsBitmap = true;
			mc.addChild (bmp);
			trace (mc);
			trace (mc.width, dimensions.x, scaleRatio);
			return mc;
		}
		
		private function ratioFinder (l:Loader, dim:Point):Number{
			var xDiff:Number = dim.x / l.width;
			var yDiff:Number = dim.y / l.height;
			trace ('diff', xDiff, yDiff)
			var scaleRatio:Number;
			if ((xDiff < 1)||(yDiff < 1)){
				
				if (xDiff <= yDiff){
					scaleRatio = xDiff;
				} else if (yDiff < xDiff){
					scaleRatio = yDiff;
				}
			} else if((xDiff < 1)&&(yDiff < 1)){
				scaleRatio = 0;
			}
			trace ('sr', scaleRatio);
			return scaleRatio;
		}

	}
	
}
