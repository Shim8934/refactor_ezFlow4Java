var beforeJob = "0";
var xmlhttp_total = createXMLHttpRequest();
var xmlhttp_completed = createXMLHttpRequest();
var lang = document.getElementById("userLang").value;
var deptName = document.getElementById("userDept").value;
var deptName2 = document.getElementById("userDept2").value;
var userTitle = document.getElementById("userTitle").value;
var userTitle2 = document.getElementById("userTitle2").value;
var userPrimary = document.getElementById("userPrimary").value;

function grapeResize() {
    var grapeWidth = document.querySelector("div.bar.my").offsetWidth;

    var displays = [
        document.querySelector(".display.first"),
        document.querySelector(".display.second"),
        document.querySelector(".display.third"),
        document.querySelector(".display.forth"),
        document.querySelector(".display.fifth"),
        document.querySelector(".display.sixth")
    ];

    var multipliers = [5, 10, 15, 20, 25, 30];
    
    displays.forEach((el, idx) => {
        if (el) { 
            if (lang != 1) {
                el.style.left = (grapeWidth / 35 * multipliers[idx]) + "px";
            } else {
                el.style.left = (grapeWidth / 35 * multipliers[idx] + 40) + "px";
            }
        }
    });
}

function getDashBoardCnt() {
    var strQuery = "<DATA><LISTTYPE>1</LISTTYPE></DATA>";
    xmlhttp_total = null;
    xmlhttp_total = createXMLHttpRequest();
    xmlhttp_total.open("POST", "/ezApprovalG/getListCount.do?mode=LEFT&type=dash", true);
    xmlhttp_total.onreadystatechange = getAprCount_after;
    xmlhttp_total.send(strQuery);
}

function getAprCount_after() {
    if (xmlhttp_total == null || xmlhttp_total.readyState != 4) return;
    try {
        if (xmlhttp_total.responseText == "") return;
        var countXml = xmlhttp_total.responseXML;
        var countList = GetChildNodes(countXml.documentElement);

        var aprPendginCnt = countList[0].innerHTML;
        var aprRejectedCnt = countList[1].innerHTML;
        var aprProgressCnt = countList[2].innerHTML;
        var aprReceivedCnt = countList[3].innerHTML;
        var ONEDAY = countList[4].innerHTML;
        var TWODAY = countList[5].innerHTML;
        var THREEDAY = countList[6].innerHTML;
        var OHTERDAY = countList[7].innerHTML;

        document.getElementById("dashboardCnt1").innerText = aprPendginCnt;
        document.getElementById("dashboardCnt2").innerText = aprProgressCnt;
        document.getElementById("dashboardCnt3").innerText = aprReceivedCnt;
        document.getElementById("dashboardCnt4").innerText = aprRejectedCnt;
        document.getElementById("OTHER").innerText = aprPendginCnt;
        document.getElementById("ONEDAY").style.width = Math.min((Number(ONEDAY)/ 35 * 100), 100) + "%";
        document.getElementById("TWODAY").style.width = Math.min((Number(TWODAY)/ 35 * 100), 100) + "%";
        document.getElementById("THREEDAY").style.width = Math.min((Number(THREEDAY)/ 35 * 100), 100) + "%";
        document.getElementById("OTHER2").style.width = Math.min((Number(OHTERDAY)/ 35 * 100), 100) + "%";
        
    } catch (e) { }
}

function dashBoardBoxClick(type) {
    var leftDoc = parent.frames["left"].document;
    var lnbULList = leftDoc.querySelectorAll("ul.lnbUL");
    var h2List = leftDoc.querySelectorAll("h2.on");
    var arrow = leftDoc.querySelector("span.sub_iconLNB.tree_arrow_down");
    
    if (arrow) {
        arrow.className = "sub_iconLNB tree_plus";
    }
    
    for (var i = 0; i < lnbULList.length; i++) {
        lnbULList[i].classList.add("off");
    }
    
    for (var j = 0; j < h2List.length; j++) {
        h2List[j].className = "off";
    }
    
    function openMenu(h2Id, ulId, targetId) {
        var h2 = leftDoc.getElementById(h2Id);
        var ul = leftDoc.getElementById(ulId);
        var target = leftDoc.getElementById(targetId);
    
        if (h2 && ul) {
            h2.className = "on";
            ul.classList.remove("off");
    
            var span = h2.querySelector("span.sub_iconLNB");
            if (span) {
                span.className = "sub_iconLNB tree_arrow_down";
            }
        }
    
        if (target) {
            target.click();
        }
    }
    
    if (type == 1) {
        openMenu("apprH2", "apprUL", "APPROVAL1");
    } else if (type == 3) {
        openMenu("apprH2", "apprUL", "APPROVAL2");
    } else if (type == 4) {
        openMenu("apprH2", "apprUL", "APPROVAL4");
    } else if (type == 24) {
        openMenu("apprH2", "apprUL", "APPROVAL24");
    } else if (type == "MYCONT") {
        openMenu("compH2", "compUL", "MYCONT");
    }
}

function openForm_Complete2(ret) {
    getformcont_Cross_OpenWin.close();
    formURL = ret[0];
    formDocType = ret[1];
    if (formURL != "cancel") {
        openDraftUI(formURL, formDocType);
    }
}

