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
            if (message.FieldExist(name)) {
                name = susinSN + "habyui" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, "");

                name = susinSN + "habyuisign" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */

                name = susinSN + "habyuipositon" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, "");


                name = susinSN + "habyuidate" + i;
                if (message.FieldExist(name))
                    message.PutFieldText(name, "");
            }
            else {
                break;
            }
        }

        if (message.FieldExist("refer"))
            message.PutFieldText("refer", "");


        if (message.FieldExist("hgamsa"))
            message.PutFieldText("hgamsa", "");


        for (i = 1; i < 20; i++) {
            if (message.FieldExist("gongram" + i))
                message.PutFieldText("gongram" + i, "");
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
        if (message.FieldExist("lastKyuljikwee"))
            message.PutFieldText("lastKyuljikwee", lastKyuljiwee);

        if (message.FieldExist("lastKyulName"))
            message.PutFieldText("lastKyulName", lastKyulName);

        hapyuiCnt = 1;
        SignCnt = 1;
        referCnt = 1;
        gongramCnt = 1;

        var fieldname;
        var field;
        var refer = "";




        for (i = 1; i < 20; i++) {
            fieldname = susinSN + "jikwe" + i
            if (message.FieldExist(fieldname)) {
                message.PutFieldText(fieldname, "");
                fieldname = susinSN + "sign" + i
                if (message.FieldExist(fieldname))
                    message.PutFieldText(fieldname, " "); /* 2023-04-28 양지혜 - 서명부분에 공백을 삽입하여 Paragraph 2개 생기는 문제 방지  */
            } else {
                break;
            }
        }

        var idx = 1;
        var hidx = 1;

        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) {

                fieldname = susinSN + "jikwe" + idx;
                if (message.FieldExist(fieldname)) {
                    var jikweName = trim(message.GetFieldText(fieldname));
                    if (jikweName.substring(0, 1) != "" + strLang128 + "")
                        message.PutFieldText(fieldname, OrderJobtitle[i]);

                    if (OrderSuggester[i] == "Y")
                        message.PutFieldText(fieldname, strLang75 + message.GetFieldText(fieldname));

                    if (OrderReporter[i] == "Y")
                        message.PutFieldText(fieldname, strLang76 + message.GetFieldText(fieldname));
                }
                idx = idx + 1;
            }
            else if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
                fieldname = susinSN + "habyui" + hidx;
                if (message.FieldExist(fieldname))
                    message.PutFieldText(fieldname, OrderDept[i]);

                fieldname = susinSN + "habyuipositon" + hidx;
                if (message.FieldExist(fieldname)) {
                    var jikweName = trim(message.GetFieldText(fieldname));
                    if (jikweName.substring(0, 1) != "" + strLang128 + "")
                        message.PutFieldText(fieldname, OrderJobtitle[i]);

                    if (OrderSuggester[i] == "Y")
                        message.PutFieldText(fieldname, strLang75 + message.GetFieldText(fieldname));

                    if (OrderReporter[i] == "Y")
                        message.PutFieldText(fieldname, strLang76 + message.GetFieldText(fieldname));
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
	if (message.FieldExist(fieldname))
		message.PutFieldText(fieldname, "");
		
	fieldname = "recipients";
	if (message.FieldExist(fieldname))
		message.PutFieldText(fieldname, "");

  }catch(e){
    alert("setClearSusinCellInfo : " + e.description);
  }
}

