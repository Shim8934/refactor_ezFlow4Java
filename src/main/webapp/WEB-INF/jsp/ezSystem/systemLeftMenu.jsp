<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t2' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="${util.addVer('ezStatistics.e2', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	<style>
		#mCSB_1_container {
			margin-right: 0px;
		} 
	</style>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
    <script type="text/javascript">
	var cChk = ${cChk};
	var fileExtensionViewType = 0;
	
	document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
    };
	
    window.onload = function()
    {	
    	if (cChk == "1") {
        	parent.frames[1].location.href = "/admin/ezSystem/systemMainMenu.do";        
    	} else {
			parent.frames[1].location.href = "/admin/ezSystem/systemConnectorHist.do";
    	}
    };
	
    function menu_change(Item) 
    {
	    var this_menu ;
	    var this_sub_menu ;
	    if(Item == '')
		    this_menu = event.srcElement.id;
	    else
	        this_menu = Item;

	    switch(this_menu)
	    {	
	    	case "PARAMETER":
				parent.frames[1].location.href = "/admin/ezSystem/systemMainMenu.do";
				break;
			case "CONNECTORLIST":
				parent.frames[1].location.href = "/admin/ezSystem/systemConnectorHist.do";
				break;
	    	case "LOGINHIST":
	    		parent.frames[1].location.href = "/admin/ezSystem/systemLoginHist.do";
	    		break;
	    	case "ADMINACCESSHIST":
	    		parent.frames[1].location.href = "/admin/ezSystem/systemAdminAccessHist.do";
	    		break;
	    	case "USERCHANGEHIST":
	    		parent.frames[1].location.href = "/admin/ezSystem/systemUserChangeHist.do";
				break;
			case "DEPTCHANGEHIST":
				parent.frames[1].location.href = "/admin/ezSystem/systemDeptChangeHist.do";
				break;
			case "PERMISSIONCHHIST":
				parent.frames[1].location.href = "/admin/ezSystem/permissionChangeHist.do";
				break;
	    	case "IPMANAGER":
	    		parent.frames[1].location.href = "/admin/ezSystem/systemIPManager.do";
	    		break;
	    	case "SYSMONITOR":
	    		//parent.frames[1].location.href = "/admin/ezSystem/sysMonitor.do";
	    		parent.frames[1].location.href = "/admin/ezSystem/sysREST.do";
	    		break;	    		
	    	case "MODMONITOR":
	    		parent.frames[1].location.href = "/admin/ezSystem/systemModuleMonitor.do";
	    		break;
	    	case "MULTILOGIN":
	    		parent.frames[1].location.href = "/admin/ezSystem/multiLoginManager.do";
	    		break;
	    	case "ADMINIPMANAGER":
	    		parent.frames[1].location.href = "/admin/ezSystem/systemAdminIPManager.do";
	    		break;
	    	case "PASSWORDPOLICY":
	    		parent.frames[1].location.href = "/admin/ezSystem/passwordPolicyMain.do";
	    		break;
    		// 2022-12-23 김대현  파일 업로드 허용 확장자명 분기처리
			case "FILEEXTENSION":
				fileExtensionViewType = 0;
				parent.frames[1].location.href = "/admin/ezSystem/systemFileExtension.do";
				break;
	    }
	    
	    $("#left .adminListBox h2 span").click(function(){
			$("#left .adminListBox h2").removeClass("on");
			$(this).parent().addClass("on");
		})
				
    }

//     function goPage(idx)
//     {
// 	    var url = "";
// 	    switch(idx)
// 	    {
// 		    case 1:
// 		        url = "/ezStatistics/statisticsMailDept.do";
// 			    break;
// 	    }

