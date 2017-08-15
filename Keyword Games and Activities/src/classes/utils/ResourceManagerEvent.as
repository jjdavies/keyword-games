package utils {
	
	import flash.events.*;
	
	public class ResourceManagerEvent extends Event {
		
		public static const KEY_LOADED:String = "keyLoaded";
		public var loadedData:Array;
		

		public function ResourceManagerEvent(type:String, loadedData:Array) {
			this.loadedData = loadedData;
			super (type, true, false);
		}
		
		override public function clone ():Event{
			return new ResourceManagerEvent (type, loadedData);
		}

	}
	
}
