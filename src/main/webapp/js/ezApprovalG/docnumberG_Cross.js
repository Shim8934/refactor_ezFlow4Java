var fractionsymbol;
//문서 번호 작성 함수 ex) A부서-11111
function getDocNumber(pDeptID, pPrefix, docNumZeroCnt) {
    try {
    	var fields;
        var name, docnumber;
        var rtnval;

        name = pPrefix + "docnumber";
        
        if (approvalFlag == 'G' && (pDraftFlag == "SUSIN" || pDraftFlag == "HABYUI") && useReceiveDocNo == 'NO') {
        	name = "receiptnumber";
        }
        
        if (isHWP == "Y") {
            if (!HwpCtrl.CheckFieldExist(name)) {
                return true;
            }

            fractionsymbol = HwpCtrl.GetFieldText(name);
        } else {
        	fields = message.GetFieldsList();
        	var field = message.GetListItem(fields, name);
        	if (!field) return true;
        	
        	fractionsymbol = field.textContent;
        }

    	var result = "";
    	var SN = ""; 
    	var dataNodes = "";
    /* if (isHWP == "Y" && nonElecRec != "Y") { */ //mht양식 채번이 안되서 주석처리
		if (nonElecRec != "Y") { // 비전자문서는 채번안함
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
	    	
	    	dataNodes = GetChildNodes(loadXMLString(result));
	    	SN = getNodeText(dataNodes[0]);
	    	
    	} else {
    		if (approvalFlag == "G" && pDraftFlag == "SUSIN") {
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
    			
    			dataNodes = GetChildNodes(loadXMLString(result));
    	    	SN = getNodeText(dataNodes[0]);
    		} else {
    			SN = fractionsymbol;
    		}
    	}

        if (SN == "") {
            DocNumCode = "";
            return false;
        } else {
        	if (approvalFlag == "S") {
        		var tempNumString = SN;
        		if (tempNumString < Math.pow(10, docNumZeroCnt)) {
        			for (var i = 0; i < docNumZeroCnt-SN.length; i++) {
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
        		if (isHWP == "Y") {
        			if (nonElecRec != "Y") {
	                    HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + SN);
	                    var tempNumString = SN;
	                    var templen = tempNumString.length;
	                    for (var i = 0; i < 6 - templen; i++) {
	                    	tempNumString = "0" + tempNumString;
	                    }
	                    DocNumCode = pDeptID + tempNumString;
	                    
        			} else {
        				if (approvalFlag == "G" && pDraftFlag == "SUSIN") {
        					if (fractionsymbol == "") {
        						fractionsymbol = arr_userinfo[5] + "-";
        					}
        					
        					HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + SN);
    	                    var tempNumString = SN;
    	                    var templen = tempNumString.length;
    	                    
    	                    for (var i = 0; i < 6 - templen; i++) {
    	                    	tempNumString = "0" + tempNumString;
    	                    }
    	                    DocNumCode = pDeptID + tempNumString;
    	                    
        				} else {
        					DocNumCode = SN;
        				}
        			}

        			if (approvalFlag == 'G' && pDraftFlag == "SUSIN" && useReceiveDocNo == 'NO') {
                        if (HwpCtrl.CheckFieldExist("receiptdate"))
                            if (trim(HwpCtrl.GetFieldText("receiptdate")) == "")
                                HwpCtrl.SetFieldText("receiptdate", getGyulJeDate());
                    } else {
                    	if (HwpCtrl.CheckFieldExist("enforcedate"))
                            if (trim(HwpCtrl.GetFieldText("enforcedate")) == "")
                                HwpCtrl.SetFieldText("enforcedate", getGyulJeDate());
                    }

                    return true;
        		} else {
        			field.textContent = fractionsymbol + SN;
        			
        			var tempNumString = SN;
        			var templen = tempNumString.length;
        			for (var i = 0; i < 6 - templen; i++) {
        				tempNumString = "0" + tempNumString;
        			}
        			
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
        }
    } catch (e) {
        if (SN != "") {
        	if (isHWP == "Y") {
        		HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + SN);
        	} else {
        		field.textContent = fractionsymbol + SN;
        	}
        	
        	rollbackDocNumber(pDeptID, pPrefix, pDocID);
        	return false;
        }
    }
}
//문서 번호 작성 함수 (공공버전 일반버전 공통채번 소스개선) 2019-01-07 천성준
function getDocNumberNew(pDeptID, pPrefix, docNumZeroCnt) {
	var name;
	var rtnval;
	var fields;
	var docnumber;
	var SN = "";

	name = pPrefix + "docnumber";
	
	try {
		if (approvalFlag == "G") {
			
			if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
				pDeptID = upperDeptCode;
			}
			
			if (pDraftFlag == "SUSIN" && useReceiveDocNo == "NO") {
				name = "receiptnumber";
				
				/* 2022-08-22 홍승비 - 접수문서가 아닌 경우, 문서번호 필드가 없으면 문서번호 부여 로직이 스킵되어 결재가 정상 진행되는 분기 오류 수정 (파일 백지화 현상과도 관련있음) */
				if (isHWP == "Y") {
					if (!HwpCtrl.CheckFieldExist(name)) {
						return true;
					}
					
					fractionsymbol = HwpCtrl.GetFieldText(name);
				} else {
					fields = message.GetFieldsList();
					
		        	var field = message.GetListItem(fields, name);
		        	if (!field) {
		        		return true;
		        	}
		        	
		        	fractionsymbol = field.textContent;
				}
			}
			else {
				// 일반적인 문서번호 필드가 없는 경우, 결재를 중단 (문서번호 부여 이전이므로, 롤백 함수 실행 없이 바로 false를 리턴)
				if (isHWP == "Y") {
					if (!HwpCtrl.CheckFieldExist(name)) {
						if (name == "bedocnumber") { // 기안 시 사용할 수 있는 bedocnumber 필드의 경우, 없으면 그대로 기안 진행
							return true;
						} else {
							return false;
						}
					}
					
					fractionsymbol = HwpCtrl.GetFieldText(name);
				} else {
					fields = message.GetFieldsList();
					
		        	var field = message.GetListItem(fields, name);
		        	if (!field) {
						if (name == "bedocnumber") {
							return true;
						} else {
							return false;
						}
		        	}
		        	
		        	fractionsymbol = field.textContent;
				}
			}
			
			if (nonElecRec == "Y") {
				if (pDraftFlag == "SUSIN") {
					var result = getCabinetSN(pDeptID);
	    			var dataNodes = GetChildNodes(loadXMLString(result));
	    	    	SN = getNodeText(dataNodes[0]);
				} else {
					SN = fractionsymbol;
				}
			} else {
				var result = getCabinetSN(pDeptID);
				var dataNodes = GetChildNodes(loadXMLString(result));
		    	SN = getNodeText(dataNodes[0]);
			}
			
			if (SN == "") {
				DocNumCode = "";
	            return false;
			} else {
				if (isHWP == "Y") {
					if (nonElecRec == "Y") {
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
			        			
			        			HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + tempNumString);
			        		} else {
			        			HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + tempNumString);
			        		}
						} else {
							DocNumCode = SN;
						}
					} else {
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
		        			
		        			HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + tempNumString);
		        		} else {
		        			HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + tempNumString);
		        		}
					}
					
					if (pDraftFlag == "SUSIN" && useReceiveDocNo == "NO") {
						if (HwpCtrl.CheckFieldExist("receiptdate")) {
							if (trim(HwpCtrl.GetFieldText("receiptdate")) == "") {
								HwpCtrl.SetFieldText("receiptdate", getGyulJeDate());
							}
						}
					} else {
						if (HwpCtrl.CheckFieldExist("enforcedate")) {
							if (trim(HwpCtrl.GetFieldText("enforcedate")) == "") {
								HwpCtrl.SetFieldText("enforcedate", getGyulJeDate());
							}
						}
					}
					
					return true;
				} else {
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
	        			
	        			field.textContent = fractionsymbol + tempNumString;
	        		} else {
	        			field.textContent = fractionsymbol + tempNumString
	        		}
        			
        			message.DocumentBodySetAttribute("regnumbercode", tempNumString);
        			message.DocumentBodySetAttribute("deptid", pDeptID);
        			
        			var field = message.GetListItem(fields, "enforcedate");
        			
        			if (pDraftFlag == "SUSIN" && useReceiveDocNo == "NO") {
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
		} else {
			/* 2022-08-22 홍승비 - 문서번호 필드가 없으면 문서번호 부여 로직이 스킵되어 결재가 정상 진행되는 분기 오류 수정 (파일 백지화 현상과도 관련있음) */
			fields = message.GetFieldsList();
        	var field = message.GetListItem(fields, name);
        	if (!field) {
				if (name == "bedocnumber") { // 기안 시 사용할 수 있는 bedocnumber 필드의 경우, 없으면 그대로 기안 진행
					return true;
				} else {
					return false; // 문서번호 부여 로직 이전이므로, 롤백 함수 실행 없이 바로 false를 리턴
				}
        	}
        	
        	fractionsymbol = field.textContent;
        	
			if (pDraftFlag == "HABYUI" || pDraftFlag == "HAPYUI") {
				if(approvalFlag == "S") {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezApprovalG/getChaebunDept.do",
						data : {
							deptID : pDeptID,
							orgCompanyID : orgCompanyID
						},
						success: function(xml){
							result = xml;
							if(result != null) {
								dataNodes = GetChildNodes(loadXMLString(result).documentElement);
								fractionsymbol = getNodeText(dataNodes[0]) + "-";
								pDeptID = getNodeText(dataNodes[2]);
							}
						}        			
					});
				} else {
					fractionsymbol = arr_userinfo[5] + "-";
				}
			}
        	
        	var result = getCabinetSN(pDeptID);
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
		}
	} catch (e) {
		if (SN != "") {
			if (isHWP == "Y") {
				HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + SN);
			} else {
				field.textContent = fractionsymbol + SN;
			}
			rollbackDocNumber(pDeptID, pPrefix, pDocID);
        	return false;
		}
	}
}
function rollbackDocNumber(pDeptID, pPrefix, pDocID) {
    try {
        var name, docnumber;
		var rtnval;
		if (!pPrefix) {
			pPrefix = "doc";
		}
        name = pPrefix + "number";
        
        if (isHWP == "Y") {
            if (!HwpCtrl.CheckFieldExist(name))
                return true;

            docnumber = HwpCtrl.GetFieldText(name);
        } else {
        	var fields = message.GetFieldsList();
        	var field = message.GetListItem(fields, name);
        	if (!field) return true;
        	
        	docnumber = field.textContent;
        }
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
        
        if (isHWP == "Y") {
        	HwpCtrl.SetFieldText(name, fractionsymbol);
        } else {
        	field.textContent = fractionsymbol;
        }

        if (rtnval == "FALSE") {
            DocNumCode = "";
        }
        else {
            DocNumCode = "";
        }
    } catch (e) {
    	if (isHWP == "Y") {
    		HwpCtrl.SetFieldText(name, fractionsymbol);
    	} else {
    		field.textContent = fractionsymbol;
    	}
    }
}

function getCabinetSN(pDeptID) {
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
