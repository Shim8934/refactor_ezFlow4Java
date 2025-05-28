<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberGAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ApprovUI_Cross.js')}"></script>
 		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezAproveAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ApprGContent.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
		<!-- FormBuilder -->
		<c:if test="${isReform}">
			<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/reform/reformUseProcessor.js')}"></script>
			<c:if test="${!empty reformFunctionUrl}">
				<script type="text/javascript" src="${util.addVer(reformFunctionUrl)}"></script>
			</c:if>
		</c:if>
		<!-- FormBuilder end -->
		
		<%-- 2023-12-05 홍승비 - 결재 서명 데이터를 DB(TBL_SIGNINFO)에서 가져와, 문서 상에 다시 그려주는(재맵핑) 함수 적용 --%>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprSignRedraw.js')}"></script>
		
	    <style>
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
    	</style>
	    <script  language="javascript" type="text/javascript">
			var userLang = '${lang}';
	        document.onselectstart = function () {
	            var ret = false;
	            var obj = event.srcElement;
	            var useAllowTextSelection = "<c:out value ='${useAllowTextSelection}'/>";
	            try {
	            	if(useAllowTextSelection == "YES" || useAllowTextSelection == "") {
	            		ret = true;
	            	} else {
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
			                else if (obj.nodeName == "P") {
			                		ret = false;	                		
			                }
	            	}
	            } catch (e) { }
	            return ret;
	            
	        };
