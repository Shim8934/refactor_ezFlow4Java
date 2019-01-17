/**
 * 메모 정렬(순서 바꾸기) 메서드
 */
function getMemoSortable() {
	$("#boardMemoList").sortable({
    	 containment: '#bodyFrame',
	 	 opacity : 0.5,
	 	 tolerance: "pointer",
	 	 cursor: "move",
    	 update : function (event, ui) {
    		 if($("#orderOption").val() == 1) {
    			 var compareElId; 
        		 var clickedItem = ui.item;
        		 var clickedItemId = clickedItem.attr("id");
        		 var draggedElId = clickedItemId.replace("memo", "");
        		 
        		 if (clickedItem.prev().attr("id") != undefined) {
        			 if (clickedItem.next().attr("orders") == undefined || parseInt(clickedItem.attr("orders")) > parseInt(clickedItem.prev().attr("orders")) && parseInt(clickedItem.attr("orders")) > parseInt(clickedItem.next().attr("orders"))) {
        				compareElId = clickedItem.prev().attr("id").replace("memo", "");
        			 } else {
        				compareElId = clickedItem.next().attr("id").replace("memo", "");
        			 }
        		 } else if (clickedItem.next().attr("id") != undefined) {
        			 if (clickedItem.prev().attr("orders") == undefined || parseInt(clickedItem.attr("orders")) < parseInt(clickedItem.prev().attr("orders")) && parseInt(clickedItem.attr("orders")) < parseInt(clickedItem.next().attr("orders"))) {
        				 compareElId = clickedItem.next().attr("id").replace("memo", "");
	        		} else {
						 compareElId = clickedItem.prev().attr("id").replace("memo", "");
	        		}
        		 }
        		 $.ajax({
        			type : "POST",
        			data : {
        				draggedElId : draggedElId,
        				compareElId : compareElId
        			},
        			dataType : "JSON",
        			url : "/ezMemo/reOrder.do",
        			success : function(result) {
        				if (result.status == 1) {
	        				parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
        				}
        			}
        		 });
        	 }
    	 }
    });
}

/**
 * config값 가져오는 메서드
 */
function getMemoConfig() {
	$.ajax({
		type : "GET",
		dataType : "json",
		async : false,
			url : '/ezMemo/getMemoConfig.do',
			success : function(result){
				fontSize = result.memoConfigVO.font_size;
				useDate = result.memoConfigVO.use_date;
				defaultColor = result.memoConfigVO.default_color;
			}
		});
}

/**
 * 메모함 리스트 출력 메서드
 */
function getFolderList() {
	$.ajax({
		type : "GET",
		dataType : "json",
		async : false,
			url : '/ezMemo/getMemoFoldersInfo.do',
			success : function(result){
				var opts = "<option value='0'>"+ strLangMemo9 +"</option>";;
				$(result.folders).each(function() {
					var folderName = this.folder_name;
					if (folderName.length > 11) {
						folderName = folderName.substr(0, 10);
						folderName += "...";
					}
					opts += "<option value=" + this.folder_id + ">" + folderName + "</option>";
				})
				$("#memoType").html(opts);
			}
	  });
}

/**
 * 메모 체크박스 상태 변경
 */
function allClick() {
	if(checkOpt == "off") {
		$("input[name=memo]:checkbox").each(function() {
			$(this).prop("checked", true);
		});
		checkOpt = "true";
	} else {
		$("input[name=memo]:checkbox").each(function() {
			$(this).prop("checked", false);
		});
		checkOpt = "off";
	}
}

/**
 * 메모 추가 메서드
 */
function newMemo() {
	$.ajax ({
		   	url : '/ezMemo/memoWrite.do',
		   	type : 'POST',
        dataType : 'json',
        data : { 
        	folderId : folderId
        },  
        cache: false,
        success: function(result) {
        	var memo = result["memo"];
        	insertMemo(memo);
        	setMemoCount($(".memoLay").length);
        	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
        },
        error : function() {
        	
        }
	});
}

