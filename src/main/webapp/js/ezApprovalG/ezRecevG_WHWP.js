var pRelayDocInfo = "";
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
		alert("GetRelayDocInfo : " + e);
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

	
	var xmlContent = createXmlDom();
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
    
    sihangXML = loadXMLString(result);
	
	if (getXmlString(sihangXML) == "") {
	    alert(strLang726 + xmlURL);
	    return false;
	}

	var eNodes = sihangXML;
	
	try {
		var bodyTagUse = true;
	    // 에러로그 여부
	    try {
	    	var Nodes = SelectNodes(eNodes, "body");
	        if (Nodes.length > 0) {
	            bodyTagUse = true;
	        }
	        else {
	            bodyTagUse = false;
	        }
	        Nodes = SelectNodes(eNodes, "ERRORMESSAGE");
	
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
	
		var Nodes = SelectNodes(eNodes, "pubdoc/head/organ");
		if( Nodes.length > 0 ) {
			if( message.FieldExist("organ") ) {	
			    message.PutFieldText("organ", getNodeText(Nodes[0]));
			}
		}
	} catch (e) {
    	alert("getExtInfo error");
    }
		
	try {
		var Nodes = SelectNodes(eNodes, "pubdoc/head/receiptinfo/recipient");
		if( Nodes.length > 0 ) {
		    if( GetAttribute(Nodes[0],"refer") == "true" ) {
				if( message.FieldExist("recipient") )
					message.PutFieldText("recipient", strLang728);
				
				if( message.FieldExist("recipientheader") )
					message.PutFieldText("recipientheader", strLang129);
				
				if( message.FieldExist("recipients") )
				    message.PutFieldText("recipients", getNodeText(Nodes[0]));
		    } else {
				if( message.FieldExist("recipient") )
				    message.PutFieldText("recipient", getNodeText(Nodes[0]));
				
				if( message.FieldExist("recipientheader") )
					message.PutFieldText("recipientheader", " ");
				
				if( message.FieldExist("recipients") )
					message.PutFieldText("recipients", " ");
			}
		}
	} catch(e) {
		alert("recipients error");
	}
	
	try {
		var Nodes = SelectNodes(eNodes, "pubdoc/head/receiptinfo/via");
		if( Nodes.length > 0 ) {
			if( message.FieldExist("refer") ) {
			    message.PutFieldText("refer", getNodeText(Nodes[0]));
			}
		} 
	} catch(e) {
		alert("refer error");
	}
		
	try {
		var Nodes = null;
		var Nodes = SelectNodes(eNodes, "pubdoc/body/title");				
		if( Nodes.length > 0 ) {
			if( message.FieldExist("doctitle") ) {
			    message.PutFieldText("doctitle", ReplaceHTML(getNodeText(Nodes[0])));
			}
			if( message.FieldExist("doctitle2") ) {
			    message.PutFieldText("doctitle2", ReplaceHTML(getNodeText(Nodes[0])));
			}
		}
	} catch(e) {
		alert("title error");
	}
	
	try {
		var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendername");
		if( Nodes.length > 0 ) {
			if( message.FieldExist("chief") ) {
			    message.PutFieldText("chief", getNodeText(Nodes[0]));
			}
		}
	} catch(e) {
		alert("sendername error");
	}
		
	try {
		var Nodes = SelectNodes(eNodes, "pubdoc/foot/seal");
		if( Nodes.length > 0 ) {
		    var pomit = GetAttribute(Nodes[0],"omit");
			if( pomit == "false" ) {
				sealPath = dirPath + sCompanyID + "/ExDocSign/" + sealURL;
				if( message.FieldExist("sealsign") )
				{
					message.PutFieldText("sealsign", "");
					message.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + encodeURI(sealPath));
				}
			}
			
			if( pomit == "true" )
			{
				if( message.FieldExist("sealsign") )
				{
					message.PutFieldText("sealsign", "");
					//관인없을 경우, 경로가 닷넷 경로 그대로 사용하던 오류 수정. 2019-11-22 홍대표.
					message.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape("/files/sealImg/nostamp.gif"), 12);
				}
			}
		}
	} catch(e) {
		alert("seal error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/approvalinfo/approval");
	var ApprovalAnyFlag = 0;
	if( Nodes.length > 0 )
	{
		var lastSignSN = Nodes.length;
		for( var i = 0 ; i < Nodes.length ; i++ )
		{
		    var SignOrder = GetAttribute(Nodes[i],"order");
			var SignText = "";
			if( SignOrder == "final" )
				SignOrder = lastSignSN;
			
			SignText = "";
			
			var tempNode = SelectSingleNode(Nodes[i], "signposition");
			if( tempNode )
			{
				if( message.FieldExist("jikwe" + SignOrder) )
				{
				    message.PutFieldText("jikwe" + SignOrder, getNodeText(tempNode) + SignText);
				}
			}
			var SignInputFlag = false;
			SignText = "";
			
			var tempNode = SelectSingleNode(Nodes[i], "type");
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
			
			if( GetAttribute(Nodes[i],"order") == "final" || ApprovalAnyFlag == 1 )
			{
				var tempNode = SelectSingleNode(Nodes[i], "date");
				if( tempNode )
				    SignText = SignText + convertDate(getNodeText(tempNode)) + "\15";
			}
						
			var name = SelectSingleNode(Nodes[i], "name");
			var tempNode = SelectSingleNode(Nodes[i], "signimage");
			if( name && tempNode == null)
			{
				if( message.FieldExist("sign" + SignOrder) )
				{
					if( ApprovalAnyFlag > 1 )
					{
						message.PutFieldText("sign" + SignOrder, SignText);
					}
					else
					{
					    message.PutFieldText("sign" + SignOrder, SignText+getNodeText(name));
						//HwpCtrl.AppendFieldText("sign" + SignOrder, SignText, true);
					}
				}
				SignInputFlag = true;
			}

			// var tempNode = SelectSingleNode(Nodes[i], "signimage");
			if (tempNode)
			{
			    signPath =  dirPath + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(SelectSingleNode(tempNode, "img"),"src"));
				if( message.FieldExist("sign" + SignOrder) ) {
					message.PutFieldText("sign" + SignOrder, SignText, true);
					message.SetFieldImage("sign" + SignOrder, document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(signPath), 1, 13, 7);

				}
				SignInputFlag = true;
			}
			
			if (!SignInputFlag) {
				if(message.FieldExist("sign" + SignOrder)) {
					message.PutFieldText("sign" + SignOrder, SignText);
				}
			}
		}
	}
	} catch(e) {
		alert("sign error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/approvalinfo/assist");
	if( Nodes.length > 0 )
	{
		var lastSignSN = Nodes.length;
		for( var i = 0 ; i < Nodes.length ; i++ )
		{
		    var SignOrder = GetAttribute(Nodes[i],"order");
			var SignText = "";
			if( SignOrder == "final" )
				SignOrder = lastSignSN;
			
			var tempNode = SelectSingleNode(Nodes[i], "signposition");
			if( tempNode )
			{
				if( message.FieldExist("habyuipositon" + SignOrder) )
				{
				    message.PutFieldText("habyuipositon" + SignOrder, getNodeText(tempNode) + SignText);
				}
			}
			
			var tempNode = selectSingleNode(Nodes[i], "name");
			if( tempNode )
			{
				if( message.FieldExist("habyuisign" + SignOrder) )
				{
				    message.PutFieldText("habyuisign" + SignOrder, getNodeText(tempNode));
				}
			}

			var tempNode = SelectSingleNode(Nodes[i], "signimage");
			if( tempNode )
			{
			    signPath =  dirPath + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(SelectSingleNode(tempNode, "img"),"src"));
				if( message.FieldExist("habyuisign" + SignOrder) ) {					
					message.PutFieldText("habyuisign" + SignOrder, "");
					message.SetFieldImage("habyuisign" + SignOrder, document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(signPath), 3, 0, 0, true, 2);
					message.AppendFieldText("habyuisign" + SignOrder, SignText, true);
				}
			}
		}
		
	}
	} catch(e) {
		alert("habyuisign error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/processinfo/regnumber");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("docnumber") ) {
		    message.PutFieldText("docnumber", getNodeText(Nodes[0]));
		}
		
		var regnumbercode = GetAttribute(Nodes[0],"regnumbercode");
		if( regnumbercode.length > 0 )
		{
			SetDocumentElement("deptid", regnumbercode.substring(0, 7));
			SetDocumentElement("regnumbercode", regnumbercode.substring(7, regnumbercode.length));
			pOrgDocNumCode = regnumbercode;
		}
		else
		{
			SetDocumentElement("deptid", "");
			SetDocumentElement("regnumbercode", "");
			pOrgDocNumCode = "";
		}
	}
	else
	{
		if( message.FieldExist("docnumber") )
		{
			message.PutFieldText("docnumber", "");
		}
		
		SetDocumentElement("deptid", "");
		SetDocumentElement("regnumbercode", "");
		pOrgDocNumCode = "";
	}
	} catch(e) {
		alert("regnumber error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/processinfo/enforcedate");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("enforcedate") )
		{	
		    message.PutFieldText("enforcedate", getNodeText(Nodes[0]));
		}
	}
	} catch(e) {
		alert("enforcedate error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foor/processinfo/receipt");
	if( Nodes.length > 0 )
	{
		var tempNode = Nodes[0].selectSingleNode("number");
		if( tempNode )
		{
			if( message.FieldExist("receiptnumber") )
			{
			    SetDocumentElement("receiptnumber", getNodeText(tempNode));
			}
  			
  			SetDocumentElement("recvdeptid", "");
  			SetDocumentElement("recvdeptname", "");
  			SetDocumentElement("recvdocnum", "");
		}
		else
		{
			if( message.FieldExist("receiptnumber") )
			{
				SetDocumentElement("receiptnumber", "");
			}
  			SetDocumentElement("recvdeptid", "");
  			SetDocumentElement("recvdeptname", "");
  			SetDocumentElement("recvdocnum", "");
		}
		
		var ReceiptDateText = "";
		var tempNode = Nodes[0].selectSingleNode("date");
		if( tempNode )
		{
		    ReceiptDateText = getNodeText(tempNode);
		}

		var tempNode = Nodes[0].selectSingleNode("time");
		if( tempNode )
		{
		    ReceiptDateText = ReceiptDateText + " " + getNodeText(tempNode);
		}
		
		if( message.FieldExist("receiptdate") )
		{
			message.PutFieldText("receiptdate", ReceiptDateText);
		}		
	}
	else
	{
		if( message.FieldExist("receiptnumber") )
		{
			SetDocumentElement("receiptnumber", "");
		}
		
		if( message.FieldExist("receiptdate") )
		{
			message.PutFieldText("receiptdate", getGyulJeDate());
		}
	}
	} catch(e) {
		alert("receipt error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/zipcode");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("zipcode") )
		{	
		    message.PutFieldText("zipcode", getNodeText(Nodes[0]));
		}
	}
	else
	{
		if( message.FieldExist("zipcode") )
		{
			message.PutFieldText("zipcode", "");
		}
	}
	} catch(e) {
		alert("zipcode error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/address");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("address") )
		{	
		    message.PutFieldText("address", getNodeText(Nodes[0]));
		}
	}
	else
	{
		if( message.FieldExist("address") )
		{
			message.PutFieldText("address", "");
		}
	}
	} catch(e) {
		alert("address error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/homeurl");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("homepage") )
		{	
		    message.PutFieldText("homepage", getNodeText(Nodes[0]));
		}
	}
	else
	{
		if( message.FieldExist("homepage") )
		{
			message.PutFieldText("homepage", "");
		}
	}
	} catch(e) {
		alert("homeurl error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/telephone");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("telephone") )
		{	
		    message.PutFieldText("telephone", getNodeText(Nodes[0]));
		}
	}
	else
	{
		if( message.FieldExist("telephone") )
		{
			message.PutFieldText("telephone", "");
		}
	}
	} catch(e) {
		alert("telephone error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/fax");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("fax") )
		{	
		    message.PutFieldText("fax", getNodeText(Nodes[0]));
		}
	}
	else
	{
		if( message.FieldExist("fax") )
		{
			message.PutFieldText("fax", "");
		}
	}
	} catch(e) {
		alert("fax error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/email");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("email") )
		{	
		    message.PutFieldText("email", getNodeText(Nodes[0]));
		}
	}
	else
	{
		if( message.FieldExist("email") )
		{
			message.PutFieldText("email", "");
		}
	}
	} catch(e) {
		alert("email error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/publication");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("publication") )
		{	
		    message.PutFieldText("publication", getNodeText(Nodes[0]));
			pPublicFlag = GetAttribute(Nodes[0],"code");
		}
	}
	} catch(e) {
		alert("publication error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/symbol");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("symbol") )
		{
		    signPath =  dirPath + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(GetChildNodes(Nodes[0])[0],"src"));
			var signWidth, signHeight;
			if (GetAttribute(GetChildNodes(Nodes[0])[0],"width") == "" || GetAttribute(GetChildNodes(Nodes[0])[0],"width") == null) {
				signWidth = 20;
			} else {
				signWidth = GetAttribute(GetChildNodes(Nodes[0])[0],"width");
				//px로 들어오거나 pt로 들어올경우 mm 단위로 변환
				if (signWidth.indexOf("px") > -1) {
					signWidth = signWidth.replace("px", "") / 3.779;
				} else if (signWidth.indexOf("pt") > -1) {
					signWidth = signWidth.replace("pt", "") / 2.834;
				} else {
					signWidth = signWidth.replace("mm", "");
				}
			}
	  		
			if (GetAttribute(GetChildNodes(Nodes[0])[0],"height") == "" || GetAttribute(GetChildNodes(Nodes[0])[0],"height") == null) {
				signHeight = 20;
			} else {
				signHeight = GetAttribute(GetChildNodes(Nodes[0])[0],"height")
				
				if (signHeight.indexOf("px") > -1) {
					signHeight = signHeight.replace("px", "") / 3.779;
				} else if (signHeight.indexOf("pt") > -1) {
					signHeight = signHeight.replace("pt", "") / 2.834;
				} else {
					signHeight = signHeight.replace("mm", "");
				}
			}
	  		
			message.PutFieldText("symbol", "");
			message.SetFieldImage("symbol", document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(signPath), 1, signWidth, signHeight, true, 2);
		}
	}
	else
	{
		if( message.FieldExist("symbol") )
		{
			message.PutFieldText("symbol", "");
		}
	}
	} catch(e) {
		alert("symbol error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/logo");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("logo") )
		{
		    signPath =  dirPath + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(GetChildNodes(Nodes[0])[0],"src"));
			var signWidth, signHeight;
			if (GetAttribute(GetChildNodes(Nodes[0])[0],"width") == "" || GetAttribute(GetChildNodes(Nodes[0])[0],"width") == null)
	  			signWidth = 20;
	  		else
			    signWidth = GetAttribute(GetChildNodes(Nodes[0])[0],"width").replace("mm", "");

			if (GetAttribute(GetChildNodes(Nodes[0])[0],"height") == "" || GetAttribute(GetChildNodes(Nodes[0])[0],"height") == null)
	  			signHeight = 20;
	  		else
			    signHeight = GetAttribute(GetChildNodes(Nodes[0])[0],"height").replace("mm", "");
	  		
			message.PutFieldText("logo", "");
			message.SetFieldImage("logo", document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(signPath), 1, signWidth, signHeight, true, 2);
		}
	}
	else
	{
		if( message.FieldExist("logo") )
		{
			message.PutFieldText("logo", "");
		}
	}
	} catch(e) {
		alert("logo error");
	}
	
	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/campaign/headcampaign");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("headcampaign") )
		{	
		    message.PutFieldText("headcampaign", getNodeText(Nodes[0]));
		}
	}
	else
	{
		if( message.FieldExist("headcampaign") )
		{	
			message.PutFieldText("headcampaign", "");
		}
	}
	} catch(e) {
		alert("headcampaign error");
	}

	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/foot/campaign/footcampaign");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("footcampaign") )
		{	
		    message.PutFieldText("footcampaign", getNodeText(Nodes[0]));
		}
	}
	else
	{
		if( message.FieldExist("footcampaign") )
		{	
			message.PutFieldText("footcampaign", "");
		}
	}
	} catch(e) {
		alert("footcampaign error");
	}

	try {
	var Nodes = SelectNodes(eNodes, "pubdoc/attach/title");
	if( Nodes.length > 0 )
	{
		if( message.FieldExist("attachment") )
		{
			var AttachmentText = "";
			var isFirst = true;
		
			for( var i = 0 ; i < Nodes.length ; i++ )
			{
				if( isFirst )
				{
				    AttachmentText = getNodeText(Nodes[i]);
					isFirst = false;
				}
				else
				{
				    AttachmentText = ", " + getNodeText(Nodes[i]);
				}
			}
			message.PutFieldText("attachment", AttachmentText);
		}
	}
	} catch(e) {
		alert("title error");
	}
	
	try {
		var Nodes = SelectNodes(eNodes, "pubdoc/body");
		if( Nodes.length > 0 ) {
		    //if( GetAttribute(Nodes[0], "separate") == "true" || GetAttribute(Nodes[0], "separate") == null) {
				var tempNodes = SelectNodes(eNodes, "pubdoc/body/content");
				if( tempNodes.length > 0 ) {
					if( message.FieldExist("body") ) {
						var bodySTR = "";
						for( var i = 0 ; i < tempNodes[0].childNodes.length ; i++ ) {
							if( i == 0 )
							    bodySTR = getNodeText(tempNodes[0].childNodes[i]);
							else
							    bodySTR = bodySTR + getNodeText(tempNodes[0].childNodes[i]);
						}
						
						if( bodySTR.indexOf("<![CDATA[") > -1 ) {
							bodySTR = bodySTR.replace("<![CDATA[", "");
							bodySTR = bodySTR.replace("]]>", "");
						}
						message.SetCloneDataCallback(Decode(bodySTR), "body", "HTML", SetBody_Complete);
					}
				}
			/*}
			else
			{
				if( !needDoubleFormFlag )
				{
					needDoubleFormFlag = true;
					var URL = document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pRelayURL2);
					message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
					return false;
				}
				
				var tempNodes = SelectNodes(eNodes, "pubdoc/body/content");
				if( tempNodes.length > 0 )
				{
					if( message.FieldExist("body") )
					{
						var bodySTR = "";
						for( var i = 0 ; i < tempNodes[0].childNodes.length ; i++ )
						{
							if( i == 0 )
								bodySTR = getNodeText(tempNodes[0].childNodes[i]);
							else
							    bodySTR = bodySTR + getNodeText(tempNodes[0].childNodes[i]);
						}
						
						if( bodySTR.indexOf("<![CDATA[") > -1 )
						{
							bodySTR = bodySTR.replace("<![CDATA[", "");
							bodySTR = bodySTR.replace("]]>", "");
						}
						message.SetCloneDataCallback(Decode(bodySTR), "body", "HTML", SetBody_Complete);
					}
				}
			}*/
		}
	} catch(e) {
		alert("body error");
	}
	/*
	SetHref("UPD");
	SetDocInfo();
	SaveFile();		
	SendAckForSend("", "accept");
	return true;*/
}          

