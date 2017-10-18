<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='main.t1006' /></title>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<link href="<spring:message code='main.e6' />" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="/css/ezPoll/vote.css" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPoll/stomp.min.js"></script>
		<script type="text/javascript" src="/js/ezPoll/sockjs.min.js"></script>
		<script type="text/javascript">
			var qstTitle = "${qstTitle}";
		    var qstId = "${qstId}";
		    var votesArr = [];
		    var totalVotes = 0;
		    var tenantId = "${tenantId}";
		    var numberOptions = "<c:out value='${numberOfOptions}'/>";		   
		    
		    window.onload = function() {
		    	getConnect();
		    	updateGraph();
		    }
		    
		    function getConnect(){
			    var socket = new SockJS('/ezFlow/hello');
			    stompClient = Stomp.over(socket);			
			    stompClient.connect({}, function (frame) {
		        	stompClient.subscribe('/reply/getResultUpdateForQst' + qstId + "+" + tenantId, function (updatedInfo) {
			        	var optId = JSON.parse(updatedInfo.body).optionId;			        	
			        	var mode = JSON.parse(updatedInfo.body).mode;
			        	
			        	if (mode == 1) {
			        		//In adding mode
			        		totalVotes = totalVotes + 1;
			        		
			        		for (var i = 0; i < numberOptions; i++) {
			        			if (votesArr[i][0] == optId) {
			        				votesArr[i][1] = votesArr[i][1] + 1;			        			
			        				break;
			        			}
			        		}	
			        		
			        		updateGraph();
			        	}
			        	else {
			        		//In removing mode
			        		totalVotes = totalVotes - 1;
			        		
			        		for (var i = 0; i < numberOptions; i++) {
			        			if (votesArr[i][0] == optId) {
			        				votesArr[i][1] = votesArr[i][1] - 1;			        				
			        				break;
			        			}
			        		}	
			        		
			        		updateGraph();
			        	}
		        	});
			    });
		    }		    
		    
		    function viewQstList() {
		    	window.open("/ezBoard/boardMain.do?func=3","main");		    	
		    }
		    
		    function vote_poll() {
		         window.open("/ezBoard/boardMain.do?func=3&qstId=" + qstId, "main");
		    }
		    
		    function updateGraph() {		    	
		    	if (numberOptions == null) {
		    		return;
		    	} 		    	
		    	
				for (var i = 0; i < numberOptions; i++) {
					var graph = document.getElementById("graph" + votesArr[i][0]);				
					var inforDiv = document.getElementById("info" + votesArr[i][0]);
					
					if (totalVotes > 0) {
						var percent = votesArr[i][1]/totalVotes;												
						inforDiv.innerHTML = "&nbsp(<strong>" + votesArr[i][1] + "</strong><spring:message code = 'ezPoll.t166'/>/"
											+ "<span style=\"color:red; font-weight: bold\">" +  (percent * 100).toFixed(1) + "</span>" + "%)";
						
						if (votesArr[i][1] != 0) {																					
							graph.style.display = "inline-block";		
							graph.setAttribute("style", "width:" + percent*100 + "%");
						}
						else {
							graph.style.display = "none";
						}
					}
					else {
						graph.style.display = "none";
						inforDiv.innerHTML = inforDiv.innerHTML + "<span style=\"color:red; font-weight: bold\">0.0</span>" + "%)";
					}
				}
			}
		</script>						
	</head>
	<body>
		<section class="body_bg1">
			<article class="portletbox pollbox">
   				<div class="title"><span class="tl"></span><span class="tr"></span> <span class="title_txt"><spring:message code='main.t2002' /></span><span class="btn_more" onclick="viewQstList()"><img src="/images/kr/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='main.t1008' />"></span></div>
  				<div class="pollcont" style="overflow-y: auto; overflow-x: hidden;">
 	 				<c:choose>
  						<c:when test="${qstId != -1}">
  							<p class="qusetion">
   								<span class="btn_blue" onclick="vote_poll()"><span><spring:message code='main.t2001' /></span></span><span title="${qstTitle }" style="margin-left:3px">${qstTitle}</span>
    						</p>
      						<c:forEach var="_option" items="${listOptions}" varStatus="loop">     
      							<div class="poll_list1"> 								    
		               				<div style="display: inline-block; width: 100%; font-family: Gulim,Dotum,Arial,Helvetica,sans-serif; font-size: 12px; ">
		               					<div style="float:left; display: block;">${loop.index + 1}. </div>
		               					<div style="float:left; display: block;">${_option.content}</div>
		               					<div id="info<c:out value ="${_option.ansId}" />" style="float:left; display: block;">&nbsp(<strong>${_option.votesNumber}</strong><spring:message code = 'ezPoll.t166'/>/</div>
		               				</div>
		               				<div class="graphbar1">
		               					<p id="graph<c:out value ="${_option.ansId}" />" class="gx_bar11"></p>           					
		               				</div>
		               				<script type="text/javascript">		               					
			               					var voteNum = ${_option.votesNumber};
			               					var optionID = ${_option.ansId};		               					
			               					votesArr.push([optionID, voteNum]);	  
			               					totalVotes = totalVotes + voteNum;
			               			</script>  	
			               		</div>              		             		         			              			
      						</c:forEach>
  						</c:when>
  						<c:otherwise>
	  						<br />
    						<br />
    						<div class="nodata_portlet">
	    						<p><img src="/images/kr/main/nodata_white.gif" width="107" height="70"></p>
    							<p><spring:message code='main.t260' /></p>
    						</div>
  						</c:otherwise>
  					</c:choose>
   				</div>
   				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section>
	</body>
</html>
