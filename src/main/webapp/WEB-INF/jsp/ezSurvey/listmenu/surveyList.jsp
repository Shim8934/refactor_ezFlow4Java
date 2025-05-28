<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		<style>
        #ui-datepicker-div {
          width:195px;
        }
		
		.select_filter {
			float: left;
			margin-right: 3px;
		}
        </style>
	</head>
	<body class="mainbody overY">
		<h1>
			<c:out value='${pageName}'/>
			<span id="surveyInfo" class="surveyTtlInf"></span>
			<span class="topSearchSpan">
				<select id="searchCheck">
					<option value="title" selected><spring:message code='ezSurvey.t23'/></option>
					<option value="creator"       ><spring:message code='ezSurvey.t24'/></option>
				</select>
				
				<input name="keyword" type="text" id="ssInput" style="height: 27px !important;">
				<a id="searchBttnSp"><img src="/images/bsearch_new.gif"></a>
			</span>
		</h1>
		
		<div id="mainmenu">
			<ul>
				<c:choose>
					<c:when test="${mode != 'draft'}">
						<li id="modifyBttn"><a><span><spring:message code='ezSurvey.t78'/></span></a></li>
						<c:if test="${reuseFlag == 1}"><li id="reuseBttn" ><a><span><spring:message code='ezSurvey.t22'/></span></a></li></c:if>
						<li id="analysisBttn" class="analysisBttn2" ><a><span><spring:message code='ezSurvey.t110'/></span></a></li>
						<li id="searchBttn" class="searchBttn2"><a><span class="icon16 icon16_search switchIcon"></span><span class="iconTexts"><spring:message code='ezSurvey.t20'/></span></a></li>
						<li id="deleteBttn" class="deleteBttn2"><a><span class="icon16 icon16_delete switchIcon"></span><span class="iconTexts"><spring:message code='ezSurvey.t21'/></span></a></li>
						<div class="sub_frameIcon" style="float: right;">
                            <select name="filterStatus" id="filterStatus" class="select_filter"></select>
							<div class="sub_frameIconUL">
								<p class="frameIconLI"><span class="icon16 ${config.previewMode == 'off' ? 'btn_onnoframe'     : 'btn_noframe'}"     id="preViewNone"  ></span></p>
								<p class="frameIconLI"><span class="icon16 ${config.previewMode == 'h'   ? 'btn_onbottomframe' : 'btn_bottomframe'}" id="preViewBottom"></span></p>
								<p class="frameIconLI"><span class="icon16 ${config.previewMode == 'w'   ? 'btn_onleftframe'   : 'btn_leftframe'}"   id="preViewleft"  ></span></p>
							</div>
							<div class="sub_frameIconUL02">
								<p class="frameIconLI"><span role="off" class="icon16 btn_arrow_down" id="sltView"></span></p>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<li id="modifyBttn"><a><span><spring:message code='ezSurvey.t78'/></span></a></li>
						<li id="searchBttn" class="searchBttn2"><a><span class="icon16 icon16_search"></span></a></li>
						<li id="deleteBttn" class="deleteBttn2"><a><span class="icon16 icon16_delete"></span></a></li>
						<div class="sub_frameIcon" style="float: right;">
							<div class="sub_frameIconUL02">
								<p class="frameIconLI"><span role="off" class="icon16 btn_arrow_down" id="sltView"></span></p>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
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
		</div>
		
		<div id="layer_Viewpopup" class="viewPopupMain" style="left: 0px; top: 0px; display: none;">
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
				<div class="wraperTableDiv">
					<table class="mainlist surveyTbl" id="tblSurveyList">
						<tr>
							<th headers=""    class="inputTh"><input type="checkbox"></th>
							<th headers="at"  class="inputTh"><img src="/images/newAttach.gif"></th>
							<th headers="surveyId"  class="numTh"><spring:message code='ezSurvey.listHeader.pgb03'/></th>
							<th headers="tt"  class="ttlTh"    ><spring:message code='ezSurvey.t23'/></th>
<%--							<th headers="ct"  class="createTh" ><spring:message code='ezSurvey.t24'/></th>--%>
<%--							<th headers="cd"  class="endDateTh"><spring:message code='ezSurvey.t99'/></th>--%>
<%--							<th headers="ed"  class="endDateTh"><spring:message code='ezSurvey.t29'/></th>--%>
							<th headers="period"  class="endDateTh"><spring:message code='ezSurvey.t26'/></th>
