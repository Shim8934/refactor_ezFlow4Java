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
			<c:choose>
				<c:when test="${usedTheme eq 3 }">
					<div class="sortablePortlet">
						<dl class="portlet_tab">
							<dt class="portletText" id="tabBoardPortletName"><span><c:out value='${portletName }'/></span></dt>
							<dt id="tabBoardList1Tab"   onclick="return tapBoardChangeTab(this, 'tabBoardList1')" class="tabBoardTab" style="display: none;"><span></span></dt>
							<dt id="tabBoardList2Tab"   onclick="return tapBoardChangeTab(this, 'tabBoardList2')" class="tabBoardTab" style="display: none;"><span></span></dt>
							<dt id="tabBoardList3Tab"   onclick="return tapBoardChangeTab(this, 'tabBoardList3')" class="tabBoardTab" style="display: none;"><span></span></dt>
						</dl>
					</div>
				</c:when>
				<c:otherwise>
					<dl class="sortablePortlet portlet_tab">
							<dt class="portletText" id="tabBoardPortletName"><span><c:out value='${portletName }'/></span></dt>
							<dt id="tabBoardList1Tab"   onclick="return tapBoardChangeTab(this, 'tabBoardList1')" class="tabBoardTab" style="display: none;"><span></span></dt>
							<dt id="tabBoardList2Tab"   onclick="return tapBoardChangeTab(this, 'tabBoardList2')" class="tabBoardTab" style="display: none;"><span></span></dt>
							<dt id="tabBoardList3Tab"   onclick="return tapBoardChangeTab(this, 'tabBoardList3')" class="tabBoardTab" style="display: none;"><span></span></dt>
					</dl>
				</c:otherwise>
			</c:choose>
			<dl class="portlet_tab_plus">
				<dd class="portletPlus" id="tabBoardPlus" onclick="tabBoardPlus()">
					<img src="/images/ezNewPortal/portlet_Plus<c:out value='${usedTheme }'/>.png">
				</dd>
			</dl>
			<div id="notexistence" class="portlet_list">
				<dl class='nodata' id="notexistence">
					<dt><img src='/images/kr/main/noData_sIcon.png'></dt>
					<dd><spring:message code='ezNewPortal.t018' /></dd>
				</dl>
			</div>
			<ul class="portlet_list portletPagingArea" id="tabBoardList1" style="display: none;"></ul>
			<ul class="portlet_list portletPagingArea" id="tabBoardList2" style="display: none;"></ul>
			<ul class="portlet_list portletPagingArea" id="tabBoardList3" style="display: none;"></ul>
    	</div>
    	<div id="tabBoardBtnDiv">
    		<span class="portlet_list_nav prev" id="tabBoardPrevBtn"></span>
    		<span class="portlet_list_nav next" id="tabBoardNextBtn"></span>
    	</div>
    </article>
</body>
</html>