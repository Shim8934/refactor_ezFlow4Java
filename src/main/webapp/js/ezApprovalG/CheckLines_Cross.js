var CheckAprLinesXML = "";
var CheckDeptLinesXML = "";

function setAprLinesXML(tempXML) {
    if (tempXML != "cancel")
        CheckAprLinesXML = tempXML;
}

function setDeptLinesXML(tempXML) {
    if (tempXML == "NONE")
        CheckDeptLinesXML = "";
    else if (tempXML != "cancel")
        CheckDeptLinesXML = tempXML;
}

function checkLines() {
    if (CheckAprLinesXML && CheckAprLinesXML != "") {
        var xmlHTTP = createXMLHttpRequest();
        xmlHTTP.open("POST", "/ezApprovalG/checkAprLines.do", false);
        xmlHTTP.setRequestHeader('Content-Type','text/html;charset=utf-8');
        xmlHTTP.send(CheckAprLinesXML);

        var dataNodes = GetChildNodes(xmlHTTP.responseXML, OpenAlertUILong_Complete);
        var rtnVal = getNodeText(dataNodes[0]);

        if (rtnVal != "") {
            OpenAlertUI(rtnVal);
            return false;
        }
    }

    if (CheckDeptLinesXML && CheckDeptLinesXML != "") {
        var xmlHTTP2 = createXMLHttpRequest();
        xmlHTTP2.open("POST", "/ezApprovalG/checkDeptLines.do", false);
        xmlHTTP2.send(CheckDeptLinesXML);

        var dataNodes = GetChildNodes(xmlHTTP2.responseXML);
        var rtnVal = getNodeText(dataNodes[0]);

        if (rtnVal != "") {
            OpenAlertUI(rtnVal, OpenAlertUILong_Complete2);
            return false;
        }
    }
    return true;
}

var ezapralertlong_cross_dialogArguments = new Array();
function OpenAlertUILong(pAlertContent) {
	var parameter = pAlertContent;
	var url = "/ezApprovalG/ezAprAlertLong.do";
	
	if (ext == "hwp") {
		var feature = "status:no;dialogWidth:330px;dialogHeight:305px;help:no;scroll:no;edge:sunken";
		
		window.showModalDialog(url, parameter, feature);
	} else {
		ezapralertlong_cross_dialogArguments[0] = parameter;
		ezapralertlong_cross_dialogArguments[1] = OpenAlertUILong_Complete;
		
		DivPopUpShow(330, 305, url);
	}
}

function OpenAlertUILong_Complete() {
    DivPopUpHidden();
//    btnSetAprLine_onclick();
    btnApprovalInfo();
}

function OpenAlertUILong_Complete2() {
    DivPopUpHidden();
//    btnSetReceivLine_onclick();
    btnApprovalInfo()
}


function getFormInfo(pCode1, pCode2) {
    var Result = "";
    var xmlHTTP3 = createXMLHttpRequest();
    var xmlDOM = createXmlDom();

    var objNode;
    createNodeInsert(xmlDOM, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CODE1", pCode1);
    createNodeAndInsertText(xmlpara, objNode, "CODE2", pCode2);

    xmlHTTP3.open("POST", "/myoffice/ezApprovalG/ezaprline/aspx/getCodeInfo.aspx", false);
    xmlHTTP3.send(xmlDOM);

    if (xmlHTTP3.status == 200)
        Result = xmlHTTP3.responseText;
    else
        alert("ezViewEnd_HWP.aspx, getFormInfo() - " + xmlHTTP3.status);

    xmlHTTP3 = null;
    xmlDOM = null;

    return Result;
}

/* 2020-10-05 홍승비 - 재사용문서 결재선 지정 없이 바로 임시저장 > 기안하는 경우, 결재선 체크하도록 수정 */
function checkTmpLines(pDocSN) {
	var lineChk = true;
	
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getTmpDocAprStateIsOK.do",
		data : {
			pDocSN : pDocSN.split("@")[1]
		},
		success: function(result) {
            if (result == "NO") { // 결재상태가 비어있는 결재선이 존재하는 경우
            	lineChk = false;
            }
		}        	
	});
	
	return lineChk;
}
