<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezSurvey.t34"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/survey.css')                 }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}   "></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }   "></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.ddslick.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')}              "></script>
	</head>
	
	<body class="mainbody srvey">
		<div class="surveyCrtTtl">
			<div class="sryFirst"></div>
			<div class="sryTxt"><spring:message code='ezSurvey.t34'/></div>
		</div>
		
		<div class="headpanel">
			<span class="crust selected">
				<a class="crumb"><span><spring:message code='ezSurvey.t35'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t36'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t37'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t77'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
		</div>
		
		<div id="bodyPanel">
			<div id="tab1" class="select-tab">
				<c:choose>
					<c:when test="${not empty survey}">
						<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyInfomationReuse.jsp"></jsp:include>
					</c:when>
					<c:otherwise>
						<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyInfomation.jsp"></jsp:include>
					</c:otherwise>
				</c:choose>
			</div>
			<div id="tab2" class="hidden-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/questionCreate.jsp"></jsp:include>
			</div>
			<div id="tab3" class="hidden-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/preview.jsp"></jsp:include>
			</div>
			<div id="tab4" class="hidden-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/previewSurvey.jsp"></jsp:include>
			</div>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/survey.js')} }"></script>
		<c:choose>
			<c:when test="${not empty survey}">
				<script type="text/javascript">SurveyCreate.start(${survey});</script>
			</c:when>
			<c:otherwise>
				<script type="text/javascript">SurveyCreate.start();</script>
			</c:otherwise>
		</c:choose>
		
	</body>
</html>


