package ui {
	
	import flash.display.*;
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	
	import utils.FilePacker;
	import utils.ResourceManager;
	import utils.ResourceManagerEvent;
	import utils.GameEvent;
	
	public class Document extends MovieClip{
		
		private var canvas:Canvas;
		private var resourceManager:ResourceManager;
		//temp
		private var testLaunchURL:String = "C:/Users/1/Documents/GitHub/keyword-games/Keyword Games and Activities/bin/key/BF1U1L1.key";
		//

		public function Document() {
			
			
			//var filePacker:FilePacker = new FilePacker(new Array(apple, appleMask, caterpillar, caterpillarMask, watermelon, watermelonMask), "BF1U1L5", new Array(appleInit, caterpillarInit, watermelonInit));
			NativeApplication.nativeApplication.addEventListener (InvokeEvent.INVOKE, onInvokeEvent);
			resourceManager = new ResourceManager();
			resourceManager.addEventListener (ResourceManagerEvent.KEY_LOADED, keyFileLoadComplete);
		}
		
		private function onInvokeEvent(e:InvokeEvent):void{
			//check if src contains .key file extension
			if (e.arguments[0] == undefined){
				//not launched from file
				canvas = new Canvas(testLaunchURL);
				resourceManager.loadKeyFile(testLaunchURL);
			} else {
				var sourceString:String = e.arguments[0].toString();
				if (sourceString.indexOf (".key") != -1){
					//launched from associated .key file
					canvas = new Canvas(sourceString);
					resourceManager.loadKeyFile(sourceString);
					
					
				} else {
					//not launched from associated .key file
					//canvas = new Canvas();
					
				}
			}
			
			this.addChild (canvas);
			canvas.mask = maskAll;
		}
		
		private function keyFileLoadComplete(e:ResourceManagerEvent):void{
			trace (e.loadedData);
			canvas.updateLessonContent(e.loadedData);
		}

	}
	
}
