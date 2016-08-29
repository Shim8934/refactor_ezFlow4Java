<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPortal/functionLib.js"></script>
		<script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
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
	                pObj.style.backgroundColor = "#ECF3BA";
    	            g_SelectedObj = pObj;
        	    } else {
                	pObj.style.backgroundColor = "#ECF3BA";

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
                	xmlhttp.open("POST", "/myoffice/ezPortal/environ/UseMyPortalPage.aspx?uid_=" + g_UID, false);
                	xmlhttp.send();
                	if (xmlhttp.responseText == "OK")
                    	window.parent.parent.location = window.parent.parent.location.href;
                	else
                    	alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);

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
		<%
			int intPage = (request.getParameter("intPage") != null && !request.getParameter("intPage").equals(""))?Integer.parseInt(request.getParameter("intPage")) : 0;
			int totalPage = (request.getParameter("totalPage") != null && !request.getParameter("totalPage").equals(""))?Integer.parseInt(request.getParameter("totalPage")) : 0;
		%>
    	<div class="page">
        	<img src="/images/page_previous.gif" width="15" height="15" align="absmiddle" hspace="2" onclick="goToPage('front')" <% if (intPage != 1){ %>style="cursor:pointer"<% } %>>
        		<spring:message code='ezPortal.t253'/>${totalPage} <spring:message code='ezPortal.t254'/>
        	<input type="text" name="txt_PageInputNum" style="width: 30px" value='${intPage}' onkeypress="if ( window.event.keyCode == 13 ) { goToPage('page'); }">
        	<img src="/images/page_next.gif" width="15" height="15" align="absmiddle" hspace="2" <% if (intPage != totalPage){ %>style="cursor:pointer" onclick="goToPage('next')" <% } %>>
    	</div>
    	<div class="textbox"><spring:message code='ezPortal.t990023'/></div>
    	<div class="select_themebox">
        	<%-- <% for (int i = 0; i < xmldom_3.GetElementsByTagName("UID_").Count; i++){ %>
        		<%if (xmldom_3.GetElementsByTagName("USEFLAG").Item(i).InnerText.Trim() == "Y"){%>
        			<%Response.Write("<script>var SelectedItems='" + xmldom_3.GetElementsByTagName("UID_").Item(i).InnerText + "'</script>"); %>
        			<dl id='<%= xmldom_3.GetElementsByTagName("UID_").Item(i).InnerText %>' onclick="setValueNew('<%= xmldom_3.GetElementsByTagName("UID_").Item(i).InnerText %>', '<%= xmldom_3.GetElementsByTagName("USEFLAG").Item(i).InnerText %>', this)" ondblclick="selectItem('<%= xmldom_3.GetElementsByTagName("UID_").Item(i).InnerText %>', this)">
            			<dt>
                			<div class="onimg"></div>
                			<img src="<%=xmldom_3.GetElementsByTagName("IMAGEURL").Item(i).InnerText %>" width="175" height="140">
                		</dt>
            			<dd><%=xmldom_3.GetElementsByTagName("DISPLAYNAME").Item(i).InnerText %></dd>
        			</dl>
        		<%}else{ %>
        			<dl id='<%= xmldom_3.GetElementsByTagName("UID_").Item(i).InnerText %>' onclick="setValueNew('<%= xmldom_3.GetElementsByTagName("UID_").Item(i).InnerText %>', '<%= xmldom_3.GetElementsByTagName("USEFLAG").Item(i).InnerText %>', this)" ondblclick="selectItem('<%= xmldom_3.GetElementsByTagName("UID_").Item(i).InnerText %>', this)">
            			<dt>
                			<div>
                    			<img src="<%=xmldom_3.GetElementsByTagName("IMAGEURL").Item(i).InnerText %>" width="175" height="140">
            			</dt>
            			<dd><%=xmldom_3.GetElementsByTagName("DISPLAYNAME").Item(i).InnerText %></dd>
        			</dl>
        		<%} %>
        	<%} %> --%>
        	${resultHTML}
    	</div>
    	<script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
    	</script>
	</body>
</html>