<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">			    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        document.getElementById("1tab1").onclick();
		        //ChangeTab(document.getElementById("1tab1"));
		        window_resize();	
		    }
	
		    window.onresize = window_resize;
		    function window_resize() {
		        document.getElementById("mainframe").style.height = (document.documentElement.clientHeight - 120) + "PX";
		    }
	
		    var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
	
		    function Tab1_MouserOut(obj) {
		        if(Tab1_SelectID != obj.id)
		            obj.className = "";
		    }
	
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
	
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
	
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;
	
		                    if (i == 0) {
		                        document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
		                    }	
		                }
		            }
		        }
		    }
	
		    function ChangeTab(obj) {
		        var pSelectTab = GetAttribute(obj, "divname");
	
		        switch (pSelectTab) {
		            case "scheduleTab": schedule_ini(); break;
		            case "taskTab": task_ini(); break;
		            case "addressTab": address_ini(); break;
		            case "googleTab": Google_ini(); break;
		        }
		    }
	
		    function schedule_ini() {
				document.getElementById("mainframe").src = "/ezSchedule/scheduleConfig.do";		        
		    }
		    
		    function task_ini() {
	            document.getElementById("mainframe").src = "/myoffice/ezTask/task_config_cross.aspx";
		    }
		    
		    function address_ini() {
	            document.getElementById("mainframe").src = "/myoffice/ezAddress/address_config_cross.aspx";
		    }
		    
		    function Google_ini() {
	            document.getElementById("mainframe").src = "schedule_google.aspx";
		    }
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezSchedule.t1012' /></h1>
   		<div class="portlet_tabpart01" style="margin-top:3px;text-align:right">
       		<div class="portlet_tabpart01_top" id="tab1">
           		<p><span id="1tab1" divname="scheduleTab"><spring:message code='ezSchedule.t133' /></span></p>
           		<%-- 구글캘린더 --%>
           		<%-- <%if(pUseGoogleCalrendar == "YES"){ %>
           				<p><span id="1tab2" divname="googleTab"><%=RM.GetString("t401")%></span></p><%
           		} %> --%>
           		
           		<%-- 업무관리 --%>           		
           		<%-- <p><span id="1tab3" divname="taskTab"><spring:message code='ezSchedule.t1005' /></span></p> --%>            
       		</div>
   		</div>    
       	<iframe id="mainframe" style="width:100%;height:100%;border:0px"></iframe>    
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>	
</html>