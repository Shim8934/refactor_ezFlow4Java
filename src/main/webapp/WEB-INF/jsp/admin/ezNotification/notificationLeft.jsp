<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t2' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
            return false;
        } else {
            return true;
        }
    };
	
    function menu_change(Item) {
	    var this_menu;
	    var this_sub_menu;
	    if(Item == '') {
		    this_menu = event.srcElement.id;
	    } else {
	        this_menu = Item;
	    }
	    
	    switch(this_menu) {	
		    case "NOTISETTING":
				parent.frames[1].location.href = "/admin/ezNotification/notiSetting.do";
				break;
			case "EMERGENCYNOTI":
				parent.frames[1].location.href = "/admin/ezNotification/emergencyNotiSetting.do";
				break;
	    }
	    
    }

	$(document).ready(function() {
		leftResize();
        $(".adminListBox").mCustomScrollbar({
    		theme : "dark"
    	});
        
        $("#left .adminListBox h2 span").click(function() {
			$("#left .adminListBox h2").removeClass("on");
			$(this).parent().addClass("on");
		})
	});
       
    function leftResize() {
    	$(".adminListBox").height(window.innerHeight - 58);
    }
    
    $(window).resize(function() {
    	leftResize();
   	});

    </script>
    </head>
    <body class="newLeft"> 
	    <div id="left" class="lnb" style="overflow: auto">
		    <div class="admin_left_title" title="<spring:message code='main.t10011' />"><spring:message code='ezNotification.hth01' /></div>
		    <div class="adminListBox" style="overflow:hidden; padding-right: 0;">
	            <h2 class="on"><span class="h2Title" id="NOTISETTING" style="display:inline-block;width:100%;" onClick="menu_change('NOTISETTING')" ><spring:message code='ezNotification.hth21' /></span></h2>
	            <h2><span class="h2Title" id="EMERGENCYNOTI" style="display:inline-block;width:100%;" onClick="menu_change('EMERGENCYNOTI')" ><spring:message code='ezNotification.hth57' /></span></h2>
			</div>
      	</div>
    </body>
