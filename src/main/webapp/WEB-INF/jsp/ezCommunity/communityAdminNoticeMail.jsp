<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t553' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			String.prototype.trim = function()
			{
				return this.replace(/(^\s*)|(\s*$)/g, "");
			}
			
			function SendMail()
			{
				var titleStr	= document.mail.subject.value.trim();
				var contentStr	= document.mail.memo.value.trim();
				
				/* 2018-10-23 홍승비 - 커뮤니티 전체메일 발송 시 특수문자 처리 */
				contentStr = MakeXMLString(contentStr);
				// 2018-02-13 천성준
				contentStr = contentStr.replace(/(\n|\r\n)/g, '<br>').replace(/ /g, '&nbsp;');
				
				if( titleStr == "") {
					alert("<spring:message code='ezCommunity.t554' />");
					return;
				}
				
				if( contentStr == "") {
					alert("<spring:message code='ezCommunity.t555' />");
					return;
				}
				
				$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezCommunity/adminNoticeMailOk.do",
					data : {code : '<c:out value="${code}"/>',
							subject : titleStr, 
							memo : contentStr
						   },
					success: function(result){
						if (result["result"] == "OK") {
							alert("<spring:message code='ezCommunity.t559' />");
							mail.reset();
						}
					}
				});
			}
		</script>
		
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezCommunity.t556' /></h1>
		
		<table class="content" style="margin-top:10px">
			<form action=admin_notice_mail_ok.aspx method=post name=mail>
				<input type="hidden" value="<c:out value = '${code}' />" name="code">
		  		<tr> 
			  		<th><spring:message code='ezCommunity.t210' /></th>
	      			<td><input type="text" name="subject" id="subject" style="width:100%;height:23px; box-sizing:border-box;-moz-box-sizing:border-box;" autocomplete="off"></td>
				</tr>
				<tr> 
					<th><spring:message code='ezCommunity.t557' /></th>
					<td style="padding:3px"><textarea name=memo id=memo style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;height:400px;resize:none;overflow: auto;"></textarea></td>
				</tr>
			</form>
		</table>
		<br>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"  name="Submit" onClick="SendMail()"><span><spring:message code='ezCommunity.t108' /></span></a>
			<a class="imgbtn"  name="Submit2" onClick="javascript:mail.reset();"><span><spring:message code='ezCommunity.t109' /></span></a>
			<a class="imgbtn"  name="Submit3" onclick="parent.parent.window.close()" ><span><spring:message code='ezCommunity.t21' /></span></a>
		</div>
	</body>
</html>