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
	
	document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
    };
	
    window.onload = function()
    {
        parent.frames[1].location.href = "/ezStatistics/statisticsPerSonalMain.do";        
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
	    	case "PERSONAL":
           		parent.frames[1].location.href = "/ezStatistics/statisticsPerSonalMain.do";
           	 	break;
	        case "MAIL":
	            parent.frames[1].location.href = "/ezStatistics/statisticsMailMain.do";
	            break;
	        case "APPROVAL":
	            parent.frames[1].location.href = "/ezStatistics/statisticsApprMain.do";
	            break;
	        case "PAGELOG":
	            parent.frames[1].location.href = "PageLog/PageLog_Main.aspx";
	            break;
	        case "WEBLOG":
	            parent.frames[1].location.href = "WebLog_Statistics/WebLog_Main.aspx";
	            break;
	        case "ATTITUDE": //개인별 근태통계
	            parent.frames[1].location.href = "/ezStatistics/statisticsAttitudeMain.do";
	            break;
	    }
    }

    function goPage(idx)
    {
	    var url = "";
	    switch(idx)
	    {
		    case 1:
		        url = "/ezStatistics/statisticsMailDept.do";
			    break;
	        case 2:
	            url = "/ezStatistics/statisticsMailUser.do";
	            break;
	        case 4:
	            url = "/ezStatistics/statisticsQuantityDept.do";
	            break;
	        case 5:
	            url = "/ezStatistics/statisticsQuantityUser.do";
	            break;
	        case 6:
	            url = "/ezStatistics/statisticsMonForm.do";
	            break;
	        case 7:
	            url = "/ezStatistics/statisticsMonDept.do";
	            break;
	        case 8:
	            url = "/ezStatistics/statisticsMonUser.do";
	            break;
	        case 9:
	            url = "/ezStatistics/statisticsTimeForm.do";
	            break;
	        case 10:
	            url = "/ezStatistics/statisticsTimeDept.do";
	            break;
	        case 11:
	            url = "/ezStatistics/statisticsTimeUser.do";
	            break;
	        case 12:
	            url = "/ezStatistics/statisticsForm.do";
	            break;
	        case 13:
	            url = "/ezStatistics/statisticsDept.do";
	            break;
	        case 14:
	            url = "/ezStatistics/statisticsUser.do";
	            break;
	        case 15:
	            url = "/ezStatistics/statisticsApprMain.do";
	            break;
	        case 16:
	            url = "/ezStatistics/statisticsPerSonalMain.do";
	            break;
	        case 17:
	            url = "/ezStatistics/statisticsConnBrowser.do";
	            break;
	        case 18:
	            url = "/ezStatistics/statisticsConnOS.do";
	            break;
	        case 19:
	            url = "PageLog/PageLog_Dept.aspx";
	            break;
	        case 20:
	            url = "PageLog/PageLog_User.aspx";
	            break;
	        case 21:
	            url = "WebLog_Statistics/WebLog_Module.aspx";
	            break;
	        case 22:
	        	url = "/ezStatistics/statisticsMailRecieveLogList.do";
	        	break;
	        case 23:
	        	url = "/ezStatistics/statisticsMailSendLogList.do";
	        	break;
	        case 24: //부서별 근태통계
	        	url = "/ezStatistics/statisticsAttitudeDept.do";
	        	break;
	    }

	    window.open(url,"stat_main");
    }

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
		    <div class="admin_left_title" title="<spring:message code='ezStatistics.t124' />"><spring:message code='ezStatistics.t124' /></div>      
		    <div class="adminListBox" style="overflow:hidden; padding-right: 0;">
	            <h2 class="on">
	            	<span>
	            		<span class="sub_iconLNB tree_arrow_up"></span>
	            		<span class="h2Title" id="PERSONAL" onClick="menu_change('PERSONAL')" ><spring:message code='ezStatistics.t1049' /></span>
	            	</span>	
	            </h2>
	            <ul class="lnbUL">
	            	<div class="tree">
	            		<span>
	                		<span>
	                			<span>
	                        		<div class="node_div">
	                        			<span class="sub_iconLNB tree_blank"></span>
	                        			<span class="sub_iconLNB tree_env_myPortal"></span>
	                					<span class="h2_text" onclick="goPage(16)"><spring:message code='ezStatistics.t1047' /></span>
	                				</div>
	                			</span>
	                			<span>
	                        		<div class="node_div">
	                        			<span class="sub_iconLNB tree_blank"></span>
	                        			<span class="sub_iconLNB tree_env_myPortal"></span>
	                					<span class="h2_text" onclick="goPage(17)"><spring:message code='ezStatistics.t1045' /></span>
	                				</div>
	                			</span>
	                			<span>
	                        		<div class="node_div">
	                        			<span class="sub_iconLNB tree_blank"></span>
	                        			<span class="sub_iconLNB tree_env_myPortal"></span>
	                					<span class="h2_text" onclick="goPage(18)"><spring:message code='ezStatistics.t1048' /></span>
	                				</div>
	                			</span>
	                		</span>
	                	</span>
	                </div>
	            </ul>
	      	    <h2 class="off">
	      	    	<span id="MAIL" style="display:inline-block;width:100%;" onClick="menu_change('MAIL')"><spring:message code='ezStatistics.t2' /></span>
	      	    </h2>
			    <ul class="lnbUL off">
				    <li><span style="display:inline-block;width:100%;" onClick="menu_change('MAIL')"><spring:message code='ezStatistics.t1001' /></span></li>
				    <li><span style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code='ezStatistics.t1012' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(2)"><spring:message code='ezStatistics.t1018' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(4)"><spring:message code='ezStatistics.t1023' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(5)"><spring:message code='ezStatistics.t1025' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(22)"><spring:message code='ezStatistics.kyj1' /></span></li>
	                <li><span style="display:inline-block;width:100%;" onclick="goPage(23)"><spring:message code='ezStatistics.kyj2' /></span></li>
			    </ul>
	            <c:if test="${packageType == 'standard'}">
	            	<c:if test="${use_approvalG == 'YES'}">
	            		<h2 class="off"><span id="APPROVAL" style="display:inline-block;width:100%;" onClick="menu_change('APPROVAL')" ><spring:message code='ezStatistics.t1030' /></span></h2>
					    <ul class="lnbUL off">
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(15)"><spring:message code='ezStatistics.t1030' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(6)"><spring:message code='ezStatistics.t1031' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(7)"><spring:message code='ezStatistics.t1033' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(8)"><spring:message code='ezStatistics.t1034' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(9)"><spring:message code='ezStatistics.t1036' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(10)"><spring:message code='ezStatistics.t1037' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(11)"><spring:message code='ezStatistics.t1038' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(12)"><spring:message code='ezStatistics.t1039' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(13)"><spring:message code='ezStatistics.t1040' /></span></li>
			                <li><span style="display:inline-block;width:100%;" onclick="goPage(14)"><spring:message code='ezStatistics.t1041' /></span></li>
					    </ul>
	           	 	</c:if>
	      <!--
	            <h2><span id="Span2" style="display:inline-block;width:100%;" onClick="menu_change('WEBLOG')" ><spring:message code='ezStatistics.t2004' /></span></h2>
	            <ul>
	                <li><span style="display: inline-block; width: 100%;" onclick="menu_change('WEBLOG')"><spring:message code='ezStatistics.t2004' /></span></li>
	                <li><span style="display: inline-block; width: 100%;" onclick="goPage(21)"><spring:message code='ezStatistics.t2005' /></span></li>
	            </ul>
	            -->
	            </c:if>
	            <c:if test="${use_attitude == 'YES'}">
		            <h2 class="off"><span id="ATTITUDE" style="display:inline-block;width:100%;" onClick="menu_change('ATTITUDE')"><spring:message code='ezStatistics.kbm1' /></span></h2>
				    <ul class="lnbUL off">
					    <li><span style="display:inline-block;width:100%;" onClick="menu_change('ATTITUDE')"><spring:message code='ezStatistics.t1018' /></span></li>
					    <li><span style="display:inline-block;width:100%;" onClick="goPage(24)"><spring:message code='ezStatistics.t1012' /></span></li>
				    </ul>
			    </c:if>
		    </div>
	    </div>
    </body>
</html>