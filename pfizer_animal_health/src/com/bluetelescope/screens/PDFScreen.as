package com.bluetelescope.screens
{		
	import flash.display.MovieClip;	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Timer;	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
		
	import com.bluetelescope.CustomEvent; 	
	import caurina.transitions.Tweener; 
	
	import mdm.*; 
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class PDFScreen extends BaseScreen
	{				
		private var file:String;							
		//private var btnClose:btn = new btnCloseLinkage(); 		
		private var popupPage:MovieClip; 
		public var pdfMC; 
		
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

			pdfMC = new mdm.PDF(pdfX, pdfY, pdfW, pdfH, file);						
			pdfMC.firstPage(); 
			pdfMC.visible = false; 			
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
			pdfMC.firstPage(); 
			trace("PDFScreen: Display " + file);		
		}
		
		override public function Hide():void 
		{
			super.Hide(); 
			pdfMC.firstPage();
			pdfMC.visible = false; 
		}
			
	}
	
}