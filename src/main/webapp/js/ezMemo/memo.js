function createMemo(memo, flag) {
	
	var div = document.createElement("div");
	div.setAttribute("class", "mamo0"+ memo.color_id +" memoLay");
	div.id  = "memo" + memo.memo_id;
	div.setAttribute("orders", memo.orders)
	if(flag == 1) {
		div.style.opacity = 0.5;
	}
	
	/*var div = document.createElement("div");
	div.setAttribute("class", "individual-memo");
	div.style.backgroundColor = hColor;
	div.id  = "memo" + memoId;
	div.setAttribute("orders", orders)
	if(flag == 1) {
		div.style.opacity = 0.5;
	}*/
	
	var dl = document.createElement("dl");
	dl.setAttribute("class", "memoTit");
	
	if (flag != 'layer') {
		var input = document.createElement("input");
		input.setAttribute("name", "memo");
		input.setAttribute("type", "checkbox");
		input.setAttribute("value", memo.memo_id);
	}
	
	var dt = document.createElement("dt");
	dt.setAttribute("class", "mtitText");
	
	var dd = document.createElement("dd");
	dd.setAttribute("class", "memoIcon memoX");
	
	var dd2 = document.createElement("dd");
	dd2.setAttribute("class", "memoIcon pallete");
	
	dl.appendChild(dt);
	dl.appendChild(input);
	dl.appendChild(dd);
	dl.appendChild(dd2);
	
	var textarea = document.createElement("textarea");
	textarea.setAttribute("class", "memoText");
	textarea.setAttribute("memoId", memo.memo_id);
	textarea.style.fontSize = fontSize + "px";
	
	if(memo.contents != null) {
		textarea.innerHTML = memo.contents;
	}
	
	div.appendChild(dl);
	div.appendChild(textarea);
	
	/*
	var span = document.createElement("span");
	span.setAttribute("class", "write-date");
	
	var img = document.createElement("img");
	img.setAttribute("src", "/images/ezMemo/more.png");
	img.style.visibility = "hidden";
	img.style.float = "right";
	img.style.height = "20px";
	img.style.paddingRight = "10px";
	img.style.cursor = "pointer";
	
	var textarea = document.createElement("textarea");
	textarea.setAttribute("class", "memo-text");
	textarea.setAttribute("memoId", memoId);
	textarea.style.backgroundColor = bColor;
	textarea.style.fontSize = fontSize + "px";
	
	var closeImg = document.createElement("img");
	closeImg.setAttribute("src", "/images/ezMemo/close_xBtn.png");
	closeImg.style.visibility = "hidden";
	closeImg.style.float = "right";
	closeImg.style.height = "20px";
	closeImg.style.paddingRight = "10px";
	closeImg.style.cursor = "pointer";
	closeImg.id = "memoId" + memoId;
	
	if(contents != null) {
		textarea.innerHTML = contents;
	}
	
	for(var i=1; i<=6; i++) {
		var div3 = document.createElement("div");
		div3.setAttribute("class", "memo-color-list");
		div3.setAttribute("color-num", i);
		div2.appendChild(div3);
	}
	
	if (flag == 'layer') {
		div.appendChild(closeImg);
		
	} else {
		div.appendChild(input);
	}
	
	div.appendChild(dl);
	div.appendChild(span);
	div.appendChild(img);
	div.appendChild(textarea);
	*/
	
	return div;
}

function insertMemo(hColor, bColor, memoId, layerFlag) {
	var div = createMemo(hColor, bColor, memoId, null, layerFlag);
	
	if (layerFlag == 'layer') {
		$(".memo_main").prepend(div);
	} else {
		$("#boardMemoList").prepend(div);
	}
	if(useDate == 1)
		addDateInfo();
}


function loadMemoList(flag) {
	
	$("#boardMemoList").html('');
	$(".memo_main").html('');
	
	for(var i=0; i<memoList.length; i++) {
		if ('layer' != flag) {
			var hColor = memoColor[memoList[i].color_id-1];
			var bColor = memoColor[memoList[i].color_id+5];
			//var div = createMemo(hColor, bColor, memoList[i].memo_id, memoList[i].contents, memoList[i].display_flag, memoList[i].orders);
			var div = createMemo(memoList[i]);
			
			$("#boardMemoList").prepend(div);
		} else {
			if (memoList[i].display_flag != 1) {
				var hColor = memoColor[memoList[i].color_id-1];
				var bColor = memoColor[memoList[i].color_id+5];
				//var div = createMemo(hColor, bColor, memoList[i].memo_id, memoList[i].contents, flag, memoList[i].orders);
				var div = createMemo(memoList[i], flag);
				
				$(".memo_main").prepend(div);
			}
		}
		if(useDate == 1)
			addDateInfo(memoList[i].write_date.substring(0,10));
	}
}

function addDateInfo(date) {
    	var nowDate 
    	
    	if(date == null) {
    		nowDate = new Date();
    	}
    	else {
    		nowDate = new Date(date);
    	}
    	
    	var month = nowDate.getMonth() + 1;
    	var date = nowDate.getDate();
    	var day = nowDate.getDay();
    	
    	if(month < 10) {
    		month = "0"+month;
    	}
    	if(date < 10) {
    		date = "0"+date;
    	}

		$(".mtitText:first").html(month+"."+date+" ("+dayArray[day]+")");	
}

//날짜 초기화
function btn_PostDate_Clear() {
    $("#Sdatepicker").datepicker('setDate', "");
    $("#Edatepicker").datepicker('setDate', "");
}

// 검색 닫기
function BoardSearchOptionHidden() {		    	
	document.getElementById("layer_popup").style.display = "none";
	btn_PostDate_Clear();
	$("#searchTitle").val('');
     
    if (window.parent.frames['left'] != undefined) {
       $.modal.close();			       		
    }
    
    if (parent.parent.frames['left'] != undefined) {
       $.modal.close();
    }
}

//새로고침
function refresh_onclick() {
    window.location.href = "/ezMemo/memoMain.do";
}

//리스트설정 on/off 설정
function MailOptionView(obj) {
    if (obj.getAttribute("mode") == "off") {
        document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 210 + "px";
        document.getElementById("layer_Viewpopup").style.top = "100px";
        document.getElementById("layer_Viewpopup").style.display = "";
        obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
        obj.setAttribute("mode", "on");
    }
    else {
        MailOptionHidden();
    }
}

function MailOptionHidden() {
    document.getElementById("layer_Viewpopup").style.display = "none";
    document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
    document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");    
}

function MailOptionHiddenOutside(e) {
	var container = $('#layer_Viewpopup');
	var maillistoptionmode = $('#maillistoptiondiv').attr('mode');
	if (maillistoptionmode == "on") {
		if (container.has(e.target).length === 0 && $(e.target).attr('id') != 'maillistoptiondiv') {
			MailOptionHidden();
		}
	}
}