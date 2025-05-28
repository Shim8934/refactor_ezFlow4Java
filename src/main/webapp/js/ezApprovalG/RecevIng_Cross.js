var LastSignSN;
var KuyjeType = "002";

function createNewDoc() {
    try {
        var NewDocID;
        var objRoot;
        var objNode;

        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);

        xmlhttp.open("POST", "../aspx/createnewdoc.aspx", false);
        xmlhttp.send(xmlpara);

        if (xmlhttp.responseText == "False") {  
            var pAlertContent = strLang131 + "<br> " + strLang132;
            OpenAlertUI(pAlertContent);
        }
        else {
            return xmlhttp.responseText;
        }
    } catch (e) {
        alert("createNewDoc : " + e.description);
    }
}

function SetAutoPropertyValue() {
    try {
        var fields = message.GetFieldsList();
        if (!fields) return;

        var field = message.GetListItem(fields, "receiptdate");
        if (field) {
            if (trim(field.textContent) == "") {
                field.textContent = getGyulJeDate();
                SaveFile();
            }
        }
    } catch (e) {
        alert("SetAutoPropertyValue : " + e.description);
    }
}

var apropinion_cross_dialogArguments = new Array();
function openOpinionUI(pOpinionFlag) {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;
        parameter[1] = pOpinionFlag;
        parameter[2] = KuyjeType;
        parameter[3] = pDraftFlag;
        parameter[99] = "mht";
        
        apropinion_cross_dialogArguments[0] = parameter;
        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;

        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
    } catch (e) {
        alert("openOpinionUI : " + e.description);
    }
}

function openOpinionUI_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel") {
        var NodeList;
        var objXML = loadXMLString(ret);
        NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

        if (NodeList.length != 0) {
            pHasOpinionYN = "Y";
        } else {
            pHasOpinionYN = "N";
            ret = "cancel";
        }
    }
}

function openOpinionUI_New(pOpinionType, CompleteFunction) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = KuyjeType;	//DRAFTFLAG 결재는 공백 고정 
		parameter[3] = pDocState;	//DOCSTATE
		parameter[4] = orgCompanyID;//ORGCOMPANYID
		parameter[99] = ext;		//EXT
		
		apropinion_cross_dialogArguments[0] = parameter;
		if (typeof(CompleteFunction) != "undefined") {
			apropinion_cross_dialogArguments[1] = CompleteFunction; 
		} else {
			apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete;
		}
		
		DivPopUpShow(530, 520, "/ezApprovalG/aprOpinionNew.do");
	} catch (e) {
		alert("openOpinionUI_New ::: " + e.description);
	}
}
function openOpinionUI_New_Complete(ret) {
	try {
		DivPopUpHidden();
		if (ret == "Clear") {
			pHasOpinionYN = "N";
		} else if (ret == "cancel") {
			//do_nothing
		} else {
	        var objXML = createXmlDom();
	        objXML = loadXMLString(ret);
	        
	        var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
	        if (NodeList.length != 0) {
	            pHasOpinionYN = "Y";
	        } else {
	            pHasOpinionYN = "N";
	            ret = "cancel";
	        }
	        makeOpinionList(objXML);
		}
	} catch (e) {
		alert("openOpinionUI_New_Complete ::: " + e.description);
	}
}

function makeOpinionList(OpinionXML) {

    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, "opinions");
    if (!field) return;
    var firstFlag = true;
    var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
    if (NodeList.length > 0) {
        var strOpinion = " ";
        for (i = NodeList.length - 1; i >= 0; i--) {
            if (getNodeText(GetChildNodes(NodeList[i])[9]) == "001") {
                if (firstFlag) {
                    strOpinion = "<P>[" + strLang27 + "</P>";
                    firstFlag = false;
                }
                if (getNodeText(GetChildNodes(NodeList[i])[2]) != "")
                    strOpinion = strOpinion + "<P>" + getNodeText(GetChildNodes(NodeList[i])[2]) + "&nbsp;&nbsp;&nbsp;";
                else
                    strOpinion = strOpinion + "<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

                strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[1]) + "&nbsp;&nbsp;&nbsp;";
                strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[6]) + "</P>";
            }
        }
        field.innerHTML = strOpinion;

        if (OpinionAction == "ADD" || OpinionAction == "DEL")
            SaveFile();

        OpinionAction = "";
    }
    else {
        field.innerHTML = " ";
    }
}

function openOpinionUI_Distribute_Complete(ret) {
	DivPopUpHidden();
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

function openFileAttachUI() {
    try {
        var parameter = pDocID;
        var url = "../ezAPRATTACH/Aprattach_Cross.aspx";
        var feature = "status:no;dialogWidth:390px;dialogHeight:285px;edge:sunken;scroll:no"; 
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            setAttachInfo(pDocID, "APR", lstAttachLink);
        }
        return ret;
    } catch (e) {
        alert("openFileAttachUI : " + e.description);
    }
}


