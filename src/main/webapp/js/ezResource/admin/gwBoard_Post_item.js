

var pHasAttachYN =0;     
var pAttachListXml="";	  


function onReservationDateChaked()
{
	var cDate = new Date();
	var rDate = idDatepicker.value;
	var tDate ;
	var pCDateMonth, pCDateDate, pCDateHours , pCDateMinutes;
	
	if (_T1.value.substring(0,2) == "" + strLang15 + "" )
	{	
		var pDateSplit = _T1.value.split(" ");
		var cTime = pDateSplit[1].split(":");
						
		if ( cTime[0] < 10 )
			pReservationTime = "0" +_T1.value.substring(3,8)
		else
			pReservationTime = _T1.value.substring(3,8)
	}
	else
	{
		pReservationTime =  idDatepicker.startHours + ":" + idDatepicker.startMinutes ;
	}
	
	if ( (cDate.getMonth() +1) < 10 )
			pCDateMonth = "0" + (cDate.getMonth() +1);
	else
			pCDateMonth = cDate.getMonth() +1;
	
	if (  cDate.getDate() < 10 )
			pCDateDate = "0" + cDate.getDate();
	else
			pCDateDate = cDate.getDate();
			
	if (cDate.getHours() < 10)
			pCDateHours = "0" + cDate.getHours();
	else
			pCDateHours = cDate.getHours();
	
	if (cDate.getMinutes() < 10 )
			pCDateMinutes = "0" + cDate.getMinutes();
	else
			pCDateMinutes = cDate.getMinutes();

	if ( (_D2.value) < (idDatepicker.value) )
	{
		idDatepicker.value = "";
		alert("" + strLang16 + "");
		g_winDocAll['idDatepicker'].vtLocalDate= cDate;
		idDatepicker.value = "";
		_T1.value ="";
	    
	}  
}

function onTodayReservationDateChaked()
{
	var cDate = new Date();
	var pCDateMonth, pCDateDate, pCDateHours , pCDateMinutes;
    
	if (_T1.value.substring(0,2) == "" + strLang15 + "" )
	{	
		var pDateSplit = _T1.value.split(" ");
		var cTime = pDateSplit[1].split(":");
						
		if ( cTime[0] < 10 )
			pReservationTime = "0" +_T1.value.substring(3,8)
		else
			pReservationTime = _T1.value.substring(3,8)
	}
	else
	{
		pReservationTime =  idDatepicker.startHours + ":" + idDatepicker.startMinutes ;
	}
	
    
	if ( (cDate.getMonth() +1) < 10 )
			pCDateMonth = "0" + (cDate.getMonth() +1);
	else
			pCDateMonth = cDate.getMonth() +1;
	
	if (  cDate.getDate() < 10 )
			pCDateDate = "0" + cDate.getDate();
	else
			pCDateDate = cDate.getDate();
			
	if (cDate.getHours() < 10)
			pCDateHours = "0" + cDate.getHours();
	else
			pCDateHours = cDate.getHours();
	
	if (cDate.getMinutes() < 10 )
			pCDateMinutes = "0" + cDate.getMinutes();
	else
			pCDateMinutes = cDate.getMinutes();
    
	if (idDatepicker.value != "") 
	{
	    if (_T1.value != "")
			var pResDate = idDatepicker.value.substring(0,10) + " " + pReservationTime ;
		else
			var pResDate = idDatepicker.value.substring(0,10)
			
			
		var pCDate =cDate.getYear()+"-"+ pCDateMonth+ "-" + pCDateDate + " " + pCDateHours + ":" + pCDateMinutes;
	
	
		if ( pCDate > pResDate)
		{
			alert("" + strLang17 + "");
			g_winDocAll['idDatepicker'].vtLocalDate= cDate;
			idDatepicker.value = "";
			_T1.value ="";
			
			return false;
		}
	}
	return true;
}


function SaveItemInfo_onClick()
{
	var strCheck = InsertInfoCheck();
	
	if (strCheck)
		SaveItemInfo();

		
}


