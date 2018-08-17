<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<title></title>
	    <link rel="stylesheet" href="${util.addVer('/js/ezEditor/kukudocsEditor/stylesheets/style.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-1.9.1.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-ui-1.11.4.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/javascripts/build/Editor.bundle.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
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
                var tempStr = ConvertMHTtoHTML(pURL);
                var tempXML = loadXMLString(tempStr);
                var XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                var htmlData = getNodeText(XmlBodyDATA);
                kukudocsEditor.SetEditorContent(htmlData);
			}
			
			function GetEditorContentURL(url) {
	            var tempStr = ConvertMHTtoHTML(url);
	            var tempXML = loadXMLString(tempStr);
	            var XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
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
	        
	        function GetEditorBody() {
	        	return kukudocsEditor.getContentViewElement()[0];
	        }
		</script> 
	</head>
	<body>
		<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
		<script type="text/javascript">
			// 언어 설정
			var lang = "";
			var userLang = "${userInfo.lang}";
			
			switch (userLang) {
		    	case "1": 
		    		lang = "ko";
		    		break;
		    	case "2": 
		    		lang = "en";
		    		break;
		    	case "3": 
		    		lang = "ja";
		    		break;
		    	case "4": 
		    		lang = "zh";
		    		break;
		    	default :
		    		lang = "en";
		    		break;
	    	}
			
			// html 모드 사용 여부 설정
			var useHTMLMode = "${useHTMLMode}" == "NO" ? false : true;
			
			// 메뉴 설정			
			var customAlignMenu = ['about','print','undo','redo','text_paste','textFormatCopy','textFormatPaste','link','unlink','image','symbol','horizontal','numbered_list','bullet_list','outdent','indent',
								   'table','table_insert_left','table_insert_right','table_insert_top','table_insert_bottom','table_remove_col','table_remove_row','table_remove_table',
								   'table_merge','table_split_col','table_split_row','table_background_color','table_border_style','align_left','align_center','align_right','align_justify','paragraph_margin',
								   'template','heading','fontFamily','fontSize','line_height','bold','italic','underline','strike_through','remove_format','color','backgroundColor'];
			
			// 메일 부재중설정, 커뮤니티 포토게시판일 경우 이미지 업로드 아이콘 제거
			if (type == "MAILOUTOFOFFICE" || type == "COMMUNITYPHOTO") {
				customAlignMenu.splice(customAlignMenu.indexOf('image'), 1);
	        }
			
			// 이미지 업로드 URL 설정
			var imageUploadURL = "/ezEditor/kukudocsUpload.do?type=" + type;
			
			if (type == "MAILLETTER") { // 편지지 
	        	var letterBoxNo = parent.popLetterBoxNo; // letterEditPopUp.jsp
	        	var letterId = parent.popLetterId; // letterEditPopUp.jsp
	        	
	        	imageUploadURL = "/ezEditor/kukudocsUpload.do?type=" + type + "&letterBoxNo=" + letterBoxNo 
	        			+ "&letterId=" + letterId;
	        }
			
			// 디폴트 폰트 설정
			var defaultFontFamily = "${defaultFontFamily}";
			var defaultFontSize = "${defaultFontSize}";
			
			// 폰트 크기 리스트 설정
			var fontSize = [
				{name:'8px',  value:'8px'},
				{name:'9px',  value:'9px'},
				{name:'10px', value:'10px'},
				{name:'11px', value:'11px'},
				{name:'12px', value:'12px'},
				{name:'13px', value:'13px'},
				{name:'14px', value:'14px'},
				{name:'15px', value:'15px'},
				{name:'16px', value:'16px'},
				{name:'18px', value:'18px'},
				{name:'20px', value:'20px'},
				{name:'22px', value:'22px'},
				{name:'24px', value:'24px'},
				{name:'26px', value:'26px'},
				{name:'36px', value:'30px'},
				{name:'36px', value:'36px'},
				{name:'36px', value:'42px'},
				{name:'36px', value:'48px'},
				{name:'54px', value:'54px'},
				{name:'54px', value:'72px'},
				{name:'54px', value:'80px'},
				{name:'72px', value:'88px'},
				{name:'72px', value:'100px'}
			];
			
			// 폰트 리스트 설정
			var fontFamilyArr = "<spring:message code='main.t0620' />".split(";");
			var fontFamily = [];
			
			for (var i = 0; i < fontFamilyArr.length; i++) {
				fontFamily[i] = {
					name : fontFamilyArr[i],
					value : fontFamilyArr[i]
				}
			}
			
			// 템플릿 설정
			var templateList = [{
				name : 'Default Template', 
				items : [{name : 'Meeting log', type : 'url', value : '/js/ezEditor/kukudocsEditor/template/meeting_log.html'},
						 {name : 'Report', type : 'url', value : '/js/ezEditor/kukudocsEditor/template/report.html'},
						 {name : 'Vacation', type : 'url', value : '/js/ezEditor/kukudocsEditor/template/vacation.html'}]
			}];
			
			var kukudocsEditor = new KuKudocsEditor('editor1', {
	            minHeight : 0,
	            maxHeight : 0,
	            width : '100%',
	            height : '100%',
	            defaultLanguage : lang,
	            languagePathURL : '/js/ezEditor/kukudocsEditor/lang/',
	            defaultFontFamily : defaultFontFamily,
	            defaultFontSize : defaultFontSize,
	            fontSize : fontSize,
	            fontFamily : fontFamily,
	            defaultTableWidth : 700,
	            customMagicLineStyle : 'background-color:#888;',
	            customAlignMenu : customAlignMenu,
	            useMenuBar : false,
	            useHTMLMode : useHTMLMode,
	            useTextMode : false,
	            usePreviewMode : false,
	            useEditorResize : false,
	            useFirstFocus : false,
	            useOnlyTableContentMenu : true,
	            publicPathURL : '/js/ezEditor/kukudocsEditor/',
	            templateList : templateList,
	            defaultEditorStylePath :'/js/ezEditor/kukudocsEditor/stylesheets/editor_style.css',
	            loadingImageURL : '/js/ezEditor/kukudocsEditor/images/load.gif',
	            errorImageURL : '/js/ezEditor/kukudocsEditor/images/error.png',
	            imageUploadURL : imageUploadURL,
	            Editor_Complete : Editor_Complete
	        });
		</script>
	</body>
</html>