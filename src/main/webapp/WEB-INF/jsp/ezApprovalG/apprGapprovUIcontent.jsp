<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script language="javascript" type="text/javascript">
	        document.onselectstart = function () {
	            var ret = false;
	            var obj = event.srcElement;
	            try {
	                if (obj.nodeName == "#text")
	                    obj = obj.parentElement;
	
	                if (obj.nodeName == "TD") {
	                    if (obj.getAttribute("free") != null)
	                        ret = true;
	                }
	                else if (obj.nodeName == "DIV") {
	                    var pParentNode = obj;
	                    for (var i = 0; i < 3; i++) {
	                        pParentNode = pParentNode.parentElement;
	                        if (pParentNode.nodeName == "TD") {
	                            if (pParentNode.getAttribute("free") != null) {
	                                ret = true; break;
	                            }
	                        }
	                        else if (pParentNode.nodeName == "BODY" || pParentNode.nodeName == "HTML")
	                            break;
	
	                    }
	                }
	            } catch (e) { }
	            return ret;
	        };
	        var XmlBodyATT = createXmlDom();
	        var pEditor = "${editor}";
	        var isConDoc = false;
	        var isEditor = false;
	        window.onload = function () {
	            try {
	                parent.DocumentComplete();
	            }
	            catch (e)
	            {}
	        };
	        
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
	                }
	                else if (curevent.keyCode == "8" && navigator.userAgent.indexOf('Firefox') != -1) {
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
	                    }
	                    else {
	                        if (obj.textContent.length == 0)
	                            return false;
	                        else {
	                            if (obj.innerHTML == "&nbsp;")
	                                return false;
	                            else
	                                return true;
	                        }
	                    }
	                }
	                else
	                    return true;
	            }
	        }
	        function onKeyDownEvent_Element(e, obj) {
	            var curevent = (typeof event == 'undefined' ? e : event);
	            if (curevent.keyCode == "8") {
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
	                }
	                else {
	                    if (obj.textContent.length == 0)
	                        return false;
	                    else {
	                        if (obj.innerHTML == "&nbsp;")
	                            return false;
	                        else
	                            return true;
	                    }
	                }
	            }
	            else
	                return true;
	        }
	        function SelectOnchange(obj) {
	            for (var i = 0; i < obj.childNodes.length; i++) {
	                obj.childNodes.item(i).setAttribute("check", "1");
	            }
	            obj.childNodes.item(obj.selectedIndex).setAttribute("check", "2");
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
	                                for (var Cnt = 0 ; Cnt < ChildNodes_.childNodes.length; Cnt++) {
	                                    if (ChildNodes_.childNodes.item(Cnt).nodeName == "TD" || ChildNodes_.childNodes.item(Cnt).nodeName == "TABLE") {
	                                        isContinue = false; break;
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
	                        if (navigator.userAgent.indexOf('Firefox') != -1)
	                            Div_.onkeypress = function (event) { var ret = onKeyDownEvent_Element(event, this); if (!ret) return false; };
	                        Div_.innerHTML = TDRows.item(i).innerHTML;
	                        TDRows.item(i).innerHTML = "";
	                        TDRows.item(i).appendChild(Div_);
	                    }
	                    else if (TDRows.item(i).getAttribute("free") != null && TDRows.item(i).id == "doctitle") {
	                        var Div_ = document.createElement("DIV");
	                        Div_.setAttribute("id", "frame_doctitle");
	                        Div_.setAttribute("name", "frame_doctitle");
	                        Div_.style.width = "99%";
	                        Div_.style.marginLeft = "2px";
	                        Div_.style.overflow = "hidden";
	                        Div_.setAttribute("contentEditable", true);
	                        Div_.style.textAlign = "left";
	                        Div_.onkeypress = function (event) { var ret = onKeyDownEvent(event, this, 127); if (!ret) return false; };
	                        Div_.innerHTML = TDRows.item(i).innerHTML;
	                        TDRows.item(i).innerHTML = "";
	                        TDRows.item(i).appendChild(Div_);
	                    }
	                }
	            } catch (e) { }
	        }
	        function Set_EditorContentURL(url) {
	            try {
	                var tempXML = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempStr = "";
// 	                var URL = "/ezApprovalG/downloadAttach.do?filePath=" + encodeURI(url);
	                tempStr = ConvertMHTtoHTML(url);
	                if (tempStr.indexOf("MIME-Version: 1.0") > 0) {
	                    Set_EditorContentURL(url);
	                }
	                else {
	                    tempXML = loadXMLString(tempStr);
	                    XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	
	                    var _DocContentHtml = getNodeText(XmlBodyDATA);
	                    var ConXmlDiv = document.createElement("DIV");
	                    ConXmlDiv.innerHTML = _DocContentHtml;
	                    if (ConXmlDiv.getElementsByTagName("XML").length > 0) {
	                        ConXmlDiv.getElementsByTagName("XML").item(0).style.display = "none";
	                        CONNINFO.innerHTML = ConXmlDiv.getElementsByTagName("XML").item(0).outerHTML;
	                        _DocContentHtml = ConXmlDiv.innerHTML;
	                    }
	
	                    document.getElementById('div_Content').innerHTML = _DocContentHtml; //.replace(/(<p)/igm, '<div').replace(/<\/p>/igm, '</div>');
	                    _htmlcontent = document.getElementById('div_Content').innerHTML;
	                    var TDRows = document.getElementById('div_Content').getElementsByTagName("TD");
	                    for (var i = 0; i < TDRows.length; i++) {
	                        if (TDRows.item(i).getAttribute("class") == "FIELD") {
	                            if (TDRows.item(i).childNodes.length == 0) {
	                                if (TDRows.item(i).innerHTML == "" || TDRows.item(i).innerHTML == " ") {
	                                    TDRows.item(i).innerHTML = "&nbsp;";
	                                }
	                            }
	                        }
	
	                        if (TDRows.item(i).style.borderLeftWidth.indexOf("0.") > -1) {
	                            TDRows.item(i).style.borderLeftWidth = "1px";
	                        }
	                        if (TDRows.item(i).style.borderRightWidth.indexOf("0.") > -1) {
	                            TDRows.item(i).style.borderRightWidth = "1px";
	                        }
	                        if (TDRows.item(i).style.borderTopWidth.indexOf("0.") > -1) {
	                            TDRows.item(i).style.borderTopWidth = "1px";
	                        }
	                        if (TDRows.item(i).style.borderBottomWidth.indexOf("0.") > -1) {
	                            TDRows.item(i).style.borderBottomWidth = "1px";
	                        }
	                    }
	                    parent.OrgHtml = _htmlcontent;
	                    BodyTagsDisabled(document.getElementById('div_Content'));
	                    parent.FieldsAvailable();
	                }
	            } catch (e)
	            { }
	        }
	
	        var BODYTag;
	        var BODYHTML;
	        var DocTitleObj;
	        var OrgBodyHtml;
	        function SetEditable(flag) {
	            try {
	                if (flag) {
	                    OrgBodyHtml = document.getElementById('div_Content').innerHTML;
	                    BodyTagsEnabled(document.getElementById('div_Content'));
	                    var Body_innerHTML = "";
	                    if (document.getElementById("body") != null) {
	                        if (document.getElementById("body").getAttribute("class") == "FIELD") {
	                            Body_innerHTML = document.getElementById("body").innerHTML;
	                            document.getElementById("body").innerHTML = "";
	                        }
	                    }
	                    Conent_contentEditable(document.getElementById('div_Content'));
	                    var SelectRows = document.getElementById('div_Content').getElementsByTagName("SELECT");
	                    for (var i = 0; i < SelectRows.length; i++) {
	                        SelectRows.item(i).onchange = function () { SelectOnchange(this); };
	                    }
	                    var CheckRows = document.getElementById('div_Content').getElementsByTagName("INPUT");
	                    for (var i = 0; i < CheckRows.length; i++) {
	                        if (CheckRows.item(i).type == "checkbox" || CheckRows.item(i).type == "radio")
	                            CheckRows.item(i).onchange = function () { CheckBoxOnclick(this); };
	                    }
	                    if (document.getElementById("body") != null) {
	                        if (document.getElementById("body").getAttribute("class") == "FIELD") {
	                            document.getElementById("body").innerHTML = Body_innerHTML;
	                            BODYTag = document.getElementById("body");
	                        }
	                    }
	                    if (document.getElementById("doctitle").getAttribute("class") == "FIELD")
	                        DocTitleObj = document.getElementById("doctitle");
	
	                    DocTitleHTML = document.createElement("DIV");
	                    var EditorHeight = 500;
	                    if (document.getElementById("body") != null) {
	                        if (BODYTag.getAttribute("tagfreeheight")) {
	                            EditorHeight = BODYTag.getAttribute("tagfreeheight");
	                        }
	                        if (BODYTag.childNodes.length >= 1) {
	                            if (BODYTag.children[0].id != "bodyblock") {
	                                BODYTag.innerHTML = "<div id='bodyblock' style='margin-top:5px;TEXT-ALIGN:left;'>" + BODYTag.innerHTML + "</div>";
	                            }
	                        }
	                        div_BODY.innerHTML = BODYTag.innerHTML;
	                        parent.modifiOrgBody = BODYTag.innerHTML;
	                    }
	                    if (document.getElementById("body") != null) {
	                        if (BODYTag.getAttribute("editor") == null) {
	                            isEditor = true;
	                            if (pEditor == "TAGFREE") 
	                                BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='../TagFree_TFX_Editor.aspx?height=" + EditorHeight + "' frameborder='0'></ifrmae>";
	                            else if(pEditor == "DEXT")
	                                BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='../DEXT_Editor.aspx?height=" + EditorHeight + "' frameborder='0'></ifrmae>";
	                            else 
	                                BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/ezApprovalG/ckEditor.do?height=" + EditorHeight + "' frameborder='0'></ifrmae>";
	                            
	                        }
	                        else {
	                            try {
	                                Conent_contentEditable(document.getElementById('body'));
	                            } catch (e) { }
	                        }
	                    }
	                }
	                else {
	                    DocTitleObj.innerHTML = GetDocTitle();
	                    if (document.getElementById("body") != null) {
	                        var HtmlContent = isEditor ? iframe_content.GetEditorContent() : document.getElementById("body").innerHTML;
	                        BODYTag.innerHTML = HtmlContent;
	                        document.getElementById("body").innerHTML = BODYTag.innerHTML;
	                    }
	                    BodyTagsDisabled(document.getElementById('div_Content'));
	                    document.getElementById('div_Content').innerHTML = Get_HtmlBody(document.getElementById('div_Content').innerHTML);
	                }
	            }
	            catch (e) {
	            }
	        }
	
	        function GetDocTitle() {
	            try {
	                if (document.getElementById("frame_doctitle") == null) {
	                    return document.getElementById("doctitle").textContent;
	                }
	                else {
	                    return document.getElementById("frame_doctitle").textContent;
	                }
	            } catch (e)
	            { return ""; }
	        }
	
	        function Set_EditorInputBodyHTML(Content) {
	            try {
	                if (iframe_content != null)
	                    iframe_content.SetEditorContent(Content);
	            }
	            catch (e)
	            { }
	        }
	
	        function Set_HtmlDocument() {
	            try {
	                document.getElementById('div_Content').innerHTML = OrgBodyHtml;
	            } catch (e) {
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
	            }
	            catch (e) {
	                return TagsList;
	            }
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
	            }
	            catch (e)
	            { }
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
	                            TDRows.item(i).innerHTML = Div_Tag.innerHTML;
	                        }
	                    }
	                }
	            }
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
	                            SelectRows.item(i).childNodes.item(j).outerHTML = SelectRows.item(i).childNodes.item(j).outerHTML.replace("option ", "option selected ");
	                        else {
	                            SelectRows.item(i).childNodes.item(j).outerHTML = SelectRows.item(i).childNodes.item(j).outerHTML.replace("selected=\"\"", "");
	                        }
	                    }
	                }
	            }
	
	            return Div.innerHTML;
	        }
	
	        var Doc_ContentHtml;
	        function Get_EditorBodyHTML() {
	            try {
	                var HTML = document.createElement("HTML");
	                var HEAD = document.createElement("HEAD");
	                var META = document.createElement("META");
	                META.content = "text/html; charset=utf-8";
	                META.httpEquiv = "Content-Type";
	                var META2 = document.createElement("META");
	                META2.name = "GENERATOR";
	                META2.content = "MSHTML 10.00.9200.16721";
	                HEAD.appendChild(META);
	                HEAD.appendChild(META2);
	                HTML.appendChild(HEAD);
	                var BODY = document.createElement("BODY");
	                Doc_ContentHtml = document.createElement("DIV");
	                Doc_ContentHtml.innerHTML = document.getElementById('div_Content').innerHTML;
	                BODY.appendChild(Doc_ContentHtml);
	                HTML.appendChild(BODY);
	
	                return HTML.outerHTML;
	            } catch (e)
	            { return ""; }
	        }
	
	        function Set_EditorBodyHTML(Body) {
	            try {
	                if (Body != null)
	                    iframe_content.SetEditorContent(Body);
	                else
	                    iframe_content.SetEditorContent(div_BODY.innerHTML);
	            } catch (e)
	            { }
	        }
	
	        function BodyTagsEnabled(HtmlObject) {
	            var SelectRows = HtmlObject.getElementsByTagName("SELECT");
	            for (var i = 0; i < SelectRows.length; i++) {
	                if (SelectRows.item(i).disabled)
	                    SelectRows.item(i).disabled = false;
	            }
	            var inputRows = HtmlObject.getElementsByTagName("INPUT");
	            for (var i = 0; i < inputRows.length; i++) {
	                if (inputRows.item(i).disabled)
	                    inputRows.item(i).disabled = false;
	            }
	            return HtmlObject;
	        }
	
	        function BodyTagsDisabled(HtmlObject) {
	            var SelectRows = HtmlObject.getElementsByTagName("SELECT");
	            for (var i = 0; i < SelectRows.length; i++) {
	                if (!SelectRows.item(i).disabled)
	                    SelectRows.item(i).disabled = true;
	            }
	            var inputRows = HtmlObject.getElementsByTagName("INPUT");
	            for (var i = 0; i < inputRows.length; i++) {
	                if (!inputRows.item(i).disabled)
	                    inputRows.item(i).disabled = true;
	            }
	            return HtmlObject;
	        }
	
	        function DocumentBodySetAttribute(AttributeName, AttributeValue) {
	            try {
	                if (document.getElementById("body").getAttribute("class") == "FIELD") {
	                    document.getElementById("body").setAttribute(AttributeName, AttributeValue);
	                }
	            } catch (e) {
	            }
	        }
	
	        function DocumentBodyGetAttribute(AttributeName) {
	            try {
	                return document.getElementById("body").getAttribute(AttributeName);
	            } catch (e)
	            { }
	        }
	
	        function Editor_SetFieldValue(fieldname, value) {
	            try {
	                iframe_content.Set_ElementByIDValue(fieldname, value);
	            }
	            catch (e)
	            { }
	        }
	
	        function Editor_GetFieldValue(fieldname) {
	            try {
	                return iframe_content.Get_ElementByIDValue(fieldname);
	            } catch (e)
	            { return ""; }
	        }
	
	        function Editor_Complete() {
	            try {
	                BodyTagsEnabled(div_BODY);
	                iframe_content.SetEditorContent(div_BODY.innerHTML);
	                parent.Conn_Initial();
	            } catch (e) {
	            }
	        }
	
	        function Conn_Before() {
	            parent.document.getElementById("btnEdit").style.display = "none";
	        }
	
	        function Conn_after() {
	        }
	
	        function Conn_BodyFieldWrite(FieldName, FieldValue) {
	            document.getElementById(FieldName).textContent = FieldValue;
	        }
	    </script>
	</head>
	<body>
	    <div id="div_Content"></div>
	    <div id="div_BODY" style="display: none"></div>
	    <div id="CONNINFO" name="CONNINFO" style="display: none"></div>
	</body>
</html>