function btn_AttachFile_Onclick()
{
	
	if ( SelBoardNM.value == "")
	{
		if ((pBrdMod =="MyBoard" || pBrdMod =="TotalBoard" || pBrdMod =="ResBoard") && pMod == "New") 
		{
				alert("" + strLang18 + "");
	
				SelBoardNM.focus();
		
				return;
		}
	}
	else
	{
		var Para = new Array();
		var url = "../Item_Attach_Main.asp";
			 
		Para["MODE"] = pMod;
		Para["USERID"] = pUserID;
		Para["BOARDID"] = pBoardID;	
		Para["ITEMID"] = pItemNo;	
		Para["WindowOpener"] = window;
		Para["BoardFileSize"] = pBoardFileSize;
			
		if (pAttachListXml != "" && typeof(Para) != "undefined" )
		{
			Para["ATTACHLISTXML"] = pAttachListXml;
		}
		else
		{
			Para["ATTACHLISTXML"] = ""
		}	
	
		window.showModalDialog(url, Para,"dialogWidth:386px;dialogHeight:270px; status:no; scroll:NO; help:no");
	}
	
}



function AppendFileAttachInfo(ret)
{
  
	try{
        
        pAttachListXml = ret;
        
		var xmlAttach = new ActiveXObject("Microsoft.XMLDOM");
		var rep
  
		xmlAttach.loadXML(ret);
		var objAttachNodes = xmlAttach.selectNodes("LISTVIEWDATA/ROWS/ROW");
		lstAttachLink.innerHTML = "";
		var strAttach = "";
		strPreViewAttach = "";
		rep = /'/g;
	
		for (i = 0 ; i < objAttachNodes.length ; i++ )
		{
			
			strAttach = strAttach + "<IMG SRC='../Images/attach-small.gif'>";
			var IncodFileNM = escape(objAttachNodes(i).childNodes.item(0).childNodes.item(1).text);
			strAttach = strAttach + "<a href='" + IncodFileNM.replace(rep, "&#39;") + "' target='_blank'>" 
			strAttach = strAttach + objAttachNodes(i).childNodes.item(0).childNodes.item(0).text + "&nbsp;(" +  objAttachNodes(i).childNodes.item(1).childNodes.item(0).text   + ")</a>&nbsp; "
		    strPreViewAttach = strPreViewAttach + "<IMG SRC='../Images/attach-small.gif'>";
		    strPreViewAttach = strPreViewAttach + objAttachNodes(i).childNodes.item(0).childNodes.item(0).text + "&nbsp;(" +  objAttachNodes(i).childNodes.item(1).childNodes.item(0).text   + ")&nbsp";
		}
	  
		lstAttachLink.innerHTML = strAttach;
	
	}catch(e){
    
		alert("showAttachFiles :: " + e.description);
    
	}

}


