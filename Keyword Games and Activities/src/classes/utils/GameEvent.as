package utils {
	
	import flash.events.*;
	
	public class GameEvent extends Event {
		
		public static const RETRIEVE_GAMES:String = "retrieveGames";
		public static const GAME_SELECTION:String = "gameSelection";
		public static const END_GAME:String = "endGame";
		public var select:String;
		

		public function GameEvent(type:String, select:String = null) {
			this.select = select;
			super (type, true, false);
		}
		
		
		override public function clone():Event{
			return new GameEvent (type, select);
		}

	}
	
}
