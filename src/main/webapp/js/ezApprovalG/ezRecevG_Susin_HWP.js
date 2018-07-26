function btnSetTaskCode_onclick() {
  try {
	var para = new Array();
	para[0] = cabinetID;
	var url = "/myoffice/ezApprovalG/ezCabinet/SelectCabinet.aspx?initFlag=1";
	var feature = "dialogWidth:850px;dialogHeight:455px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
  
	if(url != "") {
		var rtn = window.showModalDialog(url,para,feature);
	}
	
	if (rtn[0] == "TRUE") {
		var g_SelCabXml = rtn[1];
		var xmlCab = createXmlDom();
		xmlCab = loadXMLString(g_SelCabXml);
		cabinetID = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/CABINETID"));
		TaskCode = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/TASKCODE"));
	}
  } catch(e) {
	alert("btnSetTaskCode_onclick : " + e.description);
  }
}

function GetDraftAprLineInfo(ret) {
    try {
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

        var susinSN = "";
        if (pDraftFlag == "SUSIN" || pDocState == "011") {
            susinSN = pSusinSN
        }

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


        if (xmlReDraft == "C") {
            ApplyDocCellInfo();
        }
        else if (xmlReDraft == "R") {
            ClearDocCellInfo();
        }


        xmldom = loadXMLString(xmlKuljea);
        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        count = objNodes.length;


        for (i = 1; i < 20; i++) {
            name = susinSN + "habyuisign" + i;
            if (HwpCtrl.CheckFieldExist(name)) {
                name = susinSN + "habyui" + i;
                if (HwpCtrl.CheckFieldExist(name))
                    HwpCtrl.SetFieldText(name, "");

                name = susinSN + "habyuisign" + i;
                if (HwpCtrl.CheckFieldExist(name))
                    HwpCtrl.SetFieldText(name, "");

                name = susinSN + "habyuipositon" + i;
                if (HwpCtrl.CheckFieldExist(name))
                    HwpCtrl.SetFieldText(name, "");


                name = susinSN + "habyuidate" + i;
                if (HwpCtrl.CheckFieldExist(name))
                    HwpCtrl.SetFieldText(name, "");
            }
            else {
                break;
            }
        }

        if (HwpCtrl.CheckFieldExist("refer"))
            HwpCtrl.SetFieldText("refer", "");


        if (HwpCtrl.CheckFieldExist("hgamsa"))
            HwpCtrl.SetFieldText("hgamsa", "");


        for (i = 1; i < 20; i++) {
            if (HwpCtrl.CheckFieldExist("gongram" + i))
                HwpCtrl.SetFieldText("gongram" + i, "");
        }


        for (i = 0; i < count; i++) {
        	var Cell = GetChildNodes(objNodes[i]);
            var KyljeaOrder = getNodeText(Cell[0]);
            var KyljeaName = getNodeText(Cell[1]);
            var KyljeaDeptName = getNodeText(Cell[3]);
            var KyljeaType = getNodeText(Cell[16]);
            var KyljeaTypeName = getNodeText(Cell[4]);
            var KyljeaStat = getNodeText(Cell[17]);
            var KyljeaStatName = getNodeText(Cell[5]);
            var KyljeaJobtitle = getNodeText(Cell[2]);
            var ReasonDoNotApprov = getNodeText(Cell[12]);
            var suggester = getNodeText(Cell[13]);
            var reporter = getNodeText(Cell[14]);

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

        LastSignSN = OrderType.length

        CurAprType = OrderType[1];
        if (OrderType.length > 2)
            NextAprType = OrderType[2];

        for (i = 1; i < OrderType.length; i++) {
            if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) {
                LastSignSN = i;
                i = OrderType.length
            }
            else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3)
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
        var refer = "";




        for (i = 1; i < 20; i++) {
            fieldname = susinSN + "jikwe" + i
            if (HwpCtrl.CheckFieldExist(fieldname)) {
                HwpCtrl.SetFieldText(fieldname, "");
                fieldname = susinSN + "sign" + i
                if (HwpCtrl.CheckFieldExist(fieldname))
                    HwpCtrl.SetFieldText(fieldname, "");
            } else {
                break;
            }
        }

        var idx = 1;
        var hidx = 1;

        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) {

                fieldname = susinSN + "jikwe" + idx;
                if (HwpCtrl.CheckFieldExist(fieldname)) {
                    var jikweName = trim(HwpCtrl.GetFieldText(fieldname));
                    if (jikweName.substring(0, 1) != "" + strLang128 + "")
                        HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);

                    if (OrderSuggester[i] == "Y")
                        HwpCtrl.SetFieldText(fieldname, strLang75 + HwpCtrl.GetFieldText(fieldname));

                    if (OrderReporter[i] == "Y")
                        HwpCtrl.SetFieldText(fieldname, strLang76 + HwpCtrl.GetFieldText(fieldname));
                }
                idx = idx + 1;
            }
            else if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
                fieldname = susinSN + "habyui" + hidx;
                if (HwpCtrl.CheckFieldExist(fieldname))
                    HwpCtrl.SetFieldText(fieldname, OrderDept[i]);

                fieldname = susinSN + "habyuipositon" + hidx;
                if (HwpCtrl.CheckFieldExist(fieldname)) {
                    var jikweName = trim(HwpCtrl.GetFieldText(fieldname));
                    if (jikweName.substring(0, 1) != "" + strLang128 + "")
                        HwpCtrl.SetFieldText(fieldname, OrderJobtitle[i]);

                    if (OrderSuggester[i] == "Y")
                        HwpCtrl.SetFieldText(fieldname, strLang75 + HwpCtrl.GetFieldText(fieldname));

                    if (OrderReporter[i] == "Y")
                        HwpCtrl.SetFieldText(fieldname, strLang76 + HwpCtrl.GetFieldText(fieldname));
                }
                hidx = hidx + 1;
            }
        }



    } catch (e) {
        alert("GetDraftAprLineInfo(ret)" + e.description);
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

  }catch(e){
    alert("setClearSusinCellInfo : " + e.description);
  }
}

