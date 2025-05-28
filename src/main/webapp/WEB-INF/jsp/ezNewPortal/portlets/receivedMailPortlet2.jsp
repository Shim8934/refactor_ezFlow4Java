<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<article class="mail box_shadow">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<c:out value='${portletName }'/>
				</dt>
				<dd class="portletPlus plus" onclick="Mailmore_btnClick2('${MailServerURL2}')">
				</dd>
				<dd class="mailGraph" id="mailGraph2"></dd>
			</dl>
			<ul id="MailList2" class="portlet_list portletPagingArea"></ul>
		</div>
		<div class="portletPageNav">
            <span class="portlet_list_nav prev"></span>
            <span class="portlet_list_nav next"></span>
        </div>
	</article>
</body>
</html>
