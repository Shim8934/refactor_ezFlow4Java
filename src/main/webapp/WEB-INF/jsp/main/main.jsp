<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Language" content="ko" />
		<title>메인페이지</title>
		<link href="<c:url value='/'/>css/common.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
		<noscript>자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다.</noscript>	
		<!-- 전체 레이어 시작 -->		
		<div id="wrap">
			<!-- header 시작 -->
			<div id="header_mainsize">
			    <c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" />
			</div>
			<div id="topnavi">
			    <c:import url="/EgovPageLink.do?link=main/inc/EgovIncTopnav" />
			</div>		
			<!-- //header 끝 -->
			<!-- container 시작 -->
			<div id="main_container">
				<div class="lefttitle_image">
				    ${cookie.userName.value}<br/>
				    ${cookie.userID.value}
				</div>		
			</div>
			<!-- footer 시작 -->
			<div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div>
			<!-- //footer 끝 -->
		<!-- //전체 레이어 끝 -->
		</div>
	</body>
</html>

