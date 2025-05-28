var lastKyulName, lastKyuljiwee, LastSignSN;
var DraftLastFlag = false;

function GetDraftAprLineInfo(ret) {
  try {
	DraftLastFlag = false;
	
	var xmlKuljea;
	var chamjo;
	var hapyuiCnt;
	var SignCnt;
	var referCnt;
	var xmlReDraft;
					  
	var objNodes;
	var findstring;
	var count;
	var i;
	var name;
					   
	var OrderType = new Array();     
	var OrderTypeName = new Array(); 
	var OrderDept = new Array();     
	var OrderName = new Array();     
	var OrderStat = new Array();     
	var OrderStatName = new Array(); 
	var OrderJobtitle = new Array(); 
	var OrderReason = new Array();   
	var OrderSuggester = new Array(); 
	var OrderReporter = new Array(); 
					  
	var xmldom = new ActiveXObject("Microsoft.XMLDOM");
	
	if (ret[5] == undefined) {
	    xmlKuljea = ret[0];
	    xmlReDraft = ret[2];
	} else {
	    xmlKuljea = ret[1];
	    xmlReDraft = ret[5];
	}
	
	setAprLinesXML(xmlKuljea);
	
	if(xmlReDraft == "C") {
		ApplyDocCellInfo();
	} else if(xmlReDraft == "R")	{
		ClearDocCellInfo();
	}
    
	xmldom.loadXML(xmlKuljea);
	  
	objNodes = xmldom.selectNodes("LISTVIEWDATA/ROWS/ROW");
	count = objNodes.length;
	
	for(i=1;i<20;i++)
	{
	   	name = "habyuisign" + i;
		if (HwpCtrl.CheckFieldExist(name))
		{
	  		name = "habyui" + i;
	  		if (HwpCtrl.CheckFieldExist(name))
	  			HwpCtrl.SetFieldText(name, "");
	  		
	  		name = "habyuisign" + i;
	  		if (HwpCtrl.CheckFieldExist(name))
	  			HwpCtrl.SetFieldText(name, "");
	  		
	  		name = "habyuipositon" + i;
	  		if (HwpCtrl.CheckFieldExist(name))
	  			HwpCtrl.SetFieldText(name, "");
	  		
	  		
	  		name = "habyuidate" + i;
	  		if (HwpCtrl.CheckFieldExist(name))
	  			HwpCtrl.SetFieldText(name, "");
	  	}
	  	else
	  	{
	  	   break;
	  	}
	}
	
	if (HwpCtrl.CheckFieldExist("refer"))
	  	HwpCtrl.SetFieldText("refer", "");
	
	
	if (HwpCtrl.CheckFieldExist("hgamsa"))
	  	HwpCtrl.SetFieldText("hgamsa", "");
	
	
	for(i=1;i < 20;i++)
	{
		if (HwpCtrl.CheckFieldExist("gongram" + i))
	  		HwpCtrl.SetFieldText("gongram" + i, "");
	}
    
    	
	for(i=0;i < count;i++)
	{
	    var KyljeaOrder = getNodeText(objNodes.item(i).childNodes(0))
	    var KyljeaName = getNodeText(objNodes.item(i).childNodes(1))
	    var KyljeaDeptName = getNodeText(objNodes.item(i).childNodes(3))
	    var KyljeaType  = getNodeText(objNodes.item(i).childNodes(16));       
	    var KyljeaTypeName  = getNodeText(objNodes.item(i).childNodes(4))    
	    var KyljeaStat = getNodeText(objNodes.item(i).childNodes(17));         
	    var KyljeaStatName = getNodeText(objNodes.item(i).childNodes(5))      
	    var KyljeaJobtitle = getNodeText(objNodes.item(i).childNodes(2))     
	    var ReasonDoNotApprov = getNodeText(objNodes.item(i).childNodes(12)); 
   		var suggester = getNodeText(objNodes.item(i).childNodes(13));      
   		var reporter = getNodeText(objNodes.item(i).childNodes(14));	   
	      	
	    OrderType[KyljeaOrder] = KyljeaType;
	    OrderTypeName[KyljeaOrder] = KyljeaTypeName;     
	    OrderName[KyljeaOrder] = KyljeaName;
	    OrderDept[KyljeaOrder] = KyljeaDeptName;
	    OrderStat[KyljeaOrder] = KyljeaStat;
	    OrderStatName[KyljeaOrder] = KyljeaStatName;    
	    OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
	    OrderReason[KyljeaOrder] = ReasonDoNotApprov;
   		OrderSuggester[KyljeaOrder] = suggester;
   		OrderReporter[KyljeaOrder] = reporter;
    }

    CurAprType = OrderType[1];
    if (OrderType.length > 2)
		NextAprType = OrderType[2];
    
    var chkGamsa = false;
	LastSignSN = OrderType.length
    
    for(i=1;i<OrderType.length;i++)
    {
		if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16)
		{
			LastSignSN = i;
			i = OrderType.length
		}
		
		else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType3)
		{
    		LastSignSN = i;
		}
		
		else if (OrderType[i] == strAprType13)
		{
        	chkGamsa = true;
	    }
    }
    
    
    lastKyulName = OrderName[LastSignSN]
    lastKyuljiwee = OrderJobtitle[LastSignSN]
	if (HwpCtrl.CheckFieldExist("lastKyuljikwee"))
		HwpCtrl.SetFieldText("lastKyuljikwee", lastKyuljiwee);

	if (HwpCtrl.CheckFieldExist("lastKyulName"))
		HwpCtrl.SetFieldText("lastKyulName", lastKyulName);
      
	hapyuiCnt = 1;
	SignCnt = 1;
	referCnt = 1;
	gongramCnt = 1;
	
	var fieldname;
	var field;
	  
	
	for(i=1;i < 20;i++)
	{
	  	fieldname = "jikwe" + i
		if (HwpCtrl.CheckFieldExist(fieldname))
		{
			HwpCtrl.SetFieldText(fieldname, "");
			fieldname = "sign" + i
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
		}else{
			break;
		}	
	}

	var idx = 1;
	var hidx = 1;	  
	for(i=1;i < OrderJobtitle.length;i ++)
	{
		
		if(OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1  || OrderType[i] == strAprType16 || OrderType[i] == strAprType3 || OrderType[i] == strAprType4)
		{
			fieldname = "jikwe" + idx;
			if (HwpCtrl.CheckFieldExist(fieldname))
			{
				var jikweName = trim(HwpCtrl.GetFieldText(fieldname));					
				if(jikweName.substring(0,1) != strLang128)
					HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);
					
				if(OrderSuggester[i] == "Y")
					HwpCtrl.SetFieldText(fieldname, strLang75 + HwpCtrl.GetFieldText(fieldname));
					
				if(OrderReporter[i] == "Y")
					HwpCtrl.SetFieldText(fieldname, strLang76 + HwpCtrl.GetFieldText(fieldname));
			}
			idx = idx + 1;
	  	}
		else if(OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12)
		{
			fieldname = "habyui" + hidx;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, OrderDept[i]);
		
			fieldname = "habyuipositon" + hidx;
			if (HwpCtrl.CheckFieldExist(fieldname))
			{
				var jikweName = trim(HwpCtrl.GetFieldText(fieldname));					
				if(jikweName.substring(0,1) != strLang128)
					HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);
					
				if(OrderSuggester[i] == "Y")
					HwpCtrl.SetFieldText(fieldname, strLang75 + HwpCtrl.GetFieldText(fieldname));
					
				if(OrderReporter[i] == "Y")
					HwpCtrl.SetFieldText(fieldname, strLang76 + HwpCtrl.GetFieldText(fieldname));
			}
			hidx = hidx + 1;
		}
		
	    if (chkGamsa) {
	        fieldname = "deptgamsaname";
	        field = HwpCtrl.CheckFieldExist(fieldname);
	        if (field) {
	            HwpCtrl.SetFieldText(fieldname, "감    사");
	        }
	    }
	    else {
	        fieldname = "deptgamsaname";
	        field = HwpCtrl.CheckFieldExist(fieldname);
	        if (field) {
	            HwpCtrl.SetFieldText(fieldname, "");
	        }
	    }
	}
	
	
  }catch(e){
    alert("GetDraftAprLineInfo(ret)" + e.description);
  }	
}

