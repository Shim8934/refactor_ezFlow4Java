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
				circularUserList += "<tr class='circularUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left'>";
//				circularUserList += "<td style='text-align:left;'>" + vo.memberName + "&nbsp;<a class='imgbtn' style='vertical-align:middle;'><span circularUserID='" + vo.memberID + "' onclick='showEdit(this)'>의견작성</span></a></td>"
				
				circularUserList += "<th style='border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left'>";
				circularUserList += "<img src='/images/i_group.gif' align='middle'/>&nbsp;" + vo.memberName + "&nbsp;";
				circularUserList += "<img src='/images/modify2.gif' style='cursor:pointer;' align='middle' onclick='alert(2222222222222);'/>&nbsp;&nbsp;&nbsp;&nbsp;" + vo.confirmDate;
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
				circularCommentList += "<td style='padding-left:3px'><img src='/images/i_rep.gif' align='middle'/>" + vo.memberName + "</td>";
				circularCommentList += "<td style='text-align:left;padding:10px;'>" + vo.circularComment +  "&nbsp;(" + vo.regDate.substring(11, 19) + ")&nbsp;";
				
				if (vo.memberID == userInfoID) {
					circularCommentList = "<img src='/images/comment_del.gif' align='middle' style='cursor:pointer;' onclick='deleteCircularComment(this)'/></td>";
				}
				
				circularCommentList += "<td style='text-align:right;padding-right:8px'>" + vo.regDate.substring(0, 10) + "</td>";
				circularCommentList  += "</tr>";
				
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
	$("tr.circularComment").remove();
	
	var commentEditor = "";
	commentEditor += "<tr class='circularComment' circularUserID='" + $(obj).attr("circularUserID") + "' circularID='" + circularID + "'>";
	commentEditor += "<td style='border:0px;' colspan='3'><textarea style='width:97%; text-align:left;' /></td>";
	commentEditor += "<td style='width:50px; border:0px; text-align:right;'><a class='imgbtn' style='text-align:right;'><span circularUserID='" + $(obj).attr("circularUserID") + "' onclick='editCircularComment(this)'>저장</span></a></td>";
	commentEditor += "</tr>";
	
	$("table[circularUserID='" + $(obj).attr("circularUserID") + "']").html(commentEditor + $("table[circularUserID='" + $(obj).attr("circularUserID") + "'] tbody").html());
	$("table[circularUserID='" + $(obj).attr("circularUserID") + "']").closest("tr").show();
}

//댓글작성
function editCircularComment(obj) {
	var circularUserID = $(obj).attr("circularUserID");
	var circularComment = $("tr.circularComment[circularUserID='" + $(obj).attr("circularUserID") + "'] > td > textarea").val();
	
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