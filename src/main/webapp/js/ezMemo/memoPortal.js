/**
 * 초기 pointet-event set 메서드
 */
function defaultPointer() {
	$(".noteBlock").css("visibility", "hidden");
	//$("#open-memo").css("visibility", "visible");
}

/**
 * noteBlock(노트패널), layer-popup(노트판), open-memo(노트 아이콘)의 포인터 set 메서드
 */
function setPanelPointer() {
/*	$("#open-memo").draggable({
		containment : ".noteBlock",
		stop : function() {

			setGadgetPosition();

			defaultPointer();
		},
		scroll: false 
	}).on("mouseup", function() {
		$(".noteBlock").css("visibility", "hidden");
		$("#open-memo").css("visibility", "visible");
		$("#layer-popup").css("visibility", "visible");
	}).on("mousedown", function() {
		$(".noteBlock").css("visibility", "visible");
	}).on("click", function(event) {
		event.preventDefault();
		if ("none" == ($("#layer-popup").css("display"))) {
			$("#open-memo").css("display", "none");
			$("#layer-popup").css("display", "");
		} else {
			$("#layer-popup").css("display", "none");
		}
	});*/
	$("#open-memo").on("click", function(event) {
		event.preventDefault();
		if ("hidden" == ($("#layer-popup").css("visibility"))) {
			//$("#open-memo").css("display", "none");
			$(".noteBlock").css("visibility", "visible");
			$("#layer-popup").css("visibility", "visible");
			$("#contextMenuBlock").css("display", "none");
		} else {
			$("#layer-popup").css("visibility", "hidden");
			$("#contextMenuBlock").css("display", "");
		}
	});	

	$('.memo_wrap').on("mouseup", function() {
		$(".noteBlock").css("visibility", "hidden");
		$("#open-memo").css("visibility", "visible");
		$("#layer-popup ").css("visibility", "visible");
	}).on("mousedown", function() {
		$(".noteBlock").css("visibility", "visible");
	}).draggable({

		containment : ".noteBlock",
		stop : function() {
			$(".noteBlock").css("visibility", "hidden");
			$("#open-memo").css("visibility", "visible");
			$("#layer-popup ").css("visibility", "visible");

			setLayerPosition();
		}
	});
}


/**
 * layer-popup(노트판)의 투명도 조절 메서드
 */
function layerPopupOpacity() {

	var defaultValue = 5;
	$("#layer-popup").css("background-color", "rgba(0,0,0,0.5)");

	$("#slider-range").slider({
		step : 1,
		range : "max",
		min : 0,
		max : 10,
		value : defaultValue,
		slide : function(event, ui) {
			opacityValue = ui.value;

			switch (opacityValue) {
				case 0:
					opacityValue = 0.0;
					break;
				case 1:
					opacityValue = 0.1;
					break;
				case 2:
					opacityValue = 0.2;
					break;
				case 3:
					opacityValue = 0.3;
					break;
				case 4:
					opacityValue = 0.4;
					break;
				case 5:
					opacityValue = 0.5;
					break;
				case 6:
					opacityValue = 0.6;
					break;
				case 7:
					opacityValue = 0.7;
					break;
				case 8:
					opacityValue = 0.8;
					break;
				case 9:
					opacityValue = 0.9;
					break;
				case 10:
					opacityValue = 1;
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
    	$("#layer-popup").css("visibility", "hidden");
		$(".select_inner").css("display", "none");
    	$("#contextMenuBlock").css("display", "");

/* 컨텍스트 메뉴 작업하면서 주석처리 */
//    	if (userGadget == 1) {
//    		$("#open-memo").css("display", "");
//    	} else {
//    		$("#open-memo").css("display", "none");
//    		setGadgetPositionResize();
//    	}
    	
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
       				if (result.status == 'ok') {
       					if(window.frames["main"].frames["right"] != undefined) {			
			               	if(window.frames["main"].frames["right"].folderId != null) {
			               		window.frames["main"].frames["right"].getMemoList();	// 메모 게시판 새로고침
			               	}		           		
		                }
       				}
       			 },
       			 error : function() {
       				 alert(strLangMemo21);
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
    	layerToggle();
    });
 	
    // 메모 레이어 이전크기 시
    $("#controllable").click(function() {
    	layerToggle();
    });	
}

// 클릭한 버튼에 따라 메모 레이어 변경
function layerToggle() {
	var memoLayer = $("#layer-popup");
	var layerClass = memoLayer.attr("class");
	
	if (layerClass.indexOf("layerControl") != -1) {				// // layer resizable mode
		$("#fullScreen").css("display", "none");
		$("#controllable").css("display", "");
		
		memoLayer.removeClass("layerControl").addClass("layerFullScreen");
		
		$("#layer-popup .ui-resizable-handle").css("display", "none");
		
		draggableFalse();
		setMemoLayerMode(1);
		
	} else if(layerClass.indexOf("layerFullScreen") != -1) {	// layer full-screen mode
		$("#controllable").css("display", "none");
		$("#fullScreen").css("display", "");
		
		memoLayer.removeClass("layerFullScreen").addClass("layerControl ui-draggable ui-draggable-handle ui-resizable");
		$("#layer-popup .ui-resizable-handle").css("display", "");

		draggableTrue();
		setMemoLayerMode(0);
	}
	layerClass = memoLayer.attr("class");
	
	getMemoLayerSize(layerClass);
	
	emptyMemoResize();
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
        	
        	checkAndActionBigMemo(memoId);
        	
        	if(window.frames["main"].frames["right"] != undefined) {			
            	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
            		window.frames["main"].frames["right"].getMemoList();
        	}
        	
        },
        error : function() {
        	alert(strLangMemo21);
        }
	});
}


