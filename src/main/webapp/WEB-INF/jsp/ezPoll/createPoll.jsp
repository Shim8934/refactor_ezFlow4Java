<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Create Poll</title>	
		
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">	
	<link rel="stylesheet" href="${util.addVer('/css/ezPoll/sort.css')}" type="text/css">	
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
	<style>
		#Sdatepicker:disabled {
			background-color:white;
		}
		.qstSettingSpan{width: 130px !important;}

		.attachInnerNotice_p_on {
			text-align: center;
			margin: 10px 0 0 0;
		}

		.attachInnerNotice_p_off {
			display: none;
		}

		.attachInnerNotice_span {
			line-height: 55px;
		}
	</style>
	 
	<script src="${util.addVer('/js/jquery/jquery.min.js')}"></script> 
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPoll/dropzone.js')}"></script>
  	<script src="${util.addVer('/js/jquery-ui/jquery-ui.js')}"></script>
  	<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
	<script type="text/javascript">	
		var messageCode1	  = '<spring:message code="ezPoll.t164"/>';
		var messageCode2	  = '<spring:message code="ezPoll.t165"/>';
		var messageCode3	  = '<spring:message code="ezPoll.t208"/>';
	    var filesize 		  = 0;
	    var file 			  = new Array();
	    var xhr 			  = new XMLHttpRequest();
		var lstAttachLink 	  = document.getElementById("lstAttachLink");
	    var isfileup 		  = false;
	    var mode 			  = "<c:out value='${mode}'/>";
	    var configFlag 		  = "<c:out value='${hasConfig}'/>";
		var L_StartDate 	  = "";
		var L_EndDate 		  = "";
		var L_StartTime 	  = "";
		var L_EndTime 		  = "";
		var g_windowReference = null;
		var qst_ID 			  = "<c:out value='${question.qstId}'/>";
		var flag			  = 0;
		var tempObj			  = "";
		var optImgPrevArr 	  = [];
		var optImgOld		  = [];
		
		window.onunload = function() {
			if (mode == "modify" && flag == 0) {
				//Update the vote modifying status
/* 				var qstID = "<c:out value='${question.qstId}'/>";
				var fd = new FormData();
				fd.append("questionId", qstID);
			    xhr.open("POST", "/ezPoll/undoModifyVote.do");
			    xhr.send(fd); 
			    window.close(); */

				undoEditing();
			}	
			
			optImgPrevDelete();
    	}; 
		window.onload = function() {
 			document.getElementById("lstAttachLink").appendChild(getAttachInnerNoticeObject());
			preProcessing();		
			//setBorder();
			
			$( "#columnsbnk" ).sortable({
				handle: ".drag_drop",
		    	axis: "y",
		    	containment: "#columnsbnk",
		    	tolerance: 'pointer',
		    	update: function() {
					/* for(var i = 0; i < $('#columnsbnk li').length; i++){
						$('#columnsbnk li').eq(i).children("span").text(i + 1);
						//$('#columnsbnk li').eq(i).removeClass("myBorder");
					} */
					
					//항목 드래그 버튼으로 순서 정해주기 위해 수정.
		    		for(var i = 0; i < $('#columnsbnk li').length; i++){
		    		    $('#columnsbnk li').eq(i).children("span").text(i + 1);
		    		    $('#columnsbnk li').eq(i).children("input").get(0).id = 'option'+(i+1);
		    		    $('#columnsbnk li').eq(i).children("input").get(0).name = 'option'+(i+1);
		    		    var optImages = $('#columnsbnk li').eq(i).children("img");
		    		    optImages.get(optImages.length - 1).setAttribute("_optimgid", "option"+(i+1));
		    		}
					//setBorder();
		    	}
				
		    });
			fileUploadStart();
			setAttachSortable();
		}

		window.addEventListener('popstate', function(event) {
			undoEditing();
		});
		
		function preProcessing() {
			var sHourMinute = null;
        	var eHourMinute = null;	  
        	var EDate = null;
        	var SDate = null;
        	var sConfigTime = null;
        	var eConfigTime = null;
			
			if (mode == "modify" || mode == "reuse") {
				//Modify the vote
				//var questionTitle = "<c:out value='${question.title}'/>";
				//document.getElementById("qst_title").value = questionTitle;
				var pathFile = sigBody2.innerHTML;

				if (pathFile != null && pathFile.replace(/ /g,'') != "") {
					var oTable = document.getElementById("filelist");
					
					if (oTable == null) {
						oTable = document.createElement("TABLE");
					    oTable.style.width = "100%";
					    oTable.id = "filelist";
					    oTable.className = "sublist";
					}

				    document.getElementById("lstAttachLink").appendChild(oTable);
					setAttachFileInfo1(pathFile);
				}
				
				var listOfOptions = ${optList};
				var addOptions = listOfOptions.length - 3;
				
				if (addOptions >= 0) {
					for (var i = 0; i < addOptions + 1; i++) {
						addOption();
					}
				}
				
				for (var j = 0; j < listOfOptions.length; j++) {
					var _id = "option" + (j + 1);
					document.getElementById(_id).value =  listOfOptions[j].content;
					if(listOfOptions[j].filePath !== null){
						optImageTagAppend(listOfOptions[j], "", "");
						optImgOld.push(listOfOptions[j].filePath);
					}
				}
				
				/***************************Set other fields**********************************/
				//Allow multi-select
				var _multi_select = "<c:out value='${question.multiSelect}'/>";
				if (_multi_select == 1) {
					$('#multipleCheck').attr('checked', false);
					$('#numberOfMultiSelect').css("display","none");
				}
				else {
					$('#multipleCheck').attr('checked', true);
					$('#numberOfMultiSelect').css("display","inline-block");
					
					if (_multi_select == 0) {
						$("#numberOfMultiSelect select").val("1");
					}
					else {
						$("#numberOfMultiSelect select").val(_multi_select);
					}
				}
				
				//See result before Voting
				seeResultOptSetting();
				
				//Allow secret vote
				var _secretVote = "<c:out value='${question.secretVote}'/>";
				if (_secretVote == 1) {
					$('#anonymousVote ').attr('checked', true);
				}
				
				//Set end date	
				var _setDate = "<c:out value='${question.setDate}'/>";	
				
				//Allow sorting option.
				var _isSorting = "<c:out value='${question.isSorting}'/>";
				if (_isSorting == 1) {
					$('#isSorting ').attr('checked', true);
				}
								
				//Allow selecting option only once.
				var _isSelOnlyOnce = "<c:out value='${question.isSelOnlyOnce}'/>";
				if (_isSelOnlyOnce == 1) {
					$('#isSelOnlyOnce ').attr('checked', true);
				}
				
				//Allow selecting option only once.
				var _openToAll = "<c:out value='${question.openToAll}'/>";
				if (_openToAll == 1) {
					$('#openToAll ').attr('checked', true);
				}
				
				//Hide sending notification mail option.
				if(mode === "modify"){
					$('#sendPostNotiMailDiv').hide();
				}
				
		    	$("#Sdatepicker").datepicker({
		        	changeMonth: true,
		        	changeYear: true,
		        	autoSize: true,
		        	showOn: "both",
		        	buttonImage: "/images/ImgIcon/calendar-month.png",
		        	buttonImageOnly: true,
		            onSelect: function(dateText, inst) {
		            	dateCompare(dateText, SDate);
		            }
		    	});
				
				$("#Edatepicker").datepicker({
			        changeMonth: true,
		    	    changeYear: true,
		        	autoSize: true,
		        	showOn: "both",
		        	buttonImage: "/images/ImgIcon/calendar-month.png",
		        	buttonImageOnly: true
		    	});		
		
				var _startD = "<c:out value='${question.startDate}'/>";
				var _endD = "<c:out value='${question.endDate}'/>";
				
	        	var sYear = _startD.substring(0, 4);
				var sMonth = _startD.substring(5, 7);
				var sDay = _startD.substring(8, 10);
				var sHour = _startD.substring(11, 13);
				var sMin = _startD.substring(14, 16);				
				SDate = new Date(sYear, sMonth-1, sDay);
				
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		        
		        var eYear = _endD.substring(0, 4);
				var eMonth = _endD.substring(5, 7);
				var eDay = _endD.substring(8, 10);
				var eHour = _endD.substring(11, 13);
				var eMin = _endD.substring(14, 16);				
	        	EDate = new Date(eYear, eMonth-1, eDay);
	        	
	        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Edatepicker").datepicker('setDate', EDate);
	        	
	        	sHourMinute = sHour + sMin;
	        	eHourMinute = eHour + eMin;	  
	        	
	        	var selection = "";
	        	var i = 0;
	        	for (var i = 0; i < 24; i++) {
	        	    var j = zeroFill(i, 2);
	        	    selection += "<option value='"+ j +"00'>"+ j + ":00" + "</option>";
	        	    selection += "<option value='"+ j +"30'>"+ j + ":30" + "</option>";
	        	} 
	        	
	        	$("#sTimePicker").html(selection);       		        	
	        	$("#eTimePicker").html(selection);   	
	        	
	        	$("#sTimePicker").val(sHourMinute).change();
	        	$("#eTimePicker").val(eHourMinute).change();
	        	
	        	if (_setDate == "1") {
	        		$('#endDate ').attr('checked', true);
	        		//$('#_dateTimePicker').show();
	        		$('#_dateTimePicker').css('display', 'inline-block');
	        	}
	        	else {
	        		$('#endDate ').attr('checked', false);
	        		$('#_dateTimePicker').hide();
	        	}      		        	
	        	
	        	//Select Target
	        	var _selectedTarget = "<c:out value='${question.target}'/>";

	        	if (_selectedTarget == 0) {
	        		$('#receiverBttn').hide();
	        		$("#set_Target").val("0").change();	        		
	        	}
	        	else {
	        		var targList = "<c:out value='${listOfTarget}'/>";
	        		
	        		if (targList != "") {
	        			document.getElementById("newTargetDiv").innerHTML = targList;
	        			document.getElementById("newTargetDiv").setAttribute("title", targList);
	        	    	document.getElementById("newTargetDiv").style.display = "";	   
	        		}
	        		
	        		$('#receiverBttn').show();
	        		$("#set_Target").val("1").change();		
	        		document.getElementById("RangeXMLStr").value = sigBody3.innerHTML;
	        	}
			}
			else {						
				var listTarget = "<c:out value='${listOfTarget}'/>";
    			if (listTarget != "") {
    				var newTargetDiv = document.getElementById("newTargetDiv");
        	    	newTargetDiv.innerHTML = listTarget;
        	    	newTargetDiv.setAttribute("title", listTarget);
        	    	newTargetDiv.style.display = "";
        	    	
        	    	$("#set_Target").val("1").change();
        	    	$('#receiverBttn').show();
        	    	document.getElementById("RangeXMLStr").value = sigBody3.innerHTML;
    			}
    			else {
    				document.getElementById("RangeXMLStr").value = "<RANGE></RANGE>";
    				$("#set_Target").val("0").change();
    				$('#receiverBttn').hide();
    			}
    			
    			//Set time
    			setDateTimeValue();	
    			sConfigTime = "<c:out value='${configStartTime}'/>";
    			eConfigTime = "<c:out value='${configEndTime}'/>";
    			
    			sConfigTime = sConfigTime.replace(":", "");
    			eConfigTime = eConfigTime.replace(":", "");   
    			
				$('#anonymousVote').removeAttr('checked');	
				$('#endDate').removeAttr('checked');			
				$('#_dateTimePicker').hide();			
				document.getElementById("seeResultFirst").checked = true;
				//$('#isSorting').removeAttr('checked');
				//$('#receiverBttn').hide();										
			}
			
			/* 2018-08-13 홍승비 - 투표모듈 DatePicker 다국어 설정 추가 */
			var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
			 $.datepicker.regional["<spring:message code='main.t0619' />"] = {
	        	closeText: "<spring:message code='main.t3' />",
	            prevText: "<spring:message code='main.t0604' />",
	            nextText: "<spring:message code='main.t0605' />",
				currentText: "<spring:message code='main.t0606' />",
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
	        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
			
			$('#multipleCheck').click(function() {
				if (this.checked) {
					$('#numberOfMultiSelect').css("display","inline-block");
				}
				else {
					$('#numberOfMultiSelect').css("display","none");
				}
			});	
			
			$('#endDate').click(function() {
				if (this.checked) {
					if (mode == "modify") {
						showDateTimePicker2(SDate, EDate, sHourMinute, eHourMinute); 
					}
					else {
						showDateTimePicker(sConfigTime, eConfigTime);
					}					
				}
				else {
					$('#_dateTimePicker').hide();
					var NowDate = new Date(new Date().getTime());
					var NextWeek = new Date(new Date().getTime() + 7 * 24 * 60 * 60 * 1000);
					$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
					$("#Sdatepicker").datepicker('setDate', NowDate); 
					$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
					$("#Edatepicker").datepicker('setDate', NextWeek);
				}
			});
			
			$('#set_Target').on('change', function(e) {					
			    if ($(this).val() == '1') {
			    	var listTarget = "<c:out value='${listOfTarget}'/>";
			    	
		    		if (listTarget != "") {
			    		document.getElementById("RangeXMLStr").value = sigBody3.innerHTML;

	    				var newTargetDiv = document.getElementById("newTargetDiv");
	        	    	newTargetDiv.innerHTML = listTarget;
	        	    	newTargetDiv.setAttribute("title", listTarget);
	        	    	newTargetDiv.style.display = "";
		    		}			    		
			    	
			    	$('#receiverBttn').show();
			    }
			    else {			    	
			    	document.getElementById("newTargetDiv").style.display = "none";	
			    	document.getElementById("RangeXMLStr").value = "<RANGE></RANGE>";
			    	$('#receiverBttn').hide();
			    }
			}); 
			
			//썸네일 이미지에 레이어 팝업 기능 관련
			addThumbnailEvent();
		}
		
		function dateCompare(dateText, SDate) {
			var newDate = new Date();					
			var year = newDate.getFullYear();
			var month = newDate.getMonth() + 1;
			var day = newDate.getDate();					
			var curDate = year + "-" + ("0" + month).slice(-2) + "-" + ("0" + day).slice(-2);
			
			if (curDate > dateText) {				
				alert('<spring:message code="ezPoll.t245"/>');
				
				if (mode == "modify") {
					$("#Sdatepicker").datepicker('setDate', SDate);
				}
				else {
					$("#Sdatepicker").datepicker('setDate', curDate);
				}
			}
			else {
				$("#Sdatepicker").datepicker('setDate', dateText);
			}
		}
		
		function checkOptionsList() {			
    		var totalOptions = $('#columnsbnk li').length;
    		var check_flag = 0;
    		
    		for (var i = 1; i <= totalOptions; i++) {
    			var optionId = "#option" + i;
    			var pLastChild = $(optionId).parent()[0].lastChild;
    			var pLastChildNodeName = pLastChild.nodeName.toLowerCase();
    			var imgFlag = pLastChildNodeName === "img" && pLastChild.hasAttribute("_fileinfo");
    			
    			if ($(optionId).val() == "" && !imgFlag) {
    				check_flag = 1;
    				break;
    			}
    		} 
    		
    		if (check_flag == 0) {
    			addOption();
    		}
		}
		
		//Set bottom boder for all li but the last li
		function setBorder() {
			for (var i = 0; i < $('#columnsbnk li').length - 1; i++) {
				$('#columnsbnk li').eq(i).addClass("myBorder");
			}
		}
		
		function showDateTimePicker2(SDate, EDate, sHourMinute, eHourMinute) {
	        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Sdatepicker").datepicker('setDate', SDate);
        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
        	$("#Edatepicker").datepicker('setDate', EDate);
        	
        	$("#sTimePicker").val(sHourMinute).change();
        	$("#eTimePicker").val(eHourMinute).change();
        	
			//$('#_dateTimePicker').show();
			$('#_dateTimePicker').css('display', 'inline-block');
			$('#Edatepicker').show();
			$('#eTimePicker').show();
			$('#Sdatepicker').show();
			$('#sTimePicker').show();
		}
		
		
		function showDateTimePicker(sConfigTime, eConfigTime) {
			var NowDate = new Date(new Date().getTime());
			var NextWeek = new Date(new Date().getTime() + 7 * 24 * 60 * 60 * 1000);
			
        	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
        	$("#Sdatepicker").datepicker('setDate', NowDate); 
        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
        	$("#Edatepicker").datepicker('setDate', NextWeek);

			if (sConfigTime) {
	        	$("#sTimePicker").val(sConfigTime).change();
	        	$("#eTimePicker").val(eConfigTime).change();
			}
			else {
				$("#sTimePicker").val("0900").change();
	        	$("#eTimePicker").val("1800").change();
				$("#sTimePicker option[value='0900']").attr('selected','selected');
	        	$("#eTimePicker option[value='1800']").attr('selected','selected');
			}
			
			//$('#_dateTimePicker').show();
			$('#_dateTimePicker').css('display', 'inline-block');
			$('#Edatepicker').show();
			$('#eTimePicker').show();
			$('#Sdatepicker').show();
			$('#sTimePicker').show();
		}
		
		/* 2020-01-31 홍승비 - IE에서 SdatePicker로 날짜 선택 시 계속해서 캘린더가 reopen되는 현상 수정 */
		function setDateTimeValue() {
	    	$("#Sdatepicker").datepicker({
	        	changeMonth: true,
	        	changeYear: true,
	        	autoSize: true,
	        	format: 'yyyy-mm-dd',
	        	showOn: "both",
	        	buttonImage: "/images/ImgIcon/calendar-month.png",
	        	buttonImageOnly: true,
	            onSelect: function(dateText, inst) {
	            	dateCompare(dateText);
	            	$(this).datepicker('disable'); // 캘린더에서 날짜 선택 시 datePicker를 disable 시킨다.
	            },
	            onClose: function () { // 캘린더가 닫힐때, datePicker를 enable시키고 잠깐 타임아웃을 건다.
	                window.setTimeout(function (e) {
	                    $(e).datepicker('enable');
	                }.bind(undefined, this), 10);
	            }
	    	});
	    	
			$("#Edatepicker").datepicker({
		        changeMonth: true,
	    	    changeYear: true,
	        	autoSize: true,
	        	format: 'yyyy-mm-dd',
	        	showOn: "both",
	        	buttonImage: "/images/ImgIcon/calendar-month.png",
	        	buttonImageOnly: true
	    	});
			
			var NowDate = new Date(new Date().getTime());
			var NextWeek = new Date(new Date().getTime() + 7 * 24 * 60 * 60 * 1000);
			
        	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
        	$("#Sdatepicker").datepicker('setDate', NowDate); 
        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
        	$("#Edatepicker").datepicker('setDate', NextWeek);			
        	
        	var selection = "";
        	var i = 0;
        	
        	for (var i = 0; i < 24; i++) {
        	    var j = zeroFill(i, 2);
        	    selection += "<option value='"+ j +"00'>"+ j + ":00" + "</option>";
        	    selection += "<option value='"+ j +"30'>"+ j + ":30" + "</option>";
        	} 
        	
        	$("#sTimePicker").html(selection);       	 	
        	$("#eTimePicker").html(selection); 
		}		
		
		function zeroFill( number, width ) {
		  width -= number.toString().length;
		  
		  if ( width > 0 ) {
		    return new Array( width + (/\./.test( number ) ? 2 : 1) ).join( '0' ) + number;
		  }
		  
		  return number + "";
		}

		function addOption() {		
			var currentOptionNumber = $('#columnsbnk li').length + 1;	
			
			/* 항목 추가시 타이틀 체크기능 주석처리 */
			/* if ($('#qst_title').val().replace(/ /g,'') == '') {
				alert('<spring:message code="ezPoll.t147"/>');
	            document.getElementById("qst_title").value = "";	           
	            document.getElementById("qst_title").focus();
			}
			else {
				$('#columnsbnk li').eq(currentOptionNumber - 2).addClass("myBorder");
				$('#columnsbnk').append('<li class="myBorder"> \n <span>' + currentOptionNumber + '</span> \n <input type="text" oninput="checkOptionsList();" value="" placeholder="<spring:message code="ezPoll.t152"/>" id="option' + currentOptionNumber + '" name="option' + currentOptionNumber + '" maxlength="200"> \n <img src="/images/sortIcon.png" class="drag_drop"> \n </li>');
			} */					
			$('#columnsbnk li').eq(currentOptionNumber - 2).addClass("myBorder");
			$('#columnsbnk').append('<li class="myBorder"> \n <span>' + currentOptionNumber + '</span> \n <input type="text" oninput="checkOptionsList();" value="" placeholder="<spring:message code="ezPoll.t152"/>" id="option' + currentOptionNumber + '" name="option' + currentOptionNumber + '" maxlength="200"> \n <img src="/images/sortIcon.png" class="drag_drop"> \n <img src="/images/poll/attach_file_vote.png" onclick="optUploadBtn(this)" style="cursor: pointer;""/> \n </li>');
		}
		
		function menuQst_List() {
    		if (mode == "modify") {
				var params = "<c:out value='${params}'/>";
				var searchStr = "<c:out value='${searchStr}'/>";
				var searchN = "<c:out value='${searchN}'/>";				
				var paramArray = params.split(","); 
				var currentPage = paramArray[0];
				var checkSeeAll = paramArray[1];
				var radioBttn = paramArray[2];
				var mode1 = paramArray[3];
				var pollType = paramArray[4];
    			
    			var szUrl = "/ezPoll/pollList.do?brdID=6" + "&see=" + checkSeeAll + "&currPage=" + currentPage + "&mode=" + radioBttn + "&search=" + searchStr + "&mode1=" + mode1 + "&searchN=" + searchN + "&pollType=" + pollType;
    			if(params == ""){
    				szUrl = "/ezPoll/pollList.do?brdID=6";
    			}
    		} 
    		else {
    			var szUrl = "/ezPoll/pollList.do?brdID=6";
    		}
    		
    		window.location.href = szUrl;	
		}
		
		function menu_SelectRange() {
	         if (CrossYN()) {
	            var item_no = document.getElementById("item_no").value;
	
	            if (CrossYN()) {
	            	var szUrl = "/ezPoll/qstRangeSelect.do?brdID=6&itemNo=" + item_no;
	            }
	            else {
	            	var szUrl = "/ezPoll/qstRangeSelect.do?brdID=6&itemNo=" + item_no;
	            }
	  
	            var _MSIE = 'MSIE';
	            var useragentstr = navigator.userAgent;
	            
	            if (useragentstr.indexOf(_MSIE) != -1) {	            	
	                var szParam = "dialogHeight:708px;dialogWidth:562px;edge:sunken;status:no;resizable:no;help:no;center:yes;scroll:no" + GetShowModalPosition(562, 708);
	                var rv = window.showModalDialog(szUrl, document.getElementById("RangeXMLStr").value, szParam);
	                
	                if (rv[0] == "OK") {
	                    document.getElementById("set_Target").selectedIndex = 1;
	                    document.getElementById("hidTarget").value = "1";
	                    document.getElementById("select_YN").value = "YES";
	                    document.getElementById("RangeXMLStr").value = rv[1];
	                } 
	                else if (rv[0] == "NO") {
	                    document.getElementById("set_Target").selectedIndex = 0;
	                    document.getElementById("hidTarget").value = "0";
	                    document.getElementById("selectYN").value = "NO";
	                    document.getElementById("RangeXMLStr").value = "";
	                }
	            } 
	            else {	            	
	                if ((g_windowReference == null) || (g_windowReference.closed == true)) {
	                    if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
	                        var feature = GetOpenPosition(560, 730);
	                        g_windowReference = window.open(szUrl, "SelectRange", "height=730,width=560,resizable=no,center=yes" + feature);
	                    } 
	                    else {
	                        var feature = GetOpenPosition(614, 720);
	                        g_windowReference = window.open(szUrl, "SelectRange", "height=720,width=614,resizable=no,center=yes" + feature);
	                    }
	                }
	                
	                g_windowReference.focus();
	            }
	        } 
	        else {
	            menu_SelectRange_IE();
	        } 
	    }
		
		function fun_Cancel() {
    		var compTemp = "";
    		
    		if (mode == 'modify'){
    			compTemp = confirm("<spring:message code='ezPoll.t255' />");
    		}else{
    			compTemp = confirm("<spring:message code='ezPoll.t254' />");
    		}
    		
    		if (compTemp == true) {
				undoEditing();
        		menuQst_List();
    		}
		}
		
	    function menu_SelectRange_IE() {
	        var item_no = document.all("item_no").value;
	        var szUrl = "/ezPoll/qstRangeSelect.do?brdID=6&itemNo=" + item_no; 
	        
	        if ((g_windowReference == null) || (g_windowReference.closed == true)) {
	            if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
	                var feature = GetOpenPosition(560, 630);
	                g_windowReference = window.open(szUrl, "SelectRange", "height=630,width=560,resizable=no,center=yes" + feature);
	            } 
	            else {
	                var feature = GetOpenPosition(560, 700);
	                g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
	            }
	        }
	        
	        g_windowReference.focus();
	    }
	    
    	function GetRangeValue() {
	        return document.getElementById("RangeXMLStr").value;
	    }
    	    	
    	function fun_OK(element) {
			element.style.pointerEvents = 'none';
			try {
    		$('#numberOfOptions').val($('#columnsbnk li').length); 
    		
/*     		if (!$('#endDate').is(':checked')) {    			
            	$("#sTimePicker option[value='0000']").attr('selected','selected');            	
            	$("#eTimePicker option[value='2330']").attr('selected','selected');
            	L_StartTime = $( "#sTimePicker option:selected" ).text() + ":00";
            	L_EndTime   = $( "#eTimePicker option:selected" ).text() + ":59";       	
    		}
    		else {
    			L_StartTime = $( "#sTimePicker option:selected" ).text() + ":00";
    			L_EndTime   = $( "#eTimePicker option:selected" ).text() + ":59";
    		} */
    		
    		L_StartTime = $( "#sTimePicker option:selected" ).text() + ":00"; //20180109
			L_EndTime   = $( "#eTimePicker option:selected" ).text() + ":59"; //20180109
    		
    		L_StartDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    		L_EndDate   = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    		
       		if ($('#endDate').is(':checked')) {
       			document.getElementById("hidSetDate").value = "1";
    		}
    		else {
    			document.getElementById("hidSetDate").value = "0";
    		}
    		
    		if ($('#anonymousVote').is(':checked')) {
    			$('#hidSecreteVote').val("1");
    		}
    		else {
    			$('#hidSecreteVote').val("0");
    		} 
    		
			var seeResultInput = document.querySelectorAll("div.seeResult input");
			var seeResultInputChecked = Array.prototype.filter.call(seeResultInput, function(elem){
				return elem.checked == true;
			});
			$('#hidResultFirst').val(seeResultInputChecked[0].value);
    		
	        if ($('#multipleCheck').is(':checked')) {
	        	var myListSelected = document.getElementById("myList").selectedIndex;
	        	
	    		if (myListSelected == 0) {
	    			$('#multiSelectNumber').val('0');
	    		}
	    		else {
	    			myListSelected = (myListSelected + 1) + "";
	    			$('#multiSelectNumber').val(myListSelected);
	    		}
	        }    
	        else {
	        	$('#multiSelectNumber').val('1');
	        }
	        
	        if ($('#isSorting').is(':checked')) {
	        	$('#hidIsSorting').val("1");	
	        }
	        else{
	        	$('#hidIsSorting').val("0");	
	        }
	       
	        if ($('#isSelOnlyOnce').is(':checked')) {
	        	$('#hidIsSelOnlyOnce').val("1");	
	        }
	        else{
	        	$('#hidIsSelOnlyOnce').val("0");	
	        }
	        
	        if ($('#sendPostMail').is(':checked')) {
	        	$('#hidSendPostNotice').val("1");	
	        }
	        else{
	        	$('#hidSendPostNotice').val("0");	
	        }
	        
	        if ($('#openToAll').is(':checked')) {
	        	$('#hidOpenToAll').val("1");
	        }
	        else{
	        	$('#hidOpenToAll').val("0");
	        }
	        
    		if (form_check() == false) {
				element.style.pointerEvents = '';
        		return;
        	} 
    		else {        		
            	document.getElementById("hidStartDate").value = L_StartDate + " " + L_StartTime ; 
            	document.getElementById("hidEndDate").value = L_EndDate + " " + L_EndTime ;
            	document.getElementById("hidCreateDate").value = getCurrTime();
            	document.getElementById("hidContent").textContent = message.GetEditorContent();
		    	var listtable = document.getElementById("filelist");
		    	var filelist = GetChildNodes(listtable);		    	
				
		    	var optListTable = document.getElementById("columnsbnk");
		    	var optList = GetChildNodes(optListTable);		    	
		    	
		    	for (var i = 0; i < filelist.length; i++) {			    	    
		    	    document.getElementById("hidFilePath").value += GetAttribute(filelist[i], "fileinfo") + "|";
		    	}
		    	
		    	for (var i = 0; i < optList.length - 1; i++) {			    	    
		    		if(optList[i].lastChild !== null && optList[i].lastChild.className === "thumbnail"){
		    			var _fileinfo = GetAttribute(optList[i].lastChild, "_fileinfo");
		    			var _optimgid = GetAttribute(optList[i].lastChild, "_optimgid");
		    			document.getElementById("hidOptImgFilePath").value += _fileinfo+ "//" +_optimgid + "|";
		    			makeDeleteImgList(_fileinfo);
		    		}
		    	}
		    	optImgPrevArr = optImgPrevArr.concat(optImgOld);
		    	
		    	if (mode == "modify") {
		    		var qstID = "<c:out value='${question.qstId}'/>";
		    		document.getElementById("hidModifyInfo").value = qstID;
		    		flag = 1;
		    	}
		    	
		    	window.parent.frames["left"].resetNodeSelected();
				
		    	document.getElementById("hidFilePath").value = document.getElementById("hidFilePath").value.substring(0, document.getElementById("hidFilePath").value.length - 1);               	  
		    	document.getElementById("hidOptImgFilePath").value = document.getElementById("hidOptImgFilePath").value.substring(0, document.getElementById("hidOptImgFilePath").value.length - 1);               	  
            	document.frmCreate.qst_title = encodeURIComponent(document.frmCreate.qst_title); 
            	document.frmCreate.message = encodeURIComponent(document.frmCreate.message);             	
            	document.frmCreate.submit();
        	}
			} catch (e) {
				console.log(e);
				element.style.pointerEvents = '';
			}
    	}    	
    	
    	function checkOption() {
    		var totalOptions = $('#columnsbnk li').length;
    		var count = 0;
    		for (var i = 1; i <= totalOptions; i++) {
    			var optionId = "#option" + i;
    			var pLastChild = $(optionId).parent()[0].lastChild;
    			var pLastChildNodeName = pLastChild.nodeName.toLowerCase();
    			var optVal = $(optionId).val().replace(/ /g,'');
    			
    			if (optVal != "") {    				
    				count ++;
    			}
    			else if (pLastChildNodeName === "img" && pLastChild.hasAttribute("_fileinfo") && optVal == "") {
    				var targetOpt = document.getElementById("option" + i);
    				targetOpt.focus();
    				targetOpt.value = "<spring:message code='ezPoll.t152'/>";
    				targetOpt.style.backgroundColor = "#dcdcdc";
    				setTimeout(
   						function(){
   							targetOpt.style.backgroundColor = "";
   							targetOpt.value = "";
  						}
 					, 800);
    				return -i;
    			}
    			else {
    				$(optionId).val("");
    			}
    		} 
    		
    		return count;
    	}
    	
    	function form_check() {
	        if (trim_Cross(document.getElementById("qst_title").value) == "") {
	            alert('<spring:message code="ezPoll.t234"/>');	    
	            document.getElementById("qst_title").value = "";	           
	            document.getElementById("qst_title").focus();
	            return false;
	        }
	        
	        if (document.getElementById("set_Target").selectedIndex == 1) {
	        	var rangeSelect = document.getElementById("RangeXMLStr").value;
	        	
	        	if (rangeSelect == null || rangeSelect == "" || rangeSelect == "<RANGE></RANGE>") {
 					alert('<spring:message code="ezPoll.t235"/>');
     				return false;
 				}
	        	
/* 	            if (document.getElementById("select_YN").value != "YES") {
	            	if (mode != "modify" && configFlag != "1") {
		            	alert('<spring:message code="ezPoll.t235" />');
		                return false;
	            	}	            	
	            	document.getElementById("RangeXMLStr").value = sigBody3.innerHTML;
	            } */
	            
	        }
	       /*  && mode != "modify" */
	        var chkFlags = checkOption();
	        if (chkFlags == 0) {	        	
	        	alert('<spring:message code="ezPoll.t148"/>');
	        	document.getElementById("option1").focus();
	        	return false;
	        }
	        else if(chkFlags < 0){
	        	alert('<spring:message code="ezPoll.t152"/>');
	        	return false;
	        }
	        
	        L_StartDate = L_StartDate.substring(0, 10);
	        L_EndDate 	= L_EndDate.substring(0, 10);
	        
	        if (L_StartDate > L_EndDate) {
	        	alert('<spring:message code="ezPoll.t236" />');
	        	var NowDate = new Date(new Date().getTime());
	        	var NextWeek = new Date(new Date().getTime() + 7 * 24 * 60 * 60 * 1000);
	        	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Sdatepicker").datepicker('setDate', NowDate); 
	        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Edatepicker").datepicker('setDate', NextWeek);
	            return false;
	        }
	        else if (L_StartDate == L_EndDate) {
	        	if (L_StartTime >= L_EndTime) {
		        	alert('<spring:message code="ezPoll.t236" />');
		            return false;
	        	}
	        }
 	        
	        var rtnValue = $.isNumeric(trim_Cross($('#multiSelectNumber').val()));
	        
	        if (!rtnValue) {	        	
	        	return false;
	        }

	        if ($('#hidSecreteVote').val() == "") {
	        	return false;
	        }
    	}
	    function closeWindow() {
	        if ((g_windowReference != null) && (g_windowReference.closed == false)) {
	            g_windowReference.close();
	            g_windowReference = null;
	        }
	    }
	    function updateParent(_element, _value, _Type) {
	        var elementRef = document.getElementsByName(_element);
	
	        if (elementRef.length > 0) {
	            switch (_Type) {
	                case "selectedIndex":
	                    elementRef[0].selectedIndex = _value;
	                    break;
	                case "value":
	                    elementRef[0].value = _value;
	                    break;
	            }
	        }
	    }
	    
	    function updateTarget(listOfTarget) {	    	    	
	    	var newTargetDiv = document.getElementById("newTargetDiv");
	    	newTargetDiv.innerHTML = listOfTarget;
	    	newTargetDiv.setAttribute("title", listOfTarget);
	    	newTargetDiv.style.display = "";	    	
	    }
	    
	    function Editor_Complete() {
	    	if (mode == "modify" || mode == "reuse") {
	    		message.SetEditorContent(sigBody.innerHTML);
	    	}
	    }
	    
	    function uploadbtn() {
	        document.getElementById("file").click();
	    }
	    
	    function optUploadBtn(obj){
	    	tempObj = obj;
	        document.getElementById("optionfile").click();
	    }
	    
	    function optImgUpload(){
	    	var fd = new FormData();		    	
	    	var _file = document.getElementById("optionfile").files[0];    	
	    	var ext = _file.name.split('.').pop().toLowerCase();
	    	
            if (_file.size / 1024 / 1024 > 5) {
                alert("<spring:message code = 'ezPoll.t208' />");
                return;
            }	 
            
            fd.append("fileToUpload", _file);			
	        xhr.addEventListener("load", uploadOptImgComplete, false);
	        
	        if (ext == "jpg" || ext == "png" || ext == "bmp") {
	        	/* 2021-12-09 홍승비 - 사원 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 (실제 파일 업로드 이전에 ajax로 체크) */
				if (checkImgExtension(ext) == "UPLOAD_EXT_ERROR") {
					alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
					return false;
				}
				
	    	    xhr.open("POST", "/ezPoll/uploadFile.do");
	    	    xhr.send(fd); 
	        }
	        else {
	        	alert("<spring:message code = 'ezCommunity.lhj03' /> (jpg, png, bmp)");
	        	return false;
	        }
	    }
	    
	    function uploadOptImgComplete(evt) {		    	
	    	xhr.removeEventListener("load", uploadOptImgComplete);
	    	clearFileInput(document.getElementById("optionfile"));
	    	var fileinfo = getNodeText(SelectNodes(loadXMLString(xhr.responseText), "ROOT/NODES/DATA")[0]);
	    	optImgPrevArr.push(fileinfo);
	        showAttachedOptFile(xhr.responseText);		       
	    }
	    
	    function showAttachedOptFile(strXML) {
	    	if (strXML == "ERROR") {    	
	            alert("Upload Failed!");
	            return;
	        }		    	
	    	
	        var xml = loadXMLString(strXML); 	        	        
	    	var fileinfo = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[0]);		
	    	var orgFileName = fileinfo.split("/")[1];		 	    	
	    	var _ext = orgFileName.split('.').pop().toLowerCase();		 
	    	var imagePreview = null;
	    	
	    	var selOptRow = tempObj.parentNode;
	    	var optimgid = selOptRow.getElementsByTagName('input')[0].id;
	    	
	    	//썸네일 이미지 처리.
	    	if(selOptRow.getElementsByClassName("thumbnail").length !== 0){
	    		cancelAttachOptImgFile(selOptRow);
	    		optImageTagAppend(fileinfo, selOptRow, optimgid);
	    	}else{
	    		optImageTagAppend(fileinfo, selOptRow, optimgid);
	    	}
	    }
	    
	    function cancelAttachOptImgFile(obj) {
	    	obj = obj.tagName.toLowerCase() === "img" ? obj : obj.lastChild;
			/* 미리보기 첨부파일을 한번에 모아서 지우기 위해 주석처리 */
	    	/* var type = obj.getAttribute("_type");
			if (type == "file") {
				//Send delete file request to server
		    	var fileinfo = obj.getAttribute("_fileInfo");		    	
		    	var orgFileName = fileinfo.split("/")[1];
		    	var ext = orgFileName.split('.').pop().toLowerCase();
		        var fd = new FormData();		        
		        fd.append("fileToDelete", fileinfo);
		        
		        if (ext == "jpg" || ext == "png" || ext == "bmp") {
			        xhr.open("POST", "/ezPoll/deleteFile.do");
			        xhr.send(fd);
		        }
		        
			} */	
			$("#imgPopupBox").removeClass("imgPopupBox").addClass("imgPopupBoxOff");
    		$("#imgPopup").removeClass("imgPopup").addClass("imgPopupOff");
    		$(obj).remove();
	    }
	    
	    //파일 업로드시 onchange 이벤트로 업로드 하는데 파일 올린 후 이 로직이 없으면 같은 파일 올릴 경우 미작동.
	    function clearFileInput(ctrl) {
	    	  try {
	    	    ctrl.value = null;
	    	  } 
	    	  catch(ex) { }
	    	  
	    	  if (ctrl.value) {
	    	    ctrl.parentNode.replaceChild(ctrl.cloneNode(true), ctrl);
	    	  }
	    }
	    
	    function getCurrTime() {		    	
	    	var strTime = new Date().toTimeString().split(" ")[0];
	    	var strDateTime = new Date().toISOString();
	    	var strDate = strDateTime.substring(0, 10);
	    	return strDate + " " + strTime;
	    }
	    
	    // 보기 항목에 이미지 첨부시 이미지 추가.
	    function optImageTagAppend(fileinfo, selOptRow, optimgid){
	    	var tenantId = ${tenantId};
	    	if(fileinfo !== null){
		    	if(mode !== ""){
		    		var selOptRow = document.getElementById(optimgid === "" ? "option"+fileinfo.ansId : optimgid).parentNode;
		    		var optimgid = selOptRow.getElementsByTagName('input')[0].id;
		    	}
		    	var objImg = document.createElement("img");
		    	var _fileinfo = typeof(fileinfo) === "object" ? fileinfo.filePath : fileinfo;
		    	objImg.setAttribute("_fileInfo", _fileinfo);
		    	objImg.setAttribute("_type", "file");
		    	objImg.setAttribute("_optimgid", optimgid);
		    	objImg.setAttribute("onclick", "cancelAttachOptImgFile(this)");
		    	objImg.className = "thumbnail";
	    		if(typeof(fileinfo) === "string"){
	    			fileinfo = fileinfo.split('/')[0];
	    		}else{
	    			fileinfo = fileinfo.filePath.split('/')[0];
	    		}
		    	objImg.src = "/fileroot/" + tenantId + "/files/upload_vote/uploadFile/" + fileinfo;
	    		$(selOptRow).append(objImg);
	    		checkOptionsList();
	    	}
	    }
	    
	  	//썸네일 이미지에 레이어 팝업 기능 관련
	    function addThumbnailEvent(){
	    	$("#ballotSystemBody").append("<div id='imgPopupBox' class='imgPopupBoxOff'><img id='imgPopup' class='imgPopupOff'/></div>");
	    	$(document).on("mouseover",".thumbnail",function(e){
				$("#imgPopupBox").removeClass("imgPopupBoxOff").addClass("imgPopupBox");
	    		$("#imgPopup").removeClass("imgPopupOff").addClass("imgPopup");
	    		$("#imgPopup").attr("src",e.target.src);
	    		$("#imgPopupBox").css("left",(window.innerWidth-$("#imgPopupBox").width())/2);
	    		$("#imgPopupBox").css("top",(window.innerHeight-$("#imgPopupBox").height())/2 + window.pageYOffset);
	    		$("#imgPopup").css("left",($("#imgPopup").parent().width()-$("#imgPopup").width())/2);
	    		$("#imgPopup").css("top",($("#imgPopup").parent().width()-$("#imgPopup").height())/2);
			}).on('mouseout',function(e){
				$("#imgPopupBox").removeClass("imgPopupBox").addClass("imgPopupBoxOff");
	    		$("#imgPopup").removeClass("imgPopup").addClass("imgPopupOff");
	    		$("#imgPopup").removeAttr("src");
			});
	    }
	  	
	  	//이미지 미리보기 파일 삭제
	    function optImgPrevDelete(){
	  		var str = optImgPrevArr.join()
	        $.ajax({
	            type : "POST",
	            async : false,
	            url : "/ezPoll/deleteOptPrevFile.do",
	            data : {
	                optImgPrevArr : str
	            }
	        });
	    }
	  	
	  	//삭제 이미지 목록 생성.
	  	function makeDeleteImgList(_fileinfo){
	  		/* if(optImgOld.length > 0 && optImgOld.includes(_fileinfo)){
    			for(var i = 0; i < optImgOld.length; i++){
    				if(optImgOld[i] === _fileinfo){
    					optImgOld.splice(i,1);
    				}
    			}
			}
	  		
			if(optImgPrevArr.length > 0 && optImgPrevArr.includes(_fileinfo)){
    			for(var i = 0; i < optImgPrevArr.length; i++){
    				if(optImgPrevArr[i] === _fileinfo){
    					optImgPrevArr.splice(i,1);
    				}
    			}
			} */
	  		if(optImgOld.length > 0){
    			for(var i = 0; i < optImgOld.length; i++){
    				if(optImgOld[i] === _fileinfo){
    					optImgOld.splice(i,1);
    				}
    			}
			}
	  		
			if(optImgPrevArr.length > 0){
    			for(var i = 0; i < optImgPrevArr.length; i++){
    				if(optImgPrevArr[i] === _fileinfo){
    					optImgPrevArr.splice(i,1);
    				}
    			}
			}
	  	}
	  	
		function seeResultOptSetting(){
			var _seeResultFirst = "<c:out value='${question.resultFirst}'/>";
			var seeResultInput = document.querySelectorAll("div.seeResult input");
			seeResultInput[0].checked = false;
			seeResultInput[1].checked = false;
			seeResultInput[2].checked = false;
			
			if (_seeResultFirst == 0) {
				seeResultInput[1].checked = true;
			}
			else if (_seeResultFirst === "1") {
				seeResultInput[0].checked = true;
			}
			else {
				seeResultInput[2].checked = true;
			}
		}

		function undoEditing() {
			$.ajax({
				type : "POST",
				dataType : "text",
				async : false,
				url : "/ezPoll/undoModifyVote.do",
				data : {
					questionId : qst_ID
				}
			});
		}
	  	
	</script>
