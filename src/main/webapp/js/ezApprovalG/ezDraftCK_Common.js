
var g_progresswin = null;	
function showProgress(inforstring) {
    g_progresswin = window.showModelessDialog("/myoffice/ezApproval/show_progress_Cross.aspx?fileinfo=" + escape(inforstring), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
}

function hideProgress() {
  try {
	if (g_progresswin)
		g_progresswin.close();
  } catch(e) {}
}

function getDocInfo()
{
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	
	var objNode;		
	    createNodeInsert(xmlpara, objNode, "PARAMETER"); 
	    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	
	    xmlhttp.open("Post", "/myoffice/ezApproval/aspx/getDocInfo.aspx", false);
	xmlhttp.send(xmlpara);	
	xmldoc = loadXMLString(xmlhttp.responseText);

	var objNodes = xmldoc.documentElement.childNodes;
	if(objNodes.length > 0)
	{
		pOrgDocID = getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "ORGDOCID")[0]);			
		if (getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "HASOPINIONYN")[0]) == "Y" || getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "HASOPINIONYN")[0]) == "O")
			pHasOpinionYN = "Y";
			
		tempSecurity = getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "SECURITYCODE")[0]);
		tempKeep = getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "STORAGEPERIOD")[0]);
		tempUrgent = getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "URGENTAPPROVAL")[0]);
		tempPublic = getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "ISPUBLIC")[0]);
		tempKeyword = getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "KEYWORD")[0]);
		tempItemCode = getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "ITEMCODE")[0]);
		tempItemName = getNodeText(GetElementsByTagName(loadXMLString(xmlhttp.responseText), "ITEMNAME")[0]);		
	}
}

function getDraftUserInfo() {
    try {
        var objNode, objRoot;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "CN", pUserID);
        createNodeAndInsertText(xmlpara, objNode, "PROP", "DisplayName;mail;Description;Company;facsimileTelephoneNumber;TelephoneNumber;streetaddress;postalcode");
        createNodeAndInsertText(xmlpara, objNode, "CATE", "user");

        xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetADInfos.aspx", false);
        xmlhttp.send(xmlpara);

        xmluserInfo = loadXMLString(xmlhttp.responseText);

    } catch (e) {
        alert("getDraftUserInfo()" + e.description);
    }
}

function trim(parm_str) {
    if (parm_str == "")
        return ""
    else
        return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
    var str_temp = parm_str;
    while (str_temp.length != 0) {
        if (str_temp.substring(0, 1) == " ") {
            str_temp = str_temp.substring(1, str_temp.length);
        } else {
            return str_temp;
        }
    }
    return str_temp;
}

function rtrim(parm_str) {
    var str_temp = parm_str;
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


function getGyulJeDate() {
    try {
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "getDate", "");
        xmlhttp.open("POST", "/myoffice/ezApproval/aspx/GetDate.aspx", false);
        xmlhttp.send(xmlpara);
        return xmlhttp.responseText;
    } catch (e) {
        alert("getGyulJeDate()" + e.description);
    }
}

function getGyulJeFullDate() {
    try {
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "getDate", "");
        xmlhttp.open("POST", "/myoffice/ezApproval/aspx/GetFullDate.aspx", false);
        xmlhttp.send(xmlpara);
        return xmlhttp.responseText;
    } catch (e) {
        alert("getGyulJeFullDate()" + e.description);
    }
}

function createNewDoc() {
    try {
        var NewDocID;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);
        createNodeAndInsertText(xmlpara, objNode, "xdocid", "");
        xmlhttp.open("POST", "/myoffice/ezApproval/aspx/createnewdoc.aspx", false);
        xmlhttp.send(xmlpara);

        if (xmlhttp.responseText == "False") {
            var pAlertContent = strLang344 + "<br> " + strLang345;
            OpenAlertUI(pAlertContent);
        } else {
            return xmlhttp.responseText;
        }
    } catch (e) {
        alert("createNewDoc()" + e.description);
    }
}