function GetAprDocFormID() {
    try {
    	var result = "";
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getDocData.do",
    		data : {
    			docID : pDocID,
    			mode  : "APR",
    			sel   : "FormID"
    		},
    		success: function(xml){
    			result = loadXMLString(xml);
    		}        			
    	});
        
        pFormID = getNodeText(GetChildNodes(result)[0]);

    } catch (e) {
        alert("GetAprDocFormID : " + e.description);
    }
}

function trim(parm_str) {
    return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
    str_temp = parm_str;
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
    str_temp = parm_str;
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
    	var result = "";
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getDate.do",
    		data : {
    			getDate : ""
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});

        return result;
    } catch (e) {
        alert("getGyulJeDate : " + e.description);
    }
}

function setSusinUpdataDocID() {
    try {
    	var result = "";
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/setSusinUpdateDocID.do",
    		data : {
    			orgDocID : pOrgDocID,
    			docID    : pDocID,
    			deptID   : arr_userinfo[4]
    		},
    		success: function(xml){
    			result = loadXMLString(xml);
    		}        			
    	});
        
        var dataNodes = GetChildNodes(result);
        
        return getNodeText(dataNodes[0]);

    } catch (e) {
        alert("setSusinUpdataDocID : " + e.description);
    }
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}


var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";

    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}

function getDocInfo() {
	var result = "";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getDocInfo.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});
    
    xmldoc = result;
    var objNodes = GetChildNodes(xmldoc.documentElement);

    if (objNodes) {
        pOrgDocID = getNodeText(objNodes[2]);
        if (getNodeText(objNodes[10]) == "Y" || getNodeText(objNodes[10]) == "O")
            pHasOpinionYN = "Y";
    }
}

function getReceiveDocInfo() {
    try {
    	var result = "";
    	var pdocXML;
    	var xmlpara;
    	var xmlString;
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getReceiveDocInfo.do",
    		data : {
    			docID : pDocID
    		},
    		success: function(xml){
    			result = loadXMLString(xml);
    		}        			
    	});
        
        xmlpara = createXmlDom();

        pdocXML = SelectSingleNodeNew(result, "RECEIVEDATA/DOCINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("DOCINFO").dataSource = xmlpara;

        CONNINFO.XMLDocument = loadXMLString(xmlString);
        var node = GetElementsByTagName(xmlpara, "ORGDOCNUMCODE");
        pOrgDocNumCode = getNodeText(node[0]);
        if (pOrgDocNumCode == "") {
            var node = GetElementsByTagName(xmlpara, "DOCNUMCODE");
            pOrgDocNumCode = getNodeText(node[0]);
        }

        xmlpara = createXmlDom();
        pdocXML = SelectSingleNodeNew(result, "RECEIVEDATA/ATTACHINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);
        document.getElementById("ATTACHINFO").dataSource = xmlpara;

        xmlpara = createXmlDom();
        pdocXML = SelectSingleNodeNew(result, "RECEIVEDATA/DOCFLAGINFO");
        xmlString = getXmlString(pdocXML);
        xmlpara = loadXMLString(xmlString);

        var node = GetElementsByTagName(xmlpara, "DocFlag");
        pDraftFlag = getNodeText(node[0]);
        
        var node = GetElementsByTagName(xmlpara, "Href");
        pFormHref = getNodeText(node[0]);

        pOrgDocID = getNodeText(GetElementsByTagName(result, "ORGDOCID")[0]);
        var doctitle = getNodeText(GetElementsByTagName(result, "DOCTITLE")[0]);

        pWriterDeptID = getNodeText(GetElementsByTagName(result, "WRITERDEPTID")[0]);
        zFormID = getNodeText(GetElementsByTagName(result, "FORMID")[0]);

        pSusinSN = getNodeText(GetElementsByTagName(xmlpara, "RecieveSN")[0]);
        pDocType = getNodeText(GetElementsByTagName(xmlpara, "DocType")[0]);
        pDocState = getNodeText(GetElementsByTagName(xmlpara, "DocState")[0]);
        pAprState = getNodeText(GetElementsByTagName(xmlpara, "AprState")[0]);
        pSusinDocURL = pFormHref;

        if (CrossYN()) {
            RECEIPTDEPTID.textContent = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
        }
        else {
            RECEIPTDEPTID.innerText = getNodeText(GetElementsByTagName(result, "RECEIPTDEPTID")[0]);
        }
        pOrgAttach = "";

        pRelayURL = getNodeText(GetElementsByTagName(result, "RELAY")[0]);
        pRelayURL2 = getNodeText(GetElementsByTagName(result, "RELAY2")[0]);

    } catch (e) {
        alert("getReceiveDocInfo :: " + e.description);
    }
}

