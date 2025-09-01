<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='main.t1006' /></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezPoll/vote.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPoll/stomp.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPoll/sockjs.min.js')}"></script>
		<script type="text/javascript">			
		    var qstId 			= "${qstId}";
		    var votesArr 		= [];
		    var totalVotes 		= 0;
		    var tenantId 		= "${tenantId}";
		    var numberOptions   = "<c:out value='${numberOfOptions}'/>";		   
		    var seeResultBefore = "${seeResultBefore}";		
		    var totalVoteToday = parseInt("${totalVoteToday}");	
		    
		    window.onload = function() {
		    	if (qstId != "-1") {
		    		getConnect();
		    		updateGraph();
		    	}
		    }
		    /* 2018-07-30 홍승비 - 영문 리소스 span 위치 조절용 jquery */
		    $(document).ready(function () { 	
		    	var voteTW = $(".title_txt").width();
		    	$("#todayVotes").css("left", voteTW + 14);    	
		    });

		    function getConnect(){
			    var socket = new SockJS('/hello');
			    stompClient = Stomp.over(socket);			
			    stompClient.connect({}, function (frame) {
			        stompClient.subscribe('/reply/finishVoteForQst' + qstId + "+" + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;
			        	
			            if (ret == "OK") {							
			            	window.location.reload();
					    }
				    });
			        
		        	stompClient.subscribe('/reply/getResultUpdateForQst' + qstId + "+" + tenantId, function (updatedInfo) {
			        	var optId = JSON.parse(updatedInfo.body).optionId;			        	
			        	var mode = JSON.parse(updatedInfo.body).mode;
			        	
			        	if (mode == 1) {
			        		//In adding mode
			        		totalVotes = totalVotes + 1;
			        		totalVoteToday = totalVoteToday + 1;
			        		document.getElementById("todayVotes").innerHTML = "(" + totalVoteToday + ")";
			        		
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
			        		totalVoteToday = totalVoteToday - 1;
			        		document.getElementById("todayVotes").innerHTML = "(" + totalVoteToday + ")";
			        		
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
                parent.document.querySelector("iframe[name=main]").src = "/ezBoard/boardMain.do?func=3";		    	
		    }
		    
		    function vote_poll() {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezPoll/checkPoll.do",
		    		data : {
		    			qstId : qstId
		    		},
		    		success: function(data) {		    			
						var result = JSON.parse(data).result;					
						
						if (result == "Normal") {
                            parent.document.querySelector("iframe[name=main]").src = "/ezBoard/boardMain.do?func=3&qstId=" + qstId;
						}
						else {
							alert("<spring:message code = 'ezPoll.t233'/>");
							window.location.reload();
						}
			        },
			        error: function(error) {
			        	alert(error);
			        }
		    	});
		        
		    }
		    
		    function updateGraph() {		    	
		    	if (numberOptions == null) {
		    		return;
		    	} 		    	

				for (var i = 0; i < numberOptions; i++) {
					var graph = document.getElementById("graph" + votesArr[i][0]);	
					var divGrap = document.getElementById("divGraph" + votesArr[i][0]);
					var percentDiv = document.getElementById("percent" + votesArr[i][0]);
					/* var inforDiv = document.getElementById("info" + votesArr[i][0]); */
					
					if (totalVotes > 0 && seeResultBefore == 1) {
						/* var spaceElmt = document.getElementById("space" + votesArr[i][0]); */
						
						/* if (spaceElmt != null) {
							spaceElmt.style.display = "none";
						} */
						
						var percent = votesArr[i][1]/totalVotes;												
						/* inforDiv.innerHTML = "&nbsp<span class='Pt_QstInfoVotes'>" + votesArr[i][1] + "</span><spring:message code = 'ezPoll.t166'/>/"
											 + "<span class='Pt_QstInfoPercent'>" +  (percent * 100).toFixed(1) + "</span>" + "%"; */
						percentDiv.innerHTML = (percent * 100).toFixed(0) + "%";
						
						if (votesArr[i][1] != 0) {																					
							graph.style.display = "inline-block";		
							graph.setAttribute("style", "width:" + percent*100 + "%");
						}
						else {
							graph.style.display = "none";
						}
						divGrap.style.display = "block";
					}
					else {
						graph.style.display = "none";
						/* inforDiv.innerHTML = "&nbsp<span class='Pt_QstInfoVotes'>" + votesArr[i][1] + "</span><spring:message code = 'ezPoll.t166'/>/"
											 + "<span class='Pt_QstInfoPercent'>0.0</span>" + "%"; */
					}
				}
			}
		</script>
	</head>
	<body>
		<div class="layDIV">
	        <dl class="portlet_title">
	            <dt class="portletText"><spring:message code='main.t2002' /><span id="todayVotes" class="tab_num"> (<c:out value='${totalVoteToday}'/>)</span></dt>
	            <dd class="portletPlus" onclick="viewQstList()"><img src="/images/kr/main/portlet_Plus.png"></dd>
	        </dl>
	       	 <c:choose>
		        <c:when test="${qstId != -1}">
		        	<p class="voteTitle">"<c:out value='${qstTitle}'/>"</p>
			        <p class="voteBtn" onclick="vote_poll()"><spring:message code='main.t2001' /></p>
			        <ul class="voteList">
			         	<c:forEach var="_option" items="${listOptions}" varStatus="loop"> 
			         		<li class="voteList_0${loop.index+1}">
			         			<div class="voteT" style='width:${seeResultBefore == 1 ? "22%" : "82%"}'><span class="Vnum">${loop.index+1}</span><span class="Vtext"><c:out value ="${_option.content}" /></span></div>
                                <div class="percent" id="percent<c:out value ="${_option.ansId}" />">0%</div>
                                <c:choose>
	               						<c:when test="${seeResultBefore == 1}">
			               					<div class="voteGraph" id="divGraph<c:out value ="${_option.ansId}" />">
				               					<span id="graph<c:out value ="${_option.ansId}" />" style="width:0px"></span>           					
				               				</div>				               				
	               						</c:when>
	               						<c:otherwise>
	               							<div class="voteGraph" style="display: none;" id="divGraph<c:out value ="${_option.ansId}" />">
				               					<span id="graph<c:out value ="${_option.ansId}" />" style="width:0px"></span>           					
				               				</div>
	               						</c:otherwise>
	               					</c:choose>
	               					<script type="text/javascript">		               					
		               					var voteNum = ${_option.votesNumber};
		               					var optionID = ${_option.ansId};		               					
		               					votesArr.push([optionID, voteNum]);	  
		               					totalVotes = totalVotes + voteNum;
			               			</script> 
                            </li>   
			         	</c:forEach>
			        </ul>
		        </c:when>
  				<c:otherwise>
  					<%-- <div class="nodata_portlet">
						<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>
						<p><spring:message code='main.t261' /></p>
					</div> --%>
					<ul class="portlet_list">
						<dl class='nodata'>
		                	<dt><img src='/images/kr/main/nodata.png'></dt>
		                	<dd>"<spring:message code='main.t00026' />"</dd>
	                	</dl>
                	</ul>
  				</c:otherwise>
  			</c:choose>
	    </div>
		<%-- <section class="body_bg1">
			<article class="portletbox pollbox">
   				<div class="title"><span class="tl"></span><span class="tr"></span> <span class="title_txt" style="display: inline-block;"><spring:message code='main.t2002' /></span> <span id="todayVotes" style="position: absolute; top: 14px; left: 41px;" class="tab_num"> (<c:out value='${totalVoteToday}'/>)</span><span class="btn_more" onclick="viewQstList()"><img src="/images/<spring:message code='main.t00025' />/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='main.t1008' />"></span></div>
  				<div class="pollcont" style="overflow-y: hidden; overflow-x: hidden;">
 	 				<c:choose>
  						<c:when test="${qstId != -1}">
  							<p class="qusetion">
   								<span class="btn_blue" onclick="vote_poll()"><span><spring:message code='main.t2001' /></span></span><span title="<c:out value='${qstTitle}'/>" style="margin-left:3px; text-overflow: ellipsis;"><c:out value='${qstTitle}'/></span>
    						</p>
      						<c:forEach var="_option" items="${listOptions}" varStatus="loop">
      							<div class="poll_list1">
		               				<div style="display: inline-block; width: 100%; font-size: 12px; ">
		               					<div style="float:left; display: block;">${loop.index + 1}. </div>
		               					<div class="Pt_QstOptTitleDiv" title="<c:out value ="${_option.content}" />"><c:out value ="${_option.content}" /></div>
		               					
		               					<c:choose>
		               						<c:when test="${seeResultBefore == 1}">
		               							<div id="info<c:out value ="${_option.ansId}" />" class="Pt_QstInfoDiv">&nbsp${_option.votesNumber}<spring:message code = 'ezPoll.t166'/>/</div>
		               						</c:when>
		               						<c:otherwise>
		               							<div id="info<c:out value ="${_option.ansId}" />" class="Pt_QstInfoDivOff">&nbsp${_option.votesNumber}<spring:message code = 'ezPoll.t166'/>/</div>
		               						</c:otherwise>
		               					</c:choose>
		               					
		               				</div>
		               				
	               					<c:choose>
	               						<c:when test="${seeResultBefore == 1}">
			               					<div class="graphbar1" id="divGraph<c:out value ="${_option.ansId}" />">
				               					<p id="graph<c:out value ="${_option.ansId}" />" class="gx_bar11" ></p>
				               				</div>
	               						</c:when>
	               						<c:otherwise>
	               							<div class="graphbar1" style="display: none;" id="divGraph<c:out value ="${_option.ansId}" />">
				               					<p id="graph<c:out value ="${_option.ansId}" />" class="gx_bar11" ></p>
				               				</div>
		               						<div id="space<c:out value ="${_option.ansId}" />" style="display: inline-block;"></div>
	               						</c:otherwise>
	               					</c:choose>

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
    						<div class="nodata_portlet">
	    						<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>
    							<p><spring:message code='main.t00026' /></p>
    						</div>
  						</c:otherwise>
  					</c:choose>
   				</div>
   				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section> --%>
	</body>
</html>
