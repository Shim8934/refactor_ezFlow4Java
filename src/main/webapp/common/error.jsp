<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<!-- <meta http-equiv="content-language" content="ko"> -->
<title>ERROR</title>

    <style>
        body, div, h2, ul, li, p{margin: 0; padding: 0;}

        ul{list-style: none;}
        img{border: 0 none;}

        .error_wrap{width: 100%;}
        .error_page{width: 580px; padding: 10px;position: absolute; top:50%; left: 50%; transform: translate(-50%, -50%)}

        .error_page .text_wrap{text-align:center; padding-top:50px; width: 100%; position: relative}
        .error_page .text_wrap .text{position:relative; font-size: 15px; font-weight: bold; color: #333; margin-top: 20px;}
    </style>
    
</head>
<body>
<div class="error_wrap">
    <div class="error_page">
        <div class='text_wrap'>
            <img src="/images/error_img.svg" width="90">
            <p class="text">
                <spring:message code="main.t0634"/>
            </p>
        </div>
    </div>
</div>
</body>
</html>