<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/tfxEditor/js/xfe_main.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style>.xfeToolbar {border-top-left-radius : 0px !important; border-top-right-radius : 0px !important;}</style>
		<script  type="text/javascript">
			var type = "<c:out value='${type}'/>";
			var editorLoadFlag = false;
			var doc = null; // 제품 디자인영역 document
			
			// 2025.07.30 김대현 - 커서를 원래 위치로 돌리는 함수
			function setFocus(selection,savedRange) {
				selection.removeAllRanges();
				selection.addRange(savedRange);
			}

			// 2025.07.30 김대현 - 현재 스크롤 위치 저장 함수
			function saveCursorPosition() {
				const iframe = document.querySelector('.xfeDesignFrame');
				const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
				const currentScroll = iframeDoc.body.scrollTop;
				return currentScroll;
			}
			
			function SetEditorContent(Data) {
	            try {
	            	// 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
	            	if (parent.onloadflag || typeof parent.onloadflag === "undefined") {
	            		if (Data === "") {
							Data = "<p " + defaultFontAndSize + "><br></p>";
						}
						
						// 2025-07-29 김대현 임시저장시 setEditorContent 후 커서 위치로 다시 이동
						const doc = xfe.xfeStackObject.xfeDocument;
						const body = doc.body;
						
						const iframe = document.querySelector('.xfeDesignFrame');
						const currentScroll = saveCursorPosition();

						const selection = doc.getSelection();
						let offset = 0;

						if (selection && selection.rangeCount > 0) {
							const range = selection.getRangeAt(0);
							const preRange = range.cloneRange();
							preRange.selectNodeContents(body);
							preRange.setEnd(range.startContainer, range.startOffset);
							offset = preRange.toString().length;
						}


						body.innerHTML = Data;


						let currentOffset = 0;
						const walker = doc.createTreeWalker(body, NodeFilter.SHOW_TEXT, null, false);

						while (walker.nextNode()) {
							const node = walker.currentNode;
							const length = node.nodeValue.length;

							if (currentOffset + length >= offset) {
								const range = doc.createRange();
								range.setStart(node, offset - currentOffset);
								range.collapse(true);

								const sel = doc.getSelection();
								sel.removeAllRanges();
								sel.addRange(range);
								break;
							}

							currentOffset += length;
						}
						
						iframe.contentDocument.body.scrollTop = currentScroll;
					} else {
	            		setTimeout(parent.Editor_Complete, 10);
	            	}
	            } catch (e) { }
	        }
		
			function GetEditorContent() {
				try {
					
					// 2025.07.28 김대현 태그프리 자동저장시 커서 사라지는 현상 수정
					var selection = doc.getSelection();// 현재 문서에서 선택(커서) 정보
					const iframe = document.querySelector('.xfeDesignFrame');
					const currentScroll = saveCursorPosition();

					let savedRange = null;
					savedRange = selection.rangeCount > 0 ? selection.getRangeAt(0).cloneRange() : null; // 마우스 위치 저장
					
					var result = xfe.getBodyValue();

					if (savedRange) setFocus(selection,savedRange);
					iframe.contentDocument.body.scrollTop = currentScroll;
					
	            	return result;
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
	 	            	
 	            		textData += "<p " + defaultFontAndSize + ">" + line[i] + "</p>";
	 	            }
	            	
	 	           xfe.setHtmlValue(textData);
	            } catch (e) { }
	        }
			
			function GetEditorTextContent() {
				var selection = doc.getSelection();// 현재 문서에서 선택(커서) 정보

				let savedRange = null;
				savedRange = selection.rangeCount > 0 ? selection.getRangeAt(0).cloneRange() : null; // 마우스 위치 저장
				const iframe = document.querySelector('.xfeDesignFrame');
				const currentScroll = saveCursorPosition();

                var resultStr = xfe.getBodyValue();

				if (savedRange) setFocus(selection,savedRange);
                
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
				iframe.contentDocument.body.scrollTop = currentScroll;
				
                return  resultStr;
	        }
			
			function GetBodyValue() {
	            try {
	                return xfe.getBodyValue();
	            } catch (e) { return ""; }
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
                xfe.setBodyValue(htmlData);
	        }	
		
			function GetEditorContentURL(url) {
				var tempXML = createXmlDom();
//                 var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(url);
                tempXML = loadXMLString(tempStr)
//                 XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
			    return getNodeText(XmlBodyDATA);
			}
			
			function SetEditorContentURL_Admin(pURL) {
	            try {
	                var tempXML = createXmlDom();
// 	                var XmlBodyATT = createXmlDom();
	                var XmlBodyDATA = createXmlDom();
	                var tempStr = "";
	                tempStr = ConvertMHTtoHTML(pURL);
	                tempXML = loadXMLString(tempStr)
// 	                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];

	                var Doc_ContentHtml = document.createElement("DIV");
	                Doc_ContentHtml.innerHTML = getNodeText(XmlBodyDATA);

	                var htmlData = "";
	                var ConnData = "";
	                for (var i = 0; i < GetChildNodes(Doc_ContentHtml).length ; i++) {
	                    if (GetChildNodes(Doc_ContentHtml)[i].id.toUpperCase() == "CONN") {
	                        ConnData = Doc_ContentHtml.children[i].innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', '');
	                    }
	                    else if (GetChildNodes(Doc_ContentHtml)[i].tagName != undefined && (GetChildNodes(Doc_ContentHtml)[i].tagName.toUpperCase() != "XML" || GetChildNodes(Doc_ContentHtml)[i].tagName.toUpperCase() != "TABLEINFO"))
	                        htmlData = htmlData + GetChildNodes(Doc_ContentHtml)[i].outerHTML;
	                }

	                xfe.setBodyValue(htmlData);
	                return ConnData;
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
			
			function GetFieldsList() {           
	            var FieldsList = new Array();
	            FieldsList[0] = xfe.getDom().getElementById("MailSign")
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
	                var ElementObj = xfe.getDom().getElementById(elementID);
	                if (ElementObj) {
	                    ElementObj.innerHTML = Html;
	                }
	            } catch (e) {
	            }
	        }

	        function GetEditorBody() {
	        	return xfe.getDom().body;
	        }
	        const xfeHeight = (document.documentElement.clientHeight - 1) ;

			window.onresize =  function () {
	             try {
	                /*setTimeout(function(){
                         let height = document.documentElement.clientHeight - 220;

                            xfe.setWidth("100%");
                            xfe.setHeight(height+ "px");
	                },100);*/

                    xfe.setWidth("100%");
                    xfe.setHeight((document.documentElement.clientHeight - 1) + "px");
	            } catch (e) { }
	        }
			
			// 현재 위치에 텍스트 넣는 함수(서명 템플릿 관리>서명 템플릿 추가 및 수정 팝업창에서 사용)
	        function setCursorAtText(text) {
	        	var range = xfe.getSavedRange();
	        	xfe.insertHtmlAtCursor(text, range);
	        }

			function SetEditorFocus() { // 에디터 textarea에 커서를 위치시킴
				xfe.setFocus();
			}
		</script> 
	</head>
	<body style="margin: 0px; padding: 0px; overflow: hidden;" id="xfe">
	    <script type="text/javascript">
	    	var userLang = "<c:out value='${userInfo.lang}'/>";
	    	var lang = "";
	    	var useHTMLMode = "<c:out value='${useHTMLMode}'/>";
	    	var defaultFontFamily = "<c:out value='${defaultFontFamily}'/>";
			var defaultFontSize = "<c:out value='${defaultFontSize}'/>";
			var defaultFontAndSize = "style='font-size:" + defaultFontSize + ";font-family:" + defaultFontFamily + "'";
			
	    	switch (userLang) {
		    	case "1": 
		    		lang = "korean";
		    		break;
		    	case "2": 
		    		lang = "english";
		    		break;
		    	case "3": 
		    		lang = "japanese";
		    		break;
		    	case "4": 
		    		//중국어 간체 (번체는 chinese_t)
		    		lang = "chinese_s";
		    		break;
		    	default :
		    		lang = "english";
		    		break;
	    	}
	    	
	    	var initFontFamilyMenu = "<spring:message code='main.t0620' />".split(";");

	    	var uploadFilePath = "/ezEditor/tfxUpload.do?type=" + type;
	    	var uploadPasteContentsPath = "/ezEditor/tfxSimpleUpload.do?type=" + type;
	    	
	    	if (type == "MAILOUTOFOFFICE" || type == "COMMUNITYPHOTO") {
	   			uploadPasteContentsPath = "/ezEditor/tfxNoop.do";
	   		} else if (type == "MAILLETTER") {
	        	var letterBoxNo = parent.popLetterBoxNo; // letterEditPopUp.jsp
	        	var letterId = parent.popLetterId; // letterEditPopUp.jsp
	        	
	        	uploadFilePath = "/ezEditor/tfxUpload.do?type=" + type + "&letterBoxNo=" + letterBoxNo + "&letterId=" + letterId;
	        	uploadPasteContentsPath = "/ezEditor/tfxSimpleUpload.do?type=" + type + "&letterBoxNo=" + letterBoxNo + "&letterId=" + letterId;
	   		}
	    	
	        xfe = new XFE({
	        	lang : lang,
	            basePath : "/js/ezEditor/tfxEditor",
	            width : "100%",
	            height : xfeHeight + "px",
	            initFontFamilyMenu : initFontFamilyMenu,
	            initFontFamily : defaultFontFamily,
	            initFontSize : defaultFontSize,
	            skin : "classic",
	            uploadFilePath : uploadFilePath,
	            uploadPasteContentsPath : uploadPasteContentsPath,
	            autoFocus : false,
	            rootFrameId : 'tbContentElement',
	            ignoreMinHeight : true,
				autoSave: {apply : false}
	        });
	        
	        xfe.render('xfe');
	        xfe.showMenubar(false);
			doc = xfe.xfeStackObject?.xfeDocument; // 제품 디자인영역 document
	        
	        if (type == "MAILOUTOFOFFICE" || type == "COMMUNITYPHOTO") {
	        	xfe.showToolbarItem(0, 11, false);
	        	xfe.showToolbarItem(0, 12, false);
	        	xfe.showToolbarItem(0, 13, false);
	        }
	        
	        if (useHTMLMode == "NO") {
	        	xfe.showTab(1, false);
	        }

			window.onload = function() {
				editorLoadFlag = true;
				if (parent && (parent.onloadflag || typeof parent.onloadflag === "undefined")) {
					if (typeof parent.Editor_Complete === "function") {
						parent.Editor_Complete();
					} 
				} else {
					setTimeout(OnInitCompleted, 10);
				}
			};

			function OnInitCompleted() {
				if (parent && (parent.onloadflag || typeof parent.onloadflag === "undefined")) {
					if (typeof parent.Editor_Complete === "function") {
						parent.Editor_Complete();
					} 
				} else {
					setTimeout(OnInitCompleted, 10);
				}
			}
	    </script>
	</body>
</html>
