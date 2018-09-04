<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
		<link href="<spring:message code='main.e6' />" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="/js/jquery/jquery-ui.css">
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memo.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.concat.min.js')}"></script>
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

			#open-memo { width:60px; height:60px; position: absolute; z-index: 1000; cursor: pointer; background-color: white; text-align: center;}
			.individual-memo { width:230px; height:230px; background-color:#0470e4; text-align:left; border:1px solid black; float: left; margin: 10px 25px 10px 25px; overflow:hidden; padding-top:5px; position:relative; }
			#layer-popup{float:right; background:white; position:absolute; text-align:center; border:1px solid black; z-index: 1001; background-color: rgba(231,231,231,1);overflow:hidden; height: 50%;min-height: 270px; min-width: 270px; }
			.noteBlock { margin: 0;padding: 0;width:100%;height:100%;position:absolute;z-index:1000;top:0;left:0;}
			#memo-btn{text-align:right; height:40px; }
			/* #font-btn{text-align:right; height: 23px; } */
			#slider-range{width:70px;float:left; margin-left:15px;}
			.ui-widget-header{background: #0470e4}
			.ui-slider-handle{background: #eeeeee; margin-top:2px}
			#detailMemoContents{padding-left:10px; padding-right:10px; width:100%; height:354px; margin-left:-3px; overflow-y:scroll; font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif; }
			.detailMemo{border: 1px solid black; width: 400px; height: 400px; margin: 0 auto; overflow:hidden; z-index:9001; position: absolute; }
			.memo-text{margin-top:10px; padding-left:11px; padding-right: 25px; border:0px; width:100%; height:84%; resize:none; overflow-y:scroll; padding-bottom:5px; font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif;}
			.memo-color{ padding:0px; /* margin-left:1px; margin-right:1px;  */box-sizing:border-box; width: 202px; height: 36px; position:absolute; top:0px; left:0px; visibility:hidden;}
			.memo-color-list {display:inline-block; width:16.5%; height:100%; text-align:center; float:left;}
			.ui-resizable-se {background-image: url("");}
			.write-date {font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif; }
			#btn-bundle {text-align: right; margin:8px; height: 16px;}
			.mCSB_inside > .mCSB_container{margin-right: 10px;}
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
	    	
	    	
			topHeight = "56";

		 	window.onresize = function () {
		        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
		        document.getElementById("mainFrame").style.height = MainHeight + "px";
		        chagePosition();
		 	}
		 	
		 	$(window).resize(function() {
		        setLayerSizeOnResize();
		 		
		 	});
		 	
		    window.onload = function() {
		    	$("#open-memo").css("display", "");
		    	
		    }
		
		    function chagePosition() {
		    	
		    	var winHeight = window.innerHeight;
				var winWidth = window.innerWidth;
				var memoBtn = $("#open-memo");
				
				memoBtn.css({"top" : winHeight - 80, "left" : winWidth - 100});
		    }
		    
		    function setLayerSizeOnResize() {
		    	
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

	        	
	        	if (height > windowHeight) {
	        		
	        		height = windowHeight - 30;
	        		$("#layer-popup").css("height", height + "px");
	        		$(".memoListBox").css("height", height - 35 + "px");
	        		$("#memoList").css("height", height - 35 + "px");
	        	}
	        	
	        	if (width > windowWidth) {
	        		width = windowWidth - 30;
	        		$("#layer-popup").css("width", width + "px");
	        		$(".memoListBox").css("width", width + "px");
	        		$("#memoList").css("width", width + "px");
	        	}
	        	
	        	
        		var leftZero;
        		
	        	if (windowWidth > width) {
	        		leftZero = windowWidth - width;
	        	}
	        	
	        	var bottomZero;
	        	
	        	if (windowHeight > height) {
	        		bottomZero = windowHeight - height;
	        	}
	        	
        		if (top > windowHeight) {
        			$("#layer-popup").css("top", bottomZero - 10);
        			
        		} else if (top < windowHeight) {
        			if (top + height > windowHeight) {
        				$("#layer-popup").css("top", bottomZero - 10);
        			}
        		}
        		
	        	if (left > windowWidth) {
	        		$("#layer-popup").css("left", leftZero - 10);
	        		
	        	} else if (left < windowWidth) {
	        		if (left + width > windowWidth) {
		        		$("#layer-popup").css("left", leftZero - 10);
		        		
	        		 }
	        	}
	        	
	        	setLayerPosition();
	    		setLayerArea();
		    }
		    
		    $(function() {
		    	chagePosition();
		    	defaultPointer();
		    	setPanelPointer();
		    	layerPopupOpacity();
		    	setDetailMemoPosition();
		    	checkDefaultFolder();
		    	memoFoldersInfo();
		    	
		     
		    	// 스크롤바 디자인 변경
		    	$(".memoListBox").mCustomScrollbar({
		    		theme : "dark",
		    		scrollType : "stepped",
		    		/* scrollInertia : 1000 */
		    		
		    	});
		    	
		        $("#close-button").click(function() {
		        	$("#layer-popup").css("display", "none")
		        	$("#open-memo" ).css("display", "");
		        });
		        
		        // 메모 정렬
		        $("#memoList").sortable({
		        	
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
		        					
			        				getMemoList();
		        				}
		        			}
		        		 });
		        		 
		        	 }
		        	
		        });
		        // 폰트 사이즈 높이기
		        $("#font-up").click(function() {
		        	
		        	var textarea = $("#font-up").parent().parent().find("textarea");
		        	var thisFont = textarea.css("font-size");
		        	var fontNum = parseInt(thisFont.substr(0, 2));
		        	 
		        	switch(fontNum) {
			        	case 12 : 
			        		textarea.css("font-size", "13px");
			        		break;
	
			        	case 13 : 
			        		textarea.css("font-size", "14px");
			        		break;
		        		
		        		case 14 : 
			        		textarea.css("font-size", "15px");
			        		break;
			        		
		        		case 15 : 
			        		textarea.css("font-size", "16px");
			        		break;
			        		
		        		case 16 : 
			        		textarea.css("font-size", "17px");
			        		break;
			        		
		        		case 17 : 
			        		textarea.css("font-size", "18px");
			        		break;
			        		
		        		case 18 : 
			        		textarea.css("font-size", "19px");
			        		break;
			        	
		        		case 19 : 
			        		textarea.css("font-size", "20px");
			        		break;
			        		
		        	}
		        	
		        });
		     // 폰트 사이즈 줄이기
		        $("#font-down").click(function() {
		        	
		        	var textarea = $("#font-down").parent().parent().find("textarea");
		        	var thisFont = textarea.css("font-size");
		        	var fontNum = parseInt(thisFont.substr(0, 2));
		        	
		        	switch(fontNum) {
		        		case 20 : 
			        		textarea.css("font-size", "19px");
			        		break;
		        		
		        		case 19 : 
			        		textarea.css("font-size", "18px");
			        		break;
			        		
		        		case 18 : 
			        		textarea.css("font-size", "17px");
			        		break;
			        		
		        		case 17 : 
			        		textarea.css("font-size", "16px");
			        		break;
			        		
		        		case 16 : 
			        		textarea.css("font-size", "15px");
			        		break;
		        		
		        		case 15 : 
			        		textarea.css("font-size", "14px");
			        		break;
			        		
		        		case 14 : 
			        		textarea.css("font-size", "13px");
			        		break;
			        		
		        		case 13 : 
			        		textarea.css("font-size", "12px");
			        		break;
	        		}
		        	
		        });
		        // 메모 레이어 리사이즈
		        $(".layerControl").resizable({
		        	
		        	handles : "n, e, s, w, ne, se, sw, nw",
		        	containment:".noteBlock",
		        	resize : function() {
		        		setMemoListSize();
		        	},
		        	stop : function () {
		        		
		        		setLayerArea();
		        	}
		        });
		        
		        
		        // 메모 디테일 리사이즈
		        $(".detailMemo").resizable({
		        	
		        	handles : "n, e, s, w, ne, se, sw, nw",
		        	containment:".noteBlock",
		        	minWidth: 310,
		        	minHeight: 310,
		        	ghost : true,
		        	stop : function() {
		        	
			    	var detailMemoHeight = $(".detailMemo").height();
			        var memoBtnHeight = $("#memo-btn").height();
			        
			        var fontBtnHeight = $("#font-btn").height();
			        
			        var textareaHeight = detailMemoHeight - (memoBtnHeight + fontBtnHeight + 5);
			        $("#detailMemoContents").css("height", parseInt(textareaHeight) +"px");
			        
				    }
		        });
		        
		        $(".layerControl").resize(function(e) {
		        	
		        	var layerHeight = $(this).height();
		        	var btnBundle = $("#btn-bundle").height();
		        	
		        	var memoListHeight = $("#memoList").css("height", layerHeight-btnBundle-10);
		        	
		        });
		        
		        
		        $("#memoMove").click(function() {

		        	var OpenWin = window.open("/ezMemo/memoFolderManage.do", "", GetOpenWindowfeature(500, 500));
		            try { OpenWin.focus(); } catch (e) { }
		        });
		        // 메모 레이어 전체화면, 사이즈 조절
		        $("#changeMode").click(function() {
		        	
		        	var layerClass = $("#layer-popup").attr("class");
		        	
		        	if (layerClass.indexOf("layerControl") != -1) {
		        		$("#layer-popup").removeClass().addClass("layerFullScreen");
		        		$(".ui-resizable-handle").css("display", "none");
		        		
		        	} else if (layerClass.indexOf("layerFullScreen") != -1) {
		        		$("#layer-popup").removeClass().addClass("layerControl ui-draggable ui-draggable-handle ui-resizable");
		        		$(".ui-resizable-handle").css("display", "");
		        		
		        	}
		        	
		        	setLayerSize();
		        	
		        });
		        
		        getMemoConfig();
		        // 새 메모 추가 
		        $("#newMemo").click(function() {
		        	newMemo();
		        });
				
		        getMemoList();
		        
		        // 메모 숨김 상태 변경 
		        $("#memoList").on("click", ".individual-memo img", function() {
		        	var memoId = $(this).attr("id").replace("memoId", "");
		        	
		        	$.ajax({
		        		type: "POST",
		        		data : {
		        			memo_ids : memoId,
		        			display : 1
		        		},
		        		dataType: "JSON",
		        		url : "/ezMemo/memo-display.do",
		        		success : function(result) {
		        			
		        			if (result.result == "ok") {
		        				getMemoList();
		        			}
		        		}
		        	});
		        });
		        
		        $("#memoList").on("blur", ".individual-memo textarea", function() {
		        	modifyMemo(this);
		        });
		        
		        $("#btn-bundle").on("change", "select[name=memoFolderList]", function() {
		        	getMemoList();
		        });
		        
		        $("#detailClose").click(function() {
		        	$(".detailMemo").css("display", "none");
		        });
		        
		        $("#detailMemoContents").blur(function() {
					modifyMemo(this);
		        });
		    });
		    
		 	// 메모 내용 변경	    
		    function modifyMemo(obj) {

		 		var memoId, beforeContents, afterContents;
		 		
		 		if (obj.getAttribute("memoid") != null) {
		 			
					memoId = obj.getAttribute("memoid");
					beforeContents = obj.innerHTML;
					afterContents = $(".memo-text[memoid=" + memoId + "]").val();
					
		 		} else {
		 			
		 			memoId = obj.getAttribute("textareaMemoid");
					beforeContents = obj.innerHTML;
					afterContents = $("textarea[textareamemoid=" + memoId + "]").val();
		 		}
				
				if(beforeContents != afterContents) {
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
		                	
		                	getMemoList();
		                },
		                error : function() {
		                	
		                }
					}); 
				}
		    }
		 	
		    // 모드 변경 시 레이어 넓이 변경
		    function setLayerSize() {
		    	var layerClass = $("#layer-popup").attr("class");
		    	
	    		var winWidth = window.innerWidth;
	    		var winHeight = window.innerHeight;
	    		
		    	if (layerClass.indexOf("layerFullScreen") != -1) {
		    		
		    		$(".layerFullScreen").css({"width" : winWidth, "height" : winHeight-56, "top" : 56, "left" : 0});
		    		$(".memoListBox").css({"width" : winWidth, "height" : winHeight-56-40});
		    		$("#memoList").css({"width" : winWidth, "height" : winHeight-56-40});

		    	} else if (layerClass.indexOf("layerControl") != -1) {
		    		getMemoConfig();
		    		setMemoListSize();
		    	}
		    }
		    
		    // 메모 컨피그 DB 확인 후 없으면 insert
		    function getMemoConfig() {
	        	
		        $.ajax({
		        	type : "GET",
		        	dataType : "JSON",
		        	async : false,
		        	url : "/ezMemo/getMemoConfig.do",
		        	success : function(result) {
		        		
		        		if (result.memoConfigVO != null) {
		        		
		        			fontSize = result.memoConfigVO.font_size;
							useDate = result.memoConfigVO.use_date;
							defaultColor = result.memoConfigVO.default_color;
		        			$("#layer-popup").css({"top": result.memoConfigVO.layer_top, "left": result.memoConfigVO.layer_left, "width": result.memoConfigVO.layer_width, "height": result.memoConfigVO.layer_height});
		        		
		        		} else {
		        			
		        			$.ajax({
		        				type : "POST",
		        				dataType : "JSON",
		        				url : "/ezMemo/insertMemoConfig.do",
		        				success : function(result) {
		        					console.log("insert 성공");
		        				}
		        			});
		        		}
		        	}
		        });
	        }
		    // 메모 디테일 default값 세팅
		    function setDetailMemoPosition () {
		    	
		    	var winWidth = $(window).width();
		    	var winHeight = $(window).height();
		    	
		    	var detalMemWidth = $(".detailMemo").width();
		    	var detalMemHeight = $(".detailMemo").height();
		    	
		    	var top = winHeight/2 - detalMemHeight/2;  
		    	var left = winWidth/2 - detalMemWidth/2;
		    	
		    	$(".detailMemo").css({"top" : top, "left" : left });
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
		     
		        $('.layerControl, .detailMemo').on("mouseup", function() {
		        	$(".noteBlock").css("pointer-events", "none");
		        	$("#open-memo").css("pointer-events", "auto");
		        	$("#layer-popup, .detailMemo").css("pointer-events", "auto");
		        }).on("mousedown", function() {
		        	$(".noteBlock").css("pointer-events", "auto");
		       	}).draggable({
		       		containment:".noteBlock",
		       		stop : function() {
		       			$(".noteBlock").css("pointer-events", "none");
			        	$("#open-memo").css("pointer-events", "auto");
			        	$("#layer-popup, .detailMemo").css("pointer-events", "auto");
			        	
			        	setLayerPosition();
		       		}
		       	});
			}
			
		    // 레이어 위치값 변경
		    function setLayerPosition() {
		    	
	        	var layerTop = $("#layer-popup").css("top");
        		var layerLeft = $("#layer-popup").css("left");
	        	layerRight = $("#layer-popup").css("right");
	        	layerBottom = $("#layer-popup").css("bottom");
	        	
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
		    
		    // 레이어 넓이값 변경
		    function setLayerArea() {
	        	var layerWidth = $(".layerControl").width();
        		var layerHeight = $(".layerControl").height();
        		
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
		    /**
		     * layer-popup(노트판)의 투명도 조절
		     */
		    function layerPopupOpacity(){
		    	$("#slider-range").slider({
		            step: 1,
		            range: "max",
		            min: 0,
		            max: 5,
		            value: 5,
		            slide: function( event, ui ) {
		            	var opacityValue = ui.value;
		            
		             	switch(opacityValue) {
				        	case 0:
				        		opacityValue = 0;
				            	break;
				            case 1:
				            	opacityValue = 0.2;
				            	break;
				            case 2:
				            	opacityValue = 0.4;
				            	break;
				            case 3:
				            	opacityValue = 0.6;
				            	break;
				            case 4:
				            	opacityValue = 0.8;
				            	break;
				            case 5:
				            	opacityValue = 1;
				            	break;
				          }
		             	$("#layer-popup").css("background-color", "rgba(231,231,231," + opacityValue + ")");
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
		    	var layerFlag = $("#layerFlag").val();
		    	
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
	                	var memoId = result["memoId"];
	                	
	                	getMemoList("new");
	                	parent.parent.getMemoList();
	                },
	                error : function() {
	                	
	                }
				});
			}
			
		    function addremove() {
			    $(".individual-memo").mouseenter(function(){
			    	$(this).children("img").css("visibility", "visible");
			    	$(this).children("img").click(function(){
			    		$(this).prevAll("div").css("visibility", "visible");
			    		$(this).prevAll("div").children().each(function(index, element){
			    			$(element).css("background-color", memoColor[index]);
			    		});
			    	});
		        });
			    
		        $(".individual-memo").mouseleave(function(){
		        	$(this).children("img").css("visibility", "hidden");
		        });
		        
		        $(".memo-color-list").click(function(){
		        	modifyMemoColor($(this).parent().parent(), $(this).index()+1);
		        })
		        
		        $(".memo-text").dblclick(function() {
		        	
		        	var memoId = $(this).attr("memoid");
		        	
		        	$.ajax({
		        		type : "GET",
		        		data : {
		        			memoId : memoId
		        		},
		        		dataType : "JSON",
		        		url : "/ezMemo/memoDetail.do",
		        		success : function(result) {

		        			var $textarea = $("#detailMemoContents");
		        			var $memoDetail = $(".detailMemo");
		        			
		                	var memoColor = result.memoList.split(";");
		                	
		                	var memoColorId = result.memo.color_id;
		                	var detailHeaderColor = memoColor[memoColorId-1];
		                	var detailBodyColor = memoColor[memoColorId+5]; 
		        			
		        			$textarea.val(result.memo.contents);
		        			$textarea.css("background-color", detailBodyColor);
		        			$textarea.attr("textareaMemoid", result.memo.memo_id);
		        			
		        			$memoDetail.css("background-color", detailHeaderColor);
		        			$memoDetail.css("display", "");
		        		}
		        	});
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
	                	defaultColor = idx;
	                	getMemoList();
	                	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
	                },
	                error : function() {
	                	
	                }
				}); 
		    }
		    // 메모 리스트 출력
		    function getMemoList(type) {
		    	
		    	var folderId = $("select option:selected").val();
		    	var layerFlag = $("#layerFlag").val();
				
				$.ajax ({
	 			   	url : '/ezMemo/getMemoList.do',
	 			   	type : 'POST',
	                dataType : 'json',
	                data : { 
	                	folderId : folderId,
	                	layerFlag : layerFlag
	                },
	                cache: false,
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
		    	
		    	var btnBundlHeight = $("#btn-bundle").height();
			    var layerHeight = $("#layer-popup").height();
			    var layerWidth = $("#layer-popup").width();
			    var memoListHeight = layerHeight - btnBundlHeight - 20;
			    
			    $(".memoListBox").css({"height" : memoListHeight, "width" : layerWidth});
			    $("#memoList").css({"width" : layerWidth, "height" : memoListHeight});
			    
		    }
		    // 메모함 리스트 출력
		    function memoFoldersInfo() {
		    	selFolderId="";
				selFolderName="";
		    	$.ajax({
					type : "GET",
					dataType : "json",
					//async : false,
					url : "/ezMemo/getMemoFoldersInfo.do",
					success: function(result){
						
						var folderList = result["folders"];
						var html="";
						html += "<option value='0'>전체</option>";
						folderList.forEach(function(list, index){
							html += "<option value='"+list.folder_id+"'>"+list.folder_name +"</option>"
						});
						$('#memoFolderList option').remove();
						$('#memoFolderList').html(html);
					}     			
				});
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
			<div id="layer-popup" style="display: none" class="layerControl">

				<!-- 메모 리스트 -->
				<div style="text-align: center">
					
					<div id="btn-bundle">
						<div id="slider-range"></div>
						
						<select id="memoFolderList" name="memoFolderList"></select>
						<button id="changeMode">모</button>
						<button id="newMemo">추</button>
						<button id="close-button">닫</button>
					</div>
										
					<div class="memoListBox" style="overflow:hidden;">
						<!-- <div id="memoList" style="height: 50%; overflow-y:scroll;  position:relative; margin-right:-25px;"></div> -->
						<!-- <div id="memoList" style="height:100%; overflow-y:scroll;  position:relative; margin-right:-25px;"></div> -->
						<div id="memoList" style="height:100%; position:relative;"></div>
					</div>
					
				</div>
			</div>
			
			<!-- 하나 클릭 -->
			<div class="selected-memoWrapper">
				<div class="detailMemo" style="display: none">
					<input type="hidden" id="layerFlag" value="layer" />
					<div id="memo-btn">
						<button id="font-up">폰트+</button> 
					    <button id="font-down">폰트-</button>
						<div id="detailClose" style="display:inline-block"><img src='/images/close_xBtn.png' style='float:right; height:20px; padding-right:5px; cursor:pointer; margin-top: 10px;'></div> 
					</div>
					<textarea id="detailMemoContents" style="resize:none;"></textarea>
	        	</div>
			
			<div id="open-memo" style="display: none;"><img src="/images/cmtFile.png" width="60px"></div>
		</div>
		
	</body>
	<script type="text/javascript">
    	var Main_DialogArguments = new Array();
    	var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
    	/* var MainHeight = document.documentElement.clientHeight - parseInt("${topHeight}"); */
    	document.getElementById("mainFrame").style.height = MainHeight + "px";
	</script>
</html>