var fractionsymbol;
function setDocNumFormat() {
    var Arr_Header = new Array()
    var Header, Tail
    var d = new Date();

    var numHeader = ""
    var DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);

    if (!message.FieldExist("receiptnumber"))
        return;

    var fieldValue = trim(message.GetFieldText("receiptnumber"));
    if (fieldValue != "" && fieldValue.replace("@", "") == fieldValue) {
        pDocNo = fieldValue;
        var tempString = pDocNo.split("-");

        var tempNumString = "";
        if (tempString.length - 1 > 0)
            tempNumString = tempString[tempString.length - 1];

        var i = 0;
        var templen = tempNumString.length;
        for (i = 0; i < 6 - templen; i++)
            tempNumString = "0" + tempNumString;
        pDocNumCode = arr_userinfo[4] + tempNumString;
        return false;
    }
    else if (fieldValue == "") {
        fieldValue = GetDocumentElement(message, "receiptnumber");
    }

    Arr_Header = fieldValue.split("@")
    for (var i = 1; i < Arr_Header.length; i++) {
        Header = Arr_Header[i].substr(0, 2);
        Tail = Arr_Header[i].substr(2);

        switch (Header) {
            case "DP":
                numHeader = numHeader + DeptSymbol + Tail
                break;

            case "dp":
                numHeader = numHeader + DeptSymbol + Tail
                break;

            case "YY":
                numHeader = numHeader + d.getYear() + Tail
                break;

            case "yy":
                var yyear = d.getYear()
                numHeader = numHeader + yyear.toString().substr(2) + Tail
                break;

            case "MM":
                var mmonth = d.getMonth() + 1
                if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
                numHeader = numHeader + mmonth + Tail
                break;

            case "mm":
                numHeader = numHeader + (d.getMonth() + 1) + Tail
                break;

            case "NN":
                break;

            case "nn":
                break;

            case "cs":
                numHeader = numHeader + strLang107 + Tail;
                break;

            default:
                numHeader = numHeader + fieldValue;
                break;
        }
    }
    message.PutFieldText("receiptnumber", numHeader);
    return true;
}
function getRecvDocNumber(pDeptID, docNumZeroCnt) {
	try {
        var name, docnumber;
        var rtnval;
        var result = "";
        
        name = "receiptnumber";
        
        if (LastSignSN == 1 || useReceiveDocNo != 'NO' || pDraftFlag == "HAPYUI") {
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
        			result = loadXMLString(xml);
        		}
        	});
        	
        	if (!message.FieldExist(name)) {
            	var DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
                var SN = getNodeText(GetChildNodes(result)[0]);
                
                //2019-01-08 천성준 - 접수번호 채번 시, 채번길이 설정이 안먹혀서 주석
                //pDocNo = DeptSymbol + "-" + SN; 
                
                var tempNumString = SN;
                var templen = tempNumString.length;
                
                for (var i = 0; i < 6 - templen; i++) {
                    tempNumString = "0" + tempNumString;
                }
                
                pDocNumCode = pDeptID + tempNumString;
                
                //2019-01-08 천성준 - 접수번호 채번 시, 채번길이 설정한 값만큼 앞에 0을 붙여주는 로직 추가
                tempNumString = SN;
				if (tempNumString < Math.pow(10, docNumZeroCnt)) {
        			for (var i = 0; i < docNumZeroCnt-SN.length; i++) {
        				tempNumString = "0" + tempNumString;
        			}
        			pDocNo = DeptSymbol + "-" + tempNumString;
        		} else {
        			pDocNo = DeptSymbol + "-" + tempNumString;
        		}
                
                SaveFile();
                
                return true;
            } else {
            	var rtnVal = setDocNumFormat();
                
                if (!rtnVal) {
                	return true;
                }
                
                fractionsymbol = trim(message.GetFieldText(name));
                
                var SN = getNodeText(GetChildNodes(result)[0]);
                
                if (SN == "") {
                    pDocNumCode = "";
                    pDocNo = "";
                    message.PutFieldText(name, "");
                    
                    return false;
                } else {
                    var tempNumString = SN;
                    var templen = tempNumString.length;
                    
                    for (var i = 0; i < 6 - templen; i++) {
                        tempNumString = "0" + tempNumString;
                    }
                    
                    pDocNumCode = pDeptID + tempNumString;
                    
                    //2019-01-08 천성준 - 접수번호 채번 시, 채번길이 설정한 값만큼 앞에 0을 붙여주는 로직 추가
                    tempNumString = SN;
    				if (tempNumString < Math.pow(10, docNumZeroCnt)) {
            			for (var i = 0; i < docNumZeroCnt-SN.length; i++) {
            				tempNumString = "0" + tempNumString;
            			}
            			message.PutFieldText(name, fractionsymbol + tempNumString);
            			pDocNo = fractionsymbol + tempNumString;
            		} else {
            			message.PutFieldText(name, fractionsymbol + tempNumString);
            			pDocNo = fractionsymbol + tempNumString;
            		}
    				
                    SaveFile();
                    
                    return true;
                }
            }
        } else {
        	var rtnVal = setDocNumFormat();
        	fractionsymbol = trim(message.GetFieldText(name));
        	pDocNo = fractionsymbol;
    		return true;
        }
    } catch (e) {
        if (SN != "") {
        	message.PutFieldText(name, fractionsymbol + SN);
            rollbackDocNumber(pDeptID, pDocID)
            return false;
        }
        else {
        	message.PutFieldText(name, "");
            pDocNo = "";
        }
    }
}
function rollbackDocNumber(pDeptID, pDocID) {
    try {
        var name, docnumber;
        var rtnval;

        name = "receiptnumber"
        if (!message.FieldExist(name))
            return;

        docnumber = message.GetFieldText(name);
        if (fractionsymbol == "") {
            var tempList = docnumber.split("-");
            fractionsymbol = tempList[0] + "-";
        }
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
        message.PutFieldText(name, "");

        if (rtnval == "FALSE") {
            pDocNumCode = "";
            pDocNo = "";
        }
        else {
            SaveFile();
            pDocNumCode = "";
            pDocNo = "";
        }
    } catch (e) {
    	message.PutFieldText(name, "");
        pDocNumCode = "";
        pDocNo = "";
    }
}
function SaveFile() {
    try {
    	var result = "";

    	var data = {
			docID : pDocID,
            // formId : pFormID,
			html  : SaveHtml
    	}
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/saveFileHWP.do",
    		contentType : "application/json",
    		data : JSON.stringify(data),
    		success: function(text){
    			result = text;
    		}        			
    	});
        
        return result;
    } catch (e) {
        alert("SaveFile : " + e);
    }
}

function getDeptSymbol(DeptID, DeptName) {
var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getADInfos.do",
		data : {
			cn : DeptID,
			prop : "extensionAttribute6",
			cate  : "group"
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    var dataNodes = GetChildNodes(loadXMLString(result).documentElement);
    var RtnVal = getNodeText(dataNodes[0]);

    if (RtnVal == "") {
        return DeptName;
    }
    else {
        return RtnVal;
    }
}