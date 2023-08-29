<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body class="body_bg1">
		<c:choose>
			<c:when test="${usedTheme == 1 }">
			<article class="box_shadow">
				<div class="layDIV" id="helpDiv">
					<span class="leftImg"><img src="/images/ezNewPortal/bannerImg_left.png"></span>
					<dl class="bannerText sortablePortlet">
						<dt class="bText" style="margin-top: 2px"><spring:message code='ezNewPortal.t040' /></dt>
						<dt class="sText">
							<spring:message code='ezNewPortal.t041' /><br><spring:message code='ezNewPortal.t042' />
						</dt>
						<dd class="bannerBtn" id="helpDetail">
							<%--2023-08-29 민지수 - 다국어 버전 > 그룹웨어 영어매뉴얼 다운되도록 수정--%>
							<c:if test="${lang ne '2'}">
								<spring:message code='ezNewPortal.t043' />
							</c:if>
							<c:if test="${lang eq '2'}">
								<a href = "/files/QST User Guide.pptx" style="color: white"><spring:message code='ezNewPortal.t043' /></a>
							</c:if>
						</dd>
					</dl>
					<span class="rightImg"><img src="/images/ezNewPortal/bannerImg_right.png"></span>
				</div>
			</article>
			</c:when>
			<c:when test="${usedTheme == 3}">
				<article class="box_shadow groupware_banner">
					<div class="layDIV">
	                        <span class="leftImg"><img src="/images/ezNewPortal/theme3Img/bannerImg_left.png"></span>
	                        <div class="groupware_bannerWrap sortablePortlet">
	                            <dl class="bannerText">
	                                <dt class="bText"><spring:message code='ezNewPortal.t040' /></dt>
	                                <dt class="sText"><spring:message code='ezNewPortal.t041' /><br><spring:message code='ezNewPortal.t042' /></dt>
	                                <dd class="bannerBtn" id="helpDetail">
										<c:if test="${lang ne '2'}">
											<spring:message code='ezNewPortal.t043' />
										</c:if>
										<c:if test="${lang eq '2'}">
											<a href = "/files/QST User Guide.pptx" style="color: white"><spring:message code='ezNewPortal.t043' /></a>
										</c:if>
									</dd>
	                            </dl>
	                        </div>
	                	</div>
	            </article>
			</c:when>
			<c:otherwise>
				<article class="box_shadow">
				<div class="layDIV" id="helpDiv">
					<span class="leftImg"><img src="/images/ezNewPortal/bannerImg_left.png"></span>
					<dl class="bannerText sortablePortlet">
						<dt class="bText"><spring:message code='ezNewPortal.t040' /></dt>
						<dt class="sText">
							<spring:message code='ezNewPortal.t041' /><br><spring:message code='ezNewPortal.t042' />
						</dt>
						<dd class="bannerBtn" id="helpDetail">
							<c:if test="${lang ne '2'}">
								<spring:message code='ezNewPortal.t043' />
							</c:if>
							<c:if test="${lang eq '2'}">
								<a href = "/files/QST User Guide.pptx" style="color: white"><spring:message code='ezNewPortal.t043' /></a>
							</c:if>
						</dd>
					</dl>
					<span class="rightImg"><img src="/images/ezNewPortal/bannerImg_right.png"></span>
				</div>
				</article>
			</c:otherwise>
		</c:choose>
</body>
</html>