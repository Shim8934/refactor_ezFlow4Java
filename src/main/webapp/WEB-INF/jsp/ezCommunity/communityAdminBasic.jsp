<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admin_basic</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			.radioTypeText {
				vertical-align: middle;
			    margin-top: 2px;
			    display: inline-block;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var pPermitCount = "<c:out value = '${pPermitCount}' />";
			var code = "<c:out value = '${code}' />";
			var readGrade = "<c:out value = '${readGrade}' />";

			window.onload = function () {
				getGradeList();
			}
			
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

			function getGradeList() {
				$.ajax({
					type : "GET",
					url : "/ezCommunity/getAdminMemberGrade.do",
					dataType : "json",
					data : {
						code : code
					},
					success : function(result) {
						getGradeList_after(result);
					},
					error : function(xhr, status, error) {
						console.error("Error: " + error);
					}
				});
			}

			function getGradeList_after(gradeList) {
				var selectGrade = document.getElementById("read_Grade");
				selectGrade.innerHTML = "";

				var isGradeFound = false;

				for (var i = 0; i < gradeList.length-1; i++) {
					var option = document.createElement("option");

					option.value = gradeList[i].gradeCode;
					option.textContent = gradeList[i].gradeName;
					option.name = 'read_Grade';

					if (gradeList[i].gradeCode == readGrade) {
						option.selected = true;
						isGradeFound = true;
					}

					selectGrade.appendChild(option);
				}

				if (!isGradeFound && gradeList.length > 0) {
					selectGrade.options[selectGrade.options.length - 1].selected = true;
				}
			}
		</script>
	</head>
	<body class="mainbody">
		<form method="post" name="mod" action="/ezCommunity/adminBasicOk.do?" >
			<input type="hidden" name="code" value="<c:out value = '${code}' />" >
			<h1><spring:message code ='ezCommunity.t450' /></h1>
			
			<table class="content" style="margin-top:5px">
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
								<td><input type="text" name="c_ClubName" maxlength="50" value="<c:out value = '${club.c_ClubName}' />" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
							</tr>
							<tr class="secondary">
								<th><c:out value = '${lang_Secondary}' /></th>
								<td><input type="text" name="c_ClubName2" maxlength="50" value="<c:out value = '${club.c_ClubName2}' />" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th><spring:message code ='ezCommunity.t11' /></th>
					<td>
						<c:out value = '${c_cate_a}' />
						<%-- <c:choose>
							<c:when test="${c_cate_a != '' && c_cate_b != '' }">
								<c:out value = '${c_cate_a}' />, &nbsp; <c:out value = '${c_cate_b}' />
							</c:when>
							<c:otherwise>
								<c:out value = '${c_cate_a}' />
								<c:out value = '${c_cate_b}' />
							</c:otherwise>
						</c:choose> --%>
					</td>
				</tr>
				<tr>
					<th><spring:message code ='ezCommunity.t65' /></th>
					<td style="padding:5px">
						<div class="custom_radio">
							<c:choose>
								<c:when test="${club.c_ClubConfirmType == '2'}">
									<input id="c_ClubConfirmType1" type="radio" name="c_ClubConfirmType" value="2" checked >
								</c:when>
								
								<c:otherwise>
									<input id="c_ClubConfirmType1" type="radio" name="c_ClubConfirmType" value="2" >
								</c:otherwise>
							</c:choose>
							
							<label for="c_ClubConfirmType1"><spring:message code ='ezCommunity.t451' /></label>
										
							<c:choose>
								<c:when test="${club.c_ClubConfirmType == '3'}">
									<input id="c_ClubConfirmType2" type="radio" name="c_ClubConfirmType" value="3" checked >
								</c:when>
								
								<c:otherwise>
									<input id="c_ClubConfirmType2" type="radio" name="c_ClubConfirmType" value="3" >
								</c:otherwise>
							</c:choose>
							
							<label for="c_ClubConfirmType2"><spring:message code ='ezCommunity.t14' /></label>
						</div>
						<div style="margin-top:5px">
							<spring:message code ='ezCommunity.t452' /><br>
							<spring:message code ='ezCommunity.t453' />
						</div>	
					</td>
				</tr>
				<tr>
					<th><spring:message code ='ezCommunity.t15' /></th>
					<td style="padding:5px">
						<div class="custom_radio">
							<c:choose>
								<c:when test="${club.c_ClubGubun == '2' }">
									<input id="c_ClubGubun1" type="radio" name="c_ClubGubun" value="2" checked >
								</c:when>
								
								<c:otherwise>
									<input id="c_ClubGubun1" type="radio" name="c_ClubGubun" value="2" >
								</c:otherwise>
							</c:choose>
							
							<label for="c_ClubGubun1"><spring:message code ='ezCommunity.t454' /></label>
							
							<c:choose>
								<c:when test="${club.c_ClubGubun == '3' }">
									<input id="c_ClubGubun2" type="radio" name="c_ClubGubun" value="3" checked >
								</c:when>
								
								<c:otherwise>
									<input id="c_ClubGubun2" type="radio" name="c_ClubGubun" value="3" >
								</c:otherwise>
							</c:choose>
							
							<label for="c_ClubGubun2"><spring:message code ='ezCommunity.t17' /></label>
						</div>
						<div style="margin-top:5px">
							<spring:message code ='ezCommunity.t1017' /><br>
							<spring:message code ='ezCommunity.t1018' />
						</div>	
					</td>
				</tr>
				<tr style="display:none">
					<th><spring:message code ='ezCommunity.t68' /></th>
					<td>
						<div class="custom_radio">
							<c:choose>
								<c:when test="${club.isIn == '1' }">
									<input id="isIn1" type="radio" name="isIn" value="1" checked >
								</c:when>
								
								<c:otherwise>
									<input id="isIn1" type="radio" name="isIn" value="1" >
								</c:otherwise>
							</c:choose>
							
							<label for="isIn1"><spring:message code ='ezCommunity.t457' /></label>
							
							<c:choose>
								<c:when test="${club.isIn == '2' }">
									<input id="isIn2" type="radio" name="isIn" value="2" checked >
								</c:when>
								
								<c:otherwise>
									<input id="isIn2" type="radio" name="isIn" value="2" >
								</c:otherwise>
							</c:choose>
						
							<label for="isIn2"><spring:message code ='ezCommunity.t458' /></label>
						</div>
						<br>
						<spring:message code ='ezCommunity.t459' /><br>
						<spring:message code ='ezCommunity.t460' />
					</td>
				</tr>
				<tr>
					<th><spring:message code ='ezCommunity.lyj21' /></th>
					<td style="padding:5px">
						<select name="memlist_readGrade" id="read_Grade" style="font-size: 13px;vertical-align: middle;cursor: pointer;MIN-WIDTH: 80px;height: 20px;" onchange="">
							<option value="3"><spring:message code = 'ezCommunity.lyj07' /></option>
							<option value="4" selected><spring:message code = 'ezCommunity.lyj08' /></option>
						</select> <span style="vertical-align: middle;"><spring:message code = 'ezCommunity.lyj22' /></span>
					</td>
				</tr>
				<tr>
					<th colspan="2"><spring:message code ='ezCommunity.t2008' /></th>
				</tr>
				<tr>
					<td colspan="2" style="padding:3px"><textarea name="c_ClubDesc" maxlength="2000" style="height:120px;width:100%;box-sizing:border-box;-moz-box-sizing:border-box;resize:none"><c:out value = '${club.c_ClubDesc}' /></textarea></td>
				</tr>
			</table>
		
		<!-- 18-04-27 김민성 - UI 수정 -->
		<br><br><br>
				  
			<div class="btnposition btnpositionNew">
				<a class="imgbtn"	name="Submit"	onclick="javascript:check();"><span><spring:message code ='ezCommunity.t20' /></span></a>
				<a class="imgbtn"	name="Submit2"	onclick="window.location.reload(false)" ><span><spring:message code ='ezCommunity.t109' /></span></a>
				<a class="imgbtn"	name="Submit3"	onclick="parent.parent.window.close()"><span><spring:message code ='ezCommunity.t21' /></span></a>
			</div>
		</form>
	</body>
</html>