var lastKyulName, lastKyuljiwee, LastSignSN;
var DraftLastFlag = false;

function GetDraftAprLineInfo(ret)
{
  try{
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
					  
	var xmldom = createXmlDom();
	
	if (ret[5] == undefined) {
	    xmlKuljea = ret[0];
	    xmlReDraft = ret[2];
	}
	else {
	    xmlKuljea = ret[1];
	    xmlReDraft = ret[5];
	}
	
	setAprLinesXML(xmlKuljea);
	
	if(xmlReDraft == "C")
	{
		ApplyDocCellInfo();
	}
	else if(xmlReDraft == "R")
	{
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
    


    
	LastSignSN = OrderType.length
    
    for(i=1;i<OrderType.length;i++)
    {
		if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16)
		{
			LastSignSN = i;
			i = OrderType.length
		}
		
		else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType3 || OrderType[i] == strAprType13)
    		LastSignSN = i;
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
		
		if(OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1  || OrderType[i] == strAprType16 || OrderType[i] == strAprType3 || OrderType[i] == strAprType4 || OrderType[i] ==strAprType13)
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
	var xmldom = createXmlDom();
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
	if (getOpinionCount())
	{
		PositionText = "(" + strLang5;
	}
	
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
				HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret), 3, 0, 0, true, 2);
				HwpCtrl.AppendFieldText(psigncell, strLang7 + OpinionText, true);

			  	
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
				
				HwpCtrl.AppendFieldText(psigncell, strLang7 + OpinionText, true);
		  		
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
				HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret), 3, 0, 0, true, 2);
	
				if (HwpCtrl.CheckFieldExist(pseumyungdatecell)) {
				    OpinionText = "";
				}

				if (CurAprType == strAprType4)	
					OpinionText = strLangAprType4 + OpinionText;
	
				HwpCtrl.AppendFieldText(psigncell, OpinionText, true);
	
			  	
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

				if (CurAprType == strAprType4)	
					OpinionText = strLangAprType4 + OpinionText;
			  	
				HwpCtrl.SetFieldText(psigncell, arr_userinfo[2]);	

				HwpCtrl.AppendFieldText(psigncell, OpinionText, true);
			  	
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


function getDraftInfo()
{
  try{
	pFormHref	= FormHref;
	
	
	
	
	pDraftFlag = DraftFlag; 
	pDocType = DocType;

	
	pSusinSN = SusinSN;    
	pDocState= DocState;
	pDocState = ConvertDocState(pDocState);
	  
	if(pDraftFlag == "SUSIN")
	{
		pSusinSN = SusinSN;
		pDocType = DocType;
		pDocState= DocState;
	
		pDocType = ConvertDocType(pDocType);
		pDocState = ConvertDocState(pDocState);
	}
	else if(pDraftFlag == "HAPYUI")
	{
		pDocType = DocType;
		pDocState= DocState;
	
		pDocType = ConvertDocType(pDocType);
		pDocState = ConvertDocState(pDocState);
	}
  }catch(e){
    alert("getDraftInfo()" + e.description);
  }
}


function ConvertDocType(pDocType)
{
	var xmlhttp = createXMLHttpRequest();
	var RtnValxml = createXmlDom();
	var xmlpara = createXmlDom();
  
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "CODE1", "A01");
	createNodeAndInsertText(xmlpara, objNode, "CODE2", pDocType);
	createNodeAndInsertText(xmlpara, objNode, "FLAG", "CODE");

	xmlhttp.open("Post", "/myoffice/ezApprovalG/aspx/getCodeData.aspx", false);
  	xmlhttp.send(xmlpara);	
   	
   	return getNodeText(loadXMLString(xmlhttp.responseText));
}


function ConvertDocState(pDocState)
{
	var xmlhttp = createXMLHttpRequest();
	var RtnValxml = createXmlDom();
	var xmlpara = createXmlDom();
  
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "CODE1", "A02");
	createNodeAndInsertText(xmlpara, objNode, "CODE2", pDocType);
	createNodeAndInsertText(xmlpara, objNode, "FLAG", "CODE");

	xmlhttp.open("Post", "/myoffice/ezApprovalG/aspx/getCodeData.aspx", false);
  	xmlhttp.send(xmlpara);	
   	
   	return getNodeText(loadXMLString(xmlhttp.responseText));
}


