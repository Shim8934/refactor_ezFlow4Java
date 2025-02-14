<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />				
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.css')}" />
    	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mobile/mobile.css')}" />
    	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mobile/mApprovalG.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mobile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mApprovalG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>			
	</head>
	<body class="loginbody">
		<section id="doApproveDetail" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGDetailTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">
		      	<div class="ui-body ui-body-a ui-corner-all">
		      		<div class="ui-field-contain">
		        		<h1>야근수당</h1>
		        		<br/>
		        		<h5>지정석 사원(오픈솔루션팀)</h5>
		        	</div>
		        	<c:forEach var="aprLineList" items="${aprLineList}" varStatus="status">
			        	<div class="ui-field-contain">
			        		<div style="float:left;">
			        			<c:choose>
			        				<c:when test="${aprLineList.aprMemberPhoto != null}">
						        		<img src="/ezCommon/downloadAttach.do?filePath=${photoPath}/${aprLineList.aprMemberPhoto}" style="width: 50px; height: 60px;">
			        				</c:when>
			        				<c:otherwise>
						        		<img src="/images/OrganTree/porson_noimg.gif" style="width: 50px; height: 60px;">
			        				</c:otherwise>
			        			</c:choose>
			        		</div>
			        		<div style="float:left;">
				        		<h4>${aprLineList.aprMemberName} ${aprLineList.aprMemberJobTitle}(${aprLineList.aprMemberDeptName})</h4><br/>
				        		<h4>${aprLineList.receivedDate}</h4>
				        	</div>
			        		<div style="padding-top:15px; float:right;">
			        			<c:if test="${aprLineList.aprState == '001'}">
			        				대기
			        			</c:if>
			        			<c:if test="${aprLineList.aprState == '002'}">
			        				진행
			        			</c:if>
			        			<c:if test="${aprLineList.aprState == '003'}">
			        				승인
			        			</c:if>
			        			<c:if test="${aprLineList.aprState == '004'}">
			        				반송
			        			</c:if>
			        			<c:if test="${aprLineList.aprState == '005'}">
			        				보류
			        			</c:if>
			        			<c:if test="${aprLineList.aprState == '006'}">
			        				회수
			        			</c:if>
			        			<c:if test="${aprLineList.aprState == '010'}">
			        				완료
			        			</c:if>
				        	</div>
			        	</div>	
		        	</c:forEach>
		        	<div class="ui-field-contain">
		        	</div>
		        	<div class="ui-field-contain">
		        		<h1 style="text-align: center">본문</h1>
		        		<div style="overflow: auto;">${bodyHTML}</div>
		        	</div>
		      	</div>	
		      	<div class="writeButton" onclick="javascript:writeComment('${docID}', 1)"></div>										
     		</div>
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGPopup.jsp" />
     		<!-- layer Popup import -->
     	</section>
	</body>	
</html>