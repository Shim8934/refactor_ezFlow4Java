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
	<body>
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
						<div class="prevHeaderCabH">
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
						
						<iframe id="ifrmPreViewH" name="ifrmPreViewH" src="" class="cabIfrmPreview" style="width: 100%; height: 0px;"></iframe>
					</div>
				</div>
			</div>
			
			<div id="previewCabW" class="cabDivPrevW" style="display: none;">
				<div id="preContentW" class="cabMainPrevW">
					<div style="width: 100%;">
						<div class="prevHeaderCabW">
							<div id="previewHeaderW">
								<p class="cabPrevTitle">
									<span class="cabPrevIcon"></span>
									<span id="PreW_subject" class="cabTitleTxt">${cabinetId}</span>
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
						
						<iframe id="ifrmPreViewW" name="ifrmPreViewW" src="" class="cabIfrmPreview" style="width: 100%; height: 0px;"></iframe>
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
