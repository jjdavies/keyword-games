package utils {
	
	import flash.display.*;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import flash.filesystem.*;
	import flash.geom.Matrix;

	
	public class FilePacker extends MovieClip{

		public function FilePacker(fileOrder:Array, lessonCode:String, initArr:Array) {
			var submittedFileOrder:Array = fileOrder;
			var packedByteArray:ByteArray = new ByteArray();
			packedByteArray.writeUTFBytes(lessonCode);
			packedByteArray.writeFloat(0);
			packedByteArray.writeFloat(submittedFileOrder.length);
			for (var i:int = 0; i < submittedFileOrder.length; i++){
				var imageWidth:int = submittedFileOrder[i].width;
				var imageHeight:int = submittedFileOrder[i].height;
				var bitmapData:BitmapData = new BitmapData (imageWidth, imageHeight,true, 0x00000000);
				var matrix:Matrix = new Matrix();
				matrix.translate (imageWidth/2, imageHeight/2);
				bitmapData.draw(submittedFileOrder[i], matrix);
				//var imageByteArray:ByteArray = new ByteArray();
				//imageByteArray.writeBytes(bitmapData);
				var imageByteArray:ByteArray = bitmapData.getPixels (new Rectangle(0, 0, imageWidth, imageHeight));
				packedByteArray.writeFloat(imageByteArray.length);
				packedByteArray.writeFloat(imageWidth);
				packedByteArray.writeFloat(imageHeight);
				trace (imageWidth, imageHeight, packedByteArray.length);
				packedByteArray.writeBytes (imageByteArray);
				trace (packedByteArray.length);
				
			
			}
			trace (packedByteArray.length);
			var file:File = new File ("C:/Users/asua/Documents/GitHub/keyword-games/Keyword Games and Activities/BF1U1L1.key");
			var fileStream:FileStream = new FileStream();
			//fileStream.addEventListener (Event.CLOSE, fileSaved);
			fileStream.openAsync (file, FileMode.WRITE);
			fileStream.writeBytes (packedByteArray, 0, packedByteArray.length);
			
			//coloring game data
			var coloringGameBA:ByteArray = new ByteArray();
			coloringGameBA.writeFloat(0);
			coloringGameBA.writeFloat (3);
			//img0
			coloringGameBA.writeFloat(0);//img ref
			coloringGameBA.writeFloat(1);//img mask ref
			coloringGameBA.writeFloat(initArr[0].x);//init x
			coloringGameBA.writeFloat(initArr[0].y);//init y
			coloringGameBA.writeFloat(fileOrder[0].x);//target x
			coloringGameBA.writeFloat(fileOrder[0].y);//target y
			coloringGameBA.writeFloat(.5);//init scale
			//
			//img1
			coloringGameBA.writeFloat(2);//img ref
			coloringGameBA.writeFloat(3);//img mask ref
			coloringGameBA.writeFloat(initArr[1].x);//init x
			coloringGameBA.writeFloat(initArr[1].y);//init y
			coloringGameBA.writeFloat(fileOrder[2].x);//target x
			coloringGameBA.writeFloat(fileOrder[2].y);//target y
			coloringGameBA.writeFloat(.5);//init scale
			//
			//img1
			coloringGameBA.writeFloat(4);//img ref
			coloringGameBA.writeFloat(5);//img mask ref
			coloringGameBA.writeFloat(initArr[2].x);//init x
			coloringGameBA.writeFloat(initArr[2].y);//init y
			coloringGameBA.writeFloat(fileOrder[4].x);//target x
			coloringGameBA.writeFloat(fileOrder[4].y);//target y
			coloringGameBA.writeFloat(.3);//init scale
			//
			fileStream.writeBytes(coloringGameBA, 0, coloringGameBA.length);
			fileStream.close();
		}

	}
	
}