/**
 * 메모 수정 후 저장하는 메서드
 * @param obj
 */
function modifyMemo(obj) {
	var size;
	var memoId;
	var afterContents;

	if (obj.getAttribute("memoid")) {				// 작은 메모 수정
		memoId = obj.getAttribute("memoid");
		afterContents = $(".memoText[memoid=" + memoId + "]").val();
		size = "small";
	} else {
		memoId = obj.getAttribute("bigmemoid");		// 큰 메모 수정
		afterContents = $("#dMContents").val();
		size = "big";
	}
	
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
        	// saveMemoToast(memoId);
            if(window.frames["main"].frames["right"] != undefined) {			
               	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
               		window.frames["main"].frames["right"].getMemoList();
            }
            setContents(size, memoId, afterContents);
        },
        error : function() {
        	alert(strLangMemo21);
        }
    }); 
}

/**
 * 메모 숨김 처리하는 메서드
 * @param obj
 */
function hideMemo(obj) {
	var memoId = obj.getAttribute("memoid");
	
	$.ajax ({
		  url : '/ezMemo/memo-display.do',
		  type : 'POST',
          dataType : 'json',
          data : { 
            memo_ids : memoId,
            display : 1
          },  
          cache: false,
          success: function(result) {
        	  $('#memo' + memoId).remove();
        	  
        	  if(window.frames["main"].frames["right"] != undefined) {			
                  if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
                	  window.frames["main"].frames["right"].getMemoList();
              }
        	  checkAndActionBigMemo(memoId);
          },
          error : function() {
        	  alert(strLangMemo21);
          }
	});
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
    	},
    	error : function() {
    		alert(strLangMemo21);
    	}
    });
}


/**
 * config값 가져오는 메서드
 */
