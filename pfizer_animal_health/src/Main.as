package  
{
	import com.bluetelescope.gui.CheckBox;
	import com.bluetelescope.screens.AttractLoop;
	import com.bluetelescope.screens.Background;
	import com.bluetelescope.screens.BaseScreen;
	import com.bluetelescope.screens.Challenge;
	import com.bluetelescope.screens.DisplayContent;
	import com.bluetelescope.screens.HiddenScreen;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip; 		
	import flash.events.MouseEvent;
	import flash.events.Event; 
	import flash.events.TimerEvent; 
	import flash.events.KeyboardEvent; 
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.Font; 
	
	import flash.net.URLLoader;
	import flash.net.URLRequest; 
	import flash.utils.Timer;
	
	import flash.ui.Mouse; 
	import flash.utils.*; 
	import flash.system.fscommand;
	
	import com.bluetelescope.*;
	import com.bluetelescope.leads.*; 
	import caurina.transitions.Tweener; 	
	
	import mdm.*;
	
	/**
	 * ...
	 * @author Ron Cunningham
	 */
	public class Main extends MovieClip 
	{		
		
		public static var TOUCH_BGD : Background;
		public static var DISPLAY_BGD : Background;
		public var thisURL:String;
		public var thisDir:String; 
		public var _url:String; 
		private var xmlLoader:URLLoader; 	
		private var configXMLdata:XML = new XML();	
		private var configXMLFile:String;	
		
		
		private var i:uint;					
		private var programTimer:Timer;
		private var thanksTimer:Timer; 
		private var showCursor:String; 
		
		private var attractLoop:AttractLoop; 
		private var attractLoop2:AttractLoop; 
		private var touchscreen:BaseScreen;
		private var displayscreen:BaseScreen;
		private var loginscreen:BaseScreen; 
		private var optinscreen:BaseScreen; 
		private var mainmenuscreen:BaseScreen; 		
		private var learnmorescreen:BaseScreen; 
		private var thanksscreen:BaseScreen; 
		private var hiddenscreen:HiddenScreen; 
		private var currentScreen:BaseScreen; 
		private var selectedChallenge:Challenge; 
		
		private var sectionList:Array = new Array(); 
		private var sectionPos:int; 
		private var currentBrand:String; 
		
		private var challengeList:Array = new Array(); 
		private var challengePos:int; 
		
		private var displayContentList:Array = new Array(); 		
		
		private var backgroundList:Array = new Array();
		private var backgroundList2:Array = new Array(); 
		private var isAccept:Boolean; 
		
		
		private var isLoggedIn:Boolean; 
		private var userOptInList:Array = new Array(3); 
		
		private var astEmail:MovieClip;
		private var astClinic:MovieClip;
		private var astPosition:MovieClip; 
		private var astZip:MovieClip;
		private var checkLoginRequire:int; 
		
		public function Main() 
		{			
			thisURL = this.loaderInfo.loaderURL;				
			thisDir = unescape(thisURL.substring(0, thisURL.lastIndexOf("/")));
			thisDir = thisURL.substring(0, thisURL.lastIndexOf("/"));
			thisDir = thisDir.substr(8);			
			mdm.Application.init(this, onInit);			
			if (String(mdm.Application.path).length > 8) {						
				_url = mdm.Application.path; 
			}else {				
				_url = "";
			}			
			LoadConfig(); 			
			listFonts();
		}
		
		private function onInit():void 	{ }			
		
		private function reset():void
		{
			trace("reset"); 		
			programTimer.stop(); 
			thanksTimer.stop(); 			
			HideAll(); 			
			touchscreen.addChild(attractLoop); 			
			attractLoop.Display(); 
			touchscreen.Display(); 
			
			attractLoop2.Display(); 
			displayscreen.addChild(attractLoop2); 
			displayscreen.Display(); 
			
			for (var c:int = 0; c < challengeList.length; c++) {
				var aChallenge:Challenge = challengeList[c] as Challenge; 
				aChallenge.Reset(); 
			}	
			
			for (var d:int = 0; d < displayContentList.length; d++) {
				var aDispContent:DisplayContent = displayContentList[d] as DisplayContent; 
				aDispContent.Reset(); 
			}	
			
			for (var b:int = 0; b < touchscreen.bkg.numChildren; b++) {
				var obj1 = touchscreen.bkg.getChildAt(b); 
				var obj2 = displayscreen.bkg.getChildAt(b); 				
				var testClass = getClass(obj1); 
				if (obj1 == Background) {
					touchscreen.bkg.removeChild(obj1); 
					displayscreen.bkg.removeChild(obj2); 
				}						
			}			
			
			userOptInList = ["VetDashboard|false", "EID|false","Rewards|false"]; 
			
			var chkBox:CheckBox = optinscreen.checkBoxVetDashboard as CheckBox; 
			chkBox.reset(); 
			chkBox = optinscreen.checkBoxEID as CheckBox;
			chkBox.reset();
			chkBox = optinscreen.checkBoxRewards as CheckBox;
			chkBox.reset();
						
			sectionPos = 0; 			
			challengePos = 0; 			
			isLoggedIn = false; 					
			addChild(hiddenscreen); 			
			if(Person.personXML != null){
				trace("is there data \n" + Person.personXML); 
				CSharpTalker.sendUserData(Person.personXML); 				
				//if the user isAccept, then write a text file								
				if (isAccept) {
					var fileName:String = Person.firstName +"_" + Person.lastName + "_" + Person.cardId; 					
					ZincFileWriter.writeDrawingFile(fileName,  Person.displayPersonInfo()); 
				}			
				Person.reset(); 				
			}
			isAccept = false; 	
			checkLoginRequire = 0; 
									
		}		
		
		private function LoadConfig():void
		{			
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, LoadConfigComplete);			
			xmlLoader.load(new URLRequest(_url + "config/config.xml"));			
		}
		
		private function LoadConfigComplete(e:Event):void
		{
			configXMLdata = new XML(e.target.data);
			xmlLoader.removeEventListener(Event.COMPLETE, LoadConfigComplete);				
			Init(); 
		}	
		
		private function Init():void 
		{
			trace("Init Complete!");
			touchscreen = new Touchscreen(); 
			addChild(touchscreen); 
			
			displayscreen = new Displayscreen(); 
			addChild(displayscreen); 
			displayscreen.x = 1080; 
			
			hiddenscreen = new HiddenScreenLinkage(); 		
			
			var child:XMLList = configXMLdata.children(); 
			for ( var i:int = i; i < child.length(); i++)
			{
				var aXML:XML = child[i]; 
				var section:String = aXML.name(); 								
				switch (section) 
				{										
					case "settings":												
						programTimer = new Timer(Number(aXML.timeOut)*1000);
						programTimer.addEventListener(TimerEvent.TIMER, TimeOutLogOut); 
						this.addEventListener(MouseEvent.MOUSE_UP, RestartTimer);						
						showCursor = aXML.showCursor; 
						setCursor(); 
						
						thanksTimer = new Timer(10000); 
						thanksTimer.addEventListener(TimerEvent.TIMER, ThanksTimerEvent); 
											
						attractLoop = new AttractLoop(); 
						attractLoop.LoadAttract(_url + aXML.attractFile); 		
						
						attractLoop2 = new AttractLoop(); 
						attractLoop2.LoadAttract(_url + aXML.attractFile2); 
						displayscreen.addChild(attractLoop2); 
					break; 
					
					case "sections":	
						var secXMLList:XMLList = aXML.children(); 
						for (var s:int = 0 ; s < secXMLList.length(); s++) {
							var secXML:XML = secXMLList[s]; 
							//var subsection:String = secXMLList[s]; 
							sectionList.push(secXML.name()); 							
							//trace("subsection: " + secXML.name()); 													
							if (secXML.name() == "mainMenu") {								
								//let's buildChallenge Screens																
								for(var c:int = 0; c<secXML.children().length();  c++){																	
									var aChallenge:Challenge = new Challenge(); 									
									var capName:String = String(secXML.child(c).name());  
									capName = capName.substring(0, 1).toUpperCase() + capName.substring(1);									
									aChallenge.name = capName; 
									aChallenge._url = _url; 
									aChallenge.LoadContent(_url + secXML.child(c).@file); 								
									//trace("mainMenu is here!: aChallenge.name " + aChallenge.name ); 
									challengeList.push(aChallenge); 
									this.addChild(aChallenge); 			
									
									var bgd_count : Number = Number(secXML.child(c).@bgdCount);
									if(!bgd_count) bgd_count = 1;
									var bkgFileBaseName:String = _url + "media/Background_" + capName; 
									var aBkg:Background = new Background(bkgFileBaseName,bgd_count);
									var aBkg2:Background = new Background(bkgFileBaseName,bgd_count); 
									
									aBkg.name = aChallenge.name; 
									aBkg.LoadBackground(); 
									
									aBkg2.name = aChallenge.name + "2"; 
									aBkg2.LoadBackground(); 
									
									backgroundList.push(aBkg); 	
									backgroundList2.push(aBkg2); 
									
									var iconName:String = "Icon_" + capName; 
									var classType:Class = getDefinitionByName(iconName) as Class;	
																		
									var iconBitmapData = new classType(); 		
									var iconImage:Bitmap = new Bitmap(iconBitmapData);
									var iconImage2:Bitmap = new Bitmap(iconBitmapData); 									
									iconImage.name = "myIcon"; 
									iconImage2.name = "myIcon2"; 
									
									aChallenge.addChild(iconImage); 
									aChallenge.iconImage = iconImage; 
									iconImage.x = 842; 
									iconImage.y = 109; 	
																	
									//For DisplayScreen									
									var aDisplayContent:DisplayContent = new DisplayContent(); 
									aDisplayContent.LoadContent(_url + secXML.child(c).@file); 									
									aDisplayContent.name = capName; 
									aDisplayContent._url = _url; 
									
									aDisplayContent.addChild(iconImage2); 
									aDisplayContent.iconImage = iconImage2; 
									iconImage2.x = 842; 
									iconImage2.y = 109; 
									
									displayContentList.push(aDisplayContent); 
									displayscreen.addChild(aDisplayContent);
									
									
									
							    }													
							}							
						}
						BuildScreens(); 						
					break;									
				}
			}
			addEventListener(CustomEvent.ATTRACT_CLICK, AttractClick); 	
			addEventListener(CustomEvent.BTN_CLICK, ButtonClick); 
			addEventListener(CustomEvent.CHALLENGE_DONE, ChallengeDone); 
			addEventListener(CustomEvent.PROGRAM_RESET, ProgramReset); 
			addEventListener(CustomEvent.DISPLAY_ANSWER, DisplayAnswerEvent); 			
			addEventListener(CustomEvent.HIDDEN_LOGIN, HiddenLogin); 
			addEventListener(CustomEvent.CHK_BOX_CLICK, CheckBoxClickEvent); 
			
			CSharpTalker.dispatcher.addEventListener(CSharpTalkerCustomEvent.GOT_DATA, createLogInFromCSharp);
			
			reset(); 		
		}
		
				
		private function ChallengeDone(e:CustomEvent):void 
		{
			trace("ChallengeDone "); 
			for (var c:int = 0; c < challengeList.length; c++) {
				var aChallenge:Challenge = challengeList[c] as Challenge; 
				aChallenge.Reset(); 
			}			
			//Learn More
			GoToSection(5); 
		}
		
		private function BuildScreens():void 
		{
			for (var i:int = 0; i < sectionList.length; i++) {				
				var secName:String = sectionList[i]; 				
				switch (secName) 
				{
					case "logIn":
						loginscreen = new Login(); 
						touchscreen.addChild(loginscreen); 
						
						astEmail = loginscreen.ast_email as MovieClip; 
						astClinic = loginscreen.ast_clinic as MovieClip; 
						astPosition = loginscreen.ast_position as MovieClip; 
						astZip = loginscreen.ast_zip as MovieClip; 											
		
					break;	
					
					case "optIn":
						optinscreen = new Optin(); 
						touchscreen.addChild(optinscreen); 
					break;						
					
					case "mainMenu":
						mainmenuscreen = new Mainmenu(); 
						touchscreen.addChild(mainmenuscreen); 
					break;	
					
					case "learnMore": 
						learnmorescreen = new Learnmore(); 
						touchscreen.addChild(learnmorescreen); 
					break; 
					
					case "thanks":
					    thanksscreen = new Thanks();						
						thanksscreen.addEventListener(MouseEvent.CLICK, ThanksMouseClick); 						
						touchscreen.addChild(thanksscreen); 						
					break;	
				}
										
			}
		}
			
		private function SetBackground(brand:String):void 
		{
			//trace("SetBackground:Band " + brand); 
			for (var a:int = 0; a < backgroundList.length; a++) {
				var aBkg1:Background = backgroundList[a]; 
				var aBkg2:Background = backgroundList2[a];
				
				if (brand.toLowerCase() == aBkg1.name.toLowerCase()) {					
					//remove other backgrounds
					for (var b:int = 0; b < touchscreen.bkg.numChildren; b++) {
						var obj1 = touchscreen.bkg.getChildAt(b); 
						var obj2 = displayscreen.bkg.getChildAt(b); 
						
						var testClass = getClass(obj1); 
						if (obj1 == Background) {
							touchscreen.bkg.removeChild(obj1); 
							displayscreen.bkg.removeChild(obj2); 
						}						
					}
					
					touchscreen.bkg.addChild(aBkg1); 
					displayscreen.bkg.addChild(aBkg2);
					TOUCH_BGD = aBkg1;
					DISPLAY_BGD = aBkg2;
					
					aBkg1.Display(); 
					aBkg2.Display(); 
				}					
			}
		}
					
		// Swipe + Login + Logout
		private function ActivateProgram():void {}
		
		private function CreateLogin():void {}
		
		private function CreateLogOut():void 
		{			
			reset(); 
		}
        
		private function HiddenLogin(e:CustomEvent):void 
		{
			var action:String = e.params.msg; 
			switch (action) 
			{
				case "Reset":
					if (isLoggedIn) {
						CreateLogOut(); 
					}else {						
						AttractClick(null); 
					}													
				break;
				
				case "Quit":
					fscommand("Quit");
					//mdm.Application.exit(); 
				break; 
				
			}
			
				
		}
		// called when BT_Leads receives a data
        public function createLogInFromCSharp(event:CSharpTalkerCustomEvent):void 
        {
            // event.params.msg is comma separated data string from BT Leads via CSharpTalker class
            Person.build(event.params.msg);           			
			isLoggedIn = true;			
			//ActionTimer.startTiming(); 			
			attractLoop.Hide(); 
			isLoggedIn = true; 
			GoToSection(1); 
			//Go to LoginScreen
        }  				
		
		private function ThanksMouseClick(event:MouseEvent):void 
		{			
			reset(); 
		}
		
		
		// Custom Event functions
		private function ProgramReset(event:CustomEvent):void 
		{			
			reset(); 
		}
		
		private function AttractClick(event:CustomEvent = null):void 
		{			
			attractLoop.Hide(); 
			Person.build(null); 	
			isLoggedIn = true; 
			GoToSection(1); 
		}
		
		private function CheckBoxClickEvent(e:CustomEvent):void 
		{
			var action:String = e.params.msg; 
			trace("CheckBoxClickEvent: " + action); 				
			//userOptInList = ["VetDashboard|false", "EID|false","Rewards|false"]; 
			
			if (action.indexOf("VetDashboard") > -1) {
				userOptInList[0] = action; 
			}else if (action.indexOf("EID") > -1) {				
				userOptInList[1] = action;
			}else if (action.indexOf("Rewards") > -1) {
				userOptInList[2] = action;
			}
			
			CSharpTalker.addMiscData(userOptInList.join(",") +"," + isAccept); 
		}
		
		private function SaveLoginFields():void 
		{
			Person.email = loginscreen.txt_email.text; 
			Person.institution = loginscreen.txt_clinic.text;
			Person.city = loginscreen.txt_city.text; 
			Person.state = loginscreen.txt_state.text; 
			Person.zip = loginscreen.txt_zip.text; 
			Person.phone = loginscreen.txt_phone.text; 
			Person.dtitle = loginscreen.txt_position.text;
			
			Person.firstName = loginscreen.txt_firstName.text;
			Person.lastName  = loginscreen.txt_lastName.text;
			Person.address = loginscreen.txt_address.text;
			
			Person.personXML.userData.replace("phone", <phone>{Person.phone}</phone>);
			Person.personXML.userData.replace("zip", <zip>{Person.zip}</zip>);
			Person.personXML.userData.replace("state", <state>{Person.state}</state>);
			Person.personXML.userData.replace("city", <city>{Person.city}</city>); 
			Person.personXML.userData.replace("organization", <organization>{Person.institution}</organization>);
			Person.personXML.userData.replace("email", <email>{Person.email}</email>); 
			Person.personXML.userData.replace("title", <title>{Person.dtitle}</title>);
			
			Person.personXML.userData.replace("firstName", <title>{Person.firstName}</title>); 
			Person.personXML.userData.replace("lastName", <title>{Person.lastName}</title>);
			Person.personXML.userData.replace("address", <title>{Person.address}</title>);
		}
		
		private function ButtonClick(e:CustomEvent):void 
		{
			var action:String = e.params.msg; 
			trace("Main:: ProgamAction: " + action); 			
			
			
			switch (action) 
			{
				case "LoginSubmit":
					//create login and save data	
					checkLoginRequire = 0; 
					checkLoginFields();						
					if (checkLoginRequire >= 4) {
						isAccept = true; 
						GoToOptInScreen(); 
						checkLoginRequire = 0; 
					}			
					//isAccept = true; 
					//GoToOptInScreen(); 												
				break;
				
			case "LoginDecline":
					checkLoginRequire = 0; 
					checkLoginFields();
					//if (checkLoginRequire >= 3) {
						isAccept = false;  
						GoToOptInScreen(2); 
						checkLoginRequire = 0; 
					//}
																	
				break;
				
			case "OptInSubmit":
				currentScreen.Hide(); 
					//save the text fields to the Person
					SaveLoginFields(); 
					GoToMainMenu(); 
				break; 
				
				case "ChallengeConvenia":
				case "ChallengeRevolution":
				case "ChallengeRimadyl":
				case "ChallengeBronchicine":
				case "ChallengeVanguard":
				case "ChallengeProheart6":
				case "ChallengeDexdomitor": 
					currentScreen.Hide(); 
					var act:String = action.substr(9); 
					currentBrand = act; 
					SetBackground(act); 
					GoToChallenge(act);					
					DisplayBrandLogo(act); 									
				break;
				
			case "Next":
				currentScreen.Hide(); 
					if (selectedChallenge.currentQuestionNumber > selectedChallenge.numOfQuestions) {
						dispatchEvent(new CustomEvent (CustomEvent.CHALLENGE_DONE, { msg:"challenge done" }, true, false));
					}else{
						selectedChallenge.GoToQuestion(selectedChallenge.currentQuestionNumber); 						
					}
					DisplayBrandLogo(currentBrand); 
				break; 
				
			case "PI":
				currentScreen.Hide(); 
					trace("displayPI"); 
					selectedChallenge.DisplayPI(); 
				break; 
				
			case "Close":
				currentScreen.Hide(); 
					selectedChallenge.ClosePI(); 
				break; 
				
			case "LearnYes":		
				currentScreen.Hide(); 
					GoToMainMenu();
				break; 
				
			case "LearnNo":			
				currentScreen.Hide(); 
					GoToSection(6); 
				break; 
				
				
			}			
		}
		
		private function HideAll():void 
		{
			attractLoop.Hide(); 			
			loginscreen.Hide(); 
			optinscreen.Hide();  
			mainmenuscreen.Hide(); 
			learnmorescreen.Hide(); 
			thanksscreen.Hide(); 
			
			for(var c:int = 0; c<challengeList.length;  c++){				
				var aChallenge:Challenge = challengeList[c] as Challenge; 												
				aChallenge.Hide(); 																				
			}				
		}
		
		private function DisplayBrandLogo(brand:String):void 
		{					
			trace("Main:: DisplayBrandLogo " + brand)
			var disContent:DisplayContent = displayscreen.getChildByName(brand) as DisplayContent; 
			attractLoop2.Hide(); 			
			disContent.HideAll(); 			
			disContent.Display(); 
			disContent.DisplayScreen("brandFile"); 
			displayscreen.addChild(disContent); 
			disContent.iconImage.visible = false; 
		}
				
		private function DisplayAnswerEvent(e:CustomEvent):void 
		{
			//trace("displayAnswerEvent:  " + e.params.msg); 
			var answerFile:String = String(e.params.msg);			
			trace("answerFile: " + answerFile); 
			DisplayAnswer(answerFile); 
			addChild(hiddenscreen); 
		}
		
		private function DisplayAnswer(_name:String):void 
		{					
			var disContent:DisplayContent = displayscreen.getChildByName(currentBrand) as DisplayContent; 					
			disContent.HideAll(); 
			disContent.Display();			
			disContent.DisplayScreen(_name); 
			displayscreen.addChild(disContent);
			disContent.iconImage.visible = true;  
			addChild(hiddenscreen);
		}
		
		private function GoToSection(forcePos:int = 0):void 
		{				
			if (sectionPos >= sectionList.length) {
				sectionPos = 0; 
			}			
			var currentSection:String = sectionList[forcePos]; 
			trace("currentSection: " + currentSection); 
				switch (currentSection) 
				{
					case "logIn":																									
						GoToLoginScreen();						
						currentScreen = loginscreen; 
					break;	
					
					case "optIn":
						GoToOptInScreen();
						currentScreen = optinscreen; 
					break;						
					
					case "mainMenu":						
						GoToMainMenu(); 
						currentScreen = mainmenuscreen; 
					break;
					
					//5
					case "learnMore": 
						touchscreen.addChild(learnmorescreen); 
						learnmorescreen.Display(); 
						currentScreen = learnmorescreen; 						
					break; 
					
					//6
					case "thanks":
					    thanksscreen.Display(); 
						thanksTimer.start(); 
						currentScreen = thanksscreen; 
					break;	
				}				
			addChild(hiddenscreen);				
	
		}
		
		private function GoToLoginScreen():void 
		{
			
			
			
			HideAll(); 
			
			astEmail.visible = true;
			astClinic.visible = true; 
			astPosition.visible = true; 
			astZip.visible = true; 
			
			loginscreen.txt_email.text = "";
			loginscreen.txt_clinic.text = "";
			loginscreen.txt_city.text = "";
			loginscreen.txt_state.text = "";
			loginscreen.txt_zip.text = "";
			loginscreen.txt_phone.text = "";	
			loginscreen.txt_position.text = "";	
			
			//let's populate fields
			loginscreen.txt_email.text = Person.email; 
			loginscreen.txt_clinic.text = Person.institution; 
			loginscreen.txt_city.text = Person.city; 
			loginscreen.txt_state.text = Person.state; 
			loginscreen.txt_zip.text = Person.zip; 
			loginscreen.txt_position.text = Person.dtitle; 		
			loginscreen.txt_phone.text = Person.phone; 
			loginscreen.txt_firstName.text = Person.firstName; 
			loginscreen.txt_lastName.text = Person.lastName;
			loginscreen.txt_address.text = Person.address;		
			//checkLoginFields(); 
			
			loginscreen.Display(); 
		}
		
		
		private function checkLoginFields() 
		{
			trace("checkLoginFields: " + checkLoginRequire); 
			
			
			if (loginscreen.txt_email.text != "") {
				astEmail.visible = false; 
				checkLoginRequire++
			}else {
				astEmail.visible = true; 
			}
			
			if (loginscreen.txt_clinic.text != "") {
				astClinic.visible = false; 
				checkLoginRequire++				
			}else {
				astClinic.visible = true; 
			}
			
			if (loginscreen.txt_position.text != "") {
				astPosition.visible = false; 
				checkLoginRequire++				
			}else {
				astClinic.visible = true; 
			}
			
			
					
			if (loginscreen.txt_zip.text != "") {
				astZip.visible = false; 
				checkLoginRequire++
			}else {
				astZip.visible = true; 
			}
			trace("checkLoginFields: " + checkLoginRequire); 
			
			

		}
		
		
		private function GoToOptInScreen(whichFrame:int = 1):void 
		{
			HideAll(); 			
			optinscreen.gotoAndStop(whichFrame); 
			optinscreen.Display();
			
			var cbVetDash:CheckBox = optinscreen.checkBoxVetDashboard as CheckBox; 
			if (whichFrame > 1) {
				trace("cbVetDash " +cbVetDash); 				
				cbVetDash.turnOff(); 
			}else {
				cbVetDash.turnOn(); 
			}
			
		}
		
		private function GoToMainMenu():void 
		{
			HideAll(); 			
			mainmenuscreen.Display();		
										
			attractLoop2.Display(); 
			displayscreen.addChild(attractLoop2);
		}
		
		private function GoToChallenge(section:String):void 
		{						
			//
			HideAll(); 
			//currentScreen.Hide(); 
			
			//Hide all the others challenges and displaycontents;
			for(var c:int = 0; c<challengeList.length;  c++){				
				var aChallenge:Challenge = challengeList[c] as Challenge; 				
				var aDisplayContent:DisplayContent = displayContentList[c] as DisplayContent; 							
				if (aChallenge.name.toLowerCase() != section.toLowerCase()){					
					aChallenge.Hide(); 	
					aDisplayContent.Hide(); 
					
				}else {	
					selectedChallenge = aChallenge; 
					aChallenge.Display(); 																						
					touchscreen.addChild(aChallenge); 					
					aChallenge.GoToQuestion(1); 										
				}
			}					
		}		
				
		// Timeout
		private function RestartTimer(e:MouseEvent):void 
		{
			trace("RestartTimer"); 
			programTimer.reset();
			programTimer.start(); 
		}		
		
		private function TimeOutLogOut(e:TimerEvent):void 
		{
			//DataManager.userSave();	
			trace("TimeOutLogOut"); 
			reset(); 			
		}
		
		private function ThanksTimerEvent(e:TimerEvent):void 
		{
			reset(); 
		}
		
		// Helpers		
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
		
		// System
		private function setCursor():void 
		{		
			if(showCursor == "true"){
				Mouse.show();
				mdm.Input.Mouse.show("MainForm");
			}else{
				Mouse.hide();
				mdm.Input.Mouse.hide("MainForm");
			}			
		}
		
		public function listFonts():void
        {
            var embeddedFonts:Array = Font.enumerateFonts(false);
			
            embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
            trace("\n\n----- Enumerate Fonts -----");
            for(var i:int = 0; i<embeddedFonts.length; i++) {
				trace(embeddedFonts[i].fontName + " type: " + embeddedFonts[i].fontType + " fontStyle: " +  embeddedFonts[i].fontStyle);
			}
        }		
		
		
	}

}