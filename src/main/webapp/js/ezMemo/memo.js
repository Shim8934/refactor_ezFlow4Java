function createMemo(hColor, bColor, memoId) {
	/*var html = "";
	html += "<div class='individual-memo' style='background-color:"+ headerColor +"'>";
	html += "<input type='checkbox' name='memo'>";
	html += "<div class='memo-color'>";
	html += "<div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div></div>";
	html += "<span class='write-date'></span>";
	 html += "<img src='/images/close_xBtn.png' style='visibility:hidden; float:right; height:20px; padding-right:5px; cursor:pointer'>"; 
	html += "<img src='/images/ezMemo/more.png' style='visibility:hidden; float:right; height:20px; padding-right:10px; cursor:pointer'>";
	html += "<textarea class='memo-text' style='background-color:"+ bodyColor +"'>";
	html += "</textarea>";
	html += "</div>"
	$("#memoList").prepend(html);
	$("#textarea").val('');*/
	
	var div = document.createElement("div");
	div.setAttribute("class", "individual-memo");
	div.style.backgroundColor = hColor;
	
	var input = document.createElement("input");
	input.setAttribute("name", "memo");
	input.setAttribute("type", "checkbox");
	
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
	
	for(var i=1; i<=6; i++) {
		var div3 = document.createElement("div");
		div3.setAttribute("class", "memo-color-list");
		div3.setAttribute("color-num", i);
		div2.appendChild(div3);
	}
	div.appendChild(div2);
	div.appendChild(input);
	div.appendChild(span);
	div.appendChild(img);
	div.appendChild(textarea);
	
	$("#boardMemoList").prepend(div);
	
	addDateInfo();
}

function loadMemoList() {
	var html = "";
	html += "<div class='individual-memo' style='background-color:"+ memoColor[memoList[i].color_id-1] +"'>";
	html += "<input type='checkbox' name='memo'>";
	html += "<div class='memo-color'>";
	html += "<div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div></div>";
	html += "<span class='write-date'></span>";
//	html += "<img src='/images/close_xBtn.png' style='visibility:hidden; float:right; height:20px; padding-right:5px; cursor:pointer'>"; 
	html += "<img src='/images/ezMemo/more.png' style='visibility:hidden; float:right; height:20px; padding-right:10px; cursor:pointer'>";
	html += "<textarea class='memo-text' style='background-color:"+ memoColor[memoList[i].color_id+5] +"'>";
	html += memoList[i].contents;
	html += "</textarea>";
	html += "</div>"
	$("#memoList").prepend(html);
	$("#textarea").val('');
	
	addDateInfo(memoList[i].write_date.substring(0,10));
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