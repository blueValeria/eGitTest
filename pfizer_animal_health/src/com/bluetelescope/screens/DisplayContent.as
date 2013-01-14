package com.bluetelescope.screens {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/**
	 * ...
	 * @author Ron Cunningham
	*/
	public class DisplayContent extends BaseScreen 
	{		
		private var xmlLoader:URLLoader; 	
		private var contentXMLdata:XML = new XML();	
		
		public var currentQuestionNumber:int; 
		public var currentBrand:String; 		
		private var numOfQuestions:int; 
		public var _url:String = ""; 
		
		private var headerfooter:MovieClip = new HeaderFooterLink(); 
		public var iconImage:Bitmap; 
		private var ldr:Loader; 					
								
		public function DisplayContent() 
		{
			super();									
		}
		
		public function Reset():void 
		{
			//trace("Display Reset()"); 			
			Hide(); 		
			HideAll(); 
		}
		
		public function HideAll():void 
		{
			for (var i:int = 0; i < this.numChildren; i++) {
				var obj = this.getChildAt(i); 							
				if (obj is BaseScreen) {					
					var bS:BaseScreen = obj as BaseScreen; 
					bS.Hide(); 
				}				
			}
			var aBaseScreen:BaseScreen = this.getChildByName("brandFile") as BaseScreen; 
			if(aBaseScreen){
				aBaseScreen.Hide();
			}
		}
				
		public function DisplayScreen(_name:String):void 
		{		
			//trace("DisplayContent:: displayScreen " + _name)
			var aBaseScreen:BaseScreen = this.getChildByName(_name) as BaseScreen; 
			//aBaseScreen.Display();
			aBaseScreen.TransitionIn("fadeIn"); 
			addChild(headerfooter);			
			this.addChild(iconImage); 			
		}
				
		public function LoadContent(file:String):void 
		{
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, LoadContentComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//trace("LoadContent.file: " + file); 
			xmlLoader.load(new URLRequest(_url + file));	
		}
		
		private function LoadContentComplete(e:Event):void
		{
			contentXMLdata = new XML(e.target.data);
			xmlLoader.removeEventListener(Event.COMPLETE, LoadContentComplete);				
			//how many questions
			numOfQuestions = contentXMLdata.children().length(); 					
			Init(); 
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
            trace("DisplayContent:: ioErrorHandler: " + event);
        }			
		
		private function Init():void 
		{ 
			var child:XMLList = contentXMLdata.children();
			var aBaseScreen:BaseScreen; 					
			for ( var i:int = child.length()-1; i > -1; i--)
			{
				var aXML:XML = child[i]; 
				//trace("aXML.@displayFile: " + aXML.@displayFile); 
				aBaseScreen = new BaseScreen();
				aBaseScreen.name = String(aXML.@displayFile).substr(0,-4); 
				//trace("aBaseScreen.name: " + aBaseScreen.name); 
				
				aBaseScreen.LoadFile(_url + "media/display/" + aXML.@displayFile);				
				addChild(aBaseScreen); 				
			}					
			aBaseScreen = new BaseScreen();
			aBaseScreen.LoadFile(_url + "media/display/" + contentXMLdata.@brandFile); 
			aBaseScreen.name = "brandFile"; 
			addChild(aBaseScreen); 			
		}											
		
	}

}