var pRelayDocInfo = new ActiveXObject("Microsoft.XMLDOM");
var decodePass = "";
var decodePath = "";
var pRelayURL = "";
var pRelayURL2 = "";
var needDoubleFormFlag = false;
var pPublicFlag = "";

function GetRelayDocInfo()
{
	try
	{
    	var result ="";
      	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getRelayDocInfo.do",
    		data : {
    			docID : pDocID,
    			companyID : sCompanyID
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});

      	pRelayDocInfo = loadXMLString(result);
        if (pRelayDocInfo.documentElement.childNodes.length < 1)
            return false;
        else
            return true;
	}
	catch(e)
	{
		alert("GetRelayDocInfo : " + e.description);
		return false;
	}
}

function getPasswdEnd() { 
    var url	= "/ezApprovalG/cert.do";
	var feature = "status:no;dialogWidth:420px;dialogHeight:350px;help:no;scroll:no"
	var param = true;
	var ret = window.showModalDialog(url,param,feature);
		
	if(ret[0])
	{
		encodePass = ret[1];
		encodePath = ret[2];	
	}		
	return ret[0];
}

function decodeUp(emlName)
{
	var BaseDN;
	var result = true; 

	
	var xmlContent = new ActiveXObject("Microsoft.XMLDOM");
	xmlContent.async = false;	
	xmlContent.load("/Upload_ApprovalG/" + sCompanyID + "/ExDocMSG/" + emlName);
	var ContentsView = xmlContent.selectSingleNode("pack/contents");
	var ContentText = getNodeText(ContentsView);
	
	var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	objSave.Base64ToLocalFile(ContentText, "c:\\smime.p7m");
	
	arrDelFiles[arrDelFiles.length] = "c:\\smime.p7m";
	
	var ReceivedDate = getNodeText(pRelayDocInfo.getElementsByTagName("ReceivedDate").item(0));
	var xDeptID = getNodeText(pRelayDocInfo.getElementsByTagName("xToCode").item(0));
	
	
	if (GetAttribute(ContentsView.childNodes(0),"content-type") == "application/gcc-mime;smime-type=signedandenveloped-data;")
	{
		if(ObjGPKI.Decode(decodePath, xDeptID, "c:\\smime.p7m", decodePass, ReceivedDate)) 
		{
			ObjGPKI.WriteResultFile("C:\\" + pDocID + ".xml");  
			
			
			var ContentsView = xmlContent.selectSingleNode("pack/contents");
			ContentsView.parentNode.removeChild(ContentsView);
			
			var XMLText = xmlContent.xml;
			XMLText = XMLText.replace("</pack>", "<contents>" + ObjGPKI.Content + "</contents></pack>");
			
			objSave.SaveTextToFile("C:\\" + pDocID + ".xml", XMLText);
			
			arrDelFiles[arrDelFiles.length] = "C:\\" + pDocID + ".xml";
			
  			result = UploadDec(XMLText);
  			if (result)
  				result = UpdateAttachURL();	
		}
		else
		{
			var message = ObjGPKI.ErrorMsg;		
			var tempmessage = message.replace("req-resend|", "")
			if (tempmessage == message)
			{
				var pAlertContent = strLang722 + message.replace("\n", "<br>");			
				OpenAlertUI(pAlertContent);
			}
			else
			{
				var pAlertContent = strLang722 + tempmessage.replace("\n", "<br>") + "<br>" + strLang723;
				OpenAlertUI(pAlertContent);
				SendAckForSend(tempmessage, "req-resend");
				RemoveDocInfo();				
			}			
			result = false;
		}	
	}
	else if (GetAttribute(ContentsView.childNodes(0),"content-type") == "application/gcc-mime;smime-type=signed-data;")
	{
		if(ObjGPKI.DecodeBySign(decodePath, xDeptID, "c:\\smime.p7m", decodePass, ReceivedDate)) 
		{   
			ObjGPKI.WriteResultFile("C:\\" + pDocID + ".xml");  
			
			
			var ContentsView = xmlContent.selectSingleNode("pack/contents");
			ContentsView.parentNode.removeChild(ContentsView);
			
			var XMLText = xmlContent.childNodes(2).xml;
			XMLText = XMLText.replace("</pack>", "<contents>" + ObjGPKI.Content + "</contents></pack>");
			
			objSave.SaveTextToFile("C:\\" + pDocID + ".xml", XMLText);
			
			arrDelFiles[arrDelFiles.length] = "C:\\" + pDocID + ".xml";
			
  			result = UploadDec(XMLText);
  			if (result)
  				result = UpdateAttachURL();	
		}
		else
		{		
			var message = ObjGPKI.ErrorMsg;		
			var tempmessage = message.replace("req-resend|", "")
			if (tempmessage == message)
			{
				var pAlertContent = strLang722 + message.replace("\n", "<br>");			
				OpenAlertUI(pAlertContent);
			}
			else
			{
				var pAlertContent = strLang722 + tempmessage.replace("\n", "<br>") + "<br>" + strLang723;
				OpenAlertUI(pAlertContent);
				SendAckForSend(tempmessage, "req-resend");
				RemoveDocInfo();				
			}			
			result = false;
		}	
	}
	else if (GetAttribute(ContentsView.childNodes(0),"content-type") == "text/xml")
	{
  		
  		result = UploadDec(xmlContent.xml);
  		if (result)
  			result = UpdateAttachURL();	
	}
	else
	{
	    var pAlertContent = "GPKI " + strLang724 + "<br>" + GetAttribute(ContentsView.childNodes(0),"content-type");
		OpenAlertUI(pAlertContent);
		result = false;
	}
	
	objSave = null;
	
	return result;
}

