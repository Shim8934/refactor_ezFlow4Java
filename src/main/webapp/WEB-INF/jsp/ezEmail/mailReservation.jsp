<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezEmail.t601' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<style> 
		.imgbtn_h { height:auto; } 
		</style>
		
		<script>
			var g_bDelete = false;
			var g_drafturl = "${draftUrl}";
            var g_bHardDelete = "0";
            var pUse_Editor = "${useEditor}";
            var p_Use_IE11Browser = "${useIE11Browser}";
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
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var conWidth = pwidth * 0.8;
		        if (conWidth > 890)
		            conWidth = 890;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/ezEmail/mailEdit.do?cmd=EDIT&messageid=" + encodeURIComponent(pMessageID), "Mail_EDIT", feature);
		        }
		        else {
		            if (pUse_Editor == "")
		                window.open("mail_edit.aspx?cmd=EDIT&messageid=" + encodeURIComponent(pMessageID), "Mail_EDIT", feature);
		            else
		                window.open("mail_edit_IE.aspx?cmd=EDIT&messageid=" + encodeURIComponent(pMessageID), "Mail_EDIT", feature);
		        }
		    }
		</script>
	</head>
	
	<body scroll="no" class="popup"> 
		<form method="post"  runat="server">
		<h1><spring:message code='ezEmail.t605' /></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window.returnValue=0;window.close()"><spring:message code='ezEmail.t63' /></span></li>
		  </ul>
		</div>
		<div class="box" id="maillist" style="overflow:auto; height:250px;margin:0px;padding:0px;border-top:0px;">
			<table class="mainlist" style="table-layout:fixed;width:100%;">
				<tr>
					<th><spring:message code='ezEmail.t98' /></th>
					<th style="width:150px;white-space:nowrap;text-align:center;"><spring:message code='ezEmail.t606' /></th>
					<th style="width:100px;white-space:nowrap;text-align:center;"><spring:message code='ezEmail.t607' /></th>
				</tr>
				<c:forEach var="item" items="${list}">
					<tr>
						<td style="text-overflow:ellipsis; overflow:hidden;white-space:nowrap;"><span style="cursor:pointer;" onClick="View_ReservationMail('${item.messageId}')">${item.subject}</span></td>
						<td style="width:150px;white-space:nowrap;text-align:center;">${item.sendDate}</td>
						<td style="text-align:center;width:100px;white-space:nowrap;"><a href="#" class="imgbtn imgbtn_h"><span  onClick="cancel_mail('${item.messageId}', this)"><spring:message code='ezEmail.t39' /></span></a></td>
					</tr>
				</c:forEach>
			</table>
		</div>
		</form> 
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>



