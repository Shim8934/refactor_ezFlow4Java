<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<input type="hidden" id="userId" value="${userInfo.id}">
	<article class="community box_shadow">
		<div class="layDIV">
			<input type="hidden" id="CommuSize" value="${CommuSize}">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<c:out value="${portletName }" />
				</dt>
				<dd class="portletPlus plus" id="communityPlus"></dd>
			</dl>
			<div id="communityList" class="community_list portletPagingArea">
				<c:choose>
					<c:when test="${fn:length(CommunityList) == 0 }">
						<dl class="nodata">
							<dt>
								<img src="/images/kr/main/noData_sIcon.png">
							</dt>
							<dd>
								<spring:message code='ezNewPortal.t018' />
							</dd>
						</dl>
					</c:when>
					<c:otherwise>
						<c:forEach var="commu" items="${CommunityList }" varStatus="i">
							<dl class="comListDL0${i.count} communityPortletList" data-clubno="${commu.c_ClubNo}" style="cursor: pointer">
								<dt class="comPic">
									<c:if test="${i.count == 1}">
										<span class="best"><img src="/images/kr/main/com_best.png"></span>
									</c:if>
									<c:choose>
										<c:when
											test="${commu.c_Logo_Thumbnail == 'default_logo_type'}">
											<img src="/images/ezCommunity/logo/${commu.c_Logo_Thumbnail}">
										</c:when>
										<c:otherwise>
											<img
												src="/ezCommon/downloadAttach.do?filePath=${commuPath}/${commu.c_Logo_Thumbnail}">
										</c:otherwise>
									</c:choose>
								</dt>
								<dd class="comTit"><c:out value='${commu.c_ClubName }'/></dd>
								<dd class="comText"><c:out value='${commu.c_ClubDesc }'/></dd>
								<dd class="comPerson"><spring:message code="ezCommunity.t477"/> ${commu.c_memberCnt}<spring:message code="ezCommunity.t478"/></dd>
							</dl>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<%--	리스트 페이지 이동	--%>
		<c:choose>
			<c:when test="${fn:length(CommunityList) == 0 }">
				<div class="portletPageNav" style="display:none;">
			</c:when>
			<c:otherwise>
				<div class="portletPageNav">
			</c:otherwise>
		</c:choose>
			<span class="portlet_list_nav prev"></span>
			<span class="portlet_list_nav next"></span>
		</div>
	</article>
</body>
</html>