package com.bluetelescope.gui {
 
	import flash.display.MovieClip;	
	import flash.events.MouseEvent;
	import com.bluetelescope.CustomEvent; 
	
    public class Btn extends MovieClip {				
		public var selectedState:Boolean; 
		private var action:String; 
		
		public function Btn() {	
			//trace("Btn:: this string = " + String(this));			
			action = String(this).substring(11, (String(this).length) - 1); 
			//trace("Btn:: action = " + action);					
			//name = String(this).substring(8, (String(this).length)-5); 
			buttonMode = true;
			useHandCursor = true;			
			turnOn();												
			reset(); 
		}		
		
		private function onUp(event:MouseEvent):void 
		{													
			dispatchEvent(new CustomEvent (CustomEvent.BTN_CLICK, { msg:action },true,false));								
		}
		
		private function onOver(event:MouseEvent):void 
		{	
			gotoAndStop(2); 
		}
		
		private function onOut(event:MouseEvent):void 
		{		
			if (selectedState == false) {
				gotoAndStop(1); 
			}
		}
		public function turnOff():void {			
			//alpha = .3;			
			enabled = false;			
			removeEventListener(MouseEvent.MOUSE_UP, onUp);
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);			
			
		}
		public function turnOn():void {							
			gotoAndStop(1); 
			if(action != "Hidden"){
			//	alpha = 1;
			}			
			enabled = true;			
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);											
		}
		
		public function reset():void {									
			gotoAndStop(1); 
			selectedState = false; 
		}
			
		public function selected():void {			
			gotoAndStop(2); 
			selectedState = true; 			
		}
		
		public function hide():void 
		{
			visible = false; 
		}
		
		public function display():void 
		{
			visible = true; 
		}
		
	} 
}