<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:0%;">
	<head>
		<title><spring:message code="ezCar.shb05"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			var strBrd_ID = "${strBrdID}";
			var strOwnDeptID = "${ownDeptID}";
			var strOwnDeptNm = "${ownDeptNm}";
			var strOwnerID = "${ownerID}";
			var strOwnerNm = "${ownerNm}";
			var strOwnerPosition = "${ownerPosition}";
			var strOwnerCall = "${ownerCall}";
			var strMakeDate = "${makeDate}";
			var attachList1 = "${attachList1}";
			var car_nm = "${car_nm}";
			
			window.onload = function() {
				if(attachList1 != "") {
					document.getElementById("preview1").src = "/ezCar/getCarThumbnailInfo.do?fileName=" + encodeURIComponent(attachList1);
					document.getElementById("preview1").style.width = "119px";
					document.getElementById("preview1").style.height = "128px";
				}
			}
			
			function btnClose_Click(){
				window.close();
			}
		</script>
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
  			<tr>
    			<td height="20">
    				<h1><spring:message code="ezCar.shb05"/></h1>
      				<div id="close">
        				<ul>
          					<li><span onClick="btnClose_Click()"></span></li>
        				</ul>
      				</div>
      				<table class="content">
        				<tr>
        				<th> <spring:message code="ezResource.t153"/></th>
          					<td colspan="2"  name="Owner" idval="${ownerID}" nmval="${strBrdNm}">
								<c:forEach var="list"  items="${ownerList}" begin="0" varStatus="value">
									<c:if test ="${not value.last }">
										${list.displayName }, 
									</c:if>
									<c:if test ="${value.last }">
										${list.displayName }
									</c:if>
								</c:forEach>
							</td>
          					<%-- <th> <spring:message code="ezResource.t151"/></th>
          					<td name="OwnDept" idval="${ownDeptNm}">${ownDeptNm}</td> --%>
          					<%-- <th> <spring:message code="ezResource.t152"/></th>
          					<td id="MakeDate" style="padding-right:15px;width:120px" nowrap> ${makeDate}</td> --%>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t155"/></th>
          					<td colspan="2" name="OwnerCall" style="padding-right:15px;width:120px" nowrap> ${ownerCall}</td>
          					<%-- <th> <spring:message code="ezResource.rkms01"/></th>
          					<td colspan="3"  name="subOwner" idval="${ownerID}" nmval="${strBrdNm}">${ownerNm}(${ownerPosition}) </td>
          					<td colspan="3"  name="subOwner"  >
          					<div id="subOwner" style="overflow-y:auto; line-height:25px; height:25px;">
          					<c:if test="${!empty ownerList}" >
									<c:forEach var="list"  items="${ownerList}" begin="1" varStatus="value">
										<c:if test ="${not value.last }">
											${list.displayName }(${list.description }),  
										</c:if>
										<c:if test ="${value.last }">
											${list.displayName }(${list.description }) 
										</c:if>
									</c:forEach>
								</c:if>
							</div>
							</td> --%>
          					<%-- <th> <spring:message code="ezResource.t155"/></th>
          					<td name="OwnerCall" style="padding-right:15px;width:120px" nowrap> ${ownerCall}</td> --%>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezCar.shb03"/></th>
          					<td colspan="2" name="Brd_NM" idval="${strBrdID}"> ${strBrdNm} </td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezCar.shb04"/></th>
          					<td colspan="2" name="car_NM" idval="${car_nm}"> ${car_nm} </td>
        				</tr>
        				<tr>
          					<th style="height:128px;"><spring:message code="ezCar.shb75"/></th>
          					<td style="width:95%; border-right: 1" name="preview1"><img id="preview1" src="/images/default_pic.jpg" width="120" height="120" style="margin-left: auto; margin-right: auto; display: block; border-right: 1px;"></td>
        				</tr>
        				<br>
      				</table>
      			</td>
  			</tr>
		</table>
	</body>
</html>