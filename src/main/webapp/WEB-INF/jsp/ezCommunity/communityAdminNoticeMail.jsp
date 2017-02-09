<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t553' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			String.prototype.trim = function()
			{
				return this.replace(/(^\s*)|(\s*$)/g, "");
			}
			
			function SendMail()
			{
				var titleStr	= document.mail.subject.value.trim();
				var contentStr	= document.mail.memo.value.trim();
				
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
					data : {code : '${code}',
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
		<br>
		<br>
		<table class="content" >
			<form action=admin_notice_mail_ok.aspx method=post name=mail>
				<input type="hidden" value="<c:out value = '${code}' />" name="code">
		  		<tr> 
			  		<th><spring:message code='ezCommunity.t210' /></th>
	      			<td><input type="text" name="subject" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" id=subject></td>
				</tr>
				<tr> 
					<th><spring:message code='ezCommunity.t557' /></th>
					<td><textarea name=memo id=memo style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;height:250px"></textarea></td>
				</tr>
			</form>
		</table>
		<br>
		<div class="btnposition">
			<a class="imgbtn"  name="Submit" onClick="SendMail()"><span><spring:message code='ezCommunity.t245' /></span></a>
			<a class="imgbtn"  name="Submit2" onClick="javascript:mail.reset();"><span><spring:message code='ezCommunity.t246' /></span></a>
			<a class="imgbtn"  name="Submit3" onclick="parent.parent.window.close()" ><span><spring:message code='ezCommunity.t21' /></span></a>
		</div>
	</body>
</html>