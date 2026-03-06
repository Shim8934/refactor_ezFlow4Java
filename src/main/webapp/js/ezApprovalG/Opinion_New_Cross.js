/*
 * 2019-04-17 천성준
 * Opinion_New_Cross.js 작성
 */

/*
 * 의견리스트 정보 init
 */
function initOpinionInfo() {
	try {
		var objXML = createXmlDom();
		
		/*if (pMode == "END") { // 완료문서에서 의견리스트 가져올수 있도록 분기처리 주석처리
			objXML = getEndOpinionList();
		} else {*/
			objXML = getOpinionList();
		//}
		
		document.getElementById("lvOpinionList").innerHTML = "";
		
		var OpinionList = new ListView();
		OpinionList.SetID("OpinionList");
		OpinionList.SetRowOnClick("OpinionOnSelChange_onclick");
		OpinionList.SetRowOnDblClick("OpinionOnSelChange_ondbclick");
		OpinionList.SetMulSelectable(false);
		OpinionList.SetSelectFlag(true);
		OpinionList.DataSource(objXML);
		OpinionList.DataBind("lvOpinionList");
		
		OpinionOnSelChange_onclick();
	} catch (e) {
		alert("initOpinionInfo ::" + e.description);
	}
}

/*
 * 진행문서 의견 리스트
 * return : 의견리스트 (xmlDom)
 */
var oldOpinionList = "";
function getOpinionList(chkFlag) {
	try {
    	var result = "";
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/opinionRequest.do",
    		data : {
    			docID : pDocID,
    			orgCompanyID : pOrgCompanyID,
				state : pMode
    		},
    		success: function(xml){
    			result = xml;
    			if (typeof chkFlag == 'undefined' || chkFlag != "Y") {
    			    oldOpinionList = xml;
    			}
    		}        			
    	});
    	
        if (typeof chkFlag == 'undefined' || chkFlag != "Y") {
            return loadXMLString(result);        
        } else {
            return result;
        }
    } catch (e) {
        alert("getOpinionList ::" + e.description);
    }
}

/*
 * 완료문서 의견 리스트
 * return : 의견리스트 (xmlDom)
 */
function getEndOpinionList() {
	try {
		var rtnVal = "";
		
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/getEndOpinionInfo.do",
			data : {
				docID : pDocID,
				orgCompanyID : pOrgCompanyID
			},
			success : function(xml) {
				rtnVal = xml;
			}
		});
		
		return loadXMLString(rtnVal);
	} catch (e) {
		alert("getEndOpinionList :: " + e.description);
	}
}

/*
 * [진행, 완료] 상태 조회
 * return : APR, END (String)
 * default : APR
 */
function getDocMode() {
	var rtnVal = "APR";
	
	try {
		$.ajax({
 			type : "POST",
 			dataType : "text",
 			async : false,
 			url : "/ezApprovalG/getLineMode.do",
 			data : {
 					docID : pDocID,
 					orgCompanyID : pOrgCompanyID
 					},
 			success: function(result) {
 				rtnVal = result;
 			}        			
        });
	} catch (e) {
		alert("getDocMode() :: " + e.description);
	}
	
	return rtnVal;
}

/*
 * 의견팝업 오픈 타입
 * parameter : 공백, BanSong, BoRyu, HeSong, ReBebu (String)
 * return : 001, 002, 003, 004, 008 (String)
 * default : 001
 */
function getOpinionType(para) {
	var rtnVal = strOpinionType1;
	var pParameter = para.toUpperCase();
	/* 2023-06-26 민지수 - row에 보여질 의견 타입 추가 */
	if (pParameter == "") {
		rtnVal = strOpinionType1;	//일반의견
	} else if (pParameter == "ADD") {
		rtnVal = strOpinionType0;	//추가의견
	} else if (pParameter == "BANSONG") {
		rtnVal = strOpinionType2;	//반송의견
	} else if (pParameter == "BORYU") {
		rtnVal = strOpinionType3;	//보류의견
	} else if (pParameter == "HESONG") {
		rtnVal = strOpinionType4;	//회송의견
	} else if (pParameter == "REBEBU") {
		rtnVal = strOpinionType8;	//재배부요청의견
	}
	
	return rtnVal;
}

/*
 * 의견리스트 중 가장 첫번째 Row를 보여주는 함수. Row가 없다면 [데이터없음] 표출
 */
