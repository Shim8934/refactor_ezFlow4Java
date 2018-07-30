<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabRelatedFile">
		<h1><spring:message code="ezCabinet.t87"/></h1>
		
		<div id="cabRlClose" class="cabClose"><ul><li><span><spring:message code='ezCabinet.t66'/></span></li></ul></div>
		
		<div class="cabRlSearch">
			<div>
				<input id="ssInput" type="text" placeholder="<spring:message code='ezCabinet.t88'/>">
				<a id="searchBttn" class="cabBttn2"><span><spring:message code='ezCabinet.t49'/></span></a>
			</div>
		</div>
		<div class="cabRlMain">
			<div class="cabRlTreeMain">
				<div class="cabRlTreeDiv">
					<div id="cabinetTree" class="cbTree"></div>
				</div>
				<div class="cabRlSelect">
					<div class="rlSelectTtl"><div id="bnkDivMain"><spring:message code='ezCabinet.t89'/></div><div id="cabinetInfo"></div></div>
					<div class="rlSelectTblDiv">
						<table class="rlSelectTbl" id="tableFiles">
							<tr>
								<th class="thType"><spring:message code='ezCabinet.t61'/></th>
								<th><spring:message code='ezCabinet.t62'/></th>
							</tr>
							<tr>
								<td colspan="2" style="text-align: center; background-color: #fff;"><spring:message code='ezCabinet.err3'/></td>
							</tr>
						</table>
					</div>
					<div id="tblPageRayer" style="display: flex;"></div>
				</div>
			</div>
			<div class="cabRlBttnDiv">
				<div>
					<img id="addBttn"    src="/images/kr/cm/arr_right.gif">
					<img id="removeBttn" src="/images/kr/cm/arr_left.gif" >
				</div>
			</div>
			<div class="cabRlSelected">
				<div class="rlSelectTtl2"><spring:message code='ezCabinet.t90'/></div>
				<div class="rlSelectTblDiv">
					<table class="rlSelectTbl" id="selectedTable">
						<tr>
							<th class="thType"><spring:message code='ezCabinet.t61'/></th>
							<th><spring:message code='ezCabinet.t62'/></th>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		<div class="cabdivBttn" id="cabRlBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"         ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>" ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"            ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetNavi.js"            ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTable.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetRelateFileSelect.js"></script>
		<script type="text/javascript">CabinetRlFileSelect.init("<c:out value='${itemId}'/>")</script>
	</body>
</html>

