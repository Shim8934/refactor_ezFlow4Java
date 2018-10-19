<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <title><spring:message code='ezPortal.pjg11'/></title>
        <script>        
			
			var authkey = "oIc8P7J4MrZk4Ca4BczLODOT8p3g6esZ";
			
			var searchdate = new Date().toISOString().slice(0,10).replace(/-/g,"");
			var data = "AP01";
			
			console.log(searchdate);
			
			$.ajax({
				type     : "get",
				dataType : "json",
				url      : "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey="+authkey+"&searchdate="+searchdate+"&data="+data,
				success  : function(data){
					var parseData = JSON.parse(JSON.stringify(data));
				}
			});
        </script>
	</head>
	<body>
	    
	</body>
</html>