package  {
	
	import flash.display.*;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.events.Event;
	
	public class Transitioner extends MovieClip{
		
		private var frameCount:int;

		public function Transitioner() {
			
		}
		
		public function slide(outgoing:MovieClip, incoming:MovieClip, direction:String, onComplete:Function = null):void{
			var targetPointOutgoing:Point = new Point(0,0);
			var targetPointIncomingA:Point = new Point(0,0);
			var targetPointIncomingB:Point = new Point(0,0);
			switch (direction){
				case "left":
					targetPointOutgoing.y = outgoing.y;
					targetPointOutgoing.x = outgoing.x - 1080;
					targetPointIncomingB.y = outgoing.y;
					targetPointIncomingB.x = outgoing.x;
					targetPointIncomingA.y = outgoing.y;
					targetPointIncomingA.x = outgoing.x + 1080;
				break;
				case "right":
					targetPointOutgoing.y = outgoing.y;
					targetPointOutgoing.x = outgoing.x + 1080;
					targetPointIncomingB.y = outgoing.y;
					targetPointIncomingB.x = outgoing.x;
					targetPointIncomingA.y = outgoing.y;
					targetPointIncomingA.x = outgoing.x - 1080;
				break;
				case "up":
					targetPointOutgoing.y = outgoing.y - 720;
					targetPointOutgoing.x = outgoing.x;
					targetPointIncomingB.y = outgoing.y;
					targetPointIncomingB.x = outgoing.x;
					targetPointIncomingA.y = outgoing.y + 720;
					targetPointIncomingA.x = outgoing.x;
				break;
				case "down":
					targetPointOutgoing.y = outgoing.y + 720;
					targetPointOutgoing.x = outgoing.x;
					targetPointIncomingB.y = outgoing.y;
					targetPointIncomingB.x = outgoing.x;
					targetPointIncomingA.y = outgoing.y - 720;
					targetPointIncomingA.x = outgoing.x;
				break;
			}
			TweenLite.to (outgoing, 1, {x:targetPointOutgoing.x, y:targetPointOutgoing.y});
			if (onComplete == null){
				TweenLite.fromTo(incoming, 1, {x:targetPointIncomingA.x, y:targetPointIncomingA.y}, {x:targetPointIncomingB.x, y:targetPointIncomingB.y, onComplete:dispatchComplete});
			}else{
				TweenLite.fromTo(incoming, 1, {x:targetPointIncomingA.x, y:targetPointIncomingA.y}, {x:targetPointIncomingB.x, y:targetPointIncomingB.y, onComplete:runCompleteFunc, onCompleteParams:[onComplete]});
			}
			
			if (!incoming.parent){
				outgoing.parent.addChild (incoming);
			}
		}
		//functions fade and addIncoming are part of the fade transition
		public function fade(outgoing:MovieClip, incoming:MovieClip, fadeThroughColor:Boolean, throughColor:uint=0x000000, onComplete:Function = null):void{
			
			if (fadeThroughColor){
				var s:Shape = new Shape ();
				s.graphics.lineStyle (0,0x000000);
				s.graphics.beginFill(throughColor);
				s.graphics.drawRect(0,0,1080, 720);
				s.graphics.endFill();
				s.alpha = 0;
				outgoing.parent.addChild (s);
				TweenLite.to (s, .5, {alpha:1, onComplete:addIncoming, onCompleteParams:[outgoing, incoming, s, onComplete]});
			} else{
				incoming.x = outgoing.x;
				incoming.y = outgoing.y;
				outgoing.parent.addChild (incoming);
				if (onComplete != null){
					TweenLite.fromTo (incoming, 1, {alpha:0}, {alpha:1, onComplete:runCompleteFunc, onCompleteParams:[onComplete]});
				} else {
					TweenLite.fromTo (incoming, 1, {alpha:0}, {alpha:1, onComplete:dispatchComplete});
				}
				
			}
			
		}
		
		private function addIncoming(outgoing:MovieClip, incoming:MovieClip, shape:Shape, func:Function = null){
			incoming.x = outgoing.x;
			incoming.y = outgoing.y;
			shape.parent.addChild (incoming);
			shape.parent.addChild (shape);
			if (func != null){
				TweenLite.to (shape, .5, {alpha:0, onComplete:runCompleteFunc, onCompleteParams:[new Array(shape)]});
			} else{
				TweenLite.to (shape, .5, {alpha:0, onComplete:dispatchComplete, onCompleteParams:[new Array(shape)]});
			}
			
		}
		
		public function flip(outgoing:MovieClip, incoming:MovieClip, orientation:String, onComplete:Function = null):void{
			var scaleTarget:Point = new Point (1,1);
			if (orientation == "vertical"){
				scaleTarget.y = 0;
			} else if (orientation == "horizontal"){
				scaleTarget.x = 0;
			}
			incoming.x = outgoing.x;
			incoming.y = outgoing.y;
			outgoing.parent.addChild (incoming);
			TweenLite.to (outgoing, .5, {scaleX:scaleTarget.x, scaleY:scaleTarget.y, onComplete:resetScaling, onCompleteParams:[outgoing]});
			if (onComplete != null){
				TweenLite.fromTo (incoming, .5, {scaleX:scaleTarget.x, scaleY:scaleTarget.y}, {scaleX:1, scaleY:1, delay:.5, onComplete:runCompleteFunc, onCompleteParams:[onComplete]});
			} else {
				TweenLite.fromTo (incoming, .5, {scaleX:scaleTarget.x, scaleY:scaleTarget.y}, {scaleX:1, scaleY:1, delay:.5, onComplete:dispatchComplete});
			}
			
		}
		
		public function draw(outgoing:MovieClip, incoming:MovieClip, onComplete:Function = null):void{
			var drawingHand:DrawingHand = new DrawingHand();
			drawingHand.x = 180;
			drawingHand.y = 100;
			incoming.x = outgoing.x;
			incoming.y = outgoing.y;
			outgoing.parent.addChild (drawingHand);
			TweenLite.fromTo (drawingHand, .2, {alpha:0}, {alpha:1});
			drawingHand.gotoAndPlay(2);
			var maskShape:Shape = new Shape();
			maskShape.graphics.lineStyle (300, 0x000000, 1);
			maskShape.graphics.moveTo (0, 0);
			var bmp:Bitmap;
			incoming.cacheAsBitmap = true;
			outgoing.parent.addChild (incoming);
			//outgoing.parent.addChild (maskShape);
			var drawFunc:Function = drawMaskShape(drawingHand, maskShape, outgoing, incoming , bmp);
			drawingHand.addEventListener (Event.ENTER_FRAME, drawFunc);
		}
		
		private function drawMaskShape(drawingHand:DrawingHand, maskShape:Shape, outgoing:MovieClip, incoming:MovieClip, bmp:Bitmap):Function{
			return function(e:Event){
				frameCount++;
				if (frameCount > 45){
					frameCount = 0;
					drawingHand.removeEventListener (Event.ENTER_FRAME, arguments.callee);
					TweenLite.to (drawingHand, .2, {alpha:0, onComplete:dispatchComplete, onCompleteParams:[new Array(drawingHand)]});
					
				}
				var p:Point = new Point(drawingHand.hand.x, drawingHand.hand.y);
				var locP:Point = drawingHand.globalToLocal (p);
				var globP:Point = outgoing.parent.localToGlobal (locP);
				globP.y += 200;
				globP.x += 200;
				maskShape.graphics.lineTo (globP.x, globP.y);
				if (bmp != null){
					outgoing.parent.removeChild(bmp);
				}
				var bd:BitmapData = new BitmapData(maskShape.width, maskShape.height, true, 0x00000000);
				bd.draw (maskShape);
				bmp = new Bitmap (bd);
				bmp.cacheAsBitmap = true;
				outgoing.parent.addChild (bmp);
				outgoing.parent.addChild (drawingHand);
				incoming.mask = bmp;
			};
		}
		
		private function resetScaling(outgoing:MovieClip):void{
			TweenLite.to (outgoing, .5, {scaleX:1, scaleY:1});
		}
		
		private function runCompleteFunc(func:Function, itemsToRemove:Array = null):void{
			func();
			dispatchEvent (new TransitionEvent(TransitionEvent.TRANSITION_COMPLETE));
			if (itemsToRemove != null){
				for (var i:int = 0; i < itemsToRemove.length; i++){
					itemsToRemove[i].parent.removeChild (itemsToRemove[i]);
				}
			}
		}
		
		private function dispatchComplete (itemsToRemove:Array = null):void{
			dispatchEvent (new TransitionEvent(TransitionEvent.TRANSITION_COMPLETE));
			if (itemsToRemove != null){
				for (var i:int = 0; i < itemsToRemove.length; i++){
					itemsToRemove[i].parent.removeChild (itemsToRemove[i]);
				}
			}
		}

	}
	
}
