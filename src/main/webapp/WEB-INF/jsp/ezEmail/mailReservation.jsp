<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.t601' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
		<style> 
		.imgbtn_h { height:auto; } 
		</style>
		
		<script>
			var shareId = "${shareId}";
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
					alert("<spring:message code='ezEmail.t603' />" + xmlHTTP.status);
					xmlHTTP = null;
				}
				else 
				{
					xmlHTTP = null; 
					element.parentElement.parentElement.parentElement.parentElement.removeChild(element.parentElement.parentElement.parentElement);

					alert("<spring:message code='ezEmail.t604' />");
				}
			}
			
			function View_ReservationMail(pMessageID, pSendDate) {
                $.ajax({
                    url: '/ezEmail/getServerTime.do',
                    method : 'POST',
                    dataType: 'json',
                    success: function(response) {
                        var serverTimeStr = response.serverTime;

                        var sendDate = new Date(pSendDate.replace(" ", "T"));
                        var serverDate = new Date(serverTimeStr.replace(" ", "T"));

                        var gap = sendDate.getTime() - serverDate.getTime();

                        var pWidth = "";
                        var pHeight = "";
                        if(gap/1000/60 < 30) {
                            pUrl = "/ezEmail/mailMessage.do?messageid=" + encodeURIComponent(pMessageID);
                            pWidth = 380;
                            pHeight = 111;
                        } else {
                            pUrl = "/ezEmail/mailWrite.do?cmd=RESERVE&messageid=" + encodeURIComponent(pMessageID);
                            pUrl += shareId? "&shareId=" + encodeURIComponent(shareId) : "";
                            pWidth = 890;
                            pHeight = 840;
                        }

                        var newwin = GetOpenWindow(pUrl, "", pWidth, pHeight, "yes");
                        newwin.focus();
                    },
                    error: function(xhr, status, error) {
                        alert(error);
                    }
                });

		    }
		    
		    // 제목에 태그 입력 후 예약발송 > 예약발송관리에서 확인 시 태그 적용되어 나타나는 현상 수정
		    function removeTag(subject, uid) {
		    	document.getElementById(uid).innerHTML = subject;
		    	document.getElementById(uid).parentNode.title = subject;
		    }
		    
		</script>
	</head>
	
	<body scroll="no" class="popup"> 
		<form method="post">
		<h1 style="margin-bottom: 0px;"><spring:message code='ezEmail.t605' /></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window.returnValue=0;window.close()"></span></li>
		  </ul>
		</div>
		<div style="margin-bottom: 7px;">
			<span><spring:message code='ezEmail.ksaReservation01' /></span>
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
						<td  title="" style="text-overflow:ellipsis; overflow:hidden;white-space:nowrap;"><span id="${item.messageId}" style="cursor:pointer;" onClick="View_ReservationMail('${item.messageId}', '${item.sendDate}')">
							<script>removeTag('<c:out value="${item.subject}" />', '${item.messageId}')</script></span></td>
						<td style="width:150px;white-space:nowrap;text-align:center;">${item.sendDate}</td>
						<td style="text-align:center;width:100px;white-space:nowrap;"><a class="imgbtn imgbtn_h imgbck"><span  onClick="cancel_mail('${item.messageId}', this)"><spring:message code='ezEmail.t39' /></span></a></td>
					</tr>
				</c:forEach>
			</table>
		</div>
		</form> 
	</body>
</html>