function getMemoConfig() {
	var bigMemoInfo = {};
	var layerParam = {};
	
	var memoLayer = $('#layer-popup');
	var memoLayerClass = memoLayer.attr('class');
	
	$.ajax({
		type : "GET",
    	dataType : "JSON",
    	async : false,
    	url : "/ezMemo/getMemoConfig.do",
    	success : function(result) {
    		// 폰트 사이즈 세팅
    		fontSize = result.memoConfigVO.font_size;
    		// 메모에 날짜 표시 여부 세팅
			useDate = result.memoConfigVO.use_date;
			// 메모 추가할 때 나타낼 메모지 색깔 세팅
			defaultColor = result.memoConfigVO.default_color;
			
			// layer css 값
			layerParam['top'] = result.memoConfigVO.layer_top;
			layerParam['left'] = result.memoConfigVO.layer_left;
			layerParam['width'] = result.memoConfigVO.layer_width;
			layerParam['height'] = result.memoConfigVO.layer_height;
			layerParam['mode'] = result.memoConfigVO.full_mode;
			
			if(result.memoConfigVO.full_mode == 1) {			//	1 -> layer full-screen mode
				// 처음 사용자 계정을 만들시, 풀 스크린 모드로 출력 
				if(firstDBLayerSize=="yes") {
					$("#fullScreen").css("display", "none");	// full-screen 버튼 숨김
					$("#controllable").css("display", "");		// control 버튼 나타냄
					memoLayer.removeClass("layerControl").addClass("layerFullScreen");		// class를 full-screen으로 변경
					memoLayerClass = memoLayer.attr('class');
	        		$(".noteBlock .ui-resizable-handle").css("display", "none");
	        		
	        		memoLayer.draggable({ disabled: true });			// 드래그 방지
	        		
				} else {										//	0 -> layer resizable mode
					memoLayer.removeClass("layerFullScreen").addClass("layerControl ui-draggable ui-draggable-handle ui-resizable");	// class를 full-screen으로 변경
					memoLayerClass = memoLayer.attr('class');
	        		$("#layer-popup .ui-resizable-handle").css("display", "");
	        		memoLayer.draggable({ disabled: false });			// 드래그 살림
					return;
				}
        		firstDBLayerSize="no";
			}
			// 레이어 사이즈 세팅
			getMemoLayerSize(memoLayerClass, layerParam);
			
			// 화면에 맞춰 메모 레이어 리사이즈
			memoLayerResize();
			
			// 메모가 없을 경우 보여줄 이미지 리사이즈
			emptyMemoResize();
        	
        	bigMemoInfo.height = result.memoConfigVO.b_memo_height;
        	bigMemoInfo.width = result.memoConfigVO.b_memo_width;
        	bigMemoInfo.left = result.memoConfigVO.b_memo_left;
        	bigMemoInfo.top = result.memoConfigVO.b_memo_top;
        	
        	setBigMemoAtFirst(bigMemoInfo);
        	
        	// 최근에 큰 메모로 열었던 메모 아이디
        	var memoId = result.memoConfigVO.memo_id;
        	// 큰 메모 오픈 상태
        	var memoStatus = result.memoConfigVO.b_memo_status;
        	
        	// 메모의 오픈 상태와 아이디 체크 후 큰 메모 오픈
        	if (memoStatus != 0 && memoId != 0) {
        		getMemoDetail(memoId);
        	}
    	},
    	error : function() {
    		alert(strLangMemo21);
    	}
	});
}

// 메모 레이어 사이즈 세팅
function getMemoLayerSize(classNm, layerParam) {
	var winWidth = window.innerWidth;
	var winHeight = window.innerHeight;
	
	var top, left, width, height;
	
	// layer의 사이즈를 파라미터로 넘겨받는 경우
	if (layerParam && layerParam.mode === 0) {
		top = layerParam.top;
		left = layerParam.left;
		width = layerParam.width;
		height = layerParam.height;
	// 	layer의 사이즈를 파라미터로 넘겨받지 않는 경우
	} else {
		// layer resizable mode
		if (classNm.indexOf("layerControl") != -1) {
			$.ajax({
				type : "GET",
				dataType : "JSON",
				async : false,
				url : "/ezMemo/getMemoConfig.do",
				success : function(result) {
					if (result.memoConfigVO.full_mode == 0) {
						top = result.memoConfigVO.layer_top;
						left = result.memoConfigVO.layer_left;
						width = result.memoConfigVO.layer_width;
						height = result.memoConfigVO.layer_height;
					}
				},
				error : function() {
					alert(strLangMemo21);
		    	}
			});
		// layer full-screen mode
		} else if (classNm.indexOf("layerFullScreen") != -1) {
			top = 56;
			left = 0;
			width = winWidth;
			height = winHeight - 56;
		}
	}
	$("#layer-popup").css({"top": top, "left": left, "width": width, "height": height});
	
	setMemoListSize();
	
	memoLayerResize();
}

/**
 * 메모 리스트 사이즈 변경 메서드
 */
function setMemoListSize() {
	var layerWidth = $("#layer-popup")[0].offsetWidth;
	var layerHeight = $("#layer-popup")[0].offsetHeight;
    var memoListHeight = layerHeight - 54;					// 54 -> 메모 레이어 헤더의 높이
    
    $(".memo_main").css({"height" : memoListHeight - 30, "width" : layerWidth});	// 30 -> 임의의 숫자 - 투명도 조절 버튼이 잘 보이는 높이
    $(".memoListBox").css({"height" : memoListHeight - 30, "width" : layerWidth});
    
//	emptyMemoResize();
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
		},
		error : function() {
			alert(strLangMemo21);
    	}
	});
}

// 레이어 위치값 변경 메서드
function setLayerPosition() {
	var memoLayer = $("#layer-popup");
	var layerClass = memoLayer.attr("class");
	
	if (layerClass.indexOf("layerControl") != -1) {
		var layerTop = parseInt(memoLayer[0].offsetTop);
		var layerLeft = parseInt(memoLayer[0].offsetLeft);
		
    	$.ajax({
    		type : "POST",
    		data : {
    			layerTop : layerTop,
    			layerLeft : layerLeft
    		},
    		dataType : "JSON",
    		url : "/ezMemo/setLayerPosition.do",
    		success : function(result) {
    			
    		},
    		error : function() {
    			alert(strLangMemo21);
        	}
    	});
	}
}

