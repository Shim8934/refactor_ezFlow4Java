<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>		
		<title>Admin_Top</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/admin.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script>
			function window_onload(){				
				if("${use_portal}" != 'Y'){
					window.open("index_personal.aspx","bottom")
				}else{
					//일단 게시판으로 이동하게 만듬 2016-02-16 장진혁
					window.open("/admin/ezBoard/boardMain.do", "bottom");
				}
			}
			function menu_change(width, e){
		        var menuname = e.target.id;

			    switch (menuname){
					case "menu01":		
					    parent.frames["bottom"].location.href = "index_personal.aspx";
						break;
					case "menu02":						
					    parent.frames["bottom"].location.href = "index_organ.aspx";				
						break;				
			        case "menu03":		
			            parent.frames["bottom"].location.href = "index_approval.aspx";
						break;
					case "menu04":		
					    parent.frames["bottom"].location.href = "index_ApprovalG.aspx";
						break;
					case "menu06":	//게시판관리
					    parent.frames["bottom"].location.href = "/admin/ezBoard/boardMain.do";
						break;
					case "menu07":		
					    parent.frames["bottom"].location.href = "/Myoffice/ezCommunity/admin/default_1.aspx";
						break;
					case "menu08":		
					    parent.frames["bottom"].location.href = "index_schedule.aspx";
						break;
					case "menu09":						
					    parent.frames["bottom"].location.href = "/myoffice/ezStatistics/index_stat.aspx";				
						break;
					case "menu10":		
					    parent.frames["bottom"].location.href = "/myoffice/ezPortal/admin/index_top.aspx";
						break;								
					case "menu12":		
					    parent.frames["bottom"].location.href = "/myoffice/ezResource/Admin/index_board.aspx";
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
		</script>
	</head>
	<body class="admin_top" onload="javascript:window_onload()">		
		<form method="post">
			<h1 title="logo"></h1>
			<div id="adminmenu">
		    	<ul>		    		
		      		<c:if test="${use_portal == 'Y'}">
		      			<li><span id="menu10" onClick="menu_change(0, event)"><spring:message code="main.t22" /></span></li>
		      		</c:if>			      
		      		<li><span id="menu01" onClick="menu_change(70, event)"><spring:message code="main.t7" /></span></li>
		      		<li><span id="menu02" onClick="menu_change(170, event)"><spring:message code="main.t23" /></span></li>      
		      		<li><span id="menu08" onClick="menu_change(275, event)"><spring:message code="main.t14" /></span></li>
		      		<li><span id="menu06" onClick="menu_change(365, event)"><spring:message code="main.t12" /></span></li>
		      		<li><span id="menu03" onClick="menu_change(450, event)"><spring:message code="main.t25" /></span></li>
		      		<c:if test="${use_approvalG == 'Y'}"
		      			<li><span id="menu04" onClick="menu_change(545, event)"><spring:message code="main.t26" /></span></li>
		      		</c:if>	
		      		<li><span id="menu07" onClick="menu_change(630, event)"><spring:message code="main.t1006" /></span></li>          
		      		<li><span id="menu18" onClick="menu_change(690, event)"><spring:message code="main.t10011" /></span></li>
		      		<li><span id="menu09" onClick="menu_change(690, event)"><spring:message code="main.t27" /></span></li>
		      		<li><span id="menu12" onClick="menu_change(690, event)"><spring:message code="main.t28" /></span></li>		      		
		      		<c:if test="${use_ezKMS == 'Y'}"
		      			<li><span id="menu14" onClick="menu_change(920, event);"><spring:message code="main.t19" /></span></li>
		      		</c:if>
		      		<c:if test="${use_ezDMS == 'Y'}"
		      			<li><span id="menu15" onClick="menu_change(920, event);"><spring:message code="main.t52" /></span></li>
		      		</c:if>		      		
		      		<li><span id="menu20" onClick="menu_change(920, event);"><spring:message code="main.t10010" /></span></li>
		      		<c:if test="${use_mobileMgmt == 'Y'}"
		      			<li><span id="menu17" onClick="menu_change(920);"><spring:message code="main.t501" /></span></li>
		      		</c:if>		      		
		    	</ul>
		  	</div>		  	
		</form>		
		<script type="text/javascript">
			selToggleList(document.getElementById("adminmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

