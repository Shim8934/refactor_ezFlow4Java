<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }" >
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/survey.css')                 }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
	</head>
	<body class="mainbody overY">
		<h1>
			<c:out value='${pageName}'/>
			<span id="surveyInfo" class="surveyTtlInf"></span>
			<span class="topSearchSpan">
				<select id="searchCheck">
					<option value="title" selected><spring:message code='ezSurvey.t23'/></option>
					<option value="createuser"    ><spring:message code='ezSurvey.t24'/></option>
				</select>
				
				<input name="keyword" type="text" id="ssInput">
				<a id="searchBttnSp"><img src="/images/bsearch_new.gif"></a>
			</span>
		</h1>
		
		<div id="mainmenu">
			<ul>
				<li id="createBttn"><a><span><spring:message code='ezSurvey.t19'/></span></a></li>
				<li id="searchBttn"><a><span><spring:message code='ezSurvey.t20'/></span></a></li>
				<li id="deleteBttn"><a><span><spring:message code='ezSurvey.t21'/></span></a></li>
				<li id="reuseBttn" ><a><span><spring:message code='ezSurvey.t22'/></span></a></li>
				
				<li id="right">
					<img src="${config.previewMode == 'off' ? '/images/kr/cm/btn_onnoframe.gif'     : '/images/kr/cm/btn_noframe.gif'}"     class="btnimg survey" id="preViewNone"  >
					<img src="${config.previewMode == 'h'   ? '/images/kr/cm/btn_onbottomframe.gif' : '/images/kr/cm/btn_bottomframe.gif'}" class="btnimg survey" id="preViewBottom">
					<img src="${config.previewMode == 'w'   ? '/images/kr/cm/btn_onleftframe.gif'   : '/images/kr/cm/btn_leftframe.gif'}"   class="btnimg survey" id="preViewleft"  >
					<img src="/images/kr/cm/btn_arrow_down.gif" role="off" id="sltView">
				</li>
			</ul>
		</div>
		
		<div id="searchPanel" class="searchPanel off">
			<div class="popupMenu searchDiv">
				<div class="srchTtl"><spring:message code='ezSurvey.t25'/></div>
				<div id="surveyClose" class="closeImgBttn"><ul><li><span></span></li></ul></div>
				<table class="content searchtable">
					<tr>
						<th class="cabSearchTh"><spring:message code='ezSurvey.t24'/></th>
						<td class="searchTblTd"><input id="sCreatedUser" type="text"></td>
					</tr>
					<tr>
						<th class="cabSearchTh"><spring:message code='ezSurvey.t23'/></th>
						<td class="searchTblTd"><input id="sSurveyTtl" type="text"></td>
					</tr>
					<tr>
						<th class="cabSearchTh"><spring:message code='ezSurvey.t26'/></th>
						<td class="searchTblTd"><input type="text" id="Sdatepicker" class="srchDate" readonly="readonly">&nbsp;~&nbsp;<input type="text" id="Edatepicker" class="srchDate" readonly="readonly"></td>
					</tr>
				</table>
				<div class="srchBttnDiv" id="searchDivBttn">
					<a class="srchBttn"><span><spring:message code='ezSurvey.t27'/></span></a>
					<a class="srchBttn"><span><spring:message code='ezSurvey.t20'/></span></a>
					<a class="srchBttn"><span><spring:message code='ezSurvey.t18'/></span></a>
				</div>
			</div>
			<span class="cabCloseBttn"></span>
		</div>
		
		<div id="layerPopup" class="viewPopupMain" style="left: 0px; top: 0px; display: none;">
			<div class="popupwrap1">
				<div class="popupwrap2">
					<table class="list_element survey">
						<colgroup><col class="surveycol"><col></colgroup>
						<tr>
							<th class="surveyTitle"><spring:message code='ezSurvey.t09'/></th>
							<td> 
								<select id="listcount">
									<option value="10" ${config.listCount == '10' ? 'selected' : ''}>10</option>
									<option value="20" ${config.listCount == '20' ? 'selected' : ''}>20</option>
									<option value="30" ${config.listCount == '30' ? 'selected' : ''}>30</option>
									<option value="40" ${config.listCount == '40' ? 'selected' : ''}>40</option>
									<option value="50" ${config.listCount == '50' ? 'selected' : ''}>50</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="shadow"></div>
		</div>
		
		<div id="wraperDiv" style="height: 400px;">
			<div id="surveyList" style="width: 100%; /* display: none; */">
				<div>
					<table class="mainlist surveyTbl" id="tblSurveyList">
						<tr>
							<th headers=""   class="inputTh"><input type="checkbox"></th>
							<th headers=""   class="inputTh"><img src="/images/newAttach.gif"></th>
							<th headers=""   class="inputTh"><img src="/images/ImgIcon/view-importance.gif"></th>
							<th headers="tt" class="ttlTh"    ><spring:message code='ezSurvey.t23'/></th>
							<th headers="it" class="endDateTh"><spring:message code='ezSurvey.t29'/></th>
							<th headers="un" class="targetTh" ><spring:message code='ezSurvey.t30'/></th>
							<th headers="cd" class="createTh" ><spring:message code='ezSurvey.t24'/></th>
							<th headers="is" class="publicTh" ><spring:message code='ezSurvey.t31'/></th>
							<th headers="is" class="anoynmTh" ><spring:message code='ezSurvey.t32'/></th>
							<th headers="is" class="statisTh" ><spring:message code='ezSurvey.t33'/></th>
							<%-- <th headers=""   class="inputTh"><input type="checkbox"></th>
							<th headers="it" class="typeTh" ><spring:message code='ezCabinet.t61'/></th>
							<th headers="tt" class="ttlTh"  ><spring:message code='ezCabinet.t62'/></th>
							<th headers="un" class="userTh" ><spring:message code='ezCabinet.t63'/></th>
							<th headers="cd" class="dateTh" ><spring:message code='ezCabinet.t64'/></th>
							<th headers="is" class="sizeTh" ><spring:message code='ezCabinet.t65'/></th> --%>
						</tr>
					</table>
				</div>
				
				<div id="tblPageRayer"></div>
			</div>
			
			<div id="previewH" class="divPrevH" style="display: none;">
				<div id="preContentH" class="mainPrevH">
					<div>
						<div class="prevHeaderH" id="previewHeaderH">
							<span class="notSelected"><spring:message code='ezSurvey.t28'/></span>
						</div>
					</div>
				</div>
			</div>
			
			<div id="previewW" class="divPrevW" style="display: none;">
				<div id="preContentW" class="mainPrevW">
					<div>
						<div class="prevHeaderW" id="previewHeaderW">
							<span class="notSelected"><spring:message code='ezSurvey.t28'/></span>
						</div>
					</div>
				</div>
			 </div>
		</div>
		
		<div class="loadingPanel" id="progressPanel">&nbsp;</div>
		<div class="loadingProgress" id="processImage">
			<img src="/images/email/progress_img.gif">
			<div id="progressNum"></div>
		</div>
		
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')           }"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')             }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyPreview.js')  }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyNavi.js')     }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyTable.js')    }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyItem.js')     }"></script>
		<script type="text/javascript">
			SurveyItem.start("<c:out value='${config.contentHpercent}'/>", "<c:out value='${config.contentWpercent}'/>", "<c:out value='${config.previewMode}'/>", "<c:out value='${mode}'/>");
			</script>
	</body>
</html>
