<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t320'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezJournal.c1'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<style type="text/css">
			#tblPageRayer .pagenavi span{
				margin : 0px;
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
		  <h1><spring:message code='ezApprovalG.t1217'/></h1>
		  <div id="close">
		    <ul>
		      <li onClick="close_onclick()"><span><spring:message code='ezBoard.t12'/></span></li>
		    </ul>
		  </div>
		  <script type="text/javascript">
		  	selToggleList(document.getElementById("close"), "ul", "li", "0");
		  </script>
	        <div style="width:100%; height:305px" id="divList">
	            <table class="popuplist" style="width:100%; height: 100%;">
	            <c:choose>
		            <c:when test="${fn:length(viewerList) ne 0 }">
			            <c:forEach items="${viewerList }" var="viewer" varStatus="status">
							<tr userid="${viewer.userId }" onclick="show_info(this);" style="background-color: rgb(255, 255, 255);">
								<td align="left"
									style="width: 130px; text-align: center; cursor: pointer;">${viewer.userName }</td>
								<td align="left"
									style="width: 130px; text-align: center; cursor: pointer;">${viewer.deptName }</td>
								<td align="left"
									style="width: 130px; text-align: center; cursor: pointer;">${viewer.jikwi }</td>
								<td align="left"
									style="width: 130px; text-align: center; cursor: pointer;">${viewer.date }</td>
							</tr>
			            </c:forEach>
		            </c:when>
		            <c:otherwise>
		            	<tr style="background-color: rgb(255, 255, 255);">
							<td align="left" colspan="3"
								style="width: 130px; height:100%; text-align: center; cursor: pointer;"><spring:message code='ezBoard.kbm01'/></td>
						</tr>
		            </c:otherwise>
	            </c:choose>
			</table>
	        </div>
	        <div id='runtime' style="color:#666;padding-top:5px"></div>
	        <c:if test="${paging.endPage>0 }">
				<div id="tblPageRayer" style="width:470px; margin:6px auto;">
					<div class="pagenavi">   
						<c:choose>
								<c:when test="${paging.currentPage gt 1}">   
									<span onclick="goToPageByNum(1)" class="btnimg"><img src="/images/sub/btn_p_prev.gif" width="16" height="16"></span>            
								</c:when>
								<c:otherwise>
									<span class="btnimg"><img src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>            
								</c:otherwise>         
						</c:choose>
						<c:choose>
							<c:when test="${paging.startPage gt 1}">
								<span onclick="goToPageByNum(${paging.startPage-1})" class="btnimg"><img src="/images/sub/btn_prev.gif" width="16" height="16"></span>              
							</c:when>
							<c:otherwise>
								<span class="btnimg"><img src="/images/sub/btn_prev01.gif" width="16" height="16"></span>              
							</c:otherwise>                                                                    
						</c:choose>
						<span class="ptxt" onclick="<c:if test="${paging.currentPage gt 1 }">goToPageByNum(${paging.currentPage-1})</c:if>"><spring:message code='ezApproval.t931'/></span>                                   
						<c:forEach begin="0" end="${paging.endPage-paging.startPage }" varStatus="status">
							<c:choose>
								<c:when test="${paging.startPage+status.index eq  paging.currentPage}">
									<span class="on">${paging.currentPage }</span>
								</c:when>
								<c:otherwise>
									<span onclick="goToPageByNum(${paging.startPage+status.index})">${paging.startPage+status.index}</span>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<span class="ptxt" onclick="<c:if test="${paging.totalPage gt paging.currentPage }">goToPageByNum(${paging.currentPage+1})</c:if>"><spring:message code='ezApproval.t932'/></span>
						<c:choose>
							<c:when test="${paging.totalPage gt paging.endPage }">
								<span class="btnimg" onclick="goToPageByNum(${paging.endpage+1})"><img src="/images/sub/btn_next.gif" width="16" height="16"></span>
							</c:when>
							<c:otherwise>
								<span class="btnimg"><img src="/images/sub/btn_next01.gif" width="16" height="16"></span>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${paging.totalPage gt paging.currentPage }">
								<span class="btnimg" onclick="goToPageByNum(${paging.totalPage})"><img src="/images/sub/btn_n_next.gif" width="16" height="16"></span>
							</c:when>
							<c:otherwise>
								<span class="btnimg"><img src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</c:if>
		</form>
	</body>
</html>