// 레이어 넓이값 변경 메서드
function setLayerArea() {
	var memoLayer = $("#layer-popup");
	var layerClass = memoLayer.attr("class");
		
	if (layerClass.indexOf("layerControl") != -1) {

		var layerWidth = parseInt(memoLayer[0].offsetWidth);
		var layerHeight = parseInt(memoLayer[0].offsetHeight);
		
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
				alert(strLangMemo21);
	    	}
		});
	}
}

 /**
  * 윈도우 리사이즈 시, 레이어 위치 및 사이즈 조절
  */
function memoLayerResize() {
	var memoLayer = $('#layer-popup');
	
	var beforeWidth, width;
	var beforeHeight, height;
	var beforeTop, top;
	var beforeLeft, left;
	
	beforeWidth = width = memoLayer[0].offsetWidth;			// 레이어의 넓이
	beforeHeight = height = memoLayer[0].offsetHeight;		// 레이어의 높이
	beforeTop = top = memoLayer[0].offsetTop;				// 레이어의 top
	beforeLeft = left = memoLayer[0].offsetLeft;			// 레이어의 left
	
	var windowHeight = parseInt(window.innerHeight);
	var windowWidth = parseInt(window.innerWidth);
	
	var layerClass = memoLayer.attr("class");
	
	if (layerClass.indexOf("layerControl") != -1) {			// 레이어가 resizable 모드이면
		
		// 16 -> 스크롤 바의 넓이, 높이 
		if (height + top > windowHeight) { 					// 레이어의 높이와 top의 합이 window의 높이보다 클 때
			if (height < windowHeight) {						// 레이어의 높이가 브라우저의 높이보다는 작다면
				top = windowHeight - height - 16 >= 0 ? windowHeight - height - 16 : 0;	//  top만 변경 단, 0보다 작으면 0
				memoLayer.css('top', top);
				
			} else {											// 레이어의 높이가 브라우저의 높이보다 크면
				if (height > 380) {									// 단, 레이어의 높이가 380(레이어의 최소 높이)보다 크면
					memoLayer.css('height', windowHeight);			// 높이를 브라우저 사이즈로 변경
				}
			}
		}													// 레이어의 높이와 top의 크기의 합이 window의 높이보다 작으면 그대로
		
		if (width + left > windowWidth) {					// 레이어의 넓이와 left의 합이 window의 넓이보다 클 때
			if (width < windowWidth) {							// 레이어의 넓이가 브라우저의 넓이보다는 작다면
				left = windowWidth - width - 16 >= 0 ? windowWidth - width - 16 : 0;	// left만 변경 단, 0보다 작으면 0
				memoLayer.css('left', left);
				
			} else {											// 레이어의 넓이가 브라우저의 넓이보다 크면
				if (width > 340) {									// 단, 레이어의 넓이가 340(레이어의 최소 넓이)보다는 크면
					memoLayer.css('width', windowWidth);				// 넓이를 브라우저 사이즈로 변경
				}
			}
		}	
		setMemoListSize();
		
    	/* 
    	 * 레이어의 사이즈나 위치가 변했을 경우 
    	 * 적용된 사이즈와 position DB에 저장
    	 */
    	if (beforeTop != top || beforeLeft != left) {
	    	setLayerPosition();
    	}
    	if (beforeHeight != height || beforeWidth != width) {
	    	setLayerArea();
    	}
    	
	} else if (layerClass.indexOf("layerFullScreen") != -1) {	// 레이어가 full-screen 모드이면
		memoLayer.css({"top": 56, "left": 0, "width": windowWidth, "height": windowHeight - 56})
		
		//memoLayer.css("width", windowWidth);						// 레이어의 넓이 = 윈도우의 넓이
		//memoLayer.css("height", windowHeight - 56);				// 레이어의 높이 = 윈도우의 높이 - 포탈 페이지의 메뉴 높이(56)
    	
		setMemoListSize();
	}
}

/**
 * 퀵메모 위치값 저장 메서드
 * (display !== 'none')일때만
 */
