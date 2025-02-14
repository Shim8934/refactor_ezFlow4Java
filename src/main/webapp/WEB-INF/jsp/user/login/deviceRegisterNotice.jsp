<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<title>::: ezFlow Java :::</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="../../css/fido.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	<script type="text/javascript">
        
        function goToLogin() {
        	// 로그인 페이지로 이동
			location.href = '/user/login/login.do';
        }
        
    </script>
</head>
	<body class="login_body">
		<div class="fido_wrap">
			<p class="logo"><img src="../../images/kr/login/logo_fido.svg"></p>
			<div class="fido">
				<form style="display: inherit;" id="fidoForm" name="fidoForm" method="post">
					<p class="txt">
	                    <span class="img"></span>
	                    <span id="context"><spring:message code='main.m001'/></span>
	                    <span id="context2" class="strong"><spring:message code='main.m002'/></span>
	                    <span id="context2" class="strong"><spring:message code='main.m003'/></span>
	                </p>
	                <div class="chkbutton">
	                    <span class="tit" onclick="goToLogin()"><spring:message code='main.t4008'/></span>
					</div>
				</form>
			</div>
		</div>
	</body>
</html>
