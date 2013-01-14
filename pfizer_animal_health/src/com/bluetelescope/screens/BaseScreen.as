package com.bluetelescope.screens {
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.DisplayShortcuts;

	import com.bluetelescope.CustomEvent;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class BaseScreen extends MovieClip
	{
		private var ldr:Loader;	
		public var isSWF:Boolean = false; 
		public var fileType:String; 
		public var mc:MovieClip; 
		 
		 
		public function BaseScreen() 
		{
			alpha = 0; 
			visible = false; 
			DisplayShortcuts.init(); 							
			//name = _name;									
			//trace("new BaseScreen: " + name); 		
		}
		public function setName(_name:String):void 
		{
			name = _name; 
		}
		
		public function LoadFile(_file:String) 
		{			
			//trace("BaseScreen.LoadFile: " + _file); 
			if (_file.indexOf("swf") > -1) {
				//trace("we have a swf file"); 
				fileType = "swf"; 				
			}			
			ldr = new Loader();
			ldr.load(new URLRequest(_file)); 
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, LoadComplete);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			
			addChild(ldr);		
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
            trace("BaseScreen:: ioErrorHandler: " + event);
        }
		private function LoadComplete(event:Event):void
		{
			//trace("BaseScreen.LoadFileComplete");
			ldr.removeEventListener(Event.COMPLETE, LoadComplete);				
			//test to see what is the file					
			if(fileType == "swf"){
				mc = MovieClip(ldr.content);
			}
		}		
		
		public function TransitionOut(action:String):void 
		{			
			if(fileType != "swf"){
				Tweener.addTween(this, { _autoAlpha:0, time:1, onComplete:TransitionOutComplete } ); 
			}else {
				Display(); 
			}
		}
		
		public function TransitionIn(action:String, broadcastDone:Boolean = false ):void 
		{			
			//this.alpha = 0; 
			if (fileType != "swf") {
				if (broadcastDone) {	
					trace("sent broadCast: " + broadcastDone);
					Tweener.addTween(this, { _autoAlpha:1, time:1, delay:.5, onComplete:TransitionInComplete } );
				}else {
					Tweener.addTween(this, { _autoAlpha:1, time:1, delay:.5} );
				}
			}else {
				Display(); 
			}
		}
				
		function TransitionOutComplete():void 
		{
			//trace("TransitionOut Completed: " + this.name); 
			
		}
		
		function TransitionInComplete():void 
		{
			//trace("TransitionIn Completed: "  + this.name); 
			dispatchEvent(new CustomEvent (CustomEvent.TRANSITION_DONE, { msg:this}, true, false));
			Display(); 
		}
		
		public function Hide():void 
		{
			visible = false; 	
			alpha = 0; 
		}
		
		public function Display():void 
		{
			visible = true; 
			alpha = 1; 
			
			if (fileType == "swf") {
				//trace("we need to gotoAndPlay(1)"); 
				mc.gotoAndPlay(1); 
			}
		}
		
	}

}