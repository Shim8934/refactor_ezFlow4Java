var fractionsymbol;
//문서 번호 작성 함수 ex) A부서-11111
function getDocNumber(pDeptID, pPrefix, docNumZeroCnt) {
    try {
        var fields = message.GetFieldsList();
        var name, docnumber;
        var rtnval;
        
        name = pPrefix + "docnumber"	;
        var field = message.GetListItem(fields, name);
        
        // useReceiveDocNo NO일때 최종결재시 문서번호가 아니라 접수번호에 채번 추가
        if (approvalFlag == 'G' && pDraftFlag == "SUSIN" && useReceiveDocNo == 'NO') {
        	name = "receiptnumber";
            field = message.GetListItem(fields, name);
        }
        
        if (!field) return true;

        fractionsymbol = field.textContent;

    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getCabinetSN.do",
    		data : {
    			docID : pDocID,
    			deptID : pDeptID,
    			orgCompanyID : orgCompanyID
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});

        var dataNodes = GetChildNodes(loadXMLString(result));
        var SN = getNodeText(dataNodes[0]);

        if (SN == "") {
            DocNumCode = "";
            return false;
        }
        else {
        	if (approvalFlag == "S") {
        		var tempNumString = SN;
        		var i = 0;
        		if (tempNumString < Math.pow(10, docNumZeroCnt)) {
	        			for (i = 0; i < docNumZeroCnt-SN.length; i++) {
	        				tempNumString = "0" + tempNumString;
	        			}
        			field.textContent = fractionsymbol + tempNumString;
        		} else {
        			field.textContent = fractionsymbol + tempNumString
        		}
        		 
        		message.DocumentBodySetAttribute("regnumbercode", tempNumString);
        		message.DocumentBodySetAttribute("deptid", pDeptID);
        		
        		var field = message.GetListItem(fields, "enforcedate");
        		if (field) {
        			if (trim(field.textContent) == "") {
        				field.textContent = getGyulJeDate();
        			}
        		}
        		return true;
        	} else {
        		field.textContent = fractionsymbol + SN;
        		
        		var tempNumString = SN;
        		var i = 0;
        		var templen = tempNumString.length;
        		for (i = 0; i < 6 - templen; i++)
        			tempNumString = "0" + tempNumString;
        		DocNumCode = pDeptID + tempNumString;
        		
        		message.DocumentBodySetAttribute("regnumbercode", tempNumString);
        		message.DocumentBodySetAttribute("deptid", pDeptID);
        		
        		var field = message.GetListItem(fields, "enforcedate");
        		
        		if (approvalFlag == 'G' && pDraftFlag == "SUSIN" && useReceiveDocNo == 'NO') {
                    field = message.GetListItem(fields, "receiptdate");
                }
        		
        		if (field) {
        			if (trim(field.textContent) == "") {
        				field.textContent = getGyulJeDate();
        			}
        		}
        		return true;
        	}
        }
    } catch (e) {
        if (SN != "") {
            field.textContent = fractionsymbol + SN;
            rollbackDocNumber(pDeptID, pPrefix, pDocID);
            return false;
        }
    }
}
function rollbackDocNumber(pDeptID, pPrefix, pDocID) {
    try {
        var fields = message.GetFieldsList();
        var name, docnumber;
        var rtnval;
        name = pPrefix + "docnumber";

        var field = message.GetListItem(fields, name);
        if (!field) return true;

        docnumber = field.textContent;
        docnumber = docnumber.replace(fractionsymbol, "");

    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/rollbackCabinetSN.do",
    		data : {
    			docID : pDocID,
    			deptID : pDeptID,
    			docNumber : docnumber
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});
    	
        var dataNodes = GetChildNodes(loadXMLString(result));
        rtnval = getNodeText(dataNodes[0]);
        field.textContent = fractionsymbol;

        if (rtnval == "FALSE") {
            DocNumCode = "";
        }
        else {
            DocNumCode = "";
        }
    } catch (e) {
        field.textContent = fractionsymbol;
    }
}