function getDraftInfo() {
    try {
        pFormHref = FormHref;

        pDraftFlag = DraftFlag;
        pDocType = DocType;

        pSusinSN = SusinSN;
        pDocState = DocState;
        pDocState = ConvertDocState(pDocState);

        if (pDraftFlag == "SUSIN") {
            pSusinSN = SusinSN;
            pDocType = DocType;
            pDocState = DocState;

            pDocType = ConvertDocType(pDocType);
            pDocState = ConvertDocState(pDocState);
        }
        else if (pDraftFlag == "HAPYUI") {
            pDocType = DocType;
            pDocState = DocState;

            pDocType = ConvertDocType(pDocType);
            pDocState = ConvertDocState(pDocState);
        }
    } catch (e) {
        alert("getDraftInfo()" + e.description);
    }
}

function ConvertDocType(pDocType) {
    return pDocType;
}

function ConvertDocState(pDocState) {
    return pDocState;
}

var form_check_ui_cross_dialogArgument = new Array();
function Form_check() {
    try {
        var url = "/myoffice/ezApproval/DraftUI/Form_check_ui_Cross.aspx";
        form_check_ui_cross_dialogArgument[0] = "";
        form_check_ui_cross_dialogArgument[1] = Form_check_Complete;

        if (CrossYN() || pNoneActiveX == "YES") {
            DivPopUpShow(330, 205, url)
        }
        else {
            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
            feature = feature + GetShowModalPosition(330, 205);
            var ret = window.showModalDialog(url, "", feature);
            Form_check_Complete(ret);
        }

    } catch (e) {
        alert("Form_check()" + e.description);
    }
}
function Form_check_Complete(RtnVal) {
    DivPopUpHidden();
    if (RtnVal == "ok")
        openForm();
}

var aprDocAttach_dialogArgument = new Array();
function openAaprDocAttachUI() {
    try {
        var parameter = pDocID;
        var url = "/myoffice/ezApproval/ezAprDocAttach/aprDocAttach.aspx";

        aprDocAttach_dialogArgument[0] = parameter;
        aprDocAttach_dialogArgument[1] = openAaprDocAttachUI_Complete;
        DivPopUpShow(850, 630, url);
    } catch (e) {
        alert("openAaprDocAttachUI()" + e.description);
    }
}
function openAaprDocAttachUI_Complete(RtnVal) {
    if (RtnVal != "cancel") {
        setAttachInfo(pDocID, "APR", lstAttachLink);
    }
    DivPopUpHidden();
}

var aprsign1_dialogArgument = new Array();
function openSignUI() {
    try {
        var SignNodeList;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
        xmlhttp.open("Post", "/myoffice/ezApproval/ezAPRSIGN/aspx/GetSignRequest.aspx", false);
        xmlhttp.send(xmlpara);

        SignNodeList = SelectNodes(loadXMLString(xmlhttp.responseText), "LISTVIEWDATA/ROWS/ROW");
        if (SignNodeList.length != 0 || _USE_DirectSign == "YES") {
            aprsign1_dialogArgument[0] = pUserID;
            aprsign1_dialogArgument[1] = openSignUI_Complete;
            var url = "/myoffice/ezApproval/ezAPRSIGN/AprSign1.aspx";
            DivPopUpShow(340, 400, url);
        } else {
            Draft_Complate("NAME");
        }
    } catch (e) {
        alert("openSignUI()" + e.description);
    }
}

function openAprLineUI() {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;
        parameter[1] = pFormID;
        parameter[2] = SignCount;
        parameter[3] = SignInfo;
        parameter[4] = hapyuiCount;
        parameter[5] = pDraftFlag;
        parameter[6] = pSuSinFlag;
        parameter[7] = pChamJoFlag;
        parameter[8] = gongramCount;
        parameter[9] = false;
        parameter[10] = pDocType;
        parameter[11] = gamsaCount;
        parameter[12] = "";

        if (typeof (message.CKEDITOR.instances) != "undefined") {
            if (typeof (message.CKEDITOR.instances.editor1) != "undefined")
                parameter[15] = chkLinesForConditional("");
        }

        parameter[16] = "";
        parameter[17] = AprLineArea;
        parameter[18] = HapyuiArea;
        var url = "/myoffice/ezApproval/ezAPRLINE/aprline_Cross.aspx";
        var feature = "status:no;dialogWidth:990px;dialogHeight:720px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(990, 720);
        var ret = window.showModalDialog(url, parameter, feature);
        return ret;
    } catch (e) {
        alert("openAprLineUI()" + e.description);
    }
}

