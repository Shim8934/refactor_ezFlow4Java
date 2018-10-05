<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>portalThemes</title>
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
	</head>
	
	<body class="mainbody">
		<h1>테마관리</h1>
		
		<div id="mainmenu">    
		    <span><b>회사선택 :</b> 
			    <select id="ListCompany" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
			    </select><br /><br />
		    </span>
		</div>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript">
		getCompanies();
		
		document.getElementById("ListCompany").addEventListener('change', function() {
			selectCompanyID();
		});
		
		function getCompanies() {
			$.ajax({
   				type : "post",
   				dataType : "json",
   				url : "/admin/ezNewPortal/getCompanys.do",
   				success: function(result){
   					element = document.getElementById("ListCompany");
   					
   					result.list.forEach(function(vo, index) {
//    							element.innerHTML = "<option value=" + "\"Replace2HTML('${item.cn}')" +"/>" + ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
//     						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
   					});
//    					document.getElementById("ListCompany")
   					//userCompany 자기회사
   					//list 회사목록
   					
   				}
   			});
		}
	
		
	</script>
</html>