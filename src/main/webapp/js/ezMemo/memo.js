function createMemo(memo, flag) {
	
	var div = document.createElement("div");
	div.setAttribute("class", "mamo0"+ memo.color_id +" memoLay");
	div.id  = "memo" + memo.memo_id;
	div.setAttribute("orders", memo.orders)
	if(memo.display_flag == 1) {
		div.style.opacity = 0.6;
	}
	
	var dl = document.createElement("dl");
	dl.setAttribute("class", "memoTit");
	
	if (flag != 'layer') {
		
		var label = document.createElement("label");
		label.setAttribute("for", memo.memo_id);
		label.style.width = "175px";
		label.style.height = "36px";
		label.style.position = "absolute";
		label.style.left = "0px";
		
		var input = document.createElement("input");
		input.setAttribute("id", memo.memo_id);
		input.setAttribute("name", "memo");
		input.setAttribute("type", "checkbox");
		input.setAttribute("value", memo.memo_id);
		input.setAttribute("display", memo.display_flag);
		
		dl.appendChild(label);
		dl.appendChild(input);
		
	} 
	
	var dt = document.createElement("dt");
	dt.setAttribute("class", "mtitText");
	
	var dd2 = document.createElement("dd");
	dd2.setAttribute("class", "memoIcon pallete");
	
	var dd3 = document.createElement("dd");
	dd3.setAttribute("class", "memoIcon saveBtn");
	dd3.setAttribute("memoid", memo.memo_id);
	/*dd3.style.cursor= "pointer";
	dd3.innerHTML = "+";*/
	
	var dd = document.createElement("dd");
	dd.setAttribute("class", "memoIcon memoX");
	dd.setAttribute("memoId", memo.memo_id);
	dd.setAttribute("onclick", "addRemoveButton("+memo.memo_id+")");
	
	dl.appendChild(dt);
	dl.appendChild(dd);
	dl.appendChild(dd2);
	dl.appendChild(dd3);
	
	var textarea = document.createElement("textarea");
	textarea.setAttribute("class", "memoText");
	textarea.setAttribute("memoId", memo.memo_id);
	textarea.style.fontSize = fontSize + "px";
	
	if(memo.contents != null) {
		textarea.value = memo.contents;
	}
		
	var ul = document.createElement("ul");
	ul.setAttribute("class", "color_popup");
	ul.style.visibility = "hidden";
	
	for(var i=1; i<=6; i++) {
		var li = document.createElement("li");
		li.setAttribute("class", "color0" + i + " color_list");
		ul.appendChild(li);
	}
	
	div.appendChild(dl);
	div.appendChild(textarea);
	div.appendChild(ul);
	
	return div;
}

