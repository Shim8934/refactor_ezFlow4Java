<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html style="height:97%">
	<head>
		<title><spring:message code='ezApprovalG.t367'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/whokyulSign_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/html2canvas.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/sendMail_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprmanage_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var pDocID = "<c:out value ='${docID}'/>";
		    var pDocHref = "<c:out value ='${docHref}'/>";
		    var pListSusin = "<c:out value ='${listSusin}'/>";
		    var porgDocID = "<c:out value ='${orgDocID}'/>";
		    var pFormID = "<c:out value ='${formID}'/>";
		    var pTitle = "<c:out value ='${docTitle}'/>";
		    var pOpinionFlag;
		    var pListTypeValue = 4;
		    var flag = false;
		    var PrevOpinionFlag = false;
		    var NextOpinionFlag = true;
		    var doctitle = "";
		    var pOrgAttach = "";
		    var pendDir = "${endDir}";
		    var xmlhttp = createXMLHttpRequest();
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
		    var companyID = "<c:out value ='${userInfo.companyID}'/>";
		    var pUserID = arr_userinfo[1];
		    var SignCheckFlag = "<c:out value ='${signCheck}'/>";
		    var pUse_Editor = "<c:out value ='${editor}'/>";
		    var approvalFlag = "<c:out value ='${approvalFlag}'/>";     //전자결재 일반/공공 여부 (G : 공공 , S : 일반)
		    var admin = "<c:out value ='${admin}'/>";
		    var formDocType = "<c:out value ='${formDocType}'/>";
		    var formUrl = "<c:out value ='${formUrl}'/>";
		    var docState = "<c:out value ='${docState}'/>";
		    var WhoKyulCNT = "<c:out value ='${whoKyulCount}'/>";
		    var checkPwdFlag = "<c:out value ='${checkPwdFlag}'/>";
		    var ext = "<c:out value ='${ext}'/>";
		    var opinionFlag;
		    var includeOpinion = false;
		    var signImageType = "<c:out value ='${signImageType}'/>";
			var orgCompanyID = "<c:out value ='${orgCompanyID}'/>";
			var docFormVersion = "<c:out value='${formVersion}' />";
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
			
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
	        
	     	// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";

			// 배부대장 문서 진행/완료 여부 플래그 (APR/END)
			var docAprEnd = "<c:out value ='${docAprEnd}'/>";

			// 첨부문서 확인 여부 (첨부문서 창 닫을시 발생하는 오류 방지를 위한 Flag)
			var isDocAttach = "<c:out value = '${isDocAttach}'/>";
			
			// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
			var useHideHeaderArea = "<c:out value ='${useHideHeaderArea}'/>";

			var tenantID = "<c:out value ='${userInfo.tenantId}'/>";
			var nonElecRec = "<c:out value ='${nonElecRec}'/>";
			var ReturnFunction;

            var isPreview = "<c:out value = '${isPreview}'/>";

		    $(function () {
		    	/* 2022-07-29 홍승비 - 열람권한 체크는 초기 진입 시 한번만 진행 (관리자 > 전체 완료문서조회 > 관리자는 모든 문서 열람 가능) */
			    if ("${pass}" != "<RESULT>TRUE</RESULT>") {
		    		QuitWindow();
			    }
			    
		      	if(approvalFlag == "G") {
	        		$(".approvalG").css("display","");
	        		$(".approval").css("display","none");
	        	} else {
	        		$(".approvalG").css("display","none");
	        		$(".approval").css("display","");
	        	}
				  
				try {
					if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					}
				} catch (e) { }
		      	
		      	//감사문서도 재사용하지 못하도록 수정. 2020-03-16 홍대표.
		      	if (docState == "012" || docState == "013" || docState == "014") {
		      		document.getElementById("btnReuse").style.display = "none";
		      	}
		      	
		      	$("#message").load(function() {
					var selectOp = $("#selectImg option").length;
					if(selectOp == 1){
						$("#selectImg option").remove();
					}
					var val = parseInt($("#selectImg option:selected").val());
					var divImg = $("#message").contents().find(".divImg");
					var pages = $(divImg).children().length;
					if (pFormID != "2021000000" ) {
						if (selectOp == 1) {
							for (var i = 1; i <= pages; i++) {
								if (i <= pages) {
									$("#selectImg").append("<option value='" + i + "'>" + i + " / " + pages + " Page</option>");
								}
							}
						}
						if (pages > 1) {
							window.resizeTo(1920, 1200);
							var sw = screen.width;
							var sh = screen.height;
							var cw = document.body.clientWidth;
							var ch = document.body.clientHeight;
							var top = sh / 2 - ch / 2 - 100;
							var left = sw / 2 - cw / 2;
							$("#officeBtn").css("display", "");
							var selectNum = $("#message").contents().find(".divImg").find(".imgDiv").index();
							$("#selectImg option:eq(" + selectNum + ")").prop('selected', true);
						}
					}

					if(divImg.length > 0){
					    imgTag = divImg.find("img").get(0);
                        if(typeof imgTag != "undefined"){
                            imgTag.onload = function() {
                                officeImgExist = true;
                            }
                        }
                        setTimeout(satImgCheck,3000);

					}
				});
		      	
				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
		    });
	
		    var aprendopinion_dialogArgument = new Array();
		    function btnOpinion_onclick() {
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = "Show";
		        parameter[2] = orgCompanyID;
		
		        aprendopinion_dialogArgument[0] = parameter;
		        aprendopinion_dialogArgument[1] = openOpinionUI_Complete;
		        DivPopUpShow(530, 520, "/ezApprovalG/aprEndOpinion.do");
		    }

			/* 2023-06-26 민지수 - 전자결재 > 완료문서 > [추가의견] 클릭 시 동작 함수 추가 */
			function btnOpinion_add_onclick() {
				openOpinionUI_New_Add("ADD");
			}

		    function openOpinionUI_Complete() {
		        DivPopUpHidden();
		    }
		
		    function DocumentComplete() {
		        if (flag == false) {
		            flag = true;
		            
		            if (WhoKyulCNT > 0) {
		                document.getElementById("btnWhoKyul").style.display = "";
		                document.getElementById("btnReuse").style.display = "none";
		            } else {
		                document.getElementById("btnWhoKyul").style.display = "none";
		            }
		            
		            // ready()에서 열람권한 체크를 진행하므로, 그 이후의 열람권한 체크는 제거
	                if (pDocHref != "") {
	                    message.Set_EditorContentURL(pDocHref);
	                }
		            if (pFormID == "") {
		                document.getElementById("btnSave").style.display = "none";
		            }
		        }
		    }
		    function QuitWindow() {
                // 2023-06-19 전인하 - 전자결재G > 기록물대장 미리보기 - 사용자에게 열람권한이 없을 때 미리보기 영역에서 문서가 열렸을 경우 미리보기 프레임에 공백 페이지 삽입
		        /* 2022-07-29 홍승비 - 미리보기 영역으로 열린 경우, iframe src 자체를 공백으로 변경 */
                var ifrmPreViewH = window.parent.document.getElementById("ifrmPreViewH");
                if (ifrmPreViewH != null && window.self.frameElement.id == "ifrmPreViewH") {
                    ifrmPreViewH.src = "<spring:message code='main.kms4'/>";
                } else {
                    showAlert(strLang1139);
                    btnClose_onclick();
		        }
		    }
			/* 전달한 DOCID로 진행중문서(APR) 또는 완료문서(END) 여부를 문자열로 리턴 */
			function getAprOrEndStr() {
				var result = "";

				$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/getAprOrEndStr.do",
					data : {
						docID : pDocID,
						orgCompanyID : orgCompanyID
					},
					success: function(text){
						result = text;
					}
				});

				return result;
			}
		    function CheckOpinionInfo() {
		    	var result = "";
		    	var url = "";
		    	var sendData = "";
				var aprOrEndStr = getAprOrEndStr();
				if (aprOrEndStr == "APR") {
					$.ajax({
						type: "POST",
						dataType: "text",
						async: false,
						url: "/ezApprovalG/opinionRequest.do",
						data: {
							docID: pDocID,
							orgCompanyID: orgCompanyID,
							state : aprOrEndStr
						},
						success: function (xml) {
							result = loadXMLString(xml);
						}
					});
				} else {
					$.ajax({
						type: "POST",
						dataType: "text",
						async: false,
						url: "/ezApprovalG/getEndOpinionInfo.do",
						data: {
							docID: pDocID,
							orgCompanyID: orgCompanyID
						},
						success: function (xml) {
							result = loadXMLString(xml);
						}
					});
				}
		
		        Resultxml = result;
		
		        var NodeList = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
		
		        if (NodeList.length != "0")
		            return true;
		        else
		            return false;
		    }
		    var hasOpinion = "false"; // 의견 존재 여부
		    function FieldsAvailable() {
		        CheckSignImg();
		        //없이 테스트
// 		        if (SignCheckFlag == "N")
// 		            SignCheck();
		
		        var fields = message.GetFieldsList();
		        if (pListSusin == 1 || pListSusin == "") {
		            var field = message.GetListItem(fields, "susinhide");
		            if (field) {
		                field.style.display = 'none';
		            }
		
		            var field = message.GetListItem(fields, "susinhideP");
		            if (field) {
		                field.style.display = 'none';
		            }
		        } else {
		            var field = message.GetListItem(fields, "drafthide");
		            if (field) {
		                field.style.display = 'none';
		            }
		        }
		        
		        if ("<c:out value ='${uFlag}'/>" == "m03") {
		            setAttachInfo(pDocID, "APR", lstAttachLink);
		        } else {
		            setAttachInfo(pDocID, "END", lstAttachLink);
		        }
		        
				/* 2023-12-05 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
		        message.startRemapAllAprSign_MHT(pDocID, orgCompanyID);
		        
		        // 현재 문서가 수신문이면서 원문서가 존재하는 경우, 원문서의 서명 데이터도 재맵핑
		        if (docState == "011" && porgDocID != null && typeof(porgDocID) != "undefined" && porgDocID != "") {
		        	message.startRemapAllAprSign_MHT(porgDocID, orgCompanyID);
		        }
		        
		        hasOpinion = CheckOpinionInfo();
		        if (hasOpinion) {
		            var pInformationContent = "<spring:message code='ezApprovalG.t9'/>" + "<br>" +"<spring:message code='ezApprovalG.t170'/>";
		            OpenInformationUI(pInformationContent, btnOpinion_onclick_Complete);
		        }
		        
		        checkHeaderAction();
		    }
	
		    function btnOpinion_onclick_Complete(Ans) {
		        if (Ans) {
		            btnOpinion_onclick();
		        }
		        else {
		            DivPopUpHidden();
		        }
		    }
		
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        headerAction("open");
		    	PrintClick("Cross", pDocID, "END");
		    }
		    // function btnClose_onclick() {
			// 	if (ReturnFunction != null) {
			// 		ReturnFunction("cancel");
			// 	}
            //     window.close();
            //     window.open('/blank.htm', "_self");
		    // }
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		        if (CrossYN() && ext != 'hwp') {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        return RtnVal;
		    }
		
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		    function btnSave_onclick() {
		    }
		    function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
		        try {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = 0;
		            var top = 0;
		            if (window.screen.width > 800) {
		                var pleftpos;
		                pleftpos = parseInt(width) - 725;
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - pleftpos;
		                left = pleftpos / 2;
		            } else {
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - 10;
		            }
		            var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left
		            window.open(wfileLocation, "view", param);
		        } catch (e) {
		            showAlert("openwindow :: " + e.description);
		        }
		    }
		    
// 		    function btnMail_onclick() {
// 				    $.ajax({
//                         type:"POST",
//                         dataType:"text",
//                         async: false,
//                         data : {
//                         	imgUrl : pDocHref,
//                         	docID: pDocID
//                         },
//                         url: "/ezApprovalG/createMailImg.do",
//                         success: function (data) {
//                         	var pheight = window.screen.availHeight;
//         			        var conHeight = pheight * 0.8;
//         			        var pwidth = window.screen.availWidth;
//         			        var pTop = (pheight - conHeight) / 2;
//         			        var pLeft = (pwidth - 890) / 2;
//         			        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pDocHref);
// //        						var pURL = "/ezEmail/mailWrite.do?docHref=" + encodeURIComponent(pDocHref) + "&cmd=docsend&docID=" + pDocID + "&imageCnt=&target=APPROVALG";
//         			        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
//         			        newwin.focus();
//                         }
//                     });
// 		    }
			

			// 2018-07-10 황윤호
		    function btnMail_onclick() {	   
		    	headerAction("open");
				if(hasOpinion) {
		    		SendMailClick("Cross", pDocID, "END");
		    	} else {
		    		attachAppr();
		    	}
		     	return; 
		    }
		 
		    // var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
		        // writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		        // var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
		        // try { OpenWin.focus(); } catch (e) { }
				showPopup("/ezBoard/writeBoardSelectModal.do", 355, 600, "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600), NewItem_onclick_Complete);
		    }
		
		    function NewItem_onclick_Complete(ret) {
				hidePopup();
		        if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
		
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;
		            
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || ret[2] == "8" || (ret[3] != "null" && ret[3] != null && ret[3] != "")) {
		                showAlert(strLang1031);
		            }
		            else {
		                // window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + pDocHref + "&orgCompanyID=" + orgCompanyID, '', GetOpenWindowJun(765, 870));
						showPopup("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + pDocHref + "&orgCompanyID=" + orgCompanyID, 765, 870, "", GetOpenWindowJun(765, 870), hidePopup);
		            }
		        }
		    }
		
		    function btnBoard_onclick() {
	            window.open("/myoffice/ezBoardSTD/NewBoardItem_CK.aspx?Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pDocHref, '', 'height=870,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 870));
		    }
		    var ezaprhistory_cross_dialogArguments = new Array();
		    function btnhistory_onclick() {		    	
		        ezaprhistory_cross_dialogArguments[0] = "";
		        ezaprhistory_cross_dialogArguments[1] = btnhistory_onclick_Complete;
		
		        DivPopUpShow(740, 450, "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + "mht" );
		    }
		      
		    function btnhistory_onclick_Complete() {
		        DivPopUpHidden();
		    }
		
		    var ezdocinfog_view_cross_dialogArguments = new Array();
		    function btnDocInfo_onclick() {
		        ezdocinfog_view_cross_dialogArguments[0] = "";
		        ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;

                // 2023-10-16 전인하 - 전자결재G > 기록물배부대장 > 배부대장 문서정보 오류
                // 문서정보를 무조건 완료문서 DB에서 가져와, 진행문서를 배부대장에서 조회하는 경우 발생하는 문서정보 조회불가 현상을 수정함
                var initFlag = docAprEnd == "APR" ? "APR" : "END";
		        //DivPopUpShow(420, 500, "/ezApprovalG/ezDocInfoGView.do?docID=" + pDocID + "&ingFlag=END"); 문서정보 새로 구현해서 주석
				if (typeof approvalFlag !== "undefined" && approvalFlag == "G") {
					DivPopUpShow(430, 400, "/ezApprovalG/ezDocInfoView.do?docID=" + pDocID + "&ingFlag=" + initFlag);
				}else {
					DivPopUpShow(430, 300, "/ezApprovalG/ezDocInfoView.do?docID=" + pDocID + "&ingFlag=" + initFlag);
				}
		    }
		    function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    
		    function SignCheck() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getSignInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}
		    	});
		        var SignXML = createXmlDom();
		        
		        if (result == "") {
		            SaveSignCheck();
		            return;
		        }
		        result = loadXMLString(result);
		        var NodeList;
		        NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");

		        if (NodeList.length <= 0) {
		            SaveSignCheck();
		            return;
		        }
		        return;
		        SignXML = result;
		        var rtnVal = putSignXML(SignXML);
		        if (rtnVal) {
		            SaveFile();
		            SaveSignCheck();
		        }
		    }
		    function putSignXML(SignXML) {
		        var retVal = false;
		        try {
		            var NodeList;
		            var fields = message.GetFieldsList();
		            var field;
		            NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
		            if (NodeList.length > 0) {
		                for (i = 0; i < NodeList.length; i++) {
		                    var SignType = getNodeText(SelectSingleNode(NodeList[i], "SIGNTYPE"));
		                    var SignName = getNodeText(SelectSingleNode(NodeList[i], "SIGNNAME"));
		                    var SignCont = getNodeText(SelectSingleNode(NodeList[i], "CONTENT"));
		                    var field = GetListItem(fields, SignName);
		                    if (field) {
		                        retVal = true;
		                        if (SignType == "TEXT" || SignType == "HTML") {
		                            field.innerHTML = SignCont;
		                        }
		                        else {
		                        	var seumyung = message.GetListItem(fields, "seumyungdate" + (SignName.slice(-1)));
		                        	var habyuiDate = message.GetListItem(fields, "habyuidate" + (SignName.slice(-1)));
		                            var img = SignCont.split("::");
		                            var signWidth = parseInt(field.offsetWidth) - 4 - 15;
		                            var signHeight = parseInt(field.offsetHeight) - 4;
		                            signWidth = 50;
		                            
		                            if (seumyung) {
		                            	if (img[1] != null) {
			                            	if (img[1].indexOf(strLang7) > -1) {
			                            		signHeight = 28;
			                            	} else {
			                            		signHeight = 50;
			                            		
			                            		if (SignName.indexOf("habyuisign") > -1) {
			                            			if (!habyuiDate) {
					                            		signHeight = 28;
				                            		}
			                            		}
			                            	}
		                            	} else {
		                            		signHeight = 50;
		                            		
		                            		if (SignName.indexOf("habyuisign") > -1) {
		                            			if (!habyuiDate) {
				                            		signHeight = 28;
			                            		}
		                            		}
		                            	}
		                            } else {
		                            	signHeight = 28;
		                            }
		
		                            var strimg;
		                            if (img.length >= 1) {
		                                strimg = "<img src='" + encodeURI(img[0]) + "' border=0 embedding='1' ";
		                                strimg = strimg + " width=" + signWidth;
		                                strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>";
		                            }
		                            
		                            if (seumyung) {
		                            	field.innerHTML = strimg;
		                            	
		                            	if (SignName.indexOf("habyuisign") > -1) {
	                            			if (!habyuiDate) {
	                            				if (img.length >= 2 && img[1] != "") {
	    		                            		field.innerHTML = img[1] + "<br>" + strimg;
	    		                            	}
	    		                            	else {
	    		                            		field.innerHTML = strimg;
	    		                            	}
		                            		}
	                            		}
		                            } else {
		                            	if (img.length >= 2 && img[1] != "") {
		                            		field.innerHTML = img[1] + "<br>" + strimg;
		                            	}
		                            	else {
		                            		field.innerHTML = strimg;
		                            	}
		                            }
		                        }
		                    }
		                }
		            }
		        } catch (e) {
		            showAlert("putSignXML : " + e.description);
		            return false;
		        }
		        return retVal;
		    }
		    function SaveFile() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var mhtBody = "";
		        mhtBody = message.Get_EditorBodyHTML();
		        mhtBody = "<HTML>" + GetCKEditerHeader() + mhtBody + "</HTML>";
		        mhtBody = ConvertHTMLtoMHT(mhtBody);
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
		        createNodeAndInsertText(xmlpara, objNode, "Html", mhtBody);
		        xmlhttp.open("POST", "../aspx/saveEndFile.aspx", false);
		        xmlhttp.send(xmlpara);
		        return xmlhttp.responseText;
		    }
		    
		    function SaveEndFile() {
		    	 var mhtBody = "";
			        mhtBody = message.Get_EditorBodyHTML();
			        mhtBody = "<HTML>" + mhtBody + "</HTML>";
			        mhtBody = ConvertHTMLtoMHT(mhtBody);
			    	
			    	var data = {
		    			docID : pDocID,
		    			html  : mhtBody
			    	}
			        
			        $.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/saveEndFile.do",
			    		contentType : "application/json",
			    		data : JSON.stringify(data),
			    		success: function(xml){
			    			result = xml;
			    		}        			
			    	});
		    }

		    
		    
		    function SaveSignCheck() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/updateSignCheck.do",
		    		data : {
		    			docID : pDocID,
		    			signCheck : "Y"
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
		        return result;
		    }
		
		    // var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        ezCommon_cross_dialogArguments[0] = "";
		        ezCommon_cross_dialogArguments[1] = TotalSave_onclick_Complete;
		
		        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=" + docAprEnd + "&orgCompanyID=" + orgCompanyID);
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    
		    //재사용 추가
		    var getformcont_cross_dialogArguments = new Array();
		    var editable = "";
		    function btnReuse_onclick(type) {
		    	if (nonElecRec != "") {
		    		var pAlertContent = strLangKWC01;
					OpenAlertUI(pAlertContent);
					return;
		    	}
		    	
				$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		data : {
		    			formID : pFormID,
		    			companyID : companyID
		    		},
		    		url : "/ezApprovalG/getFormDetail.do",
		    		success: function(xml){
						xml = loadXMLString(xml);
						
						var form = {};
			            if (xml.getElementsByTagName("FORMVERSION").length > 0) {
			                form.currVersion = xml.getElementsByTagName("FORMVERSION").item(0).textContent;
						} 
						if (xml.getElementsByTagName("FORMCONNFLAG").length > 0) {
			                form.connflag = xml.getElementsByTagName("FORMCONNFLAG").item(0).textContent;
						}
						
						if (typeof form.currVersion === "undefined" && docFormVersion == "") {
							var pAlertContent = strLangKWC02;
							OpenAlertUI(pAlertContent);
							return;
						}

						if (form.currVersion != docFormVersion) {
							var pAlertContent = strLang975;
							OpenAlertUI(pAlertContent);
							return;
						} else if (form.connflag == 'Y') {
							var pAlertContent = strLang1150;
		                    OpenAlertUI(pAlertContent);
							return;
						}

						editable = type;
						
						if (true) {
							formURL = formUrl;
							formDocType = formDocType;
						}
						else {
							var parameter = new Array();
							parameter[0] = arr_userinfo[4];
							parameter[1] = "A01000";

							if (CrossYN()) {
								getformcont_cross_dialogArguments[0] = parameter;
								getformcont_cross_dialogArguments[1] = AprManage_B_Complete;
								var getFormCont = GetOpenWindow("/ezApprovalG/getFormCont.do", "getFormCont", 713, 570, "NO");
								try { getFormCont.focus(); } catch (e) {
								}
							}
							else {
								var url = "/ezApprovalG/getFormCont.do";
								var feature = "center:yes;status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no;";
								feature = feature + GetShowModalPosition(713, 570);

								var ret;
								if (window.showModalDialog) {
									ret = window.showModalDialog(url, parameter, feature);
								}
								else {
									ret = GetOpenWindow(url, "", 713, 570, "NO");
								}
								formURL = ret[0];
								formDocType = ret[1];         
							}
						}
						if (formURL != "cancel") {
							openDraftUI("DRAFT", "");
						}
		    		}        			
		    	});
		    }
		    
		    function openDraftUI(pDraftFlag, pCurSelRow) {
		        var pArgument = new Array();

		        pArgument[0] = pUserID;
		        pArgument[1] = formUrl;
		        pArgument[2] = pDraftFlag;
		        pArgument[3] = formDocType;

		        if (pCurSelRow) {
		            if (pListTypeValue != "5") {
		                pArgument[4] = GetAttribute(pCurSelRow, "DATA9");
		                pArgument[5] = GetAttribute(pCurSelRow, "DATA12");
		                pArgument[6] = GetAttribute(pCurSelRow, "DATA10");
		                pArgument[7] = "";
		            } else {
		                pArgument[4] = "0";    
		                pArgument[5] = "";     
		                pArgument[6] = "";
		                pArgument[7] = newDocID;
		            }
		            
		            pArgument[3] = GetAttribute(pCurSelRow, "DATA15");
		        } else {
		            pArgument[4] = "0"
		            pArgument[5] = ""
		            pArgument[6] = ""
		            pArgument[7] = "";
		        }
		        var temppListTypeValue = pListTypeValue;
		        pListTypeValue = "1";
		        
		        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
		            if (CrossYN()) {
		                showAlert(strLang1103);
		                return;
		            } else {
		                var openLocation = "/myoffice/ezApproval/ezViewHWP/ezDraftUI_HWP.aspx";
		            }
		        } else {
		            var openLocation = "/ezApprovalG/draftui.do";
		            
		            openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
		            openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=" + escape(pListTypeValue) + "&aprState=" + escape(pArgument[6]);
		            openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]) + "&isUsed=" +  editable;
		        }
		        
		        openLocation += "&beforeDocID=" + pDocID;
		        pListTypeValue = temppListTypeValue;
				
				if (!isTeamsDesktop()) {
					var result = GetOpenWindow(openLocation, "", 1150, 950, "YES");
					window.close();
				} else {
					parent.showPopupSlide(openLocation, 1150, 950, "", "", parent.hidePopupSlide);
				}
		    }
		    
		    var pReceiveSN = "";
		    var pSignSN = "";
		    function MappingSign(ReceiveSN, SignSN) {
		        pReceiveSN = ReceiveSN;
		        pSignSN = SignSN;
		        openSingUI();
		    }
		    
		    function openSignUI_Complete(RtnVal) {
		    	var result = "";
		        if (RtnVal == "cancel") {
		            var pAlertContent = strLang582;
		            OpenAlertUI(pAlertContent);
		            return;
		        } else {
		            var signCnt = 0;
		            ReceiveSN = trim_Cross(pReceiveSN);
		            
		            if (ReceiveSN == 0) {
		            	ReceiveSN = "";
		            }
		            var signID = ReceiveSN + "sign" + pSignSN;
		            var seumyungID = ReceiveSN + "jikwe" + pSignSN;
		            var seumyungdateID = ReceiveSN + "seumyungdate" + pSignSN;

		            var fields = message.GetFieldsList();
		            var field = message.GetListItem(fields, signID);

		            if (field) {
		                if (RtnVal == "cancel") {
		                    return RtnVal;
		                }

		                if (RtnVal != "NAME") { // 서명이 이미지인 경우 
		                    try {
		                        var signWidth = 50;
		                        var signHeight = 50; // 후결승인은 대리결재가 불가능하므로 代 문자의 삽입 없음 (이미지 서명의 높이가 50으로 고정됨)
		                        var strimg;
		                        strimg = "<img src='" + escape(RtnVal) + "' border=0 embedding='1' ";
		                        strimg = strimg + " width=" + signWidth;
		                        
		                        if (signImageType == "NAME") {
	                            	strimg = strimg + " height=" + signHeight + " spath='" + escape(RtnVal) + "'>" + "<br>" + arr_userinfo[2];
	                            } else {
	                            	strimg = strimg + " height=" + signHeight + " spath='" + escape(RtnVal) + "'>";
	                            }

		                        field.innerHTML = strimg;
		                        
		                        /* 2024-09-11 홍승비 - 후결승인 시 서명 데이터 DB 저장 형식 수정 */
		                        var content = RtnVal;
		                        if (signImageType == "NAME") {
		                        	content = content + "::" + arr_userinfo[2];
		                        }

		                        SignType[signCnt] = "IMAGE";
		                        SignName[signCnt] = signID;
		                        SignContent[signCnt] = content;

		                        signCnt = signCnt + 1;
		                    }
		                    catch (e) { showAlert(e.description); }
		                }
		                else {
		                    strimg = "<p style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</p>";
		                    field.innerHTML = strimg;
		                    SignType[signCnt] = "HTML";
		                    SignName[signCnt] = signID;
		                    SignContent[signCnt] = strimg;
		                    signCnt = signCnt + 1;
		                }
		            }

		            field = message.GetListItem(fields, seumyungdateID);

		            if (field) {
		                field.innerHTML = s;
		                SignType[signCnt] = "TEXT";
		                SignName[signCnt] = seumyungdateID;
		                SignContent[signCnt] = s;
		                signCnt = signCnt + 1;
		            }

		            SaveEndFile();
		            SignSave();
		            if (SetWhoKyulFlag() == "TRUE") {
		                OpenAlertUI(strLangSpjj31, whoKyulRefresh);
		                btnWhoKyul.style.display = "none";
		            } else {
		                OpenAlertUI(strLangSpjj32);
		            }
		        }
		    }
		    
		    function whoKyulRefresh() {
		    	try {
					window.opener.location.reload();
					window.opener.parent.frames["left"].getAprCountWHO();
				} catch (e) {
					window.parent.location.reload();
					window.parent.parent.frames["left"].getAprCountWHO();
				}
                // window.close();
				btnClose_onclick();
		    }
			
			function addRelatedCabinet() {
				//* moon 2018.07.26
// 				window.open("/ezCabinet/cabinetAddRelated.do?module=apprv", "addRelated", getOpenWindowfeature(480, 505));
				showPopup("/ezCabinet/cabinetAddRelated.do?module=apprv", 480, 505, "addRelated", getOpenWindowfeature(480, 505), hidePopup);
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
			
	    	// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
	    	function setAttachGuideText() {
	    		// 대용량첨부의 자동삭제 기능, 저장만료기한 사용하지 않음
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                
                if(bigSizeAttachDownloadLimitCount > 0) {
                	attachGuideText += strLangHSBAt06 + " <span style='color:#FF0000 ;'>" + bigSizeAttachDownloadLimitCount + strLangHSBAt09 + "</span> " + strLangHSBAt10;
                }
                
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += "</td>";
/*                 
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt05 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadPeriod + "</span></td>";
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt06 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadDay + strLangHSBAt07 + "</span>" + strLangHSBAt08;
                 */
                 
                 if (bigSizeAttachDownloadLimitCount > 0) {
                	 document.getElementById("apprAttachGuideTR").innerHTML = attachGuideText;
                 }
                 else {
                	 document.getElementById("apprAttachGuideTR").style.display = "none";
                 }
	    	}
	    	
	    	var ezapralertlong_cross_dialogArguments = new Array();
			function btnReqOpinion_onclick() {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezApprovalG/getRelayReqOpinion.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(text){
		    			result = text.opinion;
		    		}
		    	});
		    	
				var url = "/ezApprovalG/ezAprAlertLong.do";
		    	ezapralertlong_cross_dialogArguments[0] = result;
				ezapralertlong_cross_dialogArguments[1] = OpenAlertUILong_Complete;
				
				DivPopUpShow(330, 305, url);
			}
			
			function OpenAlertUILong_Complete() {
				DivPopUpHidden();
			}

			window.onbeforeunload = function () {
                if (isPreview != "Y") {
                    try {
                        if ((window.opener.g_sFlag == undefined && isDocAttach == "false") || (window.opener.g_sFlag != undefined && window.opener.g_sFlag == "m01") || (window.opener.g_sFlag != undefined && window.opener.g_sFlag == "docShare")) {
                            // 전자결재 > 완료문서, 기록물등록대장, 부서공유함에 적용 되도록 조건 추가
                            window.opener.openergetDocInfo();
                        } else {
                            return;
                        }
                    } catch (e) {
                        if ((window.parent.g_sFlag == undefined && isDocAttach == "false") || (window.parent.g_sFlag != undefined && window.parent.g_sFlag == "m01") || (window.parent.g_sFlag != undefined && window.parent.g_sFlag == "docShare")) {
                            // 전자결재 > 완료문서, 기록물등록대장, 부서공유함에 적용 되도록 조건 추가
                            window.parent.openergetDocInfo();
                        } else {
                            return;
                        }
                    }
                }
			}
			
			function checkHeaderAction() {
				if (useHideHeaderArea == "YES" && message.GetListItem(message.GetFieldsList(), "headerArea") != null) {
					document.getElementById("headerTabTR").style.display = "";
					$('#headerMenu').hover(function() {
						$('#headerMenu').css('border-bottom', '3px black solid');
						$('#headerHide').css({'color':'black', 'font-weight':'bold'});
					}, function() {
						$('#headerMenu').css('border-bottom', 'solid 1px #eaeaea');
						$('#headerHide').css({'color':'#8f8e93', 'font-weight':'normal'});
					}) 
				} else if (document.getElementById("headerTabTR") != null) {
					document.getElementById("headerTabTR").style.display = "none";
				}
			}
			
			function headerAction(action) {
	    		if (useHideHeaderArea == "YES") {
	    			var fields = message.GetFieldsList();
		    	    var field = message.GetListItem(fields, "headerArea");
		    	    
		    	    if (field) {
		    	        if (field.style.display == "none" || action == "open") {
		    	        	field.style.display = "";
		    	            document.getElementById("headerHide").innerHTML = ezApproval_headerHide01;
		    	        } else {
		    	            field.style.display = "none";
		    	            document.getElementById("headerHide").innerHTML = ezApproval_headerHide02;
		    	        }
		    	    }
	    		}
	    	}
			
		</script>
	</head>
	<body class="popup" style="OVERFLOW:hidden;height:100%">
		<table class="layout">
		  <tr>
		    <td style="height:20px"><div id="menu">
		    	<%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
		        <ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
					<c:choose>
					  <c:when test="${userInfo.lang eq '1'}">
						  <li id="btnWhoKyul" style="display:none"><span onClick="return btnWhoKyul_onclick()"><spring:message code='ezApproval.pjj35'/></span></li>
						  <li id="btnDocInfo"><span id="span_btnDocInfo" onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
						  <li id="btnSummary"><span onclick="return btnSummaryView()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
						  <li id="btnOpinion"><span id="span_btnOpinion" onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
						  <%-- 2023-06-26 민지수 - 추가의견 버튼 추가 --%>
						  <c:if test="${docAprEnd != 'APR'}"> <%-- 2023-07-13 민지수 - 배부대장의 경우 endView(완료문서보기)로 띄우지만 apr(진행중) 문서인 경우 버튼 숨김처리 --%>
							<li id="btnAddOpinion"><span id="span_btnOpinion_add" onClick="return btnOpinion_add_onclick()"><spring:message code='ezApprovalG.mjsOp01'/></span></li>
						  </c:if>
						  <li id="btnhistory"><span id="span_btnhistory" onClick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
						  <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
						  <c:if test="${sendType eq 'T'}">
							<li id="btnReqOpinion"><span onclick="btnReqOpinion_onclick()">재발송의견</span></li>
						  </c:if>
						  <c:if test="${useBoard == 'YES' }">
						  <li id="btnBoard"><span id="span_btnBoard" onClick="return NewItem_onclick()"><spring:message code='ezApprovalG.t1514'/></span></li>
						  </c:if>
						  <c:if test="${approvalFlag eq 'S' and orgCompanyID eq userInfo.companyID and formID != '2018000000' and docAprEnd != 'APR'}">
							<li id="btnReuse"><span onClick="return btnReuse_onclick('reuse')"><spring:message code='ezApprovalG.t990048'/></span></li>
						  </c:if>
						  <c:if test="${approvalFlag eq 'G' and formID != '2018000000' and docAprEnd ne 'APR'}">
							<li id="btnReuse"><span onClick="return btnReuse_onclick('reuse')"><spring:message code='ezApprovalG.t990048'/></span></li>
						  </c:if>
						  <li id="btnPrint"><span class="icon16 popup_icon16_print" id="span_btnPrint" onClick="return btnPrint_onclick()"></span></li>
						  <c:if test="${useExternalMailServer == 'NO'}">
						  <li id="btnMail"><span class="icon16 popup_icon16_mail_gray" id="span_btnMail" onClick="return btnMail_onclick()"></span></li>
						  </c:if>
						  <c:if test="${useCabinet == 'YES'}">
								<li><span onclick = "return addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
						  </c:if>
					  </c:when>
					  <c:otherwise>
						  <li id="btnWhoKyul" style="display:none"><span onClick="return btnWhoKyul_onclick()"><spring:message code='ezApproval.pjj35'/></span></li>
						  <li id="btnDocInfo"><span id="span_btnDocInfo" onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
						  <li id="btnSummary"><span onclick="return btnSummaryView()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
						  <li id="btnOpinion"><span id="span_btnOpinion" onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
						  <%-- 2023-06-26 민지수 - 추가의견 버튼 추가 --%>
						  <c:if test="${docAprEnd != 'APR'}"> <%-- 2023-07-13 민지수 - 배부대장의 경우 endView(완료문서보기)로 띄우지만 apr(진행중) 문서인 경우 버튼 숨김처리 --%>
							<li id="btnAddOpinion"><span id="span_btnOpinion_add" onClick="return btnOpinion_add_onclick()"><spring:message code='ezApprovalG.mjsOp01'/></span></li>
						  </c:if>
						  <c:if test="${approvalFlag eq 'S' and orgCompanyID eq userInfo.companyID and formID != '2018000000' and docAprEnd != 'APR'}">
							<li id="btnReuse"><span onClick="return btnReuse_onclick('reuse')"><spring:message code='ezApprovalG.t990048'/></span></li>
						  </c:if>
						  <c:if test="${approvalFlag eq 'G' and formID != '2018000000' and docAprEnd ne 'APR'}">
							<li id="btnReuse"><span onClick="return btnReuse_onclick('reuse')"><spring:message code='ezApprovalG.t990048'/></span></li>
						  </c:if>
						  <li id="btnPrint"><span class="icon16 popup_icon16_print" id="span_btnPrint" onClick="return btnPrint_onclick()"></span></li>
						  <c:if test="${useExternalMailServer == 'NO'}">
						  <li id="btnMail"><span class="icon16 popup_icon16_mail_gray" id="span_btnMail" onClick="return btnMail_onclick()"></span></li>
						  </c:if>
						  <li id="moreBoardIcon" class="view_moreboarditem" style="display: block;">
							  <span class="view_icon" onclick="this.parentNode.classList.toggle('on')">
								<img src="/images/ImgIcon/view_more.png">
							  </span>
							<ul class="layer_select">
								<li id="btnhistory"><span id="span_btnhistory" onClick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
								<li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
								<c:if test="${sendType eq 'T'}">
									<li id="btnReqOpinion"><span onclick="btnReqOpinion_onclick()">재발송의견</span></li>
								</c:if>
								<c:if test="${useBoard == 'YES' }">
									<li id="btnBoard"><span id="span_btnBoard" onClick="return NewItem_onclick()"><spring:message code='ezApprovalG.t1514'/></span></li>
								</c:if>
								<c:if test="${useCabinet == 'YES'}">
									<li><span onclick = "return addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
								</c:if>
							</ul>
						</li>
					  </c:otherwise>
					</c:choose>
		        </ul>
		        <ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
		        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
		        </ul>
		      </div>
		      <div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
		        <ul>
		          <li id="btnClose" ><span onClick="return btnClose_onclick()"></span></li>
		        </ul>
		      </div></td>
		  </tr>
			<c:if test="${useHideHeaderArea == 'YES'}">
			  <tr id="headerTabTR" style="display:none;">
				<td>
					  <div id="headerTab" style="width:90%; height:27px; margin:0 auto; border-bottom: solid 1px #eaeaea; box-sizing: border-box;">
						<div id="headerMenu" style="width:155px; height:100%; cursor:pointer; text-align:center" onclick="headerAction()">
							<span id="headerHide" style="color:#8f8e93; font-size:14px;"><spring:message code='ezApproval.headerHide01'/></span>
						</div>
					  </div>
				</td>
			  </tr>
			</c:if>
		  <tr>
		    <td style="padding-bottom:10px;height:90%"> 
		          <iframe id="message" name="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" style="width: 100%; height:100%" src="ConDocViewContent.do" frameborder="0"></iframe>                
		    </td>
		  </tr>
		   <tr>
		  <td>
		  <div id="officeBtn" style="display:none;">
		  	<div style="text-align:center; background-color:rgba(0, 0, 0, 0.5); height: 50px;">
		  		<img id="zoomIn" onclick="zoomIn()" src="/images/icviewer_plus.png" width="25" height="25" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="zoomOut" onclick="zoomOut()" src="/images/icviewer_minus.png" width="25" height="25" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="zoomReset" src="/images/icviewer_reset.png" width="25" height="25" onclick="zoomReset()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="officeBar1" src="/images/icviewer_bar.png" style="position: relative; top: 13px;">
		  		<img id="prevAll" border="0" src="/images/icviewer_p_prev.png" width="25" height="25" onClick="prevClickAll()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="prev" border="0" src="/images/icviewer_prev.png" width="25" height="25" onClick="prevClick()" style="cursor:pointer; position: relative; top: 13px;">
		  			<select id="selectImg" class="imgSelect" onchange="selectImg()">
		  				<option value=""></option>
		  			</select>
		  		<img id="next" border="0" src="/images/icviewer_next.png" width="25" height="25" onClick="nextClick()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="nextAll" border="0" src="/images/icviewer_n_next.png" width="25" height="25" onClick="nextClickAll()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="officeBar2" src="/images/icviewer_bar.png" style="position: relative; top: 13px;">
		  		<img src="/images/icviewer_expend.png" class="allImg" id="all" onclick="allImg(this)" style="cursor:pointer; position: relative; top: 13px;" width="25" height="25">
			</div>
		</div>
		  </td>
		  </tr>
		  <tr>
		    <td style="height:20px">
                <table class="file" style="height:80px;">
                    <tr>
                        <th><spring:message code='ezApprovalG.t65'/></th>
                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
                            <div id="lstAttachLink" style="height:70px;"></div>
                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
                            <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
                        </td>
                        <td style=" width:30%;">
							<div id="lstAttachLinkDoc" style="height:70px;"></div>
						</td>
						<td class="pos2" style="width:8%; background:#fffcfa;">
							<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
							<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
						</td>
                    </tr>
                </table>

				<%-- 대용량첨부 가이드 메세지 영역 --%>
                <table class="file" style="height: 20px;">
                    <tr id="apprAttachGuideTR"></tr>
                </table>
		      
			</td>
		  </tr>
		</table>
	
		<script type="text/javascript" >
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<script type="text/javascript">
			var moreBoardIcon = document.getElementById("moreBoardIcon");
			var iframeContent = document.getElementById("message");
			var liBtn = document.querySelector(".layer_select");
			
			document.addEventListener("click", function(e) {
				if (moreBoardIcon && !moreBoardIcon.contains(e.target)) {
					moreBoardIcon.classList.remove("on");
				}
			});
			
			iframeContent.addEventListener("load", function() {
				try {
					var idoc = iframeContent.contentDocument || iframeContent.contentWindow.document;
					idoc.addEventListener("click", function() {
						if (moreBoardIcon) {
							moreBoardIcon.classList.remove("on");
						}
					});
				} catch (e) {}
			});
			
			if (liBtn) {
				liBtn.addEventListener("click", function(e) {
					moreBoardIcon.classList.remove("on");
				});
			}
		</script>
	</body>
</html>
