function createMemo(memo, flag) {
	
	var div = document.createElement("div");
	div.setAttribute("class", "memo0"+ memo.color_id +" memoLay");
	div.id  = "memo" + memo.memo_id;
	div.setAttribute("orders", memo.orders)
	if(memo.display_flag == 1) {
		div.style.opacity = 0.5;
	}
	
	var dl = document.createElement("dl");
	dl.setAttribute("class", "memoTit");
	dl.setAttribute("style", "cursor:move");
	
	if (flag != 'layer') {
		
		var label = document.createElement("label");
		label.setAttribute("for", memo.memo_id);
		label.style.width = "175px";
		label.style.height = "36px";
		//label.style.position = "absolute";
		label.style.left = "0px";
		
        var inputDiv = document.createElement("div");
        inputDiv.className = "custom_checkbox";
        inputDiv.style.float = "left";
        inputDiv.style.margin = "10px 5px 0 0";
        
		var input = document.createElement("input");
		input.setAttribute("id", memo.memo_id);
		input.setAttribute("name", "memo");
		input.setAttribute("class", "kangnam");
		input.setAttribute("type", "checkbox");
		input.setAttribute("style", "cursor:pointer");
		input.setAttribute("value", memo.memo_id);
		input.setAttribute("display", memo.display_flag);
		
		dl.appendChild(label);
		inputDiv.appendChild(input);
		dl.appendChild(inputDiv);
		
	} 
	
	var dt = document.createElement("dt");
	dt.setAttribute("class", "mtitText");
	
	var dd2 = document.createElement("dd");
	dd2.setAttribute("class", "memoIcon garbage");
	dd2.setAttribute("onclick", "addRemoveButton("+memo.memo_id+")");
	
	var dd3 = document.createElement("dd");
	dd3.setAttribute("class", "memoIcon pallete");
	dd3.setAttribute("memoid", memo.memo_id);
	
	var dd = document.createElement("dd");
	dd.setAttribute("class", "memoIcon hidden");
	dd.setAttribute("memoId", memo.memo_id);
	
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
	$(".emptyDiv").remove();
	
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
	$(".emptyDiv").remove();
	$(".memo_main").html('');
	
		if(memoList.length == 0) {
			addEmptyMemo(flag);
		}
		
		for(var i=0; i<memoList.length; i++) {
			if ('layer' != flag) {
				var div = createMemo(memoList[i]);
				$("#boardMemoList").prepend(div);
			} else {
				if (memoList[i].display_flag != 1) {
					var div = createMemo(memoList[i], flag);
					$(".memo_main").prepend(div);
				}
			}
			if(useDate == 1) {
				addDateInfo(memoList[i].write_date.substring(0,10));
			}
		}
}

