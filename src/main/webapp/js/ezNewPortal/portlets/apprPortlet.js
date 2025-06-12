var absence = getAbsence();

var getApprovalList = function(type, portletId) {
	
	if (!!absence) {
		var docsHTML = "<dl class='nodata' '>";
		docsHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
		docsHTML += '<dd>';
		docsHTML += absence
		docsHTML += (messages.apprPortlet001 + '</dd>');
		docsHTML += '<br>';
		docsHTML += '<a onclick="popAskAbsence()"; style="cursor:pointer;">' + messages.apprPortlet002 + '</a>';
		docsHTML += "</dl>";

		document.getElementById('ApprList' + portletId).innerHTML = docsHTML;
		return;
	}

	var request = new XMLHttpRequest();
	request.open('POST', '/ezNewPortal/getApprovalList.do', true);
	request.setRequestHeader('Content-Type', 'application/json');

	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			var result = JSON.parse(request.responseText);
			
			var docList = result.resultList;
			var imgPath = result.imgPath;
			var docsHTML = "";
			
			if (!!docList && docList.length > 0) {
				switch (type) {
				case "doing":
					docList.forEach(function(item, index) {
                        if (index === 0) {
                            docsHTML += dataAssemblerApprLine(item, result.aprLines0, result.imgPath);
                        } else if (index === 1) {
                            docsHTML += dataAssemblerApprLine(item, result.aprLines1, result.imgPath);
                        } else if (index === 2) {
                            docsHTML += dataAssemblerApprLine(item, result.aprLines2, result.imgPath);
                        }
                    });
						
	                break;

	            case "reject":
					docList.forEach(function(item, index) {
						docsHTML += dataAssembler(item);
					});
					
	                break;

	            case "draft":
					docList.forEach(function(item, index) {
						docsHTML += dataAssembler(item);
					});
	            	
	                break;
	                
	            case "display":
	            	docList.forEach(function(item, index) {
	            		docsHTML += dataAssembler(item);
	            	});
	            	
	            	break;
				}
			} else {
				docsHTML += "<dl class='nodata'>";
				docsHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
				docsHTML += '<dd>' + messages.apprPortlet003 + '</dd>';
				docsHTML += "</dl>";
			}
			
			document.getElementById('ApprList' + portletId).innerHTML = docsHTML;
		} else {
			// We reached our target server, but it returned an error
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	var data = JSON.stringify({
		type : type
	});
	
	request.send(data);
}

var apprChangeTab = function(obj, portletId) {
	var type = "";
	
    switch (obj.id) {
    case "doingTab":
    	//1
    	type = "doing";
        document.getElementById("doingTab").className = "on";
        document.getElementById("rejectTab").className = "";
        document.getElementById("draftTab").className = "";
        break;

    case "rejectTab":
    	//4
    	type = "reject";
        document.getElementById("doingTab").className = "";
        document.getElementById("rejectTab").className = "on";
        document.getElementById("draftTab").className = "";
        break;

    case "draftTab":
    	//2
    	type = "draft";
        document.getElementById("doingTab").className = "";
        document.getElementById("rejectTab").className = "";
        document.getElementById("draftTab").className = "on";
        break;
    }
    
    var portletNum = apprPortletIDs.indexOf(portletId);
    apprPortletTypes[portletNum] = type;
    
    getApprovalList(type, portletId);
}

var Appmore_btnClick = function(portletId) {
	var portletNum = apprPortletIDs.indexOf(portletId);
	type = apprPortletTypes[portletNum];
    
    if (type == 'doing') {
    	window.open("/ezApprovalG/apprGMain.do?listType=1", "main");
    } else if (type == 'display') {
    	window.open("/ezApprovalG/apprGMain.do?listType=99", "main");
    } else if (type == 'reject') {
        window.open("/ezApprovalG/apprGMain.do?listType=24", "main");
    } else {
    	window.open("/ezApprovalG/apprGMain.do?listType=2", "main");
    }
	
}

