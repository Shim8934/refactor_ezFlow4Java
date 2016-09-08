<%@page import="org.w3c.dom.Document"%>
<%@page import="egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPersonal.t999900011' /></title>
		<link rel="stylesheet"  href="<spring:message code='ezPersonal.e3' />" type="text/css">
		<script src="/js/mouseeffect.js" type="text/javascript" ></script>
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script type="text/javascript">
		 window.onload = function () {
		        if ("${funCode}" == "1") {
		            document.getElementById("UserInfo").parentNode.onclick()
		            document.getElementById("UserInfo").onclick();
		        }
		    }
			function Open_Func(pthis) {
				switch (pthis.id) {
				    case "BoardEnv":
				        window.parent.frames.right.document.location.href = "/ezBoard/boardConfig.do";
				        break;
					case "Portal":
					    window.parent.frames.right.document.location.href="/ezPortal/myPortalPageList.do";//다중포탈페이지 사용으로 인해 변경
						break;
					case "Portal_sub1":
					    window.parent.frames.right.document.location.href="/ezPortal/myPortalPageList.do";//다중포탈페이지 사용으로 인해 변경
						break;
					case "Portal_sub2":
						window.parent.frames.right.document.location.href="/myoffice/ezPortal/environ/UserSkin.aspx?";
						break;
					case "Portal_sub3":
						window.parent.frames.right.document.location.href="/myoffice/ezPortal/environ/UserImage.aspx";				
						break;
					case "Portal_sub4": // 환경설정시 로그인 첫 화면을 특정 페이지로 선택 할수 있다. 2007-09-19
					    window.parent.frames.right.document.location.href = "/ezPortal/startPageUser.do";	
						break;
					case "Personal":
						window.parent.frames.right.document.location.href="/ezPersonal/userManageWebPart.do";
						break;
					case "UserInfo":
						<%
						String ezInfoSSL = (String)request.getAttribute("ezInfoSSL");
						%>
					    <% if (ezInfoSSL.equals("1")) { %>
						    window.parent.frames.right.document.location.href="${SSL}"+"/ezPersonal/changePersonInfo.do";
					    <% } else { %>
						    window.parent.frames.right.document.location.href="/ezPersonal/changePersonInfo.do";
					    <% } %>
						break;
					case "MailEnv":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_general_cross.aspx";
						break;
						
					case "MailEnv_sub1":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_general_cross.aspx";
						break;
						
					case "MailEnv_sub2":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_usage_cross.aspx";
						break;
						
					case "MailEnv_sub3":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_pop3_cross.aspx";
						break;
				
					case "MailEnv_sub4":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_autoforward_cross.aspx";
						break;
						
					case "MailEnv_sub5":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_filter.aspx";
						break;
						
					case "MailEnv_sub6":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_reject.aspx" ;
						break;
						
					case "MailEnv_sub7":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_autodelete_cross.aspx"; 
						break;
						
					case "MailEnv_sub8":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_setbox.aspx";
						break;
						
					case "MailEnv_sub9":
						if(navigator.userAgent.indexOf("MSIE") != -1)
					    {
					        window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_signature.aspx";
					    }	
					    else if(navigator.userAgent.indexOf("MSIE") == -1)
					    {
						    window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_signature_CK.aspx"; 
		                }	
						break;

					case "MailEnv_sub10":                
		                if(navigator.userAgent.indexOf("MSIE") != -1)
		                {
						    window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_outofoffice.aspx";
						}
						else if(navigator.userAgent.indexOf("MSIE") == -1)
						{
						    window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_outofoffice_CK.aspx";
						}               
						break;
					case "MailEnv_sub11":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_smartReject.aspx";
						break;
					case "ScheduleEnv":
						window.parent.frames.right.document.location.href="/MyOffice/ezSchedule/schedule_config_Cross.aspx";
						break;
					case "ScheduleEnv_sub1":
					    window.parent.frames.right.document.location.href = "/MyOffice/ezSchedule/schedule_config_Cross.aspx";
						break;
					case "ScheduleEnv_sub2":
						window.parent.frames.right.document.location.href="/MyOffice/ezTask/task_config_Cross.aspx";
						break;
					case "ScheduleEnv_sub3":
						window.parent.frames.right.document.location.href="/MyOffice/ezAddress/address_config_Cross.aspx";
						break;
					case "ApprovalPass":
					case "ApprovalEnv":
					    window.parent.frames.right.document.location.href = "/ezPersonal/ezApprovalConfig.do";
						break;
		            case "ApprovNoti":
		                window.parent.frames.right.document.location.href="/MyOffice/ezPersonal/PersonInfo/SetApprovNoticeMail_cross.aspx";
						break;
					case "TaskEnv":
					    window.parent.frames.right.document.location.href = "/MyOffice/ezTask/task_config_Cross.aspx";
						break;
					case "AbsenceEnv":
						window.parent.frames.right.document.location.href="/myoffice/ezPersonal/BujaeConf/ManageBujae_cross.aspx";
						break;
					case "AbsenceEnvG":
						window.parent.frames.right.document.location.href="/myoffice/ezPersonal/BujaeConf/ManageBujaeG_cross.aspx";
						break;
					case "Noti":
						window.parent.frames.right.document.location.href="/myoffice/ezNotification/NotiEnviron.aspx";
						break;
					case "TimeZone":
						window.parent.frames.right.document.location.href="/ezPersonal/timeZone.do";
						break;
					case "MailEnv_sub100":
						window.parent.frames.right.document.location.href="/myoffice/ezEmail/environ/mail_InboxRule_Cross.aspx";
						break;
					default: 
						break;
				}
			}
		    function mail_Config() {
		        parent.frames["right"].location.href = "/ezEmail/mailConfig.do";
		    }
		    function Pims_Config() {
		        parent.frames["right"].location.href = "/myoffice/ezSchedule/PIMS_config.aspx";
		    }
		    function Approval_Config() {
		        parent.frames["right"].location.href = "/ezPersonal/ezApprovalConfig.do";
		    }
		</script>
	</head>
	<body  class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<div id="left">
			<div class="left_env"></div>
			
			<%
				String usePortal = (String)request.getAttribute("usePortal");
			%>
			<% if (usePortal.equals("YES")) { %>
				<h2><span  id="Portal" name="Portal" onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900001' /></span></h2>
				<ul>
					<li><span id="Portal_sub1"  name="Portal_sub1"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900002' /></span></li>
					<li><span id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900005' /></span></li>
				</ul>
			<% } else if (request.getHeader("User-Agent").indexOf("MSIE") > -1 || request.getHeader("User-Agent").indexOf("Trident") > -1) { %>
				<h2><span  id="Personal" name="Personal" onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900005' /></span><ul></ul></h2>
			<% } %>
			
			<h2><span id="UserInfo" name="UserInfo" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t172' /></span><ul></ul></h2>
			<h2><span  id="MailEnv" name="MailEnv" onClick="mail_Config()" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900006' /></span></h2><ul></ul>
			<h2><span  id="ScheduleEnv" name="ScheduleEnv" onClick="Pims_Config()" style="width:100%;display:inline-block" ><spring:message code='ezPersonal.t999900007' /></span></h2><ul></ul>
			<h2><span id="ApprovalEnv" name="ApprovalEnv" onClick="Approval_Config()" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900008' /></span></h2><ul></ul>
    		<h2><span id="BoardEnv" name="BoardEnv" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900030' /></span></h2><ul></ul>
			<h2><span id="TimeZone" name="TimeZone" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900010' /></span><ul></ul></h2>
		</div>
	</body>
	<script type="text/javascript">
    	initToggleList(document.getElementById("left"), "h2", "ul", "li");
	</script>
</html>