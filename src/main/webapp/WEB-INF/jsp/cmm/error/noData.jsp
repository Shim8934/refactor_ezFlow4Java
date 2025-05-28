<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Title</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            background: #f8f8fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .wrapper > div {
            padding: 15px;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div><img src='/images/kr/main/noData_sIcon.png'></div>
    <div><spring:message code='ezNewPortal.t018' /></div>
</div>
<script type="text/javascript" >
    alert(<spring:message code='ezNewPortal.t018' />);
    window.close();
</script>
</body>
</html>