function SendDraftMappingSign(ret)
{
  try{
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt;
	var sn = 1;
	
	var OpinionText = "";
	var PositionText = "";
	
	if( LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16 ) {
		OpinionText = getSignDate() + "\15";
	}
	
	signCnt = 0;
	if(pDraftFlag == "SUSIN" ||  pDocState == "011") { 
	  	psigncell = pSusinSN + "sign" + sn;
	  	pseumyungcell = pSusinSN + "jikwe" + sn;
	  	pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
	} else {
	  	psigncell = "sign" + sn;
	  	pseumyungcell = "jikwe" + sn;
	  	pseumyungdatecell = "seumyungdate" + sn;
	}
	
	 
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
		
	if(CurAprType == strAprType16 )
	{			
		if (HwpCtrl.CheckFieldExist(psigncell))
		{
			
			if(ret != "NAME")
			{
				HwpCtrl.SetFieldText(psigncell, "");	
				HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname +  ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);
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
		if(pDraftFlag == "SUSIN" ||  pDocState == "011")  
		{ 
		  	psigncell = pSusinSN + "sign" + sn;
		  	pseumyungcell = pSusinSN + "jikwe" + sn;
		  	pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
		}else{
		  	psigncell = "sign" + sn;
		  	pseumyungcell = "jikwe" + sn;
		  	pseumyungdatecell = "seumyungdate" + sn;
		}
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
				HwpCtrl.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(ret), 3, 0, 0, true, 2);
			
				if (HwpCtrl.CheckFieldExist(pseumyungdatecell))
				    OpinionText = "";

				if (CurAprType == strAprType4 )	
					OpinionText = strLang6 + OpinionText;
	
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
			    if (HwpCtrl.CheckFieldExist(pseumyungdatecell))
			        OpinionText = "";

				if (CurAprType == strAprType4 )	
					OpinionText = strLang6 + OpinionText;
			  	
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

function getDraftInfo()
{
  try{
	pFormHref	= FormHref;
	pDraftFlag = DraftFlag; 
	pDocType = DocType;

	
	pSusinSN = SusinSN;    
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
	else
	{
		pDocState= DocState;
		pDocState = ConvertDocState(pDocState);
	}
	pCurSelRow = CurSelRow;
  
  }catch(e){
    alert("getDraftInfo : " + e.description);
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


function SetBtnStateFalse()
{
	try{
		setMenuBar("btnSetAprLine", false);
		setMenuBar("btnSendDraft", false);
		setMenuBar("btnOpinion", false);
	}catch(e){
		alert("SetBtnStateFalse : " + e.description);
	}
}


function SetBtnStateTrue()
{
	try{
		setMenuBar("btnSetAprLine", true);
		setMenuBar("btnOpinion", true);
		setMenuBar("btnPrint", true);
		btnClose.Enable			= "true";		
	}catch(e){
		alert("SetBtnStateTrue : " + e.description);
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

	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/createnewdoc.aspx", false);
	xmlhttp.send(xmlpara);
	
	if(xmlhttp.responseText == "False")
	{
		var pAlertContent = strLang131 + "<br> " + strLang730;
		OpenAlertUI(pAlertContent);
	}else{
		return xmlhttp.responseText;
	}
  }catch(e){
    alert("createNewDoc : " + e.description);
  }
}


function getDraftUserInfo() {
	try {
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezOrgan/getADInfos.do",
			data : {
				cn : pUserID,
				prop : "displayName;mail;description;company;facsimileTelephoneNumber;telephoneNumber;streetaddress;postalcode",
				cate  : "user"
			},
			success: function(xml){
				xmluserInfo = loadXMLString(xml);
			}        			
		});
	} catch (e) {
	    alert("getDraftUserInfo()" + e.description);
	}
}

function SetAutoPropertyValue() {
  try {
	var fieldname;
	var field;
	var pSusinNextSN;
	var objNodes;
	var CurrentDate;
	objNodes = xmluserInfo.documentElement.childNodes;
	  
    CurrentDate = getGyulJeDate();
    SignInfo = "";
    hapyuiCount = 0;
    SignCount = 0;
 
	var FieldLists = HwpCtrl.GetFieldList();
	var Fields = FieldLists.split(";");
	
	for (i = 0 ; i < Fields.length ; i ++) {
	  	if(pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
	  		switch (Fields[i]) {
	  			case "enforcedate" :		  
	  		  		break;
	  			case "recipient" :			  
		  		  	break;
	  			case "refer" :				    
	  		  		break;
	  			case "zipcode" :			    
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(7)));
	  		  		break;
	  			case "address" :			    
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(6)));
	  		  		break;												
	  			case "telephone" :		  	
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(5)));
	  		  		break;												
	  			case "fax" :			      	
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(5)));
	  		  		break;												
	  			case "department" :		  	
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(2)));
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
	  			case "keepperiod" :			  
	  		  		
	  		  		break;												
	  			case "publication" :		  
	  		  		
	  		  		break;												
	  			case "examname" :			    
	  		  		break;												
	  			case "examdate" :			    
	  		  		break;												
	  			case "headcampaign" :		  
	  				HwpCtrl.SetFieldText(Fields[i], getNodeText(objNodes.item(3)));
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
	  			case "receiptdate" :
	  				HwpCtrl.SetFieldText(Fields[i], CurrentDate);
	  		  		break;
 			}
	  	}
	  	else
	  	{
	  	    switch (Fields[i])
	  	    {
  	  		    case "receiptdate" :
  	  				HwpCtrl.SetFieldText(Fields[i], CurrentDate);
					break;
	  	     	case pSusinSN + "receiptdate" :	 
	  	     		HwpCtrl.SetFieldText(Fields[i], CurrentDate);
	  				break;
				case "susinhide" :
					break;
				case "susinhideP" :
					break;
				case "susinbody" :
					setMenuBar("btnEdit", true);
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
      
		
		var pSignSusin = pSusinSN + "habyuisign";
	    if (Fields[i].substr(0, 11) == pSignSusin)
	    {
	    	hapyuiCount = hapyuiCount + 1;
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
	    }
	    else
	    {
			if(Fields[i].substr(0,5) == "jikwe")
			{
				if(SignInfoFlag)
				{
					SignInfo = HwpCtrl.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}
				else
				{
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
	if(HwpCtrl.CheckFieldExist(fieldname)) {
		pSuSinFlag = "Y";
		btnSetReceivLine.style.display = "";
	}
	
	pChamJoFlag = "Y";
  }catch(e){	
	  alert("SetAutoPropertyValue : " + e.description);
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
		
	var url = "/myoffice/ezApprovalG/ezAPRDEPT/AprDept1.aspx";
	var feature	= "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
  	var ret = window.showModalDialog(url,parameter,feature);

	return ret
}

function setRecevInfo(ret) {
    setDeptLinesXML(ret);
    var precipent = ""
    var precipents = ""
    var recipflag = true;
    var xmldom = createXmlDom();
    xmldom.async = false;
    xmldom.loadXML(ret)

    if (xmldom.documentElement.length == 0) return;
    var rows = xmldom.documentElement.childNodes
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

            if (getNodeText(rows(i).childNodes(3)) == "Y")
                precipents = precipents + "," + getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0))
            else {
                if (isExtDoc == "Y")
                    precipents = precipents + "," + getNodeText(rows(i).childNodes(7)) + " " + getNodeText(rows(i).childNodes(0));
                else
                    precipents = precipents + "," + getNodeText(rows(i).childNodes(0));
            }
        }
    }
}

