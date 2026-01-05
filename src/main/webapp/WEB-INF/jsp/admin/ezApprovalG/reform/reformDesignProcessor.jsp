<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/reform/designProcessor.css')}" type="text/css">
<jsp:include page="lang/lang.jsp"></jsp:include>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/reform/reformDesignProcessor.js')}"></script>
<script>
	var editorInfo = {
		initFontFamilyMenu: "<spring:message code='main.t0620' />".split(";"),
		defaultFontFamily: "${defaultFontFamily}",
		defaultFontSize: "${defaultFontSize}",
		height: "762px"
	}
</script>
	<c:if test="${userlang ne '1'}">
		<style type="text/css">
			.section2 {padding: 15px 15px 55px 15px;}
			
		</style>
	</c:if>
<c:choose>
	<c:when test="${editor eq 'DEXT'}">
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/dext5Editor/js/dext5editor.js')}"></script>
		<script type="text/javascript">
			var dextId = "reform-dext";
			
			// 이 함수는 DEXT 에디터에 양식이 로드되기 전 DEXT 에디터의 초기화가 완료되면 호출된다.
			function dext_editor_loaded_event(editor) {
				DEXT5.showTopMenu(1, dextId);
				
				// 기존 양식을 로드하는 경우
				if (parent.reformUrl != "") {
					// AJAX를 동기식으로 호출하여 양식을 로드한다.
					SetEditorContentURL(parent.reformUrl);
				}
				
				// 기존 양식을 로드하는 경우엔 양식 로드가 완료된 이후에 호출된다.
				onFormDocumentLoadHandlerForDEXT5();
			}

			function dext_key_event(type, event, currElem) {
				if (type == "keyup") {
					lastSelectedElement = currElem;
					
					var parentTag = currElem;
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

			function dext_mouse_event(type, event, currElem) {
				if (type == "mousedown") {
					// this function needs to be called since webEditorDocument.reform_onClickHandler is cleared
					// after coming back to DESIGN mode from HTML mode in DEXT5.
					restoreAfterHTMLSourceEdit();
					
					lastSelectedElement = currElem;
					
					if (currElem.tagName == "TD" || currElem.tagName == "TH") {
						var tableElement = currElem.parentNode.parentNode.parentNode;
						var dataType = tableElement.getAttribute("data-type");
						if (dataType == "grid") {
							reform_onClickHandlerForGridInDEXT5(event);
						}
					} else if (currElem.parentNode.tagName == "TD" || currElem.parentNode.tagName == "TH") {
						var tableElement = currElem.parentNode.parentNode.parentNode.parentNode;
						var dataType = tableElement.getAttribute("data-type");
						if (dataType == "grid") {
							reform_onClickHandlerForGridInDEXT5(event);
						} else {
							var attValue = currElem.getAttribute("data-reform_flag");
							if (attValue == "1") {
								reform_onClickHandler(event);
							}
						}
					} else {
						var attValue = currElem.getAttribute("data-reform_flag");
						if (attValue == "1") {
							reform_onClickHandler(event);
						}
					}
					
					var parentTag = currElem;
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

			function dext_editor_afterchangemode_event(afterMode, preMode, editorID) {
				if (preMode == "source" && afterMode == "design") {
					restoreAfterHTMLSourceEdit();
					
					if (IsUIDataBindControlListEmpty()) {
						addDataBindControlListToUIDataBindControlList();
					}
				}
			}

			function dext_editor_beforepaste_event(pasteSource) {
				return "";
			}

			function SetEditorContent(Data) {
				try {
					DEXT5.setBodyValue(Data, dextId);
				} catch (e) {}
			}
			function GetEditorContent() {
				try {
					return DEXT5.getBodyValue(dextId);
				} catch (e) {
					return "";
				}
			}
			function GetEditorTextContent() {
				try {
					return DEXT5.getBodyTextValue(dextId);
				} catch (e) {
					return "";
				}
			}

			window.onresize = function() {
				try {
					DEXT5.setSize('100%', (document.documentElement.clientHeight - 10) + "px", dextId);
				} catch (e) {}
			}

			function SetEditorContentURL(pURL) {
				try {
					var tempXML = createXmlDom();
					var XmlBodyATT = createXmlDom();
					var XmlBodyDATA = createXmlDom();
					var tempStr = "";
					// ConvertMHTtoHTML 함수는 MHT 파일안의 SQL문을 암호화 하지 않은 상태로 반환한다.
					tempStr = ConvertMHTtoHTML(pURL);
					tempXML = loadXMLString(tempStr)
					XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
					XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
					var htmlData = getNodeText(XmlBodyDATA);
					DEXT5.setBodyValue(htmlData, dextId);
				} catch (e) {}
			}

			function SetEditorContentURL_Admin(pURL) {
				try {
					var tempXML = createXmlDom();
					var XmlBodyATT = createXmlDom();
					var XmlBodyDATA = createXmlDom();
					var tempStr = "";
					tempStr = ConvertMHTtoHTML_URL(pURL);
					tempXML = loadXMLString(tempStr)
					XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
					XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
					
					var Doc_ContentHtml = document.createElement("DIV");
					Doc_ContentHtml.innerHTML = getNodeText(XmlBodyDATA);
					
					var htmlData = "";
					var ConnData = "";
					if (GetChildNodes(Doc_ContentHtml)[0].id == "conn") {
						ConnData = Doc_ContentHtml.children[0].innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', '');
						htmlData = Doc_ContentHtml.children[1].outerHTML;
					} else {
						htmlData = getNodeText(XmlBodyDATA);
					}
					DEXT5.setBodyValue(htmlData, dextId);
					return ConnData;
				} catch (e) {}
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
					DEXT5.setHtmlValue("<br/>" + xmlhttp.responseText, dextId);
				} catch (e) {}
			}

			function SetEditorContentPathSign(url, strMailSign) {
				var tempXML = createXmlDom();
				var XmlBodyATT = createXmlDom();
				var XmlBodyDATA = createXmlDom();
				var tempStr = "";
				tempStr = ConvertMHTtoHTML_URL(url);
				tempXML = loadXMLString(tempStr);
				
				XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
				XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
				CKEDITOR.instances.editor1.editable().setHtml(getNodeText(XmlBodyDATA) + strMailSign);
				for (var i = 0; i < GetChildNodes(XmlBodyATT).length; i++) {
					BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODEVALUE")))
				}
			}

			function GetEditorContentURL(url) {
				var tempXML = createXmlDom();
				var XmlBodyATT = createXmlDom();
				var XmlBodyDATA = createXmlDom();
				var tempStr = "";
				tempStr = ConvertMHTtoHTML_URL(url);
				tempXML = loadXMLString(tempStr);
				XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
				XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
				return getNodeText(XmlBodyDATA);
			}

			function GetFieldsList() {
				var FieldsList = new Array();
				FieldsList[0] = DEXT5.getElementById("MailSign");
				return FieldsList;
			}

			function SetAttribute(type, id, classname) {
				var selCell = DEXT5.getSelectedCell(dextId);
				if (type == "DEL") {
					selCell[0].removeAttribute("id");
					if (selCell[0].classList.contains("FIELD"))
						selCell[0].classList.remove("FIELD");
				} else if (type == "LOCK") {
					if (selCell[0].getAttribute("free") != null)
						selCell[0].removeAttribute("free");
					else
						selCell[0].setAttribute("free", "");
				} else {
					selCell[0].setAttribute("id", id);
					if (!selCell[0].classList.contains("FIELD"))
						selCell[0].classList.add("FIELD");
				}
				
				var _editor = DEXT5.getEditor(dextId);
				_editor._FRAMEWIN.setTableCellSelect(selCell[0]);
			}

			function View_CellProperty() {
				var _editor = DEXT5.getEditor(dextId);
				var TotalTag = DEXT5.getDext5BodyDom().getElementsByTagName("TD");
				try {
					for (var i = 0; i < TotalTag.length; i++) {
						if (TotalTag[i].tagName == "TD" && TotalTag[i].id != "") {
							_editor._FRAMEWIN.setTableCellSelect(TotalTag[i]);
						}
					}
				} catch (e) {
					alert(e.message);
				}
			}

			function EditorExistsElement(elementID) {
				try {
					var editorDocument = DEXT5.getDext5DocumentDom(dextId);
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
						for (var i = 0; i < HtmlTag.length; i++) {
							if (GetAttribute(HtmlTag[i], "id") == "body")
								CheckCount++;
						}
						return CheckCount;
						break;
					case "doctitle":
						var CheckCount = 0;
						var HtmlTag = DEXT5.getDext5BodyDom().getElementsByTagName("*");
						for (var i = 0; i < HtmlTag.length; i++) {
							if (GetAttribute(HtmlTag[i], "id") == "doctitle")
								CheckCount++;
						}
						return CheckCount;
						break;
					case "receiptnumber":
						var CheckCount = 0;
						var HtmlTag = DEXT5.getDext5BodyDom().getElementsByTagName("*");
						for (var i = 0; i < HtmlTag.length; i++) {
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
					
				} catch (e) {}
			}

			function EditorElement(elementID) {
				try {
					var editorDocument = DEXT5.getDext5DocumentDom(dextId);
					var ElementObj = editorDocument.getElementById(elementID);
					if (ElementObj)
						return ElementObj;
					
				} catch (e) {}
			}

			function EditorElementSetHtml(elementID, Html) {
				try {
					var ElementObj = DEXT5.getElementById(elementID);
					if (ElementObj) {
						ElementObj.innerHTML = Html;
					}
				} catch (e) {}
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
		</script>
	</c:when>
	<c:when test="${editor eq 'NAMO'}">
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/namoEditor/js/namo_scripteditor.js')}"></script>
		<script type="text/javascript">
			function OnInitCompleted(e) {
				if (parent.reformUrl != "") {
					// AJAX를 동기식으로 호출하여 양식을 로드한다.
					SetEditorContentURL(parent.reformUrl);
					
					// DEXT 에디터와 달리 양식이 에디터에 로드되는데에 시간이 필요해 setTimeout을 이용함
					setTimeout(onFormDocumentLoadHandlerForNamo, 1000);
				} else {
					onFormDocumentLoadHandlerForNamo();
				}
			}

			function CE_OnMouseActive(e) {
				if (e.type == "mousedown") {
					restoreAfterHTMLSourceEdit();
					
					var currElem = e.targetNode;
					lastSelectedElement = currElem;
					
					// 					while (/TBODY|TR|TH|TD/.test(currElem.nodeName)) {
					// 						currElem = currElem.parentElement;
					// 					}
					
					var attValue = currElem.getAttribute("data-reform_flag");
					
					// true 값을 리턴하면 Namo 에디터가 마우스 이벤트 처리를 하지 않는다.
					// IE에서는 리폼에서 만든 control일 때 true를 리턴하지 않으면
					// Namo 에디터가 UI 처리를 직접하기 때문에 true를 반환하도록 한다.
					if (attValue == "1" && currElem.tagName !== "SPAN") {
						moveCursorToElement(currElem);
						
						return true;
					}
				} else if (e.type == "mouseup") {
					saveSelection();
				}
				
				return false;
			}

			function CE_OnKeyActive(e) {
				if (e.type == "keyup") {
					restoreAfterHTMLSourceEdit();
					saveSelection();
					
					lastSelectedElement = e.targetNode;
				}
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
					htmlData = BeforeCellUnLocked(htmlData);//애경 - 에디터에 로드 하기 전에 잠금모양 표시 해제 처리
					
					CrossEditor2.SetBodyValue(htmlData);
				} catch (e) {}
			}

			function GetEditorContent() {
				try {
					return CrossEditor2.GetBodyValue("XHTML");
				} catch (e) {
					return "";
				}
			}

			//애경 - namo_lock 기능은 사용하지 않는다. 해제 후 리턴
			function BeforeCellUnLocked(pData) {
				var div = document.createElement("DIV");
				var elements;
				
				div.innerHTML = pData;
				elements = div.getElementsByTagName("*");
				
				for (var i = 0; i < elements.length; i++) {
					if (elements[i].tagName == "TD") {
						if (elements[i].getAttribute("namo_lock") != null) {
							elements[i].removeAttribute("namo_lock");
						}
					}
				}
				
				return div.innerHTML;
			}
		</script>
	</c:when>
	<c:when test="${editor eq 'TAGFREE'}">
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/tfxEditor/js/xfe_main.js')}"></script>
		<script type="text/javascript">
			function initLoad(obj) {
				// 기존 양식을 로드하는 경우
				if (parent.reformUrl != "") {
					// AJAX를 동기식으로 호출하여 양식을 로드한다.
					SetEditorContentURL(parent.reformUrl);
					
					// 양식이 에디터에 로드되는데에 시간이 필요해 setTimeout을 이용함
					setTimeout(onFormDocumentLoadHandlerForTagfree, 1000);
					//onFormDocumentLoadHandlerForTagfree()
				} else {
					onFormDocumentLoadHandlerForTagfree();
				}
			}

			function keyUp(event) {
				restoreAfterHTMLSourceEdit();
				saveSelection();
				
				lastSelectedElement = event.target;
			}

			function mouseUp(event) {
				saveSelection();
			}

			function mouseDown(event) {
				restoreAfterHTMLSourceEdit();
				
				var currElem = event.target;
				lastSelectedElement = currElem;
				
				var attValue = currElem.getAttribute("data-reform_flag");
				
				// false 값을 리턴하면 Tagfree 에디터가 마우스 이벤트 처리를 하지 않는다.
				if (attValue == "1" && currElem.tagName !== "SPAN") {
					moveCursorToElement(currElem);
					
					return false;
				}
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
				} catch (e) {}
			}

			function GetEditorContent() {
				try {
					return xfe.getBodyValue();
				} catch (e) {
					return "";
				}
			}
		</script>
	</c:when>
	<c:when test="${editor eq 'KUKUDOCS'}">
		<link rel="stylesheet" href="${util.addVer('/js/ezEditor/kukudocsEditor/stylesheets/kk_webEditor_min.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-1.9.1.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-ui-1.11.4.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/javascripts/build/Editor.bundle.js')}"></script>
		<script>
			function onLoaded() {
				// 기존 양식을 로드하는 경우
				if (parent.reformUrl != "") {
					// AJAX를 동기식으로 호출하여 양식을 로드한다.
					SetEditorContentURL(parent.reformUrl);
				}
				
				// kukudocsEditor.setKeyEvent(onKeyEvent);
				// kukudocsEditor.setMouseEvent(onMouseEvent);
				
				setTimeout(function() {
					onFormDocumentLoadHandlerForKukudocs();
					
					webEditorDocument.addEventListener("keyup", keyUp);
					webEditorDocument.addEventListener("mousedown", mouseDown);
					webEditorDocument.addEventListener("mouseup", mouseUp);
				}, 1000);
			}

			function keyUp(event) {
				restoreAfterHTMLSourceEdit();
				saveSelection();
				
				lastSelectedElement = event.target;
			}

			function mouseUp(event) {
				saveSelection();
			}

			function mouseDown(event) {
				restoreAfterHTMLSourceEdit();
				
				var currElem = event.target;
				lastSelectedElement = currElem;
				
				var attValue = currElem.getAttribute("data-reform_flag");
				
				if (attValue == "1" && currElem.tagName !== "SPAN") {
					moveCursorToElement(currElem);
					
					event.preventDefault();
				}
			}

			function SetEditorContentURL(pURL) {
				var tempStr = ConvertMHTtoHTML(pURL);
				var tempXML = loadXMLString(tempStr);
				var XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
				var htmlData = getNodeText(XmlBodyDATA);
				kukudocsEditor.SetEditorContent(htmlData);
			}

			function GetEditorContent() {
				return kukudocsEditor.GetEditorContent();
			}
		</script>
	</c:when>
	<c:when test="${editor eq 'CK'}">
		<link rel="stylesheet" href="${util.addVer('/js/ezEditor/kukudocsEditor/stylesheets/kk_webEditor_min.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-1.9.1.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-ui-1.11.4.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/ckEditor/ckeditor.js')}"></script>
		<script>
			CKEDITOR.on('instanceReady', function(ev) {
				// 기존 양식을 로드하는 경우
				if (parent.reformUrl != "") {
					// AJAX를 동기식으로 호출하여 양식을 로드한다.
					SetEditorContentURL(parent.reformUrl);
				}
				
				onFormDocumentLoadHandlerForCK();
				
				webEditorDocument.addEventListener("keyup", keyUp);
				webEditorDocument.addEventListener("mousedown", mouseDown);
				webEditorDocument.addEventListener("mouseup", mouseUp);
			});
			
			// 에디터 커맨드 실행
			function ExecuteCommand(commandName) {
				if (CKEDITOR.instances.ck_reform.mode == 'wysiwyg') {
					CKEDITOR.instances.ck_reform.execCommand(commandName);
				}
			}

			function keyUp(event) {
				restoreAfterHTMLSourceEdit();
				saveSelection();
				
				lastSelectedElement = event.target;
			}

			function mouseUp(event) {
				saveSelection();
			}

			function mouseDown(event) {
				restoreAfterHTMLSourceEdit();
				
				var currElem = event.target;
				lastSelectedElement = currElem;
				
				var attValue = currElem.getAttribute("data-reform_flag");
				
				if (attValue == "1" && currElem.tagName !== "SPAN") {
					moveCursorToElement(currElem);
					
					event.preventDefault();
				}
			}

			function SetEditorContentURL(pURL) {
				var tempXML = createXmlDom();
				var xmlBodyData = createXmlDom();
				var tempStr = "";
				tempStr = ConvertMHTtoHTML(pURL);
				tempXML = loadXMLString(tempStr);
				
				xmlBodyData = GetElementsByTagName(tempXML, 'BODYDATA')[0];
				CKEDITOR.instances.ck_reform.setData(getNodeText(xmlBodyData));
			}

			function GetEditorContent() {
				try {
					return CKEDITOR.instances.ck_reform.getData();
				} catch (e) {
					console.err(e);
					return "";
				}
			}
		</script>
	</c:when>
	<c:otherwise>
		<%-- 		<script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApproval/js/kaoni_ActiveX.js")%>"></script> --%>
		<script type="text/javascript">
			var reflag = false;
			var completeCount = 0;
			
			function pzFormProc_reform_FieldsAvailable() {}

			// 원인은 알 수 없으나 이 함수가 2번 호출된다.
			function pzFormProc_reform_DocumentComplete() {
				completeCount++;
				
				if (reflag == false) {
					reflag = true;
					
					// 기존 양식을 로드하는 경우
					if (parent.reformUrl != "") {
						// 기존 양식을 로드하고 나면 pzFormProc_reform_DocumentComplete 함수가 한번 더, 즉 3번째로 호출된다.
						pzFormProc_reform.LoadURL(parent.reformUrl);
						// 새로운 양식을 작성하는 경우
					} else {
						onFormDocumentLoadHandlerForFormProcessor();
					}
				} else {
					// 기존 양식을 로드하는 경우의 초기화 작업 처리
					// 기존 양식 로드 전에 2번 호출되므로 3번째로 호출될 때 처리한다.
					if (completeCount == 3) {
						onFormDocumentLoadHandlerForFormProcessor();
					}
				}
			}

			function pzFormProc_InvalidDocument() {
				pzFormProc_reform.ShowWorkingDlg("", false);
			}
		</script>
		<script type="text/javascript" for="pzFormProc_reform" event="FieldsAvailable">
			pzFormProc_reform_FieldsAvailable();
		</script>
		<script type="text/javascript" for="pzFormProc_reform" event="DocumentComplete">
			pzFormProc_reform_DocumentComplete()
		</script>
		<script type="text/javascript" for="pzFormProc_reform" event="InvalidDocument">
			pzFormProc_InvalidDocument()
		</script>
	</c:otherwise>
</c:choose>
</head>
<body>
	<ul class="contentlayout">
		<li class="contentlayout_right" style="width: 258px; padding-left: 5px;">
			<!-- reform -->
			<!-- 최적화사이즈widht285px  가변가능-widht변경가능 -->
			<div id="reform">
				<!-- section1 -->
				<div class="section border_not">
					<a href="#" class="btn_type1" onclick="showPreview()">
						<span><spring:message code='reform.design.preview' /></span>
					</a>
				</div>
				<!-- //section1 -->
				<!-- section2 -->
				<div class="section">
					<h2 class="h2">
						<span class="title"><spring:message code='reform.design.databind' /></span>
						<ul class="btn_type2">
							<li onclick="showAddDataBindControlDialog()">
								<span><spring:message code='reform.design.databind.add' /></span>
							</li>
							<li onclick="showDeleteDataBindControlDialog()">
								<span><spring:message code='reform.design.databind.remove' /></span>
							</li>
							<li onclick="showModifyDataBindControlDialog()">
								<span><spring:message code='reform.design.databind.modify' /></span>
							</li>
						</ul>
					</h2>
					<p class="mt5">
						<select id="data_bind_control_list" class="sel_type1">
						</select>
					</p>
				</div>
				<div class="section2">
					<ul class="html_control">
						<li onclick="addSelectBox()">
							<span class="icon_box icon1"></span>List Box
						</li>
						<li onclick="addTextBox()">
							<span class="icon_box icon2"></span>Text Box
						</li>
						<li onclick="addCheckbox()">
							<span class="icon_box icon3"></span>Check Box
						</li>
						<li onclick="addRadioButton()">
							<span class="icon_box icon4"></span>Radio Button
						</li>
						<li onclick="addButton()">
							<span class="icon_box icon5"></span>Button
						</li>
						<li onclick="addLabel()">
							<span class="icon_box icon6"></span>Label
						</li>
						<li onclick="addDatePicker()">
							<span class="icon_box icon7"></span>Date Picker
						</li>
						<li onclick="addTimePicker()">
							<span class="icon_box icon8"></span>Time Picker
						</li>
						<li onclick="addGrid()">
							<span class="icon_box icon9"></span>Data Grid
						</li>
						<li onclick="addHiddenControl()">
							<span class="icon_box icon2"></span>Hidden
						</li>
						<li onclick="addTextarea()">
							<span class="icon_box icon2"></span>Textarea
						</li>
					</ul>
					<ul class="btn_type2">
						<li onclick="reform_removeCurrentControl()">
							<span><spring:message code='reform.design.control.remove' /></span>
						</li>
						<li onclick="reform_selectNodeToMoveOrCopy()">
							<span><spring:message code='reform.design.control.select' /></span>
						</li>
						<li onclick="reform_moveCopiedNode()">
							<span><spring:message code='reform.design.control.move' /></span>
						</li>
						<li onclick="reform_pasteCopiedNode()">
							<span><spring:message code='reform.design.control.copy' /></span>
						</li>
					</ul>
				</div>
				<!-- //section2-->
				<!-- section2 -->
				<div class="section">
					<h2 class="h2">
						<span class="title"><spring:message code='reform.design.attribute' /></span>
						</h3>
						<div class="box_deco">
							<table class="tbl_type1" border="1" cellspacing="0">
								<colgroup>
									<col style="width: 145px">
									<col>
								</colgroup>
								<tr>
									<th id="prop1_name"></th>
									<td id="prop1_value"></td>
								</tr>
								<tr>
									<th id="prop2_name"></th>
									<td id="prop2_value"></td>
								</tr>
								<tr>
									<th id="prop3_name"></th>
									<td id="prop3_value"></td>
								</tr>
								<tr>
									<th id="prop4_name"></th>
									<td id="prop4_value"></td>
								</tr>
								<tr>
									<th id="prop5_name"></th>
									<td id="prop5_value"></td>
								</tr>
								<tr>
									<th id="prop6_name"></th>
									<td id="prop6_value"></td>
								</tr>
								<tr>
									<th id="prop7_name"></th>
									<td id="prop7_value"></td>
								</tr>
								<tr>
									<th id="prop8_name"></th>
									<td id="prop8_value"></td>
								</tr>
								<tr>
									<th id="prop9_name"></th>
									<td id="prop9_value"></td>
								</tr>
								<tr>
									<th id="prop10_name"></th>
									<td id="prop10_value"></td>
								</tr>
							</table>
						</div>
				</div>
				<!-- //section2-->
				<!-- section2 -->
				<div class="section border_nob ">
					<h2 class="h2">
						<span class="title"><spring:message code='reform.design.event' /></span>
						</h3>
						<div class="box_deco">
							<table class="tbl_type1" border="1" cellspacing="0">
								<colgroup>
									<col style="width: 145px">
									<col>
								</colgroup>
								<tr>
									<th id="event1_name"></th>
									<td id="event1_value"></td>
								</tr>
								<tr>
									<th id="event2_name"></th>
									<td id="event2_value"></td>
								</tr>
								<tr>
									<th id="event3_name"></th>
									<td id="event3_value"></td>
								</tr>
								<tr>
									<th id="event4_name"></th>
									<td id="event4_value"></td>
								</tr>
							</table>
						</div>
				</div>
				<!-- //section2-->
			</div>
		</li>
		<li class="contentlayout_none">
			<c:choose>
				<c:when test="${editor eq 'DEXT'}">
					<table id="PreForm" style="vertical-align: top; border-spacing: 0px;">
						<tr>
							<td valign="top" style="width: 100%; vertical-align: top;">
								<script type="text/javascript">
									// the following line is commented out since it causes an error message(editor's name is not correct. Please check editor's name)
									// is displayed.
									//                    DEXT5.config.DialogWindow = parent.window;
									
									// 에디터가 hidden 처리되면 로드 안하다가 필요할때 로드해주는 조건을 체크해주는건데,
									// 이상하게 작동을 안 하여 무조건 로드되도록 함수를 덮어 씌움
									DEXT5.util.DEXT5_CheckEditorVisible = function() {
										return 1;
									}

									DEXT5.config.RemoveItem = "about";
									DEXT5.config.StatusBarItem = "design,source";
									DEXT5.config.ManagerMode = "1";
									DEXT5.config.zXssRemoveEvents = "onevent";
									
									DEXT5.config.userFontFamily = editorInfo.defaultFontFamily;
									DEXT5.config.Lang = "<spring message code = 'main.t0619' />";
									DEXT5.config.userFontSize = editorInfo.defaultFontSize;
									
									DEXT5.config.Height = editorInfo.height;
									
									//var editorid = new Dext5editor(dextId);
									new Dext5editor(dextId);
								</script>
							</td>
							<td id="rootTD"></td>
						</tr>
					</table>
				</c:when>
				<c:when test="${editor eq 'NAMO'}">
					<table id="PreForm" style="overflow: auto; vertical-align: top; border-spacing: 0px;">
						<tr>
							<td valign="top" style="width: 100%; vertical-align: top;">
								<script type="text/javascript">
									var CrossEditor2 = new NamoSE("reform-namo");
									var uploadUrl = "/ezEditor/namoUpload.do?type=";
									var userLang = "${userlang}";
									
									CrossEditor2.params.UploadFileExecutePath = uploadUrl;
									CrossEditor2.params.Height = editorInfo.height;
									// CrossEditor2.params.Width = "100%";
									
									if (userLang == "1") {
										CrossEditor2.params.UserLang = "kor";
									} else if (userLang == "2") {
										CrossEditor2.params.UserLang = "enu";
									} else if (userLang == "3") {
										CrossEditor2.params.UserLang = "jpn";
									} else {
										CrossEditor2.params.UserLang = "chs";
									}

									CrossEditor2.EditorStart();
								</script>
							</td>
							<td id="rootTD"></td>
						</tr>
					</table>
				</c:when>
				<c:when test="${editor eq 'TAGFREE'}">
					<table id="PreForm" style="overflow: auto; vertical-align: top; border-spacing: 0px;">
						<tr>
							<td id="xfe_ex" valign="top" style="width: 100%;">
								<script type="text/javascript">
									var userLang = "${userlang}";
									var uploadFilePath = "/ezEditor/tfxUpload.do?type=";
									var uploadPasteContentsPath = "/ezEditor/tfxSimpleUpload.do?type=";
									
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
									case "6":
										lang = "english";
										break;	
									default:
										lang = "korean";
										break;
									}

									xfe = new XFE({
										lang: lang,
										basePath: "/js/ezEditor/tfxEditor",
										width: '100%',
										height: editorInfo.height,
										initFilePath: "/js/ezEditor/tfxEditor/config/reform/env.xml",
										initFontFamilyMenu: editorInfo.initFontFamilyMenu,
										initFontFamily: editorInfo.defaultFontFamily,
										initFontSize: editorInfo.defaultFontSize,
										uploadFilePath: uploadFilePath,
										uploadPasteContentsPath: uploadPasteContentsPath,
										onLoad: initLoad,
										onMouseUp: mouseUp,
										onMouseDown: mouseDown,
										onKeyUp: keyUp,
                                        rootFrameId : 'tbContentElement',
                                        ignoreMinHeight : true
									});
									
									xfe.render('xfe_ex');
								</script>
							</td>
							<td id="rootTD"></td>
						</tr>
					</table>
				</c:when>
				<c:when test="${editor eq 'KUKUDOCS'}">
				<textarea cols="80" id="reform-kukudocs" name="reform-kukudocs" rows="10"></textarea>
								<script>
									// 언어 설정
									var lang = "";
									var userLang = "${userlang}";
									
									switch (userLang) {
									case "1":
										lang = "ko";
										break;
									case "2":
										lang = "en";
										break;
									case "3":
										lang = "ja";
										break;
									case "4":
										lang = "zh";
										break;
									case "5":
										lang = "vi";
										break;
									case "6":
										lang = "id";
										break;
									default:
										lang = "en";
										break;
									}

									// 메뉴 설정			
									var customAlignMenu = [ 'about', 'print', 'undo', 'redo', 'text_paste', 'textFormatCopy', 'textFormatPaste', 'link', 'unlink', 'image', 'symbol', 'horizontal', 'numbered_list', 'bullet_list', 'outdent', 'indent', 'table', 'table_insert_left',
											'table_insert_right', 'table_insert_top', 'table_insert_bottom', 'table_remove_col', 'table_remove_row', 'table_remove_table', 'table_merge', 'table_split_col', 'table_split_row', 'table_background_color', 'table_border_style', 'align_left',
											'align_center', 'align_right', 'align_justify', 'paragraph_margin', 'template', 'heading', 'fontFamily', 'fontSize', 'line_height', 'bold', 'italic', 'underline', 'strike_through', 'remove_format', 'color', 'backgroundColor' ];
									
									// 이미지 업로드 URL 설정
									var imageUploadURL = "/ezEditor/kukudocsUpload.do?type=";
									
									// 폰트 크기 리스트 설정
									var fontSize = [ {
										name: '8px',
										value: '8px'
									}, {
										name: '9px',
										value: '9px'
									}, {
										name: '10px',
										value: '10px'
									}, {
										name: '11px',
										value: '11px'
									}, {
										name: '12px',
										value: '12px'
									}, {
										name: '13px',
										value: '13px'
									}, {
										name: '14px',
										value: '14px'
									}, {
										name: '15px',
										value: '15px'
									}, {
										name: '16px',
										value: '16px'
									}, {
										name: '18px',
										value: '18px'
									}, {
										name: '20px',
										value: '20px'
									}, {
										name: '22px',
										value: '22px'
									}, {
										name: '24px',
										value: '24px'
									}, {
										name: '26px',
										value: '26px'
									}, {
										name: '30px',
										value: '30px'
									}, {
										name: '36px',
										value: '36px'
									}, {
										name: '42px',
										value: '42px'
									}, {
										name: '48px',
										value: '48px'
									}, {
										name: '54px',
										value: '54px'
									}, {
										name: '72px',
										value: '72px'
									}, {
										name: '80px',
										value: '80px'
									}, {
										name: '88px',
										value: '88px'
									}, {
										name: '100px',
										value: '100px'
									} ];
									
									// 폰트 리스트 설정
									var fontFamilyArr = editorInfo.initFontFamilyMenu;
									var fontFamily = [];
									
									for (var i = 0; i < fontFamilyArr.length; i++) {
										fontFamily[i] = {
											name: fontFamilyArr[i],
											value: fontFamilyArr[i]
										}
									}

									var kukudocsEditor = new KuKudocsEditor('reform-kukudocs', {
										licPathURL: '/js/ezEditor/kukudocsEditor/kukudocs.lic',
										minHeight : 0,
										maxHeight : 0,
										width: '100%',
										height: editorInfo.height,
										defaultTableWidth : 700,
										defaultLanguage: lang,
										languagePathURL: '/js/ezEditor/kukudocsEditor/lang/',
										defaultFontFamily: editorInfo.defaultFontFamily,
										defaultFontSize: editorInfo.defaultFontSize,
										fontSize: fontSize,
										fontFamily: fontFamily,
										customMagicLineStyle: 'background-color:#888;',
										customAlignMenu: customAlignMenu,
										useMenuBar: true,
										useHTMLMode: true,
										useTextMode: false,
										usePreviewMode: false,
										useEditorResize: false,
										useFirstFocus: false,
										useOnlyTableContentMenu : true,
										useNoneBorderVisualize : true,
										publicPathURL: '/js/ezEditor/kukudocsEditor/',
										defaultEditorStylePath: '/js/ezEditor/kukudocsEditor/stylesheets/editor_style.css',
										loadingImageURL: '/js/ezEditor/kukudocsEditor/images/load.gif',
										errorImageURL: '/js/ezEditor/kukudocsEditor/images/error.png',
										imageUploadURL: imageUploadURL,
										Editor_Complete: onLoaded,
										useSecurityScript: false,
										useSecurityEvent: false
									});
								</script>
				</c:when>
				<c:when test="${editor eq 'CK'}">
					<table id="PreForm" style="overflow: auto; vertical-align: top; border-spacing: 0px; width: 100%;">
						<tr>
							<td id="ck_reform" valign="top" style="width: 100%;"></td>
							<script>
								CKEDITOR.config.imageUploadUrl = "/ezEditor/ckSimpleUpload.do";
								CKEDITOR.config.contentsCss = "/js/ezEditor/ckEditor/contents.css";
								CKEDITOR.config.font_defaultLabel = editorInfo.defaultFontFamily;
								CKEDITOR.config.font_names = "<spring:message code='main.t0620' />";
								CKEDITOR.config.fontSize_defaultLabel = editorInfo.defaultFontSize;
								CKEDITOR.config.language = "<spring:message code='main.t0619' />";
								CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
								CKEDITOR.config.resize_enabled = false;
								CKEDITOR.config.allowedContent = true;
								
								CKEDITOR.replace('ck_reform', {height: 750, width: "100%"});
							</script>
						</tr>
					</table>
				</c:when>
				<c:otherwise>
					<table id="PreForm" style="height: 0px; vertical-align: top; border-spacing: 0px;"></table>
				</c:otherwise>
			</c:choose>
		</li>
	</ul>
</body>
</html>
