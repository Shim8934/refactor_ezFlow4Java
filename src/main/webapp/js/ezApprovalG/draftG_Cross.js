var sihangURL;

function getExtInfo()
{
	if (pDocID == "")
		pDocID = isTmpDocID;

	var attachxml = "";
	var attachxsl = "";
	var xmlpath = "";
	var ModiFlag = "";
	var ModiDate = "";
	var Notification = "";
	
	var Nodes;
	
	var fields = message.GetFieldsList();
	var field;
	
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var sihangXML = createXmlDom();
		
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
	
	xmlhttp.open("POST","aspx/getExchURL.aspx",false);
	xmlhttp.send(xmlpara);

	xmlpara = xmlhttp.responseXML
	if (getXmlString(xmlhttp.responseXML) == "")
	{
		var pAlertContent = "XML" + strLang166;
		OpenAlertUI(pAlertContent);
		SetBtnStateFalse();
		return;
	}
	
	Nodes = xmlpara.documentElement
	if(Nodes.childNodes.length > 0)
	{
		attachxml = SelectSingleNodeValue(Nodes, "attachxml");
		attachxsl = SelectSingleNodeValue(Nodes, "attachxsl");
		xmlpath = SelectSingleNodeValue(Nodes, "xmlpath");
		ModiFlag =  SelectSingleNodeValue(Nodes, "ModiFlag");
		ModiDate =  SelectSingleNodeValue(Nodes, "ModiDate");
		Notification =  SelectSingleNodeValue(Nodes, "Notification");
	}	
	
	if(xmlpath == "")
	{
		var pAlertContent = "XML" + strLang167;
		OpenAlertUI(pAlertContent);
		SetBtnStateFalse();
		return;
	}
	
    var Xattachxml = createXmlDom();
    var Xattachxsl = createXmlDom();
	Xattachxml.async = false;
	Xattachxsl.async = false;	
    Xattachxml = loadXMLFile("\\Upload_ApprovalG\\" + pCompanyID + "\\exch\\" + attachxml);
    Xattachxsl = loadXMLFile("\\Upload_ApprovalG\\" + pCompanyID + "\\exch\\" + attachxsl);

	var xmlURL = "\\Upload_ApprovalG\\" + pCompanyID + "\\exch\\" + xmlpath
	sihangXML.async = false;
	sihangXML = loadXMLFile(xmlURL);
	if(sihangXML.parseError.errorCode != 0) 
	{
		alert(strLang168 + sihangXML.parseError.reason)
		return;
	}		
	
	var eNodes = sihangXML.documentElement;	
	var Nodes = SelectNodes(eNodes, "HEADER/COMMON/TITLE");
	if(Nodes.length > 0)
	{
		filed = message.GetItemList(fields, "doctitle");
		if(field)
		{	
			field.textContent = getNodeText(GetChildNodes(Nodes[0]));
		}

		field = message.GetItemList(fields, "doctitle2");
		if(field)
		{	
			field.textContent = getNodeText(GetChildNodes(Nodes[0]));
		}
	}
	
	var Nodes = SelectNodes(eNodes, "BODY");
	if(Nodes.length > 0)
	{
		field = message.GetItemList(fields, "body");
		if(field)
		{	
			field.textContent = getNodeText(GetChildNodes(Nodes[0]));
		}
	}
	
	var Nodes = SelectNodes(eNodes, "HEADER/DIRECTION/TO_DOCUMENT_SYSTEM/LINES");
	var SignOrder = 1;
	var hSignOrder = 1;
	if(Nodes.length > 0)
	{
		var LineNode =  SelectSingleNode(Nodes[0], "LINE")
		var lastSignSN = LineNode.length;
		var OpinionText = "";
		for (i=0; i<LineNode.length; i++)
		{
			var SignType =getAttribute(SelectSingleNode(LineNode[i], "SANCTION"), "type");
			var SignResult = getAttribute(SelectSingleNode(LineNode[i], "SANCTION"), "result");
			
			var SignText = "";
			var SignPosition = "";
			var SignName = "";
		
			var tempNode = SelectSingleNodeNew(LineNode[i], "SANCTION/PERSON/POSITION" );
			if (tempNode)
			{
				if (SignType == strLang3)
				{
					field = message.GetItemList(fields, "habyuipositon" + hSignOrder);
					if (field)
					{
						field.value = tempNode.textContent;
					}
				}
				else
				{
					field = message.GetItemList(fields, "jikwe" + SignOrder);
					if (field)
					{
						field.value = tempNode.textContent;
					}
				}
				SignPosition = tempNode.textContent;
			}

			var tempNode = SelectSingleNodeNew(LineNode[i], "SANCTION/PERSON/NAME");
			if (tempNode)
			{
				SignName = tempNode.textContent
			}
						
			var tempNode = SelectSingleNodeNew(LineNode[i], "SANCTION/COMMENT");
			if (tempNode)
			{
				SignText = SignText + strLang171;
				if (OpinionText == "")
				{
					OpinionText = "<P>[" + strLang171 + "]</P>";
				}
				OpinionText = OpinionText + "<P>" + strLang26 + "&nbsp;&nbsp;&nbsp;";
				OpinionText = OpinionText + SignPosition + "&nbsp;&nbsp;&nbsp;";  
				OpinionText = OpinionText + SignName + "&nbsp;&nbsp;&nbsp;";
				OpinionText = OpinionText + tempNode.textContnet + "</P>";
			}
			if (SignType == strLang6)
			{
				SignText = SignText + strLang6;
			}
			else if (SignType == strLang7)
			{
				SignText = SignText + strLang7;
			}
			
			if (SignResult == strLang173)
			{
				if (SignType == strLang3)
				{
					field = fields("habyuisign" + hSignOrder);
					if (field)
					{
						field.value = SignText + SignName;
					}
				}
				else
				{
					field = fields("sign" + SignOrder);
					if (field)
					{
						field.value = SignText + SignName;
					}
				}
			}
			
			if (SignType == strLang3)
			{
				hSignOrder = hSignOrder + 1;
			}
			else
			{
				SignOrder = SignOrder + 1;
			}
		}
		var field = message.GetListItem(fields, "opinions");
		if (field)
		{
			field.innerHTML = OpinionText;
		}		
	}

	var Nodes = SelectNodes(eNodes, "ATTACHMENTS/ADMINISTRATIVE_DB");
	if(Nodes.length > 0)
	{
		var AttachmentText = "";
		AttachmentText = AttachmentText + GetAttribute(SelectSingleNode(Nodes[i],"XMLFILE"), "filename");
		AttachmentText = AttachmentText + ", " + GetAttribute(SelectSingleNode(Nodes[i],"XSLFILE"), "filename");
		var field = message.GetItemList(fields, "attachment");
		if (field)
		{
			field.textContent = AttachmentText;
		}		
	}
	
	SaveFile();	
	SetHref();
}