function SetBody_Complete(rtnVal) {
	if (rtnVal) {
		if (!imgCheck) {
			var pInformationContent = strLangAdd00041;
			var Ans = OpenInformationUI(pInformationContent);
			return getExtInfo_Complete(Ans);
		}
		else {			
			GetHTML(getExtInfo_CompleteSave);
		}
    }
}

function getExtInfo_CompleteSave(html) {
	SaveHtml = html;
	var rtn = SaveFile();
	if(rtn.toUpperCase() != "TRUE") {
		var pInformationContent = strLangAdd00040;
		alert(pInformationContent);
		return getExtInfo_Fail();
	}
	else {
		// btnReqReSend.style.display = "none";
		SetHref("UPD");
		SetDocInfo();
		SendAckForSend("", "accept");

		setAutoProperty();
		process_AfterOpen();
		SetBtnStateTrue();

		GetHTML(before_FieldsAvailable_complate);
	}	
}

function before_FieldsAvailable_complate(html) {
	SaveHtml = html;
	var rtn = SaveFile();
	if(rtn.toUpperCase() == "TRUE")
		FieldsAvailable_complate(true);
}

function getExtInfo_Fail(rtnVal) {
	DivPopUpHidden();
	SetHref("DEL");
	chkBtnConfirm("1");
	// btnReqReSend.style.display = "";
	return false;
}

