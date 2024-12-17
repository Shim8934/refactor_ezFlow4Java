<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t998' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
		
		var userId = "<c:out value='${userId}'/>";
		var userName = "<c:out value='${userName}'/>";
		var adminOrder = "<c:out value='${adminOrder}'/>";
		var setUsed = 0;
		var xhttp = null;
		
		window.onload = function() {
			$('#userInfo').text(userName);
			
			if ($('#notUsed').is(":checked")) {
				setUsed = 1;
			} 
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
		
		// 기기 삭제 버튼 
	    function deleteDevice(devid) {
			if (confirm("<spring:message code='ezPortal.t54' />")) {
		    	xhttp = createXMLHttpRequest();
		    	xhttp.onreadystatechange = loader;
				xhttp.open("POST", "/ezPersonal/deleteMobileDeviceManaged.do?userId=" + userId + "&pDevId=" + devid);
				xhttp.send();
			}
	    }
		
		// 기기별 사용여부 selectBox changed
	    function selectChange(devid, obj) {
            setDevice(devid, obj.options[obj.selectedIndex].value);
	    }
		
		// 기기별 사용여부 selectBox changed
	    function setDevice(devId, state) {
	    	xhttp = createXMLHttpRequest();
			xhttp.onreadystatechange = loader;
			xhttp.open("POST", "/ezPersonal/setMobileDeviceInfo.do?userId=" + userId + "&pDevId=" + devId + "&pState=" + state);
			xhttp.send();
	    }
		
		function loader() {
			xhttp.onreadystatechange = function() {
			    if (this.readyState == 4 && this.status == 200) {
					var response = xhttp.getResponseHeader("Result");
					
			    	if (response == "OK") {
			    	   	alert("<spring:message code='ezOrgan.kyj03' />");
			       	} else if (response == "DELETE") { 
			       		window.location.reload(true);
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
	<body class="popup" style="height:100%;">
		<h1 style="height:30px;"><spring:message code = 'ezPersonal.t998' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<br/>
		<table  class="content">
			<tr>
			  	<th><spring:message code="ezOrgan.kyj08" /></th>
				<td style="padding-left: 5px;">
					<span id="userInfo"></span>
				</td>
			</tr>
			<tr>
			  	<th><spring:message code="ezOrgan.kyj02" /></th>
				<td>
					<input type="checkbox" id="notUsed" value="1" onchange="changeChk(this)" 
						<c:if test="${adminOrder eq 1}"> checked="checked" </c:if> />
				</td>
			</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn">
		    	<span onClick="return setUserMobileInfo()"><spring:message code='ezPersonal.t34' /></span>
		    </a>
		</div>
		<br/>
		<table class="mainlist" id="deviceTbl" style="white-space: nowrap; width:100%;">
			<tr>
				<th width='50%'><spring:message code="ezPersonal.kyj01" /></th>
				<th width='15%'><spring:message code="ezPersonal.t513" /></th>
				<th width='15%'><spring:message code="ezApproval.t367" /></th>
				<th width='15%'><spring:message code="ezPersonal.kdh15" /></th>
				<th width='15%'><spring:message code="ezPersonal.kyj02" /></th>
			</tr>
			<c:if test="${deviceInfo ne null}">
				<c:forEach items="${deviceInfo}" var="list">
					<c:set var="notUsed" value="${list.notUsed}"></c:set>
					<c:set var="deviceType" value="${list.devType}"></c:set>
					<c:set var="type" value="${list.type}"></c:set>
					<c:set var="appVersion" value="${list.appVersion}"></c:set>
					<tr height=24px bgcolor=ffffff>
					<td>
						<c:choose>
							<c:when test="${deviceType eq 'Andr'}">Android</c:when>
							<c:when test="${deviceType eq 'IPHO'}">iPhone</c:when>
							<c:otherwise>${deviceType}</c:otherwise>
						</c:choose>
						${list.subType}
						<c:choose>
							<c:when test="${list.type eq 'talk'}">(<spring:message code="main.kyj01" />)</c:when>
							<c:otherwise>(<spring:message code="main.kyj02" />)</c:otherwise>
						</c:choose>
					</td>
						<td>
							<select name="selectbox" id='selectChangeState' onchange='selectChange("${list.devId}",this)'>
								<option value='0' <c:if test="${notUsed eq 0}"> selected="selected" </c:if>><spring:message code="ezPersonal.t937" /></option>
								<option value='2' <c:if test="${notUsed ne 0}"> selected="selected" </c:if>><spring:message code="ezPersonal.t1000" /></option>
							</select>
						</td>
						<td>${list.regDate}</td>
						<td>${list.appVersion}</td>
						<td class='btnposition' style="text-align:left;">
							<a class="imgbtn">
								<span style='cursor:pointer;' onclick="deleteDevice('${list.devId}')"><spring:message code="ezPersonal.t99" /></span>
							</a>
						</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${deviceInfo eq null}">
				<tr height=24px bgcolor=ffffff>
					<td colspan="5" align="center"><spring:message code='ezOrgan.kyj09' /></td>
				</tr>
			</c:if>
		</table>
		<br/><br/>
	</body>
</html>