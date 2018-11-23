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
		<h1 id="cabInfo">
			<c:out value='${cabinet.cabinetName}'/>
			<span id="surveyInfo" class="surveyTtlInf"></span>
			<span class="topSearchSpan">
				<select id="searchCheck">
					<option value="title" selected><spring:message code='ezSurvey.t23'/></option>
					<option value="createuser"    ><spring:message code='ezSurvey.t24'/></option>
				</select>
				
				<input name="keyword" type="text" id="ssInput">
				<a id="searchBttn"><img src="/images/bsearch_new.gif"></a>
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
				<h1><spring:message code='ezSurvey.t25'/></h1>
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
				<br>
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
		
		<div id="cabWraperDiv" style="height: 400px;">
			<div id="surveyList" style="width: 100%; /* display: none; */">
				<div>
					<table class="mainlist surveyTbl" id="tblCabinetList">
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
				
				<div id="surveyListBody"></div>
				
				<div id="tblPageRayer"></div>
			</div>
			
			<div id="previewCabH" class="divPrevH" style="display: none;">
				<div id="preContentH" class="mainPrevH">
					<div>
						<div class="prevHeaderCabH" id="previewHeaderH">
							<span class="notSelected"><spring:message code='ezSurvey.t28'/></span>
						</div>
					</div>
				</div>
			</div>
			
			<div id="previewCabW" class="divPrevW" style="display: none;">
				<div id="preContentW" class="mainPrevW">
					<div>
						<div class="prevHeaderCabW" id="previewHeaderW">
							<span class="notSelected"><spring:message code='ezSurvey.t28'/></span>
						</div>
					</div>
				</div>
			 </div>
		</div>
		
		<div class="loadingPanel" id="mailPanel">&nbsp;</div>
		<div class="loadingProgress" id="MailProgress">
			<img src="/images/email/progress_img.gif">
			<div id="progressNum"></div>
		</div>
		
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')           }"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')             }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }"></script>
		<%-- <script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetPreview.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetNavi.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTable.js')  }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetItem.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTree.js')   }"></script> --%>
		<script type="text/javascript">
		
			var currPage = <c:out value="1" />;
			var pageChange = 1;
			var totalPage;
			var blockSize = 10;
		
			$(function () {
				$.datepicker.regional["<spring:message code='main.t0619' />"] = {
					closeText: "<spring:message code='main.t3' />",
					prevText: "<spring:message code='main.t0604' />",
					nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
					monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					           "<spring:message code='main.t0627' />"],
					dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                "<spring:message code='main.t0627' />"],
					dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					              "<spring:message code='main.t0627' />"],
					weekHeader: "Wk",
					dateFormat: "yy-mm-dd",
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: "show",
					showMonthAfterYear: true
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619'/>"]);
				
				getSurveyList();
				
				function getSurveyList() {
					$.ajax({
						dataType:"JSON",
						url : "/ezSurvey/getSurveyList.do",
						success : function(result) {
							console.log(result);
							
							var html = "";
							html += "<table class='mainlist surveyTbody'>";
							html += "<tbody>";
							
							$.each(result.surveyList, function(index, survey) {
								html += "<tr>"
								html += "<td class='inputTd'><input type='checkbox' id ='"+survey.survey_id+"'></td>";
								html += "<td class='inputTd'><img src='/images/newAttach.gif'></td>";
								html += "<td class='inputTd'><img src='/images/ImgIcon/view-importance.gif'> </td>";
								html += "<td class='ttlTd'>"+survey.title+"</td>";
								html += "<td class='endDateTd'>종료일</td>";

								if (survey.participate_flag == 0) {
									html += "<td class='targetTd'>전체</td>";
									
								} else {
									html += "<td class='targetTd'>선택</td>";
								}
								
								html += "<td class='createTd'>"+survey.user_id+"</td>";
								
								if (survey.result_public_flag == 0) {
									html += "<td class='publicTd'><img src='/images/ezSurvey/open.png'></td>";

								} else {
									html += "<td class='publicTd'><img src='/images/ezSurvey/lock.png'></td>";
								}
								
								if (survey.anonymous_flag == 0) {
									html += "<td class='anoynmTd'><img src='/images/ezSurvey/name.png'></td>";
									
								} else {
									html += "<td class='anoynmTd'><img src='/images/ezSurvey/anonymous.png'></td>";
								}
								html += "<td class='statisTd'><img src='/images/ezSurvey/analysis.png'></td>";
								html += "</tr>"
							});

							html += "</tbody>";
							html += "</table>";
							
							$("#surveyListBody").html(html);
							
							var totalPages = result.pagination.totalPages;
							
							makePageSelPage(totalPages);
						}
					});
					
				}
				
				// 페이징 처리
				function pageZeroCheck() {
					if(totalPage==0) {
						totalPage=1;
						currPage=1;
					}
				}
				
				function goToPageByNum(page) {
					pageChange = page;
					searchOption ='on';
					if (searchSelect !== '' && searchSelect !== 'none') {
						searchLadder();
					} else  {
						participant(modeCheck);
					}
					makePageSelPage();
				}
				
				function makePageSelPage(totalPages) {
					
					totalPage = totalPages;
					pageZeroCheck();
					var strtext = "";
					var PagingHTML = "<div class='pagenavi'>";
					var pageNum = currPage;

					document.getElementById("tblPageRayer").innerHTML = "";
					if(document.getElementById("mailBoxInfo") !== null) {
						document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang8
						+ "<span style='color:#017BEC;'> " + totalLadder + " </span>"
						+ strLang9 + "]";
					}

					if (totalPage > 1 && pageNum != 1) {
						strtext = "<span class='btnimg' onClick='goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif'></span>";
						PagingHTML += strtext;
					}

					if (totalPage > blockSize) {
						if (pageNum > blockSize) {
							strtext = "<span class='btnimg' onClick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif'></span>";
							PagingHTML += strtext;
						} else {
							strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif'></span>";
							PagingHTML += strtext;
						}
					} else {
						strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif'></span>";
						PagingHTML += strtext;
					}

					var MaxNum;
					var i;
					var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1;

					if (totalPage >= (startNum + parseInt(blockSize))) {
						MaxNum = (startNum + parseInt(blockSize)) - 1;
					} else {
						MaxNum = totalPage;
					}

					for (i = startNum; i <= MaxNum; i++) {
						if (i == pageNum) {
							strtext = "<span class='on'>" + i + "</span>";
							PagingHTML += strtext;
						} else {
							console.log("버튼 생성" + i);
							strtext = "<span onClick='goToPageByNum(" + i + ")'>" + i
									+ "</span>";
							PagingHTML += strtext;
						}
					}

					if (totalPage > blockSize) {
						if (totalPage >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
							strtext = "";
							strtext = strtext
									+ "<span class='btnimg' onClick='return selafterBlock()' ><img src='/images/sub/btn_next.gif'></span>";
							PagingHTML += strtext;
						} else {
							strtext = "";
							strtext = strtext
									+ "<span class='btnimg'><img src='/images/sub/btn_next01.gif'></span>";
							PagingHTML += strtext;
						}
					} else {
						strtext = ""; 
						strtext = strtext
								+ "<span class='btnimg'><img src='/images/sub/btn_next01.gif'></span>";
						PagingHTML += strtext;
					}

					if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
						strtext = "<span class='btnimg' onclick = 'goToPageByNum("
								+ totalPage
								+ ")'><img src='/images/sub/btn_n_next.gif'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif'></span>";
						PagingHTML += strtext;
					}

					PagingHTML += "</div>";
					td_Create1(PagingHTML);
				}

				function td_Create1(strtext) {
					document.getElementById("tblPageRayer").innerHTML = strtext;
				}

				function selbeforeBlock() {
					var pageNum = parseInt(currPage);
					if(pageNum%blockSize == 0) {
						pageNum = pageNum - blockSize;
					}
					pageNum = ((parseInt(pageNum / blockSize)) * blockSize);
					goToPageByNum(pageNum);
				}

				function selbeforeBlock_one() {
					var pageNum = parseInt(currPage);
					if (parseInt(pageNum - 1) > 0)
						goToPageByNum(parseInt(pageNum - 1));
					else
						return;
				}

				function selafterBlock() {
					var pageNum = parseInt(currPage);
					pageNum = ((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1;
					goToPageByNum(pageNum);
				}

				function selafterBlock_one() {
					var pageNum = parseInt(currPage);
					if (parseInt(pageNum + 1) <= totalPage)
						goToPageByNum(parseInt(pageNum + 1));
					else
						return;
				}

				
				
			});
			
			/* CabinetItem.start("<c:out value='${cabinetId}'/>", "<c:out value='${config.contentHpercent}'/>", "<c:out value='${config.contentWpercent}'/>", "<c:out value='${config.previewMode}'/>"); */
		</script>
	</body>
</html>