function getExtInfo_Complete(rtnVal) {
	DivPopUpHidden();
	if (!rtnVal) {

		SetHref("DEL");
		chkBtnConfirm("1");
		// btnReqReSend.style.display = "";
		return false;
	}
	else {
		// btnReqReSend.style.display = "none";
		SetHref("UPD");
		SetDocInfo();
		SendAckForSend("", "accept");
		return true;
	}
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

/*function btnReqReSend_onclick() {
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
}*/

var reqResend_dialogArgument = new Array();
function btnReqReSend_onclick() {
	var url = "/ezApprovalG/ezRetOpinon.do";
	reqResend_dialogArgument[0] = "";
	reqResend_dialogArgument[1] = btnReqReSend_onclick_conplete;

	DivPopUpShow(420, 270, url);
}

function btnReqReSend_onclick_conplete(retValue, reqValue) {
	if (retValue === "cancel") {
		DivPopUpHidden();
	} else {
		var pRetMsg = retValue;
		pRetMsg = ReplaceString(pRetMsg, "\n", "<br>");
		pRetMsg = ReplaceString(pRetMsg, "&", "&amp;");
		pRetMsg = ReplaceString(pRetMsg, "<", "&lt;");
		pRetMsg = ReplaceString(pRetMsg, ">", "&gt;");

		SendAckForSend(pRetMsg, "req-resend");
	}
}

function ReplaceHTML(str) {
    str = ReplaceAll(str, "&#39;", "'");
    str = ReplaceAll(str, "&amp;", "&");
    str = ReplaceAll(str, "&lt;", "<");
    str = ReplaceAll(str, "&gt;", ">");
    str = ReplaceAll(str, "&apos;", "'");
    str = ReplaceAll(str, "&quot;", "\"");
    return str;
}

function ReplaceAll(pStrContent, pStrOrg, pStrRep) {
    return pStrContent.split(pStrOrg).join(pStrRep);
}