function setRecevInfo(ret) {
	setDeptLinesXML(ret);
	var precipent = ""
	var precipents = ""
	var recipflag = true;
	var xmldom = new ActiveXObject("Microsoft.XMLDOM");
	xmldom.async = false;
	xmldom.loadXML(ret)
	
	if( xmldom.xml == "" ) return;
	if( xmldom.documentElement.childNodes.length == 0 ) return;
	
	btnReceivLineEnable = true;
	
	var rows = xmldom.documentElement.childNodes
	if (HwpCtrl.CheckFieldExist("hrecipients"))
		HwpCtrl.SetFieldText("hrecipients", "");
	
	if (HwpCtrl.CheckFieldExist("recipient"))
		HwpCtrl.SetFieldText("recipient", "");
	
	if (HwpCtrl.CheckFieldExist("recipients"))
		HwpCtrl.SetFieldText("recipients", "");
	
    for (var i = rows.length - 1; i >= 0; i--) {
		var row = rows(i)
        if (recipflag) {
            if (getNodeText(rows(i).childNodes(3)) == "Y") {
					precipent = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0)) 
					precipents = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
					recipflag = false;	
				}
            else {
                if (isExtDoc == "Y") {
						precipent = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
						precipents = getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))				
						recipflag = false;	
					}
                else {
						precipent = getNodeText(rows(i).childNodes(0))
						precipents = getNodeText(rows(i).childNodes(0))				
						recipflag = false;	
					}
				}
			
		}
        else {
			precipent = strLang92;
			
			if(getNodeText(rows(i).childNodes(3)) == "Y")
				precipents = precipents + "," + getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
            else {
				if(isExtDoc == "Y")
					precipents = precipents + "," + getNodeText(rows(i).childNodes(7)) + " " +  getNodeText(rows(i).childNodes(0)); 
				else
					precipents = precipents + "," + getNodeText(rows(i).childNodes(0)); 
			}
		}		
	}
	
    if (HwpCtrl.CheckFieldExist("recipient")) {
        if (precipent == strLang92) {
			HwpCtrl.SetFieldText("recipient", precipent);

            if (SummaryOuterReceiverList != "") {
                if (HwpCtrl.CheckFieldExist("recipients")) {
                    HwpCtrl.SetFieldText("recipients", SummaryOuterReceiverList);
                    if (HwpCtrl.CheckFieldExist("hrecipients"))
                        HwpCtrl.SetFieldText("hrecipients", strLang129);
                }
            } else {
                if (HwpCtrl.CheckFieldExist("recipients")) {
				HwpCtrl.SetFieldText("recipients", precipents);
				if (HwpCtrl.CheckFieldExist("hrecipients"))
					HwpCtrl.SetFieldText("hrecipients", strLang129);
			}
		}
        } else {
			HwpCtrl.SetFieldText("recipient", precipent);
            if (precipents == "") {
				if (HwpCtrl.CheckFieldExist("hrecipients"))
					HwpCtrl.SetFieldText("hrecipients", "");
			
				if (HwpCtrl.CheckFieldExist("recipients"))
					HwpCtrl.SetFieldText("recipients", "");
			}
		}
	}
}


function ClearDocCellInfo()
{
	try
	{
		var i;
		var j;
		var k;
		var fieldname;
		var susunSN = "";
		if(pDraftFlag == "SUSIN" || pDocState == "011" ) susunSN = pSusinSN;
			
		for(i = 1; i <= SignCount ; i++)
		{
			fieldname = susunSN + "sign" + i;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
					  		
			fieldname = susunSN + "seumyung" + i;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
					  		
			fieldname = susunSN + "seumyungdate" + i;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
				    
			fieldname = susunSN + "jikwe" + i;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
		}

		for(j = 1 ; j <= hapyuiCount ; j++)
		{
			fieldname = susunSN + "habyui" + j;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
			    
			fieldname = susunSN + "habyuipositon" + j;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
			
	  		fieldname =  susunSN + "habyuidate" + j;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
	      
			fieldname = susunSN + "habyuisign" + j;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
		}
	    
		for(i=1;i<20;i++)
		{
			fieldname = "habyuiopinion" + i;
			if (HwpCtrl.CheckFieldExist(fieldname))
				HwpCtrl.SetFieldText(fieldname, "");
		}
		
		
		fieldname = "sealsign";
		if (HwpCtrl.CheckFieldExist(fieldname))
		{
			HwpCtrl.SetFieldText(fieldname, "");
			HwpCtrl.SetFieldBackImage(fieldname, "");
		}
		
        fieldname = "deptgamsaname";
        if (HwpCtrl.CheckFieldExist(fieldname))
        {
        	HwpCtrl.SetFieldText(fieldname, "");
        }

        fieldname = "deptgamsasign";
        if (HwpCtrl.CheckFieldExist(fieldname))
        {
        	HwpCtrl.SetFieldText(fieldname, "");
			HwpCtrl.SetFieldBackImage(fieldname, "");
        }

        fieldname = "deptgamsadate";
        if (HwpCtrl.CheckFieldExist(fieldname))
        {
        	HwpCtrl.SetFieldText(fieldname, "");
        }
		
		fieldname = "opinions";
		if (HwpCtrl.CheckFieldExist(fieldname))
		{
			HwpCtrl.SetFieldText(fieldname, "");
		}
	}
	catch(e)
	{
		alert("ClearDocCellInfo()" + e.description);
	}
}


