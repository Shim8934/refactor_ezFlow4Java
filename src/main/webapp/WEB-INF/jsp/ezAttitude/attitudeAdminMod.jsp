<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <link rel="stylesheet" href='/css/Tab.css' type="text/css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" language="javascript">			
	        
			var TabId = "modify";
		
	        document.onselectstart = function () { return false; };
	        window.onresize = window_resize;
	        
	        $(document).ready(function(){
	        	if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }   	
	            document.getElementById(TabId).setAttribute("class", "tabon");
	            Tab1_SelectID = TabId;

	            ChangeTab(document.getElementById(TabId));
	            window_resize();
	        });	        

	        function window_resize() {
	            document.getElementById("BoardEnv_ifrm").style.height = (document.documentElement.clientHeight - 120) + "PX";
	        }
	        function ChangeTab(obj) {
	            var pSelectTab = obj.getAttribute("divname");

	            switch (pSelectTab) {
	                case "BoardEnv_div1":
                        document.getElementById("BoardEnv_ifrm").src = "/ezAttitude/attitudeCheck.do";
	                    break;
	                case "BoardEnv_div2":
	                    document.getElementById("BoardEnv_ifrm").src = "/ezAttitude/attitudeAbsented.do";
	                    break;
	                case "BoardEnv_div3":
	                    document.getElementById("BoardEnv_ifrm").src = "/ezAttitude/attitudeHistory.do";
	                    break;
	            }
	        }
	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id){
	                obj.className = "";
	            }
	        }
	        function Tab1_MouseClick(obj) {
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null){
	                    document.getElementById(Tab1_SelectID).className = "";
	                }
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                console.log(Tab1_SelectID);
	                if (Tab1_SelectID == "modify"){
	                	$("absent").text("<spring:message code='ezAttitude.t51'/>");
	                	$("history").text("<spring:message code='ezAttitude.t57'/>");
	                }
	                
					if (Tab1_SelectID == "absent"){
						$("modify").text("<spring:message code='ezAttitude.t1'/>");
                		$("history").text("<spring:message code='ezAttitude.t58'/>");
	                }
	                
					if (Tab1_SelectID == "history"){
						$("absent").text("<spring:message code='ezAttitude.t51'/>");
                		$("history").text("<spring:message code='ezAttitude.t57'/>");
					}
	                ChangeTab(obj);
	            }
	        }
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	
	                    }
	                }
	            }
	        }
	    </script>
	</head>
	<body class="mainbody">
		<h1><p style="padding-left:5px">전체근태관리</p></h1>
	    <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	            <p id="BoardEnv_sub1"><span divname="BoardEnv_div1" id="modify" style="width:100px; text-align: center;"><spring:message code='ezAttitude.t1'/></span></p>
	            <p id="BoardEnv_sub2"><span divname="BoardEnv_div2" id="absent" style="width:100px; text-align: center;"><spring:message code='ezAttitude.t51'/></span></p>
	            <p id="BoardEnv_sub3"><span divname="BoardEnv_div3" id="history" style="width:100px; text-align: center;"><spring:message code='ezAttitude.t57'/></span></p>
	        </div>
	    </div>
	    <iframe id="BoardEnv_ifrm" style="width: 100%; height: 100%;" frameborder="0"></iframe>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>