<%--							<th headers="ut"  class="targetTh" ><spring:message code='ezSurvey.t30'/></th>--%>
<%--							<th headers="pl"  class="publicTh" ><spring:message code='ezSurvey.t31'/></th>--%>
<%--							<th headers="an"  class="anoynmTh" ><spring:message code='ezSurvey.t32'/></th>--%>
							<th headers="participants"    class="statusTh" ><spring:message code='ezSurvey.listHeader.pgb01'/></th>
							<th headers="participation"    class="statusTh" ><spring:message code='ezSurvey.listHeader.pgb02'/></th>
							<th headers=""    class="statusTh" ><spring:message code='ezSurvey.t81'/></th>
						</tr>
					</table>
				</div>
				
				<div id="tblPageRayer"></div>
			</div>
			
			<div id="previewH" class="divPrevH" style="display: none;">
				<div id="preContentH" class="mainPrevH">
					<div>
						<div class="prevHeaderH" id="previewHeaderH">
							<%-- <span class="notSelected"><spring:message code='ezSurvey.t28'/></span> --%>
							
							<div class="nodataDiv">
								<dl>
									<dt>
										<img src="/images/kr/main/noData_sIcon.png">
									</dt>
									<dd><spring:message code='ezSurvey.t28'/></dd>
								</dl>
							</div>
						</div>
						<div id="itemContentH" class="itemContentH">
							<iframe id="mainContentIframeH" class="pr-frame"></iframe>
						</div>
					</div>
				</div>
			</div>
			
			<div id="previewW" class="divPrevW" style="display: none;">
				<div id="preContentW" class="mainPrevW">
					<div>
						<div class="prevHeaderW" id="previewHeaderW">
							<%-- <span class="notSelected"><spring:message code='ezSurvey.t28'/></span> --%> 

							<div class="nodataDiv">
								<dl>
									<dt>
										<img src="/images/kr/main/noData_sIcon.png">
									</dt>
									<dd><spring:message code='ezSurvey.t28'/></dd>
								</dl>
							</div>
						</div>
						<div id="itemContentW" class="itemContentW">
							<iframe id="mainContentIframeW" class="pr-frame"></iframe>
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
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyPreview.js')  }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyNavi.js')     }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyTable.js')    }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyItem.js')     }"></script>
		<script type="text/javascript">
			SurveyItem.start("<c:out value='${config.contentHpercent}'/>", "<c:out value='${config.contentWpercent}'/>", "<c:out value='${config.previewMode}'/>", "<c:out value='${mode}'/>", "<c:out value='${user}'/>");
			window.onload = function () {
				<%-- 2024-07-23 김유진 - 설문작성/수정 중 목록으로 돌아올 시 설문작성/수정을 취소함 --%>
				if (window.parent.frames["left"].surveyId != -1 || window.parent.frames["left"].isInCreateSurvey == true) {
					if (window.parent.frames["left"].document.querySelector('.node_selected')) {
						document.getElementById("mainContentIframeW").src = "";
						document.getElementById("mainContentIframeH").src = "";
						window.parent.frames["left"].SurveyLeft.cancelSurvey(window.parent.frames["left"].document.querySelector('.node_selected').closest('li').id);
					}
				}

                var filterStatus = document.getElementById('filterStatus');
                var optionAll = document.createElement('option');
                optionAll.value = 'ALL';
                optionAll.innerText = "<spring:message code='ezSurvey.t81'/>";
                filterStatus.appendChild(optionAll);
                var optionTmp = document.createElement('option');
                optionTmp.value = 'TMP';
                optionTmp.innerText = SurveyMessages.strDraft;
                filterStatus.appendChild(optionTmp);
                var optionWait = document.createElement('option');
                optionWait.value = 'WAIT';
                optionWait.innerText = SurveyMessages.strWaiting;
                filterStatus.appendChild(optionWait);
                var optionIng = document.createElement('option');
                optionIng.value = 'ING';
                optionIng.innerText = SurveyMessages.strProcess;
                filterStatus.appendChild(optionIng);
                var optionEnd = document.createElement('option');
                optionEnd.value = 'END';
                optionEnd.innerText = SurveyMessages.strFinish;
                filterStatus.appendChild(optionEnd);
				SurveyItem.btnResize();
			}
			</script>
	</body>
</html>
