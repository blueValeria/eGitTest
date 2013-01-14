package com.bluetelescope.leads{	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	import flash.display.*;	
	import flash.utils.*;
    import flash.events.TimerEvent;   
	
	public class DateTimeStamp extends Sprite {		
	
		public function DateTimeStamp():void {
			//trace("new DateTimeStamp");
		}
		
		public static function stamp(type:String = null):String{
			var today:Date = new Date();
			var ret:String = String(today.getFullYear())+"-";
			ret += timeString(today.getMonth() + 1) + "-" + timeString(today.getDate()) + "_";
			
			//trace("stamp:type: " + type); 
		
			
			switch (type) 
			{
				case "BT":
					// format as MM/DD/YYYY_HH:MM:SS
					ret = timeString(today.getMonth() +1) + "/" + timeString(today.getDate()) + "/" + timeString(today.getFullYear()) + " "; 
					ret += timeString(today.getHours()) + ":" + timeString(today.getMinutes()) + ":" + timeString(today.getSeconds()); 					
					break; 
				
				
				case "US":
					ret += usClock(today.getHours(),today.getMinutes()); 
				break;
				
				case "milli":
					ret = timeString(today.getHours())+timeString(today.getMinutes())+timeString(today.getSeconds()); 
				break;
				
				default:
					ret += timeString(today.getHours())+":"+timeString(today.getMinutes());
				break; 
				
			}			
			return ret;
		}
		
		private static function timeString(nm:Number):String {
			var str:String = "";
			if (nm<10) {
				str = "0";
			}
			str = str+String(nm);
			return str;
		}
		
		private static function usClock(hrs:uint, mins:uint):String {
			var modifier:String = "PM";
			var minLabel:String = twoDigits(mins);
			if(hrs > 12) {
				hrs = hrs-12;
			} else if(hrs == 0) {
				modifier = "AM";
				hrs = 12;
			} else if(hrs < 12) {
				modifier = "AM";
			}
			return (twoDigits(hrs) + ":" + minLabel + " " + modifier);
		}
		
		private static function twoDigits(num:uint):String	{
			if(num < 10) {				
				return String("0" + num);
			}
			return String(num);
		}	
	}
}