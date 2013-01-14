package com.bluetelescope.leads 
{
	import adobe.utils.CustomActions;
	import flash.events.TimerEvent;
	
	import flash.display.MovieClip;		
	import flash.display.Sprite;
	import flash.utils.Timer; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface; 	
	import flash.net.LocalConnection;	
	import flash.events.StatusEvent; 
	
	import com.bluetelescope.leads.CSharpTalkerCustomEvent; 
	import com.bluetelescope.leads.Person; 
	import com.bluetelescope.leads.DateTimeStamp;
	
	//
	/**
	 * ...
	 * @author ...
	 */
	public class CSharpTalker extends Sprite
	{
		public static var checkBTLeadsTimer:Timer = new Timer(2000); 
		
		private static var conn:LocalConnection = new LocalConnection(); 
		private static var receiveConn:LocalConnection = new LocalConnection(); 
		public static var talkerDispatcher:Sprite = new Sprite(); 	
		public static var dispatcher:EventDispatcher = new EventDispatcher(); 
		public static var isBTLeads:Boolean = true; 
		
		static var dataXML:XML; 
		static var dXML:XML; 
		
		//Static constructor
		{			
			// set up the local connection between this and the flash file embedded in teh C# listener program	
			receiveConn.allowDomain('*'); 
			receiveConn.connect('flashExecutable'); 
			receiveConn.client = CSharpTalker;		
			
			conn.addEventListener(StatusEvent.STATUS, status); 
			
			//checkBTLeadsTimer.addEventListener(TimerEvent.TIMER, checkBTLeads); 							
		}		
		
		static function status(e:StatusEvent):void 
		{			
			var msg:String = e.level; 
			if (msg == "error") {
				// assume we last connection				
				conn.removeEventListener(StatusEvent.STATUS, status); 				
				checkBTLeadsTimer.stop(); 
				isBTLeads = false; 
				dispatcher.dispatchEvent(new CSharpTalkerCustomEvent(CSharpTalkerCustomEvent.LOST_CONNECTION, { msg:"lost" }, true, false)); 	
			}else {
				isBTLeads = true; 
			}
		}
		
		public static function createLogIn(data:String):void 
		{												
			dispatcher.dispatchEvent(new CSharpTalkerCustomEvent(CSharpTalkerCustomEvent.GOT_DATA, { msg:data }, true, false)); 									
		}		
		
		public static function sendUserData(xml:XML):void {conn.send('btListener', 'saveUserData', xml);}		
		
		public static function clearUserData():void {conn.send('btListener', 'clearUserData');}
				
		public static function isConnected():void 
		{
			//trace("just checking!"); 
		}
		
		public static function getUnswiped():void {	}
		
		public static function addQuizData(q:String, a:String, t:Number, sendNow:Boolean = false):void 
		{
			dataXML = 
				<data id={Person.cardId}>
					<qA time={t} question={q} answer={a} />
				</data>				
			Person.addData("quiz", dataXML); 		
			//trace("CSharpTalker.addQuizData: " + dataXML); 
			
			if (sendNow) { conn.send('btListener', 'addUserData', dataXML); };  
		}
		
		public static function addScreenData(s:String, t:Number, sendNow:Boolean = false):void 
		{					
			dataXML = 
				<data id={Person.cardId}>
					<screen time={t} name={s} />
				</data>								
			Person.addData("screenList",dataXML); 			
			if (sendNow) { conn.send('btListener', 'addUserData', dataXML); };  
		}
		
		public static function addCartData(i:String, sendNow:Boolean = false):void 
		{
			dataXML = 
			<data id={Person.cardId}>
				<item name={i} />
			</data>
			Person.addData("cartList",dataXML); 				
			if (sendNow) { conn.send('btListener', 'addUserData', dataXML); };  
		}
				
		public static function addMultiUserData(m:String, sendNow:Boolean = false):void 
		{
			dataXML = 
			<data id={Person.cardId}>
				<id session={m} />
			</data>			
			Person.addData("multiUserSession", dataXML); 						
			if (sendNow) { conn.send('btListener', 'addUserData', dataXML); };  
		}		
				
		public static function addMiscData(m:String, sendNow:Boolean = false):void 
		{
			dataXML = 
			<data id={Person.cardId}>
				<misc>{m}</misc>
			</data>			
			Person.addData("miscData", dataXML); 						
			if (sendNow) { conn.send('btListener', 'addUserData', dataXML); };  
		}	
		
		public static function checkBTLeads(e:TimerEvent):void
		{			
			conn.send('btListener', 'checkBTLeads','a');						
		}
		
					
	}
}

