/**
 * 
 */

$(document).ready(function() {
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
//					list += "<div class='animateMe1 ui-collapsible ui-collapsible-inset ui-corner-all ui-collapsible-themed-content ui-collapsible-collapsed' data-role='collapsible' data-iconpos='right' data-inset='true'>";
//					list += "	<h2 class='ui-collapsible-heading ui-collapsible-heading-collapsed'>";
//					list += "		<a class='ui-collapsible-heading-toggle ui-btn ui-btn-icon-right ui-btn-inherit ui-icon-plus' href='#'>";
//					list += 			value.userName + " " + value.userJobTitle + "(" + value.userDeptName + ")";
//					list += "			<span class='ui-collapsible-heading-status'> click to expand contents</span>";
//					list += "		</a>";
//					list += "	</h2>";
//					list += "	<div class='ui-collapsible-content ui-body-inherit ui-collapsible-content-collapsed' aria-hidden='true'>";
//					list += "		<p>" + value.content + "</p>";
//					list += "	</div>";
//					list += "</div>";
					
					list += "<div data-role=\"collapsible\" class=\"animateMe1\" data-iconpos=\"right\" data-inset=\"true\">";
					list += "	<h2>" + value.userName + " " + value.userJobTitle + "(" + value.userDeptName + ")</h2>";
					list += "	<p>" + value.content + "</p>";
					list += "</div>";
				});
				
				$("#set").html(list).collapsibleset("refresh");
				
			} else {
				list += "<h3 style='text-align: center'>의견이 없습니다.</h3>";
				
				$("#opinionList").html(list);
			}
			
		},
		error : function(xhr, status, error) {
			
		}
	});
	
	$("#popupComment").popup("open");
}

function writeComment() {
	
}