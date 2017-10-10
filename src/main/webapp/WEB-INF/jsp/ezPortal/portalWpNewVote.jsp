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
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var qstTitle = "${qstTitle}";
		    var qstId = "${qstId}";
		    var votesArr = [];
		    var totalVotes = 0;
		    var numberOptions = "<c:out value='${numberOfOptions}'/>";
		    
		    window.onload = function () {		    	
		    	updateGraph();
		    }
		    function viewQstList() {
		    	window.open("/ezBoard/boardMain.do?func=3","main");		    	
		    }
		    function vote_poll() {
		         window.open("/ezBoard/boardMain.do?func=3&qstId=" + qstId, "main");
		    }
		    
		    function updateGraph() {
		    	console.log("NumberOptions: " + numberOptions + ", totalVotes : " + totalVotes);
		    	if (numberOptions == null) {
		    		return;
		    	}
				for (var i = 0; i < numberOptions; i++) {
					if (totalVotes > 0) {
						var percent = votesArr[i][1]/totalVotes;
						var inforDiv = document.getElementById("info" + votesArr[i][0]);
						inforDiv.innerHTML = inforDiv.innerHTML + "<span style=\"color:red; font-weight: bold\">" +  (percent * 100).toFixed(1) + "</span>" + "%)";
						if (votesArr[i][1] != 0) {								
							var id = "myCanvas" + votesArr[i][0];	
							var test = Math.round(220 * percent);
							document.getElementById("graph" + votesArr[i][0]).style.display = "inline-block";		
							var canv = document.getElementById(id);
							
							//Fill canvas with color
	 						canv.width = test;       					
	       					var ctx = canv.getContext("2d");
	       					ctx.shadowOffsetX = 2;
	       					ctx.shadowOffsetY = 2;
	       					ctx.shadowBlur = 2;
	       					ctx.shadowColor = "#999";
	       					var gradient = ctx.createLinearGradient(0, 0, 220, 0);
	       					gradient.addColorStop(0, "#49A0D8");
	       					gradient.addColorStop(1, "#ffffff");      					
	       					ctx.fillStyle = gradient;
	       					ctx.fillRect(0, 0, 220, 50);
						}
						else {
							document.getElementById("graph" + votesArr[i][0]).style.display = "none";
						}
					}
					else {
						document.getElementById("graph" + votesArr[i][0]).style.display = "none";
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
	               				<div style="display: inline-block; padding-left: 18px; width: 100%; font-family: Gulim,Dotum,Arial,Helvetica,sans-serif; font-size: 12px; ">
	               					<div style="float:left; display: block;">${loop.index + 1}. </div>
	               					<div style="float:left; display: block;">${_option.content}</div>
	               					<div id="info<c:out value ="${_option.ansId}" />" style="float:left; display: block;">&nbsp(<strong>${_option.votesNumber}</strong>명/</div>
	               				</div>
	               				<div id="graph<c:out value ="${_option.ansId}" />" style="display: inline-block;width: 234px; padding-left: 18px;">
	               					<canvas id="myCanvas<c:out value ="${_option.ansId}" />"  height="16" style="border:1px solid #000000;"></canvas>			               					               					
	               				</div>
	               				<script type="text/javascript">		               					
		               					var voteNum = ${_option.votesNumber};
		               					var optionID = ${_option.ansId};		               					
		               					votesArr.push([optionID, voteNum]);	  
		               					totalVotes = totalVotes + voteNum;
		               			</script>  	              		             		         			              			
      						</c:forEach>
  						</c:when>
  						<c:otherwise>
	  						<br />
    						<br />
    						<div class="nodata_portlet">
	    						<p	><img src="/images/kr/main/nodata_white.gif" width="107" height="70"></p>
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
