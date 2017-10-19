<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script  type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script  type="text/javascript" src="/js/ezEditor/namoEditor/js/namo_scripteditor.js"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
		<script type="text/javascript">
		var userLang = "${userInfo.lang}";
		var type = "${type}";
		var height = "${height}";
		
        function OnInitCompleted(e) {
            // 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
            if (parent.onloadflag || typeof parent.onloadflag === "undefined") {
                parent.Editor_Complete();

	            CrossEditor.SetBodyStyle("font-family", "<spring:message code='main.t246' />");
				CrossEditor.SetBodyStyle("font-size", "13px");
            } else {
                setTimeout(OnInitCompleted, 10);
            }
        }

        var BlockArr = new Array();
        
        //양식작성기에서 사용
//         function CE_OnMouseActive(e) {
//             if (e.type == "mouseup") {
//                 if (parent.Attribute_Write != undefined) {
//                     View_CellProperty2();
//                     var parentTag = e.targetNode;
//                     if (parentTag.tagName == "TD")
//                         parent.Attribute_Write(GetAttribute(parentTag, "id"));
//                     else
//                         while (parentTag && !parentTag.previousElementSibling && !parentTag.nextElementSibling) {
//                             parentTag = parentTag.parentNode;
//                             if (parentTag.tagName == "TD") {
//                                 parent.Attribute_Write(GetAttribute(parentTag, "id"));
//                                 break;
//                             }
//                         }
//                 }
//             }
//         }

        //양식작성기에서 사용
//         function CE_OnKeyActive(e) {
//             if (e.type == "keyup") {
//                 if (parent.Attribute_Write != undefined) {
//                     View_CellProperty2();
//                     var parentTag = e.targetNode;
//                     if (parentTag.tagName == "TD")
//                         parent.Attribute_Write(GetAttribute(parentTag, "id"));
//                     else {
//                         while (parentTag && !parentTag.previousElementSibling && !parentTag.nextElementSibling) {
//                             parentTag = parentTag.parentNode;
//                             if (parentTag.tagName == "TD") {
//                                 parent.Attribute_Write(GetAttribute(parentTag, "id"));
//                                 break;
//                             }
//                         }
//                     }
//                 }
//             }
//         }

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
                selCell.removeAttribute("id");
                if (selCell.classList.contains("FIELD"))
                    selCell.classList.remove("FIELD");
            }
            else if (type == "LOCK") {
                if (selCell.getAttribute("free") != null)
                    selCell.removeAttribute("free");
                else
                    selCell.setAttribute("free", "");
            }
            else {
                selCell.setAttribute("id", id);
                if (!selCell.classList.contains("FIELD"))
                    selCell.classList.add("FIELD");
            }
            BlockArr.push(selCell);
            selCell.style.backgroundColor = "#BEE7FC";
        }
        
		//양식작성기에서 사용
//         function View_CellProperty(g_toggleFlag) {
//             var TotalTag = CrossEditor.GetBodyElementsByTagName("TD");
//             try {
//                 for (var i = 0 ; i < TotalTag.length; i++) {
//                     if (TotalTag[i].tagName == "TD" && TotalTag[i].id != "") {
//                         if (g_toggleFlag) {
//                             TotalTag[i].setAttribute("beforebgcolor", TotalTag[i].style.backgroundColor);
//                             TotalTag[i].style.backgroundColor = "#BEE7FC";
//                             BlockArr.push(TotalTag[i]);
//                         }
//                         else {
//                             TotalTag[i].style.backgroundColor = TotalTag[i].getAttribute("beforebgcolor");
//                             TotalTag[i].removeAttribute("beforebgcolor");
//                             BlockArr.push(TotalTag[i]);
//                         }
//                     }
//                 }
//             } catch (e) {
//                 alert(e.message);
//             }

//             return g_toggleFlag;
//         }

		//양식작성기에서 사용
//         function View_CellProperty2() {
//             var BlockCnt = BlockArr.length;
//             for (var i = BlockCnt - 1; i >= 0; i--) {
//                 BlockArr[i].style.backgroundColor = "";
//                 BlockArr.pop();
//             }
//         }

		//사용하는 곳 없음
//         function SetBodyValue(Data) {
//             try {
//                 CrossEditor.SetValue(Data);

//             } catch (e) { }
//         }

        function SetEditorContent(Data) {
            try {
                CrossEditor.SetBodyValue(Data);
                if (type == "APPROVAL" || type == "APPROVALG") {
            		if ("${isUsed}" != "reuse") {
            			Set_CellLocked();
            		}
            	}
            } catch (e) { }
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
                CrossEditor.SetBodyValue(htmlData);
            } catch (e) { }
        }
		
        //메일(편지지)쪽에서 사용
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
		
        //사용하는 곳 없음
//         function SetEditorContentURL_Admin(pURL) {
//             try {
//                 var tempXML = createXmlDom();
//                 var XmlBodyATT = createXmlDom();
//                 var XmlBodyDATA = createXmlDom();
//                 var tempStr = "";
//                 tempStr = ConvertMHTtoHTML(pURL);
//                 tempXML = loadXMLString(tempStr)
//                 XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
//                 XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];

//                 var Doc_ContentHtml = document.createElement("DIV");
//                 Doc_ContentHtml.innerHTML = getNodeText(XmlBodyDATA);

