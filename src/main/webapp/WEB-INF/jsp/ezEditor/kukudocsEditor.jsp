<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<title></title>
	    <link rel="stylesheet" href="${util.addVer('/js/ezEditor/kukudocsEditor/stylesheets/kk_webEditor_min.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-1.9.1.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-ui-1.11.4.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/javascripts/build/Editor.bundle.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style> html, body {height: 100%; margin: 0; padding: 0; overflow: hidden;} </style>
		<script type="text/javascript">
			var type = '<c:out value="${type}"/>';
			var height = '<c:out value="${height}"/>';
			var editorLoadFlag = false;

			window.onload = function () {
				
				var element = parent.document.getElementById("layer_menu");
				if (element) {
					$(document).mouseup(function () {

						if (element.style.display !== 'none') {
							parent.document.getElementById("view_more").classList.remove('on');
							element.style.display = 'none';
						}
					})
				}
				
			};

			function Editor_Complete() {
				editorLoadFlag = true;
				parent.Editor_Complete();
				
				// 2024-10-24 김대현 에디터 부분 클릭시 메일 쓰기창 상단 more list 숨김처리
				var iframes = document.getElementsByTagName('iframe');
				var element = parent.document.getElementById("layer_menu");
				
				if (element) {
					for (var i = 0; i < iframes.length; i++) {
						var iframe = iframes[i];
						if (iframe.classList && iframe.classList.contains('kk_contentView')) {
							var iframeDocument = iframe.contentWindow.document;
							iframeDocument.addEventListener('mouseup', function () {
								
								if (element.style.display !== 'none') {
									parent.document.getElementById("view_more").classList.remove('on');
									element.style.display = 'none';
								}
							});
							break;
						}
					}
				}
	        }
			
			function SetEditorContent(Data) {
				if (Data === "") {
					Data = "<p " + defaultFontAndSize + "><br></p>";
				}
				
				kukudocsEditor.SetEditorContent(Data);
			}
			
			function GetEditorContent() {
				return kukudocsEditor.GetEditorContent();
			}
			
			function SetEditorTextContent(data) {
            	data = data.replace(/&/gi, "&amp;");
            	data = data.replace(/</gi, "&lt;");
            	data = data.replace(/>/gi, "&gt;");
 	            
 	    		var line = data.split("\n");
 	            var textData = "";
 	            
 	            for (var i = 0; i < line.length; i++) {
 	            	if (line[i].trim() === "") {
 	            		line[i] = "&nbsp;";
 	            	}
 	            	
	            	textData += "<p " + defaultFontAndSize + ">" + line[i] + "</p>";
 	            }
            	
 	           kukudocsEditor.SetEditorContent(textData);
	        }
			
			function GetEditorTextContent() {
           	    var resultStr = kukudocsEditor.GetEditorContent();
           	    
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
	        
	        // 현재 위치에 텍스트 넣는 함수(서명 템플릿 관리>서명 템플릿 추가 및 수정 팝업창에서 사용)
	        function setCursorAtText(text) {
	        	kukudocsEditor.InsertTextByFocus(text);
	        }
	        
	        function SetEditorFocus() { // 에디터 textarea에 커서를 위치시킴
	            kukudocsEditor.SetEditorFocus();
	        }
		</script> 
	</head>
	<body>
		<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
		<script type="text/javascript">
			// 언어 설정
			var lang = "";
			var userLang = "<c:out value='${userInfo.lang}'/>";
			
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
		    	/*case "4":
		    		lang = "cn";
		    		break;*/
		    	default :
		    		lang = "en";
		    		break;
	    	}
			
			// html 모드 사용 여부 설정
			var useHTMLMode = "<c:out value='${useHTMLMode}'/>" == "NO" ? false : true;
			
			// 메뉴 설정			
			var customAlignMenu = ['about','print','undo','redo','text_paste','textFormatCopy','textFormatPaste','link','unlink','image','symbol','horizontal','numbered_list','bullet_list','outdent','indent',
								   'table','table_insert_left','table_insert_right','table_insert_top','table_insert_bottom','table_remove_col','table_remove_row','table_remove_table',
								   'table_merge','table_split_col','table_split_row','cell_horizontal_size','cell_vertical_size','table_background_color','table_border_style','align_left','align_center','align_right','align_justify','paragraph_margin',
								   'heading','fontFamily','fontSize','line_height','bold','italic','underline','strikeThrough','remove_format','color','backgroundColor', 'border_visualize'];
			
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
			var defaultFontFamily = "<c:out value='${defaultFontFamily}'/>";
			var defaultFontSize = "<c:out value='${defaultFontSize}'/>";
			var defaultFontAndSize = "style='font-size:" + defaultFontSize + ";font-family:" + defaultFontFamily + "'";
			
			// 폰트 크기 리스트 설정
			var fontSize = [
				{name:'8pt',  value:'8pt'},
                {name:'9pt',  value:'9pt'},
                {name:'10pt', value:'10pt'},
                {name:'11pt', value:'11pt'},
                {name:'12pt', value:'12pt'},
                {name:'13pt', value:'13pt'},
                {name:'14pt', value:'14pt'},
                {name:'15pt', value:'15pt'},
                {name:'16pt', value:'16pt'},
                {name:'18pt', value:'18pt'},
                {name:'20pt', value:'20pt'},
                {name:'22pt', value:'22pt'},
                {name:'24pt', value:'24pt'},
                {name:'26pt', value:'26pt'},
                {name:'30pt', value:'30pt'},
                {name:'36pt', value:'36pt'},
                {name:'42pt', value:'42pt'},
                {name:'48pt', value:'48pt'},
                {name:'54pt', value:'54pt'},
                {name:'72pt', value:'72pt'},
                {name:'80pt', value:'80pt'},
                {name:'88pt', value:'88pt'},
                {name:'100pt', value:'100pt'}
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
			
		    //Color Picker 값 수정
		    var colorPicker = {
		        simpleColor :   ["ffffff", "000000", "eeece1", "1f497d", "4f81bd", "c0504d", "9bbb59", "8064a2", "4bacc6", "f79646"],
		        standardColor : ["f2f2f2", "808080", "ddd9c3", "c6d9f1", "dce6f2", "f2dcdb", "ebf1de", "e6e0ec", "dbeee0", "fdeada",
		                        "d9d9d9", "595959", "c4bd97", "8eb4e3", "b9cde5", "e6b9b8", "d7e4bd", "ccc1da", "b7dee8", "fcd5b5",
		                        "bfbfbf", "404040", "948a54", "558ed5", "95b3d7", "d99694", "c3d69b", "b3a2c7", "93cddd", "fac090",
		                        "a6a6a6", "262626", "4a452a", "17375e", "376092", "953735", "77933c", "604a7b", "31859c", "e46c0a",
		                        "808080", "0d0d0d", "1e1c11", "10243f", "254061", "632523", "4f6228", "403152", "215968", "984807"],
		        normalColor   : ["c00000", "ff0000", "ffc000", "ffff00", "92d050", "00b050", "00b0f0", "0000ff", "002060", "7030a0"]
		    };
			
			var kukudocsEditor = new KuKudocsEditor('editor1', {
				licPathURL: '/js/ezEditor/kukudocsEditor/kukudocs.lic',
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
	            useHtmlMode : useHTMLMode,
	            useTextMode : false,
	            usePreviewMode : false,
	            useEditorResize : false,
	            useFirstFocus : false,
	            useOnlyTableContentMenu : true,
	            useNoneBorderVisualize : true,
	            publicPathURL : '/js/ezEditor/kukudocsEditor/',
	            defaultEditorStylePath :'/js/ezEditor/kukudocsEditor/stylesheets/editor_style.css',
	            loadingImageURL : '/js/ezEditor/kukudocsEditor/images/load.gif',
	            errorImageURL : '/js/ezEditor/kukudocsEditor/images/error.png',
	            imageUploadURL : imageUploadURL,
	            Editor_Complete : Editor_Complete,
	            cell_lock_name : 'cell_lock',
	            lockImageURL : '/images/lock.png',
	            colorPicker : colorPicker
	        });
		</script>
	</body>
</html>