var dataAssembler = function(object) {
	var str = "";
	
	str += '<li onclick=\'opendocview("'+ object.docID +'", "'+ object.href +'", "'+ object.aprMemberID +'", "'+ object.aprMemberName +'", "'+ object.aprMemberDeptID +'", "'+ object.docState +'", "'+ object.functionType +'", "'+ object.companyID +'")\'>';
	str += '	<span class="txt">'+ ConvertCharToEntityReference(object.docTitle) +'</span>';
	str += '	<span class="date">'+ object.startDate.substr(5, 11).replace(/-/gi,'.')+'</span>';				
	str += '	<span class="name">'+ object.writerName +'</span>';
	str += '</li>';
	
	return str;
}

var dataAssemblerApprLine = function(object, lines, imgPath) {
	var listSize = lines.length > 3 ? 3 : lines.length;
    var str = "";
    
    str += '<li class="first_approval" onclick=\'opendocview("'+ object.docID +'", "'+ object.href +'", "'+ object.aprMemberID +'", "'+ object.aprMemberName +'", "'+ object.aprMemberDeptID +'", "'+ object.docState +'", "'+ object.functionType +'", "'+ object.companyID +'")\'>';
    str += '	<p class="approval_tit">'
    str += '	<span class="txt">'+ ConvertCharToEntityReference(object.docTitle) +'</span><span class="date">'+ object.startDate.substr(5, 11).replace(/-/gi, ".") +'</span><span class="name">'+ object.writerName +'</span></p>';
    str += '	<div class="approval_content">';
    
    for(var i=0; i<listSize; i++){
        console.log("img", lines[i].ext2);
        var imgsrc = lines[i].ext2 !== null && lines[i].ext2 !== '' ? "/ezCommon/downloadAttach.do?filePath=" + imgPath + "/" + lines[i].ext2 : "/images/ezNewPortal/info_pic_none.png";
        var apprTextColor = "";
        
        // 승인 003, 진행 002, 대기, 001
        if(lines[i].aprState === "003") {
            apprTextColor = "apprText_blue";
        } else if (lines[i].aprState === "002") {
            apprTextColor = "apprText_green";
        } else if (lines[i].aprState === "001") {
            apprTextColor = "apprText_orange";
        } else {
            apprTextColor = "apprText_blue";
        }
        
        str += '		<dl class="apprDL">';
        str += '			<dt class="apprPic"><img src="'+ imgsrc +'"></dt>';
        str += '			<dd class="apprName">';
        
     	// 2023-07-28 황인경 - 포탈 > 전자결재 포트릿  > 결재선 > 이름 다국어 지원 추가
		var lang = userLang;
		
        if (lang != "1") {
        	str += lines[i].aprMemberName2 +'</dd>';	
        } else {
        	str += lines[i].aprMemberName +'</dd>';	
        }
        
        if(i==0) {
            str += '			<dd class="'+ apprTextColor +'"><span>' + messages.apprPortlet004 + '</span></dd>';
        } else {
            str += '			<dd class="'+ apprTextColor +'"><span>'+ lines[i].ext1 +'</span></dd>';
        }
        str += '		</dl>';			
        
        if(i !== listSize-1) {
            str += '		<p class="appr_arrow"><img src="/images/kr/main/approval_arrow.png"></p>';	
        }			    	
    }
    
    str += '	</div>';
    str += '</li>';   	
    
    return str;
}

/** 결재 오픈 */
function opendocview(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
    var openLocation = "";
    var selectedTapId = document.querySelector("div.layDIV.approval dl.portlet_tab dt.on").id;
	
    if (selectedTapId != "draftTab") {
        if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
            if (pDocState == "012" || pDocState == "014" || pDocState == "018") {
                OpenReceiveDraftUI(pDocID, pHref, "REDRAFT");
            } else if (pFunctionType == "004" && companyID != orgCompanyID) {
        		var pAlertContent = messages.apprPortlet005;
                alert(pAlertContent);
                return;
            } else {
                openApprDraftUI("REDRAFT", pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
            }
        } else {
            openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
        }
    } else {
        openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
    }
}

function openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
    var pArgument = new Array();
    var formURL = pHref;
    var DocID = pDocID;
    pArgument[0] = DocID;
    pArgument[1] = formURL;
    pArgument[2] = "";
    pArgument[3] = pDocState;
    pArgument[4] = "";
    pArgument[5] = "";
    pArgument[6] = "OPINION_SHOW";
    pArgument[7] = "2";
    pArgument[8] = orgCompanyID;
    
    var openLocation;
    
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
        openLocation = "/myoffice/ezApprovalG/ezViewWord/ezViewApr_Word_Cross.aspx?DocID=" + encodeURIComponent(pArgument[0]) + "&DocHref=" + encodeURIComponent(pArgument[1]);
        openLocation += "&OpinionFlag=" + encodeURIComponent(pArgument[2]) + "&docState=" + encodeURIComponent(pArgument[3]) + "&ListSusin=" + encodeURIComponent(pArgument[4]) + "&odoc=" + encodeURIComponent(pArgument[5]);
        openLocation += "&isOpinion=" + encodeURIComponent(pArgument[6]);
        openLocation += "&ListType=" + encodeURIComponent(pArgument[7]);
    }
    else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
    	if (useWebHWP == "NO") {
        	if (isIE()) {
                openLocation = "/ezApprovalG/ezviewAprHWP.do?docID=" + encodeURIComponent(pArgument[0]) + "&docHref=" + encodeURIComponent(pArgument[1]);
                openLocation += "&opinionFlag=" + encodeURIComponent(pArgument[2]) + "&docState=" + encodeURIComponent(pArgument[3]) + "&listSusin=" + encodeURIComponent(pArgument[4]) + "&odoc=" + encodeURIComponent(pArgument[5]);
                openLocation += "&isOpinion=" + encodeURIComponent(pArgument[6]);
                openLocation += "&listType=" + encodeURIComponent(pArgument[7]);
        	} else {
        		var pAlertContent = messages.apprPortlet006;
                alert(pAlertContent);
                
                return;
        	}
    	} else {
    		var isGroupDoc = checkIsGroupDoc(encodeURIComponent(pArgument[0]), encodeURIComponent(pArgument[8]));
    		
    		if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우
    			openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do?docID=" + encodeURIComponent(pArgument[0]) + "&docHref=" + encodeURIComponent(pArgument[1]);
    		} else {
    			openLocation = "/ezApprovalG/ezviewAprWHWP.do?docID=" + encodeURIComponent(pArgument[0]) + "&docHref=" + encodeURIComponent(pArgument[1]);
    		}
    		
            openLocation += "&opinionFlag=" + encodeURIComponent(pArgument[2]) + "&docState=" + encodeURIComponent(pArgument[3]) + "&listSusin=" + encodeURIComponent(pArgument[4]) + "&odoc=" + encodeURIComponent(pArgument[5]);
            openLocation += "&isOpinion=" + encodeURIComponent(pArgument[6]);
            openLocation += "&listType=" + encodeURIComponent(pArgument[7]);
    	}
    } else {
        var isGroupDoc = checkIsGroupDoc(encodeURIComponent(pArgument[0]), encodeURIComponent(pArgument[8]));

        if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우
            openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do?docID=" + encodeURIComponent(pArgument[0]) + "&docHref=" + encodeURIComponent(pArgument[1]);
        } else {
            openLocation = "/ezApprovalG/aprDocView.do?docID=";
            openLocation += encodeURIComponent(pArgument[0]) + "&docHref=" + encodeURIComponent(pArgument[1]);
        }
        openLocation += "&opinionFlag=" + encodeURIComponent(pArgument[2]) + "&docState=" + encodeURIComponent(pArgument[3]) + "&ListSusin=" + encodeURIComponent(pArgument[4]) + "&odoc=" + encodeURIComponent(pArgument[5]);
        openLocation += "&isOpinion=" + encodeURIComponent(pArgument[6]);
        openLocation += "&listType=" + encodeURIComponent(pArgument[7]);
        openLocation += "&orgCompanyID=" + encodeURIComponent(pArgument[8]);
    }

    openwindow(openLocation, "", 880, 570);
}

