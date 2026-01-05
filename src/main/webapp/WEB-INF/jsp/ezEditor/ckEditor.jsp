<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/ckEditor/ckeditor.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var type = '<c:out value="${type}"/>';
			var height = '<c:out value="${height}"/>';
			var editorLoadFlag = false;
			
		    CKEDITOR.on( 'instanceReady', function( ev ) {
		    	editorLoadFlag = true;
			    ExecuteCommand("maximize");
			    parent.Editor_Complete();
			    
			    if (type == "MAILOUTOFOFFICE") {
			    	// prevent image drop
					ev.editor.document.on('drop', function (ev) {
					   ev.data.preventDefault(true);
					});
			    }
			    
			    if (type == "COMMUNITYPHOTO") {
			    	// prevent image drop
					ev.editor.document.on('drop', function (ev) {
					   ev.data.preventDefault(true);
					});
			    }
		    });
		    
		    // Setdata 후 실행 함수.
		    CKEDITOR.on( 'afterSetData', function( ev ) {
		    });
    
		    
			// 에디터 커맨드 실행
			function ExecuteCommand(commandName) {
				var oEditor = CKEDITOR.instances.editor1;

				if (oEditor.mode == 'wysiwyg') {
					oEditor.execCommand(commandName);
				}
			}
			
			function SetEditorContent(Data) {
				try {
					if (Data === "") {
						Data = "<p " + defaultFontAndSize + "><br></p><p " + defaultFontAndSize + "></p>";
					}
					
					/* <o:p> 태그가 있는 문장에 대해 글꼴 변경시 문장 역전 되는 현상 수정 */
					var regStr = /(<|<\/)o:p(.*?)>/gi;
					Data = Data.replace(regStr, "");
					
					if (CKEDITOR.instances.editor1.mode === "source") {
						CKEDITOR.instances.editor1.setData(Data);
					} else {
						CKEDITOR.instances.editor1.editable().setHtml(Data);
					}
					
	                if (type == "APPROVAL" || type == "APPROVALG") {
	                	if ('<c:out value="${isUsed}"/>' != "reuse") {
	                    	Set_CellLocked();
	                	}
	                }
	            } catch (e) { }
			}

			function GetEditorContent() {
				try {
					if (type == "APPROVAL" || type == "APPROVALG") {
	                    return Get_BodyUnlock(CKEDITOR.instances.editor1.getData());
					} else {
	                    return CKEDITOR.instances.editor1.getData();
					}
	            } catch (e) { return ""; }
			}
			
			function SetEditorTextContent(data) {
	            try {
	            	data = data.replace(/&/gi, "&amp;");
	            	data = data.replace(/</gi, "&lt;");
	            	data = data.replace(/>/gi, "&gt;");
	 	            
	 	    		var line = data.split("\n");
	 	            var textData = "";
	 	            
	 	            for (var i = 0; i < line.length; i++) {
	 	            	if (line[i].trim() === "") {
	 	            		line[i] = "&nbsp;";
	 	            	}
	 	            	
 	            		textData += "<p " + defaultFontAndSize + ">" + line[i] + " " + "</p>";
	 	            }
	            	
					if (CKEDITOR.instances.editor1.mode === "source") {
						CKEDITOR.instances.editor1.setData(textData);
					} else {
						CKEDITOR.instances.editor1.editable().setHtml(textData);
					}
	            } catch (e) { }
	        }
			
			function GetEditorTextContent() {
           	    var resultStr = CKEDITOR.instances.editor1.getData();
           	    
           	    resultStr = resultStr.replace(/\r\n/gi, "\n");
        	    resultStr = resultStr.replace(/\n/gi, "");
        	    resultStr = resultStr.replace(/<p .*?>/gi, "<p>");
        	    resultStr = resultStr.replace(/<br .*?>/gi, "<br>");
        	    resultStr = resultStr.replace(/<hr .*?>/gi, "<hr>");
        	    resultStr = resultStr.replace(/<p><br>/gi, "\r\n"); // <p><br></p>인 경우 두줄되는 현상. 두번변환을 한번변환으로 변경.
        	    resultStr = resultStr.replace(/<p>/gi, "\r\n");
        	    resultStr = resultStr.replace(/<br>/gi, "\r\n");
        	    resultStr = resultStr.replace(/<hr>/gi, "\r\n----------------------------------------------------------------------");
        	    resultStr = resultStr.replace(/<style .*?>/gi, "<style>");
        	    resultStr = resultStr.replace(/<style>.*?<\/style>/gi, "");
        	    resultStr = resultStr.replace(/<script .*?>/gi, "<script>");
        	    resultStr = resultStr.replace(/<script>.*?<\/script>/gi, "");
        	    resultStr = resultStr.replace(/<.*?>/gi, "");
        	    resultStr = resultStr.replace(/^\r\n/gi, ""); // \r\n로 변환 시 두줄되는 현상. 첫 줄바꿈 제거. (<p><p>는 두줄이지만, \n\n은 세줄이다.)
        	    
        	    var tempTextarea = document.createElement("textarea");
        	    tempTextarea.innerHTML = resultStr;
        	    resultStr = tempTextarea.value;
        	    
        	    return  resultStr;
	        }
			
			function GetBodyValue() {
	            CKEDITOR.instances.editor1.getData();
	        }
			
			// 웹에디터에 내용 삽입(MHT 파일 url 받음)
			function SetEditorContentURL(url) {
	            var tempXML = createXmlDom();
// 	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(url);
	            tempXML = loadXMLString(tempStr);
	
// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            //CKEDITOR.instances.editor1.setData(getNodeText(XmlBodyDATA));

	            if (CKEDITOR.instances.editor1.mode === "source") {
					CKEDITOR.instances.editor1.setData(getNodeText(XmlBodyDATA));
				} else {
					CKEDITOR.instances.editor1.editable().setHtml(getNodeText(XmlBodyDATA));
				}
	        }
			
			function GetEditorContentURL(url) {
	            var tempXML = createXmlDom();
// 	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(url);
	            tempXML = loadXMLString(tempStr);

// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            return getNodeText(XmlBodyDATA);
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
	                CKEDITOR.instances.editor1.editable().setHtml("<br/>" + xmlhttp.responseText);
	            } catch (e) { }
	        }
	        
	        function SetEditorContentPathSign(url, strMailSign) {
	            var tempXML = createXmlDom();
// 	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(url);
	            tempXML = loadXMLString(tempStr);

// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            CKEDITOR.instances.editor1.editable().setHtml(getNodeText(XmlBodyDATA) + strMailSign);
	            /* for (var i = 0; i < GetChildNodes(XmlBodyATT).length; i++) {
	                BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODEVALUE")))
	            } */
	        }

	        function BodySetAttribute(name, Value) {
	            CKEDITOR.instances.editor1.document.$.body.setAttribute(name, Value, 0);
	        }

	        function BodyGetAttribute(name) {
	            CKEDITOR.instances.editor1.document.$.body.getAttribute(name);
	        }

	        function Get_BodyUnlock(HtmlBody) {
	            var Div_Body = document.createElement("DIV");
	            Div_Body.innerHTML = HtmlBody;
	            var TDRows = Div_Body.getElementsByTagName("*");
	            for (var i = 0; i < TDRows.length; i++) {
	                if (TDRows[i].getAttribute("contenteditable") != null) {
	                    TDRows[i].removeAttribute("contenteditable");
	                }
	            }
	            return Div_Body.innerHTML;
	        }
	        function Set_Size(width, height)
	        {
	            CKEDITOR.instances.editor1.resize(0, height);
	        }
	        function Set_CellLocked() {
	        	var elements = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*");
	        	
	            for (var i = 0; i < elements.length; i++) {
	                if (elements[i].tagName == "TD") {
	                    if (elements[i].getAttribute("free") == null) {
	                    	elements[i].setAttribute("contenteditable", "false");
	                    }
	                    else if (elements[i].getAttribute("free") != null) {
	                    	elements[i].setAttribute("contenteditable", "true");
	                    }
	                }
	                else if (elements[i].tagName == "TABLE") {
	                    if (elements[i].getAttribute("free") == null) {
	                    	elements[i].setAttribute("contenteditable", "false");
	                    }
	                    else if (elements[i].getAttribute("free") != null) {
	                    	elements[i].setAttribute("contenteditable", "true");
	                    }
	                }
	            }
	        }
	        function GetFieldsList() {
	            var FieldsList = new Array();
	            var FieldCount = 0;
	            var count = 0;
	            var i = 0;
				
	            var elements = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*");
	            var count = elements.length;

	            for (i = 0; i < count; i++) {
	                if (elements[i].getAttribute("id") == "MailSign") {
	                    var tmp = elements[i];
	                    if (!tmp.FieldID)
	                        tmp.FieldID = tmp.id;
	                    FieldsList[FieldCount] = tmp;
	                    FieldCount++;
	                }
	            }
	            return FieldsList;
	        }
	        
	        function GetListItem(pList, str) {
	            for (i = 0; i < pList.length; i++) {
	                if (pList[i].id == str)
	                    return pList[i];
	            }
	        }

	        function EditorElementSetHtml(elementID, Html) {
	            try {
	                var ElementObj = CKEDITOR.instances.editor1.document.$.getElementById(elementID)
	                if (ElementObj) {
	                    ElementObj.innerHTML = Html;
	                }
	                
	            } catch (e) {
	            }
	        }
	        
	        function GetEditorBody() {
	        	return CKEDITOR.instances.editor1.document.$.body;
	        }
	        
	        // 현재 위치에 텍스트 넣는 함수(서명 템플릿 관리>서명 템플릿 추가 및 수정 팝업창에서 사용)
	        function setCursorAtText(text) {
	        	CKEDITOR.instances.editor1.insertHtml(text);
	        }
		</script> 
	</head>
	<body style="margin: 0px; padding: 0px;">
		<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
		<script type="text/javascript">CKEDITOR.replace( 'editor1', {fullPage : false} );</script>
		<script type="text/javascript">
			var useHTMLMode = "<c:out value='${useHTMLMode}'/>";
			var defaultFontFamily = "<c:out value='${defaultFontFamily}'/>";
			var defaultFontSize = "<c:out value='${defaultFontSize}'/>";
			var defaultFontAndSize = "style='font-size:" + defaultFontSize + ";font-family:" + defaultFontFamily + "'";
			var uploadUrl = "/ezEditor/ckSimpleUpload.do?type=" + type;
			
			if (type == "APPROVAL" || type == "APPROVALG") {
	            CKEDITOR.config.enterMode = CKEDITOR.ENTER_BR;
	            
	        } else if (type == "MAILOUTOFOFFICE") {
	            CKEDITOR.config.removePlugins = '_Insert_Image';
	            CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
	            
	        } else if (type == "COMMUNITYPHOTO") {
	            CKEDITOR.config.removePlugins = '_Insert_Image';
	            CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
	            
	        } else if (type == "MAILLETTER") { // 편지지 
	        	var letterBoxNo = parent.popLetterBoxNo; // letterEditPopUp.jsp
	        	var letterId = parent.popLetterId; // letterEditPopUp.jsp
	        	
	        	uploadUrl += "&letterBoxNo=" + letterBoxNo + "&letterId=" + letterId;
	            CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
	        } else {
	            CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
	        }
			
			if (useHTMLMode == "NO") {
				CKEDITOR.config.removePlugins = "sourcearea";
			}
			CKEDITOR.config.imageUploadUrl = uploadUrl;
			CKEDITOR.config.contentsCss = "/js/ezEditor/ckEditor/contents.css";
		    CKEDITOR.config.font_defaultLabel = defaultFontFamily;
		    CKEDITOR.config.font_names = "<spring:message code='main.t0620' />";
		    CKEDITOR.config.fontSize_defaultLabel = defaultFontSize;
		    CKEDITOR.config.language = "<spring:message code='main.t0619' />";
		</script>
	</body>
</html>
