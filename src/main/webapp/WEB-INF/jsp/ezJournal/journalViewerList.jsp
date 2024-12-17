<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t203'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style type="text/css">
			.popuplist tr:nth-child(even) td{
				background-color : #f8f8fa;
			}
		</style>
		<script type="text/javascript">
		    window.onload = function () {
		    };
		    function show_info(elem) {
		    	var pUserID = $(elem).attr("userid");
		        GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID, "UserInfo", 420, 450, "NO");
		    }
		    function close_onclick() {
		    	parent.DivPopUpHidden();
		    }
		</script>
	</head>
	<body class="popup">
		<form method="post" >
		  <h1><spring:message code='ezJournal.t203'/></h1>
		  <div id="close">
		    <ul>
		      <li onClick="close_onclick()"><span></span></li>
		    </ul>
		  </div>		  
	      <div style="width:100%; height:305px" id="divList">
	            <c:choose>
		            <c:when test="${fn:length(viewerList) ne 0 }">
	            		<table class="popuplist" style="width:100%;">
				            <c:forEach items="${viewerList }" var="viewer" varStatus="status">
								<tr userid="${viewer.userId }" onclick="show_info(this);" style="background-color: rgb(255, 255, 255);">
									<td align="left" style="width: 130px; text-align: center; cursor: pointer;"><c:out value='${viewer.userName }'/></td>
									<td align="left" style="width: 120px; text-align: center; cursor: pointer;"><c:out value='${viewer.deptName }'/></td>
									<td align="left" style="width: 80px; text-align: center; cursor: pointer;"><c:out value='${viewer.jikwi }'/></td>
									<td align="left" style="width: 150px; text-align: center; cursor: pointer;"><c:out value='${fn:substring(viewer.date, 0, 16) }'/></td>
								</tr>
				            </c:forEach>
						</table>
		            </c:when>
		            <c:otherwise>
	            		<table class="popuplist" style="width:100%; height:100%;">
			            	<tr style="background-color: rgb(255, 255, 255);">
								<td align="left" colspan="3" style="height:100%; width: 130px; text-align: center; cursor: pointer;"><spring:message code='ezJournal.t205'/></td>
							</tr>
						</table>
		            </c:otherwise>
	            </c:choose>
	        </div>
	        <!-- <div id='runtime' style="color:#666;padding-top:5px"></div> -->
	       <c:choose>
			<c:when test="${paging.endPage>0 }">
				<div id="tblPageRayer" style="width:470px; height:24px; margin:6px auto; font-size:0">
					<div class="pagenavi">   
						<c:choose>
								<c:when test="${paging.currentPage gt 1}">   
									<span onclick="parent.journalViewerList(1)" class="btnimg first"></span>
								</c:when>
								<c:otherwise>
									<span class="btnimg first disabled"></span>
								</c:otherwise>         
						</c:choose>
						<c:choose>
							<c:when test="${paging.startPage gt 1}">
								<span onclick="parent.journalViewerList(${paging.startPage-1})" class="btnimg prev"></span>
							</c:when>
							<c:otherwise>
								<span class="btnimg prev disabled"></span>
							</c:otherwise>                                                                    
						</c:choose>
						<%-- <span class="ptxt" onclick="<c:if test="${paging.currentPage gt 1 }">parent.journalViewerList(${paging.currentPage-1})</c:if>"><spring:message code='ezApproval.t931'/></span> --%>                                   
						<c:forEach begin="0" end="${paging.endPage-paging.startPage }" varStatus="status">
							<c:choose>
								<c:when test="${paging.startPage+status.index eq  paging.currentPage}">
									<span class="on">${paging.currentPage }</span>
								</c:when>
								<c:otherwise>
									<span onclick="parent.journalViewerList(${paging.startPage+status.index})">${paging.startPage+status.index}</span>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<%-- <span class="ptxt" onclick="<c:if test="${paging.totalPage gt paging.currentPage }">parent.journalViewerList(${paging.currentPage+1})</c:if>"><spring:message code='ezApproval.t932'/></span> --%>
						<c:choose>
							<c:when test="${paging.totalPage gt paging.endPage }">
								<span class="btnimg next" onclick="parent.journalViewerList(${paging.endpage+1})"></span>
							</c:when>
							<c:otherwise>
								<span class="btnimg next disabled"></span>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${paging.totalPage gt paging.currentPage }">
								<span class="btnimg last" onclick="parent.journalViewerList(${paging.totalPage})"></span>
							</c:when>
							<c:otherwise>
								<span class="btnimg last disabled"></span>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</c:when>
			<c:otherwise>
			<div id="tblPageRayer" style="width:470px; height:24px; margin:6px auto; font-size:0">
				<div class="pagenavi">  
					<span class="btnimg first disabled"></span>
					<span class="btnimg prev disabled"></span>
					<%-- <span class="ptxt"> <spring:message code='ezApproval.t931'/></span> --%>  
					<span class="on">1</span> 
					<%-- <span class="ptxt"><spring:message code='ezApproval.t932'/></span> --%>
					<span class="btnimg next disabled"></span>
					<span class="btnimg last disabled"></span>
				</div>
			</div>
			</c:otherwise>
		</c:choose>
		</form>
	</body>
</html>