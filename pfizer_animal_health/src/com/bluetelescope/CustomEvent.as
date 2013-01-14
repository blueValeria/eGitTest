package com.bluetelescope{
	import flash.events.Event;
	
	/**
	 * ...
	 * Use addEventListener(CustomEvent.MENU_BTN_SELECTED, AnswerButton_Click, false, 0, true); 
	 * dispatchEvent(new CustomEvent (CustomEvent.INTRO_TEXT, { msg:quizXML.intro.toXMLString() }, true, false));
	 * @author Ron Cunningham
	 */
	public class CustomEvent extends Event
	{
		public static const DEFAULT_NAME:String = "CustomEvent";
		public static const BTN_CLICK:String = "onBtnClick"; 		
		public static const ANSWER_BTN_CLICK:String = "onAnswerBtnClick"; 	
		public static const CHK_BOX_CLICK:String = "onCheckBoxClick"; 
		public static const ATTRACT_CLICK:String = "onAttractClick";
				
		public static const PROGRAM_RESET:String = "onProgramReset"; 
		public static const HIDDEN_LOGIN:String = "onHiddenLogin"
		
		public static const DISPLAY_ANSWER:String = "onDisplayAnswer"; 
		public static const TRANSITION_DONE:String = "onTranistionDone"; 
		public static const CHALLENGE_DONE:String = "onChallengeDone"; 
	

	
		
		public var params:*;
		
        public function CustomEvent( $type:String,$params:Object,$bubbles:Boolean = false,$cancelable:Boolean = false )        {
            super( $type, $bubbles, $cancelable );
            this.params = $params;			
			//trace($type); 			
        }
        
        public override function clone():Event{
            return new CustomEvent( type, this.params,bubbles, cancelable );
        }
        
        public override function toString():String {
			return formatToString( "customEvent", "params", "type","bubbles", "cancelable" );
        }
		
	}
	
}