var favoriteForm = document.getElementById("favoriteForm");
var getFavoriteForms = function() {
    favoriteForm.innerHTML = "";
    var request = new XMLHttpRequest();
    request.open('GET', '/ezNewPortal/getFavoriteForms.do', true);

    request.onload = function() {
        if (request.status >= 200 && request.status < 400) {
            var result = JSON.parse(request.responseText);
            
            var forms = result.resultList;
            var formsHTML = "";
            
            if (forms.length > 0) {
                for (var i = 0; i < 6; i++) {
                    if (forms[i]) {
                        formsHTML += "<li class='dashFavorite' data-location='" + forms[i].formFileLocation + "' data-type='" + forms[i].formDocType + "'>";
                        formsHTML += "<a>" + forms[i].formName + "</a></li>";
                    }
                }
                
                favoriteForm.innerHTML = formsHTML
            
                var elementList = document.querySelectorAll('.dashFavorite');
                
                [].forEach.call(elementList, function(element) {
                    element.addEventListener('click', function() {
                        checkBujaeOpenDraftUI(this.getAttribute("data-location"), this.getAttribute("data-type"));
                    });
                });
                favoriteForm.classList = "info";
            } else {
                favoriteForm.classList = "info nodata";
                favoriteForm.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
            }
        } else {
        }
    };

    request.onerror = function() {
    };
    
    request.send();
}

function favoriteFormAdd() {
    parent.frames["left"].document.getElementById("draftBtn").click();
}

var makeDraftBox = function(object) {
    try {
        var lists = object;
        var attach = lists.hasAttachYn;
        var title = "";
        
        if (lang == 1)  {
            title = "[" + lists.formName + "] " + lists.docTitle;
        } else {
            if (lists.formName2) {
                title = "[" + lists.formName2 + "] " + lists.docTitle;
            } else {
                title = "[" + lists.formName + "] " + lists.docTitle;
            }
        }
        
        var writer = "";
        writer = lists.writerDeptName + " ";
        
        if (lang == 1) {
            writer += lists.writerName;
        } else {
            writer += lists.writerName2;
        }
         
        var writerJobTitle = lists.writerJobTitle;
        
        if (writerJobTitle) {
            writer += " " + writerJobTitle;
        }
            
        var li = document.createElement("li");
        var a = document.createElement("a");
        var div = document.createElement("div");
        var span = document.createElement("span");
        var p = document.createElement("p");
        var span2 = document.createElement("span");
        var span3 = document.createElement("span");
        
        if (attach == "Y") {
            span.classList = "i_file";
        }
        
        div.classList = "t_right";
        span2.classList = "i_issue";
        span3.classList = "day";
        span3.textContent = writer;
        
        p.appendChild(span2);
        p.insertBefore(document.createTextNode(title), null); 
        div.appendChild(span);
        a.appendChild(div);
        a.appendChild(p);
        a.appendChild(span3);
        li.appendChild(a);
        draftBox.appendChild(li);
        
        li.setAttribute("onclick",
            "openViewDocInfo2(" +
                "'" + lists.docID + "', " +
                "'" + lists.href.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\n/g, "\\n") + "', " +
                "'" + lists.aprMemberID + "', " +
                "'" + lists.aprMemberName + "', " +
                "'" + lists.aprMemberDeptID + "', " +
                "'" + lists.docState + "', " +
                "'" + lists.functionType + "', " +
                "'" + lists.companyID + "'" +
            ")"
        );
    } catch (e) {
      
    }
    
}

function dashBoardOpendocview(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID, mode) {
    if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
        if (pDocState == "012" || pDocState == "014" || pDocState == "018") {
            OpenReceiveDraftUI(pDocID, pHref, "REDRAFT");
        } else if (pFunctionType == "004" && companyID != orgCompanyID) {
            var pAlertContent = messages.apprPortlet005;
            showAlert(pAlertContent);
            return;
        } else {
            openApprDraftUI("REDRAFT", pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
        }
    } else {
        if (mode == "apr") {
            openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
        } else {
            openViewDocInfo2(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID)
        }
    }
}

