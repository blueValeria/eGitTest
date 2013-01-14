package com.bluetelescope.screens {
	import caurina.transitions.Tweener;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.html.HTMLLoader;
	import flash.html.HTMLPDFCapability;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class PDFScreen extends BaseScreen
	{				
		private var file:String;							
		//private var btnClose:btn = new btnCloseLinkage(); 		
		private var popupPage:MovieClip; 
		public var pdfMC : Sprite;
		private var pdf : HTMLLoader;
		 
		
		//private var bkg:MovieClip; 		
		
		public function PDFScreen():void 
		{			
			super();
								
		}
		
		public function SetPDF(_aFile:String,pdfX:int, pdfY:int,pdfW:int, pdfH:int):void 
		{
			file = _aFile; 							
			//var filePath:String = "media/" + pName + "/" + file; 
			//fileType = filePath.substring(filePath.lastIndexOf(".")); 										
			//trace("new PDFScreen: " + _aFile); 			

//			pdfMC = new mdm.PDF(pdfX, pdfY, pdfW, pdfH, file);						
//			pdfMC.firstPage(); 
//			pdfMC.visible = false; 
			pdfMC = new Sprite();
			pdfMC.x = pdfX;
			pdfMC.y = pdfY;	
			trace(HTMLLoader.pdfCapability)
			if(HTMLLoader.pdfCapability == HTMLPDFCapability.STATUS_OK)  
			{ 
			    trace("PDF content can be displayed"); 
				var request:URLRequest = new URLRequest(_aFile); 								
				pdf = new HTMLLoader();				 
				pdf.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				pdf.height = pdfW; 
				pdf.width = pdfH; 
				pdf.load(request); 
				pdfMC.addChild(pdf);				
			} 
			else  
			{ 
			    trace("PDF cannot be displayed. Error code:", HTMLLoader.pdfCapability); 
			}			
								

			pdfMC.visible = false;						
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
            trace("PDFScreen:: ioErrorHandler: " + event);
        }		
		
		public function Reset():void 
		{
			Tweener.removeTweens(this);
			this.Hide(); 
			pdfMC.visible = false; 
		}
		
		override public function Display():void 
		{			
			super.Display();
			pdfMC.visible = true; 			
//			pdfMC.firstPage(); 
			trace("PDFScreen: Display " + file);		
		}
		
		override public function Hide():void 
		{
			super.Hide(); 
//			pdfMC.firstPage();
			pdfMC.visible = false; 
		}
			
	}
	
}