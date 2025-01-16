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
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<link rel="stylesheet" href="${util.addVer('/css/ezMemo/memo.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memo.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memoBoard.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezMemo.e1', 'msg')}"></script>
		<!-- data picker-->
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
	<script type="text/javascript">
		var memoList;
		var folderId =  "<c:out value='${folderId}' />";
		var topHeight = "100";
		var useDate;
		var fontSize;
		var memoColor;
		var defaultColor;
		var listType = 0;		// 정렬 보기 방식 선택
		var moveFlag = 0;		// 전체 메모일때 이동 보여주고, 아닐때 안보여줌
		var folders;
    	var searchInput;
		var startDate;
		var endDate;
		var dayArray = ["<spring:message code='main.t00052'/>", "<spring:message code='main.t00053'/>", "<spring:message code='main.t00054'/>", "<spring:message code='main.t00055'/>", "<spring:message code='main.t00056'/>", "<spring:message code='main.t00057'/>", "<spring:message code='main.t00058'/>"];
		var checkOpt="off";
		var configView = "<c:out value='${configView}' />";
		
		var beforeMemoId;
		var beforeMemo;
    	var memoInter;
		var memoClickTimer = 0;
     	var memoDelay = 200;
     	var memoPrevent = false;
     	
		window.onunload = Window_onunload;
		
	 	window.onresize = function () {
	 		/* 메모리스트 size 변경 */
	        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
	        document.getElementById("bodyFrame").style.height = MainHeight + "px";
	        
	        /* 검색 레이어 팝업 위치 변경 */
	        var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
			$("#srarchpopup").css("left", popupX);		
			
			MailOptionHidden();
	 	}
	 	
	 	window.onbeforeunload = function() {
			
		};
	 	
		window.onload = function() {
			var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
	        document.getElementById("bodyFrame").style.height = MainHeight + "px";

			getMemoSortable();
			getMemoConfig();
			getFolderList();
			
			if(folderId != null && folderId != ""){
				$("#memoType").val(folderId);
			}
			
			getMemoList();
			bodyClearSelection();
			
			$($(window.parent.frames['left'].document)).mouseup(function (e) {
	    		MailOptionHiddenOutside(e);
	    	});
	    	
	    	$(parent.document).mouseup(function (e) {
	    		MailOptionHiddenOutside(e);
	    	});
	    	
	    	$(document).mouseup(function (e) {
	    		MailOptionHiddenOutside(e);
	    	});
	    	
	    	// 클리과 더블클릭 이벤트 구분
	     	
	     	$(document).on('focus', '.memoText', function(event) {		// 클릭 -> 메모 자동 저장 시작
   				var thisEl = event.target;
	     	
   				parent.parent.draggableFalse();		// draggable 때문에 레이어 안에서의 blur 이벤트 안 먹혀서 잠시 죽임
	     											// (memoPortal.js에 있는 함수)
	     		memoClickTimer = setTimeout(function() {
	     			
	     			if (!memoPrevent) {
	     				memoFocusEvent(thisEl);
	    	     		// autoSaveStart(thisEl);
	     			}
	     		}, memoDelay);
	     	}).on('dblclick', '.memoText', function (event, ui) {	// 더블 클릭 -> 큰 메모 열기
	     		var memoId = $(this).attr("memoid");
	     		
	     		clearTimeout(memoClickTimer);
	     		
	     		getMemoDetail(memoId);
	     	});
	     	
	     	// 메모 자동 저장 정지
	     	$(document).on('blur', '.memoText', function() {
	     		autoSaveStop();					// 자동 저장 멈춤
	     		parent.parent.draggableTrue();	// 메모 레이어 드래그 살림 (memoPortal.js에 있는 함수)
	     		modifyMemo($(this)[0]);			// 메모 내용 수정
	     	});
	     	
	    	/* 위의 자동 저장 기능 추가하면서 주석처리
	    	$(document).on("click", ".saveBtn", function(){
			    	  var obj = $(this).parent().next();
			    	  modifyMemo(obj[0]);
			});
	    	*/
	    	
	    	// 메모 숨김 기능
	    	$(document).on('click', '.hidden', function() {
	    		var thisEl = $(this)[0];
	    		hideMemo(thisEl);
	    	});
	    	
	    	$(document).on("click", ".color_list", function(){
	    		var thisEl = $(this);
	    		defaultColor = thisEl.index()+1;

	    		var obj = $(this).parent().parent();
	    	   	modifyMemoColor(obj, defaultColor);
	    	});
	    	
	    	$(document).on("mouseleave", ".color_popup", function(){
	           	$(this).css("visibility", "hidden");
	       	});
	    	
	    	$(document).on("mouseenter", ".pallete", function(){
	    		$(this).parent().nextAll(".color_popup").css("visibility", "");
	    	});
	    	
	    	$(document).on("mouseleave", ".pallete", function(e){
	    		e = e || event;
	    		var goingto = e.relatedTarget || e.toElement;
	    		if (!goingto || goingto.className != "color_popup") {
	    			$(this).parent().nextAll(".color_popup").css("visibility", "hidden"); 
	    		}
	    	});
	    	
	    	if(configView == 'true'){
	    		newMemo();
	    	}

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
				buttonImage : "/images/ImgIcon/calendar-month.png",
				buttonImageOnly : true
			});
			
			$("#Edatepicker").datepicker({
				changeMonth : true,
				changeYear : true,
				autoSize : true,
				showOn : "both",
				buttonImage : "/images/ImgIcon/calendar-month.png",
				buttonImageOnly : true
			});

			$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			$("#Sdatepicker").datepicker('setDate', "");

			$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			$("#Edatepicker").datepicker('setDate', "");
			
			$.datepicker.regional[memoMessages.strLangMemo23] = {
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
		        $.datepicker.setDefaults($.datepicker.regional[memoMessages.strLangMemo23]);
		});
		
		var inputNameDlg_cross_dialogArguments = new Array();
		
	</script>
	<body class="mainbody" style="overflow: hidden;" marginwidth="0" marginheight="0">
		<h1><c:out value="${folderName }"></c:out><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
		  <ul>
		        <li class="important"><span onclick="newMemo()"><spring:message code='ezMemo.t0014'/></span></li>
		        <li><span onClick="allClick()"><spring:message code='ezMemo.t0013'/></span></li>
		        <li><span onClick="memoMove()"><spring:message code='ezMemo.t0022'/></span></li>
		        <li><span onClick="memoDisplayChange()"><spring:message code='ezMemo.t0017'/></span></li>
		        <li><span onClick="memoDisplayChange2()"><spring:message code='ezMemo.t0024'/></span></li>
		        <li onClick="doLayerPopup(this);"><span class="icon16 icon16_search switchIcon"></span><span class="iconTexts"><spring:message code='ezMemo.t0016'/></span></li>
		        <li onClick="DeleteItem_onclick()"><span class="icon16 icon16_delete switchIcon"></span><span class="iconTexts"><spring:message code='ezMemo.t0015'/></span></li>
		        <li onClick="refresh_onclick()"><span class="icon16 icon16_refresh switchIcon"></span><span class="iconTexts"><spring:message code='ezMemo.t0018'/></span></li>
		        <div class="sub_frameIcon" style="float:right">
					<div class="sub_frameIconUL02">
					  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="maillistoptiondiv" onclick="MailOptionView(this);"></span></p>  
					</div>
				 </div>
				 <li style="display: none; float:right;height:27px;"><select id="memoType" style="width:175px; height:27px !important; line-height: 25px !important;" onchange="getMemoList('folder')"></select></li>
		  </ul>
		</div>
		<div style="width:100%; border-bottom: 1px solid #e8e8e8;"></div>
		<div id="bodyFrame" style="width:100%; height:100%; overflow-y:auto;">
 		 	<table class="mainlist" style="width:100%;">
 		 		<div id="boardMemoList">
		 		</div>
 		 	</table>
 		 </div>
