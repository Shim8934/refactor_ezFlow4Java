<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t2' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="${util.addVer('ezStatistics.e2', 'msg')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript">
	
	document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
    };
	
    window.onload = function()
    {
        parent.frames[1].location.href = "/admin/ezSystem/systemMainMenu.do";        
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
	    	case "LOGINHIST":
	    		parent.frames[1].location.href = "/admin/ezSystem/systemLoginHist.do";
	    		break;
	    	case "SYSMONITOR":
	    		//parent.frames[1].location.href = "/admin/ezSystem/sysMonitor.do";
	    		parent.frames[1].location.href = "/admin/ezSystem/sysREST.do";
	    		break;	    		
	    }
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

    </script>
    </head>

    <body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
	    <div id="left">
		    <div class="left_admin" title="<spring:message code='main.t10011' />"><img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;<spring:message code='main.t10011' /></div>
            <h2><span id="PARAMETER" style="display:inline-block;width:100%;" onClick="menu_change('PARAMETER')" ><spring:message code='main.kms1' /></span>
            <ul class="on"></ul>
            </h2>
            <h2><span id="LOGINHIST" style="display:inline-block;width:100%;" onClick="menu_change('LOGINHIST')" ><spring:message code='ezSystem.x0021' /></span>
            <ul class="on"></ul>
            </h2>
            <h2><span id="SYSMONITOR" style="display:inline-block;width:100%;" onClick="menu_change('SYSMONITOR')" ><spring:message code='ezSystem.pjg08' /></span>
            <ul class="on"></ul>
            </h2>            
      	</div>
        <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
        </script>
    </body>
