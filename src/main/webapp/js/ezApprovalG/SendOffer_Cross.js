var MDeptList = null;
var ezselectone_cross_dialogArguments = new Array();
var temppUserID;
var temppDocID;
function SendOffer(pUserID)
{
	try
	{
		MDeptList = null;
		var DocList = new ListView();
        DocList.LoadFromID("DocList");   
        var tr = DocList.GetSelectedRows();
	
		if (tr.length <= 0)
		{
			var pAlertContent = strLang195;
			OpenAlertUI(pAlertContent)
			return;
		}
		
		var pDocID = tr[0].getAttribute("DATA1");
		var pHref = tr[0].getAttribute("DATA2");
		temppUserID = pUserID;
		temppDocID = pDocID;
		rtnVal = SendOfferCheck(pDocID, pUserID);
		if (rtnVal == "NORECEIPT")
		    return;

		if (!rtnVal)
		    return;
		
		OpenSendOfferUI();
	}
	catch(e)
	{
	}
}

function OpenSendOfferUI() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    var pDocID = tr[0].getAttribute("DATA1");
    var pHref = tr[0].getAttribute("DATA2");

    //if (_UserInfo_ApprovalG_UNIV == "YES") {
        //var heigth = window.screen.availHeight;
        //var width = window.screen.availWidth;
        //var heigth = heigth - 10;
        //var width = width - 10;

        //var left = 0;
        //var top = 0;

        //if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
        //    var openLocation = "../ezViewWord/ezConv_word_Cross.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref) + "&ListSusin=";
        //}
        //else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
        //    var openLocation = "../ezViewHWP/ezConvSendG_HWP_Cross.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref) + "&ListSusin=";
        //}
        //else {
        //    var openLocation = "../enforce/ezConvSendG_Cross.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref) + "&ListSusin=";
        //}
        //openwindow(openLocation, "", 880, 550);
    //}
    //else {
        var parameter = ""

        ezselectone_cross_dialogArguments[0] = parameter;
        ezselectone_cross_dialogArguments[1] = SendOffer_Complete;

        var OpenWin = window.open("/ezApprovalG/ezSelectOne.do", "ezSelectOne_Cross", GetOpenWindowfeature(600, 500));
        try { OpenWin.focus(); } catch (e) { }
    //}
}


function SendOffer_Complete(ret) {
    if (ret[0] == "OK") {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var tr = DocList.GetSelectedRows();
        var pDocID = tr[0].getAttribute("DATA1");
        var pHref = tr[0].getAttribute("DATA2");

        var newDocID = CreateNewDoc(pDocID, temppUserID );
        if (newDocID == "") {
            UndoUpdateProcessYN(pDocID);

            var pAlertContent = strLang196;
            OpenAlertUI(pAlertContent)
            return;
        }

        var rvalue = UpdateReceiptOffer(newDocID, pDocID)
        if (!rvalue) {
            UndoCreateDoc(newDocID);

            UndoUpdateProcessYN(pDocID);

            var pAlertContent = strLang196;
            OpenAlertUI(pAlertContent)
            return;
        }
        var rvalue2 = doSendOffer(newDocID, pDocID, ret, pHref);
        if (!rvalue2) {
            UndoCreateDoc(newDocID);

            UndoUpdateProcessYN(pDocID);
        }
    }
    else {
        UndoUpdateProcessYN(pDocID);

        var pAlertContent = strLang197;
        OpenAlertUI(pAlertContent)
        return;
    }
}

function UndoUpdateProcessYN(pDocID)
{
	if( MDeptList != null )
	{
		if( MDeptList[0] == "OK" )
		{
			for( var i = 0 ; i < MDeptList[1].length ; i++ )
			{
				UpdateProcessYN(pDocID, MDeptList[1][i], MDeptList[3][i], MDeptList[2][i], MDeptList[4][i]);
			}
		}
	}
}

function UndoCreateDoc(pDocID)
{
	if (pDocID != "")
	{
		var xmlpara = createXmlDom();
		var xmlhttp = createXMLHttpRequest();		
		var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pDocTypeName", pDocTypeValue);

		xmlhttp.open ("Post","../aspx/UndoDocMust.aspx",false);
		xmlhttp.send(xmlpara);
	}
}

