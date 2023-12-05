<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<title>::: ezEKP Java :::</title>
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
            document.getElementById("timer").innerHTML = minutes + ":" + seconds;
            // 상태 1초마다 확인, 서버부담 우려 시 2초로 수정 - 짝수일때 요청으로 수정하면 됨
            getFidoSessionStatus();

            if (count <= 0) {
                clearInterval(counter);
                document.getElementById("context").innerHTML = "인증요청 시간이 만료되었습니다.";
                document.getElementById("timer").innerHTML = "EXPIRED";
                // 상태 만료로 db 데이터 변경
                expireFidoSession();
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
   	        		console.log('fidoSession ok -' + result);
   	        	},
   	        	error : function(error){
   	        		console.log('fidoSession error -' + result);
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
   	        			document.getElementById("context").innerHTML = "2차 인증이 승인되었습니다.";
   	        			endGetStatus();
   	        			// 로그인
   	        			actionLogin();
   	        		} else if (result.indexOf("rejected") > -1) {
   	        			document.getElementById("context").innerHTML = "2차 인증을 거부하였습니다.";
   	        			endGetStatus();
   	        		} else if (result.indexOf("failed") > -1) {
   	        			document.getElementById("context").innerHTML = "2차 인증이 실패하였습니다.";
   	        			endGetStatus();
   	        		} 
   	        	},
   	        	error : function(error){
   	        		document.getElementById("context").innerHTML = "2차 인증이 실패하였습니다.";
   	        		endGetStatus()
   	        	}
   	        });
        }

        function endGetStatus() {
        	document.getElementById("timer").innerHTML = "";
   			clearInterval(counter);
        }
        
        function actionLogin() {
        	var frm = document.fidoForm;
			frm.action="<c:url value='/user/login/actionLogin.do'/>";        
			frm.submit();
        }
        
    </script>
</head>
	<body>
		<form style="display: inherit;" id="fidoForm" name="fidoForm" method="post">
			<p id="context"> 인증을 요청하고 있습니다.<br> 모바일 앱에서 확인해 주세요.</P>
			<p>제한시간</p>
			<p id="timer"></p>
			
			<input type="text" id="encryptID" name="encryptID" value="<c:out value='${encryptId}' />" />
			<input type="text" id="encryptPass" name="encryptPass" value="<c:out value='${encryptPassword}' />" />
			<input type="text" id="fidoSessionId" name="fidoSessionId" value="<c:out value='${fidoSessionId}' />" />
		</form>
	</body>
</html>
