<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
		    document.onselectstart = function () { return false; };
		    window.onload = function()
		    {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        document.getElementById("mainframe").src = "/ezPersonal/approvalConfig.do";
		        window_resize();
		    };
		    window.onresize = window_resize;
		    function window_resize() {
		        document.getElementById("mainframe").style.height = (document.documentElement.clientHeight - 200) + "PX";
		    }
		    var Tab1_SelectID = "";
		    var Tab1_flag = true;
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id)
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
		            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;
		
		                    if (Tab1_flag) {
		                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
		                        Tab1_flag = false;
		                    }
		
		                }
		            }
		        }
		    }
		     function ChangeTab(obj) {
		        var pSelectTab = obj.getAttribute("divname");
		        switch (pSelectTab) {
		            case "passTab": Approval_config_ini(); break;
		            case "bujaeTab": ManageBujae_ini(); break;
		            case "bujaeGTab": ManageBujaeG_ini(); break;
		            case "noticeTab": SetApprovNoticeMail_ini(); break;
		            case "signTab": sign_ini(); break;
		        }
		    }
		     function Approval_config_ini()
		    {
		         document.getElementById("mainframe").src = "/ezPersonal/approvalConfig.do";
		    }
		     function ManageBujae_ini()
		    {
		         document.getElementById("mainframe").src = "/myoffice/ezPersonal/BujaeConf/managebujae_cross.aspx";
		    }
		     function ManageBujaeG_ini()
		    {
		         document.getElementById("mainframe").src = "/ezPersonal/manageBujaeG.do";
		    }
		     function SetApprovNoticeMail_ini()
		    {
		         document.getElementById("mainframe").src = "/ezPersonal/setApprovNoticeMail.do";
		     }
		     function sign_ini()
		     {
		         document.getElementById("mainframe").src = "/ezPersonal/signimageConfig.do";
		     }
		      
		</script>
	    <title><spring:message code='ezPersonal.t999900008'/></title>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezPersonal.t999900008'/></h1>
	    <div class="portlet_tabpart01" style="margin-top:3px;">
	        <div class="portlet_tabpart01_top" id="tab1">
	            <p><span id="1tab1" divname="passTab"><spring:message code='ezPersonal.t999900024'/></span></p>
	            <c:if test="${userInfoApprovalG == 'NO' || userInfoApprovalG == 'BOTH'}">
		            <p><span id="1tab2" divname="bujaeTab"><spring:message code='ezPersonal.t999900025'/></span></p>
	            </c:if>
	            <c:if test="${userInfoApprovalG == 'YES' || userInfoApprovalG == 'BOTH'}">
		            <p><span id="1tab3" divname="bujaeGTab"><spring:message code='ezPersonal.t999900026'/></span></p>
	            </c:if>
	            <c:if test="${userInfoApprovalG == 'YES' || userInfoApprovalG == 'NO' || userInfoApprovalG == 'BOTH'}">
		            <p><span id="1tab4" divname="noticeTab"><spring:message code='ezPersonal.t999900027'/></span></p>
	            </c:if>
	            <p><span id="1tab5" divname="signTab"><spring:message code='ezPersonal.t3000'/></span></p>
	        </div>
	    </div>
	    <div>
	        <iframe id="mainframe" style="width:100%;height:100%;" frameborder="0"></iframe>
	    </div>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>