function openFormUI()
{
	try
	{
		var parameter = new Array();
		parameter[0] = arr_userinfo[4];
		parameter[1] = "000";				
		
		var url = "/myoffice/ezApprovalG/formContainer/getFormCont.aspx?FileType=hwp";
		var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no"
		var ret = window.showModalDialog(url,parameter,feature);
		
		pFormHref = ret[0];
		pDocType  = ret[1];
		
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
	  			
	  			var isTrue = HwpCtrl.LoadFile(document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pFormHref), false);
		  		
	  			
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
	catch(e)
	{
		alert("openFormUI()" + e.description);
	}
}

function Form_check()
{
  try{
      var url = "/myoffice/ezApprovalG/DraftUI/Form_check_ui.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret = window.showModalDialog(url,"",feature);
	var pCheck = ret;
	if(pCheck == "ok")  
		return "OK";
  }catch(e){
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
		if (pDraftFlag == "REDRAFT") {
		    setMenuBar("btnSaveServer", false);
		}
		else {
		    setMenuBar("btnSaveServer", true);
		}
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
		if (pDraftFlag == "REDRAFT") {
		    setMenuBar("btnSaveServer", false);
		}
		else {
		    setMenuBar("btnSaveServer", true);
		}
	}catch(e){
		alert("SetBtnStateTrue()" + e.description);
	}
}


function createNewDoc()
{
  try{
	var NewDocID;
	var objRoot;
	var objNode;
	
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	

	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);
	createNodeAndInsertText(xmlpara, objNode, "xdocid", "");


	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/createnewdoc.aspx", false);
	xmlhttp.send(xmlpara);
	
	if(xmlhttp.responseText == "False")
	{
		var pAlertContent = strLang131 + "<br> " + strLang721;
		OpenAlertUI(pAlertContent);
	}else{
		return xmlhttp.responseText;
	}
  }catch(e){
    alert("createNewDoc()" + e.description);
  }
}


function getDraftUserInfo()
{
  try{
	var objNode, objRoot;
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
  
	createNodeInsert(xmlpara, objNode, "DATA");
	createNodeAndInsertText(xmlpara, objNode, "CN", pUserID);
	createNodeAndInsertText(xmlpara, objNode, "PROP", "DisplayName;mail;Description;Company;facsimileTelephoneNumber;TelephoneNumber;streetaddress;postalcode");
	createNodeAndInsertText(xmlpara, objNode, "CATE", "user");

	xmlhttp.open("POST","/myoffice/ezOrgan/OrganInfo/GetADInfos.aspx",false);
	xmlhttp.send(xmlpara);
	
	xmluserInfo = loadXMLString(xmlhttp.responseText);
	
	
  }catch(e){
	alert("getDraftUserInfo()" + e.description);
  }
}