/* 컨텍스트 메뉴 작업하면서 주석처리 */
//function setGadgetPosition() {
//	var gadgetStatus = $("#open-memo").css("display");
//	
//	if (gadgetStatus != "none") {
//		// 2019-01-04 김민성 - IE 메모 가젯 오류 수정
//		var topString = $("#open-memo").offset().top;
//		var leftString = $("#open-memo").offset().left;
//		
//    	/*var topPIndex = topString.indexOf("p");
//		var leftPIndex = leftString.indexOf("p");*/
//		
//		var windowHeight = parseInt(window.innerHeight);
//    	var windowWidth = parseInt(window.innerWidth);
//		
//    	var outHeight = parseInt($("#open-memo").height());
//    	var outWidth = parseInt($("#open-memo").width());
//		
//    	var gadgetBottom = windowHeight - outHeight - topString;
//		var gadgetRight = windowWidth - outWidth - leftString;
//		/*var gadgetBottom = windowHeight - outHeight - parseInt(topString.substr(0, topPIndex));
//		var gadgetRight = windowWidth - outWidth - parseInt(leftString.substr(0, leftPIndex));*/
//    	
//		$.ajax({
//			type : "POST",
//			data : {
//				gadgetBottom: gadgetBottom,
//				gadgetRight : gadgetRight
//			}, 
//			dataType: "JSON",
//			url : "/ezMemo/setGadgetPosition.do",
//			success : function(result) {
//				
//			}
//			
//		});
//	}
//	
//}


/**
 * 퀵메모 위치값 get 메서드
 * @param memoConfigVO
 */
/* 컨텍스트 메뉴 작업하면서 주석처리 */
//function getGadgetPosition(memoConfigVO) {
//	
//	var gadgetBottom = memoConfigVO.gadget_bottom;
//	var gadgetRight = memoConfigVO.gadget_right;
//
//	$("#open-memo").css({"bottom" : gadgetBottom, "right" : gadgetRight})
//}


/**
 * 윈도우 리사이즈 시, 퀵메모 위치 변경 메서드
 */
/* 컨텍스트 메뉴 작업하면서 주석처리 */
//function setGadgetPositionResize() {
//	
//	var bottom = $("#open-memo").offset().bottom;
//	var right = $("#open-memo").offset().right;
//	/*var stringBottom = $("#open-memo").css("bottom");
//	var stringRight = $("#open-memo").css("right");*/
//	
//	var windowHeight = parseInt(window.innerHeight);
//	var windowWidth = parseInt(window.innerWidth);
//	
//	/*var bottomPIndex = stringBottom.indexOf("p");
//	var rightPIndex = stringRight.indexOf("p");*/
//	
//	var width = parseInt($("#open-memo").width());
//	var height = parseInt($("#open-memo").height());
//	
//	/*var bottom = parseInt(stringBottom.substr(0, bottomPIndex));
//	var right = parseInt(stringRight.substr(0, rightPIndex));*/
//	
//	if (bottom < 0) {
//		$("#open-memo").css({"top" : "auto", "bottom" : 15 });
//	} 
//
//	if (right < 0) {
//		$("#open-memo").css({"left" : "auto", "right" : 15 });
//	}
//	
//	setGadgetPosition();
//}


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
        	alert(strLangMemo21);
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
        	obj[0].setAttribute("class", "memo0" + defaultColor + " memoLay");
        	obj.context.parentElement.style.visibility = "hidden";
        	
        	if(window.frames["main"].frames["right"] != undefined) {			
            	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
            		window.frames["main"].frames["right"].getMemoList();
        	}
        	checkAndActionBigMemo(memoId, idx);
        },
        error : function() {
        	alert(strLangMemo21);
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
        	memoList = result["memoList"];
        	layerFlag = result["layerFlag"];
        	
	    	setMemoListSize();

	    	loadMemoList(layerFlag);
		    
			var memoLength = $(".memo_main .memoLay").length;
        	if (memoLength == 0) {

        		addEmptyMemo(layerFlag);
        	}
	     },
	     error : function() {
	    	 alert(strLangMemo21);
	    }
	});
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
			html += "<option value='0'>" + strLangMemo9 + "</option>";
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
		},
		error : function() {
			alert(strLangMemo21);
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
    		//portalContextMenu.js
    		
    		if (userGadget == 1) {
    			var layerStatus = $("#layer-popup").css("display");

//    			if (layerStatus.indexOf("none") != -1) {
//        			getGadgetPosition(memoConfig);
//        			openMemo.style.display = "block";
//    			}
    			
    			setMemoFlag('YES');
    			
    		} else {
    			if(openMemo !== null) {
    				openMemo.style.display = "none";	
    			}
    			document.getElementById("layer-popup").style.display = "none";
    			setMemoFlag('NO');
    		}
    	},
    	error : function() {
    		alert(strLangMemo21);
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
    		
    	},
    	error : function() {
    		alert(strLangMemo21);
    	}
	});
}


/**
 * noteBlock 내 더블클릭시, 음영 삭제 메서드
 */