//                 var htmlData = "";
//                 var ConnData = "";
//                 if (GetChildNodes(Doc_ContentHtml)[0].id == "conn") {
//                     ConnData = Doc_ContentHtml.children[0].innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', '');
//                     htmlData = Doc_ContentHtml.children[1].outerHTML;
//                 }
//                 else {
//                     htmlData = getNodeText(XmlBodyDATA);
//                 }
//                 CrossEditor.SetBodyValue(htmlData);
//                 return ConnData;
//             } catch (e) { }
//         }

		//양식작성기에서 사용
//         function FormInfoCheck(type) {
//             try {
//                 switch (type) {
//                     case "null":
//                         if (CrossEditor.GetEditor() == null)
//                             return true;
//                         else
//                             return false;
//                         break;
//                     case "body":
//                         var CheckCount = 0;
//                         var HtmlTag = CrossEditor.GetBodyElementsByTagName("*");
//                         for (var i = 0 ; i < HtmlTag.length; i++) {
//                             if (GetAttribute(HtmlTag[i], "id") == "body")
//                                 CheckCount++;
//                         }
//                         return CheckCount;
//                         break;
//                     case "doctitle":
//                         var CheckCount = 0;
//                         var HtmlTag = CrossEditor.GetBodyElementsByTagName("*");
//                         for (var i = 0 ; i < HtmlTag.length; i++) {
//                             if (GetAttribute(HtmlTag[i], "id") == "doctitle")
//                                 CheckCount++;
//                         }
//                         return CheckCount;
//                         break;
//                     case "doctitlefield":
//                         var CheckCount = 0;
//                         var HtmlTag = CrossEditor.GetBodyElementsByTagName("*");
//                         for (var i = 0 ; i < HtmlTag.length; i++) {
//                             if (GetAttribute(HtmlTag[i], "id") == "body")
//                                 return GetAttribute(HtmlTag[i], "doctitlefield");
//                         }
//                         break;
//                     default:
//                 }

//             } catch (e) {
//             }
//         }

        function GetEditorContent() {
            try {
            	if (type == "APPROVAL" || type == "APPROVALG") {
	                return Get_BodyUnlock(CrossEditor.GetBodyValue("XHTML"));
            	} else {
	                return CrossEditor.GetBodyValue("XHTML");
            	}
            } catch (e) { return ""; }
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
		
        //메일(plain text)에서 사용
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

        function Set_CellLocked() {
        	var elementArr = CrossEditor.GetBodyElementsByTagName("*");
        	
            for (var i = 0; i < elementArr.length; i++) {
                if (elementArr[i].tagName == "TD") {
                    if (elementArr[i].getAttribute("free") == null) {
                    	elementArr[i].setAttribute("namo_lock", "namo_lock");
                    }
                }
            }
        }
		
        //사용하는 곳 없음
//         function SetEditorFocus() {
//             try {
//                 CrossEditor.SetFocusEditor();
//             } catch (e) {
//             }
//         }

        //메일(서명)쪽에서 사용
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

        //메일(편지지)쪽에서 사용
        function EditorElementHTML(elementID, gubun) {
            try {
                var ElementObj;
                var ElementObjArr = CrossEditor.GetBodyElementsByTagName("*");
                
                for (var i = 0; i < ElementObjArr.length; i++) {
                    if (ElementObjArr[i].id == elementID) {
                        ElementObj = ElementObjArr[i];
                    }
                }

                if (!ElementObj) {
                    return "";
                }
                else {
                    if (gubun == "1") {
                        return ElementObj.innerHTML;
                    }
                    else {
                        return ElementObj.outerHTML;
                    }
                }
            } catch (e) {
                return "";
            }
        }

        //전자결재쪽에서 사용
        function GetFieldsList() {
            var FieldsList = new Array();
            var elementArr = CrossEditor.GetBodyElementsByTagName("*");
            
            for (var i = 0; i < elementArr.length; i++) {
                if (elementArr[i].id == "MailSign") {
                    FieldsList[0] = elementArr[i];
                }
            }
            return FieldsList;
        }

        //사용하는 곳 없음
//         function GetBodyFields() {
//             var FieldsList = new Array();
//             FieldsList = CrossEditor.GetBodyElementsByTagName("*");
//             return FieldsList;
//         }
		</script>
	</head>
	<body style="margin: 0px; padding: 0px;">
	    <script type="text/javascript">
	        var CrossEditor = new NamoSE("Namo");
			
	        if (type == "APPROVAL" || type == "APPROVALG") {
				CrossEditor.params.Height = height + "px";
			} else {
				CrossEditor.params.Height = document.documentElement.clientHeight + "px";
			}
	        
	        if (type == "MAILOUTOFOFFICE") {
	        	//TODO: 이미지 업로드 못하도록(붙여넣기, 드래그앤드랍 시 에러메시지 안나오도록..)
	        	CrossEditor.params.DeleteCommand = ["image"];
	        }
	        
	        CrossEditor.params.UploadFileExecutePath = "${serverUrl}/ezEditor/namoUpload.do?type=" + type;
			CrossEditor.params.FullScreen = true;
	        CrossEditor.params.PutStyleInBody = true;
	        CrossEditor.params.Font = "<spring:message code='main.t0620' />".split(";");
	        CrossEditor.params.ParagraphTagStyle = {"font-size":"13px;", "font-family":"<spring:message code='main.t246' />"};
	        
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