function UploadDec(XMLText) 
{	
	
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
	var xmlpara2 = new ActiveXObject("Microsoft.XMLDOM");
	xmlpara.loadXML(XMLText);
	xmlpara2.loadXML(xmlpara.documentElement.xml);
	
	xmlhttp.open("POST","/myoffice/ezApprovalG/ReceivUI/aspx/uploadDec.aspx",false);
	xmlhttp.send(xmlpara2);	
	
	if (xmlhttp.responseText == "OK")
		return true;
	else
		return false;
}

function UpdateAttachURL()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
	var xmlre = new ActiveXObject("Microsoft.XMLDOM");
	
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "xDocID", getNodeText(pRelayDocInfo.getElementsByTagName("xDocID").item(0)));
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	
	xmlhttp.open("POST","/myoffice/ezApprovalG/ReceivUI/aspx/updateAttachURL.aspx",false);
	xmlhttp.send(xmlpara);
	
	xmlre = loadXMLString(xmlhttp.responseText);
	
	if( xmlre.xml == "" )
	{
		return false;
	}
	else
	{
	    if( getNodeText(xmlre.documentElement.childNodes(0)) == "TRUE" )
			return true;
		else
			return false;
	}
}

function SendAckForSend(errMsg, type)
{
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/sendAckforReSend.do",
		data : {
				docID : pDocID,
				type  : type,
				userName : arr_userinfo[11],
				userDeptName : arr_userinfo[15],
				errMsg : errMsg
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    if (type == "req-resend") {
    	if (result == "<RESLUT>TRUE</RESULT>") {
	        var pAlertContent = strLang725;
	        OpenAlertUI(pAlertContent, function() {
	        	window.close();
	        });
    	} else {
    		OpenAlertUI("재전송요청에 실패하였습니다.");
    	}
    }
}

function RemoveDocInfo()
{
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
    var xmlhttp = createXMLHttpRequest();


	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
	createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp.open ("Post","/myoffice/ezApprovalG/aspx/UndoDocMust.aspx",false);
    xmlhttp.send(xmlpara);
}

function getExtInfo()
{
    var xmlURL = getNodeText(pRelayDocInfo.getElementsByTagName("xmlURL").item(0));
    var sealURL = getNodeText(pRelayDocInfo.getElementsByTagName("sealURL").item(0));
	
	if( xmlURL == "" )
	{
		var pAlertContent = "XML" + strLang167;
		OpenAlertUI(pAlertContent);
		chkBtnConfirm("1");
		return false;
	}
	
	xmlURL = sCompanyID + "/ExDocXML/" + xmlURL;
    
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/loadDocXML.do",
		data : {
			XMLPATH : xmlURL
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    xmlDoc.async = "false";
    xmlDoc.loadXML(result);
    
    sihangXML = xmlDoc;
	
	if (sihangXML.xml == "") {
	    alert(strLang726 + xmlURL);
	    return false;
	}

	var eNodes = sihangXML.documentElement;
	var bodyTagUse = true;
    // 에러로그 여부
    try {
        var Nodes = eNodes.selectNodes("body");
        if (Nodes.length > 0) {
            bodyTagUse = true;
        }
        else {
            bodyTagUse = false;
        }
        Nodes = eNodes.selectNodes("ERRORMESSAGE");

        if (Nodes.length > 0) {
            if (bodyTagUse) {
                OpenAlertUI("오류내용:" + getNodeText(Nodes[0]) + "<br>" + " > 문서를 불러올수 있으나 정상표시되는지 확인하세요.");
            }
            else {
                OpenAlertUI("오류내용:" + getNodeText(Nodes[0]) + "<br>" + " > 문서를 불러올수 없습니다.");
                return false;
            }
        }
    } catch (e) {
    	alert("getExtInfo error");
    }

	var Nodes = eNodes.selectNodes("head/organ");		
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("organ") )
		{	
		    HwpCtrl.SetFieldText("organ", getNodeText(Nodes(0)));
		}
	}
	
	var Nodes = eNodes.selectNodes("head/receiptinfo/recipient");
	if( Nodes.length > 0 )
	{
	    if( GetAttribute(Nodes(0),"refer") == "true" )	
		{
			if( HwpCtrl.CheckFieldExist("recipient") )
				HwpCtrl.SetFieldText("recipient", strLang728);
			
			if( HwpCtrl.CheckFieldExist("recipientheader") )
				HwpCtrl.SetFieldText("recipientheader", strLang129);
			
			if( HwpCtrl.CheckFieldExist("recipients") )
			    HwpCtrl.SetFieldText("recipients", getNodeText(Nodes(0)));
		}
		else
		{
			if( HwpCtrl.CheckFieldExist("recipient") )
			    HwpCtrl.SetFieldText("recipient", getNodeText(Nodes(0)));
			
			if( HwpCtrl.CheckFieldExist("recipientheader") )
				HwpCtrl.SetFieldText("recipientheader", " ");
			
			if( HwpCtrl.CheckFieldExist("recipients") )
				HwpCtrl.SetFieldText("recipients", " ");
		}
	}
	
	var Nodes = eNodes.selectNodes("head/receiptinfo/via");		 
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("refer") )
		{
		    HwpCtrl.SetFieldText("refer", getNodeText(Nodes(0)));
		}
	}
	
	var Nodes = eNodes.selectNodes("body/title");				
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("doctitle") )
		{
		    HwpCtrl.SetFieldText("doctitle", getNodeText(Nodes(0)));
		}
		if( HwpCtrl.CheckFieldExist("doctitle2") )
		{
		    HwpCtrl.SetFieldText("doctitle2", getNodeText(Nodes(0)));
		}
	}
	
	var Nodes = eNodes.selectNodes("body");
	if( Nodes.length > 0 )
	{
	    if( GetAttribute(Nodes(0),"separate") == "false" )
		{
			var tempNodes = eNodes.selectNodes("body/content");
			if( tempNodes.length > 0 )
			{
				if( HwpCtrl.CheckFieldExist("body") )
				{
					var bodySTR = "";
					for( var i = 0 ; i < tempNodes(0).childNodes.length ; i++ )
					{
						if( i == 0 )
						    bodySTR = getNodeText(tempNodes(0).childNodes(i));
						else
						    bodySTR = bodySTR + getNodeText(tempNodes(0).childNodes(i));
					}
					
					if( bodySTR.indexOf("<![CDATA[") > -1 )
					{
						bodySTR = bodySTR.replace("<![CDATA[", "");
						bodySTR = bodySTR.replace("]]>", "");
					}
					HwpCtrl.SetCloneData(Decode(bodySTR), "body", "HTML");
				}
			}
		}
		else
		{
			if( !needDoubleFormFlag )
			{
				HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
				needDoubleFormFlag = true;
				var URL = document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pRelayURL2);
	  			var isTrue = HwpCtrl.LoadFile(URL, true);
	  			FieldsAvailable(isTrue);
	  			return false;
			}
			
			var tempNodes = eNodes.selectNodes("body/content");
			if( tempNodes.length > 0 )
			{
				if( HwpCtrl.CheckFieldExist("body") )
				{
					var bodySTR = "";
					for( var i = 0 ; i < tempNodes(0).childNodes.length ; i++ )
					{
						if( i == 0 )
							bodySTR = getNodeText(tempNodes(0).childNodes(i));
						else
						    bodySTR = bodySTR + getNodeText(tempNodes(0).childNodes(i));
					}
					
					if( bodySTR.indexOf("<![CDATA[") > -1 )
					{
						bodySTR = bodySTR.replace("<![CDATA[", "");
						bodySTR = bodySTR.replace("]]>", "");
					}
					HwpCtrl.SetCloneData(Decode(bodySTR), "body", "HTML");
				}
			}
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendername");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("chief") )
		{
		    HwpCtrl.SetFieldText("chief", getNodeText(Nodes(0)));
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/seal");
	if( Nodes.length > 0 )
	{
	    var pomit = GetAttribute(Nodes(0),"omit")
		if( pomit == "false" )
		{
			sealPath = dirPath + sCompanyID + "/ExDocSign/" + sealURL;
			if( HwpCtrl.CheckFieldExist("sealsign") )
			{
				HwpCtrl.SetFieldText("sealsign", "");
				HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(sealPath));
			}
		}
		
		if( pomit == "true" )
		{
			if( HwpCtrl.CheckFieldExist("sealsign") )
			{
				HwpCtrl.SetFieldText("sealsign", "");
				//관인없을 경우, 경로가 닷넷 경로 그대로 사용하던 오류 수정. 2019-11-22 홍대표.
				HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape("/files/sealImg/nostamp.gif"), 12);
			}
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/approvalinfo/approval");
	var ApprovalAnyFlag = 0;
	if( Nodes.length > 0 )
	{
		var lastSignSN = Nodes.length;
		for( var i = 0 ; i < Nodes.length ; i++ )
		{
		    var SignOrder = GetAttribute(Nodes(i),"order");
			var SignText = "";
			if( SignOrder == "final" )
				SignOrder = lastSignSN;
			
			SignText = "";
			
			var tempNode = Nodes(i).selectSingleNode("signposition");
			if( tempNode )
			{
				if( HwpCtrl.CheckFieldExist("jikwe" + SignOrder) )
				{
				    HwpCtrl.SetFieldText("jikwe" + SignOrder, getNodeText(tempNode) + SignText);
				}
			}
			var SignInputFlag = false;
			SignText = "";
			
			var tempNode = Nodes(i).selectSingleNode("type");
			if( tempNode )
			{
			    if( getNodeText(tempNode) == strLang6)
				{
					SignText = SignText + strLang6;
					ApprovalAnyFlag = ApprovalAnyFlag + 1;
				}
			    else if( getNodeText(tempNode) == strLang7)
				{
					SignText = SignText + strLang7;
					ApprovalAnyFlag = 1;
				}
				else
				{
					ApprovalAnyFlag = 0;
				}
			}
			
			if( GetAttribute(Nodes(i),"order") == "final" || ApprovalAnyFlag == 1 )
			{
				var tempNode = Nodes(i).selectSingleNode("date");
				if( tempNode )
				    SignText = SignText + convertDate(getNodeText(tempNode)) + "\15";
			}
						
			var tempNode = Nodes(i).selectSingleNode("name");
			if( tempNode )
			{
				if( HwpCtrl.CheckFieldExist("sign" + SignOrder) )
				{
					if( ApprovalAnyFlag > 1 )
					{
						HwpCtrl.SetFieldText("sign" + SignOrder, SignText);
					}
					else
					{
					    HwpCtrl.SetFieldText("sign" + SignOrder, getNodeText(tempNode));
						HwpCtrl.AppendFieldText("sign" + SignOrder, SignText, true);
					}
				}
				SignInputFlag = true;
			}

			var tempNode = Nodes(i).selectSingleNode("signimage");
			if (tempNode)
			{
			    signPath =  dirPath + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(tempNode.selectSingleNode("img"),"src"));
				if( HwpCtrl.CheckFieldExist("sign" + SignOrder) )
				{
					HwpCtrl.SetFieldText("sign" + SignOrder, "");
					HwpCtrl.SetFieldImage("sign" + SignOrder, document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(signPath), 3, 0, 0, true, 2);
					HwpCtrl.AppendFieldText("sign" + SignOrder, SignText, true);
				}
				SignInputFlag = true;
			}
			
			if (!SignInputFlag)
			{
				if(HwpCtrl.CheckFieldExist("sign" + SignOrder))
				{
					HwpCtrl.SetFieldText("sign" + SignOrder, SignText);
				}
			}
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/approvalinfo/assist");
	if( Nodes.length > 0 )
	{
		var lastSignSN = Nodes.length;
		for( var i = 0 ; i < Nodes.length ; i++ )
		{
		    var SignOrder = GetAttribute(Nodes(i),"order");
			var SignText = "";
			if( SignOrder == "final" )
				SignOrder = lastSignSN;
			
			var tempNode = Nodes(i).selectSingleNode("signposition");
			if( tempNode )
			{
				if( HwpCtrl.CheckFieldExist("habyuipositon" + SignOrder) )
				{
				    HwpCtrl.SetFieldText("habyuipositon" + SignOrder, getNodeText(tempNode) + SignText);
				}
			}
			
			var tempNode = Nodes(i).selectSingleNode("name");
			if( tempNode )
			{
				if( HwpCtrl.CheckFieldExist("habyuisign" + SignOrder) )
				{
				    HwpCtrl.SetFieldText("habyuisign" + SignOrder, getNodeText(tempNode));
				}
			}

			var tempNode = Nodes(i).selectSingleNode("signimage");
			if( tempNode )
			{
			    signPath =  dirPath + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(tempNode.selectSingleNode("img"),"src"));
				if( HwpCtrl.CheckFieldExist("habyuisign" + SignOrder) )
				{					
					HwpCtrl.SetFieldText("habyuisign" + SignOrder, "");
					HwpCtrl.SetFieldImage("habyuisign" + SignOrder, document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(signPath), 3, 0, 0, true, 2);
					HwpCtrl.AppendFieldText("habyuisign" + SignOrder, SignText, true);
				}
			}
		}
		
	}
	var Nodes = eNodes.selectNodes("foot/processinfo/regnumber");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("docnumber") )
		{
		    HwpCtrl.SetFieldText("docnumber", getNodeText(Nodes(0)));
		}
		
		var regnumbercode = GetAttribute(Nodes(0),"regnumbercode");
		if( regnumbercode.length > 0 )
		{
			SetDocumentElement(HwpCtrl, "deptid", regnumbercode.substring(0, 7));
			SetDocumentElement(HwpCtrl, "regnumbercode", regnumbercode.substring(7, regnumbercode.length));
			pOrgDocNumCode = regnumbercode;
		}
		else
		{
			SetDocumentElement(HwpCtrl, "deptid", "");
			SetDocumentElement(HwpCtrl, "regnumbercode", "");
			pOrgDocNumCode = "";
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("docnumber") )
		{
			HwpCtrl.SetFieldText("docnumber", "");
		}
		
		SetDocumentElement(HwpCtrl, "deptid", "");
		SetDocumentElement(HwpCtrl, "regnumbercode", "");
		pOrgDocNumCode = "";
	}
	
	var Nodes = eNodes.selectNodes("foot/processinfo/enforcedate");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("enforcedate") )
		{	
		    HwpCtrl.SetFieldText("enforcedate", getNodeText(Nodes(0)));
		}
	}
	
	var Nodes = eNodes.selectNodes("foor/processinfo/receipt");
	if( Nodes.length > 0 )
	{
		var tempNode = Nodes(0).selectSingleNode("number");
		if( tempNode )
		{
			if( HwpCtrl.CheckFieldExist("receiptnumber") )
			{
			    SetDocumentElement(HwpCtrl, "receiptnumber", getNodeText(tempNode));
			}
  			
  			SetDocumentElement(HwpCtrl, "recvdeptid", "");
  			SetDocumentElement(HwpCtrl, "recvdeptname", "");
  			SetDocumentElement(HwpCtrl, "recvdocnum", "");
		}
		else
		{
			if( HwpCtrl.CheckFieldExist("receiptnumber") )
			{
				SetDocumentElement(HwpCtrl, "receiptnumber", "");
			}
  			SetDocumentElement(HwpCtrl, "recvdeptid", "");
  			SetDocumentElement(HwpCtrl, "recvdeptname", "");
  			SetDocumentElement(HwpCtrl, "recvdocnum", "");
		}
		
		var ReceiptDateText = "";
		var tempNode = Nodes(0).selectSingleNode("date");
		if( tempNode )
		{
		    ReceiptDateText = getNodeText(tempNode);
		}

		var tempNode = Nodes(0).selectSingleNode("time");
		if( tempNode )
		{
		    ReceiptDateText = ReceiptDateText + " " + getNodeText(tempNode);
		}
		
		if( HwpCtrl.CheckFieldExist("receiptdate") )
		{
			HwpCtrl.SetFieldText("receiptdate", ReceiptDateText);
		}		
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("receiptnumber") )
		{
			SetDocumentElement(HwpCtrl, "receiptnumber", "");
		}
		
		if( HwpCtrl.CheckFieldExist("receiptdate") )
		{
			HwpCtrl.SetFieldText("receiptdate", getGyulJeDate());
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo/zipcode");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("zipcode") )
		{	
		    HwpCtrl.SetFieldText("zipcode", getNodeText(Nodes(0)));
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("zipcode") )
		{
			HwpCtrl.SetFieldText("zipcode", "");
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo/address");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("address") )
		{	
		    HwpCtrl.SetFieldText("address", getNodeText(Nodes(0)));
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("address") )
		{
			HwpCtrl.SetFieldText("address", "");
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo/homeurl");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("homepage") )
		{	
		    HwpCtrl.SetFieldText("homepage", getNodeText(Nodes(0)));
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("homepage") )
		{
			HwpCtrl.SetFieldText("homepage", "");
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo/telephone");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("telephone") )
		{	
		    HwpCtrl.SetFieldText("telephone", getNodeText(Nodes(0)));
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("telephone") )
		{
			HwpCtrl.SetFieldText("telephone", "");
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo/fax");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("fax") )
		{	
		    HwpCtrl.SetFieldText("fax", getNodeText(Nodes(0)));
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("fax") )
		{
			HwpCtrl.SetFieldText("fax", "");
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo/email");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("email") )
		{	
		    HwpCtrl.SetFieldText("email", getNodeText(Nodes(0)));
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("email") )
		{
			HwpCtrl.SetFieldText("email", "");
		}
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo/publication");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("publication") )
		{	
		    HwpCtrl.SetFieldText("publication", getNodeText(Nodes(0)));
			pPublicFlag = GetAttribute(Nodes(0),"code");
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo/symbol");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("symbol") )
		{
		    signPath =  dirPath + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(Nodes(0).childNodes(0),"src"));
			var signWidth, signHeight;
			if (GetAttribute(Nodes(0).childNodes(0),"width") == "" || GetAttribute(Nodes(0).childNodes(0),"width") == null) {
				signWidth = 20;
			} else {
				signWidth = GetAttribute(Nodes(0).childNodes(0),"width");
				//px로 들어오거나 pt로 들어올경우 mm 단위로 변환
				if (signWidth.indexOf("px") > -1) {
					signWidth = signWidth.replace("px", "") / 3.779;
				} else if (signWidth.indexOf("pt") > -1) {
					signWidth = signWidth.replace("pt", "") / 2.834;
				} else {
					signWidth = signWidth.replace("mm", "");
				}
			}
	  		
			if (GetAttribute(Nodes(0).childNodes(0),"height") == "" || GetAttribute(Nodes(0).childNodes(0),"height") == null) {
				signHeight = 20;
			} else {
				signHeight = GetAttribute(Nodes(0).childNodes(0),"height")
				
				if (signHeight.indexOf("px") > -1) {
					signHeight = signHeight.replace("px", "") / 3.779;
				} else if (signHeight.indexOf("pt") > -1) {
					signHeight = signHeight.replace("pt", "") / 2.834;
				} else {
					signHeight = signHeight.replace("mm", "");
				}
			}
	  		
			HwpCtrl.SetFieldText("symbol", "");
			HwpCtrl.SetFieldImage("symbol", document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(signPath), 1, signWidth, signHeight, true, 2);
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("symbol") )
		{
			HwpCtrl.SetFieldText("symbol", "");
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo/logo");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("logo") )
		{
		    signPath =  dirPath + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(Nodes(0).childNodes(0),"src"));
			var signWidth, signHeight;
			if (GetAttribute(Nodes(0).childNodes(0),"width") == "" || GetAttribute(Nodes(0).childNodes(0),"width") == null)
	  			signWidth = 20;
	  		else
			    signWidth = GetAttribute(Nodes(0).childNodes(0),"width").replace("mm", "");

			if (GetAttribute(Nodes(0).childNodes(0),"height") == "" || GetAttribute(Nodes(0).childNodes(0),"height") == null)
	  			signHeight = 20;
	  		else
			    signHeight = GetAttribute(Nodes(0).childNodes(0),"height").replace("mm", "");
	  		
			HwpCtrl.SetFieldText("logo", "");
			HwpCtrl.SetFieldImage("logo", document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(signPath), 1, signWidth, signHeight, true, 2);
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("logo") )
		{
			HwpCtrl.SetFieldText("logo", "");
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/campaign/headcampaign");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("headcampaign") )
		{	
		    HwpCtrl.SetFieldText("headcampaign", getNodeText(Nodes(0)));
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("headcampaign") )
		{	
			HwpCtrl.SetFieldText("headcampaign", "");
		}
	}

	var Nodes = eNodes.selectNodes("foot/campaign/footcampaign");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("footcampaign") )
		{	
		    HwpCtrl.SetFieldText("footcampaign", getNodeText(Nodes(0)));
		}
	}
	else
	{
		if( HwpCtrl.CheckFieldExist("footcampaign") )
		{	
			HwpCtrl.SetFieldText("footcampaign", "");
		}
	}

	var Nodes = eNodes.selectNodes("attach/title");
	if( Nodes.length > 0 )
	{
		if( HwpCtrl.CheckFieldExist("attachment") )
		{
			var AttachmentText = "";
			var isFirst = true;
		
			for( var i = 0 ; i < Nodes.length ; i++ )
			{
				if( isFirst )
				{
				    AttachmentText = getNodeText(Nodes(i));
					isFirst = false;
				}
				else
				{
				    AttachmentText = ", " + getNodeText(Nodes(i));
				}
			}
			HwpCtrl.SetFieldText("attachment", AttachmentText);
		}
	}
	
	SetHref("UPD");
	SetDocInfo();
	SaveFile();		
	SendAckForSend("", "accept");
	return true;
}          

function SetHref(mode) {
 	var result = "";
 	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/setHref.do",
		data : {
			docID : pDocID,
			fileType : "hwp",
			mode  : mode
		},
		success: function(xml){
			result = xml;
		}        			
	});
}

function ConversionPt(cmm) {
    if (cmm.indexOf("mm") > -1 || cmm.indexOf("pt") > -1 || cmm.indexOf("px") > -1) {
        if (cmm.indexOf("px") > -1)
            return cmm;
        else {
            cmm = ReplaceText(ReplaceText(cmm, "mm", ""), "pt", "");
            return (cmm * 3.779527559055).toFixed(2);
        }
    }
    else
        return (cmm * 3.779527559055).toFixed(2);
}

function Decode(text) {
    var docHTML = ReplaceString(ReplaceString(text, "width=", "kaoni_width="), "height=", "kaoni_height=");
    var Content = document.createElement('div');
    Content.innerHTML = docHTML;

    var ElementsRows = Content.getElementsByTagName("*");
    for (var Cnt = 0; Cnt < ElementsRows.length; Cnt++) {
        if (ElementsRows.item(Cnt).tagName == "P") {
            if (!ElementsRows.item(Cnt).style.marginTop)
                ElementsRows.item(Cnt).style.marginTop = "0mm";
            if (!ElementsRows.item(Cnt).style.marginBottom)
                ElementsRows.item(Cnt).style.marginBottom = "0mm";

            if (!ElementsRows.item(Cnt).style.textIndent && !ElementsRows.item(Cnt).style.marginLeft) {

                if(ElementsRows.item(Cnt).style.textIndent.replace("-", "") == ElementsRows.item(Cnt).style.marginLeft.replace("-", ""))
                {
                    if (ElementsRows.item(Cnt).style.textIndent != ElementsRows.item(Cnt).style.marginLeft)
                    {
                        ElementsRows.item(Cnt).style.removeAttribute("text-indent");
                        ElementsRows.item(Cnt).style.removeAttribute("margin-left");
                    }
                }
            }

            if (ElementsRows.item(Cnt).style.lineHeight) {
                if (ElementsRows.item(Cnt).style.lineHeight.indexOf("%") < 0)
                    ElementsRows.item(Cnt).style.lineHeight = ConversionPt(ElementsRows.item(Cnt).style.lineHeight) + "pt";
            }

            if (ElementsRows.item(Cnt).innerHTML == "")
                ElementsRows.item(Cnt).innerHTML = "&nbsp;";
        }

        if (ElementsRows.item(Cnt).tagName == "TABLE") {
            ElementsRows.item(Cnt).cellPadding = 0;
            if (!ElementsRows.item(Cnt).cellSpacing)
                ElementsRows.item(Cnt).cellSpacing = 0;
        }
    }
    return ReplaceString(ReplaceString(Content.innerHTML, "kaoni_width=", "width="), "kaoni_height=", "height=");
}

function getSignURL(SignURL) {
    var rtnVal = "";
    for (var i = 0 ; i < pRelayDocInfo.getElementsByTagName("SignName").length ; i++) {
        if (getNodeText(pRelayDocInfo.getElementsByTagName("SignName").item(i)).toLowerCase() == SignURL.toLowerCase())
            rtnVal = getNodeText(pRelayDocInfo.getElementsByTagName("RealSignName").item(i));
    }
    
    //경로에 / 포함된경우 비교가 안되는 케이스로 인해 추가
    if (rtnVal == null || rtnVal == "") {
    	for (var i = 0 ; i < pRelayDocInfo.getElementsByTagName("SignName").length ; i++) {
            if (getNodeText(pRelayDocInfo.getElementsByTagName("SignName").item(i)).toLowerCase().indexOf(SignURL.toLowerCase()) > -1)
                rtnVal = getNodeText(pRelayDocInfo.getElementsByTagName("RealSignName").item(i));
        }
    }

    return rtnVal;
}

function SetDocInfo() {
    var result = "";
    
  	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/setRecvDocInfo.do",
		data : {
			docID : pDocID,
			publicFlag : pPublicFlag,
			docNo : pDocNo,
			docNumCode : pDocNumCode,
			orgDocNumCode : pOrgDocNumCode,
			mode : "I",
			fileType : "hwp"
		},
		success: function(xml){
			result = xml;
		}        			
	});
}

function convertDate(datestring) {
    try {
        var datedim = datestring.split(".");
        if (datedim.length > 1) {
            return datedim[1] + "/" + datedim[2];
        }
        else {
            var datedim2 = datestring.split("-");
            if (datedim2.length > 1) {
                return datedim2[1] + "/" + datedim2[2];
            }
            else {
                return datestring;
            }
        }
    }
    catch (e) {
        return datestring;
    }
}

function btnReqReSend_onclick() {
    var url = "/ezApprovalG/ezRetOpinon.do";
    var feature = "status:no;dialogWidth:420px;dialogHeight:270px;help:no;scroll:no"
    var ret = window.showModalDialog(url, null, feature);

    if (ret[0]) {
        var pRetMsg = ret[1];
        pRetMsg = ReplaceString(pRetMsg, "\n", "<br>");
        pRetMsg = ReplaceString(pRetMsg, "&", "&amp;");
        pRetMsg = ReplaceString(pRetMsg, "<", "&lt;");
        pRetMsg = ReplaceString(pRetMsg, ">", "&gt;");

        SendAckForSend(pRetMsg, "req-resend");
    }
}