function showFirstOpinionRow() {
	try {
		var OpinionList = new ListView();
	    OpinionList.LoadFromID("OpinionList");
    
	    if (OpinionList.GetDataRows().length > 0) {
	    	OpinionList.SetSelectedID(OpinionList.GetSelectedRowID(0));
	    	OpinionOnSelChange_onclick();
	    } else {
	    	var objTr = document.createElement("TR");
	    	objTr.setAttribute("id", "OpinionList_TR_noItems");
	    		
	    	var oText = document.createTextNode(strLang944);
	    	var objTd = document.createElement("TD");
	    	objTd.align = "center";
	
	    	var colCount = document.getElementById("OpinionList").getElementsByTagName("th").length;
	    	objTd.setAttribute("colSpan", colCount);
	    	objTd.appendChild(oText);
	    	objTr.appendChild(objTd);
	
	    	document.getElementById("OpinionList").appendChild(objTr);
	    	document.getElementById("txt_OpinionContent").disabled = "disabled";
	    }
    } catch (e) {
    	alert("showFirstOpinionRow :: " + e.description);
    }
}

/*
 * 의견List Row추가 함수
 * parameter : 의견내용 (String)
 * return : 결괏값 'TRUE','FALSE' (String)
 */
function addOpinionContent(pOpContent) {
	var result = "";

	try {
		var objXML = createXmlDom();
		objXML = getAprOpinionXML(pOpContent);
		
		var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");
        
        var pTotalRows = OpinionList.GetDataRows();
        if (pTotalRows[0].id.indexOf("noItems") > 0) {
        	document.getElementById("lvOpinionList").innerHTML = "";
        	
        	OpinionList.SetRowOnClick("OpinionOnSelChange_onclick");
        	OpinionList.SetRowOnDblClick("OpinionOnSelChange_ondbclick");
        	OpinionList.SetMulSelectable(false);
        	OpinionList.SetSelectFlag(false);
        	OpinionList.DataSource(objXML);
        	OpinionList.DataBind("lvOpinionList");
        } else {
        	var maxIdx = 0;
        	for (var i = 0; i < pTotalRows.length; i++) {
        		var rowID = OpinionList.GetSelectedRowID(i);
        		var rowIdx = Number(rowID.substring(rowID.lastIndexOf('_') + 1));
        		if (maxIdx < rowIdx) {
        			maxIdx = rowIdx;
        		}
        	}
        	
        	var objTr = OpinionList.NewAddRow(0, "OpinionList_TR_" + (maxIdx + 1));
        	OpinionList.AddDataRow(objTr, objXML);
        }
        
        showFirstOpinionRow();
        ModifiedFlag = true;
        result = "TRUE";
	} catch (e) {
		alert("addOpinionContent :: " + e.description);
		result = "FALSE";
	}
	return result;
}

/*
 * 의견List Row수정 함수
 * parameter : 의견내용 (String)
 * return : 결괏값 'TRUE','FALSE' (String)
 */
function modOpinionContent(pOpContent) {
	var result = "";
	
	try {
		var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");
        
        var pSelectedRow = OpinionList.GetSelectedRows();
        if (pSelectedRow.length > 0) {
        	pSelectedRow[0].setAttribute("DATA3", pOpContent);
        	
        	OpinionOnSelChange_onclick();
        	ModifiedFlag = true;
        	result = "TRUE";
        }
	} catch (e) {
		alert("modOpinionContent :: " + e.description);
		result = "FALSE";
	}
	return result;
}

/*
 * 의견List Row삭제 함수_1
 */
function deleteOpinionInfo() {
	var OpinionList = new ListView();
    OpinionList.LoadFromID("OpinionList");
    
    var pSelectedRow = OpinionList.GetSelectedRows();
    if (pSelectedRow.length > 0) {
    	var pInformationContent = strLang406;
    	OpenInfoUI(pInformationContent, deleteOpinionInfo_complete);
    	return;
    }
}

/*
 * 의견List Row삭제 함수_2
 * parameter : boolean
 */
function deleteOpinionInfo_complete(ret) {
	DivPopUpHidden();
	if (ret) {
		var OpinionList = new ListView();
		OpinionList.LoadFromID("OpinionList");
		
		var pSelectedRow = OpinionList.GetSelectedRows();
		var selIdx = GetAttribute(pSelectedRow[0], "id");
		
		OpinionList.DeleteRow(selIdx);
		document.getElementById("txt_OpinionContent").value = "";
		
		/* 2020-04-02 홍승비 - 신규작성한 반송, 보류, 회송의견 삭제 시 버튼표출 플래그값 수정 */
		if (GetAttribute(pSelectedRow[0], "ISNEWBBHOPINION") != null && GetAttribute(pSelectedRow[0], "ISNEWBBHOPINION") == "true") {
	        if (typeof(isNewBBHOpinionFlag) != "undefined" && isNewBBHOpinionFlag != null) {
	        	isNewBBHOpinionFlag = false;
	        }
		}
		
		ModifiedFlag = true;
		showFirstOpinionRow();
		displayButtons();
	}
}

