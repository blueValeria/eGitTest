package com.bluetelescope.screens 
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.DisplayShortcuts;

	import com.bluetelescope.CustomEvent;
	import com.bluetelescope.gui.AnswerBtn;
	import com.bluetelescope.gui.Btn;
	import com.bluetelescope.leads.ActionTimer;
	import com.bluetelescope.leads.CSharpTalker;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author Ron Cunningham
	 * 
	 * 
	 * colors:
	 * Convenia 0x0053A3/0x0053A3
	 * Revolution 0x0053A3/0x0053A3
	 * Rimadyl 0x004A3F/0x000000
	 * Bronchicine 0xF3791F/0x000000
	 * Vangauard 0xF3791F/0x000000
	*/
	public class Challenge extends BaseScreen 
	{
		private var xmlLoader:URLLoader; 	
		private var contentXMLdata:XML = new XML();	
		private var questionXMLList:XMLList; 
		public var currentQuestionNumber:int; 
		public var currentBrand:String; 
		public var numOfQuestions:int; 
		private var numOfAnswerOptions:int; 
		private var listOfAnswerBtns:Array = new Array(); 
		public var textColorsList:Array = new Array(); 
		
		private var ldr:Loader; 
		private var questionWindow:BaseScreen = new QuestionWindow();		
		private var style:StyleSheet; 
		private var cssLoader:URLLoader;		
		private var headerfooter:MovieClip = new HeaderFooterLink(); 	
		public var iconImage:Bitmap; 
		private var btnNext:Btn; 
		private var btnPI:Btn; 
		public var pdfScreen:PDFScreen; 
		private var hasPDF:Boolean = false; 
		
		public var _url:String = "";  
								
		public function Challenge() 
		{
			super();	
			DisplayShortcuts.init(); 
			
			addEventListener(CustomEvent.ANSWER_BTN_CLICK, AnswerButton_Click, false, 0, true);
			addEventListener(CustomEvent.TRANSITION_DONE, TurnOnButtons, false, 0, true); 
			XML.prettyPrinting = false;
		}
		
		public function Reset():void 
		{
			//trace("Challenge Reset()"); 
			ResetAnswerOptions(); 
			numOfAnswerOptions = 0; 
			Hide(); 
			if(hasPDF){			
				pdfScreen.Hide(); 
			}						
		}
		
		public function LoadContent(file:String):void 
		{
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, LoadContentComplete);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//trace("LoadContent.file: " + file); 
			xmlLoader.load(new URLRequest(file));	
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
            trace("Challenge:: ioErrorHandler: " + event);
        }
				
		private function LoadContentComplete(e:Event):void
		{
			contentXMLdata = new XML(e.target.data);
			xmlLoader.removeEventListener(Event.COMPLETE, LoadContentComplete);				
			//how many questions
			numOfQuestions = contentXMLdata.children().length(); 	
			//trace("LoadContentCompleted:numOfQuestions: " + numOfQuestions); 
			
			LoadPI(); 
			LoadAnswerScreens(); 
			LoadStyle(_url + "config/style.css"); 			
			Init(); 
		}
		
		private function LoadPI():void 
		{
			var pdfFile:String = contentXMLdata.@piFile; 
			
			if (pdfFile.length > 0) {				
				pdfFile = _url +  "media/pis/" + pdfFile; 
				pdfScreen = new PDFscreenLinkage(); 
				pdfScreen.SetPDF(pdfFile, 40, 330, 1000, 1380); 
				pdfScreen.name = this.name + "_PDF"; 
				pdfScreen.x = 0; 
				pdfScreen.y = 0; 
				hasPDF = true; 				
			}					
			//trace("Challenge:: LoadPI: pdfFile: " + pdfFile.length + " and file; "  + pdfFile); 
		}
		
		public function DisplayPI():void 
		{
			if(hasPDF){
				addChild(pdfScreen);
				pdfScreen.Display(); 
			}
		}
		
		public function ClosePI():void 
		{
			pdfScreen.Hide(); 
		}
		
		private function LoadAnswerScreens():void 
		{
			var child:XMLList = contentXMLdata.children();
			var aBaseScreen:BaseScreen; 					
			for ( var i:int = child.length()-1; i > -1; i--)
			{
				var aXML:XML = child[i]; 
				//trace("aXML.@displayFile: " + aXML.@displayFile); 
				aBaseScreen = new BaseScreen();
				aBaseScreen.name = String(aXML.@displayFile).substr(0,-4); 										
				//trace("aBaseScreen.name: " + aBaseScreen.name); 											
				aBaseScreen.LoadFile(_url + "media/touchscreen/" + aXML.@displayFile);				
				addChild(aBaseScreen); 				
			}												
		}
		
		public function LoadStyle(file:String):void
		{			
			var req:URLRequest = new URLRequest(file);				
	        cssLoader = new URLLoader();
            cssLoader.addEventListener(Event.COMPLETE, CSSFileLoaded);
            cssLoader.load(req);	
		}
		
		private function CSSFileLoaded(event:Event):void
		{			
			style = new StyleSheet();       	  
			style.parseCSS(cssLoader.data);		
			cssLoader.removeEventListener(Event.COMPLETE, CSSFileLoaded);				
		}		
		
		private function Init():void 
		{
			btnNext	= new BtnNext(); 
			addChild(btnNext);
			btnNext.x = 937; 
			btnNext.y = 1096; 
			btnNext.hide(); 			
			btnPI = this.pi as Btn; 			
		}
		
		private function AnswerButton_Click(e:CustomEvent):void 
		{
			var action:String = e.params.msg; 
			CSharpTalker.addQuizData(this.name + "-" +currentQuestionNumber.toString(), action, ActionTimer.getDuration()); 											
			//if (currentQuestionNumber < numOfQuestions) {					
				var aString:String = this.name+"_0" + currentQuestionNumber.toString(); 
				dispatchEvent(new CustomEvent (CustomEvent.DISPLAY_ANSWER, { msg:aString }, true, false));
				GoToAnswer(aString); 					
			//}else {
				//trace("we're done"); 
			//	dispatchEvent(new CustomEvent (CustomEvent.CHALLENGE_DONE, { msg:"challenge done" }, true, false));
			//}					
		}
		
		private function TurnOnButtons(e:CustomEvent):void 
		{
			trace("TurnOnButtons"); 
			for (var a:int = 0; a < numOfAnswerOptions; a++) {
				var aBtn:AnswerBtn = listOfAnswerBtns[a] as AnswerBtn; 
				aBtn.turnOn(); 
			}
		}
		
		private function ImageLoaded(e:Event):void {
		 
			//Save the loaded bitmap to a local variable
			var image:Bitmap = (Bitmap)(e.target.content);		 
			//Save the image's holder to a local variable
			//var holder:MovieClip = imageHolders[loadedImages];
		 
			//Add the image to the holder
			//holder.addChild(image);
			addChild(image); 					 
					 
			//Tween the preloader.
			//We call the function "tweenFinished" when the animation is done.
			//We pass the preloader and the image holder as parameters to the function.
			//TweenLite.to(holder.preloader, 1, {scaleX: 2, scaleY: 2, alpha: 0, 
			// onComplete:tweenFinished, onCompleteParams:[holder.preloader, holder]});
		 
			//Update the loaded images count
			//loadedImages++;
		 
			//We load the next image if there are still more URLs in the array
			//if (imageURLs.length > 0) {
			//	loadImage();
			//}
			
			// Load the Question Window
			addChild(headerfooter); 				
			addChild(questionWindow); 			
		}
		
		public function GoToAnswer(_name:String):void 
		{
			trace("GoToAnswer: " + _name); 
			var aBaseScreen:BaseScreen = this.getChildByName(_name) as BaseScreen; 							
			aBaseScreen.TransitionIn("fadeIn");			
			questionWindow.visible = false;			
			addChild(headerfooter); 
			
			if (this.name == "Bronchicine" || this.name ==  "Vanguard") {					
				btnPI.hide(); 				
			}else {
				this.addChild(btnPI); 
				btnPI.display(); 
			}
						
			addChild(btnNext); 		
			btnNext.visible = true; 
			btnNext.alpha = 0; 
			Tweener.addTween(btnNext, { alpha:1, time:2, delay:1.5 } ); 			
		
			currentQuestionNumber++; 			
		}
				
		public function GoToQuestion(pos:int):void 
		{
			trace("pos: " + pos + " currentQuestionNumber: " + currentQuestionNumber + " and numOfQuestions: " + numOfQuestions);
			
			Main.TOUCH_BGD.setPos(pos);
			Main.DISPLAY_BGD.setPos(pos);
			//hide the others?
			HideAll(); 
			Display(); 
			ResetAnswerOptions(); 
			
			textColorsList = String(contentXMLdata.@colors).split("|"); 
			textColorsList[0] = uint(textColorsList[0]); 
			textColorsList[1] = uint(textColorsList[1]);
									
			addChild(questionWindow); 
			
								
			questionWindow.visible = true;
			currentQuestionNumber = pos; 						
			questionXMLList = contentXMLdata.children(); 	
			var qXML:XML = questionXMLList[--pos]; 				
			//trace("question:  "  + qXML.q.toXMLString()); 						
			var questionTF:TextField = questionWindow.txt_q; 
			questionTF.styleSheet = style;
			questionTF.htmlText = qXML.q.toXMLString();
			//trace("Challenge:: question = " + questionTF.htmlText) 
			questionTF.textColor = textColorsList[0]; 
			questionTF.y = int(qXML.@qY); 			
			if (questionTF.y == 0) {
				questionTF.y = 318; 
			}	
						
			// how many answer options - build the answers
			var answerXMLList:XMLList = qXML.answers.children(); 
			numOfAnswerOptions = answerXMLList.length(); 
			
			
			var startAnswerY:int = int(qXML.answers.@buttonStartY); 
			var spacing:int = int(qXML.answers.@spacing); 			
			if (spacing == 0) {
				spacing = 210; 
			}
									
			for (var a:int = 0; a < numOfAnswerOptions; a++) {
				var aBtn:AnswerBtn; 											
				if (listOfAnswerBtns[a] == null) {
					var btnName:String = "BtnAnswer" + name.substr(0, 1).toUpperCase() + name.substr(1); 	
				//	trace("btnName: " + btnName); 
					var classType:Class = getDefinitionByName(btnName) as Class;		
					aBtn = new classType();  
					
					listOfAnswerBtns.push(aBtn); 
				}else {
					aBtn = listOfAnswerBtns[a]; 
				}	
				aBtn.turnOff(); 
								
				var answerXML:XML = answerXMLList[a];				
				aBtn.answerString = String(a + 1); 											
				var tf:TextField = aBtn.txt_a; 
				
				tf.styleSheet = style;																			
				tf.htmlText = answerXML.toXMLString();	
				tf.textColor = textColorsList[1]; 
				tf.autoSize = TextFieldAutoSize.CENTER; 				
				// vertically center text; 159 is the height of the "button" bkg
				tf.y = (159 * .5) - (tf.height * .5); 						
				
				questionWindow.addChild(aBtn); 
				aBtn.x = 230; 
				aBtn.y = startAnswerY; 
				startAnswerY += spacing; 									
				aBtn.display(); 
			}		
			
			//FOOTNOTE
			var footTF:TextField = questionWindow.txt_foot;
			footTF.htmlText = "";						
			if (qXML.references.toString().length > 0) {
				footTF.styleSheet = style;	
				footTF.htmlText = qXML.references.toXMLString();
				footTF.textColor = textColorsList[0];	tf.autoSize = TextFieldAutoSize.CENTER; 	
				
			//	trace("startAnswerY: " + startAnswerY); 
				if (startAnswerY > footTF.y) {
					footTF.y = startAnswerY + 10; 
				}
			}			
						
				
			if (this.name == "Bronchicine" || this.name ==  "Vanguard") {
				//trace("this.name: " + this.name + "  hide me"); 		
				btnPI.hide(); 				
			}else {
				this.addChild(btnPI); 
				btnPI.display(); 
			}
			//Icon
			this.addChild(iconImage); 
			
			questionWindow.TransitionIn("FadeIn", true); 
			ActionTimer.startTiming(); 
			
		}
		
		public function HideAll():void 
		{
			for (var i:int = 0; i < this.numChildren; i++) {
				var obj = this.getChildAt(i); 							
				if (obj is BaseScreen) {					
					var bS:BaseScreen = obj as BaseScreen; 
					bS.Hide(); 
				}				
			}
			if(btnNext != null){
				btnNext.hide(); 
			}			
		}		
		
		private function ResetAnswerOptions():void 
		{
			if (numOfAnswerOptions > 0) {
				for (var w:int = 0; w < listOfAnswerBtns.length; w++){
					var aBtn:AnswerBtn = listOfAnswerBtns[w] as AnswerBtn; 
					aBtn.turnOff(); 
				}				
			}
			if(btnNext != null){
				btnNext.hide(); 
			}
		}
					
		private function getClass(obj:*):Class
		{
			var className:String = flash.utils.getQualifiedClassName( obj );
			var classType:Class = flash.utils.getDefinitionByName(className) as Class;
			return classType; 
		}		
		
		private function getSuperClass(obj:*):Class
		{
			var className:String = flash.utils.getQualifiedClassName( obj );
			var superClassName:String = flash.utils.getQualifiedSuperclassName(obj);
			var superClass:Class = flash.utils.getDefinitionByName(superClassName) as Class;	
			return superClass; 
		}			

		
	}

}