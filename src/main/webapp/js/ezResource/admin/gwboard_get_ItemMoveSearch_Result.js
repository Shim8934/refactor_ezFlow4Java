
function window.onload()
{
		var rep = new RegExp( "&", "gi" );
		pUpNm = pUpNm.replace( rep, "chr(38)" );
}

function cmdSelect_onclick(){
	var para = new Array();
	var retVal = new Array();

	var url = "Organ.aspx"
	
	para[0] = OrgBrd_id;
	para[1] = pCompanyID;

	retVal = window.showModalDialog(url,para,"dialogWidth:265px;dialogHeight:450px;status:no;help:no;edge:sunken");

	if ( typeof(retVal) != "undefined" )
	{
		p_TBrd_Level	= retVal[0];	
		p_TBrd_Ref		= retVal[1];	
		p_TBrd_ID		= retVal[2];	
		p_TBrd_UpID		= retVal[3];	
		p_TBrd_NM		= retVal[4];	
		p_TBrd_Explain	= retVal[5];	
		txtTBrd_NM.innerText = p_TBrd_NM;	 
	}
}


function TrimText( orgStr )
{
	var copyStr = "";
	var strIndex;

	for ( strIndex = 0; strIndex < orgStr.length; strIndex ++ ) {
		if ( orgStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = orgStr.substr( strIndex );
			break;
		}
	}
	
	for ( strIndex = copyStr.length - 1; strIndex >= 0; strIndex -- ) {
		if ( copyStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = copyStr.substr( 0, strIndex + 1 );
			break;
		}
	}
	return copyStr;
}

/*
function btn_ItemMove_onclick()
{	
	var Brd_NM = txtTBrd_NM.innerText;
	var pBrd_NM = TrimText( Brd_NM );

	if  (pBrd_NM == "")
	{
		alert("" + strLang2 + "");
	}
	else if ( OrgBrd_id == p_TBrd_ID)
	{
		alert("" + strLang3 + "");
	}
	else 
	{
		var checkYN=0;
		var vItemNo;
		var result="";
		var pMoveItemcnt = 0;

		if (document.frmOutbox.length <= 1 )
		{
 			if (document.frmOutbox.item(0).checked  == true)
			{
				checkYN = checkYN +1;
				
				pItem_Level = Item_Level.value;
				
				if (pItem_Level == "0") 
				{
					result+= document.frmOutbox.item(0).value+ ";"
					MovetemList = result.split(";")
					pMoveItemcnt = 1
				}
			}	
 		
 		}
 		else
		{
			for (var icnt=0 ; icnt < document.frmOutbox.length ; icnt++)
			{
				if (document.frmOutbox.item(icnt).checked  == true)
				{
					checkYN = checkYN +1;
					pItem_Level = Item_Level(icnt).value;
				
					if (pItem_Level == "0") 
					{
						result+= document.frmOutbox.item(icnt).value + ";"
						MovetemList = result.split(";")
						pMoveItemcnt =pMoveItemcnt+1
					}
				}	
			}
		}
		
	
		if (checkYN == 0)
		{
			alert("" + strLang4 + "");
		}
		else
		{
			result = confirm("" + strLang5 + "");
		
				if (  result == true && pMoveItemcnt > 0)
				{
					var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
					var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
					var resultXML = new ActiveXObject("Microsoft.XMLDOM");
				
				
					var objRoot = xmlDoc.createNode(1,"ITEMDATA","");
					xmlDoc.appendChild(objRoot);
						
					var objNode1 = xmlDoc.createNode(1,"BRD_ID","");       
					objNode1.text = OrgBrd_id;
					objRoot.appendChild(objNode1);
					
					var objNode2 = xmlDoc.createNode(1,"TARGET_ID","");    
					objNode2.text = p_TBrd_ID;
					objRoot.appendChild(objNode2);

					var objNode3 = xmlDoc.createNode(1,"USER_ID","");      
					objNode3.text = pUserID;
					objRoot.appendChild(objNode3);
                    
                    var objNode4 = xmlDoc.createNode(1,"USER_NM","");      
					objNode4.text = pUserNM;
					objRoot.appendChild(objNode4);
					
					var objNode5 = xmlDoc.createNode(1,"USER_EMAIL","");   
					objNode5.text = pUserEmail;
					objRoot.appendChild(objNode5);
					
					var objNode6 = xmlDoc.createNode(1,"DEPT_ID","");     
					objNode6.text = pDeptID;
					objRoot.appendChild(objNode6);

					var objNode7 = xmlDoc.createNode(1,"PATH","");        
					objNode7.text = pPath;
					objRoot.appendChild(objNode7);
				
					var objNode8 = xmlDoc.createNode(1,"ITEMLIST","");	  
				
					for (var i=0; i <= MovetemList.length -2; i++)
					{
						var objNode9 = xmlDoc.createNode(1,"ITEM_NO","");       
						objNode9.text = MovetemList[i];
						objNode8.appendChild(objNode9);  
					}
				
					objRoot.appendChild(objNode8);
					
					var objNode9 = xmlDoc.createNode(1,"STRPARA","");     
					objNode9.text = pCompanyID;
					objRoot.appendChild(objNode9);
		        
					xmlHttp.Open("POST", "Call_MoveCopyItem.asp", false);
					
					xmlHttp.send(xmlDoc.xml);
					
					var MovRes = xmlHttp.responseText;

					if ( MovRes == "TRUE")
					{
						var pURL;	
						pURL = "gwboard_get_ItemMoveSearch_Result.asp?Brd_id="+OrgBrd_id +"&brd_nm=" + pUpNm + "&Brd_mod=" + pBrdMod + "&Menu=" + pMenu;
						pURL = pURL + "&SelCompanyID=" + pCompanyID;
						document.brds.target = "_self"; 
						document.brds.action = pURL;
						document.brds.submit();
					}
					else
					{				
						alert("" + strLang6 + "");
					}
				}
			}
			xmlHttp=null;
			xmlpara=null;
		}
}
*/

