<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezCircular.t105'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/ecmascript">
	        var ReturnFunction;
	        var CancelFunction;
	        var InputValue;
            var FolderId;
            var folderNameList = "<c:out value='${folderNameList}'/>";
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        
	        function window_onload() {
                ReturnFunction = parent.inputNameDlg_cross_dialogArguments[0];
                CancelFunction = parent.inputNameDlg_cross_dialogArguments[1];
                InputValue = parent.inputNameDlg_cross_dialogArguments[2];
                FolderId = parent.inputNameDlg_cross_dialogArguments[3];
                
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
	            var specialChar = /[&\<>\'\"]/gi;
	            var folderNameArr = folderNameList.split(";");

	            if (folderName == "") {
	            	alert("<spring:message code='ezCircular.t58'/>")
	            	return;
	            }
	            
	            if (specialChar.test(folderName)) {
	            	alert("<spring:message code='ezCircular.t187'/>");
	            	return ;
	            }

	            if ($.trim($("#txt_FolderName").val()) == "") {
		        	alert("<spring:message code='ezCircular.t191' />");
		        	doubleSubmitFlag = false;

		        	return;
		        }

	            for (var i=0; i<folderNameArr.length; i++) {
	            	if (folderNameArr[i] == folderName) {
	            		alert("<spring:message code='ezCircular.t186'/>");
		            	return;	
	            	}
	            }

	            if (FolderId == "") {
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
							alert("<spring:message code='ezCircular.t102' />");	
						}
					})
	            } else {
	            	$.ajax({
						method : "POST",
						dataType : "text",
						async : false,
						url : "/ezCircular/circularFolderModify.do",
						data : {
							FolderId : FolderId,
							folderName : folderName
						},
						success : function() {
							ReturnFunction();
						},
						error : function() {
							alert("<spring:message code='ezCircular.t102' />");	
						}
					})
	            }
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
	    <h1><spring:message code='ezCircular.t105' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="btn_cancel_onclick()"></span></li>
            </ul>
        </div>
	    <div class="txt">▒&nbsp;<spring:message code='ezCircular.t106' /></div>
	    <div class="nobox" style="margin-top:10px">
	        <input id="txt_FolderName" type="text" onkeydown="folderName_onkeydown()" style="width: 100%;height:25px;border:1px solid #ccc" maxlength="20">
	    </div>
	    <div class="btnposition btnpositionNew">
	        <a id="btn_ok" class="imgbtn" onclick="btn_ok_onclick()"><span><spring:message code='ezCircular.t65' /></span></a>
	    </div>
	</body>
</html>