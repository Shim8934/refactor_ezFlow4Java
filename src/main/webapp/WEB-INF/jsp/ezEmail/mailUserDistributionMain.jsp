<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <title><spring:message code='ezEmail.t904' /></title>
	</head>
	<body class="mainbody" style="min-width: 835px;">
		<div class="portlet_tabpart01_top" id="tab1">
			<p id="Mail_sub0">
				<span id="1tab0"><spring:message code='ezEmail.userDL16' /></span>
			</p>
			<p id="Mail_sub1">
				<span id="1tab1"><spring:message code='ezEmail.userDL17' /></span>
			</p>
			<p id="Mail_sub2">
				<span id="1tab2"><spring:message code='ezEmail.t37' /></span>
			</p>
		</div>
	    
	    <iframe id="MailEnv_ifrm" style ="width:100%;height:100%;" frameborder="0" ></iframe>
	    
	</body>
	<script type = "text/javascript">
		var Tab1_SelectID = "";
	
		window.onload = window_onload;
		window.onresize = window_resize;

		function window_onload() {
			$("#tab1 > p > span").on({
				click : function() { Tab1_MouseClick(this);},
				mouseover : function() { Tab1_MouserOver(this);},
				mouseleave : function() { Tab1_MouserOut(this);}
			});
			
			Tab1_MouseClick(document.getElementById("1tab0"));
			window_resize();
		}
		
		function window_resize() {
            document.getElementById("MailEnv_ifrm").style.height = (document.documentElement.clientHeight - 80) + "PX";
        }
		
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
                if(Tab1_SelectID!="" && document.getElementById(Tab1_SelectID) != null)
                    document.getElementById(Tab1_SelectID).className = "";

                obj.className = "tabon";
                Tab1_SelectID = obj.id;
                ChangeTab(obj);
            }
        }
		
		function ChangeTab(obj) {
	        var pSelectTab = obj.getAttribute("id");
	        switch (pSelectTab) {
	            case "1tab0":
	                document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailUserDistributionOwner.do";
	                break;
	            case "1tab1":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailUserDistributionInclude.do";
	                break;
	            case "1tab2":
	                document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailUserDistributionSearch.do";
	                break;
	        }
	    }
	</script>
</html>