function setBtnEnable() {
	var result = "";
	
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
			
			var tempFlag = false;
		    if (getNodeText(GetChildNodes(result.documentElement)[0]) != "")
		        tempFlag = true;

		    if (tempFlag) { //문서과
		        btnReqReSend.style.display = isRelay ? "" : "none";    //재전송요청
		        btnDistribute.style.display = "";       //배부
		        btnReDistribute.style.display = "none"; //재배부요청
		        // 재접수 기능이 아직 없어서 주석처리.
//		        btnRefresh.style.display = ""; //재접수
                if (pAprState === "014") {
                    btnReqReSend.style.display = "none";
                    btnReDistribute.style.display = "";
                }
		    }
		    else {  //일반부서
		        btnReqReSend.style.display = "none";     //재전송요청
		        btnDistribute.style.display = "none";     //배부
		        if (pSusinAdmin == "YES") {   //수발신담당자
		            btnReDistribute.style.display = pAprState === "014" ? "" : "none"; //재배부요청
		            btnAssign.style.display = "";   //지정
		        }
		        else {
		            btnReAssign.style.display = "";; //재지정요청
		        }
		    }
		}        			
	});
}

function document_oncontextmenu() {
    if (g_sendDraftFlag) {
        return false;
    } else {

        return true;
    }
}

var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd()
{
    var parameter = pUserID;
    var url = "/ezApprovalG/ezchkPasswd.do";

    ezchkpasswd_cross_dialogArguments[0] = parameter;
    ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

    DivPopUpShow(350, 225, url);
}


function openAaprDocAttachUI() {
    try {
        var parameter = pUserID;
        var url = "../ezAprDocAttach/aprDocAttac_Crossh_Cross.aspx";
        var feature = "status:no;dialogWidth:574px;dialogHeight:385px;edge:sunken;scroll:no";
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            setAttachInfo(pDocID, "APR", lstAttachLink);
        }
        return ret;
    } catch (e) {
        alert("openAaprDocAttachUI : " + e.description);
    }
}

function openwindow(wfileLocation, wName) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;
        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;
            pleftpos = parseInt(width) - 725;
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - pleftpos;
            left = pleftpos / 2;
        }
        else {
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - 10;
        }
        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
    } catch (e) {
        alert("openwindow :: " + e.description);
    }
}

function setMenuBar(id, flag) {
    var strCmd, display_Value;

    if (flag)
        display_Value = "";
    else
        display_Value = "none";

    strCmd = id + ".style.display='" + display_Value + "'";
    eval(strCmd);
}

var bbtnDistribute = "";
var bbtnReDistribute = "";
var bbtnAssign = "";
var bbtnReAssign = "";
var bbtnCabinet = "";
var bbtnSendAround = "";
var bbtnOpinion = "";
var bbtnPrint = "";

function chkBtnConfirm(para) {
    if (para == "1") {
        if (btnDistribute.style.display == "") {
            setMenuBar("btnDistribute", false);
            bbtnDistribute = "1";
        }

        if (btnReDistribute.style.display == "") {
            setMenuBar("btnReDistribute", false);
            bbtnReDistribute = "1";
        }

        if (btnAssign.style.display == "") {
            setMenuBar("btnAssign", false);
            bbtnAssign = "1";
        }

        if (btnReAssign.style.display == "") {
            setMenuBar("btnReAssign", false);
            bbtnReAssign = "1";
        }

        if (btnCabinet.style.display == "") {
            setMenuBar("btnCabinet", false);
            bbtnCabinet = "1";
        }

        if (btnSendAround.style.display == "") {
            setMenuBar("btnSendAround", false);
            bbtnSendAround = "1";
        }

        if (btnOpinion.style.display == "") {
            setMenuBar("btnOpinion", false);
            bbtnOpinion = "1";
        }

        if (btnPrint.style.display == "") {
            setMenuBar("btnPrint", false);
            bbtnPrint = "1";
        }
    }
    else {
        if (bbtnDistribute == "1")
            setMenuBar("btnDistribute", true);

        if (bbtnReDistribute == "1")
            setMenuBar("btnReDistribute", true);

        if (bbtnAssign == "1")
            setMenuBar("btnAssign", true);

        if (bbtnDistribute == "1")
            setMenuBar("btnDistribute", true);

        if (bbtnReAssign == "1")
            setMenuBar("btnReAssign", true);

        if (bbtnCabinet == "1")
            setMenuBar("btnCabinet", true);

        if (bbtnSendAround == "1")
            setMenuBar("btnSendAround", true);

        if (bbtnOpinion == "1")
            setMenuBar("btnOpinion", true);

        if (bbtnPrint == "1")
            setMenuBar("btnPrint", true);
    }
}