function SetAutoPropertyValue()
{
  try{
	var fieldname;
	var field;
	var pSusinNextSN;
	var objNodes;
	var CurrentDate;

	var DocumentInfo = createXmlDom();
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
						HwpCtrl.SetFieldText(Fields[i], SendName + "장");
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
  }catch(e){	
	alert("SetAutoPropertyValue()" + e.description);
  }
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
  
    var url = "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion.aspx";
	var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
	var ret = window.showModalDialog(url,parameter,feature);
	if(ret != "cancel")
	{
	    var NodeList;
	    var objXML = createXmlDom();
	    
	    objXML.loadXML(ret);
	    NodeList = objXML.selectNodes("LISTVIEWDATA/ROWS/ROW");
	
	    if(NodeList.length != 0)
	    {
			pHasOpinionYN = "Y";
	    }else{
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
					strOpinion = "[" + strLang717 + "";
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
	var parameter	= pDocID;
	var url = "/myoffice/ezApprovalG/ezAPRATTACH/Aprattach.aspx?FormID=" + escape(pFormID);
	var feature	= "status:no;dialogWidth:820px;dialogHeight:350px;edge:sunken;scroll:no"; 
	var ret = window.showModalDialog(url,parameter,feature);

	if(ret != "cancel")
	{
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
	var url = "/myoffice/ezApprovalG/ezAprDocAttach/aprCabinetAttach.aspx";
	var feature	= "status:no;dialogWidth:800px;dialogHeight:370px;edge:sunken;scroll:no;help:no"; 
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



function SaveDraftDocInfo()
{
	var rtnVal;
	if (SaveFile() != "TRUE")
		return "FALSE";
		
    SignSave();         
	rtnVal = SaveDraftDocInfo_ilban("002");
	if (rtnVal.toUpperCase() != "TRUE")
	{
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
	

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);

	if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI") {
	    createNodeAndInsertText(xmlpara, objNode, "OrgDocID", pOrgDocID);
	    createNodeAndInsertText(xmlpara, objNode, "DocType", pDocType);
	    createNodeAndInsertText(xmlpara, objNode, "DocState", pDocState);
	}
	else {
	    createNodeAndInsertText(xmlpara, objNode, "OrgDocID", "");
	    createNodeAndInsertText(xmlpara, objNode, "DocType", "");
	    createNodeAndInsertText(xmlpara, objNode, "DocState", "");
	}

	createNodeAndInsertText(xmlpara, objNode, "FunctionType", pState);
	createNodeAndInsertText(xmlpara, objNode, "Href", "/document/doc/" + pDocID + ".hwp");




	if (HwpCtrl.CheckFieldExist("doctitle"))
	    createNodeAndInsertText(xmlpara, objNode, "DocTitle", HwpCtrl.GetFieldText("doctitle"));
	else
	    createNodeAndInsertText(xmlpara, objNode, "DocTitle", "");



	var field = "";
	if (HwpCtrl.CheckFieldExist("docnumber"))
	    field = HwpCtrl.GetFieldText("docnumber");
	else if (HwpCtrl.CheckFieldExist("be_docnumber"))
	    field = HwpCtrl.GetFieldText("be_docnumber");
	else if (HwpCtrl.CheckFieldExist("deptshortedname"))
	    field = HwpCtrl.GetFieldText("deptshortedname");
	else
	    field = "";

	createNodeAndInsertText(xmlpara, objNode, "DocNo", field);


	createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);
	createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", pHasOpinionYN);

	var startdate;
	if (pState == "000")
	    startdate = "DRAFTSAVE";
	else
	    startdate = "DRAFT";
	createNodeAndInsertText(xmlpara, objNode, "StartDate", startdate);
	createNodeAndInsertText(xmlpara, objNode, "EndDate", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "WriterID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "WriterName", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", arr_userinfo[13]);
	createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", arr_userinfo[4]);
	createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", arr_userinfo[15]);
	createNodeAndInsertText(xmlpara, objNode, "Html", "");
	createNodeAndInsertText(xmlpara, objNode, "OrgHtml", "");
	createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

	createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
	createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
	createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);

	createNodeAndInsertText(xmlpara, objNode, "public", tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "ItemCode", tempItemCode);
	createNodeAndInsertText(xmlpara, objNode, "ItemName", tempItemName);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);
	createNodeAndInsertText(xmlpara, objNode, "UrgentApproval", tempUrgent);
	createNodeAndInsertText(xmlpara, objNode, "KeyWord", tempKeyword);
	createNodeAndInsertText(xmlpara, objNode, "Xdocid", "");

	createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
	createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
	createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml");
	if (!g_SepAttachLVXml)
	    createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", "");
	else
	    createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", GetSepAttParamXml(g_SepAttachLVXml));

	createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);

	createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);

	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName2);


	
	xmlhttp.open("POST","aspx/dodraft_HWP.aspx",false);
	xmlhttp.send(xmlpara);
	
	if(pState != "000")		
		SetBtnStateFalse();
	return getNodeText(loadXMLString(xmlhttp.responseText));
  }catch(e){
    alert("SaveDraftDocInfo_ilban(pState)" + e.description);
  }
}


function openSignUI()
{
  try{
	var objRoot;
	var objNode;
	var SignNodeList;
	    
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
	  
	xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/GetSignRequest.aspx", false);
	xmlhttp.send(xmlpara);
  
    SignNodeList = loadXMLString(xmlhttp.responseText).selectNodes("LISTVIEWDATA/ROWS/ROW"); 
  
    if(SignNodeList.length != 0)
    { 
		var parameter	= pUserID;
		var url = "/myoffice/ezApprovalG/ezAPRSIGN/AprSign1_Cross.aspx";
		var feature	= "status:no;dialogWidth:350px;dialogHeight:310px;help:no;scroll:no;edge:sunken";
	    var ret = window.showModalDialog(url,parameter,feature);
    }else{
		var ret = "NAME";
    }
	return ret;
  }catch(e){
    alert("openSignUI()" + e.description);
  }
}


