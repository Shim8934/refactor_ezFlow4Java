<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Create Poll</title>	
		
	<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">	
	<link rel="stylesheet" href="/css/ezPoll/sort.css" type="text/css">	
	<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
	<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
	<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezSchedule/schedule_write_Cross.js"></script>
	<script type="text/javascript" src="/js/ezPoll/dropzone.js"></script>
  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  	<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	  
	<script type="text/javascript">		
		//Variable for file upload()
	    var filesize = 0;
	    var file = new Array;
	    var xhr = new XMLHttpRequest();
		var lstAttachLink = document.getElementById("lstAttachLink");
	    var isfileup = false;
	    //end
	    var mode = "<c:out value='${mode}'/>";
		var L_StartDate = "";
		var L_EndDate = "";
		var L_StartTime = "";
		var L_EndTime = "";
		var g_windowReference = null;		
		
		window.onunload = function(){
			if (mode == "modify"){
				//Update the vote modifying status
				var qstID = "<c:out value='${question.qstId}'/>";
				var fd = new FormData();
				fd.append("questionId", qstID);
			    xhr.open("POST", "/ezPoll/undoModifyVote.do");
			    xhr.send(fd); 
			    window.close();
			}			
    	}; 
		window.onload = function () {	
			preProcessing();		
			setBorder();
			
			$( "#columnsbnk" ).sortable({
				handle: ".drag_drop",
		    	axis: "y",
		    	containment: "#columnsbnk",
		    	tolerance: 'pointer',
		    	update: function() {
					for(var i = 0; i < $('#columnsbnk li').length; i++){
						$('#columnsbnk li').eq(i).children("span").text(i + 1);
						$('#columnsbnk li').eq(i).removeClass("myBorder");
					}
					setBorder();
		    	}
				
		    });
			fileUploadStart();
		}
		
		function preProcessing(){
			if (mode == "modify") {
				//Modify the vote
				var questionTitle = "<c:out value='${question.title}'/>";
				document.getElementById("qst_title").value = questionTitle;
				var pathFile = sigBody2.innerHTML;

				if (pathFile != null || pathFile != "") {
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
				
				for( var j = 0; j < listOfOptions.length; j++) {
					var _id = "option" + (j + 1);
					document.getElementById(_id).value =  listOfOptions[j].content;
				}
				
				/***************************Set other fields**********************************/
				//Allow multi-select
				var _multi_select = "<c:out value='${question.multiSelect}'/>";
				if (_multi_select == 1) {
					$('#multipleCheck').attr('checked', false);
					$('#numberOfMultiSelect').hide();
				}
				else {
					$('#multipleCheck').attr('checked', true);
					$('#numberOfMultiSelect').show();
					if(_multi_select == 0){
						$("#numberOfMultiSelect select").val("1");
					}
					else {
						$("#numberOfMultiSelect select").val(_multi_select);
					}
				}
				
				//See result before Voting
				var _seeResultFirst = "<c:out value='${question.resultFirst}'/>";
				if (_seeResultFirst == 0) {
					$('#seeResultFirst ').attr('checked', false);
				}
				
				//Allow secret vote
				var _secretVote = "<c:out value='${question.secretVote}'/>";
				if (_secretVote == 1) {
					$('#anonymousVote ').attr('checked', true);
				}
				
				//Set end date	
		    	$("#Sdatepicker").datepicker({
		        	changeMonth: true,
		        	changeYear: true,
		        	autoSize: true,
		        	showOn: "both",
		        	buttonImage: "/images/ImgIcon/calendar-month.gif",
		        	buttonImageOnly: true
		    	});
				$("#Edatepicker").datepicker({
			        changeMonth: true,
		    	    changeYear: true,
		        	autoSize: true,
		        	showOn: "both",
		        	buttonImage: "/images/ImgIcon/calendar-month.gif",
		        	buttonImageOnly: true
		    	});
				$('#endDate ').attr('checked', true);
				var _startD = "<c:out value='${question.startDate}'/>";
				var _endD = "<c:out value='${question.endDate}'/>";
				
	        	var sYear = _startD.substring(0, 4);
				var sMonth = _startD.substring(5, 7);
				var sDay = _startD.substring(8, 10);
				var sHour = _startD.substring(11, 13);
				var sMin = _startD.substring(14, 16);
				
				var SDate = new Date(sYear, sMonth-1, sDay);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		        
		        var eYear = _endD.substring(0, 4);
				var eMonth = _endD.substring(5, 7);
				var eDay = _endD.substring(8, 10);
				var eHour = _endD.substring(11, 13);
				var eMin = _endD.substring(14, 16);
				
	        	var EDate = new Date(eYear, eMonth-1, eDay);
	        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Edatepicker").datepicker('setDate', EDate);
	        	
	        	var sHourMinute = sHour + sMin;
	        	var eHourMinute =  eHour + eMin;	  
	        	
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
	        	
	        	//Select Target
	        	var _selectedTarget = "<c:out value='${question.target}'/>";
	        	//var _pathTarget = "<c:out value='${targetPath}'/>";
	        	//console.log("Target checking: " + sigBody3.innerHTML);
	        	if (_selectedTarget == 0) {
	        		$('#receiverBttn').hide();
	        		$("#set_Target").val("0").change();	        		
	        	}
	        	else {
	        		$('#receiverBttn').show();
	        		$("#set_Target").val("1").change();	
	        		document.getElementById("RangeXMLStr").value = sigBody3.innerHTML;
	        	}
	        	
				$('#set_Target').on('change', function(e) {					
				    if($(this).val() == '1'){
				    	$('#receiverBttn').show();
				    }
				    else{
				    	$('#receiverBttn').hide();
				    }
				}); 
			}
			else {
				
				$('#anonymousVote').removeAttr('checked');	
				$('#endDate').removeAttr('checked');			
				$('#_dateTimePicker').hide();			
				$('#receiverBttn').hide();

				setDateTimeValue();

				$('#multipleCheck').click(function(){
					if(this.checked){
						$('#numberOfMultiSelect').show();
					}
					else{
						$('#numberOfMultiSelect').hide();
					}
				});	
				
				$('#endDate').click(function(){
					if(this.checked){
						showDateTimePicker();
					}
					else{
						$('#_dateTimePicker').hide();					
					}
				});	
				
				//showDateTimePicker();
				$('#set_Target').on('change', function(e) {					
				    if($(this).val() == '1'){
				    	$('#receiverBttn').show();
				    }
				    else{
				    	$('#receiverBttn').hide();
				    }
				}); 
			}
		}
		
		function checkOptionsList(){
			if ($('#qst_title').val() == '') {
				alert("You must enter the question!");
			}
			
    		var totalOptions = $('#columnsbnk li').length;
    		var check_flag = 0;
    		for(var i = 1; i <= totalOptions; i++){
    			var optionId = "#option" + i;
    			if($(optionId).val() == ""){
    				check_flag = 1;
    				break;
    			}
    		} 
    		if(check_flag == 0){
    			addOption();
    		}
		}
		
		//Set bottom boder for all li but the last li
		function setBorder() {
			for (var i = 0; i < $('#columnsbnk li').length - 1; i++) {
				$('#columnsbnk li').eq(i).addClass("myBorder");
			}
		}
		function showDateTimePicker() {
			$('#_dateTimePicker').show();
			$('#Edatepicker').show();
			$('#eTimePicker').show();
			$('#Sdatepicker').show();
			$('#sTimePicker').show();
        	$("#sTimePicker option[value='0800']").attr('selected','selected');
        	$("#eTimePicker option[value='0800']").attr('selected','selected');
		}
		
		function setDateTimeValue() {
	    	$("#Sdatepicker").datepicker({
	        	changeMonth: true,
	        	changeYear: true,
	        	autoSize: true,
	        	showOn: "both",
	        	buttonImage: "/images/ImgIcon/calendar-month.gif",
	        	buttonImageOnly: true
	    	});
			$("#Edatepicker").datepicker({
		        changeMonth: true,
	    	    changeYear: true,
	        	autoSize: true,
	        	showOn: "both",
	        	buttonImage: "/images/ImgIcon/calendar-month.gif",
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
        	for(var i = 0; i < 24; i++)
        	{
        	    var j = zeroFill(i, 2);
        	    selection += "<option value='"+ j +"00'>"+ j + ":00" + "</option>";
        	    selection += "<option value='"+ j +"30'>"+ j + ":30" + "</option>";
        	} 
        	
        	$("#sTimePicker").html(selection);        	
        	//$("#sTimePicker option[value='0800']").attr('selected','selected');
        	$("#eTimePicker").html(selection); 
        	//$("#eTimePicker option[value='0800']").attr('selected','selected');
		}		
		
		function zeroFill( number, width ) {
		  width -= number.toString().length;
		  
		  if ( width > 0 ) {
		    return new Array( width + (/\./.test( number ) ? 2 : 1) ).join( '0' ) + number;
		  }
		  return number + ""; // always return a string
		}

		function addOption(){		
			var currentOptionNumber = $('#columnsbnk li').length + 1;	
			
			if ($('#qst_title').val() == '') {
				alert("You must enter the question!");
			}
			else {
				$('#columnsbnk li').eq(currentOptionNumber - 2).addClass("myBorder");
				$('#columnsbnk').append('<li> \n <span>' + currentOptionNumber + '</span> \n <input type="text" oninput="checkOptionsList();" value="" placeholder="New option" id="option' + currentOptionNumber + '" name="option' + currentOptionNumber + '"> \n <img src="/images/sortIcon.png" class="drag_drop"> \n </li>');
			}					
		}
		
		function menuQst_List() {
    		if(CrossYN()) {
    			var szUrl = "/ezPoll/pollList.do?brdID=6"
    		} else {
    			var szUrl = "/ezPoll/pollList.do?brdID=6"
    		}
    		window.location.href = szUrl;	
		}
		
		function menu_SelectRange() {
	         if (CrossYN()) {
	            var item_no = document.getElementById("item_no").value;
	
	            if (CrossYN()) {
	            	var szUrl = "/ezQuestion/qstRangeSelect.do?brdID=5&itemNo=" + item_no;
	            } else {
	            	var szUrl = "/ezQuestion/qstRangeSelect.do?brdID=5&itemNo=" + item_no;
	            }
	  
	            var _MSIE = 'MSIE';
	            var useragentstr = navigator.userAgent;
	            if (useragentstr.indexOf(_MSIE) != -1) {	            	
	                var szParam = "dialogHeight:705px;dialogWidth:562px;edge:sunken;status:no;resizable:no;help:no;center:yes;scroll:no" + GetShowModalPosition(562, 705);
	                var rv = window.showModalDialog(szUrl, document.getElementById("RangeXMLStr").value, szParam);
	                console.log("Checking :" + rv);
	                if (rv[0] == "OK") {
	                    document.getElementById("set_Target").selectedIndex = 1;
	                    document.getElementById("hidTarget").value = "1";
	                    document.getElementById("select_YN").value = "YES";
	                    document.getElementById("RangeXMLStr").value = rv[1];
	                } else if (rv[0] == "NO") {
	                    document.getElementById("set_Target").selectedIndex = 0;
	                    document.getElementById("hidTarget").value = "0";
	                    document.getElementById("selectYN").value = "NO";
	                    document.getElementById("RangeXMLStr").value = "";
	                }
	            } else {	            	
	                if ((g_windowReference == null) || (g_windowReference.closed == true)) {
	                    if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
	                        var feature = GetOpenPosition(560, 730);
	                        g_windowReference = window.open(szUrl, "SelectRange", "height=730,width=560,resizable=no,center=yes" + feature);
	                    } else {
	                        var feature = GetOpenPosition(730, 700);
	                        g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
	                    }
	                }
	                g_windowReference.focus();
	            }
	        } else {
	            menu_SelectRange_IE();
	        } 
	    }
		
		function fun_Cancel() {
    		var compTemp = "";
    		compTemp = confirm("<spring:message code='ezQuestion.t434' />");
    		if (compTemp == true) {
        		surveyState = "CANCEL";
        		menuQst_List();
    		}
		}
		
	    function menu_SelectRange_IE() {
	        var item_no = document.all("item_no").value;
	         var szUrl = "/ezQuestion/qstRangeSelect.do?brdID=5&itemNo=" + item_no; 
	        if ((g_windowReference == null) || (g_windowReference.closed == true)) {
	            if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
	                var feature = GetOpenPosition(560, 630);
	                g_windowReference = window.open(szUrl, "SelectRange", "height=630,width=560,resizable=no,center=yes" + feature);
	            } else {
	                var feature = GetOpenPosition(560, 700);
	                g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
	            }
	        }
	        g_windowReference.focus();
	    }
	    
    	function GetRangeValue() {
	        return document.getElementById("RangeXMLStr").value;
	    }
    	    	
    	function fun_OK() {
    		$('#numberOfOptions').val($('#columnsbnk li').length); 
    		
    		if (!$('#endDate').is(':checked')) {
    			
            	$("#sTimePicker option[value='0000']").attr('selected','selected');            	
            	$("#eTimePicker option[value='2330']").attr('selected','selected');
            	L_StartTime = $( "#sTimePicker option:selected" ).text() + ":00";
            	L_EndTime   = $( "#eTimePicker option:selected" ).text() + ":59";
            	
    		}
    		else {
    			L_StartTime = $( "#sTimePicker option:selected" ).text() + ":00";
    			L_EndTime   = $( "#eTimePicker option:selected" ).text() + ":59";
    		}
    		
    		L_StartDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    		L_EndDate   = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    		
    		if ($('#anonymousVote').is(':checked')) {
    			$('#hidSecreteVote').val("1");
    		}
    		else {
    			$('#hidSecreteVote').val("0");
    		} 
    		
    		if ($('#seeResultFirst').is(':checked')) {
    			$('#hidResultFirst').val("1");
    		}
    		else {
    			$('#hidResultFirst').val("0");
    		} 
    		
	        if ($('#multipleCheck').is(':checked')) {
	    		if ($("#myList option:selected").text() == "Unlimited") {
	    			$('#multiSelectNumber').val('0');
	    		}
	    		else {
	    			$('#multiSelectNumber').val($("#myList option:selected").text());
	    		}
	        }    
	        else {
	        	$('#multiSelectNumber').val('1');
	        }
    		if (form_check() == false) {
        		return;
        	} 
    		else {        		
            	document.getElementById("hidStartDate").value = L_StartDate + " " + L_StartTime ; 
            	document.getElementById("hidEndDate").value   = L_EndDate + " " + L_EndTime ;           	
            	document.getElementById("hidContent").innerHTML   = message.GetEditorContent();          	       	
		    	var listtable = document.getElementById("filelist");
		    	var filelist = GetChildNodes(listtable);		    	
				
		    	for (var i = 0; i < filelist.length; i++) {			    	    
		    	    document.getElementById("hidFilePath").value += GetAttribute(filelist[i], "fileinfo") + ";";
		    	}
		    	if (mode == "modify") {
		    		var qstID = "<c:out value='${question.qstId}'/>";
		    		document.getElementById("hidModifyInfo").value = qstID;
		    	}
				
		    	document.getElementById("hidFilePath").value = document.getElementById("hidFilePath").value.substring(0, document.getElementById("hidFilePath").value.length - 1);               	  
            	document.frmCreate.qst_title = encodeURIComponent(document.frmCreate.qst_title); 
            	document.frmCreate.message = encodeURIComponent(document.frmCreate.message);             	
            	document.frmCreate.submit();
        	}
    	}    	
    	
    	function checkOption(){
    		var totalOptions = $('#columnsbnk li').length;
    		var count = 0;
    		for(var i = 1; i <= totalOptions; i++){
    			var optionId = "#option" + i;
    			if($(optionId).val() != ""){
    				//alert(optionId + $(optionId).val());
    				count ++;
    			}
    		}   
    		return count;
    	}
    	
    	function form_check() {
    		//alert("Run in form_check!");
	        if (trim_Cross(document.getElementById("qst_title").value) == "") {
	            alert('<spring:message code="ezQuestion.t185" />');	            
	            document.getElementById("qst_title").focus();
	            return false;
	        }
	        if (document.getElementById("set_Target").selectedIndex == 1) {
	            if (document.getElementById("select_YN").value != "YES") {
	            	alert('<spring:message code="ezQuestion.t432" />');
	                return false;
	            }
	        }
	        if(checkOption() <= 0){
	        	alert("Please enter at least one option for this question!");
	        	document.getElementById("option1").focus();
	        	return false;
	        }	        
	        L_StartDate = L_StartDate.substring(0, 10);
	        L_EndDate 	= L_EndDate.substring(0, 10);
	        if (L_StartDate > L_EndDate) {
	        	alert('<spring:message code="ezQuestion.jjs2" />');
	            return false;
	        }
	        else if(L_StartDate == L_EndDate){
	        	if(L_StartTime >= L_EndTime){
		        	alert('<spring:message code="ezQuestion.jjs2" />');
		            return false;
	        	}
	        }
	        var rtnValue = $.isNumeric(trim_Cross($('#multiSelectNumber').val()));
	        if(!rtnValue){
	        	alert("Something wrong with multi-select funtion()");
	        	return false;
	        }
	        if($('#hidSecreteVote').val() == ""){
	        	alert("Something wrong with secretVote");
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
	    function Editor_Complete() {
	    	if (mode == "modify") {
	    		message.SetEditorContent(sigBody.innerHTML);
	    	}
	    }
	    
	    function uploadbtn() {
	        document.getElementById("file").click();
	    }
	</script>
</head>
<xmp id="sigBody3" style="display: none;">${targetPath}</xmp>
<xmp id="sigBody2" style="display: none;">${filePath}</xmp>
<xmp id="sigBody" style="display: none;">${content}</xmp>
<body class="mainbody">
	<form id="frmCreate" method="post" action="/ezPoll/pollComplete.do" name="frmCreate"> 	
		<h1><spring:message code="ezQuestion.t438" /></h1>

		<table class="content" style="width: 100%;"> 
			<tr>    <!------------Question title----------------> 
				<%-- <th>Question</th>			--%>
				<td style="width: 100%;">							
					<input id="qst_title" name="qst_title" type="text"  placeholder="Question" style="width: 100%;">
				</td>

			</tr>
			<tr>
				<td style="width:100%;height:350px;" id="EdtorSize">
	               <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:100%; width:99.8%;overflow:auto;border-top:0px" ></iframe>
           		</td>
			</tr>		
			
			<tr>
				<td>					
					<div style="width:100%;white-space:nowrap;display:inline-block;height:22px">
						<div id="progdiv" class="progarea" style="display: none">
							<p class="prog_bar">
								<span id="prog_bar" style="width: 0%"></span>
							</p>
							<span class="prog_num"><strong id="prog_num">0</strong>%</span>
						</div>
						<div style="clear: both"></div>
					</div>
					<div id="lstAttachLink" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="height: 100px;border: 1px solid #3C2F2E;overflow: auto;">
						<div id="addFile" style="color: #818181;padding-left: 10px;padding-top: 10px;">
						<img src="/images/plus1600.png" style="height:24px;width:24px;vertical-align:middle" onclick="uploadbtn()">
						Add Files
						</div>
					</div> 
					<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width: 1px; height: 1px" /> 
					<input type="hidden" onclick="fileupload()"/>
				</td>
			</tr>
			
		</table> 
		
			    <!------------Answer option---------------->
		<table class="content" style="width: 100%;"> 
			<tr>
				<td style="padding-left: 0px;">
					<ul id="columnsbnk" >
						<li>
							<span>1</span>
							<input type="text" value=""	placeholder="New option" id="option1" name="option1" oninput="checkOptionsList();">
							<img src="/images/sortIcon.png" class="drag_drop">
						</li>
						<li>
							<span>2</span>
							<input type="text" value="" placeholder="New option" id="option2" name="option2" oninput="checkOptionsList();">
							<img src="/images/sortIcon.png" class="drag_drop">
						</li>
						<li>
							<span>3</span>
							<input type="text" value=""	placeholder="New option" id="option3" name="option3" oninput="checkOptionsList();">
							<img src="/images/sortIcon.png" class="drag_drop">
						</li>
					</ul>
				</td>
			</tr>
		</table>

		<button type="button" id="addOpt" onclick="javascript:addOption();">New	option</button>

		<table class="content" style="width: 100%;"> 
			<tr>    <!------------Question setting---------------->
				<td>
				<div class="qstSetting">
					<input id="multipleCheck" type="checkbox" checked> <span>Allow
						multi-select</span>
				</div>
				<div id="numberOfMultiSelect">
					Maximum multi-select <select id="myList">
						<option value="1">Unlimited</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
					</select>
				</div>
				<div class="qstSetting">
					<input id="seeResultFirst" type="checkbox" checked> 
					<span>See Result Before Voting</span>
				</div>
					<div class="qstSetting">
					<input id="anonymousVote" type="checkbox">
					<span>Allow secret voting</span>
				</div>
				
				<div class="qstSetting">
					<input id="endDate" type="checkbox">
					<span>Set End Date</span>
				</div>		
	
				
				<div id="_dateTimePicker">		
					<span>Start Date</span>			
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly" >
					<select id="sTimePicker"></select>
					<span>End Date</span>
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly" >
					<select id="eTimePicker"></select>						
				</div>
	
				<div id="target_select">
					<span>Select target</span>
					<select id="set_Target">
						<option value="0" selected="selected"><spring:message code="ezQuestion.t251" /></option>
						<option value="1"><spring:message code="ezQuestion.t252" /></option>
					</select>	
					<a class="imgbtn" id="receiverBttn"><span onclick="menu_SelectRange();">Receivers</span></a>																		
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
					
				</div>
				</td>
			</tr>						
		</table> 
		
		<div class="button" style="padding-top: 20px;">				
			<a class="imgbtn" onclick="fun_OK()" style="padding-right: 25px;"><span><spring:message code="ezQuestion.t484" /></span></a>				
			<a class="imgbtn" onclick="fun_Cancel()"><span><spring:message code="ezQuestion.t38" /></span></a>				
		</div>
			
	</form>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.5); display: none;"	id="mailPanel">&nbsp;</div>
	<div class="layerpopup"	style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />"style="border: none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>