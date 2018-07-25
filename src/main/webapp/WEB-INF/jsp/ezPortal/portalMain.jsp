<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
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

			#open-memo { width:50px; height:50px; position: absolute; z-index: 1000; border: solid 1px black;cursor: pointer; background-color: gray; text-align: center;}
			#layer-popup{float:right; background:white; position:absolute; text-align:center; border:1px solid black; z-index: 1001; background-color: gray;}
			.individual-memo { width:200px; height:200px; background:white; text-align:center; border:1px solid black; cursor: pointer;}
			#selected-memo { position:absolute;z-index:9001; top:48px; left:36px; display:table;}
			.noteBlock { margin: 0;padding: 0;width:100%;height:100%;position:absolute;z-index:1000;top:0;left:0;}
			#maskDiv { position:absolute; background:white; z-index:9001; top:0px; left:0px; opacity:0.4; z-index:9000; background:rgb(59, 60, 60);}
			.selected-memoWrapper {display:table-cell;vertical-align:middle;}
			#memo-btn{text-align:right;margin:0 auto;}
    	</style>
		<script type="text/javascript">
			var topHeight = "${topHeight}";
			var topUrl = "${topUrl}";
			var mainUrl = "${mainUrl}";
			
			topHeight = "56";

		 	window.onresize = function () {
		        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
		        document.getElementById("mainFrame").style.height = MainHeight + "px";
		        chagePosition();
		 	}
		 	
		    function Div_Close() {
		        document.getElementById("popup_layer").style.display = "none";
		    }

		    window.onload = function() {
		    	$("#open-memo").css("display", "");
		    }
		    
	    	var winHeight = window.innerHeight;
			var winWidth = window.innerWidth;
		
		    function chagePosition() {
		    	
				var memoBtn = $("#open-memo");
				var opendMemo = $("#selected-memo");
				
				memoBtn.css({"top" : winHeight - 80, "left" : winWidth - 100});
				//opendMemo.css({"top": 50, "left": 50});
				
				changSizeOfLayer();
		    }
		    
		    function changSizeOfLayer() {
				var layerHalf = $(".layer-half");
				var layerWhole = $(".layer-whole");
		    	var maskDiv = $("#maskDiv");
				var className = $("#layer-popup").attr("class");
	        	var opendMemo = $("#selected-memo");
	        	
	        	layerWhole.css({"top":65, "left": winWidth/2, "right" : 10, "width" : winWidth/2 - 20, "height":winHeight - 56 - 30});
	        	layerHalf.css({"top":65, "left": 10, "right" : 20, "width" : winWidth - 30, "height":winHeight - 56 - 30});

				if (className.indexOf("layer-half") != -1) {
	        		$("#layer-popup").removeClass().addClass("layer-whole");
	        		maskDiv.css({"top":0, "left": 0, "width" : winWidth - 30, "height":winHeight - 56 - 30});
	        		opendMemo.css({"top":20, "left": 20, "width" : winWidth - 90, "height":winHeight - 56 - 90})
	        	} else if (className.indexOf("layer-whole") != -1) {
	        		$("#layer-popup").removeClass().addClass("layer-half");
	        		maskDiv.css({"top":0, "left":0, "width" : winWidth/2 - 20, "height":winHeight - 56 - 30});
	        		opendMemo.css({"top":10, "left":10, "width" : winWidth/2 - 50, "height":winHeight - 56 - 50})
	        	}
		    }
		    
		    $(function() {
			    
		    	chagePosition();
		    	
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
/////////////////////////////////
		        $("#change-mode").click(function() {
		        	
		        	changSizeOfLayer();
		        });
		        
		        $("#memoList").sortable();
		     });
//////////////////////////////
		    function newMemo() {
		        $("#maskDiv").css("display", "");
		        $("#selected-memo").css("display", "");
		        var textareaW = $(textarea).css("width");
		        
		        $("#memo-btn").css("width", textareaW);
		    }
		    
		    function save() {
		    	var text = $("#textarea").val();
		    	alert('저장 되었습니다.');
		    	$("#memoList").append("<div class='individual-memo' style='float: left; margin: 10px'>" + text + "</div>");
		    	$("#memoList > div").attr("onclick", "read('" + text + "')");
		    	$("#textarea").val('');
		    	$("#maskDiv").css("display", "none");
		    	$("#selected-memo").css("display", "none");
		    }
		    
		    function read(text) {
		        $("#maskDiv").css("display", "");
		        $("#selected-memo").css("display", "");
		        $("#textarea").val(text);
		    }
		    
		    function closeMemo() {
		    	$("#textarea").val('');
		    	$("#maskDiv").css("display", "none");
		    	$("#selected-memo").css("display", "none");
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
						<button id="change-mode">모드</button>
						<button id="new-memo" onclick="newMemo()">추가</button>
						<button id="close-button">닫기</button>
					</div>
					
					<div>메모 레이어 팝업</div>
					
					<div id="memoList" style="height: 100%; overflow:auto; margin: 10px">
					</div>
					
				</div>
				
				<!-- 하나 클릭 -->
				<div id="selected-memo" style="display: none">
					<div class="selected-memoWrapper">
						<div id="memo-btn">
							<button onclick="save()">저장</button> 
							<button onclick="closeMemo()">닫기</button>
						</div>
						<textarea id="textarea" cols="50" rows="28"></textarea>
					</div>
				</div>
			</div>
			
			<div id="open-memo" style="display: none;">메모</div>
		</div>
		
	</body>
	<script type="text/javascript">
    	var Main_DialogArguments = new Array();
    	var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
    	/* var MainHeight = document.documentElement.clientHeight - parseInt("${topHeight}"); */
    	document.getElementById("mainFrame").style.height = MainHeight + "px";
	</script>
</html>