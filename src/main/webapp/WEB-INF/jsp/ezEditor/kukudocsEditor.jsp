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
		<style> html, body {height: 100%; margin: 0; padding: 0; overflow: hidden;} </style>
		<script type="text/javascript">
			var type = "${type}";
			var height = "${height}";
			var editorLoadFlag = false;
			
			function Editor_Complete() {
				editorLoadFlag = true;
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
//                 var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(pURL);
                tempXML = loadXMLString(tempStr)
//                 XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                var htmlData = getNodeText(XmlBodyDATA);
                kukudocsEditor.SetEditorContent(htmlData);
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
			
	        function EditorElementSetHtml(elementID, Html) {
	            try {
                    var ElementObj = kukudocsEditor.GetElement(elementID);
                    if (ElementObj) {
                        ElementObj.innerHTML = Html;
                    }
	            } catch (e) {
	            }
	        }
		</script> 
	</head>
	<body>
		<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
		<script type="text/javascript">
			var defaultFontFamily = "${defaultFontFamily}";
			var defaultFontSize = "${defaultFontSize}";
		
			// 언어 설정 > 쿠쿠닥스에서 아직 kr만 지원
			var lang = "";
			var userLang = "${userInfo.lang}";
			
			switch (userLang) {
		    	case "1": 
		    		lang = "kr";
		    		break;
		    	case "2": 
		    		lang = "us";
		    		break;
		    	case "3": 
		    		lang = "jp";
		    		break;
		    	case "4": 
		    		lang = "cn";
		    		break;
		    	default :
		    		lang = "us";
		    		break;
	    	}
			
			// html 모드 사용 여부 설정
			var useHTMLMode = true;
			var useHTMLModeStr = "${useHTMLMode}";
			
			if (useHTMLModeStr == "NO") {
				useHTMLMode = false;
	        }
			
			// TODO: 메뉴 줄 설정
			// 메뉴 설정			
			var customAlignMenu = ['print','menu_line','undo','redo','menu_line','text_paste','menu_line','textFormatCopy','textFormatPaste','menu_line','link','unlink','menu_line','image','menu_line','symbol','horizontal','menu_line',
								   'numbered_list','bullet_list','menu_line','outdent','indent','menu_line',
								   'table','menu_line','table_insert_left','table_insert_right','table_insert_top','table_insert_bottom','menu_line','table_remove_col','table_remove_row','table_remove_table','menu_line',
								   'table_merge','table_split_col','table_split_row','menu_line','table_background_color','table_border_style','menu_line','align_left','align_center','align_right','align_justify','menu_line','paragraph_margin','menu_line',
								   'heading','fontFamily','fontSize','line_height','menu_line','bold','italic','underline','strike_through','paragraph_remove_format','menu_line','color','background_color','menu_line','about'];
			
			// 메일 부재중설정, 커뮤니티 포토게시판일 경우 이미지 업로드 아이콘 제거
			if (type == "MAILOUTOFOFFICE" || type == "COMMUNITYPHOTO") {
				customAlignMenu.splice(customAlignMenu.indexOf('image'), 2);
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
	            customAlignMenu : customAlignMenu,
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