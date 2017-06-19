/** 이효진 작성*/
function getcircularComment() {
	$.ajax({
		type : "POST",
		url : "/ezCircular/getcircularComment.do",
		dataType : "json",
		data : {
			circularID : circularID
		},
		success : function(result) {
			//회람자 목록
			
			//회람자 목록에 해당하는 코멘트
			
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}

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