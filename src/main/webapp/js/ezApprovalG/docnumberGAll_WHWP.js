//문서 번호 작성 함수 ex) A부서-11111
//문서 번호 작성 함수 (공공버전 일반버전 공통채번 소스개선) 2019-01-07 천성준
var fractionsymbol;
// var docNumSn = ""; // 부모창의 배열로 수정

// 해당 함수는 각 안별로 자식창에 접근하여 호출된다.
function getDocNumberNew(pDeptID, pPrefix, docNumZeroCnt, currIdx) {
	var name;
	var rtnval;
	var fields;
	var docnumber;
	var SN = "";
	//var currIfrm = document.getElementById("ifrm" + currIdx); // 각 안별 웹한글기안기 iframe을 사용 (해당 함수는 자식창이 아닌 부모창에서 호출된다.)
	name = pPrefix + "docnumber";
	
	try {
//		if (approvalFlag == "G") {
			/*
			if (pDraftFlag == "SUSIN" && useReceiveDocNo == "NO") { // 일괄기안창에서는 타지 않는 분기이므로 주석처리
				name = "receiptnumber";
			}
			*/
			if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
				pDeptID = upperDeptCode;
			}
			
			/* 2022-08-19 홍승비 - 접수문서가 아닌 경우, 문서번호 필드가 없으면 문서번호 부여 로직이 스킵되어 결재가 정상 진행되는 분기 오류 수정 (파일 백지화 현상과도 관련있음) */
			if (!FieldExist(name)) {
				if (name == "bedocnumber") { // 기안 시 사용할 수 있는 bedocnumber 필드의 경우, 없으면 그대로 기안 진행
					return true;
				} else {
					return false;
				}
			}
			
			fractionsymbol = GetFieldText(name);
/*			
			if (nonElecRec == "Y") {
				if (pDraftFlag == "SUSIN") {
					var result = getCabinetSN(pDeptID, pDocIDAry[currIdx]);
	    			var dataNodes = GetChildNodes(loadXMLString(result));
	    	    	SN = getNodeText(dataNodes[0]);
				} else {
					SN = fractionsymbol;
				}
			} else {*/
				var result = getCabinetSN(pDeptID, parent.pDocIDAry[currIdx]);
				var dataNodes = GetChildNodes(loadXMLString(result));
		    	SN = getNodeText(dataNodes[0]);
		//	}
			
			if (SN == "") {
				//DocNumCode = "";
				parent.pDocNumCodeAry[currIdx] = "";
	            return false;
			} else {
/*				if (nonElecRec == "Y") {
					if (pDraftFlag == "SUSIN") {
						if (fractionsymbol == "") {
    						fractionsymbol = arr_userinfo[5] + "-";
    					}
						
						var tempNumString = SN;
						var templen = tempNumString.length;
						for (var i = 0; i < 6 - templen; i++) {
							tempNumString = "0" + tempNumString;
						}
						
						DocNumCode = pDeptID + tempNumString;
						
						tempNumString = SN;
						if (tempNumString < Math.pow(10, docNumZeroCnt)) {
		        			for (var i = 0; i < docNumZeroCnt-SN.length; i++) {
		        				tempNumString = "0" + tempNumString;
		        			}
		        			
	        				currIfrm.contentWindow.PutFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + tempNumString);
		        		} else {
	        				currIfrm.contentWindow.PutFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + tempNumString);
		        		}
					} else {
						DocNumCode = SN;
					}
				} else {*/
					var tempNumString = SN;
					var templen = tempNumString.length;
					for (var i = 0; i < 6 - templen; i++) {
						tempNumString = "0" + tempNumString;
					}
					
					//DocNumCode = pDeptID + tempNumString;
					parent.pDocNumCodeAry[currIdx] = pDeptID + tempNumString;
					
					tempNumString = SN;
					if (tempNumString < Math.pow(10, docNumZeroCnt)) {
	        			for (var i = 0; i < docNumZeroCnt-SN.length; i++) {
	        				tempNumString = "0" + tempNumString;
	        			}
        				PutFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + tempNumString);
	        		} else {
        				PutFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + tempNumString);
	        		}
		//		}
				
					// 아마 SUSIN은 필요없는 분기가 될거임 (내부결재완료시 각 안이 쪼개져서 별도 문서가 되므로, 접수문서에서는 일괄기안창에 접근하지 않음) 
					/*
				if (pDraftFlag == "SUSIN" && useReceiveDocNo == "NO") {
					if (currIfrm.contentWindow.FieldExist("receiptdate")) {
						if (trim(currIfrm.contentWindow.GetFieldText("receiptdate")) == "") {
							currIfrm.contentWindow.PutFieldText("receiptdate", getGyulJeDate());
						}
					}
				} else {
				*/
					if (FieldExist("enforcedate")) {
						if (trim(GetFieldText("enforcedate")) == "") {
							PutFieldText("enforcedate", getGyulJeDate());
						}
					}
				//}

                parent.pDocNumSnAry[currIdx] = SN;
				
				return true;
			}
