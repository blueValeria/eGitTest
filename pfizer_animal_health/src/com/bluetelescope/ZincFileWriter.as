package com.bluetelescope 
{
	import adobe.utils.CustomActions;
	import flash.display.*;	
	import flash.events.*;
	import flash.system.Capabilities;
	import mdm.*; 
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class ZincFileWriter extends Sprite
	{
		public static var dateFolder:String;
		public static var btFolder:String = "C:\\blue-telescope\\";
		public static var myDate:Date; 
		
		
		public static function writeDrawingFile(fileName:String, data:String) : void {						
			trace("ZincFileWriter:: writeDrawingFile")
			myDate = new Date();					
			dateFolder = btFolder + String(myDate.month +1) + "_" + myDate.date + "_" + myDate.fullYear + "\\"; 				
			//trace("dateFolder: " + dateFolder); 			
			var exists:Boolean = mdm.FileSystem.folderExists(dateFolder);
			if (!exists) {
				mdm.FileSystem.makeFolder(dateFolder); 
			}						
			var aFile:String = dateFolder + "/" + fileName +".txt"; 
			//trace("aFile: " + aFile);						
			mdm.FileSystem.saveFile(aFile, data);
		}
		
	}

}

