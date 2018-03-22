<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script type="text/javascript" src="/js/ezEditor/kukudocsEditor/externalLib/jquery-1.9.1.min.js"></script>
	    <script type="text/javascript" src="/js/ezEditor/kukudocsEditor/externalLib/jquery-ui-1.11.4.min.js"></script>
	    <script type="text/javascript" src="/js/ezEditor/kukudocsEditor/javascripts/build/Editor.bundle.js"></script>
	    <link rel="stylesheet" href="/js/ezEditor/kukudocsEditor/stylesheets/style.css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<style> html, body {height: 100%; margin: 0; padding: 0;} </style>
		<script type="text/javascript">
			var type = "${type}";
			var height = "${height}";
			
			function Editor_Complete() {
				parent.Editor_Complete();
	        }
			
			function SetEditorContent(Data) {
				kukudocsEditor.SetEditorContent(Data);
			}
			
			function GetEditorContent() {
				return kukudocsEditor.GetEditorContent();
			}
			
			function GetEditorTextContent() {
				return kukudocsEditor.GetEditorTextContent();
			}
			
			function SetEditorContentURL(pURL) {
				var tempXML = createXmlDom();
                var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(pURL);
                tempXML = loadXMLString(tempStr)
                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                var htmlData = getNodeText(XmlBodyDATA);
                kukudocsEditor.SetEditorContent(htmlData);
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
			
	        function EditorElementSetHtml(elementID, Html) {
	            try {
                    var ElementObj = kukudocsEditor.GetElement(elementID);
                    if (ElementObj) {
                        ElementObj.innerHTML = Html;
                    }
	            } catch (e) {
	            }
	        }
	        
	        function GetFieldsList() {
	            var FieldsList = new Array();
	            FieldsList[0] = kukudocsEditor.GetElement("MailSign");
	            return FieldsList;
	        }
	        
	        function GetListItem(pList, str) {
	            for (i = 0; i < pList.length; i++) {
	                if (pList[i].id == str)
	                    return pList[i];
	            }
	        }
	        
	        function CellCheckField() {
	            if (parent.Attribute_Write != undefined) {
	                var selectE = kukudocsEditor.GetCurrentElement("TD");
	
	                if (Array.isArray(selectE)) {
	                    if (selectE.length > 1) {
	                        selectE = selectE[0];
	                    }
	                }
	                
	                if (selectE != null && selectE.tagName == "TD") {
	                    parent.Attribute_Write(GetAttribute(selectE, "id"));
	                }
	            }
	        }
			/* mouseup, keyup 에 등록해야하는 function */
	        function View_CellProperty(g_toggleFlag) {
	            var TotalTag = GetElementsByTagName(kukudocsEditor.getContentViewElement()[0], "TD");
	            
	            for (var i = 0; i < TotalTag.length; i++) {
	                if (TotalTag[i].id != "") {
	                    if (TotalTag[i].classList != null) {
	                        if (TotalTag[i].classList.contains("FIELD")) {
	                            if (g_toggleFlag) {
	                                TotalTag[i].setAttribute("beforebgcolor", TotalTag[i].style.backgroundColor);
	                                TotalTag[i].style.backgroundColor = "#BEE7FC";
	                            }
	                            else {
	                                TotalTag[i].style.backgroundColor = TotalTag[i].getAttribute("beforebgcolor");
	                                TotalTag[i].removeAttribute("beforebgcolor");
	                            }
	                        }
	                    }
	                    else {
	                        if (TotalTag[i].className.indexOf("FIELD") > -1) {
	                            if (g_toggleFlag) {
	                                TotalTag[i].setAttribute("beforebgcolor", TotalTag[i].style.backgroundColor);
	                                TotalTag[i].style.backgroundColor = "#BEE7FC";
	                            }
	                            else {
	                                TotalTag[i].style.backgroundColor = TotalTag[i].getAttribute("beforebgcolor");
	                                TotalTag[i].removeAttribute("beforebgcolor");
	                            }
	                        }
	                    }
	                }
	            }
	
	            return g_toggleFlag;
	        }
		</script> 
	</head>
	<body>
		<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
		<script type="text/javascript">
			var defaultFontFamily = "${defaultFontFamily}";
			var defaultFontSize = "${defaultFontSize}";
		
			// TODO: 언어 설정
			var lang = "kr"; // 언어
			var userLang = "${userInfo.lang}"; // 사용자 언어
			
			// html 모드 사용 여부 설정
			var useHTMLMode = true;
			var useHTMLModeStr = "${useHTMLMode}";
			
			if (useHTMLModeStr == "NO") {
				useHTMLMode = false;
	        }
			
			// 숨김 메뉴 설정
			var hiddenMenu = ["new", "file_open", "save", "auto_save_load", "layout", "template", "copy", "paste", "cut", "all_select", "page_break", 
							  "dir_ltr", "dir_rtl", "video", "video_modify", "file", "emoticon", "layer", "fullscreen", "setting", "help"];
			
			if (type == "MAILOUTOFOFFICE" || type == "COMMUNITYPHOTO") {
	        	//메일 부제중설정 시 이미지 업로드 아이콘 제거
				hiddenMenu.push("image", "image_modify");
	        }
			
			// 이미지 업로드 URL 설정
			var imageUploadURL = "/ezEditor/kukudocsUpload.do?type=" + type;
			
			// TODO: 디폴트 폰트 설정
			
			var kukudocsEditor = new KuKudocsEditor('editor1', {
	            minHeight : 0,
	            maxHeight : 0,
	            width : '100%',
	            height : '100%',
	            lang : lang,
	            hiddenMenu : hiddenMenu,
	            useMenuBar : false,
	            useHTMLMode : useHTMLMode,
	            useTextMode : false,
	            usePreviewMode : false,
	            useEditorResize : false,
	            loadingImageURL : '/js/ezEditor/kukudocsEditor/images/load.gif',
	            errorImageURL : '/js/ezEditor/kukudocsEditor/images/error.png',
	            imageUploadURL : imageUploadURL,
	            Editor_Complete : Editor_Complete
	        });
			
		</script>
	</body>
</html>