function noteClearSelection() {
	var noteBlock = document.getElementsByClassName('noteBlock');
	noteBlock[0].addEventListener("dblclick", clearSelection, false);
	
	//$(".noteBlock").on("selectstart", function(event){return false;});
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
		if(w < 340) {
			w = 340;
		}
		// 브라우저 높이
		var h = window.innerHeight;
		if(h < 425) {
			h = 425;
		}
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
			memoMain.style.height = (h - 135) + "px";
			popup.style.width = w + "px";
			popup.style.height = (h - 45) + "px";
			
		} else {
			/*
			 *  창모드일 경우
			 *  브라우저의 크기를 layer-popup이 벗어날 경우
			 */
			if(((w>popupLeft) && (w < popupLeft + popupWidth)) || ((h>popupTop) && (h < popupTop + popupHeight))){
				mLBox.style.width = w + "px";
				mLBox.style.height = (h - 120) + "px";
				memoMain.style.width = w + "px";
				memoMain.style.height = (h - 120) + "px";
				popup.style.width = w + "px";
				popup.style.height = (h - 45) + "px";
				popup.style.left = "0px";
				popup.style.top = "55px";
			}
		}
		
		// 빈메모 resize 이벤트 추가
		emptyMemoResize();
	}
}

// 큰 메모관련 이벤트
function addEventInBigMemo() {
	var memoStatus;
	var beforeContents;
    var afterContents;
    var bigHeight;
    var bigWidth;
    var bigTop;
    var bigLeft;
    
    // 큰 메모에 리사이즈 이벤트
    $("#detailMemo").resizable({
    	handles : "n, e, s, w, ne, se, sw, nw",
		containment:".noteBlock",
		minWidth: 340,
		minHeight: 380,
		start : function () {
			bigHeight = parseInt($('#detailMemo')[0].clientHeight);
			bigWidth = parseInt($('#detailMemo')[0].clientWidth);
		},
		resize : function (event, ui) {
			bigHeight = parseInt($('#detailMemo')[0].clientHeight);
			bigWidth = parseInt($('#detailMemo')[0].clientWidth);
			
			setBigMemoBody(bigHeight, bigWidth);
		},
		stop : function (event, ui) {
			setBigMemoArea(bigHeight, bigWidth);
		}
    }).on('mousedown', function () {
    	$('#noteBlock').css('visibility', 'visible');
    }).on('mouseup', function () {
        $('#noteBlock').css('visibility', 'hidden');
    });

    // 큰 메모에 드래그 이벤트
    $("#detailMemo").draggable({
    	containment:".noteBlock",
        scroll : false,
        opacity : 0.7,
        drag : function() {
        	bigTop = parseInt($('#detailMemo')[0].offsetTop);
        	bigLeft = parseInt($('#detailMemo')[0].offsetLeft);
        },
        stop : function() {
        	setBigMemoPositon(bigTop, bigLeft);
        }
    }).on('mousedown', function () {
        $('#noteBlock').css('visibility', 'visible');
    }).on('mouseup', function () {
        $('#noteBlock').css('visibility', 'hidden');
    });
    
    // 큰 메모 닫기
    $("#closeMemo").click(function() {
    	setDetailStatus();
        $("#detailMemo").css('visibility', 'hidden');
    });

    // 큰 메모에서 내용 수정
    $('#dMContents').on('blur', function () {
    	var thisEl = $(this);
        modifyMemo(thisEl[0]);
    });
}

// 큰 메모의 제일 처음 위치와 사이즈를 정함
function setBigMemoAtFirst(sizeInfo) {
	var bigMemo = $('#detailMemo');
   
	var defaultHeight = 400;
	var defaultWidth = 400;

	var bigHeight;
	var bigWidth;
	var bigTop;
	var bigLeft;
	
	if (sizeInfo.width != null && sizeInfo.width != 0) {
		bigWidth = sizeInfo.width;
		bigHeight = sizeInfo.height;
		bigTop = sizeInfo.top;
		bigLeft = sizeInfo.left;
	} else {
		var winWidth = window.innerWidth;
		var winHeight = window.innerHeight;

		bigWidth = defaultWidth;
		bigHeight = defaultHeight;
		
		bigLeft = winWidth/2 - defaultWidth/2;
		bigTop = winHeight/2 - defaultHeight/2;
	}
	
	bigMemo.css({'width' : bigWidth, 'height' : bigHeight, 'top' : bigTop, 'left' :bigLeft});
	setBigMemoBody(bigHeight, bigWidth);
}

