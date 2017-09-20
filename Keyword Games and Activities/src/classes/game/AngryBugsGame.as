package game {
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.display.*;
	import flash.events.*;
	import utils.GameEvent;
	import flash.net.URLRequest;
	import display.ImageWizard;
	import flash.geom.Point;
	
	public class AngryBugsGame extends MovieClip {
	private var imageRefs:Array;
	private var loadedKeyData:Array;	
    private var imgArr:Array
	private var numberOfGames:int;
	private var numberOfImages:int;	
	private var gameImages:Array;
	private var gameData:Array;
	private var objectsHit:Array;
	private var loaders:Array;
	private var sling1:Shape;
	private var sling2:Shape;
	private var gameBG:GameBG;
	private var angryBugsArr: Array;
	private var angryBugs: MovieClip;
	private var imageWizard:ImageWizard;
	private var images:Array;
	private var uniqueInts:Array;
	private var basket:Basket;
	private var gameOptions:GameOptions;
	private var menuButton:MenuButton;
	private var reloadButton:ReloadButton;
	
		
		public function AngryBugsGame(loadedKeyData:Array) {
			imageWizard = new ImageWizard();
			imageRefs = new Array();
			imgArr = new Array();
			images = new Array();
			gameOptions = new GameOptions();
			menuButton = new MenuButton();
			reloadButton = new ReloadButton();
			//add at least 4 bug images into the library
			var bug1 = new Bug1();
			var slingshot = new Slingshot();
			basket = new Basket();
			var newBug = new NewBug();
			angryBugsArr = new Array(bug1);
			angryBugs = new MovieClip;
			gameBG = new GameBG(); 
			this.addChild(gameBG);
			this.loadedKeyData = loadedKeyData;
			this.numberOfGames = loadedKeyData[2];
				for (var i:int = 0; i < numberOfGames; i++){
					if (loadedKeyData[4+(2*i)]== 1){
					this.numberOfImages = loadedKeyData[5+(2*i)][0];	
					gameData = loadedKeyData[5+(2*i)];
					}
				}
			gameImages = new Array();
			sling1 = new Shape();
			sling2 = new Shape();
			objectsHit = new Array();
			this.addChild (slingshot);
			slingshot.scaleX = 1.5; 
			slingshot.scaleY = 1.5; 
			slingshot.x = -240;
			slingshot.y = 170;
			this.addChild (reloadButton);
			reloadButton.x = -20;
			reloadButton.y = -251;
			reloadButton.scaleX = .5;
			reloadButton.scaleY = .5;
			this.addChild (menuButton);
			menuButton.x = 80;
			menuButton.y = -251;
			menuButton.scaleX = .5;
			menuButton.scaleY = .5;
			this.addChild (newBug); //add newBug button and set coordinates for it
			newBug.x = -265;
			newBug.y = 70;
			
			
			reloadButton.addEventListener (MouseEvent.CLICK, resetGame);
			menuButton.addEventListener (MouseEvent.CLICK, menu);
			gameOptions.endButton.addEventListener (MouseEvent.CLICK, endGame);
			newBug.addEventListener(MouseEvent.MOUSE_DOWN,addNewBug);
			
			
			
			
			
			
				
			
			
			for (var j:int = 0; j < numberOfImages; j++){
				imageRefs.push (gameData[j+1]);
				var mc:MovieClip = imageWizard.mcMaker (loadedKeyData[3][gameData[j+1]], new Point (90,90));
				images.push(mc);
				trace (mc);
			}
		}
		
		private function menu(e:MouseEvent):void {
			this.addChild (gameOptions);
		}
		
		private function endGame(e:MouseEvent):void {
			this.removeChild (gameOptions);
			dispatchEvent(new GameEvent(GameEvent.END_GAME));
		}
		
		
		private function  drawSlings(e:Event):void{
			sling1.graphics.clear();
			sling2.graphics.clear();
			sling1.graphics.lineStyle (6, 0x000000);
			sling1.graphics.moveTo (-190,170);
			sling1.graphics.lineTo (angryBugs.x, angryBugs.y);
			this.addChild(sling1);
			sling2.graphics.lineStyle (6, 0x000000);
			sling2.graphics.moveTo (-290, 170);
			sling2.graphics.lineTo (angryBugs.x, angryBugs.y);
			this.addChild(sling2);
		}
		private function collisionDet(e:Event) {
			for (var k:int = 0; k < images.length; k++){
			if (angryBugs.hitTestObject(images[uniqueInts[k]])) {
				objectsHit.push(images[uniqueInts[k]]);
				for (var i:int = 0; i < objectsHit.length; i++) {
				TweenLite.to (objectsHit[i], 2, {x:-265-40 , y:-133 - 70, rotation:1440});
				
				
							}
						}
					}
				}
				
		private function addNewBug(e:Event):void{
		for (var i:int = 0; i < angryBugsArr.length; i++){
		angryBugs.addChild(angryBugsArr[i*Math.random()]);
		this.addChild(angryBugs);		
		angryBugs.scaleX = .7;
		angryBugs.scaleY = .7;
		angryBugs.x = -424;
		angryBugs.y =200;
		angryBugs.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);	
				}
			
		}
		
	private function mouseDown (e:Event) {
		angryBugs.startDrag();
		angryBugs.addEventListener (MouseEvent.MOUSE_UP, mouseUp);
		angryBugs.addEventListener(MouseEvent.MOUSE_MOVE, drawSlings);
		 }
		 
		private function mouseUp (e:Event){
		angryBugs.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		angryBugs.removeEventListener(MouseEvent.MOUSE_MOVE, drawSlings);
		angryBugs.stopDrag();
		var angle=Math.atan2((202 - angryBugs.y),(-245 - angryBugs.x))
		TweenLite.to (angryBugs, 1, {x:550, y:-31 + (449 * Math.sin(angle))});
		sling1.graphics.clear();
		sling2.graphics.clear();
		
		}
	
		private function resetGame(e:Event):void{
		uniqueInts = uniqueIntsGenerator();
			for (var k:int = 0; k < 3; k++){
			this.addChild(images[uniqueInts[k]]);
			this.addEventListener(Event.ENTER_FRAME,collisionDet);
			images[uniqueInts[k]].x = 300;
			images[uniqueInts[k]].y = - 300 + 220*k;
			objectsHit.length = 0;
				}	
			this.addChild(basket); 
			basket.scaleX = 2;
			basket.scaleY = 2;
			basket.x = -265;
			basket.y = -133;
		}	
		
		private function uniqueIntsGenerator():Array {
			var arr:Array = new Array();
			for (var i:int = 0; i < 1; i=i){
				var r:int = Math.random() * numberOfImages;
				var index:int = arr.indexOf(r);
				trace (r);
				if (index == -1){
					arr.push(r);
				}
				if (arr.length == 3){
					i = 1;
				}
			}
			return arr;
			
		}
	
	

	}
}