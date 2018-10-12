<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>approvalListPortlet</title>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script src="${util.addVer('/js/jquery/raphael.2.1.0.min.js')}"></script>
		<script src="${util.addVer('/js/jquery/justgage.1.0.1.min.js')}"></script>
	</head>
	<body>
		<div class="layDIV approval">
            <dl class="portlet_tab">
                <dt id="doingTab" class="on" onclick="apprChangeTab(this)"><span><spring:message code='main.t00003' /></span></dt>
                <dt id="rejectTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00004' /></span></dt>
                <dt id="draftTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00005' /></span></dt>
                <dd class="portletPlus" onclick="Appmore_btnClick()"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
            </dl>
            <ul id ="ApprList" class="portlet_list">
				<dl class='nodata'>
					<dt><img src='/images/ezNewPortal/nodata.png'></dt>
					<dd><spring:message code='main.t00026' /></dd>
				</dl>

            </ul>
        </div>
		
		<script type="text/javascript">
			var getApprGraph = function() {
				var request = new XMLHttpRequest();
				request.open('POST', '/ezNewPortal/getApprovalList.do', true);
	
				request.onload = function() {
					if (request.status >= 200 && request.status < 400) {
						var result = JSON.parse(request.responseText);
						
						var docList = result.resultList;
						var docsHTML = "";
						
						for (var i = 0; i < 5; i++) {
							if (forms[i]) {
								docsHTML += "<li class='bookmarkLi' data-location='" + forms[i].formFileLocation + "' data-type='" + forms[i].formDocType + "'><span>" + forms[i].formName + "</span></li>";
							} else {
								docsHTML += "<li class='bookmarkLi_none'></li>";
							}
						}
						
						document.getElementsByClassName('bookmark')[0].innerHTML = formsHTML
						
						Array.from(document.getElementsByClassName('bookmarkLi')).forEach(function(element) {
							element.addEventListener('click', function() {
								checkBujaeOpenDraftUI(this.getAttribute("data-location"), this.getAttribute("data-type"));
							});
						});
					} else {
						// We reached our target server, but it returned an error
					}
				};
	
				request.onerror = function() {
				  // There was a connection error of some sort
				};
				
				request.send();
			}
			/* var getApprGraph = function(tabId) {
				
				
				$.ajax({
		 	    	type : "POST",
		 	        dataType : "JSON",
		 	        contentType: "application/json",
		 	        async: "false",
		 	        url : "/ezApprovalG/getPortletAprList.do",
		 	        data : JSON.stringify({
		 	        	pListTypeName: type, // 1. 결재할문서, 4. 반송문서, 2. 기안문서  
		 	        	pUserID: pUserID,
		 	        	companyID: companyID
					}),
					success : function(res){
						$('#ApprList').empty();
						if(pListTypeValue === "1") {
							$(res.list).each(function(index, element) {
								index === 0 ? $('#ApprList').append(dataAssemblerApprLine(element, res.listDtl, res.imgPath)) : $('#ApprList').append(dataAssembler(element)); 
							});													
						} else {
							$(res.list).each(function(index, element) {
								$('#ApprList').append(dataAssembler(element));
							});								
						}
						
						// 데이터가 없는 경우
						if(res.list.length < 1) {
							$('#ApprList').append(noData());
						}
						
						$('#ApprList li').css("cursor", "pointer");
		 	        },
		 	        error : function(error){
		 	        	console.log("<spring:message code='ezBoard.t22'/>wpNewApprMail" + error);	
		 	        }
				});
			} */
			
			var apprChangeTab = function(obj) {
				var type = "";
		        switch (obj.id) {
		            case "doingTab":
		                document.getElementById("doingTab").className = "on";
		                document.getElementById("rejectTab").className = "";
		                document.getElementById("draftTab").className = "";
		                break;
	
		            case "rejectTab":
		                document.getElementById("doingTab").className = "";
		                document.getElementById("rejectTab").className = "on";
		                document.getElementById("draftTab").className = "";
		                break;
	
		            case "draftTab":
		                document.getElementById("doingTab").className = "";
		                document.getElementById("rejectTab").className = "";
		                document.getElementById("draftTab").className = "on";
		                break;
		        }
		        
		        getApprGraph(obj.id);
		    }
		</script>
	</body>
</html>