/*
 * 의견정보 DB데이터 추가 함수
 */
function saveOpinionInfo() {
	try {
	    // 개인병렬에 의해 동시 의견 변경시, 앞선 의견이 삭제되는 경우가 있어 일반의견 저장시 변경사항 체크하도록 함
	    if (typeof pOpinionType != 'undefined' && pOpinionType == "001" && oldOpinionList != "") {
	        var nowOpinionList = getOpinionList("Y");
	        if (nowOpinionList != oldOpinionList) {
                var pAlertContent = strLangKYJ01;
                OpenAlertUI(pAlertContent);
                return;
	        }
	    }
	
		var OpinionList = new ListView();
		OpinionList.LoadFromID("OpinionList");
		
		var pTotalRows = OpinionList.GetDataRows();
		if (pTotalRows[0].id.indexOf("noItems") == -1) {
			var objXML = createXmlDom();
			objXML = getOpinionListInfo();
			
			var xmlhttp = new createXMLHttpRequest();
			/* 2023-06-26 민지수 - 완료문서 구분을 위한 pMode 전달 */
	        xmlhttp.open("POST", "/ezApprovalG/opinionSave.do?orgCompanyID=" + pOrgCompanyID + "&isSihangReject=" + isSihangReject + "&pMode="+ pMode, false);
	        xmlhttp.send(objXML);
	        
	        var RtnVal = xmlhttp.responseText;
	        if (xmlhttp != null && xmlhttp.readyState == 4) {
	        	if (xmlhttp.status == 200 && RtnVal == "TRUE") {
	        		if (ReturnFunction != null) {
	        			ReturnFunction(getXmlString(objXML));
	                    window.close();
	                } else {
	                	window.returnValue = getXmlString(objXML);
	                	window.close();
	                }
	        		return;
	        	} else {
					var pAlertContent = strLang417;
					OpenAlertUI(pAlertContent);
					return;
	        	}
	        }
		} else {
			var Rtnval = removeOpinionInfo();
			if (Rtnval != "TRUE") {
                var pAlertContent = strLang199;
                OpenAlertUI(pAlertContent);
                return;
            } else {
            	var ReturnVal = "";
            	if (pOpinionType == "001") {
            		ReturnVal = "Clear";
            	} else {
            		ReturnVal = "cancel";
            	}
            	
				// 2021.12.17 - 강승구 : (#89657) 결재문서 의견란 오류
				if(typeof(parent.pHasOpinionYN) != 'undefined') {
					parent.pHasOpinionYN = 'N';
				}

            	if (ReturnFunction != null) {
            		ReturnFunction(ReturnVal);
            		window.close();
            	} else {
            		window.returnValue = ReturnVal;
            		window.close();
            	}
            }
		}
	} catch (e) {
		console.log(e);
		alert("saveOpinionInfo :: " + e.description);
	}
}

/*
 * 의견정보 DB데이터 삭제 함수
 * return : 'TRUE', 'FALSE' (String)
 */
function removeOpinionInfo() {
	try {
		var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/opinionDel.do",
		data : {
			docID : pDocID,
			isSihangReject : isSihangReject,
			pMode : pMode
		},
		success: function(text){
			result = text;
		},
		error : function () {
			result = "FALSE";
			}
		});
	    
	    return result;
	} catch (e) {
	    alert("removeOpinionInfo :: " + e.description);
	}
}

/*
 * 의견내용 XML 가공
 * parameter : 의견내용 (String)
 * return : XML 처리된 의견내용 (XmlDom)
 */
