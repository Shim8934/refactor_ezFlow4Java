<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/namoEditor/js/namo_scripteditor.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
		var userLang = "${userInfo.lang}";
		var type = '<c:out value="${type}"/>';
		var height = '<c:out value="${height}"/>';
		
        function LockF5() {
            if (event.keyCode == 116) {
                event.keyCode = 0;
                return false;
            }
        }
        document.onkeydown = LockF5;
        function OnInitCompleted(e) {
            // 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
            if (parent.onloadflag || typeof parent.onloadflag === "undefined") {
                parent.Editor_Complete();

	            CrossEditor.SetBodyStyle("font-family", "<spring:message code='main.t246' />");
				CrossEditor.SetBodyStyle("font-Size", "13px");
            } else {
                setTimeout(OnInitCompleted, 10);
            }
        }

        var BlockArr = new Array();
        function CE_OnMouseActive(e) {
            if (e.type == "mouseup") {
                if (parent.Attribute_Write != undefined) {
                	parent.Attribute_Write("");
                    View_CellProperty2();
                    var parentTag = e.targetNode;
                    if (parentTag.tagName == "TD")
                        parent.Attribute_Write(GetAttribute(parentTag, "id"));
                    else
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

        function CE_OnKeyActive(e) {
            if (e.type == "keyup") {
                if (parent.Attribute_Write != undefined) {
                    View_CellProperty2();
                    var parentTag = e.targetNode;
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
        }

        function SetAttribute(type, id, classname) {
            var selCell = CrossEditor.GetCaretObject();
            if (selCell.tagName != "TD") {
                while (selCell && !selCell.previousElementSibling && !selCell.nextElementSibling) {
                    selCell = selCell.parentNode;
                    if (selCell.tagName == "TD") {
                        break;
                    }
                }
            }

            if (type == "DEL") {
            	// 일지 양식작성에서 사용하는 부분
            	if ('<c:out value="${type}"/>' == "JOURNAL") {
            		selCell.removeAttribute("id");
            		selCell.innerHTML = "";
            	} else {
	                selCell.removeAttribute("id");
            	}
            	
                if (selCell.classList.contains("FIELD")) {
                    selCell.classList.remove("FIELD");
                
	                BlockArr.push(selCell);
	                selCell.style.backgroundColor = "#BEE7FC";
                }
            }
            else if (type == "LOCK") {
                if (selCell.getAttribute("free") != null) {
                    selCell.removeAttribute("free");
                }
                else {
                    selCell.setAttribute("free", "");
                }
                
                BlockArr.push(selCell);
                selCell.style.backgroundColor = "#BEE7FC";
            }
            else {
            	// 일지양식작성에서 사용하는 부분
                if ('<c:out value="${type}"/>' == "JOURNAL") {
	                selCell.setAttribute("id", id);
                	selCell.innerHTML = "@" + id;
                	
                } else {
	                selCell.setAttribute("id", id);
                }
            	
                if (!selCell.classList.contains("FIELD")) {
                    selCell.classList.add("FIELD");
                }
                
	            BlockArr.push(selCell);
	            selCell.style.backgroundColor = "#BEE7FC";
            }
          	   //2018-10-01 김보미 - 값이 비어있는 부분 클릭 후 취소시 포커스(배경색이 파란색으로)되지 않도록 변경
//             BlockArr.push(selCell);
//             selCell.style.backgroundColor = "#BEE7FC";
        }

        function View_CellProperty(g_toggleFlag) {
            var TotalTag = CrossEditor.GetBodyElementsByTagName("TD");
            try {
                for (var i = 0 ; i < TotalTag.length; i++) {
                    if (TotalTag[i].tagName == "TD" && TotalTag[i].id != "") {
                        if (g_toggleFlag) {
                            TotalTag[i].setAttribute("beforebgcolor", TotalTag[i].style.backgroundColor);
                            TotalTag[i].style.backgroundColor = "#BEE7FC";
                            BlockArr.push(TotalTag[i]);
                        }
                        else {
                            TotalTag[i].style.backgroundColor = TotalTag[i].getAttribute("beforebgcolor");
                            TotalTag[i].removeAttribute("beforebgcolor");
                            BlockArr.push(TotalTag[i]);
                        }
                    }
                }
            } catch (e) {
                alert(e.message);
            }

            return g_toggleFlag;
        }

        function View_CellProperty2() {
            var BlockCnt = BlockArr.length;
            for (var i = BlockCnt - 1; i >= 0; i--) {
                BlockArr[i].style.backgroundColor = "";
                BlockArr.pop();
            }
        }

        function SetBodyValue(Data) {
            try {
                CrossEditor.SetValue(Data);

            } catch (e) { }
        }

        function SetEditorContent(Data) {
            try {
            	if (Data === "") {
					Data = "<p " + defaultFontAndSize + "><br></p>";
				}
            	
                CrossEditor.SetBodyValue(Data);
//                 Set_CellLocked();

            } catch (e) { }
        }

        function SetEditorContentURL(pURL) {
            try {
                var tempXML = createXmlDom();
//                 var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(pURL);
                tempXML = loadXMLString(tempStr)
//                 XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                var htmlData = getNodeText(XmlBodyDATA);
                CrossEditor.SetBodyValue(htmlData);
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
                CrossEditor.SetBodyValue("<br/>" + xmlhttp.responseText);
            } catch (e) { }
        }

        function SetEditorContentURL_Admin(pURL) {
            try {
                var tempXML = createXmlDom();
//                 var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(pURL);
                tempXML = loadXMLString(tempStr)
//                 XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];

                var Doc_ContentHtml = document.createElement("DIV");
                Doc_ContentHtml.innerHTML = getNodeText(XmlBodyDATA);

                var htmlData = "";
                var ConnData = "";
                if (GetChildNodes(Doc_ContentHtml)[0].id == "conn") {
                    ConnData = Doc_ContentHtml.children[0].innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', '');
                    htmlData = Doc_ContentHtml.children[1].outerHTML;
                }
                else {
                    htmlData = getNodeText(XmlBodyDATA);
                }
                CrossEditor.SetBodyValue(htmlData);
                return ConnData;
            } catch (e) { }
        }

        function FormInfoCheck(type) {
            try {
                switch (type) {
                    case "null":
                        if (CrossEditor.GetEditor() == null)
                            return true;
                        else
                            return false;
                        break;
                    case "body":
                        var CheckCount = 0;
                        var HtmlTag = CrossEditor.GetBodyElementsByTagName("*");
                        for (var i = 0 ; i < HtmlTag.length; i++) {
                            if (GetAttribute(HtmlTag[i], "id") == "body")
                                CheckCount++;
                        }
                        return CheckCount;
                        break;
                    case "doctitle":
                        var CheckCount = 0;
                        var HtmlTag = CrossEditor.GetBodyElementsByTagName("*");
                        for (var i = 0 ; i < HtmlTag.length; i++) {
                            if (GetAttribute(HtmlTag[i], "id") == "doctitle")
                                CheckCount++;
                        }
                        return CheckCount;
                        break;
					case "receiptnumber":
                        var CheckCount = 0;
                        var HtmlTag = CrossEditor.GetBodyElementsByTagName("*");
                        for (var i = 0 ; i < HtmlTag.length; i++) {
                            if (GetAttribute(HtmlTag[i], "id") == "receiptnumber")
                                CheckCount++;
                        }
                        return CheckCount;
                        break;
                    case "doctitlefield":
                        var CheckCount = 0;
                        var HtmlTag = CrossEditor.GetBodyElementsByTagName("*");
                        for (var i = 0 ; i < HtmlTag.length; i++) {
                            if (GetAttribute(HtmlTag[i], "id") == "body")
                                return GetAttribute(HtmlTag[i], "doctitlefield");
                        }
                        break;
                    default:
                }

            } catch (e) {
            }
        }

        function GetEditorContent() {
            try {
                return Get_BodyUnlock(CrossEditor.GetBodyValue("XHTML"));
            } catch (e) { return ""; }
        }

        function GetEditorContentURL(url) {
            var tempXML = createXmlDom();
//             var XmlBodyATT = createXmlDom();
            var XmlBodyDATA = createXmlDom();
            var tempStr = "";
            tempStr = ConvertMHTtoHTML(url);
            tempXML = loadXMLString(tempStr);
//             XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
            return getNodeText(XmlBodyDATA);
        }

        function GetEditorTextContent() {
            try {
                return CrossEditor.GetTextValue();
            } catch (e) { return ""; }
        }

        function Get_BodyUnlock(HtmlBody) {
            var Div_Body = document.createElement("DIV");
            Div_Body.innerHTML = HtmlBody;
            var TDRows = Div_Body.getElementsByTagName("*");
            for (var i = 0; i < TDRows.length; i++) {
                if (TDRows[i].getAttribute("namo_lock") != null) {
                    TDRows[i].removeAttribute("namo_lock");
                }
            }
            return Div_Body.innerHTML;
        }

        /* function Set_CellLocked() {
            for (var i = 0; i < CrossEditor.GetBodyElementsByTagName("*").length; i++) {
                if (CrossEditor.GetBodyElementsByTagName("*")[i].tagName == "TD") {
                    if (CrossEditor.GetBodyElementsByTagName("*")[i].getAttribute("free") == null) {
                        CrossEditor.GetBodyElementsByTagName("*")[i].setAttribute("namo_lock", "namo_lock")
                    }
                }
            }
        } */

        function SetEditorFocus() {
            try {
                CrossEditor.SetFocusEditor();
            } catch (e) {
            }
        }

        function EditorElementSetHtml(elementID, Html) {
            try {
                var ElementDoc = CrossEditor.GetEditorDocument("doc");
                if (ElementDoc) {
                    var ElementObj = ElementDoc.getElementById(elementID);
                    if (ElementObj) {
                        ElementObj.innerHTML = Html;
                    }
                }
            } catch (e) {
            }
        }

        function EditorElementHTML(elementID, gubun) {
            try {
                var ElementObj;
                for (var i = 0; i < CrossEditor.GetBodyElementsByTagName("*").length; i++) {
                    if (CrossEditor.GetBodyElementsByTagName("*")[i].id == elementID)
                        ElementObj = CrossEditor.GetBodyElementsByTagName("*")[i];
                }

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

        function GetFieldsList() {
            var FieldsList = new Array();
            for (var i = 0; i < CrossEditor.GetBodyElementsByTagName("*").length; i++) {
                if (CrossEditor.GetBodyElementsByTagName("*")[i].id == "MailSign")
                    FieldsList[0] = CrossEditor.GetBodyElementsByTagName("*")[i];
            }
            return FieldsList;
        }

        function GetBodyFields() {
            var FieldsList = new Array();
            FieldsList = CrossEditor.GetBodyElementsByTagName("*");
            return FieldsList;
        }
    </script>
</head>
<body style="margin: 0px; padding: 0px;">
    <script type="text/javascript">
        var CrossEditor = new NamoSE("Namo");
        var defaultFontFamily = "${defaultFontFamily}";
		var defaultFontSize = "${defaultFontSize}";
		var defaultFontAndSize = "style='font-size:" + defaultFontSize + ";font-family:" + defaultFontFamily + "'";
		
		var fontList = "<spring:message code='main.t0620' />".split(";");
        var fontListObject = {};
        for (var i = 0; i < fontList.length; i++) {
        	fontListObject[fontList[i]] = fontList[i];
        }
		
		CrossEditor.params.UploadFileExecutePath = "${serverUrl}/ezEditor/namoUpload.do?type=" + type;
		CrossEditor.params.Height = (height - 10) + "px";
		
		CrossEditor.params.FullScreen = true;
        CrossEditor.params.PutStyleInBody = true;
        CrossEditor.params.Font = fontListObject;
        CrossEditor.params.ParagraphTagStyle = {"font-size":defaultFontSize, "font-family":defaultFontFamily};

        if (userLang == "1") {
        	CrossEditor.params.UserLang = "kor";
        } else if (userLang == "2") {
        	CrossEditor.params.UserLang = "enu";
        } else if (userLang == "3") {
        	CrossEditor.params.UserLang = "jpn";
        } else {
        	CrossEditor.params.UserLang = "chs";
        }

        CrossEditor.EditorStart();
    </script>
</body>
</html>