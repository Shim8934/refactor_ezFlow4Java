<%@page import="org.w3c.dom.Document"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezNewPortal.t006' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<link type="text/css" rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" />
	    <style type="text/css">
	    	#mCSB_1_container {
				margin-right: 0px;
			}
			.lnbUL li .list_text {
				width: 125%;
			}
	    </style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript">
			var configFlag = "true";
		 	window.onload = function () {
		 		// 20181018 조진호 - 패키지타입이 standard가 아닐때 일어나는 오류 수정
		 		if ("${funCode}" == "1" || "${packageType}" != "standard" || "${firstScreen_Mail}" == "YES" || "${portalEnv}" == "3") {
		        	//2018-08-08 김보미 - 주석제거
//		            document.getElementById("UserInfo").parentNode.onclick();
		            document.getElementById("UserInfo").onclick();
		        } else if("${usePortal}" == "NO") {
		        	document.getElementById("TimeZone").onclick();			        	
		        } else {
		        	// 테마설정 메뉴 제거
// 		        	if ("${portalEnv}" == "1") {
// 			            //document.getElementById("Portal_sub1").parentNode.onclick()
// 			            document.getElementById("Portal_sub1").onclick();
// 			        } else if ("${portalEnv}" == "2") {
// 			        	//document.getElementById("Portal_sub4").parentNode.onclick()
// 			            document.getElementById("Portal_sub4").onclick();
// 			        } else {
// 			        	document.getElementById("Portal_sub1").onclick();
// 			        }
		            document.getElementById("Portal_sub4").click();
		        }
		 		leftResize();
		        $(".envListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});
		    }
			function Open_Func(pthis) {
				switch (pthis.id) {
				    case "BoardEnv":
				        window.parent.frames.right.document.location.href = "/ezBoard/boardConfig.do";
				        break;
					case "Portal":
					    //window.parent.frames.right.document.location.href="/ezPortal/myPortalPageList.do";//다중포탈페이지 사용으로 인해 변경
					    window.parent.frames.right.document.location.href="/ezNewPortal/userThemeSetting.do";//ezNewPortal
						break;
					case "Portal_sub1":
					    //window.parent.frames.right.document.location.href="/ezPortal/myPortalPageList.do";//다중포탈페이지 사용으로 인해 변경
					    window.parent.frames.right.document.location.href="/ezNewPortal/userThemeSetting.do";//ezNewPortal
						break;
					case "Portal_sub2":
						window.parent.frames.right.document.location.href="/myoffice/ezPortal/environ/UserSkin.aspx?";
						break;
					case "Portal_sub3":
						window.parent.frames.right.document.location.href="/myoffice/ezPortal/environ/UserImage.aspx";				
						break;
					case "Portal_sub4": // 환경설정시 로그인 첫 화면을 특정 페이지로 선택 할수 있다. 2007-09-19
					    //window.parent.frames.right.document.location.href = "/ezPortal/startPageUser.do";
					    window.parent.frames.right.document.location.href = "/ezNewPortal/userStartPageSetting.do";
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
						break;
					case "LOGINHIST":
						window.parent.frames.right.document.location.href = "/ezSystem/systemLoginHist.do";
						// 2023-06-28 황인경 - 디자인 개선 > 사용자환경설정 > 좌측메뉴 > 트리구조 LNB 이미지 수정, 클래스 제어
						$("h2.on").attr("class", "off");
						$(".lnbUL.on").removeClass("on").addClass("off");
						$(".list_text.node_selected").removeClass("node_selected");
						$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
						$("#LOGINHIST").parent().attr("class", "on");
						break;
					case "ezPMSEnv":
						window.parent.frames.right.document.location.href = "/ezPMS/pmsSetting.do";
						break;
					case "noti":
						window.parent.frames.right.document.location.href="/ezPersonal/notificationSetting.do";
						break;
					case "useSurvey":
						window.parent.frames.right.document.location.href="/ezSurvey/surveyConfig.do";
						break;
					default: 
						break;
				}
				
				// 2023-06-28 황인경 - 디자인 개선 > 사용자환경설정 > 좌측메뉴 > 트리구조 서브메뉴 선택 클래스 제어
				if (pthis.id != "LOGINHIST") {
					liSelected();
				}
			}
		    function mail_Config() {
		        parent.frames["right"].location.href = "/ezEmail/mailConfig.do?flag=email";
		        liSelected();
		    }
		    function address_Config() {
		        parent.frames["right"].location.href = "/ezEmail/mailConfig.do?flag=address";
		        liSelected();
		    }
		    function Pims_Config() {
		        parent.frames["right"].location.href = "/ezSchedule/scheduleConfigMain.do?flag=schedule";
		        liSelected();
		    }
		    function Approval_Config() {
		        parent.frames["right"].location.href = "/ezPersonal/ezApprovalConfig.do";
		        liSelected();
		    }
		    function Task_Config() {
		        parent.frames["right"].location.href = "/ezSchedule/scheduleConfigMain.do?flag=task";
		        liSelected();
		    }
		    function leftResize(){
	        	$(".envListBox").height(window.innerHeight-55);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
	        
	        function showProgress() {
			    document.getElementById("progressPanel").style.display = "block";
			    document.getElementById("progressPanel").style.opacity = 0.5;
			    document.getElementById("progressPanel").style.background = "rgba(0,0,0,0.7)";
			}
	        
	        function hideProgress() {
	        	document.getElementById("progressPanel").style.display = "none";
	        }
	        
	        // 2023-06-28 황인경 - 디자인 개선 > 사용자환경설정 > 좌측메뉴 > 트리구조 LNB 이미지 수정, 클래스 제어
	        function openFolder() {
	        	var openSpan = $(event.target).parent();
		        
		        if (openSpan.hasClass("off")) {
		           	$("h2.on").attr("class", "off");
		           	$(".lnbUL.on").removeClass("on").addClass("off");
		           	$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		           	openSpan.attr("class", "on");
		           	
		           	if (openSpan.children().eq(1).Id != "LOGINHIST") {
		           		openSpan.next().attr("class", "lnbUL on");
		           		openSpan.children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
		           	}
		           	
		        } else {
		        	openSpan.attr("class", "off");
		        	   $(".lnbUL.on").removeClass("on").addClass("off");
			           $(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		        }
	        }
	        
	        function liSelected() {
	        	if (event.target.tagName == "SPAN") {
		        	$(".node_selected").attr("class", "list_text");
			    	$("#" + event.target.id).attr("class", "list_text node_selected");
	        	}
	        }
		</script>
	</head>
	<body  class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
		<!-- <div class="lnb_btn"></div> -->
        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기-->        
	    	<div class="left_title" title="<spring:message code='ezNewPortal.t006' />"><spring:message code='ezNewPortal.t006' />
	        	<!--<span class="sub_iconLNB tree_leftconfig" title="환경설정"></span>-->
	        </div>
	        <div class="envListBox" style="overflow:hidden; padding-right: 0;">
		        <%-- 2023-06-28 황인경 - 디자인 개선 > 사용자환경설정 > 좌측메뉴 > LNB 클래스 변경 --%>
		        <h2 class="on">
	            	<span class="sub_iconLNB tree_arrow_down"></span><span class="h2Title" onclick="openFolder()"><spring:message code='ezPersonal.jjh01' /></span>
		        </h2>
		        <ul class="lnbUL on">
               		<c:if test="${packageType == 'standard'}">
						<c:if test="${firstScreen_Mail != 'YES'}">
							<c:choose>
								<c:when test="${portalEnv == '0' and usePortal eq 'YES'}">
<%-- 	                            	<li><span class="list_text node_selected" id="Portal_sub1" name="Portal_sub1"  onclick="Open_Func(this)"><spring:message code='ezNewPortal.t034' /></span></li> --%>
	                            	<li><span class="list_text" id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)"><spring:message code='ezNewPortal.t136' /></span></li>
			                    </c:when>
			                    <c:when test="${portalEnv == '1'}">
<%-- 	                            	<li><span class="list_text" id="Portal_sub1" name="Portal_sub1"  onclick="Open_Func(this)"><spring:message code='ezNewPortal.t034' /></span></li> --%>
			                    </c:when>
			                    <c:when test="${portalEnv == '2'}">
	                            	<li><span class="list_text" id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)"><spring:message code='ezNewPortal.t136' /></span></li>
			                    </c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:if>
		            </c:if>
<%-- 				<h2 class="on"> 
	 	            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title"><spring:message code='ezPersonal.jjh01' /></span> 
	 		        </h2> 
	 		        <ul class="lnbUL"> 
	                	<c:if test="${packageType == 'standard'}"> 
	 						<c:if test="${firstScreen_Mail != 'YES'}"> 
	 							<c:choose> 
	 								<c:when test="${portalEnv == '0' and usePortal eq 'YES'}"> 
	 	                            	<li><span class="sub_iconLNB tree_env_myPortal"></span><span class="list_text" id="Portal_sub1" name="Portal_sub1"  onclick="Open_Func(this)"><spring:message code='ezNewPortal.t034' /></span></li> 
	 	                            	<li><span class="sub_iconLNB tree_env_myPortal"></span><span class="list_text" id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)"><spring:message code='ezNewPortal.t136' /></span></li> 
	 			                    </c:when> 
	 			                    <c:when test="${portalEnv == '1'}"> 
	 	                            	<li><span class="sub_iconLNB tree_env_myPortal"></span><span class="list_text" id="Portal_sub1" name="Portal_sub1"  onclick="Open_Func(this)"><spring:message code='ezNewPortal.t034' /></span></li> 
	 			                    </c:when> 
	 			                    <c:when test="${portalEnv == '2'}"> 
	 	                            	<li><span class="sub_iconLNB tree_env_myPortal"></span><span class="list_text" id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)"><spring:message code='ezNewPortal.t136' /></span></li> 
	 			                    </c:when> 
	 								<c:otherwise></c:otherwise> 
	 							</c:choose> 
	 						</c:if> 
	 		            </c:if> --%>
		            <c:if test="${usePortal eq 'YES' }">
                   	<%-- 2023-06-28 황인경 - 디자인 개선 > 사용자환경설정 > 좌측메뉴 > LNB 이미지 삭제 --%>
                   	<li><span class="list_text" id="UserInfo" name="UserInfo" onClick="Open_Func(this)"><spring:message code='ezPersonal.t172' /></span></li>
                   	</c:if>
					<%-- 아래 2가지 상황 중 하나 이상 해당되어야 알림환경설정을 보여줌
						1. 사용자에게 결재 메뉴가 표출되는 권한이 있을 때
						2. 사용자에게 메일 메뉴가 표출되는 권한이 있으면서 서버 내에서 톡 푸시를 사용할 때 --%>
					<c:if test="${isApprUsed == 'Y' or (isMailUsed == 'Y' and useEzTalkNotification)}">
					<li><span class="list_text" id="noti" onclick="Open_Func(this)"><spring:message code='ezPersonal.noti.title' /></span></li>
					</c:if>
                   	<li><span class="list_text" id="TimeZone" name="TimeZone" onClick="Open_Func(this)"><spring:message code='ezPersonal.s3' /></span></li>
		        </ul>
		        <h2 class="off">
	            	<span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder()"><spring:message code='ezPersonal.jjh02' /></span>
		        </h2>
		        <ul class="lnbUL off">
               		<c:if test="${isMailUsed == 'Y'}">
                       	<li><span class="list_text" id="MailEnv" name="MailEnv" onClick="mail_Config()"><spring:message code='ezEmail.t904' /></span></li>
                       	<li><span class="list_text" id="AddressEnv" name="AddressEnv" onClick="address_Config()"><spring:message code='ezAddress.hyh001' /></span></li>
                    </c:if>
                    <c:if test="${firstScreen_Mail != 'YES' && packageType != 'mail'}">
       					<c:if test="${isScheduleUsed == 'Y'}">
                          	<li><span class="list_text" id="ScheduleEnv" name="ScheduleEnv" onClick="Pims_Config()"><spring:message code='ezPersonal.t999900007' /></span></li>
	                   </c:if>
	                   <c:if test="${isTaskUsed == 'Y'}">
                           	<li><span class="list_text" id="TaskEnv" name="TaskEnv" onClick="Task_Config()"><spring:message code='ezTask.hyh001' /></span></li>
	                   </c:if>
	                    <c:if test="${packageType == 'standard'}">
	                    	<c:if test="${isApprUsed == 'Y'}">
                            	<li><span class="list_text" id="ApprovalEnv" name="ApprovalEnv" onClick="Approval_Config()"><spring:message code='ezPersonal.t999900008' /></span></li>
		                    </c:if>
		                </c:if>
		                <c:if test="${isBoardUsed == 'Y'}">    	
                           	<li><span class="list_text" id="BoardEnv" name="BoardEnv" onClick="Open_Func(this)"><spring:message code='ezBoard.t10010' /></span></li>
	                    </c:if>
	                    <c:if test="${isCircularUsed == 'Y'}">                          
                           	<li><span class="list_text" id="CircularEnv" name="CircularEnv" onClick="Open_Func(this)"><spring:message code='ezCircular.t17' /></span></li>
	                    </c:if>                                                          
	                    <c:if test="${isJournalUsed == 'Y'}">                            
                           	<li><span class="list_text" id="journalEnv" onClick="Open_Func(this)"><spring:message code='ezJournal.t150' /></span></li>
	                    </c:if>                                                         
	                    <c:if test="${isWebfolderUsed == 'Y'}">                         
                           	<li><span class="list_text" id="webfolder" name="webfolder" onClick="Open_Func(this)"><spring:message code='ezWebFolder.t31' /></span></li>
	                    </c:if>                                                         
	                    <c:if test="${isPMSUsed == 'Y'}">                               
                           	<li><span class="list_text" id="ezPMSEnv" name="ezPMS" onClick="Open_Func(this)"><spring:message code='ezPMS.t171' /></span></li>
	                    </c:if>
						<c:if test="${isuseSurveyUsed == 'Y'}">
							<li><span class="list_text" id="useSurvey" name="useSurvey" onClick="Open_Func(this)"><spring:message code='ezSurvey.t08' /></span></li>
						</c:if>
					</c:if>
		        </ul>
		        <h2><span class="sub_iconLNB tree_plus" ></span><span id="LOGINHIST" onClick="Open_Func(this)"><spring:message code='ezSystem.x0021' /></span></h2>
