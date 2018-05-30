<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezCircular.t10'/></title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/Tab.css" type="text/css">
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>	
<script type="text/javascript">
$(function(){
	$("#1tab0").addClass("tabon");
});
	
</script>
<style type="text/css">
#contentArea {
	width : 100%;
	height : 91%;
}
</style>
</head>
<body class="mainbody">
    <h1>프로젝트관리 환경설정</h1>
    <div class="portlet_tabpart01" style="margin-bottom: 10px">
	   <div class="portlet_tabpart01_top" id="tab1">
	   		<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab">기본환경설정</span></p>
	   </div>
	</div>
    <div id="contentArea" style="overflow:auto;">
    	12345
    </div>
</body>
</html>