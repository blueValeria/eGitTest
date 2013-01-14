package com.bluetelescope.screens
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	import com.bluetelescope.CustomEvent; 
		
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class HiddenScreen extends MovieClip
	{				
		
		public var configStr:String = ""; 
		
		public function HiddenScreen():void 
		{									
			alpha = 0; 
			visible = true;
			
			btnHiddenA.addEventListener(MouseEvent.CLICK, BtnHidden_Click); 
			btnHiddenB.addEventListener(MouseEvent.CLICK, BtnHidden_Click); 
			btnHiddenC.addEventListener(MouseEvent.CLICK, BtnHidden_Click); 
		}
		
		public function Reset():void 
		{
			configStr = ""; 
		}
		
		private function BtnHidden_Click(e:MouseEvent):void 
		{
			//trace("BtnHidden_Click " + e.currentTarget.name);
			//trace("configStr: " + configStr); 	
			
			switch (e.currentTarget.name) 
			{
				case "btnHiddenA":
					configStr += "A"; 
					if (configStr.indexOf("ABAB") > -1) {
						this.dispatchEvent(new CustomEvent (CustomEvent.HIDDEN_LOGIN, { msg:"Quit" }, true, false));
						configStr = ""; 
					}					
				break;
				
				case "btnHiddenB":
					configStr += "B"; 									
				break;
				
				case "btnHiddenC":
					this.dispatchEvent(new CustomEvent (CustomEvent.HIDDEN_LOGIN, { msg:"Reset" }, true, false));
				break;
				
				
			}
			
		}
		
		
		
	}
	
}