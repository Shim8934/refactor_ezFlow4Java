/**
 * 초기 pointet-event set 메서드
 */
function defaultPointer() {
	$(".noteBlock").css("pointer-events", "none");
	$("#open-memo").css("pointer-events", "auto");
}

/**
 * noteBlock(노트패널), layer-popup(노트판), open-memo(노트 아이콘)의 포인터 set 메서드
 */
function setPanelPointer() {
	$("#open-memo").draggable({
		containment : ".noteBlock",
		stop : function() {

			setGadgetPosition();

			defaultPointer();
		}
	}).on("mouseup", function() {
		$(".noteBlock").css("pointer-events", "none");
		$("#open-memo").css("pointer-events", "auto");
		$("#layer-popup").css("pointer-events", "auto");
	}).on("mousedown", function() {
		$(".noteBlock").css("pointer-events", "auto");
	}).on("click", function(event) {
		event.preventDefault();
		if ("none" == ($("#layer-popup").css("display"))) {
			$("#open-memo").css("display", "none");
			$("#layer-popup").css("display", "");
		} else {
			$("#layer-popup").css("display", "none");
		}
	});

	$('.memo_wrap').on("mouseup", function() {
		$(".noteBlock").css("pointer-events", "none");
		$("#open-memo").css("pointer-events", "auto");
		$("#layer-popup ").css("pointer-events", "auto");
	}).on("mousedown", function() {
		$(".noteBlock").css("pointer-events", "auto");
	}).draggable({

		containment : ".noteBlock",
		stop : function() {
			$(".noteBlock").css("pointer-events", "none");
			$("#open-memo").css("pointer-events", "auto");
			$("#layer-popup ").css("pointer-events", "auto");

			setLayerPosition();
		}
	});
}


/**
 * layer-popup(노트판)의 투명도 조절 메서드
 */
function layerPopupOpacity() {

	var defaultValue = 2;
	$("#layer-popup").css("background-color", "rgba(0,0,0,0.3)");

	$("#slider-range").slider({
		step : 1,
		range : "max",
		min : 1,
		max : 3,
		value : defaultValue,
		slide : function(event, ui) {
			opacityValue = ui.value;

			switch (opacityValue) {
				case 1:
					opacityValue = 0.2;
					break;
				case 2:
					opacityValue = 0.3;
					break;
				case 3:
					opacityValue = 0.4;
					break;
			}
			$("#layer-popup").css("background-color",
			"rgba(0,0,0," + opacityValue + ")");
		}
	});
}


/**
 * 스크롤바 디자인 변경 메서드
 */
function scrollUI(){
	$(".memoListBox").mCustomScrollbar({
		theme : "dark",
	});	
}


/**
 * 메모레이어 닫기 메서드
 */
function layerClose() {
    $(".memoClose").click(function() {
    	$("#layer-popup").css("display", "none")
		$(".select_inner").css("display", "none");
    	
    	if (userGadget == 1) {
    		$("#open-memo").css("display", "");
    	} else {
    		$("#open-memo").css("display", "none");
    	}
    	
    });	
}


/**
 * 메모 정렬(순서 바꾸기) 메서드
 */
function memoSortable() {
	 $(".memo_main").sortable({
		 containment: '.mCSB_container',
		 opacity : 0.5,
		 tolerance: "pointer",
		 scroll : true,
		 change:function(e,ui){
			var h=ui.helper.outerHeight(true);
			var elem=$(".memoListBox .mCustomScrollBox");
			var elemHeight=elem.height();
			var elemWidth = elem.width();
			var moveBy=$(".memoLay").outerHeight(true);
			var moveByX = $(".memoLay").outerWidth(true);
			var mouseCoordsY=e.pageY-elem.offset().top;
			var helper = ui.helper.index();
			var pholder = ui.placeholder.index();
			
			if(mouseCoordsY<h || helper > pholder + parseInt(elemWidth/moveByX)){
				$(".memoListBox").mCustomScrollbar("scrollTo","+="+moveBy);
			}else if(mouseCoordsY>elemHeight-h || helper < pholder - parseInt(elemWidth/moveByX)){
				$(".memoListBox").mCustomScrollbar("scrollTo","-="+moveBy);
			}
	 	 },
		 update : function (event, ui) {
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
       					if(window.frames["main"].frames["right"] != undefined) {			
			               	if(window.frames["main"].frames["right"].folderId != null) {
			               		window.frames["main"].frames["right"].getMemoList();	// 메모 게시판 새로고침
			               	}		           		
		                }
       				}
       			 }
       		 });
       	 }
     }); 	
}


