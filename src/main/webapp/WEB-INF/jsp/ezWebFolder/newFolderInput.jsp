<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t348' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script src="/js/ezEmail/js_cross/string_component.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/ecmascript">
	        var ReturnFunction;
	        var CancelFunction;
	        var folderUppId = "";
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        function window_onload() {
	            try {
	            	folderUppId = parent.inputNameDlg_cross_dialogArguments[0];
	                ReturnFunction = parent.inputNameDlg_cross_dialogArguments[1];
	                CancelFunction = parent.inputNameDlg_cross_dialogArguments[2];
	            } catch (e) { }
// 	            if (InputValue != "") {
// 	                txt_FolderName.value = InputValue;
// 	            }
	            try {
	                txt_FolderName.focus();
	            }
	            catch (e)
	            { }
	        }
	        function btn_ok_onclick() {
	        	
	            var szInput1="";
	            var szInput2="";
	            szInput1 = txt_FolderName1.value;
	            szInput2 = txt_FolderName2.value;
	            szInput1 = ReplaceText(szInput1, " ", "");
	            szInput2 = ReplaceText(szInput2, " ", "");
	
	            if (szInput1 == "") {
	                alert("<spring:message code='ezEmail.t349' />");
	                return;
	            }
	            if (szInput2 == "") {
	                alert("<spring:message code='ezEmail.t349' />");
	                return;
	            }
	            var szCheckPermit1 = szInput1;
	            szCheckPermit1 = ReplaceText(szInput1, "=", "");
	            var szCheckPermit2 = szInput2;
	            szCheckPermit2 = ReplaceText(szInput2, "=", "");
	
// 	            if (szInput != szCheckPermit) {
// 	                alert("<spring:message code='ezEmail.t351' />");
// 	                return;
// 	            }
	            $.ajax ({
					type :"POST",
					async: true,
					url  : "/ezWebFolder/insertFolder.do",
					data : { 
							 "folderId"   	 : folderUppId
							,"newFolderName1" : szCheckPermit1
							,"newFolderName2" : szCheckPermit2
						},
					dataType: "JSON",
					success : function (data) {
						alert("newFolderName1" + szInput1);
//		        			window.close();
// 						opener.parent.location.reload();
// 						window.close();
			            ReturnFunction(szInput1);
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
	    <h1>테스트</h1>
	    <div class="txt">만들 폴더명을 입력하세요</div>
	    <div class="nobox">
	    	<span id = "ko_lang">한글 </span>
	        <input id="txt_FolderName1" type="text" onkeydown="folderName_onkeydown()" style="width: 80%;margin-top:2px" maxlength="8">
	        <br>
	    	<span id = "ko_lang">영문 </span>
	        <input id="txt_FolderName2" type="text" onkeydown="folderName_onkeydown()" style="width: 80%;margin-top:2px" maxlength="8">
	    </div>
	    <div class="btnposition btnpositionNew">
	        <a id="btn_ok" class="imgbtn" onclick="btn_ok_onclick()"><span><spring:message code='ezEmail.t38' /></span></a>
	        <a id="btn_cancel" class="imgbtn" onclick="btn_cancel_onclick()"><span><spring:message code='ezEmail.t39' /></span></a>
	    </div>	
	</body>
</html>