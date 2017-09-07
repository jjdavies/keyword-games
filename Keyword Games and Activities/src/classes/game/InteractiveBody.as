package game{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	public class InteractiveBody extends MovieClip{
		
		private var loader:Loader;

		public function InteractiveBody() {
			loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, loadComplete);
			loader.load (new URLRequest ("C:/Users/1/Documents/GitHub/keyword-games/Keyword Games and Activities/hand.swf"));
		}
		
		private function loadComplete (e:Event):void{
			trace ('load is complete');
			loader.x = -540;
			loader.y = -360;
			this.addChild (loader);
		}

	}
	
}
