<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
<script type="text/javascript">
	window.onload = function (){
		get_Sys_Param();
	};
	
	function get_Sys_Param(){
		var list;
		$.ajax({
        	type : "POST",
        	url : "/admin/Ezsystem/getSysParam.do",
        	data : {
        		
        	},
        	success : function(result){		        		
        		list = result;
        	},
        	error : function(error){
        		alert("<spring:message code='ezBoard.t22'/>" + error);	
        	}
        	});
		
	}
	
</script>
<title>Insert title here</title>
</head>
<body>
여기에서 파라미터 이름과 값을 읽고 업데이트 할 것임.
<table>
<tr>
<c:forEach var="param" items="list">
<td>${param}</td>
</c:forEach>
</tr>
</table>
</body>
</html>