function addDateInfo(date, detail) {
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
    	if (detail) {
    		$('#dMTime').html(month+"."+date+" ("+dayArray[day]+")");
    	} else {
    		$(".mtitText:first").html(month+"."+date+" ("+dayArray[day]+")");	
    	}

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
	popHeader.innerHTML = "<span>"+memoMessages.strLangMemo4+"</span>";
	
	var popContainer = document.createElement('div');
	popContainer.setAttribute("class", "popContainer");
	
	var txtDialog = document.createElement('div');
	txtDialog.setAttribute("class", "txtDialog");
	
	var footBtn = document.createElement('p');
	footBtn.setAttribute("class", "footBtn");
	//footBtn.innerHTML = "<div class='modRm-wrap'><span class='modRm' id='modRm" +memoId +"' onclick='modalDelete("+ memoId +")'>"+memoMessages.strLangMemo5+"</span></div><div class='close-wrap'><span class='close' id='close" +memoId +"' onclick=$('#modal"+memoId+"').remove()>"+memoMessages.strLangMemo6+"</span></div>";
	
	var div = document.createElement("div");
	div.setAttribute("class", "modRm-wrap");
	
	var span = document.createElement("span");
	span.setAttribute("class", "modRm");
	span.setAttribute("id", "modRm"+memoId);
	span.setAttribute("onclick", "modalDelete("+memoId+")");
	span.innerHTML = memoMessages.strLangMemo5;

	var div2 = document.createElement("div");
	div2.setAttribute("class", "close-wrap");

	var span2 = document.createElement("span");
	span2.setAttribute("class", "close");
	span2.setAttribute("id", "close"+memoId);
	span2.setAttribute("onclick", "$('#modal"+memoId+"').remove()");
	span2.innerHTML = memoMessages.strLangMemo6;
	
	div.appendChild(span);
	div2.appendChild(span2);
	footBtn.appendChild(div);
	footBtn.appendChild(div2);
	txtDialog.appendChild(footBtn);
	popContainer.appendChild(txtDialog);
	popHeader.appendChild(popContainer);
	alertPopup.appendChild(popHeader);
	modal.appendChild(alertPopup)
		
	$("#memo" + memoId).prepend(modal);
	
	$("#modRm" + memoId).attr("tabindex", -1).on("focus", function() {
		
		var agent = navigator.userAgent.toLowerCase();
		
		if (agent.indexOf("chrome") != -1) {
			$(this).css("outline", "none");
			
		}
	}).on("keyup", function(event) {
		
		if (event.keyCode == 13) {
			modalDelete(memoId);
		}
		
	}).focus();
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
	$(window.parent.frames["left"].document.getElementsByClassName("node_selected")).click();
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
/*
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
			html += "<option value='0'>"+ memoMessages.strLangMemo9 +"</option>";
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
}*/

// 메모 없을 때 투명한 메모 생성
function addEmptyMemo(flag) {
	
	if(flag != 'layer') {		// 메모 게시판 게시물 없을 때
		var div = document.createElement("div");
		div.setAttribute("class", "emptyDiv");
		div.innerHTML = "<dl class='nodata_sIcon'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd>" + memoMessages.strLangMemo7 + "</dd></dl>";		
		
		$("#boardMemoList").parent().prepend(div);
		
		return;
	} else if(flag == 'layer') {
		
		$("#addFirstMemo").remove();
		
		var div = document.createElement("div");
		div.setAttribute("class", "memo_add");
		div.id = "addFirstMemo";
		var span = document.createElement("span");
		span.innerHTML = memoMessages.strLangMemo7;
		
		div.appendChild(span);
		
		$(".memo_main").prepend(div);
		
		emptyMemoResize();
	}
}

/**
 * toast 팝업 출력 메서드
 * @param memoId
 */
/* 더 이상 사용하지 않기로 하여 주석처러 함
function saveMemoToast(memoId) {
	var doc = window.document;
	var alertMessage = strLangMemo8;
	var toastArea = doc.createElement("div");
		
	toastArea.innerHTML = alertMessage;
	toastArea.setAttribute("class", "toastArea");
	toastArea.style.top = "134px";
	toastArea.style.left = "85px";
	toastArea.style.display = "block";
	toastArea.id = "tos"+memoId;
	$("#memo" + memoId).prepend(toastArea);
	
	// 1sec show, 1sec fadeOut, element delete
	setTimeout(function(){
		$("#tos"+memoId).fadeOut(1000, function(){
			var parent = doc.getElementById('memo' + memoId);
			parent.removeChild(toastArea);		
		});
	}, 1000);	
}
*/

/**
 * 음영 삭제 메서드
 */
function clearSelection() {
	var sel = window.getSelection ? window.getSelection() : document.selection;
	if (sel) {
	    if (sel.removeAllRanges) {
	        sel.removeAllRanges();
	    } else if (sel.empty) {
	        sel.empty();
	    }
	}
}

/**
 * mainBody 내 더블클릭시, 음영 삭제 메서드
 */
function bodyClearSelection() {
	var doc = window.document;
	var mainbody = doc.getElementsByClassName('mainbody');
	var mainmenu = doc.getElementById('mainmenu');
	
	mainbody[0].addEventListener("dblclick", clearSelection, false);
	//$(".mainbody").on("selectstart", function(event){return false;});
	mainmenu.addEventListener("click", clearSelection, false);
	mainmenu.addEventListener("drag", clearSelection, false);
}

// 저장 이전 내용과 이후 내용 비교
function compareContents(param) {
	// if문으로 값 비교후 반환할 객체
	var resultObj = {};
	// 포커스 들어간 메모가 작은 메모인가 큰 메모인가 확인 후 메모 id 획득
	var thisMemoId = param.getAttribute('memoid') ? param.getAttribute('memoid') : param.getAttribute('bigmemoid');
	//console.log('비교할 id', beforeMemoId, ', ', thisMemoId);
	//console.log('비교할 내용', beforeMemo, ', ', param.value);
	// 메모의 id는 같고 내용이 다를 때 내용 수정 허용
	if (beforeMemoId === thisMemoId && beforeMemo != param.value) {
		resultObj.result = 'ok';
		resultObj.afterVal = param.value;
		
	} else {
		resultObj.result = 'fail';
	}
	return resultObj;
}