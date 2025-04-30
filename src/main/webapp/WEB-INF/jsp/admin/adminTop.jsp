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
				document.getElementById("adminTopTitle").addEventListener("click", function() {
					process();
					//parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezNewPortal/portalMain.do";
				});
			}
			
			function process() {
				var admin = "${admin}"; // 전체관리자, 회사관리자
				if (admin == "admin"){
				    <c:if test="${packageType != 'standard' || firstScreen_Mail == 'YES'}">
				    	window.open("/admin/ezOrgan/organMain.do", "bottom");
				    </c:if>
				    <c:if test="${packageType == 'standard' && firstScreen_Mail == 'NO'}">
					//일단 게시판으로 이동하게 만듬 2016-02-16 장진혁
					//메인화면 포탈로 설정 2016-10-04 지정석
//						window.open("/admin/ezPortal/portalMain.do", "bottom");
	 					window.open("/admin/ezNewPortal/portalMain.do", "bottom");
					</c:if>
					/* <c:if test="${use_portal != 'YES'}">
						window.open("/admin/ezPersonal/personalMain.do", "bottom");
					</c:if> */
					
					<c:if test="${useActiveX == 'YES'}">
						var userAgent = window.navigator.userAgent;
						
						if ((/msie/i.test(userAgent)) || (/rv:11.0/i.test(userAgent))) {
							GetObject();
						}
			    	</c:if>
				} else {
					if ("${isWFAdmin}" == "YES") {
						window.open("/admin/ezWebFolder/webFolderMain.do", "bottom");
					}				
				}
			}
			
			function menu_change(width, e){
		        var menuname = e.target.id;

			    switch (menuname){
					case "menu01":		
					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezPersonal/personalMain.do";
						break;
					case "menu02":						
					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezOrgan/organMain.do";				
						break;				
			        case "menu03":		
			            parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezApproval/apprMain.do";
						break;
					case "menu04":		
					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezApprovalG/apprGMain.do";
						break;
					case "menu06":	//게시판관리
					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezBoard/boardMain.do";
						break;
					case "menu07":		
					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezCommunity/communityMain.do";
						break;
					case "menu08":		
					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezSchedule/scheduleMain.do";
						break;
					case "menu09":						
					    parent.document.querySelector("iframe[name=bottom]").src = "/ezStatistics/statisticsMain.do";				
						break;
					case "menu10":		
// 					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezPortal/portalMain.do";
 					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezNewPortal/portalMain.do";
						break;								
					case "menu12":		
					    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezResource/resourceMain.do";
						break;				
				    case "menu13":		
				        parent.document.querySelector("iframe[name=bottom]").src = "/Myoffice/ezDocManagement/Admin/DocAdmin_index.html";
						break;				
					case "menu14":		
					    parent.document.querySelector("iframe[name=bottom]").src = "/myoffice/ezKMS/admin/index_admin.aspx";
						break;
                    //김왕용 : ezDMS 관리자페이지 추가
					case "menu15":		
					    parent.document.querySelector("iframe[name=bottom]").src = "/Myoffice/ezDMS/admin/index_admin.aspx";
						break;              
					case "menu16":
				    	parent.document.querySelector("iframe[name=bottom]").src = "index_approval_Proc.htm";
						break;
                	//20120725 모바일 기기 관리자 메뉴 추가	start						
					case "menu17":
					    parent.document.querySelector("iframe[name=bottom]").src = "index_mobileMgmt.htm";
						break;
	                case "menu18":
	                    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezSystem/systemMain.do";
	                    break;
// 	                   업무일지
	                case "menu19":
	                    parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezJournal/journalMain.do";
	                    break;
				    case "menu20":
				        parent.document.querySelector("iframe[name=bottom]").src = "/myoffice/ezStatistics/ezLog/index_Log.aspx";
				        break;
					//20120725 모바일 기기 관리자 메뉴 추가	end	
					
					// ezPMS 관리자페이지 추가
				    case "menu21":
				    	parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezPMS/pmsMain.do";
						break;
				    //근태관리 관리자 메뉴 추가
				    case "menu30":
				    	parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezAttitude/attitudeMain.do";
				    	break;
				    // 캐비넷 관리자 메뉴 추가
				    case "menu40":
				    	parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezCabinet/cabinetAdminMain.do";
				    	break;
					// 메일관리
					case "menu31":
						parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezEmail/adminMailMain.do";
						break;
						
					case "menu32":
						parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezWebFolder/webFolderMain.do";
						break;
						
					case "menu33":
						parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezCar/carMain.do";
						break;
					case "menu34":
						parent.document.querySelector("iframe[name=bottom]").src = "/admin/ezNotification/notificationMain.do";
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
		<c:if test="${useActiveX == 'YES'}">
			<script type="text/javascript">
				ezIcd_ActiveX("i_icd2");
			</script>
        </c:if>
		<form method="post">
			<%-- <h1 title="logo"><spring:message code="ezBoard.t84" /></h1> --%>
			<div id="adminmenu">
				<div class="adminTopTitle" id="adminTopTitle"><spring:message code="ezBoard.t84" /></div>
		    	<ul style="padding-left:150px;">
                    <c:if test="${admin == 'admin'}">
	                    <c:if test="${firstScreen_Mail == 'YES'}">
	                    	<li><span id="menu10" onClick="menu_change(70, event)"><spring:message code="main.t22" /></span></li>
	                    	<li><span id="menu02" onClick="menu_change(170, event)"><spring:message code="main.t23" /></span></li> 
	                    	<li><span id="menu09" onClick="menu_change(690, event)"><spring:message code="main.t27" /></span></li>
	                    </c:if>
	                    <c:if test="${firstScreen_Mail != 'YES'}">
			      			<%-- <c:if test="${use_portal == 'YES' && packageType == 'standard'}">
			      				<li><span id="menu10" onClick="menu_change(0, event)"><spring:message code="main.t22" /></span></li>
			      			</c:if> --%>
			      			<%-- 패키지 타입이 mail일때에도 포탈 메뉴가 선별적으로 필요해서 처리 --%>
	                    	<li><span id="menu10" onClick="menu_change(0, event)"><spring:message code="main.t22" /></span></li>
			      			<li><span id="menu02" onClick="menu_change(170, event)"><spring:message code="main.t8" /></span></li>
			      			<c:if test="${use_mail == 'YES' }">
			      			<li><span id="menu31" onClick="menu_change(170, event)"><spring:message code="main.t78" /></span></li>
			      			</c:if>
			      			<c:if test="${packageType != 'mail'}">      
			      				<c:if test="${useSchedule == 'YES' }">
				      			<li><span id="menu08" onClick="menu_change(275, event)"><spring:message code="ezSchedule.t1010" /></span></li>
				      			</c:if>
				      			<c:if test="${useBoard == 'YES' }">
				      			<li><span id="menu06" onClick="menu_change(365, event)"><spring:message code="ezBoard.t116" /></span></li>
			      				</c:if>
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
								<c:if test="${useResource == 'YES'}">
			      				<li><span id="menu12" onClick="menu_change(690, event)"><spring:message code="main.t28" /></span></li>
								</c:if>
								<%-- 업무일지 --%>
								<c:if test="${use_journal == 'YES'}">
									<li><span id="menu19" onClick="menu_change(690, event)"><spring:message code="ezJournal.t1" /></span></li>
								</c:if>
			      				<%-- 근태관리 --%>
			      				<c:if test="${use_attitude == 'YES'}">
			      					<li><span id="menu30" onClick="menu_change(690, event)"><spring:message code="ezAttitude.t1" /></span></li>
			      				</c:if>
			      				<%-- ezPMS --%>
			      				<c:if test="${use_ezPMS == 'YES'}">
			      				<li><span id="menu21" onClick="menu_change(690, event)"><spring:message code="ezPMS.t8" /></span></li>
			      				</c:if>
								<%-- 캐비넷 --%>
								<c:if test="${useCabinet == 'YES'}">
									<li><span id="menu40" onClick="menu_change(690, event)"><spring:message code="ezCabinet.t154" /></span></li>
								</c:if>
								<%-- 웹폴더 --%>
				      			<c:if test="${use_webfolder == 'YES'}">
				      				<li><span id="menu32" onClick="menu_change(690, event)"><spring:message code="ezWebFolder.t10" /></span></li>
				      			</c:if>
			      			</c:if>
			      			<%-- 시스템 --%>          
			      			<li><span id="menu18" onClick="menu_change(690, event)"><spring:message code="main.t10011" /></span></li>
			      			<%-- 통계 --%>
			      			<li><span id="menu09" onClick="menu_change(690, event)"><spring:message code="main.t27" /></span></li>
			      			<%-- 차량관리 --%>
			      			<c:if test="${useCar == 'YES'}">
			      			<li><span id="menu33" onClick="menu_change(690, event)"><spring:message code="main.shb01" /></span></li>
			      			</c:if>
			      			<c:if test="${use_ezKMS == 'YES'}">
			      				<li><span id="menu14" onClick="menu_change(920, event);"><spring:message code="main.t19" /></span></li>
			      			</c:if>
			      			<c:if test="${use_ezDMS == 'YES'}">
			      				<li><span id="menu15" onClick="menu_change(920, event);"><spring:message code="main.t52" /></span></li>
			      			</c:if>
			      				<li><span id="menu34" onClick="menu_change(920, event);"><spring:message code='ezNotification.hth01'/></span></li>
                 	   </c:if>
               	    </c:if>
                    <c:if test="${admin != 'admin'}">
	                    <c:if test="${isWFAdmin == 'YES'}">
		                    <c:if test="${packageType == 'standard'}">
				      			<c:if test="${use_webfolder == 'YES'}">
				      				<li><span id="menu32" onClick="menu_change(690, event)"><spring:message code="ezWebFolder.t10" /></span></li>
				      			</c:if>
			                </c:if>
		                </c:if>
                    </c:if>
                    <li class='btn_logout' style='float:right;'><span style='cursor:pointer' onclick='top.location.href = "/user/login/actionLogout.do"'><spring:message code='ezPortal.t990043' /></span></li>
		    	</ul>
		  	</div>		  	
		</form>		
		<script type="text/javascript">
			selToggleList(document.getElementById("adminmenu"), "ul", "li", "0");
		</script>
		<c:if test="${useActiveX == 'YES'}">
			<iframe id=if_Progress style="display:none" src="/admin/ezApprovalG/progressAdmin.do?"></iframe>
		</c:if>
	</body>
</html>

