<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/diff.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
	    
	    <%-- 2023-12-05 홍승비 - 결재 서명 데이터를 DB(TBL_SIGNINFO)에서 가져와, 문서 상에 다시 그려주는(재맵핑) 함수 적용 --%>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprSignRedraw.js')}"></script>
		
	    <style type="text/css">
	    	 P { margin-top: 0px;margin-bottom: 0px; }
	        .viewbox {
				border:0;
				padding:5px;
				height:100%;
				background-color:#fff;
				border-collapse:collapse
			}
			
			#div_Content table {
		     	word-break : break-word;   
		    }
		    
			addsentence {
				text-decoration: none;
	            background-color: #d4fcbc;
			}
	        delsentence {
	            text-decoration: line-through;
	            background-color: #fbb6c2;
	            color: #555;
	        }
	    </style>
	    <script language="javascript" type="text/javascript">
// 	        var XmlBodyATT = createXmlDom();
	        document.onselectstart = function () { return true; };
	        window.onload = function () {
	            try {
	                parent.DocumentComplete(this);
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
				var textAreaElements = HtmlObject.getElementsByTagName("textarea");
				var element;

				for (var i = 0; i < textAreaElements.length; i++) {
					element = textAreaElements[i];

					if (!element.disabled) {
						element.disabled = true;
					}
				}
	            return HtmlObject;
	        }
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
	                    }
	                    BodyTagsDisabled(document.getElementById('div_Content'));
	                    parent.FieldsAvailable(this);
	                }
	            } catch (e)
	            { }
	        }
	        
	        /* 2020-02-25 홍승비 - 본문 비교용 함수 추가 */
	        function Set_EditorContentURL_Compare(OrgHref, Href) {
	            try {
	                var tempOrgXML = createXmlDom();
	                var tempXML = createXmlDom();
	                var XmlBodyOrgDATA = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempOrgStr = "";
	                var tempStr = "";
	                
	                tempOrgStr = ConvertMHTtoHTML(encodeURI(OrgHref));
	                tempStr = ConvertMHTtoHTML(encodeURI(Href));
	                tempOrgXML = loadXMLString(tempOrgStr);
                    tempXML = loadXMLString(tempStr);
                    
                    XmlBodyOrgDATA = GetElementsByTagName(tempOrgXML, 'BODYDATA')[0];
                    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];

                    var _DocOrgHTML = getNodeText(XmlBodyOrgDATA);
                    var _DocHTML = getNodeText(XmlBodyDATA);

                    // 이미지는 비교하지 않는다.
                    var img_tag = /<IMG(.*?)>/gi;
                    _DocHTML = _DocHTML.replace(img_tag, ""); 
                    _DocHTML = _DocHTML.replace(/<OPTION(.*?)>/gi, ""); 
                    //_DocHTML = _DocHTML.replace(/(<\/INPUT|<INPUT)*>/gi, ""); 
                    //_DocHTML = _DocHTML.replace(/<\/INPUT|<INPUT)(type?radio?)(\/>|>)/gi, ""); 

                    var _OrgHTMLTag = document.createElement("DIV");
                    _OrgHTMLTag.innerHTML = _DocOrgHTML;
                    var _DocOrgBody = "";

                    var _HTMLTag = document.createElement("DIV");
                    _HTMLTag.innerHTML = _DocHTML;
                    var _DocBody = "";

                    for (var i = 0; i < _OrgHTMLTag.getElementsByTagName("*").length; i++) {
                        if (_OrgHTMLTag.getElementsByTagName("*")[i].id.toLocaleLowerCase() == "body") {
                            _DocOrgBody = _OrgHTMLTag.getElementsByTagName("*")[i].innerHTML;

                            for (var j = 0; j < _HTMLTag.getElementsByTagName("*").length; j++) {
                                if (_HTMLTag.getElementsByTagName("*")[j].id.toLocaleLowerCase() == "body") {
                                    _DocBody = _HTMLTag.getElementsByTagName("*")[j].innerHTML;
									_OrgHTMLTag.getElementsByTagName("*")[i].innerHTML = $(_DocBody).find("tr").length == $(_DocOrgBody).find("tr").length ? htmldiff(_DocOrgBody, _DocBody) : _DocOrgBody;
                                    break;
                                }
                            }
                        }
                    }

                    for (var i = 0; i < _OrgHTMLTag.getElementsByTagName("*").length; i++) {
                        if (_OrgHTMLTag.getElementsByTagName("*")[i].id.toLocaleLowerCase() == "ezeditor" && _OrgHTMLTag.getElementsByTagName("*")[i].innerHTML.trim() == "") {
                            _OrgHTMLTag.getElementsByTagName("*")[i].parentNode.removeChild(_OrgHTMLTag.getElementsByTagName("*")[i]);
                            break;
                        }
                    }
                    
                    var _DocContentHtml = _OrgHTMLTag.innerHTML;
                    var ConXmlDiv = document.createElement("DIV");
                    ConXmlDiv.innerHTML = _DocContentHtml;

                    if (ConXmlDiv.getElementsByTagName("XML").length > 0) {
                        ConXmlDiv.getElementsByTagName("XML").item(0).style.display = "none";
                        CONNINFO.innerHTML = ConXmlDiv.getElementsByTagName("XML").item(0).outerHTML;
                        _DocContentHtml = ConXmlDiv.innerHTML;
                    }
                    
                    document.getElementById('div_Content').innerHTML = "";
                    document.getElementById('div_Content').innerHTML = _DocContentHtml;

                    _htmlcontent = document.getElementById('div_Content').innerHTML;

                    var TDRows = document.getElementById('div_Content').getElementsByTagName("TD")
                    for (var i = 0; i < TDRows.length; i++) {
                        if (GetAttribute(TDRows.item(i), "id") != null) {
                            if (TDRows.item(i).childNodes.length == 0) {
                                if (TDRows.item(i).innerHTML == "" || TDRows.item(i).innerHTML == " ") {
                                    TDRows.item(i).innerHTML = "&nbsp;";
                                }
                            }
                        }
                    }
                    BodyTagsDisabled(document.getElementById('div_Content'));
                    // 미사용 parent.FieldsAvailable() 함수 제거
	            } catch (e)
	            { }
	        }
	        
	        function GetFieldsList() {
	            var FieldsList = new Array();
	            var FieldCount = 0;
	            var count = 0;
	            var i = 0;
	            try {
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

					var controls = getControlList();
					FieldsList = FieldsList.concat(controls);
					
	                return FieldsList;
	            } catch (e) { return FieldsList; }
	        }
	        function GetListItem(pList, str) {
	            try {
	                for (i = 0; i < pList.length; i++) {
	                    if (pList[i].id == str || pList[i].name == str)
	                        return pList[i];
	                }
	            } catch (e)
	            { return null; }
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

            function GetFieldText(name){
                var list = GetFieldsList();
                var result = "";
                list.forEach(function(item, i){
                    if(item.id == name){
                        result = item.textContent;
                        return;
                     }
                });
               return result;
            }

	    </script>
	</head>
	<body>
	    <div id="div_Content"></div>
	    <div id="div_BODY" style="display: none"></div>
	    <div id="CONNINFO" name="CONNINFO" style="display: none"></div>
	</body>
</html>