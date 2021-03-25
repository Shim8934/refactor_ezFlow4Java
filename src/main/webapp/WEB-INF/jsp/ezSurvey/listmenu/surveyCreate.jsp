<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezSurvey.t34"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1">
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/jquery.qtip.css')            }">
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}   "></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }   "></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.ddslick.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.qtip.js')}       "></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/cytoscape.min.js')}    "></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/dagre.js')}             "></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/cytoscape-dagre.js')}   "></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/cytoscape-qtip.js')}    "></script>
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')}              "></script>
	</head>
	
	<body class="mainbody srvey">
		<h1><spring:message code='ezSurvey.t34'/></h1>
		
		<div class="surveyBtn">
			<div class="headpanel">
				<span class="crust selected">
					<a class="crumb"><span class="crust_info"></span><span><spring:message code='ezSurvey.t35'/></span></a>
					<span class="arrow"><span></span></span>
				</span>
				<span class="crust">
					<a class="crumb"><span class="crust_write"></span><span><spring:message code='ezSurvey.t36'/></span></a>
					<span class="arrow"><span></span></span>
				</span>
				<span class="crust">
					<a class="crumb"><span class="crust_logic"></span><span><spring:message code='ezSurvey.t37'/></span></a>
					<span class="arrow"><span></span></span>
				</span>
				<span class="crust">
					<a class="crumb"><span class="crust_check"></span><span><spring:message code='ezSurvey.t77'/></span></a>
					<span class="arrow"><span></span></span>
				</span>
			</div>
			
			<div class="draft-survey" id="draftBttn"><span><spring:message code='ezSurvey.t111'/></span></div>
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
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyQuestion.jsp"></jsp:include>
			</div>
			<div id="tab3" class="hidden-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyLogic.jsp"></jsp:include>
			</div>
			<div id="tab4" class="hidden-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyPreview.jsp"></jsp:include>
			</div>
		</div>
		
		<div id="addURLPanel" class="searchPanel off">
			<div class="popupMenu searchDiv">
				<div class="srchTtl"><spring:message code='ezSurvey.t85'/></div>
				<div id="addUrlClose" class="closeImgBttn"><ul><li><span></span></li></ul></div>
				<table class="content searchtable">
					<tr>
						<th class="cabSearchTh"><spring:message code='ezSurvey.t82'/></th>
						<td class="searchTblTd"><input id="attfileName" type="text"></td>
					</tr>
					<tr>
						<th class="cabSearchTh"><spring:message code='ezSurvey.t83'/></th>
						<td class="searchTblTd"><input id="attfileUrl" type="text"></td>
					</tr>
				</table>
				<div class="srchBttnDiv" id="searchDivBttn">
					<a class="srchBttn" id="addUrlAttach"  ><span><spring:message code='ezSurvey.t84'/></span></a>
					<a class="srchBttn" id="removeUrlPopup"><span><spring:message code='ezSurvey.t18'/></span></a>
				</div>
			</div>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/survey.js'    )}"></script>
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


