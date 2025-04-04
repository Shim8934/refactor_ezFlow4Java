<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberGAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ApprovUI_Cross.js')}"></script>
 		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezAproveAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
		<script type="text/javascript" src="${webHWPUrl}js/hwpctrlapp/utils/util.js"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/hwpCtrlApp.js')}"></script>
    	<script type="text/javascript" src="${webHWPUrl}js/webhwpctrl.js"></script>
    	
    	<%-- 2023-12-07 홍승비 - 결재 서명 데이터를 DB(TBL_SIGNINFO)에서 가져와, 문서 상에 다시 그려주는(재맵핑) 함수 적용 --%>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprSignRedraw.js')}"></script>
		
	    <script language="javascript" type="text/javascript">
	    	var HwpCtrl;
	    	var useWebHWP = parent.useWebHWP;
	    	var frameNum = "<c:out value ='${frameNum}'/>"; // 프레임 번호
	    	var ListType = parent.ListType; // 임시저장 등 분기처리를 위한 ListType
	    	var docID = "<c:out value ='${docID}'/>"; // 재기안시 문서 id
	    	var docHref = "<c:out value ='${docHref}'/>"; // 사실상 양식의 formHref임
	    	var formID = ""; // 양식 ID
	    	var pUserID = "";
	    	var pingUserID = parent.pingUserID;
	    	var pDocID = "";
	    	var pCompanyID = parent.pCompanyID;
	    	var docState = parent.docState;
	    	var OrgAprUserID = parent.OrgAprUserID;
	        var OrgAprUserName = parent.OrgAprUserName;
	        var OrgAprUserName2 = parent.OrgAprUserName2;
	        var OrgAprUserDeptID = parent.OrgAprUserDeptID;
	        var pOrgAprUserID;
	        var pOrgAprUserName;
	        var pOrgAprUserName2;
	        var pOrgAprUserDeptID;
	    	var arr_userinfo = parent.arr_userinfo;
	    	var isUsed = parent.isUsed;
	    	var AprState = parent.AprState;
	    	var pAprLineType = parent.pAprLineType;
	    	var nonElecRec = "";
	    	var useOpenGov = parent.useOpenGov;
	    	var orgCompanyID = parent.orgCompanyID;
	    	var splitChar = "\x02";
			var xmlhttp		= createXMLHttpRequest();	
		    var xmldoc		= createXmlDom();
		    var xmlaprline	= createXmlDom();
		    var xmlattach	= createXmlDom();
		    var Resultxml   = createXmlDom();
		    var draftAllFlag = "Y";
		    var ext = "hwp";
	      
			var pDocHref = "";
			var pDraftFlag = "";
			var pDocType = "";
			var pSusinSN = "";
			var pDocState = "";
			var SignInfoFlag = "";
			var approvalFlag = "";
			
			/* 2023-04-20 홍승비 - 일괄기안된 문서는 모든 안에 대해 결재선이 동일하므로, 부모창의 값을 자식 프레임에서 그대로 사용 */
			var pModeForAllDocInfo = "APR";
			var pModeForAllAttachInfo = "APR";
			
			/* 2024-12-27 홍승비 - MHT 양식의 일괄기안 기능이 추가되며 발생한 사이드 이펙트 수정 (isHWP 변수 추가, 항상 Y) */
			var isHWP = "<c:out value ='${isHWP}'/>";
	    
	    	$(document).ready(function() {
	    		pDocHref = parent.pDocHrefAry[frameNum];
	            pDraftFlag = parent.pDraftFlag;
	            pDocType = parent.pDocTypeAry[frameNum];
	            pSusinSN = parent.pSusinSN;
	            pDocState = parent.docState;
	            SignInfoFlag = parent.SignInfoFlag;
	            DeptSymbol = parent.DeptSymbol;
	            approvalFlag = parent.approvalFlag;
	            pModeForAllDocInfo = parent.pModeForAllDocInfo;
	            pModeForAllAttachInfo = parent.pModeForAllAttachInfo;
	            
	            getApprovInfo(); // 양식id, 문서id, 문서제목, 첨부정보 등을 가져온다. 태그 XML 접근해서 거기에 값을 넣어줌
                getDocInfo(); // 문서정보, 원문정보공개 등의 정보를 가져와서 파라미터에 부여한다.
                setAttachInfoAll(parent.pDocIDAry[frameNum], pModeForAllAttachInfo, parent.document.getElementById("lstAttachLink")); // 각 안 별 첨부파일 플래그 세팅
                
                //GetExchInfo(); // 아무런 동작 없이 그냥 리턴된다.
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
	                	
						process_AfterOpen();
						
	                    // 현재 안 탭의 정보를 부모페이지에도 부여 (결과적으로는 로딩 완료 후 1안을 다시 선택하게 된다.)
	                    parent.setTabInfo(frameNum);
	                    setInitOpinion(); // 문서에 opinions 필드가 있는 경우, 각 안별 의견정보 셋팅 진행
	                    
	                    EditMode(0);
						SetViewProperties(2, 100);
	                    ScrollPosTop(100);
	                    
	                    // 부모창의 문서로딩완료 카운트를 하나 증가시킨다.
                    	parent.docLoadCompleteCnt ++;
                    	
                    	// 로딩된 문서의 전체 갯수가 재기안 시작 시 가져온 전체 안의 갯수와 일치한다면, addFlag 등을 변경시킨다.
                    	if (parent.docLoadCompleteCnt == (parent.pDocIDAry.length - 1)) {
                    		parent.titleOptionFlag = true;
                    		parent.contentOptionFlag = true;
                    		parent.attachOptionFlag = true;
                    		parent.docAttachOptionFlag = true;
                    		parent.seperateAttachOptionFlag = true;
                    		parent.opinionOptionFlag = true;
                    		parent.addFlag = true;
                    		
            	        	parent.HiddenMailProgress(); // 전부 완료 시 로딩중 이미지 제거
            	        	parent.CheckOpinionYN(1); // 모든 문서가 완료된 다음, 대표로 1안에 대해서만 의견 존재 여부를 확인하고, 레이어 팝업을 호출한다.
            	        	
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
	                alert("apprGdraftuiAllContent_WHWP.FieldsAvailable()  ::  " + e);
	            }
	        }
	
			function GetFormType(pFormID) {
			    try {
			    	var Result = "";
			    	
			        $.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		data : {
			    			formID : pFormID,
			    			companyID : pCompanyID
			    		},
			    		url : "/ezApprovalG/getFormDetail.do",
			    		success: function(xml){
			    			xml = loadXMLString(xml);
				            if (xml.getElementsByTagName("FORMDOCTYPE").length > 0) {
				                Result = xml.getElementsByTagName("FORMDOCTYPE").item(0).text;
				            }
			    		}        			
			    	});

			        return Result;
			
			    } catch (e) {
			        alert("apprGdraftuiAllContent_WHWP.jsp > GetFormType()::" + e.description);
			    }
			}
	
			function process_AfterOpen() {
			    try {
			    	// 최초 결재선 확인 및 서명칸 체크 동작은 한번만 수행하면 된다. (모든 안에서 결재선이 동일하므로)
			    	// 버튼 제어 동작도 한번만 동작시킨다.
			    	if (parent.docLoadCompleteCnt == 0) { // 최초 1안 로딩완료 이전에 한번만 동작해야 하므로
			    		pDocID = parent.pDocIDAry[frameNum];
						parent.getCurApproverAprLine(); // 결재선 갯수, 서명칸, 최종결재자 번호 등을 가져오는 부분 (모든 결재선이 동일하므로 사실상 1안의 pDocID를 전달)
					    parent.pGubun = "8";
					    
					    // 부모창의 버튼 및 구분값 제어
					    if (pAprLineType == strAprType2 || pAprLineType == strAprType7 || pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
					        setMenuBar("btntotaldocinfo", false);
					        setMenuBar("btnJunKyul", false);
					        setMenuBar("btnModAprLine", false);
					        setMenuBar("btnEdit", false);
					        setMenuBar("btnDocInfo", false);
					        setMenuBar("btnFileAttach", false);
					        setMenuBar("btnAprDocAttach", false);
					      //  setMenuBar("btnModAprDept", false);
					        setMenuBar("btnSetTaskCode", false);
					        setMenuBar("btnAddSepAttach", false);
					        parent.pGubun = "10";
					    }
					    else if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
					    	setMenuBar("btnModAprLine", false);
					    	parent.pGubun = "5";
					    }
					
					    if (parent.KuyjeType == "001") {
					    	parent.setBtnDisableAprLineType();
					    }
			    	}
				    
			    	// 이 분기부터는 각 안에 대하여 수신결재선을 체크하고 배열에 값을 부여하므로, 각 안에 대해 전부 돌게 한다.
//				    if (pDraftFlag == "SUSIN") {
				    	// 일괄기안문서는 편집 불가능 + 수신문서 접수 시에는 단일 문서 접수이므로 일괄기안 결재창에서 pDraftFlag가 SUSIN이 되는 경우도 없음
/* 				        if (FieldExist("susinbody"))
				        	setMenuBar("btnEdit", true);
				        else
				        	setMenuBar("btnEdit", false); */
				
/* 				
				        setMenuBar("btnModAprDept", false);
				        setMenuBar("btnFileAttach", false);
				        setMenuBar("btnAprDocAttach", false);
				        parent.pGubun = "6";
				    }
				    else { */
				    
			    	/* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
				    // 일괄기안 웹한글문서는 내부결재가 완료되면 각 안 별로 분리되며, 부서수신함의 수신문도 단일 문서로 접근하게 된다.
			        startRemapAllAprSign_WHWP(parent.pDocIDAry[frameNum], orgCompanyID);
				    
			        pSuSinFlag = "N";
			        
			        var RtnVal = FieldExist("recipient");
			        if (RtnVal) {
			            pSuSinFlag = "Y";
			            parent.pSuSinFlagAry[frameNum] = "Y";
			            //setMenuBar("btnModAprDept", true); // 수신자 단독설정 버튼. 사실상 .aspx로 이어지는 구현 안된 기능이므로, 제거한다.
			        } else {
			            pSuSinFlag = "N";
			            parent.pSuSinFlagAry[frameNum] = "N";
			            //setMenuBar("btnModAprDept", false);
			            if (parent.pGubun == "5") {
			            	parent.pGubun = "7";
			            }
			            else {
			            	parent.pGubun = "6";
			            }
			        }
			
			        if (pDraftFlag == "HABYUI") {
			        	setMenuBar("btntotaldocinfo", false);
			        }
			//		}
			    	
				} catch (e) {
					console.log(e);
				    alert("apprGdraftuiAllContent_WHWP.jsp > process_AfterOpen()  ::  " + e);
				}
			}
			
			// 부모창에 접근해서 display 스타일을 변경함
			function setMenuBar(id, flag) {
			    var display_Value;

			    if (flag) {
			        display_Value = "";
			    } else {
			        display_Value = "none";
			    }
			    
			    if (parent.document.getElementById(id) != null) {
			    	parent.document.getElementById(id).style.display = display_Value;
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

	        // 가져온 html이 어느 안의 데이터인지 알 수 있도록 ...
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
			 
	        // 분리첨부 복사 시 자식 프레임에 접근하여 함수를 호출하게 된다.
			function GetSepAttParamXml(g_SepAttachLVXml) {
				try {
					var sepAtt, Data;
					var rtnXml = createXmlDom();
					var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
					
					if (g_SepAttachLVXml != "") {
						// 분리첨부 데이터가 중복된 sepattachlvxml 태그를 가지지 않도록 수정 (원인 분석이 어려워 하드코딩으로 수정함)
						g_SepAttachLVXml = g_SepAttachLVXml.replace("<sepattachlvxml xmlns=\"http://www.w3.org/1999/xhtml\"><sepattachlvxml", "<sepattachlvxml");
						g_SepAttachLVXml = g_SepAttachLVXml.replace("<sepattachlvxml><sepattachlvxml", "<sepattachlvxml");
						g_SepAttachLVXml = g_SepAttachLVXml.replace("</sepattachlvxml></sepattachlvxml>", "</sepattachlvxml>");
						
						var sepLVXml = createXmlDom();
						sepLVXml = loadXMLString(g_SepAttachLVXml);
						
						var pRows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");
						if (pRows) {
							for (var i = 0; i < pRows.length; i++) {
 				                sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID",	SelectSingleNodeValue(pRows.item(i).childNodes[0], "DATA1"));
		                		Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", 	SelectSingleNodeValue(pRows.item(i).childNodes[1], "VALUE"));
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE",	SelectSingleNodeValue(pRows.item(i).childNodes[4], "VALUE"));
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", 	SelectSingleNodeValue(pRows.item(i).childNodes[0], "DATA2"));
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY",	SelectSingleNodeValue(pRows.item(i).childNodes[6], "VALUE"));
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE",	SelectSingleNodeValue(pRows.item(i).childNodes[0], "DATA3"));
				            }
						} else {
							var oRows = sepLVXml.getElementsByTagName("ROW");
							for (var i = 0; i < oRows.length; i++) {
								sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
		            			Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA1"));
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[1], "VALUE"));
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(GetChildNodes(oRows[i])[4], "VALUE"));
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA2"));
				                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[6], "VALUE"));
			                	Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA3"));
							}
						}
					}
					
					return getXmlString(rtnXml);
				} catch (e) {
					alert("apprGdraftuiAllContent_WHWP.jsp > GetSepAttParamXml() : " + e.description);
					console.log(e);
				}
			}
	        
	        //  각 안에 맞는 배열 인덱스에 데이터를 삽입하기 위한 함수 분리 (원본 함수 ApprovUI_Cross.js에 존재함)
			function getApprovInfo() {
			    try {
			        pOrgAprUserID = OrgAprUserID;
			        pOrgAprUserName = OrgAprUserName;
			        pOrgAprUserName2 = OrgAprUserName2;
			        pOrgAprUserDeptID = OrgAprUserDeptID;
			        pUserID = pOrgAprUserID;
			        parent.pUserID = pUserID;
			       
			        /* 2023-04-20 홍승비 - 각 안별 탭 생성 및 웹에디터 로딩 이전, 순차실행이 보장되도록 결재문서 데이터를 가져와 각 안이 사용할 수 있게 분리 */
			    	var result = loadXMLString(parent.pDocInfoAry[frameNum]);
			    	
			        var xmlpara = createXmlDom();
			        var pdocXML;
			
			        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/DOCINFO");
			        var xmlString = getXmlString(pdocXML);
			        xmlpara = loadXMLString(xmlString);
			        document.getElementById("DOCINFO").dataSource = xmlpara;
			
			        parent.pFormIDAry[frameNum] = getNodeText(SelectSingleNodeNew(xmlpara, "DOCINFO/DATA/FORMID"));
			        parent.pOrgDocIDAry[frameNum] = getNodeText(SelectSingleNodeNew(xmlpara, "DOCINFO/DATA/ORGDOCID"));
			
			        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/ATTACHINFO");
			        xmlString = getXmlString(pdocXML);
			        xmlpara = loadXMLString(xmlString);
			        document.getElementById("ATTACHINFO").dataSource = xmlpara;
			
			        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/APRLINEINFO");
			        xmlString = getXmlString(pdocXML);
			        xmlpara = loadXMLString(xmlString);
			        document.getElementById("APRLINEINFO").dataSource = xmlpara;
			
			        var dataNodes = GetElementsByTagName(xmlpara, "DATA6");
			        var lastIdx = dataNodes.length;
			        
			        parent.drafterDeptid = getNodeText(dataNodes[lastIdx - 1]);
			        parent.aprDocTimeStamp = getNodeText(SelectSingleNodeNew(result, "APROVEDATA/APRDOCTIMESTAMP"));
			
			        pdocXML = SelectSingleNodeNew(result, "APROVEDATA/DOCFLAGINFO");
			        xmlString = getXmlString(pdocXML);
			        xmlpara = loadXMLString(xmlString);
			
			        var node = GetElementsByTagName(xmlpara, "DocHref");
			        pDocHref = getNodeText(node[0]); // 이미 pDocHrefAry[]에는 값이 들어가있다. 이 페이지 내부에서 쓸 수있도록 지정해줌
			        var node = GetElementsByTagName(xmlpara, "DocFlag");
			        pDraftFlag = getNodeText(node[0]); // DRAFT로 고정
			
			        var doctitle = GetElementsByTagName(result, "DOCTITLE");
			        parent.pDocTitleAry[frameNum] = doctitle[0].textContent;
			
			        var docflagnode = GetElementsByTagName(xmlpara, "DocFlagValue");
			        switch (trim(pDraftFlag)) {
			            case "DRAFT":
			                pDocType = getNodeText(docflagnode[0]);
			                parent.pDocTypeAry[frameNum] = pDocType; // 각 양식별 타입 지정 (내부결재, 수신문, 시행문....)
			                break;
			                
			            case "GONGRAM":
			            	approvalType = "GONRAM";
			                pOrgDocID = getNodeText(docflagnode[0]);
			                parent.pOrgDocIDAry[frameNum] = pOrgDocID;
			                GetChildNodes(document.getElementById("btnApprove"))[0].innerHTML = strLang10;
			                setMenuBar("btnJunKyul", false);
			                break;
			                
			            case "CHAMJO":
			            	approvalType = "CHAMJO";
			                pOrgDocID = getNodeText(docflagnode[0]);
			                parent.pOrgDocIDAry[frameNum] = pOrgDocID;
			                GetChildNodes(document.getElementById("btnApprove"))[0].innerHTML = strLang10;
			                setMenuBar("btnJunKyul", false);
			                setMenuBar("btnReject", false);
			                setMenuBar("btnStay", false);
			                setMenuBar("btnOpinion", true); // 2019-04-02 천성준 - 참조자가 작성된 의견은 확인이 가능하기에 의견 버튼 표출 
			                setMenuBar("btnFileAttach", false);
			                setMenuBar("btnAprDocAttach", false);
			                setMenuBar("btnEdit", false);
			                break;
			                
			            case "HABYUI":
			            	approvalType = "HABYUI";
			                setMenuBar("btnEdit", false);
			                setMenuBar("btnModAprDept", false);
			                setMenuBar("btnFileAttach", false);
			                setMenuBar("btnAprDocAttach", false);
			                break;
			                
			            case "SUSIN":
			            	approvalType = "SUSIN";
			                pOrgDocID = getNodeText(docflagnode[0]);
			                parent.pOrgDocIDAry[frameNum] = pOrgDocID;
			                break;
			                
			            case "GAMSA":
			            	approvalType = "GAMSA";
			                setMenuBar("btnApprove", true);
			                setMenuBar("btnReject", false);
			                setMenuBar("btnStay", false);
			                setMenuBar("btnJunKyul", false);
			                setMenuBar("btnModAprLine", false);
			                setMenuBar("btnModAprDept", false);
			                setMenuBar("btnAprDocAttach", false);
			                setMenuBar("btnEdit", false);
			                setMenuBar("btnFileAttach", false);
			                break;
			                
			            case "B_GAMSA":
			            	approvalType = "B_GAMSA";
			                setMenuBar("btnApprove", true);
			                setMenuBar("btnReject", true);  // 부서감사 유형 감사부서에서 반송 가능하도록 수정. 2020-02-28 홍대표
			                setMenuBar("btnStay", false);
			                setMenuBar("btnJunKyul", false);
			                setMenuBar("btnModAprLine", false);
			                setMenuBar("btnModAprDept", false);
			                setMenuBar("btnAprDocAttach", false);
			                setMenuBar("btnEdit", false);
			                setMenuBar("btnFileAttach", false);
			                break;
			        }
			    } catch (e) {
			    	console.log(e);
			        alert("getApprovInfo :: " + e.description);
			    }
			}
	        
	        // 각 안에 맞는 배열 인덱스에 데이터를 삽입하기 위한 함수 분리
	        function getDocInfo() {
			    try {
			        xmldoc = document.getElementById("DOCINFO").dataSource; // 결재 시 해당 전역변수를 같이 사용할 수 있도록 지정
			        var APRSTATE = GetElementsByTagName(xmldoc, "FUNCTIONTYPE");
			        if (getNodeText(APRSTATE[0]) == strAprState5) { // 보류된 문서인 경우, 보류버튼 숨김처리
			            setMenuBar("btnStay", false);
			        }
			        
			        var opinionNode = GetElementsByTagName(xmldoc, "HASOPINIONYN");
			        var pHasOpinionYN = getNodeText(opinionNode[0]);
			        if (pHasOpinionYN == "Y" || pHasOpinionYN == "O") {
			        	parent.pHasOpinionYNAry[frameNum] = "Y";
			        } else {
			        	parent.pHasOpinionYNAry[frameNum] = "N";
			        }
			
			        var objNodes = xmldoc.documentElement.childNodes;
			        if (objNodes) {
			        	// 모든 안에서 공통인 문서정보이므로 최초 안 로딩 시 한번만 동작
			        	if (parent.docLoadCompleteCnt == 0) {
				        	parent.tempKeep = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/STORAGEPERIOD");
				        	parent.tempPublic = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ISPUBLIC");
				        	parent.tempUrgent = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/URGENTAPPROVAL");
				        	parent.tempKeyword = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/KEYWORD");
				        	parent.tempItemCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMCODE");
				        	parent.tempSecurity = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SECURITYCODE");
				        	parent.tempItemName = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMNAME");
				        	parent.tempItemName2 = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/ITEMNAME2");
				        	parent.tempSecurityDate = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SECURITYAPPROVAL");
				        	parent.pPublicityCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PUBLICITYCODE");
				        	parent.pPublicityYN = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PUBLICITYYN");
				        	parent.pLimitRange = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/LIMITRANGE");
				        	parent.pSummery = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SUMMARY");
				        	parent.pPageNum = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/PAGENUM");
				        	parent.TaskCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/TASKCODE");
				        	parent.cabinetID = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/CABINETID");
				        	parent.pSpecialRecordCode = SelectSingleNodeValueNew(xmldoc, "DOCINFO/DATA/SPECIALRECORDCODE");
			        	}
			        	
			        	// 각 안의 첨부파일 공개여부(fileOpenFlagListArr)도 함께 세팅
			            if (useOpenGov == "YES") {
			            	parent.basis = SelectSingleNodeValueNew(xmldoc, "DATA/BASIS");
			            	parent.reason = SelectSingleNodeValueNew(xmldoc, "DATA/REASON");
			            	parent.listOpenFlag = SelectSingleNodeValueNew(xmldoc, "DATA/LISTOPENFLAG");
			            	parent.fileOpenFlagList = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
			            	parent.fileOpenFlagListArr[frameNum] = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
			            	parent.limitDate = SelectSingleNodeValueNew(xmldoc, "DATA/LIMITDATE");
			            }
			        }
			    } catch (e) {
			    	console.log(e);
			        alert("getDocInfo :: " + e.description);
			    }
			}
	        
	        // 각 안 별 의견정보 세팅을 위해 함수 분리 (opinions 필드 존재 시에만 동작)
	        function setInitOpinion() {
	        	if (FieldExist("opinions")) {
	        		try {
	        			var result = "";
	        			var firstFlag = true;
	        			var strOpinion = " ";
	        			
	        			$.ajax({
	        				type : "POST",
	        				dataType : "text",
	        				async : false,
	        				url : "/ezApprovalG/opinionRequest.do",
	        				data : {
	        					docID : parent.pDocIDAry[frameNum],
	        					orgCompanyID : orgCompanyID,
								state : pDocState
	        				},
	        				success: function(xml) {
	        					result = xml;
	        				}        			
	        			});

	        			var OpinionXML = loadXMLString(result);
	        			var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
	        			PutFieldText("opinions", "");
	        			
	        			if (NodeList.length > 0) {
	        				for (i = NodeList.length - 1; i >=  0; i--) {
	        					if (firstFlag) {
	        						strOpinion = "[" + strLang27;
	        						firstFlag = false;
	        					}
	        					
	        					if (getNodeText(GetChildNodes(NodeList[i])[2]) != "") { // 직위
	        					    strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[2]) + "\11";  
	        					} else {
	        						strOpinion = strOpinion + "   \11";  
	        					}
	        					
	        					strOpinion = strOpinion + getNodeText(GetChildNodes(NodeList[i])[1]) + "\11"; // 이름
	        					strOpinion = strOpinion + getNodeText(GetChildNodes(GetChildNodes(NodeList[i])[0])[3]) + "\15"; // 의견내용
	        				}
	        				PutFieldText("opinions", strOpinion);
	        			}
	        		} catch (e) {
	        			alert("setInitOpinion :: " + e.description);
	        		}
	        	}
	        }
			 
	    </script>
	</head>
	<body>
	    <div id="hwpContent" style="height: 100%;"></div>
		<xml id="ATTACHINFO"></xml>
	    <xml id="DOCINFO"></xml>
	    <xml id="APRLINEINFO"></xml>
	</body>
</html>