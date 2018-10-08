<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>help Portlet</title>
<script type="text/javascript">

var helpPortletLoadFunc = function () {

	var helpDetail = function () {
		var height = window.screen.availHeight;
		var width = window.screen.availWidth;
		var top = (height - 750) / 2;
		var left = (width - 1000) / 2;
		var url = '/ezPortal/help/help.do';
		var option = 'height=700px,width=1000px,top=' + top + ',left = ' + left + 'status = no, toolbar=no, menubar=no, location=no, resizable=0';
		
		window.open(url, "", option);
	}
		
	/* 이벤트 추가 */
	document.getElementById("helpDetail").addEventListener('click', helpDetail );	
}

// 즉시실행함수처럼 사용하기.
helpPortletLoadFunc();

</script>
</head>
<body class="body_bg1">
<div class="layDIV" id="helpDiv">
    <span class="leftImg"><img src="/images/ezNewPortal/bannerImg_left.png"></span>
    <dl class="bannerText">
	    <dt class="bText">그룹웨어 쉽게 활용하기</dt>
	    <dt class="sText">그룹웨어 알아보기 등 활용도를<br>높일 수 있는 메뉴얼입니다.</dt>
	    <dd class="bannerBtn" id="helpDetail">자세히보기</dd>
    </dl>
    <span class="rightImg"><img src="/images/ezNewPortal/bannerImg_right.png"></span>
</div>
</body>
</html>