function setClearSusinCellInfo()
{
  try{
	var fieldname;			
	fieldname = "recipient";
	if (HwpCtrl.CheckFieldExist(fieldname))
		HwpCtrl.SetFieldText(fieldname, "");
		
	fieldname = "recipients";
	if (HwpCtrl.CheckFieldExist(fieldname))
		HwpCtrl.SetFieldText(fieldname, "");
  }
  catch(e){
	alert("setClearSusinCellInfo()" + e.description);
  }
}


function ApplyDocCellInfo()
{
  try{
	var i;
	var j;
	var k;
	var fieldname;
	var fieldvalue;
		
	for(j = 1 ; j <= hapyuiCount ; j++)
	{
		fieldname = "habyuidate" + j;
		if (HwpCtrl.CheckFieldExist(fieldname))
		{
			fieldvalue = HwpCtrl.GetFieldText(fieldname);
			fieldvalue = trim(fieldvalue);
		    
		  	if(fieldvalue == "")
		  	{
		  		fieldname = "habyui" + j;
				if (HwpCtrl.CheckFieldExist(fieldname))
					HwpCtrl.SetFieldText(fieldname, "");
			}
		} 
	}
  }catch(e){
	alert("ApplyDocCellInfo()" + e.description);
  }	
}


function putJunkyulSign(signID)
{
	if (HwpCtrl.CheckFieldExist(signID))
		HwpCtrl.SetFieldText(signID, strLang6);
}


function SendDraftMappingSign(ret)
{
  try{
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt = 0;
	var sn = 1;
	
	var OpinionText = "";
	var PositionText = "";
	
	if( LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16) 
	{
		OpinionText = getSignDate() + "\15";
	}
	
	psigncell = "sign" + sn;
	pseumyungcell = "jikwe" + sn;
	pseumyungdatecell = "seumyungdate" + sn;
	
	 
	var RtnVal = getGyulJeDate();
	var CurrentDate = RtnVal.split(".");
	var s = CurrentDate[1] + "." + CurrentDate[2]; 
	var strimg;
	var SingFlag = true;
	var DekyulFlag = false;

	if (HwpCtrl.CheckFieldExist(pseumyungcell))
	    HwpCtrl.SetFieldText(pseumyungcell, HwpCtrl.GetFieldText(pseumyungcell) + PositionText);

	if (HwpCtrl.CheckFieldExist(pseumyungdatecell))
	    HwpCtrl.SetFieldText(pseumyungdatecell, s);
		
	if(CurAprType == strAprType16)  
	{			
		if (HwpCtrl.CheckFieldExist(psigncell))
		{
			
			if(ret != "NAME")
			{
				HwpCtrl.SetFieldText(psigncell, "");	
				HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);
				HwpCtrl.AppendFieldText(psigncell, strLang7 + "\15" + OpinionText, true);
			  	
			  	signInfo[signCnt] = psigncell;
			  	
				SignType[signCnt] = "IMAGE";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = ret + "::" + strLang7 + OpinionText;
							  	
			  	SetDocumentElement(HwpCtrl, psigncell, ret);
			  	signCnt = signCnt + 1
			  	SingFlag = true;
			}
			else
			{
				HwpCtrl.SetFieldText(psigncell, arr_userinfo[2]);	
				
				HwpCtrl.AppendFieldText(psigncell, strLang7 + "\15" + OpinionText, true);
		  		
		  		signInfo[signCnt] = psigncell;
		  		
				SignType[signCnt] = "TEXT";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = arr_userinfo[2] + strLang7 + OpinionText;
		  		
		  		signCnt = signCnt + 1
		  		SingFlag = false; 
		  	}
		}	
		DekyulFlag = true;
		sn = sn + 1;
		psigncell = "sign" + sn;
		pseumyungcell = "jikwe" + sn;
		pseumyungdatecell = "seumyungdate" + sn;
	}	
	
	if (DekyulFlag && NextAprType == strAprType4) 
	{
		if (HwpCtrl.CheckFieldExist(psigncell))
		{
			HwpCtrl.SetFieldText(psigncell, strLang6);	
			
			signInfo[signCnt] = psigncell;
			
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = psigncell;
			SignContent[signCnt] = strLang6;
			
			signCnt = signCnt + 1
			SingFlag = false; 
		}
	}
	else if (DekyulFlag)
	{
	}
	else
	{	
		if (HwpCtrl.CheckFieldExist(psigncell))
		{
			
			if(ret != "NAME")
			{
				HwpCtrl.SetFieldText(psigncell, "");	
				HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);
	
				if (HwpCtrl.CheckFieldExist(pseumyungdatecell)) {
				    OpinionText = "";
				}

				HwpCtrl.AppendFieldText(psigncell, OpinionText, true);
				
				if (CurAprType == strAprType4)	
					HwpCtrl.AppendFieldText(psigncell, strLang6 + "\15", true);
			  	
			  	signInfo[signCnt] = psigncell;
			  	
				SignType[signCnt] = "IMAGE";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = ret + "::" + OpinionText;
				
			  	SetDocumentElement(HwpCtrl, psigncell, ret);
			  	signCnt = signCnt + 1
			  	SingFlag = true;
			}
			else
			{
			    if (HwpCtrl.CheckFieldExist(pseumyungdatecell)) {
			        OpinionText = "";
			    }
			    
				HwpCtrl.SetFieldText(psigncell, arr_userinfo[2]);	
				HwpCtrl.AppendFieldText(psigncell, OpinionText, true);
				
				if (CurAprType == strAprType4)	
					HwpCtrl.AppendFieldText(psigncell, strLang6 + "\15", true);
			  	
			  	signInfo[signCnt] = psigncell;
			  	
		        SignType[signCnt] = "TEXT";
		        SignName[signCnt] = psigncell;
		        SignContent[signCnt] = arr_userinfo[2] + OpinionText;
			        
			  	signCnt = signCnt + 1
			  	SingFlag = false; 
			}
		}
	}	
    return signInfo;	
  }catch(e){
    alert("SendDraftMappingSign(ret)" + e.description);
  }
}


function UndoSignInfo(signInfo)
{
  try{
	var cnt 
	if(signInfo)
	{
		for(cnt=0; cnt < signInfo.length; cnt++)
		{
			if (HwpCtrl.CheckFieldExist(signInfo[cnt]))
				HwpCtrl.SetFieldText(signInfo[cnt], "");
		}
	}
  }catch(e){
	alert("UndoSignInfo(signInfo)" + e.description);
  }
}

function ConvertDocType(pDocType) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCodeData.do",
		data : {
			code1 : "A01",
			code2 : pDocType,
			flag  : "CODE"
		},
		success: function(xml){
			result = xml;
		}        			
	});

    return SelectSingleNodeValue(loadXMLString(result), "RESULT");
}