function openAprLineUI()
{
  
  
  try{
	var parameter	= new Array();
	parameter[0]  = pDocID;
	parameter[1]  = pFormID;
	parameter[2]  = SignCount;
	parameter[3]  = SignInfo;
	parameter[4]  = hapyuiCount;
	parameter[5]  = pDraftFlag;
	parameter[6]  = pSuSinFlag;
	parameter[7]  = pChamJoFlag;
	parameter[8]  = gongramCount;
	parameter[9]  = false;        
	parameter[10] = pDocType;    
	parameter[11] = gamsaCount;
	parameter[12] = "";

	var url = "/myoffice/ezApprovalG/ezAPRLINE/aprline.aspx";
	var feature	= "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";

	
	
	
	var ret = window.showModalDialog(url,parameter,feature);	
	return ret;
  }catch(e){
	alert("openAprLineUI()" + e.description);
  }
}


function openReceivUI()
{
	var parameter	= new Array();
	isExtDoc = GetDocumentElement(HwpCtrl, "EXTDOC");
	if(isExtDoc != "Y")	isExtDoc = "N"
	
	parameter[0]	= pFormID;
	parameter[1]	= pDocID;
	parameter[2]    = "SEND"
	parameter[3]	= isExtDoc;
	
	
	parameter[4] = DocType;
	
	var url = "/myoffice/ezApprovalG/ezAPRDEPT/AprDept1.aspx";
	var feature	= "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
	  
  	var ret = window.showModalDialog(url,parameter,feature);
	return ret
}


function GetAprDocFormID()
{
  try{
	var objRoot;
	var objNode;
	
	var xmlpara = createXmlDom();	
	var xmlhttp = createXMLHttpRequest();
	
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

	xmlhttp.open("Post", "/myoffice/ezApprovalG/draftui/aspx/GetAprDocFormID.aspx", false);
	xmlhttp.send(xmlpara);
	
	pFormID = getNodeText(loadXMLString(xmlhttp.responseText).childNodes(0));
  }catch(e){
    alert("GetAprDocFormID()" + e.description);
  }
}

function trim(parm_str)
{
  if(parm_str == "")
	return ""
  else
	return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
  var str_temp = parm_str ;
  while (str_temp.length != 0) {
    if (str_temp.substring(0, 1) == " ") {
      str_temp = str_temp.substring(1, str_temp.length) ;
    } else {
      return str_temp ;
    }
  }
  return str_temp ;
}

function rtrim(parm_str) {
  var str_temp = parm_str ;
  while (str_temp.length != 0) {
    int_last_blnk_pos = str_temp.lastIndexOf(" ");
    if ((str_temp.length - 1) == int_last_blnk_pos) {
      str_temp = str_temp.substring(0, str_temp.length - 1);
    } else {
      return str_temp;
    }
  }
  return str_temp;
}


function getGyulJeDate()
{
  try{
	var objRoot;
	var objNode;
	    
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
		  

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "getDate", "");

	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetDate.aspx", false);
	xmlhttp.send(xmlpara);
		  
	return xmlhttp.responseText;

  }catch(e){
    alert("getGyulJeDate()" + e.description);
  }
}

function getGyulJeFullDate()
{
  try{
	var objRoot;
	var objNode;
	    
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
		  
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "getDate", "");

	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetFullDate.aspx", false);
	xmlhttp.send(xmlpara);
		  
	return xmlhttp.responseText;

  }catch(e){
    alert("getGyulJeFullDate()" + e.description);
  }
}


function setSusinUpdataDocID()
{
  try{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pOrgDocID", pOrgDocID);
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

	xmlhttp.open("POST", "/myoffice/ezApprovalG/DraftUI/aspx/setSusinUpdateDocID.aspx", false);
	xmlhttp.send(xmlpara);

	return xmlhttp.responseText;
  }catch(e){
	alert("setSusinUpdataDocID()" + e.description);
  }
}

function OpenInformationUI(pInformationContent)
{
	var parameter = pInformationContent;
	var url = "/myoffice/ezApprovalG/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
	return RtnVal;
}

function OpenAlertUI(pAlertContent)
{
	var parameter = pAlertContent;
	var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
}