function UpdateReceiptOffer(pDocID, pOrgDocID)
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	
	var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "OrgDocID", pOrgDocID);	
	
	xmlhttp.open("POST","/ezApprovalG/updateReceiptOffer.do",false);
	xmlhttp.send(xmlpara);
	
	var dataNodes = GetChildNodes(xmlhttp.responseXML); 
	var rtnVal = getNodeText(dataNodes[0]);	
	
	if (rtnVal == "TRUE")
		return true;
	else
		return false;
}

function doSendOffer(newDocID, pDocID, array, pHref)
{
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", newDocID);
    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pDocID);	
    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", "");	
    createNodeAndInsertText(xmlpara, objNode, "HTML", "doc");	
    createNodeAndInsertText(xmlpara, objNode, "HREF", pHref);	
    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERID", array[1]);	
    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERNAME", array[2]);	
    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERJOBTITLE", array[3]);	
    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTID", array[4]);	
    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTNAME", array[5]);	
    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERNAME2", array[6]);
    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTNAME2", array[7]);	
    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERJOBTITLE2", array[8]);	    

	xmlhttp.open("POST","/ezApprovalG/sendOfferG.do",false);
	xmlhttp.send(xmlpara);
	
	var dataNodes = GetChildNodes(xmlhttp.responseXML); 
	
	if(getNodeText(dataNodes[0]) == "TRUE")
	{
		var pAlertContent = strLang198;
		OpenAlertUI(pAlertContent);
		return true;
	}
	else
	{
		var pAlertContent = strLang199;
		OpenAlertUI(pAlertContent);
		return false;
	}
}
var xmlhttp2 = createXMLHttpRequest();
function SendOfferCheckBtn(pDocID, pUserID)
{
	try
	{
		if( document.getElementById("tdichange_Rec").style.display == "none" )
			return;
	}
	catch(e) {}
	
	try
	{
	    xmlhttp2 = createXMLHttpRequest();
		var xmlpara = createXmlDom();
		var objNode;
	    createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "UserID", pUserID);
		
        xmlhttp2.open("POST", "/ezApprovalG/sendOfferCheck.do", true);
        xmlhttp2.onreadystatechange = SendOfferCheckBtn_after;
        xmlhttp2.send(xmlpara);
	}
	catch(e) 
	{
		ichange_Rec.Enable = "false";
	}
}

function SendOfferCheckBtn_after() {
    if (xmlhttp2 == null || xmlhttp2.readyState != 4) return;
    try {
        var dataNodes = GetChildNodes(xmlhttp2.responseXML);
        var rtnVal = getNodeText(dataNodes[0]);

        if (rtnVal == "TRUE" || rtnVal == "NORECEIPT")
            document.getElementById("ichange_Rec").Enable = "true";
        else
            document.getElementById("ichange_Rec").Enable = "false";
    }
    catch (e) { }
}

function SendOfferCheck(pDocID, pUserID)
{
	try
	{
		var xmlhttp = createXMLHttpRequest();
		var xmlpara = createXmlDom();
		
		var objNode;
	    createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);  
		
		xmlhttp.open("POST","/ezApprovalG/sendOfferCheck.do",false);
		xmlhttp.send(xmlpara);
		var dataNodes = GetChildNodes(xmlhttp.responseXML); 

	    var rtnVal = getNodeText(dataNodes[0]);	

		if (rtnVal == "FALSE")
		{
			var pAlertContent = strLang200;
			OpenAlertUI(pAlertContent)
			return false;
		}
		else if (rtnVal == "TRUE")
		{
			return true;
		}
		else if (rtnVal == "NORECEIPT")
		{
			var pInformationContent = " " + strLang201 + "<br> " + strLang202;
			OpenInformationUI(pInformationContent, SendOfferCheck_OpenUI);
			return "NORECEIPT";
		}
		else if (rtnVal == "NODEPT")
		{
			var pAlertContent = strLang203;
			OpenAlertUI(pAlertContent)
			return false;
		}
		else if (rtnVal == "NODOC")
		{
			var pAlertContent = strLang204;
			OpenAlertUI(pAlertContent)
			return false;
		}
		else if (rtnVal == "NOUSER")
		{
			var pAlertContent = strLang205;
			OpenAlertUI(pAlertContent)
			return false;
		}
		else if (rtnVal == "OTHERUSER")
		{
			var pAlertContent = strLang206 + "<br>" + strLang207;
			OpenAlertUI(pAlertContent)
			return false;
		}
		else
		{
			var pAlertContent = strLang200;
			OpenAlertUI(pAlertContent)
			return false;
		}
	}
	catch(e)
	{
		var pAlertContent = strLang208 + "<br>" + e.description;
		OpenAlertUI(pAlertContent)
		return false;
	}
}

