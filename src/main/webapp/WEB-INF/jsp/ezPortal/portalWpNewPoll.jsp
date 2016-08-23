<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezHome.t1006' /></title>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<section  class="body_bg1">
			<article class="portletbox pollbox">
   				<div class="title"><span class="tl"></span><span class="tr"></span> <span class="title_txt"><spring:message code='ezHome.t2000' /></span><span class="btn_more" onclick="viewquicklist()"><img src="/images/kr/main/btn_more02.gif" width="35" height="20" alt="더보기"></span></div>
  				<div class="pollcont">
 	 				<c:choose>
  						<c:when test="${not empty pPollItemSeq}">
  							<p class="qusetion">
   								<span class="btn_blue" onclick="vote_poll()"><span><spring:message code='ezHome.t2001' /></span></span><span style="margin-left:3px">${pPollTitle }</span>
    						</p>
      						${pPollResultContent}
  						</c:when>
  						<c:otherwise>
	  						<br />
    						<br />
    						<div class="nodata_portlet">
	    						<p	><img src="/images/kr/main/nodata_white.gif" width="107" height="70"></p>
    							<p><spring:message code='ezHome.t260' /></p>
    						</div>
  						</c:otherwise>
  					</c:choose>
   				</div>
   				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section>
		
		<link href="/css/main.css" rel="stylesheet" type="text/css">
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script type="text/javascript">
		 var votepoll = "${votePoll}";
		    var itemseq = "${pPollItemSeq}";
		    function viewquicklist() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 420) / 2;
		        var pLeft = (pwidth - 765) / 2;
		        if(CrossYN())
		            window.open("/ezPersonal/homePollListUser.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=420,width=765,top=" + pTop + ",left=" + pLeft, "");
		else
		            window.open("/ezPersonal/homePollListUser.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=420,width=765,top=" + pTop + ",left=" + pLeft, "");
		    }
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
</html>