/*
function btn_ItemMoveALL_onclick()
{
	var Brd_NM = txtTBrd_NM.innerText;
	var pBrd_NM = TrimText( Brd_NM );
	
	if  (pBrd_NM == "")
	{
		alert("" + strLang2 + "");
	}
	else if ( OrgBrd_id == p_TBrd_ID)
	{
		alert("" + strLang3 + "");
	}
	else
	{
		var checkYN=0;
		var vItemNo;
		var result="";
		var pMoveItemcnt = 0;
		
		if (document.frmOutbox.length < 1 ){
			alert("" + strLang4 + "");
		}
		else{
			result = confirm("" + strLang5 + "");
		
			if (  result == true )
			{
				var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
				var resultXML = new ActiveXObject("Microsoft.XMLDOM");
					
					
				var objRoot = xmlDoc.createNode(1,"ITEMDATA","");
				xmlDoc.appendChild(objRoot);
							
				var objNode1 = xmlDoc.createNode(1,"BRD_ID","");     
				objNode1.text = OrgBrd_id;
				objRoot.appendChild(objNode1);
						
				var objNode2 = xmlDoc.createNode(1,"TARGET_ID","");  
				objNode2.text = p_TBrd_ID;
				objRoot.appendChild(objNode2);

				var objNode3 = xmlDoc.createNode(1,"USER_ID","");    
				objNode3.text = pUserID;
				objRoot.appendChild(objNode3);
			            
			    var objNode4 = xmlDoc.createNode(1,"USER_NM","");    
				objNode4.text = pUserNM;
				objRoot.appendChild(objNode4);
						
				var objNode5 = xmlDoc.createNode(1,"USER_EMAIL",""); 
				objNode5.text = pUserEmail;
				objRoot.appendChild(objNode5);
						
				var objNode6 = xmlDoc.createNode(1,"DEPT_ID","");    
				objNode6.text = pDeptID;
				objRoot.appendChild(objNode6);

				var objNode7 = xmlDoc.createNode(1,"PATH","");       
				objNode7.text = pPath;
				objRoot.appendChild(objNode7);
					
				var objNode8 = xmlDoc.createNode(1,"SUser_NM","");	 
				objNode8.text = document.brds.User_NM.value;
				objRoot.appendChild(objNode8);  
				
				var objNode9 = xmlDoc.createNode(1,"STitle","");	 
				objNode9.text =  document.brds.Title.value;
				objRoot.appendChild(objNode9);  
				
				var objNode10 = xmlDoc.createNode(1,"SSPost_DATE","");
				objNode10.text = document.brds.SPost_DATE.value;
				objRoot.appendChild(objNode10);  
				
				var objNode11 = xmlDoc.createNode(1,"SSEPost_DATE","");
				objNode11.text = document.brds.EPost_DATE.value;
				objRoot.appendChild(objNode11);  
				
				var objNode12 = xmlDoc.createNode(1,"SSEnd_DATE","");	
				objNode12.text = document.brds.SEnd_DATE.value;
				objRoot.appendChild(objNode12);  
			        
			    var objNode13 = xmlDoc.createNode(1,"SEEnd_DATE","");	
				objNode13.text = document.brds.EEnd_DATE.value;
				objRoot.appendChild(objNode13); 
				
				var objNode14 = xmlDoc.createNode(1,"STRPARA","");      
				objNode14.text = pCompanyID;
				objRoot.appendChild(objNode14);
				
				xmlHttp.Open("POST", "Call_ALLMoveCopyItem.asp", false);
				xmlHttp.send(xmlDoc.xml);
						
				var MovRes = xmlHttp.responseText;

				if ( MovRes == "TRUE")
				{
					
					var pURL;	
					pURL = "gwboard_get_ItemMoveSearch_Result.asp?Brd_id="+OrgBrd_id +"&brd_nm=" + pUpNm + "&Brd_mod=" + pBrdMod + "&Menu=" + pMenu;
					pURL = pURL + "&SelCompanyID=" + pCompanyID;
					document.brds.target = "_self"; 
					document.brds.action = pURL;
					document.brds.submit();
				}
				else
				{				
					alert("" + strLang6 + "");
				}
			}			
				xmlHttp=null;
				xmlpara=null;
		}
	}
}
*/