/**
 * 메모지 색상 변경 메서드
 * @param obj
 * @param idx
 */
function modifyMemoColor(obj, idx) {
	var memoId = obj.attr("id").replace("memo", "");
	
	$.ajax ({
		   	url : '/ezMemo/memoColorModify.do',
		   	type : 'POST',
	        dataType : 'json',
	        data : { 
	        	memoId : memoId,
	        	colorId : idx
	        },  
	        cache: false,
	        success: function(result) {
	        	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
	        },
	        error : function() {
	        	
	        }
	}); 
}

/**
 * 메모 수정 후 저장하는 메서드
 * @param obj
 */
function modifyMemo(obj) {
	var memoId = obj.getAttribute("memoid");
	var afterContents = $(".memoText[memoid=" + memoId + "]").val();

    	$.ajax ({
    		url : '/ezMemo/memoModify.do',
    		type : 'POST',
            dataType : 'json',
            data : { 
            	memoId : memoId,
            	contents : afterContents
            },  
            cache: false,
            success: function(result) {
            	saveMemoToast(memoId);
            	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
            },
            error : function() {
            	
            }
		}); 
}

/**
 * 메모 삭제 메서드
 * @param memoId
 */
function modalDelete(memoId) {
	$.ajax ({  	
        	url : '/ezMemo/memoDelete.do',
 			type : 'POST',
            dataType : 'json',
            data : { 
               	memo_ids : memoId
            },  
            async:false,
            cache: false,
            success: function(result) {
            	$("#memo"+memoId).remove();
            	var memoLength = $("#boardMemoList .memoLay").length;
            	if (memoLength == 0) {
            		addEmptyMemo();
            	}
            	setMemoCount(memoLength);
            	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
            },
            error : function() {
                	
            }
	});
}

