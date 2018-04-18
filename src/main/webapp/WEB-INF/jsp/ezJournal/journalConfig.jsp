<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title><spring:message code='ezCircular.t10'/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="<spring:message code='ezCircular.c1'/>" type="text/css">
    <link rel="stylesheet" href="/css/Tab.css" type="text/css" />
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    <script type="text/javascript">
    	$(document).ready(function() {
    	//	$("#HContent").val("<c:out value="${journalEnv.previewHcontent}"/>").attr("selected", "selected");
    	//	$("#WContent").val("<c:out value="${journalEnv.previewWcontent}"/>").attr("selected", "selected");
    	});
    
    	document.onselectstart = function () { return false; };
        window.onload = function () {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.body.style.MozUserSelect = 'none';
                document.body.style.WebkitUserSelect = 'none';
                document.body.style.khtmlUserSelect = 'none';
                document.body.style.oUserSelect = 'none';
                document.body.style.UserSelect = 'none';
            }
            document.getElementById("1tab1").setAttribute("class", "tabon");
            Tab1_SelectID = "1tab1";
            ChangeTab(document.getElementById("1tab1"));
        }
        
        function ChangeTab(obj) {
            var pSelectTab = obj.getAttribute("divname");
            switch (pSelectTab) {
                case "JournalEnv_div1":
                	if (document.getElementById("JournalEnv_content1").style.display == "none") {
                		document.getElementById("JournalEnv_content1").style.display = "";
                		document.getElementById("JournalEnv_content2").style.display = "none";
                	}
                    break;
                case "JournalEnv_div2":
                	if (document.getElementById("JournalEnv_content2").style.display == "none") {
                		document.getElementById("JournalEnv_content2").style.display = "";
                		document.getElementById("JournalEnv_content1").style.display = "none";
                	}
                    break;
            }
        }
        var Tab1_SelectID = "";
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
        
        function PreviewOption(val) {       
        	console.log(val);
        	if (val == "NONE") {
            	$("#PreviewWDiv").css("display", "none");                	
            	$("#PreviewHDiv").css("display", "none");                	
        	} else if (val == "H") {                	
            	$("#PreviewWDiv").css("display", "none");                	
            	$("#PreviewHDiv").css("display", "");                	
	        	$("#HContent").val("<c:out value="${journalEnv.previewHcontent}"/>").attr("selected", "selected");
        	} else {
            	$("#PreviewWDiv").css("display", "");                	
            	$("#PreviewHDiv").css("display", "none");                	
	    		$("#WContent").val("<c:out value="${journalEnv.previewWcontent}"/>").attr("selected", "selected");
        	}
    	}
        // 리스트옵션 화면에서 취소클릭시 원래의 설정으로변경
        function Cancel_Click() {
    		var viewEnv = "${journalEnv.viewenv}";
        	document.getElementById("listcount").value = "${journalEnv.listCnt}";
    		document.getElementById("PreviewMode").value = "${journalEnv.viewenv}";
			PreviewOption(viewEnv);    		
    	}
        
        // 리스트옵션 저장
    	function saveListEnv() {
    		var listCount = document.getElementById("listcount").value;
 			var preview = document.getElementById("PreviewMode").value;
 			var previewHcontent = document.getElementById("HContent").value;
 			var previewWcontent = document.getElementById("WContent").value;
 			
 			$.ajax({
 				url : "/ezJournal/saveJournalEnv.do",
 				method : "POST",
 				dataType : "text",
 				data : {
     				listCnt : listCount ,
	 				viewenv : preview,
	 				previewHcontent : previewHcontent,
	 				previewWcontent : previewWcontent
 				},
     			success : function() {
     				alert("<spring:message code='ezJournal.t137'/>");
 				}
 			});       
    	}
    	
        // 메일알림 옵션 저장
    	function saveMailAlert() {
    		var recvAlert = ($("#recvMail").is(":checked")) ? "Y" : "N";
    		var replyAlert = ($("#replyMail").is(":checked")) ? "Y" : "N";
    		
    		$.ajax({
    			type : "POST",
    			dataType : "text",
    			url : "/ezJournal/saveJournalEnv.do",
    			data : {
    				recvAlert : recvAlert,
    				replyAlert : replyAlert
    			},
    			success : function() {
    				alert("<spring:message code='ezJournal.t137'/>");
    			}
    		});
    		
    	}
    </script>
