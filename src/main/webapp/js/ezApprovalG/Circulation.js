/**
 * 회람 관련 소스
 */

function SaveAprLineInfoCC(pstrXML) {
    try {
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("Post", "/ezApprovalG/gongRamSave.do?type=" + type, false);
        xmlhttp.send(pstrXML);

        if (xmlhttp != null && xmlhttp.readyState == 4) {
          	 if (xmlhttp.statusText == "OK") {
          		var dataNodes = GetChildNodes(xmlhttp.responseXML);
                var ret = getNodeText(dataNodes[0]);
                
                if (ret != "FALSE") {
                	if (type != "ING") {
                    	UpdateLineHistoryCC(ret);
                	}
                }
          	 }
        } 
    } catch (e) {
        alert("SaveAprLineInfo :: " + e.description);
    }
}

function delAprLineInfoCC() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/gongRamDocInfo.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}
	});
	
    pGongRamDocID = getNodeText(GetChildNodes(loadXMLString(result))[0]);
    
    if (pGongRamDocID != "NONE") {
        delCirculation();
    } 
}

function delCirculation() {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/delCirculation.do",
		data : {
			docID : pGongRamDocID
		},
		success: function(xml){
		}
	});
}

function UpdateLineHistoryCC(_DOCID) {
    if (_DOCID == "") {
        return;
    }

	var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateLineHistory.do",
		data : {
			docID : _DOCID,
			userID : arr_userinfo[1],
			userName : arr_userinfo[11],
			userJobTitle : arr_userinfo[13],
			userDeptID : arr_userinfo[4],
			userDeptName : arr_userinfo[15],
			chkFlag : "MUST",
			userName2 : arr_userinfo[12],
			userJobTitle2 : arr_userinfo[14],
			userDeptName2 : arr_userinfo[16]
		},
		success: function(xml){
			result = xml;
		}        			
	});
}