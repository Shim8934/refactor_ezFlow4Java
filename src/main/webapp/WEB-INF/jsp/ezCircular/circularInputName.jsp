<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>회람문서함 추가/수정</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/ecmascript">
	        var ReturnFunction;
	        var CancelFunction;
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        
	        function window_onload() {
	            var InputValue;
	            
                ReturnFunction = parent.inputNameDlg_cross_dialogArguments[0];
                CancelFunction = parent.inputNameDlg_cross_dialogArguments[1];
                InputValue = parent.inputNameDlg_cross_dialogArguments[2];
                
	            if (InputValue != "") {
	                txt_FolderName.value = InputValue;
	            }

                txt_FolderName.focus();
                
                var ua = navigator.userAgent;
                
                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
                    KeEventControl(document.getElementById("txt_FolderName"));
                }
	        }
	        
	        function btn_ok_onclick() {
	            var folderName = txt_FolderName.value;
	            
				$.ajax({
					method : "POST",
					dataType : "text",
					async : false,
					url : "/ezCircular/circularFolderAdd.do",
					data : {
						folderName : folderName
					},
					success : function() {
						ReturnFunction();
					},
					error : function() {
						alert("에러 발생");	
					}
				})
	        }
	        
	        function btn_cancel_onclick() {
	            CancelFunction();
	        }
	        
	        function folderName_onkeydown() {
	            if (event.keyCode == 13)
	                btn_ok_onclick();
	        }
	    </script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
	    <h1>회람문서함 추가/수정</h1>
	    <div class="txt">회람문서함 이름을 입력하세요.</div>
	    <div class="nobox">
	        <input id="txt_FolderName" type="text" onkeydown="folderName_onkeydown()" style="width: 100%" maxlength="8">
	    </div>
	    <div class="btnposition">
	        <a id="btn_ok" class="imgbtn" onclick="btn_ok_onclick()"><span><spring:message code='ezEmail.t38' /></span></a>
	        <a id="btn_cancel" class="imgbtn" onclick="btn_cancel_onclick()"><span><spring:message code='ezEmail.t39' /></span></a>
	    </div>
	</body>
</html>