/**
 * 메모 레이어 리사이즈 메서드
 */
function layerPopupResize(){
    $("#layer-popup").resizable({
    	handles : "n, e, s, w, ne, se, sw, nw",
    	containment:".noteBlock",
    	minWidth: 340,
    	minHeight: 380,
    	resize : function() {
    		setMemoListSize();
    		emptyMemoResize();
    	},
    	stop : function () {
    		setLayerArea();
    	}
    });	
}


/**
 * 레이어 창크기, 이전모드 버튼 클릭 메서드
 */
function layerExpand() {
	// 메모 레이어 최대화 시
    $("#fullScreen").click(function() {
    	var layerClass = $("#layer-popup").attr("class");
    	
    	if (layerClass.indexOf("layerControl") != -1) {
    		$("#fullScreen").css("display", "none");
    		$("#controllable").css("display", "");
    		
    		$("#layer-popup").removeClass("layerControl").addClass("layerFullScreen");
    		$("#layer-popup .ui-resizable-handle").css("display", "none");
    		
    		$("#layer-popup").draggable({
    			disabled: true
    		});
    		setMemoLayerMode(1);
    	}
    	setLayerSize();
    	emptyMemoResize();
    });
 	
    // 메모 레이어 이전크기 시
    $("#controllable").click(function() {
    	var layerClass = $("#layer-popup").attr("class");
    	
    	if (layerClass.indexOf("layerFullScreen") != -1) {
    		$("#controllable").css("display", "none");
    		$("#fullScreen").css("display", "");
    		
    		$("#layer-popup").removeClass("layerFullScreen").addClass("layerControl ui-draggable ui-draggable-handle ui-resizable");
    		$("#layer-popup .ui-resizable-handle").css("display", "");
    		
    		$("#layer-popup").draggable({
    			disabled: false
    		});
    		setMemoLayerMode(0);
    	}
    	setLayerSize();
    	emptyMemoResize();
    });	
}


/**
 * 새 메모 추가 메서드
 */
function memoAdd() {
 
    $("#addMemo").click(function() {
    	newMemo();
    });	
}


/**
 * 메모분류함 마우스 포인터 in&out 처리 메서드
 */
function closeSelectInner() {
	var selectInner = document.getElementById("select_inner");	    	
	selectInner.addEventListener('mouseleave', function() {
		selectInner.style.display = "none";
	});
}


/**
 * 메모분류함 클릭시, 분류함 변경 메서드
 */
function changeFolder() {
    $(".changeFolder").click(function(event) {
    	$("select option:selected").val();
    	$("select").val(event.target.id).prop("selected", true);
    	getMemoList();
    	emptyMemoResize();
    });
}


/**
 * 메모 삭제 메서드
 * @param memoId
 */
function modalDelete(memoId) {
	layerflag = $("#layerFlag").val();
	
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
        	
        	var memoLength = $(".memo_main .memoLay").length;
        	if (memoLength == 0) {

        		addEmptyMemo(layerflag);
        	}
        	
        	if(window.frames["main"].frames["right"] != undefined) {			
            	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
            		window.frames["main"].frames["right"].getMemoList();
        	}
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
            if(window.frames["main"].frames["right"] != undefined) {			
               	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
               		window.frames["main"].frames["right"].getMemoList();
            	}
            },
        error : function() {
        }
    }); 
}
	

/**
 * 레이어 사이즈 변경 메서드
 */
function setLayerSize() {
	var layerClass = $("#layer-popup").attr("class");
	var winWidth = window.innerWidth;
	var winHeight = window.innerHeight;
	
	if (layerClass.indexOf("layerFullScreen") != -1) {
		$(".layerFullScreen").css({"width" : winWidth, "height" : winHeight, "top" : 55, "left" : 0});
		$(".memoListBox").css({"width" : winWidth, "height" : winHeight-130});
		$(".memo_main").css({"width" : winWidth, "height" : winHeight-150});
		$("#layer-popup").css({"height" : winHeight-45});
	} else if (layerClass.indexOf("layerControl") != -1) {
		getMemoConfig();
		setMemoListSize();
	}
}