function getAprOpinionXML(pOpContent) {
	var ppUserID = pUserID;
	var ppUserTitle = pUserTitle;
	var ppUserTitle2 = pUserTitle2;
	var ppUserDeptID = pUserDeptID;
	var ppUserDeptName = pUserDeptName;
	var ppUserDeptName2 = pUserDeptName2;
	var ppUserDisplayName = pUserDisplayName;
	var ppUserDisplayName2 = pUserDisplayName2;
	var ppUserCompanyID = pUserCompanyID;
	
	if (pDraftFlag == "") {
		try {
			var xmldom = createXmlDom();
			var resultXML = "";
			
			$.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/aprLineRequest.do",
	    		data : {
	    			docID : pDocID,
	    			userID : ppUserID,
	    			formID : "",
	    			isUsed   : "",
	    			mode     : "",
	    			orgCompanyID : pOrgCompanyID
	    		},
	    		success: function(xml){
	    			resultXML = xml;
	    		}        			
	    	});
			
			xmldom = loadXMLString(resultXML);
			objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
	        count = objNodes.length - 1;
	
	        for (var i = count; i >= 0; i--) {
	            var cell = GetChildNodes(objNodes[i]);
	            var cellzero = GetChildNodes(cell[0]);
	            var KyljeaUserID = getNodeText(cellzero[4]);
	            var KyljeaAprState = getNodeText(cellzero[12]);
	            
	            if (KyljeaUserID == pUserID && (KyljeaAprState == strAprState2 || KyljeaAprState == strAprState5)) {
	            	ppUserDeptID = getNodeText(cellzero[6]);
	            	ppUserDeptName = getNodeText(cell[3]);
	            	ppUserDeptName2 = getNodeText(cellzero[16]);
	            	ppUserTitle = getNodeText(cell[2]);
	            	ppUserTitle2 = getNodeText(cellzero[18]);
	                break;
	            }
	        }
		} catch (e) {
			alert("getAprOpinionXML_1 :: " + e.description);
		}
	}
	
	try {
		var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");
        
        var pTotalRows = OpinionList.GetDataRows();
        var pOpinionLen = OpinionList.GetRowCount();
        
        if (pOpinionLen == 1 && pTotalRows[0].id.indexOf("noItems") > -1) {
        	pOpinionLen = 0;
        }
        
        var pAddIndex = pOpinionLen + 1;

        var HEADERS;
        var HEADER;
        var NAME;
        var WIDTH;
        var ROWS;
        var ROW;
        var CELL;
        var CELLVALUE;
        var CELLDATA;
        var objRoot;

        var objXML = createXmlDom();

        objRoot = createNodeInsert(objXML, objRoot, "LISTVIEWDATA");
        HEADERS = createNodeAndAppandNode(objXML, objRoot, HEADERS, "HEADERS");
        
        HEADER = createNodeAndAppandNode(objXML, HEADERS, HEADER, "HEADER");
        createNodeAndAppandNodeText(objXML, HEADER, NAME, "NAME", strLang31);
        createNodeAndAppandNodeText(objXML, HEADER, WIDTH, "WIDTH", "55");

        HEADER = createNodeAndAppandNode(objXML, HEADERS, HEADER, "HEADER");
        createNodeAndAppandNodeText(objXML, HEADER, NAME, "NAME", strLang29);
        createNodeAndAppandNodeText(objXML, HEADER, WIDTH, "WIDTH", "100");

        HEADER = createNodeAndAppandNode(objXML, HEADERS, HEADER, "HEADER");
        createNodeAndAppandNodeText(objXML, HEADER, NAME, "NAME", strLang28);
        createNodeAndAppandNodeText(objXML, HEADER, WIDTH, "WIDTH", "100");

        HEADER = createNodeAndAppandNode(objXML, HEADERS, HEADER, "HEADER");
        createNodeAndAppandNodeText(objXML, HEADER, NAME, "NAME", strLang32);
        createNodeAndAppandNodeText(objXML, HEADER, WIDTH, "WIDTH", "100");

        ROWS = createNodeAndAppandNode(objXML, objRoot, ROWS, "ROWS");
        ROW = createNodeAndAppandNode(objXML, ROWS, ROW, "ROW");
        CELL = createNodeAndAppandNode(objXML, ROW, CELL, "CELL");

        createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", getOpinionTypeName(pOpinionType));
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA1",  pDocID);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA2",  ppUserID);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA3",  pOpContent);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA4",  ppUserDeptID);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA5",  pAddIndex);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA6",  pOpinionType);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA7",  ppUserDisplayName);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA8",  ppUserDisplayName2);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA9",  ppUserTitle);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA10", ppUserTitle2);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA11", ppUserDeptName);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA12", ppUserDeptName2);
        /* 2020-04-02 홍승비 - 신규 작성된 반송, 보류, 회송의견 판별용 데이터 추가 */
        if (typeof(isNewBBHOpinionFlag) != "undefined" && isNewBBHOpinionFlag != null) {
        	createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "ISNEWBBHOPINION", isNewBBHOpinionFlag);
        }

        /* 2020-08-06 홍승비 - 전자결재 의견작성 후 저장 > 의견 리스트에 작성한 의견 표출 시 다국어 대응하도록 수정 */
        CELL = createNodeAndAppandNode(objXML, ROW, CELL, "CELL");
        if (primary == "1") {
        	createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", ppUserDisplayName);
        } else {
        	createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", ppUserDisplayName2);
        }
        
        CELL = createNodeAndAppandNode(objXML, ROW, CELL, "CELL");
        if (primary == "1") {
        	createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", ppUserTitle);
        } else {
        	createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", ppUserTitle2);
        }
        
        CELL = createNodeAndAppandNode(objXML, ROW, CELL, "CELL");
        if (primary == "1") {
        	createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", ppUserDeptName);
        } else {
        	createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", ppUserDeptName2);
        }
        
        return objXML;
	} catch (e) {
		alert("getAprOpinionXML_2 ::" + e.description);
	}
}

