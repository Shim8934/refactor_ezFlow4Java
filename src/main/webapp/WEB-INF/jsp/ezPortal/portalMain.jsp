<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
		<link href="<spring:message code='main.e6' />" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="/js/jquery/jquery-ui.css">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
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
			.individual-memo { width:200px; height:200px; background:url('/images/ezMemo/background.gif') repeat-x; background-size:200px 190px;text-align:center; border:1px solid black; cursor: pointer; float: left; margin: 3px 3px 3px 38px;}
			#layer-popup{float:right; background:white; position:absolute; text-align:center; border:1px solid black; z-index: 1001; background-color: rgba(231,231,231,1);}
			#selected-memo { position:absolute;z-index:9001; top:48px; left:36px; display:table;}
			.noteBlock { margin: 0;padding: 0;width:100%;height:100%;position:absolute;z-index:1000;top:0;left:0;}
			#maskDiv { position:absolute; background:white; z-index:9001; top:0px; left:0px; opacity:0.4; z-index:9000; background:rgb(59, 60, 60);}
			.selected-memoWrapper {display:table-cell;vertical-align:middle;}
			#memo-btn{text-align:right;margin:0 auto;}
			#font-btn{text-align:right;margin:0 auto; width:367px;}
			#slider-range{width:100px;float:left; margin-left:15px;}
			.ui-widget-header{background: #0470e4}
			.ui-slider-handle{background: #eeeeee; margin-top:2px}
    	</style>
		<script type="text/javascript">
			var topHeight = "${topHeight}";
			var topUrl = "${topUrl}";
			var mainUrl = "${mainUrl}";
			var memoIndex = -1;
			
			topHeight = "56";

		 	window.onresize = function () {
		        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
		        document.getElementById("mainFrame").style.height = MainHeight + "px";
		        chagePosition();
		        setSizeOfLayer();
		 	}
		 	
		    function Div_Close() {
		        document.getElementById("popup_layer").style.display = "none";
		    }

		    window.onload = function() {
		    	$("#open-memo").css("display", "");
		    }
		    
		
		    function chagePosition() {
		    	
		    	var winHeight = window.innerHeight;
				var winWidth = window.innerWidth;
				var memoBtn = $("#open-memo");
				var opendMemo = $("#selected-memo");
				
				memoBtn.css({"top" : winHeight - 80, "left" : winWidth - 100});
				//opendMemo.css({"top": 50, "left": 50});
		    }
		    
		    function changSizeOfLayer() {
		    	var winHeight = window.innerHeight;
				var winWidth = window.innerWidth;
		    	
				var layerHalf = $(".layer-half");
				var layerWhole = $(".layer-whole");
		    	var maskDiv = $("#maskDiv");
				var className = $("#layer-popup").attr("class");
	        	var opendMemo = $("#selected-memo");
	        	
	        	layerWhole.css({"top":65, "left": winWidth/2, "right" : 10, "width" : winWidth/2 - 20, "height":winHeight - 56 - 30});
	        	layerHalf.css({"top":65, "left": 10, "right" : 20, "width" : winWidth - 30, "height":winHeight - 56 - 30});

				if (className.indexOf("layer-half") != -1) {
	        		$("#layer-popup").removeClass().addClass("layer-whole");
	        	} else if (className.indexOf("layer-whole") != -1) {
	        		$("#layer-popup").removeClass().addClass("layer-half");
	        	}
				setSizeOfLayer();
				$(".memoListBox").css("height",winHeight - 56 - 60);
		    }
		    
		    function setSizeOfLayer() {
		    	var winHeight = window.innerHeight;
				var winWidth = window.innerWidth;
		    	
				var layerHalf = $(".layer-half");
				var layerWhole = $(".layer-whole");
		    	var maskDiv = $("#maskDiv");
				var className = $("#layer-popup").attr("class");
	        	var opendMemo = $("#selected-memo");

				if (className.indexOf("layer-half") != -1) {
	        		layerHalf.css({"top":65, "left": winWidth/2, "right" : 10, "width" : winWidth/2 - 20, "height":winHeight - 56 - 30});
	        		maskDiv.css({"top":0, "left":0, "width" : winWidth/2 - 20, "height":winHeight - 56 - 30});
	        		opendMemo.css({"top":10, "left":10, "width" : winWidth/2 - 50, "height":winHeight - 56 - 50})
	        	} else if (className.indexOf("layer-whole") != -1) {
	        		layerWhole.css({"top":65, "left": 10, "right" : 20, "width" : winWidth - 30, "height":winHeight - 56 - 30});
	        		maskDiv.css({"top":0, "left": 0, "width" : winWidth - 30, "height":winHeight - 56 - 30});
	        		opendMemo.css({"top":20, "left": 20, "width" : winWidth - 90, "height":winHeight - 56 - 90})
	        	}
				$(".memoListBox").css("height",winHeight - 56 - 60);
		    }
		    
		    $(function() {
		    	$(".noteBlock").css("pointer-events", "none");
	        	$("#open-memo").css("pointer-events", "auto");
		    	chagePosition();
		    	setSizeOfLayer();
		    	
		    	$( "#open-memo" ).draggable().on("mouseup", function() {
		        	$(".noteBlock").css("pointer-events", "none");
		        	$("#open-memo").css("pointer-events", "auto");
		        	$("#layer-popup").css("pointer-events", "auto");
		        }).on("mousedown", function() {
		        	$(".noteBlock").css("pointer-events", "auto");
		       	}).on("click", function(event){
		       		event.preventDefault();
		       		if ("none" == ($("#layer-popup").css("display"))) {
						$("#layer-popup").css("display", "");
		        	} else {
						$("#layer-popup").css("display", "none");
		        	}
		       	});
		     
		        $('#layer-popup').on("mouseup", function() {
		        	$(".noteBlock").css("pointer-events", "none");
		        	$("#open-memo").css("pointer-events", "auto");
		        	$("#layer-popup").css("pointer-events", "auto");
		        }).on("mousedown", function() {
		        	$(".noteBlock").css("pointer-events", "auto");
		       	}).draggable();
				
		     
		        $("#close-button").click(function() {
		        	$("#layer-popup").css("display", "none")
		        })
		        
		        $("#maskDiv").click(function() {
		        	$("#maskDiv").css("display", "none");
		        	$("#selected-memo").css("display", "none");
		        });

		        $("#change-mode").click(function() {
		        	
		        	changSizeOfLayer();
		        });
		        
		        $("#memoList").sortable({
		        	 containment: '.memoListBox'
		        });
		        
		        layerPopupOpacity();
		        
		        $("#font-up").click(function() {
		        	
		        	var textarea = $("#font-up").parent().parent().find("textarea");
		        	var thisWidth = textarea.css("width");
		        	var thisHeight = textarea.css("height");
		        	var thisFont = textarea.css("font-size");
		        	var fontNum = parseInt(thisFont.substr(0, 2));
		        	 
					if (fontNum == 15) {
		        		
			        	textarea.css("font-size", "20px");
		        	} else if (fontNum == 10) {
		        		
			        	textarea.css("font-size", "15px");
		        	}
		        	
					console.log(thisWidth);
		        	textarea.css("width", thisWidth);
		        	
		        	textarea.css("height", thisHeight);
		        });
		        
		        $("#font-down").click(function() {
		        	var textarea = $("#font-down").parent().parent().find("textarea");
		        	var thisWidth = textarea.css("width");
		        	var thisHeight = textarea.css("height");
		        	var thisFont = textarea.css("font-size");
		        	var fontNum = parseInt(thisFont.substr(0, 2));
		        	
		        	if (fontNum == 20) {
		        		
			        	textarea.css("font-size", "15px");
		        	} else if (fontNum == 15) {
		        		
			        	textarea.css("font-size", "10px");
		        	}
		        	textarea.css("width", thisWidth);
		        	textarea.css("height", thisHeight);
		        });

		     });
			
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
		    function newMemo() {
		        $("#maskDiv").css("display", "");
		        $("#selected-memo").css("display", "");
		        var textareaW = $(textarea).css("width");
		        
		        $("#memo-btn").css("width", textareaW);
		    }
		    
		    function save() {
		    	if(memoIndex != -1) {		// 수정일때
		    		$(".individual-memo").eq(memoIndex).remove();
		    	}
		    	
		    	var text = $("#textarea").val();
		    	$("#memoList").prepend("<div class='individual-memo'><img src='/images/close_xBtn.png'  style='visibility:hidden; float:right;'><textarea class='memo-text' style='margin-top:5px; padding-left:10px; padding-right:10px; border:0px; width:90%; height:87%; resize:none; overflow-y:auto;'>" + text + "</textarea></div>");
		    	$("#textarea").val('');
		    	$("#maskDiv").css("display", "none");
		    	$("#selected-memo").css("display", "none");
		    	
		    	memoIndex = -1;
		    	
		    	addremove();
		    }
		    
		    function closeMemo() {
		    	$("#textarea").val('');
		    	$("#maskDiv").css("display", "none");
		    	$("#selected-memo").css("display", "none");
		    	
		    	memoIndex = -1;
		    }
		    
		    function addremove() {
			    $(".individual-memo").mouseenter(function(){
			    	$(this).children("img").css("visibility", "visible");
			    	$(this).children("img").click(function(){
			    		$(this).parent().remove();
			    	})
		        });
		        
		        $(".individual-memo").mouseleave(function(){
		        	$(this).children("img").css("visibility", "hidden");
		        });
		        
		        $(".individual-memo").dblclick(function(){
		        	memoIndex = $(this).index();
		        	var currText = $(this).children(".memo-text").val();
		        	$("#maskDiv").css("display", "");
			        $("#selected-memo").css("display", "");
			        $("#textarea").css("font-size", "15px");
			        $("#font-btn").css("display", "");
			        $("#textarea").val(currText);
			        
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
			<div id="layer-popup" style="display: none" class="layer-half">
				<div id="maskDiv" style="display: none"></div>

				<!-- 메모 리스트 -->
				<div style="text-align: center">
					
					<div style="text-align: right">
						<div id="slider-range"></div>
						<button id="change-mode">모드</button>
						<button id="new-memo" onclick="newMemo()">추가</button>
						<button id="close-button">닫기</button>
					</div>
										
					<div class="memoListBox" style="overflow:hidden;">
						<div id="memoList" style="height: 100%; overflow-y:scroll;  position:relative; margin-right:-25px;"></div>
					</div>
					
				</div>
				
				<!-- 하나 클릭 -->
				<div id="selected-memo" style="display: none">
					<div class="selected-memoWrapper">
						<div id="memo-btn">
							<button id="save" onclick="save()">저장</button> 
							<button onclick="closeMemo()">닫기</button>
						</div>
						<textarea id="textarea" cols="50" rows="28"></textarea>
						<div id="font-btn" style="text-align: right; display: none">
					        <button id="font-up">폰트+</button> 
					        <button id="font-down">폰트-</button>
			        	</div>
					</div>
				</div>
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