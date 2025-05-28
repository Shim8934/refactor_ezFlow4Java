<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>guest_edit</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<c:if test="${mode == 'edit' && bIsMyContent == false}">
			<script type="text/javascript">
				alert("<spring:message code='ezCommunity.t567' />");
				window.history.back();
			</script>
		</c:if>
		
		<script type="text/javascript">
			function sendit() {
				if (document.getElementById("memo").value == "") {
					alert("<spring:message code='ezCommunity.t568' />\n<spring:message code='ezCommunity.t569' />");
					document.getElementById("memo").focus();
					
					return;
				}
				
				//2018-07-02 김보미 - 개행문자 -> <br>태그로 변경
				var memo = $("#memo").val();
				//memo = memo.replace(/(?:\r\n|\r|\n)/g, "<br>");

				//2018-07-16 김보미 - 특수문자, 개행처리
				/* var memoTemp = $("#memo").val();
				memoTemp = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(memoTemp, "&", "&amp;"), "&lt;", "<"), "&gt;", ">"), "&quot;", "'"),"&dquot;", '"');
				memo = memoTemp.split("\n"); */
				
				$.ajax({
		        	type : "POST",
		        	url : "/ezCommunity/guestEditOk.do",
		        	async : false,
		        	data : {c_no : $("#c_no").val(),
		        			name : $("#name").val(),
		        			code : $("#code").val(),
		        			mode : $("#mode").val(),
 		        			memo : encodeURIComponent(memo)
//		        			memo : JSON.stringify(memo)
		        			},
		        	success : function(result) {
		        		goPage(1);
	        		}
		        });
			}
			
			function goPage(idx) {
				var url = "";
				
				switch(idx) {
					case 1:
						url = "/ezCommunity/guestOne.do?code=" + '<c:out value="${code}"/>';
						break;					
				}
				
			    window.location.href = url;
			}
				
			
			/* function checkIsZenkaku(value) { 
				for (var i = 0; i < value.length; ++i) { 
					var c = value.charCodeAt(i);
					
					if (c < 256 || (c >= 0xff61 && c <= 0xff9f)) { 
						return false; 
					} 
				}
				
				return true; 
			} */
		</script>
	</head>
	<body class="cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezCommunity.t570' /></h1>
				
		<div id="mainmenu">
			<ul>
				<li><span onclick="goPage(1)"><spring:message code='ezCommunity.t168' /></span></li>
				<li><span onclick="javascript:sendit()"><spring:message code='ezCommunity.t20' /></span></li>
				<%-- 18-04-30 방명록 작성/수정 중 취소 수정
				<li><span onclick="javascript:webpds.reset();"><spring:message code='ezCommunity.t109' /></span></li>		 --%>		
				<li><span onclick="javascript:history.go(-1)"><spring:message code='ezCommunity.t109' /></span></li>		
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<form action="/ezCommunity/guestEditOk.do" method="POST" name="webpds">
	        <input type="hidden" id="c_no" value="<c:out value = '${no}' />">
	        <input type=hidden id="name" value="<c:out value = '${item.id}' />">
	        <input type=hidden id="code" value="<c:out value = '${code}' />">
	        <input type=hidden id="mode" value="<c:out value = '${mode}' />">
	        
			<table class="content" style="margin-top:12px">
	        	<tr>
					<th><spring:message code='ezCommunity.t138' /></th>
					<!-- 18-04-30 김민성 - 작성자 안나오는 오류 수정 -->
					<td><c:out value = '${userInfo.displayName}'/></td>
					<%-- <c:choose>
						<c:when test="${userInfo.lang!='2' }">
							<td><c:out value='${item.userName}' /></td>
						</c:when>
						<c:otherwise>
							<td><c:out value='${item.userName2}' /></td>
						</c:otherwise>
					</c:choose> --%>
				</tr>
				<tr>
	          		<td colspan="2" style="padding:3px"><textarea id="memo" style="width:98%;height:200px;resize:none;" maxlength="3000"><c:out value='${item.content}' /></textarea></td>
	        	</tr>
			</table>
		</form>	
		
		<script type="text/javascript">
			document.webpds.memo.focus();
		</script>
	</body>
</html>