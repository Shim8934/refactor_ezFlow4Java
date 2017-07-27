/**
 * 
 */

$(document).ready(function() {
	getApproveList("DO");
	getApproveListCount("DO");

	$.searchApprove = function() {
		alert("Search!");
	}
});

$(document).on('pageshow', '#doApproveDetail', function() {
	$('.writeButton').css('bottom', 60);
	$('.writeButton').css('left', $(window).width() - 60 );
	
	$(window).on('resize', function() {
		$('.writeButton').css('bottom', 60);
		$('.writeButton').css('left', $(window).width() - 60 );
	});
});

function searchApprove() {
	if ($("#searchApprove").css("display") == "none") {
   		$("#searchApprove").slideDown(250);
   	} else {	
   		$("#searchApprove").slideUp(250);
	} 
}

function approveList() {
	if ($("#approveList").css("display") == "none") {
		$("#approveList").slideDown(250);
	} else {	
		$("#approveList").slideUp(250);
	} 
}

//검색버튼 누른후 리스트 가져오기
function searchApproveList() {
	var searchText = $("#searchApprroveInput").val();
	
	$.ajax({
		type : "POST",
		url : "/mobile/ezApprovalG/doSearchApproveList.do",
		dataType : "json",
		data : {
			pSearchText : searchText
		},
		success : function(data) {
			var list = "";

			//리스트 업데이트
			if (data.docList.length > 0) {
				$.each(data.docList, function(key, value) {
					list += "<li class='ui-first-child'>";
					list += "  	<a class='ui-btn ui-btn-icon-right ui-icon-carat-r' href='/mobile/ezApprovalG/doApprovalGDetail.do?pDocID=" + value.docID + "' >";
					list +=	"  		<h2 style='font-size:12px'>" + value.writerName + "</h2>";
					list += "  		<p class='ui-li-aside'>" + value.startDate + "</p>";
					list +=	"  		<p>" + value.docTitle + "</p>";
					list += "  	</a>";
					list += "</li>";
				});

				$("#apprList").html(list);
			} else {
				list += "<li class='ui-first-child'>";
				list +=	"  	<p>결재할문서가 없습니다.</p>";
				list += "</li>";
				
				$("#apprList").html(list);
			}
			
			//리스트 카운트 업데이트
			$("#listCount").text("(" + data.listCount + ")");
		},
		error : function(xhr, status, error) {
			
		}
	});
}

function getApproveList(type) {
	$.ajax({
		type : "POST",
		url : "/mobile/ezApprovalG/mGetApproveList.do",
		dataType : "json",
		data : {
			pType : type,
			pSearchText : "",
			pLastDate : ""
		},
		success : function(data) {
			var list = "";
			
			//리스트 업데이트
			if (data.approvalList.length > 0) {
				$.each(data.approvalList, function(key, value) {
					list += "<li class='ui-first-child'>";
					list += "  	<a class='ui-btn ui-btn-icon-right ui-icon-carat-r' href='/mobile/ezApprovalG/doApprovalGDetail.do?pDocID=" + value.docID + "' >";
					list +=	"  		<h2 style='font-size:12px'>" + value.writerName + "</h2>";
					list += "  		<p class='ui-li-aside'>" + value.startDate + "</p>";
					list +=	"  		<p>" + value.docTitle + "</p>";
					list += "  	</a>";
					list += "</li>";
				});
				
				$("#apprList").html(list);
			} else {
				list += "<li class='ui-first-child'>";
				list +=	"  	<p>결재할문서가 없습니다.</p>";
				list += "</li>";
				
				$("#apprList").html(list);
			}
			
			//리스트 카운트 업데이트
//			$("#listCount").text("(" + data.listCount + ")");
		},
		error : function(xhr, status, error) {
			
		}
	});
}

function getApproveListCount(type) {
	$.ajax({
		type : "POST",
		url : "/mobile/ezApprovalG/mGetApproveListCount.do",
		dataType : "json",
		data : {
			pType : type,
			pSearchText : ""
		},
		success : function(data) {
			var list = "";
			
			
			//리스트 카운트 업데이트
			$("#listCount").text("(" + data.listCount + ")");
		},
		error : function(xhr, status, error) {
			
		}
	});
}

function backApproveList() {
	window.location.href = "/mobile/ezApprovalG/doApproveList.do";
}

function showOriginal() {
	alert("원문보기");
}

function showComment(docID, listType) {
	$.ajax({
		type : "POST",
		url : "/mobile/ezApprovalG/getOpinionInfo.do",
		dataType : "json",
		data : {
			pDocID : docID,
			pListType : listType
		},
		success : function(data) {
			var list = "";
			
			if (data.opinionList.length > 0) {
				$.each(data.opinionList, function(key, value) {
					list += "<div data-role=\"collapsible\" class=\"animateMe1\" data-iconpos=\"right\" data-inset=\"true\">";
					list += "	<h2>" + value.userName + " " + value.userJobTitle + "(" + value.userDeptName + ")</h2>";
					list += "	<p>" + "의견종류 : " + value.opinionGB + "<br/>내용 : " + value.content + "</p>";
					list += "</div>";
				});
				
				$("#popupCommentSet").html(list).collapsibleset("refresh");
				
			} else {
				list += "<h3 style='text-align: center'>의견이 없습니다.</h3>";
				
				$("#popupCommentSet").html(list);
			}
			
		},
		error : function(xhr, status, error) {
			
		}
	});
	
	$("#popupComment").popup("open");
}

function writeComment(docID, listType) {
	$.ajax({
		type : "POST",
		url : "/mobile/ezApprovalG/getOpinionInfo.do",
		dataType : "json",
		data : {
			pDocID : docID,
			pListType : listType
		},
		success : function(data) {
			var list = "";
			
			if (data.opinionList.length > 0) {
				$.each(data.opinionList, function(key, value) {
					if (value.userID == data.userID) {
						$("#writeComment").val(value.content);
					}
				});
			} 
		},
		error : function(xhr, status, error) {
			
		}
	});
	
	$("#popupWriteComment").popup("open");
}

function commentSave(docID) {
	$.ajax({
		type : "POST",
		url : "/mobile/ezApprovalG/saveOpinionInfo.do",
		dataType : "json",
		data : {
			pDocID    : docID,
			pContent  : $("#writeComment").val(), 
			pOpinionGB: "001"
		},
		success : function() {
		},
		error : function(xhr, status, error) {
			
		}
	});
	
	//닫는게 아니라 새로고침을 한번 해주든가 카운트만 새로고침해야할듯
	$("#popupWriteComment").popup("close");
}