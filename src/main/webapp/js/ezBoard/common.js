function OpenInformationUI(pInformationContent)
{
	var parameter = pInformationContent;
	var url = "/myoffice/ezCommunity/htm/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:180px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
	return RtnVal;
}
function OpenAlertUI(pAlertContent)
{
	var parameter = pAlertContent;
	var url = "/myoffice/ezCommunity/htm/ezAPRALERT.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:180px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
}
function make_searchstring(orgStr)
{
	//return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "'", "''"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
	return ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "&", "[&]"), "'", "''"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
}

function make_searchstring2(orgStr)
{
	return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "&", "[&]"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
}

function ReplaceText( orgStr, findStr, replaceStr )
{
	var re = new RegExp( findStr, "gi" );
	return ( orgStr.replace( re, replaceStr ) );
}

function S4() {
    return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
}

function GetGUID() {
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

function CustomRandom() {
    var now = new Date();
    var seed = now.getMilliseconds();
    return Math.random(seed) + 1;
}

//강민수92
function openBoardComment() {
	DivPopUpShow($('body').prop('scrollWidth') * 0.95, $('body').prop('scrollHeight') * 0.92, "/ezBoard/boardCommentPopup.do?itemID=" 
			+ encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&gubun=" + gubun + "&Reply_FG=" + Reply_FG + "&OneLineReplyFlag=" + OneLineReplyFlag);
}
//강민수92
function closePopup() {
	parent.DivPopUpHidden();
}
//강민수92
function getBoardComment() {
	$.ajax({
		type : "POST",
		async : false,
		url : "/ezBoard/getBoardComment.do",
		dataType : "json",
		data : {
			itemID : pItemID,
			boardID : pBoardID,
			gubun : gubun
		},
		success : function(result) {
			boardCommentList = "<colgroup><col width='20%' /><col width='61%' /><col width='19%' /></colgroup>";
			list = result.boardLineReplyVOList;
			var commentBgColor = 1;
			var updateCount = parseInt(result.totalCommentCount);

			list.forEach(function(vo, index) {
				var replyDelFlag = 0;

				if (vo.userID == null || vo.userID == '') {
					if (gubun == "2" && !(vo.content == null || vo.content == '')) {
						vo.userName = strLangLGE06;
					} else {
						vo.userName = "";
					}
				}
				if (vo.content == null || vo.content == '') { // 자식댓글이 존재하는 삭제된 부모댓글인 경우
					vo.content = strLangLGE07;
					replyDelFlag = 1;
					updateCount -= 1;
				}

				// 하나의 댓글은 2개의 tr로 구성, 각각의 tr은 3개의 td로 구성
				// 첫번째 tr - 댓글 작성자 td, 댓글 내용 td, 댓글 작성일시(수정일시) td로 구성
				if (commentBgColor === 1) {
					boardCommentList += "<tr class='boardComment' replyLevel='" + vo.replyLevel + "' boardUserID='" + vo.userID + "' memberID='"
						+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" 
						+ 1 + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:white;'>";
				} else {
					boardCommentList += "<tr class='boardComment' replyLevel='" + vo.replyLevel + "' boardUserID='" + vo.userID + "' memberID='"
						+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" 
						+ 1 + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#fafafa;'>";
				}
				// 댓글 작성자 td
				if (gubun == "2") {
					if (vo.replyLevel >= 2) {
						boardCommentList += "<td style='padding-left:47px;line-height:1.5'><img src='/images/egovframework/com/cmm/icon/reply_arrow.gif'> &nbsp;<span>" + vo.userName + "</span></td>";
					} else {
						boardCommentList += "<td style='padding-left:3px;line-height:1.5'>&nbsp;<span>" + vo.userName + "</span></td>";
					}
				} else {
					if (vo.replyLevel >= 2) {
						boardCommentList += "<td style='padding-left:47px;'><img src='/images/egovframework/com/cmm/icon/reply_arrow.gif'> &nbsp;<span style='cursor:pointer'"
							+ " onclick='OpenUserInfo(\"" + vo.userID + "\", \"" + vo.deptID + "\")'>" + vo.userName + "</span></td>";
					} else {
						boardCommentList += "<td style='padding-left:3px;'>&nbsp;<span style='cursor:pointer'"
							+ " onclick='OpenUserInfo(\"" + vo.userID + "\", \"" + vo.deptID + "\")'>" + vo.userName + "</span></td>";
					}
				}
				// 댓글 내용 td
				if ((vo.parentWriterName != null && vo.parentWriterName != "") && vo.replyLevel >= "2") {
					boardCommentList += "<td id='contentTd" + index + "' style='text-align:left;vertical-align:middle;padding:10px;word-break:break-all;line-height:1.5; white-space:pre-wrap;'>"
						+ "<span style='font-weight: bold; background-color: #E5EFFF'>@" + vo.parentWriterName + "</span>&ensp;<span class='contentSpan'>" + vo.content + "</span>&nbsp;&nbsp;";
				} else {
					if (vo.replyLevel == "1" && replyDelFlag == 1) {
						boardCommentList += "<td id='contentTd" + index + "' style='text-align:center;vertical-align:middle;padding:10px;'><span style='color:darkgray;'>"
						+ vo.content + "</span>&nbsp;&nbsp;";
					} else {
						/* 2019-11-22 홍승비 - 댓글 작성 시의 공백과 줄바꿈 전부 표출하도록 수정 */
						boardCommentList += "<td id='contentTd" + index + "' style='text-align:left;vertical-align:middle;padding:10px;word-wrap:break-word;line-height:1.5; white-space:pre-wrap;'>"
						+ vo.content + "&nbsp;&nbsp;";
					}
				}
				if (typeof userInfoID == "undefined") {
				    userInfoID = "";    	
				}
				if (vo.userID == userInfoID) {
					boardCommentList += "<img src='/images/ImgIcon/comment_del.gif'" +
							" style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px' onclick='deleteBoardComment(this)'/>";
					boardCommentList += "<img src='/images/modify2.gif'" + " style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px' onclick='modifyBoardComment(this);'/>";
				} else {
					/* 2020-01-10 홍승비 - 익명게시판 댓글 체크 부분 오라클 호환 수정 */
					if ((vo.userID == null || vo.userID == "") && gubun == "2" && replyDelFlag == 0) {
						//익명일 경우
						boardCommentList += "<img src='/images/ImgIcon/comment_del.gif'" +
								" style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px;' onclick='deleteBoardComment(this)'/>";
						boardCommentList += "<img src='/images/modify2.gif'" + " style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px' onclick='modifyBoardComment(this)'/>";
					} else {
						;
					}
				}
				boardCommentList += "</td>";
				// 댓글 작성일시(수정일시) td
				if (replyDelFlag == 1) { // 삭제된 경우 작성일시를 표출하지 않음, 두번째 tr도 사용하지 않음
					boardCommentList += "<td></td>";
				} else if (vo.updateDate == null || vo.updateDate == "") {
					boardCommentList += "<td style='text-align:right;padding-right:8px;border-bottom:hidden;'>" + vo.writeDate.substring(0, 16) + "</td>";
				} else {
					boardCommentList += "<td style='text-align:right;padding-right:8px;border-bottom:hidden;'>" + vo.updateDate.substring(0, 16) + "</td>";
				}
				boardCommentList += "</tr>";
				// 첫번째 tr 종료

				// 두번째 tr - 답글쓰기 버튼 td, 비어있는 td, 좋아요/싫어요 버튼 td로 구성
				/* 2023-03-07 이가은 - 댓글 좋아요/싫어요 버튼 및 우측 숫자 표출 */
				if (replyDelFlag != 1) {
					if (commentBgColor === 1) {
						if (vo.replyLevel >= 2) {
							boardCommentList += "<tr class='commentReact" + index + "' parentreplyid=" + vo.parentReplyID + " style='text-align:left;border:1px solid #e2e2e2;background-color:white;'>";
						} else {
							boardCommentList += "<tr class='commentReact" + index + "' style='height:20px; text-align:left; border:1px solid #e2e2e2; background-color:white;'>";
						}
					} else {
						if (vo.replyLevel >= 2) {
							boardCommentList += "<tr class='commentReact" + index + "' parentreplyid=" + vo.parentReplyID + " style='text-align:left;border:1px solid #e2e2e2;background-color:#fafafa;'>";
						} else {
							boardCommentList += "<tr class='commentReact" + index + "' style='height:20px; text-align:left; border:1px solid #e2e2e2; background-color:#fafafa;'>";
						}
					}
					// 답글쓰기 버튼 td
					if (vo.replyLevel >= 2) {
						boardCommentList += "<td style='border-top:hidden;padding-left:58px;'>";
					} else {
						boardCommentList += "<td style='border-top:hidden;'>";
					}
					boardCommentList += "<a style='color: #8c8b89; float: left; padding-left: 7px; margin-bottom: 13px;' onclick='replyOnclick(this, \"" + vo.replyID + "\", \"" + vo.userName + "\")'><span class='replyWriteSpan" + index + "' style='cursor:pointer;'>" + strLangLGE01 + "</span></a></td>";
					// 비어있는 td
					boardCommentList += "<td style='border-top:hidden;'></td>";
					// 좋아요/싫어요 버튼 td
					boardCommentList += "<td class='reactTd' style='text-align:right; border-top:hidden; padding-right:13px; float:right;' replyid=" + vo.replyID + ">";
					if (reactFlag != null && reactFlag == "Y") {
						if (gubun != 2) {
							boardCommentList += "<div><p style='float:left; margin-top:0px;'><img src='/images/like_off.png' style='cursor:pointer;' id=Y" + vo.replyID + " replyid=" + vo.replyID + " userid=" + vo.userID + " reactflag=Y index=" + index + " onclick='react_onclick(this)' /></p>";
							boardCommentList += "<p style='width:16px; float:left; margin-top:0px;'><span id='myY" + index + "' style='color:#F55E51;'>" + vo.re_like + "</span></p>";
							boardCommentList += "<p style='float:left; margin-top:0px; margin-left:15px;'><img src='/images/hate_off.png' style='cursor:pointer;' id=N" + vo.replyID + " replyid=" + vo.replyID + " userid=" + vo.userID + " reactflag=N index=" + index + " onclick='react_onclick(this)'/></p>";
							boardCommentList += "<p style='width:16px; float:left; margin-top:0px;'><span id='myN" + index + "' style='color:#5381F5;'>" + vo.re_hate + "</span></p></div>";
							boardCommentList += "</td>";
							boardCommentList += "</tr>";
						} else {
							boardCommentList += "<div><p style='float:left; margin-top:0px;'><img src='/images/like_off.png' style='cursor:pointer;' id=Y" + vo.replyID + " replyid=" + vo.replyID + " userid=anonym reactflag=Y index=" + index + " onclick='react_onclick(this)' /></p>";
							boardCommentList += "<p style='width:16px; float:left; margin-top:0px;'><span id='myY" + index + "' style='color:#F55E51;'>" + vo.re_like + "</span></p>";
							boardCommentList += "<p style='float:left; margin-top:0px; margin-left:15px;'><img src='/images/hate_off.png' style='cursor:pointer;' id=N" + vo.replyID + " replyid=" + vo.replyID + " userid=anonym reactflag=N index=" + index + " onclick='react_onclick(this)'/></p>";
							boardCommentList += "<p style='width:16px; float:left; margin-top:0px;'><span id='myN" + index + "' style='color:#5381F5;'>" + vo.re_hate + "</span></p></div>";
							boardCommentList += "</td>";
							boardCommentList += "</tr>";
						}
					} else {
						boardCommentList += "</td></tr>";
					}
				}
				commentBgColor = commentBgColor * (-1);
			});
			// 두번째 tr 종료
			  
			if (list.length == 0) {
				boardCommentList += "<tr style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:white;'>";
				boardCommentList += "<td colspan='3' style='padding:10px;border-top:0px;border-bottom:1px solid #e2e2e2;"
									+ "border-right:0px;border-left:0px;text-align:center;background-color:white;'>" 
									+ strLang181 + "</td>";
				boardCommentList += "</tr>";
			}
			
			$("#commentList").html("");
			$("#commentList").append(boardCommentList);
			
			document.getElementById('onelinereply').value = "";
			$("#headTitle").html("[" + updateCount + "]");
			var a = $('#commentCount', parent.document).text(strLang186 + "[" + updateCount + "]");
			
			nowCommentCount = updateCount; // 댓글 옵션처리를 위해 전역변수에 최신 댓글갯수를 부여, 자식댓글이 있는 삭제된 부모댓글은 댓글갯수에서 제외
			if (reactFlag != null && reactFlag == "Y") {
				showUserReplyReact(pItemID); // 사용자별 게시판 댓글 반응 표출 (아이콘 파란색으로 변경, 숫자 볼드 처리)
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}
//강민수92
function delete_onelinereply_Complete(ret) {
    var xmlhttp = createXMLHttpRequest();
    if (ret == "NO") {
        alert(strLang185);
        return;
    }
    else if (ret == "cancel" || ret == undefined) {
        return;
    }
	// function deleteBoardComment의 흐름과 동일
	if (delReplyLevel == "1" && delParentReply == 1) { // 자식이 있는 부모 댓글 삭제
		$.ajax({
			type : "GET",
			dataType : "text",
			async : false,
			url : "/ezBoard/updateDelParentReply.do",
			data : {
				boardID	: pBoardID,
				itemID	: pItemID,
				replyID	: delpReplyID
			},
			success: function() {
			}
		});
	} else if (delReplyLevel != "1" && delParentReply == 2) { // 삭제된 부모 댓글의 하나 뿐인 자식 댓글 삭제
		xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
		xmlhttp.send();
		xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(parentReplyID) + "&guBun=" + gubun + "&flag=true", false);
		xmlhttp.send();
	} else {
		xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
		xmlhttp.send();
	}

	if (xmlhttp.responseText == "FAIL") { // deleteOneLineReply.do를 타고 나서 실패한 경우, 자기가 작성한 댓글이 아닌 경우
		alert(strLang184);
	}

	allReactDelete(delpReplyID); // 삭제된 댓글의 반응 삭제
	getBoardComment(); // 댓글 리스트 다시 불러오기
	xmlhttp = null;

	// 사용한 변수를 초기화
	delpReplyID = "";
	delParentReply = 0;
	delChildReply = 0;
	delReplyLevel = "";
	parentReplyID = "";

	/* 2019-11-06 홍승비 - 게시물 미리보기 영역에서 댓글 삭제 시 게시물 리스트 갱신 */
	if (window.location.href.indexOf("/ezBoard/boardItemPreviewContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewPhotoContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewMovieContent.do") > -1) {
		window.parent.getBoardList();
	}
}
//강민수92
function deleteBoardCommentPopup(obj) {
	delpReplyID = $(obj).closest("tr").attr("replyID");

	/* 2019-11-07 홍승비 - 하단댓글의 경우 레이어팝업 표출영역 수정 */
	if (OneLineReplyFlag == "1") {
		DivPopUpShow2($('body').prop('scrollWidth') * 0.5, $('body').prop('scrollHeight') * 0.3, "/ezBoard/checkPassWord.do?itemID=" 
				+ encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID) + "&replyFlag=true&clickFlag=delete");
	}
	else if (OneLineReplyFlag == "2") {
		if ($(window).height() < $('body').prop('scrollHeight')) {
			document.getElementById("mailPanel2").style.height = ($('body').prop('scrollHeight') + "px");
		} else {
			document.getElementById("mailPanel2").style.height = ($(window).height() + "px");
		}
		DivPopUpShow2(376, 191, "/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID) + "&replyFlag=true&clickFlag=delete");
	}
}
//강민수92
function closePopup2() {
	parent.DivPopUpHidden2();
}
//강민수92
function deleteBoardComment(obj) {
	delpReplyID = $(obj).closest("tr").attr("replyID");
	delReplyLevel = $(obj).closest("tr").attr("replylevel");
	parentReplyID = $(obj).closest('tr')[0].nextSibling.getAttribute('parentreplyid');

	var replyID = "";

	if (delReplyLevel != "1" && (parentReplyID != null || parentReplyID != '')) {
		if ($(obj).closest('tr')[0].previousSibling.className == "boardComment") {
			delChildReply = 1;
		}
	}

	if (delReplyLevel == "1") {
		replyID = delpReplyID;
	} else {
		replyID = parentReplyID;
	}

	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezBoard/getChildReplyCnt.do",
		data : {
			boardID : pBoardID,
			itemID	: pItemID,
			replyID : replyID
		},
		success: function(result){
			if ((delReplyLevel == "1" && result > 0) || (delReplyLevel != "1" && result == 1 && delChildReply == 0)) {
				delParentReply = 1;
			} else if (delReplyLevel != "1" && result == 1 && delChildReply == 1) {
				delParentReply = 2;
			}
		}
	});

	var xmlhttp = createXMLHttpRequest();

	if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && gubun == "2" && CrossYN()) { // 권한 없음, 익명게시판, CrossYN()이 true -> 흐름을 다르게 타야 함
		checkpassword_dialogArguments[1] = delete_onelinereply_Complete;
		deleteBoardCommentPopup(obj);
		try {
			OpenWin.focus();
		} catch (e) {
		}
	} else {
		if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && gubun == "2" && !CrossYN()) { // 권한 없음, 익명게시판, CrossYN()이 false -> 암호 확인, 아래 흐름을 탐
			var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
			feature = feature + GetShowModalPosition(330, 200);
			var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID), "", feature);

			if (ret == "NO") {
				alert("<spring:message code='ezBoard.t267' />");
				return;
			} else if (ret == "cancel" || ret == undefined) {
				return;
			}
		} else if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && gubun != "2") { // 권한 없음, 익명게시판 아님 -> 본인 댓글인지 확인, 아래 흐름을 탐
			xmlhttp.open("POST", "/ezBoard/checkOneLineOwner.do?replyID=" + encodeURIComponent(delpReplyID), false);
			xmlhttp.send();
			if (xmlhttp.responseText.substr(0, 2) != "OK") {
				alert(strLang184);
				return;
			} else {
				if (!confirm(strLang180)) return;
			}
		} else {
			if (!confirm(strLang180)) return;
		}
		// 권한이 있는 경우 + 암호를 확인하거나, 본인 댓글인지 확인된 경우
		if (delReplyLevel == "1" && delParentReply == 1) { // 자식이 있는 부모 댓글 삭제
			$.ajax({
				type : "GET",
				dataType : "text",
				async : false,
				url : "/ezBoard/updateDelParentReply.do",
				data : {
					boardID	: pBoardID,
					itemID	: pItemID,
					replyID	: delpReplyID
				},
				success: function() {
				}
			});
		} else if (delReplyLevel != "1" && delParentReply == 2) { // 삭제된 부모 댓글의 하나 뿐인 자식 댓글 삭제
			xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
			xmlhttp.send();
			xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(parentReplyID) + "&guBun=" + gubun + "&flag=true", false);
			xmlhttp.send();
		} else {
			xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
			xmlhttp.send();
		}

		if (xmlhttp.responseText == "FAIL") { // deleteOneLineReply.do를 타고 나서 실패한 경우, 자기가 작성한 댓글이 아닌 경우
			alert(strLang184);
		}

		allReactDelete(delpReplyID); // 삭제된 댓글의 반응 삭제
		getBoardComment(); // 댓글 리스트 다시 불러오기
		xmlhttp = null;

		// 사용한 변수를 초기화
		delpReplyID = "";
		delParentReply = 0;
		delChildReply = 0;
		delReplyLevel = "";
		parentReplyID = "";

		/* 2019-11-06 홍승비 - 게시물 미리보기 영역에서 댓글 삭제 시 게시물 리스트 갱신 */
		if (window.location.href.indexOf("/ezBoard/boardItemPreviewContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewPhotoContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewMovieContent.do") > -1) {
			window.parent.getBoardList();
		}
	}
}
//강민수92
function OneLineReply_onkeydown() {
    if (event.keyCode == 13) Save_OneLineReply();
}
//강민수92
function Save_OneLineReply(reply) {
    if (Reply_FG != "true") {
        alert(strLang173);
	    return;
	}
    /* 2019-11-05 홍승비 - 게시물 본문하단 댓글옵션 추가 */
    if (reply.id != 'childReplySaveBtn') {
    	if (OneLineReplyFlag == "1" || OneLineReplyFlag == "2") {
    		var text = document.getElementById('onelinereply').value.replace(/\s|　/gi, '');
    		if (text == "") {
    			alert(strLang182);
    			return;
    		}
    	}

	    if (gubun == "2" && trim(document.getElementById('txtPassWord').value) == "") {
	        alert(strLang183);
		    document.getElementById('txtPassWord').focus();
		    return;
		}
    }
    var pReplyID = "";
    pReplyID = "{" + GetGUID().toUpperCase() + "}";

    var replyLevel = 1;
	var content,password;
	if (OneLineReplyFlag == "1" || OneLineReplyFlag == "2"){
		content = MakeXMLString(document.getElementById('onelinereply').value);
	} else {
		content = "";
	}
	if (gubun != "2") {
	    password = "";
	} else {
	    password = rsa.encrypt(document.getElementById("txtPassWord").value);
	}

	// 답글일 경우
	if (reply.id == 'childReplySaveBtn') {
		var parentReplyId = reply.closest('tr').getAttribute('parentreplyid');
		var parentWriterName = reply.closest('tr').getAttribute('parentwritername');
		var replyLevel = reply.getAttribute('replyLevel');

		content = MakeXMLString(document.getElementById('reReply').value);

		if (content.trim() == "") {
			alert(strLang182);
			return;
		}

		if (gubun == "2") {
			if (trim(document.getElementById('childReplyPW').value) == "") {
				alert(strLang183);
				document.getElementById('childReplyPW').focus();
				return;
			} else {
				password = rsa.encrypt(document.getElementById("childReplyPW").value);
			}
		}
	}
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezBoard/saveOneLineReply.do",
		data : { boardID    : pBoardID, 
				 itemID 	: pItemID,
				 replyID	: pReplyID,
				 content	: content,
				 password	: password,
				 parentReplyId : parentReplyId,
				 replyLevel : replyLevel,
				 parentWriterName : parentWriterName
			   },
		success: function(){
			getBoardComment();
			$('#txtPassWord').val("");
			
			/* 2019-11-06 홍승비 - 게시물 미리보기 영역에서 댓글 작성 시 게시물 리스트 갱신 */
			if (window.location.href.indexOf("/ezBoard/boardItemPreviewContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewPhotoContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewMovieContent.do") > -1) {
				window.parent.getBoardList();
			}
			
			/* 2021-06-23 홍승비 - 댓글알림 기능 추가 (댓글알림 시에 그룹사게시판 여부 파라미터는 필요없음) */
			sendBoardAlert("comment", pBoardID, pItemID, "");
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("ajax error");
		}
	});
}
//2017.12.28 강민수92
function OpenUserInfo(pUserID, pDeptID) {
    var result = GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "UserInfo", 420, 450, "NO");
}

