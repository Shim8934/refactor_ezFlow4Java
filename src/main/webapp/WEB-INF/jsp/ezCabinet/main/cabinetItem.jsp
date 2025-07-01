<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')               }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		<style>
			.cabPrevItemJP dd {
				padding: 0px 0px 2px 68px;
			}
		</style>
	</head>
	<body class="mainbody overY">
		<h1 id="cabInfo">
			<c:out value='${cabinet.cabinetName}'/>
			<span id="cabinetInfo" class="cabTtlInf"></span>
			<span class="searchForm">
				<select id="searchCheck" class="text">
					<option value="title" selected><spring:message code='ezCabinet.t51'/></option>
					<option value="summary"       ><spring:message code='ezCabinet.t52'/></option>
				</select>
				
				<input name="keyword" class="searchinputBox" type="text" id="ssInput">
				<a id="searchBttn" class="searchBtn nofilter"><img src="/images/bsearch_new2.png"></a>
			</span>
		</h1>
		
		<div id="mainmenu">
			<ul>
				<c:choose>
					<c:when test="${cabinet.permission == '2'}">
						<li id="addBttn" class="important"><a><span style="color: #0470e4;"><spring:message code='ezCabinet.t45'/></span></a></li>
						<li id="movBttn"><a><span><spring:message code='ezCabinet.t47'/></span></a></li>
						<li id="shaBttn"><a><span><spring:message code='ezCabinet.t50'/></span></a></li>
						<li id="schBttn"><a><span class="icon16 icon16_search"></span></a></li>
						<li id="delBttn"><a><span class="icon16 icon16_delete"></span></a></li>
						<li id="refBttn"><a><span class="icon16 icon16_refresh"></span></a></li>
					</c:when>
					<c:when test="${cabinet.permission == '1'}">
						<li id="addBttn" class="important"><a><span style="color: #0470e4;"><spring:message code='ezCabinet.t45'/></span></a></li>
						<li id="movBttn"><a><span><spring:message code='ezCabinet.t47'/></span></a></li>
						<li id="schBttn"><a><span class="icon16 icon16_search"></span></a></li>
						<li id="delBttn"><a><span class="icon16 icon16_delete"></span></a></li>
						<li id="refBttn"><a><span class="icon16 icon16_refresh"></span></a></li>
					</c:when>
					<c:otherwise>
						<li id="schBttn"><a><span class="icon16 icon16_search"></span></a></li>
						<li id="refBttn"><a><span class="icon16 icon16_refresh"></span></a></li>
					</c:otherwise>
				</c:choose>
				
				<div id="right" class="sub_frameIcon" style="float:right">
					<div class="sub_frameIconUL">
						<p class="frameIconLI"><span class="${config.previewMode == 'off' ? 'icon16 btn_onnoframe'     : 'icon16 btn_noframe'}"     id="preViewNone"  ></span></p>
						<p class="frameIconLI"><span class="${config.previewMode == 'h'   ? 'icon16 btn_onbottomframe' : 'icon16 btn_bottomframe'}" id="preViewBottom"></span></p>
						<p class="frameIconLI"><span class="${config.previewMode == 'w'   ? 'icon16 btn_onleftframe'   : 'icon16 btn_leftframe'}"   id="preViewleft"  ></span></p>
					</div>
					<div class="sub_frameIconUL02">
						<p class="frameIconLI"><span class="icon16 btn_arrow_down" role="off" id="sltView"></span></p>
					</div>
				</div>
			</ul>
		</div>
		
		<div id="searchPanel" class="cabSearchPanel off">
			<div class="popup cabsearch">
				<h1><spring:message code='ezCabinet.t54'/></h1>
				<div id="cabSearchClose" class="cabClose"><ul><li><span></span></li></ul></div>
				<table class="content cabtable">
					<tr>
						<th class="cabSearchTh"><spring:message code='ezCabinet.t01'/></th>
						<td class="cabSearchTd">
							<div>
								<span id="cabinetName" class="cabSearchName"><c:out value='${cabinet.cabinetName}'/></span>
								<span class="searchDetail"><div class="custom_checkbox"><input type="checkbox" id="dCheckBox"></div><span><spring:message code='ezCabinet.t91'/></span></span>
							</div>
						</td>
					</tr>
					<tr>
						<th class="cabSearchTh"><spring:message code='ezCabinet.t55'/></th>
						<td class="cabSearchTd"><input id="sUserName" type="text"></td>
					</tr>
					<tr>
						<th class="cabSearchTh"><spring:message code='ezCabinet.t56'/></th>
						<td class="cabSearchTd"><input id="sCabTitle" type="text"></td>
					</tr>
					<tr>
						<th class="cabSearchTh"><spring:message code='ezCabinet.t52'/></th>
						<td class="cabSearchTd"><input id="sCabSum" type="text"></td>
					</tr>
					<tr>
						<th class="cabSearchTh"><spring:message code='ezCabinet.t58'/></th>
						<td class="cabSearchTd"><input type="text" id="Sdatepicker" class="cabDate" readonly="readonly">&nbsp;~&nbsp;<input type="text" id="Edatepicker" class="cabDate" readonly="readonly"></td>
					</tr>
				</table>
				<br>
				<div class="cabdivBttn" id="searchDivBttn">
					<a class="cabBttn"><span><spring:message code='ezCabinet.t59'/></span></a>
					<a class="cabBttn"><span><spring:message code='ezCabinet.t49'/></span></a>
					<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
				</div>
			</div>
			<span class="cabCloseBttn"></span>
		</div>
		
		<c:if test="${cabinet.permission == '2' || cabinet.permission == '1'}">
			<jsp:include page="/WEB-INF/jsp/ezCabinet/item/cabinetFileMove.jsp"  ></jsp:include>
		</c:if>
		
		<div id="layerPopup" class="cabViewPopup" style="left: 0px; top: 0px; display: none;">
			<div class="popupwrap1">
				<div class="popupwrap2">
					<table class="list_element cabinet">
						<colgroup><col class="cabcol"><col></colgroup>
						<tr>
							<th class="cabTitle"><spring:message code='ezCabinet.t92'/></th>
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
			<div id="cabinetFileList" style="width: 100%; display: none;">
				<div>
					<table class="mainlist cabTbl" id="tblCabinetList">
						<tr>
							<th headers=""   class="inputTh"><div class="custom_checkbox"><input type="checkbox"></div></th>
							<th headers="it" class="typeTh" ><spring:message code='ezCabinet.t61'/></th>
							<th headers="tt" class="ttlTh"  ><spring:message code='ezCabinet.t62'/></th>
							<th headers="un" class="userTh" ><spring:message code='ezCabinet.t63'/></th>
							<th headers="cd" class="dateTh" ><spring:message code='ezCabinet.t64'/></th>
							<th headers="is" class="sizeTh" ><spring:message code='ezCabinet.t65'/></th>
						</tr>
					</table>
				</div>
				<div id="tblPageRayer"></div>
			</div>
			
			<div id="previewCabH" class="cabDivPrevH" style="display: none;">
				<div id="preContentH" class="cabMainPrevH">
					<div>
						<div class="prevHeaderCabH" id="previewHeaderH">
							<dl class="notSelected">
								<dt><img src="/images/kr/main/noData_sIcon.png"></dt>
								<dd><spring:message code='ezCabinet.t141'/></dd>
							</dl>
						</div>
					</div>
				</div>
			</div>
			
			<div id="previewCabW" class="cabDivPrevW" style="display: none;">
				<div id="preContentW" class="cabMainPrevW">
					<div>
						<div class="prevHeaderCabW" id="previewHeaderW">
							<dl class="notSelected">
								<dt><img src="/images/kr/main/noData_sIcon.png"></dt>
								<dd><spring:message code='ezCabinet.t141'/></dd>
							</dl>
						</div>
					</div>
				</div>
			 </div>
		</div>
		
		<!-- 2018-09-27 문성업 - 프로그래스바 추가 -->
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" >&nbsp;</div>
		<div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
			<img src="/images/email/progress_img.gif" style="padding-top:20px;">
			<div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
		</div>
		
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')			}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')             }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetPreview.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetNavi.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTable.js')  }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetItem.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTree.js')   }"></script>
		<script type="text/javascript">
			var lang = "<c:out value='${lang}'/>";
			// 자식창에서 공유자 리스트 받아옴.
			window.addEventListener('message', (event) => {
				if (event.data[0] === 'end') {
					var firstList = event.data[1]; // 최초 공유자 리스트
					var cabinetID = event.data[2];

					$.ajax({
						type: "POST",
						url: "/ezCabinet/saveShareUserList.do",
						data: {
							"cabinetId": cabinetID,
							"userList": JSON.stringify(firstList)
						},
						dataType: "JSON",
						async: false,
						success: function (data) {
						},
						error: function (error) {
						}
					});
				}
			});
		
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
			});
			
			CabinetItem.start("<c:out value='${cabinetId}'/>", "<c:out value='${config.contentHpercent}'/>", "<c:out value='${config.contentWpercent}'/>", "<c:out value='${config.previewMode}'/>");
		</script>
	</body>
</html>
