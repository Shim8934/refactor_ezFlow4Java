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

	        function CellCheckField(a, b) {
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
			
	        function SetAttribute(type, id, classname) {
	            var selCell = kukudocsEditor.GetCurrentElement("TD");
	
	            if (Array.isArray(selCell)) {
	                selCell = selCell[0];
	            } else if (selCell == null) {
	                return false;
	            }
	
	            while (selCell && !selCell.previousElementSibling && !selCell.nextElementSibling) {
	                selCell = selCell.parentNode;
	                
	                if (selCell.tagName == "TD" || selCell.tagName == "TH") {
	                    break;
	                }
	            }
	
	            if (type == "DEL") {
	            	// 일지 양식작성에서 사용하는 부분
	            	if ("${type}" == "JOURNAL") {
	            		selCell.removeAttribute("id", id);
	            		selCell.innerHTML = "";
	            	} else {
		                selCell.removeAttribute("id");
	            	}
	
	                if (selCell.classList != null) {
	                    if (selCell.classList.contains("FIELD")) {
	                        selCell.classList.remove("FIELD");
	                    }
	                } else {
	                    if (selCell.className.indexOf("FIELD") > -1) {
	                        selCell.className = selCell.className.replace("FIELD ", "").replace(" FIELD", "").replace("FIELD", "");
	                    }
	                }
	
	                parent.Attribute_Write("");
	                ChangeCell_display(selCell);
	            } else if (type == "LOCK") {
                    if (selCell.getAttribute("free") != null) {
                        selCell.removeAttribute("free");
                    } else {
                        selCell.setAttribute("free", "free");
                    }

                    ChangeCell_display(selCell);
	            } else {
	            	// 일지양식작성에서 사용하는 부분
	                if ("${type}" == "JOURNAL") {
		                selCell.setAttribute("id", id);
	                	selCell.innerHTML = "@" + id;
	                	
	                } else {
		                selCell.setAttribute("id", id);
	                }
	
	                if (selCell.classList != null) {
	                    if (!selCell.classList.contains("FIELD")) {
	                        selCell.classList.add("FIELD");
	                    }
	                } else {
	                    if (selCell.className.indexOf("FIELD") < 0) {
	                        if (selCell.className === "") {
	                            selCell.className = "FIELD";
	                        } else {
	                            selCell.className = selCell.className + " FIELD";
	                        }
	                    }
	                }
	
	                ChangeCell_display(selCell);
	            }
	        }
	        
	        function ChangeCell_display(selectCell) {
	            // 셀설정시 설정 셀 배경색 변경표시후 0.5초뒤 원복
	            selectCell.setAttribute("beforebgcolor", selectCell.style.backgroundColor);
	            selectCell.style.backgroundColor = "#BEE7FC";
	
	            setTimeout(function () {
	                selectCell.style.backgroundColor = selectCell.getAttribute("beforebgcolor");
	                selectCell.removeAttribute("beforebgcolor");
	            }, 500);
	        }
	
	        function FormInfoCheck(type) {
	            try {
	                switch (type) {
	                    case "null":
	                        if (GetEditorContent() == "")
	                            return true;
	                        else
	                            return false;
	                        break;
	                    case "body":
	                        var CheckCount = 0;
	                        var HtmlTag = GetElementsByTagName(kukudocsEditor.getContentViewElement()[0], "*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "body")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
	                    case "doctitle":
	                        var CheckCount = 0;
	                        var HtmlTag = GetElementsByTagName(kukudocsEditor.getContentViewElement()[0], "*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "doctitle")
	                                CheckCount++;
	                        }
	                        return CheckCount;
	                        break;
	                    case "doctitlefield":
	                        var CheckCount = 0;
	                        var HtmlTag = GetElementsByTagName(kukudocsEditor.getContentViewElement()[0], "*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "body")
	                                return GetAttribute(HtmlTag[i], "doctitlefield");
	                        }
	                        break;
	                    default:
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
	            Editor_Complete : Editor_Complete,
	            Mouse_event : {'keyup' : CellCheckField},
	            Key_event : {'mouseup' : CellCheckField}
	        });
			
		</script>
	</body>
</html>