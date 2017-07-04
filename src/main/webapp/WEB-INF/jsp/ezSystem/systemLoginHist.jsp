<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='main.kyj1'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="<spring:message code='main.e15'/>" type="text/css">
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<script type="text/javascript" src=""></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript">

</script>
</head>
<body class="mainbody">
	<h1><spring:message code="main.kyj1"></spring:message></h1>
	<table style="width: 100%; background-color: #e9e9e9; border: 1px solid #d3d2d2; ">
		<tr>
			<td style="margin-bottom: 10px; padding: 5px 5px;">
				<span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t1002'/> : &nbsp;
					<input type="text" id="start_datepicker" style="width: 100px; text-align: center" readonly="readonly" /> ~ 
					<input type="text" id="ended_datepicker" style="width: 100px; text-align: center" readonly="readonly" />
				</span> 
				&nbsp;&nbsp;
				<span id="topmenu" style="width: 500px"><spring:message code="main.kyj6"></spring:message> : &nbsp;
					<select> 
						<option><spring:message code="main.t76"></spring:message></option>
						<option><spring:message code="main.t75"></spring:message></option>
						<option><spring:message code="main.kyj2"></spring:message></option>
						<option><spring:message code="main.kyj3"></spring:message></option>
						<option><spring:message code="main.kyj4"></spring:message></option>
						<option><spring:message code="main.kyj5"></spring:message></option>
					</select>
					<input type="text" style="width: 150px;" />
					<a class="imgbtn" id="btnSearchLoginHist">
						<span><spring:message code="main.kyj7"></spring:message></span>
					</a>
				</span> 
			</td>
		</tr>
	</table>
	<table class="mainlist" style="width:100%;">
		<thead>
			<tr>
				<th><spring:message code="main.t76"></spring:message></th>
				<th><spring:message code="main.t75"></spring:message></th>
				<th><spring:message code="main.kyj2"></spring:message></th>
				<th><spring:message code="main.kyj3"></spring:message></th>
				<th><spring:message code="main.kyj4"></spring:message></th>
				<th><spring:message code="main.kyj5"></spring:message></th>
			</tr>
		</thead>
		<tbody id="loginHistListBody">
		
		</tbody>
	</table>
</body>
</html>