var apropinion_cross_dialogArguments = new Array();
function openOpinionUI(pOpinionFlag) {
    var parameter = new Array();
    
    parameter[0]	= pDocID;
    parameter[1]	= pOpinionFlag;
    parameter[2]	= KuyjeType;
    parameter[3]	= pDraftFlag;
    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
    parameter[99] = "hwp";
    
    var url = "/ezApprovalG/aprOpinion.do";
	var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no;help:no"
	var ret     = window.showModalDialog(url,parameter,feature);
	
	 if (ret != "cancel" && ret!= "Clear") {
	        var Rtnxml = createXmlDom();
	        Rtnxml = loadXMLString(ret);

	        var NodeList = SelectNodes(Rtnxml, "LISTVIEWDATA/ROWS/ROW");

	        if (NodeList.length != 0)
	            pHasOpinionYN = "Y";
	        else {
	            pHasOpinionYN = "N";
	            ret = "cancel";
	        }
	    }
	 return ret;
}

function openFileAttachUI()
{
  try{
	var parameter	= pDocID;
	var url = "/myoffice/ezApprovalG/ezAPRATTACH/Aprattach.aspx";
	var feature	= "status:no;dialogWidth:820px;dialogHeight:350px;edge:sunken;scroll:no"; 
	var ret = window.showModalDialog(url,parameter,feature);

	if(ret != "cancel")
	{
		setAttachInfo(pDocID, "APR", lstAttachLink);
    }
	return ret;
  }catch(e){
    alert("openFileAttachUI : " + e.description);
  }
}