function openApprDraftUI(pDraftFlag, pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
    var pArgument = new Array();
    var formURL = pHref;
    
    // pArgument[0] = userID;
    pArgument[1] = pHref;
    pArgument[2] = pDraftFlag;
    pArgument[3] = "";
	
    if (CheckFormConnFlag(pDocID, orgCompanyID)) {
        var pAlertContent = messages.apprPortlet007;
        showAlert(pAlertContent);
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
            var isGroupDoc = checkIsGroupDoc(pDocID, encodeURIComponent(pArgument[8])); 

            if (isGroupDoc == "Y" && draftAllTypeB != "Y") {
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
    		var isGroupDoc = checkIsGroupDoc(pDocID, encodeURIComponent(pArgument[8]));
    		
    		if (isGroupDoc == "Y" && draftAllTypeB != "Y") { // 일괄기안 문서를 여는 경우
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
            var isGroupDoc = checkIsGroupDoc(pDocID, encodeURIComponent(pArgument[8])); 

            if (isGroupDoc == "Y" && draftAllTypeB != "Y") { 
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
                showAlert(pAlertContent);
                
                return;
        	}
    	} else {
    		var isGroupDoc = checkIsGroupDoc(encodeURIComponent(pArgument[0]), encodeURIComponent(orgCompanyID)); 
    		
    		if (isGroupDoc == "Y" && draftAllTypeB != "Y") { 
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
        var isGroupDoc = checkIsGroupDoc(encodeURIComponent(pArgument[0]), encodeURIComponent(orgCompanyID)); 

        if (isGroupDoc == "Y" && draftAllTypeB != "Y") { 
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
    openLocation += "&mode=APR";
    openwindow(openLocation, "", 880, 550);
}

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

var draftBox = document.getElementById("draftBox");
var progressDoc = document.getElementById("progressDoc");

function getDraftAndDoing(type) {
    draftBox.innerHTML = "";
    var request = new XMLHttpRequest();
    request.open('POST', '/ezNewPortal/getApprovalList.do', true);
    request.setRequestHeader('Content-Type', 'application/json');
    request.onload = function() {
        if (request.status >= 200 && request.status < 400) {
            var result = JSON.parse(request.responseText);
            var docList = result.resultList;
            var imgPath = result.imgPath;
            if (!!docList && docList.length > 0) {
                draftBox.innerHTML = "";
               for (let i = 0; i < docList.length && i < 3; i++) {
                    makeDraftBox(docList[i]);
                };
            } else {
                draftBox.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
            }
        } else {
            draftBox.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
        }
    };
    
    request.onerror = function() {
	};
	
	var data = JSON.stringify({
		type : type
	});
	
	request.send(data);
}

function openViewDocInfo2(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
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
                showAlert(pAlertContent);
                
                return;
        	}
    	} else {
    		var isGroupDoc = checkIsGroupDoc(encodeURIComponent(pArgument[0]), encodeURIComponent(pArgument[8]));
    		
    		if (isGroupDoc == "Y" && draftAllTypeB != "Y") { // 일괄기안 문서를 여는 경우
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

        if (isGroupDoc == "Y" && draftAllTypeB != "Y") { // 일괄기안 문서를 여는 경우
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
    openLocation += "&mode=APR";
    openwindow(openLocation, "", 880, 570);
}

var deptboxListUl = document.getElementById("deptBoxLists");

function makeDeptBox(result) {
    deptboxListUl.innerHTML = "";
    var parser = new DOMParser();
    var xmlDoc = parser.parseFromString(result, "text/xml");
    var rows = xmlDoc.getElementsByTagName("ROW");
    try {
        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var writer = "";
                var cells = row.getElementsByTagName("CELL");
                var deptBoxLists = cells[0];
                var title = "[" + cells[7].getElementsByTagName("VALUE")[0].textContent + "] " + deptBoxLists.getElementsByTagName("VALUE")[0].textContent;
                var data1 = deptBoxLists.getElementsByTagName("DATA1")[0].textContent;
                var DATA3 = deptBoxLists.getElementsByTagName("DATA3")[0].textContent;
                var hasAttachYn = deptBoxLists.getElementsByTagName("DATA4")[0].textContent;
                var DATA5 = deptBoxLists.getElementsByTagName("DATA5")[0].textContent;
                var data7 = deptBoxLists.getElementsByTagName("DATA7")[0].textContent;
                var data8 = deptBoxLists.getElementsByTagName("DATA8")[0].textContent;
                var data9 = deptBoxLists.getElementsByTagName("DATA9")[0].textContent;
                var data10 = deptBoxLists.getElementsByTagName("DATA10")[0].textContent;
                var DATA15 = deptBoxLists.getElementsByTagName("DATA15")[0].textContent;
                var orgCompanyid = deptBoxLists.getElementsByTagName("ORGCOMPANYID")[0].textContent;
                var writerName = deptBoxLists.getElementsByTagName("WRITERNAME")[0].textContent;
                var sentdeptName = deptBoxLists.getElementsByTagName("SENTDEPTNAME")[0].textContent;
                var processDate = deptBoxLists.getElementsByTagName("PROCESSDATE")[0].textContent;
                var jobTitle = deptBoxLists.getElementsByTagName("WRITERJOBTITLE")[0].textContent;
                
                writer = sentdeptName + " " +  writerName + " " + jobTitle + " " + processDate.slice(0,10);
                
                var li = document.createElement("li");
                var a = document.createElement("a");
                var div = document.createElement("div");
                var div2 = document.createElement("div");
                var p = document.createElement("p");
                var span = document.createElement("span");
                var span2 = document.createElement("span");
                var span3 = document.createElement("span");
                var span4 = document.createElement("span");
                
                li.setAttribute("DATA1", data1);
                li.setAttribute("DATA3", DATA3);
                li.setAttribute("DATA5", DATA5);
                li.setAttribute("DATA7", data7);
                li.setAttribute("DATA8", data8);
                li.setAttribute("DATA9", data9);
                li.setAttribute("DATA10", data10);
                li.setAttribute("DATA12", "");
                li.setAttribute("DATA15", DATA15);
                li.setAttribute("orgCompanyID", orgCompanyid);
                
                if (DATA5 == "Y") {
                    div.classList = "t_right";
                    span2.classList = "i_message";
                    div.appendChild(span2);
                    a.appendChild(div);
                }
                
                if (hasAttachYn == "Y") {
                    div2.classList = "t_right";
                    span4.classList = "i_file";
                    div2.appendChild(span4);
                    a.appendChild(div2);
                }
                
                span.classList = "i_issue";
                p.insertBefore(span, p.firstChild);
                p.appendChild(document.createTextNode(title));
                
                span3.classList= "day";
                span3.textContent = writer;
                
                a.appendChild(p);
                a.appendChild(span3);
                li.appendChild(a);
                
                deptboxListUl.appendChild(li);
                pSelMenu = "all";
                
                if (DATA3.substr(DATA3.length - 3, DATA3.length).toLowerCase() != 0) {
                    li.setAttribute("onclick", "openDeptBoxList(this)");
                }
            }
        } else {
           deptboxListUl.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
        }
    } catch (e) {
       deptboxListUl.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
       console.log(e);
    }
    
}

function openViewDocInfoDeptBox(data) {
    var pArgument = new Array();
    var formURL = data.getAttribute("DATA3");
    var DocID = data.getAttribute("DATA1");
    var orgCompanyID = data.getAttribute("orgCompanyID");

    pArgument[0] = DocID;
    pArgument[1] = formURL;
    pArgument[2] = data.getAttribute("DATA5");
    pArgument[3] = "VIEW";
    pArgument[4] = pSusinManagerFlag;
    pArgument[5] = data.getAttribute("DATA7");
    pArgument[6] = "OPINION_SHOW";
    pArgument[7] = 4;

    var openLocation;
    var formUrlExt = getOriginalFileExtension(formURL);

    if (formUrlExt === "hwp") {
        if (useWebHWP == "NO") {
            if (CrossYN() && isIE()) {
                openLocation = "/ezApprovalG/ezviewAprHWP.do";
            } else {
                var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                showAlert(pAlertContent);

                return;
            }
        } else {
            var isGroupDoc = checkIsGroupDoc(encodeURI(DocID), orgCompanyID);

            if (isGroupDoc == "Y" && draftAllTypeB != "Y") { // 일괄기안 문서를 여는 경우 (결재진행문서, 기안한문서 메뉴에서 접근 시 지원)
                openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do";
            } else {
                openLocation = "/ezApprovalG/ezviewAprWHWP.do";
            }
        }
    } else {
        var isGroupDoc = checkIsGroupDoc(encodeURI(DocID), orgCompanyID);

        if (isGroupDoc == "Y" && draftAllTypeB != "Y") { // 일괄기안 문서를 여는 경우 (결재진행문서, 기안한문서 메뉴에서 접근 시 지원)
            openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do";
        } else {
            openLocation = "/ezApprovalG/aprDocView.do";
        }
    }
    openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&docHref=" + encodeURI(pArgument[1]);
    openLocation = openLocation + "&opinionFlag=" + encodeURI(pArgument[2]) + "&docState=" + encodeURI(pArgument[3]) + "&listSusin=" + encodeURI(pArgument[4]) + "&oDoc=" + encodeURI(pArgument[5]);
    openLocation = openLocation + "&isOpinion=" + encodeURI(pArgument[6]);
    openLocation = openLocation + "&listType=" + encodeURI(pArgument[7]);
    openLocation = openLocation + "&CallBackType=" + escape(trim_Cross(""));
    openLocation = openLocation + "&ext=" + escape(trim_Cross(formURL));
    openLocation = openLocation + "&orgCompanyID=" + orgCompanyID;
    
    openwindow(openLocation, "", 880, 570);
}

function OpenReceiveDeptBoxDraftUI(data, pDraftFlag) {
    var openLocation;
    if (data != null) {
        if (pDraftFlag == "SUSIN") {
        	var pURL = data.getAttribute("DATA3");
            var pDocID = data.getAttribute("DATA1").trim();
            var docHref = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
            var isMht = docHref == "mht" || (docHref != "hwp");
            if (isMht) {
                openLocation = "";
                
                if (data.getAttribute("DATA15") == "001") {
                	openLocation = "/ezApprovalG/recevG.do";
                } else {
                	openLocation = "/ezApprovalG/recevGSusin.do";
                }
                
                openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag);
                openLocation = openLocation + "&uOrgID=" + encodeURI(data.getAttribute("DATA7"));
            } else {
            	if(useWebHWP == "NO") {
	                if (/chrome/i.test(navigator.userAgent)) {
	                     showAlert(strLang1103);
	                     return;
	            	 } else {
	            		if (docHref == "hwp") {
	            			openLocation = "/ezApprovalG/ezRecevGSusinHWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag) + "&uOrgID=" + encodeURI(data.getAttribute("DATA7"));
	                    }
	            	 }
            	} else {
            		openLocation = "/ezApprovalG/ezRecevGSusinWHWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag) + "&uOrgID=" + encodeURI(data.getAttribute("DATA7"));
            	}
            }
            openwindow(openLocation, "receive", 880, 550);
        } else {
            var pURL = data.getAttribute("DATA3");
            var pDocID = data.getAttribute("DATA1");
            var orgCompanyID = data.getAttribute("orgCompanyID");
            
            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
            	if(useWebHWP == "NO") {
	            	if (/chrome/i.test(navigator.userAgent)) {
	            		showAlert(strLang1103);
	            		return;
	            	} else {
	            		openLocation = "/ezApprovalG/ezDeptRecevUI_HWP.do";
	            	}
            	} else {
            		openLocation = "/ezApprovalG/ezDeptRecevUI_WHWP.do";
            	}
            } else if (approvalFlag == "G") {
            	openLocation = "/ezApprovalG/recevGDeptHapyui.do";
            } else {
            	openLocation = "/ezApprovalG/recev.do";
            }
            openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag) + "&orgCompanyID=" + encodeURI(orgCompanyID);
            openwindow(openLocation, "receive", 880, 550);
        }
    } else {
        var pAlertContent = strLang870;
        OpenAlertUI(pAlertContent);
    }
}

function getCompletedList() {
    var subCondition = "";
    var shareDeptId = "";
    var PageSize = "3";
    var settingDate = new Date();
    settingDate.setYear(parseInt(nowDate.substring(0,4)) - 1);
    var settingmonth = nowDate.substring(5,7);
    var settingday = nowDate.substring(8,10);
    var SQLPARADATA2 = "<ROOT><TYPE>STARTDATEAF;STARTDATEBF;</TYPE><DATA><STARTDATEAF>" + (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01</STARTDATEAF>";
    SQLPARADATA2 +=  "<STARTDATEBF>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</STARTDATEBF></DATA></ROOT>";
    
    curpage = 1;
    nowblock = 0;
    totalPage = 0;
    OrderOption = "";
    OrderCell = "";

    var objNode, i, nodeName;
    var xmlpara = createXmlDom();
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    
    if (approvalFlag == 'S') {
    	for (i = 0; i < 12 ; i++) {
            if (typeof (condition[i]) == "undefined") {
                createNodeAndInsertText(xmlpara, objNode, "Param" + i, "");
            } else {
                createNodeAndInsertText(xmlpara, objNode, "Param" + i, condition[i]);
            }
        }
        
        if (typeof (ContainerID) == "undefined")
            createNodeAndInsertText(xmlpara, objNode, "Param12", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "Param12", "");

        createNodeAndInsertText(xmlpara, objNode, "Param13", pUserID);
        createNodeAndInsertText(xmlpara, objNode, "Param14", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "Param15", "DETAIL");
        createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);
        createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
        createNodeAndInsertText(xmlpara, objNode, "DocState", "");
        
        var searchStatus = "ALL"
        createNodeAndInsertText(xmlpara, objNode, "searchStatus", searchStatus);
        
        createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
        createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);

        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition);
        createNodeAndInsertText(xmlpara, objNode, "SearchQuery", SQLPARADATA2);
        createNodeAndInsertText(xmlpara, objNode, "shareDeptId", shareDeptId);

        xmlhttp_completed.open("POST", "/ezApprovalG/getFormSearchDocListS.do", true);
	    xmlhttp_completed.onreadystatechange = makeCompletedBox;		
	    xmlhttp_completed.send(xmlpara);
	} else {
        for (i = 0; i < condition.length - 1 ; i++) {
	        if (typeof(condition[i]) == "undefined") {
                createNodeAndInsertText(xmlpara, objNode, "Param" + i, "");
            } else {
                createNodeAndInsertText(xmlpara, objNode, "Param" + i, condition[i]);
            }
	    }
        
        createNodeAndInsertText(xmlpara, objNode, "Param24", "");
	    createNodeAndInsertText(xmlpara, objNode, "Param25", pUserID);   	        
	    createNodeAndInsertText(xmlpara, objNode, "Param26", arr_userinfo[4]);  	
	    createNodeAndInsertText(xmlpara, objNode, "Param27", "DETAIL");             
	    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);              
	    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);            
	    createNodeAndInsertText(xmlpara, objNode, "DocState", "");

	    if (subCondition == "")
	        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", condition[condition.length - 1]);
	    else if (condition[condition.length - 1] == "")
	        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition);
	    else
	        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition + " AND " + condition[condition.length - 1]);

	    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
	    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);

        xmlhttp_completed.open("POST", "/ezApprovalG/getFormSearchDocList.do", true);
	    xmlhttp_completed.onreadystatechange = makeCompletedBox;		
	    xmlhttp_completed.send(xmlpara);
	}
}

