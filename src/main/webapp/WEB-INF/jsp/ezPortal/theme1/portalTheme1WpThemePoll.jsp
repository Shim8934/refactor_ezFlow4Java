<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			window.onload = function () {
	            try { top.onresize() } catch (e) { }
	        }
			var votepoll = "${votePoll}";
	        var itemseq = "${pPollItemSeq}";
	        
	        function vote_poll() {
	            if (votepoll == "") {
	                var pheight = window.screen.availHeight;
	                var pwidth = window.screen.availWidth;
	                var pTop = (pheight - 370) / 2;
	                var pLeft = (pwidth - 300) / 2;
	                if (CrossYN())
	                    window.open("/ezPersonal/wpLightPoll.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=370,width=300,top=" + pTop + ",left=" + pLeft, "");
	                else
	                    window.open("/ezPersonal/wpLightPoll.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=370,width=300,top=" + pTop + ",left=" + pLeft, "");
	            }
	            else {
	                var heigth = window.screen.availHeight;
	                var width = window.screen.availWidth;
	
	                var left = (width - 455) / 2;
	                var top = (heigth - 400) / 2;
	                window.open("/ezPersonal/pollResult.do?itemSeq=" + itemseq, "", "height=400px,width=455, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=" + top + ",left = " + left);
	            }
	        }
		</script>
	</head>
	<body>
		<!-- quickpoll -->
		<div class="content_quickpoll">
			<dl class="content_title02">
	    		<dt><spring:message code='main.t2000' /></dt>
	    	</dl>
	    	<div class="content_list02">
	    		<c:choose>
	    			<c:when test="${pPollItemSeq != 0}">
	    				<dl class="quickpoll_list">
	        				<dt><span><spring:message code='main.t00042' />:</span>${pPollTitle }</dt>
	            			<dd onclick="vote_poll()"><spring:message code='main.t00050' /> </dd>
	        			</dl>
	    			</c:when>
	    			<c:otherwise>
	    				<div class="nodata_poll">
	                		<p><img src="/images/kr/theme01/main/nodata_poll.png" ></p>
	                		<p><spring:message code='main.t00026' />></p>
	            		</div>		
	    			</c:otherwise>
	    		</c:choose>
		</div>
	</div>
	<!-- //quickpoll -->
	</body>
</html>