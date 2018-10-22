<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.kms1'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var timeZone = "${configMap.PrimaryTimeZone}";
			var list = [];
			var confirmChange = "";
			window.onload = window_onload;
			var editorFontStyle = "";
			var useAllUserOldMailDelete = "${useAllUserOldMailDelete}";
			var useAllUserOldMailDeletePeriod = "${useAllUserOldMailDeletePeriod}";
			
			function window_onload() {
				
				if (timeZone != "") {
					document.getElementById("PrimaryTimeZone").value = timeZone;
				} else {
					document.getElementById("PrimaryTimeZone").value = "235|+09:00";
				}
				
			}
			
			function update_Sys_Param() {
				var paramArray
					= [
						{ name : "BigSizeMailAttachDelDay", value : document.getElementById("BigSizeMailAttachDelDay").value.trim() },
						{ name : "totBigSizeMailAttachLimit", value : document.getElementById("totBigSizeMailAttachLimit").value.trim() },
						{ name : "MailAttachLimit", value : document.getElementById("MailAttachLimit").value.trim() },				
						{ name : "ExpirePassPeriod", value : document.getElementById("ExpirePassPeriod").value.trim() },
						{ name : "MaxAllowedCountOfLoginFail", value : document.getElementById("MaxAllowedCountOfLoginFail").value.trim() },				
						{ name : "INDIVIDUALMAILUSER", value : document.getElementById("INDIVIDUALMAILUSER").value.trim() },
						{ name : "IS_READ_DELETE", value : document.getElementById("IS_READ_DELETE").value.trim() },
						{ name : "PrimaryLang", value : document.getElementById("PrimaryLang").value.trim() },
						{ name : "PrimaryTimeZone", value : document.getElementById("PrimaryTimeZone").value.trim() },
						{ name : "USE_FileExtension", value : document.getElementById("USE_FileExtension").value.trim() },
						{ name : "LicenseKey", value : document.getElementById("LicenseKey").value.trim() },
						{ name : "Use_FromAddress", value : document.getElementById("Use_FromAddress").value.trim() },
						{ name : "USE_HTMLMODE", value : document.getElementById("Use_HTMLMode").value.trim() },
						{ name : "editorFontStyle", value : editorFontStyle },
						{ name : "useAllUserOldMailDeletePeriod", value : useAllUserOldMailDeletePeriod },
						{ name : "useSession", value : document.getElementById("useSession").value.trim() }
					  ];
				
				if (!paramArray[0].value.match(/^\d+$/)) {
				    alert("<spring:message code='ezSystem.x0001'/>: <spring:message code='ezEmail.t99000066'/>");
				    return;
				} else if (!paramArray[1].value.match(/^\d+$/)) {
				    alert("<spring:message code='ezSystem.x0002'/>: <spring:message code='ezEmail.t99000066'/>");
				    return;
				} else if (!paramArray[2].value.match(/^\d+$/)) {
				    alert("<spring:message code='ezSystem.x0003'/>: <spring:message code='ezEmail.t99000066'/>");
				    return;
				} else if (!paramArray[3].value.match(/^\d+$/)) {
				    alert("<spring:message code='ezSystem.x0005'/>: <spring:message code='ezEmail.t99000066'/>");
				    return;
				} else if (!paramArray[4].value.match(/^\d+$/)) {
				    alert("<spring:message code='ezSystem.x0006'/>: <spring:message code='ezEmail.t99000066'/>");
				    return;
				}		
						
				var jsonStr = JSON.stringify(paramArray);
				
				$.ajax({
					type : "POST",
					url : "/admin/ezSystem/updateSysParam.do",
					processData : true, 
					contentType : "application/json; charset=UTF-8", 
					data :jsonStr,
					success : function(data){
						if(data.msg=='success'){
							alert("<spring:message code='main.sp10'/>");
							
							window.location.href='/admin/ezSystem/systemMainMenu.do';
						}
						if(data.msg=='fail'){
							alert("<spring:message code='main.sp12'/>");
						}
					},
					error : function(e) {
						alert(e);
					}
				});	
			}
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='main.kms1'/></h1>
	    <table class="content">
	        <tbody>
	            <tr><th><spring:message code="main.kms1"/></th><th><spring:message code="main.kms3"/></th></tr>
	            <c:if test="${configMap.useSession ne null and configMap.useSession ne ''}">
		            <tr><th><spring:message code="ezSystem.lsh001"/></th><td><input id="useSession" minlength="1" type="text" value="${configMap.useSession}"> (<spring:message code="ezSystem.kyj5"/>)</td></tr>
	            </c:if>
	            <tr><th><spring:message code="ezSystem.x0001"/></th><td><input id="BigSizeMailAttachDelDay" maxlength="3" type="text" value="${configMap.BigSizeMailAttachDelDay}"> (<spring:message code="ezSystem.x0010"/>)</td></tr>          
	            <tr><th><spring:message code="ezSystem.x0002"/></th><td><input id="totBigSizeMailAttachLimit" maxlength="4" type="text" value="${configMap.totBigSizeMailAttachLimit}"> (<spring:message code="ezSystem.x0011"/>, <spring:message code="ezSystem.x0019"/>)</td></tr>
	            <tr><th><spring:message code="ezSystem.x0003"/></th><td><input id="MailAttachLimit" maxlength="3" type="text" value="${configMap.MailAttachLimit}"> (<spring:message code="ezSystem.x0011"/>)</td></tr>                              
	            <tr <c:if test="${isDotNetAdmin == true}">style="display:none;"</c:if>><th><spring:message code="ezSystem.x0005"/></th><td><input id="ExpirePassPeriod" maxlength="3" type="text" value="${configMap.ExpirePassPeriod}"> (<spring:message code="ezSystem.x0010"/>, <spring:message code="ezSystem.x0014"/>)</td></tr>
	            <tr <c:if test="${isDotNetAdmin == true}">style="display:none;"</c:if>><th><spring:message code="ezSystem.x0038"/></th><td><input id="MaxAllowedCountOfLoginFail" maxlength="4" type="text" value="${configMap.MaxAllowedCountOfLoginFail}"> (<spring:message code="ezSystem.x0014"/>)</td></tr>            
	            <tr><th><spring:message code="ezSystem.x0006"/></th><td><input id="INDIVIDUALMAILUSER" maxlength="3" type="text" value="${configMap.INDIVIDUALMAILUSER}"> (<spring:message code="ezSystem.x0015"/>)</td></tr>
	            <tr><th><spring:message code="ezSystem.x0007"/></th><td><select id="IS_READ_DELETE"><option <c:if test="${configMap.IS_READ_DELETE == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezQuestion.t103"/></option><option <c:if test="${configMap.IS_READ_DELETE == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezQuestion.t104"/></option></select></td><td></tr>
	            <tr><th><spring:message code="ezSystem.x0008"/></th><td><select id="PrimaryLang" style="display:none;"><option <c:if test="${configMap.PrimaryLang == '1'}">selected="selected"</c:if> value="1"><spring:message code="ezPersonal.s81"/></option><option <c:if test="${configMap.PrimaryLang == '3'}">selected="selected"</c:if> value="3"><spring:message code="ezPersonal.s84"/></option></select>	
	           			<select id="PrimaryTimeZone">
         					<option value="000|-12:00">(GMT-12:00) <spring:message code='ezPersonal.s5'/></option>
         					<option value="001|-11:00">(GMT-11:00) <spring:message code='ezPersonal.s6'/></option>
         					<option value="002|-10:00">(GMT-10:00) <spring:message code='ezPersonal.s7'/></option>
         					<option value="003|-09:00">(GMT-09:00) <spring:message code='ezPersonal.s8'/></option>
         					<option value="004|-08:00">(GMT-08:00) <spring:message code='ezPersonal.s9'/></option>
         					<option value="015|-07:00">(GMT-07:00) <spring:message code='ezPersonal.s12'/></option>
         					<option value="013|-07:00">(GMT-07:00) <spring:message code='ezPersonal.s11'/></option>
         					<option value="010|-07:00">(GMT-07:00) <spring:message code='ezPersonal.s10'/></option>
         					<option value="030|-06:00">(GMT-06:00) <spring:message code='ezPersonal.s15'/></option>
         					<option value="033|-06:00">(GMT-06:00) <spring:message code='ezPersonal.s16'/></option>
         					<option value="025|-06:00">(GMT-06:00) <spring:message code='ezPersonal.s14'/></option>
         					<option value="020|-06:00">(GMT-06:00) <spring:message code='ezPersonal.s13'/></option>
         					<option value="040|-05:00">(GMT-05:00) <spring:message code='ezPersonal.s18'/></option>
         					<option value="035|-05:00">(GMT-05:00) <spring:message code='ezPersonal.s17'/></option>
         					<option value="045|-05:00">(GMT-05:00) <spring:message code='ezPersonal.s19'/></option>
         					<option value="055|-04:30">(GMT-04:30) <spring:message code='ezPersonal.s21'/></option>
         					<option value="050|-04:00">(GMT-04:00) <spring:message code='ezPersonal.s20'/></option>
         					<option value="056|-04:00">(GMT-04:00) <spring:message code='ezPersonal.s22'/></option>
         					<option value="056|-04:00">(GMT-04:00) <spring:message code='ezPersonal.s905'/></option>
         					<option value="056|-04:00">(GMT-04:00) <spring:message code='ezPersonal.s906'/></option>
         					<option value="056|-04:00">(GMT-04:00) <spring:message code='ezPersonal.s907'/></option>
         					<option value="060|-03:30">(GMT-03:30) <spring:message code='ezPersonal.s23'/></option>
         					<option value="070|-03:00">(GMT-03:00) <spring:message code='ezPersonal.s25'/></option>
         					<option value="056|-03:00">(GMT-03:00) <spring:message code='ezPersonal.s908'/></option>
         					<option value="073|-03:00">(GMT-03:00) <spring:message code='ezPersonal.s26'/></option>
         					<option value="073|-03:00">(GMT-03:00) <spring:message code='ezPersonal.s909'/></option>
         					<option value="073|-03:00">(GMT-03:00) <spring:message code='ezPersonal.s910'/></option>
         					<option value="065|-03:00">(GMT-03:00) <spring:message code='ezPersonal.s24'/></option>
         					<option value="075|-02:00">(GMT-02:00) <spring:message code='ezPersonal.s27'/></option>
					        <option value="080|-01:00">(GMT-01:00) <spring:message code='ezPersonal.s28'/></option>
					        <option value="083|-01:00">(GMT-01:00) <spring:message code='ezPersonal.s29'/></option>
					        <option value="090|+00:00">(GMT) <spring:message code='ezPersonal.s31'/></option>
					        <option value="090|+00:00">(GMT) <spring:message code='ezPersonal.s911'/></option>
					        <option value="085|+00:00">(GMT) <spring:message code='ezPersonal.s30'/></option>
					        <option value="100|+01:00">(GMT+01:00) <spring:message code='ezPersonal.s33'/></option>
					        <option value="105|+01:00">(GMT+01:00) <spring:message code='ezPersonal.s34'/></option>
					        <option value="105|+01:00">(GMT+01:00) <spring:message code='ezPersonal.s912'/></option>
					        <option value="110|+01:00">(GMT+01:00) <spring:message code='ezPersonal.s35'/></option>
					        <option value="113|+01:00">(GMT+01:00) <spring:message code='ezPersonal.s36'/></option>
					        <option value="095|+01:00">(GMT+01:00) <spring:message code='ezPersonal.s32'/></option>
					        <option value="115|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s913'/></option>
					        <option value="115|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s914'/></option>
					        <option value="115|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s915'/></option>
					        <option value="115|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s37'/></option>
					        <option value="140|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s42'/></option>
					        <option value="120|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s38'/></option>
					        <option value="125|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s39'/></option>
					        <option value="115|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s916'/></option>
					        <option value="130|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s40'/></option>
					        <option value="135|+02:00">(GMT+02:00) <spring:message code='ezPersonal.s41'/></option>
					        <option value="158|+03:00">(GMT+03:00) <spring:message code='ezPersonal.s46'/></option>
					        <option value="145|+03:00">(GMT+03:00) <spring:message code='ezPersonal.s43'/></option>
					        <option value="145|+03:00">(GMT+03:00) <spring:message code='ezPersonal.s917'/></option>
					        <option value="145|+03:00">(GMT+03:00) <spring:message code='ezPersonal.s918'/></option>
					        <option value="150|+03:00">(GMT+03:00) <spring:message code='ezPersonal.s44'/></option>
					        <option value="160|+03:30">(GMT+03:30) <spring:message code='ezPersonal.s47'/></option>
					        <option value="155|+04:00">(GMT+04:00) <spring:message code='ezPersonal.s45'/></option>
					        <option value="170|+04:00">(GMT+04:00) <spring:message code='ezPersonal.s49'/></option>
					        <option value="165|+04:00">(GMT+04:00) <spring:message code='ezPersonal.s48'/></option>
					        <option value="165|+04:00">(GMT+04:00) <spring:message code='ezPersonal.s919'/></option>
					        <option value="165|+04:00">(GMT+04:00) <spring:message code='ezPersonal.s920'/></option>
					        <option value="165|+04:00">(GMT+04:00) <spring:message code='ezPersonal.s921'/></option>
					        <option value="175|+04:30">(GMT+04:30) <spring:message code='ezPersonal.s50'/></option>
					        <option value="180|+05:00">(GMT+05:00) <spring:message code='ezPersonal.s51'/></option>
					        <option value="185|+05:00">(GMT+05:00) <spring:message code='ezPersonal.s52'/></option>
					        <option value="190|+05:30">(GMT+05:30) <spring:message code='ezPersonal.s53'/></option>
					        <option value="190|+05:30">(GMT+05:30) <spring:message code='ezPersonal.s922'/></option>
					        <option value="193|+05:45">(GMT+05:45) <spring:message code='ezPersonal.s54'/></option>
					        <option value="195|+06:00">(GMT+06:00) <spring:message code='ezPersonal.s55'/></option>
					        <option value="200|+06:00">(GMT+06:00) <spring:message code='ezPersonal.s56'/></option>
					        <option value="201|+06:00">(GMT+06:00) <spring:message code='ezPersonal.s57'/></option>
					        <option value="203|+06:30">(GMT+06:30) <spring:message code='ezPersonal.s58'/></option>
					        <option value="207|+07:00">(GMT+07:00) <spring:message code='ezPersonal.s60'/></option>
					        <option value="205|+07:00">(GMT+07:00) <spring:message code='ezPersonal.s59'/></option>
					        <option value="210|+08:00">(GMT+08:00) <spring:message code='ezPersonal.s61'/></option>
					        <option value="215|+08:00">(GMT+08:00) <spring:message code='ezPersonal.s62'/></option>
					        <option value="225|+08:00">(GMT+08:00) <spring:message code='ezPersonal.s64'/></option>
					        <option value="225|+08:00">(GMT+08:00) <spring:message code='ezPersonal.s923'/></option>
					        <option value="227|+08:00">(GMT+08:00) <spring:message code='ezPersonal.s65'/></option>
					        <option value="220|+08:00">(GMT+08:00) <spring:message code='ezPersonal.s63'/></option>
					        <option value="235|+09:00">(GMT+09:00) <spring:message code='ezPersonal.s67'/></option>
					        <option value="230|+09:00">(GMT+09:00) <spring:message code='ezPersonal.s66'/></option>
					        <option value="240|+09:00">(GMT+09:00) <spring:message code='ezPersonal.s68'/></option>
					        <option value="250|+09:30">(GMT+09:30) <spring:message code='ezPersonal.s70'/></option>
					        <option value="245|+09:30">(GMT+10:30) <spring:message code='ezPersonal.s69'/></option>
					        <option value="265|+10:00">(GMT+10:00) <spring:message code='ezPersonal.s73'/></option>
					        <option value="255|+10:00">(GMT+10:00) <spring:message code='ezPersonal.s71'/></option>
					        <option value="255|+10:00">(GMT+10:00) <spring:message code='ezPersonal.s924'/></option>
					        <option value="260|+10:00">(GMT+10:00) <spring:message code='ezPersonal.s72'/></option>
					        <option value="270|+10:00">(GMT+10:00) <spring:message code='ezPersonal.s74'/></option>
					        <option value="275|+11:00">(GMT+11:00) <spring:message code='ezPersonal.s75'/></option>
					        <option value="280|+11:00">(GMT+11:00) <spring:message code='ezPersonal.s76'/></option>
					        <option value="281|+12:00">(GMT+12:00) <spring:message code='ezPersonal.s900'/></option>
					        <option value="285|+12:00">(GMT+12:00) <spring:message code='ezPersonal.s77'/></option>
					        <option value="290|+12:00">(GMT+12:00) <spring:message code='ezPersonal.s78'/></option>
					        <option value="290|+12:00">(GMT+12:00) <spring:message code='ezPersonal.s925'/></option>
					        <option value="300|+13:00">(GMT+13:00) <spring:message code='ezPersonal.s79'/></option>
					        <option value="300|+13:00">(GMT+13:00) <spring:message code='ezPersonal.s926'/></option>
	       				</select>
					</td>
				</tr>
	            <tr><th><spring:message code="ezSystem.x0009"/></th><td><input id="USE_FileExtension" type="text" value="${configMap.USE_FileExtension}"> (<spring:message code="ezSystem.x0012"/>, <spring:message code="ezSystem.x0013"/>: jpg,doc,xls)</td></tr>
	            <tr><th><spring:message code="ezSystem.x0016"/></th><td><input id="LicenseKey" size="60" maxlength="60" type="text" value="${configMap.LicenseKey}"> (<spring:message code="ezSystem.x0017"/>: ${licensedUserCount}, <spring:message code="ezSystem.x0018"/>: ${userCount})</td></tr>
	            <tr><th><spring:message code="ezSystem.x0020"/></th><td><select id="Use_FromAddress"><option <c:if test="${configMap.Use_FromAddress == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezQuestion.t103"/></option><option <c:if test="${configMap.Use_FromAddress == null or configMap.Use_FromAddress == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezQuestion.t104"/></option></select></td></tr>
	            <tr><th><spring:message code="ezSystem.lhj1"/></th><td><select id="Use_HTMLMode"><option <c:if test="${configMap.USE_HTMLMODE == null or configMap.USE_HTMLMODE == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezQuestion.t103"/></option><option <c:if test="${configMap.USE_HTMLMODE == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezQuestion.t104"/></option></select></td></tr>


				<c:if test="${configMap.PrimaryLang == '1' and configMap.editorFontStyle != null}">
	            	<tr>
		            	<th><spring:message code="ezSystem.lhm1"/></th>
		            	<td>
		            		<select id="editorFontFamily">
		            			<c:forEach items="${defaultFontFamilyList}" var="item">
		            				<option value="${item.trim()}">${item.trim()}</option>
		            			</c:forEach>
		            		</select>
		            		<select id="editorFontSize">
		            			<c:forEach items="${defaultFontSizeList}" var="item">
		            				<option value="${item}">${item}</option>
		            			</c:forEach>
		            		</select>
		            	</td>
		            </tr>
		            <script>
		            	var editorFontStyle = "${configMap.editorFontStyle}";
		            	var editorFontFamily = document.getElementById("editorFontFamily");
		            	var editorFontSize = document.getElementById("editorFontSize");
		            	
		            	editorFontFamily.value = editorFontStyle.split("|")[0];
		            	editorFontSize.value = editorFontStyle.split("|")[1];
		            	
		            	editorFontFamily.addEventListener("change", function () {editorFontStyle = document.getElementById("editorFontFamily").value + "|" + document.getElementById("editorFontSize").value;});
		            	editorFontSize.addEventListener("change", function () {editorFontStyle = document.getElementById("editorFontFamily").value + "|" + document.getElementById("editorFontSize").value;});
		            </script>
		    	</c:if>
		    	
				<c:if test="${useAllUserOldMailDelete eq 'YES'}">
			    	<tr>
						<th><spring:message code="ezSystem.kyj3" /></th>
						<td>
							<input id="useAllUserOldMailDeletePeriod" maxlength="3" type="text" value="${useAllUserOldMailDeletePeriod}"> (<spring:message code="ezSystem.kyj4"/>, <spring:message code="ezSystem.kyj5"/>)
						</td>
					</tr>
					<script>
						var mailDeletePeriod = document.getElementById("useAllUserOldMailDeletePeriod");
						
						mailDeletePeriod.addEventListener("change", function () {
							useAllUserOldMailDeletePeriod = document.getElementById("useAllUserOldMailDeletePeriod").value;
						});
					</script>
				</c:if>
		    	
	        </tbody>
	    </table> 
	    <div class="btnpositionJsp">
	        <a class="imgbtn" onclick="update_Sys_Param()"><span><spring:message code='main.sp09'/></span></a>
	        <a class="imgbtn" onClick="window.location.href='/admin/ezSystem/systemMainMenu.do'"><span><spring:message code='main.t135'/></span></a>
	    </div>       
	</body>
</html>