<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t143" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/ezPersonal/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" language="javascript">
			var BoardID = "<c:out value='${model.boardID}'/>";
	        var brd_color = "<c:out value='${model.boardColor}'/>";
	        var background = $.trim("<c:out value='${model.backGround}'/>");
	        var pAdminType = $.trim("<c:out value='${adminType}'/>");
	        var FormFlag =  $.trim("<c:out value='${model.formFlag}'/>");
	        var APPRFLAG = $.trim("<c:out value='${model.apprFlag}'/>");
	        var APPRMAILFLAG = $.trim("<c:out value='${model.apprMailFlag}'/>");
	        var orgAPPRFLAG = $.trim("<c:out value='${model.apprFlag}'/>");
	        var parentBoardID =  "<c:out value='${model.parentBoardID}'/>";
	        var primary = "<c:out value='${primary}'/>";
	        var isAllGroupBoard = "<c:out value='${isAllGroupBoard}'/>";
	        var useBoardLike = "<c:out value='${model.likeFlag}'/>";
	        var useBoardDisLike = "<c:out value='${model.disLikeFlag}'/>";
	        var noticeBoardID = $.trim("<c:out value='${noticeBoardID}'/>"); // 공지사항 게시판ID(없다면 ""으로 전달됨)
	        var xmlhttp = createXMLHttpRequest();
	        var ApprUserList = "";
	        var selectTargetListXML = "";
			var selecttarget_cross_dialogArguments = new Array();
			var manycolor_dialogArguments = new Array();
			var BoardExtension_dialogArguments = new Array();
			// 2020-12-04 박기범 - 탭게시판 ID추가
			var tabBoardID1 = $.trim("<c:out value='${tabBoardID1}'/>");
			var tabBoardID2 = $.trim("<c:out value='${tabBoardID2}'/>");
			var tabBoardID3 = $.trim("<c:out value='${tabBoardID3}'/>");
			var useBoardReplyReact = "<c:out value='${model.reactFlag}'/>"; // 2023-07-28 임정은 - 게시판 댓글 좋아요 기능 사용여부
			var useKeyword = "<c:out value='${model.useKeyword}'/>"; // 키워드 사용여부(Y/N)
			var boardItemCnt = "<c:out value='${boardItemCnt}'/>";
			var attachmentFlag = $.trim("<c:out value='${model.attachmentFlag}'/>");
			var useAllNewBoard = $.trim("<c:out value='${model.allNewBoardFlag}'/>");
			var writerFlag = $.trim("<c:out value='${model.writerFlag}'/>"); 
			var starRatingFlag = "<c:out value='${model.starRatingFlag}'/>";
			var boardType = "${ model.guBun }";
			var hasBoardItemFlag = "${ hasBoardItemFlag }";
			var versionManageFlag = false;
			
	        document.onselectstart = function (){
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
	                return false;
	            }
	            else {
	                return true;
	            }
	    	};
        
			$(document).ready(function() {
	            if (background == "Y") {
	                $("#chkbackgroundimage").prop("checked",true);
	            }
	            if (FormFlag == "Y") {
	                $("#chkform").prop("checked",true);
	            }
	            /* 2019-04-04 홍승비 - 게시판에 좋아요 기능 추가 */
				if (useBoardLike == "Y") {
					$("#chkBoardLike").prop("checked", true);
	            }
				/* 2023-07-28 임정은 - 게시판에 댓글 좋아요 기능 추가 */
				if (useBoardReplyReact == "Y") {
					$("#chkBoardReplyReact").prop("checked", true);
	            } else if ($("#chkOneLineNone").is(":checked")) {
					$("#chkBoardReplyReact").prop("disabled", true);
				}
				/* 2023-04-06 기민혁 - 게시판 싫어요 기능 추가  */
	            if (useBoardDisLike == "Y") {
					$("#chkBoardDisLike").prop("checked", true);
	            }
				
				if (useKeyword == "Y") {
				    $("#keyWord").prop("checked", true);
				}
				
				/* 2024-10-02 이혜림 - 게시판에 별점 평가하기 기능 추가 */
                if (starRatingFlag == "Y") {
                    $("#chkStarRating").prop("checked", true);
                }
                
	            if (pAdminType == "y") {
	                parent.document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t60' />";
	            }
	            if (APPRFLAG == "Y") {
	                $("#chkApprBoard").prop("checked",true);
	                document.getElementById("chkApprList").style.display = "";
	                document.getElementById("chkApprListMail").style.display = "";

	                getApprUserList();
	            }
	            if (APPRMAILFLAG == "Y") {
	                $("#chkApprBoardMail").prop("checked",true);
	            }
	            
	            /* 2018-06-29 홍승비 - 기존 승인여부가 null인 게시판은 'N'값으로 처리 */
	            if (orgAPPRFLAG.trim() == "") {
	            	orgAPPRFLAG = "N";
	            }
	            if (APPRFLAG.trim() == "") {
	            	APPRFLAG = "N";
	            }
	            
	            /* 2019-10-11 홍승비 - 공지사항 게시판 사용여부 추가 */
	            if (noticeBoardID == BoardID) { // 공지사항 게시판과 현재 게시판의 ID가 동일
	            	$("#chkNoticeBoard").prop("checked", true);
	            }
	            
	            // 2020-12-01 박기범 - 탭게시판 사용여부 추가
	            if (tabBoardID1 == BoardID) { 
	            	$("#chktabBoard1").prop("checked", true);
	            }
	            if (tabBoardID2 == BoardID) { 
	            	$("#chktabBoard2").prop("checked", true);
	            }
	            if (tabBoardID3 == BoardID) { 
	            	$("#chktabBoard3").prop("checked", true);
	            }
	            
	            if ($("#chkQnABoard").is(":checked") || $("#chkAnonyBoard").is(":checked")) {
	                if ($("#chkApprBoard").is(":checked")) {
	                	$("#chkApprBoard").prop("checked",false);	                    
	                    checkApprBoard();
	                    $("#chkApprBoard").prop("disabled",true);
	                } else {
	                	$("#chkApprBoard").prop("disabled",true);
	                }
	            }

				if (writerFlag == "Y") {
					$("#chkWriterFlag").prop("checked", true);
				}

				checkGubun();
	            /* 2019-04-26 홍승비 - 게시판 설정으로 통합된 TR들을 체크박스 disabled 설정으로 변경 */
	            /* 2018-07-11 홍승비 - 포토, 썸네일, 익명, URL, 동영상 게시판 선택 시 답변메일발송 tr 보이지 않도록 수정 */
	            //추가항목
	            if ("${style}" == "") {
	                if ($("#chkPhotoBoard").is(":checked") || $("#chkThumbBoard").is(":checked") || $("#chkMovieBoard").is(":checked")) {
	                    document.getElementById("trAttribute").style.display = "none";
						document.getElementById("trAttachment").style.display = "none";
	                    $("#chkNotify").prop("disabled", true);
	                    $("#chkbackgroundimage").prop("disabled", true);
	                    $("#chkform").prop("disabled", true);
	                    
	                    $("#chkNotify").prop("checked", false);
	                    $("#chkbackgroundimage").prop("checked", false);
	                    $("#chkform").prop("checked", false);
	                }
	                else if ($("#chkAnonyBoard").is(":checked")) {
	                	$("#chkNotify").prop("disabled", true);
						$("#chkMailFG_Post").prop("disabled", true);
						$("#chkMailFG_Mod").prop("disabled", true);
						$("#chkMailFG_Comment").prop("disabled", true);
	                	$("#chkNotify").prop("checked", false);
	                	$("#chkMailFG_Post").prop("checked", false);
	                    $("#chkMailFG_Mod").prop("checked", false);
	                    $("#chkMailFG_Comment").prop("checked", false);
	                    
	                    // 2024-10-04 전인하 - 관리자 > 게시판 > 일반설정 > 익명게시판일 경우 댓글/게시글 좋아요 싫어요 기능 비활성화
	                    $("#chkBoardLike").prop("disabled", true);
                        $("#chkBoardDisLike").prop("disabled", true);
                        $("#chkBoardReplyReact").prop("disabled", true);
						$("#chkWriterFlag").prop("disabled", true);
	                }
	                /* 2018-07-13 홍승비 - 일반설정 화면 온로드 시 URL게시판 구분 추가 */
	                /* 2021-12-31 홍승비 - 홈페이지 게시판 유형 추가 */
	                /* 2024-08-28 조소정 - 카테고리 게시판 유형 추가 */
	                else if ($("#chkURLBoard").is(":checked") || $("#chkHomePageBoard").is(":checked") || $("#chkCategoryBoard").is(":checked")) {
	                	
	                	if ($("#chkURLBoard").is(":checked")) {
		            		document.getElementById("txtURL").style.display = "";
	                	} else {
	                		document.getElementById("txtURL").style.display = "none";
	                	}
	                	
	                	if ($("#chkCategoryBoard").is(":checked")) {
	                		$("#chkNoticeBoard").prop("disabled", true);
	                	}
	                	
		            	document.getElementById("trAttribute").style.display = "none";
	                    document.getElementById("expireTr").style.display = "none";
	                    document.getElementById("deleteAfterTr").style.display = "none";
	                    document.getElementById("attachLimitTr").style.display = "none";
	                    document.getElementById("trAttachment").style.display = "none";
	                    
	                    $("#chkNotify").prop("disabled", true);
	                    $("#chkMailFG_Post").prop("disabled", true);
	                    $("#chkMailFG_Mod").prop("disabled", true);
	                    $("#chkMailFG_Comment").prop("disabled", true);
	                    $("#chkbackgroundimage").prop("disabled", true);
	                    $("#chkform").prop("disabled", true);
	                    $("#chkApprBoard").prop("disabled", true);
	                    $("#chkBoardLike").prop("disabled", true);
	                    $("#chkBoardReplyReact").prop("disabled", true);
	                    $("#chkBoardDisLike").prop("disabled", true);
	                    $("#chkStarRating").prop("disabled", true);
	                    
	                    $("#chkNotify").prop("checked", false);
	                    $("#chkMailFG_Post").prop("checked", false);
	                    $("#chkMailFG_Mod").prop("checked", false);
	                    $("#chkMailFG_Comment").prop("checked", false);
	                    $("#chkbackgroundimage").prop("checked", false);
	                    $("#chkform").prop("checked", false);
	                    $("#chkApprBoard").prop("checked", false);
	                    $("#chkBoardLike").prop("checked", false);
						$("#chkBoardReplyReact").prop("checked", false);
	                    $("#chkBoardDisLike").prop("checked", false);
						$("#chkStarRating").prop("checked", false);
	                    
						/* 2020-05-27 홍승비 - URL 게시판인 경우, 댓글 disabled 처리 */
						$("#chkOneLineBottom").prop("disabled", true);
						$("#chkOneLineLayer").prop("disabled", true);
						$("#chkOneLineNone").prop("disabled", true);
						/* 2024-05-08 양지혜 - URL 게시판인 경우, 탭 게시판 disabled */
						$("#chktabBoard1").prop("disabled", true);
						$("#chktabBoard2").prop("disabled", true);
						$("#chktabBoard3").prop("disabled", true);
						/* 2024-08-13 전인하 - URL 및 홈페이지 게시판인 경우, 키워드 기능 disabled 처리 */
						$("#keyWord").prop("disabled", true);
						$("#chkWriterFlag").prop("disabled", true);
	                }
					/* 2023-11-03 민지수 - 카테고리 게시판 유형 추가 */
					else if ($("#chkCategoryBoard").is(":checked")) {
						document.getElementById("trAttribute").style.display = "none";
						$("#chkNoticeBoard").prop("disabled", true);
						$("#chkbackgroundimage").prop("disabled", true);
						$("#chkform").prop("disabled", true);
						$("#chkBoardLike").prop("disabled", true);
						$("#chkApprBoard").prop("disabled", true);
						$("#chkNotify").prop("disabled", true);
						$("#chkMailFG_Post").prop("disabled", true);
						$("#chkMailFG_Mod").prop("disabled", true);
						$("#chkMailFG_Comment").prop("disabled", true);
						$("#chkNotify").prop("disabled", true);
					}
					else if ($("#chkQnABoard").is(":checked")) {
						$("#chkWriterFlag").prop("disabled", true);
					}

	                if (!$("#chkURLBoard").is(":checked")) {
	                	document.getElementById("txtURL").style.display = "none";
	                }
	            }

				$(".boardTypeEventHandler").on("click", (e) => {
					checkboardtype(e.target.id);
				});
				
				if (boardType == '0' || boardType == '1' || boardType == '9') {
					$('#tr_versionManage').show();
				} else {
					$('#tr_versionManage').hide();
				}
				
				versionManageFlag = ${ model.versionManage eq 'Y' };
				$("#versionManageChkBox").prop("checked", versionManageFlag);

				// VOC #163284 관리자 탭 선택 오류 
				if (window.parent && window.parent !== window) {
					try {
						const parentUrl = window.parent.location.href;

						if (parentUrl.includes("admin/ezBoard/boardConfig.do")) {
							const parentDoc = window.parent.document;

							const container = parentDoc.querySelector(".portlet_tabnew01_top");

							if (container) {
								const spans = container.querySelectorAll('span[divname="BoardEnv_div1"], span[divname="BoardEnv_div2"], span[divname="BoardEnv_div3"], span[divname="BoardEnv_div4"], span[divname="BoardEnv_div5"]');

								spans.forEach(span => {
									span.removeAttribute("class");
								});

								const targetSpan = container.querySelector('span[divname="BoardEnv_div2"]');
								if (targetSpan) {
									targetSpan.classList.add("tabon");
									window.parent.Tab1_SelectID = "1tab2";
								}
							}
						}
					} catch (e) {
						console.log(e);
					}
				}
			});

			/* 2019-02-18 홍승비 - 일반설정 저장 시 각 필드 문자, 숫자 입력 제한 적용 */
			function Save() {
				if (hasBoardItemFlag == "Y" && $("#fileViewerBoardChkBox").is(":checked")) {
					alert("<spring:message code = 'ezBoard.fileViewerBoard.msg3' />");
					return;
				}
				
				var name1 = $.trim($("#txtBoardName").val());
				var name2 = $.trim($("#txtBoardName2").val());
				var name3 = $.trim($("#txtBoardName3").val());
				var name4 = $.trim($("#txtBoardName4").val());
				
				if (name1 == "") {
	                alert("<spring:message code='ezBoard.t144'/>");
	                return;
	            }
	            if (name2 == "") {
					name2 = name1;
	            }
	            if (name3 == "") {
					name3 = name1;
	            }
	            if (name4 == "") {
					name4 = name1;
	            }
	            
	            //승인게시판
	            if (APPRFLAG == "Y") {
	                if (ApprUserList == "") {
	                    alert("<spring:message code='ezBoard.t999018'/>");
	                    return;
	                }
	            } else {
	                ApprUserList = "";
	            }

	            var AttachMax = $("#txtAttachLimit").val();
	            var Description = $("#txtBoardDescription").val();
	            var Expires = "";
	            var gubun = "";
	            var replynotify = "";
	            var mailFG_Post = "";
	            var mailFG_Mod = "";
	            var mailFG_Comment = "";

	            if ($("#chkNotify").is(":checked")) {
	                replynotify = "1";
	            } else {
	                replynotify = "0";
	            }
	            if ($("#chkMailFG_Post").is(":checked")) {
	            	mailFG_Post = "Y";
	            } else {
	            	mailFG_Post = "N";
	            }
	            if ($("#chkMailFG_Mod").is(":checked")) {
	            	mailFG_Mod = "Y";
	            } else {
	            	mailFG_Mod = "N";
	            }
	            if ($("#chkMailFG_Comment").is(":checked")) {
	            	mailFG_Comment = "Y";
	            } else {
	            	mailFG_Comment = "N";
	            }

	           /*  if ($("#chkGroupBoard").is(":checked")) {
	                gubun = "1"
	            } else */ if ($("#chkAnonyBoard").is(":checked")) {
	                gubun = "2";
	            } else if ($("#chkPhotoBoard").is(":checked")) {
	                gubun = "3";
	            } else if ($("#chkThumbBoard").is(":checked")) {
	                gubun = "4";
	            } else if ($("#chkGeneralBoard").is(":checked")) {
	                gubun = "0";
	            } else if ($("#chkQnABoard").is(":checked")) {
	                gubun = "5";
	            } else if ($("#chkURLBoard").is(":checked")) {
	                gubun = "0";
	            } else if ($("#chkMovieBoard").is(":checked")) {
	            	gubun = "7";
	            } else if ($("#chkHomePageBoard").is(":checked")) {
	            	gubun = "8";
				} else if ($("#fileViewerBoardChkBox").is(":checked")) {
					gubun = "9";
	            } else if ($("#chkCategoryBoard").is(":checked")) {
	            	if (boardItemCnt > 0) {
	            		alert("<spring:message code='ezBoard.MJSCAT03'/>");
	            		return;
	            	}
	            	else {
	            		gubun = "10";	
	            	}
				}
	            
	            if ($("#chkbackgroundimage").is(":checked")) {
	                background = "Y";
	            } else {
	                background = "N";
	            }
	            
	            if ($("#chkform").is(":checked")) {
	                FormFlag = "Y";
	            } else {
	                FormFlag = "N";
				}
	            
	            if ($("#chkBoardLike").is(":checked")) {
	            	useBoardLike = "Y";
	            } else {
	            	useBoardLike = "N";
				}

				if ($("#chkBoardReplyReact").is(":checked")) {
	            	useBoardReplyReact = "Y";
	            } else {
					useBoardReplyReact = "N";
				}
				
	            if ($("#chkBoardDisLike").is(":checked")) {
	            	useBoardDisLike = "Y";
	            } else {
	            	useBoardDisLike = "N";
				}
	            
			    if ($("#keyWord").is(":checked")) {
                    useKeyword = "Y";
                } else {
                    useKeyword = "N";
                }
	            
				if ($("#chkStarRating").is(":checked")) {
                    starRatingFlag = "Y";
                } else {
                    starRatingFlag = "N";
                }
	            
	            // 게시만료일 /* 2019-03-04 홍승비 - 게시판그룹인 경우 게시만료일 체크 분기 타지 않도록 수정 */
	            if ($("#chkPermanent").is(":checked") || parentBoardID == "top") {
	                Expires = "-1";
	            } else {
	            	if (!$("#txtExpires").val().match(/^\d+$/)) {
					    alert("<spring:message code='ezBoard.t156'/>: <spring:message code='ezEmail.t99000066'/>");
					    return;
					} else {
	                	Expires = $("#txtExpires").val();
	                }
	            }

	            // 만료게시물 정책
	            var iDeleteAfter = "-1";
	            if ($("#usedeleteafter").is(":checked")) {
		            if ($("#deleteafter").val() == "") {
		                alert("<spring:message code='ezBoard.t146'/>");
		                $("#deleteafter").focus();
		                return;
		            } else if (!$("#deleteafter").val().match(/^\d+$/)) {
						alert("<spring:message code='ezBoard.t159'/>: <spring:message code='ezEmail.t99000066'/>");
					    return;
		            }
	            }
	            
	            var url = $("#txtURL").val().trim();
	             if ($("#chkURLBoard").is(":checked") && url == "") {
	                alert("<spring:message code='ezPortal.t123'/>");
	                $("#txtURL").focus();
	                return;
	            } else if (!$("#chkURLBoard").is(":checked")) {
	            	url = "";            
	            }
	             
	             if ($("#chkURLBoard").is(":checked") && url != "" && url.toLowerCase().indexOf("http") == -1) {
	            	url = "http://" + url;
	            }
	             
	            if (orgAPPRFLAG != APPRFLAG) {
	                if (orgAPPRFLAG == "N") {
	                    if (!confirm("<spring:message code='ezBoard.t999013'/>")) {
	                        return;
	                    }
	                } else {
	                    if (!confirm("<spring:message code='ezBoard.t999012'/>")) {
	                        return;
	                    }
	                }
	            }

	            if ($("#usedeleteafter").is(":checked")) {
	                iDeleteAfter = $("#deleteafter").val();
	            }
	            
	            // 첨부크기제한
	            if (AttachMax == "") {
	            	AttachMax = "5";
	            } else if (!AttachMax.match(/^\d+$/)) {
					alert("<spring:message code='ezBoard.t167'/>: <spring:message code='ezEmail.t99000066'/>");
					return;
	            }
	            
	            if (Expires == "") {
	            	Expires = "30";
	            }
	            
	            var oneLineReply = "";            
	            if ($("#chkOneLineBottom").is(":checked") == true) {
	            	oneLineReply = 2;
	            } else if ($("#chkOneLineLayer").is(":checked") == true) {
	            	oneLineReply = 1;
	            } else {
	            	oneLineReply = 0;
	            }
	            
	            /* 2019-04-26 홍승비 - 쓰임이 없는 포틀릿 옵션의 사용 여부를 "N"으로 고정 */
	            /* 2019-10-11 홍승비 - 공지사항 게시판 설정에 변경이 있는지 확인 */
	            var pNoticeBoardMod = "";
	            if (noticeBoardID != BoardID && $("#chkNoticeBoard").is(":checked") == true) {
	            	pNoticeBoardMod = "UPDATE"; // 기존의 공지사항 게시판 레코드를 전부 삭제하고 새로운 레코드를 삽입한다.
	            }
	            else if (noticeBoardID == BoardID && $("#chkNoticeBoard").is(":checked") == false) {
	            	pNoticeBoardMod = "DELETE"; // 기존의 공지사항 게시판 레코드를 전부 삭제한다.
	            }
	            
	            // 2020-12-04 박기범 - 탭게시판 갱신내용 적용
	            var ptabBoardMod1 = "";
	            var ptabBoardMod2 = "";
	            var ptabBoardMod3 = "";

				if (tabBoardID1 != BoardID && $("#chktabBoard1").is(":checked") == true) {
					ptabBoardMod1 = "UPDATE"; 
	            }
	            else if (tabBoardID1 == BoardID && $("#chktabBoard1").is(":checked") == false) {
	            	ptabBoardMod1 = "DELETE"; 
	            }

				if (tabBoardID2 != BoardID && $("#chktabBoard2").is(":checked") == true) {
					ptabBoardMod2 = "UPDATE"; 
	            }
	            else if (tabBoardID2 == BoardID && $("#chktabBoard2").is(":checked") == false) {
	            	ptabBoardMod2 = "DELETE"; 
	            }

				if (tabBoardID3 != BoardID && $("#chktabBoard3").is(":checked") == true) {
					ptabBoardMod3 = "UPDATE"; 
	            }
	            else if (tabBoardID3 == BoardID && $("#chktabBoard3").is(":checked") == false) {
	            	ptabBoardMod3 = "DELETE"; 
	            }

				if ($("#chkWriterFlag").is(":checked")) {
					writerFlag = 'Y';
				} else {
					writerFlag = 'N';
				}
				
				// 탭게시판 선택 여부 확인
				var tabBoardCheck1 = "";
				var tabBoardCheck2 = "";
				var tabBoardCheck3 = "";
				
				if ($("#chktabBoard1").is(":checked") == true) {
					tabBoardCheck1 = "true";
				}
				if ($("#chktabBoard2").is(":checked") == true) {
					tabBoardCheck2 = "true";
				}
				if ($("#chktabBoard3").is(":checked") == true) {
					tabBoardCheck3 = "true";
				}
				
				if ($("#chkAttachment").is(":checked")) {
					attachmentFlag = "Y";
				} else {
					attachmentFlag = "N";
				}
				
                var publicFlag = $("#publicFlag").is(":checked") ? "Y" : "N" ;
                

				/* 최근게시물 여부 기능 추가 */
				if ($("#chkAllNewBoard").is(":checked")) {
					useAllNewBoard = "Y";
				} else {
					useAllNewBoard = "N";
				}
				
				let vmf = $("#versionManageChkBox").prop("checked") ? "Y" : "N";	// 버전관리 사용 여부
				if(!versionManageFlag && vmf === "Y") { /* 2025-06-12 양지혜 - 버전관리 미사용 > 사용 시, 기존 게시글 히스토리 데이터 생성 */
					if (!createModifyHistory()) { return; }
				}

	            /* 2018-10-18 홍승비 - 게시판'그룹' 이름변경 시 하위게시판처럼 데이터가 업데이트되는 부분 수정 */
	            $.ajax({
	            	type : "POST",
	            	dataType : "text",
	            	url : "/admin/ezBoard/saveBoardProperty.do",
	            	async : false,
	            	data : {
	            		boardName:name1, boardName2:name2,
	            		boardName3:name3, boardName4:name4,
	            		boardID:BoardID, attachSizeLimit:AttachMax, boardDescription:Description,
	            		itemExpires:Expires, url:url, guBun:gubun, replyNotify:replynotify, deleteAfter:iDeleteAfter,
	            		boardColor:brd_color, portlet:"N", backGround:background,
	            		formFlag:FormFlag, oneLineReply:oneLineReply, apprFlag:APPRFLAG, orgApprFlag:orgAPPRFLAG,
	            		apprUserList:ApprUserList, apprMailFlag:APPRMAILFLAG, parentBoardID : parentBoardID,
	            		likeFlag:useBoardLike,disLikeFlag:useBoardDisLike,noticeBoardMod:pNoticeBoardMod,noticeBoardMod:pNoticeBoardMod,
						tabBoardMod1:ptabBoardMod1,tabBoardMod2:ptabBoardMod2,tabBoardMod3:ptabBoardMod3,
						mailFG_Post : mailFG_Post, mailFG_Mod : mailFG_Mod, mailFG_Comment : mailFG_Comment,
						reactFlag:useBoardReplyReact, useKeyword:useKeyword, publicFlag:publicFlag,
						tabBoardCheck1:tabBoardCheck1, tabBoardCheck2:tabBoardCheck2, tabBoardCheck3:tabBoardCheck3, 
						attachmentFlag:attachmentFlag, allNewBoardFlag:useAllNewBoard, writerFlag : writerFlag,
						starRatingFlag:starRatingFlag, versionManage : vmf
	            	},
	            	success : function(result) {
	            	    if (result == "success") {
                            alert("<spring:message code='ezBoard.t79'/>");
                            if ("<c:out value='${adminType}'/>" == "y") {
                                if (!!parent.parent.board_menu && !!parent.parent.board_menu.refreshLeft) {
	            				//parent.parent.board_menu.refreshLeft();window.parent.frames.location.href = "/admin/ezBoard/boardConfig.do?boardID=" + encodeURIComponent(BoardID);
                                }
                            } else {
                                if (!!parent.board_menu && !!parent.board_menu.refreshLeft) {
                                    parent.board_menu.refreshLeft();
                                }
                            }
                        } else if (result == "nonEmptyBoard") {
                            alert(strLangJIHgubunChange01);
                        }
	            	}
	            });
	        }
			
			/* 2019-02-20 홍승비 - 게시만료일 체크여부에 따라 입력필드 표시 수정 */
			function chkPermanent_onclick() {
	            if (chkPermanent.checked) {
	                chkExpires.checked = false;
	                txtExpires.value = "";
	                txtExpires.readOnly = true;
	            } else {
	                chkExpires.checked = true;
	                txtExpires.value = "365";
	                txtExpires.readOnly = false;
	            }
	        }
			function chkExpires_onclick() {
	            if (chkExpires.checked) {
	                chkPermanent.checked = false;
	                txtExpires.value = "365";
	                txtExpires.readOnly = false;
	            } else {
	                chkPermanent.checked = true;
	                txtExpires.value = "";
	                txtExpires.readOnly = true;
	            }
	        }
			
			/* 2019-02-20 홍승비 - 만료게시물 정책 체크여부에 따라 입력필드 표시 수정 */
			function chkDeleteAfter_onclick() {
	            if (document.getElementById("usedeleteafter").checked) {
	                document.getElementById("deleteafter").readOnly = false;
	            } else {
	            	document.getElementById("deleteafter").value = "";
	            	document.getElementById("deleteafter").readOnly = true;
	            }
	        }
			
			function checkboardtype(clickedTargetID) {
				let nodeBuf;
				let chkboxArr = document.getElementById("boardTypeList").querySelectorAll("input");
				let cnt = 0;

				if (typeof clickedTargetID != "undefined") {
					while ((nodeBuf = chkboxArr[cnt]) != null) {
						if (nodeBuf.id === clickedTargetID) {
							nodeBuf.checked = true;
						} else {
							nodeBuf.checked = false;
						}
	
						cnt++;
					}
				}
	            
	            // URL게시판 또는 홈페이지게시판 또는 카테고리 게시판이 체크된 경우, 옵션과 댓글의 사용여부를 전부 disabled 처리한다. (댓글은 '사용안함' 고정)
	             if (chkURLBoard.checked == true || chkHomePageBoard.checked == true || chkCategoryBoard.checked == true) {
	            	 if (chkURLBoard.checked == true) {
                    	document.getElementById("txtURL").style.display = "";
	            	 } else {
	            		 document.getElementById("txtURL").style.display = "none";
	            	 }
	            	 
                	if ($("#chkCategoryBoard").is(":checked")) {
                		$("#chkNoticeBoard").prop("disabled", true);
                	}

                    document.getElementById("expireTr").style.display = "none";
                    document.getElementById("deleteAfterTr").style.display = "none";
                    document.getElementById("attachLimitTr").style.display = "none";
                    document.getElementById("trAttachment").style.display = "none";
                    document.getElementById("trAttribute").style.display = "none";
                    
					$("#chkNotify").prop("disabled", true);
					$("#chkMailFG_Post").prop("disabled", true);
					$("#chkMailFG_Mod").prop("disabled", true);
					$("#chkMailFG_Comment").prop("disabled", true);
					$("#chkbackgroundimage").prop("disabled", true);
					$("#chkform").prop("disabled", true);
					$("#chkApprBoard").prop("disabled", true);
					$("#chkBoardLike").prop("disabled", true);
					$("#chkBoardReplyReact").prop("disabled", true);
					$("#chkBoardDisLike").prop("disabled", true);
					$("#chkStarRating").prop("disabled", true);
					/* 2020-05-27 홍승비 - URL 게시판인 경우, 댓글 사용안함 고정 + disabled 처리 */
					$("#chkOneLineBottom").prop("disabled", true);
					$("#chkOneLineLayer").prop("disabled", true);
					$("#chkOneLineNone").prop("disabled", true);
					/* 2024-05-08 양지혜 - URL 게시판인 경우, 탭 게시판 disabled */
					$("#chktabBoard1").prop("disabled", true);
					$("#chktabBoard2").prop("disabled", true);
					$("#chktabBoard3").prop("disabled", true);
					/* 2024-08-13 전인하 - URL 및 홈페이지 게시판인 경우, 키워드 기능 disabled 처리 */
                    $("#keyWord").prop("disabled", true);
					$("#chkWriterFlag").prop("disabled", true);

                    document.getElementById("chkApprBoard").checked = false;
                    checkApprBoard();                   
                    document.getElementById("chkExpires").checked = false;
                    document.getElementById("chkPermanent").checked = true;
                    document.getElementById("usedeleteafter").checked = false;
                    document.getElementById("chkbackgroundimage").checked = false;
                    document.getElementById("chkform").checked = false;
                    document.getElementById("chkNotify").checked = false;
                    document.getElementById("chkMailFG_Post").checked = false;
                    document.getElementById("chkMailFG_Mod").checked = false;
                    document.getElementById("chkMailFG_Comment").checked = false;
                    document.getElementById("chkBoardLike").checked = false;
                    document.getElementById("chkBoardReplyReact").checked = false;
                    document.getElementById("chkBoardDisLike").checked = false;
                    document.getElementById("chkStarRating").checked = false;
                   // document.getElementById("chkOneLine").checked = false;
                    document.getElementById("chkOneLineBottom").checked = false;
                    document.getElementById("chkOneLineLayer").checked = false;
                    document.getElementById("keyWord").checked = false;
                    document.getElementById("chkOneLineNone").checked = true; // 댓글옵션  '사용안함' 체크
				 	document.getElementById("chkWriterFlag").checked = false;
	            }
				 else if (chkCategoryBoard.checked == true) {
					 document.getElementById("trAttribute").style.display = "none";
					 $("#chkNoticeBoard").prop("disabled", true);
					 $("#chkbackgroundimage").prop("disabled", true);
					 $("#chkform").prop("disabled", true);
					 $("#chkBoardLike").prop("disabled", true);
					 $("#chkApprBoard").prop("disabled", true);
					 $("#chkNotify").prop("disabled", true);
					 $("#chkMailFG_Post").prop("disabled", true);
					 $("#chkMailFG_Mod").prop("disabled", true);
					 $("#chkMailFG_Comment").prop("disabled", true);
					 $("#chkNotify").prop("disabled", true);
					 /*chkMailFG_Post chkMailFG_Mod chkMailFG_Comment chkNotify*/
					 $("#chkbackgroundimage").prop("checked", false);
					 $("#chkform").prop("checked", false);
				 }
	             else { // URL 게시판이 아닌 경우
					document.getElementById("txtURL").style.display = "none";
                    document.getElementById("expireTr").style.display = "";
                    document.getElementById("deleteAfterTr").style.display = "";
                    document.getElementById("attachLimitTr").style.display = "";
                    document.getElementById("trAttachment").style.display = "";
                    document.getElementById("trAttribute").style.display = "";
                    
	            	if (chkCategoryBoard.checked == true) {
		                $("#chkNoticeBoard").prop("disabled", true);
	                }
                    
                    $("#chkNotify").prop("disabled", false);
                    $("#chkMailFG_Post").prop("disabled", false);
                    $("#chkMailFG_Mod").prop("disabled", false);
                    $("#chkMailFG_Comment").prop("disabled", false);
					$("#chkbackgroundimage").prop("disabled", false);
					$("#chkform").prop("disabled", false);
					
					/* 2019-04-29 홍승비 - 승인여부를 사용하지 않는 익명, QNA게시판 동작 조정 */
					/* 2025-01-20 임정은 - 게시자명 선택 기능을 사용하지 않는 익명, QNA게시판 동작 조정 */
	            	 if (chkQnABoard.checked == true || chkAnonyBoard.checked == true) {
						$("#chkApprBoard").prop("checked", false);
						checkApprBoard();
						$("#chkApprBoard").prop("disabled", true);
						
						$("#chkWriterFlag").prop("checked", false);
						$("#chkWriterFlag").prop("disabled", true);
	                } else {
	                    $("#chkApprBoard").prop("disabled", false);

						 $("#chkWriterFlag").prop("disabled", false);
						if (writerFlag == 'Y') {
							$("#chkWriterFlag").prop("checked", true);
						}
					}
					
					// 2024-10-04 전인하 - 관리자 > 게시판 > 일반설정 > 익명게시판일 경우 댓글/게시글 좋아요 싫어요 기능 비활성화
                    if (chkAnonyBoard.checked) {
                        $("#chkBoardLike").prop("checked", false);
                        $("#chkBoardDisLike").prop("checked", false);
                        $("#chkBoardReplyReact").prop("checked", false);
                        $("#chkBoardLike").prop("disabled", true);
                        $("#chkBoardDisLike").prop("disabled", true);
                        $("#chkBoardReplyReact").prop("disabled", true);
                    } else {
                        $("#chkBoardLike").prop("disabled", false);
                        $("#chkBoardDisLike").prop("disabled", false);
                        $("#chkStarRating").prop("disabled", false);
                        if ($("#chkOneLineNone").is(":checked")) {
                            $("#chkBoardReplyReact").prop("checked", false);
                            $("#chkBoardReplyReact").prop("disabled", true);
                        } else {
                            $("#chkBoardReplyReact").prop("disabled", false);
                        }
					}
					
					$("#chkStarRating").prop("disabled", false);
					/* 2020-05-27 홍승비 - URL 게시판이 아닌 경우, 댓글 disabled 해제 */
					$("#chkOneLineBottom").prop("disabled", false);
					$("#chkOneLineLayer").prop("disabled", false);
					$("#chkOneLineNone").prop("disabled", false);
					/* 2024-05-08 양지혜 - URL 게시판인 경우, 탭 게시판 disabled 해제 */
					$("#chktabBoard1").prop("disabled", false);
					$("#chktabBoard2").prop("disabled", false);
					$("#chktabBoard3").prop("disabled", false);
					/* 2024-08-13 전인하 - URL 및 홈페이지 게시판인 경우, 키워드 기능 disabled 해제 */
                    $("#keyWord").prop("disabled", false);
                    $("#chkNoticeBoard").prop("disabled", false);
	            }

	            /* 2019-04-29 홍승비 - 포토, 썸네일, 익명, 동영상게시판 선택 시 답변메일발송 disabled 처리 */
	             if (chkPhotoBoard.checked == true || chkThumbBoard.checked == true || chkAnonyBoard.checked == true || chkMovieBoard.checked == true) {
	                $("#chkNotify").prop("disabled", true);
	                document.getElementById("chkNotify").checked = false;
	                
	                // 게시알림, 수정알림, 댓글알림 메일은 익명게시판/URL게시판일때만 설정 불가능
	                if (chkAnonyBoard.checked == true) {
	                	$("#chkMailFG_Post").prop("disabled", true);
	                	$("#chkMailFG_Mod").prop("disabled", true);
	                	$("#chkMailFG_Comment").prop("disabled", true);
		                document.getElementById("chkMailFG_Post").checked = false;
		                document.getElementById("chkMailFG_Mod").checked = false;
		                document.getElementById("chkMailFG_Comment").checked = false;
	                }
	            } else if (chkCategoryBoard.checked == false) { // 카테고리 게시판은 공지사항 게시판으로 사용 불가
	                if (chkURLBoard.checked == false && chkHomePageBoard.checked == false) {
	                    $("#chkNotify").prop("disabled", false);
	                    $("#chkMailFG_Post").prop("disabled", false);
	                    $("#chkMailFG_Mod").prop("disabled", false);
	                    $("#chkMailFG_Comment").prop("disabled", false);
	                }
	                $("#chkNoticeBoard").prop("disabled", false);
	            }
	            
	            if (chkPhotoBoard.checked == true || chkThumbBoard.checked == true || chkMovieBoard.checked == true) {
	                document.getElementById("trAttribute").style.display = "none";
	                document.getElementById("trAttachment").style.display = "none";
	            } else if (chkURLBoard.checked == false && chkHomePageBoard.checked == false && chkCategoryBoard.checked == false) {
	                document.getElementById("trAttribute").style.display = "";
					document.getElementById("trAttachment").style.display = "";
	            }
	            
	            if (chkPhotoBoard.checked == true || chkThumbBoard.checked == true || chkMovieBoard.checked == true || chkCategoryBoard.checked == true) {
	            	$("#chkbackgroundimage").prop("disabled", true);
					$("#chkform").prop("disabled", true);
	                document.getElementById("chkbackgroundimage").checked = false;
	                document.getElementById("chkform").checked = false;
	            } else if (chkURLBoard.checked == false && chkHomePageBoard.checked == false && chkCategoryBoard.checked == false) {
	            	$("#chkbackgroundimage").prop("disabled", false);
	            	$("#chkform").prop("disabled", false);
	            }
	            
				/* 2025-01-31 임정은 - 일반, 포토, 썸네일, 동영상게시판인 경우에만 게시자명 선택 기능 사용 */
				if (chkGeneralBoard.checked || chkPhotoBoard.checked || chkThumbBoard.checked || chkMovieBoard.checked) {
					$("#chkWriterFlag").prop("disabled", false);
					if (writerFlag == 'Y') {
						$("#chkWriterFlag").prop("checked", true);
					}
				} else {
					$("#chkWriterFlag").prop("disabled", true);
					$("#chkWriterFlag").prop("checked", false);
				}
	            
	            // 2024-10-04 전인하 - 모든 게시판구분 설정을 제거한다면 일반게시판을 체크하도록 함
	            if (chkGeneralBoard.checked == false && chkAnonyBoard.checked == false && chkPhotoBoard.checked == false && chkThumbBoard.checked == false && 
	            chkMovieBoard.checked == false && chkQnABoard.checked == false && chkURLBoard.checked == false && chkHomePageBoard.checked == false && chkCategoryBoard.checked == false && fileViewerBoardChkBox.checked == false) {
	                chkGeneralBoard.checked = true;
	                checkboardtype();
	            }

                // 게시글 버전관리
                if ($("#chkGeneralBoard").prop("checked") || $("#fileViewerBoardChkBox").prop("checked")) {
                    $("#tr_versionManage").show();
                } else {
                    $("#versionManageChkBox").prop("checked", false);
                    $("#tr_versionManage").hide();
                }
			}
			
			function checkApprBoard() {
			    if (chkApprBoard.checked == true) {
			        document.getElementById("chkApprList").style.display = "";
			        document.getElementById("chkApprListMail").style.display = "";
			        APPRFLAG = "Y";
			    } else {
			        document.getElementById("chkApprList").style.display = "none";
			        document.getElementById("chkApprListMail").style.display = "none";
			        APPRFLAG = "N";
			    }
			}			
			function checkApprMail() {
			    if (chkApprBoardMail.checked == true) {
			        APPRMAILFLAG = "Y";
			    } else {
			        APPRMAILFLAG = "N";
			    }
			}			
			function SelectTarget() {
			    var receiverData = new Array();
			    receiverData["window"] = this;
			    receiverData["selectTargetListXML"] = selectTargetListXML;
			    
			    selecttarget_cross_dialogArguments[0] = receiverData;
			    selecttarget_cross_dialogArguments[1] = SelectTarget_Complete;
			    var SelectTarget_Cross = window.open("/admin/ezBoard/selectTarget2.do?isAllGroupBoard=" + isAllGroupBoard, "SelectTarget_Cross2", GetOpenWindowfeature(1144, 590));
			    try { SelectTarget_Cross.focus(); } catch (e) {}
			}
			
			/* 2018-07-26 홍승비 - 다국어 설정에 대응하여 승인자 정보 표출 */
			function SelectTarget_Complete(ret) {
			    if (typeof (ret) != "undefined") {
			        selectTargetListXML = ret;
			        document.getElementById("AccessList").innerHTML = "";

			        var listview = new ListView();
			        listview.SetID("AccessListView");
			        listview.SetSelectFlag(false);
			        listview.SetMulSelectable(true);
			        listview.DataSource(document.getElementById("listviewheader"));
			        listview.DataBind("AccessList");
			        var xmldom = loadXMLString(selectTargetListXML);
			        
			         if (primary == "1") {
			        	 var xmldomNode = SelectNodes(xmldom, "DATA/NAME");
			         } else {
			        	 var xmldomNode = SelectNodes(xmldom, "DATA/NAME2");
			         }
			         
			        for (i = 0; i < xmldomNode.length; i++) {
			            var listTR = listview.AddRow(listview.GetRowCount());
			            var listTD = document.createElement("TD");
			            listTD.style.paddingBottom = "0px";
			            listTD.style.paddingTop = "0px";
			            var listTDText = document.createTextNode(getNodeText(xmldomNode[i]));
			            listTD.appendChild(listTDText);
			            listTR.appendChild(listTD);
			        }

			        var xmldomNode2 = SelectNodes(xmldom, "DATA/CN");
			        ApprUserList = "";
			        for (var i = 0; i < xmldomNode2.length; i++) {
			            ApprUserList += getNodeText(xmldomNode2[i]);
			            if (i != xmldomNode2.length - 1) {
			                ApprUserList += ";";
			            }
			        }
			    }
			}
			function getApprUserList() {
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezBoard/get_apprUserList.do",
					async : true,
					data : {pBoardID : BoardID},
					success : function(result){
						makeApprUserList(loadXMLString(result));
					}
				});
			}			
			function makeApprUserList(getApprXml){
			    document.getElementById("AccessList").innerHTML = "";

			    var listview = new ListView();
			    listview.SetID("AccessListView");
			    listview.SetSelectFlag(false);
			    listview.SetMulSelectable(true);
			    listview.DataSource(document.getElementById("listviewheader"));
			    listview.DataBind("AccessList");

			    var xmldom = getApprXml;
			    var xmldomNode = SelectNodes(xmldom, "NODES/NODE");
			    for (i = 0; i < xmldomNode.length; i++) {
			        var listTR = listview.AddRow(listview.GetRowCount());
			        var listTD = document.createElement("TD");
			        listTD.style.paddingBottom = "0px";
			        listTD.style.paddingTop = "0px";
			         
					if (primary == "1") {
						var UserName = SelectSingleNodeValue(xmldomNode[i], "DISPLAYNAME");
				        var DeptName = SelectSingleNodeValue(xmldomNode[i], "DESCRIPTION");
			         } else {
						var UserName = SelectSingleNodeValue(xmldomNode[i], "DISPLAYNAME2");
						var DeptName = SelectSingleNodeValue(xmldomNode[i], "DESCRIPTION2");
			         }
			         
			        var listTDText = document.createTextNode(UserName + "(" + DeptName + ")");
			        listTD.appendChild(listTDText);
			        listTR.appendChild(listTD);
			    }
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "DATA");
			    var strxml = "<DATA>";
			    var xmldomNode2 = SelectNodes(xmldom, "NODES/NODE");
			    ApprUserList = "";
			    for (var i = 0; i < xmldomNode2.length; i++) {
			        ApprUserList += SelectSingleNodeValue(xmldomNode[i], "APPRUSERID");
			        if (i != xmldomNode2.length - 1) {
			            ApprUserList += ";";
			        }
			        strxml += "<CN><![CDATA[" + SelectSingleNodeValue(xmldomNode[i], "APPRUSERID") + "]]></CN>";
			        strxml += "<NAME><![CDATA[" + SelectSingleNodeValue(xmldomNode[i], "DISPLAYNAME") + "(" + SelectSingleNodeValue(xmldomNode[i], "DESCRIPTION") + ")" + "]]></NAME>";
			        strxml += "<NAME2><![CDATA[" + SelectSingleNodeValue(xmldomNode[i], "DISPLAYNAME2") + "(" + SelectSingleNodeValue(xmldomNode[i], "DESCRIPTION2") + ")" + "]]></NAME2>";
			        strxml += "<DEPT><![CDATA[PERSON]]></DEPT>";
			        strxml += "<GROUP><![CDATA[N]]></GROUP>";
			    }
			    strxml += "</DATA>";
			    selectTargetListXML = strxml;
			}			
			function change_brdColor() {
			    if (CrossYN()) {
			        manycolor_dialogArguments[1] = change_brdColor_Complete;
			        var manyColor = window.open("/ezCommon/manyColor.do", "manyColor", GetOpenWindowfeature(286, 290));
			        try { manyColor.focus(); } catch (e) {}
			    }
			    else {
			        var color = showModalDialog("/ezCommon/manyColor.do", null, "dialogHeight:290px; dialogWidth:286px; status:no;scroll:no; help:no; edge:sunken");
			        if (typeof (color) != "undefined") {
			            document.getElementById("selColor").style.backgroundColor = color;
			            document.getElementById("colorID").innerText = color;
			            brd_color = color;
			        }
			    }
			}       
			function change_brdColor_Complete(color) {
			    if (typeof (color) != "undefined") {
			        document.getElementById("selColor").style.backgroundColor = color;
			        document.getElementById("colorID").innerText = color;
			        brd_color = color;
			    }
			}
		    function ExtensionAttribute_onClick() {
		     /*    if (chkGroupBoard.checked) {
		            gubun = "1"
		        } else */ if (chkAnonyBoard.checked) {
		            gubun = "2";
		        } else if (chkPhotoBoard.checked) {
		            gubun = "3";
		        } else if (chkThumbBoard.checked) {
		            gubun = "4";
		        } else if (chkGeneralBoard.checked) {
		            gubun = "0";
		        } else if (chkQnABoard.checked) {
		            gubun = "5";
		        } else if (chkMovieBoard.checked) {
		        	gubun = "7";
		        } else if (chkCategoryBoard.checked) {
		        	gubun = "10";
		        }

		        var para = new Array();
		        para[0] = BoardID;
		        para[1] = gubun;
		        var url = "/admin/ezBoard/boardExtensionAttribute.do";

		        /* 2018-07-25 홍승비 - 확장칼럼 설정 팝업창 width 조절(일본어 대응) */
		        if (CrossYN()) {
		            BoardExtension_dialogArguments[0] = para;
		            var ExtensionAttribute = window.open(url, "ExtensionAttribute", GetOpenWindowfeature(1120, 750));
		            try { ExtensionAttribute.focus(); } catch (e) { }
		        } else {
		            var retVal = window.showModalDialog(url, para, "dialogWidth:780px;dialogHeight:750px;status:no;help:no;scroll:yes;edge:sunken");
		        }
		    }
		    
		    //파일첨부크기 넘버값만 입력받기
		    function onlyNumber(event) {
		    	event = event || window.event;
				var keyID = (event.which) ? event.which : event.keyCode;
				
				if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
					return;
				else
					return false;
		    }
		    
		    function removeChar(event) {
				event = event || window.event;
				var keyID = (event.which) ? event.which : event.keyCode;
				
				if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
					return;
				else
					event.target.value = event.target.value.replace(/[^0-9]/g, "");
				
				var v_AttachSize = $("#txtAttachLimit").val();
		    	
		    	if (v_AttachSize > 2048) {
		    		alert("<spring:message code='ezBoard.hyj10'/>");
		    		$("#txtAttachLimit").val(2048);
		    	}
			}

			/* 2023-07-25 임정은 - 댓글 사용하지 않는 경우 '댓글 좋아요' 기능(chkBoardReplyReact) 비활성화 */
		    /* 2019-11-05 홍승비 - 댓글 사용여부 체크 시 처리 추가 */
		    function checkReplyType(chkObj) {
		    	var chkBottom = document.getElementById("chkOneLineBottom");
		    	var chkLayer = document.getElementById("chkOneLineLayer");
		    	var chkNone = document.getElementById("chkOneLineNone");

		    	if (chkObj.id == "chkOneLineBottom" && chkObj.checked) {
		    		chkLayer.checked = false;
		    		chkNone.checked = false;
					$("#chkBoardReplyReact").prop("disabled", false);
					if (useBoardReplyReact == "Y") {
						$("#chkBoardReplyReact").prop("checked", true);
					}
		    	} else if (chkObj.id == "chkOneLineLayer" && chkObj.checked) {
		    		chkBottom.checked = false;
		    		chkNone.checked = false;
					$("#chkBoardReplyReact").prop("disabled", false);
					if (useBoardReplyReact == "Y") {
						$("#chkBoardReplyReact").prop("checked", true);
					}
		    	} else { // 기존에 체크된 체크박스를 다시 클릭하는 경우, '사용안함'으로 체크 이동
		    		chkBottom.checked = false;
		    		chkLayer.checked = false;
		    		chkNone.checked = true;
					document.getElementById("chkBoardReplyReact").checked = false;
					$("#chkBoardReplyReact").prop("disabled", true);
		    	}
		    }

			function setMenuBtnDisplay() {
				if (parent != null) {
					let configFormBtn = parent.document.getElementById("1tab5");

					configFormBtn.style.display = document.getElementById("chkform").checked ? "" : "none";
				}
			}

			function checkGubun() {
				let id;

				switch (boardType) {
					case "0" :
					case "1" : {
						id = "chkGeneralBoard";

						break;
					}

					case "2" : {
						id = "chkAnonyBoard";

						break;
					}

					case "3" : {
						id = "chkPhotoBoard";

						break;
					}

					case "4" : {
						id = "chkThumbBoard";

						break;
					}

					case "5" : {
						id = "chkQnABoard";

						break;
					}

					case "6" : {
						id = "chkURLBoard";

						break;
					}

					case "7" : {
						id = "chkMovieBoard";

						break;
					}

					case "8" : {
						id = "chkHomePageBoard";

						break;
					}

					case "9" : {
						id = "fileViewerBoardChkBox";

						break;
					}

					case "10" : {
						id = "chkCategoryBoard";

						break;
					}

					default : {}
				}

				$("#" + id).prop("checked", true);
			}

			/* 2025-06-12 양지혜 - 게시글 버전관리 미사용 > 사용 시 히스토리 데이터 생성 후 진행 */
			function createModifyHistory() {
				var pass = false;

				if (window.parent.itemCnt > 0) {
					if (confirm(strLangVersion01)) {
						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/admin/ezBoard/createModifyHistory.do",
							data : { boardID : BoardID },
							success: function(result){
								if (result == "PASS") {
									pass = true;
								} else {
									alert(strLangVersion02);
								}
							}
						});
					}
				} else {
					pass = true;
				}
				return pass;
			}
	    </script>
	    <style type="text/css">
	    	.mainlist tr {
	    		height : 0px;
	    	} 
	    </style>
	</head>	
	<c:if test="${adminType != 'y'}">
		<body class="mainbody"><h1><spring:message code="ezBoard.t60"/></h1>
	</c:if>
	<c:if test="${adminType == 'y'}">
		<body class="tabbody" style="margin-top:10px; margin-bottom: 15px; overflow-y:auto;">
	</c:if>		
		<xml id="listviewheader" style ="display:none"></xml>
		<div style="max-width: 800px;">
		<table class="content">
	        <tr>
	            <th style="min-width: 88px;"><spring:message code="ezBoard.t114"/></th>
	            <td style="padding: 0;">
	            	<c:if test="${use_multiData == 'YES'}">
		                <table style="width: 100%">
		                    <tr class="primary">
		                        <th><c:out value='${lang_primary}' /></th>
		                        <td style="border-bottom:1px solid #ddd;"><c:out value='${model.boardName}' /></td>
		                    </tr>
		                    <tr class="primary">
		                        <th><c:out value='${lang_secondary}' /></th>
		                        <td style="border-bottom:1px solid #ddd;"><c:out value='${model.boardName2}' /></td>
		                    </tr>
		                    <c:if test="${useJapanese == 'YES'&& lang_primary ne lang_tertiary}">
			                    <tr class="primary">
			                        <th><c:out value='${lang_tertiary}' /></th>
			                        <td style="border-bottom:1px solid #ddd;"><c:out value='${model.boardName3}' /></td>
		                    	</tr>
		                    </c:if>
		                    <c:if test="${useChinese == 'YES'}">
			                    <tr class="secondary">
			                        <th><c:out value='${lang_quaternary}' /></th>
			                        <td style="border-bottom:none;"><c:out value='${model.boardName4}' /></td>
			                    </tr>
		                    </c:if>
		                </table>
		            </c:if>
		            <c:if test="${use_multiData != 'YES'}"><c:out value='${model.boardName}' /></c:if>
	            </td>
	        </tr>
	    </table>
	    </div>
	    <br/>
	    <div style="max-width : 800px;">
	    <table class="content">
	        <tr>
	            <th style="min-width: 88px;"><spring:message code="ezBoard.t111"/></th>
	            <td style="padding: 0;">
	                <c:if test="${use_multiData == 'YES'}">
		                <table style="width: 100%;">
		                    <tr class="primary">
		                        <th><c:out value='${lang_primary}' /></th>
		                        <td style="border-bottom:1px solid #ddd;">
		                            <input type="text" id="txtBoardName" style="width: 100%" value="<c:out value='${model.boardName}' />" maxlength="20" />
		                        </td>
		                    </tr>
		                    <tr class="primary">
		                        <th><c:out value='${lang_secondary}' /></th>
		                        <td style="border-bottom:1px solid #ddd;">
		                            <input type="text" id="txtBoardName2" style="width: 100%" value="<c:out value='${model.boardName2}' />" maxlength="20" />
		                        </td>
		                    </tr>
			          		<c:if test="${useJapanese == 'YES' && lang_primary ne lang_tertiary}">
			                    <tr class="primary">
			                        <th><c:out value='${lang_tertiary}' /></th>
			                        <td style="border-bottom:1px solid #ddd;">
			                            <input type="text" id="txtBoardName3" style="width: 100%" value="<c:out value='${model.boardName3}' />" maxlength="20" />
			                        </td>
			                    </tr>
		                    </c:if>
		                    <c:if test="${useChinese == 'YES'}">
			                    <tr class="secondary">
			                        <th><c:out value='${lang_quaternary}' /></th>
			                        <td>
			                            <input type="text" id="txtBoardName4" style="width: 100%" value="<c:out value='${model.boardName4}' />" maxlength="20" />
			                        </td>
			                    </tr>
		                   	</c:if>
		                </table>
		            </c:if>    
	          		<c:if test="${use_multiData != 'YES'}">
	                	<input type="text" id="txtBoardName" style="width: 100%" value="<c:out value='${model.boardName}' />" maxlength="20" />
	                </c:if>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code="ezBoard.t154"/></th>
	            <td><c:out value='${model.boardNo}' /></td>
	        </tr>
	        <%-- 2018-11-22 홍승비 - 그룹사게시판 옵션 사용 여부 표기 --%>
	        <c:if test="${isAllGroupBoard == 'Y'}">
		        <tr style="${style2}">
		        	<th style="border-left:none; border-bottom:none;"><spring:message code ="ezCircular.t118" /> <spring:message code ="ezBoard.hsb05_1" /></th>
					<td style="border-top:1px solid #dedede; vertical-align: bottom;"><input type="checkbox" name="allGroupBoard" id="allGroupBoard" disabled checked><spring:message code ="ezBoard.hsb03" /> <spring:message code ="ezBoard.hsb04" /></td>
		        </tr>
	        </c:if>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t155"/></th>
	            <td>
	                <input type="text" id="txtBoardDescription" style="width: 100%" value="<c:out value='${model.boardDescription}' />" maxlength="99" />
	            </td>
	        </tr>
	        <tr id="expireTr" style="${style}">
	            <th><spring:message code="ezBoard.t156"/></th>
	            <td>
	            	<c:if test="${model.itemExpires == '-1'}">	            
		                <input type="checkbox" id="chkPermanent" onclick="chkPermanent_onclick()" checked />
		                <spring:message code="ezBoard.t157"/>
		                <input type="checkbox" id="chkExpires" onclick="chkExpires_onclick()" />
		                <input type="text" id="txtExpires" style="width: 35px; height: 21px !important;" readonly />
		                <spring:message code="ezBoard.t158"/>
	            	</c:if>
	                <c:if test="${model.itemExpires != '-1'}">   
		                <input type="checkbox" id="chkPermanent" onclick="chkPermanent_onclick()" />
		                <spring:message code="ezBoard.t157"/>
		                <input type="checkbox" id="chkExpires" onclick="chkExpires_onclick()" checked />
		                <input type="text" id="txtExpires" style="width: 35px" value="<c:out value='${model.itemExpires}' />" />
		                <spring:message code="ezBoard.t158"/>
	                </c:if> 
				</td>
	        </tr>
	        <tr id="deleteAfterTr" style="${style}">	        
	        	<c:if test="${model.deleteAfter == '-1'}">
		            <th><spring:message code="ezBoard.t159"/></th>
		            <td style="padding: 7px 5px;">
		            	<spring:message code="ezBoard.t160"/>
	                	<input type="inputbox" id="deleteafter" style="width: 50px; height:21px !important; margin-top:-2px" readonly />
	                	<spring:message code="ezBoard.t161"/><br/>
	                	<input type="checkbox" id="usedeleteafter" onclick="chkDeleteAfter_onclick()"/>
	                	<spring:message code="ezBoard.t162"/>
	                </td>
	            </c:if>
	            <c:if test="${model.deleteAfter != '-1'}">
	            	<th><spring:message code="ezBoard.t159"/></th>
	            	<td>
	            		<spring:message code="ezBoard.t160"/>
	                	<input type="inputbox" id="deleteafter" style="width: 50px;height:20px;margin-top:3px" value="<c:out value='${model.deleteAfter}' />"/>
	                	<spring:message code="ezBoard.t161"/><br/>
	                	<input type="checkbox" id="usedeleteafter" onclick="chkDeleteAfter_onclick()" checked />
	                	<spring:message code="ezBoard.t162"/>
	                </td>
	            </c:if>
	        </tr>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t163"/></th>
	            <td id = "boardTypeList">
					<input type="checkbox" id="chkGeneralBoard" class = "boardTypeEventHandler" />
					<spring:message code="ezBoard.t00053" />
