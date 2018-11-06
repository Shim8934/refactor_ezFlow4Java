<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('main.e4', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script>
			var useHWP = "${useHWP}";
			function window_onload(){
				process();
			}
			
			function process() {
			    <c:if test="${packageType != 'standard' || firstScreen_Mail == 'YES'}">
			    	window.open("/admin/ezOrgan/organMain.do", "bottom");
			    </c:if>
			    <c:if test="${packageType == 'standard' && firstScreen_Mail == 'NO'}">
				//일단 게시판으로 이동하게 만듬 2016-02-16 장진혁
				//메인화면 포탈로 설정 2016-10-04 지정석
//					window.open("/admin/ezPortal/portalMain.do", "bottom");
 					window.open("/admin/ezNewPortal/portalMain.do", "bottom");
				</c:if>
				<c:if test="${use_portal != 'YES'}">
					window.open("/admin/ezPersonal/personalMain.do", "bottom");
				</c:if>
				
				<c:if test="${useHWP == 'YES' && approvalFlag == 'G'}">
					var userAgent = window.navigator.userAgent;
					
					if ((/msie/i.test(userAgent)) || (/rv:11.0/i.test(userAgent))) {
						GetObject();
					}
		    	</c:if>
			}
			
			function menu_change(width, e){
		        var menuname = e.target.id;

			    switch (menuname){
					case "menu01":		
					    parent.frames["bottom"].location.href = "/admin/ezPersonal/personalMain.do";
						break;
					case "menu02":						
					    parent.frames["bottom"].location.href = "/admin/ezOrgan/organMain.do";				
						break;				
			        case "menu03":		
			            parent.frames["bottom"].location.href = "/admin/ezApproval/apprMain.do";
						break;
					case "menu04":		
					    parent.frames["bottom"].location.href = "/admin/ezApprovalG/apprGMain.do";
						break;
					case "menu06":	//게시판관리
					    parent.frames["bottom"].location.href = "/admin/ezBoard/boardMain.do";
						break;
					case "menu07":		
					    parent.frames["bottom"].location.href = "/admin/ezCommunity/communityMain.do";
						break;
					case "menu08":		
					    parent.frames["bottom"].location.href = "/admin/ezSchedule/scheduleMain.do";
						break;
					case "menu09":						
					    parent.frames["bottom"].location.href = "/ezStatistics/statisticsMain.do";				
						break;
					case "menu10":		
// 					    parent.frames["bottom"].location.href = "/admin/ezPortal/portalMain.do";
 					    parent.frames["bottom"].location.href = "/admin/ezNewPortal/portalMain.do";
						break;								
					case "menu12":		
					    parent.frames["bottom"].location.href = "/admin/ezResource/resourceMain.do";
						break;				
				    case "menu13":		
				        parent.frames["bottom"].location.href = "/Myoffice/ezDocManagement/Admin/DocAdmin_index.html";
						break;				
					case "menu14":		
					    parent.frames["bottom"].location.href = "/myoffice/ezKMS/admin/index_admin.aspx";
						break;
                    //김왕용 : ezDMS 관리자페이지 추가
					case "menu15":		
					    parent.frames["bottom"].location.href = "/Myoffice/ezDMS/admin/index_admin.aspx";
						break;              
					case "menu16":
				    	parent.frames["bottom"].location.href = "index_approval_Proc.htm";
						break;
                	//20120725 모바일 기기 관리자 메뉴 추가	start						
					case "menu17":
					    parent.frames["bottom"].location.href = "index_mobileMgmt.htm";
						break;
	                case "menu18":
	                    parent.frames["bottom"].location.href = "/admin/ezSystem/systemMain.do";
	                    break;
// 	                   업무일지
	                case "menu19":
	                    parent.frames["bottom"].location.href = "/admin/ezJournal/journalMain.do";
	                    break;
				    case "menu20":
				        parent.frames["bottom"].location.href = "/myoffice/ezStatistics/ezLog/index_Log.aspx";
				        break;
					//20120725 모바일 기기 관리자 메뉴 추가	end
				    //근태관리 관리자 메뉴 추가
				    case "menu30":
				    	parent.frames["bottom"].location.href = "/admin/ezAttitude/attitudeMain.do";
				    	break;
				}
			}
			
			function GetObject() {
                i_icd2.SetDocumentDisp(window.document);
                i_icd2.xmlURL = "http://" + document.location.hostname + ":" + location.port + "/admin/ezApprovalG/componentListTransfer.do?admin=Y";
                i_icd2.CheckVersion();
                var nCount = i_icd2.nNeedDownload;

                if (nCount) {
                    if_Progress.StartOn();
                }
                else {
                    finish_download();
                }
            }
			
			function finish_download() {
                OfficeBugPatch();
            }

            function OfficeBugPatch() {
                try {
                    var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
                    ezUtil.OfficeRegistryPatch();
                    ezUtil = null;
                } catch (e) {
                }
            }
		</script>
	</head>
	<body class="admin_top" onload="javascript:window_onload()">
		<c:if test="${useHWP == 'YES' && approvalFlag == 'G'}">
			<script type="text/javascript">
				ezIcd_ActiveX("i_icd2");
			</script>
        </c:if>
		<form method="post">
			<h1 title="logo"><spring:message code="ezBoard.t84" /></h1>
			<div id="adminmenu">
		    	<ul>		    		
                    <c:if test="${firstScreen_Mail == 'YES'}">
                    	<li><span id="menu10" onClick="menu_change(70, event)"><spring:message code="main.t22" /></span></li>
                    	<li><span id="menu02" onClick="menu_change(170, event)"><spring:message code="main.t23" /></span></li> 
                    	<li><span id="menu09" onClick="menu_change(690, event)"><spring:message code="main.t27" /></span></li>
                    </c:if>
                    
                    <c:if test="${firstScreen_Mail != 'YES'}">
		      			<c:if test="${use_portal == 'YES' && packageType == 'standard'}">
		      				<li><span id="menu10" onClick="menu_change(0, event)"><spring:message code="main.t22" /></span></li>
		      			</c:if>
		      					      
                    	<c:if test="${packageType == 'standard'}">
		      				<li><span id="menu01" onClick="menu_change(70, event)"><spring:message code="main.t7" /></span></li>
                    	</c:if>
                    	
		      			<li><span id="menu02" onClick="menu_change(170, event)"><spring:message code="main.t23" /></span></li>
		      			
		      			<c:if test="${packageType != 'mail'}">      
			      			<li><span id="menu08" onClick="menu_change(275, event)"><spring:message code="ezSchedule.t1010" /></span></li>
			      			<li><span id="menu06" onClick="menu_change(365, event)"><spring:message code="main.t12" /></span></li>
		      			</c:if>
		      			
		      			<%-- 전자결재 --%>
		      			<%-- <li><span id="menu03" onClick="menu_change(450, event)"><spring:message code="main.t25" /></span></li> --%>
                    	<c:if test="${use_approvalG == 'YES' && packageType == 'standard'}">
		      				<%-- 전자결재 공공 --%>
		      				<li><span id="menu04" onClick="menu_change(545, event)"><spring:message code="main.t25" /></span></li>
		      			</c:if>
		      				
                    	<c:if test="${packageType == 'standard'}">
							<%-- 커뮤니티 --%>
							<c:if test="${use_community == 'YES'}">
		      				<li><span id="menu07" onClick="menu_change(630, event)"><spring:message code="main.t1006" /></span></li>
		      				</c:if>
							<%-- 자원관리 --%>
		      				<li><span id="menu12" onClick="menu_change(690, event)"><spring:message code="main.t28" /></span></li>
							<%-- 업무일지 --%>
							<c:if test="${use_journal == 'YES'}">
								<li><span id="menu19" onClick="menu_change(690, event)"><spring:message code="ezJournal.t1" /></span></li>
							</c:if>
		      				<%-- 근태관리 --%>
		      				<c:if test="${use_attitude == 'YES'}">
		      					<li><span id="menu30" onClick="menu_change(690, event)"><spring:message code="ezAttitude.t1" /></span></li>
		      				</c:if>
		      			</c:if>
                    	
		      			<%-- 시스템 --%>          
		      			<li><span id="menu18" onClick="menu_change(690, event)"><spring:message code="main.t10011" /></span></li>
		      			<%-- 통계 --%>
		      			<li><span id="menu09" onClick="menu_change(690, event)"><spring:message code="main.t27" /></span></li>
		      			<c:if test="${use_ezKMS == 'YES'}">
		      				<li><span id="menu14" onClick="menu_change(920, event);"><spring:message code="main.t19" /></span></li>
		      			</c:if>
		      			<c:if test="${use_ezDMS == 'YES'}">
		      				<li><span id="menu15" onClick="menu_change(920, event);"><spring:message code="main.t52" /></span></li>
		      			</c:if>
                    </c:if>
                    <li class='btn_logout' style='float:right;'><span style='cursor:pointer' onclick='top.location.href = "/user/login/actionLogout.do"'><spring:message code='ezPortal.t990043' /></span></li>
		    	</ul>
		  	</div>		  	
		</form>		
		<script type="text/javascript">
			selToggleList(document.getElementById("adminmenu"), "ul", "li", "0");
		</script>
		<c:if test="${useHWP == 'YES' && approvalFlag == 'G'}">
			<iframe id=if_Progress style="display:none" src="/admin/ezApprovalG/progressAdmin.do?"></iframe>
		</c:if>
	</body>
</html>

