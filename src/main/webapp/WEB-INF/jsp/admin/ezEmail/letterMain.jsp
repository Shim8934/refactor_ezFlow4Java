<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript">
	    	var Tab1_SelectID = "";
	        window.onload = function () {
	        	Tab_init_select(document.getElementById("tagsub1"));
	        	Tab1_NewTabIni("tab1");
	        };
	        
	        function Tab_init_select(obj) {
	        	obj.setAttribute("class", "tabon");
                Tab1_SelectID = obj.id;
                ChangeTab(obj);
	        }
	        
	        function Tab1_MouseClick_more(obj, displayFlag) {
	            if (obj.className != "tabon") {
	
	                obj.className = "tabon";
	                if (obj.id != Tab1_SelectID) {
	                    if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                        document.getElementById(Tab1_SelectID).className = "";
	
	                    obj.className = "tabon";
	                    Tab1_SelectID = obj.id;
	                    selValue = obj.textContent;
	                    CurPage = 1;
	                }
	                if (!displayFlag)
	                    document.getElementById("tabpart01UL").style.display = "";
	                else {
	                    if (document.getElementById("tabpart01UL").style.display == "")
	                        document.getElementById("tabpart01UL").style.display = "none";
	                    else
	                        document.getElementById("tabpart01UL").style.display = "";
	                }
	            }
	            else {
	                if (document.getElementById("tabpart01UL").style.display == "")
	                    document.getElementById("tabpart01UL").style.display = "none";
	                else
	                    document.getElementById("tabpart01UL").style.display = "";
	            }
	        }
	        
	        function tabAllWidth() {
	            var allWidth = 0;
	            for (var i = 0; i < document.getElementById("tab1").getElementsByTagName("P").length; i++) {
	                allWidth += document.getElementById("tab1").getElementsByTagName("P")[i].offsetWidth;
	            }
	            return allWidth;
	        }
	
	        function ChangeTab(obj) {
	        	 var pSelectTab = obj.id;
	        	 
	        	 switch (pSelectTab) {
		            case "tagsub1": 
		            	document.getElementById("Letter_ifrm").src = "/admin/ezEmail/letterBoxManager.do";
		            	break;
		            case "tagsub2":
		            	document.getElementById("Letter_ifrm").src = "";
		            	break;
		            	
		        }
	        }
	        
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
	        
	        function Tab1_MouseClick2(obj) {
	            ChangeTab(obj);
	        }
	
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        
	                        if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id != "overSpan")
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };
	                        else
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick_more(this, true); };
	
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
	<body class="mainbody" style="height: 95%; overflow:hidden;">
	    <h1><spring:message code='main.t374'/><span></span></h1>
	    <b><spring:message code='ezOrgan.t00006'/>:</b> 
		    <select id="ListCompany" onChange="selectCompanyID()">
		    	<option value="${companyID}">${companyName}</option>
	        	
		    </select><br>
	    <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	        	<p><span id="tagsub1">편지지함<!-- spring message로 넣기 --></span></p>
			    <p><span id="tagsub2"><spring:message code='ezEmail.t824'/></span></p>
	        </div>
	    </div>
	    <iframe id="Letter_ifrm" style="width: 100%; height: 100%;" frameborder="0"></iframe>
	</body>
</html>
