<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">			    
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
	    <script type="text/javascript">
	    	var flag = "<c:out value='${flag}' />";
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if(flag === "schedule") {
		        	document.getElementById("1tab1").onclick();	
		        } else {
		        	document.getElementById("1tab3").onclick();
		        }
		        
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
		            case "scheduleMailNotiTab": schedule_noti(); break;
		            case "taskTab": task_ini(); break;
		            case "taskGeneral": task_general(); break;
		            case "addressTab": address_ini(); break;
		            case "googleTab": Google_ini(); break;
		            case "scheduleGroupTab": scheduleGroup_ini(); break;
		        }
		    }
	
		    function schedule_ini() {
				document.getElementById("mainframe").src = "/ezSchedule/scheduleConfig.do";		        
		    }
		    
		    function task_ini() {
	            document.getElementById("mainframe").src = "/ezTask/taskConfig.do";
		    }

		    function task_general() {
	            document.getElementById("mainframe").src = "/ezTask/taskGeneral.do";
		    }
		    
		    function address_ini() {
	            document.getElementById("mainframe").src = "/myoffice/ezAddress/address_config_cross.aspx";
		    }
		    
		    function Google_ini() {
	            document.getElementById("mainframe").src = "/ezSchedule/scheduleSyncConfig.do";
		    }
		    
		    function schedule_noti() {
	            document.getElementById("mainframe").src = "/ezSchedule/scheduleMailNotiConfig.do";
		    }
		    
		    function scheduleGroup_ini() {
	            document.getElementById("mainframe").src = "/ezSchedule/scheduleManageGroup.do";
		    }
		</script>
	</head>
	<body class="mainbody">
		<c:choose>
       		<c:when test="${flag eq 'schedule'}">
       			<h1><spring:message code='ezPersonal.t999900007' /></h1>		
       		</c:when>
       		<c:otherwise>
       			<h1><spring:message code='ezTask.hyh001' /></h1>	
       		</c:otherwise>
       	</c:choose>
   		<div class="portlet_tabpart01" style="margin-top:3px;text-align:right">
       		<div class="portlet_tabpart01_top" id="tab1">
       			<c:choose>
       				<c:when test="${flag eq 'schedule'}">
       					<p><span id="1tab1" divname="scheduleTab"><spring:message code='ezPersonal.yej01' /></span></p>
       					<p><span id="1tab5" divname="scheduleGroupTab"><spring:message code='ezSchedule.shb12' /></span></p>
						<%-- 2023-08-01 조수빈 - 환경설정 > 개인설정 > 알림환경설정으로 통합, 일정관리 모듈의 알림메일설정 탭 제거 --%>
						<%-- <p><span id="1tab4" divname="scheduleMailNotiTab"><spring:message code='ezPersonal.t402' /></span></p> --%>
       				</c:when>
       				<c:otherwise>
       					<p><span id="1tab3" divname="taskTab"><spring:message code='ezPersonal.yej01' /></span></p>	
       				</c:otherwise>
       			</c:choose>
           		<%-- 구글캘린더 --%>
           		<c:if test="${useGoogleCalendar == 'YES'}">
           				<p><span id="1tab2" divname="googleTab"><spring:message code='ezSchedule.t401'/></span></p>
           		</c:if>
           		<%-- <p><span id="1tab4" divname="taskGeneral"><spring:message code='ezTask.jsh12' /></span></p> --%>
       		</div>
   		</div>    
       	<iframe id="mainframe" style="width:100%;height:100%;border:0px"></iframe>    
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>