<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html ondragover="bodydragover(event)">
	<head>
	    <title></title>
	    <script  type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberGAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/signSplit_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AutoAprLine_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draft_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezDraftAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ApprGContent.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
		
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
	    <script language="javascript" type="text/javascript">
	        document.onselectstart = function () {
	            var ret = false;
	            var obj = event.srcElement;
	            try {
					if (obj.nodeName == "TEXTAREA") {
						return true;
					}

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
	                    ret = true;
	                }
	            } catch (e) { }
	            return ret;
	        };
// 	        var XmlBodyATT = createXmlDom();
	        var pEditor = "<c:out value ='${editor}'/>";
	        var isConDoc = false;
	        var isEditor = false;
	        var isReform = parent.reformFlag === "Y";
            var frameNum = "${frameNum}"; // 프레임 번호
            var docID = "${docID}"; // 재기안시 문서 id
            var docHref = "${docHref}"; // 문서경로
            var formID = "${formID}"; // 양식 ID
	    	var pUserID = parent.pUserID;
	    	var nonElecRec = "N";
	    	var approvalFlag = "";
		    var junGyulFlag = "<c:out value ='${junGyulFlag}'/>";
		    var draftJunGyulFlag = "<c:out value ='${draftJunGyulFlag}'/>";
		    var isSplit = "<c:out value ='${isSplit}'/>";
            var pFormHref = "";
            var pDraftFlag = parent.pDraftFlag;
            var ListType = parent.ListType;
            var pDocState = parent.pDocState;
            var pSusinSN = parent.pSusinSN;
            var arr_userinfo = parent.arr_userinfo;
            var orgCompanyID = parent.orgCompanyID;
            var pDocType = "";
            var SignInfoFlag = "";
            var DeptSymbol = parent.DeptSymbol;
            var pModeForAllDocInfo = "";
            var pModeForAllAttachInfo = "";
            var xmluserInfo;
            var message = this;
            var isUsed = parent.isUsed;
	    	var useOpenGov = parent.useOpenGov;
	    	var isHWP = "N";

	        window.onload = function () {
	        	var officeFlag = "<c:out value='${officeFlag}'/>";
	        	console.log(officeFlag);
	        	$('#officeVal').val(officeFlag);
	            try {
	                parent.DocumentComplete(this);
	                document.execCommand("AutoUrlDetect", false, false);
	                document.querySelector("div").addEventListener("paste", function(e) {
						if (e.target.tagName === "TEXTAREA") {
							return;
						}

	                    e.preventDefault();
	                    var text = '';
	                    if (e.clipboardData) {
	                    	text = (e.originalEvent || e).clipboardData.getData('text/plain');

	                        document.execCommand('insertText', false, text);
	                    }
	                    else if (window.clipboardData) {
	                    	text = window.clipboardData.getData('Text');
							
	                    	var selection = window.getSelection();

							if (!selection.rangeCount) return false;
							
                            selection.getRangeAt(0).insertNode(document.createTextNode(text));
	                    }
	                });
	            }
	            catch (e)
	            { }
	            
	            try {
		        	$('#div_Content #doctitle').css('word-wrap', 'break-word');
		        	if($('#frame_doctitle')) {
		        		if($('#frame_doctitle').html() == "&nbsp;") {
		        			$('#frame_doctitle').html("");
		        		} else {
		        			$('#frame_doctitle').html(parent.doctitle);
		        		}
		        	}
		        } catch (e)
		        { }
		        
	            try {
			        if (document.getElementById('attitude_annual_conn')) { //근태관리 연동양식
			    		$("select[id^=control]").each(function() {
			    			$(this).val($(this).attr("attitudetype"));
			    			$(this).children("option[value=" +$(this).attr("attitudetype") + "]").attr("selected","");
			    		});
			        	
			    		$("input[type=button][id^=control]").each(function() {
			    			$(this).css("display","");
			    		});
			    		
			    		$("select[id^=control]").each(function() {
			    			$(this).css("top","17px");
			    		});
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
	        //     	if (i == obj.selectedIndex) {
	        //     		obj.options[i].setAttribute("selected", "selected");
	        //     	} else {
	        //     		obj.options[i].removeAttribute("selected");
	        //     	}
	        //     }
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
	                        //Div_.style.textAlign = "left";
	                        if (navigator.userAgent.indexOf('Firefox') != -1)
	                            Div_.onkeypress = function (event) { var ret = onKeyDownEvent_Element(event, this); if (!ret) return false; };
	                        Div_.innerHTML = TDRows.item(i).innerHTML.replace(/(<div>|<\/div>)/gi, ""); //2019-04-05 천성준 - 재기안 시, td속 div가 계속 쌓이는 문제때문에 문서 오픈 시, div제거 추가함
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
	                
                    var textAreaElements = obj.getElementsByTagName("textarea");
                    for (i = 0; i < textAreaElements.length; i++) {
                    	textAreaElements.item(i).oninput = onInputTextarea;
                    }
	            } catch (e) { }
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
	                        isConDoc = true;
	                        ConXmlDiv.getElementsByTagName("XML").item(0).style.display = "none";
	                        CONNINFO.innerHTML = ConXmlDiv.getElementsByTagName("XML").item(0).outerHTML;
	                        _DocContentHtml = ConXmlDiv.innerHTML;
	                    }
	                    document.getElementById('div_Content').innerHTML = _DocContentHtml; //.replace(/(<p)/igm, '<div').replace(/<\/p>/igm, '</div>');	                    
	                    
	                    _htmlcontent = document.getElementById('div_Content').innerHTML;
	                    var TDRows = document.getElementById('div_Content').getElementsByTagName("TD");
	                    
	                    for (var i = 0; i < TDRows.length; i++) {
	                    	var tempVal = TDRows.item(i).getAttribute("class");
	                    	
	                    	if (tempVal != null && tempVal.indexOf("FIELD") >= 0)
	                    		tempVal = tempVal.trim();
	                    	
	                        if (tempVal == "FIELD") {
	                            if (TDRows.item(i).childNodes.length == 0) {
	                                if (TDRows.item(i).innerHTML == "" || TDRows.item(i).innerHTML == " ") {
	                                    TDRows.item(i).innerHTML = "&nbsp;";
	                                }
	                            }
	                            
	                            TDRows.item(i).setAttribute("class", tempVal);
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

	                    //body는 있지만 에디터를 사용하지 않을때
	                    if (document.getElementById("body") != null) {
	                        if (document.getElementById("body").getAttribute("editor") == "no") {
	                        	parent.isEditorComplete = true;
	                        }
	                    }
	                    
	                    // 2018.10.15 필드도 free 속성일 시에 수정 가능하도록 수정
	                    var tmpAddFlag = typeof parent.addFlag != "undefined" ? parent.addFlag : false;
	                    parent.FieldsAvailable(this);
	
	                    if (parent.pDraftFlag != "REDRAFT" || parent.pFormID !== "") {
		                    $.ajax({
			                	type: "GET",
			                	dataType: "text",
			                	url: "/ezApprovalG/getReformFlag.do",
			                	data: { formHref: url },
			                	async: false,
			                	success: function (result) {
			                		isReform = result === "Y";
			                	}
			                });
	                    }
	                    
	                    if (parent.pDraftFlag != "REDRAFT" || tmpAddFlag) {
	                    	BodyTagsEnabled(document.getElementById('div_Content'));
  							var Body_innerHTML = "";
	                        if (document.getElementById("body") != null) {
	                            if (document.getElementById("body").getAttribute("class") == "FIELD") {
	                                Body_innerHTML = document.getElementById("body").innerHTML;
	                                document.getElementById("body").innerHTML = "";
	                            }
	                        }
	                        // if (parent.isUsed != "reuse"){
		                        Conent_contentEditable(document.getElementById('div_Content'));
	                        // }
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
		                    var textAreaElements = document.getElementById('div_Content').getElementsByTagName("textarea");
		                    for (i = 0; i < textAreaElements.length; i++) {
		                    	textAreaElements.item(i).oninput = onInputTextarea;
		                    }
	                        if (document.getElementById("body") != null) {
	                        	// class가 FIELD를 포함한 두 개 이상일 때도 조건문에 포함되어야 함 2019-05-14 임민석
	                        	if (document.getElementById("body").getAttribute("class").indexOf("FIELD") != -1) {
	                                document.getElementById("body").innerHTML = Body_innerHTML;
	                                BODYTag = document.getElementById("body");
	                            }
	                        }
	                        
	                        if (document.getElementById("doctitle").getAttribute("class") == "FIELD")
	                            DocTitleObj = document.getElementById("doctitle");
	
	                        var EditorHeight = 500;
	                        // if (parent.isUsed != "reuse"){
		                        if (document.getElementById("body") != null) {
		                            if (BODYTag.getAttribute("tagfreeheight")) {
		                                EditorHeight = BODYTag.getAttribute("tagfreeheight");
		                            }
		                            div_BODY.innerHTML = BODYTag.innerHTML;
		                        }
		                        if (document.getElementById("body") != null) {
		                        	if (isReform) {
		                        		try {
		                        			Conent_contentEditable(document.getElementById('body'));
		                        			BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='viewbox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/ezApprovalG/reform/draftHtml.do?formID=" + parent.pFormID + "' frameborder='0'></iframe>";
		                                } catch (e) { }
		                        	}
		                        	else if (BODYTag.getAttribute("editor") == null) {
		                                isEditor = true;
		                                BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='viewbox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/ezEditor/selectApprovalEditor.do?type=APPROVALG&height=" + EditorHeight + "&isUsed=${isUsed}' frameborder='0'></ifrmae>";
		                            }
		                            else {
		                                try {
		                                	isEditor = false;
		                                    Conent_contentEditable(document.getElementById('body'));
		                                } catch (e) { }
		                            }
		                        }
	                        // }
	                    }
	
	
	                    /* for (var i = 0; i < GetElementsByTagName(XmlBodyATT, "NODE").length; i++) {
	                        SetAttribute(document.getElementById("body"), getNodeText(GetElementsByTagName(XmlBodyATT, "NODENAME")[i]), getNodeText(GetElementsByTagName(XmlBodyATT, "NODEVALUE")[i]));
	                    } */
	                }
	            }
	            catch (e)
	            {alert(e.message); }
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
	                    	if (isReform) {
	                    		Conent_contentEditable(document.getElementById('body'));
	                    		BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='viewbox' style='width:100%;margin:0px;padding:0px; height:" + EditorHeight + "px;' scrolling='no' src='/ezApprovalG/reform/draftHtml.do?formID=" + parent.pFormID + "' frameborder='0'></iframe>";
	                    	}
	                    	else if (BODYTag.getAttribute("editor") == null) {
	                            isEditor = true;
	                            BODYTag.innerHTML = "<iframe id='iframe_content' name='iframe_content' class='viewbox' style='width:100%;margin:0px;padding:0px;" +
	                                                "height:" + EditorHeight + "px;' scrolling='no' src='/ezEditor/selectApprovalEditor.do?height=" + EditorHeight + "' frameborder='0'></ifrmae>";
	                        }
	                        else {
	                            try {
	                            	isEditor = false;
	                                Conent_contentEditable(document.getElementById('body'));
	                            } catch (e) { }
	                        }
	                    }
	                }
	                else {
	                    if (document.getElementById("iframe_content") != null) {
	                        var HtmlContent = iframe_content.GetEditorContent();
	                        BODYTag.innerHTML = "<div>&nbsp;</div><br>" + HtmlContent;
	                        document.getElementById('div_Content').style.display = "";
	                    }
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
	        
	        function getMustFieldsInsert(lang) {
	        	try {
	        		var mustFields = $(".FIELD#doctitle, [must]");
	        		var returnval = new Array();
	        		var resStr = "";
	        		for (var i = 0; i < mustFields.length; i++) {
	        			var mustField = mustFields[i];
	        			var val = $(mustField).text().replace(/[\u200B-\u200D\uFEFF]/g, '').trim();
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

					if (isReform) {
						var controls = iframe_content.getControlList();
						FieldsList = FieldsList.concat(controls);
					}

	                return FieldsList;
	            } catch (e) {
	                return FieldsList;
	            }
	        }
	
	        function GetTagList(strTagName) {
	            try {
	            	//CONNINFO 오류발생지점
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
				
				var inputElements = Div.querySelectorAll("input, select, textarea");
				var element;

				for (var i = 0; i < inputElements.length; i++) {
					element = inputElements[i];

					if (!element.disabled) {
						element.disabled = true;
					}
				}
				// var i, len, len2;
	            // var InputRows = Div.getElementsByTagName("INPUT");
	            // for (i = 0, len = InputRows.length; i < len; i++) {
				// 	var input = InputRows.item(i);

	            //     if (input.getAttribute("check") == "1")
				// 		input.removeAttribute("check");
				// 		input.setAttribute("checked", "checked");
				// }
				
	            // var SelectRows = Div.getElementsByTagName("SELECT");
	            // for (i = 0, len = SelectRows.length; i < len; i++) {
				// 	var select = SelectRows.item(i);

	            //     for (j = 0, len2 = select.options.length; j < len2; j++) {
	            //         if (SelectRows.item(i).childNodes.item(j).nodeType == "1") {
	            //             /* if (SelectRows.item(i).childNodes.item(j).getAttribute("check") == "2")
	            //                 SelectRows.item(i).childNodes.item(j).outerHTML = SelectRows.item(i).childNodes.item(j).outerHTML.replace("option ", "option selected ");
	            //             else {
	            //                 SelectRows.item(i).childNodes.item(j).outerHTML = SelectRows.item(i).childNodes.item(j).outerHTML.replace("selected=\"\"", "");
	            //             } */
	            //             //2019-04-08 - 일괄결재로 완료된문서 재사용>임시저장 시, select박스의 option selected속성이 해제되는 현상 수정 #15360
	            //             if (SelectRows.item(i).childNodes.item(j).outerHTML.indexOf("option selected") > -1) {
	            //             	SelectRows.item(i).childNodes.item(j).removeAttribute("selected");
	            //             	SelectRows.item(i).childNodes.item(j).setAttribute("selected", "selected");
	            //             } else {
	            //             	SelectRows.item(i).childNodes.item(j).removeAttribute("selected");
	            //             }
	            //         }
	            //     }
	            // }
	
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
	
	                // var pDiv_Content = document.getElementById('div_Content');
	                // for (var i = 0; i < pDiv_Content.getElementsByTagName("input").length; i++) {
	                //     if (pDiv_Content.getElementsByTagName("input")[i].checked)
	                //         pDiv_Content.getElementsByTagName("input")[i].setAttribute("checked", "true");
	                // }
	
	                var BODY = document.createElement("BODY");
	                Doc_ContentHtml = document.createElement("DIV");
	                Doc_ContentHtml.innerHTML = Get_HtmlBody(document.getElementById('div_Content').innerHTML);
	                BODY.appendChild(Doc_ContentHtml);
	                HTML.appendChild(BODY);
	
	                var EditorContent = "";
	                
	                if (isReform) {
	                	EditorContent = GetBodyHTML();
	                } else {
	                	EditorContent = isEditor ? iframe_content.GetEditorContent() : document.getElementById("body") == null
                                ? "" : document.getElementById("body").innerHTML;
	                }
	                
	                div_BODY.innerHTML = EditorContent;
	                if(!isEditor)
	                    EditorContent = Get_HtmlBody(EditorContent);
	
	                //결재문서붙여넣기 오류 보완코드 2013.01.08
	                var Div_ = document.createElement("DIV");
	                Div_.innerHTML = EditorContent;
	                var DivCnt = Div_.getElementsByTagName("*").length;
	                for (var i = 0 ; i < DivCnt; i++) {
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
	                for (var i = 0 ; i < ElementCnt; i++) {
	                    if (Doc_ContentHtml.getElementsByTagName("*").item(i).id == "body") {
	                        bodyObj = Doc_ContentHtml.getElementsByTagName("*").item(i);
	                    }
	                    else if (Doc_ContentHtml.getElementsByTagName("*").item(i).id == "doctitle") {
	                        titleObj = Doc_ContentHtml.getElementsByTagName("*").item(i);
	                    }
	                    if (bodyObj != null && titleObj != null)
	                        break;
	                }
	                if (bodyObj != null && titleObj != null) {
	                    bodyObj.innerHTML = EditorContent;
	                    //if (bodyObj.childNodes.length >= 1) {
	                    //    if (bodyObj.children[0].id != "bodyblock") {
	                    //        bodyObj.innerHTML = "<div id='bodyblock' style='margin-top:5px;TEXT-ALIGN:left;'>" + bodyObj.innerHTML + "</div>";
	                    //    }
	                        bodyObj.style.textAlign = "left";
	                    //}
	                    if (DocTitleObj.getAttribute("free") != null) {
	                        titleObj.innerHTML = ConvertCharToEntityReference(GetDocTitle());
	                        //titleObj.style.textAlign = "left";
	                    }
	                }
	                return HTML.outerHTML;
	            } catch (e)
	            { return ""; }
	        }
	
	        function GetBodyHTML() {
	            try {
	            	if (isReform) {
	            		var documentCloneNode = iframe_content.document.cloneNode(true);
	            		var datepickerDivElement = documentCloneNode.getElementById("ui-datepicker-div");
	            		
	            		if (datepickerDivElement != null) {
	            			datepickerDivElement.parentNode.removeChild(datepickerDivElement);
	            		}
	            		
	            		// reform inner editor
	            		var reformEditor = iframe_content.iframe_content_reform;
	            		
	            		if (reformEditor) {
		            		// set editor content to innerHTML
		            		documentCloneNode.getElementById("reform-editor").innerHTML = reformEditor.GetEditorContent();	
	            		}
	            		
	            		return documentCloneNode.body.innerHTML;
	            	}
	            	
	                return iframe_content.GetEditorContent();
	            } catch (e) {
	                return null;
	            }        
	        }
	
	        function GetBodyText() {
	            try {
	                return iframe_content.GetBodyText();
	            } catch (e) {
	                return "";
	            }
	        }
	
	        function GetEditorSelectedText() {
	            try {
	                return iframe_content.GetEditorSelectedText();
	            } catch (e) {
	                return "";
	            }
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

	            	if (!isReform) {
						iframe_content.SetEditorContent(div_BODY.innerHTML);
	            		// iframe_content.SetEditorContent();
	            	} else if (parent.pDraftFlag == "REDRAFT" || parent.isUsed == "reuse") {
						iframe_content.document.body.innerHTML = div_BODY.innerHTML;
					}
	                
	                parent.isEditorComplete = true;

					if (isConDoc) {
						parent.connInit();
					}
	            } catch (e) {
	            }
	        }
	
	        function Conn_Before() {
	            try {
	                div_BODY.innerHTML = iframe_content.GetEditorContent();
	            } catch (e) {
	            }
	        }
	        function Conn_after() {
	            try {
	                iframe_content.SetEditorContent(div_BODY.innerHTML);
	            } catch (e) {
	            }
	        }
	
	        function Conn_BodyFieldWrite(FieldName, FieldValue) {
	            document.getElementById(FieldName).textContent = FieldValue;
	        }
	        
	        var _reUseContent = "";
	        function Editor_ReUseContent(content) {
	            _reUseContent = content;
	            try{
					div_BODY.innerHTML = _reUseContent.editorContent;
					var elem = document.getElementById('frame_doctitle');
					while(true) {
						if(elem.childNodes.length > 0 && elem.childNodes.item(0).nodeName == '#text') {
							elem.childNodes.item(0).textContent = _reUseContent.titleContent;
							break;
						}

						elem = elem.childNodes.item(0);
					}
	            }
	            catch (e) { }
	        }

	        function bodydragover(evt) {
		        evt.dataTransfer.dropEffect = "none";
		        evt.stopPropagation();
		        evt.preventDefault();
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
                var isHtml = text.indexOf("\15") > -1 || text.indexOf("\r") > -1;
                text = text.replaceAll("\15", "<br>").replaceAll("\r", "<br>").replaceAll("\11", "&nbsp;&nbsp;");
                if(name == "doctitle" && document.getElementById("frame_doctitle") != null){
                    name = "frame_doctitle";
                }else if(name == "body"){
                    Set_EditorBodyHTML(text);
                    return;
                }

                elem = document.getElementById(name);
                if(isHtml || text.indexOf("<br>") > -1)
                    elem.innerHTML = text;
                else
                    elem.textContent = text;
            }

            function SetDocumentElementForDraftAll(pCharName, pValue) {}

            function setMenuBar(id, flag) {
                var display_Value = flag ? "" : "none";

                if (parent.document.getElementById(id) != null) {
                    parent.document.getElementById(id).style.display = display_Value;
                }
            }

            function process_AfterOpen(frameNum) {
                try {
                    if (frameNum == "1") {
                        parent.winOnload();
                    }

                    pFormHref = parent.pFormHrefAry[frameNum];
                    pDraftFlag = parent.pDraftFlag;
                    pDocType = parent.pDocTypeAry[frameNum];

                    pSusinSN = parent.pSusinSN;
                    pDocState = parent.pDocState;
                    SignInfoFlag = parent.SignInfoFlag;
                    DeptSymbol = parent.DeptSymbol;
                    approvalFlag = parent.approvalFlag;

                    pModeForAllDocInfo = parent.pModeForAllDocInfo;
                    pModeForAllAttachInfo = parent.pModeForAllAttachInfo;
                    xmluserInfo = parent.xmluserInfo;

                    parent.ShowMailProgress(); // 문서 로딩중 이미지 표출

                    // 임시저장된 문서의 결재정보는 새로운 docId를 생성 후에 가져오는 방식으로 수정
                    if (frameNum == "1" && parent.ListType == "21") {
                        parent.getLineModeAll(parent.pDocIDAry[1]); // 결재진행중/완료여부 체크
                        parent.getDocInfoAll(parent.pDocIDAry); // 결재문서 기본 정보
                        parent.getAttachInfoAll(parent.pDocIDAry); // 첨부파일 정보
                    }
                    var ifCond = (pDraftFlag == "REDRAFT" && parent.addFlag == false);
                    if (pDraftFlag == "REDRAFT" && parent.addFlag == false) { // 재기안이면서 최초 1안 추가가 시작되지 않은 경우 (기존 문서들을 로딩중인 경우)
                        var len;
                        var pInformationContent;
                        var Ans;

                        if (docID == "") {
                            len = docHref.lastIndexOf("/");
                            pDocID = docHref.substr(len + 1, 20);
                        } else {
                            pDocID = docID;
                        }

                        GetAprDocFormID();
                        parent.pFormIDAry[frameNum] = pFormID;

                        /* 2023-04-21 홍승비 - 일괄기안 문서 재기안 시, 기존 첨부파일 정보를 각 안마다 가져오는 부분을 부모 페이지로 이동하여 한번에 가져옴 */
                        setAttachInfoAll(pDocID, pModeForAllAttachInfo, parent.document.getElementById("lstAttachLink")); // 각 안 별 첨부파일 플래그 세팅
                        getDocInfo(frameNum); // 현재 페이지에 새롭게 선언한 함수로 변경
                    }
                    // 1안 이후에 추가된 경우, 기존 원문공개와 결재선 정보를 가져온다.
                    else {
                        pDraftFlag = "DRAFT";

                        if (pFormHref != "PC") {
                            var len;
                            len = pFormHref.lastIndexOf("/");
                            pFormID = pFormHref.substring(len + 1, pFormHref.lastIndexOf("."));

                            parent.pFormIDAry[frameNum] = pFormID;
                        }

                        if (parent.pDocIDAry[frameNum] == null) {
                            if (parent.pReadPC) {
                                ClearDocCellInfo();
                            }

                            setClearSusinCellInfo();

                            pDocID = parent.createNewDoc();
                        }

                        parent.pDocIDAry[frameNum] = pDocID;

                        if (parent.listOpenFlag != undefined && parent.listOpenFlag != "") {
                            $.ajax({
                                type : "POST",
                                dataType : "text",
                                async : false,
                                url : "/ezApprovalG/openGovInfoSave.do",
                                data : {
                                        openGovListFlag : parent.listOpenFlag,
                                        fileOpenFlagList : parent.fileOpenFlagListArr[1],
                                        basis : parent.basis,
                                        reason : parent.reason,
                                        publicity : parent.pPublicityCode,
                                        docID : pDocID,
                                        limitDate : parent.limitDate
                                }
                            });

                            $.ajax({
                                type : "POST",
                                dataType : "text",
                                async : false,
                                url : "/ezApprovalG/copyOpenGovAttachInfo.do",
                                data : {
                                        docID : pDocID,
                                        parentDocID : parent.pDocIDAry[1]
                                }
                            });
                        }
                    }
                } catch (e) {
                    console.log(e);
                    alert("apprGdraftuiAllContent_WHWP.jsp > process_AfterOpen()  ::  " + e.description);
                }
            }

            function CopyAndPasteContent(isTrue) {
                try {
                    var ifrm1 = parent.document.getElementById("ifrm1");

                    if (isTrue) {
                        if (parent.contentOptionFlag == true) {
                            if(ifrm1.src.indexOf("draftContentAll_WHWP") < 0){
                                var html = ifrm1.contentWindow.GetBodyHTML();
                                if(html){
                                    if(GetBodyHTML())
                                        Set_EditorBodyHTML(html);
                                    else
                                        body.innerHTML = html;
                                }else{
                                    html = ifrm1.contentWindow.Get_EditorBodyHTML();
                                    var parser = new DOMParser();
                                    var doc = parser.parseFromString(html, 'text/html');
                                    html = doc.getElementById("body").innerHTML;
                                    if(GetBodyHTML())
                                        Set_EditorBodyHTML(html);
                                    else
                                        body.innerHTML = html;
                                }
                            }else{
                               ifrm1.contentWindow.GetCloneData("body", "HTML", function(data){
                                    if(GetBodyHTML())
                                        Set_EditorBodyHTML(data);
                                    else
                                        body.innerHTML = data;
                                });
                            }
                        }
                    } else {
                        var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
                        OpenAlertUI(pAlertContent);
                        Clear();
                    }
                } catch (e) {
                    alert("CopyAndPasteContent ::" + e);
                }
            }

            function copyDoc() {
                var ifrm1 = parent.document.getElementById("ifrm1");

                copyAprLine(); // 결재선정보 복사

                 if (parent.titleOptionFlag == true) { // 제목
                    var mainDocTitle = ifrm1.contentWindow.GetFieldText("doctitle");
                    PutFieldText("doctitle", mainDocTitle);
                }

                /* if (parent.seperateAttachOptionFlag == true) { // 분리첨부
                    // 단, 해당 분리첨부 내용이 공백이 아닌 경우에만 복사함
                    var ifrm1SepXML = ifrm1.contentWindow.GetDocumentElementForDraftAll("sepattachlvxml", true);
                    if (ifrm1SepXML != "") {
                        SetDocumentElementForDraftAll("sepattachlvxml", ifrm1.contentWindow.GetDocumentElementForDraftAll("sepattachlvxml", true));
                    }
                } */

                // 1안에 대해 일반첨부, 문서첨부가 없는 경우 플래그 조정 (첨부파일 복사 필요없음)
                if (parent.pHasAttachYNAry[1] != "Y") {
                    parent.attachOptionFlag = false;
                    parent.pHasAttachYN = "N";
                    parent.pHasAttachYNAry[frameNum] = "N";
                }
                if (parent.pHasDocAttachYNAry[1] != "Y") {
                    parent.docAttachOptionFlag = false;
                    parent.pHasDocAttachYN = "N";
                    parent.pHasDocAttachYNAry[frameNum] = "N";
                }

                // 1안의 의견은 복사하지 않는다.
/* 	    		if (parent.pHasOpinionYNAry[0] != "Y") { // 의견이없는 경우 플래그 조정
                    parent.opinionOptionFlag = false;
                } */
                // 의견 복사하지 않으므로 N으로 고정
                parent.pHasOpinionYN = "N";
                parent.pHasOpinionYNAry[frameNum] = "N";

                // 일반첨부, 문서첨부 데이터 복사
                if (parent.attachOptionFlag == true || parent.docAttachOptionFlag == true) {
                    $.ajax({
                        type : "POST",
                        dataType : "text",
                        async : false,
                        data : {
                            attachFlag : parent.attachOptionFlag,
                            docAttachFlag : parent.docAttachOptionFlag,
                            seperateAttachFlag : parent.seperateAttachOptionFlag,
                            //opinionFlag : parent.opinionOptionFlag,
                            mainDocID  : parent.pDocIDAry[1],
                            currentDocID : pDocID
                        },
                        url : "/ezApprovalG/copyDocAttachHwp.do",
                        success: function(result) {
                            // 첨부파일 복사 후, 부모창과 해당 안의 플래그 변경
                            if (parent.attachOptionFlag == true) {
                                parent.pHasAttachYN = "Y";
                                parent.pHasAttachYNAry[frameNum] = "Y"
                            }
                            if (parent.docAttachOptionFlag == true) {
                                parent.pHasDocAttachYN = "Y";
                                parent.pHasDocAttachYNAry[frameNum] = "Y";
                            }
                        }
                    });

                    // 하단 첨부파일 영역에 정보 셋팅 (일단 숨김처리한 상태)
                    if (parent.attachOptionFlag == true || parent.docAttachOptionFlag == true) {
                        setAttachInfo(pDocID, "APR", parent.lstAttachLink);
                    }
                }
            }

	        // 1안의 결재선 복사 (컨트롤러단에서 전부 처리함. 리턴값 없음)
	        function copyAprLine() {
	    		$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		data : {
		    			mainDocID  : parent.pDocIDAry[1], // 1안의 문서ID를 메인으로 사용
		    			currentDocID : pDocID
		    		},
		    		url : "/ezApprovalG/copyAprLine.do",
		    		success: function(result) {}
		    	});
	    	}

	    	function GetDocumentElementForDraftAll(){}
	    	function Resize(){}

            // 재기안 > 결재올림 시, 각 안의 문서번호 재설정 함수를 호출하는 함수
            function UpdateDocNum() {
                if (!FieldExist("docnumber")) {
                    console.log("hwpContent hasn't a docnumber field");
                    return false;
                }

                // ajax로 현재 문서의 docnumber 형식을 리턴
                var numberFormat = "";
                numberFormat = getDocNumFormatByFormID(parent.pFormIDAry[frameNum], parent.orgCompanyID);

                PutFieldText("docnumber", getDocNumByFormat(numberFormat));
            }

            function AppendFieldText(field, text) {
                var iText = GetFieldText(field) + text;
                PutFieldText(field, iText);
            }

            function PrependFieldText(field, text) {
                var iText = text + GetFieldText(field);
                PutFieldText(field, iText);
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

            function GetTextFile(hwp, blank, callback){
                var mhtBody = "";
                mhtBody = Get_EditorBodyHTML();
                EmbedContentIntoXML(mhtBody);
                mhtBody = ConvertHTMLtoMHT(mhtBody);
                ingFlag = false;
                callback(mhtBody);
            }

            // 각 안에 맞는 배열 인덱스에 데이터를 삽입하기 위한 함수 분리
            function getDocInfo(currIdx) {
                var xmldoc = loadXMLString(parent.pDocInfoAry[currIdx]);
                var objNodes = xmldoc.documentElement.childNodes;

                if (objNodes) {
                    if (SelectSingleNodeValueNew(xmldoc, "DATA/HASOPINIONYN") == "Y" || SelectSingleNodeValueNew(xmldoc, "DATA/HASOPINIONYN") == "O") {
                        parent.pHasOpinionYNAry[currIdx] = "Y";
                    } else {
                        parent.pHasOpinionYNAry[currIdx] = "N";
                    }

                    parent.tempSecurity = SelectSingleNodeValueNew(xmldoc, "DATA/SECURITYCODE");
                    parent.tempKeep = SelectSingleNodeValueNew(xmldoc, "DATA/STORAGEPERIOD");
                    parent.tempUrgent= SelectSingleNodeValueNew(xmldoc, "DATA/URGENTAPPROVAL");
                    parent.tempPublic = SelectSingleNodeValueNew(xmldoc, "DATA/ISPUBLIC");
                    parent.tempKeyword = SelectSingleNodeValueNew(xmldoc, "DATA/KEYWORD");
                    parent.tempItemCode = SelectSingleNodeValueNew(xmldoc, "DATA/ITEMCODE");
                    parent.tempItemName = SelectSingleNodeValueNew(xmldoc, "DATA/ITEMNAME");
                    parent.pSummery = SelectSingleNodeValueNew(xmldoc, "DATA/SUMMARY");
                    parent.pSpecialRecordCode = SelectSingleNodeValueNew(xmldoc, "DATA/SPECIALRECORDCODE");
                    parent.pPublicityCode = SelectSingleNodeValueNew(xmldoc, "DATA/PUBLICITYCODE");
                    parent.pPublicityYN = SelectSingleNodeValueNew(xmldoc, "DATA/PUBLICITYYN");
                    parent.pLimitRange = SelectSingleNodeValueNew(xmldoc, "DATA/LIMITRANGE");
                    parent.pPageNum = SelectSingleNodeValueNew(xmldoc, "DATA/PAGENUM");
                    parent.cabinetID = SelectSingleNodeValueNew(xmldoc, "DATA/CABINETID");
                    parent.TaskCode = SelectSingleNodeValueNew(xmldoc, "DATA/TASKCODE");
                    parent.tempSecurityDate = SelectSingleNodeValueNew(xmldoc, "DATA/SECURITYAPPROVAL");

                    if (useOpenGov == "YES") {
                        parent.basis = SelectSingleNodeValueNew(xmldoc, "DATA/BASIS");
                        parent.reason = SelectSingleNodeValueNew(xmldoc, "DATA/REASON");
                        parent.listOpenFlag = SelectSingleNodeValueNew(xmldoc, "DATA/LISTOPENFLAG");
                        parent.fileOpenFlagList = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
                        parent.fileOpenFlagListArr[currIdx] = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
                        parent.limitDate = SelectSingleNodeValueNew(xmldoc, "DATA/LIMITDATE");
                    }
                }
            }

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
	    <div id="div_Content"></div>
	    <div id="div_BODY" style="display: none"></div>
	    <div id="CONNINFO" name="CONNINFO" style="display: none"></div>
	</body>
</html>
