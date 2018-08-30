<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<script type="text/javascript">
			function Img_OnClick() {
            	var pheight = window.screen.availHeight;
            	var pwidth = window.screen.availWidth;
            	var pTop = (pheight - 750) / 2;
            	var pLeft = (pwidth - 1000) / 2;

            	window.open("/ezPortal/help/help.do", "", "height=700px,width=1000px,top=" + pTop + ",left = " + pLeft + "status = no, toolbar=no, menubar=no, location=no, resizable=0");
        	}
		</script>
	</head>	
	<%-- <body  class="body_bg1">
    	<article class="gw_banner">
    		<img src="/images/<spring:message code='main.t00025' />/main/manual.gif" width="208" height="168" usemap="#Map_gwb" style="cursor:pointer" onclick="Img_OnClick()">
    			<map name="Map_gwb">
      				<area alt="" shape="rect" coords="252,8,344,47" href="#">
    			</map>
    	</article>
	</body> --%>
	<body>
		<div class="layDIV">
        	<span class="leftImg"><img src="/images/kr/main/bannerImg_left.png"></span>
            <dl class="bannerText">
            	<dt class="bText">그룹웨어 쉽게 활용하기</dt>
                <dt class="sText">그룹웨어 알아보기 등 활용도를<br>높일 수 있는 메뉴얼입니다.</dt>
                <dd class="bannerBtn" onclick="Img_OnClick()">자세히보기</dd>
            </dl>
            <span class="rightImg"><img src="/images/kr/main/bannerImg_right.png"></span>
        </div>
	</body>
</html>