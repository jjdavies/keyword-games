package game {
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.display.*;
	import flash.events.*;
	import utils.GameEvent;
	import flash.net.URLRequest;
	
	public class AngryBugsGame {
		
    private var imgArr:Array
	private var numberOfGames:int;
	private var numberOfImages:int;	
	private var gameImages:Array;
	private var objectsHit:Array;
	private var loaders:Array;
	private var sling1:Shape;
	private var sling2:Shape;
	private var gameBG:GameBG;
	private var angryBugsArr: Array;
	private var angryBugs: Array;
	
		
		public function AngryBugs(loadedKeyData:Array) {
			imgArr = new Array();
			//add at least 4 bug images into the library
			angryBugsArr = new Array(angryBug1, angryBug2, angryBug3, angryBug4);
			angryBugs = new Array();
			gameBG = new GameBG(); //add background to the library
			this.loadedKeyData = loadedKeyData;
			this.numberOfGames = loadedKeyData[2];
			this.numberOfImages = loadedKeyData[5][0];			
			gameImages = new Array();
			sling1 = new Shape();
			sling2 = new Shape();
			objectsHit = new Array();
			this.addChild (slingshot);
			sligshot.x = 400.1;
			sligshot.y = 538.85;
			this.addChild (basket); //add a basket to the library
			basket.x = 85;
			basket.y = 95.05;
			this.addChild(reset);//add a reset button to the library
			reset.x = 516.3;
			reset.y = 76.75;
			this.addChild (newBug); //add newBug button and set coordinates for it
			//newBug.x =
			//newBug.y =
			
			newBug.addEventListener(MouseEvent.MOUSE_DOWN,addNewBug);
			angryBugs.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			reset.addEventListener (MouseEvent.MOUSE_DOWN, resetGame);
			
			for (var i:int = 0; i < numberOfImages; i++){
				var imgRef:int = loadedKeyData[5][i+1][0];
				var maskRef:int = loadedKeyData[5][i+1][1];
				trace (imgRef, maskRef);
				gameImages.push(loadedKeyData[3][imgRef]);
			}
		}
		
		private function  drawSlings(e:Event):void{
			sling1.graphics.clear();
			sling2.graphics.clear();
			sling1.graphics.lineStyle (6, 0x000000);
			sling1.graphics.moveTo (464, 534.85);
			sling1.graphics.lineTo (angryBugs.x, angryBugs.y);
			this.addChild(sling1);
			sling2.graphics.lineStyle (6, 0x000000);
			sling2.graphics.moveTo (320.05, 534.85);
			sling2.graphics.lineTo (angryBugs.x, angryBugs.y);
			this.addChild(sling2);
		}
		private function collisionDet(e:Event) {
			for (var k:int = 0; k < loaders.length; k++){
			if (angryBugs.hitTestObject(loaders[k])) {
				objectsHit.push(loaders[k]);
				for (var i:int = 0; i < objectsHit.length; i++) {
				TweenLite.to (objectsHit[i], 2, {x:basket.x-40 , y:basket.y - 70});
				TweenLite.to (angryBugs, 1, {x:166.7, y:638.5});
				this.addChild (basket);
							}
						}
					}
				}
				
		private function addNewBug(e:Event):void{
		for (var i:int = 0; i < angryBugsArr.length; i++){
		angryBugs.push(angryBugsArr[Math.random()*1]);	
		angryBugs.x = 166.7;
		angryBugs.y = 638.5;
			}
		}
		
	private function mouseDown (e:Event) {
		angryBugs.startDrag();
		angryBugs.addEventListener (MouseEvent.MOUSE_UP, mouseUp);
		angryBugs.addEventListener(MouseEvent.MOUSE_MOVE, drawSlings);
		 }
		 
		private function mouseUp (e:Event){
		angryBugs.stopDrag();
		var angle=Math.atan2((529.95 - angryBugs.y),(395 - angryBugs.x))
		TweenLite.to (angryBugs, 2, {x:1080, y:296.95 + (777.95 * Math.sin(angle))});
		
		}
	
		private function resetGame(e:Event):void{
		this.removeChild(angryBugs);
		
		}	
		
	
	

	}
}