// 큰 메모의 textarea 사이즈
function setBigMemoBody(bigHeight, bigWidth) {
	// 37 - 큰 메모 헤더 높이, 29 - 큰 메모 bottom 높이
	var contentsHeight = parseInt(bigHeight - 37 - 29);
	// 11 - 스크롤바 넓이
	var contentsWidth = parseInt(bigWidth - 12);
	
	$('#dMContents').css({'width': contentsWidth, 'height' : contentsHeight});
}

// 큰 메모 불러오기
function getMemoDetail(memoId) {
	
    $.ajax({
    	type : 'GET',
    	data : { 'memoId' : memoId, },
    	url : '/ezMemo/memoDetail.do',
    	dataType : 'JSON',
    	success : function(result) {
    		var detail = $('#detailMemo');
    		var detailContents = $('#dMContents');
    		
    		detailContents.attr('bigMemoId', result.memo.memo_id);		// 새로 불러올 메모 id 세팅
    		detail.removeClass().addClass('ui-resizable ui-draggable ui-draggable-handle memo0' + result.memo.color_id + 'Big');	// 새로 불러올 메모 색상 세팅
    		
    		if (useDate === 1) {		// 날짜 표시하는 경우
    			addDateInfo(result.memo.write_date.substring(0,10), detail);	// 날짜 표시
    		}
    		detailContents.val('').val(result.memo.contents);	// 큰 메모의 내용을 지운 후 다시 세팅
    		
    		setDetailStatus(memoId);							// 더블 클릭한 메모의 id와 함께 큰 메모 열림 상태 저장
    		
    		bigMemoResize();									// 큰 메모 생성 후 리사이즈
    		
			detail.css('visibility', 'visible');				// 큰 메모 관련 모든 것이 세팅 되면 큰 메모를 띄움
			detailContents.focus();								// 큰 메모에 포커스 생성
    	},
    	error : function() {
    		alert(strLangMemo21);
    	}
    });
}

// 큰 메모에서 내용 수정시 작은 메모에도 적용
function setContents(size, memoId, afterContents) {
	if (memoId != null && memoId != undefined) {
		if (size === 'big') {
			$(".memoText[memoid=" + memoId + "]").val(afterContents);
		} else {
			var bigMContents = $("#dMContents");
			var bigMemoId = parseInt(bigMContents.attr('bigmemoid'));
			
			if (bigMContents.css('visibility') === 'visible' && bigMemoId === parseInt(memoId)) {
				bigMContents.val(afterContents);
			}
		}
	}
}

// 큰 메모의 높이와 넓이 저장
function setBigMemoArea(bigHeight, bigWidth) {
	$.ajax({
    	type : 'POST',
        url : '/ezMemo/setDetailMemoArea.do',
        data : {
        	'bigHeight' : bigHeight,
			'bigWidth' : bigWidth
        },
        dataType : 'JSON',
        success : function(result) {
        },
        error : function() {
        	alert(strLangMemo21);
    	}
    });
}

