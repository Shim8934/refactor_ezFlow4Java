<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
		<script type="text/javascript">
			var g_SelectedObj = null;
        	var g_UID = "";
        	var g_GubunFlag = "";
        	var g_UseFlag = "";
        	var g_SearchString = "${pSearchString}";
        	var g_PortalGubun = "${portalGubun}";
        	var g_intPage = "${intPage}";
        	var g_totalPage = "${totalPage}";
        	
        	document.onselectstart = function () { return false; };
        	
        	window.onload = function () {
	            try {
    	            pUID = SelectedItems;
        	        g_UID = pUID;
            	    g_SelectedObj = document.getElementById(SelectedItems);
	                g_SelectedObj.setAttribute("class", "on");
            	} catch (e) {
	
    	        }
	        }
        	
        	function setValue(pUID, pUseFG, pObj) {
	            g_UID = pUID;
            	g_UseFlag = pUseFG;
            	
            	if (g_SelectedObj == null) {
	                pObj.style.backgroundColor = "#f1f8ff";
    	            g_SelectedObj = pObj;
        	    } else {
                	pObj.style.backgroundColor = "#f1f8ff";

                	if (pObj != g_SelectedObj) g_SelectedObj.style.backgroundColor = "#FFFFFF";
                	g_SelectedObj = pObj;
            	}
        	}
        	
        	function setValueNew(pUID, pUseFG, pObj) {
	            g_UID = pUID;
    	        g_UseFlag = pUseFG;
    	        
            	if (g_SelectedObj == null) {
	                pObj.setAttribute("class", "on");
    	            g_SelectedObj = pObj;
        	    } else {
                	pObj.setAttribute("class", "on");
                	if (pObj != g_SelectedObj) g_SelectedObj.removeAttribute("class");
                	g_SelectedObj = pObj;
            	}
        	}
        	
        	function selectItem(pUID, pObj) {
	            //return;
            	if (CrossYN())
	                location.href = "/ezPortal/myPortalPage.do?mode=edit&pageID=" + pUID;
    	        else
        	        location.href = "/ezPortal/myPortalPage.do?mode=edit&pageID=" + pUID;
        	}
        	
        	function preview() {
	            if (g_UID == "") {
    	            alert("<spring:message code='ezPortal.t60'/>");
                	return;
            	}
            	window.open("/ezPortal/portalPage.do?mode=view&viewMode=preview&pageID=" + g_UID);
        	}
        	
        	function btnSearch_onClick() {
	            var pSearchString = TrimText(ReplaceText(SearchString.value, "'", ""));
            	var pSearchGubun = "";
            	
            	if (PortalGubun.value == "") {
	                for (var i = 0; i < PortalGubun.length; i++) {
                    	if (PortalGubun[i].value != "") {
	                        if (pSearchGubun == "")
    	                        pSearchGubun += "'" + PortalGubun[i].value + "'";
        	                else
                            	pSearchGubun += ",'" + PortalGubun[i].value + "'";
                    	}
                	}
            	} else {
                	pSearchGubun = "'" + PortalGubun.value + "'";
            	}

	            window.location.href = "portalpage_list.aspx?pSearchString=" + escape(pSearchString) + "&PortalGubun=" + escape(pSearchGubun);
    	    }
        	
	        function entercheck() {
            	if (window.event.keyCode == 13)
	                btnSearch_onClick();
    	    }
	        
	        function goToPage(r_value) {
            	if (r_value == "page") {
	                var movenum = txt_PageInputNum.value;
	
    	            if (movenum == "") {
        	            alert("<spring:message code='ezPortal.t234'/>");
                       	return;
                    } else if (!is_num(movenum)) {
                        alert("0 ~ 9 <spring:message code='ezPortal.t235'/>");
                        return;
                    } else if (parseInt(movenum, 10) > parseInt(g_totalPage, 10)) {
						alert("<spring:message code='ezPortal.t236'/>" + g_totalPage + ") <spring:message code='ezPortal.t237'/>");
                        return;
					}
                	pageChange(movenum);
            	} else if (r_value == "front") {
                	if (g_intPage != "1") {
                    	var prevnum = parseInt(g_intPage) - 1
                    	pageChange(prevnum);
                	}
            	} else if (r_value == "next") {
                	if (g_intPage != g_totalPage) {
	                    var nextnum = parseInt(g_intPage) + 1
    	                pageChange(nextnum);
        	        }
            	}
        	}
	        
        	function pageChange(p_intPage) {
            	window.location.href = "/ezPortal/myPortalPageList.do?&intPage=" + p_intPage;
        	}
        	
        	function usepage() {
	            if (g_UID == "") {
    	            alert("<spring:message code='ezPortal.t240'/>");
        	        return;
	            }

            	if (g_UseFlag == "Y") {
                	alert("<spring:message code='ezPortal.t241'/>");
                	return;
            	}
            	
            	if (confirm("<spring:message code='ezPortal.t242'/>")) {
                	var xmlhttp = createXMLHttpRequest();
                	xmlhttp.open("POST", "/ezPortal/useMyPortalPage.do?uID=" + g_UID, false);
                	xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
                	xmlhttp.send();
                	
                	if (xmlhttp.responseText == "OK") {
                    	window.parent.parent.location = window.parent.parent.location.href;
                	} else {
                    	alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
                	}

                	xmlhttp = null;
            	}
        	}	
		</script>
	</head>
	<body class="mainbody">
    	<h1><spring:message code='ezPortal.t321'/></h1>
    	<div id="mainmenu">
        	<ul>
            	<li><span onclick="preview()"><spring:message code='ezPortal.t63'/></span></li>
            	<li><span onclick="usepage()"><spring:message code='ezPortal.t248'/></span></li>
        	</ul>
    	</div>
		
