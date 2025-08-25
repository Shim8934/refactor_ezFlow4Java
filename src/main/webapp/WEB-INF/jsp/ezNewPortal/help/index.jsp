<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/ezNewPortal/webguide.css')}">
<title><spring:message code='main.t00037' /></title>
	<script type="text/javascript">
		window.onload = function(){
			var helpMainUrl = "";

			if (packageType == "standard") {
				helpMainUrl = "/ezNewPortal/help/sub1-1.do";
			} else {
				helpMainUrl = "/ezNewPortal/help/sub2-1.do";
 			}
 			
			document.getElementById('content_frame').src = helpMainUrl;
		}
	</script>
</head>
<body>
	<header>
        <dl>
            <dt><span class="tit01">도움말안내</span></dt>
            <dd class="lng">
                <span class="kr">한국어</span><!-- <span class="us">영어</span><span class="jp">일본어</span><span class="cn">중국어</span> -->
            </dd>
            <!-- 사이트에 나가거나 빌드버전이 바뀐 경우 해당 버전을 변경 하셔야합니다. -->
            <dd class="ver"><span class="tit03">ezFlow v6.9.10.STD_20250630</span></dd>
            <!--<dd class="logo"></dd>-->
            <!-- <dd class="search">
                <input type="text" id="txt_Search" class="top_search" placeholder="통합검색" onkeydown="entercheck()">
                <span class="bnt_topsearch" onclick="Search_Integrate()" title="검색"><span class="icon_menu top_searchBtn"></span></span>
              </dd> -->
        </dl>
    </header>
    <aside class="leftmenu">
        <!-- menu start -->
        <c:set var = "packageType" value='${packageType}' />
       		<c:if test="${packageType == 'standard'}">
		        <h2 class="menu"><span>포탈</span></h2>
		        <ul class="submenu">
		            <li><a href="/ezNewPortal/help/sub1-1.do" target="content_frame">포탈설정</a></li>
		        </ul>
		    </c:if>
		        <h2 class="menu"><span>전자메일</span></h2>
		        <ul class="submenu">
		            <li><a href="/ezNewPortal/help/sub2-1.do" target="content_frame">메일작성</a></li>
					<li><a href="/ezNewPortal/help/sub2-2.do" target="content_frame">메일확인</a></li>
					<li><a href="/ezNewPortal/help/sub2-3.do" target="content_frame">메일환경설정</a></li>
		        </ul>
			<c:if test="${packageType == 'standard'}">	
		        <h2 class="menu"><span>전자결재</span></h2>
				<ul class="submenu">
		            <li><a href="/ezNewPortal/help/sub3-1.do" target="content_frame">기안작성</a></li>
					<li><a href="/ezNewPortal/help/sub3-2.do" target="content_frame">결재</a></li>
					<li><a href="/ezNewPortal/help/sub3-3.do" target="content_frame">결재환경설정</a></li>
		        </ul>
			</c:if>	
			<c:if test="${packageType != 'mail'}">
		        <h2 class="menu"><span>게시판</span></h2>
		        <ul class="submenu">
		            <li><a href="/ezNewPortal/help/sub4-1.do" target="content_frame">게시등록</a></li>
					<li><a href="/ezNewPortal/help/sub4-2.do" target="content_frame">게시읽기</a></li>
					<li><a href="/ezNewPortal/help/sub4-3.do" target="content_frame">게시판환경설정</a></li>
		        </ul>
				<h2 class="menu"><span>일정관리</span></h2>
		        <ul class="submenu">
		            <li><a href="/ezNewPortal/help/sub5-1.do" target="content_frame">일정등록</a></li>
					<li><a href="/ezNewPortal/help/sub5-2.do" target="content_frame">일정보기</a></li>
					<li><a href="/ezNewPortal/help/sub5-3.do" target="content_frame">일정환경설정</a></li>
		        </ul>
			</c:if>	
			<c:if test="${packageType == 'standard'}">
				<h2 class="menu"><span>자원관리</span></h2>
		        <ul class="submenu">
		            <li><a href="/ezNewPortal/help/sub6-1.do" target="content_frame">자원예약</a></li>
		        </ul>
			</c:if>
		<!--//menu end-->

    </aside>
    <script>
    	var packageType = "${packageType}";
        var acc = document.getElementsByClassName("menu");
        var i;

        for (i = 0; i < acc.length; i++) {
            acc[i].addEventListener("click", function () {
                this.classList.toggle("active");
                var submenu = this.nextElementSibling;
                if (submenu.style.display === "block") {
                    submenu.style.display = "none";
                } else {
                    submenu.style.display = "block";
                }
            });
        }
    </script>
	<div class="center" id="main_frame">
		<iframe src="about:blank" id="content_frame" name="content_frame"  frameborder="0" allowfullscreen></iframe>
	</div>
</body>
</html>