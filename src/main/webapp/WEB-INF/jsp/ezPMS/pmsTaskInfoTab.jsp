<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t256' /></title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">

<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript">
	var taskDetails;
	var nowStatus;
	
	$(function(){
		taskDetails = ${taskDetails};
		
		var preTaskId = "${taskDetails.pretask}";
		
		var preTaskTR = $("[taskid$='_t" + preTaskId + "']", parent.opener.document);
		var preTaskName = preTaskTR.find("input[name='name']").val();
		
		if(typeof preTaskName != 'undefined') {
			$(".preTaskName").text(preTaskName);
		} else {
			$(".preTaskName").text('-');
		}
	});
	
	
</script>
<style type="text/css">
.tg    {border-collapse:collapse;border-spacing:0;width:100%;}
.tg tr {height: 30px;}
.tg td {padding:5px 5px;border:1px solid #ccc;}
.tg th {padding:5px 5px;border:1px solid #ccc;width:60px;}
th.overviewTh{height:310px;}
td.overviewTd{vertical-align:top;}
</style>
</head>
<body class="taskInfoTabBody">
	<table class="tg">
	<c:choose>
	<c:when test="${target eq 'task' }">
	  <tr>
	    <th class=""><spring:message code='ezPMS.t57' /></th>
	    <td class="">${taskDetails.writerName}</td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t131' /></th>
	    <td class="">${taskDetails.writeDate}</td>
	  </tr>
	</c:when>
	<c:otherwise>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t57' /></th>
	    <td class="">${taskDetails.creatorName}</td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t131' /></th>
	    <td class="">${taskDetails.createDate}</td>
	  </tr>
	</c:otherwise>
	</c:choose>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t42' /></th>
	    <td class="">${taskDetails.groupName == null ? "-" : taskDetails.groupName}</td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t181' /></th>
	    <td class="preTaskName"></td>
	  </tr>
	  <tr>
	    <th class=""><spring:message code='ezPMS.t267' /></th>
	    <td class="">${taskDetails.weight == null ? "-" : taskDetails.weight}</td>
	  </tr>
	  <tr>
	    <th class="overviewTh"><spring:message code='ezPMS.t66' /></th>
	    <td class="overviewTd">${taskDetails.overview == null ? "-" : taskDetails.overview}</td>
	  </tr>
	</table>
</body>
</html>