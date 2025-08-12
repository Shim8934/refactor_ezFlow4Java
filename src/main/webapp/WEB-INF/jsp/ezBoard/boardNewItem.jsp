<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html style="height: 99%;" ondragover="bodydragover(event)">
	<head>
		<c:choose>
			<c:when test="${mode == 'new' || mode == 'new1' || mode == 'boardAttach' || mode == 'boardContent' || url != ''}">
			    <title><spring:message code='ezBoard.t368' /></title>
			</c:when>
			<c:when test="${mode == 'reply'}">
			    <title><spring:message code='ezBoard.t369' /></title>
			</c:when>
			<c:otherwise>
			    <title><spring:message code='ezBoard.t370' /></title>
			</c:otherwise>
		</c:choose>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <style>
            .peopleSelectBtn {
                border-radius: 3px;
                line-height: 23px;
                border: 1px solid #ccc;
                cursor: pointer;
                padding: 2px 5px;
                margin-right: 10px;
            }
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/datepicker.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/composeappt.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/ConvertSaveImage.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
	    <c:if test="${!isCrossBrowser}">
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
	    </c:if>
	    <c:if test="${isCrossBrowser}">
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain_CK.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem_CK.js')}"></script>
	    </c:if>
	    <script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
	    <!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<!-- Whwp api -->
        <c:if test="${useHWP eq 'YES' and useHwpDownSecurity eq 'Y' and approvalFlag eq 'G' }">
	    	<script type="text/javascript" src="${webHWPUrl}js/hwpctrlapp/utils/util.js"></script>
			<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/hwpCtrlApp.js')}"></script>
    		<script type="text/javascript" src="${webHWPUrl}js/webhwpctrl.js"></script>
	    </c:if>
	    <script type="text/javascript">
		    var pUploadFilePath = "${uploadFilePath}";
		    var pBoardID = "<c:out value='${boardID}'/>";
		    var pBoardName = "${boardInfo.boardName}";
		    var pMode = "<c:out value='${mode}'/>";
		    var orgMode = "<c:out value='${mode}'/>";
		    var pModeOld = "";
		    var MHTLoadComplete = "";
		    var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.displayName1}";
		    var SSUserName2 = "${userInfo.displayName2}";
		    var SSDeptID = "${userInfo.deptID}";
		    var SSDeptName = "${userInfo.deptName1}";
		    var SSDeptName2 = "${userInfo.deptName2}";
		    var SSCompanyID = "${userInfo.companyID}";
		    var SSCompanyName = "${userInfo.companyName1}";
		    var SSCompanyName2 = "${userInfo.companyName2}";
		    var strItemID = "${itemID}";
		    var strWriterID = "${boardListVO.writerID}";
		    var strWriterName = ConvMakeXMLString("<c:out value='${boardListVO.writerName}'/>"); // 익명게시판의 게시자명 특문처리 대응
		    var strWriterDeptName = "${boardListVO.writerDeptName}";
		    var strWriterCompanyName = "${boardListVO.writerCompanyName}";
		    var strWriteDate = "${boardListVO.writeDate}";
		    var strParentWriteDate = "${boardListVO.parentWriteDate}";
		    var strImportance = "${boardListVO.importance}";
		    var strStartDate = "${boardListVO.startDate}";
		    var strEndDate = "${boardListVO.endDate}";
		    var strAttachments = "${boardListVO.attachments}";
		    var strContentLocation = "${boardListVO.contentLocation}";
		    var strUpperItemIDTree = "${boardListVO.upperItemIDTree}";
		    var strItemLevel = "${boardListVO.itemLevel}";
		    var strWriterTitle = "${boardListVO.extensionAttribute3}";
		    var strWriterFakeName = ConvMakeXMLString("<c:out value='${strWriterFakeName}'/>"); // 익명게시판의 게시자명 특문처리 대응
		    var pAttachListXml = "";
		    var AttachLimit = "${boardInfo.attachSizeLimit}";
			var pReservedItem = "<c:out value='${reservedItem}'/>";
		    var strUserRank = "${userInfo.title1}";
		    var strUserRank2 = "${userInfo.title2}";
		    var strUserPhone = "${userInfo.phone}";
		    var strNow = "${strNow}";
		    var ExpireDays = "${expireDays}";
		    var ExpireItem = "${expireItem}";
		    var gubun = "${boardInfo.guBun}";
		    var pUrl = "${url}";
		    var pDocID = "${docID}";
		    var PhotoBoard = "";
		    var flag = false;
		    var _hasattach = "${hasAttach}";
		    var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var idDatepicker_Temp = "";
		    var _T1_Temp = "";
		    if (!"${isCrossBrowser}") {
			    var objMHT = new ActiveXObject("MhtFormat.Convert");
			    var objMHTRead = new ActiveXObject("MhtFormat.Convert");
		    } 
		    
		    var NewGuid = "${newGuid}";
			var mgubun = "";
			var attachxml = "";
			var realFileNames = "";
			var pBoardType = "${boardType}";
		    var saveItemBoardId = "";
		    var SelBoard = false;
		    var pcheckForm = "${checkForm}";
		    var pUseBackGround = "${useBackGround}";
		    var defaultFontAndSize  = "${defaultFontAndSize}";
		    var FirstFlag = false;
		    var rsa = new RSAKey();
		    var orgCompanyID = "${orgCompanyID}";
		    var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
		    var mailShareId = "${mailShareId}";
		    var useKeywordFlag = "<c:out value='${useKeyword}'/>"; // 키워드 사용여부 (Y/N)
		    var keywordArr = []; // 키워드 배열

		    
		    /* 2023-05-16 김우철 - hwp결재문서를 배포용 문서로 저장하기 위한 변수 */
		    var HwpCtrl;
			var useHwpDownSecurity = "<c:out value='${useHwpDownSecurity}'/>";
			var HwpSecurityNum = "<c:out value='${HwpSecurityNum}'/>";
			var isHwpCtrlOpen = false;
		    var startCheck = false;
		    var authList = [];
		    
			/* 2023-07-04 김우철 - 전자결재 일반버전에서 테넌트 컨피그 useHwpDownSecurity값에 상관없이 대응하기 위한 변수 */
		    var approvalFlag = "<c:out value='${approvalFlag}'/>";
		    var useHWP = "<c:out value='${useHWP}'/>";

			/* 2023-09-25 민지수 - 게시판 > 공지사항 기간설정 시작, 종료시간 변수 */
			var boardNoticePeriod = "<c:out value='${boardNoticePeriod}'/>";
			var strNotiStart = "${boardListVO.notiStart}";
			var strNotiEnd = "${boardListVO.notiEnd}";
			
			/* 2023-11-17 홍승비 - 승인게시판의 경우, 반려된 게시물을 재작성 후 저장 시 수정알림메일을 발송하지 않도록 파라미터 추가 */
			var itemApprFlag = "<c:out value='${boardListVO.apprFlag}'/>";

			var offset = "${userInfo.offset}";

			/* 2024-05-20 김유진 - 일정에서 게시판 게시를 위한 변수 */
			var scheduleId = "<c:out value='${scheduleId}'/>";
			/* 2024-08-26 김유진 - 확장컬럼 사용 여부 */
			var pAttributeYN = "${boardInfo.attributeYN}";

			/* 2024-10-24 정지은 - 글 작성 시 파일첨부 가능여부 설정 */
			var attachmentFlag = "<c:out value='${boardInfo.attachmentFlag}'/>";
			
			var editor = "${editor}";
			var formPath = "";

			var writerFlag = "${boardInfo.writerFlag}"; // 2025-01-21 임정은 - 게시판 게시물 게시자명선택 사용여부 플래그
			var writerNameType = parseInt("<c:out value='${boardListVO.writerNameType}'/>"); // 2025-01-21 임정은 - 게시자명선택 타입 (0 : 이름, 1 : 부서명)

			var parentItemID = "${parentItemID}";

			var useVersion = "${ useVersion }";
			var version = "${ version }";
			var newVersionItemID;
			var newestVersion = "${ newestVersion }";
			var parentItemID = "${ parentItemID }";
			var historyModify = "${ historyModify }";

		    window.onload = function () {
		    	
		    	// useHwpDownSecurity가 Y일 때만 Whwp api 호출. 전자결재 일반버전에서는 useHwpDownSecurity의 값에 상관없이 Whwp api 호출하지 않음.
	        	/*
	        	if (useHWP == "YES" && useHwpDownSecurity == "Y" && approvalFlag == "G") {
	        		HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${webHWPUrl}", function () {isHwpCtrlOpen = true;});
	        	}
	        	*/
		    	
		        if (pUseBackGround == "TRUE") {
		            document.getElementById("pUseBackGroundTR").style.display = "";
		            GetBackGroundImage();
		        }
		        else{
		            document.getElementById("pUseBackGroundTR").style.display = "none";
		        }
				rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
				
				if (!"${isCrossBrowser}") {
			        document.all.EzHTTPTrans.SetBigLang = "${userInfo.lang}" == "1" ? 1 : 0;
			        document.all.EzHTTPTrans.UseDbCl = true;
				}
				
			    if (pMode == "reply")
			        if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
			            document.getElementById("file1").multiple = false;
			        }
			    if (gubun != "3") {
			        PhotoBoard = "N";
			    }
			    else {
			        PhotoBoard = "Y";
			    }
	
			    if (pReservedItem != "true") document.getElementById("reservation_date").style.visibility = "hidden";
			    if ((pMode == "modify" || pMode == "temp" || pMode == "boardContent" || pMode == "boardAttach") && strAttachments != "") {
			        pAttachListXml = MakeAttachList();
			        if (gubun != "3") {
			            AppendFileAttachInfo(pAttachListXml);
			            if ("${isCrossBrowser}") {
				            if (typeof (pAttachListXml) == "string")
				                pAttachListXml = loadXMLString(pAttachListXml);
				            else
				                pAttachListXml = loadXMLString(getXmlString(pAttachListXml));
				
				            var objAttachNodes = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW");
				            
							/* 2019-01-22 홍승비 - 게시물 수정, 임시저장 시 첨부파일의 경로 전체가 특문 치환되는 오류 수정 */
				            for (var i = 0; i < objAttachNodes.length; i++) {
								 attachxml += getNodeText(SelectNodes(objAttachNodes[0], "DATA2")[i]) + "|";
								 realFileNames += getNodeText(SelectNodes(objAttachNodes[0], "realFileNM")[i]) + "|";
				            }
			            }
			        }
			        else {
			            RealImageName(pAttachListXml);
			        }
			    }

			    /* 2019-12-02 홍승비 - 임시저장된 게시물 재작성하는 경우 예약게시일 설정 가능, 초기화 동작 추가 */
			    if (pMode == "new" || pMode == "new1" || (pMode == "temp" && pReservedItem != "true")) {
			        btn_PostDate_Clear();
			    } else {
			        if (pReservedItem != "true") {
			        	$("#Sdatepicker").datepicker('setDate', "");
			        }
			    }
			    
			    /* 2021-05-03 홍승비 - 확장칼럼값 설정 분기 분리 (새 게시물 작성, 메일 또는 전자결재문서 게시, 게시물을 본문으로 또는 첨부로 게시 시에만 확장칼럼값 없음) */
				if (pMode != "new" && pMode != "new1" && pMode != "boardContent" && pMode != "boardAttach") {
			            //추가항목
			            try {
			            	if("${fn:length(boardAttributeListVO)}" > 0){
			    				var colType = new Array();
			    				var tableCol = new Array();
			    				
			    				<c:forEach items="${boardAttributeListVO}" var = "item" >
			    					colType.push("${item.colType}");
			    					tableCol.push("${item.tableCol}");
			    				</c:forEach>
			    				
			    				for (var i = 0; i < colType.length;i++) {
			            			if (colType[i] == "radio") {
			            				SetRadioVal(tableCol[i], getExtensionValue(tableCol[i]));
			            			} else if (colType[i] == "text") {
			            				document.getElementById(tableCol[i]).value = getExtensionValue(tableCol[i]);
			            			} else if (colType[i] == "check") {
			            				SetCheckVal(tableCol[i], getExtensionValue(tableCol[i]));
			            			} else if (colType[i] == "cal") {
										document.getElementById(tableCol[i]).value = getExtensionValue(tableCol[i]);
									} else if (colType[i] == "select") {
										document.getElementById(tableCol[i]).value = getExtensionValue(tableCol[i]);
									} else if (colType[i] == "textArea") {
									    document.getElementById(tableCol[i]).value = getExtensionValue(tableCol[i]).replace(/<br\s*\/?>/gi, '\n');
									} else if (colType[i] == "people") {
									    // 2024-07-31 전인하 - 게시판 > 확장컬럼 > 게시물 수정 시 peoplePicker 타입 출력값 가공
									    var authListObjTemp = {};
									    var tempData = [];
									    var displayUserListText = "";
                                        var tempAuthListArr = getExtensionValue(tableCol[i]).split(";");
                                        for (let i = 0 ; i < tempAuthListArr.length; i++) {
                                            if (tempAuthListArr[i] == "") {
                                                break;
                                            }
                                            var authInfoJson = {};
                                            var tempAuthObj = tempAuthListArr[i].split("/");
                                            authInfoJson.userId = tempAuthObj[0];
                                            authInfoJson.userName = "${userInfo.lang}" == "1" ? tempAuthObj[1] : tempAuthObj[2];
                                            authInfoJson.userName1 = tempAuthObj[1];
                                            authInfoJson.userName2 = tempAuthObj[2];
                                            authInfoJson.userType = tempAuthObj[3];
                                            if (i != 0) {
                                                displayUserListText += ", "
                                            }
                                            displayUserListText += "${userInfo.lang}" == "1" ? tempAuthObj[1] : tempAuthObj[2];
                                            tempData.push(authInfoJson);
                                        }
                                        authListObjTemp.columnName = tableCol[i];
                                        authListObjTemp.data = tempData;
                                        authList.push(authListObjTemp);
                                        document.getElementById(tableCol[i]).innerText = displayUserListText;
									}
			    				}
			            	}
			            }
			            catch (e) { }
					}
			        
			    if (ExpireDays == -1 || ExpireItem == "YES") {
			    	document.getElementById('Makedate').style.visibility = "hidden";
			    }
			    if (pMode == "modify" || pMode == "temp") {
			        document.getElementById("txtTitle").value = ConvMakeXMLString("<c:out value='${boardListVO.title}'/>");
				    document.getElementById("txtAbstract").value = ConvMakeXMLString("<c:out value='${boardListVO.ABSTRACT}'/>");
				    if (gubun == "3") {
				        document.getElementById("txtPhotoFile").value = ConvMakeXMLString("${boardListVO.extensionAttribute4}");
				    }
			        if (gubun == "2") {
			            document.getElementById("txtNickName").value = ConvMakeXMLString(strWriterFakeName);
			        }
			    }
			    if (pMode == "reply") {
			    	document.getElementById("txtTitle").value = ConvMakeXMLString("<c:out value='${boardListVO.title}'/>");
			    	
			    	 if (gubun == "2") { // 익명게시물 답변 시에도 게시자명 특문처리 추가
						document.getElementById("txtNickName").value = ConvMakeXMLString(strWriterFakeName);
					}
				}
			    if (pReservedItem != "true") {
			        //var nowDate = new Date();
			        //if ($('#Stimepicker').val == "") {
			        //    if (nowDate.getMinutes() <= 30) {
			        //        $("#Sdatepicker").datepicker('setTime', nowDate.getHours() + ":" + "30");
			        //    }
			        //    else {
			        //        $("#Sdatepicker").datepicker('setTime', nowDate.getHours() + ":" + "00");
			        //    }
				    //}
			    }
			    
			    /* 2022-06-21 홍승비 - 홈페이지게시판의 게시물 등록 시, 첨부파일 및 게시만료일 사용하지 않으므로 해당 영역 숨김처리 */
			    if (gubun == "8") {
			    	document.getElementById("attachIframeTR").style.display = "none";
			    	document.getElementById("tdEndDate").style.display = "none"; // 영구 게시로 고정되어 숨김
			    	resizeMessageFrame();
			    }
			    
			    FirstFlag = true;
			    ChkPermanent();
				/* 2023-09-25 민지수 - 게시물 로드시 정보 불러오도록 추가 */
				NotiPost_onclick();
				Noti_setTime();
				
				// 2024-08-23 전인하 - 게시판 > 게시글 수정/임시저장게시글 작성 > 게시물일 경우 입력되어있던 키워드 정보 삽입
				if ((pMode == "modify" || pMode == "temp") && useKeywordFlag == "Y") {
				    var keywordSpanArr = document.querySelectorAll(".keywordSpanView");
				    for (let i=0; i<keywordSpanArr.length; i++) {
				        keywordArr.push(keywordSpanArr[i].id);
				    }
				}

			    FirstFlag = false;

				if (writerFlag == 'Y' && !isNaN(writerNameType)) {
					if (writerNameType == 1) document.getElementById('chkUseDept').checked = true;
					chkUseDept_onclick();
				}
				
			    try {
			        if (document.getElementById("txtTitle").value == "")
			            if (OpenWin == null)
			                document.getElementById("txtTitle").focus();
			    }
			    catch (e) { }

				if (useVersion === "Y") {
					let v;

					if (version != "") {
						v = version.split(".");

						document.getElementById("majorVersion").disabled = true;
						document.getElementById("minorVersion").disabled = true;
					} else {
						v = newestVersion.split(".");
					}

					var newItemFlag = v[0] === '';

					if (newItemFlag) {
						document.getElementById("tr_version").style.display = "none";
					}

					document.getElementById("majorVersion").value = !newItemFlag ? v[0] : "0";
					document.getElementById("minorVersion").value = !newItemFlag ? v[1] : "0";
				}
		    };
		    
		    /* 2022-06-21 홍승비 - 에디터 영역 리사이즈 함수 분리 */
		    window.onresize = function () {
				resizeMessageFrame();
				if (editor == "HWP") {
					var mHeight = document.getElementById("EdtorSize").clientHeight - 16 + "px";
		       		message.Resize(mHeight);
				}
				mobileDistinction();
		    };

		    function resizeMessageFrame () {
		        switch (pSelectTab) {
		            case "MailEnv_div1":
		                if ("${boardInfo.guBun}" == "2") { // 익명게시판
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		                } else if ("${boardInfo.guBun}" == "8") { // 홈페이지 게시판
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 160 + "PX";
		                } else if ("${docID}" != "" && pUrl.toLowerCase().indexOf(".hwp") < 0) { // 전자결재문서 게시 (mht)
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 500 + "PX";
		                } else if (pUrl.toLowerCase().indexOf(".hwp") < 0) { 
		        	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
		                }
						mobileDistinction();
		                break;
		            case "MailEnv_div3":
		                {
		                    if (pUseBackGround == "TRUE") {
		                        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 330 + "PX";
		                        if ("${docID}" != "" && pUrl.toLowerCase().indexOf(".hwp") < 0)
		                            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 600 + "PX";
		                    }
		                    else {
		                    	if ("${boardInfo.guBun}" == "2") {
				                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		                    	} else if ("${boardInfo.guBun}" == "8") {
				                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 160 + "PX";
		                    	} else if ("${docID}" != "" && pUrl.toLowerCase().indexOf(".hwp") < 0) {
				                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 500 + "PX";
		                    	} else if (pUrl.toLowerCase().indexOf(".hwp") < 0) { 
				        	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
		                    	}
		                    }
							mobileDistinction();
		                    break;
		                }
		            default:
		            	if (pUrl.toLowerCase().indexOf(".hwp") < 0) 
		                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
						mobileDistinction();
		                break;
		        }
				/* 2024-08-26 김유진 - 사용된 확장컬럼 높이 고려하여 에디터 높이 설정 */
				if (pAttributeYN == "Y" && document.getElementById("tab01")) {
					document.getElementById("EdtorSize").style.height = '100%'
                    mobileDistinction();
				}

				if ("<c:out value='${boardInfo.attachmentFlag}'/>" != "Y") {
					var beforeEditorSize = document.getElementById("EdtorSize").style.height;
					document.getElementById("EdtorSize").style.height = parseInt(beforeEditorSize, 10) + 145 + "PX";
					mobileDistinction();
				}
				
		        var editorW = (document.documentElement.clientWidth - 20) + "PX";
		        document.getElementById("tab02").style.width = editorW;
	            document.getElementById("message").style.width = editorW;
	            //iframe 내부 에디터의 body width 조절
	            $("iframe").ready(function(){ $("iframe[name='message']").contents().find("body").css("width" , editorW); });
		        
		    };
		
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
				$("#noti_start").datepicker({ /* 게시판 > 공지사항 시작날짜 */
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true
				});
				$("#noti_end").datepicker({ /* 게시판 > 공지사항 종료날짜 */
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true
				});
				$(".cal").datepicker({ /* 게시판 > 확장컬럼 날짜형식 */
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true
				});
		        var settime = "${startDateTime}";
		        var NowDate = new Date(settime.substring(0, 4), settime.substring(5, 7), settime.substring(8, 10), settime.substring(11, 13), settime.substring(14, 16));
		        NowDate.setMonth(NowDate.getMonth() - 1);
				var NtNowDate = new Date(strNow.substring(0, 10));
				var NtEndDate = new Date(strNow.substring(0, 10));
				NtEndDate.setDate(NtEndDate.getDate() + parseInt(boardNoticePeriod));

		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
				$("#noti_start").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#noti_start").datepicker('setDate', NtNowDate);
				$("#noti_end").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#noti_end").datepicker('setDate', NtEndDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
				$(".cal").datepicker("option", "dateFormat", "yy-mm-dd");
				$(".cal").datepicker('setDate', NtNowDate);
		
		        $("#Sdatepicker2").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
       			
		        if (ExpireDays != -1) {
			        var utcDate = new Date(strNow.substring(0, 10));
			        utcDate.setDate(utcDate.getDate() + Number(ExpireDays));
		        } else {
			        var utcDate = new Date(strNow.substring(0, 10));
			        utcDate.setMonth(utcDate.getMonth() + 1);
		        }
		        
		        $("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker2").datepicker('setDate', utcDate);
		    });
		    
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		        	closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		    
		    function DateFormat(obj) {
		        var yy = String(obj.getFullYear()).substring(0, 4);
		        if (String(obj.getMonth() + 1).length == 1) {
		            var mm = "0" + (obj.getMonth() + 1);
		        }
		        else {
		            var mm = obj.getMonth() + 1;
		        }
		        if (String(obj.getDate()).length == 1) {
		            var dd = "0" + obj.getDate();
		        }
		        else {
		            var dd = obj.getDate();
		        }
		        var date = String(yy) + "-" + String(mm) + "-" + String(dd);
		        return date;
		    }
		    function RealImageName(ret) {
		        try {
		            pAttachListXml = ret;
		            var xmlAttach = createXmlDom();
		            xmlAttach = loadXMLString(ret);
		            var objAttachNodes = SelectNodes(xmlAttach, "LISTVIEWDATA/ROWS/ROW");
		            document.getElementById("txtPhotoFile").value = SelectSingleNodeValue(objAttachNodes[0], "CELL/VALUE");
		        }
		        catch (e) {
		            alert("RealImageName :: " + e.description);
		        }
		    }
		    function MakeAttachList() {
		        var xmldom = createXmlDom();
		        var str = "";
		        var i = 0;
		        var filename = "";
		        var filepath = "";
		        var resText = "";
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getItemAttachments.do",	        			
					data : { itemID : strItemID, 
							 mode   : pMode,
							 conLocation : strContentLocation,
							 title : ConvMakeXMLString("<c:out value='${boardListVO.title}'/>")
						   },
					success: function(result){
						resText = result;
					}        			
				});	
		        xmldom.async = false;
		        xmldom.preserveWhiteSpace = true;
		        xmldom = loadXMLString(resText);
		        xmlhttp = null;
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        str += "<LISTVIEWDATA><HEADERS><HEADER><NAME>"+"<spring:message code='ezBoard.t375' />"+"</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>"+"<spring:message code='ezBoard.t376' />"+"</NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS>";
		        for (i = 0; i < xmldomNodes.length; i++) {
		            filepath = SelectSingleNodeValue(xmldomNodes[i], "FilePath");
		            filename = MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileName"));
		            
		            str += "<ROW><CELL>";
		            str += "<VALUE><![CDATA[" + filename + "]]></VALUE>";
		            str += "<DATA1><![CDATA[" + "${boardListVO.extensionAttribute4}".substring(0, "${boardListVO.extensionAttribute4}".length - 1) + "]]></DATA1>";
		            str += "<DATA2>" + MakeXMLString(filepath) + "</DATA2>";
		            str += "<DATA3></DATA3>";
		            str += "<DATA4></DATA4>";
		            str += "<DATA5>Y</DATA5>";
		            str += "<DATA6>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileSize2")) + "</DATA6>";
					str += "<realFileNM><![CDATA[" + filename + "]]></realFileNM>";
		            str += "</CELL>";
		            str += "<CELL><VALUE></VALUE>";
		            str += "</CELL></ROW>";
		        }
		        str += "</ROWS></LISTVIEWDATA>";
		        return str;
		    }
		    function GetStartDate() {
		        var pReservationTime = "";
		        if ($('#Sdatepicker').val() && document.getElementById("chk_reservation").checked) {
		            if ($('#Stimepicker').val()) {
		                pReservationTime = $('#Sdatepicker').val() + " " + $('#Stimepicker').val() + ":00";
		            }
		            else {
		                pReservationTime = $('#Sdatepicker').val() + " 00:00:00";
		            }
		        }
		        return pReservationTime;
		    }
		    function GetEndDate() {
		        var pEndDateTime;
		        if (document.getElementById("ChkPermanence").checked) {
		            pEndDateTime = "9999-12-30 23:59:59";
		        } else {
		            if ((pMode == "modify" || pMode == "temp") && $('#Sdatepicker2').val().substring(0, 4) != "9999") {
		            	//만료일자가 오늘 23:59:59 이전까지 포함할수있게 수정
		                //pEndDateTime = $('#Sdatepicker2').val() + strEndDate.substring(10, 19);
		            	pEndDateTime = $('#Sdatepicker2').val() + " 23:59:59";
		            }
		            else {
		            	//만료일자가 오늘 23:59:59 이전까지 포함할수있게 수정
		                //pEndDateTime = $('#Sdatepicker2').val() + strNow.substring(10, 19);
		            	pEndDateTime = $('#Sdatepicker2').val() + " 23:59:59";
		            }
		        }
		        return pEndDateTime;
		    }

            var isClicked = false;
		    function PreventSaveItem(pMode) {
                if (!isClicked) {
                    // 중복 클릭 방지를 위해 클릭 상태를 true로 변경
                    isClicked = true;

                    // 함수 호출
                    SaveItem(pMode);

                    // 일정 시간이 지난 후에 다시 클릭 가능하도록 상태를 리셋
                    setTimeout(function() {
                    isClicked = false;
                    }, 1000); // 예: 1초 후에 클릭 가능하도록 설정
                }
            }

		    function SaveItem(pMode) {
		        if (pBoardID == "") {
		            if (!SelBoard) {
		                alert("<spring:message code='ezBoard.t173' />");
		                return;
		            }
		        }
		    	
		    	if (editor != "HWP") {
		    		if (MHTLoadComplete != "true") {
			            alert("<spring:message code='ezBoard.t377' />");
			            return;
			        }
		    	}

				if (gubun == 9 && pMode != "temp" && (pAttachListXml == "" || pAttachListXml.getElementsByTagName("ROWS")[0].childNodes.length == 0)) {
					alert("<spring:message code = 'ezBoard.fileViewerBoard.attachNotice' />");
					return;
				}
		
		        //추가항목
				var must = new Array();
				var colType = new Array();
				var colName1 = new Array();
				var tableCol = new Array();
				
				<c:forEach items="${boardAttributeListVO}" var = "item" >
					colType.push("${item.colType}");
					must.push("${item.must}");
					if ("${userInfo.lang}" == 1) {
						colName1.push("${item.colName1}");
					} else {
						colName1.push("${item.colName2}");
					}
					tableCol.push("${item.tableCol}");
				</c:forEach>
				
				for (var i = 0; i < colType.length;i++){
					var colName = colName1[i].replace(/\n/gi, "\\n").replace(/\\\\/gi, "\\")
											 .replace(/&amp;/gi, "&")
											 .replace(/&#039;/gi, "'")
											 .replace(/&#034;/gi, '\"')
											 .replace(/&lt;/gi, "<")
											 .replace(/&gt;/gi, ">");
					
					if (must[i] == "Y") {
		        		if (colType[i] == "radio") {
		        			if (GetRadioVal(tableCol[i]) == "") {
		        				Tab1_MouseClick(document.getElementById("1tab1"));
	                            alert(strLang188 + colName + strLang179);
	                            return;
		        			}
		        		} else if (colType[i] == "text" || colType[i] == "textArea") {
		        			if (document.getElementById(tableCol[i]).value.trim() == "") {
		        			    document.getElementById(tableCol[i]).value = "";
		        				Tab1_MouseClick(document.getElementById("1tab1"));
	                            alert(strLang189 + colName + strLang187);
	                            return;
		        			}
		        		} else if (colType[i] == "check") {
		        			if(GetCheckVal(tableCol[i]) == ""){
		        				Tab1_MouseClick(document.getElementById("1tab1"));
	                            alert(strLang188 + colName + strLang179);
	                            return;
		        			}
		        		} else if (colType[i] == "people") {
		        		    var tempPeopleList = document.getElementById(tableCol[i]).innerHTML;
		        		    if (tempPeopleList.trim() == "") {
                                Tab1_MouseClick(document.getElementById("1tab1"));
                                alert(strLang188 + colName + strLang179);
                                return;
                            }
		        		}
		        	}	
				}

		        var newID = "";
		        var pStartDate = GetStartDate();
		        var pEndDate = GetEndDate();
				var pNtStartDate = "";
				var pNtEndDate = "";

		        if (document.getElementById("ChkPermanence").checked == false) {
		            var configEndDate = Number(ReplaceText("${endDateTime}", "-", ""));
		            var currEndDate = Number(ReplaceText(pEndDate.substring(0, 10), "-", ""));
		            var currReserveDate = Number(ReplaceText(pStartDate.substring(0, 10), "-", ""));
					var alertMsg = "";
					
		            /* 2020-04-16 홍승비 - 예약게시일, 게시만료일 설정 메세지 변경 (일본어인 경우) */
		            if (configEndDate < currEndDate) {
		            	if ("${userInfo.lang}" == "3") { // 일본어
		            		alertMsg = "<spring:message code='ezBoard.t191' />";
		            	} else {
		            		alertMsg = "<spring:message code='ezBoard.t382' />" + "${endDateTime}" + "<spring:message code='ezBoard.t383' />";
		            	}
		                alert(alertMsg);
		                return;
		            }
		            if (currEndDate < currReserveDate) {
		            	if ("${userInfo.lang}" == "3") { // 일본어
		            		alertMsg = "<spring:message code='ezBoard.t191' />";
		            	} else {
		            		alertMsg = "<spring:message code='ezBoard.t384' />" + pEndDate.substring(0, 10) + " <spring:message code='ezBoard.t383' />";
		            	}
		            	alert(alertMsg);
		                return;
		            }
		        }
		        /* 2019-12-02 홍승비 - 임시저장 기능과 예약게시 기능을 동시에 사용할 수 있도록 변경 */
/* 		        if (document.getElementById("chk_reservation").checked && pMode == "temp") {
		            alert("<spring:message code='ezBoard.t00029' />");
		            return;
		        } */
		        if (document.getElementById("chk_reservation").checked && pStartDate == "") {
		            alert("<spring:message code='ezBoard.t385' />");
		            return;
		        }
		        if (pStartDate != "" && pStartDate < strNow) {
		            alert("<spring:message code='ezBoard.t386' />");
		            return;
		        }
		        if (pEndDate != "" && pEndDate <= strNow) {
		            alert("<spring:message code='ezBoard.t387' />");
		            return;
		        }
		        if (pStartDate != "" && pEndDate != "" && pEndDate < pStartDate) {
		            alert("<spring:message code='ezBoard.t389' />");
		            return;
		        }
		        if (document.getElementById("txtTitle").value == "" || trim(document.getElementById("txtTitle").value) == "") {
		            alert("<spring:message code='ezBoard.t390' />");
		            Tab1_MouseClick(document.getElementById("1tab1"));
		            document.getElementById("txtTitle").focus();
		            return;
		        }
		        if (gubun == "2" && document.getElementById('txtPassWord').value == "") {
		            alert("<spring:message code='ezBoard.t391' />");
		            Tab1_MouseClick(document.getElementById("1tab1"));
		            txtPassWord.focus();
		            return;
		        }
		        if (gubun == "3" && (pAttachListXml == "" || document.getElementById("txtPhotoFile").value == "")) {
		            alert("<spring:message code='ezBoard.t454' />");
		            return;
		        }
		        if (pStartDate == "" && pReservedItem == "true") {
		            strParentWriteDate = "";
		        }

				if (document.getElementById("noticePost").checked) { //공지사항인 경우
					if(!(document.getElementById("NotiPeriod").checked) && !(document.getElementById("NotiPermanece").checked)){
						alert("<spring:message code='ezBoard.Notimjs07'/>");
						return;
					}
					if(document.getElementById("NotiPeriod").checked){ //기간설정인 경우 시작일
						pNtStartDate = $('#noti_start').val() + " 00:00:00";
					}
					if (document.getElementById("NotiPermanece").checked) { //영구공지인 경우 종료일
						pNtStartDate = strNow;
						pNtEndDate = "9999-12-30 23:59:59";
					} else {
						pNtEndDate = $('#noti_end').val() + " " + "23:59:59"; //기간설정인 경우 종료일
					}
					if (pNtStartDate != "" && pNtStartDate.substring(0, 10) < strNow.substring(0, 10)) {
						alert("<spring:message code='ezBoard.Notimjs02'/>");
						return;
					}
					if (pNtEndDate != "" && pNtEndDate <= strNow) {
						alert("<spring:message code='ezBoard.Notimjs03'/>");
						return;
					}
					if (pNtStartDate != "" && pNtEndDate != "" && pNtEndDate < pNtStartDate) {
						alert("<spring:message code='ezBoard.Notimjs04'/>");
						return;
					}

					if (pStartDate!= "" && pNtStartDate != "" && pStartDate.substring(0,10) > pNtStartDate.substring(0,10)){
						alert("<spring:message code='ezBoard.Notimjs08'/>");
						return;
					}

					if (pEndDate != "" && pNtEndDate != "" && pEndDate < pNtEndDate) {
						alert("<spring:message code='ezBoard.Notimjs09'/>");
						return;
					}
				}

				if (document.getElementById("majorVersion") != null && document.getElementById("minorVersion") != null) {
					if (!checkVersionValidate()) {
						return;
					}
				}

		        newID = "{" +NewGuid+ "}";
		        var xmlDom = createXmlDom();
		        var xmlhttp = createXMLHttpRequest();

		        var objNode = null, objSubNode = null, objDataNode = null;
		        objNode = createNodeInsert(xmlDom, objNode, "NODES");
		        objSubNode = createNodeAndAppandNode(xmlDom, objNode, objSubNode, "NODE");

		        if (gubun != "3") {
		            if (pMode != "modify") {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMID", newID);
		            } else {
						var ii = useVersion === "Y" ? (historyModify === "true" ? strItemID : newID) : strItemID;

		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMID", ii);
		            }
		        }
		        
		        var importance = "";
		        if (document.getElementById('chkEmergent').checked) {
		            importance = "1";
		        } else {
		            importance = "0";
		        }
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "BOARDID", pBoardID);
		        if (gubun != "2") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERID", SSUserID);
					if ('Y' == writerFlag) {
						var flagwriterName = $('#writerFlag').val().toString().split("\\");
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME", MakeXMLString(flagwriterName[0]));
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME2", MakeXMLString(flagwriterName[1]));
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAMETYPE", MakeXMLString(flagwriterName[2]));
					} else {
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME", MakeXMLString(SSUserName));
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME2", MakeXMLString(SSUserName2));
					}
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTID", SSDeptID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME", MakeXMLString(SSDeptName));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME2", MakeXMLString(SSDeptName2));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYID", SSCompanyID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME", MakeXMLString(SSCompanyName));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME2", MakeXMLString(SSCompanyName2));
		        }
		        else {
		            /* 2019-03-07 홍승비 - 익명게시판 표시이름 체크 시 앞뒤공백 제거 강화(일본어 전각문자 공백 체크) */
		            var nickname = document.getElementById("txtNickName").value;
		        	var nickname2 = ReplaceText(nickname, "　", " ");
		            if (trim(nickname) == "" || trim(nickname2) == "") {
		            	nickname = "<spring:message code='ezBoard.t286' />";
		            }

		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERID", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME", MakeXMLString(nickname));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME2", MakeXMLString(nickname));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTID", "");
		            /* 2018.02.09 김기하 새게시물에서 익명게시판 부서가 null로 나오는 것을 공백처리 */
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME", MakeXMLString(" "));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME2", MakeXMLString(" "));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYID", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME2", "");
		        }
		        
		        /* 2020-03-19 홍승비 - 예약게시물 수정 > 예약게시 취소한 경우 플래그 추가 */
				var isReservedCancel = "";
				if (pReservedItem == "true" && document.getElementById("chk_reservation").checked == false) {
					isReservedCancel = "true";
				}
				createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "RSVCANCEL", isReservedCancel);
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "IMPORTANCE", importance);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TITLE", document.getElementById("txtTitle").value.replace(/[\t\n\r]+/g, ' ').trim());
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "STARTDATE", pStartDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ENDDATE", pEndDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ABSTRACT", document.getElementById("txtAbstract").value);
		        
		        if (CrossYN() && pUrl.toLowerCase().indexOf(".hwp") < 0 ) {
		            if (attachxml != "") {
						callMoveAttachFileOrder(attachxml);
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", attachxml);
		            } else {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", "");
		            }
		        } else {
	            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", AttachFileList2());
		        }
		        
            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "REALFILENAMES", realFileNames);

		        /* 2021-02-16 홍승비 - 익명게시판에 TOPWRITERID 저장하지 않도록 수정 */
		        if (pMode == "new" || pMode == "new1" || pMode == "boardContent" || pMode == "boardAttach" || pUrl != "" || orgMode == "temp") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", newID);
		            
		            if (gubun == "2") {
		            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", "");
		            } else {
		            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", SSUserID);
		            }
		            
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", "1");
		        } else if ((pMode == "modify" || pMode == "temp") && pReservedItem == "") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            
		            if (gubun == "2") {
		            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", "");
		            } else {
		            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", strWriterID);
		            }
		            
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", strParentWriteDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);
		        } else if ((pMode == "modify" || pMode == "temp") && pReservedItem == "true") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            
		            if (gubun == "2") {
		            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", "");
		            } else {
		            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", strWriterID);
		            }
		            
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", pStartDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);
		        } else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            
		            if (gubun == "2") {
		            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", "");
		            } else {
		            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", strWriterID);
		            }
		            
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", strParentWriteDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);
		        }

		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "FILEPATH", pUploadFilePath);
		        //gubun 사용해야되서 추가
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "GUBUN", gubun);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE1", "");
				createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "NTSTARTDATE", pNtStartDate);
				createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "NTENDDATE", pNtEndDate);

		        if (gubun != "3" && document.getElementById('noticePost').checked) {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE2", "1");
		        }
		        else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE2", "");
		        }

				if (gubun != "2") {
					if ('Y' == writerFlag && chkUseDept.checked) {
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE3", SSDeptName);
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE32", SSDeptName2);
					} else {
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE3", strUserRank);
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE32", strUserRank2);
					}
		            if (gubun != "3") {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", strUserPhone);
		            }
		            else {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", MakeXMLString(GetFileName()));
		            }
		        }
		        else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE3", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE32", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", "");
		        }

		        if (gubun != "3") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE5", "");
		        }
		        else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE5", MakeXMLString(GetSmallUrl()));
		        }
		        var obj = GetBODY(document.getElementById('docContent')).getElementsByTagName("TD");
		        for (var i = 0; i < obj.length; i++) {
		            if (obj[i].free == "")
		                obj[i].removeAttribute('free');
		            if (obj[i].className == "FIELD")
		                obj[i].removeAttribute('className');
		        }

		        setTimeout(JSleep, 1000);

		        if (editor != "HWP") {
			        var strBody = message.GetEditorContent();
			        
			        if (pDocID != "" && pUrl.toLowerCase().indexOf(".mht") > -1) {
			        	strBody = message.GetEditorContent() + "<hr><div contenteditable='false' >" + GetBODY(document.getElementById('docContent')).innerHTML + "</div>";
			        } else {
			        	strBody = message.GetEditorContent() + "<div contenteditable='false' >" + GetBODY(document.getElementById('docContent')).innerHTML + "</div>";
			        }
			        
			        // 게시물 내용을 db에 넣기 위한 변수 2018-04-06 강민수92
			        var strContent = strBody;		        
			        
					strBody = strBody.replace(/&quot;/gi, "\'");
					
					//html 태그를 제거
					strContent = strContent.replace(/(<([^>]+)>)/gi, "");
					
	      			if (strBody.indexOf("url(\'/") > -1) {
	      				strBody = strBody.replace("url(\'/", "url(\'");
	      			}
	      			
	      			/* 2019-04-01 홍승비 - MHT파일 변환 및 저장 시 예외처리 추가 */
	      			try {
				        if (trim_Cross(strBody) != "" || pDocID == "") {
				            strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + strBody + "</BODY>" + "</HTML>", "");
				        }
				        else {
				            if (pDocID == "")
				                strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(strBody) + "</BODY>" + "</HTML>", "");
				            else if (pUrl.toLowerCase().indexOf(".mht") > -1) {
				                var tempstr = strBody + "<hr><br/>" + GetBODY(document.getElementById('docContent')).innerHTML;
				                strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(tempstr) + "</BODY>" + "</HTML>", "");
				            } else {
								var tempstr = strBody + "<br/>" + GetBODY(document.getElementById('docContent')).innerHTML;
								strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(tempstr) + "</BODY>" + "</HTML>", "");
				            }
				        }
	      			} catch (e) {
	      				alert("<spring:message code='ezCommunity.lhj04'/>");
	      				return;
	      			}
			        
					createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCCONTENT", strContent);
			        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "CONTENT", strBody.replace(/\r\n/g, "@r!n@"));
		        } else {
		        	var hwpContent = hwpHtml;
		        	hwpHtml = hwpHtml.replace(/&quot;/gi, "\'");
		        	hwpContent = hwpContent.replace(/(<([^>]+)>)/gi, "");
		        	if (hwpHtml.indexOf("url(\'/") > -1) {
		        		hwpHtml = hwpHtml.replace("url(\'/", "url(\'");
	      			}
		        	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCCONTENT", hwpContent);
			        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "CONTENT", hwpHtml.replace(/\r\n/g, "@r!n@"));
		        }

		        if (gubun == "2") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD", rsa.encrypt(document.getElementById('txtPassWord').value));
		        } else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD", "");
		        }
		        
		        if (pMode != "new" && pMode != "new1" && pMode != "reply" && pMode != "temp" && pMode != "boardContent" && pMode != "boardContent" && pReservedItem != "true") {
		            if ((document.getElementById("readCount") != undefined) && (document.getElementById("readCount").checked == true)) {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "READCOUNTFLAG", "Y");
		            } else{
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "READCOUNTFLAG", "N");
		        	}
		         } else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "READCOUNTFLAG", "N");
		        }
		        
				// 2024-10-21 박기범 - 게시물 공개 여부
				createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PUBLICFLAG", !document.getElementById("publicFlag") || document.getElementById("publicFlag").checked ? "Y" : "N");
				
				var colType = new Array();
				var tableCol = new Array();
				
				<c:forEach items="${boardAttributeListVO}" var = "item" >
					colType.push("${item.colType}");
					tableCol.push("${item.tableCol}");
				</c:forEach>
				
				for (var i = 0; i < colType.length;i++) {
		        	if (colType[i] == "radio") {
		        		createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase(), MakeXMLString(GetRadioVal(tableCol[i])));
		        	} else if(colType[i] == "text") {
		        		createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase(), MakeXMLString(document.getElementById(tableCol[i]).value));
		        	} else if(colType[i] == "check") {
		        		createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase(), MakeXMLString(GetCheckVal(tableCol[i])));
		        	} else if(colType[i] == "cal") {
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase(), MakeXMLString(document.getElementById(tableCol[i]).value));
					} else if(colType[i] == "select") {
						createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase(), MakeXMLString(document.getElementById(tableCol[i]).value));
					} else if (colType[i] == "people") {
					    // 2024-07-31 전인하 - 게시판 > 확장컬럼 > peoplePicker 타입 저장 시 문자열 형태로 입력값 가공
					    // 각 유저는 구분자 ; 를 통해 구별함. 
					    // 유저 상세정보는 /를 구분자로 사용하며 값의 의미는 순서대로 id값/이름1/이름2/타입(부서 직위 직책 등).
					    var peoplePickerString = "";
					    var authListColumn = authList.filter((e) => e.columnName == tableCol[i]);
                        if (authListColumn.length > 0) {
                            var authListData = authListColumn[0].data;
                            for (var j = 0; j < authListData.length; j++) {
                                var userId = authListData[j].userId;
                                var userName1 = authListData[j].userName1;
                                var userName2 = authListData[j].userName2;
                                var userType = authListData[j].userType;
                                peoplePickerString += userId + "/";
                                peoplePickerString += userName1 + "/";
                                peoplePickerString += userName2 + "/";
                                peoplePickerString += userType + ";";
                            }   
                        }
					    createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase(), MakeXMLString(escapeForJson(peoplePickerString)));
					} else if (colType[i] == "textArea") {
					    createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase(), MakeXMLString(document.getElementById(tableCol[i]).value).replace(/(?:\r\n|\r|\n)/g, '<br/>'));
					}
				}

				if (useKeywordFlag != null && useKeywordFlag == 'Y') {
				    for (var keyword of keywordArr) {
				        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "KEYWORD", keyword);
				    }
				}
				
                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "useVersion", useVersion);

				if (useVersion === "Y") {
					createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "version", version == null ? "" : version);
				}

				createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "parentItemID", parentItemID == "" ? newID : parentItemID);
				createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "historyModify", historyModify);

		        xmlhttp.open("POST", "/ezBoard/saveItem.do?mode=" + pMode + "&guBun=" + gubun, false);
		        xmlhttp.send(xmlDom);
				if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "OK") {
		            xmlhttp = null;
		            xmlDom = null;
		            if (orgMode == "temp") {
		                var xmlDom = createXmlDom();
		                var xmlhttp = createXMLHttpRequest();
		
		                xmlhttp.open("POST", "/ezBoard/deleteTempItem.do", false);
		                xmlhttp.send(strItemID);
		            }
		            
		            if (pMode != "temp") {
		                if (document.getElementById("chk_reservation").checked == false) {
		                	/* 2023-11-15 홍승비 - 승인게시판의 경우, 게시물 승인 전에 관리자에게 게시알림을 보내지 않도록 수정 + 답변알림을 보내지 않도록 수정 */
		                	if ("${boardInfo.apprFlag}" != "Y") {
			                	/* 2022-08-24 홍승비 - 임시저장한 게시물 저장(등록) 시, 해당 게시판의 관리자에게 게시알림이 가지 않는 오류 수정 */
			                    if (strItemID == "" || (strItemID != "" && orgMode == "temp")) {
			                        xmlhttp = createXMLHttpRequest();
			                        xmlhttp.open("POST", "/ezBoard/sendPostNotiForAdmin.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(newID), false);
			                        xmlhttp.send();
			                        xmlhttp = null;
			                    }
			                    if (pMode == "reply") {
			                        xmlhttp = createXMLHttpRequest();
			                        xmlhttp.open("POST", "/ezBoard/sendReplyNotice.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(newID) + "&itemTreeID=" + encodeURIComponent(strUpperItemIDTree), false);
			                        xmlhttp.send();
			                        xmlhttp = null;
			                    }
		                	}
		                    /* 2021-06-22 홍승비 - 게시판 게시알림(일반 사용자 대상 발송), 수정알림 추가 (승인게시판의 경우, 게시물 승인 전에 게시알림 메일 사용안함) */
		                    if (("${boardInfo.apprFlag}" != "Y") && (pMode == "new" || pMode == "new1" || pMode == "boardContent" || pMode == "boardAttach" || pMode == "save")) { // 게시알림
		                    	sendBoardAlert("new", pBoardID, newID, isAllGroupBoard);
		                    }
		                    /* 2023-11-17 홍승비 - 승인게시판의 경우, 반려된 게시물을 재작성 후 저장 시 수정알림메일을 발송하지 않도록 수정 */
		                    else if ((itemApprFlag == null || itemApprFlag == "" || itemApprFlag == "Y") && pMode == "modify") { // 수정알림 (반려된 게시물이 아닌 경우에만 발송)
		                    	sendBoardAlert("modify", pBoardID, strItemID, isAllGroupBoard);
		                    }
		                    
		                    alert("<spring:message code='ezBoard.t399' />");
		                } else {
		                    alert("<spring:message code='ezBoard.t400' />" + " " + pStartDate.substr(0, 16) + "<spring:message code='ezBoard.t401' />");
		                }
		                
		                /* 2019-05-07 홍승비 - 승인게시판의 경우, 반려된 게시물을 재작성 후 저장 시 승인요청 알림메일 발송하도록 수정 */
		                /* 2019-05-07 홍승비 - 이미 승인된 게시물을 수정하는 경우, 승인요청 알림 발송하지 않도록 수정 */
		                if (("${boardInfo.apprMail_FG}" == "Y") && ((pMode != "modify") || ((itemApprFlag != null && itemApprFlag != "Y") && pMode == "modify"))) {
		                	var tItemID = strItemID; // 게시물 수정(재작성)
		                	if (pMode != "modify") { // 신규 게시물 등록
		                		tItemID = newID;
		                	}
		                	
		                    xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "/ezBoard/sendApprNotice.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(tItemID), false);
		                    xmlhttp.send();
		                    xmlhttp = null;
		                }
		            }
		            else {
		                alert("<spring:message code='ezBoard.t10033' />");
		            }
		            
		            try {
						window.opener.leftCountRf(pBoardID);
					} catch (e) {
					    console.log(e);
					}
					
					// 전자결재문서(시행문, 문서발송)를 게시한 경우의 자동발송 처리 (SuccessBoard 함수)
		            try {
			            if (window.parent != null && window.parent.SuccessBoard != undefined) {
			                try {
			                    window.parent.SuccessBoard();
			                }
			                catch (e) {
			                }
			            }
			            else if (window.opener != null && window.opener.SuccessBoard != undefined) {
			                try {
			                    window.opener.SuccessBoard();
			                }
			                catch (e) {
			                }
			            }
			            else {
			                try {
			                    if (typeof (window.parent.SuccessBoard) == null || typeof (window.parent.SuccessBoard) == "undefined") {
		                            try {
		                                var checkboard = window.opener.location.toString();
		                                if (checkboard.indexOf("mailPreviewContent") > -1) {
		                                    window.close();
		                                    return;
		                                }
		                                if (checkboard.indexOf("mailReadContent.do") < 0) {
		                                	/* 2019-10-24 홍승비 - 게시물 임시보관함에서 저장 또는 임시저장 시, 미리보기가 열려있으면 전체 새로고침 (일반/QNA게시판) */
		                					if ((window.opener.location.href.indexOf("/ezBoard/boardItemListTemp.do") > -1) &&
		                							((window.opener.document.getElementById("PreviewRayerH").style.display != "none" && window.opener.document.getElementById("PreviewRayerH").style.display != "") ||
		                							(window.opener.document.getElementById("PreviewRayerW").style.display != "none" && window.opener.document.getElementById("PreviewRayerW").style.display != ""))) {
		                						window.opener.refresh_onclick();
		                					}
		                					else {
		                						window.opener.getBoardList();
		                					}
		                                }
		                            } catch (e) {
		                            }
			                    }
			                }
			                catch (e) { }
			                
			                /* 2019-03-19 홍승비 - 게시물 재전송 시 새로고침 동작 수정 */
			                if (pMode == "boardContent" || pMode == "boardAttach") {
			                    try {
			                        if (typeof (window.parent.parent.SuccessBoard) == null || typeof (window.parent.parent.SuccessBoard) == "undefined") {
			                            var checkboard = window.parent.location.toString();
			                            if (checkboard.indexOf("mailReadContent.do") < 0) {
			                                window.opener.opener.location.reload(false);
			                            }
			                        }
			                    }
			                    catch (e) { 
			                    }
			                }
			            }
					} catch (e) {
					}
					try {
						if (parent.opener != null && parent.opener.getNoticePortletList != undefined) {
							parent.opener.getNoticePortletList();
						}
					} catch (e) {console.log(e); }	
					
					try{
						// 카드A형, 카드B형, 리스트형 포틀릿 업데이트 되도록 수정
			            if (parent.opener != null && parent.opener.refreshBordPortletInfo != undefined) {
			            	var customBoardList = parent.opener.document.getElementsByClassName("customBoard");
			            	var customBoardCount = customBoardList.length;
			            	
			            	for (var i = 0; i < customBoardCount; i++) {
			            		var boardId = customBoardList[i].querySelector(".portletPlus").getAttribute("data1");
			            		
			            		if (boardId == pBoardID) {
			            			var portletId = customBoardList[i].parentElement.id;
			            			portletId = portletId.substring(0, portletId.indexOf("P"));
			            			parent.opener.refreshBordPortletInfo(portletId);
			            		}
			            	}
			            }
					} catch (e) {console.log(e); }
					
					try { // 탭게시판  포틀릿 새로고침
						if (parent.opener != null && parent.opener.refreshTab != undefined) {
                 			parent.opener.refreshTab();
                 		}
                 	} catch (e) {console.log(e);}
					
					try{
						if (parent.opener != null && parent.opener.getBoardList_NewBoardSTD != undefined) {
							parent.opener.getBoardList_NewBoardSTD();
						} else if (gubun === "9") {
							parent.location.href = "/ezBoard/fileViewerBoard.do?boardID="  + encodeURIComponent(pBoardID);
						}
					} catch (e) {console.log(e); }
					

                    if (pMode == "modify") {
                        if (useVersion == "Y") {
                            document.location.href = "/ezBoard/boardItemView.do?showAdjacent=&itemID=" + encodeURIComponent("{" + NewGuid +"}") + "&boardID=" + encodeURIComponent(pBoardID) + "&location=GENERAL&__wwidth=1920";
                        } else {
                            document.location.href = "/ezBoard/boardItemView.do?showAdjacent=&itemID=" + encodeURIComponent(strItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&location=GENERAL&__wwidth=1920";
                        } 
                        if (window.opener) {
                            window.opener.location.reload();
                        }
                    } else {
                        if (window.opener) {
                            window.opener.location.reload();
                        }
                        window.close();
                    }
		        } else {
		            if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "XSS") {
						alert("<spring:message code='ezBoard.t00001' />");
					}
		            else if (getNodeText(loadXMLString(xmlhttp.responseText)) == "INACCESSIBLE") {
						alert(strLang173);
					}
					else if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "GUBUNCHANGED") {
		                alert(strLangJIHgubunChange02);
		            }
					else if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "DUPLICATED") {
						alert(strLangFileViewr01);
					}
		            else {
						alert("<spring:message code='ezBoard.t403' />" + getNodeText(loadXMLString(xmlhttp.responseText)));
					}
		        }
		        xmlhttp = null;
		        xmlDom = null;
		    	
		    }
			
			function callMoveAttachFileOrder(attachxml) {
				var tmpFileList = dadiframe.document.querySelectorAll("#filelist tr[_fileindex]");
				if(tmpFileList.length > 0) {
					dadiframe.moveAttachFileOrder(tmpFileList, attachxml);
				}
			}
			
		    function JSleep() {
		    	return;
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function MakeXMLString(str) {
		        str = ReplaceText(str, "&", "&amp;");
		        str = ReplaceText(str, "<", "&lt;");
		        str = ReplaceText(str, ">", "&gt;");
		        return str;
		    }
		    function btn_PostDate_Clear() {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var settime = "${startDateTime}";
		        var NowDate = new Date(settime.substring(0, 4), settime.substring(5, 7), settime.substring(8, 10), settime.substring(11, 13), settime.substring(14, 16));
		        NowDate.setMonth(NowDate.getMonth() - 1);
		
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		    }
		    function ChkPermanent() {
		        if (pBoardType != "SELECT") {
		            if (ExpireDays != -1) {
		                if(!FirstFlag) {
		                    alert("<spring:message code='ezBoard.t405' />");
		                }
		
		                document.getElementById("ChkPermanence").checked = false;
		                return;
		            }
		            if (document.getElementById("ChkPermanence").checked) {
		                document.getElementById("Makedate").style.visibility = "hidden";
		            } else {
		            	document.getElementById("Makedate").style.visibility = "visible";
		            	
		                if (strEndDate != "") {
		                    if (strEndDate.substring(0, 4) == "9999") {
		                        $("#Sdatepicker2").datepicker({
		                            changeMonth: true,
		                            changeYear: true,
		                            autoSize: true,
		                            showOn: "both",
		                            buttonImage: "/images/ImgIcon/calendar-month.png",
		                            buttonImageOnly: true
		                        });
		                        var NowDate2 = new Date();
		                        NowDate2.setMonth(NowDate2.getMonth() + 1);
		                        $("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
		                        $("#Sdatepicker2").datepicker('setDate', NowDate2);
		                    }
		                    else {
		                        //var NowDate = new Date(strEndDate.substring(0, 4), strEndDate.substring(5, 7), strEndDate.substring(8, 10), strEndDate.substring(11, 13), strEndDate.substring(14, 16));
		                        //NowDate.setMonth(NowDate.getMonth() - 1);
		                        //2017-12-01 영구게시가 아닐때 만료일자를 지정한 날짜가 그대로 나오도록 수정
		                        $("#Sdatepicker2").datepicker('setDate', strEndDate);
		                    }
		                }
		            }
		        }
		    }
		    function Reservation_onclick() {
		        if (document.getElementById("chk_reservation").checked) {
		        	document.getElementById("reservation_date").style.visibility = "";
		        } else {
		        	document.getElementById("reservation_date").style.visibility = "hidden";
		        }
		    }

			function NotiPost_onclick() {
				if (document.getElementById("noticePost").checked) {
					document.getElementById("noti_setTime").style.display = "";
					if (document.getElementById("NotiPeriod").checked) {
						document.getElementById("notiTimeset").style.display ="";
					} else {
						document.getElementById("notiTimeset").style.display ="none";
					}
				} else {
					document.getElementById("noti_setTime").style.display = "none";
				}
			}

			function Noti_setTime() { /* 2023-09-22 민지수 - 게시물 수정 시 기존 정보로 불러오도록 구현 */
				if (strNotiEnd != null && strNotiEnd != ""){
					if (strNotiEnd.substring(0, 4) == "9999") {
						document.getElementById("NotiPermanece").checked = true;
					} else {
						document.getElementById("NotiPeriod").checked = true;
						$("#noti_end").datepicker('setDate', strNotiEnd);

						if (strNotiStart.substring(0,10) < strNow.substring(0,10)) { // 설정했던 공지 시작날짜가 현재날짜보다 이전이면 현재날짜로 세팅
							$("#noti_start").datepicker('setDate',strNow);
						} else { // 현재날짜보다 이후이면 설정한 날짜로 세팅
							$("#noti_start").datepicker('setDate',strNotiStart);
						}
						document.getElementById("notiTimeset").style.display ="";
					}
				} else if(document.getElementById("NotiPeriod").checked){
					document.getElementById("notiTimeset").style.display ="";
				} else {
					document.getElementById("notiTimeset").style.display ="none";
				}
			}

		    function PreviewItem() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
				var pWriterNameType = "";
				
				if (writerFlag == "Y") {
					if (chkUseDept.checked) {
						pWriterNameType = "1";
					} else {
						pWriterNameType = "0";
					}
				}
				
		        if (gubun != "2")
		            window.open("/ezBoard/boardItemPreView.do?guBun=" + gubun + "&boardID=" + encodeURIComponent(pBoardID) + "&writerNameType=" + pWriterNameType, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,height=720,width=744,top=" + pTop + ",left=" + pLeft, "");
		        else {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                window.open("/ezBoard/boardItemPreView.do?guBun=" + gubun + "&boardID=" + encodeURIComponent(pBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,height=640,width=744,top=" + pTop + ",left=" + pLeft, "");
		            }
		            else {
		                window.open("/ezBoard/boardItemPreView.do?guBun=" + gubun + "&boardID=" + encodeURIComponent(pBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,height=690,width=744,top=" + pTop + ",left=" + pLeft, "");
		            }
		        }
		    }
		    function AddDate(pDate, pDays) {
		        var dt = new Date(pDate);
		        dt.setDate(dt.getDate() + pDays);
		        return dt;
		    }
		    function AutoAddtoExpireDate() {
		        var temp = ExpireDays;
		        if (temp == -1) temp = 30;
		
		        idDatepicker.vtLocalEndDate = AddDate(idDatepicker.vtLocalDate, temp);
		    }
		    var BoardSelect_Cross_dialogArgument = new Array();
		    var OpenWin = null;
		    function SelectBoard(CompleteFunction) {
		        BoardSelect_Cross_dialogArgument[0] = "";
		        BoardSelect_Cross_dialogArgument[1] = CompleteFunction;
		        var url = "/ezBoard/boardSelect.do";
		
		        OpenWin = window.open(url, "BoardSelect_Cross", GetOpenWindowfeature(360, 656));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		
		    var MailxmlHTTP = createXMLHttpRequest();
		    function InsertMailInfo() {
		        var _newGuid = "{" + NewGuid + "}";
		        var strQuery = "<DATA><URL>" + pUrl + "</URL><NEWGUID>" + _newGuid + "</NEWGUID><ATTACHLIMIT>" + AttachLimit + "</ATTACHLIMIT></DATA>";
		        var FileName = "";
		        var FileURL = "";
		        var ItemID = "";
		        var requestUrl = "/ezEmail/mailReadBoard.do?itemType=board";
		        
		        if (typeof(mailShareId) != "undefined" && mailShareId != "") {
            		requestUrl += "&shareId=" + encodeURIComponent(mailShareId);
				}
		        
		        MailxmlHTTP.open("POST", requestUrl, false);
		        MailxmlHTTP.send(strQuery);
		        
		        if (MailxmlHTTP.status == 200) {
		            var mailXml = loadXMLString(MailxmlHTTP.responseText);
		            document.getElementById('txtTitle').value = "<spring:message code='ezBoard.t409' />" + getNodeText(mailXml.getElementsByTagName("SUBJECT").item(0));
		            var Content = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
		            Content += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code='ezBoard.t410' /></B>-----</p>";
		            Content += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t411' /></B>" + getNodeText(mailXml.getElementsByTagName("DATE").item(0)) + "</p>";
		            
		            if (getNodeText(mailXml.getElementsByTagName("COMMENT").item(0)) != "") {
		                Content += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t412' /></B>" + ReplaceText(getNodeText(mailXml.getElementsByTagName("FROMNAME").item(0)), "\\\"", "");
		                Content += "  (" + getNodeText(mailXml.getElementsByTagName("COMMENT").item(0)) + ") </p>";
		            } else {
		                Content += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t412' /></B>" + ReplaceText(ReplaceText(getNodeText(mailXml.getElementsByTagName("FROMNAME").item(0)), "<", "&lt"), ">", "&gt;") + "</p>";
		            }
		
		            Content += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t413' /></B>" + getNodeText(mailXml.getElementsByTagName("SUBJECT").item(0)) + "</p>";
		            Content += "<p " + defaultFontAndSize + "></p><p " + defaultFontAndSize + "></p>";
		            Content += "<p " + defaultFontAndSize + ">" + getNodeText(mailXml.getElementsByTagName("HTMLDESCRIPTION").item(0)) + "</p>";
		            Content = ReplaceText(Content, "id=doctitle", "");
		            Content = ReplaceText(Content, "id=\"doctitle\"", "");
		            Content = ReplaceText(Content, "id=\'doctitle\'", "");
			            
		            if (Content.indexOf("id=\"_BigAttachListHtml\"") != -1) {
		            	Content = ReplaceText(Content, "<td width=\"75%\"", "<td width=\"65%\"");
		            	Content = ReplaceText(Content, "<td width=\"30%\"", "<td width=\"35%\"");
		            }
		            
		            Content = '<div '+defaultFontAndSize+'>' + Content + '</div>';
			
		            message.SetEditorContent(Content);
		            
		            if (mailXml.getElementsByTagName("OVERSIZE").length > 0) {
	            		alert(strLang8 + AttachLimit + "MB" + strLang9);
	            	} else {
			            if (mailXml.getElementsByTagName("ROOT").length) {
		            		mgubun = "M";
			                
			                attachxml = getNodeText(mailXml.getElementsByTagName("ATTACH").item(0));
			                var strXML = getXmlString(mailXml.getElementsByTagName("ROOT").item(0));
			                returnvalue(strXML);
			            }
	            	}
		        }
		    }
		    
		    /* 2017-01-11 이효민사원 - 사용안함 
		    function InsertMailInfo_Complete(ret) {
		        OpenWin.close();
		        if (ret == "") {
		            if (confirm("<spring:message code='ezBoard.t414' />")) {
		                window.close();
		            }
		            else {
		                OpenWin = null;
		                SelectBoard(InsertMailInfo_Complete);
		                return;
		            }
		        }
		        if (typeof (ret) == "undefined") return "";
		
		        pBoardID = ret;
		        GetBoardInfo();
		        InitializeSettings();
		
		        if (pcheckForm.toUpperCase() == "TRUE") {
		            var tempHtml = message.GetEditorContent();
		            var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=BOARDFORM&DOCID=" + pBoardID;
		            var htmlData = message.GetEditorContentURL(fullPath);
		            message.SetEditorContent(htmlData + tempHtml);
		        }
		
		        if (pUseBackGround.toUpperCase() == "TRUE") {
		            document.getElementById("pUseBackGroundTR").style.display = "";
		            GetBackGroundImage();
		        }
		        else
		            document.getElementById("pUseBackGroundTR").style.display = "none";
		
		
		        var mailXml = loadXMLString(MailxmlHTTP.responseText);
		        if (mailXml.getElementsByTagName("ATTACHMENT").length > 0) {
		            mgubun = "M";
		            var attachHTTP = createXMLHttpRequest();
		            var filefullpath = "";
		            var strXML = "<ROOT><NODES>";
		            for (var i = 0; i < mailXml.getElementsByTagName("ATTACHMENT").length; i++) {
		                FileName = getNodeText(mailXml.getElementsByTagName("ATTACHMENT").item(i));
		                FileURL = getNodeText(mailXml.getElementsByTagName("ATTACHMENTURL").item(i));
		                ItemID = getNodeText(mailXml.getElementsByTagName("ITEMID").item(0));
		                attachHTTP.open("POST", document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_downloadattachfile.aspx?mode=Attach&ID=" + encodeURIComponent(ItemID) + "&ATTID=" + encodeURIComponent(FileURL) + "&filepath=" + pUploadFilePath + "\\" + pBoardID + "\\uploadFile" + "&newGuid=" + NewGuid, false);
		                attachHTTP.send();
		                filefullpath = pUploadFilePath + "\\" + pBoardID + "\\uploadFile\\" + NewGuid + "_" + FileName;
		                var fileHTTP = createXMLHttpRequest();
		                fileHTTP.open("POST", "interASP/getFileSize.aspx?filepath=" + encodeURIComponent(filefullpath), false);
		                fileHTTP.send();
		                var size = fileHTTP.responseText;
		                strXML += "<NODE>";
		                strXML += "<PUPLOADSN><![CDATA[" + NewGuid + "_" + FileName + "]]></PUPLOADSN>";
		                strXML += "<RESULTUPLOADA><![CDATA[" + "true" + "]]></RESULTUPLOADA>";
		                strXML += "<PFILENAME><![CDATA[" + FileName + "]]></PFILENAME>";
		                strXML += "<FILESIZE><![CDATA[" + size + "]]></FILESIZE>";
		                strXML += "<FILELOCATION><![CDATA[" + filefullpath + "]]></FILELOCATION>";
		                strXML += "</NODE>";
		            }
		            strXML += "</NODES></ROOT>";
		            returnvalue(strXML);
		        }
		    } */
		    
		     /*
		    function InsertDocInfo() {
		        var ret = "";
		        document.getElementById("docTR").style.display = "";
		        ret = SelectBoard(InsertDocInfo_Complete);
		    }
		    */

			/* 2024-05-21 김유진 - 일정 정보 가져오기 */
			function InsertScheduleInfo() {
				var _newGuid = "{" + NewGuid + "}";
				var strQuery = "<DATA><URL>" + pUrl + "</URL><NEWGUID>" + _newGuid + "</NEWGUID><ATTACHLIMIT>" + AttachLimit + "</ATTACHLIMIT><SCHEDULEID>" + scheduleId + "</SCHEDULEID></DATA>";
				var requestUrl = "/ezSchedule/ezScheduleReadBoard.do";
				MailxmlHTTP.open("POST", requestUrl, false);
				MailxmlHTTP.send(strQuery);

				if (MailxmlHTTP.status == 200) {
					var retXml = loadXMLString(MailxmlHTTP.responseText);
					document.getElementById('txtTitle').value = "일정게시 : " + getNodeText(retXml.getElementsByTagName("SUBJECT").item(0));
					var Content = "<P>&nbsp;<br></P><br><DIV><br><br>-----<B>[&nbsp;일정 내용&nbsp;]</B>-----</DIV><DIV><B>날짜 : </B>" + getNodeText(retXml.getElementsByTagName("DATE").item(0)) + "</DIV>";
					Content = Content + "<DIV><B>작성자 : </B>" + ReplaceText(ReplaceText(getNodeText(retXml.getElementsByTagName("FROMNAME").item(0)), "<", "&lt"), ">", "&gt;") + "</DIV>";
					Content = Content + "<DIV><B>제목 : </B>" + getNodeText(retXml.getElementsByTagName("SUBJECT").item(0)) + "</DIV><P><br><br>" + getNodeText(retXml.getElementsByTagName("HTMLDESCRIPTION").item(0)) + "</P>";
					Content = ReplaceText(Content, "id=doctitle", "");
					Content = ReplaceText(Content, "id=\"doctitle\"", "");
					Content = ReplaceText(Content, "id=\'doctitle\'", "");

					message.SetEditorContent(Content);

					var attCnt = retXml.getElementsByTagName("ATTACHID").length;
					if (attCnt > 0) {
						var xmlstringUl = "<DATA><BOARDID>" + pBoardID + "</BOARDID><ROWS>";
						for (i = 0; i < attCnt; i++) {
							xmlstringUl += "<ROW>";
							xmlstringUl += "<FILENAME>"+ getNodeText(retXml.getElementsByTagName("FILENAME").item(i)) + "</FILENAME>";
							xmlstringUl += "<FILEPATH>"+ decodeURIComponent(getNodeText(retXml.getElementsByTagName("FILEPATH").item(i))) + "</FILEPATH>";
							xmlstringUl += "<FILESIZE>"+ getNodeText( retXml.getElementsByTagName("FILESIZE").item(i)) + "</FILESIZE>";
							xmlstringUl += "</ROW>";
						}
						xmlstringUl += "</ROWS></DATA>";
						uploadScheduleFile(xmlstringUl);
					}
				}


			}
		    
	        function InsertDocInfo() {
	            if (OpenWin != null) {
	                OpenWin.close();
	                if (ret == "") {
	                    if (confirm("<spring:message code='ezBoard.t414' />")) {
	                        window.close();
	                    }
	                    else {
	                        OpenWin = null;
	                        SelectBoard(InsertDocInfo_Complete);
	                        return;
	                    }
	                }
	
	                if (typeof (ret) == "undefined") return "";
	                pBoardID = ret;
	            }
		        GetBoardInfo();
		        InitializeSettings();
		
		        if (pUseBackGround.toUpperCase() == "TRUE") {
		            document.getElementById("pUseBackGroundTR").style.display = "";
		            GetBackGroundImage();
		        }
		        else
		            document.getElementById("pUseBackGroundTR").style.display = "none";
		        
				if (pcheckForm.toUpperCase() == "TRUE") {
		            var tempHtml = message.GetEditorContent();
		            var fullPath = "";
                	$.ajax({
    					type : "POST",
    					dataType : "text",
    					async : false,
    					url : "/ezBoard/getContentInfo.do",	        			
    					data : { type : "BOARDFORM", 
    							 docID: pBoardID
    						   },
    					success: function(result){
    						fullPath = result;
    					}        			
    				});
                	if (editor != "HWP") {
                		var htmlData = message.GetEditorContentURL(fullPath);
    		            message.SetEditorContent(htmlData + tempHtml);	
                	} else {
                		var formFrame = document.getElementById("message2");
                		formPath = fullPath;
                		formFrame.src = "/ezBoard/WHWPEditor.do?type=form";
                	}
		        }

		        if (pUrl.toLowerCase().indexOf(".mht") > -1) {
		            var fullPath = encodeURI(pUrl);
		            var tempXML = createXmlDom();
//	 		        var XmlBodyATT = createXmlDom();
		            var XmlBodyDATA = createXmlDom();
		            var tempStr = "";
		            tempStr = ConvertMHTtoHTML(fullPath);
		            tempXML = loadXMLString(tempStr);
//	 		        XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
		            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
		            var htmlData = getNodeText(XmlBodyDATA);
		
		            if (gubun == "3") {
		                document.getElementById('docContent').style.height = "220px";
		            }
		            document.getElementById("docTR").style.display = "";
		
		            var TDRows;
		            if (CrossYN() && pUrl.toLowerCase().indexOf(".hwp") <  0) {
		                docContent.document.body.innerHTML = htmlData.replace(/(<p)/igm, '<div').replace(/<\/p>/igm, '</div>');
		                docContent.document.body.getElementsByTagName("TABLE").item(0).align = "center";
		                TDRows = docContent.document.getElementsByTagName("TD");
		            }
		            else {
		                docContent.document.body.innerHTML = htmlData.replace(/(<p)/igm, '<div').replace(/<\/p>/igm, '</div>');
		                docContent.document.body.getElementsByTagName("TABLE").item(0).align = "center";
		                TDRows = docContent.document.getElementsByTagName("TD");
		            }
		            for (var i = 0; i < TDRows.length; i++) {
		                if (TDRows.item(i).outerHTML.indexOf("class=FIELD") > 0) {
		                    if (TDRows.item(i).childNodes.length == 0) {
		                        if (TDRows.item(i).outerHTML.indexOf("><\/TD>") > 0) {
		                            TDRows.item(i).innerHTML = "&nbsp;";
		                        }
		                    }
		                }
		            }
		        }
		        addAttach();
		    }
		    
		    function addAttach() {
		    	var xmlHTTP = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var xmlstring = "<DOCINFO><DocID>" + pDocID + "</DocID><ORGCOMPANYID>"+ orgCompanyID +"</ORGCOMPANYID></DOCINFO>";
		        xmlpara = loadXMLString(xmlstring);
		        if (pUrl.toLowerCase().indexOf("/upload_approval/") > -1)
		            xmlHTTP.open("POST", "/ezApprovalG/aprAttachMail.do", false);
		        else
		            xmlHTTP.open("POST", "/ezApprovalG/aprAttachMail.do", false);
		        xmlHTTP.send(xmlpara);
		        if (xmlHTTP.status == 200) {
		            var xmldom = createXmlDom();
		            xmldom = loadXMLString(xmlHTTP.responseText);
		            document.getElementById("txtTitle").value = "<spring:message code='ezBoard.t420' />" + getNodeText(GetElementsByTagName(xmldom, "DOCTITLE")[0]);
		            startCheck = false;
		            
		            /* 2023-05-16 김우철 - 파일 업로드를 위한 xml 작성 함수 분리 및 호출 */
		            uploadXml(0, xmldom);
		        }
		    }
		    
		    function GetBoardInfo() {
		        var xmlhttp_boardinfo = createXMLHttpRequest();
		        xmlhttp_boardinfo.open("POST", "/ezBoard/getBoardInfo.do?boardID=" + encodeURIComponent(pBoardID), false);
		        xmlhttp_boardinfo.send();
		        if (xmlhttp_boardinfo.status == 200) {
		            pBoardName = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BOARDNAME")[0]);
		            AttachLimit = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "ATTACHLIMIT")[0]);
		            ExpireDays = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "EXPIREDAYS")[0]);
		            gubun = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "GUBUN")[0]);
		            pcheckForm = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "FORM")[0]);
		            pUseBackGround = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BACKIMAGE")[0]);
		        }
		        xmlhttp_boardinfo = null;
		    }
		    function InitializeSettings() {
		        document.getElementById('BoardSpan').innerText = pBoardName;
		        if (ExpireDays == "-1") {
		            document.getElementById('ChkPermanence').checked = true;
		            document.getElementById('Makedate').style.visibility = "hidden";
		        }
		        else {
		            document.getElementById('ChkPermanence').checked = false;
		            //document.getElementById('Makedate').style.display = "inherit";
		            //idDatepicker.vtLocalEndDate(AddDate(idDatepicker.vtLocalDate(), parseInt(ExpireDays)));
		        }
		    }
		    function Title_onkeyDown(e) {
		        if (window.event) {
		            if (e.keyCode != 9)
		                return;
		        }
		        else {
		            if (e.which != 9)
		                return;
		        }
		    }
		    /* 2018-04-30 홍승비 - 게시물 수정, 답변 시 특수문자 처리 */
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&#039;", "'");
		        str = ReplaceText(str, "&#034;", "\"");
		        str = ReplaceText(str, "&#92;", "\\");
		  	    str = ReplaceText(str, "&amp;", "&");	    
		        return str;
		    }
		    function GetSmallUrl() {
		        var strRet = "";
		        var filepath = "";
		        if (typeof (pAttachListXml) == "string")
		            pAttachListXml = loadXMLString(pAttachListXml);
		        else
		            pAttachListXml = loadXMLString(getXmlString(pAttachListXml));
		
		        if (getXmlString(pAttachListXml) == "") {
		            return "";
		        }
		        var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA2");
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            filepath = getNodeText(xmldomNodes[i]);
		            if (filepath.indexOf(pBoardID) != -1) {
		                var idx = filepath.lastIndexOf("/");
		                if (idx != -1) {
		                    strRet += filepath.substr(0, idx + 1) + "s_" + filepath.substr(idx + 1) + "|";
		                }
		            } else {
		                strRet += pBoardID + "/uploadFile/s_" + getNodeText(xmldomNodes.item(i)) + "|";
		            }
		        }
		        xmldom_attachlist = null;
		        return strRet;
		    }
		    function GetFileName() {
		        var strRet = "";
		        if (typeof (pAttachListXml) == "string")
		            pAttachListXml = loadXMLString(pAttachListXml);
		        else
		            pAttachListXml = loadXMLString(getXmlString(pAttachListXml));
		        if (getXmlString(pAttachListXml) == "") {
		            return "";
		        }
		        var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA1");
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            strRet += getNodeText(xmldomNodes.item(i)) + "|";
		        }
		        return strRet;
		    }
		    
		    var hwpChk = true;
		    function Editor_Complete() {
                /* 2025-01-08 홍승비 - 전자결재 메일 발송 > 웹한글문서 메일로 전송 시, 웹한글기안기의 로딩 순서를 보장하도록 수정 */
                // Editor_Complete() 함수 호출 시점은 iframe 태그 내부 "/ezEditor/selectEditor.do" 페이지의 로딩 시점에 의존함
                // useHwpDownSecurity가 Y일 때만 Whwp api 호출. 전자결재 일반버전에서는 useHwpDownSecurity의 값에 상관없이 Whwp api 호출하지 않음.
                if (useHWP == "YES" && useHwpDownSecurity == "Y" && approvalFlag == "G") {
                    if (hwpChk) {
                        // BuildWebHwpCtrl() 함수의 완료 후 콜백으로 다시 Editor_Complete()을 호출하여, 반드시 웹한글기안기 로딩이 끝난 시점에 한번 더 동작하도록 함
                        HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${webHWPUrl}", function () {
                            isHwpCtrlOpen = true;
                            hwpChk = false;
                            Editor_Complete();  // Editor_Complete() 함수 내부에서 다시 호출된 Editor_Complete() 함수가 아래의 return 코드 이후 동작을 진행
                        });
                        return; // 반드시 return이 필요 (최초에 호출된 Editor_Complete()를 즉시 종료하기 위함으로, 중복 동작을 방지)
                    }
                }
		    
		    	if (editor != "HWP") {
		    		if (flag == false) {
			            flag = true;
			            if (pMode == "new" || pModeOld == "loadpc" || pMode == "boardAttach") {
			                if (pcheckForm.toUpperCase() == "TRUE") {
			                	var fullPath = "";
			                	$.ajax({
			    					type : "POST",
			    					dataType : "text",
			    					async : false,
			    					url : "/ezBoard/getContentInfo.do",	        			
			    					data : { type : "BOARDFORM", 
			    							 docID: pBoardID
			    						   },
			    					success: function(result){
			    						fullPath = result;
			    					}        			
			    				});	
			                    var htmlData = message.GetEditorContentURL(fullPath);
			                    message.SetEditorContent(htmlData);
			                } else {
			                    if (OpenWin == null){
			                        document.getElementById("txtTitle").focus();
			                    }
			                    
			                    message.SetEditorContent("");
			                }
			            } else {
			                if (pUrl == "") {
			                    var fullPath = strContentLocation;
			                    if (pMode == "reply") {
			                        var htmlData = message.GetEditorContentURL(fullPath);
			                        htmlData = ReplaceText(htmlData, "class=&quot;FIELD&quot;", "");
			                        htmlData = ReplaceText(htmlData, "class=FIELD", "");
			                        /* 2020-11-30 홍승비 - 본문의 내용 내부 특수문자 치환할 필요 없으므로 주석처리, 이스케이프 문자 처리 추가 */
	/* 		                        htmlData = ReplaceText(htmlData, "&amp;", "&");
			                        htmlData = ReplaceText(htmlData, "&lt;", "<");
			                        htmlData = ReplaceText(htmlData, "&gt;", ">"); */
			                        htmlData = "<body free>" + htmlData + "</body>";
			                        
			                        if (gubun != "2") {
			                        	var replyHeader = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code='ezBoard.t423' /></B>-----</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t424' /></B>" + strWriteDate + "</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t425' /></B>" + strWriterName + "(" + strWriterTitle + "," + strWriterDeptName + "," + strWriterCompanyName + ")</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t413' /></B>" + ReplaceText("<c:out value = '${boardListVO.title}' />", "&amp;#92;", "\\") + "</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
			                        	htmlData = replyHeader + htmlData;
			                        } else {
			                        	var replyHeader = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code='ezBoard.t423' /></B>-----</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t424' /></B>" + strWriteDate + "</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t425' /></B>" + strWriterFakeName + "</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t413' /></B>" + ReplaceText("<c:out value = '${boardListVO.title}' />", "&amp;#92;", "\\") + "</p>";
			                        	replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
			                        	htmlData = replyHeader + htmlData;
			                        }
			                        message.SetEditorContent(htmlData);
			                    }else {
			                        message.SetEditorContentURL(fullPath);
			                    }
			                } else {
			                    if (pDocID == "" && (scheduleId == "" || scheduleId == null)) {
			                        if (InsertMailInfo() == -1) window.close();
			                    } else if (scheduleId != "" && scheduleId != null) {
									if (InsertScheduleInfo() == -1) window.close();
								} else {
			                        if (InsertDocInfo() == -1) window.close();
			                    }
			                }
			            }
			            MHTLoadComplete = "true";
			        }
		    	} else {
		    		var URL;
                    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=";
                    message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
                    
		    	}
		    }
		    
		    function Editor_Modify_Complete() {
		    	var URL;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(strContentLocation);
                message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
		    }
		
		    function btn_AttachSelect_onclick() {
		        document.getElementById('mode').value = "ATT";
		        document.form.file1.click();
		    }
		    
		    var fileSize = 0;
		    function returnvalue(strXML) {
		        var xml = loadXMLString(strXML);
		        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		        var extFlag = false;
		        
		        for (var i = 0; i < nodes.length; i++) {
		            if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
		                if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
		                    alert(strLang6);
		                    return;
		                }
		                if (document.getElementById('mode').value == "PHOTO")
		                    document.getElementById('txtPhotoFile').value = getNodeText(GetChildNodes(nodes[i])[2]);
		            }
		            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied") {
		                extFlag = true;
		            } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		                alert(strLang8 + AttachLimit + "MB" + strLang9);
		                return;
		            }
		            else {
		                alert("<spring:message code='ezCommunity.lhj08'/>" + "\n\n" + result);
		            }
		        }
		        
		        if (extFlag) {
		            alert(strLang54);
		        }
		        
		        if (dadiframe.document.getElementById("lstAttachLink") == null) {
		            setTimeout(function () { AttachFileInfo(strXML); }, 500);
		        } else {
		            AttachFileInfo(strXML);
		        }
		    }
		    
		    var firstnode = true;
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
		
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;
		                    if (firstnode) {
		                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).id;
		                        pSelectTab = document.getElementById(Tab1_SelectID).getAttribute("divname"); // 초기에 선택된 탭의 divname을 설정
		                        firstnode = false;
		                    }
		
		                }
		            }
		        }
		    }
		    var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id)
		            obj.className = "";
		    }
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
		
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    var pSelectTab;
		    function ChangeTab(obj) {
		        pSelectTab = obj.getAttribute("divname");
		        switch (pSelectTab) {
		            case "MailEnv_div1":
		                document.getElementById("tab01").style.display = "";
		                document.getElementById("tab02").style.display = "none";
		                if ("${boardInfo.guBun}" == "2") {
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		                } else if ("${boardInfo.guBun}" == "8") { // 홈페이지 게시판
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 160 + "PX";
		                } else if ("${docID}" != "" && pUrl.toLowerCase().indexOf(".hwp") < 0) {
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 500 + "PX";
		                } else if (pUrl.toLowerCase().indexOf(".hwp") < 0) { 
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
		                }
						mobileDistinction();
		                break;
		            case "MailEnv_div3":
		                document.getElementById("tab01").style.display = "none";
		                document.getElementById("tab02").style.display = "";
		                if (pUseBackGround == "TRUE") {
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 330 + "PX";
		                    if ("${docID}" != "" && pUrl.toLowerCase().indexOf(".hwp") < 0) {
		                        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 600 + "PX";
		                    }
		                }
		                else {
		                	 if ("${boardInfo.guBun}" == "2") {
		                    	document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		                    } else if ("${boardInfo.guBun}" == "8") { // 홈페이지 게시판
			                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 160 + "PX";
			                } else if ("${docID}" != "" && pUrl.toLowerCase().indexOf(".hwp") < 0) {
			                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 500 + "PX";
		                    } else if (pUrl.toLowerCase().indexOf(".hwp") < 0) { 
			                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
		                    }
							mobileDistinction();
		                }
		        }
				/* 2024-08-26 김유진 - 사용된 확장컬럼 높이 고려하여 에디터 높이 설정 */
				if (pAttributeYN == "Y" && document.getElementById("tab01")) {
					document.getElementById("EdtorSize").style.height = '100%'
                    mobileDistinction();
				}

				if ("<c:out value='${boardInfo.attachmentFlag}'/>" != "Y") {
					var beforeEditorSize = document.getElementById("EdtorSize").style.height;
					document.getElementById("EdtorSize").style.height = parseInt(beforeEditorSize, 10) + 145 + "PX";
					mobileDistinction();
				}
				
                var editorW = (document.documentElement.clientWidth - 20) + "PX";
		       	document.getElementById("tab02").style.width = editorW;
	            document.getElementById("message").style.width = editorW;
	            //iframe 내부 에디터의 body width 조절
	            $("iframe").ready(function(){ $("iframe[name='message']").contents().find("body").css("width" , editorW); });
      
		    }
		    function bodydragover(evt) {
		        evt.dataTransfer.dropEffect = "none";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
		    var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
		        if (CrossYN()) {
		            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var wWeight = "355";
		            var wHeight = "600";
		
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		
		            var left = (width - wWeight) / 2;
		            var top = (heigth - wHeight) / 2;
		            var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
		                "DialogHeight:600px;DialogWidth:355px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
		
		
		            if (typeof (ret) != "undefined") {
		                pBoardID = ret[0];
		                GetBoardInfo();
		                if (ret[2] == "3" || ret[2] == "4") {
		                    if (!confirm("<spring:message code='ezBoard.t10053' />"))
		                        return;
		                    else {
		                        document.location.href = "/ezBoard/newBoardItemPhoto.do?boardID=" + encodeURIComponent(ret[0]) + "&mode=new&bType=SELECT";
		                        return;
		                    }
		                }
		                else if (ret[2] == "2") {
		                    if (!confirm("<spring:message code='ezBoard.t10054' />"))
		                        return;
		                    else {
		                        document.location.href = "/ezBoard/newBoardItem.do?boardID=" + encodeURIComponent(ret[0]) + "&mode=new&boardNM=" + ret[1] + "&bType=SELECT";
		                        return;
		                    }
		                }
		                document.getElementById("BoardSpan").innerText = ret[1];
		                InitializeSettings();
		                ChkPermanent();
						NotiPost_onclick();
						Noti_setTime();
		                pBoardType = "";
		                
		                if (pcheckForm.toUpperCase() == "TRUE") {
		                	var fullPath = "";
		                	$.ajax({
		    					type : "POST",
		    					dataType : "text",
		    					async : false,
		    					url : "/ezBoard/getContentInfo.do",	        			
		    					data : { type : "BOARDFORM", 
		    							 docID: pBoardID
		    						   },
		    					success: function(result){
		    						fullPath = result;
		    					}        			
		    				});	
		                	
		                    var htmlData = message.GetEditorContentURL(fullPath);
		                    message.SetEditorContent(htmlData);
		                }
		                else {
		                    if (OpenWin == null)
		                        document.getElementById("txtTitle").focus();
		                    message.SetEditorContent("");
		                }
		
		                if (pUseBackGround.toUpperCase() == "TRUE") {
		                    document.getElementById("pUseBackGroundTR").style.display = "";
		                    GetBackGroundImage();
		                }
		                else
		                    document.getElementById("pUseBackGroundTR").style.display = "none";
		
		                SelBoard = true;
		            }
		        }
		    }
		    
	        function NewItem_onclick_Complete(ret) {
	            if (typeof (ret) != "undefined") {
	                pBoardID = ret[0];
	                GetBoardInfo();
	                if (ret[2] == "3" || ret[2] == "4") {
	                    if (!confirm("<spring:message code='ezBoard.t10053' />"))
	                        return;
	                    else {
	                        document.location.href = "/ezBoard/newBoardItemPhoto.do?boardID=" + encodeURIComponent(ret[0]) + "&mode=new&bType=SELECT";
	                        return;
	                    }
	                }
	                else if (ret[2] == "2") {
	                    if (!confirm("<spring:message code='ezBoard.t10054' />"))
	                        return;
	                    else {
	                        document.location.href = "/ezBoard/NewBoardItem.do?boardID=" + encodeURIComponent(ret[0]) + "&mode=new&boardName=" + ret[1] + "&bType=SELECT";
	                        return;
	                    }
	                }
	                pBoardID = ret[0];
	                document.getElementById("BoardSpan").innerText = ret[1];
	                InitializeSettings();
	                ChkPermanent();
					NotiPost_onclick();
					Noti_setTime();
	                pBoardType = "";
	
	                if (pcheckForm.toUpperCase() == "TRUE") {
	                	var fullPath = "";
	                	$.ajax({
	    					type : "POST",
	    					dataType : "text",
	    					async : false,
	    					url : "/ezBoard/getContentInfo.do",	        			
	    					data : { type : "BOARDFORM", 
	    							 docID: pBoardID
	    						   },
	    					success: function(result){
	    						fullPath = result;
	    					}        			
	    				});	
	                    var htmlData = message.GetEditorContentURL(fullPath);
	                    message.SetEditorContent(htmlData);
	                }
	                else {
	                    if (OpenWin == null)
	                        document.getElementById("txtTitle").focus();
	                    message.SetEditorContent("");
	                }
	
	                if (pUseBackGround.toUpperCase() == "TRUE") {
	                    document.getElementById("pUseBackGroundTR").style.display = "";
	                    GetBackGroundImage();
	                }
	                else
	                    document.getElementById("pUseBackGroundTR").style.display = "none";
	                SelBoard = true;
	            }
	        }
		
		    var backxmlhttp = null;
		    function GetBackGroundImage() {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/admin/ezBoard/getBackGroundImage.do",	        			
					data : {
						type : "USE",
						backGroundID : "",
						isAllGroupBoard : isAllGroupBoard
					},
					success: function(resultXml){
						event_Get_listComplite(resultXml);
					}        			
				});	
		    }
		
		    function event_Get_listComplite(resultXml) {
		    	document.getElementById("backgroundtd").innerHTML = "";
	            var backxml = loadXMLString(resultXml);
	            var i;
				var oDiv = document.createElement("div");
				oDiv.className = "custom_radio";
				oDiv.id = "custom_radio";
				document.getElementById("backgroundtd").appendChild(oDiv);
	            for (i = 0; i < SelectNodes(backxml, "DATA/ROW").length; i++) {
	                if (i == 5) {
	                    var br = document.createElement("BR");
	                    document.getElementById("backgroundtd").appendChild(br);
	                }
	                var span = document.createElement("SPAN");
	                span.setAttribute("imgwidth", getNodeText(SelectNodes(SelectNodes(backxml, "DATA/ROW")[0], "WIDTH")[i]));
	                span.setAttribute("imgheight", getNodeText(SelectNodes(SelectNodes(backxml, "DATA/ROW")[0], "HEIGHT")[i]));
	                span.setAttribute("filemane", getNodeText(SelectNodes(SelectNodes(backxml, "DATA/ROW")[0], "SAVEFILENAME")[i]));
	                span.style.display = "inline-block";
	                
	                var input = document.createElement("INPUT");
	                input.style.verticalAlign = "top";
	                input.style.marginTop = "8px";
	                input.style.marginRight = "6px";
	                input.name = "backradio";
	                input.type = "radio";
	                input.onchange = function () { backgroundimagechange(); };
	                
	                var img = document.createElement("IMG");
	                var filepath = getNodeText(SelectNodes(SelectNodes(backxml, "DATA/ROW")[0], "SAVEFILENAME")[i]);
		                img.width = 108;
	                
	                if (navigator.userAgent.indexOf("Chrome") != -1) {
		                img.width = 103;
	                }
	                
	                img.height = 30;
	               	img.src = "<spring:eval expression='@commonUtil.getUploadPath(\"upload_board.BOARDBACKGROUND\", \"${userInfo.tenantId}\")' />" + "/S_" + filepath;
	        	    img.onclick = function () { GetChildNodes(this.parentElement)[0].click(); };
	                img.style.cursor = "pointer";
	
	                span.appendChild(input);
					span.appendChild(img);
	
	                oDiv.appendChild(span);
	            }
	            if (i == 5) {
	                var br = document.createElement("BR");
	                document.getElementById("backgroundtd").appendChild(br);
	            }
	            var span = document.createElement("SPAN");
				span.style.verticalAlign = "top";
				span.style.margin = "6px 5px 0 10px";
				span.style.display = "inline-block";
	            var input = document.createElement("INPUT");
	            input.name = "backradio";
	            input.type = "radio";
	            input.onchange = function () { backgroundimagechange(); };
	            
	            var label = document.createElement("LABEL");
	            label.style.display = "inline-block";
	            label.style.marginRight = "5px";
	
	            label.innerHTML = "<spring:message code='ezBoard.t5009' />";
	            label.onclick = function () { GetChildNodes(this.parentElement)[0].click(); };
	            label.style.cursor = "pointer";
	
	            span.appendChild(input);
	            span.appendChild(label);
	            oDiv.appendChild(span);
	
	            var a = document.createElement("A");
	            a.className = "imgbtn imgbck";
	            a.style.verticalAlign = "top";
	            a.style.setProperty("margin", "3px", "important");
	
	            var span = document.createElement("SPAN");
	            span.innerHTML = "<spring:message code='ezBoard.t5010' />";
	            span.onclick = function () { BackImageUp(); };
	
	            a.appendChild(span);
	            document.getElementById("backgroundtd").appendChild(a);
		    }
		
		    function backgroundimagechange() {
		    	if (editor != "HWP") {
		    		for (var i = 0; i < document.getElementsByName("backradio").length; i++) {
			            if (document.getElementsByName("backradio")[i].checked) {
			                var Table = document.createElement("TABLE");
			                var Tr = document.createElement("TR");
			                var Td = document.createElement("TD");
			                Tr.appendChild(Td);
			                Table.appendChild(Tr);
			                Td.innerHTML = message.GetEditorContent();
			                var temp = Td.getElementsByTagName("TD");
			
			                Td.id = "imagediv";
			                Td.style.verticalAlign = "top";
			                Td.style.fontSize = "10pt";
			                Td.style.lineHeight = "20px";
			                Td.style.width = document.getElementsByName("backradio")[i].parentNode.getAttribute("imgwidth") + "px";
		                    Td.style.height = document.getElementsByName("backradio")[i].parentNode.getAttribute("imgheight") + "px";
			                Td.style.wordBreak = "break-all";
			                Td.style.backgroundRepeat = "no-repeat";
			                Td.style.backgroundSize = Td.style.width + " " +Td.style.height;     
			                Td.setAttribute("free", "");
			
			                if (document.getElementsByName("backradio")[i].parentNode.getAttribute("filemane") != null) {
		                		Td.style.backgroundImage = "URL(<spring:eval expression='@commonUtil.getUploadPath(\"upload_board.BOARDBACKGROUND\", \"${userInfo.tenantId}\")'/>" + "/S_" 
		                				+ document.getElementsByName("backradio")[i].parentNode.getAttribute("filemane") + ")";	
		                		Table.style.width = document.getElementsByName("backradio")[i].parentNode.getAttribute("imgwidth") + "px";
			                    Table.style.height = document.getElementsByName("backradio")[i].parentNode.getAttribute("imgheight") + "px";
			                }
			                else {
			                    for (var j = 0; j < temp.length; j++) {
			                        if (temp[j].id == "imagediv") {
			                            message.SetEditorContent(temp[j].innerHTML);
			                            break;
			                        }
			                    }
			                    break;
			                }
			                if (temp.length > 0) {
			                    for (var j = 0; j < temp.length; j++) {
			                        if (temp[j].id == "imagediv") {
			                            Td.innerHTML = temp[j].innerHTML;
			                            message.SetEditorContent(Table.outerHTML);
			                            break;
			                        }
			                    }
			                }
			                message.SetEditorContent(Table.outerHTML);
			            }
			        }
		    	} else {
		    		for (var i = 0; i < document.getElementsByName("backradio").length; i++) {
		    			if (document.getElementsByName("backradio")[i].checked) {
		    				if (document.getElementsByName("backradio")[i].parentNode.getAttribute("filemane") != null) {
		    					message.createField("backGround");
		    					if (message.FieldExist("backGround")) {
		    						message.MoveToField("backGround");
		    						var url = "<spring:eval expression='@commonUtil.getUploadPath(\"upload_board.BOARDBACKGROUND\", \"${userInfo.tenantId}\")'/>" + "/S_" 
												+ document.getElementsByName("backradio")[i].parentNode.getAttribute("filemane");
				    				var width = document.getElementsByName("backradio")[i].parentNode.getAttribute("imgwidth");
				                    var height = document.getElementsByName("backradio")[i].parentNode.getAttribute("imgheight");
				                    message.SetFieldImage("", document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + url, 1, width, height, true, 2);
		    					}
		    					
		    				} else {
		    					if (message.FieldExist("backGround")) {
		    						message.deleteField("backGround");
		    					}
		    				}
		    			}
		    		}
		    	}
		    }
		
		    function BackImageUp() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 330) / 2;
		        var pLeft = (pwidth - 610) / 2;
		        window.open("/ezBoard/imageUpload.do?", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=355,width=610,top=" + pTop + ",left=" + pLeft, "");
		    }
		    
		    function BackImageUp_After(rtn) {
		        var xmlhttp = null;
		        xmlhttp = createXMLHttpRequest();

		        var fd = new FormData();
	            fd.append("FILEPATH", rtn[0]);
	            fd.append("WIDTH", rtn[1]);
	            fd.append("HEIGHT", rtn[2]);
	            
		        xmlhttp.open("POST", "/ezBoard/uploadBackImage.do", false);
		        xmlhttp.send(fd);

		        var imgSrc = xmlhttp.responseText;
		        var imgWidth = rtn[1];
		        var imgHeight = rtn[2];
		        
		        if (editor != "HWP") {
		        	var Table = document.createElement("TABLE");
			        var Tr = document.createElement("TR");
			        var Td = document.createElement("TD");
			        Tr.appendChild(Td);
			        Table.appendChild(Tr);
			        Td.innerHTML = message.GetEditorContent();
			        var temp = Td.getElementsByTagName("TD");

			        Td.id = "imagediv";
			        Td.style.verticalAlign = "top";
			        Td.style.fontSize = "10pt";
			        Td.style.lineHeight = "20px";
			        Td.style.wordBreak = "break-all";
			        Td.style.backgroundRepeat = "no-repeat";
			        Td.style.width = imgWidth + "px";
			        Td.style.height = imgHeight + "px";
			        Td.style.backgroundSize = "" + imgWidth + "px" + imgHeight + "px";
		        	Td.style.backgroundImage = "URL(" + imgSrc + ")";
		        	
			        Table.style.width = "auto";
			        Table.style.height = "auto";

			        if (temp.length > 0) {
			            for (var j = 0; j < temp.length; j++) {
			                if (temp[j].id == "imagediv") {
			                    Td.innerHTML = temp[j].innerHTML;
			                    message.SetEditorContent(Table.outerHTML);
			                    break;
			                }
			            }
			        }

			        message.SetEditorContent(Table.outerHTML);
		        } else {
		        	if (message.FieldExist("backGround")) {
						message.deleteField("backGround");
					}
		        	message.createField("backGround");
		        	if (message.FieldExist("backGround")) {
		        		message.MoveToField("backGround");
		        		message.SetFieldImage("", document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + imgSrc, 1, imgWidth, imgHeight, true, 2);
		        	}
		        }
		    }
		
	        //추가항목 관련 Function 추가
	        function SetRadioVal(pObjectName, p_strVal) {
	            var RadioBtns = document.getElementsByName(pObjectName);
	            var i;
	            for (i = 0; i < RadioBtns.length; i++) {
	                if (RadioBtns[i].value == p_strVal) { 
	                	RadioBtns[i].checked = true; 
	                	break; 
	                }
	            }
	        }
	
	        //추가항목 관련 Function 추가
	        function GetRadioVal(pObjectName) {
	            var RadioBtns = document.getElementsByName(pObjectName);
	            var strReturn = "";
	            var i;
	            for (i = 0; i < RadioBtns.length; i++) {
	                if (RadioBtns[i].checked) { strReturn = RadioBtns[i].value; break; }
	            }
	            return strReturn;
	        }
	
	        function GetCheckVal(pObjectName) {
	            var chkBoxes = document.getElementsByName(pObjectName);
	            var strReturn = "";
	            var i, j;
	            for (i = 0; i < chkBoxes.length; i++) {
	                if(chkBoxes[i].checked){
	                    strReturn = strReturn + chkBoxes[i].value + ",";
	                }
	            }
	            return (strReturn.length==0) ? "":strReturn.substr(0, strReturn.length-1);
	        }
	
	        function SetCheckVal(pObjectName, p_strVal) {
	            var chkBoxes = document.getElementsByName(pObjectName);
	            var strCheckVals = p_strVal.split(",");
	            var i, j;
	            for (i = 0; i < chkBoxes.length; i++) {
	                for (j = 0; j < strCheckVals.length; j++) {
	                    if (chkBoxes[i].value == strCheckVals[j]) {
	                        chkBoxes[i].checked = true; break;
	                    }
	                }
	            }
	        }
	        
	        function getExtensionValue(tableCol) {
	        	var retValue = "";
	        	
	        	// 이미 HTML/XML에 대응하도록 저장된 확장칼럼 파라미터를 다시 c:out으로 파싱했으므로, ConvMakeXMLString()을 두 번 실행한다.
	        	if (tableCol == "extensionAttribute6") {
	        		retValue = ConvMakeXMLString(ConvMakeXMLString("<c:out value='${boardListVO.extensionAttribute6}'/>")); 
				} else if (tableCol == "extensionAttribute7") {
					retValue = ConvMakeXMLString(ConvMakeXMLString("<c:out value='${boardListVO.extensionAttribute7}'/>"));
				} else if (tableCol == "extensionAttribute8") {
					retValue = ConvMakeXMLString(ConvMakeXMLString("<c:out value='${boardListVO.extensionAttribute8}'/>"));
				} else if (tableCol == "extensionAttribute9") {
					retValue = ConvMakeXMLString(ConvMakeXMLString("<c:out value='${boardListVO.extensionAttribute9}'/>"));
				} else if (tableCol == "extensionAttribute10") {
					retValue = ConvMakeXMLString(ConvMakeXMLString("<c:out value='${boardListVO.extensionAttribute10}'/>"));
				}
	        	
	        	return retValue;
	        }
	        
	        function AttachFileList2() {
		    	var strRet = "";
		    	var filepath = "";
		    	
		        if (getXmlString(pAttachListXml) == "") {
		            return "";
		        }
		    	   var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA2");

		           for (var i = 0; i < xmldomNodes.length; i++) {
		               filepath = getNodeText(xmldomNodes[i]);
		               if (filepath.indexOf(pBoardID) != -1) {
		                   strRet += filepath + "|";
		               } else {
		            	   strRet += "tempUploadFile/" + getNodeText(xmldomNodes[i]) + "|"
		               }
		           }
		    	return strRet;
		    }
	        
	        /* 2021-06-22 홍승비 - 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendBoardAlert(pMode, pBoardID, pItemID, pIsAllGroupBoard) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/sendBoardAlert.do",
					data : {
						mode : pMode,
						boardID : pBoardID,
						itemID : pItemID,
						isAllGroupBoard : pIsAllGroupBoard
					}
				});
	        }
	        
	        var xmlstringUl = "";
	        var startMht = false;
	        
			/* 2023-05-16 김우철 - 결재문서, 첨부파일의 정보를 xml로 작성하는 함수. 결재문서, 문서첨부 파일이면서 확장자가 hwp이면 배포용 문서로 변환 */
	        function uploadXml(p_num, xmldom) {
	        	var arrayLength = SelectNodes(xmldom, "ATTACHNAME").length;
	        	
	        	// 결재문서를 게시물로 게시
	        	if (!startCheck) {
	        		var temppath = pUrl;
                    temppath = temppath.substring(34, temppath.length);
                    var orgfile = temppath.split("/");
                    orgfile = orgfile[orgfile.length - 1];
                    
                    var orgFileList = orgfile.split(".");
                    var orgFileType = orgFileList[orgFileList.length - 1];
	        		
	        		xmlstringUl += "<DATA><BOARDID>" + pBoardID + "</BOARDID><ROWS>";
	        		
	        		// 결재문서의 확장자가 hwp인 경우
	        		if (orgFileType.toUpperCase() == "HWP") {
	        			xmlstringUl += "<ROW><FILENAME><![CDATA[" + "<spring:message code='ezBoard.t419' />".split(".")[0] + "]]></FILENAME>";
	        			xmlstringUl += "<FILEPATH><![CDATA[" + temppath + "]]></FILEPATH>";
	        			xmlstringUl += "<ORGFILEPATH><![CDATA[" + orgfile + "]]></ORGFILEPATH>";
	        			
	        			if (pUrl.toLowerCase().indexOf("/upload_approval/") > -1) {
	        				xmlstringUl += "<TYPE>APPROVAL</TYPE>";
	        			} else {
	        				xmlstringUl += "<TYPE>APPROVALG</TYPE>";
	        			}
	                    xmlstringUl += "<FILESIZE>0</FILESIZE>";
	                    
	                    // useHwpDownSecurity가 Y이면 한글 배포용 문서로 변환
	                    if (useHwpDownSecurity == "Y" && approvalFlag == "G") {
	                    	if (isHwpCtrlOpen == true) {
	                    		var doc = HwpCtrl.Open(window.location.origin + pUrl, "HWP", "", function(res) {
		            				// console.log("res" + p_num + " : " + JSON.stringify(res));
		            				if (res.result) {
		                   				var dact = HwpCtrl.CreateAction("FileSetSecurity");
		            					var dset = dact.CreateSet();
		            					
		            					dact.GetDefault(dset);
		            					
		            					// 패스워드 설정
		            					dset.SetItem("Password", HwpSecurityNum);
		            					
		            					// 프린트 사용여부
		            					dset.SetItem("NoPrint", true);
		            					
		            					// 복사 방지
		            					dset.SetItem("NoCopy", true);
		            					
		            					var rtn = dact.Execute(dset, function(action, param, result, userData) {
		            						// 배포용 문서는 웹한글기안기 서버 상에 저장되며, downUrl에는 웹한글기안기 서버에서 해당 파일을 다운로드하기 위한 URL이 저장됨
		               						var downUrl = result.downloadUrl;
		               						xmlstringUl += "<DOWNURL><![CDATA[" + downUrl + "]]></DOWNURL></ROW>";
		               						startCheck = true;
		               						return uploadXml(p_num, xmldom);
		            					});
		                   			} else {
		                   				alert(strLangKWCHd01);
		                   				return;
		                   			}
		            			});
	                    	} else {
	                    		alert(strLangKWCHd01);
                   				return;
	                    	}
	            		} else {
	            			xmlstringUl += "<DOWNURL>noUrl</DOWNURL></ROW>";
	            			startCheck = true;
	            			return uploadXml(p_num, xmldom);
	            		}
	                    
	        		}
	        		// 결재문서의 확장자가 hwp가 아닌 경우
	        		else {
	        			startCheck = true;
	        			startMht = true;
            			return uploadXml(p_num, xmldom);
	        		}
	        		
	        	}
	        	// 결재문서의 일반 첨부파일 및 문서첨부를 게시물의 첨부파일로 삽입 (결재 문서의 정보를 xml에 저장 완료한 경우)
	        	else {
					if (p_num >= arrayLength) {
						xmlstringUl += "</ROWS></DATA>";
					
						if (arrayLength == 0 && startMht == true) {
							return;
						} else {
							uploadApprov(xmlstringUl);
						}
						
					} else {
						var orgTemppath = getNodeText(SelectNodes(xmldom, "ATTACHFILEHREF")[p_num]);
	                    var temppath = orgTemppath.substring(34, orgTemppath.length);
	                    var orgfile = temppath.split("/");
	                    orgfile = orgfile[orgfile.length - 1];
	                    var orgFileList = orgfile.split(".");
	                    var orgFileType = orgFileList[orgFileList.length - 1];
	                    var orgTypeCode = getNodeText(SelectNodes(xmldom, "ATTACHTYPECODE")[p_num]);
	                    var filename = getNodeText(SelectNodes(xmldom, "ATTACHNAME")[p_num]).replace("&amp;","&");
	                    filename = filename.replace(/[*|\\\":\/?<>]/gi, "_");
	                    
	                    xmlstringUl += "<ROW><FILENAME><![CDATA[" + filename + "]]></FILENAME>";
	                    xmlstringUl += "<FILEPATH><![CDATA[" + temppath + "]]></FILEPATH>";
	                    xmlstringUl += "<ORGFILEPATH><![CDATA[" + orgfile + "]]></ORGFILEPATH>";
	                    
	                    if (pUrl.toLowerCase().indexOf("/upload_approval/") > -1) {
	                    	xmlstringUl += "<TYPE>APPROVAL</TYPE>";
	                    } else {
	                    	xmlstringUl += "<TYPE>APPROVALG</TYPE>";
	                    }
	                    
	                    // orgTypeCode를 체크하여 일반 첨부파일(file)이 아닌 문서첨부(document)만 한글 배포용 문서로 변환
                        if (useHwpDownSecurity == "Y" && approvalFlag == "G" && orgFileType.toUpperCase() == "HWP" && orgTypeCode == "document") {
	                    	if (isHwpCtrlOpen == true) {
	                    		var doc = HwpCtrl.Open(window.location.origin + orgTemppath, "HWP", "", function(res) {
		            				// console.log("res" + p_num + " : " + JSON.stringify(res));
		            				if (res.result) {
		                   				var dact = HwpCtrl.CreateAction("FileSetSecurity");
		            					var dset = dact.CreateSet();
		            					
		            					dact.GetDefault(dset);
		            					
		            					// 패스워드 설정
		            					dset.SetItem("Password", HwpSecurityNum);
		            					
		            					// 프린트 사용여부
		            					dset.SetItem("NoPrint", true);
		            					
		            					// 복사 방지
		            					dset.SetItem("NoCopy", true);
		            					
		            					var rtn = dact.Execute(dset, function(action, param, result, userData) {
		            						// 배포용 문서는 웹한글기안기 서버 상에 저장되며, downUrl에는 웹한글기안기 서버에서 해당 파일을 다운로드하기 위한 URL이 저장됨
		            						var downUrl = result.downloadUrl;
		               						xmlstringUl += "<FILESIZE>" + result.size + "</FILESIZE>";
		               						xmlstringUl += "<DOWNURL><![CDATA[" + downUrl + "]]></DOWNURL></ROW>";
		               						p_num++;
		               						return uploadXml(p_num, xmldom);
		            					});
		                   			} else {
		                   				alert(strLangKWCHd01);
		                   				return;
		                   			}
		            			});
	                    	} else {
	                    		alert(strLangKWCHd01);
                   				return;
	                    	}
	            		}
                        // useHwpDownSecurity가 N이거나 파일이 한글 배포용 문서 변환 대상이 아닌 경우
                        else {
	            			xmlstringUl += "<FILESIZE>" + getNodeText(SelectNodes(xmldom, "ATTACHFILESIZE")[p_num]) + "</FILESIZE>";
	            			xmlstringUl += "<DOWNURL>noUrl</DOWNURL></ROW>";
	            			p_num++;
	            			return uploadXml(p_num, xmldom);
	            		}
					}
	        	}
	        }
	        
	        // 함수 uploadXml에서 작성한 xml의 파일 정보를 이용해 서버의 임시저장 폴더에 파일 업로드
	        function uploadApprov(xmlstring) {
	        	var xmlHTTP = createXMLHttpRequest();
	        	var xmldom2 = createXmlDom();
	        	xmldom2 = loadXMLString(xmlstring);
                xmlHTTP.open("POST", "/ezBoard/uploadApprovFile.do", false);
                xmlHTTP.send(xmldom2);
                returnvalue(xmlHTTP.responseText);

                var xml = loadXMLString(xmlHTTP.responseText);
                var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
                var strRet = "";
                for (i = 0; i < nodes.length; i++) {
                    var filepath = getNodeText(GetChildNodes(nodes[i])[0]);

                    strRet += "tempUploadFile/" + filepath + "|";
                }
                attachxml = strRet;
	        }

			function uploadScheduleFile(xmlstring) {
				var xmlHTTP = createXMLHttpRequest();
				var xmldom2 = createXmlDom();
				xmldom2 = loadXMLString(xmlstring);
				xmlHTTP.open("POST", "/ezBoard/uploadScheduleFile.do", false);
				xmlHTTP.send(xmldom2);
				returnvalue(xmlHTTP.responseText);

				var xml = loadXMLString(xmlHTTP.responseText);
				var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
				var strRet = "";
				for (i = 0; i < nodes.length; i++) {
					var filepath = getNodeText(GetChildNodes(nodes[i])[0]);

					strRet += "tempUploadFile/" + filepath + "|";
				}
				attachxml = strRet;
			}

			function openPopupAuth(e) {
			    var columnName = e.target.getAttribute("columnName");
                var OpenWin = window.open("/ezBoard/boardSelectUser.do?companyId=" + SSCompanyID + "&columnName=" + columnName, "", GetOpenWindowfeature(970, 670));
                OpenWin.focus();
            }
            
            function characterCheckForExtAttr(obj) {
                var regExp = /[\\'\"<>]/gi;
                if (regExp.test(obj.value)) {
                    alert("<spring:message code='ezBoard.extensionAttr.JIH04' />");
                    obj.value = obj.value.replace(regExp, '');
                }
            }
            
            function FieldsAvailable(isTrue) {
            	if (isTrue) {
            		if (pMode == "new" || pMode == "new1" || pMode == "boardAttach") {
            			message.SetMargin(3000);
            		}
            		message.EditMode(1);
            		message.SetViewProperties(2, 100);
		            message.ScrollPosInfo(0, 0);
		            message.ShowToolBar(true);
		            message.ShowRibbon(true);
		            message.FoldRibbon(true);
		            window.onresize();
		            if (pUrl != "") {
	                    if (pDocID == "" && (scheduleId == "" || scheduleId == null)) {
	                        if (InsertMailInfo() == -1) window.close();
	                    } else if (scheduleId != "" && scheduleId != null) {
							if (InsertScheduleInfo() == -1) window.close();
						} else {
	                        if (InsertDocInfo() == -1) window.close();
	                    }
		            } else if (pMode != "modify" && pMode != "reply") {
		            	if (pcheckForm.toUpperCase() == "TRUE") {
		                	$.ajax({
		    					type : "POST",
		    					dataType : "text",
		    					async : false,
		    					url : "/ezBoard/getContentInfo.do",	        			
		    					data : { type : "BOARDFORM", 
		    							 docID: pBoardID
		    						   },
		    					success: function(result){
		    						var formFrame = document.getElementById("message2");
		                    		formPath = result;
		                    		formFrame.src = "/ezBoard/WHWPEditor.do?type=form";
		    					}        			
		    				});	
		                }
		            } else if (pMode == "reply") {
		            	var replyHeader = "";
		            	if (gubun != "2") {
                        	replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
                        	replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code='ezBoard.t423' /></B>-----</p>";
                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t424' /></B>" + strWriteDate + "</p>";
                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t425' /></B>" + strWriterName + "(" + strWriterTitle + "," + strWriterDeptName + "," + strWriterCompanyName + ")</p>";
                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t413' /></B>" + ReplaceText("<c:out value = '${boardListVO.title}' />", "&amp;#92;", "\\") + "</p>";
                        	replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
                        } else {
                        	replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
                        	replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code='ezBoard.t423' /></B>-----</p>";
                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t424' /></B>" + strWriteDate + "</p>";
                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t425' /></B>" + strWriterFakeName + "</p>";
                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t413' /></B>" + ReplaceText("<c:out value = '${boardListVO.title}' />", "&amp;#92;", "\\") + "</p>";
                        	replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
                        }
		            	
		            	message.moveTopOfFile();
            			message.createField("reply");
            			message.AppendFieldText("reply", replyHeader, "", "HTML", "", function() {
	            			message.moveEndOfFile();
            			});
		            }
            	} else {
            		message.Clear();
            	}
            }
            
            function onresizeHWP() {
	       		var mHeight = document.getElementById("EdtorSize").clientHeight - 6 + "px";
	       		message.Resize(mHeight);
				mobileDistinction();
	        }
            
            var ingFlag = false;
            function SaveItemHWP(pMode) {
            	GetHTML(before_saveItem, pMode);
            }
            
            function GetHTML(callback, pMode) {
                ingFlag = true;
			    message.GetTextFile("HWP", "", function (data) { ingFlag = false; callback(data, pMode); });
			}
            
            var hwpHtml = "";
            function before_saveItem(html, pMode) {
            	hwpHtml = html;
            	SaveItem(pMode);
            }
            
            function PreventSaveItemHWP(pMode) {
            	GetHTML(before_preventSaveItem, pMode);
            }
            
            function before_preventSaveItem(html, pMode) {
            	hwpHtml = html;
            	PreventSaveItem(pMode);
            }
            
            function Editor_Form_Complete() {
            	var URL;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(formPath);
                message2.Open(URL, "", "", function (res) { addForm(res.result) }, null);
            }
            
            function addForm(isTrue) {
            	if (isTrue) {
            		message2.GetCloneData("", "HWP", addFormComplete);
            	}
            }
            
            function addFormComplete(data) {
            	var formData = data;
				message.moveTopOfFile();
				message.SetCloneData(formData, "", "HWP");
            }
	        
            function mobileDistinction() {
                    var  userAgent = navigator.userAgent.toLowerCase();
                
                if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
                    if (window.innerWidth > window.innerHeight) {
                        document.getElementById("EdtorSize").style.height = 436 + "PX";
                    }
                }
            }

			function chkUseDept_onclick() {
				if (chkUseDept.checked) { // 팀/부서로 표시
					spUseDept.innerHTML = "${deptName}";
					document.getElementById("writerFlag").selectedIndex = 1;
				} else { // 이름으로 표시
					spUseDept.innerHTML = "${displayName}";
					document.getElementById("writerFlag").selectedIndex = 0;
				}
			}

			function checkVersionValidate() {
				var majorV = document.getElementById("majorVersion").value;
				var minorV = document.getElementById("minorVersion").value;
				version = majorV + "." + minorV;

				if (majorV == "" || minorV == "") {
					alert("<spring:message code = 'ezBoard.versionManage.msg5' />");

					return false;
				} else if (isNaN(majorV) || isNaN(minorV)) {
					alert("<spring:message code = 'ezBoard.versionManage.msg6' />");

					return false;
				} else if (version <= newestVersion && historyModify !== "true") {
					alert("<spring:message code = 'ezBoard.versionManage.msg7' />");

					return false;
				}

				return true;
			}
	    </script>
	    <c:if test="${!isCrossBrowser}">
	   		<script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
			    Append_AttachAdd(filename);
			</script>
	    </c:if>
	</head>
	<body class="popup" style="height: 97%;">
	    <table class="layout" style="width: 100%;">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                    	<c:if test="${editor ne 'HWP'}">
	                    		<c:choose>
	                    		<c:when test="${mode == 'temp'}">
	                    		<!-- 2018-05-30 구해안 그룹웨어 모듈 '등록','저장후닫기' => '저장'으로 통일  ezBoard.t98 => t98 -->
			                        <li><span onclick="SaveItem('save');"><spring:message code='ezBoard.t98' /></span></li>
	                    		</c:when>
	                    		<c:otherwise>
			                        <li><span onclick="PreventSaveItem('<c:out value="${mode}"/>');"><spring:message code='ezBoard.t98' /></span></li>
	                    		</c:otherwise>
		                    	</c:choose>
								<c:if test="${boardInfo.guBun != '3' && boardInfo.guBun != '9'}">
									<li><span onclick="PreviewItem();"><spring:message code='ezBoard.t431' /></span></li>
		                    	</c:if>
		                    	<c:if test="${boardInfo.guBun != '2' && (mode != 'modify' && mode != 'reply')}">
			                        <li><span onclick="PreventSaveItem('temp');"><spring:message code='ezBoard.t10034' /></span></li>
		                    	</c:if>
	                    	</c:if>
	                    	
	                    	<c:if test="${editor eq 'HWP'}">
	                    		<c:choose>
	                    		<c:when test="${mode == 'temp'}">
	                    		<!-- 2018-05-30 구해안 그룹웨어 모듈 '등록','저장후닫기' => '저장'으로 통일  ezBoard.t98 => t98 -->
			                        <li><span onclick="SaveItemHWP('save');"><spring:message code='ezBoard.t98' /></span></li>
	                    		</c:when>
	                    		<c:otherwise>
			                        <li><span onclick="PreventSaveItemHWP('<c:out value="${mode}"/>');"><spring:message code='ezBoard.t98' /></span></li>
	                    		</c:otherwise>
		                    	</c:choose>
		                    	<%-- <c:if test="${boardInfo.guBun != '3'}">
			                        <li><span onclick="PreviewItemHWP();"><spring:message code='ezBoard.t431' /></span></li>
		                    	</c:if> --%>
		                    	<c:if test="${boardInfo.guBun != '2' && (mode != 'modify' && mode != 'reply')}">
			                        <li><span onclick="PreventSaveItemHWP('temp');"><spring:message code='ezBoard.t10034' /></span></li>
		                    	</c:if>
	                    	</c:if>
	                    </ul>
	                </div>
					<c:if test = "${ boardInfo.guBun != '9' }">
	                <div id="close">
	                    <ul>
	                        <li><span onclick="window.close();"></span></li>
	                    </ul>
	                </div>
					</c:if>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
        	<c:choose>
        	<c:when test="${boardInfo.guBun != '3'}">
	        <tr style="height: 20px">
	            <td>
	                <div class="portlet_tabpart03" style="margin:0px;border-top:0px;padding:0px;margin-bottom:4px">
	                    <div class="portlet_tabpart03_top" id="tab1">
	                        <p id="MailEnv_sub1"><span divname="MailEnv_div1" id="1tab1"><spring:message code='ezBoard.hsbJP02' /></span></p>
							<c:if test = "${ boardInfo.guBun != '9' }">	<%-- File Viewer 게시판 특성 상 예약게시는 구조와 맞지 않다고 판단되어 display none 처리 --%>
	                        <p id="MailEnv_sub3"><span divname="MailEnv_div3" id="1tab3"><spring:message code='ezBoard.hsbJP01' /></span></p>
							</c:if>
	                    </div>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px">
	                <table class="content" id="tab01">
	                    <tr>
	                        <th>
	                        	<c:choose>
	                        		<c:when test="${boardType != 'SELECT'}">
			                            <spring:message code='ezBoard.t111' />
	                        		</c:when>
	                        		<c:otherwise>
			                            <a class="imgbtn" onclick="NewItem_onclick()"><span><spring:message code='ezBoard.t171' /></span></a>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </th>
	                        <td id="tdBoardName" style="width: 300px">
	                        	<c:choose>
	                        		<c:when test="${boardType != 'SELECT'}">
			                            <span id="BoardSpan">
			                                <c:out value='${boardName}' />
			                            </span>
	                        		</c:when>
	                        		<c:otherwise>
	                        			<c:choose>
	                        				<c:when test="${boardID == ''}">
					                            <span id="BoardSpan"><spring:message code='ezBoard.t57' /></span>
	                        				</c:when>
	                        				<c:otherwise>
					                            <span id="BoardSpan">${boardInfo.boardName}</span>
	                        				</c:otherwise>
	                        			</c:choose>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                        <th style="width:80px"><spring:message code='ezBoard.t434' /></th>
							<td style="width: 300px; vertical-align: baseline;">
								 <div class="custom_checkbox">
									 <span style="line-height: 25px; height: 20px; display: inline-block;">
										<c:choose>
											<c:when test="${boardListVO.importance == '1'}">
												<input type="checkbox" id="chkEmergent" checked>
												<label for="chkEmergent"><spring:message code='ezBoard.t435' /></label>
											</c:when>
											<c:otherwise>
												<input type="checkbox" style="margin-top: 0px;" id="chkEmergent">
												<label for="chkEmergent"><spring:message code='ezBoard.t435' /></label>
											</c:otherwise>
										</c:choose>
										<!-- // 20090913 : 게시판 공지게시 기능 -->
										<c:choose>
											<c:when test="${mode != 'reply'}">
												<c:choose>
													<c:when test="${boardInfo.guBun != '2' && (boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'true') && boardListVO.extensionAttribute2 == '1'}">
														<input type="checkbox" id="noticePost" checked onclick="NotiPost_onclick()"/>
														<label for="noticePost"><spring:message code='ezBoard.t483' /></label>
													</c:when>
													<c:when test="${boardInfo.guBun != '2' && (boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'true')}">
														<input type="checkbox" id="noticePost" onclick="NotiPost_onclick()"/>
														<label for="noticePost"><spring:message code='ezBoard.t483' /></label>
													</c:when>
													<c:otherwise>
														&nbsp;<input type="checkbox" style="display: none" id="noticePost" />
													</c:otherwise>
												</c:choose>
											</c:when>
											<c:otherwise>
												&nbsp;<input type="checkbox" style="display: none" id="noticePost" />
											</c:otherwise>
										</c:choose>
										<c:if test="${mode != 'new' && mode != 'new1' && mode != 'boardContent' && mode != 'boardAttach' && mode != 'temp' && mode != 'reply' && reservedItem == '' && boardInfo.guBun != '9' }">
											<input type="checkbox" id="readCount" />
											<label for="readCount"><spring:message code='ezBoard.t00002' /></label>
										</c:if>
								 	</span>
								 </div>
							</td>
	                    </tr>

						<tr id="noti_setTime" style="display: none"> <%-- 공지사항 기간설정 --%>
							<th><spring:message code='ezBoard.Notimjs06' /></th>
							<td colspan="3" style="width: 300px; vertical-align: baseline;">
								<div class="custom_radio">
									<span style="line-height: 30px; height: 20px; display: inline-block;">
									<input type="radio" id="NotiPeriod" name="isNoti" onclick="NotiPost_onclick()">
									<label for="NotiPeriod"><spring:message code='ezBoard.Notimjs05' /></label>&nbsp;
									<span id = "notiTimeset" style="display: none;">
										<input type="text" id="noti_start" readonly="readonly" style="width:80px;text-align:center; margin-bottom: 3px; ">
										~ <input type="text" id="noti_end" readonly="readonly" style="width:80px;text-align:center; margin-bottom: 3px; ">
									</span>
									&nbsp;<input type="radio" id="NotiPermanece" name="isNoti" onclick="NotiPost_onclick()">
										<label for="NotiPermanece"><spring:message code='ezBoard.Notimjs01' /></label>
									</span>
								</div>
							</td>
						</tr>
						<c:if test="${'Y' == boardInfo.writerFlag}">
							<tr class="td_style">
								<th><spring:message code='ezBoard.t223' /></th>
								<td colspan="3">
									<span id="spUseDept">
										<c:choose>
											<c:when test="${mode == 'new'}">${userInfo.displayName}</c:when>
											<c:otherwise>${boardListVO.writerName}</c:otherwise>
										</c:choose>
									</span>
									<div class="custom_checkbox">
										<input type="checkbox" id="chkUseDept" style="margin-left: 0px !important;" onclick="chkUseDept_onclick()">
									</div>
									<select id="writerFlag" style="display: none;">
										<option value="<c:out value='${writerOption.N}\\${writerOption.N2}\\0' />"></option>
										<option value="<c:out value='${writerOption.T}\\${writerOption.T2}\\1' />"></option>
										<option value="<c:out value='${writerOption.D}\\${writerOption.D2}\\2' />"></option>
									</select>
								</td>
							</tr>
						</c:if>
             			<!-- 추가 항목이 있을 경우 -->
             			<c:forEach var="boardAttributeVO" items="${boardAttributeListVO}" step="1" varStatus="status">
             				<tr>
             					<c:choose>
             						<c:when test="${extenLang == 1}">
		             					<th>
											${boardAttributeVO.colName1}
											<c:if test="${boardAttributeVO.must == 'Y'}">
												<span style="color:red"> *</span>
											</c:if>
										</th>
             						</c:when>
             						<c:otherwise>
             							<th>
											${boardAttributeVO.colName2}
											<c:if test="${boardAttributeVO.must == 'Y'}">
												<span style="color:red"> *</span>
											</c:if>
										</th>
             						</c:otherwise>
             					</c:choose>
             					<c:choose>
             						<c:when test="${boardAttributeVO.colType == 'radio'}">
						                <td colspan="3">
											<div class="custom_radio">
												<c:forEach begin="0" end="${fn:length(fn:split(boardAttributeVO.value, '|')) - 1}" step="1" varStatus="status">
													<input type="radio" name="${boardAttributeVO.tableCol}" value="${fn:split(boardAttributeVO.value, '|')[status.index]}" id="lbr${boardAttributeVO.tableCol}${status.index}"/>
													<label for="lbr${boardAttributeVO.tableCol}${status.index}">${fn:split(boardAttributeVO.value, '|')[status.index]}</label>
												</c:forEach>
											</div>
						                </td>
             						</c:when>
             						<c:when test="${boardAttributeVO.colType == 'text'}">
						                <td colspan="3">
						                    <!-- 2018.02.08 입력창 최대 길이 제한-->
						                    <input type="text" id='${boardAttributeVO.tableCol}' name='${boardAttributeVO.tableCol}'  style="width:43%" maxlength="100"/>
						                </td>
             						</c:when>
             						<c:when test="${boardAttributeVO.colType == 'check'}">
						                <td colspan="3">
											<div class="custom_checkbox">
												<c:forEach begin="0" end="${fn:length(fn:split(boardAttributeVO.value, '|')) - 1}" step="1" varStatus="status">
													<input type="checkbox" name="${boardAttributeVO.tableCol}" value="${fn:split(boardAttributeVO.value, '|')[status.index]}" id="lbc${boardAttributeVO.tableCol}${status.index}"/>
													<label for="lbc${boardAttributeVO.tableCol}${status.index}">${fn:split(boardAttributeVO.value, '|')[status.index]}</label>
												</c:forEach>
											</div>
						                </td>
             						</c:when>
									<c:when test="${boardAttributeVO.colType == 'cal'}">
										<td colspan="3">
											<input type="text" class="cal" id='${boardAttributeVO.tableCol}' name='${boardAttributeVO.tableCol}'"/>
										</td>
									</c:when>
									<c:when test="${boardAttributeVO.colType == 'select'}">
										<td colspan="3">
											<select id='${boardAttributeVO.tableCol}' name='${boardAttributeVO.tableCol}'>
											<c:forEach begin="0" end="${fn:length(fn:split(boardAttributeVO.value, '|')) - 1}" step="1" varStatus="status">												
													<option value="${fn:split(boardAttributeVO.value, '|')[status.index]}">${fn:split(boardAttributeVO.value, '|')[status.index]}</option>
											</c:forEach>
											</select>
										</td>
									</c:when>
									<c:when test="${boardAttributeVO.colType == 'people'}">
                                        <td colspan="3">
                                            <span id="peopleSelectBtn" class="peopleSelectBtn" columnName='${boardAttributeVO.tableCol}' style="" onclick ='openPopupAuth(event)'><spring:message code='ezWebFolder.t516' /></span>
                                            <span id ='${boardAttributeVO.tableCol}' name='${boardAttributeVO.tableCol}' type="people" class='authList_div peoplePickerData ${boardAttributeVO.tableCol}'></span>
                                        </td>
                                    </c:when>
                                    <c:when test="${boardAttributeVO.colType == 'textArea'}">
                                        <td colspan="3">
                                            <span id='icon_textArea'></span>
                                            <textarea maxlength="450" id='${boardAttributeVO.tableCol}' name='${boardAttributeVO.tableCol}' type="textArea" onkeyup="characterCheckForExtAttr(this)" onkeydown="characterCheckForExtAttr(this)" style="width: 100%; height: 150px; box-sizing: border-box; "></textarea>
                                        </td>
                                    </c:when>
             					</c:choose>
             				</tr>
             			</c:forEach>
	         			<!-- 추가 항목이 있을 경우 끝-->
	         			<!-- 키워드 시작 -->
	         			<c:if test="${not empty useKeyword && useKeyword eq 'Y'}">
                            <tr>
                                <th><spring:message code="ezApprovalG.t1200" /></th>
                                <td colspan="3" id="keyWordResult">
                                    <c:if test="${not empty useKeyword && useKeyword eq 'Y' && (mode eq 'modify' || mode eq 'temp')}">
                                        <c:forEach var="keyword" items="${keywordListForModify}">
                                            <span id="${keyword.keywordName}" class="keywordSpanView">
                                                #${keyword.keywordName}<img src="/images/icon/oneline_delete.gif" class="keywordDeleteBtn" onclick="removeKeyword(event)">
                                            </span>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${fn:length(keywordListForModify) < 10}">
                                        <input type="text" id="txtKeyword" style="WIDTH: 20%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeyup="keyword_onkeyUp(event)" >
                                    </c:if>
                                </td>
                            </tr>
                        </c:if>
                        <!-- 키워드 끝 -->
	                    <tr>
	                        <th><spring:message code='ezBoard.t208' /></th>
	                        <td colspan="3">
	                            <input type="text" id="txtTitle" style="WIDTH: 100%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeydown="Title_onkeyDown(event)" ></td>
	                    </tr>
	                    <c:if test="${boardInfo.guBun == '2'}">
		                    <tr>
		                        <th><spring:message code='ezBoard.t438' /></th>
		                        <td colspan="3">
		                        	<input type="password" id="txtPassWord_fake" style="WIDTH: 150px; display: none;" maxlength="15" autocomplete="new-password">
		                            <input type="password" id="txtPassWord" style="WIDTH: 150px" maxlength="15" autocomplete="new-password">&nbsp;&nbsp;(<spring:message code='ezBoard.t439' /></td>
		                    </tr>
	                    </c:if>
						<c:if test = "${ (mode eq 'modify' && useVersion eq 'Y' && version ne '') || (historyModify eq 'false' && useVersion eq 'Y') }">
						<tr id = "tr_version">
							<th>버전</th>
							<td colspan = 3>
								<input type = "text" id = "majorVersion" style = "width : 25px; text-align : center;" maxLength = 2 />
								<dot style = "vertical-align : bottom">.</dot>
								<input type = "text" id = "minorVersion" style = "width : 25px; text-align : center;" maxLength = 2 />
								* 숫자만 입력 가능합니다.
							</td>
						</tr>
						</c:if>
	                </table>
	                <table id="tab02" class="content" style="display: none;">
	                	<c:choose>
	                	<%-- 2019-12-02 홍승비 - 임시저장과 예약게시 기능을 동시에 사용 가능하도록 수정 --%>
	                		<c:when test="${(mode== 'new' || mode== 'new1' || mode == 'temp' || reservedItem == 'true' || url != '') && boardInfo.guBun != '2'}">
			                    <tr id="tdReservationDate">
	                		</c:when>
	                		<c:otherwise>
			                    <tr id="tdReservationDate" style="display: none;">
	                		</c:otherwise>
	                	</c:choose>
	                        <th><spring:message code='ezBoard.t432' /></th>
	                        <td>
								<div class="custom_checkbox">
									<span style="line-height: 20px; height: 25px; display: inline-block;">
										<c:choose>
											<c:when test="${reservedItem == 'true'}">
												<input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()" checked>
												<label for="chk_reservation"><spring:message code='ezBoard.t276' /></label>
											</c:when>
											<c:otherwise>
												<input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()">
												<label for="chk_reservation"><spring:message code='ezBoard.t276' /></label>
											</c:otherwise>
										</c:choose>
										<span id="reservation_date">
											<input type="text" id="Sdatepicker" readonly="readonly" style="width:80px;text-align:center; margin-bottom: 2px;"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center; margin-bottom: 2px;"readonly readonlyExcept />
											&nbsp;<a class="imgbtn imgbck" style= "height:22px; margin-top:2px !important"><span onclick="btn_PostDate_Clear()" popuplocation='topright'><spring:message code='ezBoard.t220' /></span></a>
										</span>
									</span>
								</div>
							</td>
	                    </tr>
						<c:if test="${boardInfo.publicFlag eq 'Y'}">
							<tr>
								<th><spring:message code='ezBoard.private.pgb02'/></th>
								<td>
									<div class="custom_checkbox">
										<span style="line-height: 29px; height: 29px; display: inline-block;">
											<input type="checkbox" id="publicFlag" name="publicFlag" ${boardListVO.publicFlag == "Y" ? "checked" : "" } value="Y">
											<label for="publicFlag"><spring:message code='ezBoard.private.pgb04'/></label>
										</span>
									</div>
								</td>
							</tr>
						</c:if>
	                    <tr id="tdEndDate">
	                        <th><spring:message code='ezBoard.t156' /></th>
	                        <td>
	                        	<c:choose>
	                        	<%-- 2019-11-22 홍승비 - 임시저장한 게시물 재작성 시에도 게시만료일 설정 여부가 제대로 반영되도록 수정 --%>
	                        		<c:when test="${(mode != 'modify' && mode != 'temp' && boardInfo.expireDays == '-1') || ((mode == 'modify' || mode == 'temp') && fn:substring(boardListVO.endDate, 0, 4) == '9999')}">
			                            <span id="Chkbox">
											<div class="custom_checkbox">
			                                	<span style="line-height: 20px; height: 20px; display: inline-block;">
													<input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()" checked>
													<label for="ChkPermanence"><spring:message code='ezBoard.t433' /></label>
												</span>
											</div>
			                            </span>
			                            <span id="Makedate">
			                                <input type="text" id="Sdatepicker2" readonly="readonly" style="width:80px;text-align:center; margin-bottom:1.2px;">
			                            </span>
	                        		</c:when>
	                        		<c:otherwise>
			                            <span id="Chkbox" style="display: inline-block;">
											<div class="custom_checkbox">
												<span style="line-height: 20px; height: 20px; display: inline-block;">
													<input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()">
													<label for="ChkPermanence"><spring:message code='ezBoard.t433' /></label>
												</span>
											</div>
			                            </span>
			                            <span id="Makedate">
			                                <input type="text" id="Sdatepicker2" readonly="readonly" style="width:80px;text-align:center; margin-bottom:1.2px;">
			                            </span>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                    </tr>
	                    <c:if test="${boardInfo.guBun == '2'}">
		                    <tr>
		                        <th><spring:message code='ezBoard.t436' /></th>
		                        <td>
		                            <input type="text" id="txtNickName" style="WIDTH: 150px" maxlength="15" value="<c:out value='${boardListVO.writerName}'/>">&nbsp;&nbsp;(<spring:message code='ezBoard.t437' /></td>
		                    </tr>
	                    </c:if>
	                    <tr>
	                        <th><spring:message code='ezBoard.t209' /></th>
	                        <td>
	                            <input type="text" id="txtAbstract" style="WIDTH: 100%; word-break: break-all" value="" maxlength="100">
							</td>
	                    </tr>
	                    <tr id="pUseBackGroundTR" style="display:none;" height="50px">
	                    	<th><spring:message code='ezBoard.t5011' /></th>
	                    	<td colspan="3" id="backgroundtd"></td>
	                    </tr>
	                </table>
	            </td>
	            </c:when>
	            <c:otherwise>
	            <td>
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezBoard.t111' /></th>
	                        <td id="tdBoardName" style="width: 100%" colspan="2">${boardName}</td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezBoard.t208' /></th>
	                        <td style="vertical-align: middle" colspan="2">
	                            <input type="text" id="txtTitle" style="WIDTH: 95%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeydown="Title_onkeyDown(event)"></td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezBoard.t459' /></th>
	                        <td class="pos1">
	                            <input type="text" id="txtPhotoFile" style="WIDTH: 100%" readonly="true"></td>
	                        <td class="pos2"><a class="imgbtn"><span id="btn_AttachAdd" onclick="return btn_PhotoAttachAdd_onclick()"><spring:message code='ezBoard.t440' /></span></a></td>
	                    </tr>
	                    <tr id="tdReservationDate" style="visibility:hidden;">
	                        <th><spring:message code='ezBoard.t432' /></th>
	                        <td style="width: 100%" colspan="2">
	                            <table style="width: 100%;" border="0">
	                                <tr>
	                                    <td>
											<div class="custom_checkbox">
												<span style="line-height: 20px; height: 25px; display: inline-block;">
													<c:choose>
														<c:when test="${reservedItem == 'true'}">
															<input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()" checked>
															<label for="chk_reservation"><spring:message code='ezBoard.t276' /></label>
														</c:when>
														<c:otherwise>
															<input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()">
															<label for="chk_reservation"><spring:message code='ezBoard.t276' /></label>
														</c:otherwise>
													</c:choose>
												</span>
											</div>
	                                    </td>
	                                    <td id="reservation_date">
	                                        <input type="text" id="Sdatepicker" readonly="readonly" style="width:80px;text-align:center" ><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;"readonly readonlyExcept />
	                                        &nbsp;<img src="/images/btn_date.gif" border="0" style="CURSOR: pointer; width: 75px; height: 20px; vertical-align: middle" onclick="btn_PostDate_Clear()" popuplocation='topright'>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr id="tdEndDate" style="visibility:hidden;">
	                        <th><spring:message code='ezBoard.t156' /></th>
	                        <td style="padding-top: 0; padding-bottom: 0px" colspan="2">
	                            <table border="0">
	                                <tr>
	                                	<c:choose>
	                                		<c:when test="${(mode != 'modify' && boardInfo.expireDays == '-1') || ((mode == 'modify' || mode == 'temp') && fn:substring(boardListVO.endDate, 0, 4) == '9999')}">
			                                    <td style="width: 90px; white-space: nowrap" id="Chkbox">
			                                        <div class="custom_checkbox">
														<input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()" checked>
														<label for="ChkPermanence"><spring:message code='ezBoard.t433' /></label>
													</div>
												</td>
			                                    <td id="Makedate">
			                                        <input type="text" id="Sdatepicker2" readonly="readonly" style="width:80px;text-align:center">&nbsp;&nbsp;
			                                    </td>
	                                		</c:when>
	                                		<c:otherwise>
			                                    <td style="width: 90px; white-space: nowrap" id="Chkbox">
			                                        <div class="custom_checkbox">
														<input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()">
														<label for="ChkPermanence"><spring:message code='ezBoard.t433' /></label>
													</div>
												</td>
			                                    <td id="Makedate">
			                                        <input type="text" id="Sdatepicker2" readonly="readonly" style="width:80px;text-align:center">&nbsp;&nbsp; </td>
	                                		</c:otherwise>
	                                	</c:choose>
	                                    <td>&nbsp;</td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr style="display: none">
	                        <th><spring:message code='ezBoard.t434' /></th>
							<td style="vertical-align: middle" colspan="2">
								<div class="custom_checkbox">
									<c:choose>
										<c:when test="${importance == '1'}">
											<input type="checkbox" id="chkEmergent" checked>
											<label for="chkEmergent"><spring:message code='ezBoard.t435' /></label>
										</c:when>
										<c:otherwise>
											<input type="checkbox" id="chkEmergent">
											<label for="chkEmergent"><spring:message code='ezBoard.t435' /></label>
										</c:otherwise>
									</c:choose>
								</div>
							</td>
	                    </tr>
	                    <c:if test="${boardInfo.guBun == '2'}">
		                    <tr style="display: none">
		                        <th><spring:message code='ezBoard.t436' /></th>
		                        <td style="vertical-align: middle" colspan="2">
		                            <input type="text" id="txtNickName" style="WIDTH: 100px" maxlength="15" value="<c:out value='${boardListVO.writerName}'/>">
		                            &nbsp;&nbsp;(<spring:message code='ezBoard.t437' /></td>
		                    </tr>
		                    <tr style="display: none">
		                        <th><spring:message code='ezBoard.t438' /></th>
		                        <td style="vertical-align: middle" colspan="2">
		                            <input type="password" id="txtPassWord_fake" style="WIDTH: 100px; display: none;" maxlength="15" autocomplete="new-password">
		                            <input type="password" id="txtPassWord" style="WIDTH: 100px" maxlength="15" autocomplete="new-password">
		                            &nbsp;&nbsp;(<spring:message code='ezBoard.t439' /></td>
		                    </tr>
	                    </c:if>
	                    <tr style="display: none">
	                        <th><spring:message code='ezBoard.t209' /></th>
	                        <td style="vertical-align: middle" colspan="2">
	                            <input type="text" id="txtAbstract" style="WIDTH: 100%; word-break: break-all" value="" maxlength="100"></td>
	                    </tr>
	                </table>
	            </td>
	            </c:otherwise>
        	</c:choose>
	        </tr>
	        <tr>
	            <td style="vertical-align: top; height: 100%" id="EdtorSize">
	            	<c:if test="${editor ne 'HWP'}">
	            		<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do?type=BOARDBACKGROUND" style="padding: 0; height: 100%; width: 100%; overflow: auto; margin-top:-1px"></iframe>
	            	</c:if>
	            	<c:if test="${editor eq 'HWP'}">
	            		<iframe id="message" class="viewbox"  src="/ezBoard/WHWPEditor.do?type=${mode}" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            		<c:if test="${checkForm eq 'TRUE'}">
	            			<iframe id="message2" name="message2" style="display:none;"></iframe>
	            		</c:if>
	            	</c:if>
	            </td>
	        </tr>
	        <tr id="docTR" style="display: none">
	            <td>
	                <div id="docContentBorder" style="border: 0; BACKGROUND-COLOR: white; margin-top: 5px;">
	                    <iframe id="docContent" name="docContent" style="width: 99.5%; height: 100%;"></iframe>
	                </div>
	            </td>
	        </tr>
	    	<c:if test="${!isCrossBrowser}">
				<c:choose>
					<c:when test="${boardInfo.guBun != '3'}">
				      <tr <c:if test="${boardInfo.attachmentFlag != 'Y'}"> style="display:none;"</c:if>>
				        <td height="20" valign="top" style="padding-top:10px">
				          <table class="file" style="height:100px">
				            <form name="multicheck">
				              <tr>
				                <th><spring:message code='ezBoard.t292' /></th>
				                <td class="pos1" style="height:100px">                
				                    <SCRIPT type="text/javascript">EzHTTPTrans_ActiveX2("EzHTTPTrans", "100%", "100%");</SCRIPT>
				                    <div id="lstAttachLink" style="display:none">&nbsp;</div>                
				                </td>
				                <td class="pos2"><a class="imgbtn"><span id="btn_AttachAdd" onClick="return btn_AttachAdd_onclick()"><spring:message code='ezBoard.t440' /></span></a><br><a class="imgbtn"><span id="btn_AttachDel" onClick="return btn_AttachDel_onclick()"><spring:message code='ezBoard.t441' /></span></a></td>
				              </tr>
				            </form>
				          </table>
				        </td>
				      </tr>
					</c:when>
					<c:otherwise>
						<SCRIPT type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</SCRIPT>
					</c:otherwise>
				</c:choose>
	    	</c:if>
	    	<c:if test="${isCrossBrowser}">
				<c:choose>
					<c:when test="${boardInfo.guBun != '3'}">
						<tr id="attachIframeTR" <c:if test="${boardInfo.attachmentFlag != 'Y'}"> style="display:none;"</c:if>>
				            <td style="height: 145px">
				                <iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezBoard/dragAndDrop.do"></iframe>
				                <input type="hidden" name="mode" id="mode" />
				            </td>
				        </tr>
					</c:when>
				</c:choose>
	    	</c:if>
	    </table>
	    <input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="hwpctrl"/>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
	<script type="text/javascript">
	    if ("${boardInfo.guBun}" == "2") {
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
	    } else if("${docID}" != "" && pUrl.toLowerCase().indexOf(".hwp") < 0) {
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 500 + "PX";
	    } else if (pUrl.toLowerCase().indexOf(".hwp") < 0) {
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
	    }
		/* 2024-08-26 김유진 - 사용된 확장컬럼 높이 고려하여 에디터 높이 설정 */
		if (pAttributeYN == "Y" && document.getElementById("tab01")) {
		    document.getElementById("EdtorSize").style.height = '100%'
		}
		
		if ("<c:out value='${boardInfo.attachmentFlag}'/>" != "Y") {
			var beforeEditorSize = document.getElementById("EdtorSize").style.height;
			document.getElementById("EdtorSize").style.height = parseInt(beforeEditorSize, 10) + 145 + "PX";
		}
		
		mobileDistinction();
	</script>
</html>