//상세검색 레이어팝업
function doLayerPopup() {
	btn_PostDate_Clear();
	$("#searchTitle").val('');
	
	$("<div id='blockLeft' class='blockLeft' style='position:fixed; width:100%;height:100%; overflow:hidden;' onclick='parent.frames[\"right\"].BoardSearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);
	parent.frames["left"].document.body.style.overflow = "hidden";
	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	$("#srarchpopup").css("left", popupX);
	$("#srarchpopup").modal();
}

//레이어 팝업 생성된 상태에서 뒤로가기 이벤트 처리
function Window_onunload() {
	if (parent.frames["left"]) {
		if (parent.frames["left"].document.getElementById("blockLeft")) {
			$(parent.frames["left"].document.body).css("overflow", "");
	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
		}
	}
}

/**
 * 메모 리스트 출력 메서드
 * @param type
 */
function getMemoList(type) {
	var orderOption = $("#orderOption").val();
	folderId = $("#memoType").val();
	
	if(type=="search") {
		searchInput = $("#searchTitle").val();
		startDate = $("#Sdatepicker").val();
		endDate = $("#Edatepicker").val();

		if(searchInput == "" && startDate == "" && endDate == "") {
			 alert(strLangMemo10);
             return;
		}
		if(startDate != "" && endDate == "") {
			alert(strLangMemo11);	
            return;
		}
		if(startDate == "" && endDate != "") {
			alert(strLangMemo12);	
            return;
		}
		if(startDate > endDate) {
			alert(strLangMemo13);
            return;
		}
		
		if (searchInput.indexOf("%") != -1) {
            alert("'%'" + strLangMemo14);
            return;
        }
		
		BoardSearchOptionHidden();
	}
	else if(type=="folder") {
		checkOpt="off";
		searchInput = "";
		startDate = "";
		endDate = "";
	}
	
	$.ajax ({
		   	url : '/ezMemo/getMemoList.do',
		   	type : 'POST',
        dataType : 'json',
        data : { 
        	searchInput : searchInput,
        	startDate : startDate,
        	endDate : endDate,
        	folderId : folderId,
        	orderOption : orderOption
        },
        cache: false,
        success: function(result) {
        	memoList = result["memoList"];
        	
			loadMemoList();
			setMemoCount(memoList.length);
	     },
         error : function() {
            	
         }
	});
}

/**
 * 메모 게시판 헤더 출력
 * @param memoCount
 */
function setMemoCount(memoCount) {
	var str = "&nbsp;&nbsp;<span style='color:#017BEC;'>" + memoCount + "</span>";
	$("#mailBoxInfo").html(str);
}

/**
 * 메모 리스트 선택해서 삭제
 */
function DeleteItem_onclick() {
	var memo_ids = [];
	
	$(":checkbox[name=memo]:checked").each(function(){
		memo_ids.push($(this).val());
	});
	
	if (memo_ids.length == 0) {
    	alert(strLangMemo17);
        return;
    }
	
	if(confirm(strLangMemo18)) {
    	$.ajax ({
			url : '/ezMemo/memoDelete.do',
			type : 'POST',
            dataType : 'json',
            data : { 
            	memo_ids : memo_ids.join()
            },  
            cache: false,
            success: function(result) {
            	$(":checkbox[name=memo]:checked").each(function(){
            		$("#memo"+$(this).val()).remove();
    			});
    			var memoLength = $("#boardMemoList .memoLay").length;
            	if (memoLength == 0) {
            		addEmptyMemo();
            	}
            	setMemoCount(memoLength);
            	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
            },
            error : function() {
            	
            }
		});
	}
}

/**
 * 메모 리스트 숨김 처리
 */
function memoDisplayChange() {	
	var memo_ids = [];
	var checkList = [];
	
	$(":checkbox[name=memo]:checked").each(function(){
		checkList.push($(this).val());
		if($(this).attr("display") == 0){
			memo_ids.push($(this).val());
			$(this).attr("display", "1");
			$(this).parent().parent().attr("style", "opacity : 0.5");
		} 
	});
	
	if (checkList.length == 0) {
    	alert(strLangMemo17);
        return;
    }
	
	if(memo_ids.length != 0) {
    	$.ajax ({
 			  url : '/ezMemo/memo-display.do',
 			  type : 'POST',
              dataType : 'json',
              data : { 
                memo_ids : memo_ids.join(),
                display : 1
              },  
              cache: false,
              success: function(result) {
                parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
              },
              error : function() {
            	  
              }
		}); 
	}
	
	checkOpt = "true";
    allClick();
}

/**
 * 메모 리스트 나타내기 처리
 */
function memoDisplayChange2() {		
	var memo_ids = [];
	var checkList = [];
	
	$(":checkbox[name=memo]:checked").each(function(){
		checkList.push($(this).val());
		if($(this).attr("display") == 1){
			memo_ids.push($(this).val());
			$(this).attr("display", "0");
			$(this).parent().parent().attr("style", "");
		} 
	});
	
	if (checkList.length == 0) {
    	alert(strLangMemo17);
        return;
    }
	
	if(memo_ids.length != 0) {
    	$.ajax ({
 			  url : '/ezMemo/memo-display.do',
 			  type : 'POST',
              dataType : 'json',
              data : { 
                memo_ids : memo_ids.join(),
                display : 0
              },  
              cache: false,
              success: function(result) {
                parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
              },
              error : function() {
                	
              }
		}); 
	}
	
	checkOpt = "true";
    allClick();
}

/**
 * 메모 리스트 이동 처리
 */
function memoMove() {
	var memo_ids = [];
	
	$(":checkbox[name=memo]:checked").each(function(){
		memo_ids.push($(this).val());
	});
	
	if (memo_ids.length == 0) {
    	alert(strLangMemo17);
        return;
    }
	
	var target = document.getElementById("memoType");
	
	inputNameDlg_cross_dialogArguments[0] = memo_ids.join();
    inputNameDlg_cross_dialogArguments[1] = target.options[target.selectedIndex].text;
	
	var OpenWin = window.open("/ezMemo/memoFolderManage.do", "", GetOpenWindowfeature(500, 500));
    try { OpenWin.focus(); } catch (e) { }
}