function SetHref()
{	
	var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
	  
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");    
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

	xmlhttp.open("POST","aspx/setHrefIng.aspx",false);
	xmlhttp.send(xmlpara);

	var dataNodes = GetChildNodes(xmlhttp.responseXML); 	
	pFormHref = getNodeText(dataNodes[0]);
}
/**
 * .aspx로 전달 중 확인 필요
 * */
function SendAckForExch(pType, pMode)
{
  try {
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pType", pType);
    createNodeAndInsertText(xmlpara, objNode, "pMode", pMode);
    var field = message.GetListItem(fields, "body");
    if(field)
    {
        createNodeAndInsertText(xmlpara, objNode, "pBody", field.textContent);
    }
    else
    {
        createNodeAndInsertText(xmlpara, objNode, "pBody", "");
    }   
    createNodeAndInsertText(xmlpara, objNode, "pUserID", "");
    
    xmlhttp.open ("Post","../ezAPRRECEIVE/aspx/sendAckforExch.aspx",false);
    xmlhttp.send(xmlpara);

  } catch(e) {}
}


function btnReturn_onclick() {
	var pInformationContent = strLang174;
    var Ans = OpenInformationUI(pInformationContent);
	if (Ans) {
		SendAckForExch("return", "ING");
		removeDocInfo(pDocID);
		var pAlertContent = strLang175;
		OpenAlertUI(pAlertContent);          
		window.close();
	}
}

function attachRecordDoc() {
	$.ajax({
		type : "POST",
		dataType : "text/html",
		url : "/ezApprovalG/attachRecordDoc",
		async : false,
		data : {
			newDocID : pDocID,
			attachedDocList : attachedDocList
		},
		success : () => {}
	});

	if (opener != null) {
		opener.attachedDocList = null;
	}

	if (parent != null) {
		parent.attachedDocList = null;

		if (opener != null) {
			parent.opener.attachedDocList = null;
		}
	}
}
