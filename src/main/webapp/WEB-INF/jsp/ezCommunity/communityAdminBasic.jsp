<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admin_basic</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
		
			var pPermitCount = "<c:out value = '${pPermitCount}' />";
	
			function check() {
				if (document.mod.c_ClubName.value == "") {
					alert("<spring:message code = 'ezCommunity.t2' />");
					document.mod.c_ClubName.focus();
					return;	
				}
				
				if (document.mod.c_ClubName.value.length > 50) {
	                alert("<spring:message code='ezCommunity.t3' />");
	                document.mod.c_ClubName.focus();
	                return;
	            }
							
				if (document.mod.c_ClubName2.value.length > 50) {
	                alert("<spring:message code='ezCommunity.t3' />");
	                document.mod.c_ClubName.focus();
	                return;
	            }
				
				if (document.mod.c_ClubDesc.value == "") {
				    alert("<spring:message code = 'ezCommunity.t1529' /><spring:message code = 'ezCommunity.t448' />");
					document.mod.c_ClubDesc.focus();
					return;	
				}
				
				if (document.mod.c_ClubDesc.value.length > 2000) {
	                alert("<spring:message code='ezCommunity.t1009' />");
	                document.mod.c_ClubDesc.focus();
	                return;
	            }
				
				if(document.mod.c_ClubConfirmType[0].checked == true & pPermitCount != 0) {
			        alert("<spring:message code = 'ezCommunity.t1494' />\n<spring:message code = 'ezCommunity.t1495' />");
			        return;
			    }
				
				document.mod.submit();
			}
	
			function resetAll() {
				if(confirm("<spring:message code = 'ezCommunity.t449' />")) {
					document.location.href = document.location.href;
				}
			}
		</script>
	</head>
	<body class="mainbody">
		<form method="post" name="mod" action="/ezCommunity/adminBasicOk.do?" >
			<input type="hidden" name="code" value="<c:out value = '${code}' />" >
			<h1><spring:message code ='ezCommunity.t450' /></h1>
			<br>
			<br>
			
			<table class="content" >
				<tr>
					<th><spring:message code ='ezCommunity.t9' /></th>
					<td><c:out value = '${club.c_SysopID}' /> (<c:out value = '${name1}' />)</td>
				</tr>
				<tr>
					<th><spring:message code ='ezCommunity.t9991' /></th>
					<td style="padding:0">
						<table style="width:100%">
							<tr class="primary">
								<th><c:out value = '${lang_Primary}' /></th>
								<td><input type="text" name="c_ClubName" value="<c:out value = '${club.c_ClubName}' />" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
							</tr>
							<tr class="secondary">
								<th><c:out value = '${lang_Secondary}' /></th>
								<td><input type="text" name="c_ClubName2" value="<c:out value = '${club.c_ClubName2}' />" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th><spring:message code ='ezCommunity.t11' /></th>
					<td>
						<c:choose>
							<c:when test="${c_cate_a != '' && c_cate_b != '' }">
								<c:out value = '${c_cate_a}' />, &nbsp; <c:out value = '${c_cate_b}' />
							</c:when>
							<c:otherwise>
								<c:out value = '${c_cate_a}' />
								<c:out value = '${c_cate_b}' />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th><spring:message code ='ezCommunity.t65' /></th>
					<td>
						<c:choose>
							<c:when test="${club.c_ClubConfirmType == '2'}">
								<input type="radio" name="c_ClubConfirmType" value="2" checked >
							</c:when>
							
							<c:otherwise>
								<input type="radio" name="c_ClubConfirmType" value="2" >
							</c:otherwise>
						</c:choose>
						
						<spring:message code ='ezCommunity.t451' />
						
						<c:choose>
							<c:when test="${club.c_ClubConfirmType == '3'}">
								<input type="radio" name="c_ClubConfirmType" value="3" checked >
							</c:when>
							
							<c:otherwise>
								<input type="radio" name="c_ClubConfirmType" value="3" >
							</c:otherwise>
						</c:choose>
						
						<spring:message code ='ezCommunity.t14' /><br>
						<spring:message code ='ezCommunity.t452' /><br>
						<spring:message code ='ezCommunity.t453' />
					</td>
				</tr>
				<tr>
					<th><spring:message code ='ezCommunity.t15' /></th>
					<td>
						<c:choose>
							<c:when test="${club.c_ClubGubun == '2' }">
								<input type="radio" name="c_ClubGubun" value="2" checked >
							</c:when>
							
							<c:otherwise>
								<input type="radio" name="c_ClubGubun" value="2" >
							</c:otherwise>
						</c:choose>
						
						<spring:message code ='ezCommunity.t454' />
						
						<c:choose>
							<c:when test="${club.c_ClubGubun == '3' }">
								<input type="radio" name="c_ClubGubun" value="3" checked >
							</c:when>
							
							<c:otherwise>
								<input type="radio" name="c_ClubGubun" value="3" >
							</c:otherwise>
						</c:choose>
						
						<spring:message code ='ezCommunity.t17' /><br>
						<spring:message code ='ezCommunity.t1017' /><br>
						<spring:message code ='ezCommunity.t1018' />
					</td>
				</tr>
				<tr style="display:none">
					<th><spring:message code ='ezCommunity.t68' /></th>
					<td>
						<c:choose>
							<c:when test="${club.isIn == '1' }">
								<input type="radio" name="isIn" value="1" checked >
							</c:when>
							
							<c:otherwise>
								<input type="radio" name="isIn" value="1" >
							</c:otherwise>
						</c:choose>
						
						<spring:message code ='ezCommunity.t457' />
						
						<c:choose>
							<c:when test="${club.isIn == '2' }">
								<input type="radio" name="isIn" value="2" checked >
							</c:when>
							
							<c:otherwise>
								<input type="radio" name="isIn" value="2" >
							</c:otherwise>
						</c:choose>
						
						<spring:message code ='ezCommunity.t458' /><br>
						<spring:message code ='ezCommunity.t459' /><br>
						<spring:message code ='ezCommunity.t460' />
					</td>
				</tr>
				<tr>
					<th colspan="2"><spring:message code ='ezCommunity.t1529' /> <spring:message code ='ezCommunity.t461' /></th>
				</tr>
				<tr>
					<td colspan="2"><textarea name="c_ClubDesc" style="height:120px;width:100%;box-sizing:border-box;-moz-box-sizing:border-box;"><c:out value = '${club.c_ClubDesc}' /></textarea></td>
				</tr>
			</table>
		  
			<div class="btnposition">
				<a class="imgbtn"	name="Submit"	onclick="javascript:check();"><span><spring:message code ='ezCommunity.t245' /></span></a>
				<a class="imgbtn"	name="Submit2"	onclick="window.location.reload(false)" ><span><spring:message code ='ezCommunity.t246' /></span></a>
				<a class="imgbtn"	name="Submit3"	onclick="parent.parent.window.close()"><span><spring:message code ='ezCommunity.t21' /></span></a>
			</div>
		</form>
	</body>
</html>