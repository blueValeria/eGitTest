package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.html.HTMLLoader;
	import flash.html.HTMLPDFCapability;
	import flash.net.URLRequest;


	/**
	 * @author Macmini21
	 */
	public class AirPDFTest extends MovieClip {
		private var pdf:HTMLLoader;
		
		public function AirPDFTest() {
			trace("Air PDF Test");
			var html_loader: HTMLLoader = new HTMLLoader();
			trace(html_loader);			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage ( e : Event) : void {

			if(HTMLLoader.pdfCapability == HTMLPDFCapability.STATUS_OK)  
			{ 
			    trace("PDF content can be displayed");
				var request:URLRequest = new URLRequest("DEX.pdf"); 								
				pdf = new HTMLLoader();				 
				pdf.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				pdf.height = 300; 
				pdf.width = 300; 
				pdf.load(request); 
				addChild(pdf);				 				
			} 
			else  
			{ 
			   this.gotoAndStop(2); 
				trace("PDF cannot be displayed. Error code:", HTMLLoader.pdfCapability); 
			}
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
            trace("PDFScreen:: ioErrorHandler: " + event);
        }		
		
	}//c
}//p