/**
 * 메모 컨피그값 확인, 컨피그값 없으면 insert 메서드
 */
var firstDBLayerSize="yes";
function checkMemoConfig() {
	
    $.ajax({
    	type : "GET",
    	dataType : "JSON",
    	async : false,
    	url : "/ezMemo/getMemoConfig.do",
    	success : function(result) {
    		if (result.memoConfigVO != null) {
    			getMemoConfig();
    			quickMemoDisplay();
    		} else {
    			insertMemoConfig();
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
    	dataType : "JSON",
    	async : false,
    	url : "/ezMemo/getMemoConfig.do",
    	success : function(result) {
    		
    		fontSize = result.memoConfigVO.font_size;
			useDate = result.memoConfigVO.use_date;
			defaultColor = result.memoConfigVO.default_color;
			$("#layer-popup").css({"top": result.memoConfigVO.layer_top, "left": result.memoConfigVO.layer_left, "width": result.memoConfigVO.layer_width, "height": result.memoConfigVO.layer_height});
			
			if(result.memoConfigVO.full_mode == 1) {
				// 처음 사용자 계정을 만들시, 풀 스크린 모드로 출력.  
				if(firstDBLayerSize=="yes") {
					$("#fullScreen").css("display", "none");
					$("#controllable").css("display", "");
					
					$("#layer-popup").removeClass("layerControl").addClass("layerFullScreen");
	        		$(".noteBlock .ui-resizable-handle").css("display", "none");
	        		
	        		$("#layer-popup").draggable({
	        			disabled: true
	        		});
				} else {
					$("#layer-popup").removeClass("layerFullScreen").addClass("layerControl ui-draggable ui-draggable-handle ui-resizable");
	        		$("#layer-popup .ui-resizable-handle").css("display", "");
	        		$("#layer-popup").draggable({
	        			disabled: false
	        		});
					return;
				}
        		firstDBLayerSize="no";
        		setLayerSize();
			}
			emptyMemoResize();
        	layerResize();
    	}
	});
}


/**
 * 초기 config값 insert 메서드
 */
function insertMemoConfig() {	
	$.ajax({
		type : "POST",
		dataType : "JSON",
		url : "/ezMemo/insertMemoConfig.do",
		success : function(result) {
			checkMemoConfig();
		}
	});
}


/**
 * 레이어 위치값 변경 메서드
 */
function setLayerPosition() {
	
	var layerClass = $("#layer-popup").attr("class");
	
	if (layerClass.indexOf("layerControl") != -1) {

    	var topString = $("#layer-popup").css("top");
		var leftString = $("#layer-popup").css("left");
		
		var topPIndex = topString.indexOf("p");
		var leftPIndex = leftString.indexOf("p");
		
		var layerTop = parseInt(topString.substr(0, topPIndex));
		var layerLeft = parseInt(leftString.substr(0, leftPIndex));
		
    	$.ajax({
    		type : "POST",
    		data : {
    			layerTop : layerTop,
    			layerLeft : layerLeft
    		},
    		dataType : "JSON",
    		url : "/ezMemo/setLayerPosition.do",
    		success : function(result) {
    			
    		}
    	});
	}
}


/**
 * 레이어 넓이값 변경 메서드
 */
function setLayerArea() {
	
	var layerClass = $("#layer-popup").attr("class");
		
		if (layerClass.indexOf("layerControl") != -1) {

			var layerWidth = parseInt($(".layerControl").width());
		var layerHeight = parseInt($(".layerControl").height());
		
		$.ajax({
			type:"POST",
			async:false,
			data : {
				"layerWidth" : layerWidth,
				"layerHeight" : layerHeight
			},
			dataType: "JSON",
			url :  "/ezMemo/setLayerArea.do", 
			success : function (result) {
			},
			error : function() {
			}
		});
	}
}

 /**
  * 윈도우 리사이즈 시, 레이어 위치 및 사이즈 조절
  */
function layerResize() {
	
	var stringTop = $("#layer-popup").css("top");
	var stringLeft = $("#layer-popup").css("left");
	
	var windowHeight = parseInt(window.innerHeight);
	var windowWidth = parseInt(window.innerWidth);
	
	var pIndex = stringTop.indexOf("p");
	var pIndex = stringLeft.indexOf("p");
	
	var width = parseInt($("#layer-popup").width());
	var height = parseInt($("#layer-popup").height());
	
	var left = parseInt(stringLeft.substr(0, pIndex));
	var top = parseInt(stringTop.substr(0, pIndex));
	
	var layerClass = $("#layer-popup").attr("class");
	
	if (layerClass.indexOf("layerControl") != -1) {
    	
    	if (height > windowHeight) {
    		if (height > 380) {
    			
        		height = windowHeight - 30;
        		$("#layer-popup").css("height", height);
        		$(".memoListBox").css("height", height - 90);
        		$(".memo_main").css("height", height - 90);
    		}
    	}
    	
    	if (width > windowWidth) {
    		if (width > 340) {
    			
        		width = windowWidth - 30;
        		$("#layer-popup").css("width", width);
        		$(".memoListBox").css("width", width);
        		$(".memo_main").css("width", width);
    		}
    	}
    	
		var leftPosition;
		
    	if (windowWidth > width) {
    		leftPosition = windowWidth - width - 10;
    	}
    	
    	var bottomPosition;
    	
    	if (windowHeight > height) {
    		bottomPosition = windowHeight - height - 10;
    	}
    	
		if (top > windowHeight) {
			$("#layer-popup").css("top", bottomPosition);
			
		} else if (top < windowHeight) {
			if (top + height > windowHeight) {
				$("#layer-popup").css("top", bottomPosition);
			}
		}
		
    	if (left > windowWidth) {
    		$("#layer-popup").css("left", leftPosition);
    		
    	} else if (left < windowWidth) {
    		if (left + width > windowWidth) {
        		$("#layer-popup").css("left", leftPosition);
        		
    		 }
    	}
    	
    	setLayerPosition();
		setLayerArea();
	
	} else if (layerClass.indexOf("layerFullScreen") != -1) {
		
		$("#layer-popup").css("width", windowWidth);
    	$("#layer-popup").css("height", windowHeight-56);
    	
    	$(".memoListBox").css({"height" : windowHeight-56-54-26, "width" : windowWidth})
		$(".memo_main").css({"height" : windowHeight-56-54-26, "width" : windowWidth})
		}
}
 
/**
 * 퀵메모 위치값 저장 메서드
 * (display !== 'none')일때만
 */
function setGadgetPosition() {
	var gadgetStatus = $("#open-memo").css("display");
	
	if (gadgetStatus != "none") {
    	var topString = $("#open-memo").css("top");
    	var leftString = $("#open-memo").css("left");
		
    	var topPIndex = topString.indexOf("p");
		var leftPIndex = leftString.indexOf("p");
		
		var windowHeight = parseInt(window.innerHeight);
    	var windowWidth = parseInt(window.innerWidth);
		
    	var outHeight = parseInt($("#open-memo").height());
    	var outWidth = parseInt($("#open-memo").width());
		
		var gadgetBottom = windowHeight - outHeight - parseInt(topString.substr(0, topPIndex));
		var gadgetRight = windowWidth - outWidth - parseInt(leftString.substr(0, leftPIndex));
    	
		$.ajax({
			type : "POST",
			data : {
				gadgetBottom: gadgetBottom,
				gadgetRight : gadgetRight
			}, 
			dataType: "JSON",
			url : "/ezMemo/setGadgetPosition.do",
			success : function(result) {
				
			}
			
		});
	}
	
}


/**
 * 퀵메모 위치값 get 메서드
 * @param memoConfigVO
 */
function getGadgetPosition(memoConfigVO) {
	
	var gadgetBottom = memoConfigVO.gadget_bottom;
	var gadgetRight = memoConfigVO.gadget_right;

	$("#open-memo").css({"bottom" : gadgetBottom, "right" : gadgetRight})
}


/**
 * 윈도우 리사이즈 시, 퀵메모 위치 변경 메서드
 */
function setGadgetPositionResize() {
	
	var stringBottom = $("#open-memo").css("bottom");
	var stringRight = $("#open-memo").css("right");
	
	var windowHeight = parseInt(window.innerHeight);
	var windowWidth = parseInt(window.innerWidth);
	
	var bottomPIndex = stringBottom.indexOf("p");
	var rightPIndex = stringRight.indexOf("p");
	
	var width = parseInt($("#open-memo").width());
	var height = parseInt($("#open-memo").height());
	
	var bottom = parseInt(stringBottom.substr(0, bottomPIndex));
	var right = parseInt(stringRight.substr(0, rightPIndex));
	
	if (bottom < 0) {
		$("#open-memo").css({"top" : "auto", "bottom" : 15 });
	} 

	if (right < 0) {
		$("#open-memo").css({"left" : "auto", "right" : 15 });
	}
	
	setGadgetPosition();
}


/**
 * 기본분류함 체크 메서드
 */
function checkDefaultFolder() {
	$.ajax({
		type : "GET",
		dataType : "json",
		async : false,
		url : "/ezMemo/hasMemoFolder.do"
	});
}


/**
 * 메모 추가 메서드
 */
function newMemo() {
	
	var folderId = $("select option:selected").val();
	layerFlag = $("#layerFlag").val();
	
	$.ajax ({
		   	url : '/ezMemo/memoWrite.do',
		   	type : 'POST',
        dataType : 'json',
        data : { 
        	folderId : folderId,
        	layerFlag : layerFlag
        },  
        cache: false,
        success: function(result) {
        	var memo = result["memo"];
        	
        	$("#addFirstMemo").remove();
        	insertMemo(memo, layerFlag);
        
        	if(window.frames["main"].frames["right"] != undefined) {			
            	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
            		window.frames["main"].frames["right"].getMemoList("new");
        	}
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
        	if(window.frames["main"].frames["right"] != undefined) {			
            	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
            		window.frames["main"].frames["right"].getMemoList();
        	}
        },
        error : function() {
        	
        }
	}); 
}
	
/**
 * 메모 리스트 출력 메서드
 * @param type
 */
function getMemoList(type) {
	
	var folderId = $("select option:selected").val();
	layerFlag = $("#layerFlag").val();
	
	$.ajax ({
		   	url : '/ezMemo/getMemoList.do',
		   	type : 'POST',
        dataType : 'json',
        data : { 
        	folderId : folderId,
        	layerFlag : layerFlag
        },
        cache: false,
        async: false,
        success: function(result) {
        	
        	//memoColor = result["colorList"].split(";");
        	memoList = result["memoList"];
        	layerFlag = result["layerFlag"];
        	
	    	setMemoListSize();

	    	loadMemoList(layerFlag);
		    
			var memoLength = $(".memo_main .memoLay").length;
        	if (memoLength == 0) {

        		addEmptyMemo(layerFlag);
        	}
	     }
	});
}


/**
 * 메모 리스트 사이즈 변경 메서드
 */
function setMemoListSize() {
	
    var layerHeight = $("#layer-popup").height();
    var layerWidth = $("#layer-popup").width();
    var memoListHeight = layerHeight - 56;

    $(".memoListBox").css({"height" : memoListHeight-25, "width" : layerWidth});
    $(".memo_main").css({"width" : layerWidth, "height" : memoListHeight-20});
    
    var layerClass = $("#layer-popup").attr("class");
	
	if (layerClass.indexOf("layerFullScreen") != -1) {
		$(".memoListBox").css({"height" : memoListHeight-27, "width" : layerWidth});	        		
	} else {
		$(".memoListBox").css({"height" : memoListHeight-20, "width" : layerWidth});
	}
//	emptyMemoResize();
}

/**
 * 메모함 리스트 출력 메서드
 * @param type
 */
function memoFoldersInfo(type) {
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
			
			$(".select_inner").remove();
			$(".select_tag").remove();
			if((type !== "delete") && (type !== "put") && (type !== "post")){
				$('select').wrap('<div class="select_wrapper"></div>');
			}
			$('select').parent().prepend('<span class="select_tag">'+ $("select option:selected").text() +'</span>');
			$('select').css('display', '');		
			$('select').parent().append('<ul class="select_inner" id="select_inner"></ul>');
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
			if((type !== "delete") && (type !== "put") && (type !== "post")){
				$('select').parent().on('click', function (){
					$(this).find('ul').slideToggle('fast');
				});
			}
			getMemoList();
			closeSelectInner();
			changeFolder();
		}     			
	});
}