<%-- 2018-10-15 홍승비 - 그룹게시판 구분 사용하지 않도록 수정(임시로 일반게시판과 그룹게시판 구분 함침) --%>
<%-- 
	                <c:if test="${model.guBun == '1'}">	                   
	                	<input type="checkbox" id="chkGroupBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t164"/>
	                </c:if>
	                <c:if test="${model.guBun != '1'}">
	                	<input type="checkbox" id="chkGroupBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t164"/>
	                </c:if>
--%>
					<input type="checkbox" id="chkAnonyBoard" class = "boardTypeEventHandler" />
					<spring:message code="ezBoard.t165"/>

					<input type="checkbox" id="chkPhotoBoard" class = "boardTypeEventHandler" />
					<spring:message code="ezBoard.t166"/>

					<input type="checkbox" id="chkThumbBoard" class = "boardTypeEventHandler" />
					<spring:message code="ezBoard.t3000"/>

	                <%-- 2018-11-05 홍승비 - 동영상게시판 구분 추가 --%>
					<input type="checkbox" id="chkMovieBoard" class = "boardTypeEventHandler" />
					<spring:message code="ezQuestion.t180"/><spring:message code="ezBoard.t185"/>

	                <br>

					<input type="checkbox" id="chkQnABoard" class = "boardTypeEventHandler" />
					<spring:message code="ezBoard.t00054" />

	                <%-- 2018-07-13 홍승비 - URL게시판 구분 추가 --%>
					<input type="checkbox" id="chkURLBoard" class = "boardTypeEventHandler" />
					URL <spring:message code="ezBoard.t185"/>

	                 <%-- URL 필드를 게시판 구분 필드로 이동 --%>
	                 <input type="text" class="boardTxtURL" id="txtURL" value="<c:out value='${model.url}' />" />

					<%-- 2018-07-13 홍승비 - 홈페이지게시판 구분 추가 --%>
					<input type="checkbox" id="chkHomePageBoard" class = "boardTypeEventHandler" />
					<spring:message code="ezBoard.HSBHp01"/>

					<%-- File Viewer 게시판 --%>
					<input type = "checkbox" id = "fileViewerBoardChkBox" class = "boardTypeEventHandler" />
					<spring:message code = "ezBoard.fileViewerBoard.msg" />
					
					<%-- 2023-11-03 민지수 - 카테고리게시판 구분 추가 --%>
	                <c:if test="${model.guBun == '10' }">
	                	<input type="checkbox" id="chkCategoryBoard" class = "boardTypeEventHandler" checked />
	                	<spring:message code="ezBoard.MJSCAT01" />
	                </c:if>
	                <c:if test="${model.guBun != '10'}">
	                	<input type="checkbox" id="chkCategoryBoard" class = "boardTypeEventHandler" />
	                	<spring:message code="ezBoard.MJSCAT01"/>
	                </c:if>
	            </td>
	        </tr>

			<tr id = "tr_versionManage" style = "${ style }">
				<th><spring:message code = "ezBoard.versionManage.msg1" /></th>
				<td id = "versionManage">
					<input type = "checkbox" id = "versionManageChkBox"/>
					<spring:message code = "ezBoard.t162" />
				</td>
			</tr>
	        
	        <%-- 2019-04-26 홍승비 - 게시판 옵션들을 모아놓은 게시판 설정 TR 추가 --%>
	        <tr id="boardOptionTR" style="${style}">
	        	<th><spring:message code="ezBoard.hsbPR01" /></th>
	        	<td>
	        		<span style="display:inline-block;"><input type="checkbox" id="chkApprBoard" onclick="checkApprBoard()"><spring:message code="ezBoard.t999020" />&nbsp;</span>
	        		<span style="display:inline-block;"><input type="checkbox" id="chkBoardLike"><spring:message code="ezBoard.hsb10" />&nbsp;</span>
					<span style="display:inline-block;"><input type="checkbox" id="chkBoardReplyReact" onclick="checkboardtype()" /><spring:message code="ezBoard.LJE01" />&nbsp;</span>
	        		<span style="display:inline-block;"><input type="checkbox" id="chkBoardDisLike"><spring:message code="ezBoard.kmh07" />&nbsp;</span>
	        		<span style="display:inline-block;"><input type="checkbox" id="chkbackgroundimage" onclick="checkboardtype()" /><spring:message code="ezBoard.t5011_1" />&nbsp;</span>
	        		<span style="display:inline-block;"><input type="checkbox" id="chkform" onclick="checkboardtype()" /><spring:message code="ezBoard.t999027" />&nbsp;</span>
	        	    <span style="display:inline-block;"><input type="checkbox" id="keyWord" onclick="checkboardtype()" /><spring:message code="ezApprovalG.t1200" />&nbsp;</span>
	        	    <span style="display:inline-block;"><input type="checkbox" id="chkStarRating" onclick="checkboardtype()" /><spring:message code="ezBoard.lhr001" />&nbsp;</span>
	        	</td>
	        </tr>
	        
	        <%-- 승인여부 체크 시 나타나는 승인메일옵션과 승인자 리스트 --%>
	        <tr id="chkApprListMail" style="display:none;">
	            <th><spring:message code="ezBoard.t999019" /></th>
	            <td>
	                <input type="checkbox" id="chkApprBoardMail" onclick="checkApprMail()"><spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="chkApprList" style="display:none;">
	            <th>
	            	<a class="imgbtn"><span onclick="SelectTarget()"><spring:message code="ezBoard.t999003" /></span></a>
	            </th>
	            <td>
	                <span id="selectedTarget" style="vertical-align: middle;display:none;"></span>
	                <div class="listview" style="height:100px;overflow-y:auto;overflow-x:hidden;" id="AccessList"></div>
	            </td>
	        </tr>
	        
	        <tr id="writerFlagTR" style="${style}">
	        	<th><spring:message code="ezBoard.LJE02" /></th>
	        	<td>
	        		<span style="display:inline-block;"><input type="checkbox" id="chkWriterFlag"><spring:message code="ezBoard.t162"/></span>
	        	</td>
	        </tr>
	        
	        <%-- 2021-06-21 홍승비 - 메일알림 옵션 분리, 게시알림 / 수정알림 / 댓글알림 추가 --%>
			<tr id="boardMailOptionTR" style="${style}">
	        	<th><spring:message code="ezNotification.hth38" /></th>
	        	<td>
	        		<c:if test="${model.mailFG_Post == 'Y'}">	
	                	<span style="display:inline-block;"><input type="checkbox" id="chkMailFG_Post" onclick="checkboardtype()" checked /><spring:message code="ezBoard.HSBMail01" />&nbsp;</span>
	                </c:if>
	                <c:if test="${model.mailFG_Post != 'Y'}">
	                	<span style="display:inline-block;"><input type="checkbox" id="chkMailFG_Post" onclick="checkboardtype()" /><spring:message code="ezBoard.HSBMail01" />&nbsp;</span>
	                </c:if>
					<c:if test="${model.mailFG_Mod == 'Y'}">
	                	<span style="display:inline-block;"><input type="checkbox" id="chkMailFG_Mod" onclick="checkboardtype()" checked /><spring:message code="ezBoard.HSBMail02" />&nbsp;</span>
	                </c:if>
	                <c:if test="${model.mailFG_Mod != 'Y'}">
	                	<span style="display:inline-block;"><input type="checkbox" id="chkMailFG_Mod" onclick="checkboardtype()" /><spring:message code="ezBoard.HSBMail02" />&nbsp;</span>
	                </c:if>
					<c:if test="${model.mailFG_Comment == 'Y'}">
	                	<span style="display:inline-block;"><input type="checkbox" id="chkMailFG_Comment" onclick="checkboardtype()" checked /><spring:message code="ezBoard.HSBMail03" />&nbsp;</span>
	                </c:if>
	                <c:if test="${model.mailFG_Comment != 'Y'}">
	                	<span style="display:inline-block;"><input type="checkbox" id="chkMailFG_Comment" onclick="checkboardtype()" /><spring:message code="ezBoard.HSBMail03" />&nbsp;</span>
	                </c:if>
	        		<c:if test="${model.replyNotify == '1'}">
	                	<span style="display:inline-block;"><input type="checkbox" id="chkNotify" onclick="checkboardtype()" checked /><spring:message code="ezBoard.HSBMail04" />&nbsp;</span>
	                </c:if>
	                <c:if test="${model.replyNotify != '1'}">
	                	<span style="display:inline-block;"><input type="checkbox" id="chkNotify" onclick="checkboardtype()" /><spring:message code="ezBoard.HSBMail04" />&nbsp;</span>
	                </c:if>
	        	</td>
	        </tr>
	        
			<%-- 2019-11-05 홍승비 - 댓글의 옵션처리 추가 --%>
	        <tr id="oneLineTr" style="${style}">
				<th><spring:message code="ezBoard.t81" /></th>
	            <td>
	                <c:if test="${model.oneLineReply == '2'}">	                
	                	<input type="checkbox" id="chkOneLineBottom" onclick="checkboardtype();checkReplyType(this);" checked/>
	                	<spring:message code="ezBoard.hsbRp02" />
	                </c:if>
					<c:if test="${model.oneLineReply != '2'}">	                
	                	<input type="checkbox" id="chkOneLineBottom" onclick="checkboardtype();checkReplyType(this);"/>
	                	<spring:message code="ezBoard.hsbRp02" />
	                </c:if>
	            	<c:if test="${model.oneLineReply == '1'}">	                
	                	<input type="checkbox" id="chkOneLineLayer" onclick="checkboardtype();checkReplyType(this);" checked/>
	                	<spring:message code="ezBoard.hsbRp01" />
	                </c:if>
					<c:if test="${model.oneLineReply != '1'}">	                
	                	<input type="checkbox" id="chkOneLineLayer" onclick="checkboardtype();checkReplyType(this);"/>
	                	<spring:message code="ezBoard.hsbRp01" />
	                </c:if>
	            	<c:if test="${model.oneLineReply == '0'}">	                
	                	<input type="checkbox" id="chkOneLineNone" onclick="checkboardtype();checkReplyType(this);" checked/>
	                	<spring:message code="ezBoard.hsbRp03" />
	                </c:if>
					<c:if test="${model.oneLineReply != '0'}">	                
	                	<input type="checkbox" id="chkOneLineNone" onclick="checkboardtype();checkReplyType(this);"/>
	                	<spring:message code="ezBoard.hsbRp03" />
	                </c:if>
	            </td>
	        </tr>
	        
			<%-- 2019-10-11 홍승비 - 특정 게시판을 회사별 공지게시판으로 설정하는 기능 추가 --%>
			<tr id="trNoticeBoard" style="${style}">
	            <th><spring:message code="ezBoard.hsbNt01" /></th>
	            <td>
	                <input type="checkbox" id="chkNoticeBoard"/>
	                <spring:message code="ezBoard.t162" /><spring:message code="ezBoard.hsbNt02" />
	            </td>
	        </tr>
			
			<%-- 2020-12-04 박기범 - 특정 게시판을 탭게시판으로 설정하는 기능 추가 --%>
			<tr id="trTabBoard" style="${style}">
	            <th><spring:message code="ezBoard.pgb01" /></th>
	            <td>
					<input type="checkbox" id="chktabBoard1"/><spring:message code="ezBoard.pgb02" />
					<input type="checkbox" id="chktabBoard2"/><spring:message code="ezBoard.pgb03" />
					<input type="checkbox" id="chktabBoard3"/><spring:message code="ezBoard.pgb04" />
					<spring:message code="ezBoard.pgb05" />
				</td>
			</tr>
			<%-- 첨부 설정 --%>
			<tr id="trAttachment" style="${style}">
				<th><spring:message code="ezBoard.t10025" /></th>
				<td>
					<input type="checkbox" id="chkAttachment"
							<c:if test="${model.attachmentFlag == 'Y'}">
								checked
							</c:if>
					/>
					<spring:message code="ezBoard.t162"/>
				</td>
			</tr>
			<%-- 최근게시물 설정 --%>
			<tr id="trAllNewBoard" style="${style}">
				<th><spring:message code="ezBoard.lyj01" /></th>
				<td>
					<input type="checkbox" id="chkAllNewBoard" onclick="chkAllNewBoard_onclick()"
							<c:if test="${model.allNewBoardFlag == 'Y'}">
								checked
							</c:if>
					/>
					<spring:message code="ezBoard.t162"/>
				</td>
			</tr>			
	        <%-- 첨부크기제한 --%>
	        <tr id="attachLimitTr" style="${style}">
	            <th><spring:message code="ezBoard.t167" /></th>
	            <td>
	                <input type="text" id="txtAttachLimit" style="width: auto" onkeydown="onlyNumber()" onkeyup="removeChar()" value="<c:out value='${model.attachSizeLimit}'/>" maxlength="4"/>&nbsp;MB
	            </td>
	        </tr>
	        
	        <%-- 확장칼럼 --%>
	        <tr id="trAttribute" style="${style}">
	            <th><spring:message code="ezBoard.t999028" /></th>
	            <td>
	            	<a class="imgbtn imgbck"><span onClick="ExtensionAttribute_onClick()"><spring:message code="ezBoard.t999029" /></span></a>
	            </td>
	        </tr>	
	        
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t169" /></th>
	            <td style="height: 100%">
	                <table style="width: 300px">
	                    <tr>
	                        <td style="width: 100px;">
	                            <div id="selColor" style="width: 100px; height: 70%; background-color: <c:out value='${model.boardColor}' />; border: 1px solid #686868;"></div>
	                        </td>
	                        <td style="width: 100px;">
	                            <span id="colorID" style="width: 80px;"><c:out value='${model.boardColor}' /></span>
	                        </td>
	                        <td style="text-align: right; width: 100px">
	                            <a class="imgbtn imgbck"><span onclick="change_brdColor()"><spring:message code="ezBoard.t170" /></span></a>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
		</table>
		<br>
		<div style="${style}">
			<table class="content">
				<tr>
					<th style="min-width: 88px;"><spring:message code="ezBoard.private.pgb01"/></th>
					<td style="padding: 0;">
						<table style="width: 100%">
							<tr class="primary">
								<th><spring:message code="ezBoard.private.pgb02"/></th>
								<td style="border-bottom:1px solid #ddd;">
									<input type="checkbox" id="publicFlag" ${model.publicFlag == "Y" ? "checked" : "" }/>
									<label for="publicFlag">
										<spring:message code="ezBoard.private.pgb03"/>
									</label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
	    <div class="btnpositionJsp">
	        <a class="imgbtn" href="javascript:Save()"><span><spring:message code="ezBoard.t98" /></span></a>
	    </div>
	    </div>
	</body>
</html>
