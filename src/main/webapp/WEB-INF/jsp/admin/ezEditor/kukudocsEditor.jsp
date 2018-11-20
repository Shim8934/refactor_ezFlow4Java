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
                var tempStr = ConvertMHTtoHTML(pURL);
                var tempXML = loadXMLString(tempStr)
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
	            		selCell.removeAttribute("id");
	            		selCell.innerHTML = "";
	            	} else {
		                selCell.removeAttribute("id");
	            	}
	
	            	//2018-10-01 김보미 - 값이 비어있는 부분 클릭 후 취소시 포커스(배경색이 파란색으로)되지 않도록 변경 
	            	if (selCell.className == "FIELD") {
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
	            	}
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
	        
	        function tableLock() {
// 	        	var selectedElement = kukudocsEditor.GetAttributeValueByFocus();
// 	        	if (!selectedElement) {
// 	        		return;
// 	        	}
	        	
// 	        	var tableId;
	        	
// 	        	if (selectedElement.constructor === Array) {
// 	        		for (var i = 0; i < selectedElement.length; i++) {
// 	        			tableId = selectedElement[i].closest('table').attr('id');
	        			
// 	        			if (tableId) {
// 	    	        		kukudocsEditor.SetCellLockByID(tableId, true);
// 	    	        	}
// 	        		}
// 	        	} else {
// 	        		tableId = selectedElement[i].closest('table').attr('id');
	        		
// 	        		if (tableId) {
//     	        		kukudocsEditor.SetCellLockByID(tableId, true);
//     	        	}
// 	        	}
	        }
	        
	        function tableFree() {
// 	        	var selectedElement = kukudocsEditor.GetAttributeValueByFocus();
// 	        	if (!selectedElement) {
// 	        		return;
// 	        	}
	        	
// 	        	var tableId;
	        	
// 	        	if (selectedElement.constructor === Array) {
// 	        		for (var i = 0; i < selectedElement.length; i++) {
// 	        			tableId = selectedElement[i].closest('table').attr('id');
	        			
// 	        			console.log(tableId);
	        			
// 	        			if (tableId) {
// 	    	        		kukudocsEditor.SetCellLockByID(tableId, false);
// 	    	        	}
// 	        		}
// 	        	} else {
// 	        		tableId = selectedElement[i].closest('table').attr('id');
	        		
// 	        		if (tableId) {
//     	        		kukudocsEditor.SetCellLockByID(tableId, false);
//     	        	}
// 	        	}
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
								   'table_merge','table_split_col','table_split_row','cell_horizontal_size','cell_vertical_size','table_background_color','table_border_style','align_left','align_center','align_right','align_justify','paragraph_margin',
								   'template','heading','fontFamily','fontSize','line_height','bold','italic','underline','strike_through','remove_format','color','backgroundColor',
								   'cellLock', 'cellFree', 'tableLock', 'tableFree'];
			
			// 이미지 업로드 URL 설정
			var imageUploadURL = "/ezEditor/kukudocsUpload.do?type=" + type;
			
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
				{name:'30px', value:'30px'},
				{name:'36px', value:'36px'},
				{name:'42px', value:'42px'},
				{name:'48px', value:'48px'},
				{name:'54px', value:'54px'},
				{name:'72px', value:'72px'},
				{name:'80px', value:'80px'},
				{name:'88px', value:'88px'},
				{name:'100px', value:'100px'}
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
			
			// 커스텀 버튼 설정
			var customButtonMenuItem = [
				{
					id : "cellLock", 
					name : "cell lock", 
					style : "background:url('/js/ezEditor/kukudocsEditor/images/emoticon/animal0.png'); background-size:20px 18px;", 
					action : function() {
						kukudocsEditor.SetCellLockByFocus(true);
					}
				},
				{
					id : "cellFree", 
					name : "cell free", 
					style : "background:url('/js/ezEditor/kukudocsEditor/images/emoticon/animal1.png'); background-size:20px 18px;", 
					action : function() {
						kukudocsEditor.SetCellLockByFocus(false);
					}
				},
			    {
					id : "tableLock", 
					name : "table lock", 
					style : "background:url('/js/ezEditor/kukudocsEditor/images/emoticon/animal2.png'); background-size:20px 18px;", 
					action : tableLock
				},
			    {
					id : "tableFree", 
					name : "table free", 
					style : "background:url('/js/ezEditor/kukudocsEditor/images/emoticon/animal3.png'); background-size:20px 18px;", 
					action : tableFree
				}
			];
			
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
	            customButtonMenuItem : customButtonMenuItem,
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
	            Editor_Complete : Editor_Complete,
	            Mouse_event : {'keyup' : CellCheckField},
	            Key_event : {'mouseup' : CellCheckField}
	        });
		</script>
	</body>
</html>
