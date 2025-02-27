<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.kms1'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet"  href="${util.addVer('main.default.css', 'msg')}" type="text/css">
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
				checkUseSession();

				if (timeZone != "") {
					document.getElementById("PrimaryTimeZone").value = timeZone;
				} else {
					document.getElementById("PrimaryTimeZone").value = "235|+09:00";
				}
				
				parameterTableSetting();
			}
			
			function parameterTableSetting() {
				$("#parameterTable tr[class='menuTit']").each(function(i, e) { 
					var thisEle = $(e);
					var TitMenuName = thisEle.attr("data-menuName");
					var TitTrSize = $("#parameterTable tr[data-name=" + TitMenuName + "]").size();
					thisEle.children("th:first-child").attr("rowspan", TitTrSize + 1);
				});
				
				$("#parameterTable").css("opacity","1");
			} 
			
			function update_Sys_Param() {
				
				//checkUseSession();
				
				var paramArray = [];
				$("#parameterTable *[data-paramId]").each(function(i, e) { 
					var paramObj = {
						name : e.getAttribute("data-paramId"),
						value : e.value.trim()
					}
					
					paramArray.push(paramObj);
				});
				
				// 파라미터 체크로직 인덱스가 아닌 이름으로 찾도록 수정. 2020-03-04 홍대표.
				if (!checkParamValid(paramArray)) {
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
						switch (data.msg) {
						case 'success':
							alert("<spring:message code='main.sp10'/>");
							window.location.href='/admin/ezSystem/systemMainMenu.do';
							break;
						case 'fail':
							alert("<spring:message code='main.sp12'/>");
							break;
						case 'domainFail':
							alert("<spring:message code='ezSystem.lhy001'/> \n<spring:message code='ezSystem.lhy002'/> " + data.licenseDomain + "\n<spring:message code='ezSystem.lhy003'/> ${systemDomain}");
							break;
						}
					},
					error : function(e) {
						alert(e);
					}
				});	
			}
			
			function checkUseSession() {
				$.ajax({
					type : "GET",
					url : "/admin/ezSystem/checkUseSession.do",
					dataType: "json",
					success : function(result) {}
				});
			}
			
			function checkParamValid(paramArray) {
				for (var i = 0; i < paramArray.length; i++) {
					var name = paramArray[i].name;
					var value = paramArray[i].value;
					var isNumber = value.match(/^\d+$/);
					var alertMsg;
					
					if (!isNumber) {
						var errFlag = true;
						switch (name) {
							case "BigSizeMailAttachDelDay" :
								alertMsg = "<spring:message code='ezSystem.x0001'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "totBigSizeMailAttachLimit" :
								alertMsg = "<spring:message code='ezSystem.x0002'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "MailAttachLimit" :
								alertMsg = "<spring:message code='ezSystem.x0003'/>: <spring:message code='ezEmail.t99000066'/>";
								break;		
							/* case "ExpirePassPeriod" :
								alertMsg = "<spring:message code='ezSystem.x0005'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "MaxAllowedCountOfLoginFail" :
								alertMsg = "<spring:message code='ezSystem.x0038'/>: <spring:message code='ezEmail.t99000066'/>";
								break; */
							case "INDIVIDUALMAILUSER" :
								alertMsg = "<spring:message code='ezSystem.x0006'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "useSession" :
								alertMsg = "<spring:message code='ezSystem.lsh001'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "useSessionMobile" :
								alertMsg = "<spring:message code='ezSystem.ksaMobileSession'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "usePortalAutoRefreshInterval" :
								alertMsg = "<spring:message code='ezSystem.yej01'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "notiPollingInterval" :
								alertMsg = "<spring:message code='ezNotification.hth37'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "MailBigSizeAttachLimitCount" :
								alertMsg = "<spring:message code='ezEmail.hdp01'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "MailBigSizeAttachDownloadLimitCount" :
								alertMsg = "<spring:message code='ezEmail.hdp02'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							/* 2020-11-12 홍승비 - 전자결재 대용량첨부 관리자 설정 추가 */
							case "ApprTotalAttachLimit" :
								alertMsg = "<spring:message code='ezSystem.HSBAppr00'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "ApprAttachLimit" :
								alertMsg = "<spring:message code='ezSystem.HSBAppr01'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "BigSizeApprAttachLimit" :
								alertMsg = "<spring:message code='ezSystem.x0002'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "BigSizeApprAttachDelDay" :
								alertMsg = "<spring:message code='ezSystem.x0001'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "ApprBigSizeAttachLimitCount" :
								alertMsg = "<spring:message code='ezEmail.hdp01'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							case "ApprBigSizeAttachDownloadLimitCount" :
								alertMsg = "<spring:message code='ezEmail.hdp02'/>: <spring:message code='ezEmail.t99000066'/>";
								break;
							default :
								errFlag = false;
						}
						
						if (errFlag) {
							alert(alertMsg);
							return false;
						}
					}
					
					if(name == "MailBigSizeAttachLimitCount" || name == "ApprBigSizeAttachLimitCount") {
						if (value > 20) {
							alert("<spring:message code='ezEmail.hdp01'/>: <spring:message code='ezEmail.hdp06'/>");
							return false;
						}
					}
				}
				return true;
			}
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='main.kms1'/></h1>
	    <table class="content" id="parameterTable" style="opacity:0;">
	    	<thead>
	    		<tr>
	    			<th></th>
	    			<th><spring:message code="main.kms1"/></th>
	    			<th><spring:message code="main.kms3"/></th>
	    		</tr>
	    	</thead>
	        <tbody>
	        	<!-- 통합 -->
	        	<tr class="menuTit" data-MenuName="common">
	        		<th><spring:message code="ezSystem.x0041" /> </th>
	        	</tr>
	        	<tr data-name="common">
	        		<th><spring:message code="ezSystem.lsh001"/> </th>
	        		<td><input data-paramId="useSession" Id="useSession" minlength="1" maxLength="4" type="text" value="<c:out value='${configMap.useSession}'/>"> (<spring:message code="ezSystem.lsh002"/>)</td>
	        	</tr>
	        	<tr data-name="common"><th><spring:message code="ezSystem.ksaMobileSession"/></th><td><input data-paramId="useSessionMobile" Id="useSessionMobile" minlength="1"  maxLength="4" type="text" value="<c:out value='${configMap.useSessionMobile}'/>"> (<spring:message code="ezSystem.lsh002"/>)</td></tr>
	        	<tr data-name="common"><th><spring:message code="ezSystem.x0008"/></th><td><select data-paramId="PrimaryLang" Id="PrimaryLang" style="display:none;"><option <c:if test="${configMap.PrimaryLang == '1'}">selected="selected"</c:if> value="1"><spring:message code="ezPersonal.s81"/></option><option <c:if test="${configMap.PrimaryLang == '3'}">selected="selected"</c:if> value="3"><spring:message code="ezPersonal.s84"/></option></select>	
	           			<select data-paramId="PrimaryTimeZone" Id="PrimaryTimeZone">
         					<option value="000|-12:00">(UTC-12:00) <spring:message code='ezPersonal.s5'/></option>
         					<option value="001|-11:00">(UTC-11:00) <spring:message code='ezPersonal.s6'/></option>
         					<option value="002|-10:00">(UTC-10:00) <spring:message code='ezPersonal.s7'/></option>
         					<option value="003|-09:00">(UTC-09:00) <spring:message code='ezPersonal.s8'/></option>
         					<option value="004|-08:00">(UTC-08:00) <spring:message code='ezPersonal.s9'/></option>
         					<option value="015|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s12'/></option>
         					<option value="013|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s11'/></option>
         					<option value="010|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s10'/></option>
         					<option value="030|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s15'/></option>
         					<option value="033|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s16'/></option>
         					<option value="025|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s14'/></option>
         					<option value="020|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s13'/></option>
         					<option value="040|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s18'/></option>
         					<option value="035|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s17'/></option>
         					<option value="045|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s19'/></option>
         					<option value="055|-04:30">(UTC-04:30) <spring:message code='ezPersonal.s21'/></option>
         					<option value="050|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s20'/></option>
         					<option value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s22'/></option>
         					<option value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s905'/></option>
         					<option value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s906'/></option>
         					<option value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s907'/></option>
         					<option value="060|-03:30">(UTC-03:30) <spring:message code='ezPersonal.s23'/></option>
         					<option value="070|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s25'/></option>
         					<option value="056|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s908'/></option>
         					<option value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s26'/></option>
         					<option value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s909'/></option>
         					<option value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s910'/></option>
         					<option value="065|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s24'/></option>
         					<option value="075|-02:00">(UTC-02:00) <spring:message code='ezPersonal.s27'/></option>
					        <option value="080|-01:00">(UTC-01:00) <spring:message code='ezPersonal.s28'/></option>
					        <option value="083|-01:00">(UTC-01:00) <spring:message code='ezPersonal.s29'/></option>
					        <option value="090|+00:00">(UTC) <spring:message code='ezPersonal.s31'/></option>
					        <option value="090|+00:00">(UTC) <spring:message code='ezPersonal.s911'/></option>
					        <option value="085|+00:00">(UTC) <spring:message code='ezPersonal.s30'/></option>
					        <option value="100|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s33'/></option>
					        <option value="105|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s34'/></option>
					        <option value="105|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s912'/></option>
					        <option value="110|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s35'/></option>
					        <option value="113|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s36'/></option>
					        <option value="095|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s32'/></option>
					        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s913'/></option>
					        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s914'/></option>
					        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s915'/></option>
					        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s37'/></option>
					        <option value="140|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s42'/></option>
					        <option value="120|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s38'/></option>
					        <option value="125|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s39'/></option>
					        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s916'/></option>
					        <option value="130|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s40'/></option>
					        <option value="135|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s41'/></option>
					        <option value="158|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s46'/></option>
					        <option value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s43'/></option>
					        <option value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s917'/></option>
					        <option value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s918'/></option>
					        <option value="150|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s44'/></option>
					        <option value="160|+03:30">(UTC+03:30) <spring:message code='ezPersonal.s47'/></option>
					        <option value="155|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s45'/></option>
					        <option value="170|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s49'/></option>
					        <option value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s48'/></option>
					        <option value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s919'/></option>
					        <option value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s920'/></option>
					        <option value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s921'/></option>
					        <option value="175|+04:30">(UTC+04:30) <spring:message code='ezPersonal.s50'/></option>
					        <option value="180|+05:00">(UTC+05:00) <spring:message code='ezPersonal.s51'/></option>
					        <option value="185|+05:00">(UTC+05:00) <spring:message code='ezPersonal.s52'/></option>
					        <option value="190|+05:30">(UTC+05:30) <spring:message code='ezPersonal.s53'/></option>
					        <option value="190|+05:30">(UTC+05:30) <spring:message code='ezPersonal.s922'/></option>
					        <option value="193|+05:45">(UTC+05:45) <spring:message code='ezPersonal.s54'/></option>
					        <option value="195|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s55'/></option>
					        <option value="200|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s56'/></option>
					        <option value="201|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s57'/></option>
					        <option value="203|+06:30">(UTC+06:30) <spring:message code='ezPersonal.s58'/></option>
					        <option value="207|+07:00">(UTC+07:00) <spring:message code='ezPersonal.s60'/></option>
					        <option value="205|+07:00">(UTC+07:00) <spring:message code='ezPersonal.s59'/></option>
					        <option value="210|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s61'/></option>
					        <option value="215|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s62'/></option>
					        <option value="225|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s64'/></option>
					        <option value="225|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s923'/></option>
					        <option value="227|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s65'/></option>
					        <option value="220|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s63'/></option>
					        <option value="235|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s67'/></option>
					        <option value="230|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s66'/></option>
					        <option value="240|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s68'/></option>
					        <option value="250|+09:30">(UTC+09:30) <spring:message code='ezPersonal.s70'/></option>
					        <option value="245|+09:30">(UTC+10:30) <spring:message code='ezPersonal.s69'/></option>
					        <option value="265|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s73'/></option>
					        <option value="255|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s71'/></option>
					        <option value="255|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s924'/></option>
					        <option value="260|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s72'/></option>
					        <option value="270|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s74'/></option>
					        <option value="275|+11:00">(UTC+11:00) <spring:message code='ezPersonal.s75'/></option>
					        <option value="280|+11:00">(UTC+11:00) <spring:message code='ezPersonal.s76'/></option>
					        <option value="281|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s900'/></option>
					        <option value="285|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s77'/></option>
					        <option value="290|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s78'/></option>
					        <option value="290|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s925'/></option>
					        <option value="300|+13:00">(UTC+13:00) <spring:message code='ezPersonal.s79'/></option>
					        <option value="300|+13:00">(UTC+13:00) <spring:message code='ezPersonal.s926'/></option>
	       				</select>
					</td>
				</tr>
