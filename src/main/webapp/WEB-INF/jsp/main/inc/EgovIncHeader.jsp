<%--
  Class Name : EgovIncHeader.jsp
  Description : 화면상단 Header(include)
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2011.08.31   JJY       경량환경 버전 생성
 
    author   : 실행환경개발팀 JJY
    since    : 2011.08.31 
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import ="egovframework.com.cmm.LoginVO" %>
<div id="skipNav" class="invisible">
    <dl>
        <dt>콘텐츠 바로가기</dt>
        <dd><a href="#main_container">컨텐츠 바로가기</a></dd>
        <dd><a href="#topnavi">메인메뉴 바로가기</a></dd>
    </dl>
</div>
<!-- 행정안전부 로고 및 타이틀 시작 -->
<div id="logoarea">
    <h1><a href="<c:url value='/cmm/main/mainPage.do' />"><img src="<c:url value='/images/kr/setting/logo.gif' />" alt="kaoni" height="30" /></a></h1>
</div>
<div id="project_title">
	<span class="maintitle">ezEKP </span>
	<strong>메인페이지 (임시) </strong>
	<a href="<c:url value='/EgovPageLink.do?link=main/sample_menu/Intro'/>" target="_blank"><img width="20" height="20" src="<c:url value='/images/question.jpg'/>" alt="메뉴구성 설명" title="메뉴구성 설명"></a>
</div>
<!-- //행정안전부 로고 및 타이틀 끝 -->
<div class="header_login">
	<c:if test="${empty(cookie.userID)}">    
	    <div id="header_loginname">
	        <a href="#" ></a>
	    </div>
	    <div class="header_loginconnection"></div>
	    <ul class="login_bg_area">
	        <li class="righttop_bgleft">&nbsp;</li>
	        <li class="righttop_bgmiddle"><a href="<c:url value='/uat/uia/login.do'/>">로그인</a></li>
	        <li class="righttop_bgright">&nbsp;</li>
	    </ul>
	</c:if>
	<c:if test="${!empty(cookie.userID)}">	    	    
	    <div id="header_loginname">
	        <a href="#LINK" onclick="alert('개인정보 확인 등의 링크 제공'); return false;"><c:out value="${cookie.userName.value}"/> 님</a>
	    </div>
	    <div class="header_loginconnection"> 로그인하셨습니다.</div>
	    <ul class="login_bg_area">
	        <li class="righttop_bgleft">&nbsp;</li>
	        <li class="righttop_bgmiddle"><a href="<c:url value='/uat/uia/actionLogout.do'/>">로그아웃</a></li>
	        <li class="righttop_bgright">&nbsp;</li>
	    </ul>
	</c:if>       
</div>