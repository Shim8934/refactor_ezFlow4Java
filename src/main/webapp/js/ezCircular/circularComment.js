/** 이효진 작성*/
function getCircularComment() {
	$.ajax({
		type : "POST",
		url : "/ezCircular/getCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID,
			commentType : commentType,
			searchType : $(".searchType:checked").val(),
			searchValue : $("#searchValue").val()
		},
		success : function(result) {
			if (commentType == 'totalComment') {
				circularUserList = "<colgroup><col width='20%' /><col width='62%' /><col width='18%' /></colgroup>";
				
				list = result.circularUserList;
				list.forEach(function(vo, index) {
					circularUserList += "<tr class='circularUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left;vertical-align:middle;'>";
					circularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
					
					if (vo.status == 1) {
						circularUserList += "<img src='/images/ImgIcon/msg-rd.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
					} else {
						circularUserList += "<img src='/images/ImgIcon/msg-unrd.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
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
				list = result.circularCommentList;
				
				list.forEach(function(vo, index) {
					circularCommentList  = "<tr class='circularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#fafafa;'>";
					circularCommentList += "<td style='padding-left:3px'>&nbsp;&nbsp;<img src='/images/ImgIcon/commentRe.gif' style='vertical-align:middle; margin-bottom:9px'/>&nbsp;" + vo.memberName + "</td>";
					circularCommentList += "<td style='text-align:left;vertical-align:middle;padding:10px;'>" + vo.circularComment + "&nbsp;&nbsp;";
					
					if (vo.memberID == userInfoID && vo.status == 0) {
						circularCommentList += "<img src='/images/ImgIcon/circular_share2.gif' style='cursor:pointer;vertical-align:middle;' onclick='openCommentSharePopup(this)' />&nbsp;";
					}
					
					if (vo.memberID == userInfoID) {
						circularCommentList += "<img src='/images/ImgIcon/comment_del.gif' style='cursor:pointer;vertical-align:middle;' onclick='deleteCircularComment(this)'/>";
					}
					
					circularCommentList += "</td>";
					circularCommentList += "<td style='text-align:right;padding-right:8px'>" + vo.regDate.substring(0, 16) + "</td>";
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
			} else if (commentType == 'myComment') {
				circularCommentList = "<colgroup><col width='20%' /><col width='62%' /><col width='18%' /></colgroup>";
				list = result.circularCommentList;
				
				list.forEach(function(vo, index) {
					circularCommentList += "<tr class='circularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white;'>";
					circularCommentList += "<td style='padding:10px;border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
					
					if (vo.confirmStatus == 1) {
						circularCommentList += "<img src='/images/ImgIcon/msg-rd.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName;
					} else if (vo.confirmStatus == 0) {
						circularCommentList += "<img src='/images/ImgIcon/msg-unrd.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName;
					}
					
					circularCommentList += "</td>";
					
					circularCommentList += "<td style='text-align:left;vertical-align:middle;padding:10px;'>" + vo.circularComment + "&nbsp;&nbsp;";
					
					circularCommentList += "</td>";
					circularCommentList += "<td style='text-align:right;padding-right:8px'>" + vo.regDate.substring(0, 16) + "</td>";
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
		circularEdit += "<td style='background-color:#ececec;' colspan='2'><textarea style='width:105%;height:35px;resize:none;overflow:auto;'></textarea></td>";
		circularEdit += "<td style='background-color:#ececec; text-align:center;'><a class='imgbtn' style='margin-left:47px;'><span onclick='editCircularComment(this)';>" + strLang3 + "</span>&nbsp;</a><br/><div style='margin-left:35px;'><input type='checkbox' id='commentStatus' style='vertical-align:middle;'>" + strLang4 + "</input></div></td>";
		circularEdit += "</tr>";
		
		$(obj).closest("tr").after(circularEdit);
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
	
	circularComment = trim(ReplaceText(circularComment, "\n", "<br>"));
	
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
			parent.window.opener.refresh_onclick();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert(strLang15);
		}
	});
}

function openCircularComment() {
	DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.9, "/ezCircular/circularCommentPopup.do?circularID=" + circularID + "&status=" + status);
}

function openCommentSharePopup(obj) {
	$("#mailPanel").css('height', $('body').prop('clientHeight') + $(".commentConfirmDiv").eq(0).closest("div").prop('height'));
	
	DivPopUpShow(300, 490, "/ezCircular/circularCommentSharePopup.do?circularID=" + circularID + "&circularCommentID=" + $(obj).closest("tr").attr("circularCommentID"));
}

function closePopup() {
	parent.DivPopUpHidden();
}