//		}
		// 일괄기안은 G버전 웹한글 전용으로 개발됨
		/*
		else {
			fields = currIfrm.contentWindow.GetFieldsList();
        	var field = currIfrm.contentWindow.GetListItem(fields, name);
        	if (!field) {return true;}
        	
        	fractionsymbol = field.textContent;
			if (pDraftFlag == "HABYUI" || pDraftFlag == "HAPYUI") {
				fractionsymbol = arr_userinfo[5] + "-";
			}
        	
        	var result = getCabinetSN(pDeptID, pDocIDAry[currIdx]);
        	var dataNodes = GetChildNodes(loadXMLString(result));
	    	SN = getNodeText(dataNodes[0]);
	    	
	    	if (SN == "") {
	            DocNumCode = "";
	            return false;
	        } else {
	        	var tempNumString = SN;
        		if (tempNumString < Math.pow(10, docNumZeroCnt)) {
        			for (var i = 0; i < docNumZeroCnt-SN.length; i++) {
        				tempNumString = "0" + tempNumString;
        			}
        			
        			field.textContent = fractionsymbol + tempNumString;
        		} else {
        			field.textContent = fractionsymbol + tempNumString
        		}
        		 
        		currIfrm.contentWindow.DocumentBodySetAttribute("regnumbercode", tempNumString);
        		currIfrm.contentWindow.DocumentBodySetAttribute("deptid", pDeptID);
        		
        		var field = currIfrm.contentWindow.GetListItem(fields, "enforcedate");
        		if (field) {
        			if (trim(field.textContent) == "") {
        				field.textContent = getGyulJeDate();
        			}
        		}
        		return true;
	        }
		}
		*/
	} catch (e) {
		if (SN != "") {
			PutFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + SN);
			rollbackDocNumber(pDeptID, pPrefix, parent.pDocIDAry[currIdx], currIdx);
        	return false;
		}
	}
}

function rollbackDocNumber(pDeptID, pPrefix, pDocID, currIdx) {
    try {
        var name;
        var docnumber;
		var rtnval;
		
		if (!pPrefix) {
			pPrefix = "doc";
		}
        name = pPrefix + "number";
        
        if (!FieldExist(name)) {
            return true;
        }

        docnumber = GetFieldText(name);
        docnumber = docnumber.replace(fractionsymbol, "");
        
        if (!docnumber || isNaN(Number(docnumber))) {
            docnumber = parent.pDocNumSnAry[currIdx];
            fractionsymbol.replace(docnumber, "");
        }

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
        
    	PutFieldText(name, fractionsymbol);
        
    	if (pPrefix === "doc" && FieldExist("enforcedate")) {
    	    PutFieldText("enforcedate", "");
        }

    	// 일괄기안을 위한 문서번호 배열값을 초기화
    	/*
        if (rtnval == "FALSE") {
            DocNumCode = "";
        } else {
            DocNumCode = "";
        }
        */
    	parent.pDocNumCodeAry[currIdx] = "";
    	
    } catch (e) {
		PutFieldText(name, fractionsymbol);
    	if (pPrefix === "doc" && FieldExist("enforcedate")) {
    	    PutFieldText("enforcedate", "");
        }
    }
}

function getCabinetSN(pDeptID, pDocID) {
	var rtnVal = "";
	
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
			rtnVal = xml;
		}
	});
	
	return rtnVal;
}