var completedBox = document.getElementById("completedBox");

function makeCompletedBox() {
    completedBox.innerHTML = "";
    if (xmlhttp_completed == null || xmlhttp_completed.readyState != 4) return;

    try {
        var data = xmlhttp_completed.responseXML;
        var rowsNode = data.getElementsByTagName("ROWS")[0];
        var rowList = rowsNode.getElementsByTagName("ROW");
        
        if (rowList && rowList.length > 0) {
            for (var i = 0; i < rowList.length; i++) {
                var row = rowList[i];
                var attachYn = row.getElementsByTagName("HASATTACHYN")[0].textContent;
                var opinionyn = row.getElementsByTagName("HASOPINIONYN")[0].textContent;
                var addOpinionYn = row.getElementsByTagName("ADDOPINION")[0].textContent;
                var title = "[" + row.getElementsByTagName("DATA99")[0].textContent + "] " + row.getElementsByTagName("CELL")[1].getElementsByTagName("VALUE")[0].textContent;
                var writerName = row.getElementsByTagName("CELL")[2].getElementsByTagName("VALUE")[0].textContent;
                var writerName2 = row.getElementsByTagName("WRITERNAME2")[0].textContent;
                var deptName = row.getElementsByTagName("WRITERDEPTNAME")[0].textContent;
                 var deptName2 = row.getElementsByTagName("WRITERDEPTNAME2")[0].textContent;
                var jobTitle = row.getElementsByTagName("WRITERJOBTITLE")[0].textContent;
                var jobTitle2 = row.getElementsByTagName("WRITERJOBTITLE2")[0].textContent;
                var endDate = row.getElementsByTagName("ENDDATE")[0].textContent;
                var data1 = row.getElementsByTagName("DATA1")[0].textContent;
                var data2 = row.getElementsByTagName("DATA2")[0].textContent;
                var data5 = row.getElementsByTagName("DATA5")[0].textContent;
                var data6 = row.getElementsByTagName("DATA6")[0].textContent;
                var data7 = row.getElementsByTagName("DATA7")[0].textContent;
                var data10 = row.getElementsByTagName("DATA10")[0].textContent;
                var data12 = row.getElementsByTagName("DATA12")[0].textContent;
                var orgCompanyId = row.getElementsByTagName("ORGCOMPANYID")[0].textContent;
                var writer = "";
                
                if (userPrimary == 1) {
                    writer = deptName + " " + writerName + " " + jobTitle + " " + endDate.slice(0,10);
                } else {
                    writer = deptName2 + " " + writerName2 + " " + jobTitle2 + " " + endDate.slice(0,10);
                }
                
                var li = document.createElement("li");
                var a = document.createElement("a");
                var div = document.createElement("div");
                var div2 = document.createElement("div");
                var p = document.createElement("p");
                var span = document.createElement("span");
                var span2 = document.createElement("span");
                var span3 = document.createElement("span");
                var span4 = document.createElement("span");
                
                li.setAttribute("DATA1", data1);
                li.setAttribute("DATA2", data2);
                li.setAttribute("DATA5", data5);
                li.setAttribute("DATA6", data6);
                li.setAttribute("DATA7", data7);
                li.setAttribute("DATA10", data10);
                li.setAttribute("DATA12", data12);
                li.setAttribute("ORGCOMPANYID", orgCompanyId);
                
                if (addOpinionYn == "TRUE" || opinionyn == "Y") {
                    div.classList = "t_right";
                    span.classList = "i_message";
                    div.appendChild(span);
                    a.appendChild(div)
                }
                
                if (attachYn == "Y") {
                    div2.classList = "t_right";
                    span2.classList = "i_file";
                    div2.appendChild(span2);
                    a.appendChild(div2)
                }
                
                span3.classList = "i_issue";
                span4.classList = "day"
                span4.textContent = writer;
                
                p.insertBefore(span3, p.firstChild);
                p.appendChild(document.createTextNode(title));
                
                a.appendChild(p);
                a.appendChild(span4);
                li.appendChild(a);
                completedBox.appendChild(li);
                
                li.setAttribute("onclick", "OpenCompletedDoc(this)");
            }
        } else {
            completedBox.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
        }
    }
    catch (e) { 
        completedBox.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
        console.log(e);
    }
}

