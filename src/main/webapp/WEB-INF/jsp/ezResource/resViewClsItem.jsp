<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t142"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
			var strBrd_ID = "${strBrdID}";
			var strOwnDeptID = "${ownDeptID}";
			var strOwnDeptNm = "${ownDeptNm}";
			var strOwnerID = "${ownerID}";
			var strOwnerNm = "${ownerNm}";
			var strOwnerPosition = "${ownerPosition}";
			var strOwnerCall = "${ownerCall}";
			var strMakeDate = "${makeDate}";
			
			function btnClose_Click(){
				window.close();
			}
		</script>
	</head>
	<body class="popup">
		<table class="layout">
  			<tr>
    			<td height="20">
    				<h1><spring:message code="ezResource.t142"/></h1>
      				<div id="close">
        				<ul>
          					<li><span onClick="btnClose_Click()"><spring:message code="ezResource.t150"/></span></li>
        				</ul>
      				</div>
      				<script type="text/javascript">
						selToggleList(document.getElementById("close"), "ul", "li", "0");
					</script>
      				<table class="content">
        				<tr>
          					<th> <spring:message code="ezResource.t151"/></th>
          					<td name="OwnDept" idval="${ownDeptNm}">${ownDeptNm}</td>
          					<th> <spring:message code="ezResource.t152"/></th>
          					<td id="MakeDate" style="padding-right:15px;width:120px" nowrap> ${makeDate}</td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t153"/></th>
          					<td name="Owner" idval="${ownerID}" nmval="${strBrdNm}">${ownerNm}(${ownerPosition}) </td>
          					<th> <spring:message code="ezResource.t155"/></th>
          					<td name="OwnerCall" style="padding-right:15px;width:120px" nowrap> ${ownerCall}</td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t39"/></th>
          					<td colspan="3" name="Brd_NM" idval="${strBrdID}"> ${strBrdNm} </td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t148"/></th>
          					<td colspan="3" name="ResLocation"> ${resLocation} </td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t149"/></th>
          					<td colspan="3">
								<c:if test="${approveFlag eq 1}">
									<spring:message code="ezResource.t161"/>
								</c:if>
								<c:if test="${approveFlag eq 2}">
									<spring:message code="ezResource.t162"/>
								</c:if>
          					</td>
        				</tr>
      				</table>
      				<br>
      				<h2><spring:message code="ezResource.t158"/></h2>
      			</td>
  			</tr>
  			<tr>
    			<td style="padding-bottom:1px"><textarea name="Brd_Explain" style="width:440; height: 1000; resize:none" readonly> ${brdExplain}</textarea></td>
  			</tr>
		</table>
	</body>
</html>