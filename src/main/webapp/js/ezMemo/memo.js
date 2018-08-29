function createMemo(hColor, bColor, memoId, contents, flag) {
	
	var div = document.createElement("div");
	div.setAttribute("class", "individual-memo");
	div.style.backgroundColor = hColor;
	div.id  = "memo" + memoId;
	
	var input = document.createElement("input");
	input.setAttribute("name", "memo");
	input.setAttribute("type", "checkbox");
	input.setAttribute("value", memoId);
	
	var div2 = document.createElement("div");
	div2.setAttribute("class", "memo-color");
	
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
	
	div.appendChild(div2);
	div.appendChild(span);
	div.appendChild(img);
	div.appendChild(textarea);
	
	return div;
}

function insertMemo(hColor, bColor, memoId, layerFlag) {
	var div = createMemo(hColor, bColor, memoId, null, layerFlag);
	
	if (layerFlag == 'layer') {
		$("#memoList").prepend(div);
	} else {
		$("#boardMemoList").prepend(div);
	}
	addDateInfo();
}


function loadMemoList(flag) {
/*function loadMemoList() {*/
	$("#boardMemoList").html('');
	$("#memoList").html('');
	
	for(var i=0; i<memoList.length; i++) {
		if ('layer' != flag) {
			var hColor = memoColor[memoList[i].color_id-1];
			var bColor = memoColor[memoList[i].color_id+5];
			var div = createMemo(hColor, bColor, memoList[i].memo_id, memoList[i].contents, flag);
			
			$("#boardMemoList").prepend(div);
		} else {
			if (memoList[i].display_flag != 1) {
				var hColor = memoColor[memoList[i].color_id-1];
				var bColor = memoColor[memoList[i].color_id+5];
				var div = createMemo(hColor, bColor, memoList[i].memo_id, memoList[i].contents, flag);
				
				$("#memoList").prepend(div);
			}
		}
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

		$(".write-date:first").html(month+"."+date+" ("+dayArray[day]+")");	
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