function SendOfferCheck_OpenUI(Ans) {
    if (!Ans) return false;
    OpenSelectReceipts(temppDocID);
}

function CreateNewDoc(pDocID, pUserID)
{
    try {
    	var result = "";
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/createNewDoc.do",
    		data : {
    			formID : getEndFormID(pDocID),
    			pUserID : pUserID
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});
        if (result == "False") {
            var pAlertContent = strLang131 + "<br> " + strLang132;
            OpenAlertUI(pAlertContent);
        } else {
            return result;
        }
    } catch (e) {
        alert("createNewDoc()" + e.description);
    }
}

function getEndFormID(pDocID)
{
	
	 try {
	    	var result = "";
	    	
	        $.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/getDocData.do",
	    		data : {
	    			docID : pDocID,
	    			mode  : "END",
	    			sel   : "FormID"
	    		},
	    		success: function(xml){
	    			result = loadXMLString(xml);
	    		}        			
	    	});
	        
	        pFormID = getNodeText(GetChildNodes(result)[0]);
	       return pFormID;
	    } catch (e) {
	        alert("GetAprDocFormID : " + e.description);
	    }
}

var selectreceipts_cross_dialogArguments = new Array();
function OpenSelectReceipts(pDocID)
{
    selectreceipts_cross_dialogArguments[0] = "";
    selectreceipts_cross_dialogArguments[1] = OpenSelectReceipts_Complete;

    var OpenWin = window.open("/ezApprovalG/selectReceipts.do?pDocID=" + pDocID, "SelectReceipts_Cross", GetOpenWindowfeature(728, 600));
    try { OpenWin.focus(); } catch (e) { }
}

function OpenSelectReceipts_Complete(ret) {
    if (ret[0] == "cancel")
        return false;

    MDeptList = ret;

    if (MDeptList[0] == "OK") {
        for (var i = 0 ; i < MDeptList[1].length ; i++) {
            UpdateProcessYN(temppDocID, MDeptList[1][i], "T", MDeptList[2][i], MDeptList[4][i]);
        }
    }
    OpenSendOfferUI();
}

function UpdateProcessYN(pDocID, tempDeptID, tempProcessYN, tempDeptName, tempDeptName2)
{
	try
	{
		var xmlpara = createXmlDom();
		var xmlhttp = createXMLHttpRequest();
		
		if (tempDeptName == null)
		    tempDeptName = "";
		if (tempDeptName2 == null)
		    tempDeptName2 = "";
		
		var objNode;
	    createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID); 
        createNodeAndInsertText(xmlpara, objNode, "tempDeptID", tempDeptID);
        createNodeAndInsertText(xmlpara, objNode, "pProcessYN", tempProcessYN);
        createNodeAndInsertText(xmlpara, objNode, "tempDeptName", tempDeptName);
        createNodeAndInsertText(xmlpara, objNode, "tempDeptName2", tempDeptName2);
		
		xmlhttp.open("POST","/ezApprovalG/UpdateProcessYN.do",false);
		xmlhttp.send(xmlpara);
		
		var dataNodes = GetChildNodes(xmlhttp.responseXML); 
	    return getNodeText(dataNodes[0]);	
	}
	catch(e)
	{
		alert("UpdateProcessYN()" + e.description);
		return "";
	}
}

var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";

    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined) {
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
            var OpenWin = window.open(url, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
        else {
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
            var OpenWin = window.open(url, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    return RtnVal;
}