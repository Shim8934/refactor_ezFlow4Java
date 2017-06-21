/** 이효진 작성*/
//댓글목록조회
function getcircularComment() {
	$.ajax({
		type : "POST",
		url : "/ezCircular/getCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID
		},
		success : function(result) {
			//회람자 목록
			userList = "";
			list = result.userList;
			list.forEach(function(vo, index) {
				userList += "<tr circularUserID='" + vo.memberID + "'>";
				userList += "<td style='width:35%;'>" + vo.memberName + "("+ vo.memberID +")<a href='#' class='imgbtn'><span circularUserID='" + vo.memberID + "' onclick='showEdit(this)'>댓글</span></a></td>"
				
				if (vo.status == 1) {
					userList += "<td style='text-align:right;' colspan='2'>확인완료</td>"
				} else {
					userList += "<td style='text-align:right;' colspan='2'>미확인</td>";
				}
				userList += "</tr>";
				userList += "<tr style='display:none'>";
				userList += "<td colspan='3'><table style='width:100%;' circularUserID='" + vo.memberID + "'></table></td>";
				userList += "</tr>";
				userList += "<tr style='display:none'>";
				userList += "<td colspan='3'><div class='circularComment' circularUserID='" + vo.memberID + "' circularID='" + vo.circularID + "'><input type = 'text'/><a href='#' class='imgbtn'><span circularUserID='" + vo.memberID + "' onclick='editCircularComment(this)'>저장</span></a></div></td>";
				userList += "</tr>";
			});
			
			$("#commentUserList").html("");
			$("#commentUserList").append(userList);
			
			commentList = "";
			list = result.commentList;
			list.forEach(function(vo, index) {
				commentList = "<tr>";
				commentList += "<td style='width:60%;' circularCommentID='" + vo.circularCommentID + "'>content : " + vo.circularComment + "</td>";
				commentList += "<td style='width:30%;'>id,name : (" + vo.memberID + "/ " + vo.memberName + ")</td>";
				commentList += "<td style='width:10%;'>" + vo.regDate + "</td>";
				commentList += "</tr>";
				$("table[circularUserID='" + vo.circularUserID + "'").append(commentList);
				$("table[circularUserID='" + vo.circularUserID + "'").closest("tr").show();
			});
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function showEdit(obj) {
	$(".circularComment").closest("tr").hide();
	$(".circularComment[circularUserID='" + $(obj).attr("circularUserID") + "']").closest("tr").show();
}

//댓글작성
function editCircularComment(obj) {
	var circularUserID = $(obj).attr("circularUserID");
	var circularComment = $("div.circularComment[circularUserID='" + $(obj).attr("circularUserID") + "'] > input[type='text']").val();
	
	$.ajax({
		type : "POST",
		url : "/ezCircular/editCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID, // 회람ID
			circularUserID : circularUserID, // 회람자ID
			circularComment : $("div.circularComment[circularUserID='" + $(obj).attr("circularUserID") + "'] > input[type='text']").val(), //회람 코멘트 본문
		},
		success : function(result) {
			getcircularComment();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}