//2018.01.02 강민수92
function DivPopUpShow2(popUpW, popUpH, URL) {
    try {
        var Position = DivPopUpPosition(popUpW, popUpH);
        
         /* 2019-11-07 홍승비 - 하단댓글의 경우 레이어팝업 표출영역 수정 */
        if (OneLineReplyFlag == "2") {
        	Position[0] = scrollValue + ($(window).height() / 2) - 85;
        }
        
        document.getElementById("iFrameLayer2").src = URL;
        document.getElementById("iFramePanel2").style.top = Position[0] + "px";
        document.getElementById("iFramePanel2").style.left = Position[1] + "px";
        document.getElementById("iFramePanel2").style.height = popUpH + "px";
        document.getElementById("iFrameLayer2").style.width = popUpW + "px";
        document.getElementById("iFrameLayer2").style.height = popUpH + "px";
        document.getElementById("mailPanel2").style.display = "";
        document.getElementById("iFramePanel2").style.display = "";
    } catch (e) {}
}

function DivPopUpHidden2() {
    try {
        document.getElementById("mailPanel2").style.display = "none";
        document.getElementById("iFramePanel2").style.display = "none";
        document.getElementById("iFrameLayer2").src = "/blank.htm";
    } catch (e) {}
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

/* 2023-03-07 이가은 - 게시판 댓글 좋아요/싫어요 버튼 클릭 동작 함수 */
function react_onclick(reply) {
	var xmlhttp = createXMLHttpRequest();

	var replyId = reply.getAttribute('replyid');
	var replyWriter = reply.getAttribute('userid');
	var reactFlag = reply.getAttribute('reactflag');
	var replyIndex = reply.getAttribute('index');

	xmlhttp.open("POST", "/ezBoard/reactAndModeCheck.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(replyId) + "&replyWriter=" + replyWriter + "&reactFlag=" + reactFlag, false);
	xmlhttp.send();

	getBoardComment();

	if (xmlhttp.response == 1) { // 댓글이 존재하지 않는 경우
		alert(strLangLGE190);
	} else if (xmlhttp.response == 2) { // 댓글 작성자인 경우 (본인 댓글에 반응 불가)
		reactFlag == "Y" ? alert(strLangLGE188) : alert(strLangLGE189);
	} else if (xmlhttp.response == 4) { // 같은 반응을 눌렀을 경우
		$('#my' + reactFlag + replyIndex).css({"font-weight" : "normal"});
	}
}

/* 2023-03-07 이가은 - 게시판 댓글 반응 삭제 함수 */
function allReactDelete(delpReplyID) {
	var xmlhttps = createXMLHttpRequest();

	xmlhttps.open("POST", "/ezBoard/allReactDelete.do?itemID=" + encodeURIComponent(pItemID) + "&delReplyID=" + encodeURIComponent(delpReplyID), true);
	xmlhttps.send();
}

/* 2023-03-08 이가은 - 사용자별 게시판 댓글 반응 표출 함수 (사용자가 선택한 아이콘 색상변경, 숫자 볼드처리) */
function showUserReplyReact(pItemID) {
	$.ajax({
		type : "GET",
		async : false,
		url : "/ezBoard/getUserReplyReact.do",
		dataType : "json",
		data : {pItemID : pItemID},
		success : function(result) {
			for (var i in result) {
				var reactFlag = result[i].REACTFLAG;
				var replyId = result[i].REPLYID;

				if ($('td[replyid="' + replyId + '"]').length == 1) {
					var replyIndex = $('[id^="'+ reactFlag + replyId + '"]').show()[0].getAttribute('index');

					$('#my' + reactFlag + replyIndex).css({"font-weight" : "bold"});
					reactFlag == 'Y' ? $('[id^="' + reactFlag + replyId +'"]').show()[0].src = '/images/like_on.png' : $('[id^="' + reactFlag + replyId +'"]').show()[0].src = '/images/hate_on.png';
				}
			}
		}
	});
}

/* 2023-03-29 이가은 - 답글쓰기/답글접기 버튼 온클릭 메서드 */
function replyOnclick(reply, replyID, userName){
	var replyTr = ($(reply).parents()[1]).className;
	var parentReplyID = $(reply).parents()[1].getAttribute('parentreplyid');
	var replyWriteSpan = $(reply).children('span').text();
	var replyLevel = $(reply).parents()[1].previousSibling.getAttribute('replylevel');

	if (parentReplyID != null) {
		replyID = parentReplyID;
	}

	var commentList = "<tr class='tr" + replyTr + "' style='height: 71.88px;' parentReplyId= " + replyID +" parentWriterName= " + "'" + userName  + "'" + ">";

	if (gubun != 2) {
		commentList += "<td colspan='3' style='padding:3px 0px 3px 63px; position:relative; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;'>";
		commentList += "<p style='width : 14%; float: left; display:-webkit-box; -webkit-line-clamp:3; -webkit-box-orient:vertical; overflow:hidden;'><span>" + userInfoName + "</span></p>";
		commentList += "<textarea id='reReply' rows='3' style='resize:none; width: 71.5%; float: left; overflow: hidden;' maxlength='600' oninput='editAutoGrow(this)'></textarea>";
		commentList += "<a class='imgbtn' style='vertical-align: middle; position:absolute; top:50%; transform:translate(24%,-55%);'><span id='childReplySaveBtn' replyLevel=" + (parseInt(replyLevel) + 1) + " onclick='Save_OneLineReply(this)'>" + strLangLGE03 + "</span></a></td>";
		commentList += "</tr>";
	} else {
		if (OneLineReplyFlag == 1) {
			commentList += "<td colspan='3' style='padding-left:53px; padding-top:3px; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2;'>";
			commentList += "<p style='float:left; margin-right: 56px; margin-left:10px;'><span>" + strLangLGE06 + "</span></p>";
			commentList += "<textarea id='reReply' rows='3' style='resize:none; width:83%; float: left; overflow:hidden;' maxlength='600' oninput='editAutoGrow(this)'></textarea></td></tr>";
		} else {
			commentList += "<td colspan='3' style='padding-left:53px; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2;'>";
			commentList += "<p style='float:left; margin-right: 65px; margin-left:10px;'><span>" + strLangLGE06 + "</span></p>";
			commentList += "<textarea id='reReply' rows='3' style='resize:none; width:79.5%; float: left; overflow:hidden;' maxlength='600' oninput='editAutoGrow(this)'></textarea></td></tr>";
		}
		commentList += "<tr class='tr" + replyTr + "' parentReplyId= " + replyID + " parentWriterName= " + userName + ">";
		commentList += "<td colspan='3' style='width: 90%; text-align:right; padding-top:3px; padding-bottom:4px; vertical-align: middle'>";
		commentList += "<span style='font-weight:normal; margin-right:4px; display:inline-block; margin-top:2px'>" + strLangLGE05 + "&nbsp;</span>";
		commentList += "<span><input type='password' id='childReplyPW' maxlength='20' size='20'>&nbsp;</span>";
		commentList += "<a class='imgbtn' style='vertical-align: middle; margin-left: 6px; margin-right:7px;'><span id='childReplySaveBtn' replyLevel=" + (parseInt(replyLevel) + 1) + " onclick='Save_OneLineReply(this)'>" + strLangLGE03 + "</span></a></td>";
		commentList += "</td></tr>";
	}

	if (replyModifyFlag > 0) { // 댓글수정 창이 열려있는 경우 창을 닫아줌
		$('#' + replyModifyId).next('td').css('border-bottom', 'hidden');
		$('#' + replyModifyId).closest('tr').next('tr').css('display', '');
		$('#' + replyModifyId).html(replyTextarea);
		replyModifyFlag = 0;
	}

	if (replyWriteSpan == strLangLGE01) { // 답글쓰기 버튼 클릭
		replyOpenFlag += 1;

		if (replyOpenFlag == 2) { // 답글쓰기 창이 열려있는 경우 창을 닫아줌
			$('[class^=trcommentReact]').remove();
			$('[class^=replyWriteSpan]').text(strLangLGE01);
			replyOpenFlag = 1;
		}

		$(reply).children('span').text(strLangLGE02);
		$('.' + replyTr).after(commentList);
		$('#reReply').focus();
	} else if (replyWriteSpan == strLangLGE02) { // 답글접기 버튼 클릭
		replyOpenFlag -= 1;

		$('.tr' + replyTr).remove();
		$(reply).children('span').text(strLangLGE01);
	}
}

/* 2023-03-29 이가은 - 수정 버튼 온클릭 메서드 > textarea로 변경 */
function modifyBoardComment(obj){
	var replyID = $(obj).closest('tr').attr("replyID");
	var replyLevel = $(obj).closest('tr').attr('replylevel');
	var color = obj.parentNode.parentNode.style.backgroundColor;

	content = (replyLevel == 1) ? $(obj).closest("td").text() : $(obj).parents()[1].childNodes[1].childNodes[2].outerText;

	if (replyLevel == 1) {
		content = content.substr(0, content.length - 2);
	}

	// 답글쓰기 창이 열려있는 경우 창을 닫아줌
	if (replyOpenFlag > 0) {
		$('[class^=trcommentReact]').remove();
		$('[class^=replyWriteSpan]').text(strLangLGE01);
		replyOpenFlag = 0;
	}

	replyModifyArray = [obj, color, content];

	if (gubun == 2 && CrossYN()) { // 익명게시판, CrossYN()이 true -> 흐름을 다르게 타야 함
		checkpassword_dialogArguments[1] = modify_onelinereply_Complete;
		modifyBoardCommentPopup(obj);
	} else {
		if (gubun == 2 && !CrossYN()) { // 익명게시판, CrossYN()이 false -> 암호 확인, 아래 흐름을 탐
			var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
			feature = feature + GetShowModalPosition(330, 200);
			var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(replyID), "", feature);

			if (ret == "NO") {
				alert("<spring:message code='ezBoard.t267' />");
				return;
			} else if (ret == "cancel" || ret == undefined) {
				return;
			}
		}

		var modifyTextarea = "<div style='border:1px solid lightgray; width:100%; float:left;'>";
		modifyTextarea += "<div><textarea class='modifyText' style='width:98%;background-color:" + color + "; resize:none; outline:none; padding:3px; border:none; overflow:hidden;' maxlength='600' oninput='editAutoGrow(this)'>" + content + "</textarea>";
		modifyTextarea += "</div>";
		modifyTextarea += "<div style='margin-bottom:2px; float:right; margin-right:5px;'>";
		modifyTextarea += "<a onclick='getBoardComment(); replyModifyFlag -= 1;'>" + strLangLGE04 + "</a>";
		modifyTextarea += "<span style='margin-left:5px; margin-right:5px; color:gray;'>|</span>"
		modifyTextarea += "<a onclick='modiReplySave(this); replyModifyFlag -= 1;'>" + strLangLGE03 + "</a></div>";
		modifyTextarea += "</div>";

		if (replyModifyFlag == 0) {
			replyModifyId = $(obj).closest('td').attr('id');
			replyTextarea = $(obj).closest('td').html();
			$(obj).closest('td').next('td').css('border-bottom', '');
			$(obj).closest('tr').next('tr').css('display', 'none');
			$(obj).closest('td').html(modifyTextarea);
			$('.modifyText').focus();
			$('.modifyText').prop('selectionStart', content.length);

			replyModifyFlag += 1;
		} else if (replyModifyFlag > 0) { // 댓글수정 창이 열려있는 경우 창을 닫아줌
			$('#' + replyModifyId).html(replyTextarea);
			$('#' + replyModifyId).next('td').css('border-bottom', 'hidden');
			$('#' + replyModifyId).closest('tr').next('tr').css('display', '');

			replyModifyId = $(obj).closest('td').attr('id');
			replyTextarea = $(obj).closest('td').html();
			$(obj).closest('td').next('td').css('border-bottom', '');
			$(obj).closest('tr').next('tr').css('display', 'none');
			$(obj).closest('td').html(modifyTextarea);
			$('.modifyText').focus();
			$('.modifyText').prop('selectionStart', content.length);
		}
		editAutoGrow($('.modifyText')[0]);
	}
}

/* 2023-03-27 이가은 - 댓글 수정 후 등록 버튼 온클릭 메서드 */
function modiReplySave(reply) {
	var pReplyID = reply.closest('tr').getAttribute('replyid');
	var text = document.getElementsByClassName('modifyText')[0].value.replace(/\s|　/gi, '');

	if (text == "") {
		alert(strLang182);
		$('.modifyText').focus();
		replyModifyFlag += 1;
		return;
	} else {
		text = MakeXMLString(document.getElementsByClassName('modifyText')[0].value);
	}

	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezBoard/updateOneLineReply.do",
		data : {
			boardID : pBoardID,
			itemID 	: pItemID,
			replyID	: pReplyID,
			content	: text
		},
		success: function(result){
			getBoardComment();

			if (window.location.href.indexOf("/ezBoard/boardItemPreviewContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewPhotoContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewMovieContent.do") > -1) {
				window.parent.getBoardList();
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("ajax error");
		}
	});
}