<!--     	<div class="page"> -->
<%--     		<c:choose> --%>
<%--     			<c:when test="${intPage != '1'}"> --%>
<!--     				<img src="/images/page_previous.gif" align="absmiddle" hspace="2" onclick="goToPage('front')" style="cursor:pointer"> -->
<%--     			</c:when> --%>
<%--     			<c:otherwise> --%>
<!--     				<img src="/images/page_previous.gif" align="absmiddle" hspace="2" onclick="goToPage('front')"> -->
<%--     			</c:otherwise> --%>
<%--     		</c:choose> --%>
<%--         	<spring:message code='ezPortal.t253'/>${totalPage} <spring:message code='ezPortal.t254'/> --%>
<%--         	<input type="text" name="txt_PageInputNum" style="width: 30px" value='${intPage}' onkeypress="if ( window.event.keyCode == 13 ) { goToPage('page'); }"> --%>
<%--         	<c:choose> --%>
<%--         		<c:when test="${intPage != totalPage}"> --%>
<!--         			<img src="/images/page_next.gif" align="absmiddle" hspace="2" style="cursor:pointer" onclick="goToPage('next')"> -->
<%--         		</c:when> --%>
<%--         		<c:otherwise> --%>
<!--         			<img src="/images/page_next.gif" align="absmiddle" hspace="2"> -->
<%--         		</c:otherwise> --%>
<%--         	</c:choose> --%>
<!--     	</div> -->
    	<div class="textbox"><spring:message code='ezPortal.t990023'/></div>
    	<div class="select_themebox">
        	${resultHTML}
    	</div>
    	<c:choose>
			<c:when test="${endPage>0 }">
			<div id="tblPageRayer" style="display: none; width:470px; margin:6px auto; font-size:0">
				<div class="pagenavi">   
					<c:choose>
							<c:when test="${intPage gt 1}">   
								<span onclick="pageChange(1)" class="btnimg first"></span>            
							</c:when>
							<c:otherwise>
								<span class="btnimg first disabled"></span>            
							</c:otherwise>         
					</c:choose>
					<c:choose>
						<c:when test="${startPage gt 1}">
							<span onclick="pageChange(${startPage-1})" class="btnimg prev"></span>              
						</c:when>
						<c:otherwise>
							<span class="btnimg prev disabled"></span>              
						</c:otherwise>                                                                    
					</c:choose>
					<%-- <span class="ptxt" onclick="<c:if test="${intPage gt 1 }">pageChange(${intPage-1})</c:if>"><spring:message code='ezApproval.t931'/></span> --%>                                   
					<c:forEach begin="0" end="${endPage-startPage }" varStatus="status">
						<c:choose>
							<c:when test="${startPage+status.index eq  intPage}">
								<span class="on">${intPage }</span>
							</c:when>
							<c:otherwise>
								<span onclick="pageChange(${startPage+status.index})">${startPage+status.index}</span>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<%-- <span class="ptxt" onclick="<c:if test="${totalPage gt intPage }">pageChange(${intPage+1})</c:if>"><spring:message code='ezApproval.t932'/></span> --%>
					<c:choose>
						<c:when test="${totalPage gt endPage }">
							<span class="btnimg next" onclick="pageChange(${endPage+1})"></span>
						</c:when>
						<c:otherwise>
							<span class="btnimg next disabled"></span>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${totalPage gt intPage }">
							<span class="btnimg last" onclick="pageChange(${totalPage})"></span>
						</c:when>
						<c:otherwise>
							<span class="btnimg last disabled"></span>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			</c:when>
			<c:otherwise>
			<div id="tblPageRayer" style="width:470px; margin:6px auto; font-size:0">
				<div class="pagenavi">  
					<span class="btnimg first disabled"></span>
					<span class="btnimg prev disabled"></span>
					<%-- <span class="ptxt"> <spring:message code='ezApproval.t931'/></span> --%>  
					<span class="on">1</span> 
					<%-- <span class="ptxt"><spring:message code='ezApproval.t932'/></span> --%>
					<span class="btnimg next disabled"></span>
					<span class="btnimg last disabled"></span>
				</div>
			</div>
			</c:otherwise>
			</c:choose>
    	<script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
    	</script>
	</body>
</html>