</head>
<xmp id="sigBody3" style="display: none;">${targetPath}</xmp>
<xmp id="sigBody2" style="display: none;">${filePath}</xmp>
<xmp id="sigBody" style="display: none;">${content}</xmp>
<body class="mainbody">
	<form id="frmCreate" method="post" action="/ezPoll/pollComplete.do" name="frmCreate"> 	
		<h1><spring:message code="ezPoll.t206" /></h1>
		<div id="ballotSystemBody">
			<table class="content content_poll" style="width: 100%;"> 
				<tr>    <!------------Question title----------------> 
					<%-- <th>Question</th>			--%>
					<td style="width: 100%;" class="pollTd01">							
						<input id="qst_title" name="qst_title" type="text"  placeholder="<spring:message code='ezPoll.t234'/>" style="width: 100%;" class="createPoll_title" maxlength="150" value="<c:out value="${mode == 'modify' || mode == 'reuse' ? question.title : ''}"/>">
					</td>
	
				</tr>
				<tr> 
					<td style="width:100%;height:500px; margin:0px 0px 8px 0px; " id="EdtorSize" class="pollTd01">
		               <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:100%; width:100%;overflow:auto; border-top:0px" ></iframe>
	           		</td>
				</tr>		
				
				<tr>
					<td class="pollTd01">					
						<div style="width:100%;white-space:nowrap;display:none;height:22px">
							<div id="progdiv" class="progarea" style="display: none">
								<p class="prog_bar">
									<span id="prog_bar" style="width: 0%"></span>
								</p>
								<span class="prog_num"><strong id="prog_num">0</strong>%</span>
							</div>
							<div style="clear: both"></div>
						</div>
						<div id="lstAttachLink" class="ui-sortable" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="height: 120px;border: 1px solid #ddd;overflow: auto; margin:8px 0px 0px 0px;">
							<div id="addFile" class="pollAddFile">
								<img src="/images/poll/pollAddFile_Addicon.png" style="height:23px;width:20px;vertical-align:middle; margin:-4px 5px 0px 0px; padding:0px; cursor: pointer;" onclick="uploadbtn()">
								<spring:message code="ezPoll.t151"/>
							</div>
						</div> 
						<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width: 1px; height: 1px; display:none" /> 
						<input type="hidden" onclick="fileupload()"/>
					</td>
				</tr>
				
			</table> 
			
				    <!------------Answer option---------------->
			<table class="content" style="width: 100%; margin:10px 0px 10px 2px; border-bottom:none;"> 
				<tr>
					<td style="padding: 0px; border-bottom: none;" class="pollTd01">
						<ul id="columnsbnk" >
							<li class="myBorder">
								<span>1</span>
								<input type="text" value=""	placeholder="<spring:message code="ezPoll.t152"/>" id="option1" name="option1" oninput="checkOptionsList();" maxlength="200">
								<img src="/images/sortIcon.png" class="drag_drop">
								<img src="/images/poll/attach_file_vote.png" onclick="optUploadBtn(this)" style="cursor: pointer;">
							</li>
							<li class="myBorder">
								<span>2</span>
								<input type="text" value="" placeholder="<spring:message code="ezPoll.t152"/>" id="option2" name="option2" oninput="checkOptionsList();" maxlength="200">
								<img src="/images/sortIcon.png" class="drag_drop">
								<img src="/images/poll/attach_file_vote.png" onclick="optUploadBtn(this)" style="cursor: pointer;">
							</li>
							<li class="myBorder">
								<span>3</span>
								<input type="text" value=""	placeholder="<spring:message code="ezPoll.t152"/>" id="option3" name="option3" oninput="checkOptionsList();" maxlength="200">
								<img src="/images/sortIcon.png" class="drag_drop">
								<img src="/images/poll/attach_file_vote.png" onclick="optUploadBtn(this)" style="cursor: pointer;">
							</li>
								<input id="optionfile" type="file" onchange="optImgUpload()" style="display:none" accept="image/*"/>
						</ul>
					</td>
				</tr>
			</table>
			<div style="text-align: left">
				<button type="button" id="addOpt" onclick="javascript:addOption();" class="pollButton01" style="box-shadow:0px 2px 0px 0px rgba(0,0,0,0.1); width:129px; height:30px; vertical-align:top;font-size:13px; background:#FFF; border:1px solid #d2d2d2;padding-bottom:3px; border-radius:2px; cursor:pointer;font-weight:bold; color:black;"><spring:message code="ezPoll.t153"/></button>
			</div>
			<table class="content" style="width: 100%; margin:10px 0px 0px 0px;"> 
				<tr>    <!------------Question setting---------------->
					<td class="qstSettingTd">
						<div class="qstSetting">
							<div class='custom_checkbox'>
								<span class="qstSettingSpan"><spring:message code="ezPoll.hdp10"/></span>
								<input id="multipleCheck" type="checkbox"><label for="multipleCheck"><span><spring:message code="ezPoll.t154"/></span></label>
								<div id="numberOfMultiSelect" style="display: none; margin-left: 5px;">
									<%-- <span style="margin-right: 3px;"><spring:message code="ezPoll.t155"/></span> --%>
									<select id="myList">
										<option value="1"><spring:message code = 'ezEmail.lhm67'/></option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
									</select>
								</div>
							</div>
						</div>
	
						<div class="qstSetting seeResult">
							<div class='custom_radio'>
								<span class="qstSettingSpan"><spring:message code="ezPoll.hdp11"/></span>
								<input id="seeResultFirst" name="seeResult" type="radio" value="1">
								<label for="seeResultFirst"><span><spring:message code="ezPoll.hdp13"/></span></label>
								<input id="seeResultLast" name="seeResult" type="radio" value="0">
								<label for="seeResultLast"><span><spring:message code="ezPoll.hdp14"/></span></label>
								<input id="seeResultCreator" name="seeResult" type="radio" value="2">
								<label for="seeResultCreator"><span><spring:message code="ezPoll.hdp15"/></span></label>
							</div>
						</div>
						
						<div class="qstSetting">
							<div class='custom_checkbox'>
								<span class="qstSettingSpan"><spring:message code="ezPoll.hdp12"/></span>
								<input id="anonymousVote" type="checkbox">
								<label for="anonymousVote"><span><spring:message code="ezPoll.t253"/></span></label>
								
								<input id="isSorting" type="checkbox">
								<label for="isSorting"><span><spring:message code = 'ezPoll.t259'/></span></label>
								
								<input id="isSelOnlyOnce" type="checkbox">
								<label for="isSelOnlyOnce"><span><spring:message code = 'ezPoll.t260'/></span></label>
								
								<input id="endDate" type="checkbox">
								<label for="endDate"><span><spring:message code="ezPoll.t159"/></span></label>
								
								<div id="_dateTimePicker" style="display: none;">										
									<input type="text" id="Sdatepicker" style="width:80px;text-align:center;vertical-align:top;" readonly >
									<select id="sTimePicker" style="height:24px;"></select>
									<span>~</span>
									<input type="text" id="Edatepicker" style="width:80px;text-align:center;vertical-align:top;" readonly >
									<select id="eTimePicker" style="height:24px;"></select>						
								</div>
							</div>
							
							<div id="openToAllDiv" class="qstSettingInnerDivRight">
								<div class='custom_checkbox'>
									<input id="openToAll" type="checkbox" >
									<label for="openToAll"><span><spring:message code="ezPoll.hdp09"/></span></label>
								</div>
							</div>
							
						</div>
	<%-- 					<div class="qstSetting" style="height:30px; line-height:30px; border-bottom:1px solid #DDD; margin:0px; padding:0px 5px;">
							<input id="anonymousVote" type="checkbox">
							<span><spring:message code="ezPoll.t158"/></span>
						</div>
						
						<div class="qstSetting" style="height:30px; line-height:30px; border-bottom:1px solid #DDD; margin:0px; padding:0px 5px;">
							<input id="endDate" type="checkbox">
							<span><spring:message code="ezPoll.t159"/></span>
						</div>	
						
						<div id="_dateTimePicker" style="height:30px; line-height:30px; border-bottom:1px solid #DDD; margin:0px; padding:0px 5px; display: none;">		
							<span><spring:message code="ezPoll.t160"/></span>			
							<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly >
							<select id="sTimePicker"></select>
							<span><spring:message code="ezPoll.t161"/></span>
							<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly >
							<select id="eTimePicker"></select>						
						</div>
	--%>
						<div id="target_select" class="qstSetting">
							<span class="qstSettingSpan"><spring:message code="ezPoll.t162"/></span>
							<select id="set_Target" style="height:22px">
								<option value="0" selected="selected"><spring:message code="ezPoll.t237" /></option>
								<option value="1"><spring:message code="ezPoll.t238" /></option>
							</select>	
							<a class="pollImgbtn1" id="receiverBttn" style="display: none;background-color: #e8e8e8;height:21px"><span onclick="menu_SelectRange();"><spring:message code="ezPoll.t163"/></span></a>
							<div style="display:none;" id="newTargetDiv"></div>																		
							<div id="sendPostNotiMailDiv" class="qstSettingInnerDivRight">
								<div class='custom_checkbox'>
									<input id="sendPostMail" type="checkbox" style="margin-bottom: -2px;">
									<label for="sendPostMail"><span style="vertical-align: middle;"><spring:message code="ezCommunity.t553"/></span></label>
								</div>
							</div>
						</div>
						<div style="display:none">
							<input type="text" name="hidStartDate" id="hidStartDate" style="display:none"> 
		                    <input type="text" name="hidEndDate" id="hidEndDate" style="display:none">
		                    <input type="text" name="selectYN" id="select_YN" style="display:none">	
		                    <input type="text" name="itemNo" id="item_no" style="display:none"> 
							<input type="text" name="RangeXMLStr" id="RangeXMLStr" style="display:none">
							<input type="text" name="numberOfOptions" id="numberOfOptions" style="display:none">
							<input type="text" name="hidTarget" id="hidTarget" value="0" style="display:none"> 
							<input type="text" name="multiSelectNumber" id="multiSelectNumber" value="0" style="display:none"> 
							<input type="text" name="hidSecreteVote" id="hidSecreteVote" value="" style="display:none"> 
							<input type="text" name="hidResultFirst" id="hidResultFirst" value="" style="display:none"> 
							<input type="text" name="hidModifyInfo" id="hidModifyInfo" value="" style="display:none"> 
							<textarea name="hidContent" id="hidContent" style="display:none"></textarea>
							<input type="text" name="hidFilePath" id="hidFilePath" value="" style="display:none">	
							<input type="text" name="hidSetDate" id="hidSetDate" value="" style="display:none">
							<input type="text" name="hidCreateDate" id="hidCreateDate" value="" style="display:none">		
							<input type="text" name="hidIsSorting" id="hidIsSorting" value="" style="display:none">		
							<input type="text" name="hidIsSelOnlyOnce" id="hidIsSelOnlyOnce" value="" style="display:none">		
							<input type="text" name="hidOptImgFilePath" id="hidOptImgFilePath" value="" style="display:none">		
							<input type="text" name="hidSendPostNotice" id="hidSendPostNotice" value="" style="display:none">		
							<input type="text" name="hidOpenToAll" id="hidOpenToAll" value="" style="display:none">		
							
						</div>
					</td>
				</tr>						
			</table>			
			<div class="btnpositionJsp">				
				<a class="imgbtn" onclick="fun_OK(this)"><span><spring:message code="ezPoll.kje01" /></span></a>
				<a class="imgbtn" onclick="fun_Cancel()"><span><spring:message code="ezPoll.t139" /></span></a>				
			</div>
		</div>	
	</form>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.5); display: none;"	id="mailPanel">&nbsp;</div>
	<div class="layerpopup"	style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />"style="border: none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>