function chk_Passwd() {
	var parameter = pUserID;
	var url = "/ezApprovalG/ezchkPasswd.do";
	var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret = window.showModalDialog(url,parameter,feature);
	
	return ret;
}

function setDrafterAddress() {
	SetDocumentElement(HwpCtrl, "drafter", arr_userinfo[2]);
	SetDocumentElement(HwpCtrl, "address", arr_userinfo[8]);
	SetDocumentElement(HwpCtrl, "drafterdept",arr_userinfo[4]);
	SetDocumentElement(HwpCtrl, "lastKyulName", lastKyulName);
	SetDocumentElement(HwpCtrl, "lastKyuljikwee", lastKyuljiwee);
}

function openFormUIHwp()
{
	try {
		var parameter = new Array();
		parameter[0] = arr_userinfo[4];
		parameter[1] = "000";				

		getformcont_cross_dialogArguments[0] = parameter;
		getformcont_cross_dialogArguments[1] = openFormUI_CompleteHwp;
		
		var OpenUrl = "/ezApprovalG/getFormCont.do?fileType=hwp";
		
        var OpenWin = window.open(OpenUrl , "getFormCont", GetOpenWindowfeature(713, 570));
        
        try { OpenWin.focus(); } catch (e) { }
        
        
	} catch (e) {
		alert("openFormUI()" + e.description);
	}
}

function SetBtnStateFalse()
{
	try{
		setMenuBar("btnSetAprLine",false);
		setMenuBar("btnSetReceivLine",false);
		setMenuBar("btnSendDraft",false);
		setMenuBar("btnDocInfo",false);
		setMenuBar("btnFileAttach",false);
		setMenuBar("btnAprDocAttach",false);
		setMenuBar("btnOpinion",false);
		setMenuBar("btnSave", false);
		
//		if (pDraftFlag == "REDRAFT") {
//		    setMenuBar("btnSaveServer", false);
//		} else {
//		    setMenuBar("btnSaveServer", true);
//		}
	}catch(e){
		alert("SetBtnStateFalse()" + e.description);
	}
}


