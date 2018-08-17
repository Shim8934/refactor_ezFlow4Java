<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<title>memo</title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezMemo.c1', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
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
		}
	</style>
	<script type="text/javascript">
		var headerColor = "rgb(52, 152, 219)";
		var bodyColor = "rgb(159, 212, 246)";
		var topHeight = "100";

	 	window.onresize = function () {
	        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
	        document.getElementById("bodyFrame").style.height = MainHeight + "px";
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
	    	html += "<span class='write-date' style='padding-left: 10px'></span>";
	    	html += "<img src='/images/close_xBtn.png' style='visibility:hidden; float:right; height:20px; padding-right:5px; cursor:pointer'>";
	    	html += "<img src='/images/ezMemo/more.png' style='visibility:hidden; float:right; height:20px; padding-right:10px; cursor:pointer'>";
	    	html += "<textarea class='memo-text' style='background-color:"+ bodyColor +"'>";
	    	html += "</textarea>";
	    	html += "</div>"
	    	$("#memoList").prepend(html);
	    	$("#textarea").val('');
		}
	</script>
	<body class="mainbody" style="overflow: hidden;" marginwidth="0" marginheight="0">
		<h1><spring:message code='ezMemo.t001'/><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
		  <ul>
		        <li><span onClick="allClick()"><spring:message code='ezMemo.t0013'/></span></li>
		        <li><span onclick="newMemo()"><spring:message code='ezMemo.t0014'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0015'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0016'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0022'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0017'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0018'/></span></li> 
		        <li>
		        	<select id="memoType" style="height: 20px;" onchange="">
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
	 		 		<!-- <div class="individual-memo" style="background-color:rgb(52, 152, 219)">
	 		 			<input type="checkbox" name="memo" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
		 		 		<span class="write-date">2018-08-16 (목)</span>
		 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
		 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
		 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
		 		 	</div>
		 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
	 		 			<input type="checkbox" name="memo"  style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
		 		 		<span class="write-date">2018-08-16 (목)</span>
		 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
		 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
		 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
		 		 	</div>
		 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
	 		 			<input type="checkbox" name="memo" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
		 		 		<span class="write-date">2018-08-16 (목)</span>
		 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
		 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
		 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
		 		 	</div>
		 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
	 		 			<input type="checkbox" name="memo" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
		 		 		<span class="write-date">2018-08-16 (목)</span>
		 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
		 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
		 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
		 		 	</div>
		 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
	 		 			<input type="checkbox" name="memo" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
		 		 		<span class="write-date">2018-08-16 (목)</span>
		 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
		 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
		 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
		 		 	</div>
		 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
	 		 			<input type="checkbox" name="memo" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
		 		 		<span class="write-date">2018-08-16 (목)</span>
		 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
		 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
		 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
		 		 	</div> -->
		 		 </div>
 		 	</table>
 		 </div>
	</body>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
</html>