function AttachFileList( objNode )
{
	var pFileSize;
	var xmlDOM = new ActiveXObject("Microsoft.XMLDOM");
		
	var Rtnxml = new ActiveXObject("Microsoft.XMLDOM");
	var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
	
	Rtnxml.loadXML(pAttachListXml);
					
	var objAttachNodes = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
		
	for(i = 0 ; i < objAttachNodes.length ; i++)
	{
		var fileNode = xmlDOM.createElement("FILE");
			
		attrFileSize  = xmlDOM.createNode(2, "FILESZ", "");
		pFileSize = objAttachNodes(i).childNodes.item(0).childNodes.item(6).text;
		attrFileSize.text =pFileSize;
			
		fileNode.attributes.setNamedItem(attrFileSize);
			
		fileNode.text = objAttachNodes(i).childNodes.item(0).childNodes.item(2).text;
			
		objNode.appendChild(fileNode);
	}
		
	if ( objAttachNodes.length >0 )
	{
	
		pHasAttachYN = 1
	
	} 
}


 
function getItemInfo()
{
  try{
  
    var objRoot;
    var objNode;
    
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
       
    objRoot = xmlpara.createNode(1,"PARAMETER","");	
	xmlpara.appendChild(objRoot);
    
    objNode = xmlpara.createNode(1, "pBoardID", "");	
	objNode.text = pBoardID;
	xmlpara.documentElement.appendChild(objNode)
	
	objNode = xmlpara.createNode(1, "pItemID", "");	
	objNode.text = pItemID;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "pUserID", "");
	objNode.text = pUserID;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "pDeptID", "");	
	objNode.text = pDeptID;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "SearchGroup", "");	
	objNode.text = pSearchGroup;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "BoardKind", "");	
	objNode.text = pBoardKind;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1, "SearchYN", "");	
	objNode.text = pSearchYN;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1,"STRPARA","");    
	objNode.text = pCompanyID;
	objRoot.appendChild(objNode);
	

	xmlhttp.open ("Post","Call_AminItemReadAllXML.asp",false);
	
    xmlhttp.send(xmlpara);
    
    var Resultxml = xmlhttp.responseXML; 
    
	objRoot = Resultxml.documentElement;

  	if(objRoot != null)
  	{
	    pItemNo= Resultxml.documentElement.selectSingleNode("ITEM_NO").text;
	    pHasAttach= Resultxml.documentElement.selectSingleNode("HASATTACH").text;
	    pWriteUserNm= Resultxml.documentElement.selectSingleNode("USER_NM").text;
	    pTitle= Resultxml.documentElement.selectSingleNode("TITLE").text;
	    pContent= Resultxml.documentElement.selectSingleNode("CONTENT").text;
	    pPostDate= Resultxml.documentElement.selectSingleNode("POST_DATE").text;
	    pReadCnt= Resultxml.documentElement.selectSingleNode("READ_CNT").text;
	    pItemGb= Resultxml.documentElement.selectSingleNode("ITEM_GB").text;
	    pWriteUserID= Resultxml.documentElement.selectSingleNode("USER_ID").text;
	    pBoardID= Resultxml.documentElement.selectSingleNode("BRD_ID").text;
	    pEndDate= Resultxml.documentElement.selectSingleNode("END_DTE").text;
	    pBonjum= Resultxml.documentElement.selectSingleNode("BONJUM").text;
		pYoungup= Resultxml.documentElement.selectSingleNode("YOUNGUP").text;
		pImwon= Resultxml.documentElement.selectSingleNode("IMWON").text;
		pChajang= Resultxml.documentElement.selectSingleNode("CHAJANG").text;
		pGwajang= Resultxml.documentElement.selectSingleNode("GWAJANG").text;
		pMemo= Resultxml.documentElement.selectSingleNode("MEMO").text;
		pBrdNM= Resultxml.documentElement.selectSingleNode("BRDNM").text;
		pItem_level= Resultxml.documentElement.selectSingleNode("ITEM_LEVEL").text;
		
    }
  
  
  }catch(ErrMsg){
    alert(ErrMsg.description);
  }
}


function InsertItemInfo()
{
	var vEndDate;
	
	if (pMod == "Modify")
	{
		var pDate = new Date();
	    var vEndDate =pEndDate.split("-");
	    var vDate= vEndDate[2].split(" ");
	    g_winDocAll['idDatepicker'].vtLocalEndDate= pDate.setFullYear(vEndDate[0],vEndDate[1]-1,vDate[0]);
	    ModInnitEndDate = vEndDate[0] + "-" + vEndDate[1] + "-" +  vDate[0];
	    _D2.value =vEndDate[0] + "-" + vEndDate[1] + "-" + vDate[0];
	 }

	 if (  pMod == "Modify" || pMod == "ReModify" )
	 {
		memo.value =pMemo;
		title.value = pTitle;
	 }
	 else if (  pMod == "Reply")
	 {
		title.value = "[" + strLang19 + "" + pTitle;
	 }
	    
	 
	 if ( pMod == "Modify" || pMod == "Reply" || pMod == "ReModify")
	 {
	    if ( pDeptBoardYN != "true"){
		}
			
		SelBoardNM.value = pBrdNM;
			
	}
	else if (pMod == "New")
	{
		SelBoardNM.value = pBrdnm;
	}
	
}