function SetBtnStateTrue()
{
	try{
		setMenuBar("btnSelForm",true);
		setMenuBar("btnSetAprLine",true);
		setMenuBar("btnSendDraft",true);
		setMenuBar("btnDocInfo",true);
		setMenuBar("btnFileAttach",true);
		setMenuBar("btnAprDocAttach",true);
		setMenuBar("btnOpinion",true);	
		btnClose.style.diplay = ""	
		setMenuBar("btnSave",true);
		setMenuBar("btnPrint",true);
		
		if(pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
		{
			setMenuBar("btnSelForm",false);
		}
//		if (pDraftFlag == "REDRAFT") {
//		    setMenuBar("btnSaveServer", false);
//		}
//		else {
//		    setMenuBar("btnSaveServer", true);
//		}ddd

		//setFormAprOption();  //결재 세부옵션

	}catch(e){
		alert("SetBtnStateTrue()" + e.description);
	}
}

function SetAutoPropertyValue()
{
//  try{
	var fieldname;
	var field;
	var pSusinNextSN;
	var objNodes;
	var CurrentDate;

	var DocumentInfo = new ActiveXObject("Microsoft.XMLDOM");
	DocumentInfo.loadXML(HwpCtrl.GetDocumentInfo());
	
	if (DocumentInfo.getElementsByTagName("SUBJECT").length > 0)
	{
	    if (getNodeText(DocumentInfo.getElementsByTagName("SUBJECT").item(0)) == "")
		{
			if (HwpCtrl.CheckFieldExist("docnumber"))
				HwpCtrl.SetDocumentInfo("NULL", HwpCtrl.GetFieldText("docnumber"));
			
			if (HwpCtrl.CheckFieldExist("bedocnumber"))
				HwpCtrl.SetDocumentInfo("NULL", HwpCtrl.GetFieldText("bedocnumber"));
		}
	}
	objNodes = xmluserInfo.documentElement.childNodes;
	  
	
	var FullDate = getGyulJeFullDate();
	CurrentDate = getGyulJeDate();
	var SendName = getDeptSendName(arr_userinfo[4]);
	
	SignInfo = "";
	hapyuiCount = 0;
	SignCount = 0;
	gamsaCount = 0;

	var FieldLists = HwpCtrl.GetFieldList();
	var Fields = FieldLists.split(";");
	
	for (i = 0 ; i < Fields.length ; i ++)
	{
		if(pDraftFlag == "DRAFT" )
		{
			switch (Fields[i])
			{
				case "bedocnumber" :				    
					setDocNumFormat("be");
					break;

				case "docnumber" :				    
					setDocNumFormat("");
					break;

				case "enforcedate" :		  
					HwpCtrl.SetFieldText(Fields[i], "");
					break;

				case "opinions" :		  
					HwpCtrl.SetFieldText(Fields[i], "");
					break;

				case "receiptdate" :		  
					HwpCtrl.SetFieldText(Fields[i], "");
					break;
				
				case "recipient" :			  
					HwpCtrl.SetFieldText(Fields[i], "");
					break;

				case "hrecipients" :			  
					HwpCtrl.SetFieldText(Fields[i], "");
					break;

				case "recipients" :			  
					HwpCtrl.SetFieldText(Fields[i], "");
					break;
				
				case "refer" :				    
					HwpCtrl.SetFieldText(Fields[i], "");
					break;
				
				case "zipcode" :			    
					break;

				case "address" :			    
					break;												

				case "telephone" :		  	
					if( trim(getNodeText(objNodes.item(5))) != "" )
						HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(5)));
					break;

				case "depttelephone" :		  	
					HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(5)));
					break;																							
				case "fax" :			      	
					if( trim(getNodeText(objNodes.item(4))) != "" )
						HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(4)));
					break;
				case "deptfax" :			      	
					HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(4)));
					break;													
				case "department" :		  	
					HwpCtrl.SetFieldText(Fields[i], arr_userinfo[5]);
					break;												
				case "parantdept" :       
					HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(3)));
					break;
				case "seniorposition" :		
					break;												
				case "seniorname" :			  
					break;												
				case "charge" :				    
					HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(0)));
					break;
				case "position" :			    
					HwpCtrl.SetFieldText(Fields[i], arr_userinfo[3]);
					break;
				case "email" :				 
					HwpCtrl.SetFieldText(Fields[i], arr_userinfo[8]);
					break;
				case "keepperiod" :			  
					
					break;												
				case "publication" :		  
					HwpCtrl.SetFieldText(Fields[i], "");
					break;												

				case "examname" :			    
					break;												
				
				case "examdate" :			    
				break;												
				
				case "headcampaign" :		  
					
					break;							
				
				case "deptname" :         
					HwpCtrl.SetFieldText(Fields[i], arr_userinfo[5]);
					break;
				
				case "seal" :             
					HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(3)) + "대표이사");
					break;
				
				case "username" :         
					HwpCtrl.SetFieldText(Fields[i], arr_userinfo[2]);
					break;
				
				case "draftername" :      
					HwpCtrl.SetFieldText(Fields[i], arr_userinfo[2]);
					break;
				
				case "draftdate" :        
					
					HwpCtrl.SetFieldText(Fields[i], CurrentDate);
					break;
				
				case "deptshortedname" :
					HwpCtrl.SetFieldText(Fields[i], DeptSymbol + ":");
					break;

				case "organ" :        
					if (SendName != "")
						HwpCtrl.SetFieldText(Fields[i], SendName);
					break;

				case "chief" :        
					if (SendName != "")
						HwpCtrl.SetFieldText(Fields[i], SendName + strLang93);
					break;
			}
		}
		else
		{
			switch (Fields[i])
			{
				case pSusinSN + "receiptdate" :	 
					HwpCtrl.SetFieldText(Fields[i], CurrentDate);
					break;
			}
		}
	  	
		
		if(pDraftFlag == "SUSIN" ||  pDocState == "011")
		{
			var pSignSusin = pSusinSN + "sign";
			if (Fields[i].substr(0, 5) == pSignSusin)
			{
				SignCount = SignCount + 1;
			}
		}else{
			if (Fields[i].substr(0, 4) == "sign")
			{
				SignCount = SignCount + 1;
			}
		} 
	    
	    if (Fields[i].substr(0,10) == "habyuisign")
	    {
	    	hapyuiCount = hapyuiCount + 1;
	    }

	    if (Fields[i].substr(0,10) == "gamsasign1")
	    {
			gamsaCount =  gamsaCount + 1;
	    }
	    
	    if (Fields[i].substr(0, 7) == "gongram")
	    {
	    	gongramCount = gongramCount + 1;
	    }
	  	
	    if(pDraftFlag == "SUSIN" || pSusinSN != "0")
	    {
			var pSignInfoSusin = pSusinSN + "jikwe";
			if(Fields[i].substr(0,6) == pSignInfoSusin)
			{
				if(SignInfoFlag)
				{
					SignInfo = HwpCtrl.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}else{
					SignInfo = HwpCtrl.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    }else{
			if(Fields[i].substr(0,5) == "jikwe")
			{
				if(SignInfoFlag)
				{
					SignInfo = HwpCtrl.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}else{
					SignInfo = HwpCtrl.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
		}
	}
	
	pSuSinFlag = "N";

	if(pDraftFlag != "SUSIN" && pDocState != "011" )
	{
		var RtnVal = HwpCtrl.CheckFieldExist("recipient");
		if(RtnVal)
		{
			pSuSinFlag = "Y";
			setMenuBar("btnSetReceivLine", true);	
		}else{
			pSuSinFlag = "N";
			setMenuBar("btnSetReceivLine", false);	
		}
	}
	
	
	if(pSusinSN)
		pSusinNextSN = parseInt(pSusinSN) + 1;
	else
		pSusinNextSN = 1;

	fieldname = pSusinNextSN + "sign1";
	if(HwpCtrl.CheckFieldExist(fieldname))
	{
		pSuSinFlag = "Y";
		setMenuBar("btnSetReceivLine", true);
	}
	else
	{
		if(pSuSinFlag == "N")
		{	
			pSuSinFlag = "N";
			setMenuBar("btnSetReceivLine", false);
		}
	}
	
	pChamJoFlag = "Y";
	
    if (HwpCtrl.CheckFieldExist("deptgamsasign")) {
        deptgamsaCount = 1;
    }
//  }catch(e){	
//	alert("SetAutoPropertyValue()" + e.description);
//  }
}

function SetAutoPropFinal()
{
  try{
    var CurrentDate;
    CurrentDate = getGyulJeDate();
    
	var FieldLists = HwpCtrl.GetFieldList();
	var Fields = FieldLists.split(";");
  
	
	for (i = 0 ; i < Fields.length ; i ++)
	{
		if(pDraftFlag == "DRAFT" )
		{
			switch (Fields[i])
			{
	  			case "sentdate" :        
	  				HwpCtrl.SetFieldText(Fields[i], CurrentDate);
	  		  		break;
 			}
	  	}
	}  
  }catch(e){	
	alert("SetAutoPropFinal()" + e.description);
  }
}

function openOpinionUI(pOpinionFlag)
{
  try{
    var parameter = new Array();
    parameter[0]	= pDocID;
    parameter[1]	= pOpinionFlag;
    parameter[2]	= KuyjeType;
    parameter[3]	= pDraftFlag;
    parameter[98]	= orgCompanyID;
    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
    parameter[99] = "hwp";
    
    var url = "/ezApprovalG/aprOpinion.do";
	var feature = "status:no;dialogWidth:530px;dialogHeight:495px;edge:sunken;scroll:no"
	var ret = window.showModalDialog(url,parameter,feature);
	
	if (ret != "cancel" && ret != undefined) {
	    var NodeList;
	    var objXML = new ActiveXObject("Microsoft.XMLDOM");
	    
	    objXML.loadXML(ret);
	    NodeList = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	
	    if (NodeList.length != 0) {
			pHasOpinionYN = "Y";
	    } else {
			pHasOpinionYN = "N";
			ret = "cancel";
	    }
	    
	    makeOpinionList(objXML);
    }
	
    return ret;
  }catch(e){
    alert("openOpinionUI(pOpinionFlag)" + e.description);
  }
}

function openOpinionUI_New(pOpinionType) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = pDraftFlag;	//DRAFTFLAG
		parameter[3] = "";			//DOCSTATE 기안은 공백 고정
		parameter[4] = orgCompanyID;//ORGCOMPANYID
		parameter[99] = ext;		//EXT
		
		var url = "/ezApprovalG/aprOpinionNew.do";
		var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
		var ret = window.showModalDialog(url,parameter,feature);
		
		if (ret != "cancel" && ret != undefined) {
		    var objXML = new ActiveXObject("Microsoft.XMLDOM");
		    objXML.loadXML(ret);
		    
		    var NodeList = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
		    if (NodeList.length != 0) {
				pHasOpinionYN = "Y";
		    } else {
				pHasOpinionYN = "N";
				ret = "cancel";
		    }
		    makeOpinionList(objXML);
	    }
		
	    return ret;
	} catch (e) {
		alert("openOpinionUI_New ::: " + e.description);
	}
}


