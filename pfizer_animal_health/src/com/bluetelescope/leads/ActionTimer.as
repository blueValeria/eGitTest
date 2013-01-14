package com.bluetelescope.leads 
{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.utils.getTimer; 
	
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class ActionTimer extends Sprite 
	{
		public static var aTimer:Timer
		public static var startTime:Number;
				
		public static function startTiming():void 
		{
			startTime = getTimer(); 						
			
		}
				
		public static function getDuration():Number
		{		
			var elapseTime:Number = Math.ceil((getTimer() - startTime));					
			return elapseTime; 
		}
	
		
	}

}