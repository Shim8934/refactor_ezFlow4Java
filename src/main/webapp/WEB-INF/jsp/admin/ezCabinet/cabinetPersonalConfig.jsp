<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil"                      %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, request, "<spring:message code='ezCabinet.css' />")%>" type="text/css">
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/jquery.lineProgressbar.css")%>" type="text/css" />
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezCabinet/cabinet.css")%>" type="text/css" />
	</head>
	<body class="mainbody notover">
		<h1><spring:message code='ezCabinet.t10'/><span id="cabinetTtlInf"></span></h1>
		<div class="cabiMain">
			<div class="compSelect" id="companySelect">
				<span><b><spring:message code='ezCabinet.t13'/></b></span>
				<select id="companyList">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div id="mainmenu">
				<ul>
					<li><a><span><spring:message code='ezCabinet.t48' /></span></a></li>
					<li><a><span><spring:message code='ezCabinet.t49' /></span></a></li>
					<li><a><span><spring:message code='ezCabinet.t112'/></span></a></li>
					<li id="right"><img src="/images/kr/cm/btn_arrow_down.gif" role="off" id="sltView"></li>
				</ul>
			</div>
			
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
			
			<jsp:include page="/WEB-INF/jsp/admin/ezCabinet/cabinetChange.jsp"></jsp:include>
			
			<div id="searchPanel" class="cabSearchPanel2 off">
				<div class="popup cabsearch">
					<h1><spring:message code='ezCabinet.t54'/></h1>
					<div id="cabSearchClose" class="cabClose"><ul><li><span></span></li></ul></div>
					<table class="content cabtable">
						<tr>
							<th class="cabSearchTh"><spring:message code='ezCabinet.t116'/></th>
							<td class="cabSearchTd2">
								<div>
									<select id="searchOption">
										<option value="userName"><spring:message code='ezCabinet.t117'/></option>
										<option value="deptName"><spring:message code='ezCabinet.t103'/></option>
									</select>
									<input id="inputSearch" type="text">
								</div>
							</td>
						</tr>
					</table>
					<br>
					<div class="cabdivBttn" id="searchDivBttn">
						<a class="cabBttn"><span><spring:message code='ezCabinet.t49'/></span></a>
						<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
					</div>
				</div>
			</div>
			
			<div id="mainSetting" class="userCapDiv" style="height: 500px;">
				<table class="mainlist cabTbl" id="userCapacityTbl">
					<tr>
						<th              class="checkBnk"        ><input type="checkbox"></th>
						<th headers="cn" class="cabTd8"          ><spring:message code='ezCabinet.t118'/></th>
						<th headers="dn" class="cabTd8"          ><spring:message code='ezCabinet.t103'/></th>
						<th headers="un" class="cabTd8"          ><spring:message code='ezCabinet.t117'/></th>
						<th headers="ut" class="cabTd6"          ><spring:message code='ezCabinet.t119'/></th>
						<th              class="cabTd7 cabCenter"><spring:message code='ezCabinet.t120'/></th>
						<th headers="tc" class="cabTd7 cabCenter"><spring:message code='ezCabinet.t121'/></th>
						<th headers="ct" class="cabTd8 cabCenter"><spring:message code='ezCabinet.t10' /></th>
						<th              class="cabTd8 cabCenter"><spring:message code='ezCabinet.t122'/></th>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="tblPageRayer"></div>
		
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, request, "<spring:message code='ezCabinet.lang' />")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/mouseeffect.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezCabinet/cabinetNavi.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezCabinet/cabinetTable.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezTask/jquery.lineProgressbar.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezCabinet/cabinetUserCapacity.js")%>"></script>
	</body>
</html>