function getAttachList()
{
  try{
  
    var objRoot;
    var objNode;
    
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
       
    objRoot = xmlpara.createNode(1,"PARAMETER","");	
	xmlpara.appendChild(objRoot);
    
    objNode = xmlpara.createNode(1, "pBoardID", "");	
	objNode.text = pBoardID;
	xmlpara.documentElement.appendChild(objNode)
	
	objNode = xmlpara.createNode(1, "pItemID", "");	
	objNode.text = pItemNo;
	xmlpara.documentElement.appendChild(objNode);
	
	objNode = xmlpara.createNode(1,"STRPARA","");   
	objNode.text = pCompanyID;
	objRoot.appendChild(objNode);
  
    xmlhttp.open ("Post","../Call_ItemAttachList.asp",false);
    xmlhttp.send(xmlpara);
    
    var Resultxml = xmlhttp.responseXML; 
    objRoot = Resultxml.documentElement;
    
    var ret = Resultxml.xml
	
  	if(objRoot != null)
  	{
  	   pAttachListXml  = ret;
       AppendFileAttachInfo(ret);
    }
  
  
  }catch(ErrMsg){
  
    alert(ErrMsg.description);
  
  }

}


function pzFormProc_DocumentComplete()
{
    if (flag == false) 
	{
		flag = true;
		    
		FormProc	= pzFormProc.object;
		pzFormProc.MHTMLSave =1;
		
		
		if (pMod == "Modify" || pMod == "ReModify" )
		{
			getItemInfo();	
			InsertItemInfo();
			
			if (pContent != "")
			{
			     	   
				var URL = document.location.protocol + "//" + document.location.hostname + pContent;  
				FormProc.LoadURL(URL);
			}
			
			
			if (pHasAttach == "1")
			{
				getAttachList();   
			}
		}
		else if (pMod == "Reply") 
		{
			 getItemInfo();	
			 InsertItemInfo();
		
		}
		else if (pMod == "New")
		{
			InsertItemInfo();
		}
	 }
     
      pzFormProc.editor.DOM.body.setAttribute("free", " ");
}


function InsertInfoCheck()
{

	if ( pDeptBoardYN != "true")
	{
	
		if (bonjum.checked == true)
	
			 ibonjum = bonjum.value;
		else
			 ibonjum  = "0";
			
	
		if (youngup.checked == true)
	
			iyoungup = youngup.value;
		else
			iyoungup = "0";
			
	
		if (imwon.checked == true)
	
			iimwon = imwon.value;
		else
			iimwon = "0";
	
	
		if (chajang.checked == true)
	
			ichajang = chajang.value;
		else
			ichajang = "0";
			
	
		if (gwajang.checked == true)
	
			igwajang = gwajang.value;
		else
			igwajang = "0";
	}	
	
	if  ( title.value == "" )
	{
		alert("" + strLang20 + "");
		
		title.focus();
	
		return;	
	}
		
	if ( pDeptBoardYN != "true")
	{	
		if  ( ibonjum == "0" && iyoungup =="0" )
		{
			alert("" + strLang21 + "");
			
			bonjum.focus();
	
			return;	
		}
    
		if  ( iimwon == "0" && ichajang =="0" && igwajang =="0" )
		{
			alert("" + strLang22 + "");
			
			imwon.focus();
	
			return;	
		}
	}
	
	if ((pBrdMod =="MyBoard" || pBrdMod =="TotalBoard" || pBrdMod =="ResBoard") && pMod == "New") 
	{
		if ( SelBoardNM.value == "")
		{
			alert("" + strLang23 + "");
	
			SelBoardNM.focus();
		
			return;
		}
	}
	
	
	if (idDatepicker.value == ""  && _T1.value !="")
	{
		alert("" + strLang24 + "");
		_T1.value ="";
		return;
	}
	
	
	var pRtn = onTodayReservationDateChaked();
	
	if (pRtn == false)
	{
		return;
	}
	
	
	return true;
}



