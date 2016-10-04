<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${clubVO.c_ClubName}Community <spring:message code = 'ezCommunity.t1054' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<script type="text/javascript">
			<!--
			function birthYear_onfocus() {
				join.birthYear.value = "";
			}
	
			function birthMonth_onfocus() {
				join.birthMonth.value = "";
			}
	
			function birthDay_onfocus() {
				join.birthDay.value = "";
			}
	
			function openbirth_onchange() {
				if (join.openbirth.checked == true) {
					join.birthYear.disabled = false;
					join.birthMonth.disabled = false;
					join.birthDay.disabled = false;
					join.birthType1.disabled = false;
					join.birthType2.disabled = false;
				}
				
				if (join.openbirth.checked == false) {
					join.birthYear.disabled = true;
					join.birthMonth.disabled = true;
					join.birthDay.disabled = true;
					join.birthType1.disabled = true;
					join.birthType2.disabled = true;
				}
			}
	
			function window_onload() {
				join.birthYear.disabled = true;
				join.birthMonth.disabled = true;
				join.birthDay.disabled = true;
				join.birthType1.disabled = true;
				join.birthType2.disabled = true;
			}
	
			function birthYear_onchange() {
				var e1 = event.srcElement;
				var num="0123456789";
				
				event.returnValue = true;
	
				for (var i=0 ; i < e1.value.length ; i++) {
					if (-1 == num.indexOf(e1.value.charAt(i))) {
						event.returnValue = false;
					}
				}
				
				if (!event.returnValue) {
					alert("<spring:message code = 'ezCommunity.t1055' />");
				    document.getElementById("birthYear").value = "";
				    document.getElementById("birthYear").focus();
					return;
				}
	
			    if (parseInt(document.getElementById("birthYear").value) > parseInt(dd.getUTCFullYear())) {
					alert("<spring:message code = 'ezCommunity.t1056' />");
			        document.getElementById("birthYear").value = "";
			        document.getElementById("birthYear").focus();
					return;
				}	
			}
	
			function birthMonth_onchange() {
				var e1 = event.srcElement;
				var num="0123456789";
				
				event.returnValue = true;
	
				for (var i=0 ; i < e1.value.length ; i++) {
					if (-1 == num.indexOf(e1.value.charAt(i))) {
						event.returnValue = false;
					}
				}
				
				if (!event.returnValue) {
					alert("<spring:message code = 'ezCommunity.t1055' />");
				    document.getElementById("birthMonth").value = "";
				    document.getElementById("birthMonth").focus();
					return;
				}
				
			    if (parseInt(document.getElementById("birthMonth").value) > 12) {
					alert("<spring:message code = 'ezCommunity.t1057' />");
				    document.getElementById("birthMonth").value = "";
				    document.getElementById("birthMonth").focus();
					return;
				}
			}
	
			function birthDay_onchange() {
				var e1 = event.srcElement;
				var num="0123456789";
				
				event.returnValue = true;
	
				for (var i=0 ; i < e1.value.length ; i++) {
					if (-1 == num.indexOf(e1.value.charAt(i))) {
						event.returnValue = false;
					}
				}
				
				if (!event.returnValue) {
					alert("<spring:message code = 'ezCommunity.t1055' />");
				    document.getElementById("birthDay").value = "";
				    document.getElementById("birthDay").focus();
					return;
				}
				
			    if (parseInt(document.getElementById("birthDay").value) > 31) {
					alert("<spring:message code = 'ezCommunity.t1058' />");
			        document.getElementById("birthDay").value = "";
			        document.getElementById("birthDay").focus();
					return;
				}
			}
	
			function birth_check() {
				var num="0123456789";
				var dd = new Date();
				
				var returnValue = true;
				
				for (var i = 0 ; i < document.getElementById("birthYear").value.length ; i++) {
				    if (-1 == num.indexOf(document.getElementById("birthYear").value.charAt(i))) {
						returnValue = false;
				    }
				}
				
				if (!returnValue) {
					alert("<spring:message code = 'ezCommunity.t1055' />");
				    document.getElementById("birthYear").value = "";
				    document.getElementById("birthYear").focus();
					return 0;
				}
				
			    if (document.getElementById("birthYear").value == "") {
					alert("<spring:message code = 'ezCommunity.t1059' />");
			        document.getElementById("birthYear").focus();
					return 0;
				}
				
			    if (parseInt(document.getElementById("birthYear").value) > parseInt(dd.getUTCFullYear())) {
					alert("<spring:message code = 'ezCommunity.t1056' />");
			        document.getElementById("birthYear").value = "";
			        document.getElementById("birthYear").focus();
					return 0;
				}
				//년도 확인
				
			    for (var i = 0 ; i < document.getElementById("birthMonth").value.length ; i++) {
			        if (-1 == num.indexOf(document.getElementById("birthMonth").value.charAt(i))) {
						returnValue = false;
			        }
			    }
				
				if (!returnValue) {
					alert("<spring:message code = 'ezCommunity.t1055' />");
				    document.getElementById("birthMonth").value = "";
				    document.getElementById("birthMonth").focus();
					return 0;
				}
				
			    if (document.getElementById("birthMonth").value == "") {
					alert("<spring:message code = 'ezCommunity.t1061' />");
			        document.getElementById("birthMonth").focus();
					return 0;
				}
				
			    if (parseInt(document.getElementById("birthMonth").value) > 12) {
					alert("<spring:message code = 'ezCommunity.t1057' />");
			        document.getElementById("birthMonth").value = "";
			        document.getElementById("birthMonth").focus();
					return 0;
				}
				//월 확인
				
			    for (var i=0 ; i < document.getElementById("birthDay").value.length ; i++) {
			        if (-1 == num.indexOf(document.getElementById("birthDay").value.charAt(i))) {
						returnValue = false;
			        }
			    }
				
				if (!returnValue) {
					alert("<spring:message code = 'ezCommunity.t1055' />");
				    document.getElementById("birthDay").value = "";
				    document.getElementById("birthDay").focus();
					return 0;
				}
	
			    if (document.getElementById("birthDay").value == "") {
					alert("<spring:message code = 'ezCommunity.t1063' />");
			        document.getElementById("birthDay").focus();
					return 0;
				}
				
			    if (parseInt(document.getElementById("birthDay").value) > 31) {
					alert("<spring:message code = 'ezCommunity.t1058' />");
			        document.getElementById("birthDay").value = "";
			        document.getElementById("birthDay").focus();
					return 0;
				}
				//일 확인
				return 1;
			}
	
			function join_ok() {
				var chk;
				
				if( document.getElementById("c_intro").value.length > 2000 ) {
					alert("<spring:message code = 'ezCommunity.t1065' />");
					
				    document.getElementById("c_intro").focus();
					
					return;	
				}
				
			    if (document.getElementById("openbirth").checked == true) {
					chk = birth_check();
					
					if ( chk == 1 ) {
					    document.getElementById("join").submit();
					} else {
						return;
					}
				} else {
			        document.getElementById("join").submit();
				}
				
			    //window.resizeTo(435, 320);
			    var UserAgentState = navigator.userAgent.toLowerCase();
			    
			    if (!CrossYN()) {
			        if (UserAgentState.indexOf("firefox") != -1) {
			            window.resizeTo(349, 299);
			        } else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
			            window.resizeTo(346, 263);
			        } else {
			            window.resizeTo(346, 289);
			        }
			    } else {
			        window.resizeTo(346, 260);
			    }
			}
	
			function join_cancel() {
				window.location.href="/ezCommunity/joinCancel.do?code=<c:out value = '${code}' />";
			}
	
			//-->
		</script>
	</head>
	<body class="popup" onLoad="return window_onload()">
		<h1>Community <spring:message code = 'ezCommunity.t1066' /></h1>
		<table class="content">
		  	<tr>
			    <th>Community <spring:message code = 'ezCommunity.t10' /></th>
			    <td><div style="OVERFLOW-Y: auto;HEIGHT: 17px;"><c:out value = '${clubVO.c_ClubName}' /></div></td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezCommunity.t1012' /></th>
			    <td><c:out value = '${sysUserName}' />(<c:out value = '${clubVO.c_SysopID}' />)</td>
		  	</tr>
		</table>
		
		<form method="post" name="join" id="join" action="/ezCommunity/joinOk.do"  >
			<input type=hidden name=code value="<c:out value = '${code}' />">
		  	<table class="popuplist"  width="100%">
		    	<tr>
		      		<th><spring:message code = 'ezCommunity.t1067' /></th>
		    	</tr>
		    	<tr>
		      		<td align="center" style="height:60px"><!-- 회원정보 display none 시킨 DIV 부분 -->
		        		<div style="display:none">
		          			<input type="checkbox" name="openEmail" checked value="1" tabindex="1"><spring:message code = 'ezCommunity.t272' />
		          			<input type="checkbox" name="openHp" checked value="1" tabindex="2"><spring:message code = 'ezCommunity.t1069' /><br>
					        <input type="checkbox" name="openComp" checked value="1" tabindex="3"><spring:message code = 'ezCommunity.t1070' />
					        <input type="checkbox" name="openHouse" checked value="1" tabindex="4"><spring:message code = 'ezCommunity.t1071' />
					        <input type="checkbox" name="openSex" checked value="1" tabindex="5"><spring:message code = 'ezCommunity.t1072' /><br>
		        		</div>
		        		
		        		<input type="checkbox" name="openBirth" id="openbirth" value="1" onclick="return openbirth_onchange()" tabindex="6">
		        		<spring:message code = 'ezCommunity.t519' />
		        		<input type="text" name="birthYear" id="birthYear" value="YYYY" size="4" maxlength="4" onFocus="return birthYear_onfocus()" onChange="return birthYear_onchange()" tabindex="7">
		        		<spring:message code = 'ezCommunity.t1073' />
		        		<input type="text" name="birthMonth" id="birthMonth" value="MM" size="2" maxlength="2"  onFocus="return birthMonth_onfocus()" onChange="return birthMonth_onchange()" tabindex="8">
		        		<spring:message code = 'ezCommunity.t806' />
				        <input type="text" name="birthDay" id="birthDay" value="DD" size="2" maxlength="2" onFocus="return birthDay_onfocus()" onChange="return birthDay_onchange()" tabindex="9">
				        <spring:message code = 'ezCommunity.t1074' /><br>
				        
				        <c:choose>
				        	<c:when test="${userInfo.lang == '1' || userInfo.lang == '4' }">
				        		<input type="radio" name="birthType" id="birthType1" value="+" checked>
						        <spring:message code = 'ezCommunity.t1075' />
						        <input type="radio" name="birthType" id="birthType2" value="-">
						        <spring:message code = 'ezCommunity.t1076' />
				        	</c:when>
				        		
				        	<c:otherwise>
				        		<div style="display:none;">
							        <input type="radio" name="birthType" id="birthType1" value="+" checked >
							        <spring:message code = 'ezCommunity.t1075' />
							        <input type="radio" name="birthType" id="birthType2" value="-">
							        <spring:message code = 'ezCommunity.t1076' />
						        </div>
				        	</c:otherwise>
				        </c:choose>
				        
		        	</td>
		    	</tr>
		    	<tr>
		    		<th><spring:message code = 'ezCommunity.t1072' /></th>
		    	</tr>
		    	<tr>
		    		<td align="center">
			    		<input type ="radio" name = "gender" id = "gender1" value ="<spring:message code = 'ezCommunity.t1098' />" checked ><spring:message code = 'ezCommunity.t1098' />
			    		<input type ="radio" name = "gender" id = "gender1" value ="<spring:message code = 'ezCommunity.t1099' />" ><spring:message code = 'ezCommunity.t1099' />
		    		</td>
		    	</tr>
		    	<tr>
		      		<th><spring:message code = 'ezCommunity.t527' /></th>
		    	</tr>
	    		<tr>
		      		<td><textarea name="cIntro" id="c_intro" style="width: 100%;height:110px" tabindex="10"></textarea></td>
		    	</tr>
		  	</table>
		  	<!--커뮤니티 배너부분 -->
		  	<div class="btnposition">
		    	<a class="imgbtn" name="Submit"  onclick="javascript:join_ok();"><span><spring:message code = 'ezCommunity.t245' /></span></a>
				<a class="imgbtn" name="Submit2" onClick="javascript:self.close();"><span><spring:message code = 'ezCommunity.t246' /></span></a>
		  	</div>
		</form>
	</body>
</html>