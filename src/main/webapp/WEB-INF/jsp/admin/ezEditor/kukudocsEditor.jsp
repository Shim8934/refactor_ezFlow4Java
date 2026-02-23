<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
	<head>
		<title></title>
	    <link rel="stylesheet" href="${util.addVer('/js/ezEditor/kukudocsEditor/stylesheets/kk_webEditor_min.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-1.9.1.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/externalLib/jquery-ui-1.11.4.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEditor/kukudocsEditor/javascripts/build/Editor.bundle.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style> html, body {height: 100%; margin: 0; padding: 0;} </style>
		<script type="text/javascript">
			var type = "<c:out value='${type}'/>";
			var height = "<c:out value='${height}'/>";
			
			function Editor_Complete() {
				parent.Editor_Complete();
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
                	parent.Attribute_Write("");
                	
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
						case "receiptnumber":
	                        var CheckCount = 0;
	                        var HtmlTag = GetElementsByTagName(kukudocsEditor.getContentViewElement()[0], "*");
	                        for (var i = 0 ; i < HtmlTag.length; i++) {
	                            if (GetAttribute(HtmlTag[i], "id") == "receiptnumber")
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
		    		lang = "cn";
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
								   'template','heading','fontFamily','fontSize','line_height','bold','italic','underline','strikeThrough','remove_format','color','backgroundColor', 'border_visualize',
								   'cell_lock', 'table_lock'];
			
			// 이미지 업로드 URL 설정
			var imageUploadURL = "/ezEditor/kukudocsUpload.do?type=" + type;
			
			// 디폴트 폰트 설정
			var defaultFontFamily = "${defaultFontFamily}";
			var defaultFontSize = "${defaultFontSize}";
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
			
			// 템플릿 설정
			var templateList = [{
				name : 'Default Template', 
				items : [{name : 'Meeting log', type : 'url', value : '/js/ezEditor/kukudocsEditor/template/meeting_log.html'},
						 {name : 'Report', type : 'url', value : '/js/ezEditor/kukudocsEditor/template/report.html'},
						 {name : 'Vacation', type : 'url', value : '/js/ezEditor/kukudocsEditor/template/vacation.html'}]
			}];
			
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
	            useMenuBar : true,
	            useHTMLMode : useHTMLMode,
	            useTextMode : false,
	            usePreviewMode : false,
	            useEditorResize : false,
	            useFirstFocus : false,
	            useOnlyTableContentMenu : true,
	            useNoneBorderVisualize : true,
	            publicPathURL : '/js/ezEditor/kukudocsEditor/',
	            templateList : templateList,
	            defaultEditorStylePath :'/js/ezEditor/kukudocsEditor/stylesheets/editor_style.css',
	            loadingImageURL : '/js/ezEditor/kukudocsEditor/images/load.gif',
	            errorImageURL : '/js/ezEditor/kukudocsEditor/images/error.png',
	            imageUploadURL : imageUploadURL,
	            Editor_Complete : Editor_Complete,
	            Key_event : { keyup : CellCheckField },
	            Mouse_event : { click : CellCheckField},
	            useLockMenu : true,
	            cell_lock_name : 'cell_lock',
	            lockImageURL : '/images/lock.png',
	            colorPicker : colorPicker
	        });
		</script>
	</body>
</html>
