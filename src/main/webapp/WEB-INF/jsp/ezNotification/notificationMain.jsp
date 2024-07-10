<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezNotification.e1', 'msg')}"></script>
        <link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
		<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css">
	</head>

<body class="notiBody">
	<div class="notification" onclick="hideFilter()">
        <div class="noti_header">
            <h3><spring:message code="ezNotification.hth01"/></h3>
            <span class="noti_refresh" title="<spring:message code="ezNotification.hth02"/>" onclick="notiRefresh_onclick()"></span>
        </div>

        <div class="noti_search">
            <div class="noti_search_input">
                <input type="text" id="searchNotiContent" onkeypress="searchInput()" placeholder="<spring:message code='ezNotification.hth30'/>" onselectstart="event.cancelBubble=true;event.returnValue=true" maxlength="100" autocomplete="off">
                <span onclick="searchOnClick()"></span>
            </div>
            <span id="notFillterPopBtn" class="noti_filter" onclick="popUpNotFillter()"></span>
        </div>
        
        <div class="filter_pop" id="notFillterPop" onclick="stopPropa()" style="display: none;">
            <div class="check_list">
                <h2><spring:message code="ezNotification.hth03"/></h2>
                <div class="check_scroll">
                    <h3><spring:message code="ezNotification.hth04"/></h3>
                    <ul class="check_ul">
                        <li>
                            <div class="input_check">
                                <input type="checkbox" id="filter_read" onchange="searchNoti('search')" type="checkbox" name="readfilter" maintype="n" value="read" checked="checked">
                                <label for="filter_read"><spring:message code="ezNotification.hth05"/></label>
                            </div>
                        </li>
                        <li>
                            <div class="input_check">
                                <input type="checkbox" id="filter_unread" onchange="searchNoti('search')" type="checkbox" name="readfilter" maintype="n" value="unread" checked="checked">
                                <label for="filter_unread"><spring:message code="ezNotification.hth06"/></label>
                            </div>
                        </li>
                    </ul>
                    <h3><spring:message code="ezNotification.hth07"/></h3>
                    <ul class="check_ul" id="notiType">
                        <li>
                            <div class="input_check">
                                <input type="checkbox" id="filter_totalcheck" name="notitypefilter" maintype="y" value="total" checked="checked" onchange="totalfilterCheck()">
                                <label for="filter_totalcheck"><spring:message code="ezNotification.hth08"/></label>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="reset"><span onclick="filterAllSelect_onclick()"><spring:message code="ezNotification.hth09"/></span></div>
        </div>
        
        <div class="noti_info">
            <div class="noti_view">
                <span><spring:message code="ezNotification.hth08"/><em id="notiTotalCount"></em></span>
                <span><spring:message code="ezNotification.hth06"/><em id="notiUnreadCount"></em></span>
            </div>
            <div class="noti_btn">
                <span onclick="updateNotiAll('read')"><spring:message code="ezNotification.hth10"/></span>
                <span onclick="updateNotiAll('delete')"><spring:message code="ezNotification.hth11"/></span>
            </div>
        </div>

        <div class="noti_list_wrap">
            <ul class="noti_list" id="notiList" >
                
            </ul>
        </div>

        <div class="noti_paging">
            <span class="prev" onclick="moveNotiPage('down')"></span>
            <span class="page_num">
                <input type="text" id="notiCurrentPage" autocomplete="off" value="1" onkeypress="return moveInputPage()">&nbsp;/&nbsp;<span  id="notiTotalPage"></span>
            </span>
            <span class="next" onclick="moveNotiPage('up')"></span>
        </div>
        <div id="notiListProgress" style="position: relative; width: 100%; height: 639px; top: -640px; left: 0px; background-color: rgb(210, 210, 210); opacity: 0.4; z-index: 100; display: none;">
               <div style="top: 300px; left: 80px" id="MailProgress"></div>
           </div>   
    </div>
	<span class="loadingLayer" style="z-index:6000;position:absolute;display:none;" id="loadingLayer"><span class="right"><img src="/images/email/progress_img.gif" width="150" height="30" ></span></span></span>
       	
