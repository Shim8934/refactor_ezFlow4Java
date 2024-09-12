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
	<article class="box_shadow tabBoard">
		<input type="hidden" value="" class="tabBoardPorlet"/>
		<div class="layDIV" id="tabBoard">
			<dl class="sortablePortlet portlet_tab">
					<dt class="portletText" id="tabBoardPortletName"><span><c:out value='${portletName }'/></span></dt>
					<dt id="tabBoardList1Tab" class="tabBoardTab" style="display: none;"><span class="longTitle"></span></dt>
					<dt id="tabBoardList2Tab" class="tabBoardTab" style="display: none;"><span class="longTitle"></span></dt>
					<dt id="tabBoardList3Tab" class="tabBoardTab" style="display: none;"><span class="longTitle"></span></dt>
			</dl>
			<dl class="portlet_tab_plus">
				<dd class="portletPlus plus" id="tabBoardPlus" onclick="tabBoardPlus()"></dd>
			</dl>
			<div id="notexistence" class="portlet_list" style="display:none;">
				<dl class='nodata'>
					<dt><img src='/images/kr/main/noData_sIcon.png'></dt>
					<dd><spring:message code='ezNewPortal.t018' /></dd>
				</dl>
			</div>
			<ul class="portlet_list portletPagingArea" id="tabBoardList1" style="display: none;"></ul>
			<ul class="portlet_list portletPagingArea" id="tabBoardList2" style="display: none;"></ul>
			<ul class="portlet_list portletPagingArea" id="tabBoardList3" style="display: none;"></ul>
    	</div>
    	<div id="tabBoardBtnDiv" class="portletPageNav">
    		<span class="portlet_list_nav prev"></span>
    		<span class="portlet_list_nav next"></span>
    	</div>
    </article>
</body>
</html>