<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admin_memberlist</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script>
			/*  2018-06-05 홍승비 - html 인라인 이벤트 코드 스크립트로 분리 */
			function submit() {
				document.master.submit();
			}
			function back() {
				history.back(-1);
			}	
		</script>
		
		<c:choose>
			<c:when test="${userMode == '1' }">
				<script type="text/javascript">
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
 					//OpenAlertUI("${userName} <spring:message code = 'ezCommunity.t514' />");
					alert("${userName} <spring:message code = 'ezCommunity.t514' />");
					document.location.href="/ezCommunity/adminMemberList.do?code=${code}&mode=${mode}";
				</script>
			</c:when>
			
			<c:otherwise>
				<c:if test="${clubUser.permit == '3' }">
					<script type="text/javascript">
						//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
 						//OpenAlertUI("${userName} <spring:message code = 'ezCommunity.t515' />");
						alert("${userName} <spring:message code = 'ezCommunity.t515' />");
						document.location.href="/ezCommunity/adminMemberList.do?code=${code}&mode=${mode}";
					</script>
				</c:if>
			</c:otherwise>
		</c:choose>
	</head>
	<body class="mainbody" scroll="yes">
		<c:choose>
			<c:when test="${mode == 'master'}">
				<h1><spring:message code = 'ezCommunity.t516' /></h1>
			</c:when>
			
			<c:otherwise>
				<h1><spring:message code = 'ezCommunity.t517' /></h1>
			</c:otherwise>
		</c:choose>
		
		<table class="content" style="margin-top:10px">
			<tr>
				<th width="70"><spring:message code = 'ezCommunity.t518' /></th>
				<td>${memberInfo.userName}</td>
			</tr>	
			<tr style="display:none">
				<th><spring:message code = 'ezCommunity.t520' /></th>
				<td>
					<c:if test="${clubUser.c_sex != '0'}">
						${memberInfo.gender}
					</c:if>
				</td>
			</tr>		
			<tr>
				<th><spring:message code = 'ezCommunity.t521' /></th>
				<td>
					<c:if test="${memberInfo.companyZip != '' }">
						<spring:message code = 'ezCommunity.t522' /> ${memberInfo.companyZip}
					</c:if>
					
					<c:if test="${memberInfo.companyAddress != '' }">
						${memberInfo.companyAddress}
					</c:if>
				</td>
			</tr>
			<tr>
				<th><spring:message code = 'ezCommunity.t523' /></th>
				<td>
					<c:if test="${memberInfo.deptName != '' }">
						${memberInfo.deptName}
					</c:if>
				</td>
			</tr>
			<tr>
				<th><spring:message code = 'ezCommunity.t524' /></th>
				<td>
					<c:if test="${memberInfo.companyTel != '' }">
						${memberInfo.companyTel}
					</c:if>
				</td>
			</tr>
			<tr>
				<th><spring:message code = 'ezCommunity.t525' /></th>
				<td>
					<c:if test="${memberInfo.companyFax != '' }">
						${memberInfo.companyFax }
					</c:if>
				</td>
			</tr>
			<tr>
				<th><spring:message code = 'ezCommunity.t526' /></th>
				<td>
					<c:if test="${memberInfo.handPhone != '' }">
						${memberInfo.handPhone }
					</c:if>
				</td>
			</tr>
		</table>
		<br/>
				
		<div class="point">
            <!-- // 20090902 : 표준모듈 패치 -->
            <c:choose>
            	<c:when test="${mode == 'master' && cID != userInfo.id && existOutList }">
            		<spring:message code = 'ezCommunity.t1530' />
            	</c:when>
            	
            	<c:when test="${mode == 'master' && cID != userInfo.id}">
            		<spring:message code = 'ezCommunity.t528' />
            	</c:when>
            	
            	<c:when test="${mode == 'master' && cID == userInfo.id}">
            		<spring:message code = 'ezCommunity.t529' />
            	</c:when>
            	
            	<c:when test="${mode != 'master' && cID == userInfo.id }">
            		<spring:message code = 'ezCommunity.t530' />
            	</c:when>
            	
            	<c:otherwise>
            		<spring:message code = 'ezCommunity.t531' />
            	</c:otherwise>
            </c:choose>
		</div>
		
		<div class="btnposition btnpositionNew">
        <!-- // 20090902 : 표준모듈 패치 -->
	        <c:choose>       
	        	<c:when test="${cID != userInfo.id && !(mode == 'master' && cID != userInfo.id && existOutList) }">
	        		<a class="imgbtn" name="Submit"  onClick="submit()"><span><spring:message code = 'ezCommunity.t532' /></span></a>
		            <a class="imgbtn"name="Submit2"  onClick="back()"><span><spring:message code = 'ezCommunity.t533' /></span></a>
	            </c:when>
	            
	            <%-- 2018-06-05 홍승비 - 마스터가 자기 자신을 탈퇴/이취임 선택 시 뒤로가기 버튼 추가 --%>
	            <c:when test="${cID == userInfo.id}">
	            	<a class="imgbtn"name="Submit2"  onClick="back()"><span><spring:message code = 'ezCommunity.t987' /></span></a>
	        	</c:when>
	    	</c:choose>
		</div>
		
		<form name="master" method="post" action="/ezCommunity/adminMemberListOkGo.do">
			<input type="hidden" name="code" value="<c:out value = '${code}' />" > 
			<input type="hidden" name="mode" value="<c:out value = '${mode}' />" >
			<input type="hidden" name="cID" value="<c:out value = '${cID}' />" >
			<input type="hidden" name="userName" value="<c:out value = '${memberInfo.userName}' />" >
			<!-- 표준모듈 (2007.03.15) 수정 : 마스터 위임 시 게시판 권한 위임 관련 수정 -->
		    <input type="hidden" name="cNm" value="<c:out value = '${cNm}' />" >
		</form>		
	</body>
</html>