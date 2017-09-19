package utils {
	
	import flash.display.*;
	import flash.filesystem.File;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import utils.GameEvent;
	import flash.net.URLRequest;
	
	public class ResourceManager extends EventDispatcher{
		
		private var _loadedKeyData:Array;
		private var loaders:Array;
		private var loadComplete:int;
		private var dataLoadComplete:Boolean;
		private var localURL:String;
		

		public function ResourceManager(){
			_loadedKeyData = new Array();
			loaders = new Array();
			trace ('const');
		}
		
		public function loadKeyFile(keyURL:String):void{
			trace ('loadkeyfile');
			var file:File = new File (keyURL);
			file.addEventListener (Event.COMPLETE, parseData);
			file.load();
			
			var file2:File = File.applicationDirectory;
			localURL = new String(file2.url + "\\bin\\img\\");
		}
		
		private function parseData (e:Event):void{
			//This function parses all data from a .key file, starting with the image data, then retrieving specific game data related to the images
			//Parse Images
			var keyData:Array = new Array();
			var ba:ByteArray = e.target.data;
			var lessonCode:String = readVar(ba)[0];
			trace (lessonCode);
			var numberOfImages:int = readVar(ba)[0];
			var availableGames:int = readVar(ba)[0];
			trace ('available games: ', availableGames);
			trace ('available images: ', numberOfImages);
			keyData.push (lessonCode, numberOfImages, availableGames);
			var imgArr:Array = new Array();
			for (var i:int = 0; i < numberOfImages; i++){
				
				var l:Loader = new Loader();
				var str:String = readVar(ba)[0];
				var strArr:Array = str.split("\\");
				var str2:String = strArr[strArr.length-1];
				var str3:String = new String(localURL + str2);
				
				var url:URLRequest = new URLRequest (str3);
				l.contentLoaderInfo.addEventListener (Event.COMPLETE, loadCompleted);
				loaders.push (l);
				l.load (url);
			}
			keyData.push (loaders);
			//Parse Images End
			//Parse Game Data
			for (var j:int = 0; j < availableGames; j++){
				trace ('game parse', j);
				var gameName:String = readVar(ba)[0];
				var gameCode:int = readVar(ba)[0];
				var gameVars:int = readVar(ba)[0];
				trace ('next game is ', gameName, 'code is ', gameCode, ' gameVars: ', gameVars);
				switch (gameCode){
					case 0://coloring game data
						var imagesInColoring:int = readVar(ba)[0];
						var coloringData:Array = new Array();
						coloringData.push (imagesInColoring);
		
						for (var i:int = 0; i < imagesInColoring; i++){
							trace ('adding ', i);
							var imgRef:int = readVar(ba)[0];
							var maskRef:int = readVar(ba)[0];
							//var word:String = readVar(ba)[0];
							coloringData.push (new Array(imgRef, maskRef));
						}
						trace ('pushing to key data');
						keyData.push(gameCode, coloringData);
						trace ('added coloring game data: ', "code ", gameCode,"data",  coloringData);
						
					break;
					case 1://angry bugs game data
					var imagesInGame:int = readVar(ba)[0];
					var gameData:Array = new Array();
					gameData.push (imagesInGame);
	
					for (var i:int = 0; i < imagesInGame; i++){
						var imgRef:int = readVar(ba)[0];
						trace ('img ref', imgRef);
						gameData.push (imgRef);
					}
					keyData.push(gameCode, gameData);
					
					break;
					case 2://pairs game data
					var imagesInGame:int = readVar(ba)[0];
					trace ('images in wolf game', imagesInGame);
					var gameData:Array = new Array();
					gameData.push (imagesInGame);
	
					for (var i:int = 0; i < imagesInGame; i++){
						trace (i, 'th image');
						var imgRef:int = readVar(ba)[0];
						trace ('img ref', imgRef);
						gameData.push (imgRef);
						
					}
					keyData.push(gameCode, gameData);
					
					break;
					case 3://balloon game data
					var imagesInGame:int = readVar(ba)[0];
					var gameData:Array = new Array();
					gameData.push (imagesInGame);
	
					for (var i:int = 0; i < imagesInGame; i++){
						var imgRef:int = readVar(ba)[0];
						trace ('img ref', imgRef);
						gameData.push (imgRef);
						
					}
					keyData.push(gameCode, gameData);
					
					break;
					case 4://balloon game data
					var imagesInGame:int = readVar(ba)[0];
					var gameData:Array = new Array();
					gameData.push (imagesInGame);
	
					for (var i:int = 0; i < imagesInGame; i++){
						var imgRef:int = readVar(ba)[0];
						trace ('img ref', imgRef);
						gameData.push (imgRef);
						
					}
					keyData.push(gameCode, gameData);
					
					break;
					case 5://balloon game data
					var imagesInGame:int = readVar(ba)[0];
					var gameData:Array = new Array();
					gameData.push (imagesInGame);
	
					for (var i:int = 0; i < imagesInGame; i++){
						var imgRef:int = readVar(ba)[0];
						trace ('img ref', imgRef);
						gameData.push (imgRef);
						
					}
					keyData.push(gameCode, gameData);
					
					break;
				}
			}
			_loadedKeyData = keyData;
			//Parse Game Data End
			//trace ('end', _loadedKeyData);
			if (loadComplete == loaders.length){
				dispatchEvent (new ResourceManagerEvent(ResourceManagerEvent.KEY_LOADED, _loadedKeyData));
				
			} else {
				dataLoadComplete = true;
			}
			
		}
		
		public function get loadedKeyData():Array{
			return _loadedKeyData;
		}
		
		private function readVar (ba:ByteArray):Array{
			var arr:Array = new Array();
			var varType:int = ba.readFloat();
			trace (varType);
			if (varType == 0){
				//read number
				var num:Number = ba.readFloat();
				arr.push (num);
			} else if (varType == 1){
				//read string
				var len:int = ba.readFloat();
				var str:String = new String(ba.readUTFBytes(len));
				arr.push (str);
			}
			trace ('returning', arr[0]);
			return arr;
		}
		
		private function loadCompleted (e:Event):void{
			loadComplete++;
			if ((loadComplete == loaders.length)&&(dataLoadComplete)){
				dispatchEvent (new ResourceManagerEvent(ResourceManagerEvent.KEY_LOADED, _loadedKeyData));
				
			}
		}

	}
	
}