function openApprDraftUI(pDraftFlag, pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
    var pArgument = new Array();
    var formURL = pHref;
    
    pArgument[0] = userID;
    pArgument[1] = pHref;
    pArgument[2] = pDraftFlag;
    pArgument[3] = "";
	
    if (CheckFormConnFlag(pDocID, orgCompanyID)) {
        var pAlertContent = messages.apprPortlet007;
        //OpenAlertUI(pAlertContent);
        alert(pAlertContent);
        return;
    }
    
    var openLocation = "";
    var tempDocState = "001";
    var SusinSn = "0";
    
    if (pDocState == "011") {
        tempDocState = "011";
        SusinSn = "1";
    }

    var AprState = "004";
    
    if (pFunctionType == "006")
        AprState = "006";
   
    pArgument[4] = SusinSn;
    pArgument[5] = tempDocState;
    pArgument[6] = AprState;
    pArgument[7] = "";
    pArgument[8] = orgCompanyID;

    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
    	if (pDocState == "011" && pFunctionType == "004" && pDraftFlag == "REDRAFT") {
        	openLocation = "/ezApprovalG/recevGSusin.do?docID=";
			openLocation = openLocation + pDocID + "&uOrgID=" + "&isReDraft=Y" + "&draftFlag=" + pDraftFlag;
    	} else {
            var isGroupDoc = checkIsGroupDoc(pDocID, encodeURIComponent(pArgument[8])); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)

            if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우
                openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=";
            } else {
                openLocation = "/ezApprovalG/draftui.do?formURL=";
            }
            openLocation = openLocation + encodeURIComponent(pArgument[1]) + "&draftFlag=" + encodeURIComponent(pArgument[2]) + "&formDocType=" + encodeURIComponent(pArgument[3]);
            openLocation = openLocation + "&susinSN=" + encodeURIComponent(pArgument[4]) + "&docState=" + encodeURIComponent(pArgument[5]) + "&listType=1&aprState=" + encodeURIComponent(pArgument[6]);
            if (isGroupDoc == "Y" && pFunctionType == "004" && pDraftFlag == "REDRAFT") {
                openLocation = openLocation + "&isTmpDoc=" + encodeURIComponent(pDocID);
            } else {
                openLocation = openLocation + "&isTmpDoc=" + encodeURIComponent(pArgument[7]);
            }
            openLocation += "&orgCompanyID=" + encodeURIComponent(pArgument[8]);
    	}
    } else {
    	if (useWebHWP == "YES") {
    		var isGroupDoc = checkIsGroupDoc(pDocID, encodeURIComponent(pArgument[8])); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)
    		
    		if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우
    			openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURIComponent(pArgument[1]) + "&draftFlag=" + encodeURIComponent(pArgument[2]) + "&formDocType=" + encodeURIComponent(pArgument[3]);
    		} else {
    			openLocation = "/ezApprovalG/draftuiWHWP.do?formURL=" + encodeURIComponent(pArgument[1]) + "&draftFlag=" + encodeURIComponent(pArgument[2]) + "&formDocType=" + encodeURIComponent(pArgument[3]);
    		}
    		
            openLocation = openLocation + "&susinSN=" + encodeURIComponent(pArgument[4]) + "&docState=" + encodeURIComponent(pArgument[5]) + "&listType=1&aprState=" + encodeURIComponent(pArgument[6]);
            
            if (isGroupDoc == "Y" && pFunctionType == "004" && pDraftFlag == "REDRAFT") {
            	openLocation = openLocation + "&isTmpDoc=" + encodeURIComponent(pDocID);
            } else {
            	openLocation = openLocation + "&isTmpDoc=" + encodeURIComponent(pArgument[7]);
            }
    	} else {
            var isGroupDoc = checkIsGroupDoc(pDocID, encodeURIComponent(pArgument[8])); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)

            if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우
                openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURIComponent(pArgument[1]) + "&draftFlag=" + encodeURIComponent(pArgument[2]) + "&formDocType=" + encodeURIComponent(pArgument[3]);
            } else {
                openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURIComponent(pArgument[1]) + "&draftFlag=" + encodeURIComponent(pArgument[2]) + "&formDocType=" + encodeURIComponent(pArgument[3]);
            }
            openLocation = openLocation + "&susinSN=" + encodeURIComponent(pArgument[4]) + "&docState=" + encodeURIComponent(pArgument[5]) + "&listType=1&aprState=" + encodeURIComponent(pArgument[6]);
            if (isGroupDoc == "Y" && pFunctionType == "004" && pDraftFlag == "REDRAFT") {
                openLocation = openLocation + "&isTmpDoc=" + encodeURIComponent(pDocID);
            } else {
                openLocation = openLocation + "&isTmpDoc=" + encodeURIComponent(pArgument[7]);
            }
    	}
    }

    openwindow(openLocation, "", 890, 560);
}

