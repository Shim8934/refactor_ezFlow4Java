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
				userList += "<td style='width:70px;'>" + vo.memberName + "</td>"
				if (vo.status == 1) {
					userList += "<td style='width:55%; text-align:right;' colspan='2'>확인완료</td>"
				} else {
					userList += "<td style='width:55%; text-align:right;' colspan='2'>미확인</td>";
				}
				
				userList += "<td style='width:10%;'><a class='imgbtn' style='vertical-align:middle;'><span circularUserID='" + vo.memberID + "' onclick='showEdit(this)'>댓글작성</span></a></td>"
				
				userList += "</tr>";
				userList += "<tr style='display:none;'>";
				userList += "<td colspan='4'><table style='width:100%;' circularUserID='" + vo.memberID + "'></table></td>";
				userList += "</tr>";
				userList += "<tr class='circularComment' circularUserID='" + vo.memberID + "' circularID='" + vo.circularID + "' style='display:none;'>";
				userList += "<td style='width:70px'>" + result.userInfo["displayName"] + "</td>";
				userList += "<td colspan='2'><input type='text' style='width:100%;' /></td>";
				userList += "<td style='text-align:right;'><a class='imgbtn'><span circularUserID='" + vo.memberID + "' onclick='editCircularComment(this)'>저장</span></a></td>";
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
			circularComment : $("tr.circularComment[circularUserID='" + $(obj).attr("circularUserID") + "'] > td > input[type='text']").val(), //회람 코멘트 본문
		},
		success : function(result) {
			getcircularComment();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}