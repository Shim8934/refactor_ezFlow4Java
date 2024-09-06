<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<!-- <meta http-equiv="content-language" content="ko"> -->
<title>ERROR</title>
    <style type="text/css">
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
	            <c:if test="${not empty messageContent}">
					${messageContent}	            
	            </c:if>
	            <c:if test="${empty messageContent}">
	                <spring:message code="main.t0634"/>
	            </c:if>
            </p>
        </div>
    </div>
</div>
<%--<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="100%" height="100%" align="center" valign="middle" style="padding-top:150px;"><table border="0" cellspacing="0" cellpadding="0">
      <tr>
<!--         <td><span style="font-family:Tahoma; font-weight:bold; color:#000000; line-height:150%; width:440px; height:70px;">오류발생 알림화면(허용되지 않는 요청을 하셨습니다)</span></td> -->
        <td><span style="font-family:Tahoma; font-weight:bold; color:#000000; line-height:150%; width:440px; height:70px;"><spring:message code="main.t0634"/></span></td>
      </tr>
    </table></td>
  </tr>
</table>--%>
</body>
</html>