function OpenReceiveDraftUI(pDocID, pURL, pDraftFlag) {
    var openLocation;

    if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "doc") {
        openLocation = "/ezApprovalG/recev.do?docID=" + encodeURIComponent(pDocID) + "&draftFlag=" + encodeURIComponent(pDraftFlag);
    }
    else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
    	if(useWebHWP == "YES") {
    		openLocation = "/ezApprovalG/ezDeptRecevUI_WHWP.do?docID=" + encodeURIComponent(pDocID) + "&draftFlag=" + encodeURIComponent(pDraftFlag);
    	} else {
       		openLocation = "/ezApprovalG/ezDeptRecevUI_HWP.do?docID=" + encodeURIComponent(pDocID) + "&draftFlag=" + encodeURIComponent(pDraftFlag);
    	}
	}
    else {
        if (CrossYN()) {
            openLocation = "/ezApprovalG/recev.do?docID=";
        } else {
        	openLocation = "/ezApprovalG/recev.do?docID=";
        }

        openLocation = openLocation + encodeURIComponent(pDocID) + "&draftFlag=" + encodeURIComponent(pDraftFlag);
    }
    
    openwindow(openLocation, "receive", 880, 550);
}

function openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
    var pArgument = new Array();
    
    pArgument[0] = pDocID;
    pArgument[1] = pAprMemberID;
    pArgument[2] = pAprMemberName;
    pArgument[3] = pAprMemberDeptID;
    pArgument[4] = orgCompanyID;

    var formURL = pHref;
    
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
        openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?DocID=" + encodeURIComponent(pArgument[0]);
        openLocation = openLocation + "&uID=" + encodeURIComponent(pArgument[1]) + "&uName=" + encodeURIComponent(pArgument[2]);
        openLocation = openLocation + "&uDeptID=" + encodeURIComponent(pArgument[3]) + "&AllFlag=0";
        openLocation = openLocation + "&functionType=" + encodeURIComponent(pFunctionType);
    } else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
    	if (useWebHWP == "NO") {
        	if (isIE()) {
                openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + encodeURIComponent(pArgument[0]);
                openLocation = openLocation + "&id=" + encodeURIComponent(pArgument[1]) + "&name=" + encodeURIComponent(pArgument[2]);
                openLocation = openLocation + "&deptID=" + encodeURIComponent(pArgument[3]) + "&allFlag=0" + "&docState=" + encodeURIComponent(pDocState);
                openLocation += "&orgCompanyID=" + encodeURIComponent(orgCompanyID);
                openLocation += "&functionType=" + encodeURIComponent(pFunctionType);
        	} else {
        		var pAlertContent = messages.apprPortlet006;
                alert(pAlertContent);
                
                return;
        	}
    	} else {
    		var isGroupDoc = checkIsGroupDoc(encodeURIComponent(pArgument[0]), encodeURIComponent(orgCompanyID)); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)
    		
    		if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우
    			openLocation = "/ezApprovalG/approvuiAll_WHWP.do?docID=" + encodeURIComponent(pArgument[0]);
    		} else {
    			openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + encodeURIComponent(pArgument[0]);
    		}
    		
            openLocation = openLocation + "&id=" + encodeURIComponent(pArgument[1]) + "&name=" + encodeURIComponent(pArgument[2]);
            openLocation = openLocation + "&deptID=" + encodeURIComponent(pArgument[3]) + "&allFlag=0" + "&docState=" + encodeURIComponent(pDocState);
            openLocation += "&orgCompanyID=" + encodeURIComponent(orgCompanyID);
            openLocation += "&functionType=" + encodeURIComponent(pFunctionType);
    	}
    } else {
        var isGroupDoc = checkIsGroupDoc(encodeURIComponent(pArgument[0]), encodeURIComponent(orgCompanyID)); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)

        if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우
            openLocation = "/ezApprovalG/approvuiAll_WHWP.do?docID=" + encodeURIComponent(pArgument[0]);
        } else {
            openLocation = "/ezApprovalG/approvui.do?docID=";
            openLocation = openLocation + encodeURIComponent(pArgument[0]);
        }
        openLocation = openLocation + "&id=" + encodeURIComponent(pArgument[1]) + "&name=" + encodeURIComponent(pArgument[2]);
        openLocation = openLocation + "&deptID=" + encodeURIComponent(pArgument[3]) + "&allFlag=0" + "&docState=" + encodeURIComponent(pDocState);
        openLocation += "&orgCompanyID=" + encodeURIComponent(orgCompanyID);
        openLocation += "&functionType=" + encodeURIComponent(pFunctionType);
    }
    openwindow(openLocation, "", 880, 550);
}

