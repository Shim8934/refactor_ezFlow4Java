// 2023-11-09 전인하 - 게시판 이모티콘 관련 전역변수
var stickerGroup = ["girl;12;png", "officepeople;17;png"]; // 이모티콘그룹과 해당 그룹에 속하는 이모티콘 갯수
var stickerIndex = 0; // 현재 포커싱중인 이모티콘의 인덱스
// 이벤트 맵핑
$(function() {
	// 게시물 조회 > 게시물 세부정보 토글 // 기본은 펼쳐진 상태
	$('#preview_detail_toggle').click(function () {
		$('#preview_detail_toggle').toggleClass('active');
		$('.detail_category').toggleClass('active');
	});
	
	// 첨부파일 조회 > 첨부파일 리스트 토글 // 기본은 펼쳐진 상태
	$('#preview_attach_toggle').click(function () {
		$('#preview_attach_toggle').toggleClass('active');
		$('.preview_attach_list').toggleClass('active');
        
        if ($('.preview_attach_list').hasClass('active')){
            $('.preview_attach_list').css("height","auto");
        } else {
            $('.preview_attach_list').css("height","0");
        }
	});
});

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
    AllEmoticonPanelClose();
	$.ajax({
		type : "POST",
		async : false,
		url : "/ezBoard/getBoardComment.do",
		dataType : "json",
		data : {
			itemID : pItemID,
			boardID : pBoardID,
			gubun : gubun,
			sort : commentSort
		},
		success : function(result) {
			var boardCommentList = makeBoardCommentHtml(result, "view");			
			$("#commentList").html("");
			$("#commentList").append(boardCommentList);
			
			document.getElementById('onelinereply').value = "";
			
			var updateCount = parseInt(result.totalCommentCount);
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

// mode: view(게시물조회화면), print(인쇄)
function makeBoardCommentHtml(result, mode) {
    var updateCount = parseInt(result.totalCommentCount);
    var boardCommentList = "";
    
    boardCommentList.classList = "comment_list_text";
    list = result.boardLineReplyVOList;
	
	if (list.length == 0) { // 댓글이 없을 때
		boardCommentList += "<div style='padding: 15px; margin: 0 auto; width: 100%; text-align: center; border-bottom: 1px solid #CDD1D5; box-sizing: border-box;'>";
        boardCommentList += "<span style='color: #8b8b8b;font-size: 14px;'>" + strLang181 + "</span></div>";
		return boardCommentList;
    }

    for (const [index, vo] of list.entries()) {
		var replyDelFlag = 0;
		if (!vo.userID) {
			if (gubun == "2" && (!!vo.content || !!vo.imageContent)) {  // 빈 댓글 조회 기준 변경
				vo.userName = strLangLGE06;
			} else {
				vo.userName = "";
			}
		}
		if (!vo.content && !vo.imageContent) { // 빈 댓글 조회 기준 변경
			vo.content = strLangLGE07;
			vo.replyAttach = null;
			replyDelFlag = 1;
			updateCount -= 1;
		}
		if (!vo.content) { // 댓글 본문없이 이모티콘만 존재할 경우 빈문자열 삽입하여 빈댓글 취급
			vo.content = "";
		}

		if (!vo.userPhoto || gubun == "2") {
			vo.userPhoto = "/images/kr/main/bestEmployee_pic_none.png";
		}

		if (typeof userInfoID == "undefined") {
			userInfoID = "";
		}

		var dateText = !vo.updateDate ? vo.writeDate.substring(0, 16) : vo.updateDate.substring(0, 16);

		if (replyDelFlag == 1) {
			dateText = "";
		}

		if (vo.replyLevel == "1" && replyDelFlag == 1) { // 삭제된 댓글
			boardCommentList += "<div id='commentIndex" + index + "' class='reNewalCmt delComment commentReact" + index + "' replyLevel='" + vo.replyLevel + "' boardUserID='" + vo.userID + "' memberID='"
				+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" + 1 + "'>";
			boardCommentList += "<span>" + vo.content + "</span></div>";
			continue;
		}

		var isReReply = !!vo.parentWriterName && vo.replyLevel >= "2"; // 대댓글이면 true, 일반댓글이면 false;
		if (isReReply) {
			boardCommentList += "<div id='commentIndex" + index + "' class='comment_list sub_comment_list reNewalCmt commentReact" + index + "' replyLevel='" + vo.replyLevel + "' boardUserID='" + vo.userID + "' memberID='"
				+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" + 1 + "' parentreplyid='" + vo.parentReplyID + "'>";
			boardCommentList += "<div class='icon_sub_comment'></div>";
			boardCommentList += "<div class='sub_comment_listcont'>";
			boardCommentList += "<div class='comment_list_text'>";
		} else {
			boardCommentList += "<div id='commentIndex" + index + "' class='comment_list reNewalCmt commentReact" + index + "' replyLevel='" + vo.replyLevel + "' boardUserID='" + vo.userID + "' memberID='"
				+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" + 1 + "'>";
			boardCommentList += "<div class='comment_list_text'><div class='user_poto'>";
            
            if (vo.userPhoto && vo.userPhoto != '/images/kr/main/bestEmployee_pic_none.png') {
			    boardCommentList += "<img src='/admin/ezOrgan/getPersonalInfo.do?fileName=" + vo.userPhoto + "'></div>";
            } else {
                boardCommentList += "<img src='" + vo.userPhoto + "'></div>";
            }
		}
		
		boardCommentList += "<div class='comment_list_textarea'>";
		
		// 댓글 작성자명
		if (gubun == "2" || mode == "print") {
			boardCommentList += "<span class='comment_name' style='cursor: default' >";
		} else {
			boardCommentList += "<span class='comment_name' onclick='OpenUserInfo(\"" + vo.userID + "\", \"" + vo.deptID + "\")' style='cursor: pointer;'> ";
		}
		if (isReReply) {
			boardCommentList += vo.userName + "<strong style='cursor: default;' onclick='event.stopPropagation();'>@" + vo.parentWriterName + "</strong></span>"
		} else {
			boardCommentList += vo.userName + "</span>";
		}

		// 댓글 작성일
		boardCommentList += "<span class='comment_day'>" + dateText + "</span>";
		
		// 댓글 본문 및 이모티콘
		boardCommentList += "<span class='comment_txt'>" + vo.content;
		if (!!vo.imageContent) {
			boardCommentList += "<br>";
			boardCommentList += "<img class='emoticon' src='" + vo.imageContent + "' style='margin-top:10px'/>";
		}
		boardCommentList += "</span>";

		// 첨부파일
		if (!!vo.replyAttach) {
			boardCommentList += "<span class='comment_attachFile'>"
			for (let i = 0; i < vo.replyAttach.length; i++) {
				var replyAttObjStr = insertCommentAttachDom(vo.replyAttach[i], mode, 'json').outerHTML;
				boardCommentList += replyAttObjStr;
			}
			boardCommentList += "</span>";
		}
		boardCommentList += "</div></div>";

		// 답글쓰기, 수정, 삭제 버튼
		boardCommentList += "<div class='comment_list_function'><div class='comment_list_btn'>";
		if (mode != "print") {
			boardCommentList += "<span class='replyWriteSpan" + index + "' onclick='replyOnclick(this, \"" + vo.replyID + "\", \"" + vo.userName + "\")'>" +strLangLGE01 + "</span>";
			if (!vo.userID && gubun == "2" && replyDelFlag == 0 || vo.userID == userInfoID ) {
				boardCommentList += "<span onclick='modifyBoardComment(this)'>" + strLangNewBoardDesign01 + "</span>";
				boardCommentList += "<span onclick='deleteBoardComment(this)'>" + strLangNewBoardDesign02 + "</span>";
			}
		}
		boardCommentList += "</div>";

		// 좋아요 / 싫어요
		if (reactFlag != null && reactFlag == "Y") {
            if (gubun != 2) {
			    boardCommentList += "<div><div class='likeDivBox'><span id=Y" + vo.replyID + " replyid=" + vo.replyID + " userid=" + vo.userID + " reactflag=Y index=" + index + " onclick='react_onclick(this)' class='likeButton' title='" + strLangNewBoardDesign03 + "'>";
            } else {
			    boardCommentList += "<div><div class='likeDivBox'><span id=Y" + vo.replyID + " replyid=" + vo.replyID + " userid=anonym reactflag=Y index=" + index + " onclick='react_onclick(this)' class='likeButton' title='" + strLangNewBoardDesign03 + "'>";
            }
			boardCommentList += "<img id='likeButtonImg' src='/images/like_on.png'><span id='likeCountSpan'>" + vo.re_like + "</span></span></div>"
			if (gubun != 2) {
                boardCommentList += "<div id='disLikeDiv'><span id=N" + vo.replyID + " replyid=" + vo.replyID + " userid=" + vo.userID + " reactflag=N index=" + index + " onclick='react_onclick(this)' class='disLikeButton' title='" + strLangNewBoardDesign04 + "'>";
			} else {
			    boardCommentList += "<div id='disLikeDiv'><span id=N" + vo.replyID + " replyid=" + vo.replyID + " userid=anonym reactflag=N index=" + index + " onclick='react_onclick(this)' class='disLikeButton' title='" + strLangNewBoardDesign04 + "'>";
			}
			boardCommentList += "<img id='disLikeButtonImg' src='/images/disLike_off.png'><span id='disLikeCountSpan'>" + vo.re_hate + "</span></span></div></div>";
		}
		boardCommentList += "</div></div></div>";
	}
	
    return boardCommentList;
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
		xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&itemID=" + encodeURIComponent(pItemID) + "&guBun=" + gubun, false);
		xmlhttp.send();
		xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(parentReplyID) + "&itemID=" + encodeURIComponent(pItemID) + "&guBun=" + gubun + "&flag=true", false);
		xmlhttp.send();
	} else {
		xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&itemID=" + encodeURIComponent(pItemID) + "&guBun=" + gubun, false);
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
	if (previewPageCheck(window.location)) {
		window.parent.getBoardList();
	}
}
//강민수92
function deleteBoardCommentPopup(obj) {
	delpReplyID = $(obj).closest(".reNewalCmt").attr("replyID");

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
	delpReplyID = $(obj).closest(".reNewalCmt").attr("replyID");
	delReplyLevel = $(obj).closest(".reNewalCmt").attr("replylevel");
	parentReplyID = $(obj).closest('.reNewalCmt').attr('parentreplyid');

	var replyID = "";

	if (delReplyLevel != "1" && !!parentReplyID) {
		if ($(obj).closest('.reNewalCmt').prev('.delComment') > 0) {
			delChildReply = 1; // 부모댓글이 삭제된 상태일 때
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
			} else if (delReplyLevel != "1" && result == 1 && delChildReply == 1) { // 부모가 삭제 되었고, 삭제할 자식 댓글이 마지막일 때
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
			xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&itemID=" + encodeURIComponent(pItemID) + "&guBun=" + gubun, false);
			xmlhttp.send();
			xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(parentReplyID) + "&itemID=" + encodeURIComponent(pItemID) + "&guBun=" + gubun + "&flag=true", false);
			xmlhttp.send();
		} else {
			xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&itemID=" + encodeURIComponent(pItemID) + "&guBun=" + gubun, false);
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
		if (previewPageCheck(window.location)) {
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
	
    var uploadFileElement = document.getElementById("uploadedFile");    
    var fileinfo = uploadFileElement.classList.contains("open") ? uploadFileElement.lastElementChild.getAttribute("_fileInfo") : null;
    var commentAttach = reply.id == 'childReplySaveBtn' ? makeBoardCommentAttachString("commentListFile") : makeBoardCommentAttachString("commentFile");
    /* 2019-11-05 홍승비 - 게시물 본문하단 댓글옵션 추가 */
    if (reply.id != 'childReplySaveBtn') {
    	if (OneLineReplyFlag == "1" || OneLineReplyFlag == "2") {
    		var text = document.getElementById('onelinereply').value.replace(/\s|　/gi, '');
            if (!text && !fileinfo) { // 모바일 댓글 빈글체크 조건 수정
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
		var parentReplyId = reply.closest('.reNewalCmt').getAttribute('parentreplyid');
		var parentWriterName = reply.closest('.reNewalCmt').getAttribute('parentwritername');
		var replyLevel = reply.getAttribute('replyLevel');

		content = MakeXMLString(document.getElementById('reReply').value);

		if (content.trim() == ""  && (fileinfo == null || fileinfo == "")) { // 모바일 댓글 빈글체크 조건 수정
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
				 parentWriterName : parentWriterName,
				 emoticonContent : fileinfo,
				 commentAttach : commentAttach
			   },
		success: function(){
			getBoardComment();
			$('#txtPassWord').val("");
			$('#commentAttach').text("");
			
			/* 2019-11-06 홍승비 - 게시물 미리보기 영역에서 댓글 작성 시 게시물 리스트 갱신 */
			if (previewPageCheck(window.location)) {
				window.parent.getBoardList();
			}
			
			/* 2021-06-23 홍승비 - 댓글알림 기능 추가 (댓글알림 시에 그룹사게시판 여부 파라미터는 필요없음) */
			sendBoardAlert("comment", pBoardID, pItemID, "");
			closeEmoticonPreview(); // 댓글 저장 후 이모티콘 미리보기 레이어 닫기
            var firstCommentAttach = document.getElementById("commentAttach");
            
            if (firstCommentAttach) {
                firstCommentAttach.classList = "";
            }
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
    AllEmoticonPanelClose();
    removeCloneModiCommet();    
    var commentElement = $(reply).closest(".comment_list");
    var replyTr = commentElement.attr('class').match(/commentReact\S*/)[0];
    console.log(replyTr);
	var parentReplyID = commentElement.attr("parentreplyid");
	var replyWriteSpan = $(reply).text(); // 답글쓰기
	var replyLevel = commentElement.attr('replylevel');

	if (parentReplyID != null) {
		replyID = parentReplyID;
	}

	var commentList = "";
	commentList += "<div class='tr" + replyTr + " comment_list sub_comment_list reNewalCmt' parentReplyId= '" + replyID +"' parentWriterName= '" + userName  + "'>";
    commentList += "<div class='icon_sub_comment'></div>";
    commentList += "<div class='sub_comment_listcont'>";
    
    if (gubun == 2) {
        commentList += "<div class='pw_area'><input type='password' id='childReplyPW' maxlength='20' size='20' placeholder='"+ strLangNewBoardDesign08 +"'></div>";
    }
    commentList += "<div class='comment_textarea'>"
    commentList += "<textarea id='reReply' name='textarea' rows='2' placeholder='" + strLangNewBoardDesign06 + "' maxlength='500' oninput='editAutoGrow(this)'></textarea></div>";
    
    if (attachmentFlag == "Y") {
        commentList += "<div id='commentListAttach'></div>";
    }
    
    commentList += "<div class='comment_function'><div>";
    commentList += "<span id='_addEmoticonRereply' class='btn_emoticon' onclick='addSticker(this)'>" + strLangNewBoardDesign05 + "</span>";
    
    if (attachmentFlag == "Y") {
        commentList += "<span class='btn_attachFile' onclick='btnfileup(\"commentListFile\");'>" + strLangNewBoardDesign07 + "</span>"
    }
    
    commentList += "</div><div>";
    commentList += "<button id='childReplySaveBtn' class='btn_registration' replyLevel=" + (parseInt(replyLevel) + 1) + " onclick='Save_OneLineReply(this)'>" + strLangLGE03 + "</button>";
    commentList += "<button class='btn_registration' onclick='removeCloneModiCommet()'>" + strLangLGE04 + "</button>";
    commentList += "</div></div></div></div>"

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
function modifyBoardComment(obj) {
	AllEmoticonPanelClose();
    removeCloneModiCommet();
    $(".modifyClickEvent").removeClass("modifyClickEvent");
    $(obj).addClass("modifyClickEvent");
    var basePanel = $(obj).parents(".reNewalCmt");
    
    originalCommentClone(basePanel);
    
    var parentreplyid = basePanel.attr("parentreplyid");
    var replyLevel = basePanel.attr("replyLevel");
    
    var uploadedEmoticonPanel = $('#uploadedFile'); // 삽입이모티콘팝업 레이어
    var emoticonSrc = basePanel.find('.emoticon').length > 0 ? $(obj).parents('.reNewalCmt').find('.emoticon').attr('src') : ""; // 댓글에 이미 삽입되어있던 이모티콘
	var replyID = basePanel.attr('replyID');
	var replyLevel = basePanel.attr('replylevel');
	var memberId = basePanel.attr('memberid');
	var boarduserId = basePanel.attr('boarduserid');
    var content = basePanel.find('.comment_txt').text();
    var editFileList = getEditFileList(basePanel.find('.commentFileSpan'));

    var color = "";
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
        
        var modifyTextarea = "";
        
        if (!!parentreplyid && replyLevel >= "2") {
            modifyTextarea += "<div class='icon_sub_comment'></div>";
            modifyTextarea += "<div class='sub_comment_listcont'>";
        }
        
		modifyTextarea += "<div id='reReplyArea' class='comment_textarea'>";
		modifyTextarea += "<textarea rows='3' name='textarea' class='modifyText' maxlength='500' placeholder='" + strLangNewBoardDesign06 + "'oninput='editAutoGrow(this)'>" + content + "</textarea>";
        modifyTextarea += "</div>";
        
        if (attachmentFlag == "Y") {
            modifyTextarea += "<div id='commentListAttach'></div>";
        }
        
        modifyTextarea += "<div class='comment_function'><div>";
        modifyTextarea += "<span id='_addEmoticonModify' class='btn_emoticon' onclick='addSticker(this)'>" + strLangNewBoardDesign05 + "</span>";
        
        if (attachmentFlag == "Y") {
            modifyTextarea += "<span onclick='btnfileup(\"commentListFile\");' class='btn_attachFile'>" + strLangNewBoardDesign07 + "</span>"
        }
        
        modifyTextarea += "</div>";
        modifyTextarea += "<div>";
        modifyTextarea += "<button class='btn_registration' onclick='modiReplySave(this);' replyModifyFlag -= 1;'>" + strLangLGE03 + "</button>";
        modifyTextarea += "<button class='btn_registration cancelComment' onclick='getBoardComment();' replyModifyFlag -= 1;'>" + strLangLGE04 + "</button>";
        modifyTextarea += "</div></div></div></div></div>";
        
        if (!!parentreplyid && replyLevel >= "2") {
            modifyTextarea += "</div>";
        }
        
		if (replyModifyFlag == 0) {
			replyModifyFlag += 1;
		} else if (replyModifyFlag > 0) { // 댓글수정 창이 열려있는 경우 창을 닫아줌
			$('#' + replyModifyId).html(replyTextarea);
			$('#' + replyModifyId).next('td').css('border-bottom', 'hidden');
			$('#' + replyModifyId).closest('tr').next('tr').css('display', '');
		}
        
		var basePanelComment = $(obj).parents('.comment_list');
        
        basePanelComment.html(modifyTextarea);
        $('.modifyText').focus();
        $('.modifyText').prop('selectionStart', content.length);
		editAutoGrow($('.modifyText')[0]);

        var reReplyArea = $("#reReplyArea");

        if (!!emoticonSrc) {    
            reReplyArea.append(uploadedEmoticonPanel); // 삽입이모티콘팝업 레이어 삽입
            if (previewPageCheck(location) || commentPopupPageCheck(location)) {                
                uploadedEmoticonPanel.addClass('down');
            } else {
               uploadedEmoticonPanel.addClass('up');
            }
            openEmoticonPreview(emoticonSrc);
        }
        
        if (attachmentFlag == "Y") {
            if (editFileList.length > 0) {
                $("#commentListAttach").addClass("comment_attachFile");
            }
            for(let i=0; i<editFileList.length; i++) {
                var item = editFileList[i];
                var fileDomObj = insertCommentAttachDom(item, "edit", "json");
                basePanelComment.find("#commentListAttach").append(fileDomObj);
            }
        }
    }
}

/* 2023-03-27 이가은 - 댓글 수정 후 등록 버튼 온클릭 메서드 */
function modiReplySave(reply) {
    var basePanel = $(reply).closest('.reNewalCmt');
	var pReplyID = basePanel.attr('replyid');
	var text = basePanel.find('.modifyText').val();  
    var fileinfo = $("#uploadedFile").hasClass('open') ? $("#previewImage").attr("_fileInfo") : null
    var commentAttach = makeBoardCommentAttachString("commentListFile");
    
	if (!text.trim() && !fileinfo) {
		alert(strLang182);
		$('.modifyText').focus();
		replyModifyFlag += 1;
		return;
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
			content	: text,
			imageContent : fileinfo,
			commentAttach : commentAttach
		},
		success: function(result){
			getBoardComment();

			if (previewPageCheck(window.location)) {
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
	delpReplyID = $(obj).closest(".reNewalCmt").attr("replyID");

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
    
    AllEmoticonPanelClose();
    removeCloneModiCommet();   

	var obj = $(".modifyClickEvent");
	var color = replyModifyArray[1];
	var content = replyModifyArray[2];
	// 2023-11-07 전인하 - 댓글에 이미 삽입되어있던 이모티콘을 저장
	var basePanel = $(obj).closest('.reNewalCmt'); // TR 선택
	
    originalCommentClone(basePanel);
    
	var replylevel = basePanel.attr("replylevel");
	var basePanelComment = basePanel.find('.comment_textarea');
	var uploadedEmoticonPanel = $('#uploadedFile'); // 삽입이모티콘팝업 레이어
    var emoticonSrc = basePanel.find('.emoticon').length > 0 ? $(obj).parents('.reNewalCmt').find('.emoticon').attr('src') : ""; // 댓글에 이미 삽입되어있던 이모티콘
    var editFileList = getEditFileList(basePanel.find('.commentFileSpan'));

    // 2023-11-07 전인하 - 답글수정 레이어에 id 값 삽입, 이모티콘 아이콘 삽입
    var modifyTextarea = "";
    
    if (replylevel == 1){
        modifyTextarea +=  "<div id='reReplyArea' class='comment_textarea'>";
        modifyTextarea += "<textarea class='modifyText' rows='3' name='textarea' maxlength='500' oninput='editAutoGrow(this)' placeholder='" + strLangNewBoardDesign06 + "'>" + content + "</textarea></div>"
        
        if (attachmentFlag == "Y") {
            modifyTextarea += "<div id='commentListAttach' class='commentListAttach'></div>"
        }
        
        modifyTextarea += "<div class='comment_function'>";
        modifyTextarea += "<div><span id='_addEmoticonModify' class='btn_emoticon' onclick='addSticker(this)'>" + strLangNewBoardDesign05 + "</span>";
        modifyTextarea += "<span class='btn_attachFile' onclick='btnfileup(\"commentListFile\");'>" + strLangNewBoardDesign07 + "</span></div>";
        modifyTextarea += "<div><button class='btn_registration' onclick='modiReplySave(this); replyModifyFlag -= 1;'>" + strLangLGE03 + "</button>";
        modifyTextarea += "<button class='btn_registration' onclick='getBoardComment(); replyModifyFlag -= 1;'>" + strLangLGE04 + "</button></div>";
    } else {
        modifyTextarea += "<div class='icon_sub_comment'></div>";
        modifyTextarea += "<div class='sub_comment_listcont'>";
        modifyTextarea += "<div id='reReplyArea' class='comment_textarea'>";
        modifyTextarea += "<textarea class='modifyText' rows='3' name='textarea' maxlength='500' oninput='editAutoGrow(this)' placeholder='" + strLangNewBoardDesign06 + "'>" + content + "</textarea></div>"
        
        if (attachmentFlag == "Y") {
            modifyTextarea += "<div id='commentListAttach' class='commentListAttach'></div>"
        }
        
        modifyTextarea += "<div class='comment_function'>";
        modifyTextarea += "<div><span id='_addEmoticonModify' class='btn_emoticon' onclick='addSticker(this)'>" + strLangNewBoardDesign05 + "</span>";
        modifyTextarea += "<span class='btn_attachFile' onclick='btnfileup(\"commentListFile\");'>" + strLangNewBoardDesign07 + "</span></div>";
        modifyTextarea += "<div><button class='btn_registration' onclick='modiReplySave(this); replyModifyFlag -= 1;'>" + strLangLGE03 + "</button>";
        modifyTextarea += "<button class='btn_registration' onclick='getBoardComment(); replyModifyFlag -= 1;'>" + strLangLGE04 + "</button></div></div>";
    }

	replyModifyId = basePanelComment.attr('id');
    replyTextarea = basePanelComment.html();
    basePanel.html(modifyTextarea);
    $('.modifyText').focus();
    $('.modifyText').prop('selectionStart', content.length);
	editAutoGrow($('.modifyText')[0]);
	
    if (!!emoticonSrc) {    
	    // 2023-11-07 전인하 - 댓글 수정 시 이모티콘 동작
        $("#reReplyArea").append(uploadedEmoticonPanel);
    // 수정하고자 하는 댓글에 원래 삽입되어있던 이모티콘이 존재하였을 시 해당 이모티콘을 기억하여 이모티콘 미리보기 레이어에 표출함
        if (previewPageCheck(location) || commentPopupPageCheck(location)) {
            uploadedEmoticonPanel.addClass('down');
        } else {
           uploadedEmoticonPanel.addClass('up');
        }
        openEmoticonPreview(emoticonSrc);
    }
    
    for (let i = 0 ; i < editFileList.length ; i++) {
        var item = editFileList[i];
        var fileDomObj = insertCommentAttachDom(item, "edit", "json");
        basePanelComment.find("#commentListAttach").append(fileDomObj);
    }
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

 // 2023-10-31 전인하 - 이모티콘 삽입 공통함수. 투표모듈에 삽입된 것을 수정해서 씀
function addSticker(obj) {
    var basePanel = $(obj).closest('.reNewalCmt'); // 이모티콘 판넬 위치 잡는 댓글 영역
    var insertChkEmoticon = $(obj).closest('.reNewalCmt').find('.comment_textarea'); // 이모티콘 선택 후 확인 영역
    
    if (obj.id == "_addEmoticonModify") {
        basePanel.css("position", "relative");
    } else if (obj.id == "_addEmoticonRereply") {
        // var reReplyClassName = "." + $(obj).parents('div').attr('class');
        // if (gubun == 2 && (previewPageCheck(location) || commentPopupPageCheck(location))) {
        //     basePanel = $(reReplyClassName).eq(1);
        // } else {
        //     basePanel = $(reReplyClassName).eq(0);
        // }
         basePanel.css("position", "relative");
    }
    
    var emoticonListPanel = $("#emoticonPanel"); // 이모티콘 레이어
    var uploadedEmoticonPanel = $("#uploadedFile"); // 삽입이모티콘팝업 레이어
    
    if (previewPageCheck(location) || commentPopupPageCheck(location)) {
        emoticonListPanel.addClass('down');
        uploadedEmoticonPanel.addClass('down');
    } else {
        emoticonListPanel.addClass('up');
        uploadedEmoticonPanel.addClass('up');
    }
    
    basePanel.append(emoticonPanel);
    insertChkEmoticon.append(uploadedEmoticonPanel);
    emoticonListPanel.toggleClass('open');
}

// 2023-11-09 전인하 - 이모티콘 그룹 변경
function changeStickerGroup(obj) {		 
    stickerIndex = obj.id.charAt(obj.id.length-1);  // 방금 선택된 index	
    
    for (let i=0; i<stickerGroup.length; i++) {
        document.getElementById("_group" + i).style.backgroundColor  = "#fff";
        document.getElementById("_listG" + i).style.display = "none";
    }
    
    obj.style.backgroundColor  = "#d9d9d9";
    document.getElementById("_listG" + stickerIndex).style.display = "block";
    checkScrollBars();
}

// 2023-11-09 전인하 - 삽입할 이모티콘 미리보기 보여주기
function displaySticker(obj) {				    	
    var style = obj.currentStyle || window.getComputedStyle(obj, false);
    var bgImage = style.backgroundImage.slice(4, -1);
    var actualUrl = "";
    
    if (bgImage.slice(-1) === '"') {		    		
        actualUrl = bgImage.slice(bgImage.indexOf("/images/"), -1);
    }
    else {		    		
        actualUrl = bgImage.slice(bgImage.indexOf("/images/"));
    }		    				   	    		    	

    closeEmoticonPanel();
    openEmoticonPreview(actualUrl);
}

// 2023-11-09 전인하 - 화살표 사용하여 이모티콘 그룹 변경
function showNextGroupSticker(obj) {
    if (obj.id == "nextEmoticon") {
        stickerIndex++;
    } else {
        stickerIndex--;
    }
    
    if (stickerIndex <= -1) {
        stickerIndex = 0;
    }
    
    if (stickerIndex >= stickerGroup.length) {
        stickerIndex = stickerGroup.length - 1;
    }
    
    for (let i=0; i<stickerGroup.length; i++) {
        document.getElementById("_group" + i).style.backgroundColor  = "#fff";
        document.getElementById("_listG" + i).style.display = "none";
    }
    
    document.getElementById("_group" + stickerIndex).style.backgroundColor  = "#d9d9d9";
    document.getElementById("_listG" + stickerIndex).style.display = "block";
    
    checkScrollBars();
}

function checkScrollBars() {		
    if (document.getElementById("_listG" + stickerIndex + "Table").scrollHeight > 320) {
        document.getElementById("emoticonPanel").style.width = "440px";
    }
}

// 2023-11-09 전인하 - 이모티콘 미리보기 끄기
function closeEmoticonPreview() {
    $("#uploadedFile").removeClass('open');
    $("#uploadedFile").appendTo("#basePanel");
}

function openEmoticonPreview(src) {
    $('#previewImage').attr("_fileInfo", src);
    $('#previewImage').attr("src", src);
    if (!$("#uploadedFile").hasClass('open')) {
        $("#uploadedFile").addClass('open');
    }
}

function closeEmoticonPanel() {
    $('#emoticonPanel').removeClass('open');
}

// 2023-11-07 전인하 - 이모티콘 레이어 레이아웃 초기화 작업
function AllEmoticonPanelClose() {
   $('#basePanel').append($('#emoticonPanel'));
   $('#basePanel').append($('#uploadedFile'));
   $('#previewImage').attr('src', '');
   $('#previewImage').attr('_fileinfo', '');
   $('#emoticonPanel').removeClass('open');
   $('#uploadedFile').removeClass('open');
}

function previewPageCheck(location) {
    var returnPreviewCheck = location.pathname.indexOf("Preview") > -1 || location.pathname.indexOf("PreView") > -1;
    return returnPreviewCheck;
}

function commentPopupPageCheck(location) {
	var popupCommentCheck = location.pathname.indexOf("boardCommentPopup.do") > -1;
	return popupCommentCheck;
}

// 2023-11-09 전인하 - 이모티콘 레이어 초기생성 함수
function makeEmoticonPanel() {
    var _ePresentorsContent = "";
    var emoticonListContent = "";
    for (let i = 0; i < stickerGroup.length; i++) {
        var sticker = stickerGroup[i];
        var stickerName = sticker.split(";")[0];
        var stickerNum = sticker.split(";")[1];
        var stickerFilenameExtension = sticker.split(";")[2];
        var rowEmoticonCount = stickerFilenameExtension == "bmp" ? 7 : 4;
        if (stickerName == "etc") {
            rowEmoticonCount = 7;
        }
        
        if (i == 0) {
            _ePresentorsContent += "<div id='_group" + i + "' style='background-color: #d9d9d9; float:left; display: block; height:45px; width:45px; cursor: pointer; ' onclick='changeStickerGroup(this);'><img src='/images/emoticon/" + stickerName + ".png' height=30 width=30 style='padding-top: 7px; padding-left: 7px; '></div>"    
            emoticonListContent += "<div id='_listG" + i + "' style='height:310px; overflow-y: auto; overflow-x: hidden; display: block;'>"
        } else {
            _ePresentorsContent += "<div id='_group" + i + "' style='float:left; display: block; height:45px; width:45px; cursor: pointer;' onclick='changeStickerGroup(this);'><img src='/images/emoticon/" + stickerName + ".png' height=30 width=30 style='padding-top: 7px; padding-left: 7px; '></div>"
            emoticonListContent += "<div id='_listG" + i + "' style='height:310px; overflow-y: auto; overflow-x: hidden; display: none;'>"
		}
		
        emoticonListContent += "<table id='_listG" + i + "Table'>"
        stickerGroupRowNum = stickerNum / rowEmoticonCount;
		
        for (let j = 0 ; j < stickerGroupRowNum ; j++) {
            emoticonListContent += "<tr style='width:100%; height:45px;'>"
            for (let k = 1; k <= rowEmoticonCount; k++) {
                var indexParam = j * rowEmoticonCount + k;
                if (indexParam > stickerNum) {
                    break;        
                }
                indexParam = indexParam.toString().padStart(3, "0");

                var imageUrl = "";
                imageUrl = "/images/emoticon/" + stickerName + "/1set" + indexParam + "." + stickerFilenameExtension;
                emoticonListContent += "<td><div class='emoticon' style='background-image: url(" + imageUrl + ");' onclick='displaySticker(this);'></div></td>";
            }
            emoticonListContent += "</tr>"
        }
        emoticonListContent += "</table></div>"
    }
    
    $("#_ePresentors").html("");
    $("#_ePresentors").append(_ePresentorsContent);
    
    $("#emoticonList").html("");
    $("#emoticonList").append(emoticonListContent);
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

// 2024-08-23 전인하 - 게시판 > 게시물 작성 > 키워드 삭제
function removeKeyword(event) {
    var keywordObj = event.target.parentElement;
    keywordObj.remove();
    keywordArr = [];
    var keywordObjList = document.querySelectorAll(".keywordSpanView");
    if (keywordObjList.length > 0) {
        for (let i = 0 ; i < keywordObjList.length ; i++) {
            var keyObj = keywordObjList[i];
            keywordArr.push(keyObj.id);
        }
    }
    
    if (keywordArr.length < 10) {
        document.querySelector('#txtKeyword').style.display = '';
    }
}

// 2024-08-23 전인하 - 게시판 > 게시물 작성 > 키워드 textInput 키보드 동작
function keyword_onkeyUp(event) {
    var keyCode = event.key;
    var inputDom = event.target;
    
    if (!characterCheckForKeyword(inputDom)) {
        return;
    }
	
	if (keyCode == "Delete") {
		inputDom.value = "";
		return;
	}
	
    if (keyCode == "Enter" || keyCode == " " || keyCode == "Tab") {
		handleKeywordInput(event);
    }
}

function keyword_blur(event) {
    var inputDom = event.target;
	
	if (!characterCheckForKeyword(inputDom)) {
        return;
    } else {
		handleKeywordInput(event);
	}
}

function handleKeywordInput(event) {
    var inputDom = event.target;
    var inputText = inputDom.value.trim();
	
	 // 빈 값이거나 이미 최대 개수면 리턴
    if (inputText === "" || keywordArr.length >= 10) {
		inputDom.value = "";
        return;
    }
	
	// 키워드 배열에 추가
	keywordArr.push(inputText);
	
	// 키워드 span 추가
	var keywordObj = makeKeywordSpanObj(inputText, "edit");
	inputDom.before(keywordObj);
	inputDom.value = "";		 
	
	// 키워드 10개 넘어가면 입력 불가 처리
	if (keywordArr.length >= 10) {
		inputDom.style.display = 'none';
	}
}

// 2024-08-23 전인하 - 게시판 > 게시물 작성 > 키워드 span 삽입
// key : 키워드 이름 / mode: edit/view (edit는 삭제 버튼 존재)
function makeKeywordSpanObj(key, mode) {
   var keyObj = document.createElement("span");
   keyObj.innerText = key;
   keyObj.id = key;
   keyObj.className = 'keyword_tag keywordSpanView';

   // 키워드 삭제 img 삽입
   if (mode == "edit") {
       var deleteX = document.createElement("button");
       deleteX.className = "keyword_delete keywordDeleteBtn";
       deleteX.addEventListener('click', removeKeyword);
       keyObj.appendChild(deleteX);
   } else if (mode == "view") {
       keyObj.className = 'keyword_tag keywordSpan';
       keyObj.addEventListener('click', onclickKeyword);
   } else if (mode == "print") {
       // 동작없음
   }
   
   return keyObj;
} 

// 2024-08-23 전인하 - 게시판 > 포토, 썸네일, 동영상 게시물 작성 > 키워드 리스트 배열로 반환 
function getKeywordListByView() {
    var keywordArr = [];
    var keywordObjList = document.querySelectorAll(".keywordSpan");
    if (keywordObjList.length > 0) {
        for (let i = 0 ; i < keywordObjList.length ; i++) {
            var keyObj = keywordObjList[i];
            keywordArr.push(keyObj.id);
        }
    }
    return keywordArr;
}

// 2024-08-26 전인하 - 삽입되면 안되는 특문을 입력제한처리
function characterCheckForKeyword(obj) {
    var regExp = /[\\'\"<>#]/gi;

    if (regExp.test(obj.value)) {
        alert(strLangKeywordJIH01);
        obj.value = obj.value.replace(regExp, '');
        return false;
    }
    return true;
}

// 2024-08-27 전인하 - 게시판 > 키워드 클릭 > 키워드 서치 동작
function onclickKeyword(event) {
    var key = event.target.id;
    var url =  "/ezBoard/boardSearchView.do?type=KEYWORDCLICK&data=" + encodeURIComponent(key);
    GetOpenWindow(url, "_blank", 1000, 550, "yes");
}

// 게시판 > 키워드 클릭 > 키워드 영역 포커스
function keywordInput(inputId) { 
	document.getElementById(inputId).focus(); 
}

/* 2024-10-17 전인하 - 게시판 댓글 정렬 기준 클릭 메소드 */
function boardCommentSort() {
    var sortBtn = event.target.id;
    
    if (sortBtn == "earliest") {
        document.getElementById("earliest").classList = "tabon";
        document.getElementById("latest").classList = "";
        commentSort = "earliest";
    } else if (sortBtn == "latest") {
        document.getElementById("earliest").classList = "";
        document.getElementById("latest").classList = "tabon";
        commentSort = "latest";
    }
    
    getBoardComment();
}

// mode: comment / commentReply
function fileupload(mode) {
    var fd = new FormData();
    var fileList = [];
    
    // 파일명 체크
    for (var i = 0; i < file.length; i++) {
        var fnl = file[i].name.length;
        if (file[i].name.lastIndexOf('.') != -1) { // 2024-02-13 확장자 제외 파일명 길이를 체크
            fnl = file[i].name.lastIndexOf('.');
        }
        if (fnl > attachFileNameMaxLength) {
            alert(strLangAttachJIH02 + attachFileNameMaxLength + strLangAttachJIH03);
            document.getElementById("file").value = "";
            
            return;
        } else {
            fd.append("fileToUpload", file[i]);
        }
    }
    fd.append("boardID", pBoardID);
    fd.append("maxSize", attachLimit * 1024 * 1024);
    fd.append("mode", "ATT");
    
    $.ajax({
        type : "POST",
        dataType : "text",
        async : true,
        url : "/ezBoard/uploadItemAttach.do",
        contentType: false,
        processData: false,        			
        data : fd,
        success: function(fileXML) { 
            if (returnvalueCommentFile(fileXML)) { // 에러 판별
                var xmlParser = new DOMParser();
                var xmlDoc = xmlParser.parseFromString(fileXML, "text/xml");
                var fileListXml = xmlDoc.getElementsByTagName("NODE");
                for (let i=0; i<fileListXml.length; i++) {
                    var fileDomObj = insertCommentAttachDom(fileListXml[i], "edit", "xml");
                    var attachListDom = mode == "commentFile" ? document.querySelector("#commentAttach") : document.querySelector("#commentListAttach");
                    attachListDom.append(fileDomObj);
                    attachListDom.classList = "comment_attachFile";
                }
            }
			// 업로드 후 file input 객체 초기화
			document.getElementById(mode).value = null;
        },
        error : function(e) { 
            console.log(e); 
        }
    });	
}

function filechange(event) {
    var fileInputId = event.target.id;
    if (!document.getElementById(fileInputId).value == "") {
        file = new Array;
    
        var filelist = document.getElementById(fileInputId).files;
        
        var tempfilesize = 0;
        var filecnt = file.length;
        
        /* 2023-08-16 홍승비 - 게시물에 첨부파일 추가 시, 파일 사이즈의 총합을 계산하는 첨부파일 크기제한 로직 수정 */
        for (var i = 0; i < filelist.length; i++) {
            // 기존 첨부파일 사이즈 + 루프 내부에서 계산한 첨부파일 사이즈를 크기제한 사이즈와 비교 
            if (((totalFileSize + tempfilesize + parseInt(filelist[i].size)) / 1024 / 1024) > attachLimit) {
                if ("${userInfo.lang}" == "2") {
                    alert(strLang8 + attachLimit + strLang9);
                } else {
                    alert(strLang8 + attachLimit + "MB" + strLang9);
                }
                
                // 첨부파일 크기제한 초과 시, 첨부를 시도한 파일은 전부 초기화
                document.getElementById(fileInputId).value = "";
                return;
            } else {
                file[filecnt + i] = filelist[i];
                tempfilesize += filelist[i].size;
            }
        }    
        totalFileSize += tempfilesize;        
        fileupload(fileInputId);
    }
}

function uploadComplete(evt) {
    window.parent.returnvalue(xhr.responseText);
    
    var strRet = "";
    var pBoardID = window.parent.pBoardID;
    var filecnt = document.getElementById("filelist").childNodes.length;
    
    /* 2021-04-29 홍승비 - 새로운 첨부파일 업로드 완료 후, 파일경로(DATA2) 속성을 갱신하도록 수정 */
    for (var i = 0; i < filecnt - 1; i++) {
        var filepath = document.getElementById("filelist").childNodes[i + 1].getAttribute("DATA2");
        if (filepath.indexOf(pBoardID) != -1) {
            strRet += filepath + "|";
        } else {
            var tempUploadFileStr = '';
            if (filepath.split('/')[0]  != "tempUploadFile") {
                tempUploadFileStr = 'tempUploadFile/';
            }
            strRet += tempUploadFileStr + filepath + "|";
            document.getElementById("filelist").childNodes[i + 1].setAttribute("DATA2", tempUploadFileStr + filepath);
        }
    }
    window.parent.attachxml = strRet;
    
    if (CrossYN()) {
        document.getElementById("file").value = "";
    } else {
        document.getElementById("file").type = "text";
        document.getElementById("file").type = "file";
    }
}

function returnvalueCommentFile(strXML) {
    var xml = loadXMLString(strXML);
    var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
    var extFlag = false;
    
    for (var i = 0; i < nodes.length; i++) {
        if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") { // RESULTUPLOADA
            if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) { // 빈파일 업로드
                alert(strLang6); 
                return false;
            }
        } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied") { // 제한확장자
            alert(strLang54);
            return false;
        } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") { // 오버플로우
            alert(strLang8 + attachLimit + "MB" + strLang9);
            return false;
        } else {
            alert(strLangAttachJIH04);
            return false;
        }
    }
    return true;
}

function btnfileup(mode) {
    if (mode == "commentFile") {
        $("#commentListAttach").removeClass("comment_attachFile");
        $("#commentListAttach").children().remove();
    } else if (mode == "commentListFile") {
        $("#commentAttach").removeClass("comment_attachFile");
        $("#commentAttach").children().remove();
    }
    document.getElementById(mode).click();
}

/* 2023-08-16 홍승비 - 현재 게시물의 첨부파일 사이즈 총합을 계산하여 filesize 변수에 설정하는 함수 */
function initAttachFileSize() {
    totalFileSize = 0; // 첨부파일 사이즈 전역변수 초기화
    var attachListTR = $("#filelist tr");
    
    $.each(attachListTR, function(index, item) {
        var pRealFileSize = item.getAttribute("realFileSize");
        
        if (typeof(pRealFileSize) != "undefined" && pRealFileSize != null) {
            totalFileSize += parseInt(item.getAttribute("realFileSize"));
        }
    });
}

// 댓글 첨부파일 삭제 메소드
function delCommentFile() {
  var fileCommentObj = event.target.parentElement;
  var fileAttachArea = event.target.closest("div");
  fileCommentObj.remove();
  
  if (fileAttachArea && fileAttachArea.classList.contains("comment_attachFile") && fileAttachArea.childElementCount == 0) {
    fileAttachArea.classList = "";
  }
}

// 댓글 첨부파일 dom객체 생성 메소드
// mode: view, edit (view는 다운가능, edit은 삭제 가능)
// dataType : file 변수의 데이터타입 (json, xml)
function insertCommentAttachDom(file, mode, dataType) {
    var fileRtnObj = document.createElement("span");
    var tmpName = dataType == "xml" ? file.getElementsByTagName("PFILENAME")[0].textContent : file.fileName;
    var tmpSize = dataType == "xml" ? file.getElementsByTagName("FILESIZE")[0].textContent : file.fileSize;
    var uploadHref = dataType == "xml" ? file.getElementsByTagName("FILELOCATION")[0].textContent : file.filePath;
    var fileTypeImg = document.createElement("img");
    var fileInsertBtn = document.createElement("a");
    
    if (uploadHref.includes(".jpg") || uploadHref.includes(".jpeg") || uploadHref.includes(".bmp") || uploadHref.includes(".gif") || uploadHref.includes(".png") || uploadHref.includes(".tif") || uploadHref.includes(".tiff") || uploadHref.includes(".jpeg")) {
        fileTypeImg.src = "/images/image.svg";
    } else if (uploadHref.includes(".doc")) {
        fileTypeImg.src = "/images/doc.svg";
    } else if (uploadHref.includes(".xls") || uploadHref.includes(".xlsx")) {
        fileTypeImg.src = "/images/xls.svg";
    } else if (uploadHref.includes(".ppt") || uploadHref.includes(".pptx") || uploadHref.includes(".pps") || uploadHref.includes(".ppsx")) {
        fileTypeImg.src = "/images/ppt.svg";
    } else if (uploadHref.includes(".txt")) {
        fileTypeImg.src = "/images/txt.svg";
    } else if (uploadHref.includes(".zip")) {
        fileTypeImg.src = "/images/zip.svg";
    } else if (uploadHref.includes(".pdf")) {
        fileTypeImg.src = "/images/pdf.svg";
    } else if (uploadHref.includes(".ecm")) {
        fileTypeImg.src = "/images/ecm.svg";
    } else if (uploadHref.includes(".hwp") || uploadHref.includes(".hwpx")) {
        fileTypeImg.src = "/images/hwp.svg";
    } else {
        fileTypeImg.src = "/images/etc.svg";
    }
    
    tmpName = ReplaceHTML(tmpName);
    
    fileInsertBtn.classList = "btn_attach_download";
    fileRtnObj.textContent = "";
    fileRtnObj.className = "commentFileSpan";
    fileRtnObj.setAttribute("uploadHref", uploadHref);
    fileRtnObj.setAttribute("realFileSize", tmpSize);
    fileRtnObj.setAttribute("name", tmpName);
    if (mode == "view") {
        var href = "/ezBoard/boardAttachDown.do?filePath=" + encodeURIComponent(file.filePath) + "&fileName=" + encodeURIComponent(file.fileName);
        fileRtnObj.setAttribute("href", href);
        fileRtnObj.appendChild(fileTypeImg);
        fileRtnObj.append(tmpName + " (" + calculateAttachSize(tmpSize) + ")");
        fileInsertBtn.setAttribute("href", href);
        fileRtnObj.appendChild(fileInsertBtn);
    }
    
    if (mode == "print") {
        fileRtnObj.appendChild(fileTypeImg);
        fileRtnObj.append(tmpName + " (" + calculateAttachSize(tmpSize) + ")");
    }

   if (mode == "edit") {
       var deleteX = document.createElement("button");
       deleteX.className = "btn_attach_delete";
       deleteX.addEventListener('click', delCommentFile);
       fileRtnObj.appendChild(fileTypeImg);
       fileRtnObj.append(tmpName + " (" + calculateAttachSize(tmpSize) + ")");
       fileRtnObj.appendChild(deleteX);
   }
   // fileRtnObj.append(document.createElement("br"));
   return fileRtnObj;
}

// nodes to jsonArray
function getEditFileList(nodes) {
    var fileList = [];
    for(let i=0; i<nodes.length; i++) {
        var node = nodes[i];
        var file = {
            fileName : ReplaceHTML(node.getAttribute('name')),
            fileSize : node.getAttribute('realFileSize'),
            filePath : node.getAttribute('uploadHref')
        };
        fileList.push(file);
    }
    return fileList;
}

// 파일 크기 계산하여 텍스트로 표출 (사용자에게 보여주는 용도)
function calculateAttachSize(thisFileSize) {
    if (thisFileSize / 1024 / 1024 > 1) {
        thisFileSize = (Math.floor(parseFloat(thisFileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
    }
    else if (thisFileSize / 1024 > 1) {
        thisFileSize = (Math.floor(parseFloat(thisFileSize / 1024 * 10)) / 10).toFixed(1) + "KB";
    }
    else {
        thisFileSize = thisFileSize + "B";
    }
    return thisFileSize;
}

// 컨트롤러에 넘길 댓글첨부 string 구성
function makeBoardCommentAttachString(mode) {
    var strRet = "";
    var filepath = "";
    if (attachmentFlag == "Y") {
        var boardCommentAttachDomList = mode == "commentFile" ? document.querySelector("#commentAttach").children : document.querySelector("#commentListAttach").children;
        for (let i=0; i<boardCommentAttachDomList.length; i++) {
            var item = boardCommentAttachDomList[i];
            strRet += item.getAttribute("name") + ":" + item.getAttribute("uploadHref") + "|";
        }
        return strRet;
    } else {
        return "";
    }
}

// 별점 평가하기 시작
function clickRatingButton() {
	document.querySelectorAll('#ratingContainer label img').forEach((img) => {
		img.src = '/images/ImgIcon/view-flag.gif';
	});

	document.querySelectorAll('#ratingContainer input[type=radio]').forEach((radio, index, radios) => {
		if (radio.checked) {
			for (let i = 0; i <= index; i++) {
				let label = radios[i].nextElementSibling;
				if (label) {
					label.src = '/images/ImgIcon/icon-flag.gif';
				}
			}
		}
	});
}

function clickSaveRatingButton() {
	const selectedRating = document.querySelector('#ratingContainer input[type=radio]:checked');
	
	if (!selectedRating) {
		alert(strLangLHR001);
		return;
	}

	const ratingValue = selectedRating.value;
	
	if (selectedRating.value === rating) {
		alert(strLangLHR002);
		return;
	}
	
	saveRating(ratingValue);
}

function saveRating(selectedRating) {
	var isReRated = rating !== '0' ? "Y" : "N"; // 재평가 여부
	
	$.ajax({
		type : "GET",
		url : "/ezBoard/saveItemStarRating.do",
		data : {
			itemID : pItemID,
			updateRating : selectedRating,
			isReRated : isReRated
		},
		success : function(result) {
			if (result.status === "success") {
				alert(strLangLHR003);
				// 총점 및 평균 점수를 UI에 업데이트
				$("#totalRaters").text(result.totalRaters);
				// $("#avgScore").text(result.averageScore);
				$("#avgScore b").html(result.averageScore);
				rating = selectedRating; // 성공적으로 업데이트된 별점을 현재 상태로 업데이트
			} else {
				alert("<spring:message code = 'ezBoard.t181'/>");
				restoreRating();
			}
		},
		error : function(e) {
			alert("<spring:message code = 'ezBoard.t181'/>");
			console.log(e);
			restoreRating();
		}
	});
}

function restoreRating() {
	// 현재 별점 상태를 기준으로 별점 UI 복원
	const allStars = document.querySelectorAll('#ratingContainer input[type=radio]');
	allStars.forEach(star => {
		if (star.value <= rating) {
			star.checked = true;
			star.nextElementSibling.firstElementChild.src = "/images/ImgIcon/icon-flag.gif";
		} else {
			star.checked = false;
			star.nextElementSibling.firstElementChild.src = "/images/ImgIcon/view-flag.gif";
		}
	});
}
// 별점 평가하기 끝

document.addEventListener('DOMContentLoaded', function() {
    var currentUrl = window.location.href;
    if (document.getElementById("menu") && (currentUrl.includes("boardItemView") || currentUrl.includes("newPortalPortalPage")) ) {
        resizableMenuItem(currentUrl);
    }
});

function resizableMenuItem(url) {
    var mainmenu = document.getElementById("menu");
    var buttonContainer = mainmenu.querySelector("ul");

    var existingMoreBtn = document.getElementById("moreBoardIcon");
    if (existingMoreBtn) {
        existingMoreBtn.remove();
    }

    var createMoreBtnLi = document.createElement("li");
    var createMoreBtnSpan = document.createElement("span");
    var createMoreBtnImg = document.createElement("img");
    var createMoreBtnUl = document.createElement("ul");

    createMoreBtnLi.id = "moreBoardIcon";
    createMoreBtnLi.classList = "view_moreboarditem";
    createMoreBtnSpan.classList = "view_icon";
    createMoreBtnSpan.setAttribute("onclick", "this.parentNode.classList.toggle('on')");
    createMoreBtnImg.src = "/images/ImgIcon/view_more.png";
    createMoreBtnUl.classList = "layer_select";
    buttonContainer.style.overflow = "unset";

	if(url.includes("newPortalPortalPage")){
		createMoreBtnImg.style.marginTop = "10px";
	}
	
    createMoreBtnSpan.appendChild(createMoreBtnImg);
    createMoreBtnLi.appendChild(createMoreBtnSpan);
    createMoreBtnLi.appendChild(createMoreBtnUl);
    buttonContainer.appendChild(createMoreBtnLi);

    var moreButton = createMoreBtnLi;
    var dropdownMenu = createMoreBtnUl;
    var buttons = [];
    var hiddenButtons = [];
    var timer = null;
    var btns = buttonContainer.querySelectorAll("li");

    for (var i = 0; i < btns.length; i++) {
        var btn = btns[i];
        if (!btn.classList.contains("view_moreboarditem") && !btn.classList.contains("layer_select") && window.getComputedStyle(btn).display !== "none" && window.getComputedStyle(btn).float !== "right" && btn.children[0].tagName !== "SELECT") {
            buttons.push(btn);
        }
    }

    function resizeBtn() {
        var mainMenuWidth = document.querySelector("#bodyPopup").offsetWidth + 100;
		
        var rightSectionWidth = 0;
        var rightDiv = document.querySelector("#close");

        if (rightDiv) {
            rightSectionWidth += rightDiv.offsetWidth;
        }
		var remainingWidth = mainMenuWidth - rightSectionWidth;
		
		var moreButtonWidth = remainingWidth * 0.45;

		var mainMenuWidthCal = remainingWidth - moreButtonWidth;
        var totalWidth = 0;

        hiddenButtons = [];
        buttons.forEach(function (btn) {
            btn.style.display = "block";
        });

        buttons.forEach(function (button) {
            totalWidth += button.offsetWidth;

            if (totalWidth > mainMenuWidthCal) {
                hiddenButtons.push(button);
                button.style.display = "none";
            }
        });

        dropdownMenu.innerHTML = "";

        if (hiddenButtons.length > 0) {
            moreButton.style.display = "block";

            hiddenButtons.forEach(function (btn) {
                var clone = btn.cloneNode(true);
                clone.style.display = "";
                dropdownMenu.appendChild(clone);
            });
        } else {
            moreButton.style.display = "none";
        }

    }

    window.addEventListener("resize", function () {
        var currentUrl = window.location.href;
        if (document.getElementById("menu") && (currentUrl.includes("boardItemView") || currentUrl.includes("newPortalPortalPage")) ) {
            clearTimeout(timer);
            timer = setTimeout(resizeBtn, 10);
        }
    });

    resizeBtn();

    var viewMore = null;

    function hideLayerItem(event) {
        if (viewMore && !event.target.closest('.view_moreboarditem')) {
            viewMore.classList.remove('on');
        }
    }

    function setUpHideLayerEventItem() {
        viewMore = document.getElementsByClassName('view_moreboarditem')[0];

        var bodyPopup = document.getElementById('bodyPopup');

        bodyPopup.addEventListener('click', hideLayerItem);

        var iframeBody = bodyPopup.querySelector('iframe');
        if (iframeBody) {
            iframeBody.addEventListener('load', function() {
                var iframeDocument = iframeBody.contentDocument || iframeBody.contentWindow.document;

                iframeDocument.addEventListener('click', hideLayerItem);
            });
        }
    }
    setUpHideLayerEventItem();
}
    // 수정 창이 열려있을 때 다른 기능 사용시 수정창 닫기
function removeCloneModiCommet() {
    if ($(".cloneArea").length > 0) {
        var originalId = $(".cloneArea").attr("original");
        var cloneChild = $(".cloneArea").children();
        $("#" + originalId).html(cloneChild);
        $(".cloneArea").remove();
    }
    console.log($('[class^=trcommentReact]').length);
    $('[class^=trcommentReact]').remove();
}

function originalCommentClone(obj) {
    var clonedPanel = $(obj).children().clone();// 요소 복사
    var createImsi = $("<div>");
    createImsi.addClass("cloneArea");
    createImsi.attr("original", $(obj).attr("id"));
    createImsi.append(clonedPanel);
    $(obj).before(createImsi);
    createImsi.hide(); 
}

function previewAttachToggle() {
	$('#preview_attach_toggle').toggleClass('active');
	$('.preview_attach_list').toggleClass('active');
    
    if ($('.preview_attach_list').hasClass('active')){
        $('.preview_attach_list').css("height","auto");
    } else {
        $('.preview_attach_list').css("height","0");
    }
}