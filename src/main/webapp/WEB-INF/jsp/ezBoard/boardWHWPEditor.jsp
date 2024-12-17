<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${webHWPUrl}js/hwpctrlapp/utils/util.js"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/hwpCtrlApp.js')}"></script>
    	<script type="text/javascript" src="${webHWPUrl}js/webhwpctrl.js"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
		    var HwpCtrl;
	        var splitChar = "\x02";
	        var type = "${type}"

	        function Resize(pHeight) {
	            document.getElementById("hwpctrl_frame").style.width = "100%";
	            document.getElementById("hwpctrl_frame").style.height = pHeight;
	        }
	
		    window.onload = function () {
		    	if (type == "new") {
		    		HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${webHWPUrl}", function () { Editor_Complete(); });
		    	} else if (type == "modify" || type == "boardContent" || type == "temp" || type == "reply") {
		    		HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${webHWPUrl}", function () { Editor_Modify_Complete(); });
		   		} else if (type == "preview") {
		   			HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${webHWPUrl}", function () { Editor_Preview_Complete(); });
		   		} else if (type == "form") {
		   			HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${webHWPUrl}", function () { Editor_Form_Complete(); });
		   		} else {	
		    		HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${webHWPUrl}", function () { Editor_Complete(); });
		    	}
		    }
		    
	        function Editor_Complete() {
	           // 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
				if (typeof (parent.Editor_Complete) != "undefined") {
					parent.Editor_Complete();
				} else {
					if (typeof (parent.Editor_Complete) != "undefined") {
						parent.Editor_Complete();
					} else {
						setTimeout(Editor_Complete, 100);
					}
				}
			}
	        
	       	function Editor_Modify_Complete() {
				if (typeof (parent.Editor_Modify_Complete) != "undefined") {
	            	   parent.Editor_Modify_Complete();
	            } else {
					if (typeof (parent.Editor_Modify_Complete) != "undefined") {
						parent.Editor_Modify_Complete();
					} else {
						setTimeout(Editor_Modify_Complete, 100);
					}
				}
	       	}
	       	
	       	function Editor_Preview_Complete() {
	       		if (typeof (parent.Editor_Preview_Complete) != "undefined") {
	            	   parent.Editor_Preview_Complete();
	            } else {
					if (typeof (parent.Editor_Preview_Complete) != "undefined") {
						parent.Editor_Preview_Complete();
					} else {
						setTimeout(Editor_Preview_Complete, 100);
					}
				}
	       	}
	       	
	       	function Editor_Form_Complete() {
	       		if (typeof (parent.Editor_Form_Complete) != "undefined") {
	            	   parent.Editor_Form_Complete();
	            } else {
					if (typeof (parent.Editor_Form_Complete) != "undefined") {
						parent.Editor_Form_Complete();
					} else {
						setTimeout(Editor_Form_Complete, 100);
					}
				}
	       	}
		
	        function Open(url, format, type, callback, name) {
	            return HwpCtrl.Open(url, format, type, callback, name);
	        }

	        function SaveFile(filename, format, callback) {
	            HwpCtrl.SaveDocument(filename, format, callback);
	        }

	        function PrintDocument() {
	            HwpCtrl.PrintDocument();
	        }

	        function Clear() {
	            HwpCtrl.Clear(1);
	        }

	        function EditMode(option) {
	            HwpCtrl.EditMode = option;
	        }

	        function GetTextFile(format, option, callback) {
	            HwpCtrl.GetTextFile(format, option, callback);
	        }

	        function SetTextFile(data, format, option, callback) {
	            HwpCtrl.SetTextFile(data, format, option, callback);
	        }

	        function Insert(url, format, callback) {
	            return HwpCtrl.Insert(url, format, "", callback, "");
	        }

	        function OpenDocument(url, format, callback) {
	            return HwpCtrl.OpenDocument(url, format, callback);
	        }

	        function InsertDocument(url, callback) {
	            return HwpCtrl.InsertDocument(url, callback);
	        }

	        function InsertBackgroundPicture(bordertype, path, embedded, filloption, watermark, effect, brightnss, contrast) {
	            return HwpCtrl.InsertBackgroundPicture(bordertype, path, embedded, filloption, watermark, effect, brightnss, contrast);
	        }

	        function InsertPicture(field, path, callback) {
	            HwpCtrl.MoveToField(field);
	            HwpCtrl.InsertPicture(path, true, 0, false, false, 0, 0, 0, callback)
	        }

	        function GetFieldList(number, option) {
	            return HwpCtrl.GetFieldList(number, option).split(splitChar);
	        }

	        function FieldExist(field) {
	            return HwpCtrl.FieldExist(field);
	        }

	        function GetFieldText(field) {
	            return HwpCtrl.GetFieldText(field);
	        }

	        function PutFieldText(field, text) {
	            if (text == "")  //2020.07.13 웹한글기안기는 ""로 데이터 클리어 안됨
	                text = " ";

	            HwpCtrl.PutFieldText(field, text);
	        }

	        function AppendFieldText(field, text) {
	            var iText = HwpCtrl.GetFieldText(field) + text;
	            HwpCtrl.PutFieldText(field, iText);
	        }

	        function PrependFieldText(field, text) {
	            var iText = text + HwpCtrl.GetFieldText(field);
	            HwpCtrl.PutFieldText(field, iText);
	        }

	        function AppendFieldText(pFieldName, pFieldText, pAppendSart, pHwpFormat, pDeleteContent, callback) {
	            if (pDeleteContent)
	                SetFieldText(pFieldName, "")

	            if (HwpCtrl.MoveToField(pFieldName, true, pAppendSart)) {
	                if (typeof (callback) == "undefined") {
	                    if (pHwpFormat)
	                        HwpCtrl.SetTextFile(pFieldText, "HTML", "insertfile");
	                    else
	                        HwpCtrl.SetTextFile(pFieldText, "UNICODE", "insertfile");
	                }
	                else {
	                    if (pHwpFormat)
	                        HwpCtrl.SetTextFile(pFieldText, "HTML", "insertfile", function (data) { callback(data) });
	                    else
	                        HwpCtrl.SetTextFile(pFieldText, "UNICODE", "insertfile", function (data) { callback(data) });
	                }
	            }        
	        }

	        function SetFieldText(pFieldName, pFieldText, pFontSize, pBold, pColor, pUnderline, pItalic) {
	            if (pFieldText != "") {
	                HwpCtrl.PutFieldText(pFieldName, pFieldText);

	                if (HwpCtrl.MoveToField(pFieldName)) {
	                    HwpCtrl.Run("SelectAll");
	                    var HwpSet = HwpCtrl.CharShape;

	                    if (pBold)
	                        HwpSet.SetItem("Bold", true);

	                    if (pColor != -1)
	                        HwpSet.SetItem("TextColor", pColor);

	                    if (pFontSize != -1)
	                        HwpSet.SetItem("Height", pFontSize * 100);

	                    if (pUnderline != -1) {
	                        HwpSet.SetItem("UnderlineType", pUnderline)

	                        if (pColor != -1)
	                            HwpSet.SetItem("UnderlineColor", pColor);
	                    }

	                    if (pItalic) {
	                        HwpSet.SetItem("Italic", true);
	                    }

	                    HwpCtrl.CharShape = HwpSet;

	                    HwpCtrl.MoveToField(pFieldName);
	                }
	            } else {
	                if (HwpCtrl.MoveToField(pFieldName))
	                    HwpCtrl.PutFieldText(pFieldName, String.fromCharCode(2));
	            }
	        }
	  


	        function MoveToField(field) { //선택한 필드로 캐럿 이동
	            HwpCtrl.MoveToField(field, true, true, false);
	        }

	        function MoveToFieldEx(field) { //선택한 필드로 캐럿, 화면 이동
	            HwpCtrl.MoveToFieldEx(field, true, true, false);
	        }

	        function ScrollPosInfo(HorzPos, VertPos) { //스크롤바 위치
	            var ScrollPosSet;
	            ScrollPosSet = HwpCtrl.ScrollPosInfo;
	            ScrollPosSet.SetItem("HorzPos", HorzPos);
	            ScrollPosSet.SetItem("VertPos", VertPos);
	            HwpCtrl.ScrollPosInfo = ScrollPosSet;
	        }        

	        function SetToolBar(option, ToolBarID) { //툴바 설정
	            HwpCtrl.SetToolBar(option, ToolBarID);
	        }

	        function ShowToolBar(option) { //툴바 표시
	            HwpCtrl.ShowToolBar(option);
	        }

	        function ShowRibbon(option) { //리본 표시
	            HwpCtrl.ShowRibbon(option);
	        }
	        //필드내용을 복사하기위해 내용을 TEXT로 받아온다.(필드명이 없을경우 문서전체의 내용을 받아온다)
	        function GetCloneData(pFieldName, pDataType, callback) {
	            var FieldInfo;
	            if (pFieldName != "") {
	                HwpCtrl.MoveToField(pFieldName);
	                FieldInfo = GetCurrentFieldInfo(0, false);
	                var array = FieldInfo.split(';')
	                if (array.length > 1 && array[1] == "2") {
	                    HwpCtrl.MoveToField(pFieldName, true, true, true);
	                    HwpCtrl.GetTextFile(pDataType, "saveblock", callback);
	                }
	                else {
	                    var act;
	                    act = HwpCtrl.CreateAction("SelectAll");
	                    act.Run();
	                    HwpCtrl.GetTextFile(pDataType, "saveblock", callback);
	                }
	            } else {
	            	var act;
                    act = HwpCtrl.CreateAction("SelectAll");
                    act.Run();
                    HwpCtrl.GetTextFile(pDataType, "saveblock", callback);
	            }          
	        }

	        function GetCurrentFieldInfo(pFieldOption, pXmlFormat) {
	            var FieldName;
	            var FieldType;
	            var FieldAccess;
	            var FieldState;

	            FieldName = HwpCtrl.GetCurFieldName(pFieldOption);
	            FieldState = HwpCtrl.CurFieldState;

	            if (FieldState != "" && (FieldState & 16)> 0) {
	                if ((FieldState & 15) == 1) {
	                    FieldType = "1";  //셀
	                } else {
	                    FieldType = "2";  //누름틀                
	                }
	                FieldAccess = HwpCtrl.ModifyFieldProperties(FieldName, 0, 0);
	                FieldAccess = FieldAccess & 1;
	            }

	            if (pXmlFormat) {
	                return "<DATA><NAME>" + MakeXMLString(FieldName) + "</NAME><TYPE>" + FieldType + "</TYPE><ACCESS>" & FieldAccess & "</ACCESS></DATA>";
	            } else
	                return FieldName + ";" + FieldType + ";" + FieldAccess;
	        }
	       
	        function GetDocumentInfo(pXmlFormat) {
	            var rtnVal;
	            var HwpAct;
	            var HwpSet;
	            HwpAct = HwpCtrl.CreateAction("DocSummaryInfo");
	            HwpSet = HwpCtrl.CreateSet("SummaryInfo");

	            HwpAct.GetDefault(HwpSet);          

	            if (typeof (pXmlFormat) == "undefined")
	                pXmlFormat = true;

	            if (pXmlFormat) {
	                rtnVal = "<DATA><TITLE>" + HwpSet.Item("Title") + "</TITLE>" +
	                    "<SUBJECT>" + HwpSet.Item("Subject") + "</SUBJECT>" +
	                    "<AUTHOR>" + HwpSet.Item("Author") + "</AUTHOR>" +
	                    "<DATE>" + HwpSet.Item("Date") + "</DATE>" +
	                    "<KEYWORD>" + HwpSet.Item("KeyWords")+ "</KEYWORD>" +
	                    "<COMMENT>" + HwpSet.Item("Comments") + "</COMMENT>" +
	                    "<CHARACTERS>" + HwpSet.Item("Characters") + "</CHARACTERS>" +
	                    "<WORDS>" + HwpSet.Item("Words") + "</WORDS>" +
	                    "<LINES>" + HwpSet.Item("Lines") + "</LINES>" +
	                    "<PARAGRAPHS>" + HwpSet.Item("Paragraphs") + "</PARAGRAPHS>" +
	                    "<PAGES>" + HwpSet.Item("Pages") + "</PAGES></DATA>";
	            }
	            else {
	                rtnVal = HwpSet.Item("Title") + "_kaoni_seperator_" +
	                    HwpSet.Item("Subject") + "_kaoni_seperator_" +
	                    HwpSet.Item("Author") + "_kaoni_seperator_" +
	                    HwpSet.Item("Date") + "_kaoni_seperator_" +
	                    HwpSet.Item("KeyWords") + "_kaoni_seperator_" +
	                    HwpSet.Item("Comments") + "_kaoni_seperator_" +
	                    HwpSet.Item("Characters") + "_kaoni_seperator_" +
	                    HwpSet.Item("Words") + "_kaoni_seperator_" +
	                    HwpSet.Item("Lines") + "_kaoni_seperator_" +
	                    HwpSet.Item("Paragraphs") + "_kaoni_seperator_" +
	                    HwpSet.Item("Pages") + "_kaoni_seperator_";
	            }
	            return rtnVal;
	        }

	        function SetDocumentInfo(pTitle, pSubject, pAuthor, pKeyword, pComment) {
	            var HwpAct;
	            var HwpSet;
	            HwpAct = HwpCtrl.CreateAction("DocSummaryInfo");
	            HwpSet = HwpCtrl.CreateSet("SummaryInfo");

	            HwpAct.GetDefault(HwpSet);     

	            if (pTitle != "NULL")
	                HwpSet.SetItem("Title", pTitle);

	            if (pSubject != "NULL")
	                HwpSet.SetItem("Subject", pSubject);

	            if (pAuthor != "NULL")
	                HwpSet.SetItem("Author", pAuthor);

	            if (pKeyword != "NULL")
	                HwpSet.SetItem("KeyWords", pKeyword);

	            if (pComment != "NULL")
	                HwpSet.SetItem("Comments", pComment);

	            HwpAct.Execute(HwpSet);

	        }

	        function SetCloneData(pCloneData, pFieldName, pDataType) {
	            var rtnval = false;
	            try {
	                if (pFieldName != "") {
	                    HwpCtrl.MoveToField(pFieldName)
	                    HwpCtrl.PutFieldText(pFieldName, String.fromCharCode(2));                  

	                    if (HwpCtrl.SetTextFile(pCloneData, pDataType, "insertfile")) {
	                        rtnval = true;                      
	                    }

	                } else {
	                    if (HwpCtrl.SetTextFile(pCloneData, pDataType, "")) {
	                        rtnval = true;                      
	                    }
	                }
	            }
	            catch (e) {}
	            return rtnval;
	        }

	        function SetCloneDataCallback(pCloneData, pFieldName, pDataType, callback) {
	          
	            try {
	                if (pFieldName != "") {
	                    HwpCtrl.MoveToField(pFieldName)
	                    HwpCtrl.PutFieldText(pFieldName, String.fromCharCode(2));

	                    HwpCtrl.SetTextFile(pCloneData, pDataType, "insertfile", callback)

	                } else {
	                    HwpCtrl.SetTextFile(pCloneData, pDataType, "", callback)
	                }
	            }
	            catch (e) { }
	           
	        }
	        //필드에 백그라운드 이미지를 넣거나 삭제하는 함수
	        function SetFieldBackImage(pFieldName, pImagePath, pFillOption) {
	            var rtnVal = false;

	            if (typeof (pFillOption) == "undefined")
	                pFillOption = 5;

	            if (pFieldName != "") {
	            	if (HwpCtrl.MoveToField(pFieldName)) {
		                if (pImagePath != "")
		                    HwpCtrl.InsertBackgroundPicture("SelectedCell", pImagePath, true, pFillOption, false, false, false, false);
		                else
		                    HwpCtrl.InsertBackgroundPicture("SelectedCellDelete", pImagePath, false, false, false, false, false, false);

		                rtnVal = true;
		            }
	            } else {
	            	if (pImagePath != "")
	                    HwpCtrl.InsertBackgroundPicture("SelectedCell", pImagePath, true, pFillOption, false, false, false, false);
	                else
	                    HwpCtrl.InsertBackgroundPicture("SelectedCellDelete", 0, 0, 0, 0, 0, 0, 0);

	                rtnVal = true;
	            }

	            return rtnVal;
	        }

	        //필드에 이미지를 추가하는 함수
	        function SetFieldImage(pFieldName, pImagePath, pSizeType, pWidth, pHeight, pTreatAsChar, pTextWrap) {
	            var embeded = true;
	            var reverse = false;
	            var watermark = false;
	            var effect = 0; //0:실제이미지그대로, 1:그레이스케일, 2:흑백효과
	            //pSizeType 0:원래크기, 1: width,height크기로, 2: width는 셀 width만큼 height는 셀height만큼, 3: 현제셀크기에 맞춰      
	         
	            if (pFieldName != "") {
	            	if (HwpCtrl.MoveToField(pFieldName)) {
		                if (pWidth == 0)
		                    HwpCtrl.InsertPicture(pImagePath, embeded, pSizeType, reverse, watermark, effect, 0);
		                else
		                    HwpCtrl.InsertPicture(pImagePath, embeded, pSizeType, reverse, watermark, effect, pWidth, pHeight);
		            }
	            } else {
	            	if (pWidth == 0)
	                    HwpCtrl.InsertPicture(pImagePath, embeded, pSizeType, reverse, watermark, effect, 0);
	                else
	                    HwpCtrl.InsertPicture(pImagePath, embeded, pSizeType, reverse, watermark, effect, pWidth, pHeight);
	            }
	        }


	        function ClearDocument() {
	            HwpCtrl.Clear(1); //문서 내용을 버린다
	        }

	        function MakeXMLString(pOrgString) {
	            if (typeof (pOrgString) == "undefined" || pOrgString == undefined) {
	                return "";
	            }
	            return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
	        }

	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }

	        function SaveAs(fileName) {
	            HwpCtrl.SaveAs(fileName, "");
	        }
	           
	       function SaveDocument(fileName, fileType, callback) {
	            HwpCtrl.SaveDocument(fileName, fileType, callback);
			}

			function WHWP_GetDocumentElement() {
				var retVal = new Array("", "", "");

				var whwpInfo = loadXMLString(GetDocumentInfo());
				var keywordStr = ConvertEntityReferenceToChar(getXmlString(SelectSingleNodeNew(whwpInfo, "DATA/KEYWORD")));
				var keywordXml = loadXMLString(keywordStr);

				var connXml = SelectNodes(keywordXml, "KEYWORD/CONNROOT/conn");
				if (connXml.length > 0) {
					var connXmlStr = getXmlString(SelectSingleNodeNew(keywordXml, "KEYWORD/CONNROOT"));
					retVal[0] = connXmlStr.replace(/<[/]?CONNROOT>/g, "").replace(/<\/conn></g, "</conn>\n<");
				}

				var workflow1Xml = SelectNodes(keywordXml, "KEYWORD/WORKFLOW/VALIDATIONS");
				if (workflow1Xml.length > 0) {
					var validXmlStr = getXmlString(SelectSingleNodeNew(keywordXml, "KEYWORD/WORKFLOW/VALIDATIONS"));
					retVal[1] = validXmlStr.replace(/<[/]?VALIDATIONS>/g, "").replace(/<\/VALIDATION></g, "</VALIDATION>\n<");
				}
				var workflow2Xml = SelectNodes(keywordXml, "KEYWORD/WORKFLOW/APRLINES");
				if (workflow2Xml.length > 0) {
					var aprlineXmlStr = getXmlString(SelectSingleNodeNew(keywordXml, "KEYWORD/WORKFLOW/APRLINES"));
					retVal[2] = aprlineXmlStr.replace(/<[/]?APRLINES>/g, "").replace(/<\/APRLINE></g, "</APRLINE>\n<");;
				}

				return retVal;
			}

			function WHWP_SetDocumentElement(connXmlStr) {
				connXmlStr = ConvertCharToEntityReference(connXmlStr);
				SetDocumentInfo("NULL", "NULL", "NULL", connXmlStr, "NULL");
			}

	        function FormInfoCheck(type) {
	            try {
	                switch (type) {
	                    case "null":
							return HwpCtrl.IsEmpty;
	                    default:
							var CheckCount = 0;
							var fieldList = encodeURIComponent(HwpCtrl.GetFieldList(2))
								.split("%02")
								.map(function(field) {
									return decodeURIComponent(field);
								});
	                        for (var i = 0, ilen = fieldList.length; i < ilen; i++) {
								var fieldInfo = fieldList[i].match(/\w+/g);
	                            if (fieldInfo[0] === type) {
									CheckCount = +fieldInfo[1];
									break;
								}
	                        }
	                        return CheckCount;
	                }
	            } catch (e) {
					alert("FormInfoCheck error");
	            }
			}
	        
	        function FoldRibbon(option) {
	        	HwpCtrl.FoldRibbon(option);
	        }
	        
	        function SetMargin(option) {
	        	var act = HwpCtrl.CreateAction("PageSetup");
	        	var set = act.CreateSet();
	        	act.GetDefault(set);
	        	set.SetItem("ApplyTo", 3); //적용범위 : 문서전체
	        	var pset = set.CreateItemSet("PageDef","PageDef");
	        	pset.SetItem("TopMargin", option);
	        	pset.SetItem("BottomMargin", option);
	        	pset.SetItem("LeftMargin", option);
	        	pset.SetItem("RightMargin", option);
	        	pset.SetItem("HeaderLen", 0);
	        	pset.SetItem("FooterLen", 0);
	        	pset.SetItem("GutterLen", 0);
	        	act.Execute(set)
	        }
	        
	        function createField(fieldName) {
	        	HwpCtrl.CreateField("", "", fieldName);
	        	MoveToField(fieldName);
	        	HwpCtrl.SetFieldViewOption(1);
	        }
	        
	        function deleteField(fieldName) {
	        	HwpCtrl.MoveToField(fieldName, false, true, true);
	        	HwpCtrl.Run("Delete");
	        }
	        
	        function moveTopOfFile() {
	        	HwpCtrl.MovePos(2, "", "");
	        }
	        
	        function moveEndOfFile() {
	        	HwpCtrl.MovePos(3, "", "");
	        }

			/**
			 * [View의 상태 정보]
			 * 조판 부호, 화면 확대 비율과 같은 view에 관련된 정보를 나타낸다. 
			 * ParameterSet의 형식은 ParameterSet/ViewProperties 참조.
			 * 	 - zoomType : 화면 확대 종류(0 - 사용자정의, 1 - 쪽맞춤, 2 - 폭맞춤, 3 - 여러쪽)
			 * 	 - zoomRatio : 화면 확대 비율(10 ~ 500 (단위 %)) - 화면 확대 종류가 "사용자 정의"인 경우만 사용가능
			 */
			function SetViewProperties(zoomType, zoomRatio) {
				var vp = HwpCtrl.CreateSet("ViewProperties");
				vp.SetItem("ZoomType", zoomType);		//	화면 확대 종류
				vp.SetItem("ZoomRatio", zoomRatio);		// 	화면 확대 비율
				HwpCtrl.ViewProperties = vp;
			}
		</script>
	</head>
	<body style="padding: 0; margin: 0;">
	    <div id="hwpctrl" style=" width:100%;" />
	</body>
</html>