function OpenCompletedDoc(li) {
    DocID = li.getAttribute("DATA1");
    pURL = li.getAttribute("DATA2");

    var para = new Array();
    para[0] = DocID;
    para[1] = pURL;

    if (li.getAttribute("DATA10") != "" && li.getAttribute("DATA10") >= GetTodayDate()) {
        if (CheckAprLine(DocID) == "TRUE") {
                chk_CompletedPasswd(UserID);
        } else {
            showAlertUI(strLang580);
            return;
        }
    }
    else {
        chk_Completed_Passwd_Complete("TRUE", li);
    }
}

var ezchkpasswd_cross_dialogArguments = new Array();
function chk_CompletedPasswd(pUserID, CompleteFunction) {
    var parameter = pUserID;
    ezchkpasswd_cross_dialogArguments[0] = parameter;
    
    if (CompleteFunction != undefined) {
    	ezchkpasswd_cross_dialogArguments[1] = CompleteFunction;
    } else {
    	ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;
    }

    ezchkpasswd_cross_dialogArguments[2] = true;
    var url = "/ezApprovalG/ezchkPasswd.do?mode=SEC";
    var OpenWin = window.open(url, "ezchkPasswd_Cross", GetOpenWindowfeature(460, 225)); // 결재완료문서/부서문서함 리스트에서 보안결재문서 접근
    try { OpenWin.focus(); } catch (e) { }
}

