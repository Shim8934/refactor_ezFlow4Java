<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
	    <script type="text/javascript">
	        var ReturnFunction;
	        var RetValue;
	        var type;
	        
	        function window_onload() {
                RetValue = parent.inputnamedlg_dialogArguments[0];
                ReturnFunction = parent.inputnamedlg_dialogArguments[1];
                type = parent.inputnamedlg_dialogArguments[2];
                if (type == 'U') {
            		txt_FolderName.value = ConvMakeString(RetValue);
                }
	        }
	        
	        function ReplaceText(str, search, replacement) {
	            return str.split(search).join(replacement);
	        }
	        
			function btn_ok_onclick() {
			    var szInput;
			    szInput = txt_FolderName.value;
			    szInput = ReplaceText(szInput, " ", "");
			
			    if (szInput == "") {
			        alert("<spring:message code='ezResource.resFav.ygs15'/>");
			        return;
			    }
			    
			    var szCheckPermit = szInput;
			    szCheckPermit = ReplaceText(szInput, "=", "");
			
			    if (szInput != szCheckPermit) {
			        alert("<spring:message code='ezResource.resFav.ygs16'/>");
			        return;
			    }
			    
			    szInput=ConvMakeData(szInput);
			
		        ReturnFunction(szInput);
			}
			
		    function btn_cancel_onclick() {
		   		parent.DivPopUpHidden();
			}
			
			function folderName_onkeydown() {
			    if (event.keyCode == 13) {
			        btn_ok_onclick();
			    }
			}
			
			function ConvMakeString(str) {
	            str = ReplaceText(str, "&lt;", "<");
	            str = ReplaceText(str, "&gt;", ">");
	            str = ReplaceText(str, "&#039;", "'");
	            str = ReplaceText(str, "&#034;", "\"");
	            str = ReplaceText(str, "&#92;", "\\");
        	    str = ReplaceText(str, "&amp;", "&");	    
	            return str;
	        }
			
	        function ConvMakeData(str) {
	            str = ReplaceText(str, "<", "&lt;");
	            str = ReplaceText(str, ">", "&gt;");
	            str = ReplaceText(str, "'", "&#039;");
	            str = ReplaceText(str, "\"", "&#034;");
	            str = ReplaceText(str, "\\", "&#92;");
	            str = ReplaceText(str, "&", "&amp;");
	            return str;
	        }
	    </script>
	</head>
	<body class="popup" onload="javascript:window_onload();">
	    <h1><spring:message code="ezResource.resFav.ygs07" /></h1>
	    <div id="close">
            <ul>
                <li><span id="btn_cancel" onclick="btn_cancel_onclick()"></span></li>
            </ul>
        </div>
	    <div class="txt" style="margin-top:15px">▒&nbsp;<spring:message code="ezResource.resFav.ygs14"/></div>
	    <div class="nobox" style="margin-top:10px">
	        <input id="txt_FolderName" type="text" onkeydown="folderName_onkeydown();" style="width: 100%; height:25px; border:1px solid #ccc;" maxlength="20">
	    </div>
	    <div class="btnposition btnpositionNew">
	        <a id="btn_ok" class="imgbtn" onclick="btn_ok_onclick();"><span><spring:message code="ezResource.resFav.ygs17"/></span></a>
	    </div>
	
	</body>
</html>