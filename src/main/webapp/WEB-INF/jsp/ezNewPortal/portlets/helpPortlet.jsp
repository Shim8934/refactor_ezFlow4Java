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
						<dt class="bText">그룹웨어 쉽게 활용하기</dt>
						<dt class="sText">
							그룹웨어 알아보기 등 활용도를<br>높일 수 있는 메뉴얼입니다.
						</dt>
						<dd class="bannerBtn" id="helpDetail">자세히보기</dd>
					</dl>
					<span class="rightImg"><img src="/images/ezNewPortal/bannerImg_right.png"></span>
				</div>
			</article>
			</c:when>
			<c:when test="${usedTheme == 3}">
				<article class="box_shadow groupware_banner">
					<div class="layDIV">
	                        <span class="leftImg"><img src="/images/ezNewPortal/theme3Img/bannerImg_left.png"></span>
	                        <div class="groupware_bannerWrap">
	                            <dl class="bannerText">
	                                <dt class="bText">그룹웨어 쉽게 활용하기</dt>
	                                <dt class="sText">그룹웨어 알아보기 등 활용도를<br>높일 수 있는 메뉴얼입니다.</dt>
	                                <dd class="bannerBtn" id="helpDetail">자세히보기</dd>
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
						<dt class="bText">그룹웨어 쉽게 활용하기</dt>
						<dt class="sText">
							그룹웨어 알아보기 등 활용도를<br>높일 수 있는 메뉴얼입니다.
						</dt>
						<dd class="bannerBtn" id="helpDetail">자세히보기</dd>
					</dl>
					<span class="rightImg"><img src="/images/ezNewPortal/bannerImg_right.png"></span>
				</div>
				</article>
			</c:otherwise>
		</c:choose>
</body>
</html>