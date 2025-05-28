<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<c:choose>
			<c:when test="${flag eq 'add'}">
				<title>SYSTEM CONFIG <spring:message code = 'ezSystem.config.hth09' /></title>
			</c:when>
			<c:otherwise>
				<title>SYSTEM CONFIG <spring:message code = 'ezSystem.config.hth10' /></title>
			</c:otherwise>
		</c:choose>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="SHORTCUT ICON" href="${util.addVer('/images/favicon/favicon.png')}">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript">
			var companyID = "<c:out value='${companyID}' />";
			var ReturnFunction;
			var RetValue;
			var flag = "<c:out value='${flag}' />";
			window.onload = window_onload;
			function window_onload() {
				try {
					RetValue = parent.add_configtype_dialogArguments[0];
					ReturnFunction = parent.add_configtype_dialogArguments[1];
				} catch (e) {
					try {
						RetValue = opener.add_configtype_dialogArguments[0];
						ReturnFunction = opener.add_configtype_dialogArguments[1];
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
				catch (e)
				{ }
			}
			
 			function closeAddConfigType() {
 				window.close();
 			}
 			
 			function saveConfigType() {
 				var typeCodeElem = document.querySelector('#typeCode');
 				var typeCode = typeCodeElem.value;
 				var typeName = document.querySelector('#typeName').value;
 				var typeName2 = document.querySelector('#typeName2').value;
 				var description = document.querySelector('#description').value;
 				
 				if (typeCode == "") {
 					alert("<spring:message code = 'ezSystem.config.hth11' />");
 					typeCodeElem.focus();
 					return;
 				}
 				
 				if (typeCode.length > 10) {
 					alert("<spring:message code = 'ezSystem.config.hth12' />");
 					typeCodeElem.focus();
 					return;
 				}
 				
 				if (!isValidCode(typeCode)) {
					alert("<spring:message code = 'ezSystem.config.hth13' />");
					typeCodeElem.focus();
					return;
				}
 				
 				if (flag == "add") {
					var isDuplicate = false;
					checkDuplicateTypeCode(typeCode, function(duplicateCodeChk) {
						if (duplicateCodeChk == "AVAILABLE") {
							
				        } else if (duplicateCodeChk == "DUPLICATE") {
				        	alert("<spring:message code = 'ezSystem.config.hth14' />");
				        	typeCodeElem.focus();
				        	isDuplicate = true;
				        } else {
				        	alert("<spring:message code = 'ezSystem.config.hth15' />");
				        	isDuplicate = true;
				        }
					});
					
					if (isDuplicate) {
						return;
					}
 				}
 				
 				if (typeName == "") {
 					alert("<spring:message code = 'ezSystem.config.hth16' />");
 					document.querySelector('#typeName').focus();
 					return;
 				}
 				
 				if (typeName.length > 20) {
 					alert("<spring:message code = 'ezSystem.config.hth17' />");
 					document.querySelector('#typeName').focus();
 					return;
 				}
 				
 				if (typeName2 == "") {
 					alert("<spring:message code = 'ezSystem.config.hth18' />");
 					document.querySelector('#typeName2').focus();
 					return;
 				}
 				
 				if (typeName2.length > 20) {
 					alert("<spring:message code = 'ezSystem.config.hth19' />");
 					document.querySelector('#typeName2').focus();
 					return;
 				}
 				
 				if (description == "") {
 					alert("<spring:message code = 'ezSystem.config.hth31' />");
 					document.querySelector('#description').focus();
 					return;
 				}
 				
 				$.ajax({
  					type: "POST",
  					url: "/admin/ezSystem/saveSystemConfigTypeCode.do",
  					dataType:"text",
  					data:{
  						typeCode:typeCode,
  						typeName:typeName,
  						typeName2:typeName2,
  						description:description,
  						companyID:companyID,
  						flag:flag
  					},
  					success: function(result) {
  						if (result != "OK") {
  							alert("<spring:message code = 'ezSystem.w015' />");
	  						return;
  						}
  						alert("<spring:message code = 'ezSystem.w020' />");
  						
  						if (ReturnFunction != null) {
  							ReturnFunction("");
  						} else {
  							window.returnValue = "";
  							try{
  								window.opener.addConfigType_complete();
  							} catch(e) {
  							}
  						}
  						window.close();
  					},
  					error: function (xhr, status, e) {
  						alert("<spring:message code = 'ezSystem.w015' />");
  					}
  				});
 				
 			}
 			
 			function isValidCode(code) {
  			   // 정규 표현식: 영어 알파벳 대소문자, 숫자, _, - 만 허용
  			    const regex = /^[a-zA-Z0-9_-]+$/;
  				var vaildFlag = regex.test(code);  
  			    return regex.test(code);
  			}
  			
  			function checkDuplicateTypeCode(typeCode, callback) {
  				$.ajax({
  					type: "GET",
  					url: "/admin/ezSystem/checkDuplicateTypeCode.do",
  					dataType: "text",
  					data:{
  						typeCode:typeCode,
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
 			
 			function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
 			
 			
		</script>
	</head>
	<body class = "popup">
		<h1>
			<c:choose>
				<c:when test="${flag eq 'add'}">
					SYSTEM CONFIG <spring:message code = 'ezSystem.config.hth09' />
				</c:when>
				<c:otherwise>
					SYSTEM CONFIG <spring:message code = 'ezSystem.config.hth10' />
				</c:otherwise>
			</c:choose>
		</h1>
		<table style="width:99.5%">
			<tr>
				<th style="width:30%;"><spring:message code = 'ezSystem.config.hth20' /></th>
				<td style="width:70%;">
				<c:choose>
					<c:when test="${flag eq 'add'}">
						<input id="typeCode" style="width:100%;" type="text">
					</c:when>
					<c:otherwise>
						<input id="typeCode" disabled="disabled" style="width:100%;" type="text" value="<c:out value='${configTypeVO.typeCode}'/>">
					</c:otherwise>
				</c:choose>
				</td>
			</tr>
			<tr>
				<th style="width:30%;"><spring:message code = 'ezSystem.config.hth21' /></th>
				<td style="width:70%;">
				<c:choose>
					<c:when test="${flag eq 'add'}">
						<input id="typeName" style="width:100%;" type="text">
					</c:when>
					<c:otherwise>
						<input id="typeName" style="width:100%;" type="text" value="<c:out value='${configTypeVO.typeName}'/>">
					</c:otherwise>
				</c:choose>
				</td>
			</tr>
			<tr>
				<th style="width:30%;"><spring:message code = 'ezSystem.config.hth22' /></th>
				<td style="width:70%;">
				<c:choose>
					<c:when test="${flag eq 'add'}">
						<input id="typeName2" style="width:100%;" type="text">
					</c:when>
					<c:otherwise>
						<input id="typeName2" style="width:100%;" type="text" value="<c:out value='${configTypeVO.typeName2}'/>">
					</c:otherwise>
				</c:choose>
				</td>
			</tr>
			<tr>
				<th style="width:30%;"><spring:message code = 'ezSystem.w011' /></th>
				<td style="width:70%; height: 50px;">
				<c:choose>
					<c:when test="${flag eq 'add'}">
						<textarea id="description" maxlength="1000" style="width:100%; height:100%; box-sizing: border-box;"></textarea>
					</c:when>
					<c:otherwise>
						<textarea id="description" maxlength="1000" style="width:100%; height:100%; box-sizing: border-box;"><c:out value='${configTypeVO.description}'/></textarea>
					</c:otherwise>
				</c:choose>
			</tr>
		</table>
		<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="saveConfigType()"><spring:message code = 'ezSystem.kbh09' /></span></a>
			&nbsp; 
		    <a class="imgbtn"><span onclick="closeAddConfigType()"><spring:message code = 'ezSystem.w012' /></span></a>
	    </div>
	</body>
</html>