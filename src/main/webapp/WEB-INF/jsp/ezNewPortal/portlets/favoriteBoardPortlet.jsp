<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
    <input type="hidden" value="<c:out value='${usedTheme }'/>" id="usedTheme">
    <article class="board box_shadow favoriteBoardPortlet">
    	<input type="hidden" value="" class="favoriteBoardPorlet"/>
        <div class="layDIV">
            <div class="sortablePortlet">
                <dl class="portlet_tab sortablePortlet" id="BoardTab"></dl>
                <%-- 2023-06-23 황인경 - 디자인 개선 > 즐겨찾기 포틀릿 > '+' 더보기 태그 위치 변경 --%>
                <dl class="portlet_tab_plus" id="BoardTabPlus"></dl>
            </div>
            <ul class="portlet_list portletPagingArea" id="BoardList"></ul>
        </div>
        <div class="portletPageNav">
    		<span class="portlet_list_nav prev"></span>
    		<span class="portlet_list_nav next"></span>
    	</div>
    </article>
</body>
</html>