var searchMode = false; //검색중이면 오른쪽에 편지지함명

// 편지지 검색
function letterSearch() {
	var search = $("#lmSearchInput").val();
	
	// 편지지(사용자) 중에서 검색 모드일때만
	if (pageType == 'letter_user' || pageType == 'letter') {
		searchMode = true;
	}
	
	if(search.trim() === "") {
		alert(searchMsg);
		searchMode = false;
		return;
	}
	
	// searchTxt 존재여부 확인하기
	if (searchTxt !== undefined) {
		searchTxt = search;
	}
	
	disableChk();
	
	$.ajax({
		type : "POST",
		url : "/ezEmail/searchLetter.do",
		datatype : 'json',
		data : {'search': encodeURIComponent(search), "companyId" : returnCompany},
		error : function(data) {
			alert("error");
			//console.log(data);
		},
		complete : function(data) {
			addLetterList(data.responseJSON);
	    }
	});
}

// 검색어 초기화
function inputReset(){
	$(".searchInput").val("");
}

function disableChk() {
	var search = $("#lmSearchInput").val();
	
	if(search.trim() !== "") {
		//$(".searchDis").attr("disabled",true);
	}
}

// 예외처리                  (문자, 특수문자 허용여부, 길이, 대상 메시지)
function strChk(str, speChar, strLen, kindMsg) {
	// 공백, 특수문자, 길이
	var strTrim = str.trim();
	var msg = "";
	var reJson = {};
	
	if (strTrim != "") {
		if (!speChar) { 
			var speCha = /[`~!<>@#$%^&*|\\\"\';:\/?]/gi;
			
			if (speCha.test(strTrim)) {
				msg = specialMsg + "\n" + specialMsg2;
			}	
		}
		
		if (strLen !== undefined) {
			if (strTrim.length >= strLen) {
				msg = kindMsg + " " + strLen + lengthMsg;      
			} 
		}
	}else {
		msg = contentMsg;
	}
	
	reJson.str = strTrim;
	reJson.msg = msg;
	
	return reJson;
}

// 편지지 미리보기 
function letterPreView(letterNo) {
	$.ajax({
		type:"POST",
		data:{letterNo:letterNo},
		url:"/admin/ezEmail/readLetter",
		dataType:"json",
		success:function(data){
			lmPreviewChange(data);
		}
	});
}

function preViewIframe(filePath) {
	var path = filePath === "ERROR" ? "" : filePath + "?rand=" + Math.random() + "&d=" + new Date().getSeconds();
	
	$(".lmPreViewIframe").attr("src", path);
}

function lmPreviewChange(data) {
	var preTxt = $(".lmPreViewTxt");
	var preIframe = $(".lmPreViewIframe");
	var txtDisplay = "block";
	var iframeDisplay = "none";
	var ifrLetterName = "";
	var ifrLetterNo = "";
	var txtText = previewMsg;
	var filePath = "ERROR";
	var strLang = typeof(userLang) == "undefined" ? 1 : userLang;
	
	if (data !== undefined) {
		var filePathTmp = data.filePath;
		var langDisplayName = strLang == 1 ? data.displayname : data.displayname2;
		
		ifrLetterName = langDisplayName.replace(/</gi, "&lt;");
		ifrLetterNo = data.letterNo;
		
		if (filePathTmp === "ERROR") {
			txtText = letterNoMsg;
		} else {
			txtText = "";
			txtDisplay = "none";
			iframeDisplay = "block";
			filePath = filePathTmp;
		}
	}
	
	preViewIframe(filePath);
	preTxt.css("display", txtDisplay);
	preIframe.css("display", iframeDisplay);
	preTxt.text(txtText);
	preIframe.attr("data-lettername", ifrLetterName);
	preIframe.attr("data-letterno", ifrLetterNo);
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
			//console.log(d);
		}
	});
}
			    
// 편지지 목록 추가 
function addLetterList(jsonArr) {
	var letterListHtml = "";
	var listCount = jsonArr.length;
	var nowSelect = $(".lmLetterSelect").attr("id"); // 선택중인 편지지 id
	var strLang = typeof(userLang) == "undefined" ? 1 : userLang;

	if (listCount !== 0) {
		for (i = 0; i < listCount; i++) {
			var langDisplayName = strLang == 1 ? jsonArr[i].displayname : jsonArr[i].displayname2;
			langDisplayName = langDisplayName.replace(/</gi, "&lt;");
			letterListHtml += "<li id='lt" + jsonArr[i].letterNo + "' data-letterNo='" + jsonArr[i].letterNo + "' data-letterId='" + jsonArr[i].letterId + 
			"' data-letterBoxNo='" + jsonArr[i].letterBoxNo + "'>";
			
			if (pageType == 'letter_user') {
				var boxNameTag = "";
				if (searchMode) {
					try {
						$.ajax({
							type:"POST",
							url:"/ezEmail/selectLetterBoxName.do",
							dataType:"json",
							data : {"letterBoxNo" : jsonArr[i].letterBoxNo},
							async: false,
							success:function(data) {
								var boxName = data.displayname;
								boxNameTag = "<b title='" + boxName + "'>" + boxName + "</b>";
							}
						});
					} catch(e) {console.log(e);}
				}	
				
				letterListHtml += "<span style='width:100%'>" + langDisplayName + "</span>" + boxNameTag;
			} else {
				letterListHtml += "<span style='max-width:65%; padding-right:10px;'>" + langDisplayName + "</span>";
				letterListHtml += "<div><button class='lmLetterModifyBtn' onClick='letterEditPopUp(this)'>" + modifyMsg + "</button>";
				letterListHtml += "<button class='lmLetterDeleteBtn'>" + deleteMsg + "</button></div>";
			}
			
			letterListHtml += "</li>";
		}
	} else {
    	letterListHtml = "<li class='lmNoData'><span style='width:100%;'>" + dataNoMsg + "<span></li>";
	}
	
	$(".lmLetterListUl").html(letterListHtml);
	
	// 선택한 편지지 목록 유지
	if (nowSelect !== undefined && nowSelect !== "") {
		$(document).find(".lmLetterListUl #" + nowSelect).click();
	} 
	
	letterListCss(pageType, searchMode);
}

//편지지 검색 시 엔터 사용
function letterSearchEnter() {
	if (event.keyCode == 13) {
		letterSearch();
	}
}

function letterListCss(pageType, searchMode) {
	if (pageType === 'letter_user' && searchMode === true) {
		$(".lmLetterListUl li > b").css({
			"width":"45%",
			"display":"inline-block",
			"overflow":"hidden",
			"text-overflow":"ellipsis",
			"white-space":"nowrap",
			"line-height":"30px"
		});
	}
}

// 미리보기 onload
function onloadPreview(ifr) {
	var ifrHead = $(ifr).contents().find("head");
	
	$(ifrHead).html("<style> html { height:520px; } p {margin-top: 0; margin-bottom: 0;}</style>");
}

// 편지지 선택 (개별 조회 미리보기)
$(document).on("click", ".lmLetterListUl li:not(.lmLetterSelect)", function(){
	var letterNo = $(this).attr("data-letterno");
	
	$(this).css("background","#f0f6ff");
	$(this).parents("ul").find(".lmLetterSelect").css("background","none").removeClass("lmLetterSelect");
	$(this).addClass("lmLetterSelect");
	
	if (pageType != 'letter_user') {
		letterPreView(letterNo); // 편지지 미리보기
	}
});

// 편지지 마우스 올릴때 
$(document).on("mouseover", ".lmLetterListUl li:not('.lmLetterSelect')", function(){
	$(this).css("background","#f8f8f8");
});

// 편지지 마우스 땔때
$(document).on("mouseleave", ".lmLetterListUl li:not('.lmLetterSelect')",function(){
	$(this).css("background","none");
});

