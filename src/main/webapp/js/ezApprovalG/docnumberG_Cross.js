var fractionsymbol;
function getDocNumber(pDeptID, pPrefix) {
    try {
        var fields = message.GetFieldsList();
        var name, docnumber;
        var rtnval;

        name = pPrefix + "docnumber";
        var field = message.GetListItem(fields, name);
        if (!field) return true;

        fractionsymbol = field.textContent;

    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getCabinetSN.do",
    		data : {
    			docID : pDocID,
    			deptID : pDeptID
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});

        var dataNodes = GetChildNodes(result);
        var SN = getNodeText(dataNodes[0]);

        if (SN == "") {
            DocNumCode = "";
            return false;
        }
        else {
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
            if (field) {
                if (trim(field.textContent) == "") {
                    field.textContent = getGyulJeDate();
                }
            }
            return true;
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
    		dataType : "xml",
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
    	
        var dataNodes = GetChildNodes(result);
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