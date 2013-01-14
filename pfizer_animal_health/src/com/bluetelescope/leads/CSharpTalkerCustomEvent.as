package com.bluetelescope.leads{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class CSharpTalkerCustomEvent extends Event
	{
		public static const DEFAULT_NAME:String = "CustomEvent";			
		public static const GOT_DATA:String = "onGotData";			
		public static const CLEAR_DATA:String = "onClearData";	
		public static const SENT_DATA:String = "onSentData";	
		public static const LOST_CONNECTION:String = "onLostConnection"; 

		
		public var params:*;
		
        public function CSharpTalkerCustomEvent( $type:String,$params:Object,$bubbles:Boolean = false,$cancelable:Boolean = false )        {
            super( $type, $bubbles, $cancelable );
            this.params = $params;			
			//trace($type); 			
        }
        
        public override function clone():Event{
            return new CSharpTalkerCustomEvent( type, this.params,bubbles, cancelable );
        }
        
        public override function toString():String {
			return formatToString( "CSharpTalkerCustomEvent", "params", "type","bubbles", "cancelable" );
        }
		
	}
	
}