function chk_Completed_Passwd_Complete(Rtn, data) {
    var docId = data.getAttribute("DATA1");
    var formId = data.getAttribute("DATA6");
    var orgdocId = data.getAttribute("DATA5");
    var docState = "";
    if (Rtn == "FALSE") {
        var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
        showAlertUI(pAlertContent);
        return "";
    } else if (Rtn == "cancel") {
        var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
        showAlertUI(pAlertContent);
        return "";
    } else {
        pURL = data.getAttribute("DATA2");
        orgCompanyID = data.getAttribute("ORGCOMPANYID");
        if (approvalFlag == 'S' ) {
            docState =  data.getAttribute("DATA12");
        } else {
            docState =  data.getAttribute("DATA7");
        }
        var openLocation;
        var tempURL = pURL;
        
        if (tempURL.substr(tempURL.length - 4, tempURL.length).toLowerCase() == ".ezd") {
            tempURL = tempURL.substr(0, tempURL.length - 4);
        }
        
        if (tempURL.substr(tempURL.length - 3, tempURL.length).toLowerCase() == "hwp") {
            if(useWebHWP == "NO") {
                if (isIE()) {
                    openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
                } else {
                    var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                    showAlert(pAlertContent);
                    return;
                }
            } else {
                openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
            }
        } else {
            openLocation = "/ezApprovalG/contDocView.do";
        }
        openLocation = openLocation + "?docID=" + encodeURI(docId) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(formId) + "&orgDocID=" + encodeURI(orgdocId) + "&docState=" + docState + "&orgCompanyID=" + encodeURI(orgCompanyID);
        showPopupSlide(openLocation, 1000, 950, "", GetOpenWindowfeature(1000, 950), hidePopupSlide);
    }
}

var lateListBox = document.getElementById("lateListBox");
function getLateDocBox() {
    pageSize = "7";
        
    pageNum = 1;
    OrderOption = "";
    OrderCell = "";
    
    var nowyear = nowDate.substring(0,4);
    var nowmonth = nowDate.substring(5,7);
    var nowday = nowDate.substring(8,10);
    
    var SQLPARADATA3 = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
    
    getDashBoardDocList("1", SQLPARADATA3, pageSize, "");
    
}

