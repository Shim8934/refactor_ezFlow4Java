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
		
		var count = Number("${timeLimit}")*60;
        var encryptId = "<c:out value='${encryptId}' />";
        var encryptPassword = "<c:out value='${encryptPassword}' />";
        var fidoSessionId = "<c:out value='${fidoSessionId}' />";
        var counter = null;
        
        window.onload = function () {
        	startTimer();
        }

        
        function startTimer() {
        	counter = setInterval(timer, 1000); // 1초에 한 번씩 timer 함수를 호출
        }

        function timer() {
            count--;
            var minutes = Math.floor(count / 60);
            var seconds = count - minutes * 60;
            document.getElementById("timer").innerHTML = minutes + "<spring:message code='main.fido008'/> " + seconds + "<spring:message code='main.fido009'/>";
            // 상태 1초마다 확인, 서버부담 우려 시 2초로 수정 - 짝수일때 요청으로 수정하면 됨
            getFidoSessionStatus();

            if (count <= 0) {
                clearInterval(counter);
                document.getElementById("context").innerHTML = ""
                document.getElementById("context2").innerHTML = "<spring:message code='main.fido002'/>";
                document.querySelector(".droplet_spinner").style.opacity = '0';
                
                // 상태 만료로 db 데이터 변경
                expireFidoSession();
                endGetStatus();
            }
        }
        
        // 만료 시 status 만료로 변경
        function expireFidoSession() {
			$.ajax({
   	        	type : "POST",
   	        	dataType : "text",
   	        	url : "/user/login/expireFidoSession.do",
   	        	data : {
   	        		"fidoSessionId" : fidoSessionId
   	        	},
   	        	success : function(result) {
   	        		console.log('fidoSession ok - ' + result);
   	        	},
   	        	error : function(error){
   	        		console.log('fidoSession error - ' + result);
   	        	}
        	});
        }

        // Check Status
        function getFidoSessionStatus() {
           	$.ajax({
   	        	type : "POST",
   	        	dataType : "text",
   	        	url : "/user/login/getFidoSessionStatus.do",
   	        	data : {
   	        		"fidoSessionId" : fidoSessionId
   	        	},
   	        	success : function(result) {
   	        		if (result.indexOf("requesting") > -1) {
   	        			// 가장 많은 응답일 것으로 예상되어 젤 위에 위치, 아무 동작도 하지 않음
   	        		} else if (result.indexOf("approved") > -1) {
   	        			document.getElementById("context2").innerHTML = "<spring:message code='main.fido003'/>";
   	        			endGetStatus();
   	        			// 로그인
   	        			actionLogin();
   	        		} else if (result.indexOf("rejected") > -1) {
   	        			document.getElementById("context2").innerHTML = "<spring:message code='main.fido004'/>";
   	        			endGetStatus();
   	        		} else if (result.indexOf("failed") > -1) {
   	        			document.getElementById("context2").innerHTML = "<spring:message code='main.fido005'/>";
   	        			endGetStatus();
   	        		} 
   	        	},
   	        	error : function(error){
   	        		document.getElementById("context2").innerHTML = "<spring:message code='main.fido005'/>";
   	        		endGetStatus()
   	        	}
   	        });
        }

        function endGetStatus() {
        	clearInterval(counter);
        	document.getElementById("context").innerHTML =  "";
        	document.querySelector(".droplet_spinner").style.opacity = '0';
        	document.getElementById("timer").innerHTML = "-";
        	
        	// 로그인 페이지로 보냄
        	setTimeout(function () { location.href = '/user/login/login.do' }, 2000); // 2초 후로 설정
        }
        
        function actionLogin() {
        	var frm = document.fidoForm;
			frm.action="<c:url value='/user/login/actionLogin.do'/>";        
			frm.submit();
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
	                    <span id="context"><spring:message code='main.fido006'/></span>
	                    <span id="context2" class="strong"><spring:message code='main.fido007'/></span>
	                </p>
	                <div class="droplet_spinner">
	                    <div class="droplet"></div>
	                    <div class="droplet"></div>
	                    <div class="droplet"></div>
	                    <div class="droplet"></div>
	                    <div class="droplet"></div>
	                </div>
	                <div class="timearea">
	                    <span class="tit"><spring:message code='main.fido001'/></span>
	                    <span class="num"id="timer"></span>
					</div>
					<input type="hidden" id="encryptID" name="encryptID" value="<c:out value='${encryptId}' />" />
					<input type="hidden" id="encryptPass" name="encryptPass" value="<c:out value='${encryptPassword}' />" />
					<input type="hidden" id="fidoSessionId" name="fidoSessionId" value="<c:out value='${fidoSessionId}' />" />
				</form>
			</div>
		</div>
	</body>
</html>
