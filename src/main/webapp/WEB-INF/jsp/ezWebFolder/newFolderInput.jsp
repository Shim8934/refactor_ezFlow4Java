<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t348' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/ecmascript">
			var ReturnFunction;
	        var CancelFunction;
	        var folderUppId = "";
	        var functionType = "";
	        var folderName1 = "";
	        var folderName2 = "";
	        
	        document.onselectstart = function () {
	            return event.srcElement.tagName == "INPUT" || event.srcElement.tagName == "TEXTAREA";
	        };
	        
	        function window_onload() {
	            try {
	            	folderUppId    = parent.inputNameDlg_cross_dialogArguments[0];
	                ReturnFunction = parent.inputNameDlg_cross_dialogArguments[1];
	                CancelFunction = parent.inputNameDlg_cross_dialogArguments[2];
	                functionType   = parent.inputNameDlg_cross_dialogArguments[3];
	                
	                if (functionType == "insert") {
		            	$('#title').text("<spring:message code='ezWebFolder.t302'/>");
		            	/* $('.txt').text("<spring:message code='ezWebFolder.t265' />"); */
		            } else if(functionType == "update") {
		            	folderName1 = parent.inputNameDlg_cross_dialogArguments[4];
						folderName2 = parent.inputNameDlg_cross_dialogArguments[5];
		                $('#txt_FolderName1').val(folderName1);
		            	$('#title').text("<spring:message code='ezWebFolder.t303'/>");
		            	/* $('.txt').text("<spring:message code='ezWebFolder.t304' />"); */
		            }
	            } catch (e) {}
	            
	            try {
	                txt_FolderName.focus();
	            } catch (e) {}    	
	        }
	        
	        function isValid(str){
				var regex = /[*:"\\|<>\/?]/g;
				return regex.test(str);
			}
	        
	        function btn_ok_onclick() {
	            var szInput1 = "";
	            var szInput2 = "";
	            szInput1 = txt_FolderName1.value;
	            szInput1 = ReplaceText(szInput1, " ", "");
	            szInput2 = ReplaceText(szInput2, " ", "");
	
	            if (szInput1 == "") {
	                alert('<spring:message code='ezWebFolder.t314'/>');
	                return;
	            }
	            
	            var szCheckPermit1 = szInput1;
	            var szCheckPermit2 = szInput2;
	            
	            szCheckPermit1 = ReplaceText(szInput1, "=", "");
	            szCheckPermit2 = ReplaceText(szInput2, "=", "");

				if (isValid(szCheckPermit1)) {
					alert('<spring:message code='ezWebFolder.t211'/>');
					return;
				}
				
				if (functionType == "insert") {
		            $.ajax({
						type :"POST",
						async: false,
						url  : "/ezWebFolder/insertFolder.do",
						data : { 
							"folderId": folderUppId,
							"newFolderName1": szCheckPermit1
						},
						dataType: "JSON",
						success : function (data) {
							alert("<spring:message code='ezWebFolder.t263'/>");
				            ReturnFunction(szInput1);
						}
		        	});
				} else if (functionType == "update") {
					$.ajax({
						type :"POST",
						async: false,
						url  : "/ezWebFolder/updateFolder.do",
						data : { 
							"folderId": folderUppId,
							"newFolderName1": szCheckPermit1
						},
						dataType: "JSON",
						success : function (data) {
							alert("<spring:message code='ezWebFolder.t264'/>");
							ReturnFunction(szInput1);
						}
					});
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
	    <h1 id="title"></h1>
	    <div id="close">
            <ul>
                <li><span id="btn_cancel" onclick="btn_cancel_onclick()"></span></li>
            </ul>
        </div>
	    <!-- <div class="txt"><span></span></div> -->
	    <div class="nobox">
	    	<span id="ko_lang"><spring:message code='ezWebFolder.t226'/></span>
	        <input id="txt_FolderName1" type="text" maxlength="50" onkeydown="folderName_onkeydown()" style="width: 60%;margin-top:3px;height:25px">
	        <br>
	    </div>
	    <div class="btnposition btnpositionNew">
	        <a id="btn_ok" class="imgbtn" onclick="btn_ok_onclick()"><span><spring:message code='ezWebFolder.t116'/></span></a>
	    </div>	
	</body>
</html>