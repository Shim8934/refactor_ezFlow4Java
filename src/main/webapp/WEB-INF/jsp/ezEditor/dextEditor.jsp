<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/dext5Editor/js/dext5editor.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var type = "<c:out value='${type}'/>";
			var height = "<c:out value='${height}'/>";
			var id = "<c:out value='${id}'/>";
			var editorLoadFlag = false;
			
			function dext_editor_loaded_event(editor) {
				editorLoadFlag = true;
				
	            // 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
	            if (parent.onloadflag || typeof parent.onloadflag === "undefined") {
	                parent.Editor_Complete();
	                if (type == "ADMIN") {
	                    DEXT5.showTopMenu(1, id);
	                }
	            }
	            else {
	                setTimeout(dext_editor_loaded_event, 10);
	            }
	        }

	        function dext_key_event(type, event, currElem) {
	            if (type == "keyup" && parent.Attribute_Write != undefined) {
	                var parentTag = currElem;
	                if (parentTag.tagName == "TD")
	                    parent.Attribute_Write(GetAttribute(parentTag, "id"));
	                else {
	                    while (parentTag && !parentTag.previousElementSibling && !parentTag.nextElementSibling) {
	                        parentTag = parentTag.parentNode;
	                        if (parentTag.tagName == "TD") {
	                            parent.Attribute_Write(GetAttribute(parentTag, "id"));
	                            break;
	                        }
	                    }
	                }
	            }
	        }

	        function dext_mouse_event(type, event, currElem) {
	            if (type == "mousedown" && parent.Attribute_Write != undefined) {
	                var parentTag = currElem;
	                if (parentTag.tagName == "TD") {
	                    parent.Attribute_Write(GetAttribute(parentTag, "id"));
	                }
	                else {
	                    while (parentTag && !parentTag.previousElementSibling && !parentTag.nextElementSibling) {
	                        parentTag = parentTag.parentNode;
	                        if (parentTag.tagName == "TD") {
	                            parent.Attribute_Write(GetAttribute(parentTag, "id"));
	                            break;
	                        }
	                    }
	                }
	            }
	        }

	        function SetEditorContent(Data) {
	            try {
	                DEXT5.setBodyValue(Data, id);
	                Set_CellLocked();
	            } catch (e) { }
	        }

	        function GetEditorContent() {
	            try {
	                return DEXT5.getBodyValue(id);
	            } catch (e) {
	                alert("본문 내용을 가져오는중 에러가 발생하였습니다.");
	            }
	        }

	        function GetEditorTextContent() {
	            try {
	                return DEXT5.getBodyTextValue(id);
	            } catch (e) {
	                alert("본문 내용을 가져오는중 에러가 발생하였습니다.");
	            }
	        }

	        window.onresize = function () {
	            try {
	                DEXT5.setSize('100%', (document.documentElement.clientHeight - 10) + "px", id);
	            } catch (e) { }
	        }

	        function SetEditorContentURL(pURL) {
	            try {
	                var tempXML = createXmlDom();
// 	                var XmlBodyATT = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempStr = "";
	                tempStr = ConvertMHTtoHTML(pURL);
	                tempXML = loadXMLString(tempStr)
// 	                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	                var htmlData = getNodeText(XmlBodyDATA);
	                DEXT5.setBodyValue(htmlData, id);
	            } catch (e) { }
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

	                DEXT5.setBodyValue(htmlData, id);
	                return ConnData;
	            } catch (e) { }
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
	                DEXT5.setHtmlValue("<br/>" + xmlhttp.responseText, id);
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
	            /* for (var i = 0; i < GetChildNodes(XmlBodyATT).length; i++) {
	                BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODEVALUE")))
	            } */
	        }

	        function GetEditorContentURL(url) {
	            var tempXML = createXmlDom();
// 	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(url);
	            tempXML = loadXMLString(tempStr);
// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            return getNodeText(XmlBodyDATA);
	        }

	        function GetFieldsList() {
	            var FieldsList = new Array();
	            FieldsList[0] = DEXT5.getElementById("MailSign");
	            return FieldsList;
	        }

	        function GetBodyFields() {
	            var FieldsList = new Array();
	            FieldsList = DEXT5.getDext5BodyDom().getElementsByTagName("*");
	            return FieldsList;
	        }

	        function SetAttribute(type, id, classname) {
	            var selCell = DEXT5.getSelectedCell(id);
	            if (type == "DEL") {
	                selCell[0].removeAttribute("id");
	                if (selCell[0].classList.contains("FIELD"))
	                    selCell[0].classList.remove("FIELD");
	            }
	            else if (type == "LOCK") {
	                if (selCell[0].getAttribute("free") != null)
	                    selCell[0].removeAttribute("free");
	                else
	                    selCell[0].setAttribute("free", "");
	            }
	            else {
	                selCell[0].setAttribute("id", id);
	                if (!selCell[0].classList.contains("FIELD"))
	                    selCell[0].classList.add("FIELD");
	            }

	            var _editor = DEXT5.getEditor(id);
	            _editor._FRAMEWIN.setTableCellSelect(selCell[0]);
	        }

	        function View_CellProperty(g_toggleFlag) {
	            var _editor = DEXT5.getEditor(id);
	            var TotalTag = DEXT5.getDext5BodyDom().getElementsByTagName("TD");
	            try {
	                for (var i = 0 ; i < TotalTag.length; i++) {
	                    if (TotalTag[i].tagName == "TD" && TotalTag[i].id != "") {
	                        if (g_toggleFlag) {
	                            TotalTag[i].setAttribute("beforebgcolor", TotalTag[i].style.backgroundColor);
	                            _editor._FRAMEWIN.setTableCellSelect(TotalTag[i]);
	                        }
	                        else {
	                            TotalTag[i].style.backgroundColor = TotalTag[i].getAttribute("beforebgcolor");
	                            TotalTag[i].removeAttribute("beforebgcolor");
	                        }
	                    }
	                }
	            } catch (e) {
	                alert(e.message);
	            }
	            return g_toggleFlag;
	        }

	        function EditorExistsElement(elementID) {
	            try {
	                var editorDocument = DEXT5.getDext5DocumentDom(id);
	                var ElementObj = editorDocument.getElementById(elementID);
	                if (ElementObj)
	                    return true;
	                else
	                    return false;
	            } catch (e) {
	                return false;
	            }
	        }

	        function FormInfoCheck(type) {
	            try {
	                switch (type) {
	                    case "null":
	                        return DEXT5.isEmpty('DextEditor');
	                        break;
	                    case "body":
	                        var CheckCount = 0;
	                        var HtmlTag = DEXT5.getDext5BodyDom().getElementsByTagName("*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "body")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
	                    case "doctitle":
	                        var CheckCount = 0;
	                        var HtmlTag = DEXT5.getDext5BodyDom().getElementsByTagName("*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "doctitle")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
						case "receiptnumber":
	                        var CheckCount = 0;
	                        var HtmlTag = DEXT5.getDext5BodyDom().getElementsByTagName("*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "receiptnumber")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
	                    case "doctitlefield":
	                        return DEXT5.getDext5DocumentDom("DextEditor").getElementById("body").getAttribute("doctitlefield");
	                        break;
	                    default:
	                }

	            } catch (e) {
	            }
	        }

	        function EditorElement(elementID) {
	            try {
	                var editorDocument = DEXT5.getDext5DocumentDom(id);
	                var ElementObj = editorDocument.getElementById(elementID);
	                if (ElementObj)
	                    return ElementObj;
	                else
	                    return null;

	            } catch (e) {
	                return null;
	            }
	        }

	        function EditorElementSetHtml(elementID, Html) {
	            try {
	                var ElementObj = DEXT5.getElementById(elementID);
	                if (ElementObj) {
	                    ElementObj.innerHTML = Html;
	                }
	            } catch (e) {
	            }
	        }
	        function EditorElementHTML(elementID, gubun) {
	            try {
	                var ElementObj = DEXT5.getElementById(elementID);
	                if (!ElementObj)
	                    return "";
	                else {
	                    if (gubun == "1")
	                        return ElementObj.innerHTML;
	                    else
	                        return ElementObj.outerHTML;
	                }
	            } catch (e) {
	                return "";
	            }
	        }

	        function Set_CellLocked() {
	            for (var i = 0; i < DEXT5.getDext5BodyDom().getElementsByTagName("TD").length; i++) {
	                if (DEXT5.getDext5BodyDom().getElementsByTagName("TD")[i].getAttribute("free") == null) {
	                    DEXT5.getDext5BodyDom().getElementsByTagName("TD")[i].setAttribute("dext_lock", "dext_lock")
	                }
	            }
	        }

	        function GetEditorBody() {
	        	return DEXT5.getDext5BodyDom();
	        }
		</script> 
	</head>
	<body id="dextbody" style="margin: 0px; padding: 0px;">
	    <script type="text/javascript">
	    	var useHTMLMode = "<c:out value='${useHTMLMode}'/>";
	    	var defaultFontFamily = "<c:out value='${defaultFontFamily}'/>";
			var defaultFontSize = "<c:out value='${defaultFontSize}'/>";
			
			// visible 상관 없이 로드
			DEXT5.util.DEXT5_CheckEditorVisible = function() {
				return 1;
			}
			
	        DEXT5.config.DialogWindow = parent.window;
	        DEXT5.config.RemoveItem = "about";
	        if (type == "ADMIN") {
	            DEXT5.config.StatusBarItem = "design,source";
	            DEXT5.config.ManagerMode = "1";
	        }
	
	        if (type == "APPROVAL" || type == "APPROVALG") 
	            DEXT5.config.Height = height + "px";
	        else if (type == "MAIL") 
	            DEXT5.config.Height = (document.documentElement.clientHeight - 10) + "px";
	        else
	            DEXT5.config.Height = (document.documentElement.clientHeight - 10) + "px";
	        
	        if (useHTMLMode == "NO") {
	        	DEXT5.config.StatusBarItem = "design";
	        }
	        
	        DEXT5.config.Lang = "<spring:message code='main.t0619' />";
            DEXT5.config.userFontFamily = defaultFontFamily;
	        DEXT5.config.userFontSize = parseInt(defaultFontSize);
	        DEXT5.config.HandlerUrl = "http://127.0.0.1:8091/ezEditor/dextUpload.do";
	        var editorid = new Dext5editor("editor1");
	    </script>
	</body>
</html>