<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:if test="${hasWorkspace == true}">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${workspaceContextRootUrl}/Scripts/moment.min.js"></script>
<script type="text/javascript" src="${workspaceContextRootUrl}/Scripts/Groupwareapi.js"></script>
<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
</c:if>
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
		<c:if test="${hasWorkspace == true}">
		<script type="text/javascript">
		    var g_UserID = "${userID}"; // GW 사용자 Id, 가온누리 Java버전엔 이미 선언되어 있음
		    var WorkspaceUrl = "${workspaceHostUrl}"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
		    var g_bGroupwareUIType = false;  // 그룹웨어 UI 타입 => true: UIUX, false: Normal(예전 GW 화면)
		    var feedListCount = 10;
		    var g_bRayful = false;
		    var g_bVisible = true; // 문서탭 선택 시 원문에 포함된 첨부파일 포함 여부 (false: 포함)		
		    var g_ParentHref = true // location.href를 parent 윈도우의 경로를 이동시킬지 여부 (true: parent 윈도우를 통해 이동)
		    var g_bEzWorkspaceJava = true; // 협업 자바버전 변경을 위한 변수
		</script>
		</c:if>
	</head>
	<body>
		<c:choose>
			<c:when test="${hasWorkspace == true}">
		    <div class="layDIV">
		        <dl class="portlet_title">
		            <dt class="portletText">협업</dt>
		            <dd class="portletPlus" onclick="workspacemore()"><img src="/images/kr/main/portlet_Plus.png"></dd>
		        </dl>          
		        <ul class="collaborate_tab" id="divSpaceListResults" style="overflow-y: auto; height: 204px;">
		        </ul>
		        <div class="collaborate_list">
		            <dl class="collaborate_listTab">
		                <dt onClick="workspaceChangeTab('newsTab')" id="newsTab" class="on">뉴스피드</dt>
		                <dt onClick="workspaceChangeTab('taskTab')" id="taskTab">할일</dt>
		                <dt onClick="workspaceChangeTab('documentTab')" id="documentTab">문서</dt>
		                <dt onClick="workspaceChangeTab('issueTab')" id="issueTab">이슈</dt>
		            </dl>            
		            <ul class="listtype_txt" id="divNewsfeedResults">
		            </ul>            	
		        </div>
		    </div>   			
			</c:when>
			<c:otherwise>
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
			</c:otherwise>
		</c:choose>
<%-- 		<div class="layDIV">
	    	<dl class="portlet_title">
	            <dt class="portletText"><spring:message code='main.t00002' /></dt>
	            <dd class="portletPlus"></dd>
	        </dl>
	        <c:choose>
				<c:when test="${not empty list}">
      				<div class="v_graph">       					
        				<ul>
			               	<c:forEach var="item" items="${list}">
		                		<li>
									<span class="g_term">${item.displayName}</span>
			                   		<span class="g_bar1" style="height:${item.draftCount}%"></span>
			                   		<span class="g_bar2" style="height:${item.susinCount}%"></span>
								</li> 
			            	</c:forEach>
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
		</div> --%>
		
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