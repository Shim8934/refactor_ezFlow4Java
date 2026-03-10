var fractionsymbol;
function setDocNumFormat(pSn) {
    var Arr_Header = new Array();
    var Header, Tail;
    var i;
    var d = new Date();

    var numHeader = "";
    var DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
    
//    if (typeof upperDeptName !== "undefined" && upperDeptName !== "") {
//        DeptSymbol = upperDeptName;
//    }

    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, "receiptnumber");
    if (!field) return

    var fieldValue;
    try {
        fieldValue = field.getAttribute("Format");
        if(fieldValue == null || fieldValue == "")
            fieldValue = "@dp-@nn";
    }
    catch (e) {
        fieldValue = "@dp-@nn";
    }
    if (fieldValue != "" && fieldValue.replace("@", "") == fieldValue) {
        pDocNo = fieldValue;
        var tempString = pDocNo.split("-");
        var tempNumString = "";
        
        if (pSn && pSn.length > 0) {
             tempNumString = pSn;
        } else {
            if (tempString.length - 1 > 0)
                tempNumString = tempString[tempString.length - 1];
        }
        var i = 0;
        var templen = tempNumString.length;
        for (i = 0; i < 6 - templen; i++)
            tempNumString = "0" + tempNumString;
        pDocNumCode = arr_userinfo[4] + tempNumString;
        return false;
    }
    else if (fieldValue == "") {
        fieldValue = getfieldValue(field);
    }
    
    Arr_Header = fieldValue.split("-");
    
    Arr_Header.forEach(function(item, index) {
    	if (!item.indexOf('@')) {
    		//@ exist
    		Header = item.replace("@", "");

            switch (Header) {
                case "DP":
                    numHeader += DeptSymbol;
                    break;

                case "dp":
                    numHeader += DeptSymbol;
                    break;

                case "YY":
                    numHeader += getAccountingYear();
                    break;
                    
                case "yy":
                    var yyear = getAccountingYear();
                    numHeader += yyear.toString().substr(2);
                    break;

                case "MM":
                    var mmonth = d.getMonth() + 1;
                    if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
                    numHeader += mmonth;
                    break;

                case "mm":
                    numHeader += (d.getMonth() + 1);
                    break;

                case "NN":
                    break;

                case "nn":
                    break;

                case "cs":
                    numHeader += strLang107;
                    break;
                    
                case "FT":
                	numHeader += "FT";
                	break;
                	
                case "MV":
                	numHeader += "MV";
                	break;
                	
                case "YM":
                	var yyear = d.getFullYear();
                    numHeader += yyear.toString().substr(2);
                    
                	var mmonth = d.getMonth() + 1;
                    if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
                    numHeader += mmonth;
                    
                    var mdate = d.getDate();
                    if (parseInt(mdate) < 10) mdate = "0" + mdate;
                    numHeader += mdate;
                    
                    break;
                    
                /*단암 양식*/
                case "D1":
                	numHeader += "계약";
            		break;
                case "D2":
                	numHeader += "교육기안";
            		break;
                case "D3":
                	numHeader += "교육";
            		break;
                case "D4":
                	numHeader += "구매";
            		break;
                case "D5":
                	numHeader += "제";
            		break;
                case "D6":
                	numHeader += "기구";
            		break;
                case "D7":
                	numHeader += "기안";
            		break;
                case "D8":
                	numHeader += "제 문서 신청";
            		break;
                case "D9":
                	numHeader += "보고";
            		break;
                case "DA":
                	numHeader += "제조-보고";
            		break;
                case "DB":
                	numHeader += "연장근무보고서";
            		break;
                case "DC":
                	numHeader += "출장";
            		break;
                case "DD":
                	numHeader += "해외출장";
            		break;
                case "DE":
                	numHeader += "품질검사";
            		break;
                case "DF":
                	numHeader += "휴가";
                	break;

                default:
                    numHeader += fieldValue;
                    break;
            }
    	} else {
    		numHeader += item;
    	}
    	
    	if (!(index == Arr_Header.length - 1)) {
    		numHeader += "-";
    	}
    });
    
    field.textContent = numHeader;
    return true;
}
function getfieldValue(pfield) {
    var rtnVal = "";

    if (pfield) {

        switch (pfield.tagName) {
            case "TD":
                rtnVal = pfield.textContent;
                break;
            case "SELECT":
                rtnVal = pfield.textContent;
                break;
            case "INPUT":
                rtnVal = pfield.textContent;
                break;
        }
    }
    return rtnVal;
}
function getRecvDocNumber(pDeptID, docNumZeroCnt) {
    try {
        var fields = message.GetFieldsList();
        var name, docnumber;
        var rtnval;
        var result = "";

        if (approvalFlag =='G') {
	        name = "receiptnumber";
	        var field = message.GetListItem(fields, name);

            var deptName = arr_userinfo[5];
            if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
                pDeptID = upperDeptCode;
                
                /* 2024-11-07 홍승비 - 전자결재 > 상위부서문서함 관련 변수 체크 추가 */
                if (typeof upperDeptName !== "undefined" && upperDeptName !== "") {
                	deptName = upperDeptName;
                }
            }
	        
	        if (LastSignSN == 1 || useReceiveDocNo != 'NO' || (pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU")) {
	        	//전결,편철 or config값에 따라 접수시 채번
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
		        
		        if (!field) {
		            var DeptSymbol = getDeptSymbol(pDeptID, deptName);
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
                    var SN = getNodeText(GetChildNodes(result)[0]);
		        	var rtnVal = setDocNumFormat(SN);
		            
		            if (!rtnVal) {
		            	return true;
		            }
		            
		            fractionsymbol = field.textContent;
		        	
			        if (SN == "") {
			            pDocNumCode = "";
			            pDocNo = "";
			            field.textContent = "";
			            
			            return false;
			        } else {
			        	//2019-01-08 천성준 - 접수번호 채번 시, 채번길이 설정이 안먹혀서 주석
			            //field.textContent = fractionsymbol + SN;
			            //pDocNo = fractionsymbol + SN;
			            
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
	            			field.textContent = fractionsymbol + tempNumString;
	            			pDocNo = fractionsymbol + tempNumString;
	            		} else {
	            			field.textContent = fractionsymbol + tempNumString;
	            			pDocNo = fractionsymbol + tempNumString;
	            		}
			            
			            SaveFile();
			            
			            return true;
			        }
		        }
	        } else {
	        	//결재선포함한 접수 or config값에 따라 최종결재시 채번
	        	var rtnVal = setDocNumFormat("");
	        	fractionsymbol = field.textContent;
	        	pDocNo = fractionsymbol;
        		return true;
	        }
        } else {
            var rtnVal = setDocNumFormat("");

            if (!rtnVal) {
                return true;
            }

            fractionsymbol = field.textContent;
        }
        
    } catch (e) {
        if (SN != "") {
            field.textContent = fractionsymbol + SN;
            rollbackDocNumber(pDeptID, pDocID);
            
            return false;
        } else {
            field.value = "";
            pDocNo = "";
        }
    }
}
function rollbackDocNumber(pDeptID, pDocID) {
    try {
        var name, docnumber;
		var rtnval;
		name = "receiptnumber";
        
		var fields = message.GetFieldsList();
		var field = message.GetListItem(fields, name);
		if (!field) return true;
		
		docnumber = field.textContent;
        docnumber = docnumber.replace(fractionsymbol, "");

    	var result = "";

        if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
            pDeptID = upperDeptCode;
        }
    	
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
        } else {
            DocNumCode = "";
        }
    } catch (e) {
		field.textContent = fractionsymbol;
    }
}

