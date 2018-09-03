<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='main.t1006' /></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">		
		<link href="${util.addVer('/css/ezPoll/vote.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript">
			var votepoll = "${votePoll}";
		    var itemseq = "${pPollItemSeq}";
		    
		    function viewquicklist() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 500) / 2;
		        var pLeft = (pwidth - 765) / 2;
		        
		        if(CrossYN())
		            window.open("/ezPersonal/homePollListUser.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=642,width=765,top=" + pTop + ",left=" + pLeft, "");
				else
		            window.open("/ezPersonal/homePollListUser.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=642,width=765,top=" + pTop + ",left=" + pLeft, "");
		    }
		    
		    function vote_poll() {
		        if (votepoll == "") {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 370) / 2;
		            var pLeft = (pwidth - 300) / 2;
		            
		            if (CrossYN())
		            	//2018-07-25 김보미 - 팝업창 크기 조정
 		                //window.open("/ezPersonal/wpLightPoll.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=370,width=300,top=" + pTop + ",left=" + pLeft, "");
		                window.open("/ezPersonal/wpLightPoll.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=400px,width=455px,top=" + pTop + ",left=" + pLeft, "");
		            else
		            	//2018-07-25 김보미 - 팝업창 크기 조정
 		                //window.open("/ezPersonal/wpLightPoll.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=370,width=300,top=" + pTop + ",left=" + pLeft, "");
		                window.open("/ezPersonal/wpLightPoll.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=400px,width=455px,top=" + pTop + ",left=" + pLeft, "");
		        } else {
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
		<div class="layDIV">
	        <dl class="portlet_title">
	            <dt class="portletText"><spring:message code='main.t2000' /></dt>
	            <dd class="portletPlus" onclick="viewquicklist()"><img src="/images/kr/main/portlet_Plus.png"></dd>
	        </dl>
	       	 <c:choose>
		         <c:when test = "${pPollResultContent eq null || pPollResultContent == ''}">
		         	<dl class='nodata'>
	                	<dt><img src='/images/kr/main/nodata.png'></dt>
	                	<dd><spring:message code='main.t00026' /></dd>
                	</dl>
		         </c:when>
	        <%-- <c:if test="${pPollTitle != ''}"> --%>
		         <c:otherwise>
			        <p class="voteTitle">“${pPollTitle }”</p>
			        <p class="voteBtn" onclick="vote_poll()"><spring:message code='main.t2001' /></p>
			        <ul class="voteList">
			         	${pPollResultContent}
			        </ul>
		         </c:otherwise>
				        
		     </c:choose>
		    <%-- </c:if> --%>    
	    </div>
		<!-- 2018-08-21 장진혁 포틀릿 변경으로 주석처리 -->
		<%-- <section  class="body_bg1">
			<article class="portletbox pollbox">
   				<div class="title"><span class="tl"></span><span class="tr"></span> <span class="title_txt"><spring:message code='main.t2000' /></span><span class="btn_more" onclick="viewquicklist()"><img src="/images/kr/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='main.t1008' />"></span></div>
  				<!-- 2018-07-25 김보미 - 스크롤 생기지 않게 style추가 -->
<!--   				<div class="pollcont"> -->
  				<div class="pollcont" style="overflow-y: hidden; overflow-x: hidden;">
 	 				<c:choose>
  						<c:when test="${pPollItemSeq != 0}">
  							<p class="qusetion">
   								<span class="btn_blue" onclick="vote_poll()"><span><spring:message code='main.t2001' /></span></span><span title="${pPollTitle }" style="margin-left:3px">${pPollTitle }</span>
    						</p>
      						${pPollResultContent}
  						</c:when>
  						<c:otherwise>	  						
    						<div class="nodata_portlet">
	    						<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>
    							<p><spring:message code='main.t260' /></p>
    						</div>
  						</c:otherwise>
  					</c:choose>
   				</div>
   				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section> --%>
	</body>
</html>
