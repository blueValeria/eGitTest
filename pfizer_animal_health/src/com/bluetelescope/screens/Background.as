package com.bluetelescope.screens 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class Background extends BaseScreen 
	{							
		private var ldr:Loader; 					
		private var cssLoader:URLLoader;
//		private var file:String;
		private var img_array : Array = new Array();
		private var file_base_name : String;
		private var file_count : Number;
		private var loader_count : Number = 0;

		public function Background(base_name : String, count : Number) 
		{
			super();
			file_base_name = base_name;
			file_count = count; 										
		}
		
		public function Reset():void 
		{
			trace("Background Reset()"); 
			setPos(1);
		}
	
		public function LoadBackground():void 
		{					
			loadNextImg ();
			
		}
		
		public function setPos(pos : int) : void {
			if(file_count > 1){
				for ( var i : Number = 0; i < img_array.length; i++) {
					var img : Bitmap = img_array[i] as Bitmap;
					if( i + 1 == pos) {
						img.visible = true;
					}else{
						img.visible = false;
					}
				}
			}
		}
		
		private function loadNextImg () : void {
			loader_count++;
			if(loader_count<= file_count) {
				LoadImg();
			}			
		}
		
		
		private function LoadImg():void 
		{							
			if (file_count > 1) {
				file = file_base_name + "_0" + loader_count +  ".png";
			}else{				
				var file : String = file_base_name   + ".png";
			}			
			ldr = new Loader(); 
			ldr.load(new URLRequest(file)); 
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ImageLoaded);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			
		}		
		
		private function ioErrorHandler(event:IOErrorEvent):void {
            trace("Background:: ioErrorHandler: " + event);
        }		
		private function ImageLoaded(e:Event):void {
		 
			//Save the loaded bitmap to a local variable
			var image:Bitmap = (Bitmap)(e.target.content);		 
			addChild(image);
			img_array.push(image);
			//trace("BackgroundImage Loaded: " + file);
			loadNextImg (); 					 									 					
		}		
		
		
	}

}