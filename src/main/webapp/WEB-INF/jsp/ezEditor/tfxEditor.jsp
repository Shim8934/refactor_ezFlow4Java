<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
			var type = "${type}";
			var editorLoadFlag = false;
			
			function SetEditorContent(Data) {
	            try {
	            	// 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
	            	if (parent.onloadflag || typeof parent.onloadflag === "undefined") {
		                xfe.setHtmlValue(Data);
	            	} else {
	            		setTimeout(parent.Editor_Complete, 10);
	            	}
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
	 	            var defaultFontAndSize = "style='font-size:" + defaultFontSize + ";font-family:" + defaultFontFamily + "'";
	 	            
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
	            try {
            	    var resultStr = xfe.getBodyValue();
            	    
            	    resultStr = resultStr.replace(/\r\n/gi, "");
            	    resultStr = resultStr.replace(/\n/gi, "");
            	    resultStr = resultStr.replace(/<p .*?>/gi, "<p>");
            	    resultStr = resultStr.replace(/<p>/gi, "\n");
            	    resultStr = resultStr.replace(/<br .*?>/gi, "\n");
            	    resultStr = resultStr.replace(/<br>/gi, "\n");
            	    resultStr = resultStr.replace(/<hr .*?>/gi, "<hr>");
            	    resultStr = resultStr.replace(/<hr>/gi, "\n----------------------------------------------------------------------------------------------------");
            	    resultStr = resultStr.replace(/<.*?".*?".*?>/gi, "");
            	    resultStr = resultStr.replace(/<.*?'.*?'.*?>/gi, "");
            	    resultStr = resultStr.replace(/<.*?>/gi, "");
            	    resultStr = resultStr.replace(/&nbsp;/gi, " ");
            	    resultStr = resultStr.replace(/&lt;/gi, "<");
            	    resultStr = resultStr.replace(/&gt;/gi, ">");
            	    resultStr = resultStr.replace(/&quot;/gi, "\"");
            	    resultStr = resultStr.replace(/&#39;/gi, "'");
            	    resultStr = resultStr.replace(/&amp;/gi, "&");
            	    resultStr = resultStr.replace(/P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}/gi, "");
					
            	    return  resultStr;
	            } catch (e) { return ""; }
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
	        
			window.onresize = function () {
	            try {
	                xfe.setWidth("100%");
	                xfe.setHeight((document.documentElement.clientHeight - 1) + "px");
	            } catch (e) { }
	        }
		</script> 
	</head>
	<body style="margin: 0px; padding: 0px; overflow: hidden;" id="xfe">
	    <script type="text/javascript">
	    	var userLang = "${userInfo.lang}";
	    	var lang = "";
	    	var useHTMLMode = "${useHTMLMode}";
	    	var defaultFontFamily = "${defaultFontFamily}";
			var defaultFontSize = "${defaultFontSize}";
			
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
	            height : (document.documentElement.clientHeight - 1) + "px",
	            initFontFamilyMenu : initFontFamilyMenu,
	            initFontFamily : defaultFontFamily,
	            initFontSize : defaultFontSize,
	            skin : "classic",
	            uploadFilePath : uploadFilePath,
	            uploadPasteContentsPath : uploadPasteContentsPath,
	            autoFocus : false
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
