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
				userList += "<ul circularUserID='" + vo.memberID + "'>";
				userList += "<li>" + vo.memberName + "("+ vo.memberID +") <a href='#' class='imgbtn'><span circularUserID='" + vo.memberID + "' onclick='showEdit(this)'>댓글</span></a></li>";
				userList += "<table circularUserID='" + vo.memberID + "'></table>";
				userList += "<div class='circularComment' circularUserID='" + vo.memberID + "' style='display:none'><input type = 'text'/><a href='#' class='imgbtn'><span onclick='showEdit()'>저장</span></a></div>";
				userList += "</ul>";
			});
			
			commentList = "";
			$("#commentUserList").html("");
			$("#commentUserList").append(userList);
			
			list = result.commentList;
			list.forEach(function(vo, index) {
				commentList = "<tr>";
				commentList += "<td circularCommentID='" + vo.circularCommentID + "'>content : " + vo.circularComment + "</td>";
				commentList += "<td>id,name : (" + vo.memberID + "/ " + vo.memberName + ")</td>";
				commentList += "<td>regDate : " + vo.regDate + "</td>";
				commentList += "</tr>";
				$("table[circularUserID='" + vo.circularUserID + "'").append(commentList);
			});
			
			//회람자 목록에 해당하는 코멘트
			
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

function showEdit(obj) {
	$(".circularComment").hide();
	$(".circularComment[circularUserID='" + $(obj).attr("circularUserID") + "']").show();
}

//댓글작성
function editCircularComment(circularID, circularUserID, circularComment, memberID, memberName, memberName2) {
	$.ajax({
		type : "POST",
		url : "ezCircular/editCircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID, // 회람ID
			circularUserID : circularUserID, // 회람자ID
			circularComment : circularComment, //회람 코멘트 본문
			memberID : memberID, //회람 코멘트 작성자ID
			memberName : memberName, //회람 코멘트 작성자이름
			memberName2 : memberName2 //회람 코멘트 작성자이름2
		},
		success : function(result) {
			getcircularComment();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	})
}