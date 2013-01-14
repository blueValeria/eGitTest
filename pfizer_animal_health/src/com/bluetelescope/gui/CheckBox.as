package com.bluetelescope.gui {
 
	import flash.display.MovieClip;	
	import flash.events.MouseEvent;
	import com.bluetelescope.CustomEvent; 
	
    public class CheckBox extends MovieClip {				
		public var selectedState:Boolean; 
		private var action:String; 
		
		public function CheckBox() {							
			buttonMode = true;
			useHandCursor = true;			
			turnOn();												
			reset(); 
		}		
		
		private function onUp(event:MouseEvent):void 
		{																
			action = String(this.name).substr(8); 							
			if (selectedState) {
				selectedState = false; 
				gotoAndStop(1); 
			}else {
				selectedState = true; 
				gotoAndStop(2); 
			}
			var myMsg:String = action +"|" + selectedState; 
			dispatchEvent(new CustomEvent (CustomEvent.CHK_BOX_CLICK, { msg:myMsg},true,false));
			
		}
		
		private function onOver(event:MouseEvent):void {}
		
		private function onOut(event:MouseEvent):void {}
		public function turnOff():void {							
			enabled = false;
			visible = false; 
			removeEventListener(MouseEvent.MOUSE_UP, onUp);
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);			
			
		}
		
		public function turnOn():void {							
			gotoAndStop(1); 	
			enabled = true;	
			visible = true; 			
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