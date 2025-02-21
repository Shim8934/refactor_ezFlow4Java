<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>    
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezNotification.hth57' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" /> 
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}" ></script>
	</head>
	<body>
		<input type="hidden" id="notiId" value="<c:out value='${emergencyNotiItem.notiId}'/>">
		<div class="emergency_popup">
	        <h2><spring:message code='ezNotification.hth57' />
	        	<span class="close_btn" onclick="btnClose_onclick()"></span>
	        	<c:if test="${adminFlag == 'Y' or emergencyNotiItem.writerId eq userId}">
		        	<span id="btn_Delete" onclick="delEmergencyNoti()" class="icon16 popup_icon16_delete" style="width:30px; height:30px; position:absolute; right:40px;"></span>
		        </c:if>
	        </h2>
	        <div class="emergency_title"><span><spring:message code='ezNotification.hth89'/></span><p><c:out value='${emergencyNotiItem.notiTitle}'/></p></div>
	        <ul class="emergency_info">
	        	<c:choose>
	        		<c:when test="${not empty emergencyNotiItem.writerPhoto}">
	            		<li class="info_img" onclick="show_personinfo('${emergencyNotiItem.writerId}')"><img src='<c:out value='${emergencyNotiItem.writerPhoto}'/>'></li>
	            	</c:when>
	        		<c:otherwise>
	            		<li class="info_img" onclick="show_personinfo('${emergencyNotiItem.writerId}')"><img src='/images/ezNewPortal/info_pic_none.png'></li>
	        		</c:otherwise>
	        	</c:choose>
				<c:if test="${lang eq '1'}">
					<li class="info_name" onclick="show_personinfo('${emergencyNotiItem.writerId}')"><c:out value='${emergencyNotiItem.writerName}'/><span>(<c:out value='${emergencyNotiItem.writerDeptName}'/>)</span></li>
				</c:if>
				<c:if test="${lang ne '1'}">
					<li class="info_name" onclick="show_personinfo('${emergencyNotiItem.writerId}')"><c:out value='${emergencyNotiItem.writerName2}'/><span>(<c:out value='${emergencyNotiItem.writerDeptName2}'/>)</span></li>
				</c:if>
	            <li class="info_date"><c:out value='${fn:substring(emergencyNotiItem.writeDate, 0, 16)}'/></li>
	        </ul>
	        <div class="emergency_detail">
	            <c:out value='${emergencyNotiItem.notiBody}'/>
	        </div>
    	</div>
		<%-- 팝업 디자인
		<table class="layout" style=width:100%;">
	  		<tbody>
	  			<tr>
	  				<td colspan="4" style="vertical-align: top; height: 10px;">
		      		    <div id="menu">
		        			<ul class="">
		        				<c:if test="${adminFlag == 'Y' or emergencyNotiItem.writerId eq userId}">
		                    		<li id="btn_Delete" onclick="delEmergencyNoti()"><span class="icon16 popup_icon16_delete"></span></li>
		                    	</c:if>
					        </ul>
				        </div>    
				        <div id="close">
					        <ul>
					          <li><span onclick="btnClose_onclick()"></span></li>
					        </ul>
				        </div>
				    </td>
	  			</tr>
	  			<table class="content2" style="width:100%;">
		  			<tr> 
			  			<th style="width:10%"><spring:message code='ezNotification.hth58' /></th>
		      			<td style="width:40%"><c:out value='${emergencyNotiItem.notiTitle}'/></td>
		      			<th style="width:10%"><spring:message code='ezNotification.hth84' /></th>
		      			<td style="width:40%"><c:out value='${fn:substring(emergencyNotiItem.writeDate, 0, 16)}'/></td>
					</tr>
					<tr> 
						<th style="width:10%"><spring:message code='ezBoard.t207' /></th>
						<td style="width:40%"><c:out value='${emergencyNotiItem.writerName}'/></td>
						<th style="width:10%"><spring:message code='main.t75' /></th>
						<td style="width:40%"><c:out value='${emergencyNotiItem.writerDeptName}'/></td>
					</tr>
					<tr>
						<td colspan="4" style="height: 280px;">
						<c:out value='${emergencyNotiItem.notiBody}'/>
						</td>
					</tr>
				</table>
			</tbody>
		</table>
		 --%>
	</body>
	
	<script>
	function btnClose_onclick() {
		parent.document.getElementById('noticeLayer').style.display = "none";
		parent.document.getElementById('noticeLayer').querySelector('#noticeLayerFrame').setAttribute('src', '');
	}
	
	function delEmergencyNoti() {
		if (!confirm("<spring:message code='ezNotification.hth17'/>")) {
			return;
		}
		
		var notiId = document.getElementById('notiId').value;
		$.ajax({
			type: "POST",
			url: "/ezNotification/deleteEmergencyNoti.do",
			dataType:"text",
			data:{
				notiId : notiId
			},
			success: function(result) {
				alert("<spring:message code='ezMain.delete.hth01'/>");
				btnClose_onclick();
			},
			error: function (xhr, status, e) {
				alert("<spring:message code='ezNotification.hth34'/>");
			}
		});
	}
	
	function show_personinfo(userid) {
        var feature = GetOpenPosition(420, 450);
        window.open("/ezCommon/showPersonInfo.do?id=" + userid, "",
		    "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
    }
	</script>
	
</html>
