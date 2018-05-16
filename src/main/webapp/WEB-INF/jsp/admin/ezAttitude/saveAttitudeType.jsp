<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<c:choose>
				<c:when test="${typeInfo.typeId ne null }">
					<spring:message code='ezAttitude.t39' />
				</c:when>
				<c:otherwise>
					<spring:message code='ezAttitude.t33' />
				</c:otherwise>
			</c:choose>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	
		<script type="text/javascript">
			var companyId = "${companyId}";
			var typeId = "${typeInfo.typeId}";
	        var typeName = "<c:out value = '${typeInfo.typeName}' />";
	        var typeName2 = "${typeInfo.typeName2}";
			var saveMode = "";

			$(function(){
	            //수정모드일 때
	            if(typeId != "") {
	            	saveMode = "modify";
	            	
	            	//휴가유형명
	            	typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&amp;", "&"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"');
					$("#typeName").val(typeName);
	            } else {
	    			typeId = "<c:out value = '${typeId}' />";
	            }
		
			})

			function OK_Click() {
				var typeName = $('#typeName').val();
				var typeName2 = $('#typeName2').val();
				
				if (typeName == "") {
					alert("<spring:message code='ezAttitude.kbm14' />");
					return;
				}
				
				//태그 적용 안되게 하기
				typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), '"',"&quot;");
				
				if (typeName2) {
					typeName2 = ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), '"',"&quot;");
				}
				
				$.ajax({
		        	type : "POST",
		        	url : "/admin/ezAttitude/saveAttitudeType.do",
		        	async : false,
		        	data : {
		        		companyId : companyId,
		        		typeId : typeId,
		        		saveMode : saveMode,
		        		typeName : typeName,
		        		typeName2 : typeName2
		        	},
		        	success : function(result) {
		        			alert("<spring:message code='ezAttitude.bbhs19' />");
		        			window.opener.company_change();
							window.close();
		        	},
		        	error : function() {
		        		alert("<spring:message code='ezAttitude.kbm3' />");
		        	}
		        });
			}
			
			function close_Click() {
				window.close();
			}
			
		</script>
	</head>
	<body class="popup">
		<h1>
			<c:choose>
				<c:when test="${typeInfo.typeId ne null }">
					<spring:message code='ezAttitude.t39' />
				</c:when>
				<c:otherwise>
					<spring:message code='ezAttitude.t33' />
				</c:otherwise>
			</c:choose>
		</h1>
		<table class="content"> 
  			<tr> 
    			<th><spring:message code='ezAttitude.t35' /></th> 
    			<td style="padding:0">
    				<table width="100%">
			        	<tr class="primary">
			          		<th><spring:message code='ezAttitude.t41' /></th>
<%-- 			          		<td><input id="typeName" type="text" style="width:100%" value="<c:out value = '${typeInfo.typeName}' />"></td> --%>
			          		<td><input id="typeName" type="text" style="width:100%" value=""></td>
			        	</tr>
			        	<tr class="secondary">
			          		<th><spring:message code='ezAttitude.t42' /></th>
			          		<td><input id="typeName2" type="text" style="width:100%" value="${typeInfo.typeName2}"></td>
			        	</tr>
    				</table>
    			</td> 
  			</tr>
		</table>
		<div class="btnposition">
	        <a class="imgbtn"><span onclick="OK_Click();" ><spring:message code='ezAttitude.t16' /></span></a>
	        <a class="imgbtn"><span onclick="close_Click();"><spring:message code='ezAttitude.t34' /></span></a> 
	    </div>
	</body>
</html>