function makeOpinionList(OpinionXML)
{
	if (!HwpCtrl.CheckFieldExist("opinions"))
		return;

	var firstFlag = true;
	var NodeList = OpinionXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	if (NodeList.length > 0)
	{
		var strOpinion = " ";
		for (i=NodeList.length - 1; i>=0; i--)
		{
		    if (getNodeText(NodeList.item(i).childNodes(9)) == "001")
			{
				if (firstFlag)
				{
					strOpinion = "[" + strLang27 + "";
					firstFlag = false;
				}
				
				
				if (getNodeText(NodeList.item(i).childNodes(2)) != "")
				    strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(2)) + "\11";  
				else
					strOpinion = strOpinion + "   \11";  
					
				strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(1)) + "\11";  
				strOpinion = strOpinion + getNodeText(NodeList.item(i).childNodes(6)) + "\15";  
			}
				
		}		
		HwpCtrl.SetFieldText("opinions", strOpinion);
	}
	else
	{
		HwpCtrl.SetFieldText("opinions", "");
	}
}


function openFileAttachUI()
{
  try{
	var parameter = pDocID;
	var url = "/ezApprovalG/aprAttach.do?formID=" + pFormID + "&docID=" + pDocID + "&draftFlag=" + pDraftFlag + "&orgCompanyID=" + orgCompanyID + "&ext=" + "hwp";
	var feature	= "status:no;dialogWidth:800px;dialogHeight:610px;edge:sunken;scroll:no"; 
	var ret = window.showModalDialog(url, parameter, feature);

	if (ret != "cancel") {
		setAttachInfo(pDocID, "APR", lstAttachLink);
	}
	
	return ret;
  }catch(e){
	alert("openFileAttachUI()" + e.description);
  }
}


function openAaprDocAttachUI()
{
  try{
	var parameter = pDocID;
	var url = "/ezApprovalG/aprCabinetAttach.do?draftFlag=" + pDraftFlag;
	var feature	= "status:no;dialogWidth:1050px;dialogHeight:520px;edge:sunken;scroll:no;help:no"; 
	var ret = window.showModalDialog(url,parameter,feature);

	if(ret != "cancel")
	{
		setAttachInfo(pDocID, "APR", lstAttachLink);	
	}
	return ret;
  }catch(e){
	alert("openAaprDocAttachUI()" + e.description);
  }
}

function SaveDraftDocInfo() {
	var rtnVal;

	rtnVal = SaveFile();
	if (rtnVal.toUpperCase() != "TRUE") {
        return "rtnVal";
    }
		
    SignSave();
	rtnVal = SaveDraftDocInfo_ilban("002");
	
	if (rtnVal.toUpperCase() != "TRUE")	{
		SaveOrgFile();
	}
	
	return rtnVal;
}

function SaveDraftDocInfo_ilban(pState)
{
  try{
	var objRoot;
	var objNode;
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();

	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "FORMID", pFormID);

	if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
	    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pOrgDocID);
	    createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", pDocType);
	    createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", pDocState);
	}
	else {
	    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", "");
	    createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", "");
	    createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", "");
	}

	createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", pState);
	createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + pDocID + ".hwp");

	if (HwpCtrl.CheckFieldExist("doctitle"))
	    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", HwpCtrl.GetFieldText("doctitle"));
	else
	    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", "");

	var field = "";
	if (HwpCtrl.CheckFieldExist("docnumber"))
	    field = HwpCtrl.GetFieldText("docnumber");
	else if (HwpCtrl.CheckFieldExist("be_docnumber"))
	    field = HwpCtrl.GetFieldText("be_docnumber");
	else if (HwpCtrl.CheckFieldExist("deptshortedname"))
	    field = HwpCtrl.GetFieldText("deptshortedname");
	else
	    field = "";

	createNodeAndInsertText(xmlpara, objNode, "DOCNO", field);
	createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
	createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);

	var startdate;
	if (pState == "000")
	    startdate = "DRAFTSAVE";
	else
	    startdate = "DRAFT";
	createNodeAndInsertText(xmlpara, objNode, "STARTDATE", startdate);
	createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "WRITERID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", arr_userinfo[13]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", arr_userinfo[4]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", arr_userinfo[15]);
	createNodeAndInsertText(xmlpara, objNode, "HTML", "");
	createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");
	createNodeAndInsertText(xmlpara, objNode, "PUSERID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "PDEPTID", arr_userinfo[4]);

	createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);

	createNodeAndInsertText(xmlpara, objNode, "PUBLIC", tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);
	createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");

	createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
	createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml", true);
	if (!g_SepAttachLVXml)
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
	else
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));

	createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);

	createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	
	/*
	 * 2018-06-14 천성준
	 * 비전자문서 데이터 세팅 메소드
	 * */
	if (nonElecRec == "Y") {
		var NonElecXML = createXmlDom();
		NonElecXML = loadXMLString(nonElecRecInfoXml);
		
		createNodeAndInsertText(xmlpara, objNode, "NONELECREC", nonElecRec);
		createNodeAndInsertText(xmlpara, objNode, "REGISTERTYPE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE"));
		createNodeAndInsertText(xmlpara, objNode, "REGISTERDATE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERDATE"));
		createNodeAndInsertText(xmlpara, objNode, "REGISTERYEAR", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERYEAR"));
		createNodeAndInsertText(xmlpara, objNode, "EXECUTEDATE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "EXECUTEDATE"));
		createNodeAndInsertText(xmlpara, objNode, "TITLE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "TITLE"));
		createNodeAndInsertText(xmlpara, objNode, "APRMEMBERTITLE", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "APRMEMBERTITLE"));
		createNodeAndInsertText(xmlpara, objNode, "APRMEMBERTITLE2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "APRMEMBERTITLE2"));
		createNodeAndInsertText(xmlpara, objNode, "DRAFTERNAME", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DRAFTERNAME"));
		createNodeAndInsertText(xmlpara, objNode, "DRAFTERNAME2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DRAFTERNAME2"));
		createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "RECEIPTMEMBER"));
		createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER2", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "RECEIPTMEMBER2"));
		createNodeAndInsertText(xmlpara, objNode, "SENDINGMEMBER", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SENDINGMEMBER"));
		createNodeAndInsertText(xmlpara, objNode, "DELIVERYNO", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DELIVERYNO"));
		createNodeAndInsertText(xmlpara, objNode, "ORIGINREGSN", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "ORIGINREGSN"));
		createNodeAndInsertText(xmlpara, objNode, "ELECTRONICRECFLAG", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "ELECTRONICRECFLAG"));
		createNodeAndInsertText(xmlpara, objNode, "NONELECREC_CABINETID", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "CABINETID"));
		
		// 시청각 기록물일경우
		if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "5" || SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "6") {
			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECINFO", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "AUDIOVISUALRECINFO"));
			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECSUMMARY", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SUMMARY"));
		}
		
		// 분리첨부가 존재할 경우
		if (SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW").length > 0) {
			var sepAtt, Data, i;
			var rtnXml = createXmlDom();
	        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
			var sepLVXml = createXmlDom();
            	sepLVXml = loadXMLString(nonElecRecInfoXml);
            var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW");
            
            for (i = 0; i < rows.length; i++) {
                sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(rows[i], "CABINETID"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", SelectSingleNodeValue(rows[i], "SEPTITLE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(rows[i], "SEPNUMOFPAGE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", SelectSingleNodeValue(rows[i], "SEPREGTYPE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", SelectSingleNodeValue(rows[i], "SEPSUMMARY"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", SelectSingleNodeValue(rows[i], "SEPRECORDTYPE"));
            }
            
            createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SEPERATEATTACH", getXmlString(rtnXml));
		}
	}
	
	xmlhttp.open("POST","/ezApprovalG/doDraftHWP.do",false);
	xmlhttp.send(xmlpara);
	
	if(pState != "000")		
		SetBtnStateFalse();
	
	if (xmlhttp.status == 200) {
		var dataNodes = GetChildNodes(xmlhttp.responseXML);
		
        return getNodeText(dataNodes[0]);
	} else {
		return "FALSE";
	}
  }catch(e){
    alert("SaveDraftDocInfo_ilban(pState)" + e.description);
  }
}

function setDocNumFormat(pPrefix)
{
	var Arr_Header = new Array()
	var Header, Tail
	var i
	var d = new Date();
		
	var numHeader = ""
		
	if(pDraftFlag == "REDRAFT") return;
		
	if(!HwpCtrl.CheckFieldExist(pPrefix + "docnumber"))		
		return 

	var DocumentInfo = new ActiveXObject("Microsoft.XMLDOM");
	DocumentInfo.loadXML(HwpCtrl.GetDocumentInfo());
		
	var fieldValue = getNodeText(DocumentInfo.getElementsByTagName("SUBJECT").item(0));
	Arr_Header = fieldValue.split("@")
	    
	for(i=1;i<Arr_Header.length;i++)
	{
		Header = Arr_Header[i].substr(0,2);
		Tail   = Arr_Header[i].substr(2);
				
		switch(Header)
		{
			case "DP":
				numHeader = numHeader + DeptSymbol + Tail;
				break;			

			case "dp":
				numHeader = numHeader + DeptSymbol + Tail 
				break;

			case "YY":
				numHeader = numHeader + d.getYear() + Tail 
				break;

			case "yy":
				var yyear = d.getYear()
				numHeader = numHeader + yyear.toString().substr(2) + Tail
				break;

			case "MM":
				var mmonth = d.getMonth() + 1
				if(parseInt(mmonth) < 10) mmonth = "0" + mmonth;
					numHeader = numHeader + mmonth + Tail
				break;

			case "mm":
				numHeader = numHeader + (d.getMonth() + 1) + Tail
				break;

			case "NN":
				break;

			case "nn":
				break;

			case "cs":
				numHeader = numHeader + strLang107 + Tail;
				break;

			default:
				numHeader = numHeader + fieldValue;
				break;
		}
	}
			
	HwpCtrl.SetFieldText(pPrefix + "docnumber", numHeader);
	if(numHeader.indexOf(strLang107) > 0) 
		HwpCtrl.SetDocumentInfo("NULL", "NULL", numHeader);

	
	if (HwpCtrl.CheckFieldExist("receiptnumber"))
	{
		
		
		if (HwpCtrl.GetFieldText("receiptnumber") != "")
			SetDocumentElement(HwpCtrl, "receiptnumber", HwpCtrl.GetFieldText("receiptnumber"));
		
		HwpCtrl.SetFieldText("receiptnumber", "");

		
		
		if (GetDocumentElement(HwpCtrl, "receiptnumber") == "")
			SetDocumentElement(HwpCtrl, "receiptnumber", fieldValue);
	}
}

//구현해야하는부분
function SaveFile() {
	var result = "";

	var data = {
		docID : pDocID,
		formId : pFormID,
		html  : HwpCtrl.GetCloneData("", "HWP")
	}
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveFileHWP.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});
    
    return result;
}

