<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t2' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="<spring:message code='ezStatistics.e2' />" type="text/css" />
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript">
	
	document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
    };
	
    window.onload = function()
    {
        parent.frames[1].location.href = "Personal/ezStatistics_Connect.aspx";
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
	            url = "Approval/ezStatistics_Time_Dept.aspx";
	            break;
	        case 11:
	            url = "Approval/ezStatistics_Time_User.aspx";
	            break;
	        case 12:
	            url = "Approval/ezStatistics_Form.aspx";
	            break;
	        case 13:
	            url = "Approval/ezStatistics_Dept.aspx";
	            break;
	        case 14:
	            url = "Approval/ezStatistics_User.aspx";
	            break;
	        case 15:
	            url = "/ezStatistics/statisticsApprMain.do";
	            break;
	        case 16:
	            url = "Personal/ezStatistics_Connect.aspx";
	            break;
	        case 17:
	            url = "Personal/ezStatistics_Browser.aspx";
	            break;
	        case 18:
	            url = "Personal/ezStatistics_OS.aspx";
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
	    }

	    window.open(url,"stat_main");
    }

    </script>
    </head>

    <body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
	    <div id="left">
		    <div class="left_admin" title="<spring:message code='ezStatistics.t124' />"><spring:message code='ezStatistics.t124' /></div>
            <h2><span id="PERSONAL" style="display:inline-block;width:100%;" onClick="goPage(16)" ><spring:message code='ezStatistics.t1049' /></span></h2>
            <ul>
                <li><span style="display: inline-block; width: 100%;" onclick="goPage(16)"><spring:message code='ezStatistics.t1047' /></span></li>
                <li><span style="display: inline-block; width: 100%;" onclick="goPage(17)"><spring:message code='ezStatistics.t1045' /></span></li>
                <li><span style="display: inline-block; width: 100%;" onclick="goPage(18)"><spring:message code='ezStatistics.t1048' /></span></li>
            </ul>
		    <h2><span id="MAIL" style="display:inline-block;width:100%;" onClick="menu_change('MAIL')"><spring:message code='ezStatistics.t2' /></span></h2>
		    <ul>
			    <li><span style="display:inline-block;width:100%;" onClick="menu_change('MAIL')"><spring:message code='ezStatistics.t1001' /></span></li>
			    <li><span style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code='ezStatistics.t1012' /></span></li>
                <li><span style="display:inline-block;width:100%;" onclick="goPage(2)"><spring:message code='ezStatistics.t1018' /></span></li>
                <li><span style="display:inline-block;width:100%;" onclick="goPage(4)"><spring:message code='ezStatistics.t1023' /></span></li>
                <li><span style="display:inline-block;width:100%;" onclick="goPage(5)"><spring:message code='ezStatistics.t1025' /></span></li>
		    </ul>
             <h2><span id="APPROVAL" style="display:inline-block;width:100%;" onClick="menu_change('APPROVAL')" ><spring:message code='ezStatistics.t1030' /></span></h2>
		    <ul>
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
            <h2><span id="Span2" style="display:inline-block;width:100%;" onClick="menu_change('WEBLOG')" ><spring:message code='ezStatistics.t2004' /></span></h2>
            <ul>
                <li><span style="display: inline-block; width: 100%;" onclick="menu_change('WEBLOG')"><spring:message code='ezStatistics.t2004' /></span></li>
                <li><span style="display: inline-block; width: 100%;" onclick="goPage(21)"><spring:message code='ezStatistics.t2005' /></span></li>
            </ul>
	    </div>
        <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
        </script>
    </body>
</html>