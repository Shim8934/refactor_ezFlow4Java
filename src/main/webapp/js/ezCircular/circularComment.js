/** 이효진 작성*/
function getCircularComment() {
	$.ajax({
		type : "POST",
		async : false,
		url : "/ezCircular/getCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID,
			commentType : commentType,
			searchType : $(".searchType:checked").val(),
			searchValue : $("#searchValue").val()
		},
		success : function(result) {
			var lang = result.userInfo.lang;
			
			if (commentType == 'totalComment') {
				circularUserList = "<colgroup><col width='20%' /><col width='62%' /><col width='18%' /></colgroup>";
				
				userList = result.circularUserList;
				userList.forEach(function(vo, index) {
					circularUserList += "<tr class='circularUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left;vertical-align:middle;'>";
					circularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
					
					if (vo.status == 1) {
						circularUserList += "<img src='/images/ImgIcon/msg-rd.png' style='vertical-align:middle;'/>&nbsp;" + (lang == 1 ? vo.memberName : vo.memberName2) + "&nbsp;";
					} else {
						circularUserList += "<img src='/images/ImgIcon/msg-unrd.png' style='vertical-align:middle;'/>&nbsp;" + (lang == 1 ? vo.memberName : vo.memberName2) + "&nbsp;";
					}
					
					if (status == 0 && (option == 1 || option == 3)) {
						circularUserList += "<img src='/images/modify2.gif' style='cursor:pointer;vertical-align:middle;'  onclick='showEdit(this)'/>&nbsp;";
					} else {
						circularUserList += "&nbsp;"
					}
					
					circularUserList += "</th>";
					
					circularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:right;background-color:white;' colspan='2'>";
					
					if (vo.status == 1) {
						circularUserList += vo.confirmDate.substring(0, 16);
					}
					
					circularUserList += "</th>";
					circularUserList += "</tr>";
				});
				
				$("#circularUserList").html("");
				$("#circularUserList").append(circularUserList);
				
				circularCommentList = "";
				commentList = result.circularCommentList;
				
				commentList.forEach(function(vo, index) {
					circularCommentList  = "<tr class='circularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#fafafa;'>";
					circularCommentList += "<td style='padding-left:3px'>&nbsp;&nbsp;<img src='/images/ImgIcon/commentRe.gif' style='vertical-align:middle; margin-bottom:9px'/>&nbsp;" + (lang == 1 ? vo.memberName : vo.memberName2) + "</td>";
					circularCommentList += "<td style='text-align:left;vertical-align:middle;padding:10px;white-space:pre-wrap;'>" + vo.circularComment + "&nbsp;&nbsp;";
					
					if (vo.memberID == userInfoID && vo.status == 0) {
						circularCommentList += "<img src='/images/ImgIcon/circular_share2.png' style='cursor:pointer;vertical-align:middle;' onclick='openCommentSharePopup(this)' />&nbsp;";
					}
					
					if (vo.memberID == userInfoID) {
						circularCommentList += "<img src='/images/ImgIcon/comment_del.gif' style='cursor:pointer;vertical-align:middle;' onclick='deleteCircularComment(this)'/>";
					}
					
					circularCommentList += "</td>";
					circularCommentList += "<td style='text-align:right;padding-right:5px'>" + vo.regDate.substring(0, 16) + "</td>";
					circularCommentList += "</tr>";
					
					if (vo.status == 0) {
						if ($(".circularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
							$(".circularUser[circularUserID='" + vo.circularUserID + "']").after(circularCommentList);
						} else {
							$(".circularComment[circularUserID='" + vo.circularUserID + "']:last").after(circularCommentList);
						}
					} else {
						if (vo.memberID == userInfoID || vo.circularUserID == userInfoID) {
							if ($(".circularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
								$(".circularUser[circularUserID='" + vo.circularUserID + "']").after(circularCommentList);
							} else {
								$(".circularComment[circularUserID='" + vo.circularUserID + "']:last").after(circularCommentList);
							}
						}
					}
				});
				
				
				// 2018-05-31 김민성 - 작성자 의견창 활성화 & placeholder 추가
				if(status == 0 && (option == 1 || option == 3)) {
					var writer = $(".circularUser:first");
					showEdit(writer);
				}
				
				//2018-04-11 김보미 검색결과가 없을경우
				if ($("#searchValue").val() != "" && $("#searchValue").val() != null) {
					if (userList.length == 0 && commentList == 0) {
						circularCommentList = "<tr style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white;'>";
						circularCommentList += "<td colspan='3' style='padding:10px;border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:center;background-color:white;'>" + strLang16 + "</td>";
						circularCommentList += "</tr>";
						
						$("#circularUserList").html("");
						$("#circularUserList").append(circularCommentList);
					}
				}
			} else if (commentType == 'myComment') {
				circularCommentList = "<colgroup><col width='20%' /><col width='62%' /><col width='18%' /></colgroup>";
				list = result.circularCommentList;
				
				list.forEach(function(vo, index) {
					circularCommentList += "<tr class='circularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white;'>";
					circularCommentList += "<td style='padding:10px;border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
					
					if (vo.confirmStatus == 1) {
						circularCommentList += "<img src='/images/ImgIcon/msg-rd.png' style='vertical-align:middle;'/>&nbsp;" + (lang == 1 ? vo.memberName : vo.memberName2);
					} else if (vo.confirmStatus == 0) {
						circularCommentList += "<img src='/images/ImgIcon/msg-unrd.png' style='vertical-align:middle;'/>&nbsp;" + (lang == 1 ? vo.memberName : vo.memberName2);
					}
					
					circularCommentList += "</td>";
					
					circularCommentList += "<td style='text-align:left;vertical-align:middle;padding:10px;white-space:pre-wrap;'>" + vo.circularComment + "&nbsp;&nbsp;";
					
					circularCommentList += "</td>";
					circularCommentList += "<td style='text-align:right;padding-right:5px'>" + vo.regDate.substring(0, 16) + "</td>";
					circularCommentList += "</tr>";
				});
				
				if (list.length == 0) {
					circularCommentList += "<tr style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white;'>";
					circularCommentList += "<td colspan='3' style='padding:10px;border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:center;background-color:white;'>" + strLang16 + "</td>";
					circularCommentList += "</tr>";
				}
				
				$("#circularUserList").html("");
				$("#circularUserList").append(circularCommentList);
			}
			
			var updateCount = strLang2 + "[" + result.myCommentCount + "/" + result.totalCommentCount + "]"; 

			$("h1").html(updateCount);
			parent.getCommentCount();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function showEdit(obj) {
	var circularUserID = $(obj).closest("tr").attr("circularUserID");
	
	if ($(".circularCommentEdit[circularUserID='" + circularUserID + "'").length != 0) {
		$(".circularCommentEdit[circularUserID='" + circularUserID + "'").remove();
	} else {
		$(".circularCommentEdit").remove();
		
		var circularEdit = "<tr class='circularCommentEdit' circularUserID='" + circularUserID + "' style='border:1px solid #e2e2e2; padding:10px'>";
		circularEdit += "<td style='background-color:#ececec;' colspan='2'><textarea style='width:105%;height:50px;resize:none;overflow:auto;vertical-align:middle;margin:5px;border:1px solid #ddd' maxlength='5000'></textarea></td>";
		circularEdit += "<td style='background-color:#ececec; text-align:center;'><a class='imgbtn' style='margin-left:47px;padding-left:2px;'>&nbsp;<span onclick='editCircularComment(this);' style='padding-right:3px;'>" + strLang3 + "</span>&nbsp;</a><br/><div style='margin-left:35px;'><input type='checkbox' id='commentStatus' style='vertical-align:middle;'>" + strLang4 + "</input></div></td>";
		circularEdit += "</tr>";
		
		$(obj).closest("tr").after(circularEdit);
		
		// 2018-05-31 김민성 - 회람 상세정보 > 의견목록 의견 클릭시 placeholder 추가
		var writer = $(".circularUser:first").attr("circularuserid");
		
		if(writer == circularUserID) {
			var circularComment = $(".circularCommentEdit");
			circularComment.find("textarea")[0].placeholder = strLang26;
		}
		else {
			var circularComment = $(".circularCommentEdit");
			circularComment.find("textarea")[0].placeholder = strLang27;
		}
	}
}

function editCircularComment(obj) {
	var circularUserID = $(obj).closest("tr").attr("circularUserID");
	var circularComment = $("tr.circularCommentEdit[circularUserID='" + circularUserID + "'] > td > textarea").val();
	var circularCommentStatus = $("tr.circularCommentEdit[circularUserID='" + circularUserID + "'] > td > div > input:checked").length;
	
	if (trim(ReplaceText(circularComment, "\n", "")) == "") {
		alert(strLang5);
		return ;
	}
	//2018-07-06 배현상, 회람판 의견 표힌 시 \n의 <br>치환 불필요 제거
	//circularComment = trim(ReplaceText(circularComment, "\n", "<br>"));
	circularComment = trim(circularComment);
	
	$.ajax({
		type : "POST",
		url : "/ezCircular/editCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID, // 회람ID
			circularUserID : circularUserID, // 회람자ID
			circularComment : circularComment, //회람 코멘트 본문
			status : circularCommentStatus
		},
		success : function(result) {
			$("#searchValue").val("");
			getCircularComment();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function deleteCircularComment(obj) {
	var circularCommentID = $(obj).closest("tr").attr("circularCommentID");
	
	if (!confirm(strLang17)) {
		return;
	}
	
	$.ajax({
		type : "POST",
		url : "/ezCircular/deleteCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID,
			circularCommentID : circularCommentID
		},
		success : function(result) {
			getCircularComment();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert(strLang1);
		}
	});
}

function commentSendMail() {
	$.ajax({
		type : "POST",
		url : "/ezCircular/commentSendMail.do",
		dataType : "json",
		data : {
			circularID : circularID
		},
		success : function(result) {
			alert(strLang7);
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function getCommentShareUser() {
	//회람자목록 조회(본인제외)
	$.ajax({
		type : "POST",
		url : "/ezCircular/getCommentShareUser.do",
		dataType : "json",
		data : {
			circularID : circularID,
			circularCommentID : circularCommentID,
			searchType : "userID",
			searchValue : $("#searchValue").val()
		},
		success : function(result) {
			//본인 제외하고 회람자 목록 보여주면서 체크박스 만들고 확인버튼 눌렀을때 updateStatus 새거 하나 쓰자
			shareUserList = "<colgroup><col width='10%' /><col width='90%' /></colgroup>";
			
			list = result.shareUserList;
			
			if(result.shareUserList.length == 0) {
				shareUserList += "<td style='border-top:0px;border-right:0px;border-left:0px;text-align:center;background-color:white;' colspan='2'>"+ strLang50 + "</td>";
			}
			
			list.forEach(function(vo, index) {
				if (vo.memberID != userInfoID) {
					shareUserList += "<tr class='shareUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left;vertical-align:middle;'>";
					
					shareUserList += "<td style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
					shareUserList += "<input type='checkbox' class='chkBox' />";
					shareUserList += "</td>";
					shareUserList += "<td style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>" + vo.memberName + "</td>";
					
					shareUserList += "</tr>";
				}
			});
			
			$("#shareUserList").html("");
			$("#shareUserList").append(shareUserList);
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function shareComment() {
	var memberIDList = "";
	
	if ($(".chkBox:checked").length ==  0) {
		alert(strLang11);
		return;
	}
	
	if(!confirm(strLang12)) {
		return;
	}
	
	for (var i=0; i < $(".chkBox:checked").length; i++) {
		memberIDList += $(".chkBox:checked").eq(i).closest("tr").attr("circularUserID") + ";";
	}
	
	$.ajax({
		type : "POST",
		url : "/ezCircular/commentShareUser.do",
		dataType : "json",
		data : {
			circularID : circularID,
			circularCommentID : circularCommentID,
			memberIDList : memberIDList
		},
		success : function (result) {
			closePopup();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert(strLang13);
		}
	});
}

function commentConfirm() {
	if (!confirm(strLang14)) {
		return;
	}
	
	$.ajax({
		type : "POST",
		url : "/ezCircular/commentConfirm.do",
		dataType : "json",
		data : {
			circularID : circularID
		},
		success : function (result) {
			closePopup();
			parent.getCommentCount();
			parent.window.opener.getLeftCount();
			parent.window.opener.getBoardList();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert(strLang15);
		}
	});
}

function openCircularComment() {
	DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.92, "/ezCircular/circularCommentPopup.do?circularID=" + circularID + "&status=" + status);
}

function openCommentSharePopup(obj) {
	$("#mailPanel").css('height', $('body').prop('clientHeight') + $(".commentConfirmDiv").eq(0).closest("div").prop('height'));
	
	DivPopUpShow(300, 490, "/ezCircular/circularCommentSharePopup.do?circularID=" + circularID + "&circularCommentID=" + $(obj).closest("tr").attr("circularCommentID"));
}

function closePopup() {
	parent.DivPopUpHidden();
	parent.getCommentCount(); // 공유자목록 창 닫을 때 read 창에서 의견목록 Update 위해 추가
}