/*
function btn_ItemUpdate_onclick( )
{
	var checkYN=0;
	var vItemNo;
	var result="";
	var pModify;
	var vItemNo;
	var pBoardID;

	if (document.frmOutbox.length < 1 )
	{
 		if (document.frmOutbox.item.checked  == true)
		{
			checkYN = checkYN +1;
			result+= document.frmOutbox.item.value+ ";"
				
			var MovetemList = result.split(";")
			
		}	
		
		i=0;
 		
 	}
 	else
 	{
		for (var icnt=0 ; icnt < document.frmOutbox.length ; icnt++)
		{
			if (document.frmOutbox.item(icnt).checked  == true)
			{
				checkYN = checkYN +1;
				result+= document.frmOutbox.item(icnt).value + ";"

				var MovetemList = result.split(";")

				i=icnt;
			}	
		}
	}
	
	
	
	if (checkYN == 0)
	{
		alert("" + strLang7 + "");
	}
	else if (checkYN >1)
	{
		alert("" + strLang8 + "");
	}
	else if (checkYN = 1)
	{
		
		if ( document.frmOutbox.length <  2)
		{	
			OrgBrd_id = MyBrdID.value;

			pItem_Level = Item_Level.value;
			vItemNo = vItem_ID.value;

		}
		else
		{
			OrgBrd_id = MyBrdID(i).value;
				
			pItem_Level = Item_Level(i).value;
			vItemNo = vItem_ID(i).value;
			
		}
		
		if ( pItem_Level == "0")
			pModify = "Modify"
		else
			pModify = "ReModify"
		
		var pURL =  "/Myoffice/ezboard/gwBoard_Post_item.asp?Mod=" + pModify +  "&BoardID=" +OrgBrd_id + "&ItemID=" + vItemNo + "&Brd_mod=" + pBrdMod + "&brd_nm=" + pUpNm;
		pURL = pURL + "&GoTopage=" +  pGoToPage  + "&Menu=" + pMenu + "&SelCompanyID=" + pCompanyID + "&pbrdGubun=" + brdGubun;

		var openLocation = pURL;
		openwindow(openLocation, "" , 880 , 550);

	}
	   
}
*/

function Search_Set()
{
	var pURL;
	
	pGoToPage = document.frmSelPage.SelPage.value;
	
    pURL = "gwboard_get_ItemMoveSearch_Result.aspx?GoTopage=" +  pGoToPage + "&brd_id=" +OrgBrd_id;
    pURL = pURL + "&brd_nm=" +  pUpNm + "&Brd_mod=" + pBrdMod + "&Menu=" + pMenu  + "&SelCompanyID=" + pCompanyID + "&pbrdGubun=" + brdGubun;
    document.brds.target ="_self";
	document.brds.action = pURL;
	document.brds.submit();
}


function openwindow(wfileLocation , wName , wWeigth , wHeigth)
{

	try{
		
		var heigth = window.screen.availHeight;
		var width = window.screen.availWidth;
		
		var left = 0;
		var top = 0;
			
		if(window.screen.width > 800)
		{

			var pleftpos;
			
			pleftpos = parseInt(width) - 700;
			heigth = parseInt(heigth) - 176;
			width = parseInt(width) - pleftpos;
			left = pleftpos / 2;
					
		}else{
			
			heigth = parseInt(heigth) - 30;
			width = parseInt(width) - 10;
			
		}
		
	    if ( wName == "" )
		{
			window.open(wfileLocation,wName,"toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
		}
		else
		{
			
			window.open("",wName,"toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
			document.brds.target = "list"; 
			document.brds.action = wfileLocation;
			document.brds.submit();

		}	
	
	}catch(e){
	
		alert("openwindow :: " + e.description);
		
	}

}