/*
 * 의견정보 XML 가공 (저장)
 * return : XML 처리된 의견내용 (XmlDom)
 */
function getOpinionListInfo() {
	try {
		var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");
        
        var pTotalRows = OpinionList.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;
        var pTotalColsLen = pTotalRows[0].cells.length;
        
        var HEADERS;
        var ROWS;
        var ROW;
        var COLUMN;
        var COLUMNDATA;
        var objRoot;
        
        var objXML = createXmlDom();
        
        objRoot = createNodeInsert(objXML, objRoot, "LISTVIEWDATA");
        HEADERS = createNodeAndAppandNode(objXML, objRoot, HEADERS, "HEADERS");
        ROWS = createNodeAndAppandNode(objXML, objRoot, ROWS, "ROWS");
        
        for (i = 0 ; i < pTotalRowsLen ; i++) {
            ROW = createNodeAndAppandNode(objXML, ROWS, ROW, "ROW");

            var tr = pTotalRows[i];

            for (j = 0 ; j < pTotalColsLen ; j++) {
                createNodeAndAppandNodeText(objXML, ROW, COLUMN, "COLUMN", tr.cells[j].innerText);
            }
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "DocID", trim_Cross(GetAttribute(tr, "DATA1")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserID", trim_Cross(GetAttribute(tr, "DATA2")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "Content", trim_Cross(GetAttribute(tr, "DATA3")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserDeptID", trim_Cross(GetAttribute(tr, "DATA4")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "OpinionSN", trim_Cross(GetAttribute(tr, "DATA5")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "OpinionGB", trim_Cross(GetAttribute(tr, "DATA6")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserName", trim_Cross(GetAttribute(tr, "DATA7")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserName2", trim_Cross(GetAttribute(tr, "DATA8")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserJobTitle", trim_Cross(GetAttribute(tr, "DATA9")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserJobTitle2", trim_Cross(GetAttribute(tr, "DATA10")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserDeptName", trim_Cross(GetAttribute(tr, "DATA11")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserDeptName2", trim_Cross(GetAttribute(tr, "DATA12")));
        }
        
        return objXML;
	} catch (e) {
		alert("getOpinionListInfo :: " + e.description);
	}
}

/*
 * 의견 타입 이름
 * parameter : 000, 001, 002, 003, 004, 008 (String)
 * retrun : 일반의견, 반송의견, 보류의견, 회송의견, 재배부요청 (String)
 */
/* 2023-06-26 민지수 - 완료문서 의견타입 추가 */
function getOpinionTypeName(strOType) {
	switch (strOType) {
		case strOpinionType2:
			return strLangOpinionType2;	//반송
			break;
		case strOpinionType3:
			return strLangOpinionType3;	//보류
			break;
		case strOpinionType4:
			return strLangOpinionType4;	//회송
			break;
		case strOpinionType1:
			return strLangOpinionType1;	//일반
			break;
		case strOpinionType8:
			return strLangOpinionType8;	//재배부요청
			break;
		case strOpinionType0:
			return strLangOpinionType0; //추가
			break;
		default:
			return strLangOpinionType1;	//일반
			break;
    }
}

/*
 * Layer Alert
 * parameter : String, function
 */
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
/*
 * Layer Alert Complete
 */
function OpenAlertUI_Complete() {
    DivPopUpHidden();
}

/*
 * Layer Information Alert
 * parameter : String, function
 */
var ezapropinion_cross_dialogArguments = new Array();
function OpenInfoUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";
    
    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInfoUI_Complete;
        DivPopUpShow(330, 205, url);
    } else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}
/*
 * Layer Information Alert Complete
 */
function OpenInfoUI_Complete() {
    DivPopUpHidden();
}