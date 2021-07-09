<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Tab Board Portlet</title>
</head>
<body>
	<input type="hidden" value="<c:out value='${usedTheme }'/>" id="usedTheme">
	<article class="box_shadow">
		<div class="layDIV" id="tabBoard">
           <dl class="portlet_tab sortablePortlet">
           		<dt class="portletText" id="tabBoardPortletName"><span><c:out value='${portletName }'/></span></dt>
				<dt id="tabBoardList1Tab"   onclick="return tapBoardChangeTab(this)" class="tabBoardTab" style="display: none;"><span></span></dt>
				<dt id="tabBoardList2Tab"   onclick="return tapBoardChangeTab(this)" class="tabBoardTab" style="display: none;"><span></span></dt>
				<dt id="tabBoardList3Tab"   onclick="return tapBoardChangeTab(this)" class="tabBoardTab" style="display: none;"><span></span></dt>
				<dd class="portletPlus" id="tabBoardPlus" onclick="tabBoardPlus()">
				    <img src="/images/ezNewPortal/portlet_Plus1.png">
				</dd>
		   </dl>
		   <div id="notexistence">
				<dl class='nodata' id="notexistence">
                	<dt><img src='/images/kr/main/noData_sIcon.png'></dt>
                	<dd><spring:message code='ezNewPortal.t018' /></dd>
                </dl>
		   </div>
           <ul class="portlet_list" id="tabBoardList1" style="display: none;"></ul>
           <ul class="portlet_list" id="tabBoardList2" style="display: none;"></ul>
		   <ul class="portlet_list" id="tabBoardList3" style="display: none;"></ul>
    	</div>
    </article>
</body>
</html>