function makeLateBoxList(data) {
    lateListBox.innerHTML = "";
    var lists = data.getElementsByTagName("ROW");
    
    try {
        if (lists.length > 0) {
            for (i = 0; i <lists.length; i++) {
                var list = lists[i];
                var detailData = list.getElementsByTagName("CELL")[0];
                var dateData = list.getElementsByTagName("CELL")[3].textContent.slice(0, 10);
                var title = "[" + list.getElementsByTagName("CELL")[5].getElementsByTagName("VALUE")[0].textContent + "] " + detailData.getElementsByTagName("VALUE")[0].textContent;
                var data1 = detailData.getElementsByTagName("DATA1")[0].textContent;
                var data3 = detailData.getElementsByTagName("DATA3")[0].textContent;
                var data4 = detailData.getElementsByTagName("DATA4")[0].textContent;
                var data5 = detailData.getElementsByTagName("DATA5")[0].textContent;
                var companyID = detailData.getElementsByTagName("orgCompanyID")[0].textContent;
                
                if (lang == 1) {
                    data5 = detailData.getElementsByTagName("DATA5")[0].textContent;
                } else {
                    data5 = detailData.getElementsByTagName("DATA17")[0].textContent;
                }
                
                var writer = "";
                
                if (lang == 1) {
                    writer = detailData.getElementsByTagName("DATA8")[0].textContent + " " + data5 + " " + detailData.getElementsByTagName("DATA6")[0].textContent + " " +  dateData
                } else {
                    writer = detailData.getElementsByTagName("DATA19")[0].textContent + " " + data5 + " " + detailData.getElementsByTagName("DATA18")[0].textContent + " " +  dateData
                }
                
                var data7 = detailData.getElementsByTagName("DATA7")[0].textContent;
                var data10 = detailData.getElementsByTagName("DATA10")[0].textContent;
                var data12 = detailData.getElementsByTagName("DATA12")[0].textContent;
                var opinionYn = detailData.getElementsByTagName("HASOPINIONYN")[0].textContent;
                var attachYn = list.getElementsByTagName("HASATTACHYN")[0].textContent;
                
                var li = document.createElement("li");
                var dateDiv = document.createElement("div");
                var dateP = document.createElement("p");
                var dateSpan = document.createElement("span");
                var contentDiv = document.createElement("div");
                var contentA = document.createElement("a");
                var div = document.createElement("div");
                var div2 = document.createElement("div");
                var p = document.createElement("p");
                var span = document.createElement("span");
                var span2 = document.createElement("span");
                var span3 = document.createElement("span");
                var span4 = document.createElement("span");
                
                
                var wirterDate = new Date(dateData);
                var today = new Date();
                
                var lateDate = Math.floor((today - wirterDate) / (1000 * 60 * 60 * 24));
                dateDiv.classList = "conts_l";
                dateP.textContent = "+" + lateDate;
                dateSpan.textContent = "Days";
                
                dateDiv.appendChild(dateP);
                dateDiv.appendChild(dateSpan);
                
                contentDiv.classList = "conts_r";
                
                if (opinionYn == "Y") {
                    div.classList = "t_right";
                    span4.classList = "i_message";
                    div.appendChild(span4);
                    contentA.appendChild(div)
                }
                
                if (attachYn == "Y") {
                    div2.classList = "t_right";
                    span2.classList = "i_file";
                    div2.appendChild(span2);
                    contentA.appendChild(div2)
                }
                
                span.classList = "i_issue";
                
                p.insertBefore(span, p.firstChild);
                p.appendChild(document.createTextNode(title));
                
                span3.classList = "day";
                span3.textContent = writer;
                
                contentA.appendChild(p);
                contentA.appendChild(span3);
                contentDiv.appendChild(contentA);
                
                li.appendChild(dateDiv);
                li.appendChild(contentDiv);
                
                lateListBox.appendChild(li);
                
                li.setAttribute("onclick",
                    "dashBoardOpendocview(" +
                        "'" + data1 + "', " +
                        "'" + data3.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\n/g, "\\n") + "', " +
                        "'" + data4 + "', " +
                        "'" + data5 + "', " +
                        "'" + data7 + "', " +
                        "'" + data12 + "', " +
                        "'" + data10 + "', " +
                        "'" + companyID + "', 'apr'" +
                    ")"
                );
            }
        } else {
            lateListBox.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
        }
    } catch (e) {
      lateListBox.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
      console.log(e);
    }
    
}

function getDashBoardDocList(listType, sqlparadatadash, pageSize, OrderOption) {
    var listType = listType;
    var pageNum = 1;
    OrderCell = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getDashBoardDocList.do",
		data : {
				listType : listType, 
				docType  : pDocTypeValue,
				userID 		 : pUserID,
				deptID   : arr_userinfo[4],
				pageSize 	 : pageSize,
				pageNum 	 : pageNum,
				companyID    : companyID,
				orderCell    : OrderCell,
				orderOption  : OrderOption,
				searchQuery  : sqlparadatadash,
				searchCompanyID : companyID,
				searchStatus : "002"
				},
		success: function(xml){
            if (listType == "1") {
                makeLateBoxList(loadXMLString(xml));
            } else if (listType == "3") {
                makeDoingBox(loadXMLString(xml));
            }
		}        			
	});	
}

function getDoingList() {
    var nowyear = nowDate.substring(0,4);
    var nowmonth = nowDate.substring(5,7);
    var nowday = nowDate.substring(8,10);
    
    var sqlparadatadoing = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
    getDashBoardDocList(3, sqlparadatadoing, 3, "");
}