function getDocInfo()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

	xmlhttp.open("Post", "/myoffice/ezApprovalG/aspx/getDocInfo.aspx", false);
	xmlhttp.send(xmlpara);	
	xmldoc=loadXMLString(xmlhttp.responseText); 

	var objNodes = xmldoc.documentElement.childNodes;
	if(objNodes)
	{
		pOrgDocID = getNodeText(objNodes(2));			
		if (getNodeText(objNodes(10)) == "Y" || getNodeText(objNodes(10)) == "O")
			pHasOpinionYN = "Y";
			
		tempSecurity = getNodeText(objNodes(19));
		tempKeep = getNodeText(objNodes(20));
		tempUrgent = getNodeText(objNodes(21));
		tempPublic = getNodeText(objNodes(18));
		tempKeyword = getNodeText(objNodes(25));
		tempItemCode = getNodeText(objNodes(23));
		tempItemName = getNodeText(objNodes(24));		
		
		
		pSummery = getNodeText(objNodes(35));
		pSpecialRecordCode = getNodeText(objNodes(26));
		pPublicityCode = getNodeText(objNodes(27));
		pLimitRange = getNodeText(objNodes(28));
		pPageNum = getNodeText(objNodes(29));		
		cabinetID = getNodeText(objNodes(30));
		TaskCode = getNodeText(objNodes(31));
		
		
		tempSecurityDate = getNodeText(objNodes(36));
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

	var DocumentInfo = createXmlDom();
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

function chk_Passwd()
{
	var parameter = pUserID;
	var url = "/myoffice/ezApprovalG/ezchkPasswd.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret = window.showModalDialog(url,parameter,feature);

	return ret
}

function setDrafterAddress()
{
	SetDocumentElement(HwpCtrl, "drafter", arr_userinfo[2]);
	SetDocumentElement(HwpCtrl, "address", arr_userinfo[8]);
	SetDocumentElement(HwpCtrl, "drafterdept",arr_userinfo[4]);
	SetDocumentElement(HwpCtrl, "lastKyulName", lastKyulName);
	SetDocumentElement(HwpCtrl, "lastKyuljikwee", lastKyuljiwee);
}



function setFirstDrafter()
{
	var ret = getAutoAprLine();
	
	if (ret[0] != "NONE")
	{
		IsSkipDrafter = "FALSE";
		btnSendDraftEnable = "true";
		GetDraftAprLineInfo(ret);
	}
	return;
}

function delOpinionInfo()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "DocID", "002");

	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPROPINION/aspx/DeleteOpinionTypeInfo.aspx", false);
	xmlhttp.send(xmlpara);

	pHasOpinionYN = "";
	return xmlhttp.responseText;
}

function deltmpDocinfo(pSN)
{
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
	createNodeAndInsertText(xmlpara, objNode, "SN", pSN);

	xmlhttp.open("POST", "/myoffice/ezApprovalG/DraftUI/aspx/delTMPDocInfo.aspx", false);
	xmlhttp.send(xmlpara);

	return xmlhttp.responseText;
}

function removeDocInfo()
{
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "FIELD", "CHECK");

	xmlhttp.open("POST", "/myoffice/ezApprovalG/ReceivUI/aspx/deldocinfo.aspx", false);
	xmlhttp.send(xmlpara);
}

function CheckMem(DeptID)
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom(); 
	var objNode;
	createNodeInsert(xmlpara, objNode, "DATA");
	createNodeAndInsertText(xmlpara, objNode, "CN", DeptID);
	createNodeAndInsertText(xmlpara, objNode, "PROP", "DisplayName");
	createNodeAndInsertText(xmlpara, objNode, "CATE", "group");

	xmlhttp.open("POST","/myoffice/ezOrgan/OrganInfo/GetADInfos.aspx",false);
	xmlhttp.send(xmlpara);
	
	return getNodeText(xmlhttp.reponseXML);
}


function getDeptSymbol(DeptID, DeptName)
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom(); 
	
	var objNode;
	createNodeInsert(xmlpara, objNode, "DATA");
	createNodeAndInsertText(xmlpara, objNode, "CN", DeptID);
	createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute6");
	createNodeAndInsertText(xmlpara, objNode, "CATE", "group");

	xmlhttp.open("POST","/myoffice/ezOrgan/OrganInfo/GetADInfos.aspx",false);
	xmlhttp.send(xmlpara);
	
	if (getNodeText(loadXMLString(xmlhttp.responseText)) == "")
	{
		return DeptName;
	}
	else
	{
		return getNodeText(loadXMLString(xmlhttp.responseText));
	}
}