function SaveOrgFile() {
	var result = "";

	var data = {
		docID : pDocID,
		formId : pFormID,
		html  : pOrgHtml
	}
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveFileHWP.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});
    
    return result;
}

function openSignUI() {
    try {
	  	var SignNodeList;
	  	var result = "";
	  	
	  	$.ajax({
	  		type : "POST",
	  		dataType : "text",
	  		async : false,
	  		url : "/ezApprovalG/getSignRequest.do",
	  		data : {
	  			userID : pUserID
	  		},
	  		success: function(xml){
	  			result = xml;
	  		}        			
	  	});
	  	
	  	SignNodeList = SelectNodes(loadXMLString(result), "LISTVIEWDATA/ROWS/ROW");
	    
	    if (SignNodeList.length != 0) { 
	  		var parameter	= pUserID;
	  		var url = "/ezApprovalG/aprSign.do";
	  		var feature	= "status:no;dialogWidth:350px;dialogHeight:310px;help:no;scroll:no;edge:sunken";
	  	    var ret = window.showModalDialog(url, parameter, feature);
	    } else {
	  		var ret = "NAME";
	    }
	      
	  	return ret;
    } catch(e) {
      alert("openSignUI()" + e.description);
    }
}

function putSignXML(SignXML)
{
  var retVal = false;
  try {
	var NodeList;
	NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
	if (NodeList.length > 0) 
	{
		for (i=0; i<NodeList.length; i++)
		{
		    var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
		    var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
		    var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));
			
			if (HwpCtrl.CheckFieldExist(SignName))
			{			
			    retVal = true;
				if (SignType == "TEXT")
				{
					HwpCtrl.SetFieldText(SignName, SignCont);
				}
				else if (SignType == "HTML")
				{
					HwpCtrl.AppendFieldText(SignName, SignCont, true, true, true);
				}
				else if (SignType == "PROXY")
				{
					HwpCtrl.SetFieldText(SignName, " ");
					HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(SignCont), 3, 0, 0, true, 2);
					HwpCtrl.AppendFieldText(SignName, strLang17, true);
				}
				else if (SignType == "IMAGE")  
				{
				    var img = SignCont.split("::"); 
					HwpCtrl.SetFieldText(SignName, "");
					if(img.length >= 1)
					    HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(img[0]), 3, 0, 0, true, 2);
					    
				    if(img.length >= 2)
				        HwpCtrl.AppendFieldText(SignName, img[1], true);
				}			
			}
		}
	}
  } catch(e) {
	alert("putSignXML : " + e.description);
	return false;
  }
  return retVal;
}