function insertMemo(memo, layerFlag) {
	
	$(".memo_add").remove();
	
	var div = createMemo(memo, layerFlag);
	
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
	$(".memo_add").remove();
	$(".memo_main").html('');
	
	if(memoList.length == 0) {
		addEmptyMemo(flag);
	}
	/*if(memoList.length == 0 && flag != 'layer') {		// 메모 게시판 게시물 없을 때
		
		var div = document.createElement("div");
		div.setAttribute("class", "memo_add");
		div.style.margin = "10px";
		
		var span = document.createElement("span");
		span.innerHTML = strLangMemo7;
		
		div.appendChild(span);
		
		$("#boardMemoList").parent().prepend(div);
		
		return;
	} else if(memoList.length == 0 && flag == 'layer') {
		var div = document.createElement("div");
		div.setAttribute("class", "memo_add");
		div.id = "addFirstMemo";
		var span = document.createElement("span");
		span.innerHTML = strLangMemo7;
		
		div.appendChild(span);
		
		$(".memo_main").prepend(div);
	}*/
	
	for(var i=0; i<memoList.length; i++) {
		if ('layer' != flag) {
			var hColor = memoColor[memoList[i].color_id-1];
			var bColor = memoColor[memoList[i].color_id+5];
			var div = createMemo(memoList[i]);
			
			$("#boardMemoList").prepend(div);
		} else {
			if (memoList[i].display_flag != 1) {
				var hColor = memoColor[memoList[i].color_id-1];
				var bColor = memoColor[memoList[i].color_id+5];
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

function addRemoveButton(memoId) {
	var modal = document.createElement('div');
	modal.setAttribute("class", "memoModal");
	modal.setAttribute("id", "modal" + memoId);
	modal.setAttribute("onclick", "$('#modal"+memoId+"').remove()");
	
	var alertPopup = document.createElement('div');
	alertPopup.setAttribute("class", "alertPopup");
	alertPopup.setAttribute("id", "memo" + memoId);
	
	var popHeader = document.createElement('div');
	popHeader.setAttribute("class", "memoPopHeader");
	popHeader.innerHTML = "<span>"+strLangMemo4+"</span>";
	
	var popContainer = document.createElement('div');
	popContainer.setAttribute("class", "popContainer");
	
	var txtDialog = document.createElement('div');
	txtDialog.setAttribute("class", "txtDialog");
	
	var footBtn = document.createElement('p');
	footBtn.setAttribute("class", "footBtn");
	//footBtn.innerHTML = "<div class='modRm-wrap'><span class='modRm' id='modRm" +memoId +"' onclick='modalDelete("+ memoId +")'>"+strLangMemo5+"</span></div><div class='close-wrap'><span class='close' id='close" +memoId +"' onclick=$('#modal"+memoId+"').remove()>"+strLangMemo6+"</span></div>";
	
	var div = document.createElement("div");
	div.setAttribute("class", "modRm-wrap");
	
	var span = document.createElement("span");
	span.setAttribute("class", "modRm");
	span.setAttribute("id", "modRm"+memoId);
	span.setAttribute("onclick", "modalDelete("+memoId+")");
	span.innerHTML = strLangMemo5;

	var div2 = document.createElement("div");
	div2.setAttribute("class", "close-wrap");

	var span2 = document.createElement("span");
	span2.setAttribute("class", "close");
	span2.setAttribute("id", "close"+memoId);
	span2.setAttribute("onclick", "$('#modal"+memoId+"').remove()");
	span2.innerHTML = strLangMemo6;
	
	div.appendChild(span);
	div2.appendChild(span2);
	footBtn.appendChild(div);
	footBtn.appendChild(div2);
	txtDialog.appendChild(footBtn);
	popContainer.appendChild(txtDialog);
	popHeader.appendChild(popContainer);
	alertPopup.appendChild(popHeader);
	modal.appendChild(alertPopup)
		
	//modal.addEventListener('click', modalDelete, false);
	$("#memo" + memoId).prepend(modal);
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
// 메모지 이벤트 추가
function addremove() {
	$(".pallete").hover(function (e) {
		$(this).parent().nextAll(".color_popup").css("visibility", "");
	}, function (e) {
		e = e || event;
		var goingto = e.relatedTarget || e.toElement;
		if (!goingto || goingto.className != "color_popup") {
			$(this).parent().nextAll(".color_popup").css("visibility", "hidden"); 
		}
	});
	
   $(".color_popup").mouseleave(function(){
       	$(this).css("visibility", "hidden");
   });
   
   $(".color_list").click(function(){
	   defaultColor = $(this).index()+1;
   		modifyMemoColor($(this).parent().parent(), $(this).index()+1);
   		var obj = $(this).parent().parent();
   		obj[0].setAttribute("class", "mamo0"+defaultColor+ " memoLay");
   		$(this).parent().css("visibility", "hidden");
   });
   
    $(".saveBtn").click(function(){
    	  var obj = $(this).parent().next();
    	  modifyMemo(obj[0]);
    });
}

function memoFoldersInfo() {
	selFolderId="";
	selFolderName="";
	$.ajax({
		type : "GET",
		dataType : "json",
		async : false,
		url : "/ezMemo/getMemoFoldersInfo.do",
		success: function(result){
			
			var folderList = result["folders"];
			var html="";
			html += "<option value='0'>전체</option>";
			folderList.forEach(function(list, index){
				var folderName = list.folder_name;
				
				if (folderName.length > 11) {
					folderName = folderName.substr(0, 10);
					folderName += "...";
				}
				html += "<option value='"+list.folder_id+"'>"+ folderName +"</option>"

			});
			$('#memoFolderList option').remove();
			$('#memoFolderList').html(html);
			
			$('select').wrap('<div class="select_wrapper"></div>')
			$('select').parent().prepend('<span>'+ $("select option:selected").text() +'</span>');
			//$('select').parent().children('span').width($('select').width());	
			$('select').css('display', '');		
			$('select').parent().append('<ul class="select_inner"></ul>');
			$('select').children().each(function(){
			  var opttext = $(this).text();
			  var optval = $(this).val();
			  $('select').parent().children('.select_inner').append('<li class="changeFolder" id="' + optval + '">' + opttext + '</li>');
			});
			
			$('select').parent().find('li').on('click', function (){
				var cur = $(this).attr('id');
				$('select').parent().children('span').text($(this).text());
				$('select').children().removeAttr('selected');
				$('select').children('[value="'+cur+'"]').attr('selected','selected');					
			});
			$('select').parent().on('click', function (){
				$(this).find('ul').slideToggle('fast');
			});
		}     			
	});
}

// 메모 없을 때 투명한 메모 생성
function addEmptyMemo(flag) {
	
	if(flag != 'layer') {		// 메모 게시판 게시물 없을 때
		
		var div = document.createElement("div");
		div.setAttribute("class", "memo_add");
		div.style.margin = "10px";
		
		var span = document.createElement("span");
		span.innerHTML = strLangMemo7;
		
		div.appendChild(span);
		
		$("#boardMemoList").parent().prepend(div);
		
		return;
	} else if(flag == 'layer') {
		var div = document.createElement("div");
		div.setAttribute("class", "memo_add");
		div.id = "addFirstMemo";
		var span = document.createElement("span");
		span.innerHTML = strLangMemo7;
		
		div.appendChild(span);
		
		$(".memo_main").prepend(div);
		
		emptyMemoResize();
	}
}