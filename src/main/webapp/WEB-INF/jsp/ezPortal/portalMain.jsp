<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="<spring:message code='main.e6' />" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<link rel="stylesheet" href="${util.addVer('/css/ezMemo/memo.css')}">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}">
		<link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezMemo.c1', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memo.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.concat.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezMemo.e1', 'msg')}"></script>
		<style>
			.layerpopup {
				-webkit-border-top-left-radius: 5px;
				-webkit-border-top-right-radius: 5px;
				-webkit-border-bottom-left-radius: 5px;
				-webkit-border-bottom-right-radius: 5px;

				-moz-border-radius-topleft: 5px;
				-moz-border-radius-topright: 5px;
				-moz-border-radius-bottomleft: 5px;
				-moz-border-radius-bottomright: 5px;
	 			background: url('/images/kr/cm/popup_bg2.gif') repeat-x left top #ffffff ;
     			box-shadow: 0 0 3px 3px #333333;
	 			padding:2px 2px;
	 			border:1px solid #ffffff;
			}

			.individual-memo { width:230px; height:230px; background-color:#0470e4; text-align:left; border:1px solid black; float: left; margin: 10px 25px 10px 25px; overflow:hidden; padding-top:5px; position:relative; }
			.noteBlock { margin: 0;padding: 0;width:100%;height:100%;position:absolute;z-index:1000;top:0;left:0;}
			#slider-range{width:70px;float:left; margin-left:15px;}
			.ui-widget-header{background: #0470e4}
			.ui-slider-handle{background: #eeeeee; margin-top:2px}
			.ui-resizable-se {background-image: url("");}
			.memoSelect{position:absolute; height:500px;}
			#memoFolderList{display:none;}
			.memoPlus{margin-left:250px;} //임시
			
    	</style>
		<script type="text/javascript">
			var topHeight = "${topHeight}";
			var topUrl = "${topUrl}";
			var mainUrl = "${mainUrl}";
			var headerColor;
	    	var textColor;
	    	var currText;
	    	var bodyColor;
	    	var useDate;
			var fontSize;
			var defaultColor;
	    	var dayArray = ["<spring:message code='main.t00052'/>", "<spring:message code='main.t00053'/>", "<spring:message code='main.t00054'/>", "<spring:message code='main.t00055'/>", "<spring:message code='main.t00056'/>", "<spring:message code='main.t00057'/>", "<spring:message code='main.t00058'/>"];
	    	var fontSize;
	    	var useDate;
			var defaultColor;
	    	var layerRight;
	    	var memoList;
	    	var userGadget;
	    	var layerFlag;
	    	
			topHeight = "56";

		 	window.onresize = function () {
		        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
		        document.getElementById("mainFrame").style.height = MainHeight + "px";
		 	}
		 	
		 	$(window).resize(function() {
		 		
 		 		layerResize();
		        setGadgetPositionResize();
		        emptyMemoResize();
		 	});
		 	
		    $(function() {
		    	defaultPointer();
		    	setPanelPointer();
		    	layerPopupOpacity();
		    	checkDefaultFolder();
		    	memoFoldersInfo();
	    		checkMemoConfig();
	    		getMemoList();

		    	// 스크롤바 디자인 변경
		    	$(".memoListBox").mCustomScrollbar({
		    		theme : "dark",
		    		scrollType : "stepped",
		    		
		    	});
		    	
		    	// 레이어 닫기 버튼 클릭
		        $(".memoClose").click(function() {
		        	$("#layer-popup").css("display", "none")
					$(".select_inner").css("display", "none");
		        	
		        	if (userGadget == 1) {
		        		$("#open-memo").css("display", "");
		        	} else {
		        		$("#open-memo").css("display", "none");
		        	}
		        	
		        });
		        
		        // 메모 정렬
		        $(".memo_main").sortable({
		        	
		        	containment: '.memoListBox',
		        	opacity : 0.5,
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
		        					
//			        				getMemoList();
			        				
			        				if(window.frames["main"].frames["right"] != undefined) {			
					                	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
					                		window.frames["main"].frames["right"].getMemoList();
				                	}
		        				}
		        			}
		        		 });
		        		 
		        	 }
		        	
		        });
		        
		        // 메모 레이어 리사이즈
		        $(".layerControl").resizable({
		        	
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
		        
		        $("#memoMove").click(function() {

		        	var OpenWin = window.open("/ezMemo/memoFolderManage.do", "", GetOpenWindowfeature(500, 500));
		            try { OpenWin.focus(); } catch (e) { }
		        });
		        
		        // 메모 레이어 최대화 시
		        $("#fullScreen").click(function() {
		        	var layerClass = $("#layer-popup").attr("class");
		        	
		        	if (layerClass.indexOf("layerControl") != -1) {
		        		$("#fullScreen").css("display", "none");
		        		$("#controllable").css("display", "");
		        		
		        		$("#layer-popup").removeClass("layerControl").addClass("layerFullScreen");
		        		$(".ui-resizable-handle").css("display", "none");
		        		
		        		$("#layer-popup").draggable({
		        			disabled: true
		        		});
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
		        		$(".ui-resizable-handle").css("display", "");
		        		
		        		$("#layer-popup").draggable({
		        			disabled: false
		        		});
		        	}
		        	setLayerSize();
		        	emptyMemoResize();
		        });
		        
		        // 새 메모 추가 
		        $("#addMemo").click(function() {
		        	newMemo();
		        });
		        
		     	// 메모함 비어있을 시, 추가 이미지 클릭으로 새 메모 추가 
		        $(".memo_main").on("click", "#addFirstMemo", function() {
		        	newMemo();
		        });
		        
		        // 메모 내용 변경 
		        /* $(".memo_main").on("click", ".memoLay .pallete2", function() {
		        	modifyMemo(this);

		        });*/
		    });
		    
		    // 셀렉트 박스 마우스 포인터 벗어날 경우
		    function closeSelectInner() {
		    	var selectInner = document.getElementById("select_inner");	    	
		    	selectInner.addEventListener('mouseleave', function() {
		    		selectInner.style.display = "none";
		    	});
		    }
		    
		    function changeFolder() {
		        // 메모 분류함 클릭 시, 해당 메모 리스트 호출
		        $(".changeFolder").click(function(event) {
		        	$("select option:selected").val();
		        	$("select").val(event.target.id).prop("selected", true);
		        	getMemoList();
		        	emptyMemoResize();
		        });
		    }
		    
		    // 모달 삭제 || 메모지 삭제
		    function modalDelete(memoId) {
		    	var flag = $("#layerFlag").val();
		    	
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
		            	if($(".memoLay").length == 0) {
	                		loadMemoList(layerflag);
	                	}
		            	
		            	var memoLength = $(".memo_main .memoLay").length;
		            	if (memoLength == 0) {

		            		addEmptyMemo(flag);
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
		    
		 	// 메모 내용 변경	    
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
		                	
		                	//getMemoList();
		                	
		                	if(window.frames["main"].frames["right"] != undefined) {			
			                	if(window.frames["main"].frames["right"].folderId != null)		// 메모 게시판 새로고침
			                		window.frames["main"].frames["right"].getMemoList();
		                	}
		                },
		                error : function() {
		                	
		                }
					}); 
		    }
		 	
		    // 모드 변경 시 레이어 넓이 변경
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
		    
		    // 메모 컨피그 DB 확인 후 없으면 insert
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
		    
		    // 메모 설정값 가져오기
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
	        			if((result.memoConfigVO.layer_top == 55) && (result.memoConfigVO.layer_left == 0) && (result.memoConfigVO.layer_width == 340) && (result.memoConfigVO.layer_height == 380)) {
	        				// 처음 사용자 계정을 만들시, 풀 스크린 모드로 출력.  
	        				if(firstDBLayerSize=="yes") {
		        				$("#layer-popup").removeClass("layerControl").addClass("layerFullScreen");
				        		$(".ui-resizable-handle").css("display", "none");
				        		
				        		$("#layer-popup").draggable({
				        			disabled: true
				        		});
	        				} else {
	        					$("#layer-popup").removeClass("layerFullScreen").addClass("layerControl ui-draggable ui-draggable-handle ui-resizable");
	    		        		$(".ui-resizable-handle").css("display", "");
	    		        		$("#layer-popup").draggable({
	    		        			disabled: false
	    		        		});
	        					return;
	        				}
			        		firstDBLayerSize="no";
			        		setLayerSize();
	        			}
			        		
		        	}
		    	});
		    }
		    
		    // 메모 초기값 입력
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
		    
		    // 초기 pointet-event set
		    function defaultPointer() {
		    	
		    	$(".noteBlock").css("pointer-events", "none");
	        	$("#open-memo").css("pointer-events", "auto");
		    }
		    
		    /**
		     * noteBlock(노트패널), layer-popup(노트판), open-memo(노트 아이콘)의 포인터 set
		     */
			function setPanelPointer() {
	        	$("#open-memo" ).draggable({
	        		containment:".noteBlock",
	        		stop:function(){
	            		
	            		setGadgetPosition();
	        			
	        			defaultPointer();		
	        		}
	        	}).on("mouseup", function() {
		        	$(".noteBlock").css("pointer-events", "none");
		        	$("#open-memo").css("pointer-events", "auto");
		        	$("#layer-popup").css("pointer-events", "auto");
		        }).on("mousedown", function() {
		        	$(".noteBlock").css("pointer-events", "auto");
		       	}).on("click", function(event){
		       		event.preventDefault();
		       		if ("none" == ($("#layer-popup").css("display"))) {
		       			$("#open-memo" ).css("display", "none");
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
		       		
		       		containment:".noteBlock",
		       		stop : function() {
		       			$(".noteBlock").css("pointer-events", "none");
			        	$("#open-memo").css("pointer-events", "auto");
			        	$("#layer-popup ").css("pointer-events", "auto");
			        	
			        	setLayerPosition();
		       		}
		       	});
			}
			
		    // 레이어 위치값 변경
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
		    
		    // 레이어 넓이값 변경
		    function setLayerArea() {
				
		    	var layerClass = $("#layer-popup").attr("class");
		 		
		 		if (layerClass.indexOf("layerControl") != -1) {

		 			var layerWidth = parseInt($(".layerControl").width());
	        		var layerHeight = parseInt($(".layerControl").height());
	        		
	        		$.ajax({
	        			type:"POST",
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
		    
			 // 윈도우 리사이즈 시, 레이어 위치 및 사이즈 조절
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
			 
		    // 퀵메모 버튼 변경된 위치 저장 (단, display가 none이 아닐 때)
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
		    
		    // 퀵메모 버튼 위치 가져오기
		    function getGadgetPosition(memoConfigVO) {
		    	
		    	var gadgetBottom = memoConfigVO.gadget_bottom;
		    	var gadgetRight = memoConfigVO.gadget_right;

		    	$("#open-memo").css({"bottom" : gadgetBottom, "right" : gadgetRight})
		    }
		    
		    // 윈도우 리사이즈 시, 퀵메모 위치 변경 
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
        			$("#open-memo").css({"top" : "auto", "bottom" : 10 });
        			
        		} 

	        	if (right < 0) {
	        		$("#open-memo").css({"left" : "auto", "right" : 10 });
	        		
	        	}
		    	setGadgetPosition();
		    }
		    
		    /**
		     * layer-popup(노트판)의 투명도 조절
		     */
		    function layerPopupOpacity(){
		    	
		    	var defaultValue = 3;
		    	$("#layer-popup").css("background-color", "rgba(0,0,0,0.4)");
		    	
		    	$("#slider-range").slider({
		            step: 1,
		            range: "max",
		            min: 1,
		            max: 3,
		            value: defaultValue,
		            slide: function( event, ui ) {
		            	opacityValue = ui.value;
		            
		             	switch(opacityValue) {
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
		             	$("#layer-popup").css("background-color", "rgba(0,0,0," + opacityValue + ")");
		            }
		        });
		    }
		    
		    // 기본 메모함 체크
		    function checkDefaultFolder() {
		    	$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezMemo/hasMemoFolder.do"
				});
		    }
		    
		    // 메모 추가
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
			
		 	// 메모 색상 변경
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
		 	
		    // 메모 리스트 출력
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
	                	memoColor = result["colorList"].split(";");
	                	memoList = result["memoList"];
	                	layer = result["layerFlag"];
	                	
						loadMemoList(layer);
						
					    addremove();
					    
				    	setMemoListSize();
				     }
				});
			}
		    
		    // 메모 리스트 사이즈 변경
		    function setMemoListSize() {
		    	
			    var layerHeight = $("#layer-popup").height();
			    var layerWidth = $("#layer-popup").width();
			    var memoListHeight = layerHeight - 56;

			    $(".memoListBox").css({"height" : memoListHeight-20, "width" : layerWidth});
			    $(".memo_main").css({"width" : layerWidth, "height" : memoListHeight-20});
			    
		    }
		    
		    // 메모함 리스트 출력
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
		    
		 	// 퀵메모 디스플레이
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
		 	
		 	// 투명한 메모 위치 세팅
		    function emptyMemoResize() {
		    	
		    	var mainHeight = $(".memo_main").height();
		    	var mainWidth = $(".memo_main").width();
		    	
		    	var firstHeight = $("#addFirstMemo").height();
		    	var firstWidth = $("#addFirstMemo").width();
		    	
		    	var top = mainHeight/2 - firstHeight/2;
		    	var left = mainWidth/2 - firstWidth/2;

		    	$("#addFirstMemo").css({"position" : "absolute", "top" : top, "left" : left})
		    	
		    }
		 	
		</script>
	</head>
	<body style="margin:0px 0px 0px 0px;padding: 0px 0px 0px 0px;overflow:hidden;">
		<div style="height:56px;"><iframe src="${topUrl}" name="top" id="topFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;min-height:400px" frameborder="0"></iframe></div>
		<iframe src="${mainUrl}" name="main" id="mainFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;height:100%;" frameborder="0"></iframe>
		<%-- <div style="height:${topHeight}px"><iframe src="${topUrl}" name="top" id="topFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;" frameborder="0"></iframe></div>
		<iframe src="${mainUrl}" name="main" id="mainFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;" frameborder="0"></iframe> --%>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<!-- memo note -->
		<div class="noteBlock">
			
			<!-- 메모 레이어 -->
			<div id="layer-popup" class="memo_wrap layerControl" style="display:none;">
				<div class="memo_header_wrapper">
					<input type="hidden" id="layerFlag" value="layer" />
				 	<div class="memo_header">
				     	<ul class="memoHeaderUL">
				         	<li class="memoSelect">
				            	<select id="memoFolderList"></select>
				            </li>
							<li class="memoClose memoIcon30"></li>
			                <li class="memoExpand_s memoIcon30" id="controllable" style="display:none;"></li>
			                <li class="memoExpand memoIcon30" id="fullScreen"></li>
			                <li class="memoPlus memoIcon30" id="addMemo"></li>
				         </ul>
				     </div>
			     </div>
			     
			     <div class="memoListBox" style="overflow:hidden;">
			     	<div class="memo_main"></div>
			     </div>
				 
			     <div class="memobgBar">
			     	<div id="slider-range"></div>
			     </div>
			</div>
			
			<div id="open-memo" class="memoBtn" style="display: none;"><span>메모</span></div>
			
		</div>
		
	</body>
	<script type="text/javascript">
    	var Main_DialogArguments = new Array();
    	var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
    	/* var MainHeight = document.documentElement.clientHeight - parseInt("${topHeight}"); */
    	document.getElementById("mainFrame").style.height = MainHeight + "px";
	</script>
</html>