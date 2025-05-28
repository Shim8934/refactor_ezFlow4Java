<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
	    
	    <%-- 2023-12-05 홍승비 - 결재 서명 데이터를 DB(TBL_SIGNINFO)에서 가져와, 문서 상에 다시 그려주는(재맵핑) 함수 적용 --%>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprSignRedraw.js')}"></script>
		
	    <style>
	    	#div_Content table {
		     	word-break : break-word;   
		    }
	    </style>
	    <script language="javascript" type="text/javascript">
// 	        var XmlBodyATT = createXmlDom();
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
	            
	            try {
	            	$('#div_Content #body').css('overflow', 'auto');
	                $('#div_Content #doctitle').css('word-wrap', 'break-word');
	            } catch (e)
	            { }
	            
	            try {
			        if (document.getElementById('attitude_annual_conn')) { //근태관리 연동양식
			    		$("select[id^=control]").each(function() {
			    			$(this).val($(this).attr("attitudetype"));
			    			$(this).children("option[value=" +$(this).attr("attitudetype") + "]").attr("selected","");
			    		});
			        	
			    		$("input[type=button][id^=control]").each(function() {
			    			$(this).css("display","none");
			    		});
			    		
			    		$("select[id^=control]").each(function() {
			    			$(this).css("top","7px");
			    		});
			    		
			    		$('#mobile').css('display',"none");
			    	    $('#p_mobile').css('display',"");
			    	    $('#mobile2').css('display',"none");
			    	    $('#p_mobile2').css('display',"");
			        }
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
// 	                    XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];

	                    var Content = getNodeText(XmlBodyDATA);
	                    if (tempStr == "error")
	                        parent.document.getElementById("btnRefresh").style.display = "";

	                    var _DocContentHtml = Content;

	                    var ConXmlDiv = document.createElement("DIV");
	                    ConXmlDiv.innerHTML = _DocContentHtml;
	                    if (ConXmlDiv.getElementsByTagName("XML").length > 0) {
	                        ConXmlDiv.getElementsByTagName("XML").item(0).style.display = "none";
	                        CONNINFO.innerHTML = ConXmlDiv.getElementsByTagName("XML").item(0).outerHTML;
	                        _DocContentHtml = ConXmlDiv.innerHTML;
	                    }
						document.getElementById('div_Content').innerHTML = _DocContentHtml; //.replace(/(<p)/igm, '<div').replace(/<\/p>/igm, '</div>');
	                    
	                    var Document_Ptag = document.getElementById('div_Content').getElementsByTagName("P");
	                    if (Document_Ptag.length > 0) {
	                        for (var i = 0 ; i < Document_Ptag.length; i++) {
	                            if (Document_Ptag[i].style.marginBottom == "")
	                                Document_Ptag[i].style.marginBottom = "0px";
	                            if (Document_Ptag[i].style.marginTop == "")
	                                Document_Ptag[i].style.marginTop = "0px";
	                        }
	                    }
	                    
	                    _htmlcontent = document.getElementById('div_Content').innerHTML;
	                    var TDRows = document.getElementById('div_Content').getElementsByTagName("TD");
	                    for (var i = 0; i < TDRows.length; i++) {
	                        if (TDRows.item(i).getAttribute("class") == "FIELD") {
	                            if (TDRows.item(i).childNodes.length == 0) {
	                                if (TDRows.item(i).innerHTML == "" || TDRows.item(i).innerHTML == " ") {
	                                    TDRows.item(i).innerHTML = "";
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
	        function Set_EditorContentURL2(url) {
	            try {
	                var tempXML = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempStr = "";
	                var URL = encodeURI(url);
	                tempStr = ConvertMHTtoHTML(URL);
	                tempXML = loadXMLString(tempStr);
// 	                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];

	                var _DocContentHtml = getNodeText(XmlBodyDATA);

	                var ConXmlDiv = document.createElement("DIV");
	                ConXmlDiv.innerHTML = _DocContentHtml;
	                if (ConXmlDiv.getElementsByTagName("XML").length > 0) {
	                    ConXmlDiv.getElementsByTagName("XML").item(0).style.display = "none";
	                    CONNINFO2.innerHTML = ConXmlDiv.getElementsByTagName("XML").item(0).outerHTML;
	                    _DocContentHtml = ConXmlDiv.innerHTML;
	                }
	                document.getElementById('div_Content').innerHTML = _DocContentHtml;
	                _htmlcontent = document.getElementById('div_Content').innerHTML;
	                var TDRows = document.getElementById('div_Content').getElementsByTagName("TD")
	                for (var i = 0; i < TDRows.length; i++) {
	                    if (GetAttribute(TDRows.item(i),"id") != null) {
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

					var controls = getControlList();
					FieldsList = FieldsList.concat(controls);
					
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
	                var META3 = document.createElement("META");
	                META3.httpEquiv = "X-UA-Compatible";
	                META3.content = "IE=edge";
	                HEAD.appendChild(META);
	                HEAD.appendChild(META2);
	                HEAD.appendChild(META3);
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

			function GetDocumentInfo() {
				var xmlInfo = document.querySelectorAll("#div_Content xml");

				var xmlDom = createXmlDom();
				var dataRoot = createNodeInsert(xmlDom, null, "DATA");
				for (var i = 0, ilen = xmlInfo.length; i < ilen; i++) {
					var info = xmlInfo[i].firstElementChild;
					var infoName = info.tagName;
					createNodeAndAppandNodeText(xmlDom, dataRoot, null, infoName, info.outerHTML);
				}				
				
				return xmlDom;
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