function  SaveItemInfo()
{
	var pDate = new Date();
	var bEndDate = _D2.value.substring(0,10).split("-");
	var cEndDate = pDate.setFullYear(bEndDate [0],bEndDate[1],bEndDate[2]);
	
	if ( idDatepicker.value  )
	{
		var bPostDate = _D2.value.substring(0,10).split("-");
		var cPostDate = pDate.setFullYear(bPostDate [0],bPostDate[1],bPostDate[2]);
	} 
	
	
	if (isNaN(cEndDate) ) 
	{
		alert( "" + strLang25 + "");
		return;
	}
	else if ( idDatepicker.value != "" && isNaN(cPostDate))
	{
		alert( "" + strLang26 + "");
		return;
	}
	else
	{
	
		var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		var resultXML = new ActiveXObject("Microsoft.XMLDOM");
			
		var objRoot = xmlDoc.createNode(1,"ITEMDATA","");
		xmlDoc.appendChild(objRoot);
			
		var objNode1 = xmlDoc.createNode(1,"BRD_ID","");      
		objNode1.text = pBoardID;
		objRoot.appendChild(objNode1);
			
		var objNode2 = xmlDoc.createNode(1,"USER_ID","");     
		objNode2.text = pUserID;
		objRoot.appendChild(objNode2);
			
		var objNode3 = xmlDoc.createNode(1,"USER_NM","");     
		objNode3.text = pUserNM;
		objRoot.appendChild(objNode3);

		var objNode4 = xmlDoc.createNode(1,"USER_EMAIL","");  
		objNode4.text = pUserEmail;
		objRoot.appendChild(objNode4);

  		var objNode5 = xmlDoc.createNode(1,"SUBJECT","");     
		objNode5.text = title.value;
		objRoot.appendChild(objNode5);

		var objNode6 = xmlDoc.createNode(1,"CONTENT","");     
		objNode6.text = FormProc.DocumentHTML;
		objRoot.appendChild(objNode6);

		var objNode7 = xmlDoc.createNode(1,"END_DATE","");    
		objNode7.text = _D2.value.substring(0,10)+" 23:59:59";
		objRoot.appendChild(objNode7);
	

		var objNode8 = xmlDoc.createNode(1,"ATTACHLIST","");  
		AttachFileList(objNode8);
		objRoot.appendChild(objNode8);
    
		var objNode9 = xmlDoc.createNode(1,"PATH","");        
		objNode9.text = pPath;
		objRoot.appendChild(objNode9);

		var objNode10 = xmlDoc.createNode(1,"USER_DEPTNM","");
		objNode10.text = pDeptNM;
		objRoot.appendChild(objNode10);
	
		var objNode11 = xmlDoc.createNode(1,"BONJUM",""); 
		objNode11.text = ibonjum;	
		objRoot.appendChild(objNode11);
	
		var objNode12 = xmlDoc.createNode(1,"YOUNGUP","");
		objNode12.text = iyoungup;
		objRoot.appendChild(objNode12);
	
		var objNode13 = xmlDoc.createNode(1,"IMWON","");
		objNode13.text = iimwon;
		objRoot.appendChild(objNode13);
	
		var objNode14 = xmlDoc.createNode(1,"CHAJANG","");
		objNode14.text = ichajang;
		objRoot.appendChild(objNode14);
	
		var objNode15 = xmlDoc.createNode(1,"GWAJANG","");
		objNode15.text = igwajang;
		objRoot.appendChild(objNode15);
	
		var objNode16 = xmlDoc.createNode(1,"HASATTACH","");		
		objNode16.text = pHasAttachYN;
		objRoot.appendChild(objNode16);

	
		var objNode17 = xmlDoc.createNode(1,"RESERVATION_DATE",""); 
	
		if ( idDatepicker.value  )
		{
			if (_T1.value )
			{
				
				var pReservationTime;
						
				var pDateSplit = _T1.value.split(" ");
				var cTime = pDateSplit[1].split(":");
						
				if (_T1.value.substring(0,2) == "" + strLang15 + "" )
				{	
					if ( cTime[0] < 10 )
						pReservationTime = "0" +_T1.value.substring(3,8)
					else
						pReservationTime = _T1.value.substring(3,8)
				}
				else
				{
					if ( cTime[0] < 10 )
						pReservationTime =  idDatepicker.startHours + ":" + _T1.value.substring(5,7) ;
					else
						pReservationTime =  idDatepicker.startHours + ":" + _T1.value.substring(6,8) ;
				}
				
				pReservationTime =idDatepicker.value.substring(0,10) + " "+ pReservationTime;
			}
			else
			{
				pReservationTime = idDatepicker.value.substring(0,10) + " 00:00:00";
			}
			
			objNode17.text  = pReservationTime;
		}
		else
		{
			objNode17.text = "";
		}
		objRoot.appendChild(objNode17);
	
   	
   		var objNode18 = xmlDoc.createNode(1,"MEMO","");  
		objNode18.text = memo.value;
		objRoot.appendChild(objNode18);
	
		var objNode19 = xmlDoc.createNode(1,"SRC_NO","");
		objNode19.text = pItemNo;
		objRoot.appendChild(objNode19);
	
		var objNode20= xmlDoc.createNode(1,"USER_DEPTID",""); 
		objNode20.text = pDeptID;
		objRoot.appendChild(objNode20);
		
		var objNode21= xmlDoc.createNode(1,"USER_JOBTITLE","");
		objNode21.text = pJobTitle;
		objRoot.appendChild(objNode21);
		
		var objNode22= xmlDoc.createNode(1,"STRPARA","");   
		objNode22.text = pCompanyID;
		objRoot.appendChild(objNode22);
	
		var objNode23 = xmlDoc.createNode(1,"MUID","");		
		objNode23.text = "";
		objRoot.appendChild(objNode23);
		
		var objNode24 = xmlDoc.createNode(1,"QUEUEYN","");  
		objNode24.text = "N";
		objRoot.appendChild(objNode24);
		
		var objNode25 = xmlDoc.createNode(1,"CPCHECKYN","");
		objNode25.text = "N";
		objRoot.appendChild(objNode25);
		
		var objNode26 = xmlDoc.createNode(1,"MCOMPANYYN",""); 
		objNode26.text = "N";
		objRoot.appendChild(objNode26);
		
		xmlHttp.Open("POST","../Call_ezModifyItem.asp",false);
		
		xmlHttp.Send(xmlDoc.xml);
	
		btnClose_onclick();
	
	}
	
}


