package com.bluetelescope.screens
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite; 
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import com.bluetelescope.CustomEvent; 
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class AttractLoop extends BaseScreen
	{
		
		private var ldr:Loader;		
		public var aContent:MovieClip;
		private var attractText:String = null; 
		private var isTouch:Boolean
		
		public function AttractLoop():void 
		{
			//super("attrat"); 
			//make a white background
			var bkg:Sprite = new Sprite();
			addChild(bkg);
			bkg.graphics.beginFill(0x0054A2);
			bkg.graphics.drawRect(0,0,1080,1920);
			bkg.graphics.endFill();									
		}
		public function LoadAttract(_file:String,_attractText:String = null) 
		{			
			ldr = new Loader();
			ldr.load(new URLRequest(_file)); 
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, LoadComplete);
			if (_attractText != null) {
				attractText = _attractText; 
			}			
			addChild(ldr);		
		}
		
		
		private function LoadComplete(event:Event):void
		{
			ldr.removeEventListener(Event.COMPLETE, LoadComplete);						
			aContent = MovieClip(ldr.content);										
			super.Display(); 			
			addEventListener(MouseEvent.CLICK, onClick);
			
			var rect:Sprite = new Sprite();
			addChild(rect);
			rect.graphics.lineStyle(1,0x00ff00);
			rect.graphics.beginFill(0x0000FF);
			rect.graphics.drawRect(0,0,1080,1920);
			rect.graphics.endFill();
			
			rect.x = 0; //stage.stageWidth/2-rect.width/2;
			rect.y = 0; //stage.stageHeight/2-rect.height/2;
			aContent.mask = rect; 
			//aContent.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		function onClick(event:MouseEvent):void 
		{								
			dispatchEvent(new CustomEvent (CustomEvent.ATTRACT_CLICK, { msg:"attract" }, true, false));			
		}
		
		public function attractAction(act:String,type:String = null):void 
		{	
				switch (act) 
				{
					case "pause":
					break
					
					case "play":
						this.visible = true;
						this.alpha = 1; 
						this.gotoAndPlay(1);					
					break;
					
					case "rewind":						
						this.gotoAndStop(1);
						Hide(); 									
					break;				
				}
		}
		
		override public function Display():void 
		{
			super.Display();
			if(aContent){
				aContent.gotoAndPlay(1); 
				this.gotoAndPlay(1); 
			}
			
		}
		
		override public function TransitionOut(action:String):void 
		{
			super.TransitionOut(action);
			//var ani:MovieClip = this["anim"] as MovieClip; 
			//var frameNum = ani.currentFrame; 													
		}
		
		public function Reset():void 
		{
			trace("AttractLoop:Reset"); 
		}
		
		
	}
	
}