function SaveFile() {
    try {
        if (typeof headerAction === "function") {
            headerAction("open");
        }
    	var result = "";
        var mhtBody = "";
    	mhtBody = message.Get_EditorBodyHTML();
    	EmbedContentIntoXML(mhtBody);
    	mhtBody = ConvertHTMLtoMHT(mhtBody);
    	
    	var data = {
			docID : pDocID,
            // formId : pFormID,
			html  : mhtBody,
			orgCompanyID : orgCompanyID
    	}
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/saveFile.do",
    		contentType : "application/json",
    		data : JSON.stringify(data),
    		success: function(text){
    			result = text;
    		}        			
    	});

        return result;
    } catch (e) {
        alert("SaveFile : " + e.description);
    }
}

function EmbedContentIntoXML(bodyhtml) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = bodyhtml;

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0 && !imgColl.item(i).src.toLowerCase().indexOf(".tmp")) {
            var OrgSrc = imgColl.item(i).src;
            var ImgHeight = "0";
            var ImgWidth = "0";
            if (imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/) == null) {
                if (imgColl.item(i).style.width != "")
                    ImgWidth = imgColl.item(i).style.width.replace("px", "");
                if (imgColl.item(i).style.height != "")
                    ImgHeight = imgColl.item(i).style.height.replace("px", "");
            }
            else {
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgWidth = result[1];
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/height="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgHeight = result[1];
            }
            ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
        }
    }
    return bodyhtml;
}

function getCurDocNumber() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCabinetSN.do",
		data : {
			docID : pDocID,
			deptID : draftDeptID,
			orgCompanyID : orgCompanyID
		},
		success: function(xml){
			result = xml;
		}
	});
       
	var dataNodes = GetChildNodes(loadXMLString(result));
    var SN = getNodeText(dataNodes[0]);
	return SN;
}

function getDeptSymbol(DeptID, DeptName) {
var result = "";

    if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
        DeptID = upperDeptCode;
        
        /* 2024-11-07 홍승비 - 전자결재 > 상위부서문서함 관련 변수 체크 추가 */
        if (typeof upperDeptName !== "undefined" && upperDeptName !== "") {
        	DeptName = upperDeptName;
        }
    }
	
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
