<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
<!-- 		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> -->
		<title></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/dext5Editor/js/dext5editor.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		
		<script type="text/javascript">
			var formID = "${formID}";
			
			function dext_editor_loaded_event(editor) {
		        // 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
		        if (parent.onloadflag || typeof parent.onloadflag === "undefined") {
		            parent.Editor_Complete();
	                DEXT5.showTopMenu(1, formID);
		        } else {
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
		        	parent.Attribute_Write("");
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
		            DEXT5.setBodyValue(Data, formID);
		            Set_CellLocked();
		        } catch (e) { }
		    }
		
		    function GetEditorContent() {
		        try {
					return Get_BodyUnlock(DEXT5.getBodyValue(formID));
		        } catch (e) {
		            alert("본문 내용을 가져오는중 에러가 발생하였습니다.");
		        }
		    }
		
		    function GetEditorTextContent() {
		        try {
		            return DEXT5.getBodyTextValue(formID);
		        } catch (e) {
		            alert("본문 내용을 가져오는중 에러가 발생하였습니다.");
		        }
		    }
		
		    function SetEditorContentURL(pURL) {
		        try {
		            var tempXML = createXmlDom();
// 		            var XmlBodyATT = createXmlDom();
		            var XmlBodyDATA = createXmlDom();
		            var tempStr = "";
		            tempStr = ConvertMHTtoHTML(pURL);
		            tempXML = loadXMLString(tempStr)
// 		            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
		            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
		            var htmlData = getNodeText(XmlBodyDATA);
		            DEXT5.setBodyValue(htmlData, formID);
		        } catch (e) { }
		    }
		
		    function SetEditorContentURL_Admin(pURL) {
		        try {
		            var tempXML = createXmlDom();
// 		            var XmlBodyATT = createXmlDom();
		            var XmlBodyDATA = createXmlDom();
		            var tempStr = "";
		            tempStr = ConvertMHTtoHTML(pURL);
		            tempXML = loadXMLString(tempStr)
// 		            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
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
		
		            DEXT5.setBodyValue(htmlData, formID);
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
		            DEXT5.setHtmlValue("<br/>" + xmlhttp.responseText, formID);
		        } catch (e) { }
		    }
		
		    function SetEditorContentPathSign(url, strMailSign) {
		        var tempXML = createXmlDom();
// 		        var XmlBodyATT = createXmlDom();
		        var XmlBodyDATA = createXmlDom();
		        var tempStr = "";
		        tempStr = ConvertMHTtoHTML(url);
		        tempXML = loadXMLString(tempStr);
		
// 		        XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
		        XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
		        /* for (var i = 0; i < GetChildNodes(XmlBodyATT).length; i++) {
		            BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODEVALUE")))
		        } */
		    }
		
		    function GetEditorContentURL(url) {
		        var tempXML = createXmlDom();
// 		        var XmlBodyATT = createXmlDom();
		        var XmlBodyDATA = createXmlDom();
		        var tempStr = "";
		        tempStr = ConvertMHTtoHTML(url);
		        tempXML = loadXMLString(tempStr);
// 		        XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
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
		        var selCell = DEXT5.getSelectedCell(formID);
		        
		        if (type == "DEL") {
		        	// 일지 양식작성에서 사용하는 부분
	            	if ('<c:out value="${type}"/>' == "JOURNAL") {
	            		selCell[0].removeAttribute("id");
	            		selCell[0].innerHTML = "";
	            	} else {
		                selCell[0].removeAttribute("id");
	            	}
		            // selCell[0].removeAttribute("id");
		            if (selCell[0].classList.contains("FIELD")) {
		                selCell[0].classList.remove("FIELD");
				        
		                setTimeout(function () {
				        	selCell[0].style.backgroundColor = selCell[0].getAttribute("beforebgcolor");
				        	selCell[0].removeAttribute("beforebgcolor");
			            }, 500);		            	
		            }
		        }
		        else if (type == "LOCK") {
		            if (selCell[0].getAttribute("free") != null) {
		                selCell[0].removeAttribute("free");
		            }
		            else {
		                selCell[0].setAttribute("free", "");
		            }
		            
			        setTimeout(function () {
			        	selCell[0].style.backgroundColor = selCell[0].getAttribute("beforebgcolor");
			        	selCell[0].removeAttribute("beforebgcolor");
		            }, 500);
		        }
		        else {
		        	// 일지양식작성에서 사용하는 부분
	                if ('<c:out value="${type}"/>' == "JOURNAL") {
		                selCell[0].setAttribute("id", id);
	                	selCell[0].innerHTML = "@" + id;
	                	
	                } else {
		                selCell[0].setAttribute("id", id);
	                }
		            // selCell[0].setAttribute("id", id);
		            if (!selCell[0].classList.contains("FIELD")) {
		                selCell[0].classList.add("FIELD");
		            }
		            
			        setTimeout(function () {
			        	selCell[0].style.backgroundColor = selCell[0].getAttribute("beforebgcolor");
			        	selCell[0].removeAttribute("beforebgcolor");
		            }, 500);
		        }
		
		        var _editor = DEXT5.getEditor(formID);
		        _editor._FRAMEWIN.setTableCellSelect(selCell[0]);
		        
		      	//2018-10-01 김보미 - 값이 비어있는 부분 클릭 후 취소시 포커스(배경색이 파란색으로)되지 않도록 변경
		        //2017-10-25 이효진 색상복구 스크립트 추가
// 		        setTimeout(function () {
// 		        	selCell[0].style.backgroundColor = selCell[0].getAttribute("beforebgcolor");
// 		        	selCell[0].removeAttribute("beforebgcolor");
// 	            }, 500);
		    }
		
		    function View_CellProperty(g_toggleFlag) {
		        var _editor = DEXT5.getEditor(formID);
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
		            var editorDocument = DEXT5.getDext5DocumentDom(formID);
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
		            var editorDocument = DEXT5.getDext5DocumentDom(formID);
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
		    
		    function Get_BodyUnlock(HtmlBody) {
	            var Div_Body = document.createElement("DIV");
	            Div_Body.innerHTML = HtmlBody;
	            var TDRows = Div_Body.getElementsByTagName("*");
	            for (var i = 0; i < TDRows.length; i++) {
	                if (TDRows[i].getAttribute("dext_lock") != null) {
	                    TDRows[i].removeAttribute("dext_lock");
	                }
	                /* } else if (TDRows[i].getAttribute("cell_lock") != null) {
	                	TDRows[i].removeAttribute("cell_lock");
	                } else if (TDRows[i].getAttribute("table_lock") != null) {
	                	TDRows[i].removeAttribute("table_lock");
	                } */
	            }
	            return Div_Body.innerHTML;
	        }
		</script>
	</head>
	<body id="dextbody" style="margin: 0px; padding: 0px;">
		<script type="text/javascript">
			var defaultFontFamily = "${defaultFontFamily}";
			var defaultFontSize = "${defaultFontSize}";
			
			// visible 상관 없이 로드
			DEXT5.util.DEXT5_CheckEditorVisible = function() {
				return 1;
			}
			
	        DEXT5.config.DialogWindow = parent.window;
	        DEXT5.config.RemoveItem = "about";
            DEXT5.config.StatusBarItem = "design,source";
            DEXT5.config.ManagerMode = "1";
	        
            DEXT5.config.Height = (parseInt('<c:out value="${height}"/>') - 12) + "px";
	        
	        DEXT5.config.userFontFamily = defaultFontFamily;
            DEXT5.config.Lang = "<spring message code = 'main.t0619' />";
	        DEXT5.config.userFontSize = defaultFontSize;
	        
	        new Dext5editor(formID);
	    </script>
	</body>
</html>