function SaveDraftDocInfo() {
	var rtnVal;
	
	SaveFile();
    SignSave();         

	rtnVal = SaveDraftDocInfo_susin();
	return rtnVal;
}

function SaveDraftDocInfo_susin() {
  try {
    if(pDocNumCode=="")
        return "FLASE";
        
	var objRoot;
	var objNode;
	var field;
	    
    var objNodes = GetChildNodes(xmldoc.documentElement);
		
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	var xmlRtn = createXmlDom();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DOCID", getNodeText(objNodes[0]));
    createNodeAndInsertText(xmlpara, objNode, "FORMID", getNodeText(objNodes[1]));
    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", getNodeText(objNodes[2]));
    createNodeAndInsertText(xmlpara, objNode, "DOCTYPE", getNodeText(objNodes[3]));
	createNodeAndInsertText(xmlpara, objNode, "DOCSTATE", "011");
	createNodeAndInsertText(xmlpara, objNode, "FUNCTIONTYPE", "002");
	createNodeAndInsertText(xmlpara, objNode, "HREF", getNodeText(objNodes[6]));
	createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", pDocTitle);
	createNodeAndInsertText(xmlpara, objNode, "DOCNO", pDocNo);

	if (pHasAttachYN == "") {
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", getNodeText(objNodes[9]));
	} else {
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
	}

	if (pHasOpinionYN == "") {
	    createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", getNodeText(objNodes[10]));
	} else {
	    createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);
	}

	createNodeAndInsertText(xmlpara, objNode, "STARTDATE", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "ENDDATE", "DRAFT");
	createNodeAndInsertText(xmlpara, objNode, "WRITERID", getNodeText(objNodes[13]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME", getNodeText(objNodes[14]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE", getNodeText(objNodes[15]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTID", getNodeText(objNodes[16]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME", getNodeText(objNodes[17]));
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

	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", pDocNumCode);
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", pOrgDocNumCode);
	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml", true);
	if (!g_SepAttachLVXml)
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
	else
	    createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));

	createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);
	createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);
	createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", getNodeText(objNodes[37]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", getNodeText(objNodes[38]));
	createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", getNodeText(objNodes[39]));
	createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
	createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);
	
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
		createNodeAndInsertText(xmlpara, objNode, "NONELECREC_CABINETID", cabinetID);
		
		// 시청각 기록물일경우
		if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "5" || SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "6") {
			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECINFO", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "AUDIOVISUALRECINFO"));
			createNodeAndInsertText(xmlpara, objNode, "AUDIOVISUALRECSUMMARY", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SUMMARY"));
		}
		
		// 분리첨부가 존재할 경우
		if (SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/LISTVIEWDATA/ROWS/ROW").length > 0) {
			var sepAtt, Data, i;
			var rtnXml = createXmlDom();
	        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
			var sepLVXml = createXmlDom();
            	sepLVXml = loadXMLString(nonElecRecInfoXml);
            var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/LISTVIEWDATA/ROWS/ROW");
            
            for (i = 0; i < rows.length; i++) {
                sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(rows[i].childNodes[0],"DATA1"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", SelectSingleNodeValue(rows[i].childNodes[1], "VALUE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(rows[i].childNodes[4], "VALUE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", SelectSingleNodeValue(rows[i].childNodes[0], "DATA2"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", SelectSingleNodeValue(rows[i].childNodes[6], "VALUE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", SelectSingleNodeValue(rows[i].childNodes[0], "DATA3"));
            }
            createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SEPERATEATTACH", getXmlString(rtnXml));
		}
		
		// 특수목록이 존재하는 기록물 철 일경우
		if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SPECIALCATALOGFLAG") == "1") {
			var sepAtt, Data, i;
			var rtnXml = createXmlDom();
			var root = createNodeInsert(rtnXml, root, "SPECIALCATALOGINFO");
			var sepLVXml = createXmlDom();
				sepLVXml = loadXMLString(nonElecRecInfoXml);
			var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/SCDATA");
			var rows2 = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/SCNAME");
			
			sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SCNAME");
			Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST1", SelectSingleNodeValue(rows2[0], "LIST1"));
            Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST2", SelectSingleNodeValue(rows2[0], "LIST2"));
            Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST3", SelectSingleNodeValue(rows2[0], "LIST3"));
			
			for (i = 0; i < rows.length; i++) {
				sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SCDATA");
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SN", SelectSingleNodeValue(rows[i], "SN"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST1", SelectSingleNodeValue(rows[i], "LIST1"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST2", SelectSingleNodeValue(rows[i], "LIST2"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "LIST3", SelectSingleNodeValue(rows[i], "LIST3"));
			}
			createNodeAndInsertText(xmlpara, objNode, "NONELECREC_SPECIALCATALOGINFO", getXmlString(rtnXml));
		}
	}
	
    xmlhttp.open("POST", "/ezApprovalG/doDraftHWP.do", false);
	xmlhttp.send(xmlpara);

    if (xmlhttp != null && xmlhttp.readyState == 4) {
    	 if (xmlhttp.statusText == "OK") {
    		 if (nonElecRec == "Y") {
    			 nonElecRecTempCabSwitch(nonElecRecInfoXml);
    		 }
    		  SetBtnStateFalse();
    	      var dataNodes = GetChildNodes(xmlhttp.responseXML);
    	      return getNodeText(dataNodes[0]);
    	 } else {
    		return "FALSE";
    	 }
    }
  }catch(e){
    alert("SaveDraftDocInfo_susin : " + e.description);
  }
}

var inssepattach_cross_dialogArguments = new Array();
function btnAddSepAttach_onclick() {
	if (cabinetID == "") {
		var pAlertContent = strLang731;
		OpenAlertUI(pAlertContent);          
		return;
	}

	var g_SepAttachLVXml="";	
	g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml", true);
	if (!g_SepAttachLVXml)
		g_SepAttachLVXml = "";	
	
	var para = new Array();
	para[0] = g_SepAttachLVXml;	
	para[1] = cabinetID;			
	para[2] = "1";
	para[3] = ext;
	    
	var url = "/ezApprovalG/insSepAttach.do";
	var feature = "dialogWidth:730px;dialogHeight:380px;scroll:no;resizable:yes;status:no; help:no ";
  
	if(url != "") {
		var rtn = window.showModalDialog(url,para,feature);
	}

	if (rtn[0] == "TRUE") {
		g_SepAttachLVXml = rtn[1];
		SetDocumentElement(HwpCtrl, "SepAttachLVXml", g_SepAttachLVXml)
	}
}

function GetSepAttParamXml(g_SepAttachLVXml)
{
    var rtnXml = createXmlDom();

    var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
    var sepAtt, Data, i;
    if (g_SepAttachLVXml != "") {
        var sepLVXml = createXmlDom();
        sepLVXml = loadXMLString(g_SepAttachLVXml);
        var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");
        for (i = 0; i < rows.length; i++) {

            sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
            Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "CABINETID", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA1")));
            Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "TITLE", getNodeText(rows.item(i).childNodes(1).selectSingleNode("VALUE")));
            Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "NUMOFPAGE", getNodeText(rows.item(i).childNodes(4).selectSingleNode("VALUE")));
            Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "REGTYPE", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA2")));
            Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "SUMMARY", getNodeText(rows.item(i).childNodes(6).selectSingleNode("VALUE")));
            Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "AVTYPE", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA3")));

        }
    }
    return getXmlString(rtnXml);
}