<script>
	var userDeptId = "<c:out value = '${deptID}'/>"
	var userId = "<c:out value = '${userID}'/>"
	var notiListCnt = 10;
	var curPageNum = 1;
	var searchTitle = "";
	var proxyInfo = "<c:out value = '${proxyInfo}'/>";
	window.onload = function () {
		makeMainTypeList();
		getNotiList(1);
	}
	
	function makeMainTypeList() {
		var str = '';
		for (key in mainType) {
			str += '<li><div class="input_check"><input id="filter_';
			str += key + '" type="checkbox" name="notitypefilter" maintype="y" value=';
			str += '"' + key + '" checked="checked" onchange="totalfilterCheck()"><label for="filter_';
			str += key + '">'; 
			str += mainType[key];
			str += '</label></div></li>';
		}
		var notiTypeElem = document.getElementById("notiType");
		notiTypeElem.insertAdjacentHTML('beforeend', str);
	}
	
	function getNotiList(pageNum) {
		$.ajax({
			type: "GET",
			url: "/ezNotification/getNotiList.do",
			dataType: "JSON",
			data:{
				curPageNum : pageNum,
				notiListCnt : notiListCnt			
			},
			async: true,
			success: function(result) {
				makeNotiList(result);
			},
			error: function (xhr, status, e){
				
			}
		});
	}
	
	function makeNotiList(result) {
		var notiListElement = document.getElementById('notiList');
		try {
			document.getElementById('notiTotalCount').textContent = result.totalListCnt;
			document.getElementById('notiUnreadCount').textContent = result.notReadListCnt;
			document.getElementById('notiTotalPage').textContent = parseInt(result.lastPageNum) > 0 ? result.lastPageNum : 1;
			var notiList = result.notiList;
			while (notiListElement.firstChild) {
				notiListElement.removeChild(notiListElement.firstChild);
			}
			
			var str = "";
			if (notiList == "") {
				str += '<div class="notiZero">'
				str	+= '<dl class="nodata"><dt><img src="/images/kr/main/noData_sIcon.png"></dt><dd>' + notiMessages.strLang1 + '</dd></dl>'
				str += '</div>';
				curPageNum = 1;
			} else {
				for (var i = 0; i < notiList.length; i++) {
					var noti = notiList[i];
					var linkUrl = noti.linkUrl ? noti.linkUrl : "";
					str += noti.isRead == "Y" ? '<li class = \"read\" ' : '<li class = \"\" ';
					str += 'onclick=\"updateNoti(\'read\'); openLink();\" ';
					str += 'notiseq=\"' + noti.notiSeq +'\" viewtype=\"' + noti.viewType + '\" viewwidth=\"' + noti.viewWidth + '\" viewheight=\"' + noti.viewHeight + '\" ';
					str += 'linkurl=\"' + linkUrl + '\" isread=\"' + noti.isRead + '\" mainType=\"' +noti.mainType.toLowerCase() + '\">'
					str += '<i class=\"icon_' + noti.mainType.toLowerCase();
					str += noti.isRead == "Y" ? ' read\"></i>' : '\"></i>';
					str += '<div class=\"list_info\">'
					str += '<p class=\"title ellipsis2\">'
					if (noti.mainType.toLowerCase() != "etc") {
						str += '<em>[' + mainType[noti.mainType.toLowerCase()] + ']</em>';
						str += noti.subType != "" ? '[' + subType[noti.mainType.toLowerCase()][noti.subType.toLowerCase()] + '] ' : ' ';
					}
					str += ConvertCharToEntityReference(noti.notiContent) + '</p>';
					
					str += '<p class=\"desc\"><span>' + noti.senderName + '&nbsp;</span><span class=\"date\">' + noti.regDate.substring(0, 19) + '</span></p></div>';
					str += '<span class=\"list_del blind\" onclick="updateNoti(\'delete\')"></span></li>';
					
				}
		
			}
			document.getElementById('notiCurrentPage').value = curPageNum;
			notiListElement.insertAdjacentHTML('beforeend', str);
			
			setTimeout(function() {
				var notiElem = null;
	
	            var topFrame = window.parent.frames["topFrame"];
	            if (!topFrame) return;
	            if (navigator.userAgent.indexOf("MSIE") !== -1 || navigator.userAgent.indexOf("Trident") !== -1) {
					notiElem = topFrame.document.querySelector('#util_noti > span #notiin');
				} else {
					notiElem = topFrame.contentWindow.document.querySelector('#util_noti > span #notiin');
				}
	            
	            /* 알림 개수 표출 시 필요하면 사용
				if (parseInt(result.notReadTotalListCnt) >= 100) {
					result.notReadTotalListCnt = "99+";
				}
	
	            if (!!notiElem) notiElem.textContent = result.notReadTotalListCnt;
	            */ 
	            if (!!notiElem) {
	            	if (result.notReadTotalListCnt > 0) {
	            		notiElem.style.display = "block";
	            	} else {
	            		notiElem.style.display = "none";
	            	}
	            }
				
			}, 3000);
		} catch (error) {
			var errorStr = '<br/><div class="notiError"><span><spring:message code="ezNotification.hth13"/></span></div>'
			notiListElement.insertAdjacentHTML('beforeend', errorStr);
			document.getElementById('notiCurrentPage').value = 1;
		}
	}
	
	function notiRefresh_onclick() {
		searchNoti('pageMove');
	}
	
	function popUpNotFillter() {
		 if (document.getElementById('notFillterPop').style.display == "none") {
			 document.getElementById('notFillterPop').style.display = "block";
		 } else {
			 document.getElementById('notFillterPop').style.display = "none";
		 }
	 }
	
	function moveInputPage() {
		if (event.keyCode >= 48 && event.keyCode <= 57) {
			return true;
		} else if(event.keyCode == 13) {
			var notiCurrentPageVal = document.getElementById("notiCurrentPage").value;
			if (notiCurrentPageVal == "" || isNaN(notiCurrentPageVal)) {
				return false;
			}
			
			var pageNum = parseInt(document.getElementById("notiCurrentPage").value);
			
			var lastPageNum = parseInt(document.getElementById("notiTotalPage").textContent);
			if (pageNum < 1 || pageNum > lastPageNum) {
				alert('<spring:message code="ezNotification.hth14"/>');
				document.getElementById("notiCurrentPage").value = curPageNum;
				return false;
			}
			document.getElementById("notiCurrentPage").value = pageNum;
			curPageNum = pageNum;
			searchNoti('pageMove');
			return true;
		} else {
			return false;
		}
		
	}
	
	function moveNotiPage(mode) {
		var lastPageNum = parseInt(document.getElementById("notiTotalPage").textContent);
		if (mode == 'up') {
			var pageNum = curPageNum + 1; 
			if (pageNum > lastPageNum) {
				alert('<spring:message code="ezNotification.hth15"/>');
				return;
			}
			
		} else if (mode == 'down') {
			var pageNum = curPageNum - 1; 
			if (pageNum < 1) {
				alert('<spring:message code="ezNotification.hth16"/>');
				return;
			}
		}
		curPageNum = pageNum;
		document.getElementById("notiCurrentPage").value = curPageNum;
		searchNoti('pageMove');
	}
	
	function updateNoti(mode) {
		stopPropa();
		
		if (mode == "delete") {
			if (!confirm('<spring:message code="ezNotification.hth17"/>')) {
				return;	
			}
			var lastPageNum = parseInt(document.getElementById("notiTotalPage").textContent);
			if (curPageNum == lastPageNum && document.querySelectorAll('#notiList li').length == 1) {
				if (lastPageNum == 1) {
					curPageNum = 1;
				} else {
					curPageNum = lastPageNum - 1;
				}
			}
		}
		
		var notiLiElem = $(event.target).closest("li"); 
		var notiSeq = notiLiElem.attr("notiseq");
		$.ajax({
			type: "POST",
			url: "/ezNotification/updateNoti.do",
			dataType:"text",
			data:{
				notiSeq : notiSeq,
				mode: mode
			},
			async: true,
			success: function(result) {
			},
			error: function (xhr, status, e) {
				alert('<spring:message code="ezNotification.hth34"/>');
			},
			complete: function() {
				searchNoti('pageMove');
			}
		});
	}
	
	// 2023-11-09 모두 읽음/읽음 삭제
	function updateNotiAll(mode) {
		var confirmFlag = false;
		if (mode == "delete") {
			confirmFlag = confirm('<spring:message code="ezNotification.hth18"/>');
		} else if (mode == "read") {
			confirmFlag = confirm('<spring:message code="ezNotification.hth19"/>');
		}
		
		if (!confirmFlag) {
			return;
		}
		
		$.ajax({
			type: "POST",
			url: "/ezNotification/updateNotiAll.do",
			dataType:"text",
			data:{
				mode: mode
			},
			async: true,
			success: function(result) {
				if (mode == "delete") {
					curPageNum = 1;
					document.getElementById("notiCurrentPage").value = 1;
					filterAllSelect_onclick();
				} else if (mode == "read") {
					searchNoti('pageMove');
				}
			},
			error: function (xhr, status, e){
				alert('<spring:message code="ezNotification.hth34"/>');
			}
		});
	}
	
	function totalfilterCheck() {
		 var checkValue = event.target.value;
		 var isCheck = event.target.checked;
		 var notiFilterElems = document.querySelectorAll('[name="notitypefilter"]');
		 
		 if (checkValue == "total") {
			 for (var i = 0; i < notiFilterElems.length; i++) {
				 notiFilterElems[i].checked = isCheck;
			 }
		 } else if (!isCheck) {
			document.getElementById('filter_totalcheck').checked = false;
		 } else {
			var isTotalCheck = true;		
	 		for (var j = 0; j < notiFilterElems.length; j++) {
				 if (notiFilterElems[j].value == "total") {
					 continue;
				 }
				 isTotalCheck = isTotalCheck && notiFilterElems[j].checked;  
			}
	 		
	 		if (isTotalCheck) {
	 			document.getElementById('filter_totalcheck').checked = true;
	 		}
		 }
		 
		 searchNoti('search');
	}
	
	function filterAllSelect_onclick() {
		var notiFilterElems = document.querySelectorAll('[name="notitypefilter"]');
		for (var i = 0; i < notiFilterElems.length; i++) {
			notiFilterElems[i].checked = true;
		}
		
		var readFilterElems = document.querySelectorAll('[name="readfilter"]');
		for (var i = 0; i < readFilterElems.length; i++) {
			readFilterElems[i].checked = true;
		}
		searchNoti('search');
	}
	
	function hideFilter() {
		if (event.target.getAttribute("id") == 'notFillterPopBtn') {
			return;
		}
		
		if (document.getElementById('notFillterPop').style.display != "none") {
			document.getElementById('notFillterPop').style.display = "none";
		}
	}
	
	function stopPropa() {
		event.stopPropagation();
	}
	
	function searchNoti(mode) {
		document.getElementById("loadingLayer").style.display = "";
		document.getElementById("loadingLayer").style.top = (document.documentElement.clientHeight / 2) - (document.getElementById("loadingLayer").offsetHeight / 2) + "px";
		document.getElementById("loadingLayer").style.left = (document.documentElement.clientWidth / 2) - (document.getElementById("loadingLayer").offsetWidth / 2) + "px";
		
		if (mode == "search") {
			curPageNum = 1;
		}
		
		var readFlag = document.getElementById("filter_read").checked;
		var unReadFlag = document.getElementById("filter_unread").checked;
		var isRead = "";
		if (readFlag && unReadFlag) {
			isRead = 'ALL';
		} else if (readFlag && !unReadFlag) {
			isRead = 'Y';
		} else if(!readFlag && unReadFlag) {
			isRead = 'N';
		} else {
			alert('<spring:message code="ezNotification.hth20"/>');
			event.target.checked = true;
			document.getElementById("loadingLayer").style.display = "none";
			return;
		}
		
		var notiFilterElems = document.querySelectorAll('[name="notitypefilter"]');
		var notiFilter = "";
		for (var i = 0; i <notiFilterElems.length; i++) {
			if (notiFilterElems[i].value == "total") {
				continue;
			}
			
			if (notiFilterElems[i].checked) {
				notiFilter += notiFilterElems[i].value.toUpperCase() + "|";
			}
		}
		
		if (notiFilter != "") {
			notiFilter = notiFilter.slice(0, -1);
		}
		
		$.ajax({
			type: "GET",
			url: "/ezNotification/searchNoti.do",
			dataType:"JSON",
			data:{
				isRead : isRead,
				notiFilter: notiFilter,
				keyWord : searchTitle,
				curPageNum : curPageNum,
				notiListCnt : notiListCnt
			},
			async: true,
			success: function(result) {
				makeNotiList(result);
			},
			error: function (xhr, status, e){
				
			},
			complete: function() {
				document.getElementById("loadingLayer").style.display = "none";
			}
		});
		
	}
	
	function searchOnClick() {
		searchTitle = MakeXMLString(document.getElementById('searchNotiContent').value.trim());
		searchNoti('search');
	}
	
	function searchInput() {
		if (event.keyCode == 13) {
			searchTitle = MakeXMLString(document.getElementById('searchNotiContent').value.trim());
			searchNoti('search');
		}
	}
	
	function openLink() {
		var targetLi = event.currentTarget;
		var linkUrl = targetLi.getAttribute("linkurl");
		var mainType = targetLi.getAttribute("maintype");
		var viewType = targetLi.getAttribute("viewtype");
		var viewWidth = targetLi.getAttribute("viewwidth");
		var viewHeight = targetLi.getAttribute("viewheight");
		
		var popupHeight = viewHeight;
	    var popupWidth = viewWidth;
	    var pheight = window.parent.screen.availHeight;
	    var pwidth = window.parent.screen.availWidth;
	    var pTop = (pheight - popupHeight) / 2;
	    var pLeft = (pwidth - popupWidth) / 2;
	
	    var dualScreenTop = window.parent.screenY;
	    var dualScreenLeft = window.parent.screenX;
	    
	    pTop += dualScreenTop;
	    pLeft += dualScreenLeft;
	    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + popupHeight + ",width=" + popupWidth + ",top=" + pTop + ",left=" + pLeft;
	    
	    if (linkUrl == "") {
	    	alert("링크가 존재하지 않습니다.");
	    	return;
	    }
	    
	    var paramObj = null;
	    var windowName = "";
	    if (linkUrl.indexOf("/ezApprovalG/reDraftByLink.do") >= 0) {
	    	paramObj = extractParam(linkUrl);
	    	linkUrl = makeRedraftUILink(paramObj);
	    	windowName = "openDraftUI_REDRAFT"
	    } else if (linkUrl.indexOf("/ezApprovalG/openApprovByLink.do") >= 0) {
	    	paramObj = extractParam(linkUrl);
	    	linkUrl = makeApprovUiLink(paramObj);
	    } else if (linkUrl.indexOf("/ezApprovalG/openDocViewByLink.do") >= 0) {
	    	paramObj = extractParam(linkUrl);
	    	linkUrl = makeOpenDocViewLink(paramObj);
	    } else if (linkUrl.indexOf("/ezApprovalG/recevGSusinByLink.do") >= 0) {
	    	paramObj = extractParam(linkUrl);
	    	linkUrl = makeRecevGSusinLink(paramObj);
	    }
	    
	    if (linkUrl == null || linkUrl == "") {// 결재 링크 생성 에러 발생 시 동작안하도록 추가 
	    	alert("링크가 없습니다.");
	    	return;
	    }
	    
	    var newWindow = window.open(linkUrl, windowName, feature, "");
	    
	    if (/MSIE|Trident/.test(window.navigator.userAgent)) {
	        newWindow.moveTo(pLeft, pTop);
	    }
	}
	
	function extractParam(linkUrl) {
		var paramObj = {}
		var paramArr = linkUrl.split("?")[1].split("&");
		for (var i = 0; i < paramArr.length; i ++) {
			var paramKey = paramArr[i].split("=")[0];
			var paramValue = paramArr[i].split("=")[1];
			
			paramObj[paramKey] = paramValue
		}
		
		return paramObj;
	}
	
	function makeApprovUiLink(paramObj) {
		var mode = "APR";
	    var openLocation;
	    
	    var p_companyId = paramObj["companyID"];
		var p_docID = paramObj["docID"];
		var p_userDeptId = paramObj["userDeptID"];
		var p_userID = paramObj["userID"];
		var p_userName = paramObj["userName"];
	    var useWebHWP = "";
	    var pArgument = new Array();
	    var orgCompanyID = p_companyId;
	    var formURL = "";
	    var orgDocId = "";
	    var docState = "";
	    var aprMode = "";
	    var docInfo = null;
	    var allFlag = "";
	    var functionType = "";
		$.ajax({
			type: "GET",
			url: "/ezApprovalG/getAprDocInfoForLink.do",
			dataType:"JSON",
			data:{
				companyId : p_companyId,
				docId: p_docID,
				userId : p_userID
			},
			async: false,
			success: function(result) {
				if (result.status != "ok") {
					alert("에러가 발생했습니다.");
					return null;
				}
				
				pArgument[0] = p_docID;      
		        pArgument[1] = p_userID;		
		        pArgument[2] = p_userName;		
		        pArgument[3] = p_userDeptId;
		        pArgument[4] = result.data.aprMemberSN
		        orgCompanyID = p_companyId;
		        formURL = result.data.href;
				orgDocId = result.data.orgDocID == null ? "" : result.data.orgDocID;
				docState = result.data.docState;
				useWebHWP = result.useWebHWP;
				aprMode = result.mode;
				docInfo = result;
				functionType = result.data.functionType;
			},
			error: function (xhr, status, e) {
				alert("에러가 발생했습니다.");
				return;
			}
		});
		
		if (aprMode == "ING" && pArgument[4] == null) {
			if (functionType == "004" || functionType == "006") {
				return "";
			}
			
			paramObj["listType"] = "3";
			openLocation = makeOpenDocViewLink(paramObj);
			return openLocation;
		} else if (aprMode == "END") {
			openLocation = makeCompleteDocLink(docInfo);
			return openLocation;
		}
        
        if (docState == "017") {
        	   $.ajax({
        			type : "POST",
        			dataType : "text",
        			async : false,
        			url : "/ezApprovalG/getLineMode.do",
        			data : {
        					docID : pArgument[0],
        					orgCompanyID : orgCompanyID
        					},
        			success: function(xml){
        				mode = xml;
        			}        			
        	  });
        }
        
        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
            openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?docID=" + encodeURI(pArgument[0]);
            openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
            openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag);
        } else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	        if (useWebHWP == "NO") {
        		if (isIE()) {
	        		var openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + encodeURI(pArgument[0]);
	        		openLocation += "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
	        		openLocation += "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(docState) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(orgDocId);
	        	} else {
	        		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	        		alert(pAlertContent);
	                
	                return;
	        	}
        	} else {
        		var isGroupDoc = checkIsGroupDoc(encodeURI(pArgument[0]), orgCompanyID);
        		var openLocation = "";
        		
        		if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우
        			openLocation = "/ezApprovalG/approvuiAll_WHWP.do?docID=" + encodeURI(pArgument[0]);
        		} else {
            		openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + encodeURI(pArgument[0]);
        		}
        		openLocation += "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
        		openLocation += "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(docState) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(orgDocId);
        	}
        } else {
            openLocation = "/ezApprovalG/approvui.do?docID=";
            openLocation = openLocation + encodeURI(pArgument[0]);
            openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
            openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(docState) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(orgDocId) + "&aprMemberSN=" + pArgument[4];
        }
        
        return openLocation;
	}
	
	function makeRedraftUILink(paramObj) {
		var useWebHWP = "";
		var formURL = "";
		var pListTypeValue = "1";
		
		var p_companyId = paramObj["companyID"];
		var p_docID = paramObj["docID"];
		var p_userDeptId = paramObj["userDeptID"];
		var p_userID = paramObj["userID"];
		var openLocation = "";
		var mode = "";
		var aprMemberSN = "";
		var docInfo = null;
		if (p_userDeptId != userDeptId) {
			alert("결재부서와 현 부서가 다릅니다.");
			return;
		}
		
		var pArgument = new Array();
		$.ajax({
			type: "GET",
			url: "/ezApprovalG/getAprDocInfoForLink.do",
			dataType:"JSON",
			data:{
				companyId : p_companyId,
				docId: p_docID,
				userId : p_userID
			},
			async: false,
			success: function(result) {
				if (result.status != "ok") {
					alert("에러가 발생했습니다.");
					return null;
				}
				
				mode = result.mode;
				aprMemberSN = result.data.aprMemberSN;
				docInfo = result;
				
				pArgument[0] = p_userID;
			    pArgument[1] = result.data.href;
			    formURL = result.data.href;
			    pArgument[2] = "REDRAFT";
			    pArgument[3] = result.data.docType;
		        pArgument[4] = "0";
		        pArgument[5] = result.data.docState;
		        pArgument[6] = result.data.functionType;
		        pArgument[7] = p_docID;
		        useWebHWP = result.useWebHWP;
			},
			error: function (xhr, status, e) {
				alert("에러가 발생했습니다.");
				return;
			}
		});
		
		if (mode == "ING" && aprMemberSN != "1") {
			paramObj["listType"] = "3";
			openLocation = makeOpenDocViewLink(paramObj);
			return openLocation;
		} else if (mode == "END") {
			openLocation = makeCompleteDocLink(docInfo);
			return openLocation;
		}
		
	    var p_officeFlag = "";
	  
	    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
	    	openLocation = "/ezApprovalG/draftui.do?formURL=";
	        openLocation = openLocation + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
	        openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
	        openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&officeFlag=" + encodeURI(p_officeFlag);
	    } else {
	    	if (useWebHWP == "NO") {
		    	if (!isIE()) {
		            alert("한글양식은 IE에서만 기안 할 수 있습니다.");
		            return;
		        } else {
		        	openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
		            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
		            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
		        }
	    	} else {
	    		var isGroupDoc = checkIsGroupDoc(pArgument[7], ""); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)
	    		
	    		if (isGroupDoc == "Y") { // 반송된 일괄기안 문서를 여는 경우
	    			openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
	    		} else {
	    			openLocation = "/ezApprovalG/draftuiWHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
	    		}
	            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
	            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
	    	}
	    }
		
	    return openLocation;
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
	
	function makeOpenDocViewLink(paramObj) {
		var useWebHWP = "";
		var formURL = "";
		var pListTypeValue = paramObj["listType"];
		var p_companyId = paramObj["companyID"];
		var p_docID = paramObj["docID"];
		var p_userDeptId = paramObj["userDeptID"];
		var p_userID = paramObj["userID"];
		var orgCompanyID = p_companyId; // 차후 수정 필요.
		var pArgument = new Array();
		var openLocation;
		$.ajax({
			type: "GET",
			url: "/ezApprovalG/getAprDocInfoForLink.do",
			dataType:"JSON",
			data:{
				companyId : p_companyId,
				docId: p_docID,
				userId : p_userID
			},
			async: false,
			success: function(result) {
				if (result.status != "ok") {
					alert("에러가 발생했습니다.");
					return null;
				}
								
				pArgument[0] = p_docID;
				pArgument[1] = result.data.href;
				formURL = result.data.href;
				useWebHWP = result.useWebHWP;
				if (pListTypeValue == "4") {
			        pArgument[2] = result.data.hasOpinionYn;
			        pArgument[3] = "VIEW";
			        pArgument[4] = "admin"; // 수신자플래그
			        pArgument[5] = result.data.orgDocID;
			        pArgument[6] = "OPINION_SHOW";
			        pArgument[7] = pListTypeValue;
			    } else if (pListTypeValue != "7" && pListTypeValue != "8" && pListTypeValue != "9") {
			    	if (pListTypeValue == "99" && result.mode == "ING" && result.data.aprState != "002") {
			    		// 공람완료인 경우
			    		pListTypeValue = 10;
			    	}
			        pArgument[2] = result.data.hasOpinionYn;
			        pArgument[3] = result.data.docState;
			        pArgument[4] = p_userID;
			        pArgument[5] = result.data.orgDocID == null ? "" : result.data.orgDocID;
			        
			        if (pListTypeValue != "5") {
			            pArgument[6] = "OPINION_SHOW";
			        } else {
			            pArgument[6] = "OPINION_HIDE";
			        }
			        
			        pArgument[7] = pListTypeValue;
			        pArgument[8] = result.data.formID;
			    }
			},
			error: function (xhr, status, e) {
				alert("에러가 발생했습니다.");
				return;
			}
		});
		
		var formUrlExt = formURL.substr(formURL.length - 3, formURL.length).toLowerCase();
		
		if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
	        if (formUrlExt === "hwp") {
	        	if(useWebHWP == "NO") {
		            if (CrossYN() && isIE()) {
		            	openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
		            } else {
		            	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
		            	alert(pAlertContent);
		                
		                return;
		            }
	        	} else {
	        		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
	        	}
	        }
	        else {
	            openLocation = "/ezApprovalG/contDocView.do";
	        }
	        openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(formURL) + "&formID=&orgDocID=&sendType=" + GetAttribute(tr, "DATA5");
	    } else {
			if (formUrlExt === "hwp") {
	        	if (useWebHWP == "NO") {
		            if (CrossYN() && isIE()) {
		            	openLocation = "/ezApprovalG/ezviewAprHWP.do";
		            } else {
		            	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
		            	alert(pAlertContent);
		                
		                return;
		            }
	        	} else {
	        		var isGroupDoc = checkIsGroupDoc(p_docID, orgCompanyID);
	        		
	        		if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우 (결재진행문서, 기안한문서 메뉴에서 접근 시 지원)
	        			openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do";
	        		} else {
	        			openLocation = "/ezApprovalG/ezviewAprWHWP.do";
	        		}
	        	}
	        }
	        else {
	        	openLocation = "/ezApprovalG/aprDocView.do";
	        }
	        openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&docHref=" + encodeURI(pArgument[1]);
	        openLocation = openLocation + "&opinionFlag=" + encodeURI(pArgument[2]) + "&docState=" + encodeURI(pArgument[3]) + "&listSusin=" + encodeURI(pArgument[4]) + "&oDoc=" + encodeURI(pArgument[5]);
	        openLocation = openLocation + "&isOpinion=" + encodeURI(pArgument[6]);
	        openLocation = openLocation + "&listType=" + encodeURI(pArgument[7]);
	        openLocation = openLocation + "&CallBackType=" + "";
	        openLocation = openLocation + "&ext=" + escape(trim_Cross(formUrlExt));
	        openLocation = openLocation + "&orgCompanyID=" + orgCompanyID;
	        openLocation = openLocation + "&formID=" + encodeURI(pArgument[8]);
	    }
        return openLocation;
	}
	
	function makeRecevGSusinLink(paramObj) {
		var pListTypeValue = paramObj["listType"];
		var p_companyId = paramObj["companyID"];
		var p_docID = paramObj["docID"];
		var p_userDeptId = paramObj["userDeptID"];
		var p_userID = paramObj["userID"];
		var openLocation = null;
		var pDraftFlag = "SUSIN";
		var mode = "";
		var docInfo = null;
		
		$.ajax({
			type: "GET",
			url: "/ezApprovalG/getAprDocInfoForLink.do",
			dataType:"JSON",
			data:{
				companyId : p_companyId,
				docId: p_docID,
				userId : p_userID
			},
			async: false,
			success: function(result) {
				if (result.status != "ok") {
					mode = "ERROR";
				} else {
					docInfo = result;
					docInfo.data.companyID = paramObj["companyID"];
					mode = result.mode;
				}
				
			},
			error: function (xhr, status, e) {
				alert("에러가 발생했습니다.");
				return;
			}
		});
		
		if (mode == "END") {
			openLocation = makeCompleteDocLink(docInfo);
			return openLocation;
		} else if (mode == "ERROR") {
			openLocation = null;
		}
		
		$.ajax({
			type: "GET",
			url: "/ezApprovalG/getSusinProcessInfo.do",
			dataType:"JSON",
			data:{
				companyId : p_companyId,
				docId: p_docID,
				userId : p_userID,
				userDeptId : p_userDeptId
			},
			async: false,
			success: function(result) {
				if (result.status != "ok") {
					mode = "ERROR";
				}
				
				if (result.data === null) {
					mode = "NOTEXIST"; // 다른 부서로 배부 시엔 수신 부서에서 문서 확인 불가.
				} else {
					if (result.data.aprState == "015") {
						mode = "HWESONG"; // 회송 문서는 확인 불가
					}
					
					if (result.data.processorId != null && result.data.processorId != "" && result.data.processorId != userId) {
						mode = "NOTJIJUNG"; //지정상태인데 processorid와 userid가 다르면 화면 보기 x
					}
					
					if (result.data.processDocId != null && result.data.processDocId != "") {
						mode = "SUSINING"; // 접수 후 처리중이면 진행 문서 보기					
					}					
				}
				
			},
			error: function (xhr, status, e) {
				alert("에러가 발생했습니다.");
				return;
			}
		});
		
		if (mode == "ERROR" || mode == "NOTEXIST" || mode == "HWESONG" || mode == "NOTJIJUNG") {
			openLocation = null;
			return openLocation;
		}
		
		if (mode == "SUSINING") {
			paramObj["listType"] = "3";
			openLocation = makeOpenDocViewLink(paramObj);
			return openLocation;
		}
		
		var pURL = docInfo.data.href;
		var relayG_type = docInfo.relayG_type;
		var useWebHWP = docInfo.useWebHWP;
		var docType = docInfo.data.docType;
		var orgDocID = docInfo.data.orgDocID; 
		
		var formUrlExt = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
		var isMht = formUrlExt == "mht" || (formUrlExt != "hwp" && relayG_type.toUpperCase() == "MHT");
		
		if (isMht) {
            openLocation = "";
            
            if (docType == "001") {
            	openLocation = "/ezApprovalG/recevG.do";
            } else {
            	openLocation = "/ezApprovalG/recevGSusin.do";
            }
            
            openLocation = openLocation + "?docID=" + encodeURI(p_docID) + "&draftFlag=" + encodeURI(pDraftFlag);
            openLocation = openLocation + "&uOrgID=" + encodeURI(orgDocID);
        } else {
        	if(useWebHWP == "NO") {
                if (CrossYN() && isIE()) {
                	if (formUrlExt == "hwp" || relayG_type.toUpperCase() == "HWP") {
            			openLocation = "/ezApprovalG/ezRecevGSusinHWP.do?docID=" + escape(p_docID) + "&draftFlag=" + escape(pDraftFlag) + "&uOrgID=" + encodeURI(orgDocID);
                    }
            	 } else {
            		 alert("한글양식은 IE에서만 볼 수 있습니다.");
                     return;
            	 }
        	} else {
        		openLocation = "/ezApprovalG/ezRecevGSusinWHWP.do?docID=" + escape(p_docID) + "&draftFlag=" + escape(pDraftFlag) + "&uOrgID=" + encodeURI(orgDocID);
        	}
        }
		
		return openLocation;
	}
	
	function makeCompleteDocLink(docInfo) {
        var tempURL = docInfo.data.href;
        var useWebHWP = docInfo.useWebHWP;
        var orgCompanyID = docInfo.data.companyID;
        var docID = docInfo.data.docID;
        var pURL = docInfo.data.href;
        var formid = docInfo.data.formID;
        var approvalFlag = docInfo.approvalFlag;
        var docState =  docInfo.data.docState;
        var containerState = ""; // g 버전 회송함의 완료문서 보기 에서 사용. 회송함의 경우 032로 설정해서 사용하면 됨.
        var orgdocid = docInfo.data.orgDocID == null ? "" : docInfo.data.orgDocID;
        var hasopinionyn = docInfo.data.hasOpinionYn;
        var openLocation;
        var tempURL = pURL;
        var tempExt = tempURL.substr(tempURL.length - 3, tempURL.length).toLowerCase();
        
        if (tempURL.substr(tempURL.length - 4, tempURL.length).toLowerCase() == ".ezd") {
        	tempURL = tempURL.substr(0, tempURL.length - 4);
        }
        
        if (tempURL.substr(tempURL.length - 3, tempURL.length).toLowerCase() == "hwp") {
        	if(useWebHWP == "NO") {
            	if (isIE()) {
	                openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
                } else {
                	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                	alert(pAlertContent);
                    return;
                }
        	} else {
           		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
        	}
        } else {
       		openLocation = "/ezApprovalG/contDocView.do";
        }
        
        openLocation = openLocation + "?docID=" + encodeURI(docID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(formid) + "&orgDocID=" + encodeURI(orgdocid) + "&docState=" + docState + "&containerState=" + encodeURI(containerState) + "&orgCompanyID=" + encodeURI(orgCompanyID);
        
        return openLocation;
	}
	
</script>
</body>

</html>