</head>
<body class="mainbody">
    <h1><spring:message code="ezJournal.t150" /></h1>
    <div class="portlet_tabpart01">
        <div class="portlet_tabpart01_top" id="tab1">
            <p id="JournalEnv_sub1"><span divname="JournalEnv_div1" id="1tab1"><spring:message code="ezJournal.t115" /></span></p>
            <p id="JournalEnv_sub2"><span divname="JournalEnv_div2" id="1tab2"><spring:message code="ezJournal.t116" /></span></p>
        </div>
    </div>
    <div id="JournalEnv_content1" style="width:100%;height:90%; padding-top:10px; display:none">
    	<br/>	
   		<h2><spring:message code="ezJournal.t115" /></h2>
   		<span class="txt"><spring:message code="ezJournal.t117" /></span>
       	<br />    
       	<table class="content" style="width: 480px;margin-top:5px">
           	<tr>
               	<th><spring:message code="ezCircular.t18" /></th>
              		<td>               
                  		<select id="listcount" name="pListCount" style="WIDTH: 100px">
               				<option value='10' ${journalEnv.listCnt == '10' ? 'selected' : ''}>10</option>
							<option value='20' ${journalEnv.listCnt == '20' ? 'selected' : ''}>20</option>
                   			<option value='30' ${journalEnv.listCnt == '30' ? 'selected' : ''}>30</option>
                   			<option value='40' ${journalEnv.listCnt == '40' ? 'selected' : ''}>40</option>
                   			<option value='50' ${journalEnv.listCnt == '50' ? 'selected' : ''}>50</option>                        
                  		</select>
                   	<spring:message code="ezCircular.t104" />
                   </td>
           	</tr>
           	<tr>
               	<th><spring:message code="ezCircular.t19" /></th>
           		<td>
               		<select id="PreviewMode" name="pPreview" style="WIDTH: 100px" onchange="PreviewOption(this.value);">
               			<option value='NONE' ${journalEnv.viewenv == 'NONE' ? 'selected' : ''}><spring:message code="ezCircular.t20" /></option>
               			<option value='H' ${journalEnv.viewenv == 'H' ? 'selected' : ''}><spring:message code="ezCircular.t21" /></option>
               			<option value='W' ${journalEnv.viewenv == 'W' ? 'selected' : ''}><spring:message code="ezCircular.t22" /></option>             					                     
               		</select>
               		<span id="PreviewWDiv" style="${journalEnv.viewenv ne 'W' ? 'display: none;' : ''}">                   			
      					&nbsp;<spring:message code="ezCircular.t24" /> :
						<select id="WContent" name="pPreviewWContent" style="width: 50px;">
							<c:forEach var="item" begin="35" end="75">
	  							<option value='${item}' ${item == journalEnv.previewWcontent ? 'selected' : '' }>${item}</option>
							</c:forEach>
						</select>		
					</span>
               		<span id="PreviewHDiv" style="${journalEnv.viewenv ne 'H' ? 'display: none;' : ''}">                   			
	       				&nbsp;<spring:message code="ezCircular.t24" /> :
						<select id="HContent" name="pPreviewHContent" style="width: 50px;">
							<c:forEach var="item" begin="36" end="61">
	   							<option value='${item}' ${item == journalEnv.previewHcontent ? 'selected' : '' }>${item}</option>
							</c:forEach>
						</select>
					</span>		
           		</td>
           	</tr>
       	</table>       
   		<br />
   		<div style="width:480px;text-align:center;">      
       		<a class="imgbtn" onclick="saveListEnv()"><span><spring:message code="ezCircular.t25" /></span></a>
       		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezCircular.t26" /></span></a>
   		</div>
	</div>		
    <div id="JournalEnv_content2" style="width:100%;height:90%; padding-top:10px; display:none">
	    <br/>	
   		<h2><spring:message code="ezJournal.t116" /></h2>
   		<span class="txt"><spring:message code="ezJournal.t121" /></span>
       	<br />    
    	<table class="content" style="width:480px; margin-top:5px">
    		<tr>
    			<th style="white-space: nowrap;">
    				<input type="checkbox" id="recvMail"
    					<c:if test="${journalEnv.recvAlert eq 'Y'}">
	    					checked
    					</c:if> 
    				>	
    			</th>
    			<td>&nbsp;<spring:message code="ezJournal.t122"/></td>
    		</tr>
    		<tr>
    			<th style="white-space: nowrap;">
    				<input type="checkbox" id="replyMail"
    					<c:if test="${journalEnv.replyAlert eq 'Y'}">
	    					checked
    					</c:if> 
    				>	
    			</th>
    			<td>&nbsp;<spring:message code="ezJournal.t123"/></td>
    		</tr>
    	</table>
    	<br/>
    	<div style="width:480px;text-align:center;">      
       		<a class="imgbtn" onclick="saveMailAlert()"><span><spring:message code="ezCircular.t25" /></span></a>
   		</div>
	</div>		
</body>
<script type="text/javascript">
    Tab1_NewTabIni("tab1");
</script>
</html>