/**
 * 퀵메모 디스플레이 메서드
 */
function quickMemoDisplay() {
	var openMemo = document.getElementById("open-memo");
	$.ajax({
		type : "GET",
    	dataType : "JSON",
    	async : false,
    	url : "/ezMemo/getMemoConfig.do",
    	success : function(result) {
    		userGadget = result.memoConfigVO.use_gadget;
    		var memoConfig = result.memoConfigVO;
    		if (userGadget == 1) {
    			var layerStatus = $("#layer-popup").css("display");

    			if (layerStatus.indexOf("none") != -1) {
        			getGadgetPosition(memoConfig);
        			openMemo.style.display = "block";
    			}
    			
    		} else {
    			openMemo.style.display = "none";
    			document.getElementById("layer-popup").style.display = "none";
    		}
    	}
	});
}
	

/**
 * 투명한 메모 위치 세팅 메서드
 */
function emptyMemoResize() {
	
	var mainHeight = $(".memo_main").height();
	var mainWidth = $(".memo_main").width();
	
	var firstHeight = $("#addFirstMemo").height();
	var firstWidth = $("#addFirstMemo").width();
	
	var top = mainHeight/2 - firstHeight/2;
	var left = mainWidth/2 - firstWidth/2;

	$("#addFirstMemo").css({"position" : "absolute", "top" : top, "left" : left})
	
}
	