function getDeptSendName(DeptID)
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom(); 
	
	var objNode;
	createNodeInsert(xmlpara, objNode, "DATA");
	createNodeAndInsertText(xmlpara, objNode, "CN", DeptID);
	createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute5");
	createNodeAndInsertText(xmlpara, objNode, "CATE", "group");

	xmlhttp.open("POST","/myoffice/ezOrgan/OrganInfo/GetADInfos.aspx",false);
	xmlhttp.send(xmlpara);

	return trim(getNodeText(loadXMLString(xmlhttp.responseText)));
}


function setMenuBar(id,flag)
{
	var strCmd, display_Value
			
	if(flag) 
		display_Value = ""
	else
		display_Value = "none"
		
	strCmd = id + ".style.display='" + display_Value + "'"
	eval(strCmd); 
}


function SaveFile()
{


    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();


    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));

		
	xmlhttp.open("POST","aspx/SaveFileHWP.aspx",false);
	xmlhttp.send(xmlpara);
		
	return xmlhttp.responseText;
}

function SaveOrgFile()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "Html", pOrgHtml);

		
	xmlhttp.open("POST","aspx/SaveFileHWP.aspx",false);
	xmlhttp.send(xmlpara);
		
	return xmlhttp.responseText;
}


function SignSave()
{
	if (SignContent.length > 0)
	{
		var xmlhttp = createXMLHttpRequest();
		var xmlpara = createXmlDom();
  
		var objRoot, objNode, subNode;
		objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

		for (i = 0; i < SignContent.length; i++) {
		    objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "SIGNINFO");
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", pDocID);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNTYPE", SignType[i]);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNNAME", SignName[i]);
		    createNodeAndAppandNodeText(xmlpara, objNode, subNode, "CONTENT", SignContent[i]);
		}
		xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/setSignInfo.aspx", false);
		xmlhttp.send(xmlpara);
	}
}

function SignCheck()
{
	var SignXML = createXmlDom();
	
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
  
	xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/getSignInfo.aspx", false);
	xmlhttp.send(xmlpara);
	
	if (loadXMLString(xmlhttp.responseText).xml == "") 
		return;
	
	var NodeList;
	NodeList = loadXMLString(xmlhttp.responseText).selectNodes("SIGNINFOS/SIGNINFO");
	if (NodeList.length <= 0) 
		return;
	
	SignXML = loadXMLString(xmlhttp.responseText);

	var rtnVal = putSignXML(SignXML);
	if (rtnVal)	
	{
		SaveFile();
		
		
	}
}

function putSignXML(SignXML)
{
  var retVal = false;
  try {
	var NodeList;
	NodeList = SignXML.selectNodes("SIGNINFOS/SIGNINFO");
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
					HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SignCont), 3, 0, 0, true, 2);
					HwpCtrl.AppendFieldText(SignName, strLang17, true);
				}
				else if (SignType == "IMAGE")  
				{
				    var img = SignCont.split("::"); 
					HwpCtrl.SetFieldText(SignName, "");
					if(img.length >= 1)
					    HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(img[0]), 3, 0, 0, true, 2);
					    
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



function UndoDoc()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/UndoDoc.aspx", false);
	xmlhttp.send(xmlpara);
}

function getSignDate()
{
	var GyulJeDate;
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "getDate", "");

	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetSignDate.aspx", false);
	xmlhttp.send(xmlpara);

	return xmlhttp.responseText;
}


function getHistory()
{	
    var URL = "/myoffice/ezApprovalG/ezAPRHISTORY/ezAPRHISTORY_Cross.aspx?DocID=" + pDocID;
	centerOpenWindow(URL, 730, 430);
}

