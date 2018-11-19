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
	<article class="community box_shadow">
		<div class="layDIV">
			<input type="hidden" id="CommuSize" value="${CommuSize}">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<c:out value="${portletName }" />
				</dt>
				<dd class="portletPlus" id="communityPlus">
					<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
				</dd>
			</dl>
			<div class="community_list">
				<c:choose>
					<c:when test="${fn:length(CommunityList) == 0 }">
						<ul class="portlet_list">
							<dl class="comListDL01">
								<dt class="comPic">
									<img src="/images/kr/main/comImg_none.png">
								</dt>
								<dd class="comTit_none">
									"<spring:message code='main.t00026' />"
								</dd>
							</dl>
							<dl class="comListDL02">
								<dt class="comPic">
									<img src="/images/kr/main/comImg_none.png">
								</dt>
								<dd class="comTit_none">
									"<spring:message code='main.t00026' />"
								</dd>
							</dl>
						</ul>
					</c:when>
					<c:when test="${fn:length(CommunityList) == 1 }">
						<c:forEach var="commu" begin="0" end="1" items="${CommunityList }"
							varStatus="i">
							<dl class="comListDL0${i.count}" data1="${commu.c_ClubNo}"
								style="cursor: pointer">
								<dt class="comPic">
									<span class="best"><img
										src="/images/kr/main/com_best.png"></span>
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
								<dd class="comTit">"<c:out value='${commu.c_ClubName }'/>"</dd>
								<dd class="comText"><c:out value='${commu.c_ClubDesc }'/></dd>
							</dl>
						</c:forEach>
						<dl class="comListDL02">
							<dt class="comPic">
								<img src="/images/kr/main/comImg_none.png">
							</dt>
							<dd class="comTit_none">
								"<spring:message code='main.t00026' />"
							</dd>
						</dl>
					</c:when>
					<c:otherwise>
						<c:forEach var="commu" begin="0" end="1" items="${CommunityList }"
							varStatus="i">
							<dl class="comListDL0${i.count}" data1="${commu.c_ClubNo}"
								style="cursor: pointer">
								<dt class="comPic">
									<c:if test="${i.count == 0}">
										<span class="best"><img
											src="/images/kr/main/com_best.png"></span>
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
								<dd class="comTit">"<c:out value='${commu.c_ClubName }'/>"</dd>
								<dd class="comText"><c:out value='${commu.c_ClubDesc }'/></dd>
							</dl>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</article>
</body>
</html>