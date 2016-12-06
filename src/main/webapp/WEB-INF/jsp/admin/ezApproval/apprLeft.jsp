<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
		<title>ApprovalAdminLeft</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='main.e15'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		
			function goPage(idx)
				{
					var url = "";
					switch(idx)
					{
					case 1:
					    url = "/myoffice/ezApproval/manage/FormMaker/Form_Admin.aspx";
						break;
						
				    case 4:
			            url = "/admin/ezApproval/MCont.do";
						break;
						
				    case 5:
			            url = "/myoffice/ezApproval/Manage/MoveContainer2.aspx";
						break;
						
				    case 6:
			            url = "/myoffice/ezApproval/Manage/docdelete.aspx";
						break;
						
				    case 7:
			            url = "/myoffice/ezApproval/Manage/admin_receivegroup.aspx";
						break;
						
				    case 8:
			            url = "/myoffice/ezApproval/Manage/mdocnumui.aspx";
						break;
						
				    case 9:
			            url = "/myoffice/ezApproval/ezSealInfo/ManageSeal.aspx";
						break;
						
				    case 10:
			            url = "/myoffice/ezApproval/ezStatistics/ezStatistics.aspx";
						break;
						
				    case 11:
			            url = "/myoffice/ezApproval/ezStatistics/ezStatisticsforAprdoc.aspx";
						break;
						
				    case 12:
			            url = "/myoffice/ezApproval/ezStatistics/ezStatisticsfordoc.aspx";
				        break;
					}
					
					window.open(url,"right");
				}
		</script>
	</head>
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
			<div id="left">
				<div class="left_admin" title="<spring:message code='main.t25'/>"><spring:message code='main.t25'/></div>
				<c:if test="${isIEBrowser == true}">
		            <h2><span style="display: inline-block; width: 100%;" onclick="goPage(1)"><spring:message code='main.t10'/></span><ul></ul></h2>
				</c:if>
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code='main.t36'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(5)"><spring:message code='main.t37'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(6)"><spring:message code='main.t38'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(7)"><spring:message code='main.t39'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(8)"><spring:message code='main.t40'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(9)"><spring:message code='main.t41'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(10)"><spring:message code='main.t42'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(11)"><spring:message code='main.t43'/></span><ul></ul></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(12)"><spring:message code='main.t44'/></span><ul></ul></h2>	
			</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>