function SetSepAttParamXmlNull(g_SepAttachLVXml) {
	var sepAtt, Data, i;
	if(g_SepAttachLVXml != "") {
		var sepLVXml = createXmlDom();
		sepLVXml = loadXMLString(g_SepAttachLVXml);
		
		var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");
		for (i=0; i<rows.length; i++) {
		    setNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA1") , "");
		    setNodeText(rows.item(i).childNodes(2).selectSingleNode("VALUE") , "");
		}	
        g_SepAttachLVXml = getXmlString(sepLVXml);
	}	
	return g_SepAttachLVXml;
}

function CheckSepAttParamXmlNull(g_SepAttachLVXml) {
	var sepAtt, Data, i;
	var rtnVal = true;
	if (g_SepAttachLVXml != "") {
		var sepLVXml = createXmlDom();
		sepLVXml = loadXMLString(g_SepAttachLVXml);
		
		var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");
		for (i = 0; i< rows.length; i++) {
		    if (getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA1")) == "")
				rtnVal = false;
		}	
	}	
	return rtnVal;
}


function openSignUI()
{
  try{
  
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
			result = loadXMLString(xml);
		}        			
	});
  
    SignNodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW"); 
  
    if (SignNodeList.length != 0) { 
		var parameter	= pUserID;
		var url = "/ezApprovalG/aprSign.do";
		var feature	= "status:no;dialogWidth:350px;dialogHeight:310px;help:no;scroll:no;edge:sunken";
		var ret = window.showModalDialog(url,parameter,feature);
    } else {
      var ret = "NAME";
    }
	  return ret;
  } catch(e) {
    alert("openSignUI : " + e.description);
  }
}

