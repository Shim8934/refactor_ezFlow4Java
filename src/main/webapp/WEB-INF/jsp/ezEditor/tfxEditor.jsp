<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/tfxEditor/js/xfe_main.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style>.xfeToolbar {border-top-left-radius : 0px !important; border-top-right-radius : 0px !important;}</style>
		<script  type="text/javascript">
			var type = "<c:out value='${type}'/>";
			var editorLoadFlag = false;
			
			function SetEditorContent(Data) {
	            try {
	                xfe.setHtmlValue(Data);
	            } catch (e) { }
	        }
		
			function GetEditorContent() {
				try {
	            	return xfe.getBodyValue();
				} catch (e) { return ""; }
	        }
			
			function SetEditorTextContent(data) {
	            try {
	            	data = data.replace(/&/gi, "&amp;");
	            	data = data.replace(/</gi, "&lt;");
	            	data = data.replace(/>/gi, "&gt;");
	 	            
	 	    		var line = data.split("\n");
	 	            var textData = "";
	 	            
	 	            for (var i = 0; i < line.length; i++) {
	 	            	if (line[i].trim() === "") {
	 	            		line[i] = "&nbsp;";
	 	            	}
	 	            	
 	            		textData += "<p " + defaultFontAndSize + ">" + line[i] + "</p>";
	 	            }
	            	
	 	           xfe.setHtmlValue(textData);
	            } catch (e) { }
	        }
			
			function GetEditorTextContent() {
                var resultStr = xfe.getBodyValue();
                
                resultStr = resultStr.replace(/\r\n/gi, "\n");
                resultStr = resultStr.replace(/\n/gi, "");
                resultStr = resultStr.replace(/<p .*?>/gi, "<p>");
                resultStr = resultStr.replace(/<br .*?>/gi, "<br>");
                resultStr = resultStr.replace(/<hr .*?>/gi, "<hr>");
                resultStr = resultStr.replace(/<p>/gi, "\r\n");
                resultStr = resultStr.replace(/<br>/gi, "\r\n");
                resultStr = resultStr.replace(/<hr>/gi, "\r\n----------------------------------------------------------------------");
                resultStr = resultStr.replace(/<style .*?>/gi, "<style>");
                resultStr = resultStr.replace(/<style>.*?<\/style>/gi, "");
                resultStr = resultStr.replace(/<script .*?>/gi, "<script>");
                resultStr = resultStr.replace(/<script>.*?<\/script>/gi, "");
                resultStr = resultStr.replace(/<.*?>/gi, "");
                
                var tempTextarea = document.createElement("textarea");
                tempTextarea.innerHTML = resultStr;
                resultStr = tempTextarea.value;
                
                return  resultStr;
	        }
			
			function GetBodyValue() {
	            try {
	                return xfe.getBodyValue();
	            } catch (e) { return ""; }
	        }
			
			function SetEditorContentURL(pURL) {
                var tempXML = createXmlDom();
//                 var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(pURL);
                tempXML = loadXMLString(tempStr)
//                 XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                var htmlData = getNodeText(XmlBodyDATA);
                xfe.setBodyValue(htmlData);
	        }	
		
			function GetEditorContentURL(url) {
				var tempXML = createXmlDom();
//                 var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(url);
                tempXML = loadXMLString(tempStr)
//                 XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
			    return getNodeText(XmlBodyDATA);
			}
			
			function SetEditorContentURL_Admin(pURL) {
	            try {
	                var tempXML = createXmlDom();
// 	                var XmlBodyATT = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempStr = "";
	                tempStr = ConvertMHTtoHTML(pURL);
	                tempXML = loadXMLString(tempStr)
// 	                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
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
			
			function SetEditorContentPathSign(url, strMailSign) {
	            var tempXML = createXmlDom();
// 	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(url);
	            tempXML = loadXMLString(tempStr);

// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            CKEDITOR.instances.editor1.editable().setHtml(getNodeText(XmlBodyDATA) + strMailSign);
	            /* for (var i = 0; i < GetChildNodes(XmlBodyATT).length; i++) {
	                BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODEVALUE")))
	            } */
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
			
			function EditorElementSetHtml(elementID, Html) {
	            try {
	                var ElementObj = xfe.getDom().getElementById(elementID);
	                if (ElementObj) {
	                    ElementObj.innerHTML = Html;
	                }
	            } catch (e) {
	            }
	        }

	        function GetEditorBody() {
	        	return xfe.getDom().body;
	        }
	        const xfeHeight = (document.documentElement.clientHeight - 1) ;

			window.onresize =  function () {
	             try {
	                setTimeout(function(){
                         let height = document.documentElement.clientHeight - 220;

                            xfe.setWidth("100%");
                            xfe.setHeight(height+ "px");
	                },100);

                    //xfe.setWidth("100%");
                    //xfe.setHeight((document.documentElement.clientHeight - 1) + "px");
	            } catch (e) { }
	        }
			
			// 현재 위치에 텍스트 넣는 함수(서명 템플릿 관리>서명 템플릿 추가 및 수정 팝업창에서 사용)
	        function setCursorAtText(text) {
	        	var range = xfe.getSavedRange();
	        	xfe.insertHtmlAtCursor(text, range);
	        }
		</script> 
	</head>
	<body style="margin: 0px; padding: 0px; overflow: hidden;" id="xfe">
	    <script type="text/javascript">
	    	var userLang = "<c:out value='${userInfo.lang}'/>";
	    	var lang = "";
	    	var useHTMLMode = "<c:out value='${useHTMLMode}'/>";
	    	var defaultFontFamily = "<c:out value='${defaultFontFamily}'/>";
			var defaultFontSize = "<c:out value='${defaultFontSize}'/>";
			var defaultFontAndSize = "style='font-size:" + defaultFontSize + ";font-family:" + defaultFontFamily + "'";
			
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
		    		lang = "english";
		    		break;
	    	}
	    	
	    	var initFontFamilyMenu = "<spring:message code='main.t0620' />".split(";");

	    	var uploadFilePath = "/ezEditor/tfxUpload.do?type=" + type;
	    	var uploadPasteContentsPath = "/ezEditor/tfxSimpleUpload.do?type=" + type;
	    	
	    	if (type == "MAILOUTOFOFFICE" || type == "COMMUNITYPHOTO") {
	   			uploadPasteContentsPath = "/ezEditor/tfxNoop.do";
	   		} else if (type == "MAILLETTER") {
	        	var letterBoxNo = parent.popLetterBoxNo; // letterEditPopUp.jsp
	        	var letterId = parent.popLetterId; // letterEditPopUp.jsp
	        	
	        	uploadFilePath = "/ezEditor/tfxUpload.do?type=" + type + "&letterBoxNo=" + letterBoxNo + "&letterId=" + letterId;
	        	uploadPasteContentsPath = "/ezEditor/tfxSimpleUpload.do?type=" + type + "&letterBoxNo=" + letterBoxNo + "&letterId=" + letterId;
	   		}
	    	
	        xfe = new XFE({
	        	lang : lang,
	            basePath : "/js/ezEditor/tfxEditor",
	            width : "100%",
	            height : xfeHeight + "px",
	            initFontFamilyMenu : initFontFamilyMenu,
	            initFontFamily : defaultFontFamily,
	            initFontSize : defaultFontSize,
	            skin : "classic",
	            uploadFilePath : uploadFilePath,
	            uploadPasteContentsPath : uploadPasteContentsPath,
	            autoFocus : false,
	            rootFrameId : 'tbContentElement',
	            ignoreMinHeight : true
	        });
	        
	        xfe.render('xfe');
	        
	        if (type == "MAILOUTOFOFFICE" || type == "COMMUNITYPHOTO") {
	        	xfe.showToolbarItem(0, 11, false);
	        	xfe.showToolbarItem(0, 12, false);
	        	xfe.showToolbarItem(0, 13, false);
	        }
	        
	        if (useHTMLMode == "NO") {
	        	xfe.showTab(1, false);
	        }
	        
	        window.onload = function() {
	        	editorLoadFlag = true;
	        	parent.Editor_Complete();
	        };
	    </script>
	</body>
</html>