function openReceivUI() {
    var parameter = new Array();
    if (typeof (message.CKEDITOR.instances) != "undefined") {
        if (typeof (message.CKEDITOR.instances.editor1) != "undefined") {
            isExtDoc = GetAttribute(message.CKEDITOR.instances.editor1.document.$.body, "EXTDOC");
            if (isExtDoc != "Y") isExtDoc = "N";
        }
    }
    else {
        isExtDoc = "N";
    }

    parameter[0] = pFormID;
    parameter[1] = pDocID;
    parameter[2] = "SEND"
    parameter[3] = isExtDoc;
    var url = "/myoffice/ezApproval/ezAPRDEPT/AprDept.aspx";
    var feature = "status:no;dialogWidth:855px;dialogHeight:530px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(855, 530);

    var ret = window.showModalDialog(url, parameter, feature);
    return ret
}

var chk_passwd_dialogArgument = new Array();
function chk_Passwd() {       
    var url = "/myoffice/ezApproval/ezchkPasswd_Cross.aspx";
    chk_passwd_dialogArgument[0] = pUserID;
    chk_passwd_dialogArgument[1] = chk_Pass_Complete;
    DivPopUpShow(330, 200, url);
}

function setFirstDrafter() {
    var ret = getAutoAprLine("");

    if (ret[0] != "NONE") {
        IsSkipDrafter = "FALSE";
        btnSendDraftEnable = "true";

        if (approvalFlag == "S") {
            SGetDraftAprLineInfo(ret);
        } else {
            GetDraftAprLineInfo(ret);
        }
    }
    return;
}

function delOpinionInfo() {
	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/ezApprovalG/deleteOpinionTypeInfo.do",
		data : {
			docID : pDocID,
			opinionType : "002",
		},
		success: function(result) {
			pHasOpinionYN = "";
		}
	});
	
    /*var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", "");
    xmlhttp.open("POST", "/myoffice/ezApproval/ezAPROPINION/aspx/BansongOpinionDel.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;*/
}

function getDeptSymbol(DeptID, DeptName) {
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    var xmlRtn = createXmlDom();
    var objNode;

    if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
        DeptID = upperDeptCode;
        
        /* 2024-11-07 홍승비 - 전자결재 > 상위부서문서함 관련 변수 체크 추가 */
        if (typeof upperDeptName !== "undefined" && upperDeptName !== "") {
        	DeptName = upperDeptName;
        }
    }
    
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CN", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute6");
    createNodeAndInsertText(xmlpara, objNode, "CATE", "group");
    xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetADInfos.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText).documentElement);
    var RtnVal = getNodeText(dataNodes[0]);
    if (RtnVal == "") {
        return DeptName;
    }
    else {
        return RtnVal;
    }
}

function setMenuBar(id, flag) {
    var strCmd, display_Value

    if (flag)
        display_Value = ""
    else
        display_Value = "none"
    document.getElementById(id).style.display = display_Value;
}

function SignCheck() {
    var SignXML = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pDocID);

    xmlhttp.open("Post", "/myoffice/ezApproval/ezAPRSIGN/aspx/getSignInfo.aspx", false);
    xmlhttp.send(xmlpara);

    if (xmlhttp.responseText == "")
        return;

    var NodeList;
    NodeList = GetChildNodes(loadXMLString(xmlhttp.responseText).documentElement);
    if (NodeList.length <= 0)
        return;

    SignXML = loadXMLString(xmlhttp.responseText);

    var rtnVal = putSignXML(SignXML);

    if (rtnVal) {
        SaveFile();

        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("Post", "/myoffice/ezApproval/ezAPRSIGN/aspx/delSignInfo.aspx", false);
        xmlhttp.send(SignXML);
    }
}
function DeleteDeptInfo(pDocID) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp.open("Post", "/myoffice/ezApproval/ezLine/aspx/AprDeptDelete.aspx", false);
    xmlhttp.send(xmlpara);
}
function RemoveTmpDoc(pDocID) {
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezApproval/aspx/RemoveTMPDocInfo.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText));
    var RtnVal = getNodeText(dataNodes[0]);

    if (RtnVal != "TRUE") {
        var pAlertContent = strLang505;
        OpenAlertUI(pAlertContent);
    }
}