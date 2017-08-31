package game{
	
	import flash.display.*;
	import flash.events.*;
	import display.ImageWizard;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	
	public class Spyglass extends MovieClip{
		
		private var bg:SpyglassBG;
		private var numOfImages:int;
		private var imageArr:Array;
		private var chosenImage:int;
		private var maskLayer:MovieClip;

		public function Spyglass(loadedKeyData:Array) {
			bg = new SpyglassBG();
			this.addChild (bg);
			imageArr = new Array();
			maskLayer = new MovieClip();
			
			
			numOfImages = loadedKeyData[5][0];
			for (var i:int = 0; i < numOfImages; i++){
				trace ('blah', loadedKeyData[5][i+1]);
				var ref:int = loadedKeyData[5][i+1];
				var l:Loader = loadedKeyData[3][ref];
				trace (l.width, l.height);
				var imageWizard:ImageWizard  = new ImageWizard();
				
				var mc:MovieClip = imageWizard.mcMaker (l, new Point (400, 400));
				mc.x -= mc.width / 2;
				mc.y -= mc.height / 2;
				imageArr.push (mc);
				
				
			}
			var rand:int = Math.random() * 4;
			chosenImage = rand;
			this.addChild (imageArr[rand]);
			makeShape();
			trace (stage);
			this.addEventListener (Event.ADDED_TO_STAGE, added);
		}
		
		private function added (e:Event):void{
			trace  (stage);
		}
		
		private function makeShape():void{
			var rand:int = Math.random() * 1;
			switch (rand){
				case 0:
					var s:Shape = new Shape ();
				s.graphics.lineStyle (0, 0x000000);
				s.graphics.beginFill (0x000000);
				s.graphics.drawCircle(0, 0, 20);
				s.graphics.endFill();
				maskLayer.addChild (s);
				
				this.addChild (maskLayer);
				this.addEventListener (MouseEvent.MOUSE_MOVE, mouseMove);
				imageArr[chosenImage].mask = maskLayer;
				break;
			}
		}
		
		private function mouseMove (e:MouseEvent):void{
			maskLayer.x = mouseX;
			maskLayer.y = mouseY;
			imageArr[chosenImage].mask = maskLayer;
		}

	}
	
}
