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
        try { 
            var heigth = window.screen.availHeight; 
            var width = window.screen.availWidth; 
 
            var left = 0; 
            var top = 0; 
 
            if (window.screen.width > 800) { 
                var pleftpos; 
 
                pleftpos = parseInt(width) - 1150; 
                heigth = parseInt(heigth) - 25; 
 
                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) 
                    heigth = parseInt(heigth) - 40; 
 
                width = parseInt(width) - pleftpos; 
 
                left = pleftpos / 2; 
            } 
            else { 
 
                heigth = parseInt(heigth) - 25; 
 
                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) 
                    heigth = parseInt(heigth) - 40; 
 
                width = parseInt(width) - 10; 
            } 
 
window.open(redUrl, "_blank", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left); 
window.close();

        }catch (e) { 
        } 
 
        window.close(); 
    } 
</script> 
</body> 
</html>