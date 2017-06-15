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
					list += "  	<a class='ui-btn ui-btn-icon-right ui-icon-carat-r' href='/mobile/ezApprovalG/doApprovalGDetail.do?docID=" + value.docID + "' >";					    		
					list +=	"  		<h2 style='font-size:12px'>" + value.writerName + "</h2>";
					list += "  		<p class='ui-li-aside'>" + value.startDate + "</p>";
					list +=	"  		<p>" + value.docTitle + "</p>";						    	
					list += "  	</a>";
					list += "</li>";
				});

				$("#apprList").html(list);
			} else {
				list += "<li class='ui-first-child'>";
				list +=	"  	<p>데이터가 없습니다.</p>";						    	
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