function makeDoingBox(xml) {
    progressDoc.innerHTML = "";
    var aprTypeMap = {
        "001" : strLangAprType1,
        "002" : strLangAprType2,
        "003" : strLangAprType3,
        "004" : strLangAprType4,
        "005" : strLangAprType5,
        "006" : strLangAprType6,
        "007" : strLangAprType7,
        "008" : strLangAprType8,
        "009" : strLangAprType9,
        "011" : strLangAprType11,
        "012" : strLangAprType12,
        "013" : strLangAprType13,
        "014" : strLangAprType14,
        "015" : strLangAprType15,
        "016" : strLangAprType16,
        "017" : strLangAprType17,
        "018" : strLangAprType18,
        "019" : strLangAprType19,
        "040" : strLangAprType40
    }
    
    var aprStateMap = {
        "001" : strLangAprState1,
        "002" : strLangAprState2,
        "003" : strLangDashBoard01
    }
    
    var data = xml.getElementsByTagName("ROW");
    var mode = "";
    
    if (data.length > 0) {
        for (var i=0; i < data.length; i++) {
            var list = data[i];
            var detailData = list.getElementsByTagName("CELL")[0];
            var title = "[" + list.getElementsByTagName("CELL")[5].getElementsByTagName("VALUE")[0].textContent + "] " + detailData.getElementsByTagName("VALUE")[0].textContent;
            var data1 = detailData.getElementsByTagName("DATA1")[0].textContent;
            var data3 = detailData.getElementsByTagName("DATA3")[0].textContent;
            var data16 = detailData.getElementsByTagName("DATA16")[0].textContent;
            var companyID = detailData.getElementsByTagName("orgCompanyID")[0].textContent;
            var imgPath = detailData.getElementsByTagName("IMGPATH")[0].textContent;
            
            var data10 = detailData.getElementsByTagName("DATA10")[0].textContent;
            var data12 = "";
            var opinionYn = detailData.getElementsByTagName("HASOPINIONYN")[0].textContent;
            var attachYn = list.getElementsByTagName("HASATTACHYN")[0].textContent;
            
            var li = document.createElement("li");
            var div = document.createElement("div");
            var span = document.createElement("span");
            var titleA = document.createElement("a");
            var opinionA = document.createElement("a");
            var attachA = document.createElement("a");
            var ul = document.createElement("ul");
            
            li.style.cursor = "pointer";
            li.setAttribute("data1", data1);
            div.classList = "tit";
            span.classList= "i_issue";
            titleA.classList= "txt";
            titleA.textContent = title;
            
            if (opinionYn == "Y") {
                opinionA.classList = "i_message";
            }
            
            if (attachYn == "Y") {
                attachA.classList = "i_file";
            }
            
            div.appendChild(span);
            div.appendChild(titleA);
            
            if (opinionYn == "Y") {
                div.appendChild(opinionA);
            }
            
            if (attachYn == "Y") {
                div.appendChild(attachA);
            }
            
            ul.classList = "info";
            
            var allLines = list.getElementsByTagName("CELL")[0].querySelectorAll("LINE1, LINE2");
            var data9 = "";
            
            for(var j = 0; j < allLines.length; j++) {
                var line = allLines[j];
                var aprType = line.getElementsByTagName("DATA1")[0].textContent;
                var imgfile = line.getElementsByTagName("DATA8")[0].textContent;
                var imgsrc = imgfile !== null && imgfile !== '' ? "/ezCommon/downloadAttach.do?filePath=" + imgPath + "/" + imgfile : "/images/ezNewPortal/info_pic_none.png";
                var aprState = line.getElementsByTagName("DATA2")[0].textContent
                var writer = line.getElementsByTagName("DATA5")[0].textContent + " " + line.getElementsByTagName("DATA3")[0].textContent + " " + line.getElementsByTagName("DATA4")[0].textContent
                var processDate = "";
                
                if (line.getElementsByTagName("DATA6")[0].textContent) {
                    processDate = line.getElementsByTagName("DATA6")[0].textContent.slice(0,10);
                }
                
                var lineLi = document.createElement("li"); 
                var lineP = document.createElement("p"); 
                var lineSpan = document.createElement("span"); 
                var lineDiv = document.createElement("div"); 
                var lineDiv2 = document.createElement("div"); 
                var lineDiv3 = document.createElement("div"); 
                var lineImg = document.createElement("img"); 
                var lineDl = document.createElement("dl"); 
                var lineDt = document.createElement("dt"); 
                var lineDd = document.createElement("dd"); 
                
                if (j == 0) {
                     lineLi.classList = "ok";
                } else {
                    lineLi.classList = "ing";
                }
                
                lineP.textContent = aprTypeMap[aprType];
                lineSpan.textContent = aprStateMap[aprState];
                lineDiv.classList ="img";
                lineDiv2.classList ="profile-img";
                lineDiv3.classList ="photo-img s-60";
                lineImg.src = imgsrc;
                lineDt.textContent = writer;
                
                if (j != 0) {
                    processDate= "-";
                }
                
                lineDd.textContent = processDate;
                lineDl.appendChild(lineDt);
                lineDl.appendChild(lineDd);
                lineDiv3.appendChild(lineImg);
                lineDiv2.appendChild(lineDiv3);
                lineDiv.appendChild(lineDiv2);
                lineP.appendChild(lineSpan);
                lineLi.appendChild(lineP);
                lineLi.appendChild(lineDiv);
                lineLi.appendChild(lineDl);
                ul.appendChild(lineLi);
                
                if (j != 0) {
                    if (line.getElementsByTagName("DATA9")[0] && data16 != line.getElementsByTagName("DATA9")[0].textContent) {
                        mode = "view";
                    }
                }
            }
            
            if (j != 0) {
                if (line.getElementsByTagName("DATA9")[0]){
                    data9 = line.getElementsByTagName("DATA9")[0].textContent;
                    data12 = line.getElementsByTagName("DATA10")[0].textContent;
                    if (data16 != line.getElementsByTagName("DATA9")[0].textContent){
                         mode = "view";
                    }
                    else if (data16 == line.getElementsByTagName("DATA9")[0].textContent) {
                         mode = "apr";
                    }
                }
            }
            
            li.appendChild(div);
            li.appendChild(ul);
            progressDoc.appendChild(li);
            
            li.setAttribute("onclick",
        "dashBoardOpendocview('"+ data1 + "','" 
        + data3.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\n/g, "\\n")+ "','" + data9 + "','','"+ data12 +"','','" + data10 + "','" + companyID + "','" + mode + "')");
        }
    } else {
        progressDoc.innerHTML ="<div class='cont no-data'><p class='txt'>" + strLang944 + "</p></div>";
    }
}

function getOriginalFileExtension(filePath) {
    var pathLength = filePath.length;
    var lastIndexOfDot = filePath.lastIndexOf(".");
    
    if (lastIndexOfDot < 0) {
        return "";
    }
    
    var ext = trim_Cross(filePath.substr(lastIndexOfDot + 1, filePath.length).toLowerCase());
    
    if (ext === "ezd") {
        return getOriginalFileExtension(filePath.substr(0, lastIndexOfDot));
    }
    
    return ext;
}

