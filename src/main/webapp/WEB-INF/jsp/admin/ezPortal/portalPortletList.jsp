<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>portlet_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<style>
	    	.mainlist tr td:first-child {
	    		padding-left:15px;
	    	}
	    	.mainlist tr th:first-child {
	    		padding-left:10px;
	    	}
	    </style>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezPortal/functionLib.js"></script>
		<script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
		<script type="text/javascript">
			var g_SelectedObj = null;
			var g_UID = "";
			var g_SearchString = "${pSearchString}";
			var g_PortalGubun = "${portalGubun}";
			var g_intPage  = "${intPage}";
			var g_totalPage= "${totalPage}";
			var g_PortletCategoryXML = "${portletCategoryXML}";
			var g_PortalPageCategoryXML = "${portalPageCategoryXML}";
			var g_PortalPageGubun = "${portalPageGubun}";   // 포탈페이지 구분
			var pNoneActiveX = "${noneActiveX}";
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			function window_onload() {
			    var xmldom = createXmlDom();
				
				if (g_PortletCategoryXML != "")
				{
				    xmldom = loadXMLString(g_PortletCategoryXML);					
					
					for (var i=0; i<xmldom.getElementsByTagName("CATEGORY").length; i++)
					{
					    var lastindex = PortalGubun.length;
						if (getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) == 't4075') {
							var newoption = new Option("<spring:message code='ezPortal.t4075'/>", getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)));	
						} else if (getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) == 't4076') {
							var newoption = new Option("<spring:message code='ezPortal.t4076'/>", getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)));
						} else if (getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) == 't4077') {
							var newoption = new Option("<spring:message code='ezPortal.t4077'/>", getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)));
						} else if (getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) == 't4078') {
							var newoption = new Option("<spring:message code='ezPortal.t4078'/>", getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)));
						}
					    PortalGubun.options[lastindex] = newoption;
						
					    if (g_PortalGubun == getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)))
						    PortalGubun.options[lastindex].selected = true;
					}
				}
	
				xmldom = null;
			}
			
			function setValue(pUID, pObj) {
				g_UID = pUID;
				
				// 선택된 개체가 없는 경우
				if( g_SelectedObj == null )
				{
				    pObj.style.backgroundColor = "#f0f6ff";
					g_SelectedObj = pObj;
				}
				else
				{
				    pObj.style.backgroundColor = "#f0f6ff";
					
					if (pObj != g_SelectedObj) g_SelectedObj.style.backgroundColor = "#FFFFFF";
					g_SelectedObj = pObj;
				}
			}
			
			function selectItem(pUID, pObj) {
			    window.open("/admin/ezPortal/portletEdit.do?uID=" + pUID, "", "height = 420px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes" + GetOpenPosition(540, 380));
			}
			
			// 새로만들기
			function newpage() {
				window.open("/admin/ezPortal/portletEdit.do?mode=new", "", "height = 420px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes" + GetOpenPosition(540, 380));
			}
			
			// 미리보기
			function preview()
			{
				if (g_UID == "")
				{
					alert("<spring:message code='ezPortal.t60'/>");
					return;
				}
				
			    window.open("/admin/ezPortal/portletPreview.do?uID=" + g_UID, "", "height = 400px, width = 500px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(500, 400));
			}
			
			// 검색
			function btnSearch_onClick()
			{
			    var pSearchString = TrimText(ReplaceText(document.getElementById("SearchString").value, "'", ""));
			    window.location.href = "/admin/ezPortal/portletList.do?pSearchString=" + encodeURI(pSearchString) + "&portalGubun=" + PortalGubun.value + "&portalPageGubun=" + g_PortalPageGubun;
			}
			
			function entercheck()
			{
				if (window.event.keyCode == 13)
					btnSearch_onClick();
			}
			
			// 페이지 이동
			function goToPage( r_value )
			{
				if (r_value == "page")
				{
					var movenum = txt_PageInputNum.value;
					
					if (movenum == "")
					{
						alert("<spring:message code='ezPortal.t234'/>");
						return;
					}
					else if ( !is_num(movenum) )
					{
						alert("0 ~ 9 <spring:message code='ezPortal.t235'/>");
						return;
					}
					else if (parseInt(movenum, 10) > parseInt(g_totalPage, 10))
					{
						alert("<spring:message code='ezPortal.t236'/>" + g_totalPage + ") <spring:message code='ezPortal.t237'/>");
						return;
					}
					
					pageChange(movenum);
				}
				else if (r_value == "front")
				{
					if (g_intPage != "1")
					{
						var prevnum = parseInt(g_intPage) - 1
						pageChange(prevnum);
					}
				}
				else if (r_value == "next")
				{
					if (g_intPage != g_totalPage)
					{
						var nextnum = parseInt(g_intPage) + 1
						pageChange(nextnum);
					}
				}
			}
			
			// 페이지 이동
			function pageChange(p_intPage)
			{
			    window.location.href = "/admin/ezPortal/portletList.do?pSearchString=" + escape(g_SearchString) + "&portalGubun=" + PortalGubun.value + "&intPage=" + p_intPage + "&portalPageGubun=" + g_PortalPageGubun;
			}
			
			// 삭제
			function DeletePortlet()
			{
				if (g_UID == "")
				{
					alert("<spring:message code='ezPortal.t238'/>");
					return;
				}
				
				if (confirm("<spring:message code='ezPortal.t54'/>"))
				{
				    var xmlhttp = createXMLHttpRequest();
					xmlhttp.open("POST", "/admin/ezPortal/deletePortlet.do?uID=" + g_UID, false);
					xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
					xmlhttp.send();
					
					if (xmlhttp.responseText == "OK")
						document.location.reload();
					else
						alert("<spring:message code='ezPortal.t239'/>" + xmlhttp.responseText);
					
					xmlhttp = null;
				}
			}
			
			function PortalPageGubun_Change()
			{
				window.location.href = "/admin/ezPortal/portletList.do?portalPageGubun=" + PortalPageGubun.value;
			}
		</script>
	</head>
	<body class="mainbody" onload="javascript:window_onload()">
		<h1><spring:message code='ezPortal.t231'/></h1>
		<div id="mainmenu">
			<ul>
  				<li><span onClick="newpage()"><spring:message code='ezPortal.t247'/></span></li>
  				<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
  				<li><span onClick="DeletePortlet()"><spring:message code='ezPortal.t67'/></span></li>
  				<li><span onClick="preview()"><spring:message code='ezPortal.t63'/></span></li>
			</ul>
		</div>
		<div style="width:100%;">
		<table class="popuplist" width="100%">		
			<tr>
				<th><spring:message code='ezPortal.t252'/></th>
				<td style="width:100%; padding-top:3px;">
					<select name="PortalGubun" id="PortalGubun" style="height: 22px; margin-left:3px;">
						<option value=""><spring:message code='ezPortal.t251'/></option>
					</select>
				
				<input type="text" name="SearchString" id="SearchString" style="width:140px; height: 22px;" value="${pSearchString}" onKeyDown="entercheck()">
                	<a class="imgbtn">
                		<span onClick="btnSearch_onClick()">
                			<spring:message code='ezPortal.t252'/>
                		</span>
                	</a>
                </td>
			</tr>
		</table>
		</div>
		<div class="page">
			<c:choose>
				<c:when test="${intPage != '1'}">
					<img src="/images/page_previous.gif" align="absmiddle" hspace="2" onClick="goToPage('front')" style="cursor:pointer"> <spring:message code='ezPortal.t253'/>${totalPage}<spring:message code='ezPortal.t254'/>
				</c:when>
				<c:otherwise>
					<img src="/images/page_previous.gif" align="absmiddle" hspace="2" onClick="goToPage('front')"> <spring:message code='ezPortal.t253'/>${totalPage}<spring:message code='ezPortal.t254'/>
				</c:otherwise>
			</c:choose>
			
  			<input type="text"name="txt_PageInputNum" style="width:30px" value='${intPage}' onKeyPress="if ( window.event.keyCode == 13 ) { goToPage('page'); }">
  			<c:choose>
  				<c:when test="${intPage != totalPage}">
  					<img src="/images/page_next.gif" align="absmiddle" hspace="2" onClick="goToPage('next')" style="cursor:pointer">
  				</c:when>
  				<c:otherwise>
  					<img src="/images/page_next.gif" align="absmiddle" hspace="2" onClick="goToPage('next')">
  				</c:otherwise>
  			</c:choose>  			
  		</div>
  		<br>
  		<div style="width:100%; border: 1px solid #e8e8e8; border-bottom:0px;">
		<table class="mainlist" style="width:100%;">	
		<tr>
			<th style="width: 300px; border-top:0px;"><spring:message code='ezPortal.t130'/></th>
			<th style="border-top:0px;"><spring:message code='ezPortal.t260'/></th>
		</tr>
		</table>		
		<table class="mainlist" style="width:100%">
			${strHtml}
		</table>
		<script type="text/javascript">    
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		</div>
	</body>
</html>