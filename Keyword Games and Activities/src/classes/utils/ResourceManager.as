package utils {
	
	import flash.display.*;
	import flash.filesystem.File;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import utils.GameEvent;
	
	public class ResourceManager extends EventDispatcher{
		
		private var _loadedKeyData:Array;

		public function ResourceManager(){
			_loadedKeyData = new Array();
			trace ('const');
		}
		
		public function loadKeyFile(keyURL:String):void{
			trace ('loadkeyfile');
			var file:File = new File (keyURL);
			file.addEventListener (Event.COMPLETE, parseData);
			file.load();
		}
		
		private function parseData (e:Event):void{
			//This function parses all data from a .key file, starting with the image data, then retrieving specific game data related to the images
			//Parse Images
			var keyData:Array = new Array();
			var ba:ByteArray = e.target.data;
			var lessonCode:String = ba.readUTFBytes (7);
			var availableGames:int = ba.readFloat();
			var numberOfImages:int = ba.readFloat();
			keyData.push (lessonCode, availableGames, numberOfImages);
			var imgArr:Array = new Array();
			for (var i:int = 0; i < numberOfImages; i++){
				
				var sizeOfByteArray:int = ba.readFloat();
				var imageWidth:Number = ba.readFloat();
				var imageHeight:Number = ba.readFloat();
				//trace (imageWidth, imageHeight, ba.position);
				var imgByteArray:ByteArray = new ByteArray();
				ba.readBytes (imgByteArray, 0, sizeOfByteArray);
				//create image
				var bitmapData:BitmapData = new BitmapData(imageWidth, imageHeight);
				bitmapData.setPixels (new Rectangle (0, 0, imageWidth, imageHeight), imgByteArray);
				var bitmap:Bitmap = new Bitmap(bitmapData);
				imgArr.push (bitmap);
			}
			keyData.push (imgArr);
			//Parse Images End
			//Parse Game Data
			var gameCode:int = ba.readFloat();
			switch (gameCode){
				case 0://coloring game data
					var imagesInColoring:int = ba.readFloat();
					var coloringData:Array = new Array();
					for (var i:int = 0; i < imagesInColoring; i++){
						var imgRef:int = ba.readFloat();
						var maskRef:int = ba.readFloat();
						var initPos:Point = new Point (ba.readFloat(), ba.readFloat());
						trace ('initPos', initPos);
						var targetPos:Point = new Point (ba.readFloat(), ba.readFloat());
						var initScale:Number = ba.readFloat();
						coloringData.push (new Array(imgRef, maskRef, initPos, targetPos, initScale));
						
					}
					keyData.push(gameCode, imagesInColoring, coloringData);
					_loadedKeyData = keyData;
				break;
			}
			//Parse Game Data End
			//trace ('end', _loadedKeyData);
			
			dispatchEvent (new ResourceManagerEvent(ResourceManagerEvent.KEY_LOADED, _loadedKeyData));
		}
		
		public function get loadedKeyData():Array{
			return _loadedKeyData;
		}

	}
	
}
