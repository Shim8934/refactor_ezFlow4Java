<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:95%;">
	<head>
		<title><spring:message code="ezResource.t142"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
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
			var attachList2 = "${attachList2}";
			
			window.onload = function() {
				if(attachList1 != "") {
					document.getElementById("preview1").src = "/ezResource/getResourceThumbnailInfo.do?fileName=" + encodeURIComponent(attachList1);
					document.getElementById("preview1").style.width = "200px";
					document.getElementById("preview1").style.height = "200px";
				}
				if(attachList2 != "") {
					document.getElementById("preview2").src = "/ezResource/getResourceThumbnailInfo.do?fileName=" + encodeURIComponent(attachList2);
					document.getElementById("preview2").style.width = "200px";
					document.getElementById("preview2").style.height = "200px";
				}
                window.addEventListener('resize', adjustTextareaHeight);
			}

			function adjustTextareaHeight() {
                var viewScale = window.devicePixelRatio;
                var windowHeight = window.innerHeight;
                if (viewScale < 0.9 || windowHeight > 700) {
                    var secondRowFirstTD = document.getElementById('secondRowFirstTd');
                    var newHeight = windowHeight - document.getElementById('firstRowFirstTrTable').offsetHeight - 125;
                    secondRowFirstTD.style.height = newHeight + 'px';
                } else {
                    var secondRowFirstTD = document.getElementById('secondRowFirstTd');
                    var newHeight = 183;
                    secondRowFirstTD.style.height = newHeight + 'px';
                }
            }

			function btnClose_Click() {
				if (!!opener && opener.location.href.includes("/ezNewPortal/")) {
					window.close();
				} else {
					parent.DivPopUpHidden();
					$(parent.parent.frames["left"].document.getElementById("blockLeft")).remove();
				}
			}
		</script>
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
  			<tr>
    			<td height="20">
    				<h1><spring:message code="ezResource.t142"/></h1>
      				<div id="close">
        				<ul>
          					<li><span onClick="btnClose_Click()"></span></li>
        				</ul>
      				</div>
      				<table id="firstRowFirstTrTable" class="content">
						<tr>
          					<th> <spring:message code="ezResource.t39"/></th>
          					<td colspan="2" name="Brd_NM" idval="${strBrdID}"> ${strBrdNm} </td>
        				</tr>
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
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t155"/></th>
          					<td colspan="2" name="OwnerCall" style="padding-right:15px;width:120px" nowrap> ${ownerCall}</td>
        				</tr>
        				<tr>
          					<th><spring:message code="ezResource.max.ygs02"/></th>
          					<td colspan="2" name="resMaxUserCnt"> ${resMaxUserCnt}<spring:message code="ezResource.max.ygs03"/> </td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t148"/></th>
          					<td colspan="2" name="ResLocation"> ${resLocation} </td>
        				</tr>
        				<tr>
          					<th><spring:message code="ezResource.max.ygs01"/></th>
          					<td colspan="2" name="resMaxDate"> ${resMaxDate}<c:if test="${not empty resMaxDate}"><spring:message code="ezResource.max.ygs04" /> </c:if></td>
        				</tr>
						<tr>
							<th> <spring:message code="ezResource.lyj01"/></th>
							<td colspan="3">
								<c:if test="${repeatFlag eq 1}">
									<spring:message code="ezResource.lyj02"/>
								</c:if>
								<c:if test="${repeatFlag eq 0}">
									<spring:message code="ezResource.lyj03"/>
								</c:if>
							</td>
						</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t149"/></th>
          					<td colspan="2">
								<c:if test="${approveFlag eq 1}">
									<spring:message code="ezResource.t161"/>
								</c:if>
								<c:if test="${approveFlag eq 0}">
									<spring:message code="ezResource.t162"/>
								</c:if>
								<c:if test="${approveFlag eq 2}">
									<spring:message code="ezSchedule.t404"/>
								</c:if>
          					</td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.kmsr11"/></th>
          					<td colspan="3">
								<c:if test="${returnFlag eq 0}">
									<spring:message code="ezResource.kmsr12"/>
								</c:if>
								<c:if test="${returnFlag eq 1}">
									<spring:message code="ezResource.kmsr13"/>
								</c:if>
          					</td>
        				</tr>
						<tr>
          					<th> <spring:message code='ezBoard.t5007'/></th>
          					<td colspan="3">${makeDate}</td>
        				</tr>
        				<tr>
          					<th style="height:200px;"><spring:message code="ezPortal.jjs03"/></th>
          					<td style="width:50%; border-right: 0" name="preview1"><img id="preview1" src="/images/default_pic.jpg" width="120" height="120" style="margin-left: auto; margin-right: auto; display: block; border-right: 0px;"></td>
          					<td style="border-left: 0" name="preview2"><img id="preview2" src="/images/default_pic.jpg" width="120" height="120" style="margin-left: auto; margin-right: auto; display: block; border-right: 0px;"></td>
        				</tr>
      				</table>
      				<br>
      				<h2 style="font-size:12px;margin-bottom:8px"><spring:message code="ezResource.t158"/></h2>
      			</td>
  			</tr>
  			<tr>
    			<td id="secondRowFirstTd" style="padding-bottom:1px; height: 100%; padding-right:12px">
    			    <textarea name="Brd_Explain" style="width:100%; height: 100%; resize:none" readonly><c:out value='${brdExplain}' /></textarea>
    			</td>
  			</tr>
		</table>
	</body>
</html>