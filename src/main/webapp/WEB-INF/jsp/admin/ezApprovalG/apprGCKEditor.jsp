<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<script  type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script  type="text/javascript" src="/js/ckEditor/ckeditor.js"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
		
		<script type="text/javascript">
			var type = "<c:out value = '${type}' />";
			
			CKEDITOR.on('instanceReady', function (ev) {
	            ExecuteCommand("maximize");
	            parent.Editor_Complete();
	            
	        });
	        CKEDITOR.on('afterSetData', function (ev) {
	        });
	
	        function ExecuteCommand(commandName) {
	            var oEditor = CKEDITOR.instances.editor1;
	
	            if (oEditor.mode == 'wysiwyg') {
	                oEditor.execCommand(commandName);
	            }
	        }
	
	        function SetEditorContent(Data) {
	            try {
	                CKEDITOR.instances.editor1.editable().setHtml(Data);
	                if (type == "APPROVAL" || type == "APPROVALG") {
	                    Set_CellLocked();
	                }
	            } catch (e) { }
	        }
	        function GetEditorContent() {
	            try {
	            	if (type == "APPROVAL" || type == "APPROVALG")
	                    return Get_BodyUnlock(CKEDITOR.instances.editor1.getData());
	                else
	                    return CKEDITOR.instances.editor1.getData();
	            } catch (e) { return ""; }
	        }
	
	        function GetEditorTextContent() {
	            try {
	                return CKEDITOR.instances.editor1.editable().$.outerText;
	            } catch (e) { return ""; }
	        }
	
	        function GetBodyValue() {
	            CKEDITOR.instances.editor1.getData();
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
	            CKEDITOR.instances.editor1.setData(getNodeText(XmlBodyDATA));
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
	
	        function SetEditorContentURL_Format(pURL) {
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "strURL", pURL);
	            xmlhttp.open("POST", "/myoffice/ezEmail/remote/LoadHtml.aspx", false);
	            xmlhttp.send(xmlpara);
	            try {
	                CKEDITOR.instances.editor1.editable().setHtml("<br/>" + xmlhttp.responseText);
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
	
	        function BodySetAttribute(name, Value) {
	            CKEDITOR.instances.editor1.document.$.body.setAttribute(name, Value, 0);
	        }
	
	        function BodyGetAttribute(name) {
	            CKEDITOR.instances.editor1.document.$.body.getAttribute(name);
	        }
	
	        function Get_BodyUnlock(HtmlBody) {
	            var Div_Body = document.createElement("DIV");
	            Div_Body.innerHTML = HtmlBody;
	            var TDRows = Div_Body.getElementsByTagName("*");
	            for (var i = 0; i < TDRows.length; i++) {
	                if (TDRows[i].getAttribute("contenteditable") != null) {
	                    TDRows[i].removeAttribute("contenteditable");
	                }
	            }
	            return Div_Body.innerHTML;
	        }
	        function Set_Size(width, height)
	        {
	            CKEDITOR.instances.editor1.resize(0, height);
	        }
	        function Set_CellLocked() {
	            for (var i = 0; i < CKEDITOR.instances.editor1.document.$.getElementsByTagName("*").length; i++) {
	                if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].tagName == "TD") {
	                    if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("free") == null) {
	                        CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].setAttribute("contenteditable", "false")
	                    }
	                    else if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("free") != null) {
	                        CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].setAttribute("contenteditable", "true")
	                    }
	                }
	                else if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].tagName == "TABLE") {
	                    if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("free") == null) {
	                        CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].setAttribute("contenteditable", "false")
	                    }
	                    else if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("free") != null) {
	                        CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].setAttribute("contenteditable", "true")
	                    }
	                }
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
	                    if (!tmp.FieldID)
	                        tmp.FieldID = tmp.id;
	                    FieldsList[FieldCount] = tmp;
	                    FieldCount++;
	                }
	            }
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
	                var ElementObj = CKEDITOR.instances.editor1.document.$.getElementById(elementID)
	                if (ElementObj) {
	                    ElementObj.innerHTML = Html;
	                }
	                
	            } catch (e) {
	            }
	        }
		</script>
	</head>
	<body style="margin: 0px; padding: 0px;">
	    <textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
	    <script type="text/javascript">CKEDITOR.replace('editor1', { fullPage: false });</script>
	    <script type="text/javascript">
	        CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
	        CKEDITOR.config.height = parseInt("${height}") - 120 + "px";
	        CKEDITOR.config.font_defaultLabel = "<spring:message code='main.t246' />";
            CKEDITOR.config.font_names = "<spring:message code='main.t0620' />" + CKEDITOR.instances.editor1.config.font_names;
            CKEDITOR.config.language = "<spring:message code='main.t0619' />";
	    </script>
	</body>
</html>