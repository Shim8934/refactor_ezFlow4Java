<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>approvalListPortlet</title>
		<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/apprPortlet.js')}"></script>
	</head>
	<body>
		<article class="approval box_shadow">
			<div class="layDIV approval">
				<div class="sortablePortlet portlet_title">
					<dl class="portlet_tab sortablePortlet">
						<dt id="doingTab" class="on" onclick="apprChangeTab(this, '${portletId}')"><span class="longTitle"><spring:message code='main.t00003' /></span></dt>
						<dt id="rejectTab" onclick="apprChangeTab(this, '${portletId}')"><span class="longTitle"><spring:message code='main.t00004' /></span></dt>
						<dt id="draftTab" onclick="apprChangeTab(this, '${portletId}')"><span class="longTitle"><spring:message code='main.t00005' /></span></dt>
						<%-- 2023-06-22 황인경 - 디자인 개선 > 전자결재 포틀릿 > '+' 더보기 태그 위치 변경 --%>
	<%--                <dd class="portletPlus" onclick="Appmore_btnClick()"><img src="/images/ezNewPortal/portlet_Plus<c:out value='${usedTheme }'/>.png"></dd>                	 --%>
					</dl>
					<dl class="portlet_tab_plus">
						<dd class="portletPlus plus" onclick="Appmore_btnClick('${portletId}')"></dd>
					</dl>
				</div>
            	<ul id ="ApprList${portletId}" class="portlet_list"></ul>
        	</div>
		</article>
		<script type="text/javascript">
			getApprovalList("doing", "${portletId}");

			apprPortletIDs.push("${portletId}");
			apprPortletTypes.push("doing");
		</script>
	</body>
</html>