function btn_Print_Onclick()
{
	window.print();
}



function btn_Save_Onclick()
{

  if(typeof(FormProc) != "undefined")
  {
  
	    FormProc.FileSaveDlg("");
  }
}


function btn_SelBoard_Onclick()
{

	var para = new Array();
	var retVal = new Array();
	var url = "../Board_Select.htm"
	
	para["USERID"] = pUserID;
	para["DEPTID"] = pDeptID;
	para["ADMINYN"] = pBoardAdminYN ;
	para["SEARCHGROUP"] = "A00";
	
	if (pBrdMod =="WorkBoard") 
		para["ORGBRDID"] = pBoardID;
	else
		para["ORGBRDID"] = " ";
					
	retVal = window.showModalDialog(url,para,"dialogWidth:237px;dialogHeight:420px;status:no;help:no");

	if ( typeof(retVal) != "undefined" )
	{
		pBoardID =  retVal[2];
		SelBoardNM.value =retVal[4];
		pBoardFileSize = retVal[6];
		pInnitEndDate = retVal[7];
		
		pInnitEndDate = DateAdd(pInnitEndDate);
	}
}


function btn_Open_Onclick()
{
	FormProc.FileOpenDlg("");
}


function onEndDateChaked()
{
	
	if ( pMod == "Modify" || pMod == "ReModify")
	{
		pEndDate	= ModInnitEndDate;
	}
		
	var cDate = new Date();
	var rDate = idDatepicker.value;
	var tDate ;
	var pCDateMonth, pCDateDate, pCDateHours , pCDateMinutes;
	
	
	if ( (cDate.getMonth() +1) < 10 )
			pCDateMonth = "0" + (cDate.getMonth() +1);
	else
			pCDateMonth = cDate.getMonth() +1;
	
	if (  cDate.getDate() < 10 )
			pCDateDate = "0" + cDate.getDate();
	else
			pCDateDate = cDate.getDate();
			
	
	var pResDate =_D2.value.substring(0,10);
	var pCDate =cDate.getYear()+"-"+ pCDateMonth+ "-" + pCDateDate;
	
	if (pResDate <= pEndDateTime )
	{
		if ( pCDate > pResDate)
		{
			alert("" + strLang27 + "");
			
			var pDate = new Date();

			if ( pMod != "New")
			{
					_D2.value = "";
		    		var vEndDate =pEndDate.split("-");
		    		g_winDocAll['idDatepicker'].vtLocalEndCalDate= pDate.setFullYear(vEndDate[0],vEndDate[1]-1,vEndDate[2]);
			}
			else
			{
				_D2.value = "";
				var vEndDateTime = pSetEndDate.split("-");
				g_winDocAll['idDatepicker'].vtLocalEndCalDate=  pDate.setFullYear(vEndDateTime[0],vEndDateTime[1]-1,vEndDateTime[2]);
			}
		}
	}
	else
	{
		alert("" + strLang28 + "" +  pEndDateTime + "" + strLang29 + "");
		
		var pDate = new Date();

		if ( pMod != "New")
		{
				_D2.value = "";
				var vEndDate =pEndDate.split("-");
				g_winDocAll['idDatepicker'].vtLocalEndCalDate= pDate.setFullYear(vEndDate[0],vEndDate[1]-1,vEndDate[2]);
		}
		else
		{
			_D2.value = "";
			var vEndDateTime = pSetEndDate.split("-");
			g_winDocAll['idDatepicker'].vtLocalEndCalDate=  pDate.setFullYear(vEndDateTime[0],vEndDateTime[1]-1,vEndDateTime[2]);
		}
	}
}


