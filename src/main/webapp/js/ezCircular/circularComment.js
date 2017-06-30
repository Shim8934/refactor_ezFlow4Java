/** 이효진 작성*/
//댓글목록조회
function getCircularComment() {
	$.ajax({
		type : "POST",
		url : "/ezCircular/getCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID,
			searchType : $("#searchType").val(),
			searchValue : $("#searchValue").val()
		},
		success : function(result) {
			circularUserList = "<colgroup><col width='15%' /><col width='72%' /><col width='13%' /></colgroup>";
			
			list = result.circularUserList;
			list.forEach(function(vo, index) {
				circularUserList += "<tr class='circularUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left;vertical-align:middle;'>";
				circularUserList += "<th style='border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left'>";
				circularUserList += "<img src='/images/i_group.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
				
				if (status == 0) {
					circularUserList += "<img src='/images/modify2.gif' style='cursor:pointer;vertical-align:middle;'  onclick='showEdit(this)'/>&nbsp;";
				} else {
					circularUserList += "&nbsp;"
				}
				
				circularUserList += "&nbsp;&nbsp;&nbsp;" + vo.confirmDate;
				circularUserList += "</th>";
				
				circularUserList += "<th style='border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2' colspan='2'>";
				
				if (vo.status == 1) {
					circularUserList += "확인완료"
				} else {
					circularUserList += "미확인";
				}
				
				circularUserList += "</th>";
				circularUserList += "</tr>";
			});
			
			$("#circularUserList").html("");
			$("#circularUserList").append(circularUserList);

			circularCommentList = "";
			list = result.circularCommentList ;
			list.forEach(function(vo, index) {
				circularCommentList  = "<tr class='circularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "' style='height:40px;text-align:left;border-top:1px solid #e2e2e2'>";
				circularCommentList += "<td style='padding-left:3px'><img src='/images/i_rep.gif' style='vertical-align:middle;'/>&nbsp;&nbsp;" + vo.memberName + "</td>";
				circularCommentList += "<td style='text-align:left;padding:10px;'>" + vo.circularComment +  "&nbsp;(" + vo.regDate.substring(11, 19) + ")&nbsp;";
				
				if (vo.memberID == userInfoID) {
					circularCommentList += "<img src='/images/comment_del.gif' style='cursor:pointer;vertical-align:middle;' onclick='deleteCircularComment(this)'/>";
				}
				
				circularCommentList += "</td>";
				circularCommentList += "<td style='text-align:right;padding-right:8px'>" + vo.regDate.substring(0, 10) + "</td>";
				circularCommentList += "</tr>";
				
				if (vo.status == 0) {//공개
					if ($(".circularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
						$(".circularUser[circularUserID='" + vo.circularUserID + "']").after(circularCommentList);
					} else {
						$(".circularComment[circularUserID='" + vo.circularUserID + "']:last").after(circularCommentList);
					}
				} else {//비공개
					if (vo.memberID == userInfoID || vo.circularUserID == userInfoID) {
						if ($(".circularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
							$(".circularUser[circularUserID='" + vo.circularUserID + "']").after(circularCommentList);
						} else {
							$(".circularComment[circularUserID='" + vo.circularUserID + "']:last").after(circularCommentList);
						}
					}
				}
			});
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
		
		var circularEdit = "<tr class='circularCommentEdit' circularUserID='" + circularUserID + "' style='height:70px;border:1px solid #e2e2e2'>";
		circularEdit += "<td colspan='2'><textarea style='width:97%;height:50px;border:0px;resize:none;outline:none;overflow:auto;'></textarea></td>";
		circularEdit += "<td><a class='imgbtn'><span onclick='editCircularComment(this)';>의견작성</span>&nbsp;</a><br/><input type='checkbox' id='commentStatus'>비공개</input></td>";
		circularEdit += "</tr>";
		
		$(obj).closest("tr").after(circularEdit);
	}
}

//댓글작성
function editCircularComment(obj) {
	var circularUserID = $(obj).closest("tr").attr("circularUserID");
	var circularComment = $("tr.circularCommentEdit[circularUserID='" + circularUserID + "'] > td > textarea").val();
	var circularCommentStatus = $("tr.circularCommentEdit[circularUserID='" + circularUserID + "'] > td > input:checked").length;

	if (circularComment == "") {
		alert("의견을 입력해주세요");
		return ;
	}
	
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
	
	$.ajax({
		type : "POST",
		url : "/ezCircular/deleteCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID, // 회람ID
			circularCommentID : circularCommentID
		},
		success : function(result) {
			alert("의견을 삭제했습니다.");
			getCircularComment();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

//확인재촉메일
function commentSendMail() {
	$.ajax({
		type : "POST",
		url : "/ezCircular/commentSendMail.do",
		dataType : "json",
		data : {
			circularID : circularID // 회람ID
		},
		success : function(result) {
			alert("mail send");
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function DivPopUpPosition(popUpW, popUpH) {
    var ReturnValue = new Array();
    var heigth = document.documentElement.scrollHeight;
    if (heigth == 0)
        heigth = document.body.scrollHeight;

    var width = document.documentElement.clientWidth;
    if (width == 0)
        width = document.body.clientWidth;

    var left = 0;
    var top = 0;
    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;
    if (heigth < (popUpH + 50))
        ReturnValue[0] = (heigth / 2);
    else
        ReturnValue[0] = (heigth / 2) - 50;
    ReturnValue[1] = pleftpos / 2;
    return ReturnValue
}


function openCircularComment() {
	$("#mailPanel").css('height', $('body').prop('Height'));
	
	DivPopUpShow(700, 600, "/ezCircular/circularCommentPopup.do?circularID=" + circularID + "&status=" + status);
}

function closeCircularComment() {
	parent.DivPopUpHidden();
}