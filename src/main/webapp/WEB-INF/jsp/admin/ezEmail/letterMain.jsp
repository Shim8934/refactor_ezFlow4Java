<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">	
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/FormCont.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript">
	    	var Tab1_SelectID = "";
	    	var companyID = "${userInfo.companyID}";
	    	
	        window.onload = function () {
	        	companyID = document.getElementById("ListCompany") != null ? document.getElementById("ListCompany").value : companyID;
	        	Tab_init_select(document.getElementById("tagsub1"));
	        	Tab1_NewTabIni("tab1");
	        };
	        
	        function selectCompanyID() {
	        	var company = document.getElementById("ListCompany") != null ? document.getElementById("ListCompany").value : companyID;
	        	if (companyID != company) {
	        		companyID = company;
	        		
	        		var letteIfr = document.getElementById("Letter_ifrm");
	        		if (Tab1_SelectID == 'tagsub1') {
	        			letteIfr.src = "/admin/ezEmail/letterBoxManager.do?companyId=" + companyID;
	        		} else {
	        			letteIfr.src = "/admin/ezEmail/letterAdminPage.do?companyId=" + companyID;
	        		}
	        		
	        	}
	        }
	        
	        function Tab_init_select(obj) {
	        	obj.setAttribute("class", "tabon");
                Tab1_SelectID = obj.id;
                ChangeTab(obj);
	        }
	        
	        function Tab1_MouseClick_more(obj, displayFlag) {
	            if (obj.className != "tabon") {
	
	                obj.className = "tabon";
	                var tabSelect = document.getElementById(Tab1_SelectID);
	                if (obj.id != Tab1_SelectID) {
	                    if (Tab1_SelectID != "" && tabSelect != null) {
	                        tabSelect.className = "";
	                    }
	                    
	                    obj.className = "tabon";
	                    Tab1_SelectID = obj.id;
	                    selValue = obj.textContent;
	                    CurPage = 1;
	                }
	                
	                var tabpartUL = document.getElementById("tabpart01UL").style.display;
	                if (!displayFlag) {
	                	tabpartUL = "";
	                } else {
	                    if (tabpartUL == "") {
	                    	tabpartUL = "none";
	                    } else {
	                    	tabpartUL = "";
	                    }
	                }
	            } else {
	                if (tabpartUL == "") {
	                	tabpartUL = "none";
	                } else {
	                	tabpartUL = "";
	                }
	            }
	        }
	        
	        function tabAllWidth() {
	            var allWidth = 0;
	            var tabP = document.getElementById("tab1").getElementsByTagName("P");
	            
	            for (var i = 0; i < tabP.length; i++) {
	                allWidth += tabP[i].offsetWidth;
	            }
	            return allWidth;
	        }
	
	        function ChangeTab(obj) {
	        	 var pSelectTab = obj.id;
	        	 
	        	 switch (pSelectTab) {
		            case "tagsub1": 
		            	document.getElementById("Letter_ifrm").src = "/admin/ezEmail/letterBoxManager.do?companyId=" + companyID;
		            	break;
		            case "tagsub2":
		            	document.getElementById("Letter_ifrm").src = "/admin/ezEmail/letterAdminPage.do?companyId=" + companyID;
		            	break;
		        }
	        }
	        
	        function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
	
		    function Tab1_MouserOut(obj) {
		        if(Tab1_SelectID != obj.id) {
		            obj.className = "";
		        }
		    }
	
		    function Tab1_MouseClick(obj) {		    	
		        obj.className = "tabon";
		        var tabSelect = document.getElementById(Tab1_SelectID);
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && tabSelect != null) {
		            	tabSelect.className = "";
		            }
	
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
	        
	        function Tab1_MouseClick2(obj) {
	            ChangeTab(obj);
	        }
	
	        function Tab1_NewTabIni(pTabNodeID) {
	        	var tabNode = document.getElementById(pTabNodeID).childNodes;
	        	
	            for (var i = 0; i < tabNode.length; i++) {
	            	var tabNodeChildItem = tabNode.item(i).childNodes.item(0);
	            	var tabNodeChild = tabNode[i].childNodes[0];
	            		
	                if (tabNode.item(i).nodeName == "P") {
	                    if (tabNodeChildItem.nodeName == "SPAN") {
	                    	tabNodeChildItem.onmouseover = function () { Tab1_MouserOver(this); };
	                    	tabNodeChildItem.onmouseout = function () { Tab1_MouserOut(this); };
	                        
	                        if (tabNodeChild.id != "overSpan") {
	                        	tabNodeChild.onclick = function () { Tab1_MouseClick(this); };
	                        } else {
	                        	tabNodeChild.onclick = function () { Tab1_MouseClick_more(this, true); };
	                        }
	                        
	                        if (i == 0) {
	                        	tabNodeChildItem.className = "tabon";
	                            Tab1_SelectID = tabNodeChildItem.id;
	                        }
	                    }
	                }
	            }
	        }
	    </script>
	</head>
	<body class="mainbody" style="height: 95%;">
		<h1>
	    	<spring:message code='main.t374'/>
	    	<span class="title_bar"><img src="/images/name_bar.gif"></span>
	    	<select id="ListCompany" class="companySelect" onchange="selectCompanyID()" style="height:29px">
	        	<c:forEach var="item" items="${list}">
	        		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
		    </select>
	    </h1>
	    <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	        	<p><span id="tagsub1"><spring:message code='ezEmail.letter20'/></span></p>
			    <p><span id="tagsub2"><spring:message code='ezEmail.t824'/></span></p>
	        </div>
	    </div>
	    <iframe id="Letter_ifrm" style="width: 1200px; height:535px;" frameborder="0"></iframe> 
	</body>
</html>
