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
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<%-- 		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script> --%>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
		<script type="text/javascript">
			var companyId = "${companyId}";
			var typeId = "${typeInfo.typeId}";
	        var typeName = "<c:out value = '${typeInfo.typeName}' />";
	        var typeName2 = "<c:out value = '${typeInfo.typeName2}' />";
			var saveMode = "";

			$(function(){
	            //수정모드일 때
	            if(typeId != "") {
	            	//휴가유형명
	            	typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&amp;", "&"), "&#39;", "'"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"'), "&amp;", "&");
					$("#typeName").val(typeName);
					
					if (typeName2 != null && typeName2 != "") {
						typeName2 = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName2, "&amp;", "&"), "&#39;", "'"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"'), "&amp;", "&");
						$("#typeName2").val(typeName2);
					}
	            }
			});

			function OK_Click() {
				var typeName = $('#typeName').val();
				var typeName2 = $('#typeName2').val();
				
				if (typeName == "") {
					alert("<spring:message code='ezAttitude.t186' />");
					return;
				}
				
				//태그 적용 안되게 하기
				typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), "'","&#39;"), '"',"&quot;");
				if (typeName2) {
					typeName2 = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName2, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), "'","&#39;"), '"',"&quot;");
				} else {
					typeName2 = typeName;
				}
				
				$.ajax({
		        	type : "POST",
		        	url : "/admin/ezAttitude/saveAttitudeType.do",
		        	async : false,
		        	dataType : "text",
		        	data : {
		        		companyId : companyId,
		        		typeId : typeId,
		        		typeName : trim_Cross(typeName),
		        		typeName2 : trim_Cross(typeName2)
		        	},
	            	success : function(resultStatus) {
	            		if (resultStatus == "success") {
		            		alert("<spring:message code='ezAttitude.t155' />");
		            		window.opener.company_change();
							window.close();
	            		} else if (resultStatus == "failed") {
	            			alert("<spring:message code='ezAttitude.t223' />");
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
	            	},
		        	error : function() {
		        		alert("<spring:message code='ezAttitude.t175' />");
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
		<div id="close">
            <ul>
                <li><span onclick="close_Click()"></span></li>
            </ul>
        </div>
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
			          		<td><input id="typeName2" type="text" style="width:100%" value=""></td>
			        	</tr>
    				</table>
    			</td> 
  			</tr>
		</table>
		<div class="btnpositionNew">
	        <a class="imgbtn"><span onclick="OK_Click();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>