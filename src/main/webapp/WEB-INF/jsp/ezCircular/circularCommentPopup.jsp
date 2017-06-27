<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezCircular.c1" />" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		
		<script type="text/javascript">
			var circularID = "${vo.circularID}";
			var circularUserID = "${vo.memberID}";
			var status = "${vo.status}";
			var userInfoID = "${userInfo.id}";
		
			$(document).ready(function(){
				getCircularComment();
			});
		</script>
		
	</head>
	<body class="popup">
		<h1>의견목록</h1>
		
		<div id="close">
			<ul>
				<li><span onclick="commentSendMail();">회람확인메일발송</span></li>
				<li><span onclick="closeCircularComment();"><spring:message code='ezResource.t150' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript" >
   			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<table class="mainlist" style="width:100%">
			<tr>
				<th style="width: 51.5px;">의견</th>
				<th style="text-align:right;"><input type='text' id='searchValue' /><a class='imgbtn'><span onclick="getCircularComment()">검색</span></a></th>
			</tr>
			<tr>
				<td style="width: 100%; border:0px;" colspan='2'>
					<table id="comments" style="width:100%">
						<tr>
							<td style="border:0px;">
								<table id="commentUserList" class="mainlist" style="width:100%"></table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>