// 	    window.open(url,"stat_main");
//     }

		$(document).ready(function() {
			leftResize();
	        $(".adminListBox").mCustomScrollbar({
	    		theme : "dark"
	    	});
		});
        
        function leftResize(){
        	$(".adminListBox").height(window.innerHeight-58);
        }
        
        $( window ).resize(function() {
        	leftResize();
    	});

    </script>
    </head>
    <body class="newLeft"> 
	    <div id="left" class="lnb" style="overflow: auto">
		    <div class="admin_left_title" title="<spring:message code='main.t10011' />"><spring:message code='main.t10011' /></div>
		    <div class="adminListBox" style="overflow:hidden; padding-right: 0;">
		    	<c:choose>
		            <c:when test="${cChk == '1' }">
		            	<h2 class="on"><span id="PARAMETER" style="display:inline-block;width:100%;" onClick="menu_change('PARAMETER')" ><spring:message code='main.kms1' /></span></h2>
			            <h2>
		            </c:when>
		            <c:otherwise>
		            	<h2 class="on">
		            </c:otherwise>
	            </c:choose>
	            <span id="CONNECTORLIST" style="display:inline-block;width:100%;" onClick="menu_change('CONNECTORLIST')" ><spring:message code='ezSystem.jhy17' /></span></h2>
	            <h2><span id="LOGINHIST" style="display:inline-block;width:100%;" onClick="menu_change('LOGINHIST')" ><spring:message code='ezSystem.x0021' /></span></h2>
	            <h2><span id="ADMINACCESSHIST" style="display:inline-block;width:100%;" onClick="menu_change('ADMINACCESSHIST')" ><spring:message code='ezSystem.ls07' /></span></h2>
				<h2><span id="USERCHANGEHIST" style="display:inline-block;width:100%;" onClick="menu_change('USERCHANGEHIST')" ><spring:message code='ezSystem.jhy01' /></span></h2>
				<h2><span id="DEPTCHANGEHIST" style="display:inline-block;width:100%;" onClick="menu_change('DEPTCHANGEHIST')" ><spring:message code='ezSystem.jhy10' /></span></h2>
				<h2><span id="PERMISSIONCHHIST" style="display:inline-block;width:100%;" onClick="menu_change('PERMISSIONCHHIST')" ><spring:message code='ezOrgan.ls06' /></span></h2>
	            <c:if test="${cChk == '1' }">
	            <h2><span id="ADMINIPMANAGER" style="display:inline-block;width:100%;" onClick="menu_change('ADMINIPMANAGER')" ><spring:message code='ezSystem.ksa08'/></span></h2>
	            </c:if>
	            <c:if test="${useIPAccessMenu == 'YES'}">
	            	<h2><span id="IPMANAGER" style="display:inline-block;width:100%;" onClick="menu_change('IPMANAGER')" ><spring:message code='ezSystem.ksa02'/></span></h2>
	            </c:if>
	            <h2><span id="MULTILOGIN" style="display:inline-block;width:100%;" onClick="menu_change('MULTILOGIN')" ><spring:message code="ezSystem.kbh08" /></span></h2>
	            <h2><span id="PASSWORDPOLICY" style="display:inline-block;width:100%;" onClick="menu_change('PASSWORDPOLICY')" ><spring:message code='ezSystem.ksaPwPolicy01' /></span></h2>
	            <c:if test="${cChk == '1' && useSystemMonitor != 'NO'}">
	            	<h2><span id="SYSMONITOR" style="display:inline-block;width:100%;" onClick="menu_change('SYSMONITOR')" ><spring:message code='ezSystem.pjg08' /></span></h2>
	            </c:if>
	            <c:if test="${useModuleUsage == 'YES'}">
	            	<h2><span id="MODMONITOR" style="display:inline-block;width:100%;" onClick="menu_change('MODMONITOR')" ><spring:message code='ezSystem.kbh21' /></span></h2>
	            </c:if>
				<h2><span id="FILEEXTENSION" style="display:inline-block;width:100%;" onClick="menu_change('FILEEXTENSION')" ><spring:message code='ezSystem.x0009' /></span></h2>
			</div>
      	</div>
    </body>
