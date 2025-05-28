<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AprDocView_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${webHWPUrl}js/hwpctrlapp/utils/util.js"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/hwpCtrlApp.js')}"></script>
    	<script type="text/javascript" src="${webHWPUrl}js/webhwpctrl.js"></script>
    	
    	<%-- 2023-12-07 홍승비 - 결재 서명 데이터를 DB(TBL_SIGNINFO)에서 가져와, 문서 상에 다시 그려주는(재맵핑) 함수 적용 --%>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprSignRedraw.js')}"></script>
		
	    <script language="javascript" type="text/javascript">
	    	var HwpCtrl;
	    	var useWebHWP = parent.useWebHWP;
	    	var frameNum = "${frameNum}"; // 프레임 번호
	    	var ListType = parent.ListType; // 임시저장 등 분기처리를 위한 ListType
	    	var docID = "${docID}"; // 재기안시 문서 id
	    	var docHref = "${docHref}";
	    	var formID = ""; // 양식 ID
	    	var pUserID = "";
	    	var pingUserID = parent.pingUserID;
	    	var pDocID = "";
	    	var pCompanyID = parent.pCompanyID;
	    	var orgCompanyID = parent.orgCompanyID;
	    	var arr_userinfo = parent.arr_userinfo;
	    	var splitChar = "\x02";
			var pDocHref = "";
			var pDocType = "";
			var draftAllFlag = "Y";
			var ext = "hwp";
	    
	    	$(document).ready(function() {
	    		pDocHref = parent.pDocHrefAry[frameNum];
	            pDocType = parent.pDocTypeAry[frameNum];
	            
	            // 불필요한 함수 호출 제거 (실제로는 각 안 선택 시에만 필요한 함수이며, 문서보기 팝업창에서는 첨부/문서첨부의 존재여부 플래그를 배열로 관리할 필요가 없음)
                // setAttachInfo(parent.pDocIDAry[frameNum], "APR", parent.document.getElementById("lstAttachLink")); // 첨부파일 정보를 UI로 표출하고, 첨부파일 플래그도 변경해준다.
                parent.ShowMailProgress(); // 문서 로딩중 이미지 표출
                
                HwpCtrl = BuildWebHwpCtrl("hwpContent", "${webHWPUrl}", function () {Editor_Complete();});
                window.onresize();
			});
	      
	    	window.onresize = function () {Resize()};
	    	function Resize() {
	    		if (document.getElementById("hwpctrl_frame") != null && typeof(document.getElementById("hwpctrl_frame")) != "undefined") {
		    		var pHeight = (window.innerHeight - 20) + "px";
		            document.getElementById("hwpctrl_frame").style.width = "100%";
		            document.getElementById("hwpctrl_frame").style.height = pHeight;
	    		}
	        }
	      
	    	// 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
			function Editor_Complete() {
				if (typeof (parent.Editor_Complete) != "undefined") {
					parent.Editor_Complete("ifrm" + frameNum, pDocHref);
				} else {
					if (typeof (parent.Editor_Complete) != "undefined") {
						parent.Editor_Complete("ifrm" + frameNum, pDocHref);
					}
					else {
                       setTimeout(Editor_Complete, 100);
					}
				}
			}
	    	
	        function FieldsAvailable(isTrue) {
	            try {
	                if (isTrue) {
	                    // 현재 안 탭의 정보를 부모페이지에도 부여 (결과적으로는 로딩 완료 후 1안을 다시 선택하게 된다.)
	                    parent.setTabInfo(frameNum);
	                    //setInitOpinion(); // 문서에 opinions 필드가 있는 경우, 각 안별 의견정보 셋팅 진행
	                    
	                    EditMode(0);
						SetViewProperties(2, 100);
	                    ScrollPosTop(100);
	                    
	                    //  부모창의 문서로딩완료 카운트를 하나 증가시킨다.
                    	parent.docLoadCompleteCnt ++;
                    	
                    	/* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
    				    // 일괄기안 웹한글문서는 내부결재가 완료되면 각 안 별로 분리되며, 부서수신함의 수신문도 단일 문서로 접근하게 된다.
    			        startRemapAllAprSign_WHWP(parent.pDocIDAry[frameNum], orgCompanyID);
	                    
                    	// 로딩된 문서의 전체 갯수가 재기안 시작 시 가져온 전체 안의 갯수와 일치하는 경우
                    	if (parent.docLoadCompleteCnt == (parent.pDocIDAry.length - 1)) {
            	        	parent.HiddenMailProgress(); // 전부 완료 시 로딩중 이미지 제거
            	        	parent.CheckOpinionYN(); // 모든 문서가 완료된 다음, 대표로 1안에 대해서만 의견 존재 여부를 확인하고, 레이어 팝업을 호출한다.
            	        	setTimeout(function() {
            	        		parent.selTab(1); // 각 안을 전부 로딩한 뒤, 기본으로 1안을 선택하도록 한다.
    						}, parent.loadTime);
                    	}
	                } else {
	                	parent.HiddenMailProgress();
	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
	                    OpenAlertUI(pAlertContent);
	                    Clear();
	                }
 	            } catch (e) {
	                alert("apprGviewAprAllContent_WHWP.jsp.FieldsAvailable()  ::  " + e);
	            }
	        }
	        
/******************************* 웹한글기안기쪽 함수 ******************************/
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
	            HwpCtrl.MoveToField(field, true, false, false);
	            HwpCtrl.InsertPicture(path, true, 1, false, false, 0, 13, 7, callback);
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
	                text = "\n";

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
	        
	        function ScrollPosTop(time) {
				setTimeout(function() {
					var ScrollPosSet;
		            ScrollPosSet = HwpCtrl.ScrollPosInfo;
		            ScrollPosSet.SetItem("HorzPos", 0);
		            ScrollPosSet.SetItem("VertPos", 0);
		            HwpCtrl.ScrollPosInfo = ScrollPosSet;
					setTimeout(function() {
						ScrollPosInfo(0, 0);
					}, 100);
				}, time);
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

	            if (typeof (pXmlFormat) == "undefined") {
	            	pXmlFormat = true;
	            }

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

	            if (HwpCtrl.MoveToField(pFieldName)) {
	                if (pImagePath != "")
	                    HwpCtrl.InsertBackgroundPicture("SelectedCell", pImagePath, true, pFillOption, false, false, false, false);
	                else
	                    HwpCtrl.InsertBackgroundPicture("SelectedCellDelete", pImagePath, false, false, false, false, false, false);

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
	         
	            if (HwpCtrl.MoveToField(pFieldName)) {
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

////// 웹한글기안기 함수 끝 ////////

	    </script>
	</head>
	<body>
	    <div id="hwpContent" style="height: 100%;"></div>
		<xml id="ATTACHINFO"></xml>
	    <xml id="DOCINFO"></xml>
	    <xml id="APRLINEINFO"></xml>
	</body>
</html>