// 	        var XmlBodyATT = createXmlDom();
	        var pEditor = "<c:out value ='${editor}'/>";
	        var isConDoc = false;
	        var isEditor = false;
	        
			// FormBuilder
			var bodyInnerHtml = "";
			// FormBuilder end
	        // 일괄기안
			var frameNum = "";
			var docHref = "";
			var docID = "";
			var pDocHref = "";
			var pDraftFlag = "";
            var pDocType = "";
            var pSusinSN = "";
            var pDocState = "";
            var SignInfoFlag = "";
            var DeptSymbol = "";
            var approvalFlag = "";
            var pModeForAllDocInfo = "";
            var pModeForAllAttachInfo = "";
            var OrgAprUserID = parent.OrgAprUserID;
            var OrgAprUserName = parent.OrgAprUserName;
            var OrgAprUserName2 = parent.OrgAprUserName2;
            var OrgAprUserDeptID = parent.OrgAprUserDeptID;
            var pOrgAprUserID;
            var pOrgAprUserName;
            var pOrgAprUserName2;
            var pOrgAprUserDeptID;
            var pUserID;
            var xmlhttp		= createXMLHttpRequest();
            var xmldoc		= createXmlDom();
            var xmlaprline	= createXmlDom();
            var xmlattach	= createXmlDom();
            var Resultxml   = createXmlDom();
            var useOpenGov = parent.useOpenGov;
            var pingUserID = parent.pingUserID;
            var arr_userinfo;
            var pAprLineType;
            var orgCompanyID;
            var message = this;
            var pDocID;
            var SignName = new Array();
            var SignType = new Array();
            var SignContent = new Array();
            var signImageType = "IMAGE";
	    	var isHWP = "N";
	    	var nonElecRec = "N";
	    	
			var junGyulFlag = "${junGyulFlag}";
			var draftJunGyulFlag = "${draftJunGyulFlag}";
	        window.onload = function () {
	        	
	            try {
	                parent.DocumentComplete(this);
	                document.execCommand("AutoUrlDetect", false, false);
	            }
	            catch (e)
	            {}
	            
	            try {
	            	reformUseProc.onLoadHandler();
	            } catch (e) {}
	            
	            try {
// 		        	$('#div_Content #body').css('overflow', 'auto');
		        	$('#div_Content #doctitle').css('word-wrap', 'break-word');
		        } catch (e)
		        { }
		        
	            try {
			        if (document.getElementById('attitude_annual_conn')) { //근태관리 연동양식일 경우
						parent.document.getElementById('btnEdit').style.display = "none";
			        }
	            } catch (e)
	            { }
		        
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
	        // function SelectOnchange(obj) {
	        //     for (var i = 0; i < obj.options.length; i++) {
	        //         obj.options[i].setAttribute("check", "1");
	        //     }
	        //     obj.options[obj.selectedIndex].setAttribute("check", "2");
	        // }
	        // function CheckBoxOnclick(obj) {
	        //     obj.removeAttribute("checked");
	        //     if (obj.checked)
	        //         obj.setAttribute("check", "1");
	        //     else
	        //         obj.setAttribute("check", "0");
	        // }
	        function Conent_contentEditable(obj) {
	            try {
	                var TDRows = obj.getElementsByTagName("TD");
	                for (var i = 0; i < TDRows.length; i++) {
	                    if (TDRows.item(i).getAttribute("free") != null && TDRows.item(i).id != "doctitle" && TDRows.item(i).id != "body") {
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
	                        //Div_.style.textAlign = "left";
	                        if (navigator.userAgent.indexOf('Firefox') != -1)
	                            Div_.onkeypress = function (event) { var ret = onKeyDownEvent_Element(event, this); if (!ret) return false; };
	                        Div_.innerHTML = TDRows.item(i).innerHTML.replace(/(<div>|<\/div>)/gi, "");
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
	                        //Div_.style.textAlign = "left";
	                        Div_.onkeypress = function (event) { var ret = onKeyDownEvent(event, this, 127); if (!ret) return false; };
	                        Div_.innerHTML = TDRows.item(i).innerHTML;
	                        TDRows.item(i).innerHTML = "";
	                        TDRows.item(i).appendChild(Div_);
	                    }
	                }
	            } catch (e) { }
	            
	            validateAllTextArea(obj);
                var textAreaElements = obj.getElementsByTagName("textarea");
                for (i = 0; i < textAreaElements.length; i++) {
                	textAreaElements.item(i).oninput = onInputTextarea;
                }
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
 	                    parent.FieldsAvailable(this);
 	                    
 						validateAllTextArea(document.getElementById('div_Content'));
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
	                    
	                    var SelectRows = document.getElementById('div_Content').getElementsByTagName("SELECT");
	                    for (var i = 0; i < SelectRows.length; i++) {
	                        SelectRows.item(i).onchange = SelectOnchange;
	                    }
	                    var CheckRows = document.getElementById('div_Content').getElementsByTagName("INPUT");
	                    for (var i = 0; i < CheckRows.length; i++) {
	                        if (CheckRows.item(i).type == "checkbox") {
								CheckRows.item(i).onchange = CheckBoxOnclick;
								CheckRows.item(i).ondblclick = CheckBoxOnDblclick;
							} else if (CheckRows.item(i).type == "radio") {
								CheckRows.item(i).onchange = RadioOnClick;
							}
	                    }
	                    
	                    validateAllTextArea(document.getElementById('div_Content'));
	                    var textAreaElements = document.getElementById('div_Content').getElementsByTagName("textarea");
	                    for (i = 0; i < textAreaElements.length; i++) {
	                    	textAreaElements.item(i).oninput = onInputTextarea;
	                    }
	                    
	                    var Body_innerHTML = "";
	                    if (document.getElementById("body") != null) {
	                        if (document.getElementById("body").getAttribute("class") == "FIELD") {
	                            Body_innerHTML = document.getElementById("body").innerHTML;
	                            document.getElementById("body").innerHTML = "";
	                        }
	                    }
	                    Conent_contentEditable(document.getElementById('div_Content'));
	                    
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
	                        div_BODY.innerHTML = BODYTag.innerHTML;
	                        parent.modifiOrgBody = BODYTag.innerHTML;
	                    }
	                    if (document.getElementById("body") != null) {
	                    	<c:choose>
	                    		<c:when test="${isReform}">
	                    			validateAllTextArea(BODYTag);
	                    			bodyInnerHtml = BODYTag.innerHTML;
	                    			BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='viewbox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/ezApprovalG/reform/approveHtml.do?formId=" + parent.pFormID + "' frameborder='0'></ifrmae>";
	                    			
	                    			
	                    		</c:when>
	                    		<c:otherwise>
			                    	if (BODYTag.getAttribute("editor") == null) {
			                            isEditor = true;
			                            BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='viewbox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/ezEditor/selectApprovalEditor.do?height=" + EditorHeight + "' frameborder='0'></ifrmae>";
			                        }
			                        else {
			                            try {
			                                Conent_contentEditable(document.getElementById('body'));
			                            } catch (e) { }
			                        }
		                    	</c:otherwise>
	                    	</c:choose>
	                    }
	                }
	                else {
	                	<c:if test="${isReform}">
		                	iframe_content.editComplete();
	                	</c:if>
	                	
	                    DocTitleObj.innerHTML = ConvertCharToEntityReference(GetDocTitle());
	                    if (document.getElementById("body") != null) {
// 	                        var HtmlContent = isEditor ? iframe_content.GetEditorContent() : document.getElementById("body").innerHTML;
// 	                        BODYTag.innerHTML = HtmlContent;
// 	                        document.getElementById("body").innerHTML = BODYTag.innerHTML;
// 	                    }
// 	                    BodyTagsDisabled(document.getElementById('div_Content'));
// 	                    document.getElementById('div_Content').innerHTML = Get_HtmlBody(document.getElementById('div_Content').innerHTML);
	                    	 if (!isEditor) {
	                             var _checkbox = document.getElementsByTagName("input");
	                             for (var i = 0; i < _checkbox.length; i++) {
	                                 if (GetAttribute(_checkbox[i], "type") == "checkbox" && _checkbox[i].checked == true)
	                                     _checkbox[i].setAttribute("checked", "checked");
	                                 if (GetAttribute(_checkbox[i], "type") == "checkbox" && _checkbox[i].checked == false)
	                                     _checkbox[i].removeAttribute("checked");
	                             }
	                         }
	                    	 
	                    	 var HtmlContent = "";
	                    	 
							<c:choose>
								<c:when test="${isReform}">
									var documentCloneNode = iframe_content.document.cloneNode(true);
									var datepickerDivElement = documentCloneNode.getElementById("ui-datepicker-div");
									
									if (datepickerDivElement != null) {
										datepickerDivElement.parentNode.removeChild(datepickerDivElement);
									}
									
									HtmlContent = documentCloneNode.body.innerHTML;
								</c:when>
								<c:otherwise>
									HtmlContent = isEditor ? iframe_content.GetEditorContent() : document.getElementById("body").innerHTML;
								</c:otherwise>
							</c:choose>
	                    	 
	                         BODYTag.innerHTML = HtmlContent;
	                         document.getElementById("body").innerHTML = BODYTag.innerHTML;
	                     }
	                     BodyTagsDisabled(document.getElementById('div_Content'));
	                     document.getElementById('div_Content').innerHTML = Get_HtmlBody(document.getElementById('div_Content').innerHTML);
	                     
		                 validateAllTextArea(document.getElementById('div_Content'));
	                }
	            }
	            catch (e) {
	            }
	            
	            
	        }
	
           function GetDocTitle() {
               try {
               var docTitleElem;
                   if (document.getElementById("frame_doctitle") == null) {
                       docTitleElem = document.getElementById("doctitle");
                   }
                   else {
                       docTitleElem = document.getElementById("frame_doctitle");
               }

               var encDocTitle = encodeURIComponent(docTitleElem.textContent);
			   // 문서 발송시 오류때문에 제목에 줄바꿈문자 제거, 탭문자 공백문자처리
               encDocTitle = encDocTitle.replace(new RegExp('%0A|%0D', 'gi'), '').replace(new RegExp('%09', 'gi'), '%20');

               var decDocTitle = decodeURIComponent(encDocTitle);
               docTitleElem.innerText = decDocTitle;

               return decDocTitle;
               
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
	
	                var fieldElements = div_Content.querySelectorAll(".FIELD");
	                count = fieldElements.length;
	
	                for (i = 0; i < count; i++) {
	                        var tmp = fieldElements[i];
	
	                        if (!tmp.FieldID)
	                            tmp.FieldID = tmp.id;
	
	                        FieldsList[FieldCount] = tmp;
	                        FieldCount++;
	                }

					var controls = getControlList();
					FieldsList = FieldsList.concat(controls);

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
	            var selectRow, optionRow, checkAttrValue;
	            for (var i = 0; i < SelectRows.length; i++) {
	            	selectRow = SelectRows.item(i);
	                for (var j = 0; j < selectRow.options.length; j++) {
	                	optionRow = selectRow.options[j];
	                    if (optionRow.nodeType == "1") {
	                    	var checkAttrValue = optionRow.getAttribute("check");
	                        if (checkAttrValue == "2") {
	                            //SelectRows.item(i).options[j].outerHTML = SelectRows.item(i).options[j].outerHTML.replace("option ", "option selected ");
	                            optionRow.setAttribute("selected", "selected");
	                        } else if(checkAttrValue == "1") {
	                            //SelectRows.item(i).options[j].outerHTML = SelectRows.item(i).options[j].outerHTML.replace("selected=\".*\"", "");
	                            optionRow.removeAttribute("selected");
	                        }
	                        
	                        optionRow.removeAttribute("check");
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
	            
				var textAreaElements = HtmlObject.getElementsByTagName("textarea");
				var element;

				for (var i = 0; i < textAreaElements.length; i++) {
					element = textAreaElements[i];

					if (element.disabled) {
						element.disabled = false;
					}
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
	        
	        // FormBuilder textarea 제대로 나오도록 수정
	        function validateAllTextArea(targetElement) {
            	var textAreaElements = targetElement.getElementsByTagName("textarea");
            	
            	for (var i = 0; i < textAreaElements.length; i++) {
            		validateTextArea(textAreaElements[i]);
            	}
	        }
	        
	        function validateTextArea(element) {
	        	if (element.hasAttribute("value")) {
        			element.value = element.getAttribute("value");
        			element.innerHTML = element.value;
        		}
	        }
			// FormBuilder - end
	
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
	        function getMustFieldsInsert(lang) {
	        	try {
	        		var mustFields = $(".FIELD#doctitle, [must]");
	        		var returnval = new Array();
	        		var resStr = "";
	        		for (var i = 0; i < mustFields.length; i++) {
	        			var mustField = mustFields[i];
	        			var val = $(mustField).text().trim();
	        			if (val == "") {
							if ($(mustField).attr('id') == "doctitle"){
								returnval.push("<spring:message code='ezApprovalG.t1330'/>");
							} else {
								returnval.push($(mustField).attr('must'));
							}
						}
	        		}
	        		for (var i = 0; i < returnval.length; i++) {
	        			if ( i != 0 ) {
							if(lang == "3"){
								resStr += "、";
							} else {
								resStr += ",";
							}
	        			}
						resStr += returnval[i];
					}
	        		return resStr;
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

 			function process_AfterOpen(num) {
 			    try {
 			        arr_userinfo = parent.arr_userinfo;
 			        orgCompanyID = parent.orgCompanyID;
                    pAprLineType = parent.pAprLineType;
     			    frameNum = num;
 			        docHref = parent.pDocHrefAry[frameNum];
 			        docID = parent.pDocIDAry[frameNum];
 			        pDocID = parent.pDocIDAry[frameNum];
 			        pDocHref = parent.pDocHrefAry[frameNum];
                    pDraftFlag = parent.pDraftFlag;
                    pDocType = parent.pDocTypeAry[frameNum];
                    pSusinSN = parent.pSusinSN;
                    pDocState = parent.docState;
                    SignInfoFlag = parent.SignInfoFlag;
                    DeptSymbol = parent.DeptSymbol;
                    approvalFlag = parent.approvalFlag;
                    pModeForAllDocInfo = parent.pModeForAllDocInfo;
                    pModeForAllAttachInfo = parent.pModeForAllAttachInfo;

                    getApprovInfo(); // 양식id, 문서id, 문서제목, 첨부정보 등을 가져온다. 태그 XML 접근해서 거기에 값을 넣어줌
                    getDocInfo(); // 문서정보, 원문정보공개 등의 정보를 가져와서 파라미터에 부여한다.
                    setAttachInfoAll(parent.pDocIDAry[frameNum], pModeForAllAttachInfo, parent.document.getElementById("lstAttachLink")); // 각 안 별 첨부파일 플래그 세팅
 			    	// 최초 결재선 확인 및 서명칸 체크 동작은 한번만 수행하면 된다. (모든 안에서 결재선이 동일하므로)
 			    	// 버튼 제어 동작도 한번만 동작시킨다.
 			    	if (parent.docLoadCompleteCnt == 0) { // 최초 1안 로딩완료 이전에 한번만 동작해야 하므로
 			    		pDocID = parent.pDocIDAry[frameNum];
 						parent.getCurApproverAprLine(); // 결재선 갯수, 서명칸, 최종결재자 번호 등을 가져오는 부분 (모든 결재선이 동일하므로 사실상 1안의 pDocID를 전달)
 					    parent.pGubun = "8";
                        var pAprLineType = parent.pAprLineType;
 					    // 부모창의 버튼 및 구분값 제어
 					    if (pAprLineType == "002" || pAprLineType == "007" || pAprLineType == "008" || pAprLineType == "009" || pAprLineType == "011" || pAprLineType == "012") {
 					        setMenuBar("btntotaldocinfo", false);
 					        setMenuBar("btnJunKyul", false);
 					        setMenuBar("btnModAprLine", false);
 					        setMenuBar("btnEdit", false);
 					        setMenuBar("btnDocInfo", false);
 					        setMenuBar("btnFileAttach", false);
 					        setMenuBar("btnAprDocAttach", false);
 					      //  setMenuBar("btnModAprDept", false);
 					        setMenuBar("btnSetTaskCode", false);
 					        setMenuBar("btnAddSepAttach", false);
 					        parent.pGubun = "10";
 					    }
 					    else if (pAprLineType == "001" || pAprLineType == "004" || pAprLineType == "016") {
 					    	setMenuBar("btnModAprLine", false);
 					    	parent.pGubun = "5";
 					    }

 					    if (parent.KuyjeType == "001") {
 					    	parent.setBtnDisableAprLineType();
 					    }
 			    	}

 			    	// 이 분기부터는 각 안에 대하여 수신결재선을 체크하고 배열에 값을 부여하므로, 각 안에 대해 전부 돌게 한다.
                    // 일괄기안문서는 편집 불가능 + 수신문서 접수 시에는 단일 문서 접수이므로 일괄기안 결재창에서 pDraftFlag가 SUSIN이 되는 경우도 없음
 			        pSuSinFlag = "N";

 			        var RtnVal = FieldExist("recipient");
 			        if (RtnVal) {
 			            pSuSinFlag = "Y";
 			            parent.pSuSinFlagAry[frameNum] = "Y";
 			        } else {
 			            pSuSinFlag = "N";
 			            parent.pSuSinFlagAry[frameNum] = "N";
 			            if (parent.pGubun == "5") {
 			            	parent.pGubun = "7";
 			            }
 			            else {
 			            	parent.pGubun = "6";
 			            }
 			        }

 			        if (pDraftFlag == "HABYUI") {
 			        	setMenuBar("btntotaldocinfo", false);
 			        }
 				} catch (e) {
 					console.log(e);
 				    alert("apprGdraftuiAllContent_WHWP.jsp > process_AfterOpen()  ::  " + e);
 				}
 			}

            function GetFieldList(option1, option2){
                var list = GetFieldsList();
                list.forEach(function(item, i){list[i] = item.id});
                return list;
            }

            function FieldExist(name){
                var list = GetFieldsList();
                var result = false;
                list.forEach(function(item, i){
                    if(item.id == name){
                        result = true;
                        return;
                     }
                });
               return result;
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

            function PutFieldText(name, text){
                var elem;
                var isHtml = text.indexOf("\15") > -1;
                text = text.replaceAll("\15", "<br>").replaceAll("\11", "&nbsp;&nbsp;");
                if(name == "doctitle" && document.getElementById("frame_doctitle") != null){
                    name = "frame_doctitle";
                }else if(name == "body"){
                    Set_EditorBodyHTML(text);
                    return;
                }

                elem = document.getElementById(name);
                if(isHtml || text.indexOf("<br>") > -1)
                    elem.html = text;
                else
                    elem.textContent = text;
            }

	        // 각 안 별 의견정보 세팅을 위해 함수 분리 (opinions 필드 존재 시에만 동작)
	        function setInitOpinion(frameNum) {
	        	if (FieldExist("opinions")) {
	        		try {
	        			var result = "";
	        			var firstFlag = true;
	        			var strOpinion = " ";

	        			$.ajax({
	        				type : "POST",
	        				dataType : "text",
	        				async : false,
	        				url : "/ezApprovalG/opinionRequest.do",
	        				data : {
	        					docID : parent.pDocIDAry[frameNum],
	        					orgCompanyID : parent.orgCompanyID,
								state : pDocState
	        				},
	        				success: function(xml) {
	        					result = xml;
	        				}
	        			});

	        			var OpinionXML = loadXMLString(result);
	        			var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
	        			PutFieldText("opinions", "");

	        			if (NodeList.length > 0) {
	        				for (i = NodeList.length - 1; i >=  0; i--) {
	        					if (firstFlag) {
	        						strOpinion = "[" + strLang27;
	        						firstFlag = false;
	        					}

	        					if (getNodeText(GetChildNodes(NodeList[i])[2]) != "") { // 직위
	        					    strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[2]) + "\11";
	        					} else {
	        						strOpinion = strOpinion + "   \11";
	        					}

	        					strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[1]) + "\11"; // 이름
	        					strOpinion = strOpinion + getNodeText(GetChildNodes(GetChildNodes(NodeList[i])[0])[3]) + "\15"; // 의견내용
	        				}
	        				PutFieldText("opinions", strOpinion);
	        			}
	        		} catch (e) {
	        			alert("setInitOpinion :: " + e.description);
	        		}
	        	}
	        }

	        //  각 안에 맞는 배열 인덱스에 데이터를 삽입하기 위한 함수 분리 (원본 함수 ApprovUI_Cross.js에 존재함)
			function getApprovInfo() {
			    try {
			        pOrgAprUserID = OrgAprUserID;
			        pOrgAprUserName = OrgAprUserName;
			        pOrgAprUserName2 = OrgAprUserName2;
			        pOrgAprUserDeptID = OrgAprUserDeptID;
			        pUserID = pOrgAprUserID;
			        parent.pUserID = pUserID;

			        /* 2023-04-20 홍승비 - 각 안별 탭 생성 및 웹에디터 로딩 이전, 순차실행이 보장되도록 결재문서 데이터를 가져와 각 안이 사용할 수 있게 분리 */
			    	var result = loadXMLString(parent.pDocInfoAry[frameNum]);

			        var xmlpara = createXmlDom();
			        var pdocXML;

			        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/DOCINFO");
			        var xmlString = getXmlString(pdocXML);
			        xmlpara = loadXMLString(xmlString);
			        document.getElementById("DOCINFO").dataSource = xmlpara;

			        parent.pFormIDAry[frameNum] = getNodeText(SelectSingleNodeNew(xmlpara, "DOCINFO/DATA/FORMID"));
			        parent.pOrgDocIDAry[frameNum] = getNodeText(SelectSingleNodeNew(xmlpara, "DOCINFO/DATA/ORGDOCID"));

			        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/ATTACHINFO");
			        xmlString = getXmlString(pdocXML);
			        xmlpara = loadXMLString(xmlString);
			        document.getElementById("ATTACHINFO").dataSource = xmlpara;

			        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/APRLINEINFO");
			        xmlString = getXmlString(pdocXML);
			        xmlpara = loadXMLString(xmlString);
			        document.getElementById("APRLINEINFO").dataSource = xmlpara;

			        var dataNodes = GetElementsByTagName(xmlpara, "DATA6");
			        var lastIdx = dataNodes.length;

			        parent.drafterDeptid = getNodeText(dataNodes[lastIdx - 1]);
			        parent.aprDocTimeStamp = getNodeText(SelectSingleNodeNew(result, "APROVEDATA/APRDOCTIMESTAMP"));

			        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/DOCFLAGINFO");
			        xmlString = getXmlString(pdocXML);
			        xmlpara = loadXMLString(xmlString);

			        var node = GetElementsByTagName(xmlpara, "DocHref");
			        pDocHref = getNodeText(node[0]); // 이미 pDocHrefAry[]에는 값이 들어가있다. 이 페이지 내부에서 쓸 수있도록 지정해줌
			        var node = GetElementsByTagName(xmlpara, "DocFlag");
			        pDraftFlag = getNodeText(node[0]); // DRAFT로 고정

			        var doctitle = GetElementsByTagName(result, "DOCTITLE");
			        parent.pDocTitleAry[frameNum] = doctitle[0].textContent;

			        var docflagnode = GetElementsByTagName(xmlpara, "DocFlagValue");
			        switch (trim(pDraftFlag)) {
			            case "DRAFT":
			                pDocType = getNodeText(docflagnode[0]);
			                parent.pDocTypeAry[frameNum] = pDocType; // 각 양식별 타입 지정 (내부결재, 수신문, 시행문....)
			                break;

			            case "GONGRAM":
			            	approvalType = "GONRAM";
			                pOrgDocID = getNodeText(docflagnode[0]);
			                parent.pOrgDocIDAry[frameNum] = pOrgDocID;
			                GetChildNodes(document.getElementById("btnApprove"))[0].innerHTML = strLang10;
			                setMenuBar("btnJunKyul", false);
			                break;

			            case "CHAMJO":
			            	approvalType = "CHAMJO";
			                pOrgDocID = getNodeText(docflagnode[0]);
			                parent.pOrgDocIDAry[frameNum] = pOrgDocID;
			                GetChildNodes(document.getElementById("btnApprove"))[0].innerHTML = strLang10;
			                setMenuBar("btnJunKyul", false);
			                setMenuBar("btnReject", false);
			                setMenuBar("btnStay", false);
			                setMenuBar("btnOpinion", true); // 2019-04-02 천성준 - 참조자가 작성된 의견은 확인이 가능하기에 의견 버튼 표출
			                setMenuBar("btnFileAttach", false);
			                setMenuBar("btnAprDocAttach", false);
			                setMenuBar("btnEdit", false);
			                break;

			            case "HABYUI":
			            	approvalType = "HABYUI";
			                setMenuBar("btnEdit", false);
			                setMenuBar("btnModAprDept", false);
			                setMenuBar("btnFileAttach", false);
			                setMenuBar("btnAprDocAttach", false);
			                break;

			            case "SUSIN":
			            	approvalType = "SUSIN";
			                pOrgDocID = getNodeText(docflagnode[0]);
			                parent.pOrgDocIDAry[frameNum] = pOrgDocID;
			                break;

			            case "GAMSA":
			            	approvalType = "GAMSA";
			                setMenuBar("btnApprove", true);
			                setMenuBar("btnReject", false);
			                setMenuBar("btnStay", false);
			                setMenuBar("btnJunKyul", false);
			                setMenuBar("btnModAprLine", false);
			                setMenuBar("btnModAprDept", false);
			                setMenuBar("btnAprDocAttach", false);
			                setMenuBar("btnEdit", false);
			                setMenuBar("btnFileAttach", false);
			                break;

			            case "B_GAMSA":
			            	approvalType = "B_GAMSA";
			                setMenuBar("btnApprove", true);
			                setMenuBar("btnReject", true);  // 부서감사 유형 감사부서에서 반송 가능하도록 수정. 2020-02-28 홍대표
			                setMenuBar("btnStay", false);
			                setMenuBar("btnJunKyul", false);
			                setMenuBar("btnModAprLine", false);
			                setMenuBar("btnModAprDept", false);
			                setMenuBar("btnAprDocAttach", false);
			                setMenuBar("btnEdit", false);
			                setMenuBar("btnFileAttach", false);
			                break;
			        }
			    } catch (e) {
			    	console.log(e);
			        alert("getApprovInfo :: " + e.description);
			    }
			}

	        // 각 안에 맞는 배열 인덱스에 데이터를 삽입하기 위한 함수 분리
	        function getDocInfo() {
			    try {
			        xmldoc = document.getElementById("DOCINFO").dataSource; // 결재 시 해당 전역변수를 같이 사용할 수 있도록 지정
			        var APRSTATE = GetElementsByTagName(xmldoc, "FUNCTIONTYPE");
			        if (getNodeText(APRSTATE[0]) == "005") { // 보류된 문서인 경우, 보류버튼 숨김처리
			            setMenuBar("btnStay", false);
			        }

			        var opinionNode = GetElementsByTagName(xmldoc, "HASOPINIONYN");
			        var pHasOpinionYN = getNodeText(opinionNode[0]);
			        if (pHasOpinionYN == "Y" || pHasOpinionYN == "O") {
			        	parent.pHasOpinionYNAry[frameNum] = "Y";
			        } else {
			        	parent.pHasOpinionYNAry[frameNum] = "N";
			        }

			        var objNodes = xmldoc.documentElement.childNodes;
			        if (objNodes) {
			        	// 모든 안에서 공통인 문서정보이므로 최초 안 로딩 시 한번만 동작
			        	if (parent.docLoadCompleteCnt == 0) {
				        	parent.tempKeep = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/STORAGEPERIOD");
				        	parent.tempPublic = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ISPUBLIC");
				        	parent.tempUrgent = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/URGENTAPPROVAL");
				        	parent.tempKeyword = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/KEYWORD");
				        	parent.tempItemCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMCODE");
				        	parent.tempSecurity = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SECURITYCODE");
				        	parent.tempItemName = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMNAME");
				        	parent.tempItemName2 = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMNAME2");
				        	parent.tempSecurityDate = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SECURITYAPPROVAL");
				        	parent.pPublicityCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PUBLICITYCODE");
				        	parent.pPublicityYN = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PUBLICITYYN");
				        	parent.pLimitRange = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/LIMITRANGE");
				        	parent.pSummery = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SUMMARY");
				        	parent.pPageNum = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PAGENUM");
				        	parent.TaskCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/TASKCODE");
				        	parent.cabinetID = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/CABINETID");
				        	parent.pSpecialRecordCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SPECIALRECORDCODE");
			        	}

			        	// 각 안의 첨부파일 공개여부(fileOpenFlagListArr)도 함께 세팅
			            if (useOpenGov == "YES") {
			            	parent.basis = SelectSingleNodeValueNew(xmldoc, "DATA/BASIS");
			            	parent.reason = SelectSingleNodeValueNew(xmldoc, "DATA/REASON");
			            	parent.listOpenFlag = SelectSingleNodeValueNew(xmldoc, "DATA/LISTOPENFLAG");
			            	parent.fileOpenFlagList = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
			            	parent.fileOpenFlagListArr[frameNum] = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
			            	parent.limitDate = SelectSingleNodeValueNew(xmldoc, "DATA/LIMITDATE");
			            }
			        }
			    } catch (e) {
			    	console.log(e);
			        alert("getDocInfo :: " + e.description);
			    }
			}

			// 부모창에 접근해서 display 스타일을 변경함
			function setMenuBar(id, flag) {
			    var display_Value = flag ? "" : "none";

			    if (parent.document.getElementById(id) != null) {
			    	parent.document.getElementById(id).style.display = display_Value;
			    }
			}

			/**
             * 2023-04-20 홍승비 - 일괄기안 문서 전용 첨부파일 정보 추출 함수 분리 (자식 프레임 최초 로딩 시에만 동작, 화면단에 첨부파일 영역 그리는 로직 제거)
             * */
            function setAttachInfoAll(tempDocID, INGFlag, attachTag) {
                attachTag.innerHTML = "";

                var docAttachTag = ""; // 문서첨부영역 분리
                var parentHasAttachAry = new Array(); // 부모창의 일반첨부여부 배열
                var parentHasDocAttachAry = new Array(); // 부모창의 문서첨부여부 배열

                // 부모창에서 받은 첨부파일 정보를 그대로 맵핑하는 함수이므로, 일괄기안 자식 프레임에서만 호출함 (currIdx 대신 frameNum 사용)
            	attachTag = parent.document.getElementById(attachTag.id);
            	docAttachTag = parent.document.getElementById(attachTag.id + "Doc");
            	parentHasAttachAry = parent.pHasAttachYNAry;
            	parentHasDocAttachAry = parent.pHasDocAttachYNAry;

            	if (docAttachTag != undefined && docAttachTag != null) {
            		docAttachTag.innerHTML = "";
            	}

                var xmldom = createXmlDom();
                xmldom = loadXMLString(parent.pAttachInfoAry[frameNum]);

                var xmlRtn = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");

                if (xmlRtn.length > 0) {
                    for (i = 0; i < xmlRtn.length; i++) {
                    	// 해당 함수는 일괄기안의 각 자식 프레임 최초 로딩 시에만 동작하므로, 화면단에 첨부파일 정보를 그리는 작업은 제외한다.
                    	// 각 안 클릭(selTab) 시 화면단에 첨부파일 UI 그리는 작업은 기존 함수(setAttachInfo)가 담당함

                        // 일반 파일 첨부
                        if (SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == "File" || SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == strLang1136) {
                            // 일괄기안용 일반첨부 플래그 부여
                            parentHasAttachAry[frameNum] = "Y";
                        }
                        // 문서첨부
                        else {
                            // 일괄기안용 문서첨부 플래그 부여
                            parentHasDocAttachAry[frameNum] = "Y";
                        }
                    }
                    try {
                        pHasAttachYN = "Y";
                    } catch (e) { console.log(e); }
                }
                else {
                    try {
                        pHasAttachYN = "N";

                        // 일괄기안용 일반첨부, 문서첨부 플래그 부여
                    	parentHasAttachAry[frameNum] = "N";
                    	parentHasDocAttachAry[frameNum] = "N";
                    } catch (e) { console.log(e); }
                }
            }

            function GetTextFile(hwp, blank, callback){
                var mhtBody = "";
                mhtBody = Get_EditorBodyHTML();
                parent.EmbedContentIntoXML(mhtBody);
                mhtBody = ConvertHTMLtoMHT(mhtBody);
                ingFlag = false;
                callback(mhtBody);
            }

            function InsertPicture(psigncell, src, callback){
                var fields = GetFieldsList();
                var pseumyungdatecell = "seumyungdate" + psigncell.substring(4);
                var field = message.GetListItem(fields, pseumyungdatecell);
                var signWidth = 50;
                var signHeight = field ? 50 : 28;

                var ret = src.substring(src.indexOf("filePath=") + 9);
                var strimg = "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
                strimg = strimg + " width=" + signWidth + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";

                /* if (signImageType == "NAME") {
                    strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>" + "<br>" + arr_userinfo[2];
                } else {
                } */
                field = GetListItem(fields, psigncell);
                field.innerHTML = (trim(field.textContent) == "" ? "" : field.innerHTML) + strimg;
                callback();
            }
            function GetDocumentElementForDraftAll(){}
            function AprrovMappingSign(ret, maxIdx){
                docState = parent.docState;
                ext = parent.extAry[frameNum];
                getCurApproverAprLine("");
                ApprovMappingSign(ret);
            	//return signInfo;
                // 서명 부여가 완료된 안의 갯수를 체크하여, 최종 안까지 부여가 전부 끝났을때 부모창의 GetHTML를 호출한다.
                if (++parent.docApprovSignChkCnt == maxIdx) {
                    parent.GetHTML(parent.Before_SaveApproveInfo);
                }
            }

        function Resize(){}


        function SetFieldBackImage(psigncell, src){
            var fields = GetFieldsList();
            var field = message.GetListItem(fields, psigncell);
            var signWidth = 50;
            var signHeight = 50;

            var ret = src == "" ? "" : src.substring(src.indexOf("filePath=") + 9);
            var strimg = "<img src='" + encodeURI(ret) + "' border=0 embedding='1' ";
            strimg = strimg + " width=" + signWidth + " height=" + signHeight + " spath='" + encodeURI(ret) + "'>";

            field = GetListItem(fields, psigncell);
            field.innerHTML = (trim(field.textContent) == "" ? "" : field.innerHTML) + (src == "" ? "" : strimg);
        }

		</script>
	</head>
	<body>
        <xml id="ATTACHINFO"></xml>
        <xml id="DOCINFO"></xml>
        <xml id="APRLINEINFO"></xml>

	    <div id="div_Content"></div>
	    <div id="div_BODY" style="display: none"></div>
	    <div id="CONNINFO" name="CONNINFO" style="display: none"></div>
	</body>
</html>