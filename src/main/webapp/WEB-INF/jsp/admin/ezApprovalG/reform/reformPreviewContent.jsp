<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/reform/useProcessor.css')}">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/reform/reformUseProcessor.js')}"></script>
<!-- data picker-->
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
<!-- time picker-->
<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
<style>
	body {margin: 0px;}
</style>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<script language="javascript" type="text/javascript">
	var isConDoc = false;
	var XmlBodyATT = createXmlDom();
	// reform
	var args = parent.args;
	var webEditorDocument = args.webEditorDocument;
	var reformScriptCode = args.reformScriptCode;
	var isIE11Mode = args.isIE11Mode;
	var isDext = args.isDext;
	var isFormProcessor = args.isFormProcessor;
	var isNamo = args.isNamo;
	var isTagfree = args.isTagfree;
	var CrossEditor = args.CrossEditor2;
	// reform - end
	
	document.onselectstart = function() {
		var ret = false;
		var obj = event.srcElement;
		try {
			if (obj.nodeName == "#text")
				obj = obj.parentElement;
			
			if (obj.nodeName == "TD") {
				if (obj.getAttribute("free") != null)
					ret = true;
			} else if (obj.nodeName == "DIV") {
				var pParentNode = obj;
				for (var i = 0; i < 3; i++) {
					pParentNode = pParentNode.parentElement;
					if (pParentNode.nodeName == "TD") {
						if (pParentNode.getAttribute("free") != null) {
							ret = true;
							break;
						}
					} else if (pParentNode.nodeName == "BODY" || pParentNode.nodeName == "HTML")
						break;
					
				}
			}
		} catch (e) {}
		return ret;
	};
	var BODYTag;
	var BODYHTML;
	var DocTitleObj;
	var DocTitleHTML;
	var _htmlcontent;
	
	var isConDoc = false;
	var isEditor = false;
	var PreviewDiv = null;
	
	var pUse_Editor = "${editor}";
	var pUse_IE11Browser = "${ie11editor}";
	
	window.onload = function() {
		// reform
		if (isNamo) {
			document.getElementById('div_Content').innerHTML = CrossEditor.GetBodyValue("XHTML");
		} else {
			document.getElementById('div_Content').innerHTML = webEditorDocument.body.innerHTML;
		}
		
		encryptSQLQuery(document);
		Set_EditorContentURL("");
		reformUseProc.onLoadHandler();
		
		// reform - end
	}

	// reform
	function getEncryptedSQLQuery(sqlQuery) {
		var reformServerUrl = "/reform/getEncryptedSQLQuery.do";
		var postData = "sqlQuery=" + encodeURIComponent(sqlQuery);
		var xmlhttp = createXMLHttpRequest();
		xmlhttp.open("POST", reformServerUrl, false);
		xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xmlhttp.send(postData);
		if (xmlhttp.readyState == 4) {
			if (xmlhttp.status == 200) {
				sqlQuery = xmlhttp.responseText;
			}
		}
		
		return sqlQuery;
	}

	function encryptSQLQuery(documentObject) {
		var dataBindControlListElement = documentObject.getElementById("__reform_data_bind_list");
		if (dataBindControlListElement != null) {
			var dataBindControlListElementValue = dataBindControlListElement.getAttribute("value");
			var dataBindControlList = JSON.parse(dataBindControlListElementValue);
			for (var i = 0; i < dataBindControlList.length; i++) {
				var dataBindID = dataBindControlList[i];
				var dataBindControl = documentObject.getElementById(dataBindID);
				if (dataBindControl != null) {
					var dataBindControlValue = dataBindControl.getAttribute("value");
					var dataBindControlValueObject = JSON.parse(dataBindControlValue);
					var sqlQuery = dataBindControlValueObject["sql"];
					var encryptedSqlQuery = getEncryptedSQLQuery(sqlQuery);
					dataBindControlValueObject["sql"] = encryptedSqlQuery;
					dataBindControl.setAttribute("value", JSON.stringify(dataBindControlValueObject));
				}
			}
		}
	}
	// reform - end
	
	function onKeyDownEvent(e, obj, Maxlength) {
		var curevent = (typeof event == 'undefined' ? e : event)
		if (curevent.keyCode == "13")
			return false;
		else {
			if (curevent.keyCode != "8" && curevent.keyCode != "46") {
				if (obj.innerText.length > parseInt(Maxlength))
					return false;
				else
					return true;
			}
			return true;
		}
	}
	function SelectOnchange(obj) {
		for (var i = 0; i < obj.childNodes.length; i++) {
			if (obj.value == obj.childNodes.item(i).value)
				obj.childNodes.item(i).setAttribute("check", "2");
			else
				obj.childNodes.item(i).setAttribute("check", "1");
		}
	}
	function CheckBoxOnclick(obj) {
		obj.removeAttribute("checked");
		if (obj.checked)
			obj.setAttribute("check", "1");
		else
			obj.setAttribute("check", "0");
	}
	function Conent_contentEditable(obj) {
		try {
			var TDRows = obj.getElementsByTagName("TD");
			for (var i = 0; i < TDRows.length; i++) {
				if (TDRows.item(i).getAttribute("free") != null && TDRows.item(i).id != "doctitle") {
					var isContinue = true;
					if (TDRows.item(i).childNodes.length > 1) {
						var ChildNodes_;
						if (TDRows.item(i).childNodes.item(0).nodeName == "#text")
							ChildNodes_ = TDRows.item(i).childNodes.item(1);
						else
							ChildNodes_ = TDRows.item(i).childNodes.item(0);
						
						if (ChildNodes_.nodeName == "TD" || ChildNodes_.nodeName == "TABLE")
							continue;
						
						if (ChildNodes_.childNodes.length > 1) {
							for (var Cnt = 0; Cnt < ChildNodes_.childNodes.length; Cnt++) {
								if (ChildNodes_.childNodes.item(Cnt).nodeName == "TD" || ChildNodes_.childNodes.item(Cnt).nodeName == "TABLE") {
									isContinue = false;
									break;
								}
							}
						}
					}
					if (!isContinue)
						continue;
					var Div_ = document.createElement("DIV");
					Div_.style.width = "99%";
					Div_.style.overflow = "hidden";
					Div_.setAttribute("contentEditable", true);
					Div_.style.textAlign = "left";
					Div_.innerHTML = TDRows.item(i).innerHTML;
					TDRows.item(i).innerHTML = "";
					TDRows.item(i).appendChild(Div_);
				} else if (TDRows.item(i).getAttribute("free") != null && TDRows.item(i).id == "doctitle") {
					var Div_ = document.createElement("DIV");
					Div_.setAttribute("id", "frame_doctitle");
					Div_.setAttribute("name", "frame_doctitle");
					Div_.style.width = "99%";
					Div_.style.marginLeft = "2px";
					Div_.style.overflow = "hidden";
					Div_.setAttribute("contentEditable", true);
					Div_.style.textAlign = "left";
					Div_.onkeypress = function() {
						var ret = onKeyDownEvent(event, this, 127);
						if (!ret)
							return false;
					};
					Div_.innerHTML = TDRows.item(i).innerHTML;
					TDRows.item(i).innerHTML = "";
					TDRows.item(i).appendChild(Div_);
				}
			}
		} catch (e) {}
	}
	function Set_EditorContentURL(url) {
		try {
			var tempXML = createXmlDom();
			var XmlBodyDATA = createXmlDom();
			var tempStr = "";
			//                var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(url);
			//                tempStr = ConvertMHTtoHTML(URL);
			if (tempStr.indexOf("MIME-Version: 1.0") > 0) {
				Set_EditorContentURL(url);
			} else {
				/* reform
				tempXML = loadXMLString(tempStr);
				XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
				XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
				var _DocContentHtml = getNodeText(XmlBodyDATA);
				var ConXmlDiv = document.createElement("DIV");
				ConXmlDiv.innerHTML = _DocContentHtml;
				if (ConXmlDiv.getElementsByTagName("XML").length > 0) {
				    isConDoc = true;
				    ConXmlDiv.getElementsByTagName("XML").item(0).style.display = "none";
				    CONNINFO.innerHTML = ConXmlDiv.getElementsByTagName("XML").item(0).outerHTML;
				    _DocContentHtml = ConXmlDiv.innerHTML;
				}
				 */
				//                    var _DocContentHtml = webEditorDocument.body.innerHTML;
				//                    document.getElementById('div_Content').innerHTML = _DocContentHtml; //.replace(/(<p)/igm, '<div').replace(/<\/p>/igm, '</div>');
				_htmlcontent = document.getElementById('div_Content').innerHTML;
				var TDRows = document.getElementById('div_Content').getElementsByTagName("TD")
				for (var i = 0; i < TDRows.length; i++) {
					if (TDRows.item(i).getAttribute("class") == "FIELD") {
						if (TDRows.item(i).childNodes.length == 0) {
							if (TDRows.item(i).innerHTML == "" || TDRows.item(i).innerHTML == " ") {
								TDRows.item(i).innerHTML = "&nbsp;";
							}
						}
					}
					if (TDRows.item(i).style.borderBottom == "currentColor")
						TDRows.item(i).style.borderBottom = "";
					if (TDRows.item(i).style.borderTop == "currentColor")
						TDRows.item(i).style.borderTop = "";
					if (TDRows.item(i).style.borderLeft == "currentColor")
						TDRows.item(i).style.borderLeft = "";
					if (TDRows.item(i).style.borderRight == "currentColor")
						TDRows.item(i).style.borderRight = "";
				}
				if (parent.pDraftFlag != "REDRAFT") {
					var Body_innerHTML = "";
					if (document.getElementById("body") != null) {
						if (document.getElementById("body").getAttribute("class") == "FIELD") {
							Body_innerHTML = document.getElementById("body").innerHTML;
							document.getElementById("body").innerHTML = "";
						}
					}
					Conent_contentEditable(document.getElementById('div_Content'));
					/* reform
					var SelectRows = document.getElementById('div_Content').getElementsByTagName("SELECT");
					for (var i = 0; i < SelectRows.length; i++) {
					    SelectRows.item(i).onchange = function () { SelectOnchange(this); };
					}
					var CheckRows = document.getElementById('div_Content').getElementsByTagName("INPUT");
					for (var i = 0; i < CheckRows.length; i++) {
					    if (CheckRows.item(i).type == "checkbox" || CheckRows.item(i).type == "radio")
					        CheckRows.item(i).onchange = function () { CheckBoxOnclick(this); };
					}
					 */

					if (document.getElementById("body") != null) {
						if (document.getElementById("body").getAttribute("class") == "FIELD") {
							document.getElementById("body").innerHTML = Body_innerHTML;
							BODYTag = document.getElementById("body");
						}
					}
					// reform: added null check
					if (document.getElementById("doctitle") != null) {
						if (document.getElementById("doctitle").getAttribute("class") == "FIELD")
							DocTitleObj = document.getElementById("doctitle");
					}
					
					var EditorHeight = 500;
					if (document.getElementById("body") != null) {
						if (BODYTag.getAttribute("tagfreeheight")) {
							EditorHeight = BODYTag.getAttribute("tagfreeheight")
						}
						div_BODY.innerHTML = BODYTag.innerHTML;
					}
					
					if (document.getElementById("body") != null) {
						if (BODYTag.getAttribute("editor") == null) {
							isEditor = true;
							if (pUse_Editor == "TAGFREE")
								BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight
										+ "px;' scrolling='no' src='/myoffice/ezApproval/TagFree_TFI_Editor.aspx?height='" + EditorHeight + "' frameborder='0'></iframe>";
							else if (pUse_Editor == "NAMO")
								BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight
										+ "px;' scrolling='no' src='/myoffice/ezApproval/Namo_Editor.aspx?height=" + EditorHeight + "' frameborder='0'></iframe>";
							else if (pUse_Editor == "DEXT")
								BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight
										+ "px;' scrolling='no' src='/myoffice/ezApproval/DEXT_Editor.aspx?height=" + EditorHeight + "' frameborder='0'></iframe>";
							else
								BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight
										+ "px;' scrolling='no' src='/myoffice/ezApproval/CK_Editor.aspx?height='" + EditorHeight + "' frameborder='0'></iframe>";
						} else {
							try {
								Conent_contentEditable(document.getElementById('body'));
							} catch (e) {}
						}
					}
				}
				parent.FieldsAvailable();
			}
		} catch (e) {}
	}
	function BodyTagsEnabled(HtmlObject) {
		var SelectRows = HtmlObject.getElementsByTagName("SELECT")
		for (var i = 0; i < SelectRows.length; i++) {
			if (SelectRows.item(i).disabled)
				SelectRows.item(i).disabled = false;
		}
		var inputRows = HtmlObject.getElementsByTagName("INPUT")
		for (var i = 0; i < inputRows.length; i++) {
			if (inputRows.item(i).disabled)
				inputRows.item(i).disabled = false;
		}
		return HtmlObject;
	}
	function BodyTagsDisabled(HtmlObject) {
		var SelectRows = HtmlObject.getElementsByTagName("SELECT")
		for (var i = 0; i < SelectRows.length; i++) {
			if (!SelectRows.item(i).disabled)
				SelectRows.item(i).disabled = true;
		}
		var inputRows = HtmlObject.getElementsByTagName("INPUT")
		for (var i = 0; i < inputRows.length; i++) {
			if (!inputRows.item(i).disabled && inputRows.item(i).id != "frame_doctitle")
				inputRows.item(i).disabled = true;
		}
		return HtmlObject;
	}
	function GetDocTitle() {
		try {
			if (document.getElementById("frame_doctitle") == null) {
				return document.getElementById("doctitle").innerText;
			} else {
				return document.getElementById("frame_doctitle").innerText;
			}
		} catch (e) {
			return "";
		}
	}
	function GetFieldsList() {
		try {
			var FieldsList = new Array();
			var FieldCount = 0;
			var count = 0;
			var i = 0;
			
			count = div_Content.getElementsByTagName("*").length;
			
			for (i = 0; i < count; i++) {
				if (div_Content.getElementsByTagName("*")[i].getAttribute("class") == "FIELD") {
					var tmp = div_Content.getElementsByTagName("*")[i];
					
					if (!tmp.FieldID)
						tmp.FieldID = tmp.id;
					
					FieldsList[FieldCount] = tmp;
					FieldCount++;
				}
			}
			return FieldsList;
		} catch (e) {
			return FieldsList;
		}
	}

	function GetListItem(pList, str) {
		try {
			for (i = 0; i < pList.length; i++) {
				if (pList[i].id == str || pList[i].name == str)
					return pList[i];
			}
		} catch (e) {
			return null;
		}
	}

	function DocumentSetFildeValue(FildName, FildeValue) {
		try {
			document.getElementById(FildName).textContent = FildeValue;
		} catch (e) {}
	}

	function DocumentFildeCheck(FildName) {
		try {
			if (document.getElementById(FildName) != null)
				return true;
			else
				return false;
		} catch (e) {
			return false;
		}
	}

	function DocumentBodySetAttribute(AttributeName, AttributeValue) {
		try {
			if (document.getElementById("body").getAttribute("class") == "FIELD") {
				document.getElementById("body").setAttribute(AttributeName, AttributeValue);
			}
		} catch (e) {}
	}
	function DocumentBodyGetAttribute(AttributeName) {
		try {
			return document.getElementById("body").getAttribute(AttributeName);
		} catch (e) {}
	}
	var BODYTag;
	var BODYHTML;
	function SetEditable(flag) {
		try {
			if (flag) {
				BodyTagsEnabled(document.getElementById('div_Content'));
				var Body_innerHTML = "";
				if (document.getElementById("body") != null) {
					if (document.getElementById("body").getAttribute("class") == "FIELD") {
						Body_innerHTML = document.getElementById("body").innerHTML;
						document.getElementById("body").innerHTML = "";
					}
				}
				Conent_contentEditable(document.getElementById('div_Content'));
				/* reform
				var SelectRows = document.getElementById('div_Content').getElementsByTagName("SELECT");
				for (var i = 0; i < SelectRows.length; i++) {
				    SelectRows.item(i).onchange = function () { SelectOnchange(this); };
				}
				var CheckRows = document.getElementById('div_Content').getElementsByTagName("INPUT");
				for (var i = 0; i < CheckRows.length; i++) {
				    if (CheckRows.item(i).type == "checkbox" || CheckRows.item(i).type == "radio")
				        CheckRows.item(i).onchange = function () { CheckBoxOnclick(this); };
				}
				 */
				if (document.getElementById("body") != null) {
					if (document.getElementById("body").getAttribute("class") == "FIELD") {
						document.getElementById("body").innerHTML = Body_innerHTML;
						BODYTag = document.getElementById("body");
					}
				}
				// reform: added null check
				if (document.getElementById("doctitle") != null) {
					if (document.getElementById("doctitle").getAttribute("class") == "FIELD")
						DocTitleObj = document.getElementById("doctitle");
				}
				
				DocTitleHTML = document.createElement("DIV");
				var EditorHeight = 500;
				if (document.getElementById("body") != null) {
					if (BODYTag.getAttribute("tagfreeheight")) {
						EditorHeight = BODYTag.getAttribute("tagfreeheight")
					}
					div_BODY.innerHTML = BODYTag.innerHTML;
				}
				if (document.getElementById("body") != null) {
					if (BODYTag.getAttribute("editor") == null) {
						isEditor = true;
						if (pUse_Editor == "TAGFREE") {
							+EditorHeight + "' frameborder='0'></ifrmae>";
						} else if (pUse_Editor == "NAMO") {
							BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/NAMO_EDITOR.aspx?height='"
									+ EditorHeight + "' frameborder='0'></ifrmae>";
						} else if (pUse_Editor == "DEXT") {
							BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/DEXT_EDITOR.aspx?height='"
									+ EditorHeight + "' frameborder='0'></ifrmae>";
						} else {
							if (pUse_IE11Browser == "CK") {
								BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/CK_Editor.aspx?height='"
										+ EditorHeight + "' frameborder='0'></ifrmae>";
							}
						}
					} else {
						try {
							Conent_contentEditable(document.getElementById('body'));
						} catch (e) {}
					}
				}
				DocTitleHTML.innerHTML = DocTitleObj.innerHTML;
			} else {
				var HtmlContent = iframe_content.GetEditorContent();
				var DocTitle = frame_doctitle.value;
				DocTitleHTML = document.createElement("DIV");
				DocTitleHTML.innerHTML = DocTitle;
				
				BODYTag.innerHTML = HtmlContent;
				document.getElementById('div_Content').style.display = "";
				DocTitleObj.innerHTML = DocTitleHTML.innerText;
			}
		} catch (e) {}
	}
	function Set_EditorBodyHTML(Body) {
		try {
			if (Body != null)
				iframe_content.SetEditorContent(Body);
			else
				iframe_content.SetEditorContent(div_BODY.innerHTML);
		} catch (e) {}
	}

	function GetBodyHTML() {
		try {
			return iframe_content.GetEditorContent();
		} catch (e) {
			return null;
		}
	}
	function ReplaceText(orgStr, findStr, replaceStr) {
		try {
			if (findStr == ".") {
				var a = 0;
				for (a = 0; a < 10; a++)
					orgStr = orgStr.replace(".", replaceStr);
				return orgStr;
			} else {
				var re = new RegExp(findStr, "gi");
				return (orgStr.replace(re, replaceStr));
			}
		} catch (e) {
			return orgStr
		}
	}
	function Signature_ImagePathConvert(tbContent) {
		var tempDiv = document.createElement("DIV");
		tempDiv.innerHTML = tbContent;
		var imgColl = tempDiv.getElementsByTagName("IMG");
		var OrgBody = tbContent;
		for (var i = 0; i < imgColl.length; i++) {
			if (imgColl.item(i).src.indexOf("file:///") == 0) {
				var OrgSrc = imgColl.item(i).src;
				var NewSrc = ConvertSaveImageFile(OrgSrc);
				OrgBody = OrgBody.replace(OrgSrc, NewSrc);
			} else if (imgColl.item(i).src.indexOf("mhtml:") == 0) {
				var OrgSrc = imgColl.item(i).src;
				var NewSrc = ConvertSaveImageFile(OrgSrc);
				OrgBody = OrgBody.replace(OrgSrc, NewSrc);
			}
		}
		return OrgBody;
	}
	function ConvertSaveImageFile(filename) {
		filename = unescape(filename);
		if (filename.indexOf("file:///") == 0)
			filename = ReplaceText(filename, "file:///", "");
		
		var lastIndex = -1;
		lastIndex = filename.lastIndexOf('.');
		var fileExt = "";
		if (lastIndex != -1) {
			fileExt = filename.substring(lastIndex + 1, filename.len);
		} else {
			fileExt = "";
		}
		var result = false;
		var ezUtil = new ActiveXObject("ezUtil.MiscFunc.1");
		ezUtil.UseUTF8 = true;
		if (fileExt == "bmp") {
			var imageGUID = ezUtil.GetGUID();
			
			var newfilename = filename.substr(0, filename.lastIndexOf("/") + 1) + imageGUID + ".png";
			var imageUtil = new ActiveXObject("ezUtil.ImageFunc");
			
			result = imageUtil.ConvertImageFormat(filename, newfilename, "image/png");
			
		}
		
		if (result == true)
			filename = newfilename;
		
		var fullpath = filename;
		var encodedText = ezUtil.DownloadToBase64(fullpath);
		
		if (result == true)
			ezUtil.DeleteFile(filename);
		
		var XmlHttp = createXMLHttpRequest();
		var xmlDom = createXmlDom();
		var objNode;
		createNodeInsert(xmlDom, objNode, "DATA");
		createNodeAndInsertText(xmlDom, objNode, "IMAGECONTENT", encodedText);
		createNodeAndInsertText(xmlDom, objNode, "IMAGEEXT", fileExt);
		try {
			XmlHttp.open("POST", "/myoffice/Common/ImageToSaveFile_Stream.aspx", false);
			XmlHttp.send(xmlDom);
			return XmlHttp.responseText;
		} catch (e) {}
	}
	function Get_HtmlBody(HTML) {
		var Div = document.createElement("DIV");
		Div.innerHTML = HTML;
		var TDRows = Div.getElementsByTagName("TD");
		for (var i = 0; i < TDRows.length; i++) {
			if (TDRows.item(i).getAttribute("free") != null && TDRows.item(i).id != "body" && TDRows.item(i).id != "doctitle") {
				if (TDRows.item(i).childNodes.length > 0) {
					if (TDRows.item(i).childNodes.item(0).nodeName == "DIV" && TDRows.item(i).childNodes.item(0).getAttribute("contentEditable") != null) {
						var Div_Tag = document.createElement("DIV");
						Div_Tag.innerHTML = TDRows.item(i).childNodes.item(0).innerHTML;
						TDRows.item(i).innerHTML = Div_Tag.outerHTML;
					}
				}
			}
		}
		/* reform
		var InputRows = Div.getElementsByTagName("INPUT");
		for (var i = 0; i < InputRows.length; i++) {
		    if (InputRows.item(i).getAttribute("check") == "1")
		        InputRows.item(i).outerHTML = InputRows.item(i).outerHTML.replace("input ", "input checked ");
		}
		var SelectRows = Div.getElementsByTagName("SELECT");
		for (var i = 0; i < SelectRows.length; i++) {
		    for (var j = 0; j < SelectRows.item(i).childNodes.length; j++) {
		        if (SelectRows.item(i).childNodes.item(j).nodeType == "1") {
		            if (SelectRows.item(i).childNodes.item(j).getAttribute("check") == "2")
		                SelectRows.item(i).childNodes.item(j).setAttribute("selected");
		            else {
		                SelectRows.item(i).childNodes.item(j).removeAttribute("selected");
		            }
		        }
		    }
		}
		 */

		return Div.innerHTML;
	}
	var Doc_ContentHtml
	function Get_EditorBodyHTML() {
		try {
			var HTML;
			Doc_ContentHtml = document.createElement("DIV");
			Doc_ContentHtml.innerHTML = Get_HtmlBody(document.getElementById('div_Content').innerHTML);
			var EditorContent = isEditor ? iframe_content.GetEditorContent() : document.getElementById("body") == null ? "" : document.getElementById("body").innerHTML;
			
			div_BODY.innerHTML = EditorContent;
			
			if (!isEditor)
				EditorContent = Get_HtmlBody(EditorContent);
			EditorContent = Signature_ImagePathConvert(EditorContent);
			
			//body a link tagert attribute set 
			var Div_ = document.createElement("DIV");
			Div_.innerHTML = EditorContent;
			var ATagRows = Div_.getElementsByTagName("A");
			for (var i = 0; i < ATagRows.length; i++) {
				ATagRows.item(i).setAttribute("target", "_blank");
			}
			EditorContent = Div_.innerHTML;
			
			//ê²°ì¬ë¬¸ìë¶ì¬ë£ê¸° ì¤ë¥ ë³´ìì½ë 2013.01.08
			var Div_ = document.createElement("DIV");
			Div_.innerHTML = EditorContent;
			var DivCnt = Div_.getElementsByTagName("*").length;
			for (var i = 0; i < DivCnt; i++) {
				if (Div_.getElementsByTagName("*").item(i).id == "body") {
					Div_.getElementsByTagName("*").item(i).removeAttribute("id");
					Div_.getElementsByTagName("*").item(i).removeAttribute("class");
					EditorContent = Div_.innerHTML;
				}
				if (Div_.getElementsByTagName("*").item(i).id == "div_Content") {
					Div_.getElementsByTagName("*").item(i).removeAttribute("id");
					EditorContent = Div_.innerHTML;
				}
			}
			var bodyObj = null, titleObj = null;
			var ElementCnt = Doc_ContentHtml.getElementsByTagName("*").length;
			for (var i = 0; i < ElementCnt; i++) {
				if (Doc_ContentHtml.getElementsByTagName("*").item(i).id == "body") {
					bodyObj = Doc_ContentHtml.getElementsByTagName("*").item(i);
				} else if (Doc_ContentHtml.getElementsByTagName("*").item(i).id == "doctitle") {
					titleObj = Doc_ContentHtml.getElementsByTagName("*").item(i);
				}
				if (bodyObj != null && titleObj != null)
					break;
			}
			if (bodyObj != null && titleObj != null) {
				bodyObj.innerHTML = EditorContent;
				if (bodyObj.childNodes.length >= 1) {
					bodyObj.style.textAlign = "left";
				}
				if (DocTitleObj.getAttribute("free") != null) {
					titleObj.innerHTML = GetDocTitle();
					titleObj.style.textAlign = "left";
				}
			}
			HTML = HTMLtoMHT_MakeTag(Doc_ContentHtml);
			return HTML;
		} catch (e) {
			return "";
		}
	}

	function GetTagList(strTagName) {
		try {
			var TagsList = new Array();
			var TagCount = 0;
			var count = 0;
			var i = 0;
			
			count = document.getElementsByTagName("*").length;
			
			for (i = 0; i < count; i++) {
				if (document.getElementsByTagName("*")[i].tagName == strTagName) {
					TagsList[TagCount] = document.getElementsByTagName("*")[i];
					TagCount++;
				}
			}
			return TagsList;
		} catch (e) {
			return TagsList;
		}
	}

	var _reUseContent = "";
	function Editor_ReUseContent(content) {
		_reUseContent = content;
	}

	function Editor_Complete() {
		try {
			BodyTagsEnabled(div_BODY);
			if (pUse_IE11Browser == "CK") {
				iframe_content.SetEditorContent(div_BODY.innerHTML);
				if (document.getElementById("body").getAttribute("class") == "FIELD")
					BODYTag = document.getElementById("body");
				
				var EditorHeight = 500;
				if (BODYTag.getAttribute("tagfreeheight")) {
					EditorHeight = BODYTag.getAttribute("tagfreeheight")
				}
				
				iframe_content.Set_Size(0, EditorHeight);
			} else {
				iframe_content.SetEditorContent(div_BODY.innerHTML);
			}
			if (_reUseContent != "")
				iframe_content.SetEditorContent(_reUseContent);
			if (isConDoc) {
				parent.Conn_Initial();
			}
			
		} catch (e) {}
	}

	function Get_ConnFieldList() {
		try {
			var FieldsList = new Array();
			var FieldCount = 0;
			var count = 0;
			var i = 0;
			
			count = div_BODY.getElementsByTagName("*").length;
			
			for (i = 0; i < count; i++) {
				if (div_BODY.getElementsByTagName("*")[i].getAttribute("class") == "FIELD") {
					var tmp = div_BODY.getElementsByTagName("*")[i];
					
					if (!tmp.FieldID)
						tmp.FieldID = tmp.id;
					
					FieldsList[FieldCount] = tmp;
					FieldCount++;
				}
			}
			return FieldsList;
		} catch (e) {}
	}
	function Conn_Before() {
		try {
			div_BODY.innerHTML = iframe_content.GetEditorContent();
		} catch (e) {}
	}
	function Conn_after() {
		try {
			iframe_content.SetEditorContent(div_BODY.innerHTML);
		} catch (e) {}
	}
	function Conn_BodyFieldWrite(FieldName, FieldValue) {
		document.getElementById(FieldName).innerText = FieldValue;
	}
</script>
</head>
<body>
	<div id="div_Content"></div>
	<div id="div_BODY" style="display: none"></div>
	<div id="CONNINFO" name="CONNINFO" style="display: none"></div>
</body>
</html>