// 큰 메모의 top, left 저장
function setBigMemoPositon(bigTop, bigLeft) {
	$.ajax({
		type : 'POST',
		data : {
			'bigTop' : bigTop,
			'bigLeft' : bigLeft
		},
		url : '/ezMemo/setDetailMemoPosition.do',
		dataType : 'JSON',
		success : function(result) {
		},
		error : function() {
			alert(strLangMemo21);
    	}
	});
}
/*윈도우 리사이즈 시 큰 메모 리사이징*/ 
function bigMemoResize() {
	var bigMemo = $("#detailMemo");
	
	// 큰 메모의 처음 크기로 쓸 변수, 상황에 따라 변할 변수
	var beforeWidth, width;
	var beforeHeight, height;
	var beforeTop, top;
	var beforeLeft, left;
	
	beforeWidth = width = bigMemo[0].offsetWidth;		// 큰 메모의 넓이
	beforeHeight = height = bigMemo[0].offsetHeight;	// 큰 메모의 높이
	beforeTop = top = bigMemo[0].offsetTop;				// 큰 메모의 top
	beforeLeft = left = bigMemo[0].offsetLeft;			// 큰 메모의 left
	
	var windowHeight = parseInt(window.innerHeight);	// window의 높이
	var windowWidth = parseInt(window.innerWidth);		// window의 넓이
	// 16 -> 스크롤 바의 넓이, 높이 
	if (height + top > windowHeight) { 					// 큰 메모의 높이와 top의 합이 window의 높이보다 클 때
		if (height < windowHeight) {						// 큰 메모의 높이가 브라우저의 높이보다는 작다면
			top = windowHeight - height - 16 >= 0 ? windowHeight - height - 16 : 0;	//  top만 변경 단, 0보다 작으면 0
			bigMemo.css('top', top);
		} else {											// 큰 메모의 높이가 브라우저의 높이보다 크면
			if (height > 380) {									// 단, 큰 메모의 높이가 380(큰 메모의 최소  높이)보다 크면
				bigMemo.css('height', windowHeight);			// 높이를 브라우저 사이즈로 변경
			}
		}
	}													// 큰 메모의 높이와 top의 크기의 합이 window의 높이보다 작으면 그대로
	
	if (width + left > windowWidth) {					// 큰 메모의 넓이와 left의 합이 window의 넓이보다 클 때
		if (width < windowWidth) {							// 큰 메모의 넓이가 브라우저의 넓이보다는 작다면
			left = windowWidth - width - 16 >= 0 ? windowWidth - width - 16 : 0;	// left만 변경 단, 0보다 작으면 0
			bigMemo.css('left', left);
		} else {											// 큰 메모의 넓이가 브라우저의 넓이보다 크면
			if (width > 340) {									// 단, 큰 메모의 넓이가 340(큰 메모의 최소  넓이)보다는 크면
				bigMemo.css('width', windowWidth);				// 넓이를 브라우저 사이즈로 변경
			}
		}
	}													// 큰 메모의 넓이와 left의 크기의 합이 window의 넓이보다 작으면 그대로
	
	//큰 메모의 리사이즈 후 큰 메모의 바디 사이즈 수정
	setBigMemoBody(height, width);
	
	//리사이즈로 큰 메모의 영역이나 위치가 변경되었다면 DB에 저장
	if (beforeWidth != width || beforeHeight != height) {	// 처음의 width, height와 비교해  
		setBigMemoArea(height, width);						// 리사이즈 이후의 넓이 or 높이가 달라졌다면 달라진 값 저장
	}
	if (beforeTop != top || beforeLeft != left) {			// 처음의 top, left와 비교해 
		setBigMemoPositon(top, left);						// 리사이즈 이후의 top or left가 달라졌다면 달라진 값 저장
	}
	
}

//작은 메모에서 삭제, 색변경, 숨김 했을 때 큰 메모 동기화
function checkAndActionBigMemo(memoId, color) {
	var visibility = $('#detailMemo').css('visibility');
	var bigMemoId = $('#dMContents').attr('bigmemoid');
	
	// 큰 메모가 열린 상태이면서 작은 메모와 같은 메모이면 작동
	if (visibility === 'visible' && parseInt(memoId) === parseInt(bigMemoId)) {
		if (color) {
			$('#detailMemo').attr('class', 'ui-resizable ui-draggable ui-draggable-handle memo0' + color + 'Big');
		} else {
			$('#closeMemo').click();
		}
	}
}

// 메모 focus 이벤트
function memoFocusEvent(thisEl) {
	beforeMemo = thisEl.value;
	autoSaveStart(thisEl);
}

//일정 시간마다 자동 저장
function autoSaveStart(param) {
	autoSaveStop();
	
	memoInter = setInterval(function() {
		//console.log('저장?');
		var resultObj = compareContents(param);
		if (resultObj.result === 'ok') {
			//console.log('yes');
			modifyMemo(param);
			beforeMemo = resultObj.afterVal;
		} else {
			//console.log('no');
		}
	}, 3000);
}

//자동 저장 기능 정지
function autoSaveStop() {
	//console.log('정지');
	clearInterval(memoInter);
}

// 메모 오픈 상태 저장
function setDetailStatus(memoId) {
	var status;
	var datas = {'memoId' : 0, 'openStatus' : 0};
	
	if (memoId != undefined) {
		datas['memoId'] = memoId;
		datas['openStatus'] = 1;
	}
	
	$.ajax({
		type : 'POST',
		url : '/ezMemo/setDetailMemoStatus.do',
		data : datas,
		dataType : 'JSON',
		success : function(result) {
		},
		error : function() {
			alert(strLangMemo21);
    	}
	});
}

// 메모 레이어의 드래그 기능 제거, memoBoard에서도 사용
function draggableFalse() {
	$('#layer-popup').draggable('disable');
}

// 메모 레이어의 드래그 기능 살림, memoBoard에서도 사용
function draggableTrue() {
	$('#layer-popup').draggable('enable');
}

/*
memoBoard에서 실행할 함수 
portal 페이지의 beforeMemo 변수에 파라미터로 넘어온 값 세팅
*/
function setBeforeMemo(paramBefore) {
	beforeMemo = paramBefore;
}

