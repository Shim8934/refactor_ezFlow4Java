<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
		<script  type="text/javascript" src="/js/dext5editor/dext5editorjs"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
		<script  type="text/javascript">
		    // 에디터가 로드 완료(작업준비) 되었을 때 발생
	        function dext_editor_loaded_event(editor) {
    	        parent.DocumentComplete();
	        }
    	    function SetEditorContent(strHtml) {
        	    try {
            	    DEXT5.setBodyValue(strHtml, 'DextEditor');
            	} catch (e) { }
        	}
        	function GetEditorContent() {
	            try {
                	return DEXT5.getHtmlValue('DextEditor');
            	} catch (e) { return ""; }
        	}

        	function SetEditorContentURL(pURL) {
	            try {
                	var tempXML = createXmlDom();
                	var XmlBodyATT = createXmlDom();
                	var XmlBodyDATA = createXmlDom();
                	var tempStr = "";
                	tempStr = ConvertMHTtoHTML(pURL);
                	tempXML = loadXMLString(tempStr)
                	XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                	XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                	var htmlData = getNodeText(XmlBodyDATA);
                	DEXT5.setBodyValue(htmlData, 'DextEditor');
            	} catch (e) { }
        	}

        	window.onload = function () {
        	}

        	window.onresize = function () {
            	DEXT5.setSize('100%', (document.documentElement.clientHeight - 10) + "px", 'DextEditor');
        	}
    	</script>
	</head>
	<body style="margin:0px;padding:0px;overflow:hidden;">
		<table style="width:100%;height:100%;">
    		<tr>
        		<td style="height:100%;">
            		<script type="text/javascript">
                		DEXT5.config.RemoveItem = 'image_create';
                		DEXT5.config.DialogWindow = parent.window;
                		DEXT5.config.Height = (document.documentElement.clientHeight - 10) + "px";
                		var editor = new Dext5editor("DextEditor");
		    		</script>
        		</td>
    		</tr>
		</table>
	</body>
</html>