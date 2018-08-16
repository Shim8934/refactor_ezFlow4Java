<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.t601' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		
		<style> 
		.imgbtn_h { height:auto; } 
		</style>
		
		<script>
			var g_bDelete = false;
			var g_drafturl = "${draftUrl}";
            var g_bHardDelete = "0";
            var pUse_Editor = "${useEditor}";
            var pNoneActiveX = "${noneActiveX}";
            document.onselectstart = function () {
                if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
                    return false;
                else
                    return true;
            };
			function cancel_mail(URL, element)
			{
				if (!confirm("<spring:message code='ezEmail.t602' />"))
					return;
				delete_mail(URL, element);
			}

			function delete_mail(URL, element)
			{	
				var xmlHTTP = createXMLHttpRequest();
				xmlHTTP.open("POST", "/ezEmail/mailDeleteReservedMail.do?messageid=" + URL, false);
				xmlHTTP.send();
				
				if(xmlHTTP.status < 200 || xmlHTTP.status > 300)
				{
					alert("<spring:message code='ezEmail.t603' />" + xmlHTTP.statusText);
					xmlHTTP = null;
				}
				else 
				{
					xmlHTTP = null; 
					element.parentElement.parentElement.parentElement.parentElement.removeChild(element.parentElement.parentElement.parentElement);

					alert("<spring:message code='ezEmail.t604' />");
				}
			}
		    function View_ReservationMail(pMessageID) {
		        pUrl = "/ezEmail/mailEdit.do?cmd=EDIT&messageid=" + encodeURIComponent(pMessageID);
		        var newwin = GetOpenWindow(pUrl, "", 890, 840, "yes");
		        newwin.focus();
		    }
		    
		    // 제목에 태그 입력 후 예약발송 > 예약발송관리에서 확인 시 태그 적용되어 나타나는 현상 수정
		    function removeTag(subject, uid) {
		    	document.getElementById(uid).innerText = subject;
		    }
		    
		</script>
	</head>
	
	<body scroll="no" class="popup"> 
		<form method="post">
		<h1><spring:message code='ezEmail.t605' /></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window.returnValue=0;window.close()"></span></li>
		  </ul>
		</div>
		<div class="box" id="maillist" style="overflow:auto; height:250px;margin:0px;padding:0px;border-top:0px;border-right:1px solid #ddd">
			<table class="mainlist" style="table-layout:fixed;width:100%;">
				<tr>
					<th><spring:message code='ezEmail.t98' /></th>
					<th style="width:150px;white-space:nowrap;text-align:center;"><spring:message code='ezEmail.t606' /></th>
					<th style="width:100px;white-space:nowrap;text-align:center;"><spring:message code='ezEmail.t607' /></th>
				</tr>
				<c:forEach var="item" items="${list}">
					<tr>
						<td style="text-overflow:ellipsis; overflow:hidden;white-space:nowrap;"><span id="${item.messageId}" style="cursor:pointer;" onClick="View_ReservationMail('${item.messageId}')">
							<script>removeTag('${item.subject}', '${item.messageId}')</script></span></td>
						<td style="width:150px;white-space:nowrap;text-align:center;">${item.sendDate}</td>
						<td style="text-align:center;width:100px;white-space:nowrap;"><a href="#" class="imgbtn imgbtn_h imgbck"><span  onClick="cancel_mail('${item.messageId}', this)"><spring:message code='ezEmail.t39' /></span></a></td>
					</tr>
				</c:forEach>
			</table>
		</div>
		</form> 
	</body>
</html>



