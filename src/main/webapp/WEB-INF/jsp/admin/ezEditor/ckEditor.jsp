<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/ckEditor/ckeditor.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		
		<script type="text/javascript">
			CKEDITOR.on('instanceReady', function (ev) {
	            ExecuteCommand("maximize");
	            parent.Editor_Complete();
	        });
	
	        // 20161229_소스모드로 이동하면 이벤트가 제거되어 wysiwyg 모드설정시 이벤트 재설정함.
	        CKEDITOR.on('instanceCreated', function (e) {
	            e.editor.on('mode', function (e) {
	                if (e.editor.mode == 'wysiwyg') {
	                    e.editor.editable().on('keyup', function () { CellCheckField(); });
	                    e.editor.editable().on('mouseup', function () { CellCheckField(); });
	                }
	            });
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
	            	if (Data === "") {
						Data = "<p " + defaultFontAndSize + "><br></p><p " + defaultFontAndSize + "><br></p>";
					}
	            	
					CKEDITOR.instances.editor1.editable().setHtml(Data);
					
	                if ("${type}" == "APPROVAL" || "${type}" == "APPROVALG"){
	                    Set_CellLocked();
	                }
	            } catch (e) { }
	        }
	        function GetEditorContent() {
	            try {
	                if ("${type}" == "APPROVAL" || "${type}" == "APPROVALG")
	                    return Get_BodyUnlock(CKEDITOR.instances.editor1.getData());
	                else
	                    return CKEDITOR.instances.editor1.getData();
	            } catch (e) { return ""; }
	        }
	
	        function GetEditorTextContent() {
	            try {
	                if (CKEDITOR.instances.editor1.editable().findOne('STYLE') != null)
	                    CKEDITOR.instances.editor1.editable().findOne('STYLE').remove();
	
	                return CKEDITOR.instances.editor1.editable().$.outerText;
	            } catch (e) { return ""; }
	        }
	
	        function SetEditorTextContent(Data) {
	            try {
	                return CKEDITOR.instances.editor1.editable().$.innerText = Data;
	            } catch (e) { return ""; }
	        }
	
	        function GetBodyValue() {
	            CKEDITOR.instances.editor1.getData();
	        }
	
	        function SetEditorContentURL(url) {
	            var tempXML = createXmlDom();
// 	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(url);
	            tempXML = loadXMLString(tempStr);
	
// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            CKEDITOR.instances.editor1.setData(getNodeText(XmlBodyDATA));
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
	
	        function View_CellProperty(g_toggleFlag) {
	            if (CKEDITOR.instances.editor1.mode !== "wysiwyg") {
	                // 소스보기 일경우 설정보기 안함.
	                return !g_toggleFlag;
	            }
	
	            var TotalTag = CKEDITOR.instances.editor1.document.$.getElementsByTagName("TD");
	
	            for (var i = 0; i < TotalTag.length; i++) {
	                if (TotalTag[i].id != "") {
	                    if (TotalTag[i].classList != null) {
	                        if (TotalTag[i].classList.contains("FIELD")) {
	                            if (g_toggleFlag) {
	                                TotalTag[i].setAttribute("beforebgcolor", TotalTag[i].style.backgroundColor);
	                                TotalTag[i].style.backgroundColor = "#BEE7FC";
	                            }
	                            else {
	                                TotalTag[i].style.backgroundColor = TotalTag[i].getAttribute("beforebgcolor");
	                                TotalTag[i].removeAttribute("beforebgcolor");
	                            }
	                        }
	                    }
	                    else {
	                        if (TotalTag[i].className.indexOf("FIELD") > -1) {
	                            if (g_toggleFlag) {
	                                TotalTag[i].setAttribute("beforebgcolor", TotalTag[i].style.backgroundColor);
	                                TotalTag[i].style.backgroundColor = "#BEE7FC";
	                            }
	                            else {
	                                TotalTag[i].style.backgroundColor = TotalTag[i].getAttribute("beforebgcolor");
	                                TotalTag[i].removeAttribute("beforebgcolor");
	                            }
	                        }
	                    }
	                }
	            }
	
	            return g_toggleFlag;
	        }
	
	        function CellCheckField() {
	            var selectE = null;
	            if (parent.Attribute_Write != undefined) {
	            	parent.Attribute_Write("");
	            	
	                var selection = CKEDITOR.instances.editor1.getSelection();
	                if (selection.getType() == CKEDITOR.SELECTION_ELEMENT) {
	                    selectE = selection.getSelectedElement();
	                } else if (selection.getType() == CKEDITOR.SELECTION_TEXT) {
	                    if (CKEDITOR.env.ie) {
	                        selection.unlock(true);
	                        selectE = selection.getNative().anchorNode;
	                    } else {
	                        selectE = selection.getNative().anchorNode;
	                    }
	
	                    while (selectE && !selectE.previousElementSibling && !selectE.nextElementSibling) {
	                        selectE = selectE.parentNode;
	                        if (selectE.tagName == "TD" || selectE.tagName == "TH") {
	                            break;
	                        }
	                    }
	                }
	
	                if (selectE != null && selectE.tagName == "TD")
	                    parent.Attribute_Write(GetAttribute(selectE, "id"));
	                else {
	                    while (selectE && !selectE.previousElementSibling && !selectE.nextElementSibling) {
	                        selectE = selectE.parentNode;
	                        if (selectE.tagName == "TD") {
	                            parent.Attribute_Write(GetAttribute(selectE, "id"));
	                            break;
	                        }
	                    }
	                }
	            }
	        }
	
	        function SetAttribute(type, id, classname) {
	            if (CKEDITOR.instances.editor1.mode !== "wysiwyg") {
	                // 소스보기 일경우 설정보기 안함.
	                return;
	            }
	
	            var selCell = null;
	            var selection = CKEDITOR.instances.editor1.getSelection();
	            
	            if (selection == null) {
	                return;
	            }
	
	            if (selection.getType() == CKEDITOR.SELECTION_ELEMENT) {
	                selCell = selection.getSelectedElement();
	            } else if (selection.getType() == CKEDITOR.SELECTION_TEXT) {
	                if (CKEDITOR.env.ie) {
	                    selection.unlock(true);
	                    selCell = selection.getNative().anchorNode;
	                } else {
	                    selCell = selection.getNative().anchorNode;
	                }
	
	                while (selCell && !selCell.previousElementSibling && !selCell.nextElementSibling) {
	                    selCell = selCell.parentNode;
	                    if (selCell.tagName == "TD" || selCell.tagName == "TH") {
	                        break;
	                    }
	                }
	            }
	
	            if (selCell == null) {
	                return;
	            }
	
	            if (type == "DEL") {
	            	// 일지 양식작성에서 사용하는 부분
	            	if ("${type}" == "JOURNAL") {
	            		selCell.removeAttribute("id");
	            		selCell.innerHTML = "";
	            	} else {
		                selCell.removeAttribute("id");
	            	}
	
	            	//2018-10-01 김보미 - 값이 비어있는 부분 클릭 후 취소시 포커스(배경색이 파란색으로)되지 않도록 변경 
	            	if (selCell.className == "FIELD") {
		                if (selCell.classList != null) {
		                    if (selCell.classList.contains("FIELD")) {
		                        selCell.classList.remove("FIELD");
		                    }
		                }
		                else {
		                    if (selCell.className.indexOf("FIELD") > -1) {
		                        selCell.className = selCell.className.replace("FIELD ", "").replace(" FIELD", "").replace("FIELD", "");
		                    }
		                }
		
		                parent.Attribute_Write("");
		                ChangeCell_display(selCell);
	            	}
	            }
	            else if (type == "LOCK") {
	                if (selCell.getAttribute("free") != null) {
	                    selCell.removeAttribute("free");
	                }
	                else {
	                    selCell.setAttribute("free", "free");
	                }
	                ChangeCell_display(selCell);
	            }
	            else {
	            	// 일지양식작성에서 사용하는 부분
	                if ("${type}" == "JOURNAL") {
		                selCell.setAttribute("id", id);
	                	selCell.innerHTML = "@" + id;
	                	
	                } else {
		                selCell.setAttribute("id", id);
	                }
	
	                if (selCell.classList != null) {
	                    if (!selCell.classList.contains("FIELD"))
	                        selCell.classList.add("FIELD");
	                }
	                else {
	                    if (selCell.className.indexOf("FIELD") < 0) {
	                        if (selCell.className === "") {
	                            selCell.className = "FIELD";
	                        }
	                        else {
	                            selCell.className = selCell.className + " FIELD";
	                        }
	                    }
	                }
	                ChangeCell_display(selCell);
	            }
	        }
	
	        function ChangeCell_display(selectCell) {
	            // 셀설정시 설정 셀 배경색 변경표시후 0.5초뒤 원복
	            selectCell.setAttribute("beforebgcolor", selectCell.style.backgroundColor);
	            selectCell.style.backgroundColor = "#BEE7FC";
	
	            setTimeout(function () {
	                selectCell.style.backgroundColor = selectCell.getAttribute("beforebgcolor");
	                selectCell.removeAttribute("beforebgcolor");
	            }, 500);
	        }
	
	        function FormInfoCheck(type) {
	            try {
	                switch (type) {
	                    case "null":
	                        if (CKEDITOR.instances.editor1.getData() == "")
	                            return true;
	                        else
	                            return false;
	                        break;
	                    case "body":
	                        var CheckCount = 0;
	                        var HtmlTag = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "body")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
	                    case "doctitle":
	                        var CheckCount = 0;
	                        var HtmlTag = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "doctitle")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
	                    case "doctitlefield":
	                        var CheckCount = 0;
	                        var HtmlTag = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*");
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
		</script>
	</head>
	<body style="margin: 0px; padding: 0px;">
	    <textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
	    <script type="text/javascript">CKEDITOR.replace('editor1', { fullPage: false });</script>
	    <script type="text/javascript">
	    	var defaultFontFamily = "${defaultFontFamily}";
			var defaultFontSize = "${defaultFontSize}";
			var defaultFontAndSize = "style='font-size:" + defaultFontSize + ";font-family:" + defaultFontFamily + "'";
			
	        CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
	        CKEDITOR.config.height = parseInt("${height}") - 120 + "px";
	        CKEDITOR.config.font_defaultLabel = defaultFontFamily;
            CKEDITOR.config.font_names = "<spring:message code='main.t0620' />";
            CKEDITOR.config.language = "<spring:message code='main.t0619' />";
	    </script>
	</body>
</html>