function check_bonjum()
{
	if  (pBonjum == "1")
	{
		bonjum.checked = true;
		bonjum.value = "1"
	
	}
	else
	{
		bonjum.checked = false;
		bonjum.value = "0"
	}
	
}


function check_youngup()
{

	if  (pYoungup == "1")
	{
		youngup.checked = true;
		youngup.value = "1"
	
	}
	else
	{
		youngup.checked = false;
		youngup.value = "0"
	}

}



function check_imwon()
{
	
	if  (pImwon == "1")
	{
		imwon.checked = true;
		imwon.value = "1"
	
	}
	else
	{
		imwon.checked = false;
		imwon.value = "0"
	}
	
}



function check_chajang()
{
	if  (pChajang == "1")
	{
		chajang.checked = true;
		chajang.value = "1"
	
	}
	else
	{
		chajang.checked = false;
		chajang.value = "0"
	}

}


function check_gwajang()
{
	
	if  (pGwajang == "1")
	{
		gwajang.checked = true;
		gwajang.value = "1"
	
	}
	else
	{
		gwajang.checked = false;
		gwajang.value = "0"
	}
	
}

function DateAdd(pInnitEndDate)
{

	var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
	var resultXML = new ActiveXObject("Microsoft.XMLDOM");

	var objRoot = xmlDoc.createNode(1,"ITEMDATA","");
	xmlDoc.appendChild(objRoot);
				
	var objNode1 = xmlDoc.createNode(1,"INNITDATE","");  
	objNode1.text = pInnitEndDate;
	objRoot.appendChild(objNode1);

	xmlHttp.Open("POST","../GetBoardDate.asp",false);
	
	xmlHttp.Send(xmlDoc.xml);
	
	return xmlHttp.responseText 


}


function btnClose_onclick()
{
	OpenerMainListChange();
	window.close();
}



function OpenerMainListChange()
{
	if (typeof(window.opener.document) != "unknown" ) 
	{
	
		szUrl = "gwboard_get_ItemMoveSearch_Result.aspx?Brd_id=" + pOrgBoardID + "&DeptBoardYN=" + pDeptBoardYN+ "&Brd_Mod=" + pBrdMod  + "&brd_nm=" + pUpNm;
		szUrl = szUrl  + "&Menu=" + pMenu + "&GoTopage=" + pGoToPage + "&SelCompanyID=" + pCompanyID;
		window.opener.document.brds.target = "_self";
		window.opener.document.brds.action = szUrl;
		window.opener.document.brds.submit();
	
	}
	
	
}

