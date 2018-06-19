<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
		<link rel="stylesheet" href="/css/Tab.css"                           type="text/css"/>
	</head>
	<body class="cabGeneral" style="margin-left: 10px; margin-right: 10px;">
		<br/>
		<h2><spring:message code="ezCabinet.t24"/></h2>
		
		<div align="center" style="width:677px;border:1px solid #d6d6d6;margin-top:5px">
			<div id="cabinetVolume" style="width:400px; height:200px;display: inline-block;"></div>
		</div>
		
		<span class="txt">▒&nbsp;<spring:message code="ezCabinet.t23"/></span>
		<br />
		<table class="content" style="width: 680px; margin-top: 5px">
			<tr>
				<th><spring:message code="ezWebFolder.t241" /></th>
				<td>
					<select id="listcount" name="pListCount" style="WIDTH: 100px">
						<option value='10' ${wfListConfig.envValue eq '10'? 'selected' : ''}>10</option>
						<option value='20' ${wfListConfig.envValue eq '20'? 'selected' : ''}>20</option>
						<option value='30' ${wfListConfig.envValue eq '30'? 'selected' : ''}>30</option>
						<option value='40' ${wfListConfig.envValue eq '40'? 'selected' : ''}>40</option>
						<option value='50' ${wfListConfig.envValue eq '50'? 'selected' : ''}>50</option>
					</select>
					<spring:message code="ezWebFolder.t138" />
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezEmail.t487'/></th>
				<td>
					<select id="PreviewMode" style="WIDTH: 100px" onchange="PrevieOption(this);">
							<option value="OFF" ${previewMode == 'OFF'? selected : ''}><spring:message code='ezEmail.t99000017'/></option>
							<option value="H"   ${previewMode == 'H'  ? selected : ''}><spring:message code='ezEmail.t99000018'/></option>
							<option value="W"   ${previewMode == 'W'  ? selected : ''}><spring:message code='ezEmail.t99000019'/></option>
					</select>
					<span id="PreviewHSizeDiv" <c:if test="${previewMode != 'H'}">style="display:none;"</c:if>>
						<spring:message code='ezEmail.t99000020' />
						<select id="HListUser" style="width: 50px;" onchange="HChange(this);">
								<c:forEach var="i" begin="39" end="74" step="1">
									<c:choose>
										<c:when test="${previewHListSize == i}">
											<option value="<c:out value='${i}'/>" selected><c:out value='${i}' /></option>
										</c:when>
										<c:otherwise>
											<option value="<c:out value='${i}'/>"><c:out value='${i}' /></option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select> <spring:message code='ezEmail.t99000021' /> 
						<select id="HPreUser" style="width: 50px;" onchange="HChange(this);">
								<c:forEach var="i" begin="26" end="61" step="1">
									<c:choose>
										<c:when test="${previewHContentSize == i}">
											<option value="<c:out value='${i}'/>" selected><c:out value='${i}' /></option>
										</c:when>
										<c:otherwise>
											<option value="<c:out value='${i}'/>"><c:out value='${i}' /></option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select>
					</span>
					<span id="PreviewWSizeDiv" <c:if test="${previewMode != 'W'}">style="display:none;"</c:if>>
						<spring:message code='ezEmail.t99000020' />
						<select id="WListUser" style="width: 50px;" onchange="WChange(this);">
							<c:forEach var="i" begin="24" end="65" step="1">
								<c:choose>
									<c:when test="${previewWListSize == i}">
										<option value="<c:out value='${i}'/>" selected><c:out value='${i}' /></option>
									</c:when>
									<c:otherwise>
										<option value="<c:out value='${i}'/>"><c:out value='${i}' /></option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
						<spring:message code='ezEmail.t99000021'/>
						<select id="WPreUser" style="width: 50px;" onchange="WChange(this);">
							<c:forEach var="i" begin="35" end="76" step="1">
								<c:choose>
									<c:when test="${previewWContentSize == i}">
										<option value="<c:out value='${i}'/>" selected><c:out value='${i}' /></option>
									</c:when>
									<c:otherwise>
										<option value="<c:out value='${i}'/>"><c:out value='${i}' /></option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
					</select>
				</span></td>
			</tr>
		</table>
		
	 	<br/>
	 	
		<div class="cabBttnDiv">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script src="/js/jquery/raphael.2.1.0.min.js"                       ></script>
		<script src="/js/jquery/justgage.1.0.1.min.js"                      ></script>
		
		<script type="text/javascript">
			(function() {
				var volumeDraw = null;
				
				init();
				
				function init() {
					document.onselectstart = function () { return false; };
					
					if (navigator.userAgent.indexOf('Firefox') != -1) {
						document.body.style.MozUserSelect    = 'none';
						document.body.style.WebkitUserSelect = 'none';
						document.body.style.khtmlUserSelect  = 'none';
						document.body.style.oUserSelect      = 'none';
						document.body.style.UserSelect       = 'none';
					}
					
					var buttons = document.querySelectorAll("a[class='imgbtn']");
					buttons[0].firstElementChild.onclick = function(e) {save();};
					buttons[1].firstElementChild.onclick = function(e) {cancel();};
					
					volumeDraw = new JustGage({
						id: "cabinetVolume",
						value: 0,
						min: 0,
						max: 100,
						showInnerShadow: true,
						levelColorsGradient : true
					});
					
					volumeDraw.refresh("45");
					volumeDraw.refreshtitle("총 450MB중 220MB(45%) 사용중입니다.");
				}
				
				function cancel() {
					document.getElementById("listcount").value = listCnt;
				}
				
				function save() {
					var listCount = document.getElementById("listcount").value;
					
					$.ajax({
						url : '',
						method : 'POST',
						dataType : 'JSON',
						data : {
							"listCount" : listCount
						} ,
						success : function(data, textStatus, jqXHR) {
							var result = data.resultValue;
							
							if (result == "ok") {
								alert('<spring:message code="ezWebFolder.t182"/>');
								listCnt = listCount;
							}
							else {
								alert('<spring:message code="ezWebFolder.t134"/>');
							}
						},
						error : function(error) {
							alert('Error: ' + error);
						}
					});
				}
			})();
		</script>
	</body>
</html>