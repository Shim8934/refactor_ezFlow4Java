<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>redirect...</title>
</head>
<body>
<input type="hidden" id="redUrl" value="${redUrl}">
<script type="text/javascript">
    window.onload = function() {
        var redUrl = document.querySelector("#redUrl").value;
        window.open(redUrl, "_self");
    }
</script>
</body>
</html>