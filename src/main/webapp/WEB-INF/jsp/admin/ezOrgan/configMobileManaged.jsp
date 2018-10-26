<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t998' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet"	href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
		
		var userId = "${userId}";
		var userName = "${userName}";
		var adminOrder = "${adminOrder}";
		var setUsed = 0;
		var xhttp = null;
		
		window.onload = function() {
			$('#userInfo').text(userName);
		}
		
		function changeChk(obj) {
			if ($('#notUsed').is(":checked")) {
				setUsed = 1;
			} else {
				setUsed = 0;
			}
		}
		
		// 사용자별 사용안함 체크박스 값 저장 
		function setUserMobileInfo() {
			xhttp = createXMLHttpRequest();
			xhttp.onreadystatechange = loader;
			xhttp.open("GET", "/admin/ezOrgan/setUserMobileManaged.do?userId=" + userId + "&setUsed=" + setUsed);
			xhttp.send();
		}
		
		function loader() {
			xhttp.onreadystatechange = function() {
			    if (this.readyState == 4 && this.status == 200) {
			       	if (xhttp.getResponseHeader("customStatus") == "OK") {
			    	   	alert("<spring:message code='ezOrgan.kyj03' />");
			    	   	cancel_onclick();
			       	} else {
			    		alert("<spring:message code='ezOrgan.kyj04' />");
			    	}
			       
			       xhttp = null;
			    }
			};
		}
		
		// 취소 버튼 
		function cancel_onclick() {
			window.close();
		}	
		</script>
	</head>
	<body class="popup" >
		<h1 style="height:30px;"><spring:message code = 'ezPersonal.t998' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<br/>
		<table  class="content">
			<tr>
			  	<th>사용자 정보</th>
				<td style="padding-left: 5px;">
					<span id="userInfo"></span>
				</td>
			</tr>
			<tr>
			  	<th>사용안함</th>
				<td>
					<input type="checkbox" id="notUsed" value="1" onchange="changeChk(this)" 
						<c:if test="${adminOrder eq 1}"> checked="checked" </c:if> />
				</td>
			</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn">
		    	<span onClick="return setUserMobileInfo()"><spring:message code='ezOrgan.t124' /></span>
		    </a>
		</div>
	</body>
</html>