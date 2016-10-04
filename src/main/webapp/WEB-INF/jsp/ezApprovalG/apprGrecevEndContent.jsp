<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script language="javascript" type="text/javascript">
	        var XmlBodyATT = createXmlDom();
	        document.onselectstart = function () { return false; };
	        var BODYTag;
	        var BODYHTML;
	        var DocTitleObj;
	        var DocTitleHTML;
	        var _htmlcontent;
	        window.onload = function () {
	            try {
	                parent.DocumentComplete();
	            } catch (e)
	            { }
	        };
	        function Set_EditorContentURL(url) {
	            try {
	                var tempXML = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempStr = "";
	                var URL = encodeURI(url);
	                tempStr = ConvertMHTtoHTML(URL);
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
	
	                    document.getElementById('div_Content').innerHTML = _DocContentHtml.replace(/(<p)/igm, '<div style=\"font-size:10pt;\"').replace(/<\/p>/igm, '</div>');
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
	                    }
	                    BodyTagsDisabled(document.getElementById('div_Content'));
	                    parent.FieldsAvailable();
	                }
	            } catch (e)
	            { }
	        }
	        function Set_EditorContentURL2(url) {
	            try {
	                var tempXML = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempStr = "";
	                var URL = encodeURI(url);
	                tempStr = ConvertMHTtoHTML(URL);
	                tempXML = loadXMLString(tempStr);
	                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	
	                var _DocContentHtml = getNodeText(XmlBodyDATA);
	
	                var ConXmlDiv = document.createElement("DIV");
	                ConXmlDiv.innerHTML = _DocContentHtml;
	                if (ConXmlDiv.getElementsByTagName("XML").length > 0) {
	                    ConXmlDiv.getElementsByTagName("XML").item(0).style.display = "none";
	                    CONNINFO2.innerHTML = ConXmlDiv.getElementsByTagName("XML").item(0).outerHTML;
	                    _DocContentHtml = ConXmlDiv.innerHTML;
	                }
	                document.getElementById('div_Content').innerHTML = _DocContentHtml.replace(/(<p)/igm, '<div style=\"font-size:10pt;\"').replace(/<\/p>/igm, '</div>');
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
	                }
	                parent.FieldsAvailable2();
	            } catch (e)
	            { }
	        }
	        function GetDocTitle() {
	            try {
	                if (document.getElementById("frame_doctitle") == null) {
	                    return document.getElementById("doctitle").textContent;
	                }
	                else {
	                    return document.getElementById("frame_doctitle").value;
	                }
	            } catch (e) {
	                return "";
	            }
	        }
	        function GetFieldsList() {
	            var FieldsList = new Array();
	            var FieldCount = 0;
	            var count = 0;
	            var i = 0;
	            try {
	                count = div_Content.getElementsByTagName("*").length;
	                for (i = 0; i < count; i++) {
	                    var cName = "";
	                    if (CrossYN()) {
	                        cName = div_Content.getElementsByTagName("*")[i].getAttribute("class");
	                    }
	                    else {
	                        cName = div_Content.getElementsByTagName("*")[i].className;
	                    }
	
	                    if (cName == "FIELD") {
	                        var tmp = div_Content.getElementsByTagName("*")[i];
	                        if (!tmp.FieldID)
	                            tmp.FieldID = tmp.id;
	                        FieldsList[FieldCount] = tmp;
	                        FieldCount++;
	                    }
	                }
	                return FieldsList;
	            } catch (e) { return FieldsList; }
	        }
	        function GetListItem(pList, str) {
	            try {
	                for (var i = 0; i < pList.length; i++) {
	                    if (pList[i].id == str || pList[i].name == str)
	                        return pList[i];
	                }
	            } catch (e)
	            { return null; }
	        }
	        function DocumentSetFildeValue(FildName, FildeValue) {
	            try {
	                document.getElementById(FildName).textContent = FildeValue;
	            } catch (e)
	            { }
	        }
	        function DocumentFildeCheck(FildName) {
	            try {
	                if (document.getElementById(FildName) != null)
	                    return true;
	                else
	                    return false;
	            } catch (e) { return false; }
	        }
	        function DocumentBodySetAttribute(AttributeName, AttributeValue) {
	            try {
	                if (document.getElementById("body").getAttribute("class") == "FIELD") {
	                    document.getElementById("body").setAttribute(AttributeName, AttributeValue);
	                }
	            } catch (e) { }
	        }
	        function DocumentBodyGetAttribute(AttributeName) {
	            try {
	                return document.getElementById("body").getAttribute(AttributeName);
	            } catch (e)
	            { return null; }
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
	
	        function GetTagList(strTagName) {
	            var TagsList = new Array();
	            var TagCount = 0;
	            var count = 0;
	            var i = 0;
	            try {
	                count = document.getElementsByTagName("*").length;
	
	                for (i = 0; i < count; i++) {
	                    if (document.getElementsByTagName("*")[i].tagName == strTagName) {
	                        TagsList[TagCount] = document.getElementsByTagName("*")[i];
	                        TagCount++;
	                    }
	                }
	                return TagsList;
	            } catch (e)
	            { return TagsList; }
	        }
	
	        function Editor_Complete() {
	            try {
	                iframe_content.xfe.SetFocus();
	                iframe_content.SetEditorContent(div_BODY.innerHTML);
	                parent.Conn_Initial();
	            } catch (e)
	            { }
	        }
	
	        function Editor_SetFieldValue(fieldname, value) {
	            try {
	                iframe_content.Set_ElementByIDValue(fieldname, value);
	            } catch (e)
	            { }
	        }
	        function Editor_GetFieldValue(fieldname) {
	            try {
	                return iframe_content.Get_ElementByIDValue(fieldname);
	            } catch (e) { return null; }
	        }
	
	        function Get_ConnFieldList() {
	            var FieldsList = new Array();
	            var FieldCount = 0;
	            var count = 0;
	            var i = 0;
	            try {
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
	            } catch (e)
	            { return FieldsList; }
	        }
	        function Conn_Before() {
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
	    <div id="div_Content2"></div>
	    <div id="div_BODY" style="display: none"></div>
	    <div id="div_BODY2" style="display: none"></div>
	    <div id="CONNINFO" name="CONNINFO" style="display: none"></div>
	    <div id="CONNINFO2" name="CONNINFO2" style="display: none"></div>
	</body>
</html>