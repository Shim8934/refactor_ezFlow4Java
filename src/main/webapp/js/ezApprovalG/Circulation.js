/**
 * 회람 관련 소스
 */

function SaveAprLineInfoCC(pstrXML) {
	if (window.hasOwnProperty('pDocIDAry')) {
		if (pDocIDAry.length > 2) {
			for (i = 0; i < gongramXMLAry.length; i++) {
				SaveAprLineInfoCC_after(gongramXMLAry[i]);
			}
		}else {
            SaveAprLineInfoCC_after(pstrXML);
        }
	} else {
		SaveAprLineInfoCC_after(pstrXML);
	}
}

function delAprLineInfoCC() {
	if (window.hasOwnProperty('pDocIDAry')) {
		if (pDocIDAry.length > 2) {
			for (i = 1; i < pDocIDAry.length; i++) {
				delAprLineInfoCC_after(pDocIDAry[i]);
			}
		}
	} else {
		delAprLineInfoCC_after(pDocID);
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

/* 2023-05-24 임정은 - 일괄기안문서의 공람을 위해 메소드 분리 */
function delAprLineInfoCC_after(_DOCID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/gongRamDocInfo.do",
		data : {
			docID : _DOCID,
			orgCompanyID : orgCompanyID
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

function SaveAprLineInfoCC_after(pstrXML) {
	try {
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("Post", "/ezApprovalG/gongRamSave.do?type=" + type + "&orgCompanyID=" + orgCompanyID, false);
        xmlhttp.send(pstrXML);

        if (xmlhttp != null && xmlhttp.readyState == 4) {
          	 if (xmlhttp.status == 200) {
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

/* 2024-11-18 홍승비 - 전자결재 G > 일괄접수 시에도 공람 기능이 정상 동작하도록 수정, 전용 함수 분리 */
function delAprLineInfoCC_receiptAll(pDocIDArr) {
	try {
		if (pDocIDArr.length > 0) {
			for (i = 0; i < pDocIDArr.length; i++) {
				delAprLineInfoCC_after(pDocIDArr[i]);
			}
		}
    } catch (e) {
        console.log(e);
        alert("delAprLineInfoCC_receiptAll :: " + e.description);
    }
}

function SaveAprLineInfoCC_receiptAll(pstrXML, pDocIDArr) {
	try {
		var result = "";
		
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/gongRamSave_receiptAll.do",
			data : {
				docIDArr : pDocIDArr,
				xmlPara : pstrXML,
				orgCompanyID : orgCompanyID
			},
			success: function(xml) {
				result = xml; // 정상 완료된 경우 <RESULT>TRUE</RESULT>
			}
		});
    } catch (e) {
    	console.log(e);
    	alert("SaveAprLineInfoCC_receiptAll :: " + e.description);
    }
}