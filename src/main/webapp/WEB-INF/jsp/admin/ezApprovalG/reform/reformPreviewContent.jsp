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
	// reform
	var args = parent.args;
	var reformScriptCode = args.reformScriptCode;
	var isIE11Mode = args.isIE11Mode;
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
			} else if (obj.nodeName == "P") {
				ret = true;
			}
		} catch (e) {}
		return ret;
	};

	var BODYTag;
	var BODYHTML;
	var DocTitleObj;
	var DocTitleHTML;
	var _htmlcontent;
	
	var isEditor = false;
	
	var pUse_Editor = "${editor}";
	var pUse_IE11Browser = "${ie11editor}";
	
	window.onload = function() {
		// reform
		document.getElementById('div_Content').innerHTML = args.bodyHtml;
		
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
		var curevent = (typeof event == 'undefined' ? e : event);
		if (curevent.keyCode == "13")
			return false;
		else {
			if (curevent.keyCode != "8" && curevent.keyCode != "46") {
				if (obj.textContent.length > parseInt(Maxlength))
					return false;
				else
					return true;
			} else if (curevent.keyCode == "8" && navigator.userAgent.indexOf('Firefox') != -1) {
				if (obj.childNodes.length > 0) {
					var i = 0;
					if (obj.childNodes.item(i).nodeName == "#text")
						i = 1;
					if (obj.childNodes.item(i).textContent.length == 0)
						return false;
					else {
						
						if (obj.childNodes.item(i).innerHTML == "&nbsp;")
							return false;
						else
							return true;
					}
				} else {
					if (obj.textContent.length == 0)
						return false;
					else {
						if (obj.innerHTML == "&nbsp;")
							return false;
						else
							return true;
					}
				}
			} else
				return true;
		}
	}
	function SelectOnchange(obj) {
		for (var i = 0; i < obj.options.length; i++) {
			if (i == obj.selectedIndex) {
				obj.options[i].setAttribute("selected", "selected");
			} else {
				obj.options[i].removeAttribute("selected");
			}
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
</script>
</head>
<body>
	<div id="div_Content"></div>
	<div id="div_BODY" style="display: none"></div>
	<div id="CONNINFO" name="CONNINFO" style="display: none"></div>
</body>
</html>
