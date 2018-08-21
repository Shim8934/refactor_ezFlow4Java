<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezMemo.c1', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	</head>
	
	<style>
		h1 {
			font-size:13px;margin:0px 0px 10px 0px;height:24px; line-height:15px; padding:0px; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;
		}
		.individual-memo { 
			width:200px; height:200px; 
			background-color:#0470e4; 
			text-align:left; float: left; 
			margin: 10px 25px 10px 25px; overflow:hidden; 
			padding-top:5px; position:relative; 
			border:1px solid black; 
		}
		.memo-text {
			margin-top:10px; padding-left:11px; padding-right: 25px; padding-bottom:5px; 
			border:0px; width:100%; height:81%; resize:none; 
			overflow-y:scroll; font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif;
		}
		.write-date {
			font-size:14px; 
			font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif;
			vertical-align: middle;
		}
		input { 
			width: 13px; height: 13px; margin-left: 10px;
			vertical-align: middle;
		}
		.memo-color { 
			padding:0px; box-sizing:border-box; width: 202px; height: 36px; position:absolute; top:0px; left:0px; visibility:hidden;
		}
		.memo-color-list { 
			display:inline-block; width:16.5%; height:100%; text-align:center; float:left;
		}
			
	</style>
	<script type="text/javascript">
		var memoList = ${memoList};
		var headerColor = "rgb(52, 152, 219)";
		var bodyColor = "rgb(159, 212, 246)";
		var topHeight = "100";
		var memoBColor = [
			"rgb(52, 152, 219)", "rgb(243, 202, 38)", "rgb(230, 126, 34)", "rgb(39, 174, 96)", "rgb(155, 89, 182)", "rgb(149, 165, 166)"
		];
		var memoColor = [
			"rgb(159, 212, 246)", "rgb(244, 232, 182)",  "rgb(246, 201, 159)", "rgb(165, 241, 197)", "rgb(233, 193, 250)", "rgb(255, 255, 255)"              
		];
		var listType = 0;		// 정렬 보기 방식 선택
		var moveFlag = 0;		// 전체 메모일때 이동 보여주고, 아닐때 안보여줌

	 	window.onresize = function () {
	 		/* 메모리스트 size 변경 */
	        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
	        document.getElementById("bodyFrame").style.height = MainHeight + "px";
	        
	        /* 검색 레이어 팝업 위치 변경 */
	        var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
			$("#srarchpopup").css("left", popupX);		
	 	}
	 	
		window.onload = function() {
			var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
	        document.getElementById("bodyFrame").style.height = MainHeight + "px";
	        
			$(".individual-memo").mouseenter(function(){
		    	$(this).children("img").css("visibility", "visible");
		    	$(this).children("img:first").click(function(){
		    		$(this).parent().remove();
		    	})
		    });
			
			$(".individual-memo").mouseleave(function(){
	        	$(this).children("img").css("visibility", "hidden");
	        });

			/* $("#memoList").draggable({
	        	 containment: "#bodyFrame",
	        	 stop:function(){
	        			defaultPointer();		
	        	}
	        }); */
			
			for(var i=0; i<memoList.length; i++) {
				var html = "";
		    	html += "<div class='individual-memo' style='background-color:"+ memoBColor[memoList[i].color_id-1] +"'>";
		    	html += "<input type='checkbox' name='memo'>";
		    	html += "<div class='memo-color'>";
		    	html += "<div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div></div>";
		    	html += "<span class='write-date'></span>";
		    	/* html += "<img src='/images/close_xBtn.png' style='visibility:hidden; float:right; height:20px; padding-right:5px; cursor:pointer'>"; */
		    	html += "<img src='/images/ezMemo/more.png' style='visibility:hidden; float:right; height:20px; padding-right:10px; cursor:pointer'>";
		    	html += "<textarea class='memo-text' style='background-color:"+ memoColor[memoList[i].color_id-1] +"'>";
		    	html += memoList[i].contents;
		    	html += "</textarea>";
		    	html += "</div>"
		    	$("#memoList").prepend(html);
		    	$("#textarea").val('');
		    	
		    	addDate(memoList[i].write_date.substring(0,10));
		    	
		    	addremove();
			}
			/* // 체크 박스 모두 해제
			$("#uncheckAll").click(function() {
				$("input[name=box]:checkbox").each(function() {
					$(this).attr("checked", false);
				});
			});

			$("#getCheckedAll").click(function() {
				$("input[name=box]:checked").each(function() {
					var test = $(this).val();
				});
			});  */

		}
		
		function allClick() {
			// 체크 박스 모두 체크
			$("input[name=memo]:checkbox").each(function() {
				$(this).attr("checked", true);
			});
		}
		
		function newMemo() {
			var html = "";
	    	html += "<div class='individual-memo' style='background-color:"+ headerColor +"'>";
	    	html += "<input type='checkbox' name='memo'>";
	    	html += "<div class='memo-color'>";
	    	html += "<div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div><div class='memo-color-list'></div></div>";
	    	html += "<span class='write-date'></span>";
	    	/* html += "<img src='/images/close_xBtn.png' style='visibility:hidden; float:right; height:20px; padding-right:5px; cursor:pointer'>"; */
	    	html += "<img src='/images/ezMemo/more.png' style='visibility:hidden; float:right; height:20px; padding-right:10px; cursor:pointer'>";
	    	html += "<textarea class='memo-text' style='background-color:"+ bodyColor +"'>";
	    	html += "</textarea>";
	    	html += "</div>"
	    	$("#memoList").prepend(html);
	    	$("#textarea").val('');
	    	
	    	addDate();
	    	addremove();
		}
		
	    function addDate(date) {
	    	var nowDate 
	    	
	    	if(date == null) {
	    		nowDate = new Date();
	    	}
	    	else {
	    		nowDate = new Date(date);
	    	}
	    	
	    	var year = nowDate.getFullYear();
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

			$(".write-date:first").html(year+"-"+month+"-"+date+" "+arrayDay[day]);
	    	
	    }
	    
	    function addremove() {
		    $(".individual-memo").mouseenter(function(){
		    	$(this).children("img").css("visibility", "visible");
		    	$(this).children("img").click(function(){
		    		$(this).prevAll("div").css("visibility", "visible");
		    		$(this).prevAll("div").children().each(function(index, element){
		    			$(element).css("background-color", memoBColor[index]);
		    		})
		    	})
	        });
		    
		    $(".individual-memo").dblclick(function(){
		    	var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        pheight = parseInt(pheight) / 2;
		        pwidth = parseInt(pwidth) / 2;
		        pheight = pheight - 200;
		        pwidth = pwidth - 127;
		        
		    	window.open("/ezMemo/memoRead.do", "",  "height=500px, width=355px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top="+pheight+", left="+pwidth);
		    });
	        
	        $(".individual-memo").mouseleave(function(){
	        	$(this).children("img").css("visibility", "hidden");
	        });
	        
	        $(".memo-color-list").click(function(){
	        	headerColor = $(this).css("background-color");
	        	bodyColor = memoColor[$(this).index()];
	        	$(this).parent().parent().css("background-color", headerColor);
	        	$(this).parent().nextAll("textarea").css("background-color", bodyColor);
	        	$(this).parent().css("visibility", "hidden");
	        })
	        
	        $(".memo-color").mouseleave(function(){
	        	if($(this).css("visibility") == "visible") {
	        		$(this).css("visibility", "hidden");
	        	}
	        });
	    }
	    
	    // 메모 삭제
	    function DeleteItem_onclick() {
	    	if(confirm("<spring:message code='ezMemo.t0023'/>")) {
		    	var valuesArray = $("input[name=memo]:checked");
	    	}
	    	else {

	    	}
	    }
	    
	  // 상세검색 레이어팝업
		function doLayerPopup() {
			$("<div id='blockLeft' class='blockLeft' style='position:fixed; width:100%;height:100%; overflow:hidden;' onclick='parent.frames[\"right\"].BoardSearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);
	    	parent.frames["left"].document.body.style.overflow = "hidden";
	    	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	    	$("#srarchpopup").css("left", popupX);
	    	$("#srarchpopup").modal();
	  }
	  
		var monthMsg = "<spring:message code='ezBoard.t218' />";
	    var monthStr = monthMsg.split(";");		    
	    var dayMsg = "<spring:message code='ezBoard.t216' />";
	    var dayStr = dayMsg.split(";");
	    
		$(function() {
			$("#Sdatepicker").datepicker({
				changeMonth : true,
				changeYear : true,
				autoSize : true,
				showOn : "both",
				buttonImage : "/images/ImgIcon/calendar-month.gif",
				buttonImageOnly : true
			});
			
			$("#Edatepicker").datepicker({
				changeMonth : true,
				changeYear : true,
				autoSize : true,
				showOn : "both",
				buttonImage : "/images/ImgIcon/calendar-month.gif",
				buttonImageOnly : true
			});

			$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			$("#Sdatepicker").datepicker('setDate', "");

			$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			$("#Edatepicker").datepicker('setDate', "");
			
			$.datepicker.regional["ko"] = {
		        	monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["ko"]);
		});
		
		// 날짜 초기화
		function btn_PostDate_Clear() {
	        $("#Sdatepicker").datepicker('setDate', "");
	        $("#Edatepicker").datepicker('setDate', "");
	    }
	    
		// 새로고침
		function refresh_onclick() {
	        window.location.href = "/ezMemo/memoMain.do";
	    }
		
		function onSelect_Option() {
			alert($("#memoType").val());
		}
	</script>
	<body class="mainbody" style="overflow: hidden;" marginwidth="0" marginheight="0">
		<h1><spring:message code='ezMemo.t001'/><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
		  <ul>
		        <li><span onClick="allClick()"><spring:message code='ezMemo.t0013'/></span></li>
		        <li><span onclick="newMemo()"><spring:message code='ezMemo.t0014'/></span></li>
		        <li><span onClick="DeleteItem_onclick()"><spring:message code='ezMemo.t0015'/></span></li>
		        <li><span onClick="doLayerPopup(this);"><spring:message code='ezMemo.t0016'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0022'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0017'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0024'/></span></li>
		        <li><span onClick="refresh_onclick()"><spring:message code='ezMemo.t0018'/></span></li> 
		        <li>
		        	<select id="memoType" style="height: 20px;" onchange="onSelect_Option(this);">
                           <option value="0"><spring:message code='ezMemo.t0019'/></option>
                           <option value="1"><spring:message code='ezMemo.t0020'/></option>
                           <option value="2"><spring:message code='ezMemo.t0021'/></option>
                    </select>    
		        </li>
		  </ul>
		</div>
		<div style="width:100%; border-bottom: 1px solid #e8e8e8;"></div>
		<div id="bodyFrame" style="width:100%; overflow-y:scroll; padding-right: 27px; ">
 		 	<table class="mainlist" style="width:100%;">
 		 		<div id="memoList">
		 		</div>
 		 	</table>
 		 </div>
 		 
 	<div class="jquery-modal blocker current" id="layer_popup" style="display: none;">
 		 <div id="srarchpopup" class="popupwrap1 modal" style="margin-bottom: 70px; left: 297.5px; display: inline-block;">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezMemo.t001' /><spring:message code='ezMemo.t0016' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="BoardSearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content">
					<tr>
						<th style="text-align: center">
							<spring:message code='ezBoard.garm01' />
						</th>
						<td>
							<input type="text" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){goToPageBySearch(); return false;}" id="searchTitle" style="width: 100%;  margin-left: 0px;">
						</td>
					</tr>
					<tr>
						<th style="text-align: center">
							<spring:message code='ezBoard.t210' />
						</th>
						<td>
							<input type="text" id="Sdatepicker" style="width: 80px; text-align: center; margin-left: 0px;" readonly="readonly">
							~ 
							<input type="text" id="Edatepicker" style="width: 80px; text-align: center; margin-left: 0px;" readonly="readonly">
						</td>
					</tr>
				</table>
				<table style="width: 100%">
					<tr>
						<td style="text-align: center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezBoard.t220' /></span></a>
								<a class="imgbtn"><span onClick="goToPageBySearch()"><spring:message code='ezBoard.t188' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>	
		</div>
	</div>
	</body>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
</html>