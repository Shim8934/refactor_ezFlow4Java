<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	                xfe.setBodyValue(Data);
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
	        
	        function BodySetAttribute(name, Value) {
	        	xfe.getDom().body.setAttribute(name, Value, 0);
	        }

	        function BodyGetAttribute(name) {
	        	xfe.getDom().body.getAttribute(name);
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
	
	        function CellCkeckField() {
	            if (parent.Attribute_Write != undefined) {
	                // 태그프리 블록지정시 xfe.getCurrentElement()는 배열로 리턴. 블록지정이 아닐경우는 1개만 리턴
	                var selectE = xfe.getCurrentElement();
	
	                if (Array.isArray(selectE)) {
	                    if (selectE.length > 1) {
	                        selectE = selectE[0];
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
	
	        function View_CellProperty(g_toggleFlag) {
	            var TotalTag = xfe.getBody().getElementsByTagName("TD");
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
	
	        function SetAttribute(type, id, classname) {
	            var index = xfe.getActiveTab();
	            if (index.index != 0) {
	                return false;
	            }
	
	            var selCell = xfe.getCurrentElement();
	
	            if (Array.isArray(selCell)) {
	                selCell = selCell[0];
	            }
	            else if (selCell == null) {
	                return false;
	            }
	
	            while (selCell && !selCell.previousElementSibling && !selCell.nextElementSibling) {
	                selCell = selCell.parentNode;
	                if (selCell.tagName == "TD" || selCell.tagName == "TH") {
	                    break;
	                }
	            }
	
	            if (type == "DEL") {
	                selCell.removeAttribute("id");
	
	                if (selCell.classList != null) {
	                    if (selCell.classList.contains("FIELD"))
	                        selCell.classList.remove("FIELD");
	                }
	                else {
	                    if (selCell.className.indexOf("FIELD") > -1) {
	                        selCell.className = selCell.className.replace("FIELD ", "").replace(" FIELD", "").replace("FIELD", "");
	                    }
	                }
	
	                parent.Attribute_Write("");
	                ChangeCell_display(selCell);
	            }
	            else if (type == "LOCK") {
	                // 블록지정일 경우 모든 블록 처리.
	                if (Array.isArray(xfe.getCurrentElement())) {
	                    var isFree_FirstCell = false;
	                    selCell = xfe.getCurrentElement();
	
	                    for (var i = 0; i < selCell.length; i++) {
	                        if (i === 0) {
	                            if (selCell[i].getAttribute("free") != null) {
	                                selCell[i].removeAttribute("free");
	                                isFree_FirstCell = false;
	                            }
	                            else {
	                                selCell[i].setAttribute("free", "free");
	                                isFree_FirstCell = true;
	                            }
	                        }
	                        else {
	                            if (isFree_FirstCell) {
	                                selCell[i].setAttribute("free", "free");
	                            }
	                            else {
	                                selCell[i].removeAttribute("free");
	                            }
	                        }
	                    }
	
	                    for (var i = 0; i < selCell.length; i++) {
	                        ChangeCell_display(selCell[i]);
	                    }
	                }
	                else {
	                    if (selCell.getAttribute("free") != null)
	                        selCell.removeAttribute("free");
	                    else
	                        selCell.setAttribute("free", "free");
	
	                    ChangeCell_display(selCell);
	                }
	            }
	            else {
	                selCell.setAttribute("id", id);
	
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
	                        if (xfe.getBodyValue() == "")
	                            return true;
	                        else
	                            return false;
	                        break;
	                    case "body":
	                        var CheckCount = 0;
	                        var HtmlTag = xfe.getBodyValue().getElementsByTagName("*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "body")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
	                    case "doctitle":
	                        var CheckCount = 0;
	                        var HtmlTag = xfe.getBodyValue().getElementsByTagName("*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "doctitle")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
	                    case "doctitlefield":
	                        var CheckCount = 0;
	                        var HtmlTag = xfe.getBodyValue().getElementsByTagName("*");
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
			
			/* window.onresize = function () {
	            try {
	                xfe.setWidth("100%");
	                xfe.setHeight(document.documentElement.clientHeight + "px");
	            } catch (e) { }
	        } */
		</script>
	</head>
	<body style="margin: 0px; padding: 0px; overflow: hidden;" id="xfe">
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
	    	
	        xfe = new XFE({
	        	lang : lang,
	            basePath : "/js/ezEditor/tfxEditor",
	            width : "100%",
// 	            height : (document.documentElement.clientHeight) + "px",
	            height : parseInt("${height}") - 8 + "px",
	            initFontFamilyMenu : initFontFamilyMenu,
	            initFontFamily : "<spring:message code='main.t246' />",
	            initFontSize : "13px",
	            skin : "classic",
	            uploadFilePath : uploadFilePath,
	            uploadPasteContentsPath : uploadPasteContentsPath,
	            onMouseUp : CellCkeckField,
	            onKeyUp : CellCkeckField
	        });
	        
	        xfe.render('xfe');
	        
	        if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailoutofoffice.do") > -1) {
	        	xfe.showToolbarItem(0, 12, false);
	        	xfe.showToolbarItem(0, 13, false);
	        	xfe.showToolbarItem(0, 14, false);
	        }
	        
	        window.onload = parent.Editor_Complete;
	    </script>
	</body>
</html>