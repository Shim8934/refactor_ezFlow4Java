var searchMode = false; //검색중이면 오른쪽에 편지지함명

//편지지 검색
function letterSearch() {
	
	// 편지지(사용자) 중에서 검색 모드일때만
	if (pageType == 'letter_user') {
		searchMode = true;
	}
	
	var search = $("#lmSearchInput").val();
	if(search.trim() === "") {
		alert("검색어를 입력해주세요.");
		return;
	}
	
	// searchTxt 존재여부 확인하기
	if (searchTxt !== "") {
		searchTxt = search;
	}
	
	$.ajax({
		type : "POST",
		url : "/ezEmail/searchLetter.do?search=" + encodeURI(encodeURIComponent(search)),
		datatype : 'json',
		error : function(data) {
			alert("error");
			//console.log(data);
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


// 편지지 선택 (개별 조회 미리보기)
$(document).on("click", ".lmLetterListUl li:not(.lmLetterSelect)", function(){
	var letterNo = $(this).attr("data-letterno");
	
	$(this).css("background","#e9f1ff");
	$(this).parents("ul").find(".lmLetterSelect").css("background","none").removeClass("lmLetterSelect");
	$(this).addClass("lmLetterSelect");
	
	if (pageType != 'letter_user') {
		letterPreView(letterNo); // 편지지 미리보기
	}
	
});

// 편지지 마우스 올릴때 
$(document).on("mouseover", ".lmLetterListUl li:not('.lmLetterSelect') span", function(){
	$(this).parent("li").not(".lmLetterSelect").css("background","#f8f8f8");
});

// 편지지 마우스 땔때
$(document).on("mouseleave", ".lmLetterListUl li:not('.lmLetterSelect') span",function(){
	$(this).parent("li").not(".lmLetterSelect").css("background","none");
});

// 편지지 개별조회
function readLetter(letterNo) {
	$.ajax({
		type:"POST",
		data:{letterNo:letterNo},
		url:"/admin/ezEmail/readLetter",
		dataType:"json",
		success:function(data){
			
		}
	});
}

// 편지지 미리보기 
function letterPreView(letterNo) {
	$.ajax({
		type:"POST",
		data:{letterNo:letterNo},
		url:"/admin/ezEmail/readLetter",
		dataType:"json",
		success:function(data){
			var filePath = data.filePath; 
			var txtDisplay = "none";
			var iframeDisplay = "block";
			
			if (filePath == "ERROR") {
				txtDisplay = "block";
				iframeDisplay = "none";
				
				$(".lmPreViewIframe").attr("src", "");
				$(".lmPreViewTxt").text("존재하지 않는 편지지입니다.");
			} else {
				preViewIframe(filePath);
				
				$(".lmPreViewTxt").text("");
				$(".lmPreViewIframe").attr("data-letterName", data.displayname.replace(/</gi, "&lt;"));
			}
			
			$(".lmPreViewTxt").css("display",txtDisplay);
			$(".lmPreViewIframe").css("display",iframeDisplay);
		}
	});
}

function preViewIframe(filePath) {
	var path = filePath + "?rand=" + Math.random() + "&d=" + new Date().getSeconds();
	
	$(".lmPreViewIframe").attr("src", path);
}

// 편지지 리스트  nowSelect -> 선택 유지 시킬 id
function getLetterList(letterBoxNo, nowSelect) {
	$.ajax({
		type:"POST",
		data:{letterBoxNo:letterBoxNo},
		url:"/admin/ezEmail/readLetterList",
		dataType:"json",
		success:function(data){
			addLetterList(data, nowSelect); // 편지지 리스트 html
			
	    	$(".boxNo").attr("data-boxNo", letterBoxNo); // 편지지 리스트 div, 편지지 버튼 div => letterBoxNo
	    	
		},
		error:function(d){
			//console.log(d);
		}
	});
}
			    
// 편지지 목록 추가 
function addLetterList(jsonArr, nowSelect) {
	var letterListHtml = "";
	var listCount = jsonArr.length;

	if (listCount !== 0) {
		for (i = 0; i < listCount; i++) {
			
			letterListHtml += "<li id='lt" + jsonArr[i].letterNo + "' data-letterNo='" + jsonArr[i].letterNo + "' data-letterId='" + jsonArr[i].letterId + "'>"; 
			letterListHtml += "<span style='float:left'>" + jsonArr[i].displayname.replace(/</gi, "&lt;") + "</span>";
			
			if (pageType == 'letter_user') {
				if (searchMode) {
					var boxName = "";
					$.ajax({
						type:"POST",
						url:"/ezEmail/selectLetterBoxName.do?letterBoxNo=" + jsonArr[i].letterBoxNo,
						dataType:"json",
						async: false,
						success:function(data) {
							boxName = data.displayname;
						},
						error:function(data){
							alert("error");
							//console.log(data);
						}
					});
					
					letterListHtml += "<b>" + boxName + "</b>";
				}
			} else {
				letterListHtml += "<button class='lmLetterModifyBtn' onClick='letterEditPopUp(this)'>수정</button>";
				letterListHtml += "<button class='lmLetterDeleteBtn'>삭제</button>";
			}
			
			letterListHtml += "</li>";
		}
	} else {
    	letterListHtml = "<li class='lmNoData'>데이터가 없습니다.</li>";
	}
	
	$(".lmLetterListUl").html(letterListHtml);

	// 선택한 편지지 목록 유지
	if (nowSelect !== undefined) {
		$(document).find("#" + nowSelect).addClass("lmLetterSelect");
		$(".lmLetterSelect").css("background","#e9f1ff");
	}
	
	letterListCss(pageType, searchMode);
	searchMode = false;
}

function letterListCss(pageType, searchMode) {
	if (pageType === 'letter_user' && searchMode === true) {
		$(".lmLetterListUl li > span").css({
			"width":"70%",
			"margin":"0"
		});
		
		$(".lmLetterListUl li > b").css({
			"width":"30%",
			"display":"inline-block",
			"overflow":"hidden",
			"text-overflow":"ellipsis",
			"white-space":"nowrap"
		});
	}
}
