<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script  type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js//tfxEditor/js/xfe_main.js"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
		<script  type="text/javascript">
			// 웹에디터에 내용 삽입(MHT 파일 url 받음)
			function SetEditorContentURL(pURL) {
                var tempXML = createXmlDom();
                var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(pURL);
                tempXML = loadXMLString(tempStr)
                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                var htmlData = getNodeText(XmlBodyDATA);
                xfe.setBodyValue(htmlData);
	        }	
		
			// 웹에디터에 내용 삽입(MHT 파일 url 받음)
			function SetEditorContentURL2(url) {
				var tempXML = createXmlDom();
                var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(url);
                tempXML = loadXMLString(tempStr)
                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
			    return getNodeText(XmlBodyDATA);
			}
			
			function SetEditorContent(Data) {
	            try {
	                xfe.setHtmlValue(Data);
	            } catch (e) { }
	        }
		
			function GetEditorContent() {
	            return xfe.getBodyValue();
	        }
		
		</script> 
	</head>
	<body style="margin: 0px; padding: 0px;" id="xfe">
	    <script type="text/javascript">
	    	var userLang = "${userInfo.lang}";
	    	var lang = "";
	    	
	    	switch (userLang) {
		    	case "1": 
		    		lang = "korean";
		    		break;
		    	case "2": 
		    		lang = "english";
		    		break;
		    	case "3": 
		    		lang = "japanese";
		    		break;
		    	case "4": 
		    		//중국어 간체 (번체는 chinese_t)
		    		lang = "chinese_s";
		    		break;
		    	default :
		    		lang = "korean";
		    		break;
	    	}
	    	
	    	var initFontFamilyMenu = "<spring:message code='main.t0620' />".split(";");
	    	var uploadFilePath = "/ezCommon/tfxUpload.do";
	    	var uploadPasteContentsPath = "/ezCommon/tfxSimpleUpload.do";
	    	
	        xfe = new XFE({
	        	lang : lang,
	            basePath : "/js/tfxEditor",
	            width : "100%",
	            height : (document.documentElement.clientHeight) + "px",
	            initFontFamilyMenu : initFontFamilyMenu,
	            initFontFamily : "<spring:message code='main.t246' />",
	            initFontSize : "13px",
	            skin : "classic",
	            uploadFilePath : uploadFilePath,
	            uploadPasteContentsPath : uploadPasteContentsPath
	        });
	        
	        xfe.render('xfe');
	        
	        window.onload = parent.DocumentComplete();
	    </script>
	</body>
</html>