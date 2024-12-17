<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>SYSTEM CONFIG 
		<c:choose>
			<c:when test="${flag eq 'add'}"><spring:message code = 'ezSystem.w007' /></c:when>
			<c:when test="${flag eq 'mod'}"><spring:message code = 'ezSystem.w008' /></c:when>
		</c:choose>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="SHORTCUT ICON" href="${util.addVer('/images/favicon/favicon.png')}">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var companyID = "<c:out value='${companyID}'/>";
			var ReturnFunction;
			var RetValue;
			var flag = "<c:out value='${flag}' />";
			var nowDate = new Date();
			var useLang = "<c:out value='${useLang}' />";
			window.onload = window_onload;
			function window_onload() {
				try {
					RetValue = parent.add_systemconfig_dialogArguments[0];
					ReturnFunction = parent.add_systemconfig_dialogArguments[1];
				} catch (e) {
					try {
						RetValue = opener.add_systemconfig_dialogArguments[0];
						ReturnFunction = opener.add_systemconfig_dialogArguments[1];
					} catch (e) {
						RetValue = window.dialogArguments;
					}
				}
				
				try {
					var ua = navigator.userAgent;
					if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
						var input = document.getElementsByTagName("input");
						for (var i = 0; i < input.length; i++) {
							if (input[i].getAttribute("type") == "text")
							KeEventControl(input[i]);
						}
					}
				}
				catch (e) {
					
				}
				
				makePrefixCode();
				
			}

			function OK_Click() {
				var code = "";
				if (flag == "add") {
					code = document.getElementById('prefixCode').value + document.getElementById('suffixCode').value 
				} else {
					code = document.getElementById('code').value;
				}
				
				var typeSelectElem = document.getElementById('typeSelect');
		        var typeCode = typeSelectElem.value;
				
		        if (typeCode == "") {
		        	alert("<spring:message code = 'ezSystem.config.hth02'/>");
		        	return;
		        }
		        
				if (flag == 'add') {
					var suffixCodeElem = document.getElementById('suffixCode'); 
					if (suffixCodeElem.value == "") {
			            alert("<spring:message code = 'ezSystem.w013'/>");
			            document.getElementById('suffixCode').focus();
			            return;
			        }
					
					if (suffixCodeElem.value.length + document.getElementById('prefixCode').value.length > 20) {
						alert("<spring:message code = 'ezSystem.config.hth03'/>");
						suffixCodeElem.focus();
						return;
					}
					
					if (!isValidCode(suffixCodeElem.value)) {
						alert("<spring:message code = 'ezSystem.config.hth04'/>");
						suffixCodeElem.focus();
						return;
					}
					
					var isDuplicate = false;
					checkDuplicateCode(code, function(duplicateCodeChk) {
						if (duplicateCodeChk == "AVAILABLE") {
							
				        } else if (duplicateCodeChk == "DUPLICATE") {
				        	alert("<spring:message code = 'ezSystem.config.hth05'/>");
				        	suffixCodeElem.focus();
				        	isDuplicate = true;
				        } else {
				        	alert("<spring:message code = 'ezSystem.config.hth06'/>");
				        	isDuplicate = true;
				        }
					});
					
					if (isDuplicate) {
						return;
					}
					
				}

		        if (get_length(document.getElementById("codevalue").value) > 8000) {
		            alert("<spring:message code = 'ezSystem.w014'/>");
		            return;
		        }
				
		        var codeValue = document.getElementById("codevalue").value.trim();
		        
		        if (codeValue == "") {
		        	alert("<spring:message code = 'ezSystem.config.hth30'/>");
		        	return;
		        }
		        
		        var description = document.getElementById("description").value.trim();
		        
		        if (description == "") {
		        	alert("<spring:message code = 'ezSystem.config.hth31'/>");
		        	return;
		        }
		        
				var objRoot, objNode;
				var xmlDom = createXmlDom();
				var xmlHTTP = createXMLHttpRequest();
				createNodeInsert(xmlDom, objRoot, "DATA"); 
				createNodeAndInsertText(xmlDom, objNode, "FLAG", flag);
				createNodeAndInsertText(xmlDom, objNode, "CODE", code);
				createNodeAndInsertCDataText(xmlDom, objNode, "CODEVALUE", codeValue);
				createNodeAndInsertCDataText(xmlDom, objNode, "DESCRIPTION", description);
				createNodeAndInsertCDataText(xmlDom, objNode, "COMPANYID", companyID);
				createNodeAndInsertCDataText(xmlDom, objNode, "TYPECODE", typeCode);

				xmlHTTP.open("POST", "/admin/ezSystem/saveSystemConfig.do", false);
				xmlHTTP.send(xmlDom);

				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
					alert("<spring:message code = 'ezSystem.w015' />");
				} else {
					alert("<spring:message code = 'ezSystem.w020'/>");

					if (ReturnFunction != null) {
						ReturnFunction("");
					} else {
						window.returnValue = "";
						try{
							window.opener.SystemConfig_List();
						} catch(e) {
						}
					}
					window.close();
				}
			}

			function get_length(chkstr) {
				var length = 0;
				var i;
				
				for (i=0; i<chkstr.length; i++) {
					if (chkstr.charCodeAt(i) > 256) {
						length = length + 2;
					} else {
						length++;
					}
				}
				return length;
			}
			
 			function CLOSE_Click() {
 				window.close();
 			}
 			
 			function makePrefixCode() {
 				if (flag == 'add') {
 					var typeCode = document.getElementById('typeSelect').value;
	 				document.getElementById('prefixCode').value = typeCode;
 				} else if (flag == 'mod') {
 					document.getElementById('typeSelect').setAttribute('disabled', 'disabled');
 					document.getElementById('typeSelect').style.backgroundColor = '#d3d3d3';
 				} else {
 					document.getElementById('typeSelect').setAttribute('disabled', 'disabled');
 				}
 			}
 			
 			function isValidCode(code) {
 			   // 정규 표현식: 영어 알파벳 대소문자, 숫자, _, - 만 허용
 			    const regex = /^[a-zA-Z0-9_-]+$/;
 				var vaildFlag = regex.test(code);  
 			    return regex.test(code);
 			}
 			
 			function checkDuplicateCode(code, callback) {
 				$.ajax({
 					type: "GET",
 					url: "/admin/ezSystem/checkDuplicateCode.do",
 					dataType: "text",
 					data:{
 						code:code,
 						companyID:companyID
 					},
 					async: false,
 					success: function(result) {
 						callback(result);
 					},
 					error: function (xhr, status, e){
 						return "DUPLICATE_CHK_ERROR";
 					}
 				});
 			}
		</script>
	</head>
	<body class = "popup">
		<h1>
			SYSTEM CONFIG 
			<c:choose>
				<c:when test="${flag eq 'add'}">
					<spring:message code = 'ezSystem.w007' />
				</c:when>
				<c:when test="${flag eq 'mod'}">
					<spring:message code = 'ezSystem.w008' />
				</c:when>
			</c:choose>
		</h1>
		<table class="content" style="margin-top:3px">
			<tr> 
		    	<th rowspan="3"><spring:message code = 'ezSystem.w009' /></th>
		    	<th><spring:message code = 'ezSystem.config.hth07' /></th>
		  		<td>
	  				<select id = "typeSelect" onchange="makePrefixCode()">
	  					<c:forEach var="configType" items="${configTypeList}">
	  						<c:choose>
	  						<c:when test="${(configType.typeCode eq configVO.typeCode) && ((flag eq 'mod') or (flag eq 'view'))}">
		  						<option value="${configType.typeCode}" selected>${configType.typeName}</option>
	  						</c:when>
	  						<c:otherwise>
	  							<option value="${configType.typeCode}">${configType.typeName}</option>
	  						</c:otherwise>
	  						</c:choose>
	  					</c:forEach>
	  				</select>
		  		</td>
		  	</tr>
		  	<tr>
		  		<th><spring:message code = 'ezSystem.w010' /></th> 
		  		<td>
		  		<c:choose>
					<c:when test="${flag eq 'add' }">
						<input type="text" id="prefixCode" disabled="disabled" style="width: 30%; background-color:#d3d3d3;"  value=""><input type="text" id="suffixCode" style="width: 70%" value="">
					</c:when>
					<c:when test="${flag eq 'view'}">
						<input type="text" id="code" style="width: 100%;" value="<c:out value = '${configVO.code}' />" readonly="true">
					</c:when>
					<c:otherwise>
						<input type="text" id="code" style="width: 100%; background-color:#d3d3d3;" value="<c:out value = '${configVO.code}' />" readonly="true">
					</c:otherwise>
				</c:choose>
		  		</td>
		  	</tr>
		  	<tr> 
		    	<th>VALUE</th>
		  		<td><textarea <c:if test="${flag eq 'view'}">disabled = "disabled"</c:if> style="min-height:560px;WIDTH:98%;margin:10 10 10 10;" id="codevalue"><c:out value = '${configVO.codeValue}' /></textarea></td>
		  	</tr> 
		  	<tr> 
		    	<th><spring:message code = 'ezSystem.w011' /></th> 
		  		<td colspan="2"><input type="text" id="description" <c:if test="${flag eq 'view'}">disabled = "disabled"</c:if> style="WIDTH: 100%" value="<c:out value = '${configVO.description}' />"></td>
		  	</tr>
		</table> 
		<div class="btnpositionNew">
			<c:if test="${flag ne 'view'}"> 
			    <a class="imgbtn"><span onclick="OK_Click()"><spring:message code = 'ezSystem.kbh09' /></span></a>
			    &nbsp;
		    </c:if>
		    <a class="imgbtn"><span onclick="CLOSE_Click()"><spring:message code = 'ezSystem.config.hth08' /></span></a>
	    </div>
	</body>
</html>