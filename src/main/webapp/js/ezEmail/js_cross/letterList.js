var searchMode = false; //검색중이면 오른쪽에 편지지함명

//편지지 검색
function letterSearch() {
	
	// 편지지(사용자) 중에서 검색 모드일때만
	if (pageType == 'letter_user') {
		searchMode = true;
	}
	
	var search = $("#lmSearchInput").val();
	if(search.trim() == "") {
		alert("검색어를 입력해주세요.");
		return;
	}
	
	$.ajax({
		type : "POST",
		url : "/ezEmail/searchLetter.do?search=" + search,
		datatype : 'json',
		error : function(data) {
			alert("error");
			console.log(data);
		},
		complete : function(data) {
			addLetterList(data.responseJSON);
			
	    }
	});
	
}

//검색어 초기화
function inputReset(){
	$(".searchInput").val("");
}

//편지지 삭제
$(document).on("click", ".lmLetterListUl .lmLetterDeleteBtn", function(){
	var deleteChk = confirm("정말로 삭제하시겠습니까?");
	
	if(deleteChk) {
		var letterId = $(this).parent("li").attr("data-letterId");
		var letterBoxNo = $(this).parents(".boxNo").attr("data-boxNo");
		var letterNo = $(this).parent("li").attr("data-letterNo");
		
		$.ajax({
			type:"POST",
			data:{letterNo:letterNo,letterBoxNo:letterBoxNo,letterId:letterId},
			url:"/admin/ezEmail/deleteLetter",
			success:function(){
				getLetterList(letterBoxNo);
				alert("삭제하였습니다.");
			}
		});
	}
	
});

// 편지지 선택 (개별 조회)
$(document).on("click", ".lmLetterListUl li span", function(){
	var letterNo = $(this).parent("li").attr("data-letterno");
	
	$(this).parent("li").css("background","#e9f1ff");
	$(this).parents("ul").find(".lmLetterSelect").css("background","none").removeClass("lmLetterSelect");
	$(this).parent("li").addClass("lmLetterSelect");
	
	letterPreView(letterNo); // 편지지 미리보기
});

// 편지지 마우스 올릴때 
$(document).on("mouseover", ".lmLetterListUl li:not('.lmLetterSelect') span", function(){
	$(this).parent("li").not(".lmLetterSelect").css("background","#f8f8f8");
});

// 편지지 마우스 땔때
$(document).on("mouseleave", ".lmLetterListUl li:not('.lmLetterSelect') span",function(){
	$(this).parent("li").not(".lmLetterSelect").css("background","none");
});

// 편지지 미리보기
function letterPreView(letterNo) {
	$.ajax({
		type:"POST",
		data:{letterNo:letterNo},
		url:"/admin/ezEmail/readLetter",
		dataType:"json",
		success:function(data){
			$(".lmPreViewTxt").css("display","none");
			$(".lmPreViewIframe").attr("src",data.filePath);
			$(".lmPreViewIframe").css("display","block");
		}
	});
}

// 편지지 리스트
function getLetterList(letterBoxNo) {
	$.ajax({
		type:"POST",
		data:{letterBoxNo:letterBoxNo},
		url:"/admin/ezEmail/readLetterList",
		dataType:"json",
		success:function(data){
			addLetterList(data); // 편지지 리스트 html
			
	    	$(".boxNo").attr("data-boxNo", letterBoxNo); // 편지지 리스트 div, 편지지 버튼 div => letterBoxNo
		},
		error:function(d){
			console.log(d);
		}
	});
}
			    
// 편지지 목록 추가 
function addLetterList(jsonArr) {
	
	var letterListHtml = "";
	var listCount = jsonArr.length;

	if (listCount != 0) {
		for (i = 0; i < listCount; i++) {
			letterListHtml += "<li data-letterNo='" + jsonArr[i].letterNo + "' data-letterId='" + jsonArr[i].letterId + "'>"; 
			letterListHtml += "<span style='float:left'>" + jsonArr[i].displayname + "</span>";
			
			if (pageType == 'letter_user') {
				if (searchMode) {
					var boxName;
					
					$.ajax({
						type:"POST",
						url:"/ezEmail/selectLetterBoxName.do?letterbox_no=" + jsonArr[i].letterbox_no,
						dataType:"json",
						async: false,
						success:function(data) {
							boxName = data.displayname;
						},
						error:function(data){
							alert("error");
							console.log(data);
						}
					});
					
					letterListHtml += "<span style='float:right'>" + boxName + "</span>";
				}
			} else {
				letterListHtml += "<button class='lmLetterModifyBtn' onClick='letterEditPopUp()'>수정</button>";
				letterListHtml += "<button class='lmLetterDeleteBtn'>삭제</button>";
			}
			
			letterListHtml += "</li>";
		}
	} else {
    	letterListHtml = "<li class='lmNoData'>데이터가 없습니다.</li>";
	}
	
	searchMode = false;
	$(".lmLetterListUl").html(letterListHtml);
}

// 편지지 이동
function letterBoxMove(btn){
	// 편지지함 no
	letterNo = $(".lmLetterSelect").attr("data-letterno");
	
	if (letterNo !== "undefined") {
		//url
		url = "/admin/ezEmail/letterBoxMovePopUp.do?" + "letterNo=" + letterNo;  
			
		window.open(url,"_blank","width=890, height=660");
	}
}
