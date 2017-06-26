/** 이효진 작성*/
//댓글목록조회
function getCircularComment() {
	$.ajax({
		type : "POST",
		url : "/ezCircular/getCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID,
			searchValue : $("#searchValue").val()
		},
		success : function(result) {
			//회람자 목록
			userList = "";
			list = result.userList;
			list.forEach(function(vo, index) {
				userList += "<tr circularUserID='" + vo.memberID + "'>";
				userList += "<td style='text-align:left;'>" + vo.memberName + "&nbsp;<a class='imgbtn' style='vertical-align:middle;'><span circularUserID='" + vo.memberID + "' onclick='showEdit(this)'>댓글작성</span></a></td>"
				
				if (vo.status == 1) {
					userList += "<td style='width:55%; text-align:right; padding-right:10px;' >확인완료</td>"
				} else {
					userList += "<td style='width:55%; text-align:right; padding-right:10px;' >미확인</td>";
				}
				
				userList += "</tr>";
				userList += "<tr style='display:none;'>";
				userList += "<td style='padding:5px 2px;' colspan='2'><table style='width:100%;' circularUserID='" + vo.memberID + "'></table></td>";
				userList += "</tr>";
			});
			
			$("#commentUserList").html("");
			$("#commentUserList").append(userList);

			commentList = "";
			list = result.commentList;
			list.forEach(function(vo, index) {
				commentList = "<tr style='padding:10px; 4px;'>";
				commentList += "<td style='width:70px; border:0px;'>" + vo.memberName + "</td>";
				commentList += "<td style='border:0px;' circularCommentID='" + vo.circularCommentID + "'>" + vo.circularComment + "</td>";
				commentList += "<td style='width:130px; border:0px; text-align:right;'>" + vo.regDate + "</td>";
				commentList += "<td style='width:50px; border:0px;' ><a class='imgbtn' style='vertical-align:middle;'><span class='deleteComment' memberID='" + vo.memberID + "' circularID='" + circularID + "' circularCommentID='" + vo.circularCommentID + "' onclick='deleteCircularComment(this)'>삭제</span></a></td>"
				commentList += "</tr>";
				
				$("table[circularUserID='" + vo.circularUserID + "']").append(commentList);
				$("table[circularUserID='" + vo.circularUserID + "']").closest("tr").show();
			});
			
			if (($("#option").prop("checked") != true) || (status == 1)) {
				$("#commentUserList > tbody > tr > td > a").hide();
			}
			
			$(".deleteComment[memberID != '" + userInfoID + "']").closest("a").hide();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function showEdit(obj) {
	$("tr.circularComment").remove();
	
	var commentEditor = "";
	commentEditor += "<tr class='circularComment' circularUserID='" + $(obj).attr("circularUserID") + "' circularID='" + circularID + "'>";
	commentEditor += "<td style='border:0px;' colspan='3'><textarea style='width:97%; text-align:left;' /></td>";
	commentEditor += "<td style='width:50px; border:0px; text-align:right;'><a class='imgbtn' style='text-align:right;'><span circularUserID='" + $(obj).attr("circularUserID") + "' onclick='editCircularComment(this)'>저장</span></a></td>";
	commentEditor += "</tr>";
	
	
	$("table[circularUserID='" + $(obj).attr("circularUserID") + "']").html($("table[circularUserID='" + $(obj).attr("circularUserID") + "'] tbody").html() + commentEditor);
	$("table[circularUserID='" + $(obj).attr("circularUserID") + "']").closest("tr").show();
	
	
}

//댓글작성
function editCircularComment(obj) {
	var circularUserID = $(obj).attr("circularUserID");
	var circularComment = $("tr.circularComment[circularUserID='" + $(obj).attr("circularUserID") + "'] > td > textarea").val();
	
	if (circularComment == "") {
		alert("댓글을 입력해주세요");
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
	var circularCommentID = $(obj).attr("circularCommentID");
	$.ajax({
		type : "POST",
		url : "/ezCircular/deleteCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID, // 회람ID
			circularCommentID : circularCommentID
		},
		success : function(result) {
			alert("댓글을 삭제했습니다.");
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

//댓글보기
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
	$("#mailPanel").css('height', $('body').prop('scrollHeight'));
	
	DivPopUpShow(700, 700, "/ezCircular/circularCommentPopup.do?circularID=" + circularID);
}

function closeCircularComment() {
	parent.DivPopUpHidden();
}
