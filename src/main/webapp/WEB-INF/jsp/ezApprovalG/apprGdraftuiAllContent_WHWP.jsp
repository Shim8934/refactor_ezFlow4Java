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
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draft_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draftG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberGAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AutoAprLine_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezDraftAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
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
	    	var docHref = "${docHref}"; // 문서경로
	    	var formID = "${formID}"; // 양식 ID
	    	var pUserID = parent.pUserID;
	    	var pDocID = "";
	    	var arr_userinfo = parent.arr_userinfo;
	    	var isUsed = parent.isUsed;
	    	var AprState = parent.AprState;
	    	var nonElecRec = "";
	    	var useOpenGov = parent.useOpenGov;
	    	var orgCompanyID = parent.orgCompanyID;
	    	var splitChar = "\x02";
	    	var draftAllFlag = "Y";
			var ext = "hwp";
	      
			var pFormHref = "";
			var pDraftFlag = "";
			var pDocType = "";
			var pSusinSN = "";
			var pDocState = "";
			var SignInfoFlag = "";
			var approvalFlag = "";
			
			/* 2023-04-20 홍승비 - 일괄기안된 문서는 모든 안에 대해 결재선이 동일하므로, 부모창의 값을 자식 프레임에서 그대로 사용 */
			var pModeForAllDocInfo = "APR";
			var pModeForAllAttachInfo = "APR";
			var xmluserInfo = createXmlDom();

			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = '${useAprFilePrvw}';

			var attachedDocList;
			
			var junGyulFlag = "${junGyulFlag}";
			var draftJunGyulFlag = "${draftJunGyulFlag}";
			var isSplit = "${optisSplit}";

	    	$(document).ready(function() {
	    		// 1안 추가 시에 최초로 동작하는 부모창의 draftFlag 등 부여 함수
 	    		if (frameNum == "1") {
	    			parent.winOnload();
	    		} 
	    		
	    		pFormHref = parent.pFormHrefAry[frameNum];
	            pDraftFlag = parent.pDraftFlag;
	            pDocType = parent.pDocTypeAry[frameNum];

	            pSusinSN = parent.pSusinSN;
	            pDocState = parent.pDocState;
	            SignInfoFlag = parent.SignInfoFlag;
	            DeptSymbol = parent.DeptSymbol;
	            approvalFlag = parent.approvalFlag;
	            
	            pModeForAllDocInfo = parent.pModeForAllDocInfo;
	            pModeForAllAttachInfo = parent.pModeForAllAttachInfo;
	            xmluserInfo = parent.xmluserInfo;
	            
                parent.ShowMailProgress(); // 문서 로딩중 이미지 표출
                
                // 임시저장된 문서의 결재정보는 새로운 docId를 생성 후에 가져오는 방식으로 수정
                if (frameNum == "1" && parent.ListType == "21") {
                	parent.getLineModeAll(parent.pDocIDAry[1]); // 결재진행중/완료여부 체크
                	parent.getDocInfoAll(parent.pDocIDAry); // 결재문서 기본 정보
                	parent.getAttachInfoAll(parent.pDocIDAry); // 첨부파일 정보
                }
                
                HwpCtrl = BuildWebHwpCtrl("hwpContent", "${webHWPUrl}", function () {Editor_Complete();});
                window.onresize();
			});
	      
	    	window.onresize = function () {Resize()};
	    	function Resize() {
	    		var hwpCtrlIfrm = document.getElementById("hwpctrl_frame");
	    		if (hwpCtrlIfrm != null && typeof(hwpCtrlIfrm) != "undefined") {
		    		var pHeight = (window.innerHeight - 20) + "px";
		    		
		    		hwpCtrlIfrm.style.width = "100%";
		    		hwpCtrlIfrm.style.height = pHeight;
		            
		            /* 2022-03-14 홍승비 - 기안창이 축소된 상태에서 결재올림 실패 > 알러트 확인 후 탭 클릭(selTab) > iframe 내부 크기 style값이 0이 되는 오류 수정*/
		            var paperCanvas = hwpCtrlIfrm.contentWindow.document.getElementById("PaperCanvas");
					if (paperCanvas != null && typeof(paperCanvas) != "undefined") {
			    		var pWidth1 = paperCanvas.width + "px";
			    		var pHeight1 = paperCanvas.height + "px";
			    		
			    		paperCanvas.style.width = pWidth1;
			    		paperCanvas.style.height = pHeight1;
	    			}
		            
					var editCanvas = hwpCtrlIfrm.contentWindow.document.getElementById("EditCanvas");
					if (editCanvas != null && typeof(editCanvas) != "undefined") {
			    		var pWidth2 = editCanvas.width + "px";
			    		var pHeight2 = editCanvas.height + "px";
			    		
			    		editCanvas.style.width = pWidth2;
			    		editCanvas.style.height = pHeight2;
	    			}
					
					// 스크롤바 영역의 넓이는 hwpctrl_frame과 동일 (100%), 높이는 캔버스 영역과 동일
					var scrollDiv = hwpCtrlIfrm.contentWindow.document.getElementById("hcwoViewScroll");
					if (scrollDiv != null && typeof(scrollDiv) != "undefined" && paperCanvas != null && typeof(paperCanvas) != "undefined") {
			    		var pWidth3 = "100%";
			    		var pHeight3 = paperCanvas.height + "px";
			    		
			    		scrollDiv.style.width = pWidth3;
			    		scrollDiv.style.height = pHeight3;
	    			}
	    		}
	        }
	      
	    	// 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
			function Editor_Complete() {
				if (typeof (parent.Editor_Complete) != "undefined") {
					parent.Editor_Complete("ifrm" + frameNum, pFormHref);
				} else {
					if (typeof (parent.Editor_Complete) != "undefined") {
						parent.Editor_Complete("ifrm" + frameNum, pFormHref);
					}
					else {
                       setTimeout(Editor_Complete, 100);
					}
				}
			}

	    	var timeoutCnt = 0;
	        function FieldsAvailable(isTrue) {
	            try {
                    if(typeof DeptSymbol == "undefined"){
                        DeptSymbol = parent.DeptSymbol;
                        if(timeoutCnt++ == 6)
                            location.reload();
	                    setTimeout(function(){FieldsAvailable(isTrue)}, 500);
	                    return;
	                }
	                if (isTrue) {
	                	// 기안자 정보 xmluserInfo 변수는 onload 시 부모 페이지에서 가져온 값을 그대로 사용 (하단의 SetAutoPropertyValue에서 사용됨)
	                	// getDraftUserInfo();
	                	SetAutoPropertyValue(frameNum);
	                	
	                    process_AfterOpen();
	                    // 현재 안 탭의 정보를 부모페이지에도 저장
	                    parent.setTabInfo(frameNum);

						if (frameNum == 1 && attachedDocList != "" && pDraftFlag == "DRAFT" && ListType != "21") {
							var pd = parent.document;

							attachRecordDoc();
							pd.getElementById("ifrm" + frameNum).contentWindow.setAttachInfo(pDocID, "APR", pd.getElementById("lstAttachLink"));

							attachedDocList = "";
						}

	                    // 반송문서가 아닌 임시저장 문서의 경우, 안 추가 시 초기 고정수신처 세팅 진행
	                    if (pDraftFlag != "REDRAFT" || (ListType == "21" && parent.addFlag == true)) {
	                        setFirstDrafter(); // 기본 결재선 설정 및 고정수신처 설정 등을 진행 (ezDraftAll_WHWP.js > GetDraftAprLineInfo)
                            if(frameNum != 1 && parent.TempsaveAprlineinfo != undefined){
                                var ret = new Array()
                                ret[0] = parent.TempsaveAprlineinfo;
                                if(approvalFlag == "S")
                                    SGetDraftAprLineInfo(ret);
                                else
                                    GetDraftAprLineInfo(ret);
                            }
	                    } else {
	                        // 반송문서 재기안 또는 임시저장문서를 초기에 가져오는 분기 -> 이미 결재선 및 수신처가 지정된 상태이므로, 수신처가 존재하는지만 간단하게 확인해서 부모의 btnReceivLineEnableAry배열에 값을 넣는다.
	                        if (ListType == "21") { // 임시저장된 문서
	                        	parent.btnReceivLineEnableAry[frameNum] = getReceiptExists(parent.DocSNAry[frameNum], "TMP");
	                        } else { // 반송된 문서 재기안
	                        	parent.btnReceivLineEnableAry[frameNum] = getReceiptExists(parent.pDocIDAry[frameNum], "APR");
	                        }
	                    }
	                    
	                    // 1안 이후에 추가된 안에는 1안의 정보를 복사해준다.
	                    // 반송문서 또는 임시저장문서 재기안 시, 전체 문서 로딩 완료 이후 안 추가시에만 1안의 정보를 복사해준다. 
			    		 if (parent.addFlag == true) {
			    			 CopyAndPasteContent(true);
			    			 copyDoc();
		                }
	                    
	                    EditMode(2);
						SetViewProperties(2, 100);
	                    MoveToField("doctitle");
	                    ScrollPosInfo(0, 0);
	                    
	                    //  모든 안이 순차적으로 로딩 완료되지 않으므로(비동기), 로딩 완료 카운트를 하나씩 증가시켜서 부모창의 파라미터에 부여한다.
	                    // 재기안 상태이면서 addFlag가 아직 변경되지 않은 경우 (초기 로딩 상태 진행 중임)
	                    if (pDraftFlag == "REDRAFT" && parent.addFlag == false) {
	                    	parent.docLoadCompleteCnt ++;
	                    	
	                    	/* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
	    			        startRemapAllAprSign_WHWP(pDocID, orgCompanyID);
	                    	
	                    	// 로딩된 문서의 전체 갯수가 재기안 시작 시 가져온 전체 안의 갯수와 일치한다면, addFlag 등을 변경시킨다.
	                    	if (parent.docLoadCompleteCnt == (parent.pDocIDAry.length - 1)) {
	                    		parent.titleOptionFlag = true;
	                    		parent.contentOptionFlag = true;
	                    		parent.attachOptionFlag = true;
	                    		parent.docAttachOptionFlag = true;
	                    		parent.seperateAttachOptionFlag = true;
	                    		parent.opinionOptionFlag = true;
	                    		parent.addFlag = true;
	                    		
	            	        	parent.selTab(1); // 각 안을 전부 로딩한 뒤, 기본으로 1안을 선택하도록 한다.
	                    		parent.HiddenMailProgress(); // 전부 완료 시 로딩중 이미지 제거
	                    		parent.CheckOpinionYN(1); // 1안 기준으로 의견이 존재한다면 레이어팝업 표출
	                    	}
	                    } else { // 한개씩 안추가하는 경우, 완료 후 바로 이미지 제거
	                    	parent.HiddenMailProgress(); // 문서 로딩중 이미지 제거 (현재 iframe이 ready될때 호출된 ShowMailProgress를 문서 호출 완료하고 닫는 동작
	                    }
	                } else {
	                	parent.HiddenMailProgress();
	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
	                    OpenAlertUI(pAlertContent);
	                    Clear();
	                }
	                FreeUndoHistory();
 	            } catch (e) {
 	            	console.log(e);
	                alert("apprGdraftuiAllContent_WHWP.FieldsAvailable()  ::  " + e.description);
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
			        if (pFormHref == "") {
			            SetBtnStateFalse();
			        } else {
			        	var ifCond = (pDraftFlag == "REDRAFT" && parent.addFlag == false);
			            if (pDraftFlag == "REDRAFT" && parent.addFlag == false) { // 재기안이면서 최초 1안 추가가 시작되지 않은 경우 (기존 문서들을 로딩중인 경우)
			                var len;
			                var pInformationContent;
			                var Ans;
			                
			                if (docID == "") {
			                    len = docHref.lastIndexOf("/");
			                    pDocID = docHref.substr(len + 1, 20);
			                } else {
			                    pDocID = docID;
			                }
			                
			                GetAprDocFormID();
		                    parent.pFormIDAry[frameNum] = pFormID;
		                    
		                    /* 2023-04-21 홍승비 - 일괄기안 문서 재기안 시, 기존 첨부파일 정보를 각 안마다 가져오는 부분을 부모 페이지로 이동하여 한번에 가져옴 */
							setAttachInfoAll(pDocID, pModeForAllAttachInfo, parent.document.getElementById("lstAttachLink")); // 각 안 별 첨부파일 플래그 세팅
			                getDocInfo(frameNum); // 현재 페이지에 새롭게 선언한 함수로 변경
			            }
			            // 1안 이후에 추가된 경우, 기존 원문공개와 결재선 정보를 가져온다.
			            else {
			                pDraftFlag = "DRAFT";
			
			                if (pFormHref != "PC") {
			                    var len;
			                    len = pFormHref.lastIndexOf("/");
			                    pFormID = formID;
			                    
			                    parent.pFormIDAry[frameNum] = pFormID;
			                }
			                
			                if (parent.pDocIDAry[frameNum] == null) {
			                    if (parent.pReadPC) {
			                        ClearDocCellInfo();			                        
								}
			                    
			                    setClearSusinCellInfo();
			                    
			                    pDocID = createNewDoc();
			                }
			                
			                parent.pDocIDAry[frameNum] = pDocID;
			                
				            if (parent.listOpenFlag != undefined && parent.listOpenFlag != "") {
					            $.ajax({
			                   		type : "POST",
			                   		dataType : "text",
			                   		async : false,
			                   		url : "/ezApprovalG/openGovInfoSave.do",
			                   		data : {
			                   				openGovListFlag : parent.listOpenFlag,
			                   				fileOpenFlagList : parent.fileOpenFlagListArr[1],
			                   				basis : parent.basis,
			                   				reason : parent.reason,
			                   				publicity : parent.pPublicityCode,
			                   				docID : pDocID,
			                   				limitDate : parent.limitDate
			                   		}
			                	});
					            
			 		            $.ajax({
		                    		type : "POST",
		                    		dataType : "text",
		                    		async : false,
		                    		url : "/ezApprovalG/copyOpenGovAttachInfo.do",
			                    	data : {
			                    			docID : pDocID,
			                    			parentDocID : parent.pDocIDAry[1]
			                    	}
	                 			});
				            }
			            }
					}
				} catch (e) {
					console.log(e);
				    alert("apprGdraftuiAllContent_WHWP.jsp > process_AfterOpen()  ::  " + e.description);
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
	        
            function FreeUndoHistory() {
			    HwpCtrl.FreeUndoHistory();
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
////////// 웹한글기안기 함수 끝 //////////
			 
			 // 1안의 본문을 이후 추가된 안에도 복사하기 위한 함수
	        function CopyAndPasteContent(isTrue) {
	        	try {
	        		var ifrm1 = parent.document.getElementById("ifrm1");
	        		
		        	if (isTrue) {
		        		if (parent.contentOptionFlag == true) {
		        			// 본문 내부 이미지까지 전부 가져오기 위해 HWP 타입으로 받아온다.
		        			if(ifrm1.src.indexOf("draftContentAll_WHWP") < 0)
		        			    GetCloneData("body", "HWP", function(){AppendFieldText("body", ifrm1.contentWindow.GetBodyHTML(), false, true, true);});
                            else
		        			    ifrm1.contentWindow.GetCloneData("body", "HWP", function (tempContent) { SetCloneData(tempContent, "body", "HWP"); });
		        		}
		        	} else {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
	                    OpenAlertUI(pAlertContent);
	                    Clear();
	                }
	        	} catch (e) {
		            alert("CopyAndPasteContent ::" + e);
		        }
	        }
	        
	        // 1안 이후 안추가 시 1안의 정보를 복사
	        function copyDoc() {
	        	var ifrm1 = parent.document.getElementById("ifrm1");
	        	 
	    		copyAprLine(); // 결재선정보 복사
	    		
				if (parent.titleOptionFlag == true) { // 제목
					var mainDocTitle = ifrm1.contentWindow.GetFieldText("doctitle");
	    			PutFieldText("doctitle", stripHTMLTags(mainDocTitle));
				}

				if (FieldExist("publication")) {
					var publication = ifrm1.contentWindow.GetFieldText("publication");
					PutFieldText("publication", publication);
				}
				
	    		
	    		if (parent.seperateAttachOptionFlag == true) { // 분리첨부
	    			// 단, 해당 분리첨부 내용이 공백이 아닌 경우에만 복사함
	    			var ifrm1SepXML = ifrm1.contentWindow.GetDocumentElementForDraftAll("sepattachlvxml", true);
		    		if (ifrm1SepXML != "") {
		    			SetDocumentElementForDraftAll("sepattachlvxml", ifrm1.contentWindow.GetDocumentElementForDraftAll("sepattachlvxml", true));
		    		}
	    		}
	    		
	    		// 1안에 대해 일반첨부, 문서첨부가 없는 경우 플래그 조정 (첨부파일 복사 필요없음)
	    		if (parent.pHasAttachYNAry[1] != "Y") {
	    			parent.attachOptionFlag = false;
	    			parent.pHasAttachYN = "N";
	    			parent.pHasAttachYNAry[frameNum] = "N";
	    		}
	    		if (parent.pHasDocAttachYNAry[1] != "Y") {
	    			parent.docAttachOptionFlag = false;
	    			parent.pHasDocAttachYN = "N";
	    			parent.pHasDocAttachYNAry[frameNum] = "N";
	    		}
    		
	    		// 1안의 의견은 복사하지 않는다.
/* 	    		if (parent.pHasOpinionYNAry[0] != "Y") { // 의견이없는 경우 플래그 조정
	    			parent.opinionOptionFlag = false;
	    		} */
	    		// 의견 복사하지 않으므로 N으로 고정
	    		parent.pHasOpinionYN = "N";
	    		parent.pHasOpinionYNAry[frameNum] = "N";
	    		
	    		// 일반첨부, 문서첨부 데이터 복사
	    		if (parent.attachOptionFlag == true || parent.docAttachOptionFlag == true) {
	    			$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		data : {
			    			attachFlag : parent.attachOptionFlag,
			    			docAttachFlag : parent.docAttachOptionFlag,
			    			seperateAttachFlag : parent.seperateAttachOptionFlag,
			    			//opinionFlag : parent.opinionOptionFlag,
			    			mainDocID  : parent.pDocIDAry[1],
			    			currentDocID : pDocID
			    		},
			    		url : "/ezApprovalG/copyDocAttachHwp.do",
			    		success: function(result) {
			    			// 첨부파일 복사 후, 부모창과 해당 안의 플래그 변경
			    			if (parent.attachOptionFlag == true) {
			    				parent.pHasAttachYN = "Y";
				    			parent.pHasAttachYNAry[frameNum] = "Y"
				    		}
				    		if (parent.docAttachOptionFlag == true) {
				    			parent.pHasDocAttachYN = "Y";
				    			parent.pHasDocAttachYNAry[frameNum] = "Y";
				    		}
			    		}
			    	});
	    			
	    			// 하단 첨부파일 영역에 정보 셋팅 (일단 숨김처리한 상태)
	    			if (parent.attachOptionFlag == true || parent.docAttachOptionFlag == true) {
	    				setAttachInfo(pDocID, "APR", parent.lstAttachLink);
	    			}
	    		}
	        }
	        
	        // 1안의 결재선 복사 (컨트롤러단에서 전부 처리함. 리턴값 없음)
	        function copyAprLine() {
	    		$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		data : {
		    			mainDocID  : parent.pDocIDAry[1], // 1안의 문서ID를 메인으로 사용
		    			currentDocID : pDocID
		    		},
		    		url : "/ezApprovalG/copyAprLine.do",
		    		success: function(result) {}
		    	});
	    	}
	        
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
					console.log(e.stack);
				}
			}
	        
	        // 각 안에 맞는 배열 인덱스에 데이터를 삽입하기 위한 함수 분리
			function getDocInfo(currIdx) {
			    var xmldoc = loadXMLString(parent.pDocInfoAry[currIdx]);
			    var objNodes = xmldoc.documentElement.childNodes;
			    
			    if (objNodes) {
			        if (SelectSingleNodeValueNew(xmldoc, "DATA/HASOPINIONYN") == "Y" || SelectSingleNodeValueNew(xmldoc, "DATA/HASOPINIONYN") == "O") {
			        	parent.pHasOpinionYNAry[currIdx] = "Y";
			        } else {
			        	parent.pHasOpinionYNAry[currIdx] = "N";
			        }
			        
			        parent.tempSecurity = SelectSingleNodeValueNew(xmldoc, "DATA/SECURITYCODE");
			        parent.tempKeep = SelectSingleNodeValueNew(xmldoc, "DATA/STORAGEPERIOD");
			        parent.tempUrgent= SelectSingleNodeValueNew(xmldoc, "DATA/URGENTAPPROVAL");
			        parent.tempPublic = SelectSingleNodeValueNew(xmldoc, "DATA/ISPUBLIC");
			        parent.tempKeyword = SelectSingleNodeValueNew(xmldoc, "DATA/KEYWORD");
			        parent.tempItemCode = SelectSingleNodeValueNew(xmldoc, "DATA/ITEMCODE");
			        parent.tempItemName = SelectSingleNodeValueNew(xmldoc, "DATA/ITEMNAME");
			        parent.pSummery = SelectSingleNodeValueNew(xmldoc, "DATA/SUMMARY");
			        parent.pSpecialRecordCode = SelectSingleNodeValueNew(xmldoc, "DATA/SPECIALRECORDCODE");
			        parent.pPublicityCode = SelectSingleNodeValueNew(xmldoc, "DATA/PUBLICITYCODE");
			        parent.pPublicityYN = SelectSingleNodeValueNew(xmldoc, "DATA/PUBLICITYYN");
			        parent.pLimitRange = SelectSingleNodeValueNew(xmldoc, "DATA/LIMITRANGE");
			        parent.pPageNum = SelectSingleNodeValueNew(xmldoc, "DATA/PAGENUM");
			        parent.cabinetID = SelectSingleNodeValueNew(xmldoc, "DATA/CABINETID");
			        parent.TaskCode = SelectSingleNodeValueNew(xmldoc, "DATA/TASKCODE");
			        parent.tempSecurityDate = SelectSingleNodeValueNew(xmldoc, "DATA/SECURITYAPPROVAL");
			        
			        if (useOpenGov == "YES") {
			        	parent.basis = SelectSingleNodeValueNew(xmldoc, "DATA/BASIS");
			        	parent.reason = SelectSingleNodeValueNew(xmldoc, "DATA/REASON");
			        	parent.listOpenFlag = SelectSingleNodeValueNew(xmldoc, "DATA/LISTOPENFLAG");
			        	parent.fileOpenFlagList = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
			        	parent.fileOpenFlagListArr[currIdx] = SelectSingleNodeValueNew(xmldoc, "DATA/FILEOPENFLAGLIST");
			        	parent.limitDate = SelectSingleNodeValueNew(xmldoc, "DATA/LIMITDATE");
			        }
			    }
			}
	        
	        // 재기안 > 결재올림 시, 각 안의 문서번호 재설정 함수를 호출하는 함수
			function UpdateDocNum() {
				if (!FieldExist("docnumber")) {
					console.log("hwpContent hasn't a docnumber field");
					return false;
				}
				
				// ajax로 현재 문서의 docnumber 형식을 리턴
				var numberFormat = "";
				numberFormat = getDocNumFormatByFormID(parent.pFormIDAry[frameNum], orgCompanyID);
				
				PutFieldText("docnumber", getDocNumByFormat(numberFormat));
			}

            function setSignSlash(pSignKinds, pSusin) {
                var i, j;
                var fieldName;
                var field, fieldvalue;
                var tempFieldName;
                var fields = GetFieldList();
                for (i = 1; i < 21; i++) {
                    fieldName = pSusin + pSignKinds + i;
                    if (FieldExist(fieldName)) {
                        fieldvalue = trim(GetFieldText(fieldName));
                        MoveToField(fieldName);
                        var act = HwpCtrl.CreateAction("CellBorder");
                        var set = act.CreateSet();
                        act.GetDefault(set);
                        if (fieldvalue == "") {
                            set.SetItem("DiagonalType", 1);
                            set.SetItem("SlashFlag", 0x02);
                        }
                        /* 2020-07-24 홍승비 - 전자결재 일반버전의 경우, 서명과 결재자명 필드 구분하도록 수정 */
                        else if (trim(fieldvalue) == "[NOSLASH]") {
                            set.SetItem("SlashFlag", 0x00);
                            PutFieldText(fieldName, " ");
                        }else
                            set.SetItem("SlashFlag", 0x00);

                        act.Execute(set);
                    }
                }
            }

			function stripHTMLTags(htmlString) {
				const tempDiv = document.createElement("div");
				tempDiv.innerHTML = htmlString;
				return tempDiv.textContent || tempDiv.innerText || "";
			}
	    </script>
	</head>
	<body>
	    <div id="hwpContent" style="height: 100%;"><div>
	</body>
</html>