<%--	        	<tr data-name="common"><th><spring:message code="ezSystem.x0009"/></th><td><input data-paramId="USE_FileExtension" Id="USE_FileExtension" type="text" value="<c:out value='${configMap.USE_FileExtension}'/>"> (<spring:message code="ezSystem.x0012"/>, <spring:message code="ezSystem.x0013"/>: jpg,doc,xls)</td></tr>--%>
	        	<tr data-name="common"><th><spring:message code="ezSystem.x0016"/></th><td><input data-paramId="LicenseKey" Id="LicenseKey" maxlength="200" type="text" value="<c:out value='${configMap.LicenseKey}'/>" style="width:40%" /> (<spring:message code="ezSystem.x0017"/>: ${licensedUserCount}, <spring:message code="ezSystem.x0018"/>: ${userCount})</td></tr>
	        	<tr data-name="common"><th><spring:message code="ezSystem.lhj1"/></th><td><select data-paramId="Use_HTMLMode" Id="Use_HTMLMode"> <option <c:if test="${configMap.USE_HTMLMODE == null or configMap.USE_HTMLMODE == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezQuestion.t103"/></option><option <c:if test="${configMap.USE_HTMLMODE == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezQuestion.t104"/></option></select></td></tr>
	        	<c:if test="${configMap.PrimaryLang == '1' and configMap.editorFontStyle != null}">
	            	<tr data-name="common">
		            	<th><spring:message code="ezSystem.lhm1"/></th>
		            	<td><input type="hidden" data-paramId="editorFontStyle" Id="editorFontStyle" value="${configMap.editorFontStyle}"/>
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
		            	
		            	editorFontFamily.addEventListener("change", function () {editorFontStyle = document.getElementById("editorFontFamily").value + "|" + document.getElementById("editorFontSize").value; document.getElementById("editorFontStyle").value = editorFontStyle; });
		            	editorFontSize.addEventListener("change", function () {editorFontStyle = document.getElementById("editorFontFamily").value + "|" + document.getElementById("editorFontSize").value; document.getElementById("editorFontStyle").value = editorFontStyle; });
		            </script>
		    	</c:if>
		    	
	        	<!-- 포탈 -->
	        	<c:if test="${usePortal eq 'YES' and packageType ne 'mail'}">
		    	<tr class="menuTit" data-MenuName="portal"><th><spring:message code="ezSystem.x0042" /></th></tr>
				<tr data-name="portal">
					<th><spring:message code="ezSystem.yej01" /></th>
					<td>
						<input data-paramId="usePortalAutoRefreshInterval" Id="usePortalAutoRefreshInterval" maxlength="3" type="text" value="<c:out value='${usePortalAutoRefreshInterval}'/>"> (<spring:message code="ezSystem.yej02"/>)
					</td>
				</tr>
				<tr data-name="portal">
					<th><spring:message code="ezNotification.hth37" /></th>
					<td>
						<input data-paramId="notiPollingInterval" Id="notiPollingInterval" maxlength="3" type="text" value="<c:out value='${notiPollingInterval}'/>"> (<spring:message code="ezSystem.yej02"/>)
					</td>
				</tr>
				<tr data-name="portal">
					<th><spring:message code="ezSystem.reset01" /></th>
					<td>
						<a class="imgbtn resetBtn" id="frameReset" onclick="personalReset('frame')"><span><spring:message code='ezSystem.reset03'/></span></a>
						<spring:message code="ezSystem.reset12" />
					</td>
				</tr>
				<tr data-name="portal">
					<th><spring:message code="ezSystem.reset02" /></th>
					<td>
						<a class="imgbtn resetBtn" id="portletReset" onclick="personalReset('portlet')"><span><spring:message code='ezSystem.reset04'/></span></a>
						<spring:message code='ezSystem.reset13'/>
					</td>
				</tr>
				</c:if>
				
	        	<!-- 메일 -->
	        	<c:if test="${useExternalMailServer != 'YES'}">
		        	<tr class="menuTit" data-MenuName="mail"><th><spring:message code="ezSystem.x0043" /></th></tr>
		        	<tr data-name="mail"><th><spring:message code="ezSystem.x0003"/></th><td><input data-paramId="MailAttachLimit" id="MailAttachLimit" maxlength="3" type="text" value="<c:out value='${configMap.MailAttachLimit}'/>"> (<spring:message code="ezSystem.x0011"/>)</td></tr>          
		            <tr data-name="mail"><th><spring:message code="ezSystem.x0002"/></th><td><input data-paramId="totBigSizeMailAttachLimit" id="totBigSizeMailAttachLimit" maxlength="4" type="text" value="<c:out value='${configMap.totBigSizeMailAttachLimit}'/>"> (<spring:message code="ezSystem.x0011"/>, <spring:message code="ezSystem.x0019"/>)</td></tr>
		            <tr data-name="mail"><th><spring:message code="ezSystem.x0001"/></th><td><input data-paramId="BigSizeMailAttachDelDay" id="BigSizeMailAttachDelDay" maxlength="3" type="text" value="<c:out value='${configMap.BigSizeMailAttachDelDay}'/>"> (<spring:message code="ezSystem.x0010"/>)</td></tr>          
		            
			    	<tr data-name="mail">
			    		<th><spring:message code="ezEmail.hdp01"/></th>
			    		<td><input data-paramId="MailBigSizeAttachLimitCount" id="MailBigSizeAttachLimitCount" maxlength="2" type="text" value="<c:out value='${configMap.MailBigSizeAttachLimitCount}'/>"> (<spring:message code="ezSystem.x0014"/>)</td>
			    	</tr>
	            	<tr data-name="mail">
	            		<th><spring:message code="ezEmail.hdp02"/></th>
	            		<td><input data-paramId="MailBigSizeAttachDownloadLimitCount" id="MailBigSizeAttachDownloadLimitCount" maxlength="5" type="text" value="<c:out value='${configMap.MailBigSizeAttachDownloadLimitCount}'/>"> (<spring:message code="ezSystem.x0014"/>)</td>
	            	</tr>
		            
		            <tr data-name="mail"><th><spring:message code="ezSystem.x0006"/></th><td><input data-paramId="INDIVIDUALMAILUSER" id="INDIVIDUALMAILUSER" maxlength="3" type="text" value="<c:out value='${configMap.INDIVIDUALMAILUSER}'/>"> (<spring:message code="ezSystem.x0015"/>)</td></tr>
		            <%-- 2024-01-30 장혜연 메일 개별발신 디폴터 설정 추가 --%>
		            <tr data-name="mail" >
						<th><spring:message code="ezSystem.hy01"/></th>
						<td><select data-paramId="useEachMailDefault" id="use_EachMailDefault"><option <c:if test="${configMap.useEachMailDefault == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezQuestion.t103"/></option><option <c:if test="${configMap.useEachMailDefault == null or configMap.useEachMailDefault == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezQuestion.t104"/></option></select></td>
					</tr>
		            <tr data-name="mail"><th><spring:message code="ezSystem.x0007"/></th><td><select data-paramId="IS_READ_DELETE" id="IS_READ_DELETE"><option <c:if test="${configMap.IS_READ_DELETE == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezSystem.hsb01"/></option><option <c:if test="${configMap.IS_READ_DELETE == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezSystem.hsb02"/></option></select></td></tr>
		            <tr data-name="mail"><th><spring:message code="ezSystem.x0020"/></th><td><select data-paramId="Use_FromAddress" id="Use_FromAddress"><option <c:if test="${configMap.Use_FromAddress == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezQuestion.t103"/></option><option <c:if test="${configMap.Use_FromAddress == null or configMap.Use_FromAddress == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezQuestion.t104"/></option></select></td></tr>
					<c:if test="${useAllUserOldMailDelete eq 'YES'}">
				    	<tr data-name="mail">
							<th><spring:message code="ezSystem.kyj3" /></th>
							<td>
								<input data-paramId="useAllUserOldMailDeletePeriod" id="useAllUserOldMailDeletePeriod" maxlength="3" type="text" value="<c:out value='${useAllUserOldMailDeletePeriod}'/>"> (<spring:message code="ezSystem.kyj4"/>, <spring:message code="ezSystem.kyj5"/>)
							</td>
						</tr>
						<script>
							var mailDeletePeriod = document.getElementById("useAllUserOldMailDeletePeriod");
							
							mailDeletePeriod.addEventListener("change", function () {
								useAllUserOldMailDeletePeriod = document.getElementById("useAllUserOldMailDeletePeriod").value;
							});
						</script>
					</c:if>
			    	<tr data-name="mail">
			    		<th><spring:message code="ezSystem.x0040"/></th>
			    		<td><select data-paramId="useMailConfirm" id="use_MailConfirm"><option <c:if test="${configMap.useMailConfirm == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezQuestion.t103"/></option><option <c:if test="${configMap.useMailConfirm == null or configMap.useMailConfirm == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezQuestion.t104"/></option></select></td>
			    	</tr>
		    	</c:if>
		    	<c:if test="${dotNetIntegration ne 'YES' and packageType ne 'mail'}">
			    	<%-- 2020-11-12 홍승비 - 전자결재 대용량첨부 관리자 설정 추가 --%>
			    	<tr class="menuTit" data-MenuName="approval"><th><spring:message code="main.t25" /></th></tr>
		        	<tr data-name="approval"><th><spring:message code="ezSystem.HSBAppr00"/></th><td><input data-paramId="ApprTotalAttachLimit" id="ApprTotalAttachLimit" maxlength="4" type="text" value="<c:out value='${configMap.ApprTotalAttachLimit}'/>"> (<spring:message code="ezSystem.x0011"/>, <spring:message code="ezSystem.x0014"/>)</td></tr>          
		        	<tr data-name="approval"><th><spring:message code="ezSystem.HSBAppr01"/></th><td><input data-paramId="ApprAttachLimit" id="ApprAttachLimit" maxlength="3" type="text" value="<c:out value='${configMap.ApprAttachLimit}'/>"> (<spring:message code="ezSystem.x0011"/>)</td></tr>          
		            <tr data-name="approval"><th><spring:message code="ezSystem.x0002"/></th><td><input data-paramId="BigSizeApprAttachLimit" id="BigSizeApprAttachLimit" maxlength="4" type="text" value="<c:out value='${configMap.BigSizeApprAttachLimit}'/>"> (<spring:message code="ezSystem.x0011"/>, <spring:message code="ezSystem.x0019"/>)</td></tr>
		            <%-- 대용량첨부 자동삭제 기능 사용하지 않음, 주석처리 --%>
		            <%--<tr data-name="approval"><th><spring:message code="ezSystem.x0001"/></th><td><input data-paramId="BigSizeApprAttachDelDay" id="BigSizeApprAttachDelDay" maxlength="3" type="text" value="<c:out value='${configMap.BigSizeApprAttachDelDay}'/>"> (<spring:message code="ezSystem.x0010"/>)</td></tr>--%>          
			    	<tr data-name="approval">
			    		<th><spring:message code="ezEmail.hdp01"/></th>
			    		<td><input data-paramId="ApprBigSizeAttachLimitCount" id="ApprBigSizeAttachLimitCount" maxlength="2" type="text" value="<c:out value='${configMap.ApprBigSizeAttachLimitCount}'/>"> (<spring:message code="ezSystem.x0014"/>)</td>
			    	</tr>
			    	
			    	<%-- 다운로드횟수제한 기본값 0으로 셋팅하고 display none처리 (사실상 기능 사용안함) --%>
	            	<tr data-name="approval" style="display:none;">
	            		<th><spring:message code="ezEmail.hdp02"/></th>
	            		<%--<td><input data-paramId="ApprBigSizeAttachDownloadLimitCount" id="ApprBigSizeAttachDownloadLimitCount" maxlength="5" type="text" value="<c:out value='${configMap.ApprBigSizeAttachDownloadLimitCount}'/>"> (<spring:message code="ezSystem.x0014"/>)</td>--%>
	            		<td><input data-paramId="ApprBigSizeAttachDownloadLimitCount" id="ApprBigSizeAttachDownloadLimitCount" maxlength="5" type="text" value="0"> (<spring:message code="ezSystem.x0014"/>)</td>
	            	</tr>
            	</c:if>
	        </tbody>
	    </table> 
	    <div class="btnpositionJsp">
	        <a class="imgbtn" onclick="update_Sys_Param()"><span><spring:message code='main.sp09'/></span></a>
	        <a class="imgbtn" onClick="window.location.href='/admin/ezSystem/systemMainMenu.do'"><span><spring:message code='main.t135'/></span></a>
	    </div>       
	<script>
		function personalReset(val) {
			var wWeight ="390";
			var wHeight = "250";

			var heigth = window.screen.availHeight;
			var width = window.screen.availWidth;
			var left = (width - wWeight) / 2;
			var top = (heigth - wHeight) / 2;
			console.log(val);
			if (val == "frame") {
				window.open("/admin/ezSystem/resetUserSettings.do?type=frame", "", "height = " + wHeight + ", width = " + wWeight
						+ ", status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1, top=" + top + ",left = " + left);
			} else if (val == "portlet") {
				window.open("/admin/ezSystem/resetUserSettings.do?type=portlet", "", "height = " + wHeight + ", width = " + wWeight
						+ ", status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1, top=" + top + ",left = " + left);
			}
		}
		
	</script>
	</body>
</html>