function centerOpenWindow(wfileLocation, wWeight, wHeight)
{
	try{
		var heigth = window.screen.availHeight;
		var width = window.screen.availWidth;
		
		var left = (width - wWeight) / 2;
		var top = (heigth - wHeight) / 2;
		
		window.open(wfileLocation, "" ,"toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	
	}catch(e){
		alert("centerOpenWindow :: " + e.description);
	}
}

function UpdateDocHistory(pHtml)
{
	var xmlhttp2 = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pHtml", pHtml);

	xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezAPRHISTORY/aspx/UploadDocHistoryHWP.aspx", false);
	xmlhttp2.send(xmlpara);
	
	var URL = xmlhttp2.responseText;
	
	if (URL.length < 255 && URL != "FALSE")
	{
		var xmlhttp = createXMLHttpRequest();		
		var xmlpara = createXmlDom();
		var objNode;
		createNodeInsert(xmlpara, objNode, "PARAMETER");
		createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
		createNodeAndInsertText(xmlpara, objNode, "pURL", URL);
		createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
		createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
		createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
		createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
		createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
		createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
		createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[14]);
		createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", arr_userinfo[16]);

		xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPRHISTORY/aspx/UpdateDocHistory.aspx", false);
		xmlhttp.send(xmlpara);

		if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE")
		{
		}
		else
		{
			var pAlertContent = "" + strLang718 + "";
      		OpenAlertUI(pAlertContent);
		}
	}
	else
	{
		var pAlertContent = "" + strLang719 + "";
		OpenAlertUI(pAlertContent);
	}
}


function UpdateLineHistory()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
	createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
	createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
	createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
	createNodeAndInsertText(xmlpara, objNode, "chkFlag", "MUST");
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[14]);
	createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", arr_userinfo[16]);
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPRHISTORY/aspx/UpdateLineHistory.aspx", false);
	xmlhttp.send(xmlpara);
	
	if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE")
	{
	}
	else
	{
		var pAlertContent = strLang720;
    	OpenAlertUI(pAlertContent);
	}	
}

function getOpinionCount()
{
  try {
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
	createNodeAndInsertText(xmlpara, objNode, "chkFlag", "ING");
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPROPINION/aspx/GetOpinionCount.aspx", false);
	xmlhttp.send(xmlpara);
	
	var tempValue = parseInt(getNodeText(loadXMLString(xmlhttp.responseText)))	
	if (tempValue > 0)
	{
		return true;
	}
	else
	{
		return false;
	}
  } catch(e) {
	return false;
  }
}

function setFirstDrafterAuto() {

    var d = new Date();
    var RecieveDay = d.getFullYear() + "." + (d.getMonth() + 1) + "." + d.getDate();

    var pxml
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    pxml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang331 + "</NAME><WIDTH>100</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>100</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>150</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>150</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>100</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang332 + "</NAME><WIDTH>120</WIDTH></HEADER>"
    pxml = pxml + "<HEADER><NAME>" + strLang333 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>"
    pxml = pxml + "<ROWS><ROW><COLUMN>1</COLUMN>"
    pxml = pxml + "<COLUMN>" + arr_userinfo[2] + "</COLUMN>"
    pxml = pxml + "<COLUMN>" + arr_userinfo[3] + "</COLUMN>"
    pxml = pxml + "<COLUMN>" + arr_userinfo[5] + "</COLUMN>"
    pxml = pxml + "<COLUMN>" + strLang6 + "</COLUMN>"
    pxml = pxml + "<COLUMN>" + strLang18 + "</COLUMN>"
    pxml = pxml + "<DATA name='ProcessDate'></DATA>"
    pxml = pxml + "<DATA name='ReceivedDate'>" + RecieveDay + "</DATA>"
    pxml = pxml + "<DATA name='DocID'>" + pDocID + "</DATA>"
    pxml = pxml + "<DATA name='AprMemberID'>" + arr_userinfo[1] + "</DATA>"
    pxml = pxml + "<DATA name='AprmemberIsDeptYN'>N</DATA>"
    pxml = pxml + "<DATA name='AprMemberDeptID'>" + arr_userinfo[4] + "</DATA>"
    pxml = pxml + "<DATA name='ReasonDoNotApprov'>" + "" + "</DATA>"
    pxml = pxml + "<DATA name='isProposerYN'>N</DATA>"
    pxml = pxml + "<DATA name='isBriefUserYN'>N</DATA>"
    pxml = pxml + "<DATA name='isCompanyID'>" + pCompanyID + "</DATA>"
    pxml = pxml + "<DATA name='AprType'>" + strAprType4 + "</DATA>" 
    pxml = pxml + "<DATA name='AprState'>" + strAprState2 + "</DATA>" 
    pxml = pxml + "<DATA name='PMemberName'>" + arr_userinfo[11] + "</DATA>"
    pxml = pxml + "<DATA name='SMemberName'>" + arr_userinfo[12] + "</DATA>"
    pxml = pxml + "<DATA name='PMemberDeptName'>" + arr_userinfo[15] + "</DATA>"
    pxml = pxml + "<DATA name='SMemberDeptName'>" + arr_userinfo[16] + "</DATA>"
    pxml = pxml + "<DATA name='PMemberJobTitle'>" + arr_userinfo[13] + "</DATA>"
    pxml = pxml + "<DATA name='SMemberJobTitle'>" + arr_userinfo[14] + "</DATA>"
    pxml = pxml + "</ROW></ROWS></LISTVIEWDATA>"

    xmlpara.loadXML(pxml);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave.aspx", false);
    xmlhttp.send(xmlpara);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

function RemoveTmpDoc(pDocID) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();

    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/RemoveTMPDocInfo.aspx", false);

    xmlhttp.send(xmlpara);

    var RtnVal = getNodeText(loadXMLString(xmlhttp.responseText));
    if (RtnVal != "TRUE") {
        var pAlertContent = strLang1008;
        OpenAlertUI(pAlertContent);
    }
}

