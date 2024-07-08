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
			boardCommentList = "<colgroup><col width='20%' /><col width='62%' /><col width='18%' /></colgroup>";
			list = result.boardLineReplyVOList;
			var commentBgColor = 1;
			var updateCount = parseInt(result.totalCommentCount);

			list.forEach(function(vo, index) {
				if (commentBgColor === 1) {
					boardCommentList += "<tr class='boardComment' boardUserID='" + vo.userID + "' memberID='"
						+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" 
						+ 1 + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:white;'>";
				} else {
					boardCommentList += "<tr class='boardComment' boardUserID='" + vo.userID + "' memberID='"
						+ vo.userID + "' replyID='" + vo.replyID + "' boardCommentStatus='" 
						+ 1 + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#fafafa;'>";
				}

				if (gubun == "2") {
					boardCommentList += "<td style='padding-left:3px;line-height:1.5'>&nbsp;<span>" + vo.userName + "</span></td>";					
				} else {
					boardCommentList += "<td style='padding-left:3px;'>&nbsp;<span style='cursor:pointer'" 
										+ " onclick='OpenUserInfo(\"" + vo.userID + "\", \"" + vo.deptID + "\")'>" + vo.userName + "</span></td>";	
				}
				boardCommentList += "</td>";
				
				/* 2019-11-22 홍승비 - 댓글 작성 시의 공백과 줄바꿈 전부 표출하도록 수정 */
				boardCommentList += "<td style='text-align:left;vertical-align:middle;padding:10px;word-wrap:break-word;line-height:1.5; white-space:pre-wrap;'>"
									+ vo.content + "&nbsp;&nbsp;";
					
				if ( typeof userInfoID == "undefined") {
				    userInfoID = "";    	
				}
				
				if (vo.userID == userInfoID) {
					boardCommentList += "<img src='/images/ImgIcon/comment_del.gif'" +
							" style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px' onclick='deleteBoardComment(this)'/>";
				} else {
					/* 2020-01-10 홍승비 - 익명게시판 댓글 체크 부분 오라클 호환 수정 */
					if (vo.userID == null || vo.userID == "") {
						//익명일 경우
						boardCommentList += "<img src='/images/ImgIcon/comment_del.gif'" +
								" style='cursor:pointer;vertical-align:middle;inline-block;padding-bottom:1.6px;' onclick='deleteBoardComment(this)'/>";
					} else {
						;
					}
				}
				boardCommentList += "</td>";
				boardCommentList += "<td style='text-align:right; padding-right:8px;";
				if (reactFlag != null && reactFlag == "Y") boardCommentList += "border-bottom:hidden;";
				boardCommentList +=	"'>" + vo.writeDate.substring(0, 16) + "</td>";
				boardCommentList += "</tr>";

				/* 2023-03-07 이가은 - 댓글 좋아요/싫어요 버튼 및 우측 숫자 표출 */
				if (reactFlag != null && reactFlag == "Y") {
					if (commentBgColor === 1) {
						boardCommentList += "<tr class='commentReact" + index + "' style='text-align:left; border:1px solid #e2e2e2; background-color:white;'>";
					} else {
						boardCommentList += "<tr class='commentReact" + index + "' style='text-align:left; border:1px solid #e2e2e2; background-color:#fafafa;'>";
					}
					boardCommentList += "<td style='border-top:hidden;'></td>";
					boardCommentList += "<td style='border-top:hidden;'></td>";
					boardCommentList += "<td class='reactTd' style='text-align:right; height:28px; border-top:hidden; padding-right:13px; float:right;' replyid=" + vo.replyID + ">";
					if (gubun != 2) {
						boardCommentList += "<div><p style='float:left; margin-top:0px;'><img src='/images/like_off.png' style='cursor:pointer;' id=Y" + vo.replyID +" replyid=" + vo.replyID + " userid=" + vo.userID + " reactflag=Y index=" + index + " onclick='react_onclick(this)' /></p>";
						boardCommentList +=	"<p style='width:16px; float:left; margin-top:0px;'><span id='myY" + index +"' style='color:#F55E51;'>"+ vo.re_like +"</span></p>";
						boardCommentList += "<p style='float:left; margin-top:0px; margin-left:15px;'><img src='/images/hate_off.png' style='cursor:pointer;' id=N" + vo.replyID +" replyid=" + vo.replyID + " userid=" + vo.userID + " reactflag=N index=" + index + " onclick='react_onclick(this)'/></p>";
						boardCommentList += "<p style='width:16px; float:left; margin-top:0px;'><span id='myN" + index +"' style='color:#5381F5;'>" + vo.re_hate + "</span></p></div>";
						boardCommentList += "</td>";
						boardCommentList += "</tr>";
					} else {
						boardCommentList += "<div><p style='float:left; margin-top:0px;'><img src='/images/like_off.png' style='cursor:pointer;' id=Y" + vo.replyID +" replyid=" + vo.replyID + " userid=anonym reactflag=Y index=" + index + " onclick='react_onclick(this)' /></p>";
						boardCommentList +=	"<p style='width:16px; float:left; margin-top:0px;'><span id='myY" + index +"' style='color:#F55E51;'>"+ vo.re_like +"</span></p>";
						boardCommentList += "<p style='float:left; margin-top:0px; margin-left:15px;'><img src='/images/hate_off.png' style='cursor:pointer;' id=N" + vo.replyID +" replyid=" + vo.replyID + " userid=anonym reactflag=N index=" + index + " onclick='react_onclick(this)'/></p>";
						boardCommentList += "<p style='width:16px; float:left; margin-top:0px;'><span id='myN" + index +"' style='color:#5381F5;'>" + vo.re_hate + "</span></p></div>";
						boardCommentList += "</td>";
						boardCommentList += "</tr>";
					}
				} 
//				else {
//					boardCommentList += "</td></tr>";
//				}
				commentBgColor = commentBgColor * (-1);
			}); 
			  
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
			
			nowCommentCount = result.totalCommentCount; // 댓글 옵션처리를 위해 전역변수에 최신 댓글갯수를 부여
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

    xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
    xmlhttp.send();
    getBoardComment();
    xmlhttp = null;
}
//강민수92
function deleteBoardCommentPopup() {
	/* 2019-11-07 홍승비 - 하단댓글의 경우 레이어팝업 표출영역 수정 */
	if (OneLineReplyFlag == "1") {
		DivPopUpShow2($('body').prop('scrollWidth') * 0.5, $('body').prop('scrollHeight') * 0.3, "/ezBoard/checkPassWord.do?itemID=" 
				+ encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID) + "&replyFlag=true");
	}
	else if (OneLineReplyFlag == "2") {
		if ($(window).height() < $('body').prop('scrollHeight')) {
			document.getElementById("mailPanel2").style.height = ($('body').prop('scrollHeight') + "px");
		} else {
			document.getElementById("mailPanel2").style.height = ($(window).height() + "px");
		}
		DivPopUpShow2(376, 191, "/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID) + "&replyFlag=true");
	}
}
//강민수92
function closePopup2() {
	parent.DivPopUpHidden2();
}
//강민수92
function deleteBoardComment(obj) {
	var boardCommentID = $(obj).closest("tr").attr("replyID");
    delpReplyID = boardCommentID;
    var xmlhttp = createXMLHttpRequest();
    
    if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
        if (gubun == "2") {
            if (CrossYN()) {
                checkpassword_dialogArguments[1] = delete_onelinereply_Complete;
                deleteBoardCommentPopup();
                try { OpenWin.focus(); } catch (e) { }
            	
            } else {
            	var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
                feature = feature + GetShowModalPosition(330, 200);
                var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(delpReplyID), "", feature);
                
                if (ret == "NO") {
                    alert("<spring:message code='ezBoard.t267' />");
                    return;
                } else if (ret == "cancel" || ret == undefined) {
                    return;
                }
                
                xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
                xmlhttp.send();
                if (xmlhttp.responseText == "FAIL") {
                    alert(strLang184);
                } 

                getBoardComment();
                xmlhttp = null;
            }
            
        } else {
            xmlhttp.open("POST", "/ezBoard/checkOneLineOwner.do?replyID=" + encodeURIComponent(delpReplyID), false);
            xmlhttp.send();
            if (xmlhttp.responseText.substr(0, 2) != "OK") {
                alert(strLang184);
                return;
            } else {
            	if (!confirm(strLang180)) return;
            	xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
            	xmlhttp.send();	
            }
            
        }
    } else {
    	if (!confirm(strLang180)) return;
    	xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + encodeURIComponent(delpReplyID) + "&guBun=" + gubun, false);
    	xmlhttp.send();	
    	
    }
    
    if (xmlhttp.responseText == "FAIL") {
        alert(strLang184);
    }
    getBoardComment();
    xmlhttp = null;
    
	/* 2019-11-06 홍승비 - 게시물 미리보기 영역에서 댓글 삭제 시 게시물 리스트 갱신 */
	if (window.location.href.indexOf("/ezBoard/boardItemPreviewContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewPhotoContent.do") > -1 || window.location.href.indexOf("/ezBoard/boardItemPreViewMovieContent.do") > -1) {
		window.parent.getBoardList();
	}
}
//강민수92
function OneLineReply_onkeydown() {
    if (event.keyCode == 13) Save_OneLineReply();
}
//강민수92
function Save_OneLineReply() {
    if (Reply_FG != "true") {
        alert(strLang173);
	    return;
	}
    /* 2019-11-05 홍승비 - 게시물 본문하단 댓글옵션 추가 */
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
    var pReplyID = "";
    pReplyID = "{" + GetGUID().toUpperCase() + "}";

	var content,password;
	if (OneLineReplyFlag == "1" || OneLineReplyFlag == "2"){
		content = MakeXMLString(document.getElementById('onelinereply').value);
	}else{
		content = "";
	}
	if (gubun != "2") {
	    password = "";
	}
	else {
	    password = rsa.encrypt(document.getElementById("txtPassWord").value);
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
				 password	: password
					 
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