function SaveTMPFile() {
    var result = "";

    var docID = "";
    if(Saveflag) {
    	docID = newpDocID;
    }
    else {
    	docID = pDocID
    }
    
	var data = {
		docID : docID,
		formId : pFormID,
		html  : HwpCtrl.GetCloneData("", "HWP")
	}
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/saveTmpFileHWP.do",
		contentType : "application/json",
		data : JSON.stringify(data),
		success: function(text){
			result = text;
		}        			
	});

    return result;
}

function SaveTMPDocInfo(AutoSave, Saveflag, pState, phtml) {
    try {
        var objRoot;
        var objNode;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");

        if(Saveflag) 
        	createNodeAndInsertText(xmlpara, objNode, "DOCID", newpDocID);
        else
        	createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "FORMID", pFormID);
        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pOrgDocID);
        else
            createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", "");

        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", pDocType);
        else
            createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", "");

        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", pDocState);

        else
            createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", "");

        createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", strAprState1);
        createNodeAndInsertText(xmlpara, objNode, "HREF", "/document/doc/" + pDocID + ".htm");


        if (HwpCtrl.CheckFieldExist("doctitle"))
            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", HwpCtrl.GetFieldText("doctitle"));
        else
            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", "");

        var field
        if (HwpCtrl.CheckFieldExist("docnumber"))
            field = HwpCtrl.GetFieldText("docnumber");
        else if (HwpCtrl.CheckFieldExist("be_docnumber"))
            field = HwpCtrl.GetFieldText("be_docnumber");
        else if (HwpCtrl.CheckFieldExist("deptshortedname"))
            field = HwpCtrl.GetFieldText("deptshortedname");
        else
            field = "";

        createNodeAndInsertText(xmlpara, objNode, "DOCNO", field);
        createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);
        createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "DRAFTSAVE");
        createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WRITERID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "HTML", "");
        createNodeAndInsertText(xmlpara, objNode, "ORGHTML", "");
        createNodeAndInsertText(xmlpara, objNode, "PUSERID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "PDEPTID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "SECURITY", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICATION", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "PUBLIC", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "ITEMCODE", tempItemCode);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME", tempItemName);
        createNodeAndInsertText(xmlpara, objNode, "URGENTAPPROVAL", tempUrgent);
        createNodeAndInsertText(xmlpara, objNode, "KEYWORD", tempKeyword);
        createNodeAndInsertText(xmlpara, objNode, "XDOCID", "");
        createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
        createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
        createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
        createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
        createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");
        createNodeAndInsertText(xmlpara, objNode, "FORMHREF", FormHref);
        createNodeAndInsertText(xmlpara, objNode, "DOCSN", DocSN);
        createNodeAndInsertText(xmlpara, objNode, "LISTTYPE", ListType);
        createNodeAndInsertText(xmlpara, objNode, "DRAFTFLAG", DraftFlag);

        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml", true);
        if (!g_SepAttachLVXml)
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));

        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);
		createNodeAndInsertText(xmlpara, objNode, "SUMMARYPATH", pSummaryPath);
        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);
        
        if(Saveflag) {
        	createNodeAndInsertText(xmlpara, objNode, "saveFlag", Saveflag);
        	createNodeAndInsertText(xmlpara, objNode, "oldDocID", pDocID);
        }
        
        xmlhttp.open("POST", "/ezApprovalG/doDraftHWP.do", false);
        xmlhttp.send(xmlpara);

        if (xmlhttp.status == 200) {
    		var dataNodes = GetChildNodes(xmlhttp.responseXML);
    		
            return getNodeText(dataNodes[0]);
    	} else {
    		return "FALSE";
    	}
    } catch (e) {
        OpenAlertUI("SaveTMPDocInfo()" + e.description);
    }
}

function OpenInformationUI(pInformationContent) {
	var parameter = pInformationContent;
	var url = "/ezApprovalG/ezAprOpinion.do";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
	return RtnVal;
}

//결재 세부옵션처리
function setFormAprOption(){  
    if(formAprOption.indexOf("_a2_"))  //파일첨부
        setMenuBar("btnFileAttach", false);	
    if(formAprOption.indexOf("_a3_"))  //문서첨부
        setMenuBar("btnAprDocAttach", false);	
}


function openFormUI_CompleteHwp(ret) {
	pFormHref = ret[0];
	pDocType = ret[1];

	if(pFormHref == "PC")
	{
		pReadPC = true;

		var rtnval = HwpCtrl.LoadFile("", false);

		lstAttachLink.innerHTML = "";
		AppendFileAttach = "";
		AppenAprDocAttachList = "";
		window_onbeforeunload();
		pFormID = ""
			pDocID = ""
				pDraftFlag = "DRAFT";

		pSummery = "";
		pSpecialRecordCode = "";
		pPublicityCode = "";
		pLimitRange = "";
		pPageNum = "1";
		cabinetID = "";
		TaskCode = "";
		DocNumCode = "";	  		

		tempSecurity = "";
		tempKeep = "";
		tempUrgent = "N";
		tempPublic = "Y";
		tempKeyword = "";
		tempItemCode = "";
		tempItemName = "";
		tempdocnumcode = strLang107;

		tempSecurityDate = "";

		FieldsAvailable(rtnval);
	}
	else
	{
		if(pFormHref != "cancel")
		{
			HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");

			var isTrue = HwpCtrl.LoadFile(document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pFormHref), false);

			pReadPC = false;

			pFormID = ""
				pDocID = ""
					SetBtnStateTrue();

			lstAttachLink.innerHTML = "";
			AppendFileAttach = "";
			AppenAprDocAttachList = "";
			window_onbeforeunload();
			pFormID = ""
				pDocID = ""
					pDraftFlag = "DRAFT";

			pSummery = "";
			pSpecialRecordCode = "";
			pPublicityCode = "";
			pLimitRange = "";
			pPageNum = "1";
			cabinetID = "";
			TaskCode = "";
			DocNumCode = "";

			tempSecurity = "";
			tempKeep = "";
			tempUrgent = "N";
			tempPublic = "Y";
			tempKeyword = "";
			tempItemCode = "";
			tempItemName = "";
			tempdocnumcode = strLang107;

			tempSecurityDate = "";

			FieldsAvailable(isTrue);
		}
	}	
}

function Form_checkHwp() {
    try {
        form_check_ui_cross_dialogArguments[0] = "";
        form_check_ui_cross_dialogArguments[1] = Form_check_CompleteHwp;
        
        var OpenUrl = "/ezApprovalG/formCheckUI.do";
        
        var OpenWin = window.open(OpenUrl , "formCheckUI", GetOpenWindowfeature(330, 205));
        
        try { OpenWin.focus(); } catch (e) { }

    } catch (e) {
        alert("openFormUI()" + e.description);
    }
}

function Form_check_CompleteHwp(pCheck) {

    if (pCheck.toUpperCase() == "OK")
        openForm();
}