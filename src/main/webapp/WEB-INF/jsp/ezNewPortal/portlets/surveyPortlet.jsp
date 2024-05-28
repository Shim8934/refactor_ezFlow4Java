<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
	<article class="box_shadow survey">
		<div class="layDIV pollLay">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<c:out value='${portletName }'/>
				</dt>
				<dd class="portletPlus" id="surveyPlus">
					<img src="/images/ezNewPortal/portlet_Plus<c:out value='${usedTheme }'/>.png">
				</dd>
			</dl>
			<div class="vote_contents">
				<div id="surveyInfo">
					<ul id="surveyUl" class="portlet_list portletPagingArea">
						<!-- <li class="mail_open" ></li> -->
					</ul>
				</div>
			</div>
		</div>
		
		<span class="portlet_list_nav prev" onclick="portletMovePage(<c:out value='${portletId}'/>, 'prev')"></span>
		<span class="portlet_list_nav next" onclick="portletMovePage(<c:out value='${portletId}'/>, 'next')"></span>
	</article>
</body>
</html>