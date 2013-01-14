package com.bluetelescope.leads
{	
	import com.bluetelescope.leads.DateTimeStamp;
	
	[Bindable]
	public class Person
	{						
		public static var cardData:String = ""; 
		public static var firstName:String="";
		public static var lastName:String="";
		public static var dtitle:String="";
		public static var middle:String="";
		public static var address:String="";
		public static var address2:String = "";
		public static var zip:String="";
		public static var city:String="";
		public static var phone:String="";
		public static var country:String="";
		public static var fax:String="";
		public static var institution:String="";
		public static var state:String="";
		public static var cardId:String="";
		public static var email:String="";
		public static var projectId:String="";
		public static var dateTime:String = "";
		public static var position:String = ""; 
		
		public static var isReal:Boolean = false;  
		
		public static var personXML:XML; 
		
		// hard coded because we have formalized the order of the 'nlstirng'
		// which comes from BarCodeScanner		
		private static var fNamePos:Number = 0;
		private static var middlePos:Number = 1;
		private static var lNamePos:Number = 2;	
		private static var titlePos:Number = 3;	
		private static var institutionPos:Number = 4;
		private static var addressPos:Number = 5;
		private static var address2Pos:Number = 6;
		private static var cityPos:Number = 7;
		private static var statePos:Number = 8;
		private static var zipPos:Number= 9;
		private static var countryPos:Number = 10;		
		private static var phonePos:Number = 11;
		private static var faxPos:Number = 12;
		private static var emailPos:Number = 13;		
		private static var cardIdPos:Number = 14;				
						
		
		public static function build(data:String = null):void 
		{
			if (data == "hidden" || data == null) {
				data = "FirstName|MiddleName|LastName|MD|Org|1 Main St.|Floor 3|New York|NY|10001|USA|555-123-1234|555-123-1235|first.last@email.com|007|ATT";
				isReal = false; 
			}else {
				isReal = true; 
			}
			
			cardData = data; 								
			var userArray:Array = cardData.split("|");																								
			firstName = userArray[fNamePos];			
			lastName = userArray[lNamePos];			
			cardId = userArray[cardIdPos];			
			city = userArray[cityPos];			
			middle = userArray[middlePos];			
			country = userArray[countryPos];			
			fax = userArray[faxPos];			
			institution = userArray[institutionPos];			
			phone = userArray[phonePos];			
			state = userArray[statePos];
			dtitle = userArray[titlePos]; 
			zip = userArray[zipPos];
			address = userArray[addressPos];
			address2 = userArray[address2Pos];
			email = userArray[emailPos];
			
			personXML = 
				<user timestamp={DateTimeStamp.stamp("BT")}>					
					<badgeID>{cardId}</badgeID>
					<cardData>{cardData}</cardData>
					<userData>
						<firstName>{firstName}</firstName>
						<middleName>{middle}</middleName>
						<lastName>{lastName}</lastName>						
						<title>{dtitle}</title>
						<organization>{institution}</organization>
						<address1>{address}</address1>
						<address2>{address2}</address2>
						<city>{city}</city>
						<state>{state}</state>
						<zip>{zip}</zip>
						<country>{country}</country>
						<phone>{phone}</phone>
						<fax>{fax}</fax>
						<email>{email}</email> 
					</userData>							
					<data>
						<quiz/>
						<screenList/>
						<cartList/>						
						<multiUserSession/>
					</data>
					<misc />								
				</user>;			
		}
		
		public static function Update():void 
		{
			
			
		}
		
		public static function reset():void 
		{
			firstName = "";			
			lastName = "";		
			cardId = "";		
			city = "";			
			middle = "";			
			country = "";			
			fax = "";			
			institution = "";			
			phone = "";			
			state = "";
			dtitle = ""; 
			zip = "";
			address = "";
			address2 = "";
			email = "";		
						
			isReal = false; 
			personXML = null; 
		}
		
		public static function addData(dataKind:String, dataXML:XML) 
		{				
			var addNode:XML = new XML(dataXML.children()[0].toXMLString());			
			
			//trace("dataKind: " + dataKind); 
			
			switch (dataKind) 
			{
			case "quiz":
					personXML.data.quiz.appendChild(addNode); 
					//trace(" Person.addData " + addNode); 
				break;
				
			case "screenList":
					personXML.data.screenList.appendChild(addNode); 
				break;
				
			case "cartList":
					personXML.data.cartList.appendChild(addNode); 
				break; 
				
			case "multiUserSession":
					personXML.data.multiUserSession.appendChild(addNode); 
				break; 
			
			
			case "miscData":
					//personXML.misc.appendChild(addNode); 
					personXML.replace("misc", addNode); 
				break; 
								
			}
			
			//trace("personXML: \n" + personXML.toString()); 		
		}
				
		public static function displayPersonInfo():String
		{
			var str:String = "firstName: " + firstName + "\n"; 
			str += "middle: " + middle + "\n";
			str +="lastName: " + lastName + "\n";
			str +="title: " + dtitle + "\n"; 			
			str +="institution: " + institution + "\n"; 
			str +="address: " + address + "\n";
			str +="address2: " + address2 + "\n";
			str +="city: " + city + "\n";
			str +="state: " + state + "\n";				
			str +="zip: " + zip + "\n";	
			str +="country: " + country + "\n";
			str +="phone: " + phone+ "\n";
			str +="fax: " + fax + "\n";
			str +="email: " + email+ "\n";
			str +="cardId: " + cardId; 
			
			return str; 
			
			
		}
				
		
		
	}
}