function trim(parm_str)
{
  return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
  str_temp = parm_str ;
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
  str_temp = parm_str ;
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

function OpenInformationUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
    return RtnVal;
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

function setButtonReceiveTrue()
{
	SetBtnStateFalse();
}

function setHeSongDocInfo() {
	  try {
	    	var result = "";
	        var docState = "";
	        
	    	if (pAprState == strAprState15) {
	    		docState = "REACK";
	    	} else {
	    		docState = "RECEIVE";
	    	}
	    	
	        $.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/setHeSongDocInfo.do",
	    		data : {
	    			docID : pDocID,
	    			receiveSN : pSusinSN,
	    			deptID  : arr_userinfo[4],
	    			docState : docState,
	    			userID : pUserID,
	    			userName : arr_userinfo[11],
	    			userName2 : arr_userinfo[12]
	    		},
	    		success: function(xml){
	    			result = loadXMLString(xml);
	    		}, error: function() {
	    			var pAlertContent = strLang740;
	                OpenAlertUI(pAlertContent);
	                return false;
	    		}			
	    	});

	        var RtnVal = getNodeText(result.documentElement);

	        if (RtnVal == "TRUE") {
	        	   var pAlertContent = strLang741;
	               OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
	               return true;
	        }
	    }
	    catch (e) {
	        alert("setHeSongDocInfo :: " + e.description);
	        return false;
	    }
	}

function OpenAlertUI_Close_Complete() {
    btnClose_onclick();
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
		pleftpos = parseInt(width) - 725;
		heigth = parseInt(heigth) - 30;
		width = parseInt(width) - pleftpos;
		left = pleftpos / 2;
	}else{
		heigth = parseInt(heigth) - 30;
		width = parseInt(width) - 10;
	}
	
	var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left
	window.open(wfileLocation,"view",param);

  }catch(e){
	alert("openwindow :: " + e.description);
  }
}

