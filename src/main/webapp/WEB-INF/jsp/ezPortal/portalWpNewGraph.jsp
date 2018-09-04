<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<script type="text/javascript">
	    	window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            	document.body.style.MozUserSelect = 'none';
	            	document.body.style.WebkitUserSelect = 'none';
	            	document.body.style.khtmlUserSelect = 'none';
	            	document.body.style.oUserSelect = 'none';
	            	document.body.style.UserSelect = 'none';
	        	}
	    	}
		</script>
	</head>
	<body>
		<div class="layDIV">
	    	<dl class="portlet_title">
	            <dt class="portletText"><spring:message code='main.t00002' /></dt>
	            <dd class="portletPlus"></dd>
	        </dl>
	        <c:choose>
				<c:when test="${not empty list}">
      				<div class="v_graph">       					
        				<ul>
			               	<%-- <c:forEach var="item" items="${list}">
		                		<li>
									<span class="g_term">${item.displayName}</span>
			                   		<span class="g_bar1" style="height:${item.draftCount}%"></span>
			                   		<span class="g_bar2" style="height:${item.susinCount}%"></span>
								</li> 
			            	</c:forEach> --%>
			            	<c:forEach var="item" begin="0" end="4" items="${list}" varStatus="i">
			             		<li>
									<span class="g_term">${item.displayName}</span>
			                   		<span class="g_bar1" style="height:${item.draftCount}%"></span>
			                   		<span class="g_bar2" style="height:${item.susinCount}%"></span>
								</li> 
							</c:forEach>
		             		<c:if test="${fn:length(list) < 5 }">
		             			<c:forEach begin="0" end="${4 - fn:length(list)}">
		             				<li>
										<span class="g_term"></span>
				                   		<span class="g_bar1"></span>
				                   		<span class="g_bar2"></span>
									</li> 
		             			</c:forEach>
		             		</c:if>
        				</ul>
        			</div>	
      			</c:when>
      			<c:otherwise>
      				<div class="v_graph">       					
        				<ul>
			               	<c:forEach var="item" begin="0" end="4">
		                		<li>
									<span class="g_term"></span>
			                   		<span class="g_bar1"></span>
			                   		<span class="g_bar2"></span>
								</li> 
			            	</c:forEach>
        				</ul>
        			</div>	
      			</c:otherwise>
      		</c:choose>			
		</div>
		
		<!-- 2018-08-21 장진혁 포틀릿 변경으로 주석처리 -->
		<%-- <section  class="body_bg1">
			<article class="portletbox graphbox">
				<div class="title_nb"><span class="tl_nb"></span><span class="tr_nb"></span><span class="title_txt"><spring:message code='main.t00002' /></span></div>
				<div class="graphcont">
    				<!-- 그래프영역 -->
    				<!-- UI Object -->        				
       				<c:choose>
       					<c:when test="${not empty list}">
       						<div class="v_graph">
        						<span class="r_arrow"> ^</span>
	        					<span class="l_arrow"> ^</span>
    	    					<span class="maxtxt">${dMaxCount } max</span>
	        					<ul>
				                	<c:forEach var="item" items="${list}">
			                			<li>
											<span class="g_term">${item.displayName}</span>
				                    		<span class="g_bar1" style="height:${item.draftCount}%"></span>
				                    		<span class="g_bar2" style="height:${item.susinCount}%"></span>
										</li> 
				               		</c:forEach>
	        					</ul>
	        				</div>	
       					</c:when>
       					<c:otherwise>
       						<div class="nodata_portlet">
       							<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>
       							<p><spring:message code='main.t00026' /></p>
       						</div>
       					</c:otherwise>
       				</c:choose>
				</div>
				<!-- //UI Object -->    			
				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section> --%>
	</body>
</html>