function openwindow(wfileLocation) {
    var height = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;

    if (window.screen.width > 800) {
        var pleftpos;
        pleftpos = parseInt(width) - 1150;
        height = parseInt(height) - 30;
        
        if (CrossYN())
        	height = parseInt(height) - 25;

        if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
        	height = parseInt(height) - 40;

        width = parseInt(width) - pleftpos;
        
        left = pleftpos / 2;
    } else {
    	height = parseInt(height) - 30;
        
        if (CrossYN())
        	height = parseInt(height) - 25;

        if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
        	height = parseInt(height) - 40;

        
        width = parseInt(width) - 10;
    }
    window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + height + ",width=" + width + ",top=" + top + ",left = " + left);
}

function CheckFormConnFlag(docID, companyID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getFormConnFlag.do",
		data : {
			docID : docID,
			companyID : companyID
		},
		success: function(xml){
			result = xml;
		}
	});
	
    if (getNodeText(loadXMLString(result).documentElement) == "Y")
        return true;
    else
        return false;
}

/* 2022-01-27 홍승비 - 일괄기안된 문서인지 판별하는 ajax 함수 (Y/N) */
function checkIsGroupDoc(pDocID, pOrgCompanyID) {
    var res = "";
    
    $.ajax({
        type : "GET",
        dataType : "text",
        async : false,
        url : "/ezApprovalG/checkIsGroupDoc.do",
        data : {
            docID : pDocID,
            orgCompanyID : pOrgCompanyID
        },
        success: function(result) {
            res = result;
        }        			
    });
    
    return res;
}

function getAbsence() {
	var absence = "";
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/endAbsence.do",
		success: function(result) {
			absence = result;
		}
	});

	return absence;
}

function clearAbsence(isOk) {
	if (!isOk) return;

	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezPersonal/clearAbsence.do",
		success: function(result) {
			if (result === "true") {
				BString = "";
				absence = "";
				
				for (let i = 0; i < apprPortletIDs.length; i++) {
					getApprovalList(apprPortletTypes[i], apprPortletIDs[i]);
				}
			}
		}
	});
}

var ezapropinion_cross_dialogArguments = new Array();
function popAskAbsence() {
	ezapropinion_cross_dialogArguments[0] = messages.apprPortlet008;
	ezapropinion_cross_dialogArguments[1] = clearAbsence;
	ezapropinion_cross_dialogArguments[2] = true;

	var OpenWin = window.open("/ezApprovalG/ezAprOpinion.do", "popAskAbsence", GetOpenWindowfeature(330, 205));
	try { OpenWin.focus(); } catch (e) { console.log(e);}
}
