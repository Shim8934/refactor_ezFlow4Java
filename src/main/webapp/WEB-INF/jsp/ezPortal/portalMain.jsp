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
			#open-memo { width:50px; height:50px; position: absolute; top: 676px; left: 1371px; z-index: 1000; border: solid 1px black;cursor: pointer; background-color: gray; text-align: center;}
			#layer-popup{ float:right; width:500px; height:600px; background:white; position:absolute; text-align:center; border:1px solid black;z-index:1001;}
			.individual-memo { width:200px; height:200px; background:white; text-align:center; border:1px solid black; cursor: pointer;}
			#selected-memo { position:absolute; width:400px; height:500px; background:white; z-index:9001; top:48px; left:36px;}
			.noteBlock { margin: 0;padding: 0;width:100%;height:100%;position:absolute;z-index:1000;top:0;left:0;}
			#maskDiv { position:absolute; width:500px; height:600px; background:white; z-index:9001; top:0px; left:0px; opacity:0.4; z-index:9000; background:rgb(59, 60, 60);}

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

		    function chagePosition() {
		    	var winHeight = window.innerHeight;
				var winWidth = window.innerWidth;
		    	
		    	$("#layer-popup").css("top", winHeight - 700);
		    	$("#layer-popup").css("left", winWidth - 600);
		    	
		    	$("#selected-memo").css("top", 50);
		    	$("#selected-memo").css("left", 50);
		    }

		    window.onload = function() {
		    	$("#open-memo").css("display", "");
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
		        
		        $("#memo-1").click(function() {
		        	$("#maskDiv").css("display", "");
		        	$("#selected-memo").css("display", "");
		        });
		        $("#maskDiv").click(function() {
		        	$("#maskDiv").css("display", "none");
		        	$("#selected-memo").css("display", "none");
		        });

		     });
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
			<div id="layer-popup" style="display: none">
				<div id="maskDiv" style="display: none"></div>
				<div>
					<button id="close-button" style="float:right" >닫기 X</button>
					<div>메모 레이어 팝업</div>
					
					<!-- 메모 리스트 -->
					<table id="memo-1" class="individual-memo" style="cursor: pointer;">
						<tbody><tr><td>내용</td></tr></tbody>
					</table>
					<table id="memo-2" class="individual-memo">
						<tbody><tr><td>내용</td></tr></tbody>
					</table>
				</div>

			<!-- 하나 클릭 -->
				<div id="selected-memo" style="display: none">
					<div id="memo-btn" style="text-align: right">
						<button>저장</button> <button>휴지통</button>
					</div>
					<div>
						<p>내용</p>
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