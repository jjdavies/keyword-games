package  {
	
	import flash.events.*;
	
	public class TransitionEvent extends Event{
		
		public static const TRANSITION_COMPLETE:String = "transitionComplete";

		public function TransitionEvent(type:String) {
			super (type, true, false);
		}
		
		override public function clone():Event{
			return new TransitionEvent(type);
		}

	}
	
}