function chk_Passwd() {
	var parameter = pUserID;
	var url = "/ezApprovalG/ezchkPasswd.do";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret = window.showModalDialog(url,parameter,feature);
	return ret;
}

function setFirstDrafter() {
    var ret = getAutoAprLine("");

    if (ret[0] != "NONE") {
    	if (approvalFlag == "S") {
    		SGetDraftAprLineInfo(ret);
    	} else {
    		GetDraftAprLineInfo(ret);
    	}
        btnSendDraft.Enable = "true";
        LastSignSN = 1;
    }

	return;
}


function openAaprDocAttachUI()
{
  try{
	var parameter = pUserID;
	var url = "/myoffice/ezApprovalG/ezAprDocAttach/aprDocAttach.aspx";
	var feature	= "status:no;dialogWidth:574px;dialogHeight:385px;edge:sunken;scroll:no";
	var ret = window.showModalDialog(url,parameter,feature);

	if(ret != "cancel")
	{
		setAttachInfo(pDocID, "APR", lstAttachLink);	
	}
	return ret;
  }catch(e){
	alert("openAaprDocAttachUI : " + e.description);
  }
}

function delDocInfo()
{
	var xmlpara = createXmlDom();
	
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);


	xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/UndoDocMust.aspx", false);
	xmlhttp.send(xmlpara);
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

var bbtnSetAprLine = "";
var bbtnSendDraft = "";
var bbtnOpinion = "";
var bbtnDistribute = "";
var bbtnReturn = "";
var bbtnEdit = "";
var bbtnRJunkyul = "";
var bbtnPrint = "";
var bbtnMail = "";

function chkBtnConfirm(para)
{
	if(para == "1")
	{
		if(btnSetAprLine.style.display == "")
		{
			setMenuBar("btnSetAprLine", false);
			bbtnSetAprLine = "1";
		}
			
		if(btnSendDraft.style.display == "")
		{
			setMenuBar("btnSendDraft", false);
			bbtnSendDraft = "1";
		}
			
		if(btnOpinion.style.display == "")
		{
			setMenuBar("btnOpinion", false);
			bbtnOpinion = "1";
		}
			
		if(btnDistribute.style.display == "")
		{
			setMenuBar("btnDistribute", false);
			bbtnDistribute = "1";
		}
			
		if(btnReturn.style.display == "")
		{
			setMenuBar("btnReturn", false);
			bbtnReturn = "1";
		}
			
		if(btnEdit.style.display == "")
		{
			setMenuBar("btnEdit", false);
			bbtnEdit = "1";
		}
			
		if(btnRJunkyul.style.display == "")
		{
			setMenuBar("btnRJunkyul", false);
			bbtnRJunkyul = "1";
		}
			
		if(btnPrint.style.display == "")
		{
			setMenuBar("btnPrint", false);
			bbtnPrint = "1";
		}
			
		if(btnMail.style.display == "")
		{
			setMenuBar("btnMail", false);
			bbtnMail = "1";
		}
	}
	else
	{
		if(bbtnSetAprLine  == "1")
			setMenuBar("btnSetAprLine", true);
			
		if(bbtnSendDraft  == "1")
			setMenuBar("btnSendDraft", true);
			
		if(bbtnOpinion  == "1")
			setMenuBar("btnOpinion", true);
			
		if(bbtnDistribute  == "1")
			setMenuBar("btnDistribute", true);
			
		if(bbtnReturn  == "1")
			setMenuBar("btnReturn", true);
			
		if(bbtnEdit  == "1")
			setMenuBar("btnEdit", true);
			
		if(bbtnRJunkyul  == "1")
			setMenuBar("btnRJunkyul", true);
			
		if(bbtnPrint  == "1")
			setMenuBar("btnPrint", true);
			
		if(bbtnMail  == "1")
			setMenuBar("btnMail", true);
			
	}
}

function setPublicFlag2() {
    if (!HwpCtrl.CheckFieldExist("publication")) return;
    var PublicType = pPublicityYN.substring(0, 1);

    var PublicText = "";
    if (PublicType == "Y")
        PublicText = "<spring:message code='ezApprovalG.t47'/>";
    else if (PublicType == "N")
        PublicText = "<spring:message code='ezApprovalG.t46'/>";
    else
        PublicText = " ";
    
    HwpCtrl.SetFieldText("publication", PublicText);
}