<!--  		<div style="width:100%; border-top: 1px solid #e8e8e8;"></div> -->
 	<div class="jquery-modal blocker current" id="layer_popup" style="display: none;">
 		 <div id="srarchpopup" class="popupwrap1 modal" style="margin-bottom: 70px; left: 297.5px; display: inline-block;">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezMemo.t0067' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="BoardSearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content">
					<tr>
						<th style="text-align: center">
							<spring:message code='ezMemo.t0068' />
						</th>
						<td>
							<input type="text" onfocus="this.value=''" onkeypress="if(event.keyCode==13){getMemoList('search'); return false;}" id="searchTitle" style="width: 100%;  margin-left: 0px;">
						</td>
					</tr>
					<tr>
						<th style="text-align: center">
							<spring:message code='ezMemo.t0069' />
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
								<a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezMemo.t0070' /></span></a>
								<a class="imgbtn"><span onClick="getMemoList('search');"><spring:message code='ezMemo.t0016' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>	
		</div>
	</div>
	
	<div id="layer_Viewpopup" style="width: 200px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
		<div class="popupwrap1">
			<div class="popupwrap2">
				<table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
					<caption></caption>
					<colgroup>
						<col style="width: 80px;">
						<col>
					</colgroup>
					<tr>
						<th><spring:message code='ezEmail.t99000035' /></th>
						<td>
							<select id="orderOption" style="WIDTH: 80px; height: 20px;" onchange="getMemoList();">
								<option value="1"><spring:message code='ezMemo.t0019'/></option>
                       		    <option value="2"><spring:message code='ezMemo.t0020'/></option>
                           		<option value="3"><spring:message code='ezMemo.t0021'/></option>
							</select>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="shadow"></div>
	</div>
	
	</body>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
</html>