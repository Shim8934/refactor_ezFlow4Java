<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t998' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <style>
			.mainlist tr th{white-space:normal; word-break:break-all;}
			.mainlist tr select{max-width:100%;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">

		var notUsed = "${notUserMobileLogin}";
		var adminOrder = "${adminOrder}";
		var setUsed = 0;
		var xhttp = null;

		window.onload = function() {
			// 관리자 사용안함 처리 
			if (adminOrder == "1") {
				$('#chkMobileNotUse').prop('checked', true);
				$('#chkMobileNotUse').prop('disabled', true);
				$('select[name=selectbox]').attr('disabled', true);
				$('.ftbt').attr('disabled', true).css('cursor', 'default');
			}
			
			// 사용자 사용안함 처리
			if (notUsed == "1") {
				$('#chkMobileNotUse').prop('checked', true);
			}
		};

		// 기기별 사용여부 selectBox changed // Section? S:P
	    function selectChange(devid, obj, section) {
            setDevice(devid, obj.options[obj.selectedIndex].value, section);
	    }
	
		// 취소버튼
		function cancel_onclick() {
    		window.close();
		}
		
		// 사용안함 체크박스 상태 변경 
		function changeChk(obj) {
			if ($('#chkMobileNotUse').is(":checked")) {
				setUsed = 1;
			} else {
				setUsed = 0;
			}
		}
		
		// 전체 사용안함 버튼 
		function setNotUsedStatus() {
			xhttp = createXMLHttpRequest();
			xhttp.onreadystatechange = loader;
			xhttp.open("POST", '/ezPersonal/setMobileManaged.do?pNotUsed=' + setUsed);
			xhttp.send();
		}
		
		// 기기별 사용여부 selectBox changed
	    function setDevice(devId, state, section) {
	    	xhttp = createXMLHttpRequest();
			xhttp.onreadystatechange = loader;
			xhttp.open("POST", "/ezPersonal/setMobileDeviceInfo.do?pDevId=" + devId + "&pState=" + state);
			xhttp.send();
	    }
		
		// 기기 삭제 버튼 
	    function deleteDevice(devid) {
			if (confirm("<spring:message code='ezPortal.t54' />")) {
		    	xhttp = createXMLHttpRequest();
		    	xhttp.onreadystatechange = loader;
				xhttp.open("POST", "/ezPersonal/deleteMobileDeviceManaged.do?pDevId=" + devid);
				xhttp.send();
			}
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
		</script>
	</head>
	<body class="popup">
    	<h1><spring:message code='ezPersonal.t998'/></h1>
    	<div id="close">
        	<ul>
            	<li><span onclick="cancel_onclick()"></span></li>
        	</ul>
    	</div>
    	<table class="content">
        	<tr>
            	<th>
            		<span><strong><spring:message code="ezPersonal.t1000" /></strong></span>
            	</th>
            	<td class="pos1" colspan="2">
	                <input id="chkMobileNotUse" name="chkMobileNotUse" type="checkbox" 
	                	<c:if test="${notUserMobileLogin eq 1}"> checked="checked" </c:if> onchange="changeChk(this);" />
	                <span id="" style="color:#000000"> (※<spring:message code="ezPersonal.kyj03" />)</span>
				</td>
			</tr>
    	</table>
    	<div class="btnposition">
    		<input type="submit" name="btnMobilManaged" value="<spring:message code="ezPersonal.t34" />" id="btnMobilManaged" class="ftbt" onclick="setNotUsedStatus();">
    	</div>
    	<br/>
    	<table class="mainlist" style="width:100%; overflow-x: hidden; overflow-y: scroll;">
            <tr>
                <th width='50%'><spring:message code="ezPersonal.kyj01" /></th>
                <th width='15%'><spring:message code="ezPersonal.t513" /></th>
                <th width='15%'><spring:message code="ezApproval.t367" /></th>
				<th width='15%'><spring:message code="ezPersonal.kdh15" /></th>
                <th width='15%'><spring:message code="ezPersonal.kyj02" /></th>
            </tr>
            <c:if test="${deviceInfo ne null}">
	    		<c:forEach items="${deviceInfo}" var="list">
					<c:set var="deviceType" value="${list.devType}"></c:set>
					<c:set var="type" value="${list.type}"></c:set>
		            <c:set var="notUsed" value="${list.notUsed}"></c:set>
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
							<select name="selectbox" id='selectChangeState' onchange='selectChange("${list.devId}",this,"S")'>
								<option value='0' <c:if test="${notUsed eq 0}"> selected="selected" </c:if>><spring:message code="ezPersonal.t937" /></option>
								<option value='1' <c:if test="${notUsed ne 0}"> selected="selected" </c:if>><spring:message code="ezPersonal.t1000" /></option>
							</select>
						</td>
						<td>${list.regDate}</td>
						<td>${list.appVersion}</td>
						<td class='btnposition' style="text-align:left;">
							<input class='ftbt' type='button' value='<spring:message code="ezPersonal.t99" />' style='cursor:pointer;' onclick="deleteDevice('${list.devId}')" />
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
	</body>
</html>