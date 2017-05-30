<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script  type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezEditor/tfxEditor/js/xfe_main.js"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
		<script  type="text/javascript">
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
		
			function GetEditorContentURL(url) {
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
			
			function SetEditorContentPathSign(url, strMailSign) {
	            var tempXML = createXmlDom();
	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(url);
	            tempXML = loadXMLString(tempStr);

	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            CKEDITOR.instances.editor1.editable().setHtml(getNodeText(XmlBodyDATA) + strMailSign);
	            for (var i = 0; i < GetChildNodes(XmlBodyATT).length; i++) {
	                BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODEVALUE")))
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
			
			function EditorElementSetHtml(elementID, Html) {
	            try {
	                var ElementObj = xfe.getDom().getElementById(elementID);
	                if (ElementObj) {
	                    ElementObj.innerHTML = Html;
	                }
	            } catch (e) {
	            }
	        }
			
			function setTextPlain() {
			}
			
			function changeTextMode(isTextPlain) {
				var defaultFont = "<spring:message code='main.t246' />";
		    	
		    	if (isTextPlain) {
		        	var texts = GetEditorTextContent().split("\r\n").join("\n").split("\n");
		            
		            var p_ = document.createElement("p");
		            var defaultFontAndSize = "font-size:13px;font-family:" + defaultFont;
		            p_.setAttribute('style', defaultFontAndSize); 
		            
		            var textData = "";
		            
		            for (var i=0; i<texts.length; i++) {
		            	if (texts[i] != "") {
		            		p_.innerText = texts[i];
		            		textData += p_.outerHTML;
		            	}
		            }
		        	
		            //xfe.xfeStackObject.xfeToolbarLine[0].children.length;
		            
		            xfe.hideToolbar(true);
		            xfe.hideTab(true);
		            
		            //복붙 시 p태그로 감싼 텍스트만 오도록
// 		        	config.forcePasteAsPlainText = true;
		        	
		        	SetEditorContent(textData);
		    	} else {
		        	var textData = GetEditorContent();
		        	
		        	xfe.hideToolbar(false);
		            xfe.hideTab(false);
	        		
		        	SetEditorContent(textData);
		    	}
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
	    	var uploadFilePath = "/ezEditor/tfxUpload.do";
	    	var uploadPasteContentsPath = "/ezEditor/tfxSimpleUpload.do";
	    	
	    	if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailsignature.do") > -1) {
	   			uploadFilePath = "/ezEditor/tfxUploadMail.do";
	   			uploadPasteContentsPath = "/ezEditor/tfxSimpleUploadMail.do";
	   		} else if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailoutofoffice.do") > -1) {
	   			uploadPasteContentsPath = "/ezEditor/tfxNoop.do";
	   		}
	    	
	        xfe = new XFE({
	        	lang : lang,
	            basePath : "/js/ezEditor/tfxEditor",
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
	        	xfe.showToolbarItem(0, 12, false);
	        	xfe.showToolbarItem(0, 13, false);
	        	xfe.showToolbarItem(0, 14, false);
	        }
	        
	        window.onload = parent.Editor_Complete();
	    </script>
	</body>
</html>