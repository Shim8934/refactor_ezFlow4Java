<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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
			 #open-memo {
			 	width:50px;
			 	height:50px;
			    position: absolute;
			    /* top: 600px;
			    left: 650px; */
			    z-index: 1000;
			    border: solid 1px black;
			    cursor: pointer;
			}
			#layer-popup{
				float:right;
				width:500px; height:600px; background:gray;
  				position:absolute; /* top:60px; left:940px; */ text-align:center; 
  				border:1px solid black;
			}
    	</style>
		<script type="text/javascript">
			var topHeight = "${topHeight}";
			var topUrl = "${topUrl}";
			var mainUrl = "${mainUrl}";
			
			topHeight = "56";

		 	window.onresize = function () {
		        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
		        document.getElementById("mainFrame").style.height = MainHeight + "px";
		    }
		 	
		    function Div_Close() {
		        document.getElementById("popup_layer").style.display = "none";
		    }

		    function chagePosition() {
		    	var winHeight = window.innerHeight;
				var winWidth = window.innerWidth;
		    	$( "#open-memo" ).css("top", winHeight - 100);
		    	$( "#open-memo" ).css("left", winWidth - 100);
		    	
		    	$("#layer-popup").css("top", winHeight - 700);
		    	$("#layer-popup").css("left", winWidth - 600);
		    }


		    $(window).resize(function () {
		    	chagePosition();
		    });
		    
		    $(function() {
			    
		    	chagePosition();
				
		        $( "#open-memo" ).click(function() {
					$("#layer-popup").css("display", "");
		        });
		        
		        $("#close-button").click(function() {
		        	$("#layer-popup").css("display", "none")
		        })
		        
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
		<div id="layer-popup" >
			<div>
				<span>
					<button id="close-button" style="float: right">닫기 X</button>
				</span>
			</div>
			<div>메모 레이어 팝업</div>
		</div>
		<!-- test -->
		<div>
			<button id="open-memo">메모 버튼</button>
		</div>
	</body>
	<script type="text/javascript">
    	var Main_DialogArguments = new Array();
    	var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
    	/* var MainHeight = document.documentElement.clientHeight - parseInt("${topHeight}"); */
    	document.getElementById("mainFrame").style.height = MainHeight + "px";
	</script>
</html>