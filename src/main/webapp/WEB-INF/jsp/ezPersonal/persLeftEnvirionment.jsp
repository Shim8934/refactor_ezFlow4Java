<%@page import="org.w3c.dom.Document"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPersonal.t999900011' /></title>
		<link rel="stylesheet"  href="<spring:message code='ezPersonal.e3' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
		 	window.onload = function () {
		 		if ("${portalEnv}" == "1") {
		            //document.getElementById("Portal_sub1").parentNode.onclick()
		            document.getElementById("Portal_sub1").onclick();
		        } else if ("${portalEnv}" == "2") {
		        	//document.getElementById("Portal_sub4").parentNode.onclick()
		            document.getElementById("Portal_sub4").onclick();
		        } else {
		        	document.getElementById("Portal_sub1").onclick();
		        }
			 
		        if ("${funCode}" == "1" || "${packageType}" != "standard" || "${firstScreen_Mail}" == "YES" || "${portalEnv}" == "3") {
		        	//2018-08-08 김보미 - 주석제거
		            document.getElementById("UserInfo").parentNode.onclick();
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
					    window.parent.frames.right.document.location.href="/ezPersonal/changePersonInfo.do";
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
					case "CircularEnv":
				        window.parent.frames.right.document.location.href = "/ezCircular/circularConfig.do";
				        break;
					case "journalEnv":
				        window.parent.frames.right.document.location.href = "/ezJournal/journalConfig.do";
				        break;
					case "webfolder":
						window.parent.frames.right.document.location.href = "/ezWebFolder/webfolderConfig.do";
					default: 
						break;
				}
			}
		    function mail_Config() {
		        parent.frames["right"].location.href = "/ezEmail/mailConfig.do";
		    }
		    function Pims_Config() {
		        parent.frames["right"].location.href = "/ezSchedule/scheduleConfigMain.do";
		    }
		    function Approval_Config() {
		        parent.frames["right"].location.href = "/ezPersonal/ezApprovalConfig.do";
		    }
		</script>
	</head>
	<body  class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<div id="left">
			<div class="left_env"><span><spring:message code='ezBoard.t0005' /></span></div>
			<c:if test="${packageType == 'standard'}">
				<c:if test="${firstScreen_Mail != 'YES'}">
					<c:choose>
						<c:when test="${portalEnv == '0'}">
							<h2><span  id="Portal" name="Portal" onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900001' /></span></h2>
							<ul>
								<li><span id="Portal_sub1"  name="Portal_sub1"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900002' /></span></li>
								<li><span id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900005' /></span></li>
							</ul>
						</c:when>
						<c:when test="${portalEnv == '1'}">
							<h2><span  id="Portal_sub1" name="Portal" onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900001' /></span></h2>
							<ul>
								<li><span id="Portal_sub1"  name="Portal_sub1"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900002' /></span></li>
							</ul>
						</c:when>
						<c:when test="${portalEnv == '2'}">
							<h2><span  id="Portal_sub4" name="Portal" onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900001' /></span></h2>
							<ul>
								<li><span id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900005' /></span></li>
							</ul>
						</c:when>
						<c:otherwise>
						</c:otherwise>
					</c:choose>
				</c:if>
            </c:if>
			
			<h2><span id="UserInfo" name="UserInfo" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t172' /></span><ul></ul></h2>
			<c:if test="${isMailUsed == 'Y'}">
				<h2><span  id="MailEnv" name="MailEnv" onClick="mail_Config()" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900006' /></span></h2><ul></ul>
            </c:if>
            <c:if test="${firstScreen_Mail != 'YES' && packageType != 'mail'}">
            	<c:if test="${isScheduleUsed == 'Y'}">
            		<h2><span  id="ScheduleEnv" name="ScheduleEnv" onClick="Pims_Config()" style="width:100%;display:inline-block" ><spring:message code='ezPersonal.t999900007' /></span></h2><ul></ul>
            	</c:if>
	            <c:if test="${packageType == 'standard'}">
	            	<c:if test="${isApprUsed == 'Y'}">
						<h2><span id="ApprovalEnv" name="ApprovalEnv" onClick="Approval_Config()" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900008' /></span></h2><ul></ul>
					</c:if>
	            </c:if>
	            <c:if test="${isBoardUsed == 'Y'}">
	    			<h2><span id="BoardEnv" name="BoardEnv" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900030' /></span></h2><ul></ul>
	    		</c:if>
    			<c:if test="${isCircularUsed == 'Y'}">
    				<h2><span id="CircularEnv" name="CircularEnv" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900031' /></span></h2><ul></ul>
    			</c:if>
            </c:if>
            <c:if test="${isJournalUsed == 'Y'}">
   				<h2><span id="journalEnv" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezJournal.t150' /></span></h2><ul></ul>
   			</c:if>
			<c:if test="${isWebfolderUsed == 'Y'}">
				<h2><span id="webfolder" name="webfolder" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezWebFolder.t31' /></span><ul></ul></h2>
   			</c:if>
			<h2><span id="TimeZone" name="TimeZone" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900010' /></span><ul></ul></h2>
		</div>
	</body>
	<script type="text/javascript">
    	initToggleList(document.getElementById("left"), "h2", "ul", "li");
	</script>
</html>