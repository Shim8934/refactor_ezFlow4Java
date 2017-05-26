<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ckEditor/ckeditor.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
		    CKEDITOR.on('instanceReady', function (ev) {
		        ExecuteCommand("maximize");
		        parent.Editor_Complete();
		    });
		    CKEDITOR.on('afterSetData', function (ev) {
		        try{
		            parent.FieldsAvailable();
		        } catch (e) { }
		    });
		    function SetEditorContent(strHtml) {
		        CKEDITOR.instances.editor1.editable().setHtml(strHtml);
		    }
		    function GetEditorContent() {
		        return CKEDITOR.instances.editor1.getData();
		    }
		    function SetEditorContentURL_Format(pURL) {
		
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "strURL", pURL);
		        xmlhttp.open("POST", "/myoffice/ezEmail/remote/LoadHtml.aspx", false);
		        xmlhttp.send(xmlpara);
		        try {
		            CKEDITOR.instances.editor1.editable().setHtml("<br/>"+xmlhttp.responseText);
		        } catch (e) { }
		    }
		    function SetEditorContentURL(url) {
		        var tempXML = createXmlDom();
		        var XmlBodyATT = createXmlDom();
		        var XmlBodyDATA = createXmlDom();
		        var tempStr = "";
		        tempStr = ConvertMHTtoHTML(url);
		        tempXML = loadXMLString(tempStr);
		
		        XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
		        XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
		        CKEDITOR.instances.editor1.editable().setHtml(getNodeText(XmlBodyDATA));
		        for (var i = 0; i < GetChildNodes(XmlBodyATT).length; i++) {
		            BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODEVALUE")))
		        }
		    }
		
		    function BodySetAttribute(name, Value) {
		        CKEDITOR.instances.editor1.document.$.body.setAttribute(name, Value, 0);
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
		    function SetEditorFocus() {
		        CKEDITOR.instances.editor1.focus();
		    }
		    
		    function GetHtmlValue() {
		        return CKEDITOR.instances.editor1.getData();
		    }
		    
		    function GetTextValue() {
		        var Div_ = document.createElement("DIV");
		        Div_.innerHTML = CKEDITOR.instances.editor1.getData();
		        return Div_.innerText;
		    }
		    function GetListItem(pList, str) {
		        for (i = 0; i < pList.length; i++) {
		            if (pList[i].id == str)
		                return pList[i];
		        }
		    }
		    function ExecuteCommand(commandName) {
		        var oEditor = CKEDITOR.instances.editor1;
		
		        if (oEditor.mode == 'wysiwyg') {
		            oEditor.execCommand(commandName);
		        }
		    }
		    function GetFieldsList() {
		        var FieldsList = new Array();
		        var FieldCount = 0;
		        var count = 0;
		        var i = 0;
		        count = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*").length;
		        for (i = 0; i < count; i++) {
		            if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("id") == "MailSign") {
		                var tmp = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i];
		
		
		                FieldsList[FieldCount] = tmp;
		                FieldCount++;
		            }
		        }
		        return FieldsList;
		    }            
		    function EditorExistsElement(elementID) {
		        try {
		            var ElementObj = CKEDITOR.instances.editor1.document.$.getElementById(elementID);
		            if (ElementObj)
		                return true;
		            else
		                return false;
		        } catch (e) {
		            return false;
		        }
		    }
		    function EditorElementSetHtml(elementID, Html) {
		        try {
		            var ElementObj = CKEDITOR.instances.editor1.document.$.getElementById(elementID);
		            if (ElementObj) {
		                ElementObj.innerHTML = Html;
		            }
		        } catch (e) {
		        }
		    }
		    
		    function setTextPlain(isTextPlain) {
		    	
		    	if (isTextPlain) { // case of text-plain
		    		// make text plain data wrapped by P tag
		    		var mhtBody = "";
		            var div_ = document.createElement("DIV");
		            div_.innerHTML = div_.innerHTML = "<HTML>" + GetCKEditerHeader() + GetEditorContent() + "</HTML>";
		            mhtBody = div_.textContent;
		            mhtBody = mhtBody.replace("P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm } ", "");
		            mhtBody = mhtBody.replace("P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}", "");
		            mhtBody = mhtBody.replace("P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} ", "");
		            
		            var texts = mhtBody.split("\n");
		            var textData = "";
		            var defaultFont = "<spring:message code='main.t246' />";
		            var defaultFontAndSize = "style='font-size:13px;font-family:" + defaultFont + "'";
		            for (var i=0; i<texts.length; i++) {
		            	if (texts[i] != "") {
		            		textData += "<p " + defaultFontAndSize + ">" + texts[i] + "</p>";
		            	}
		            }
		        	
		            // create new editor config and replace
		        	var config = {};
		        	config.toolbar = [['Print']];
		        	config.resize_enabled = false;
		        	config.removePlugins = 'elementspath';
		        	config.forcePasteAsPlainText = true; // forse to set plain text on paste
		        	
		        	CKEDITOR.instances.editor1.destroy();
		        	CKEDITOR.replace('editor1', config);
		        	
		        	// prevent image drop
		        	CKEDITOR.on('instanceReady', function (ev) {
					   ev.editor.document.on('drop', function (ev) {
					      ev.data.preventDefault(true);
					   });
					});
		        	
		        	// set editor content
		        	setTimeout( function(a) {
		        		SetEditorContent(a);
		        	}, 500, textData);
		        	
		    	} else { // case of text-html
		    		var textData = GetEditorContent();
		        	
		    		// replace to the old config
	        		CKEDITOR.instances.editor1.destroy();
	        		CKEDITOR.replace('editor1', oldConfig);
	        		
	        		//TODO: 수정 - image drop 막은거 풀어야함...ㅠ
	        		CKEDITOR.on('instanceReady', function (ev) {
						ev.editor.document.off('drop');
	        		});
	        		
	        		// set editor content
	        		setTimeout( function(a) {
		        		SetEditorContent(a);
		        	}, 500, textData);
		    	}
		    }
		</script> 
	</head>

	<body>
		<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
		<script type="text/javascript">
			//TODO: oldConfig 어디다가 둬야하지
			var oldConfig;
		
			if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailoutofoffice.do") > -1) {
				CKEDITOR.replace('editor1', { fullPage: false, removePlugins: '_Insert_Image' });
				
				CKEDITOR.on('instanceReady', function (ev) {
				   // Prevent drag-and-drop.
				   ev.editor.document.on('drop', function (ev) {
				      ev.data.preventDefault(true);
				   });
				});
			} else {
				CKEDITOR.replace('editor1', { fullPage: false });
			}
			
		    CKEDITOR.config.font_defaultLabel = "<spring:message code='main.t246' />";
		    CKEDITOR.config.font_names = "<spring:message code='main.t0620' />";
		    CKEDITOR.config.language = "<spring:message code='main.t0619' />";
		    
		    if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailsignature.do") > -1) {
		    	CKEDITOR.config.imageUploadUrl = "/ezEmail/ckSimpleUpload.do";
		    }
		    
		    oldConfig = CKEDITOR.config;
		</script>
	</body>
</html>