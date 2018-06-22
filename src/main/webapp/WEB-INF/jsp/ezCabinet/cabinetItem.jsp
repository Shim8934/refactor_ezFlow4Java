<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
		<link rel="stylesheet" href="/css/jquery-ui.css"                     type="text/css">
	</head>
	<body class="mainbody">
		<h1>
			<%-- <spring:message code='ezWebFolder.t220'/>
			<span id="mailBoxInfo"></span> --%>
			<span class="topSearchSpan">
				<input name="searchCheck" id="radio1" type="radio" value="subject" checked><label for="radio1">&nbsp;<spring:message code='ezCabinet.t51'/></label>
				<input name="searchCheck" id="radio2" type="radio" value="title"          ><label for="radio2">&nbsp;<spring:message code='ezCabinet.t52'/></label>
				&nbsp;
				<input name="keyword" type="text" id="ssInput">
				<a id="searchBttn"><img src="/images/sub/bsearch.gif"></a>
			</span>
		</h1>
		
		<div id="mainmenu" style="position: relative;">
			<ul>
				<li><a><span><spring:message code='ezCabinet.t45'/></span></a></li>
				<li><img src="/images/i_bar.gif"></li>
				<li><a><span><spring:message code='ezCabinet.t46'/></span></a></li>
				<li><a><span><spring:message code='ezCabinet.t47'/></span></a></li>
				<li><img src="/images/i_bar.gif"></li>
				<li><a><span><spring:message code='ezCabinet.t48'/></span></a></li>
				<li><a><span><spring:message code='ezCabinet.t49'/></span></a></li>
				<li><img src="/images/i_bar.gif"></li>
				<li><a><span><spring:message code='ezCabinet.t50'/></span></a></li>
				<li id="right">
					<img src="/images/kr/cm/btn_noframe.gif"     class="btnimg cabinet" id="preViewNone"  >
					<img src="/images/kr/cm/btn_bottomframe.gif" class="btnimg cabinet" id="preViewBottom">
					<img src="/images/kr/cm/btn_leftframe.gif"   class="btnimg cabinet" id="preViewleft"  >
					<img src="/images/kr/cm/btn_arrow_up.gif"    role="off" id="sltView">
				</li>
			</ul>
		</div>
		
		<div id="searchPanel" class="wfSearchPanel" style="display:none;">
			<div style="margin: 20px;">
				<table class="content wftable">
					<tr>
						<th class="layerHeader" colspan="2"><img src="/images/webfolder/left_webfolder.png" style="vertical-align: middle;padding-bottom:1px" width="16px">&nbsp;<spring:message code='ezWebFolder.t22'/></th>
					</tr>
					<tr>
						<td class="wfSearchTh2" colspan="2"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t151'/></th>
						<td class="wfSearchTd"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">&nbsp;~&nbsp;<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t152'/></th>
						<td class="wfSearchTd"><input id="fileExtVal" type="text" style="height: 23px; width: 200px;"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t153'/></th>
						<td class="wfSearchTd"><input id="fileNameVal" type="text" style="height: 23px; width: 200px;"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t154'/></th>
						<td class="wfSearchTd"><input id="fileCreatorVal" type="text" style="height: 23px; width: 200px;"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t188'/></th>
						<td class="wfSearchTd">
							<select id="fileTypeVal">
								<option value="1" selected><spring:message code='ezWebFolder.t191'/></option>
								<option value="2"         ><spring:message code='ezWebFolder.t192'/></option>
								<option value="3"         ><spring:message code='ezWebFolder.t193'/></option>
								<option value="4"         ><spring:message code='ezWebFolder.t194'/></option>
								<option value="5"         ><spring:message code='ezWebFolder.t195'/></option>
								<option value="6"         ><spring:message code='ezWebFolder.t196'/></option>
								<option value="7"         ><spring:message code='ezWebFolder.t311'/></option>
							</select>
						</td>
					</tr>
				</table>
				<div class="wfdivBttn">
					<a class="webfolderBttn"><span><spring:message code='ezWebFolder.t123'/></span></a>
					<a class="webfolderBttn"><span><spring:message code='ezWebFolder.t112'/></span></a>
				</div>
			</div>
			<span class="wfCloseBttn"></span>
		</div>
		
		<div id="layer_popup" class="cabViewPopup" style="left: 0px; top: 0px; display: none;">
			<div class="popupwrap1">
				<div class="popupwrap2">
					<table class="list_element cabinet">
						<colgroup><col class="cabcol"><col></colgroup>
						<tr>
							<th class="cabTitle">리스트 개수</th>
							<td> 
								<select id="listcount" onchange="ListCount(this.value);">
									<option value="10" ${cabinetGeneral.listCount == '10' ? 'selected' : ''}>10</option>
									<option value="20" ${cabinetGeneral.listCount == '20' ? 'selected' : ''}>20</option>
									<option value="30" ${cabinetGeneral.listCount == '30' ? 'selected' : ''}>30</option>
									<option value="40" ${cabinetGeneral.listCount == '40' ? 'selected' : ''}>40</option>
									<option value="50" ${cabinetGeneral.listCount == '50' ? 'selected' : ''}>50</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="shadow"></div>
		</div>
		
		<div id="cabWraperDiv" style="height: 400px; display: flex;">
			<div id="cabinetFileList" style="width: 50%; height: 100%;">
				<table class="mainlist wftablefile" style="width: 100%; text-algin: center;" id="tblFileList">
					<tr>
						<th width="20px" ><input type="checkbox"></th>
						<th headers="ft" style="text-align: center; width: 20px;"><spring:message code='ezWebFolder.t188'/></th>
						<th headers="fn" style="width: 30%;"><spring:message code='ezWebFolder.t156'/></th>
						<th headers="fs" style="text-align: center; width: 6%;" ><spring:message code='ezWebFolder.t157'/></th>
						<th headers="un" style="width: 7%;"><spring:message code='ezWebFolder.t189'/></th>
						<th headers="cd" style="width: 10%;"><spring:message code='ezWebFolder.t190'/></th>
						<th headers="ud" style="width: 10%;"><spring:message code='ezWebFolder.t198'/></th>
						<th              style="width: 25%;"><spring:message code='ezWebFolder.t199'/></th>
						<th headers="dt" width="70px" style="text-align: center;"><spring:message code='ezWebFolder.t200'/></th>
					</tr>
					
				</table>
			</div>
			
			<div id="previewCabH" class="cabDivPrevH">
				<div id="preContentH" class="cabMainPrevH">
					<div>
						<div class="prevHeaderCab">
							<div id="preview_HeaderH">
								<p class="cabPrevTitle">
									<span class="cabPrevIcon"></span>
									<span id="PreH_subject" class="cabTitleTxt">회신: [부고] 솔루션1팀 이효민 대리 외조부상</span>
								</p>
								<span class="cabPreDate">2018-06-22 09:50</span>
								<dl class="cabPrevItem">
									<dt><spring:message code='ezCabinet.t53'/>:<span id="PreH_MailReceiver">응웬바오</span></dt>
								</dl>
							</div>
						</div>
						
						
						<iframe id="ifrmPreViewH" name="ifrmPreViewH" src="" style="height: 100%; width: 100%; border: 0px; display: inline-block;"></iframe>
					</div>
				</div>
			</div>
			
			<div id="previewCabW" class="cabDivPrevW" style="display: none;">
				<div id="preContentW" class="cabMainPrevW">
					<div style="width: 100%;">
						<div class="prevHeaderCab">
							<div id="Preview_HeaderW">
								<p class="cabPrevTitle">
									<span class="cabPrevIcon"></span>
									<span id="PreW_subject" class="cabTitleTxt">회신: [부고] 솔루션1팀 이효민 대리 외조부상</span>
								</p>
								<span class="cabPreDate">2018-06-22 09:50</span>
								<dl class="cabPrevItem">
									<dt>
										<spring:message code='ezBoard.t223'/>:
										<span id="PreW_MailReceiver"></span>
									</dt>
								</dl>
							</div>
						</div>
						
						<iframe id="ifrmPreViewW" name="ifrmPreViewW" src="<spring:message code='main.kms4' />" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
					</div>
				</div>
			 </div>
		</div>
		
		<div id="tblPageRayer"></div>
		<script type="text/javascript" src="/js/mouseeffect.js"             ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery-ui/jquery-ui.min.js" ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetPreview.js"></script>
		<script type="text/javascript">
			(function() {
				/* Only for test */
				var cabinetPreview = null;
				
				setData(30, 70, 40, 60);
				window.addEventListener("resize", function(e) {cabinetPreview.resizeByWidth();}, false);
				
				function setData(minWPercent, maxWPercent, minHPercent, maxHPercent) {
					var cabinetGeneral = {
						minWidth  : minWPercent,
						maxWidth  : maxWPercent,
						minHeight : minHPercent,
						maxHeight : maxHPercent
					};
					
					cabinetPreview = new CabinetPreview({
						percent     : cabinetGeneral,
						prevDivH    : "previewCabH",
						prevDivW    : "previewCabW",
						tableId     : "cabinetFileList",
						wraperId    : "cabWraperDiv",
						preContentH : "preContentH",
						preContentW : "preContentW"
					});
					
					cabinetPreview.resizeByWidth();
				}
				
				/* Only for test end */
				
				var crrPreMode = null;
				window.addEventListener("resize", function(e) {windowResize();}, false);
				
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
				initEvents();
				
				function windowResize() {
					closeViewPopUp();
				}
				
				function initEvents() {
					var sSearchInputElmt = document.getElementById("ssInput");
					sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
					sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
					
					var searchBttnElmt = document.getElementById("searchBttn");
					searchBttnElmt.addEventListener("click", function(e) {startSimpleSearch();}, false);
					
					var preViewNoneElmt   = document.getElementById("preViewNone");
					var preViewBottomElmt = document.getElementById("preViewBottom");
					var preViewleftElmt   = document.getElementById("preViewleft");
					var optionViewElmt    = document.getElementById("sltView");
					
					preViewNoneElmt.addEventListener("click", function(e) {changePreview("None");}, false);
					preViewBottomElmt.addEventListener("click", function(e) {changePreview("W");}, false);
					preViewleftElmt.addEventListener("click", function(e) {changePreview("H");}, false);
					optionViewElmt.addEventListener("click", function(e) {toggleOptionView(this);}, false);
				}
				
				function onStartSimpleSearch(event) {if(event.keyCode == "13") {startSimpleSearch();}}
				
				function startSimpleSearch() {
					
				}
				
				function clearKeyword(inputElmt) {inputElmt.value = "";}
				
				function changePreview(mode) {
					if (mode == crrPreMode) {return;}
					
					switch(mode) {
						case "None":
							document.getElementById("previewCabH").style.display = "none";
							document.getElementById("previewCabW").style.display = "none";
							cabinetPreview.resizeDestroy();
							break;
						case "W":
							document.getElementById("previewCabH").style.display = "none";
							document.getElementById("previewCabW").style.display = "";
							cabinetPreview.resizeByWidth();
							break;
						case "H":
							document.getElementById("previewCabH").style.display = "";
							document.getElementById("previewCabW").style.display = "none";
							cabinetPreview.resizeByHeight();
							break;
						default:
							return;
					}
				}
				
				function toggleOptionView(optElmt) {
					if (optElmt.getAttribute("role") == "off") {showViewPopUp();} else {closeViewPopUp();}
				}
				
				function showViewPopUp() {
					var optElmt             = document.getElementById("sltView");
					var viewPopup           = document.getElementById("layer_popup");
					viewPopup.style.left    = document.documentElement.clientWidth - 160 + "px";
					viewPopup.style.top     = "100px";
					viewPopup.style.display = "";
					optElmt.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
					optElmt.setAttribute("role", "on");
				}
				
				function closeViewPopUp() {
					var optElmt = document.getElementById("sltView");
					document.getElementById("layer_popup").style.display = "none";
					optElmt.setAttribute("role", "off");
					optElmt.setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
				}
			})();
		</script>
	</body>
</html>
