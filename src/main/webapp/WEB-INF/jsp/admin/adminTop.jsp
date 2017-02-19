<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/admin.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script>
			function window_onload(){
				if("<c:out value='${use_portal}'/>" != 'YES'){
					window.open("index_personal.aspx","bottom");
				}else{
				    <c:if test="${IsJMochaStandAlone == 'YES'}">
				    window.open("/admin/ezOrgan/organMain.do", "bottom");
				    </c:if>
				    <c:if test="${IsJMochaStandAlone != 'YES'}">
					//일단 게시판으로 이동하게 만듬 2016-02-16 장진혁
					//메인화면 포탈로 설정 2016-10-04 지정석
					window.open("/admin/ezPortal/portalMain.do", "bottom");
					</c:if>
				}
				
				<c:if test="${IsJMochaStandAlone != 'YES'}">
				var ua = navigator.userAgent;
		    	if ((/msie/i.test(ua)) || (/rv:11.0/i.test(ua))) {
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
					    parent.frames["bottom"].location.href = "/admin/ezPortal/portalMain.do";
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
	                    parent.frames["bottom"].location.href = "/myoffice/ezStatistics/index_System.aspx";
	                    break;
				    case "menu20":
				        parent.frames["bottom"].location.href = "/myoffice/ezStatistics/ezLog/index_Log.aspx";
				        break;
					//20120725 모바일 기기 관리자 메뉴 추가	end				
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
        <c:if test="${IsJMochaStandAlone != 'YES'}">
		<OBJECT id="i_icd2" style="DISPLAY: none" codeBase="/files/ezIcd2.cab#version=1,0,0,14" data="data:application/x-oleobject;base64,GvFdR8IrqUGKl+mJ4CPlFwADAADYEwAA2BMAAA=="classid="CLSID:9E1C0C21-48B8-455a-9005-48C8D78B7900" VIEWASTEXT></OBJECT>
        </c:if>
		<form method="post">
			<h1 title="logo"></h1>
			<div id="adminmenu">
		    	<ul>		    		
                    <c:if test="${IsJMochaStandAlone == 'YES'}">
                    <li><span id="menu02" onClick="menu_change(170, event)"><spring:message code="main.t23" /></span></li> 
                    <li><span id="menu09" onClick="menu_change(690, event)"><spring:message code="main.t27" /></span></li>
                    </c:if>
                    <c:if test="${IsJMochaStandAlone != 'YES'}">
		      		<c:if test="${use_portal == 'YES'}">
		      			<li><span id="menu10" onClick="menu_change(0, event)"><spring:message code="main.t22" /></span></li>
		      		</c:if>			      
		      		<li><span id="menu01" onClick="menu_change(70, event)"><spring:message code="main.t7" /></span></li>
		      		<li><span id="menu02" onClick="menu_change(170, event)"><spring:message code="main.t23" /></span></li>      
		      		<li><span id="menu08" onClick="menu_change(275, event)"><spring:message code="main.t14" /></span></li>
		      		<li><span id="menu06" onClick="menu_change(365, event)"><spring:message code="main.t12" /></span></li>
		      		<%-- 전자결재 --%>
		      		<%-- <li><span id="menu03" onClick="menu_change(450, event)"><spring:message code="main.t25" /></span></li> --%>
		      		<c:if test="${use_approvalG == 'YES'}">
		      		<%-- 전자결재 공공 --%>
		      			<li><span id="menu04" onClick="menu_change(545, event)"><spring:message code="main.t26" /></span></li>
		      		</c:if>	
		      		<li><span id="menu07" onClick="menu_change(630, event)"><spring:message code="main.t1006" /></span></li>
		      		<%-- 시스템 --%>          
		      		<%-- <li><span id="menu18" onClick="menu_change(690, event)"><spring:message code="main.t10011" /></span></li> --%>
		      		<%-- 통계 --%>
		      		<li><span id="menu09" onClick="menu_change(690, event)"><spring:message code="main.t27" /></span></li>
		      		<li><span id="menu12" onClick="menu_change(690, event)"><spring:message code="main.t28" /></span></li>		      		
		      		<c:if test="${use_ezKMS == 'YES'}">
		      			<li><span id="menu14" onClick="menu_change(920, event);"><spring:message code="main.t19" /></span></li>
		      		</c:if>
		      		<c:if test="${use_ezDMS == 'YES'}">
		      			<li><span id="menu15" onClick="menu_change(920, event);"><spring:message code="main.t52" /></span></li>
		      		</c:if>
		      		<%-- 로깅 --%>		      		
		      		<%-- <li><span id="menu20" onClick="menu_change(920, event);"><spring:message code="main.t10010" /></span></li> --%>
<%-- 		      		<c:if test="${use_mobileMgmt == 'YES'}"> --%>
<%-- 		      			<li><span id="menu17" onClick="menu_change(920);"><spring:message code="main.t501" /></span></li> --%>
<%-- 		      		</c:if>		      		 --%>
                    </c:if>
                    <li class='btn_logout' style='float:right;'><span style='cursor:pointer' onclick='top.location.href = "/user/login/actionLogout.do"'><spring:message code='ezPortal.t990043' /></span></li>
		    	</ul>
		  	</div>		  	
		</form>		
		<script type="text/javascript">
			selToggleList(document.getElementById("adminmenu"), "ul", "li", "0");
		</script>
		<iframe id=if_Progress style="display:none" src="/admin/ezApprovalG/progressAdmin.do?"></iframe>
	</body>
</html>

