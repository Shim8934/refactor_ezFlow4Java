<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='main.e15'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };
		    
		    function goPage(idx) {
				var url = "";
				
				switch(idx)	{
					case 1:
						url = "/myoffice/ezApprovalG/manage/FormMaker/Form_Admin.aspx" ;
						break;					
					case 2:
					    url = "/myoffice/ezApprovalG/manage/FormMaker/Form_Admin.aspx?type=HWP";
						break;						
				    case 3:
	                    url = "/admin/ezApprovalG/apprGMCont.do";
	                    break;						
				    case 4:
				        url = "/myoffice/ezApprovalG/Manage/admin_receivegroup_cross.aspx";
						break;					
				    case 5:
				        url = "/myoffice/ezApprovalG/ezCabinet/Manage/TaskCodeManage_cross.aspx";
						break;					
					case 6:
					    url = "/myoffice/ezApprovalG/ezCabinet/Manage/TaskAdmin_Dept_Cross.aspx";
						break;						
					case 7:
					    url = "/myoffice/ezApprovalG/ezSealInfo/ManageSeal_Cross.aspx";
						break;						
					case 8:
					    url = "/myoffice/ezApprovalG/ezSealInfo/ManageDeptSeal_Cross.aspx";
						break;					
					case 9:
						url = "/myoffice/ezApprovalG/Manage/ManageSendInfo.aspx";
						break;						
					case 10:
					    url = "/myoffice/ezApprovalG/ezStatistics/ezStatistics_Cross.aspx";
						break;						
					case 11:
					    url = "/myoffice/ezApprovalG/ezStatistics/ezStatisticsforAprdoc_Cross.aspx";
						break;						
					case 12:
					    url = "/myoffice/ezApprovalG/ezStatistics/ezStatisticsfordoc_Cross.aspx";
						break;								
				}
				
				window.open(url,"right");
			}
		</script>
	</head>
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<div id="left" style="overflow-x:hidden">
			<div class="left_admin" title="<spring:message code='main.t26'/>"><spring:message code='main.t26'/></div>
			<%-- TODO : 2016-05-04 장진혁과장 -- 폼프로세스 에디터(activeX) 이슈로 인한 일시적인 주석 처리 
	        	<h2><span id="1" style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code='main.t33'/></span><ul></ul></h2>	
				<h2><span id="2" style="display:inline-block;width:100%;" onClick="goPage(2)"><spring:message code='main.t34'/></span><ul></ul></h2>
 			--%>
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(3)"><spring:message code='main.t36'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code='main.t39'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(5)"><spring:message code='main.t46'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='main.t47'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(7)"><spring:message code='main.t41'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(8)"><spring:message code='main.t48'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(9)"><spring:message code='main.t49'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(10)"><spring:message code='main.t42'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(11)"><spring:message code='main.t50'/></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(12)"><spring:message code='main.t51'/></span><ul></ul></h2>	
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>