function SendDraftMappingSign(ret) {
  try {
	var psigncell;
	var pseumyungcell;
	var pseumyungdatecell;
	var signInfo = new Array();
	var signCnt;
	var sn = 1;
	
	var OpinionText = "";
	var PositionText = "";
	
	if (LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16) {
		OpinionText = getSignDate() + "\15";
	}

    if (approvalFlag == "S") {
        if (LastSignSN == 1) {
            for (i = 1; i < 20; i++) {
                if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
                else signID = "sign" + i

                if (message.FieldExist(signID)) {
                    LastSignNo = i;
                }
            }
            sn = LastSignNo;
        } else if (DraftLastFlag) {
            putJunkyulSign("sign" + sn);
            for (i = 1; i < 20; i++) {
                if (pDraftFlag == "SUSIN") signID = pSusinSN + "sign" + i
                else signID = "sign" + i

                if (message.FieldExist(signID)) {
                    LastSignNo = i;
                }
            }
            sn = LastSignNo;
        }
    }
	
	signCnt = 0;
	if (pDraftFlag == "SUSIN" || pDocState == "011") { 
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
	
	// 2023-11-24 홍승비 - 웹한글 접수기안 > 서명 이미지 삽입 시 포트번호 추가
	var portNum = document.location.port == "" ? "" : ":" + document.location.port;

	if (message.FieldExist(pseumyungcell)) {
	    message.PutFieldText(pseumyungcell, message.GetFieldText(pseumyungcell) + PositionText);
	}
	
	if (message.FieldExist(pseumyungdatecell)) {
	    message.PutFieldText(pseumyungdatecell, s);
        rtnSignInfo.push(pseumyungdatecell);
        
        /* 2023-10-06 홍승비 - 서명일자가 TBL_SIGNINFO 테이블에 저장되도록 데이터 추가 (서명일자 필드 존재 시) */
		signInfo[signCnt] = pseumyungdatecell;
		SignName[signCnt] = pseumyungdatecell;
		SignType[signCnt] = "TEXT";
		SignContent[signCnt] = s;
		signCnt = signCnt + 1;
    }
    
	if (CurAprType == strAprType16) {
		if (message.FieldExist(psigncell)) {
			// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
			if (message.FieldExist(pseumyungdatecell)) {
			    OpinionText = "\15";
			}
			
			/* 2023-11-24 홍승비 - 웹한글문서 접수기안 시 이미지 맵핑 관련 함수 호출 일부 변경 */
			if (ret != "NAME") {
				message.PutFieldText(psigncell, "");	
				//message.SetFieldImage(psigncell, document.location.protocol + "//" + document.location.hostname +  ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(ret), null);
				message.PrependFieldText(psigncell, strLang7 + OpinionText);
				message.InsertPicture(psigncell, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(ret), null);
			  	
			  	signInfo[signCnt] = psigncell;
				SignType[signCnt] = "IMAGE";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = ret + "::" + strLang7 + OpinionText;
                rtnSignInfo.push(psigncell);
                
                // 연동정보 저장 함수로, 웹한글문서 접수기안 시 이미지 서명 사용 중에 오류를 발생시킨다. 추후 확인 예정
			  	SetDocumentElement(psigncell, ret);
			  	signCnt = signCnt + 1
			  	SingFlag = true;
			}
			else {
				message.PutFieldText(psigncell, arr_userinfo[2]);	
				message.PrependFieldText(psigncell, strLang7 + OpinionText, true);
		  		
		  		signInfo[signCnt] = psigncell;
				SignType[signCnt] = "TEXT";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = strLang7 + OpinionText + arr_userinfo[2];
                rtnSignInfo.push(psigncell);
				
		  		signCnt = signCnt + 1
		  		SingFlag = false; 
		  	}
		}	
		DekyulFlag = true;
		sn = sn + 1;
		
		if (pDraftFlag == "SUSIN" ||  pDocState == "011") { 
		  	psigncell = pSusinSN + "sign" + sn;
		  	pseumyungcell = pSusinSN + "jikwe" + sn;
		  	pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
		} else {
		  	psigncell = "sign" + sn;
		  	pseumyungcell = "jikwe" + sn;
		  	pseumyungdatecell = "seumyungdate" + sn;
		}
	}
	
	if (DekyulFlag && NextAprType == strAprType4) {
		if (message.FieldExist(psigncell)) {
			message.PutFieldText(psigncell, strLang6);	
			
			signInfo[signCnt] = psigncell;
			SignType[signCnt] = "TEXT";
			SignName[signCnt] = psigncell;
			SignContent[signCnt] = strLang6;
            rtnSignInfo.push(psigncell);
			
			signCnt = signCnt + 1
			SingFlag = false; 
		}
	}
	else if (DekyulFlag) {
	}
	else {
		if (message.FieldExist(psigncell)) {
			// 서명일자칸이 존재하는 경우, 서명칸에는 날짜를 표출하지 않음
			if (message.FieldExist(pseumyungdatecell)) {
			    OpinionText = "\15";
			}
			
			if (ret != "NAME") {
				message.PutFieldText(psigncell, "");
				
				if (CurAprType == strAprType4) {
                    OpinionText = strLangAprType4 + OpinionText;
				}
				
				// OpinionText에 대결/전결/서명일자 표기 없이 개행문자만 존재하는 경우, 공백으로 치환
				if (OpinionText == "\15") {
					OpinionText = "";
				}
				
				message.PrependFieldText(psigncell, OpinionText);
                message.InsertPicture(psigncell, document.location.protocol + "//" + document.location.hostname + portNum + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(ret), null);
                
			  	signInfo[signCnt] = psigncell;
				SignType[signCnt] = "IMAGE";
				SignName[signCnt] = psigncell;
				SignContent[signCnt] = ret + "::" + OpinionText;
                rtnSignInfo.push(psigncell);
				
                // 연동정보 저장 함수로, 웹한글문서 접수기안 시 이미지 서명 사용 중에 오류를 발생시킨다. 추후 확인 예정
			  	SetDocumentElement(psigncell, ret);
			  	signCnt = signCnt + 1
			  	SingFlag = true;
			}
			else {
				if (CurAprType == strAprType4) {
			    	OpinionText = strLangAprType4 + OpinionText;
			    }
			    
			    // OpinionText에 대결/전결/서명일자 표기 없이 개행문자만 존재하는 경우, 공백으로 치환
				if (OpinionText == "\15") {
					OpinionText = "";
				}
				
				message.PutFieldText(psigncell, arr_userinfo[2]);	
			    message.PrependFieldText(psigncell, OpinionText);
			  	
			  	signInfo[signCnt] = psigncell;
		        SignType[signCnt] = "TEXT";
		        SignName[signCnt] = psigncell;
		        SignContent[signCnt] = OpinionText + arr_userinfo[2];
                rtnSignInfo.push(psigncell);
		        
			  	signCnt = signCnt + 1
			  	SingFlag = false; 
			}
		}
	}	
    return signInfo;
  } catch(e) {
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
 
	var Fields = message.GetFieldList();
	
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
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(7)));
	  		  		break;
	  			case "address" :			    
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(6)));
	  		  		break;												
	  			case "telephone" :		  	
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(5)));
	  		  		break;												
	  			case "fax" :			      	
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(5)));
	  		  		break;												
	  			case "department" :		  	
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(2)));
	  		  		break;												
	  			case "parantdept" :       
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(3)));
	  		  		break;
	  			case "seniorposition" :		
	  		  		break;												
	  			case "seniorname" :			  
	  		  		break;												
	  			case "charge" :				    
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(0)));
	  		  		break;
	  			case "position" :			    
	  				message.PutFieldText(Fields[i], arr_userinfo[3]);
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
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(3)));
	  		  		break;							
	  			case "deptname" :         
	  				message.PutFieldText(Fields[i], arr_userinfo[5]);
	  		  		break;
	  			case "seal" :             
	  				message.PutFieldText(Fields[i], getNodeText(objNodes.item(3)) + "대표이사");
	  		  		break;
	  			case "username" :         
	  				message.PutFieldText(Fields[i], arr_userinfo[2]);
	  		  		break;
	  			case "draftername" :      
	  				message.PutFieldText(Fields[i], arr_userinfo[2]);
	  		  		break;
	  			case "draftdate" :        
	  				message.PutFieldText(Fields[i], CurrentDate);
	  		  		break;
	  			case "receiptdate" :
	  				message.PutFieldText(Fields[i], CurrentDate);
	  		  		break;
 			}
	  	}
	  	else
	  	{
	  	    switch (Fields[i])
	  	    {
  	  		    case "receiptdate" :
  	  				message.PutFieldText(Fields[i], CurrentDate);
					break;
	  	     	case pSusinSN + "receiptdate" :	 
	  	     		message.PutFieldText(Fields[i], CurrentDate);
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
					SignInfo = message.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}else{
					SignInfo = message.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    }
	    else
	    {
			if(Fields[i].substr(0,5) == "jikwe")
			{
				if(SignInfoFlag)
				{
					SignInfo = message.GetFieldText(Fields[i]);
					SignInfoFlag = false;
				}
				else
				{
					SignInfo = message.GetFieldText(Fields[i]) + ";" + SignInfo ;
				}
			}
	    }
	}
	pSuSinFlag = "N";

	
	if(pDraftFlag != "SUSIN" && pDocState != "011" )
	{
		var RtnVal = message.FieldExist("recipient");
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
	if(message.FieldExist(fieldname)) {
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
	isExtDoc = GetDocumentElement("EXTDOC", false);
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
        var row = rows(i);
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
            precipent = approvalFlag == "G" ? strLang92 : strLangS68;

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
	
	 if (ret != "cancel" && ret!= "Clear" && ret != undefined) {
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

/*function openOpinionUI_New(pOpinionType) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = pDraftFlag;	//DRAFTFLAG 
		parameter[3] = pDocState;	//DOCSTATE
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
	    }
		
	    return ret;
	} catch (e) {
		alert("openOpinionUI_New ::: " + e.description);
	}
}*/

/*function openFileAttachUI()
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
}*/


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
	if (approvalFlag == 'G') {
        createNodeAndInsertText(xmlpara, objNode, "DOCNO", pDocNo);
    } else {
        createNodeAndInsertText(xmlpara, objNode, "DOCNO",  message.GetFieldText("docnumber"));
    }

	if (pHasAttachYN == "") {
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", getNodeText(objNodes[9]));
	} else {
	    createNodeAndInsertText(xmlpara, objNode, "HASATTACHYN", pHasAttachYN);
	}
	
	//2018-08-30 배현상, 재기안 시 의견이 없는 경우 의견이 있다고 알럿창이 나오는 버그 수정
    createNodeAndInsertText(xmlpara, objNode, "HASOPINIONYN", pHasOpinionYN);

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
	createNodeAndInsertText(xmlpara, objNode, "PUBLICITYYN", tempPublic);
	createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
	createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
	createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
	createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);

	createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", pDocNumCode);
	createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", pOrgDocNumCode);
	var g_SepAttachLVXml = "";
	g_SepAttachLVXml = GetDocumentElement("sepattachlvxml", true);
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
		if (SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW").length > 0) {
			var sepAtt, Data, i;
			var rtnXml = createXmlDom();
	        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
			var sepLVXml = createXmlDom();
            	sepLVXml = loadXMLString(nonElecRecInfoXml);
            var rows = SelectNodes(sepLVXml, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW");
            
            for (i = 0; i < rows.length; i++) {
                sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "CABINETID"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", SelectSingleNodeValue(rows[i], "SEPTITLE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(rows[i], "SEPNUMOFPAGE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", SelectSingleNodeValue(rows[i], "SEPREGTYPE"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", SelectSingleNodeValue(rows[i], "SEPSUMMARY"));
                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", SelectSingleNodeValue(rows[i], "SEPRECORDTYPE"));
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
    	 if (xmlhttp.status == 200) {
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
	var deptCheckFlag = checkDeptAndCabinetId();
	
	if (deptCheckFlag == "3") {
		alert("접수창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n겸직부서를'" + arr_userinfo[5] + "'부서로 변경하시거나 접수창을 새로 띄워주시기바랍니다." );
		return;
	} else if (deptCheckFlag == "4") {
		alert("접수창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n사용자의 부서가 변경되거나 겸직이 삭제되었으니 접수창을 새로 띄워주시기바랍니다.");
		return;
	} else if (deptCheckFlag == "2" && upperDeptCode == "") {
		alert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
		return;
	}
	
	if (cabinetID == "") {
		var pAlertContent = strLang731;
		OpenAlertUI(pAlertContent);          
		return;
	}

	var g_SepAttachLVXml="";	
	g_SepAttachLVXml = GetDocumentElement("sepattachlvxml", true);
	if (!g_SepAttachLVXml)
		g_SepAttachLVXml = "";	
	
	var para = new Array();
	para[0] = g_SepAttachLVXml;	
	para[1] = cabinetID;			
	para[2] = "1";
	para[3] = ext;
	    
	var url = "/ezApprovalG/insSepAttach.do";
	//var feature = "dialogWidth:920px;dialogHeight:630px;scroll:no;resizable:yes;status:no; help:no ";
	inssepattach_cross_dialogArguments[0] = para;
	inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;
	
	DivPopUpShow(920, 630, url);
	/*if(url != "") {
		var rtn = window.showModalDialog(url,para,feature);
	}

	if (rtn[0] == "TRUE") {
		g_SepAttachLVXml = rtn[1];
		SetDocumentElement(HwpCtrl, "SepAttachLVXml", g_SepAttachLVXml)
	}*/
}

function btnAddSepAttach_onclick_Complete(rtn) {
	DivPopUpHidden();
	if (rtn[0] == "TRUE") {
		g_SepAttachLVXml = rtn[1];
		SetDocumentElement("sepattachlvxml", SetSepAttParamXmlNull(g_SepAttachLVXml));
	}
}

//2019-01-18 천성준 - 새 HWP 분리첨부 XML파싱 소스 생성
function GetSepAttParamXml(g_SepAttachLVXml) {
	try {
		var sepAtt, Data;
		var rtnXml = createXmlDom();
		var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
		
		if (g_SepAttachLVXml != "") {
			var sepLVXml = createXmlDom();
				sepLVXml = loadXMLString(g_SepAttachLVXml);
				
			var pRows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");
			if (pRows) {
				for (var i = 0; i < pRows.length; i++) {
					sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID",	getNodeText(pRows.item(i).childNodes(0).selectSingleNode("DATA1")));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", 	getNodeText(pRows.item(i).childNodes(1).selectSingleNode("VALUE")));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE",	getNodeText(pRows.item(i).childNodes(4).selectSingleNode("VALUE")));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", 	getNodeText(pRows.item(i).childNodes(0).selectSingleNode("DATA2")));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY",	getNodeText(pRows.item(i).childNodes(6).selectSingleNode("VALUE")));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE",	getNodeText(pRows.item(i).childNodes(0).selectSingleNode("DATA3")));
				}
			} else {
				var oRows = sepLVXml.getElementsByTagName("ROW");
				for (var i = 0; i < oRows.length; i++) {
					sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA1"));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[1], "VALUE"));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(GetChildNodes(oRows[i])[4], "VALUE"));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA2"));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[6], "VALUE"));
					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA3"));
				}
			}
		}
		
		return getXmlString(rtnXml);
	} catch (e) {
		alert("ezrecevG_susinui_hwp.GetSepAttParamXml() : " + e.description);
	}
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


/* function openSignUI()
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
} */

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

/*function OpenInformationUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
    return RtnVal;
}*/

/*var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}*/

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

/*function chk_Passwd() {
	var parameter = pUserID;
	var url = "/ezApprovalG/ezchkPasswd.do";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
	var ret = window.showModalDialog(url,parameter,feature);
	return ret;
}*/

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


/*function openAaprDocAttachUI()
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
}*/

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

		var btnReturn = document.getElementById("btnReturn");
		if(btnReturn && btnReturn.style.display == "")
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

// 대민공개여부로 publication 필드 설정, 일반버전용이 아님
function setPublicFlag2() {
//    if (!message.FieldExist("publication")) return;
//    var PublicType = pPublicityYN.substring(0, 1);
//
//    var PublicText = "";
//    if (PublicType == "Y")
//        PublicText = strLang82;
//    else if (PublicType == "N")
//        PublicText = strLang84;
//    else
//        PublicText = " ";
//    
//    message.PutFieldText("publication", PublicText);
	if (!message.FieldExist("publication"))
		return;
					
	var PublicType = pPublicityCode.substring(0,1);
	var PublicLevel = pPublicityCode.substring(1,9);
	var PublicText = "";

	if (pLimitRange != "")
		PublicText = " (" + pLimitRange + ")";
	
	if (PublicType == "1")
		PublicText = strLang82;
	else if (PublicType == "2")
		PublicText = strLang83 + getPublicLevel(PublicLevel);
	else if (PublicType == "3")
		PublicText = strLang84 + getPublicLevel(PublicLevel);
	else
		PublicText = " ";

	message.PutFieldText("publication", PublicText);
}

function getPublicLevel(PublicLevel) {
    var strRtn = "";
    var firstFlag = true;
    for (i = 0; i < 8; i++) {
        if (PublicLevel.substring(i, i + 1) == "Y") {
            if (firstFlag) {
                strRtn = "(" + (i + 1);
                firstFlag = false;
            }
            else {
                strRtn = strRtn + "," + (i + 1);
            }
        }
    }
    if (!firstFlag)
        strRtn = strRtn + ")";
    return strRtn;
}

// 접수관련된 버튼의 보임여부 처리
function setBtnEnable() {
	var result = "";
	var tempFlag = false;
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getADInfos.do",
		data : {
			cn : arr_userinfo[4],
			prop : "extensionAttribute4"
		},
		success: function(xml){
			result = loadXMLString(xml);
			if (getNodeText(GetChildNodes(result.documentElement)[0]) != "") {
				tempFlag = true;
			}
		}        			
	});

	var btnReturn = document.getElementById("btnReturn"); //회송
	if (btnReturn) {
		btnReturn.style.display = "none";
	}
	btnAssign.style.display = "none";   	//지정
	btnDistribute.style.display = "none";   //배부
	btnReDistribute.style.display = "none"; //재배부요청
	btnReqReSend.style.display = "none";    //재전송요청

	if (pDocType === "001") { // 시행문(G)
		if (tempFlag) { //문서과
			btnAssign.style.display = "";
			btnDistribute.style.display = "";
			btnReqReSend.style.display = isRelay ? "" : "none";
			if (pAprState === "014") {
				btnReqReSend.style.display = "none";
				btnReDistribute.style.display = "";
			}
		} else { //일반부서
			if (pAprState === "012") {
				btnAssign.style.display = "";
				if (pSusinAdmin === "YES") {
					btnReDistribute.style.display = "";
				}
			} else if (pAprState === "014") {
				btnAssign.style.display = "";
				btnReDistribute.style.display = "";
			}
		}
	} else if (pDocType === "003") {
		var btnReturn = document.getElementById("btnReturn");
		if (pAprState === "011") {
			if (btnReturn) {
				btnReturn.style.display = "";
			}
			btnAssign.style.display = "";
			btnDistribute.style.display = "";
		} else if (pAprState === "012") {
			btnAssign.style.display = "";
			/* 2024-12-06 홍승비 - 수신문 접수 > 지정받은 문서는 수발신담당자 권한에 상관없이 회송/배부가 가능하도록 수정 (MHT와 동일 스펙, 비전자문서도 수신문이므로 포함) */
			//if (pSusinAdmin === "YES") {
			if (btnReturn) {
				btnReturn.style.display = "";
			}			btnDistribute.style.display = "";
			//}
		} else if (pAprState === "014") {
			if (btnReturn) {
				btnReturn.style.display = "";
			}			
			btnAssign.style.display = "";
			btnDistribute.style.display = "";
		} else if (pAprState === "013") {
			if (btnReturn) {
				btnReturn.style.display = "";
			}			
			btnAssign.style.display = "";
			btnDistribute.style.display = "";
		}
	}
}

function openOpinionUI_Distribute_Complete(ret) {
    if (ret != "cancel") {
        var NodeList;
        var objXML = loadXMLString(ret);
        NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

        if (NodeList.length != 0) {
            pHasOpinionYN = "Y";

            btnReDistribute_onclick_complete();
        } else {
            pHasOpinionYN = "N";
            ret = "cancel";
        }
    }
}