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
			.individual-memo { width:200px; height:200px; background-color:#0470e4; text-align:left; border:1px solid black; float: left; margin: 10px 25px 10px 25px; overflow:hidden; padding-top:5px; position:relative; }
			#layer-popup{float:right; background:white; position:absolute; text-align:center; border:1px solid black; z-index: 1001; background-color: rgba(231,231,231,1);overflow:hidden; height: 50%;min-height: 270px; min-width: 270px; }
			.noteBlock { margin: 0;padding: 0;width:100%;height:100%;position:absolute;z-index:1000;top:0;left:0;}
			#memo-btn{text-align:right; height:40px; }
			#font-btn{text-align:right; height: 23px; }
			#slider-range{width:100px;float:left; margin-left:15px;}
			.ui-widget-header{background: #0470e4}
			.ui-slider-handle{background: #eeeeee; margin-top:2px}
			#textarea{padding-left:10px; padding-right:10px; width:100%; height:332px; margin-left:-3px; overflow-y:scroll; font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif; }
			.detailMemo{border: 1px solid black; width: 400px; height: 400px; margin: 0 auto; overflow:hidden; z-index:9001; position: absolute; }
			.memo-text{margin-top:10px; padding-left:11px; padding-right: 25px; border:0px; width:100%; height:81%; resize:none; overflow-y:scroll; padding-bottom:5px; font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif;}
			.memo-color{ padding:0px; /* margin-left:1px; margin-right:1px;  */box-sizing:border-box; width: 202px; height: 36px; position:absolute; top:0px; left:0px; visibility:hidden;}
			.memo-color-list { display:inline-block; width:16.5%; height:100%; text-align:center; float:left;}
			.ui-resizable-se { background-image: url("");}
			.write-date { font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif; }
    	</style>
		<script type="text/javascript">
			var topHeight = "${topHeight}";
			var topUrl = "${topUrl}";
			var mainUrl = "${mainUrl}";
			var memoIndex = -1;
			var memoBColor = [
					"rgb(52, 152, 219)", "rgb(243, 202, 38)", "rgb(230, 126, 34)", "rgb(39, 174, 96)", "rgb(155, 89, 182)", "rgb(149, 165, 166)"
			];
			var memoColor = [
			  "rgb(159, 212, 246)", "rgb(244, 232, 182)",  "rgb(246, 201, 159)", "rgb(165, 241, 197)", "rgb(233, 193, 250)", "rgb(255, 255, 255)"              
			];
			var headerColor;
	    	var textColor;
	    	var currText;
			
			
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
				
				memoBtn.css({"top" : winHeight - 80, "left" : winWidth - 100});
		    }
		    
		    function setSizeOfLayer() {
		    	var winHeight = window.innerHeight;
	        	var layerWidth =$("#layer-popup").css("width");
	        		        
	        	$(".memoListBox").css("width", layerWidth);

		    }
		    
		    $(function() {
		    	chagePosition();
		    	setSizeOfLayer();
		    	defaultPointer();
		    	setPanelPointer();
		    	layerPopupOpacity();
		    	setDetailMemoPosition();
		     
		        $("#close-button").click(function() {
		        	$("#layer-popup").css("display", "none")
		        	$("#open-memo" ).css("display", "");
		        })
		        
		        $("#memoList").sortable({
		        	 containment: '.memoListBox'
		        });
		        
		        $("#font-up").click(function() {
		        	
		        	var textarea = $("#font-up").parent().parent().find("textarea");
		        	var thisFont = textarea.css("font-size");
		        	var fontNum = parseInt(thisFont.substr(0, 2));
		        	 
		        	switch(fontNum) {
			        	case 10 : 
			        		textarea.css("font-size", "15px");
			        		break;
	
			        	case 15 : 
			        		textarea.css("font-size", "20px");
			        		break;
		        		
		        		case 20 : 
			        		textarea.css("font-size", "25px");
			        		break;
			        		
		        		case 25 : 
			        		textarea.css("font-size", "30px");
			        		break;
		        	}
		        	
		        });
		        
		        $("#font-down").click(function() {
		        	var textarea = $("#font-down").parent().parent().find("textarea");
		        	var thisFont = textarea.css("font-size");
		        	var fontNum = parseInt(thisFont.substr(0, 2));
		        	
		        	switch(fontNum) {
		        		case 30 : 
			        		textarea.css("font-size", "25px");
			        		break;
		        		
		        		case 25 : 
			        		textarea.css("font-size", "20px");
			        		break;
			        		
		        		case 20 : 
			        		textarea.css("font-size", "15px");
			        		break;
			        		
		        		case 15 : 
			        		textarea.css("font-size", "10px");
			        		break;
	        		}
		        	
		        });

		        
		        $("#layer-popup").resizable({
		        	handles : "n, e, s, w, ne, se, sw, nw",
		        	containment:".noteBlock",
		        	stop : function () {
		        		
		        		var layerWidth = $("#layer-popup").width();
		        		var layerHeight = $("#layer-popup").height();
		        		
		        		$.ajax({
		        			type:"POST",
		        			data : {
		        				"layerWidth" : layerWidth,
		        				"layerHeight" : layerHeight
		        			},
		        			dataType: "JSON",
		        			url :  "/ezMemo/setLayerArea.do", 
		        			success : function (result) {
		        				console.log(result);
		        			},
		        			error : function() {
		        				console.log("에러");
		        			}
		        		});
		        	}
		        });
		        
		        $(".detailMemo").resizable({
		        	handles : "n, e, s, w, ne, se, sw, nw",
		        	containment:".noteBlock",
		        	minWidth: 270,
		        	minHeight: 270,
		        	ghost : true,
		        	stop : function() {
		        	
			    	var detailMemoHeight = $(".detailMemo").height();
			        var memoBtnHeight = $("#memo-btn").height();
			        
			        var fontBtnHeight = $("#font-btn").height();
			        
			        var textareaHeight = detailMemoHeight - (memoBtnHeight + fontBtnHeight + 5);
			        $("#textarea").css("height", parseInt(textareaHeight) +"px");
				    }
		        });
		        
		        $("#layer-popup").resize(function(e) {
		        	
		        	var layerHeight = $(this).height();
		        	var btnBundle = $("#btn-bundle").height();
		        	
		        	var memoListHeight = $("#memoList").css("height", layerHeight-btnBundle-10);
		        	
		        });
		        
		        $.ajax({
		        	type : "GET",
		        	dataType : "JSON",
		        	url : "/ezMemo/getMemoConfig.do",
		        	success : function(result) {
						
		        		if (result.memoConfigVO != null) {

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
		        
		     });

		    
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
		     
		        $('#layer-popup, .detailMemo').on("mouseup", function() {
		        	$(".noteBlock").css("pointer-events", "none");
		        	$("#open-memo").css("pointer-events", "auto");
		        	$("#layer-popup, .detailMemo").css("pointer-events", "auto");
		        }).on("mousedown", function() {
		        	$(".noteBlock").css("pointer-events", "auto");
		       	}).draggable({
		       		containment:".noteBlock",
	        		stop:function(){
	        			$(".noteBlock").css("pointer-events", "none");
			        	$("#open-memo").css("pointer-events", "auto");
			        	$("#layer-popup, .detailMemo").css("pointer-events", "auto");
			        	
			        	var layerTop = $("#layer-popup").css("top");
		        		var layerLeft = $("#layer-popup").css("left");
			        	
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
			        	})
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
		    

		    
		    function save() {
		    	if(headerColor == null) {			// 지정색 없을 때
		    		headerColor = memoBColor[0];
			    	textColor = memoColor[0];
		    	}
		    	
		    	var text = $("#textarea").val();
		    	var html = "";
		    	html += "<div class='individual-memo' style='background-color:"+ headerColor +"'>";
		    	html += "<div class='memo-color'>";
		    	html += "<div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div></div>";
		    	html += "<span class='write-date' style='padding-left: 10px'></span>";
		    	html += "<img src='/images/close_xBtn.png' style='visibility:hidden; float:right; height:20px; padding-right:5px; cursor:pointer'>";
		    	html += "<img src='/images/ezMemo/more.png' style='visibility:hidden; float:right; height:20px; padding-right:10px; cursor:pointer'>";
		    	html += "<textarea class='memo-text' style='background-color:"+ textColor +"'>";
		    	html += text;
		    	html += "</textarea>";
		    	html += "</div>"
		    	$("#memoList").prepend(html);
		    	$("#textarea").val('');
		    	
		    	addDate();
		    	addremove();
		    }
		    
		    function addDate() {
		    	var nowDate = new Date();
		    	var month = nowDate.getMonth() + 1;
		    	var date = nowDate.getDate();
		    	var day = nowDate.getDay();
		    	var arrayDay = ["(일)", "(월)", "(화)", "(수)", "(목)", "(금)", "(토)"];
		    	
		    	if(month < 10) {
		    		month = "0"+month;
		    	}
		    	if(date < 10) {
		    		date = "0"+date;
		    	}
		    	$(".write-date:first").html(month+"-"+date+" "+arrayDay[day]);
		    }
		    
		    function addremove() {
			    $(".individual-memo").mouseenter(function(){
			    	$(this).children("img").css("visibility", "visible");
			    	$(this).children("img:first").click(function(){
			    		$(this).parent().remove();
			    	})
			    	$(this).children("img:last").click(function(){
			    		$(this).prevAll("div").css("visibility", "visible");
			    		$(this).prevAll("div").children().each(function(index, element){
			    			$(element).css("background-color", memoBColor[index]);
			    		})
			    	})
		        });
		        
		        $(".individual-memo").mouseleave(function(){
		        	$(this).children("img").css("visibility", "hidden");
		        });
		        
		        $(".individual-memo").dblclick(function(){
		        	memoIndex = $(this).index()+1;
		        	currText = $(this).children(".memo-text").val();
		        	var headerColor = $(this).css("background-color");
			    	var textColor = $(this).children("textarea").css("background-color");
			    	
		        	/* $("#maskDiv").css("display", ""); */
			        $(".detailMemo").css("display", "");
					$("#textarea").css("font-size", "15px");
					$("#textarea").css("background-color", textColor);
					$("#textarea").css("border-color", textColor);
					$(".detailMemo").css("background-color", headerColor);
			        $("#font-btn").css("background-color", textColor);
			        $("#font-btn").css("display", "");
			        $("#textarea").val(currText);
		        });
		        
		        $(".memo-color-list").click(function(){
		        	headerColor = $(this).css("background-color");
		        	textColor = memoColor[$(this).index()];
		        	$(this).parent().parent().css("background-color", headerColor);
		        	$(this).parent().nextAll("textarea").css("background-color", textColor);
		        	$(this).parent().css("visibility", "hidden");
		        })
		        
		        $(".memo-color").mouseleave(function(){
		        	if($(this).css("visibility") == "visible") {
		        		$(this).css("visibility", "hidden");
		        	}
		        });
		    }
		    
		    function detailMemoSave() {
		    	$(".individual-memo:nth-child("+memoIndex+") > .memo-text").val($("#textarea").val());
		    	$("#textarea").val('');
		    	$(".detailMemo").css("display", "none");
		    	memoIndex = -1;
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
				<!-- <div id="maskDiv" style="display: none"></div> -->

				<!-- 메모 리스트 -->
				<div style="text-align: center">
					
					<div style="text-align: right; margin:8px;" id="btn-bundle">
						<!-- <button id="change-mode" style="float: left">모드</button> -->
						<div id="slider-range"></div>
						
						<select id="memoFolderList">
							<option value="all" selected="selected">전체</option>
							<option >할 일</option>
						</select>
						<button id="memoMove">이동</button>
						<button id="new-memo" onclick="save()">추가</button>
						<button id="close-button">닫기</button>
					</div>
										
					<div class="memoListBox" style="overflow:hidden;">
						<div id="memoList" style="height: 50%; overflow-y:scroll;  position:relative; margin-right:-25px;"></div>
					</div>
					
				</div>
			</div>
			
			<!-- 하나 클릭 -->
			<!-- <div id="selected-memo" style="display: none; ">
				<div class="selected-memoWrapper"> -->
					<div class="detailMemo" style="display: none">
						<div id="memo-btn">
							<div id="save" onclick="detailMemoSave()" style="display:inline-block"><img src='/images/close_xBtn.png' style='float:right; height:20px; padding-right:5px; cursor:pointer; margin-top: 10px;'></div> 
						</div>
			        	<div id="font-btn" style="text-align: left; display: none ">
							<button id="font-up">폰트+</button> 
						    <button id="font-down">폰트-</button>
				        </div>
						<textarea id="textarea" style="resize:none;"></textarea>
		        	</div>
				<!-- </div>
			</div> -->
			
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