/* 2023-08-09 임정은 - 익명게시판 답글 수정 > checkPassWord.do로 보내주는 메서드 */
function modifyBoardCommentPopup(obj) {
	delpReplyID = $(obj).closest("tr").attr("replyID");

	if (OneLineReplyFlag == "1") {
		DivPopUpShow2($('body').prop('scrollWidth') * 0.5, $('body').prop('scrollHeight') * 0.3, "/ezBoard/checkPassWord.do?itemID="
			+ encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID) + "&replyFlag=true&clickFlag=modify");
	} else if (OneLineReplyFlag == "2") {
		if ($(window).height() < $('body').prop('scrollHeight')) {
			document.getElementById("mailPanel2").style.height = ($('body').prop('scrollHeight') + "px");
		} else {
			document.getElementById("mailPanel2").style.height = ($(window).height() + "px");
		}
		DivPopUpShow2(376, 191, "/ezBoard/checkPassWord.do?itemID="
			+ encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID) + "&replyFlag=true&clickFlag=modify");
	}
	try {
		OpenWin.focus();
	} catch (e) {
	}
}

/* 2023-08-09 임정은 - 익명게시판 답글 수정 > 비밀번호 확인 후 textarea로 변경해주는 메서드 */
function modify_onelinereply_Complete(ret) {
	if (ret == "NO") {
		alert("<spring:message code='ezBoard.t267' />");
		return;
	} else if (ret == "cancel" || ret == undefined) {
		return;
	}

	var obj = replyModifyArray[0];
	var color = replyModifyArray[1];
	var content = replyModifyArray[2];

	var modifyTextarea = "<div style='border:1px solid lightgray; width:100%; float:left;'>";
	modifyTextarea += "<div><textarea class='modifyText' style='width:98%;background-color:" + color + "; resize:none; outline:none; padding:3px; border:none; overflow:hidden;' maxlength='600' oninput='editAutoGrow(this)'>" + content + "</textarea>";
	modifyTextarea += "</div>";
	modifyTextarea += "<div style='margin-bottom:2px; float:right; margin-right:5px;'>";
	modifyTextarea += "<a onclick='getBoardComment(); replyModifyFlag -= 1;'>" + strLangLGE04 + "</a>";
	modifyTextarea += "<span style='margin-left:5px; margin-right:5px; color:gray;'>|</span>"
	modifyTextarea += "<a onclick='modiReplySave(this); replyModifyFlag -= 1;'>" + strLangLGE03 + "</a></div>";
	modifyTextarea += "</div>";

	if (replyModifyFlag == 0) {
		replyModifyId = $(obj).closest('td').attr('id');
		replyTextarea = $(obj).closest('td').html();
		$(obj).closest('td').next('td').css('border-bottom', '');
		$(obj).closest('tr').next('tr').css('display', 'none');
		$(obj).closest('td').html(modifyTextarea);
		$('.modifyText').focus();
		$('.modifyText').prop('selectionStart', content.length);

		replyModifyFlag += 1;
	} else if (replyModifyFlag > 0) { // 댓글수정 창이 열려있는 경우 창을 닫아줌
		$('#' + replyModifyId).html(replyTextarea);
		$('#' + replyModifyId).next('td').css('border-bottom', 'hidden');
		$('#' + replyModifyId).closest('tr').next('tr').css('display', '');

		replyModifyId = $(obj).closest('td').attr('id');
		replyTextarea = $(obj).closest('td').html();
		$(obj).closest('td').html(modifyTextarea);
		$('.modifyText').focus();
		$('.modifyText').prop('selectionStart', content.length);
	}
	editAutoGrow($('.modifyText')[0]);
}

/* 2023-03-27 이가은 - textarea 자동높이 함수 추가 */
function editAutoGrow(element) {
	element.style.height = "1px";    	
    element.style.height = (element.scrollHeight - 10) + "px";	
    
    if (element.id == "reReply") {
    	if (element.scrollHeight < 67) element.style.height = "57px";
    } else {
    	if (element.scrollHeight < 55) element.style.height = "35px";
    }
}

// 2024-07-31 전인하 - 게시판 > 확장컬럼 > peoplePicker 타입 출력값 가공
function peoplePickerDisplay(attr, userLang) {
    if (attr == null || typeof attr == "undefined") {
        return "";
    }
    attr = attr.trim();
    if (attr == "") {
        return attr;
    }
    
    var rtnString = "";
    var tempAuthListArr = attr.split(";");
    for (let i = 0 ; i < tempAuthListArr.length; i++) {
        var tempAuthObj = tempAuthListArr[i].split("/");
        if (tempAuthListArr[i] == "") {
            break;
        }
        if (i != 0) {
            rtnString += ", "
        }
        
        rtnString += userLang == "1" ? tempAuthObj[1] : tempAuthObj[2];
    }
    return rtnString;
}