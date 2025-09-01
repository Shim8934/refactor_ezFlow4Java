<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html class="frame_main">
<title>
	<spring:message code='ezApprovalG.lhr001'/>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</title>
<body>
<iframe id="left"
		src="/admin/ezApprovalG/apprGDocListAdminLeft.do?listType=${listType}&selectDeptID=${selectDeptID}"
		name="left"></iframe>
<iframe src="" id="right" name="right"></iframe>
</body>
</html>