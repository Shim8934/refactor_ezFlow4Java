<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/default_kr.css&#9;" type="text/css">
<script type="text/javascript"
	src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
<script type="text/javascript">
	var list = [];
	
	window.onload = function() {
		get_Sys_Param();
	};

	function get_Sys_Param() {
		$.ajax({
			type : "POST",
			url : "/admin/Ezsystem/getSysParam.do",
			data : {

			},
			async: false,
			success : function(result) {
				list = result;
				for (var i = 0; i < list.length; i++) {
					$("table").append('<tr><th>'+list[i].name+'</th><td>'
					+list[i].value+'</td><td><input type="text" value='+list[i].value+'/></td></tr>');
				}
			},
			error : function(error) {
				alert("<spring:message code='ezBoard.t22'/>" + error);
			}
		});

	}
	
	function update_Sys_Param() {
		
	}
</script>
<title>Insert title here</title>
</head>
<body>
	<form>
	<table>
	<tr>
	<th><spring:message code='main.kms3'/></th>
	<th><spring:message code='main.kms4'/></th>
	<th><spring:message code='main.kms5'/></th></tr>
	</table>
	<span style="text-align: center;">
	<input type="button" value="<spring:message code='main.sp09'/>" onclick="update_Sys_Param()">
	<input type="reset" value="<spring:message code='main.sp11'/>">
	</span>
	</form>
</body>
</html>