/**
 * 레이어 창모드, 이전모드 저장 메서드
 */
function setMemoLayerMode(mode) {
	$.ajax({	
 		type : "POST",
    	dataType : "text",
    	async : false,
    	url : "/ezMemo/setMemoLayerMode.do",
    	data: {
    		"full_mode" : mode
    	},
    	success : function(result) {
    		
    	}
	});
}


/**
 * noteBlock 내 더블클릭시, 음영 삭제 메서드
 */
function noteClearSelection() {
	var noteBlock = document.getElementsByClassName('noteBlock');
	noteBlock[0].addEventListener("dblclick", clearSelection, false);
}


/**
 * 브라우저 resize시, layer-popup 위치 조절 메서드
 */
function browserResize() {
	if(memoFlag === "YES") {	
		
		// dom
		var doc = window.document;
		// 브라우저 넓이
		var w = window.innerWidth;
		// 브라우저 높이
		var h = window.innerHeight;
		// memoListBox element
		var mLBOX = doc.getElementById("mLBox");
		// layer-popup element
		var popup = doc.getElementById("layer-popup");
		// memo-main element
		var memoMain = doc.getElementById("memoMain");
		
		// 팝업  창모드, 전체모드 class 
		var popupClass = "";
		if(popup.classList.contains("layerControl")) {
			popupClass = "layerControl";
		} else {
			popupClass = "layerFullScreen";
		}
		
		// 팝업 left
		var popupLeft = popup.style.left;
		// 팝업 top
		var popupTop = popup.style.top;
		// 팝업 넓이
		var popupWidth = popup.style.width;
		// 팝업 높이
		var popupHeight = popup.style.height;
		
		/** index로 px 제거 */
		var topPIndex = popupTop.indexOf("p");
		var leftPIndex = popupLeft.indexOf("p");
		
		var popupTop = parseInt(popupTop.substr(0, topPIndex));
		var popupLeft = parseInt(popupLeft.substr(0, leftPIndex));
		
		var widthPIndex = popupWidth.indexOf("p");
		var heightPIndex = popupHeight.indexOf("p");
		
		var popupWidth = parseInt(popupWidth.substr(0, widthPIndex));
		var popupHeight = parseInt(popupHeight.substr(0, heightPIndex));
		
		// 전체모드 일 경우
		if(popupClass === "layerFullScreen") {
			mLBox.style.width = w + "px";
			mLBox.style.height = (h - 130) + "px";
			memoMain.style.width = w + "px";
			memoMain.style.height = (h - 150) + "px";
			popup.style.width = w + "px";
			popup.style.height = (h - 45) + "px";
			
		} else {
			/*
			 *  창모드일 경우
			 *  브라우저의 크기를 layer-popup이 벗어날 경우
			 */
			if(((w>popupLeft) && (w < popupLeft + popupWidth)) || ((h>popupTop) && (h < popupTop + popupHeight))){
				mLBox.style.width = w + "px";
				mLBox.style.height = (h - 130) + "px";
				memoMain.style.width = w + "px";
				memoMain.style.height = (h - 150) + "px";
				popup.style.width = w + "px";
				popup.style.height = (h - 45) + "px";
				popup.style.left = "0px";
				popup.style.top = "55px";
			}
		}
	}
}