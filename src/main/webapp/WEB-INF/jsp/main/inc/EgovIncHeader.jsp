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
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="egovframework.let.user.login.vo.LoginVO" %>
<%@ page import="java.net.URLDecoder" %>
<%	
	String userName = "";

	if(request.getCookies()!=null){				
		Cookie[] cookies = request.getCookies();		    	
    	
   		for (Cookie cookie : cookies) {
   			if(cookie.getName().equals("userName")){
   				userName = URLDecoder.decode(cookie.getValue(), "utf-8");	
   			}
   	    }		    	
    }
%>
<!-- 로고 및 타이틀 시작 -->
<div id="logoarea">
    <h1><a href="<c:url value='/cmm/main/mainPage.do' />"><img src="<c:url value='/images/kr/setting/logo.gif' />" alt="kaoni" height="30" /></a></h1>
</div>
<div id="project_title">
	<span class="maintitle">ezEKP</span>
	<strong>메인페이지 (임시)</strong>	
</div>
<!-- //로고 및 타이틀 끝 -->
<div class="header_login">			    	    
    <div id="header_loginname">
        <a href="#LINK" onclick="alert('개인정보 확인 등의 링크 제공'); return false;"><c:out value="<%= userName %>"/> 님</a>
    </div>
    <div class="header_loginconnection"> 로그인하셨습니다.</div>
    <ul class="login_bg_area">
        <li class="righttop_bgleft">&nbsp;</li>
        <li class="righttop_bgmiddle"><a href="<c:url value='/user/login/actionLogout.do'/>">로그아웃</a></li>
        <li class="righttop_bgright">&nbsp;</li>
    </ul>	
</div>