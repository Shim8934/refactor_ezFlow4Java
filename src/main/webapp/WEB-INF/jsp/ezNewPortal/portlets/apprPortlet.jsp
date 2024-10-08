<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>apprPortlet</title>
		<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/apprPortlet.js')}"></script>
	</head>
	<body>
		<article class="approval box_shadow">
			<div class="layDIV">
				<dl class="portlet_title sortablePortlet">
					<dt class="portletText">
						<c:out value='${portletName }'/>
					</dt>
					<dd class="portletPlus plus" onclick="Appmore_btnClick('${portletId}')">
					</dd>
				</dl>
            	<ul id ="ApprList${portletId}" class="portlet_list"></ul>
        	</div>
		</article>
		<script type="text/javascript">
			getApprovalList("${cabinetType}", "${portletId}");
			
			apprPortletIDs.push("${portletId}");
			apprPortletTypes.push("${cabinetType}");
		</script>
	</body>
</html>