/** 이효진 작성*/
//댓글목록조회
function getcircularComment() {
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
				userList += "<td style='text-align:left;'>" + vo.memberName + "<a class='imgbtn' style='vertical-align:middle;'><span circularUserID='" + vo.memberID + "' onclick='showEdit(this)'>댓글작성</span></a></td>"
				
				if (vo.status == 1) {
					userList += "<td style='width:55%; text-align:right;' >확인완료</td>"
				} else {
					userList += "<td style='width:55%; text-align:right;' >미확인</td>";
				}
				
				userList += "</tr>";
				userList += "<tr style='display:none;'>";
				userList += "<td colspan='2'><table style='width:100%;' circularUserID='" + vo.memberID + "'></table></td>";
				userList += "</tr>";
			});
			
			$("#commentUserList").html("");
			$("#commentUserList").append(userList);
			
			commentList = "";
			list = result.commentList;
			list.forEach(function(vo, index) {
				commentList = "<tr>";
				commentList += "<td style='width:70px; border:0px;'>" + vo.memberName + "</td>";
				commentList += "<td style=' border:0px;' circularCommentID='" + vo.circularCommentID + "'>" + vo.circularComment + "</td>";
				commentList += "<td style='width:20%; border:0px; text-align:right;'>" + vo.regDate + "</td>";
				commentList += "</tr>";
				
				$("table[circularUserID='" + vo.circularUserID + "']").append(commentList);
				$("table[circularUserID='" + vo.circularUserID + "']").closest("tr").show();
			});
			
			if (($("#option").prop("checked") != true) || (status == 1)) {
				$("#commentUserList > tbody > tr > td > a").hide();
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function showEdit(obj) {
	if ($("tr.circularComment[circularUserID='" + $(obj).attr("circularUserID") + "']").length == 0) {
		var commentEditor = "";
		commentEditor += "<tr class='circularComment' circularUserID='" + $(obj).attr("circularUserID") + "' circularID='" + circularID + "' style='display:none;'>";
		commentEditor += "<td colspan='3'><textarea style='width:90%; text-align:left;' /><a class='imgbtn' style='text-align:right;'><span circularUserID='" + $(obj).attr("circularUserID") + "' onclick='editCircularComment(this)'>저장</span></a></td>";
		commentEditor += "</tr>";
		
		$("table[circularUserID='" + $(obj).attr("circularUserID") + "']").html($("table[circularUserID='" + $(obj).attr("circularUserID") + "'] tbody").html() + commentEditor);
		$("tr.circularComment").hide();
		$("tr.circularComment[circularUserID='" + $(obj).attr("circularUserID") + "']").show();
	}
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
			getcircularComment();
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