<%-- 		        <li><span class="sub_iconLNB tree_env_myPortal"></span><span class="list_text" id="UserInfo" name="UserInfo" onClick="Open_Func(this)"><spring:message code='ezPersonal.t172' /></span></li> --%>
<%--                    	</c:if> --%>
<%-- 					아래 2가지 상황 중 하나 이상 해당되어야 알림환경설정을 보여줌
<%-- 						1. 사용자에게 결재 메뉴가 표출되는 권한이 있을 때 --%>
<%-- 						2. 사용자에게 메일 메뉴가 표출되는 권한이 있으면서 서버 내에서 톡 푸시를 사용할 때 --%>
<%-- 					<c:if test="${isApprUsed == 'Y' or (isMailUsed == 'Y' and useEzTalkNotification)}">
	 					<li><span class="sub_iconLNB tree_env_myPortal"></span><span class="list_text" id="noti" onclick="Open_Func(this)"><spring:message code='ezPersonal.noti.title' /></span></li> 
	 					</c:if> 
	                    	<li><span class="sub_iconLNB tree_env_myPortal"></span><span class="list_text" id="TimeZone" name="TimeZone" onClick="Open_Func(this)"><spring:message code='ezPersonal.s3' /></span></li> 
	 		        </ul> 
	 		        <h2 class="on"> 
	 	            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title"><spring:message code='ezPersonal.jjh02' /></span> 
	 		        </h2> 
	 		        <ul class="lnbUL"> 
	                		<c:if test="${isMailUsed == 'Y'}"> 
	                        	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="MailEnv" name="MailEnv" onClick="mail_Config()"><spring:message code='ezEmail.t904' /></span></li> 
	                        	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="AddressEnv" name="AddressEnv" onClick="address_Config()"><spring:message code='ezAddress.hyh001' /></span></li> 
	                     </c:if> 
	                     <c:if test="${firstScreen_Mail != 'YES' && packageType != 'mail'}"> 
	        					<c:if test="${isScheduleUsed == 'Y'}"> 
	                           	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="ScheduleEnv" name="ScheduleEnv" onClick="Pims_Config()"><spring:message code='ezPersonal.t999900007' /></span></li> 
	 	                   </c:if> 
	 	                   <c:if test="${isTaskUsed == 'Y'}"> 
	                            	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="TaskEnv" name="TaskEnv" onClick="Task_Config()"><spring:message code='ezTask.hyh001' /></span></li> 
	 	                   </c:if> 
	 	                    <c:if test="${packageType == 'standard'}"> 
	 	                    	<c:if test="${isApprUsed == 'Y'}"> 
	                             	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="ApprovalEnv" name="ApprovalEnv" onClick="Approval_Config()"><spring:message code='ezPersonal.t999900008' /></span></li> 
	 		                    </c:if> 
	 		                </c:if> 
	 		                <c:if test="${isBoardUsed == 'Y'}">    	 
	                            	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="BoardEnv" name="BoardEnv" onClick="Open_Func(this)"><spring:message code='ezBoard.t10010' /></span></li> 
	 	                    </c:if> 
	 	                    <c:if test="${isCircularUsed == 'Y'}"> 
	                            	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="CircularEnv" name="CircularEnv" onClick="Open_Func(this)"><spring:message code='ezCircular.t17' /></span></li> 
	 	                    </c:if> 
	 	                    <c:if test="${isJournalUsed == 'Y'}"> 
	                            	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="journalEnv" onClick="Open_Func(this)"><spring:message code='ezJournal.t150' /></span></li> 
	 	                    </c:if> 
	 	                    <c:if test="${isWebfolderUsed == 'Y'}"> 
	                            	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="webfolder" name="webfolder" onClick="Open_Func(this)"><spring:message code='ezWebFolder.t31' /></span></li> 
	 	                    </c:if> 
	 	                    <c:if test="${isPMSUsed == 'Y'}"> 
	                            	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" id="ezPMSEnv" name="ezPMS" onClick="Open_Func(this)"><spring:message code='ezPMS.t171' /></span></li> 
	 	                    </c:if> 
	 					</c:if> 
	 		        </ul> -->
	 		        <h2><span id="LOGINHIST" style="display:inline-block;width:100%;" onClick="Open_Func(this)"><spring:message code='ezSystem.x0021' /></span></h2> --%>
	        </div>
	    </div>
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;display:none;" id="progressPanel">&nbsp;</div>    
		<%-- <div id="left">
			<div class="left_env"><span><spring:message code='ezBoard.t0005' /></span></div>
			<c:if test="${packageType == 'standard'}">
				<c:if test="${firstScreen_Mail != 'YES'}">
					<c:choose>
						<c:when test="${portalEnv == '0'}">
							<h2><span  id="Portal" name="Portal" onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900001' /></span></h2>
							<ul>
								<li><span id="Portal_sub1"  name="Portal_sub1"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.t999900002' /></span></li>
								<li><span id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezNewPortal.t136' /></span></li>
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
								<li><span id="Portal_sub4"  name="Portal_sub4"  onclick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezNewPortal.t136' /></span></li>
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
				<h2><span  id="AddressEnv" name="AddressEnv" onClick="address_Config()" style="width:100%;display:inline-block"><spring:message code='ezAddress.hyh001' /></span></h2><ul></ul>
            </c:if>
            <c:if test="${firstScreen_Mail != 'YES' && packageType != 'mail'}">
            	<c:if test="${isScheduleUsed == 'Y'}">
            		<h2><span  id="ScheduleEnv" name="ScheduleEnv" onClick="Pims_Config()" style="width:100%;display:inline-block" ><spring:message code='ezPersonal.t999900007' /></span></h2><ul></ul>
            		<h2><span  id="TaskEnv" name="TaskEnv" onClick="Task_Config()" style="width:100%;display:inline-block" ><spring:message code='ezTask.hyh001' /></span></h2><ul></ul>
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
			<h2><span id="TimeZone" name="TimeZone" onClick="Open_Func(this)" style="width:100%;display:inline-block"><spring:message code='ezPersonal.s3' /></span><ul></ul></h2>
		</div> --%>
	</body>
	<script type="text/javascript">
    	//initToggleList(document.getElementById("left"), "h2", "ul", "li");
	</script>
</html>