function SaveTMPFile() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));

    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/saveTmpFile_Hwp.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}

function SaveTMPDocInfo(AutoSave, saveflag, pState, phtml) {
    try {
        var objRoot;
        var objNode;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");

        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);
        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "OrgDocID", pOrgDocID);
        else
            createNodeAndInsertText(xmlpara, objNode, "OrgDocID", "");

        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "DocType", pDocType);
        else
            createNodeAndInsertText(xmlpara, objNode, "DocType", "");

        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI")
            createNodeAndInsertText(xmlpara, objNode, "DocState", pDocState);

        else
            createNodeAndInsertText(xmlpara, objNode, "DocState", "");

        createNodeAndInsertText(xmlpara, objNode, "FunctionType", strAprState1);
        createNodeAndInsertText(xmlpara, objNode, "Href", "/document/doc/" + pDocID + ".htm");


        if (HwpCtrl.CheckFieldExist("doctitle"))
            createNodeAndInsertText(xmlpara, objNode, "doctitle", HwpCtrl.GetFieldText("doctitle"));
        else
            createNodeAndInsertText(xmlpara, objNode, "doctitle", "");

        var field
        if (HwpCtrl.CheckFieldExist("docnumber"))
            field = HwpCtrl.GetFieldText("docnumber");
        else if (HwpCtrl.CheckFieldExist("be_docnumber"))
            field = HwpCtrl.GetFieldText("be_docnumber");
        else if (HwpCtrl.CheckFieldExist("deptshortedname"))
            field = HwpCtrl.GetFieldText("deptshortedname");
        else
            field = "";

        createNodeAndInsertText(xmlpara, objNode, "doctitle", field);





        createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", pHasOpinionYN);
        createNodeAndInsertText(xmlpara, objNode, "StartDate", "DRAFTSAVE");
        createNodeAndInsertText(xmlpara, objNode, "EndDate", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WriterID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "WriterName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "Html", "");
        createNodeAndInsertText(xmlpara, objNode, "OrgHtml", "");
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "public", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "ItemCode", tempItemCode);
        createNodeAndInsertText(xmlpara, objNode, "ItemName", tempItemName);
        createNodeAndInsertText(xmlpara, objNode, "UrgentApproval", tempUrgent);
        createNodeAndInsertText(xmlpara, objNode, "KeyWord", tempKeyword);
        createNodeAndInsertText(xmlpara, objNode, "Xdocid", "");
        createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
        createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
        createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
        createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
        createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);
        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", DocNumCode);
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", "");

        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml");
        if (!g_SepAttachLVXml)
            createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", GetSepAttParamXml(g_SepAttachLVXml));

        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);
        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", arr_userinfo[16]);
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);
        if (Saveflag)
            xmlhttp.open("POST", "aspx/dodraftTmp_hwp.aspx", false);
        else
            xmlhttp.open("POST", "aspx/dodraft_hwp.aspx", false);

        xmlhttp.send(xmlpara);

        return getNodeText(loadXMLString(xmlhttp.responseText));
    } catch (e) {
        OpenAlertUI("SaveTMPDocInfo()" + e.description);
    }
}