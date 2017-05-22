<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <title></title>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/tfxEditor/js/xfe_main.js"></script>
	    <script type="text/javascript">
	        function SetEditorContent(Data) {
	            try {
	                xfe.setHtmlValue(Data);
	            } catch (e) { }
	        }
	        function DisabledBody() {
	            xfe.setEditMode(2);
	        }
	        function GetEditorContent() {
	            try {
	                return xfe.getBodyValue();
	            } catch (e) { return ""; }
	        }
	        function GetEditorTextContent() {
	            try {
	                return xfe.getTextValue();
	            } catch (e) { return ""; }
	        }
	        function GetBodyValue() {
	            try {
	                return xfe.getBodyValue();
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
	                xfe.setBodyValue(htmlData);
	            } catch (e) { }
	        }
	
	        function SetEditorContentURL_Admin(pURL) {
	            try {
	                var tempXML = createXmlDom();
	                var XmlBodyATT = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempStr = "";
	                tempStr = ConvertMHTtoHTML(pURL);
	                tempXML = loadXMLString(tempStr)
	                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	
	                var Doc_ContentHtml = document.createElement("DIV");
	                Doc_ContentHtml.innerHTML = getNodeText(XmlBodyDATA);
	
	                var htmlData = "";
	                var ConnData = "";
	                for (var i = 0; i < GetChildNodes(Doc_ContentHtml).length ; i++) {
	                    if (GetChildNodes(Doc_ContentHtml)[i].id.toUpperCase() == "CONN") {
	                        ConnData = Doc_ContentHtml.children[i].innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', '');
	                    }
	                    else if (GetChildNodes(Doc_ContentHtml)[i].tagName != undefined && (GetChildNodes(Doc_ContentHtml)[i].tagName.toUpperCase() != "XML" || GetChildNodes(Doc_ContentHtml)[i].tagName.toUpperCase() != "TABLEINFO"))
	                        htmlData = htmlData + GetChildNodes(Doc_ContentHtml)[i].outerHTML;
	                }
	
	                xfe.setBodyValue(htmlData);
	                return ConnData;
	            } catch (e) { }
	        }
	
	        function GetEditorContentURL(url) {
	            var tempXML = createXmlDom();
	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(url);
	            tempXML = loadXMLString(tempStr);
	
	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            return getNodeText(XmlBodyDATA);
	        }
	        function Editor_GetTableHTML(name) {
	            try {
	                return xfe.getDom().getElementById(name);
	            } catch (e) { }
	        }        
	
	        function EditorElementSetHtml(elementID, Html) {
	            try {
	                var ElementObj = xfe.getDom().getElementById(elementID);
	                if (ElementObj) {
	                    ElementObj.innerHTML = Html;
	                }
	            } catch (e) {
	            }
	        }
	
	        function GetFieldsList() {           
	            var FieldsList = new Array();
	            FieldsList[0] = xfe.getDom().getElementById("MailSign")
	            return FieldsList;
	        }
	        function GetListItem(pList, str) {
	            for (i = 0; i < pList.length; i++) {
	                if (pList[i].id == str)
	                    return pList[i];
	            }
	        }
	
	        window.onresize = function () {
	            try {
	                xfe.setWidth("100%")
	                xfe.setHeight(document.documentElement.clientHeight + "px");
	            } catch (e) { }
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
	    	
	   		if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailsignature.do") > -1) {
	   			uploadFilePath = "/ezEmail/tfxUpload.do";
	   			uploadPasteContentsPath = "/ezEmail/tfxSimpleUpload.do";
	   		} else if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailoutofoffice.do") > -1) {
	   			uploadPasteContentsPath = "/ezEmail/tfxNoop.do";
	   		}
	    	
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
	        
	        if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailoutofoffice.do") > -1) {
	        	xfe.showToolbarItemById("xfe_insertimage", false);
	        	xfe.showToolbarItemById("xfe_imageproperty", false);
	        }
	        
	        window.onload = parent.Editor_Complete;
	        
	    </script>
	</body>
</html>
