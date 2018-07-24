<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>"    type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"                type="text/css">
		<link rel="stylesheet" href="/css/jquery-ui.css"                        type="text/css"/>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css"/>
	</head>
	<body class="mainbody">
		<h1 id="cabInfo">
			<c:out value='${cabinet.cabinetName}'/>
			<span id="cabinetInfo" class="cabTtlInf"></span>
			<span class="topSearchSpan">
				<input name="searchCheck" id="radio1" type="radio" value="title" checked><label for="radio1">&nbsp;<spring:message code='ezCabinet.t51'/></label>
				<input name="searchCheck" id="radio2" type="radio" value="summary"      ><label for="radio2">&nbsp;<spring:message code='ezCabinet.t52'/></label>
				&nbsp;
				<input name="keyword" type="text" id="ssInput">
				<a id="searchBttn"><img src="/images/sub/bsearch.gif"></a>
			</span>
		</h1>
		
		<div id="mainmenu">
			<ul>
				<c:choose>
					<c:when test="${cabinet.permission == '2'}">
						<li id="addBttn"><a><span><spring:message code='ezCabinet.t45'/></span></a></li>
						<li><img src="/images/i_bar.gif"></li>
						<li id="delBttn"><a><span><spring:message code='ezCabinet.t46'/></span></a></li>
						<li id="movBttn"><a><span><spring:message code='ezCabinet.t47'/></span></a></li>
						<li><img src="/images/i_bar.gif"></li>
						<li id="refBttn"><a><span><spring:message code='ezCabinet.t48'/></span></a></li>
						<li id="schBttn"><a><span><spring:message code='ezCabinet.t49'/></span></a></li>
						<li><img src="/images/i_bar.gif"></li>
						<li id="shaBttn"><a><span><spring:message code='ezCabinet.t50'/></span></a></li>
					</c:when>
					<c:when test="${cabinet.permission == '1'}">
						<li id="addBttn"><a><span><spring:message code='ezCabinet.t45'/></span></a></li>
						<li><img src="/images/i_bar.gif"></li>
						<li id="delBttn"><a><span><spring:message code='ezCabinet.t46'/></span></a></li>
						<li id="movBttn"><a><span><spring:message code='ezCabinet.t47'/></span></a></li>
						<li><img src="/images/i_bar.gif"></li>
						<li id="refBttn"><a><span><spring:message code='ezCabinet.t48'/></span></a></li>
						<li id="schBttn"><a><span><spring:message code='ezCabinet.t49'/></span></a></li>
					</c:when>
					<c:otherwise>
						<li id="refBttn"><a><span><spring:message code='ezCabinet.t48'/></span></a></li>
						<li><img src="/images/i_bar.gif"></li>
						<li id="schBttn"><a><span><spring:message code='ezCabinet.t49'/></span></a></li>
					</c:otherwise>
				</c:choose>
				<li id="right">
					<img src="${config.previewMode == 'off' ? '/images/kr/cm/btn_onnoframe.gif'     : '/images/kr/cm/btn_noframe.gif'}"     class="btnimg cabinet" id="preViewNone"  >
					<img src="${config.previewMode == 'h'   ? '/images/kr/cm/btn_onbottomframe.gif' : '/images/kr/cm/btn_bottomframe.gif'}" class="btnimg cabinet" id="preViewBottom">
					<img src="${config.previewMode == 'w'   ? '/images/kr/cm/btn_onleftframe.gif'   : '/images/kr/cm/btn_leftframe.gif'}"   class="btnimg cabinet" id="preViewleft"  >
					<img src="/images/kr/cm/btn_arrow_down.gif" role="off" id="sltView">
				</li>
			</ul>
		</div>
		
		<div id="searchPanel" class="cabSearchPanel off">
			<div>
				<table class="content cabtable">
					<tr>
						<th class="layerHeader" colspan="2"><img src="/images/webfolder/left_webfolder.png">&nbsp;<spring:message code='ezCabinet.t54'/></th>
					</tr>
					<tr><td class="cabSearchTh2" colspan="2"></td></tr>
					<tr>
						<th class="cabSearchTh"><spring:message code='ezCabinet.t01'/></th>
						<td class="cabSearchTd">
							<div>
								<span id="cabinetName" class="cabSearchName"><c:out value='${cabinet.cabinetName}'/></span>
								<span class="searchDetail"><input type="checkbox" id="dCheckBox"><span><spring:message code='ezCabinet.t91'/></span></span>
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
				<div class="cabdivBttn" id="searchDivBttn">
					<a class="cabBttn"><span><spring:message code='ezCabinet.t59'/></span></a>
					<a class="cabBttn"><span><spring:message code='ezCabinet.t49'/></span></a>
					<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
				</div>
			</div>
			<span class="cabCloseBttn"></span>
		</div>
		
		<jsp:include page="/WEB-INF/jsp/ezCabinet/cabinetFileDelete.jsp"></jsp:include>
		<jsp:include page="/WEB-INF/jsp/ezCabinet/cabinetFileMove.jsp"  ></jsp:include>
		
		<div id="layerPopup" class="cabViewPopup" style="left: 0px; top: 0px; display: none;">
			<div class="popupwrap1">
				<div class="popupwrap2">
					<table class="list_element cabinet">
						<colgroup><col class="cabcol"><col></colgroup>
						<tr>
							<th class="cabTitle"><spring:message code='ezCabinet.t92'/></th>
							<td> 
								<select id="listcount">
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
		
		<div id="cabWraperDiv" style="height: 400px;">
			<div id="cabinetFileList" style="width: 100%; display: none;">
				<div>
					<table class="mainlist cabTbl" id="tblCabinetList">
						<tr>
							<th headers=""   class="inputTh"><input type="checkbox"></th>
							<th headers="it" class="typeTh" ><spring:message code='ezCabinet.t61'/></th>
							<th headers="tt" class="ttlTh"  ><spring:message code='ezCabinet.t62'/></th>
							<th headers="un" class="userTh" ><spring:message code='ezCabinet.t63'/></th>
							<th headers="cd" class="dateTh" ><spring:message code='ezCabinet.t64'/></th>
							<th headers="is" class="sizeTh" ><spring:message code='ezCabinet.t65'/></th>
						</tr>
					</table>
				</div>
				<div id="tblPageRayer" class="cabpagenaviDiv"></div>
			</div>
			
			<div id="previewCabH" class="cabDivPrevH" style="display: none;">
				<div id="preContentH" class="cabMainPrevH">
					<div>
						<div class="prevHeaderCabH" id="previewHeaderH">
							<span class="notSelected"><spring:message code='ezCabinet.t141'/></span>
						</div>
					</div>
				</div>
			</div>
			
			<div id="previewCabW" class="cabDivPrevW" style="display: none;">
				<div id="preContentW" class="cabMainPrevW">
					<div>
						<div class="prevHeaderCabW" id="previewHeaderW">
							<span class="notSelected"><spring:message code='ezCabinet.t141'/></span>
						</div>
					</div>
				</div>
			 </div>
		</div>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"                     ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="/js/jquery-ui/jquery-ui.js"             ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetPreview.js"        ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetNavi.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTable.js"          ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetItem.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript">
			CabinetItem.start("<c:out value='${cabinetId}'/>", "<c:out value='${config.contentHpercent}'/>", "<c:out value='${config.contentWpercent}'/>", "<c:out value='${config.previewMode}'/>");
		</script>
	</body>
</html>
