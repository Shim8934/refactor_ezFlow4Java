<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t367'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprmanage_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
	    <script type="text/javascript">
	        var pDocID = "<c:out value='${docID}'/>";
	        var docHref = "<c:out value='${docHref}'/>";
	        var pListSusin = "<c:out value='${listSusin}'/>";
	        var porgDocID = "<c:out value='${orgDocID}'/>";
	        var pFormID = "<c:out value='${formID}'/>";
	        var formUrl = "<c:out value='${formUrl}'/>";
	        var formDocType = "<c:out value='${formDocType}'/>";
	        var useFormContOnReuseForWHWP = "<c:out value='${useFormContOnReuseForWHWP}'/>";
	        var pTitle = "<c:out value='${docTitle}'/>";
	        var pOpinionFlag;
	        var pListTypeValue = 4;
	        var flag = false;
	        var PrevOpinionFlag = false;
	        var NextOpinionFlag = true;
	        var doctitle = "";
	        var pOrgAttach = "";
	        var pendDir = "<c:out value='${endDir}'/>";
			var xmlhttp = createXMLHttpRequest();
			var arr_userinfo = new Array();
			arr_userinfo[0] = "user";
		    arr_userinfo[1]  = "<c:out value='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value='${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value='${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value='${susinAdmin}'/>";
	        arr_userinfo[11]  = "<c:out value='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value='${userInfo.deptName2}'/>";
	        var companyID = "<c:out value='${userInfo.companyID}'/>";
	        var pUserID = arr_userinfo[1];
	        var pUse_Editor = "<c:out value='${useEditor}'/>";
			var ext = "hwp";
			var orgCompanyID = "<c:out value='${orgCompanyID}' />";
			var useExternalMailServer = "<c:out value='${useExternalMailServer}'/>";
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
			
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
			
	     	// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";

			// 배부대장 문서 진행/완료 여부 플래그 (APR/END)
			var docAprEnd = "<c:out value ='${docAprEnd}'/>";
			
			/* 2023-12-07 홍승비 - 전자결재 서명데이터 재맵핑에 필요한 docState 파라미터 추가 */
			var pDocState = "<c:out value ='${docState}'/>";
			
			// 첨부문서 확인 여부 (첨부문서 창 닫을시 발생하는 오류 방지를 위한 Flag)
			var isDocAttach = "<c:out value = '${isDocAttach}'/>";
			var ReturnFunction;
			
            var approvalFlag = "<c:out value = '${approvalFlag}'/>";
            
            var isPreview = "<c:out value = '${isPreview}'/>";
            
	        window.onresize = function () {
	       		document.getElementById("messageWHWPEditor").style.height = document.documentElement.clientHeight - 150 + "px";
	       		var mHeight = document.documentElement.clientHeight - 110 - document.getElementById("messageWHWPEditor").offsetTop + "px";
	       		message.Resize(mHeight);
	        }
	
			var aprendopinion_dialogArgument = new Array();
	        function btnOpinion_onclick() {
	            var parameter = new Array();
	            parameter[0] = pDocID;
	            parameter[1] = "Show";
	            parameter[2] = orgCompanyID;
	
	            var url = "/ezApprovalG/aprEndOpinion.do";
	            //var feature = "status:no;dialogWidth:530px;dialogHeight:520px;scroll:no;edge:sunken"
	            //var ret = window.showModalDialog(url, parameter, feature);
	            
	            aprendopinion_dialogArgument[0] = parameter;
	            aprendopinion_dialogArgument[1] = openOpinionUI_Complete;
	            DivPopUpShow(530, 520, url);
	        }

			/* 2023-06-26 민지수 - 전자결재 > 완료문서 > [추가의견] 클릭 시 동작 함수 추가 */
			function btnOpinion_add_onclick() {
				openOpinionUI_New_Add("ADD");
			}

	        function openOpinionUI_Complete() {
		        DivPopUpHidden();
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
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezApprovalG/getEndOpinionInfo.do",
						data : {
							docID : pDocID
							,orgCompanyID : orgCompanyID
						},
						success: function(xml){
							result = loadXMLString(xml);
						}
					});
				}
		
		        Resultxml = result;
		
		        var NodeList = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
		
		        if (NodeList.length != "0") {
		            return true;
		        } else {
		            return false;
		        }
	        }
	
	        function window_onload() {
	            window.onresize();
	
	            /* HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
	            HwpCtrl.SetSaveMode(1); */
				
	            if ("${pass}" != "<RESULT>TRUE</RESULT>") {
	                QuitWindow();
	            }

				try {
					if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					}
				} catch (e) { }
	            
				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
                
	        }
	
			function QuitWindow() {		
			 // 2023-09-05 전인하 - 전자결재G > 기록물대장 미리보기 - 사용자에게 열람권한이 없을 때 미리보기 영역에서 문서가 열렸을 경우 미리보기 프레임에 공백 페이지 삽입. 
			 // mht에 대해서만 적용되어있었던 처리를 whwp에서도 동일 적용함
             // 2022-07-29 홍승비 - 미리보기 영역으로 열린 경우, iframe src 자체를 공백으로 변경 */
                var ifrmPreViewH = window.parent.document.getElementById("ifrmPreViewH");
                if (ifrmPreViewH != null && window.self.frameElement.id == "ifrmPreViewH") {
                    ifrmPreViewH.src = "<spring:message code='main.kms4'/>";
                } else {
                    menu.style.display = "none";
                    alert(strLang1139);
                    btnClose_onclick();
                    window.close();
                }
			}
	
			/* function OpenAlertUI(pAlertContent, CompleteFunction) {
			    var parameter = pAlertContent;
			    var url = "/ezApprovalG/ezAprAlert.do";

		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(330, 205);
		        var RtnVal = window.showModalDialog(url, parameter, feature);
			} */
			
			
			function btnPrint_onclick() {
				message.PrintDocument();
			}
			
			// function btnClose_onclick() {
			//     window.close();
			// }
	
			var ezapropinion_cross_dialogArguments = new Array();
			function OpenInformationUI(pInformationContent, CompleteFunction) {
				var parameter = pInformationContent;
				var url = "/ezApprovalG/ezAprOpinion.do";
				//var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
				
				ezapropinion_cross_dialogArguments[0] = parameter;
	            if (CompleteFunction != undefined)
	                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
	            else
	                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
	            
	            DivPopUpShow(330, 205, url);				
			}
			
			//한글 pc저장이 안돼서 저장방식 변경
			 function FileDown(docTitle) {
	            var pDocID_mht = pDocID;
	            AttachDownFrame.location.href = "/ezApprovalG/downloadAttachDbClick.do?type=APPROVALGMHT&fileName=" + encodeURIComponent(docTitle + ".hwp") + "&docID=" + pDocID_mht + "&docStatus=" + "END";
	        }
	
			function btnSave_onclick() {
			    var hwpDoctitle = message.GetFieldText("doctitle").replace("\r\n", "");
			    hwpDoctitle = hwpDoctitle.replace(/\\/ig, '').replace(/\//ig, '').replace(/:/ig, '').replace(/\*/ig, '').replace(/\?/ig, '').replace(/“/ig, '').replace(/</ig, '').replace(/>/ig, '').replace(/|/ig, '').replace("“", "").replace("|", "");
				FileDown(hwpDoctitle);
			}
	
			function btnMail_onclick() {
// 			    window.open("/myoffice/ezEmail/mail_write.aspx?DocHref=" + docHref +"&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
// 				window.open("/ezEmail/mailWrite.do?docHref=" + docHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
				showPopup("/ezEmail/mailWrite.do?docHref=" + docHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", 890, window.screen.availHeight * 0.8, "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8), hidePopup);
			}
	
			function btnBoard_onclick() {
			    var wWeight = "345";
			    var wHeight = "660";
			
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			
			    var left = (width - wWeight) / 2;
			    var top = (heigth - wHeight) / 2;
			    var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
			        "DialogHeight:660px;DialogWidth:345px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
			
			    if (typeof (ret) != "undefined") {
			        pBoardID = ret[0];
			
			        if (pBoardID == "" || typeof (pBoardID) == "undefined") {
			            return;
			        }
			
			        var pheight = window.screen.availHeight;
			        var pwidth = window.screen.availWidth;
			        var pTop = (pheight - 720) / 2;
			        var pLeft = (pwidth - 765) / 2;
			
			        if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
			            alert(strLang1031);
			        }
			        else {
			            if (pUse_Editor == "" || pUse_Editor == "CK") {
			                window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + docHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
			            }
			            else {
			                window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + docHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
			                //window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + docHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
			            }
			        }
			    }
			}
	
			function btnhistory_onclick() {
			    getHistory();
			}
	
			function getHistory() {
				var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + ext;
				centerOpenWindow(URL, 740, 450);
			}
	
			function centerOpenWindow(wfileLocation, wWeight, wHeight) {
			    try {
			    	if (CrossYN()) {
			        	if (isIE() && !document.getElementById("iFrameLayer")) {
			        		var heigth = window.screen.availHeight;
			        		var width = window.screen.availWidth;
			        		var left = (width - wWeight) / 2;
			        		var top = (heigth - wHeight) / 2;
			        		window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
			        	} else {
			        		DivPopUpShow(wWeight, wHeight, wfileLocation);
			        	}
			        } else {
			            var heigth = window.screen.availHeight;
			            var width = window.screen.availWidth;
			            var left = (width - wWeight) / 2;
			            var top = (heigth - wHeight) / 2;
			            window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
			        }
			    } catch (e) {
			        alert("centerOpenWindow :: " + e);
			    }
			}
	
			var ezdocinfog_view_cross_dialogArguments = new Array();
			function btnDocInfo_onclick() {
				ezdocinfog_view_cross_dialogArguments[0] = "";
		        ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;
                // 2023-10-16 전인하 - 전자결재G > 기록물배부대장 > 배부대장 문서정보 오류
                // 문서정보를 무조건 완료문서 DB에서 가져와, 진행문서를 배부대장에서 조회하는 경우 발생하는 문서정보 조회불가 현상을 수정함
		        var ingFlag = docAprEnd == "APR" ? "APR" : "END";
				var url = "/ezApprovalG/ezDocInfoView.do?docID=" + pDocID + "&ingFlag=" + ingFlag;
			    //var feature = "status:no;dialogWidth:420px;dialogHeight:495px;help:no;scroll:no;edge:sunken;";
			    //var RtnVal = window.showModalDialog(url, "", feature);
				if (typeof approvalFlag !== "undefined" && approvalFlag == "G") {
					DivPopUpShow(430, 400, url);
				}else {
					DivPopUpShow(430, 300, url);
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
				/* var feature = "status:no;dialogWidth:330px;dialogHeight:305px;help:no;scroll:no;edge:sunken";
				
				window.showModalDialog(url, result, feature); */
		    	ezapralertlong_cross_dialogArguments[0] = parameter;
				ezapralertlong_cross_dialogArguments[1] = OpenAlertUILong_Complete;
				
				DivPopUpShow(330, 305, url);
			}
			
			function OpenAlertUILong_Complete() {
				DivPopUpHidden();
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
			
	    	function Editor_Complete() {
	        	if (docHref != "") {
                    var URL;
                    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(docHref);
                    message.Open(URL, "", "", function (res) {
                    	if (res.result) {
    	                    setAttachInfo(pDocID, "END", lstAttachLink);
    	                    
    	                    /* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
    	    		        message.startRemapAllAprSign_WHWP(pDocID, orgCompanyID);
    	    		        
    	    		        // 현재 문서가 수신문이면서 원문서가 존재하는 경우, 원문서의 서명 데이터도 재맵핑
    	    		        if (pDocState == "011" && porgDocID != null && typeof(porgDocID) != "undefined" && porgDocID != "") {
    	    		        	message.startRemapAllAprSign_WHWP(porgDocID, orgCompanyID);
    	    		        }
    	    		        
    	                    var Rtnval = CheckOpinionInfo();
    	                    if (Rtnval) {
    	                        var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
    	                        OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
    	                    }
    	
    	                    //HwpCtrl.SetImgReg();
    	                } else {
    	                    //hideProgress();
    	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
    	                    OpenAlertUI(pAlertContent);
    	                    message.Clear();
    	                }
                    	message.EditMode(0);
						message.SetViewProperties(2, 100);
                    }, null);
	        	}
	    	}
	    	
	    	function CheckOpinionYN_complete(Ans) {
	    		DivPopUpHidden();
	    		
	    		if (Ans) {
                    btnOpinion_onclick();
                }
	    	}
	    	
	    	// 통합 PC 저장 시작
	    	var totalsavefileinfo_dialogArguments = new Array();
		    
	    	function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
		
		        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=" + docAprEnd + "&orgCompanyID=" + orgCompanyID);
		    }
		    
	    	function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
	    	// 통합 PC 저장 끝
	    	
	    	// 게시판 게시 시작
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
		                alert(strLang1031);
		            }
		            else {
		                // window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + docHref + "&orgCompanyID=" + orgCompanyID, '', GetOpenWindowJun(765, 870));
						showPopup("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + docHref + "&orgCompanyID=" + orgCompanyID, 765, 870, "", GetOpenWindowJun(765, 870), hidePopup);
		            }
		        }
		    }
		 // 게시판 게시 끝
		    
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
		 
		var editable = "";
	 	function btnReuse_onclick(type) {
	 		editable = type;
	 		if (useFormContOnReuseForWHWP === "YES") {
		 		var parameter = new Array();
		        parameter[0] = "sol2";
		        parameter[1] = "A01000";
		        
		        url = "/ezApprovalG/getFormCont.do?fileType=HWP&reuseFlag=Y";
		        
		        if (CrossYN()) {
		            getformcont_cross_dialogArguments[0] = parameter;
		            getformcont_cross_dialogArguments[1] = btnReuse_onclick_complete;
		            var getFormCont_Cross = window.open(url, "/ezApproval/getFormCont.do", GetOpenWindowfeature(713, 570));
		            
		            try { getFormCont_Cross.focus(); } catch (e) {}
		        } else {
		            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		            var ret = window.showModalDialog(url, parameter, feature);
		            formURL = ret[0];
		            formDocType = ret[1];
		            
		            if (formURL != "cancel") {
		                openDraftUI(formURL, formDocType);
		            }
		        }
	 		}
	 		else {
	 			newFormURL = formUrl;
	 			newFormDocType = formDocType;
	 	        openDraftUI("DRAFT");
	 		}
	 	}
	 	
	 	var editable = "";
	 	var newFormURL = "";
	 	var newFormDocType = "";
		function btnReuse_onclick_complete(ret) {
			if(ret[0] != "cancel") {
				newFormURL = ret[0];
		        newFormDocType = ret[1];
		        newFormID = newFormURL.substring(newFormURL.lastIndexOf("/")+1);
		        
				var pAlertContent;
				 $.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		data : {
			    			formID : newFormID,
			    			companyID : orgCompanyID
			    		},
			    		url : "/ezApprovalG/getFormDetail.do",
			    		success: function(xml){
							xml = loadXMLString(xml);
							
							var currConnflag = getNodeText(GetElementsByTagName(xml, 'FORMCONNFLAG')[0]);
							var currVersion = getNodeText(GetElementsByTagName(xml, 'FORMVERSION')[0]);
	
							if(currConnflag === 'Y') {
								pAlertContent = '연동양식은 재사용 할 수 없습니다.';
								OpenAlertUI(pAlertContent);
								return;
							}
							
							openDraftUI("DRAFT", "");
						},
						error: function() {
							pAlertContent = '문서 재사용에 실패하였습니다.';
							OpenAlertUI(pAlertContent);
						}        			
		    	});
			}
	     }
		 
		function openDraftUI(pDraftFlag) {
			var pArgument = new Array();
			
	        pArgument[0] = newFormURL;
	        pArgument[1] = pDraftFlag;
	        pArgument[2] = newFormDocType;
            pArgument[3] = "0";
            pArgument[4] = "";
            pArgument[5] = "1";
            pArgument[6] = "";
            pArgument[7] = "";
            pArgument[8] = editable;
            pArgument[9] = pDocID;
            
			var params = {
				formURL: escape(pArgument[0]),
				draftFlag: escape(pArgument[1]),
				formDocType: escape(pArgument[2]),
				susinSN: escape(pArgument[3]),
				docstate: escape(pArgument[4]),
				listType: escape(pArgument[5]),
				aprState: escape(pArgument[6]),
				isTmpDoc: escape(pArgument[7]),
				isUsed: escape(pArgument[8]),
				beforeDocID: escape(pArgument[9])
			};
	        
			var openLocation = "";
			
			if(useWebHWP == "YES") {
				openLocation = "/ezApprovalG/draftuiWHWP.do?" + new URLSearchParams(params);
			}
			else {
				openLocation = "/ezApprovalG/draftuiHWP.do?" + new URLSearchParams(params);
			}
	        
	        var result = GetOpenWindow(openLocation, "", 1050, 970, "YES");
	        window.close();
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
                            window.parent.openergetDocInfo();
                        } else {
                            return;
                        }
                    }
                }
			}
	    </script>
	</head>
	<body class="popup" style="overflow: hidden" onload="javascript:window_onload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
		        		<ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnSummary"><span onclick="return btnSummaryView()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        <li id="btnOpinion"><span onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
							<%-- 2023-06-26 민지수 - 추가의견 버튼 추가 --%>
							<c:if test="${docAprEnd != 'APR'}"> <%-- 2023-07-13 민지수 - 배부대장의 경우 endView(완료문서보기)로 띄우지만 apr(진행중) 문서인 경우 버튼 숨김처리 --%>
							<li id="btnAddOpinion"><span id="span_btnOpinion_add" onClick="return btnOpinion_add_onclick()"><spring:message code='ezApprovalG.mjsOp01'/></span></li>
							</c:if>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	                        <c:if test="${useBoard == 'YES' }">
	                        <li id="btnBoard"><span onclick="return NewItem_onclick()"><spring:message code='ezApprovalG.t1514'/></span></li>
	                        </c:if>
	                        <c:if test="${formID != '2018000000' && docAprEnd != 'APR'}"> <%-- 2024-08-19 조소정 - 배부대장의 경우 apr(진행중) 문서인 경우 버튼 숨김처리 --%>
	                        <li id="btnReuse"><span onClick="return btnReuse_onclick('reuse')"><spring:message code='ezApprovalG.t990048'/></span></li>
	                        </c:if>
	                        <li id="btnPrint"><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span></li>
	                    	<c:if test="${useExternalMailServer == 'NO' }">
	                        <li id="btnMail"><span class="icon16 popup_icon16_mail_gray" onclick="return btnMail_onclick()"></span></li>
	                        </c:if>
	                        <c:if test="${sendType eq 'T'}">
		                        <li id="btnReqOpinion"><span onclick="btnReqOpinion_onclick()">재발송의견</span></li>
	                        </c:if>
	                    </ul>
						<ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
				        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
				        </ul>
	                </div>
	                <div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-bottom:10px;height:800px;" id="messageWHWPEditor">
		    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px; margin-top:-9px;">
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
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
