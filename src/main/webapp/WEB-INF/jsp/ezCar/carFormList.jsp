<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
        <link rel="stylesheet" href="${util.addVer('/css/olstyle_nonIE.css')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/css/ezSchedule/Calendar_cross.css')}" type="text/css" />
        <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
        	var UserOffset = "<c:out value='${pOffset}'/>";
        </script>      
        <script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>        
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<!-- 2018-11-05 김혜정 -->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarDataPro_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezCar/CalendarView_Cross.js')}"></script>
	    <!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<%-- <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script> --%>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- 2018-06-12 구해안 -->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/monthpicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<style type="text/css">
 		.ui-monthpicker>.ui-datepicker-header>.ui-datepicker-title>.ui-datepicker-year{ 
 			margin: 0 auto; 
 		}  
				
 		.ui-monthpicker>.ui-datepicker-header>.ui-datepicker-title>.ui-datepicker-month { 
 		  display: none; 
 		} 
 		
		.ui-monthpicker td span {
		  padding: 5px;
		  cursor: pointer;
		  text-align: center;
		}		
		.chk_noneDisplay {
			display:none;
		}
		
		</style>
		<script type="text/javascript">	
			var pBrdid = "<c:out value='${carID}'/>";
	    	var pBrdnm = "<c:out value='${carName}'/>";
	    	var pAccessCode = "<c:out value='${accessCode}'/>";
	    	var pCompanyID = "${companyID}";
	    	var pUserID = "${userID}";
	    	var pDeptID = "${deptID}";
	    	var pAdminFg = "${adminFg}";
		   // var folder_Url = "/ezResource/scheduleGet.do";
		    var p_Type = "MAIN";
	    	var title_name = new Array();
	    	//var pBrdCount = "${brdCount}";
	    	//var pChildBrd = "${childBrd}";
		    var Mod = "";
		    var pUse_Editor = "${useEditor}";
		    //var pStartday = "${startDay}";		
		    //var lunarUseFlag = "${lunarUseFlag}";
		    //var lunarUse = "${lunarUse}";
		    /* select_memorialDays("${lang}"); */
		    var dayView = "";
		   // var TotalCnt = ${TotalCnt};
	    	 /* 2019-01-11 김민성 - 접근 권한 없는 경우 메시지 출력 수정 */
	    	var objChk = document.getElementsByTagName("INPUT");
		    if(pAdminFg == "") {
		    	var msg = "<spring:message code='ezResource.t58' />";
		        window.location.href = "/ezResource/nonResList.do?msg=" + encodeURIComponent(msg);
		    }
	    	 
		    /* window.onload = function () { 
		    	document.getElementById("TitleInfo").innerHTML = " - [" + strLang1002 + "<span class='txt_color' style='font-weight:bold;'> " + TotalCnt + " </span>" + strLang1003 + "]";
		    
		    } */
		    $('.ui-datepicker-trigger').click(function(){
		    	$('.ui-datepicker-month').css('display','none');
		    });
		    		    
	    	function btnAdd_Click() {
		        if (CheckAdmin() == false) {
		            alert("<spring:message code="ezResource.t345" />");
	    	        return;
	        	}

	        	var pURL;
	        	pURL = "/ezCar/addClsItem.do?carID=" + pBrdid
	        	var openLocation = pURL;
	        	openwindow(openLocation, "", 580, 450);
	    	}
	    	
	    	
	    	
	    	function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
		        try {
		            var heigth = window.screen.availHeight;
	    	        var width = window.screen.availWidth;
	        	    var left = 0;
	            	var top = 0;

		            if (window.screen.width > 800) {
		                var pleftpos;
		                var pheightpos;
	    	            pleftpos = parseInt(width) - 700;
	        	        pheightpos = parseInt(heigth) - 350;
	            	    width = parseInt(width) - pleftpos;
	                	heigth = parseInt(heigth) - pheightpos;
	                	left = pleftpos / 2;
	                	top = pheightpos / 2;
	            	} else {
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - 10;
		            }

	    	        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

		        } catch (e) {
		            alert("openwindow :: " + e.description);
	        	}
	    	}
	    	
	   	function RefreshPageDoc() {
	        	//window.parent.left.location.href = "/ezCar/leftCar.do?flag=SELECT_NO";
	        	window.parent.right.location.reload();
	    	}
	    	
	 		$(window).on("resize", function(){
				var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;	        	
     			$("#CarInfo").css("left", popupX);
     		});
	  
	 		
	 
	        
        		
	    	function btnDelete_Click() {
	    		var strListInfo = "";
				var checkId = $("input[name=chk]:checked");
				if (CheckAdmin() == true) {  //관리자라면
	
					if(checkId.length == 0){
			    		 alert("<spring:message code='ezCar.shb52' />");
				         return;
			    	}
			        var objChk = document.getElementsByName("chk");
			       
					for(var i=0; i<$("input[name=chk]:checked").length; i++){
					    strListInfo += $("input[name=chk]:checked")[i].value;
					    strListInfo += ";";
					}
					console.log('strListInfo : ' + strListInfo);
					var count = $("input[name=chk]:checked").length;
				
			        		
					if (!confirm(count + "<spring:message code='ezCar.shb53' />"))
					   return; 
	
					 $.ajax({
					    	type : "POST",
					    	dataType : "html",
					    	async : false,
					    	data : {
					    		car_form_id : strListInfo,
					    		carID : pBrdid
					    	},
					    	url : "/ezCar/deleteCarForm.do",
					    	success: function(text){
					    	alert(count + "<spring:message code='ezCar.shb54' />");
					    	carFormListLoad(document.getElementById('calTitle').innerText);
					    	//window.location.reload(false);

					    	},
					    	error: function(err){
					    		alert("<spring:message code='ezCar.shb55' />");
					    	}
					  });
	        	}else{ //관리자가 아니라면
	        		
					for(var i=0; i<checkId.length; i++){
						if(checkId[i].parentNode.parentElement.children[4].innerText != pUserID){
							alert("<spring:message code='ezCar.shb56' />");
							return;
						}
					}
	
					if(checkId.length == 0){
			    		 alert("<spring:message code='ezCar.shb52' />");
				         return;
			    	}
			        var objChk = document.getElementsByName("chk");
			       
					for(var i=0; i<$("input[name=chk]:checked").length; i++){
					    strListInfo += $("input[name=chk]:checked")[i].value;
					    strListInfo += ";";
					}
					console.log('strListInfo : ' + strListInfo);
					var count = $("input[name=chk]:checked").length;
				
			        		
					if (!confirm(count + "<spring:message code='ezCar.shb53' />"))
					   return; 
	
					 $.ajax({
					    	type : "POST",
					    	dataType : "html",
					    	async : false,
					    	data : {
					    		car_form_id : strListInfo,
					    		carID : pBrdid
					    	},
					    	url : "/ezCar/deleteCarForm.do",
					    	success: function(text){
					    	alert(count + "<spring:message code='ezCar.shb54' />");
					    	carFormListLoad(document.getElementById('calTitle').innerText);
						    //window.location.reload(false);
					    	},
					    	error: function(err){
					    		alert("<spring:message code='ezCar.shb55' />");
					    	}
					  });
	        	} 
	    	}
	    	
	    	function carFormListLoad(date){
	    		$.ajax({
	    			type : "GET",
	    			async : false,
	    			url : "/ezCar/carFormListAjax.do",
	    			dataType : "json",
	    			data : {
	    				date : date,
	    				carID : pBrdid
	    			},
	    			success : function(result) {
	    				boardList = "<table class='mainlist' style='width:100%; min-width:700px;'>";
	    				boardList += "<tr>";
	    			    boardList += "<th style='padding:0px; width:30px'><input type='checkbox' name='checkbox' onClick='reverse(this.checked)' id='Checkbox1'></th>";
	    			    boardList += "<th> <spring:message code='ezCar.shb57'/></th>";
	    			    boardList += "<th style='width:100px'> <spring:message code='ezCar.shb30'/></th>";
	    			    boardList += "<th style='width:120px'> <spring:message code='ezCar.shb58'/></th>";
	    			    boardList += "<th style='display:none; width:120px'><spring:message code='ezCar.shb59'/></th>";
	    			    boardList += "<th style='width:120px'> <spring:message code='ezCar.shb60'/></th>";
	    			    boardList += "</tr>";
	    				list = result.carFormList;
	    					if(list.length > 0){
	    						list.forEach(function(vo,index){
	    							boardList += "<tr>";
	    							boardList += "<td style='padding:0;'><input type='checkbox' name='chk' id='chk' value='"+vo.car_form_id+"'></td>";
	    							boardList += "<td ondblclick='Item_View("+vo.car_form_id+");' style='cursor: pointer; word-wrap:break-word;' align='left'>";
	    							var revdate = vo.rev_date;
	    							revdate = revdate.substring(0,7);
	    							boardList += vo.register_name+"_"+revdate+"<spring:message code='ezCar.shb61'/>";
	    							boardList += "</td>";
	    							boardList += "<td id='dept_name' style='word-wrap:break-word;'>"+vo.register_deptname+"</td>";
	    							boardList += "<td id='register_name' style='word-wrap:break-word;'>"+vo.register_name+"</td>";
	    							boardList += "<td id='register_id' style='display:none; word-wrap:break-word;'>"+vo.register_id+"</td>";
	    							boardList += "<td id='register_date' style='word-wrap:break-word;'>"+vo.register_date+"</td>";
	    							boardList += "</tr>"
	    						});
	    					}
	    					else{
	    						boardList += "<tr>";
	    						boardList += "<td colspan='5' style='text-align: center'><spring:message code='ezCar.shb62'/></td>";
	    						boardList += "</tr>"
	    					}
	    				boardList += "</table>";
	    				$('#carList').html("");
	    				$('#carList').append(boardList);
	    				
	    			}
	    		});
	    	}
	    	
	    	function btnView_Car() {
		        if (CheckAdmin() == false) {
		            alert("<spring:message code="ezResource.t345" />");
	    	        return;
	        	}
	    		var strListInfo = "";
				var checkId = $("input[name=chk]:checked");
		    	
		    	if(checkId.length == 0){
		    		 alert("<spring:message code='ezCar.shb63'/>");
			         return;
		    	}
		    	
		    	if(checkId.length > 1){
		    		 alert("<spring:message code='ezCar.shb64'/>");
			         return;
		    	}
		    	
		        var objChk = document.getElementsByName("chk");
		       
				for(var i=0; i<$("input[name=chk]:checked").length; i++){
				    strListInfo = $("input[name=chk]:checked")[i].value;
				}
				Item_View(strListInfo);
	    	}

		    function CheckAdmin() {
		        if (pAdminFg == "Y")
	    	        return true;
	        	else
		            return false;
		    }

		    function Item_View(car_form_id) {
		        pURL = "/ezCar/viewFormItem.do?carID=" + pBrdid +"&car_form_id=" +car_form_id;
		        var openLocation = pURL;
	        	openwindow4(openLocation, "", 3000, 800);
	            objChk[intChkNum].checked = false;
	    	}
		    
	    	
	    	// 2018-10-19 김민성 - 작성자 이름 클릭 시 사원정보보기 팝업
			function OpenUserInfo(userID, deptID) {
	        	var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + userID + "&dept=" + deptID, "", feature);
	        }
	    	
			 $(function () { 
				
		    	CalendarView("Calendar");
		    	 $.datepicker.regional["<spring:message code='main.t0619' />"] = {
				            closeText: "<spring:message code='main.t3' />",
				            prevText: "<spring:message code='main.t0604' />",
				            nextText: "<spring:message code='main.t0605' />",
				            currentText: "<spring:message code='main.t0606' />",
				            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                       "<spring:message code='main.t0627' />"],
				            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
						                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
						                       "<spring:message code='main.t0627' />"],
				            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                       "<spring:message code='main.t0627' />"],
				            weekHeader: "Wk",
				            dateFormat: "yy-mm-dd",
				            firstDay: 0,
				            isRTL: false,
				            duration: 200,
				            showAnim: "show",
				            showMonthAfterYear: true
				        };
				        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
				        
				       
			 }); 
			 
			 
			 function btn_Car_Diary(carID) {
			       /*  if (CheckAdmin() == false) {
			            alert("<spring:message code="ezResource.t345" />");
		    	        return;
		        	} */

		        	var pURL;
		        	pURL = "/ezCar/carDiary.do?carID=" + pBrdid
		        	var openLocation = pURL;
		        	openwindow2(openLocation, "", 3000, 200);
		    	}
		    	
			    function openwindow2(wfileLocation, wName, wWeigth, wHeigth) {
			        try {
			            var heigth = window.screen.availHeight;
		    	        var width = window.screen.availWidth;
		        	    var left = 0;
		            	var top = 0;
		            	

			             if (window.screen.width > 800) {
			                var pleftpos;
			                var pheightpos;
		    	            pleftpos = parseInt(width) - 1750;
		        	        pheightpos = parseInt(heigth) - 960;
		            	    width = parseInt(width) - pleftpos;
		                	heigth = parseInt(heigth) - pheightpos;
		                	left = pleftpos / 2;
		                	top = pheightpos / 2;
		                	
			            		
		            	} else {
			                heigth = parseInt(heigth) - 30;
			                width = parseInt(width) - 10;
			            } 

		    	        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,scrollbars =0,status=0,menubar=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

			        } catch (e) {
			            alert("openwindow :: " + e.description);
		        	}
		    	}
			    
			    
			    function openwindow3(wfileLocation, wName, wWeigth, wHeigth) {
				        try {
				            var heigth = window.screen.availHeight;
			    	        var width = window.screen.availWidth;
			        	    var left = 0;
			            	var top = 0;

				            if (window.screen.width > 800) {
				                var pleftpos;
				                var pheightpos;
			    	            pleftpos = parseInt(width) - 700;
			        	        pheightpos = parseInt(heigth) - 350;
			            	    width = parseInt(width) - pleftpos;
			                	heigth = parseInt(heigth) - pheightpos;
			                	left = pleftpos / 2;
			                	top = pheightpos / 2;
			            	} else {
				                heigth = parseInt(heigth) - 30;
				                width = parseInt(width) - 10;
				            }

			    	        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

				        } catch (e) {
				            alert("openwindow :: " + e.description);
			        	}
			    	}
			    
			    
			    function openwindow4(wfileLocation, wName, wWeigth, wHeigth) {
			        try {
			            var heigth = window.screen.availHeight;
		    	        var width = window.screen.availWidth;
		        	    var left = 0;
		            	var top = 0;
		            	

			             if (window.screen.width > 800) {
			                var pleftpos;
			                var pheightpos;
		    	            pleftpos = parseInt(width) - 1700;
		        	        pheightpos = parseInt(heigth) - 960;
		            	    width = parseInt(width) - pleftpos;
		                	heigth = parseInt(heigth) - pheightpos;
		                	left = pleftpos / 2;
		                	top = pheightpos / 2;
		                	
			            		
		            	} else {
			                heigth = parseInt(heigth) - 30;
			                width = parseInt(width) - 10;
			            } 

		    	        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,scrollbars =0,status=0,menubar=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

			        } catch (e) {
			            alert("openwindow :: " + e.description);
		        	}
		    	} 
			    function btn_Mod_Car_Diary() {
		        	var i, intChkCnt = 0;
		            var chkValue = [];
		        	var objChk = document.getElementsByTagName("INPUT");
		        	for (i = 0; i < objChk.length; i++) {
		            	if (objChk[i].name == "chk" && objChk[i].checked == true) {
		                	intChkCnt = intChkCnt + 1;
		                	var intChkNum = 0;
		                	var car_form_id = objChk[i].value;
		                	chkValue.push(i);
		            	}
		        	}
		        	if (CheckAdmin() == true) {  //관리자라면
		        		
		        		if (intChkCnt == 0) {
				            alert("<spring:message code='ezCar.smb08' />");
				            return;
				        } else if (intChkCnt > 1) {
			    	        alert("<spring:message code='ezCar.shb65'/>");
			    	        return;
			        	}else if (intChkCnt = 1) {
				        	var pURL;
				        	pURL = "/ezCar/modifycarDiary.do?carID=" + pBrdid +"&car_form_id=" +car_form_id;
				        	var openLocation = pURL;
				        	openwindow2(openLocation, "", 3000, 800);
				            objChk[intChkNum].checked = false;
				        }
		        	}else{ //관리자가 아니라면


				        if (intChkCnt == 0) {
				            alert("<spring:message code='ezCar.smb08' />");
				            return;
				        } else if (intChkCnt > 1) {
			    	        alert("<spring:message code='ezCar.shb65'/>");
			    	        return;
			        	} else if(objChk[chkValue[0]].parentNode.parentElement.children[4].innerText != pUserID){
			        		alert("<spring:message code='ezCar.shb66'/>")
			        		return;
			        	}else if (intChkCnt = 1) {
				        	var pURL;
				        	pURL = "/ezCar/modifycarDiary.do?carID=" + pBrdid +"&car_form_id=" +car_form_id;
				        	var openLocation = pURL;
				        	openwindow2(openLocation, "", 3000, 800);
				            objChk[intChkNum].checked = false;
				        }
		        	}

		    	}
			    
			    
			// 예약현황조회
			    function btn_Rev_List() {
			    	var yearMonth = document.getElementsByName("datePick")[0].value;
					yearMonth = yearMonth.slice(0,7);
					
		        	var pURL;
		        	pURL = "/ezCar/carRevItem.do?carID=" + pBrdid + "&date=" + encodeURI(yearMonth);
		        	var openLocation = pURL;
		        	openwindow3(openLocation, "", 580, 450);
		    	}
			    
			    function btnExcel_onclick() {
			    	if(list.length == 0){
			    		alert("<spring:message code='ezCar.shb67'/>");
			    	}
			    	var yearMonth = document.getElementsByName("datePick")[0].value;
					yearMonth = yearMonth.slice(0,7);
			        var url;
			        url = "/ezCar/excelExportOut.do";
				    url += "?yearMonth=" + encodeURI(yearMonth) + "&carID=" +
				             encodeURI(pBrdid);
			        window.frames["saveExcel"].location.href = url;
			    }
			    
			    function reverse(chkedVal) {
			        var i;
			        var objChk = document.getElementsByTagName("INPUT");

		        	if (objChk.length == undefined) {
		            	objChk.checked = chkedVal;
		        	} else {
			            for (i = 0; i < objChk.length; i++) {
			                if (document.getElementsByTagName("INPUT")[i].name == "chk") {
			                    document.getElementsByTagName("INPUT")[i].checked = chkedVal;
		    	            }
		        	    }
		        	}
		    	}	
			    
			    
		</script>
	</head>
	<body class="mainbody" style="overflow:hidden; padding-right: 6px;">
		<!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
		<h1 style="text-overflow:ellipsis;overflow:hidden;white-space:nowrap;"><c:out value='${carName} ( ${car_nm} )'/><span id="TitleInfo"></span></h1>
		<div id="mainmenu" onload = "makePageSelPage()">
            <ul class="on">
            	
              	<!-- <span id = "noResListSpan"> -->
              		<%-- <li style="background:none;float:right;cursor:default;border:0px;color:#393939">&nbsp;<img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t369" /></li>
					<li style="background:none;float:right;cursor:default;border:0px;color:#393939"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t370" /></li> --%>
				<!-- </span> -->
            </ul>
		</div>
		<!-- <div class="calendar_pagenav" id="weeklyline">
	        <ul class="contentlayout">
	            <li class="contentlayout_left" id="preM"><span class="icon16 calendarleft" onclick="pagenavi('PREV');"></span></li>
	            <li class="contentlayout_right" id="preN"><span class="icon16 calendarright" onclick="pagenavi('NEXT');"></span></li>
	            <li class="contentlayout_none"><span class="spanText" id="divViewHeader"></span>
	            </li>
	        </ul>
	    </div> -->
	    <div class="calendar_pagenav">
	        <ul class="contentlayout">
	            <li class="contentlayout_left" id="preM"></li>
	            <li class="contentlayout_right" id="preN"></li>
	            <li class="contentlayout_none"><span class="spanText" id="calTitle"></span>
	            </li>
	        </ul>
	    </div>

	    <%-- <div class="mainmenuTab" id="noResListSpan">
	    	<ul class="mainmenuTabUL_left">  <li><span class="sub_iconLNB tree_resource_ok"></span><spring:message code='ezResource.t191'/></li><li><span class="sub_iconLNB tree_resource_no"></span><spring:message code='ezResource.kmsr21'/></li> <li><span class="sub_iconLNB tree_resource_refuse"></span><spring:message code='ezResource.kmsr22'/></li> </ul>
	        <ul class="mainmenuTabUL">
	            <li id="ToDaybtn" class="off"><span onClick="setweek_onload('TODAY');"><spring:message code='ezSchedule.t140'/></span></li><li id="Weekbtn" class="on"><span onClick="setweek_onload('WEEK');"><spring:message code='ezSchedule.t141'/></span></li>
	        </ul>
	    </div> --%>
		<%-- <div id="mainmenu" onload = "makePageSelPage()">
  			<ul>
    			<c:if test="${adminFg eq 'Y'}">
    				<li><span onClick="btnAdd_Click();"><spring:message code="ezResource.t363" /></span></li>	
    				<li><span onClick="btnView_Resource();"><spring:message code="ezResource.t17" /></span></li>
    				<!-- <li id="tbar2" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif"></li> -->
    			</c:if>
    			<span id = "noResListSpan">
    			<li id="ToDaybtn"><span onClick="setweek_onload('TODAY');"><spring:message code="ezResource.t251" /></span></li>
    			<li id="Weekbtn"><span onClick="setweek_onload('WEEK');"><spring:message code="ezResource.t253" /></span></li>
    			<!-- 2018-06-05 구해안 허가,비허가 오른쪽으로 ui 수정 -->
				<li style="background:none;float:right;cursor:default"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t370" /></li>
      			<li style="background:none;float:right;cursor:default"><img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t369" /></li>
  				</span>
  			</ul>
		</div> --%>
		
		<script type="text/javascript">
    		//selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div style="overflow:auto; width:99.5%; height:800px;">
		 <table>   
			<tr>
				<td style="vertical-align:top;width:100%;">
					<DIV  style="vertical-align:top;" id="Calendar"></DIV>
				</td>
                <td style="vertical-align:top;width:10px">&nbsp;</td>
			</tr>
		</table>
		<%-- <div>
				 <li><span onClick="btn_Car_Diary();"><spring:message code="ezCar.smb02" /></span></li>
			</div> --%>
			<div id="mainmenu" onload="makePageSelPage()">
            <ul class="on">
            		 <li><span onClick="btn_Rev_List();"><spring:message code="ezCar.smb16" /></span></li>
    				 <li><span onClick="btn_Car_Diary();"><spring:message code="ezCar.smb02" /></span></li>
    				  <li><span onClick="btn_Mod_Car_Diary();"><spring:message code="ezCar.smb03" /></span></li> 
    				  <li class="off"><span class="icon16 icon16_delete" onclick="btnDelete_Click();"></span></li>       	
              		<li><span onClick="btnExcel_onclick();"><spring:message code="ezCar.smb04" /></span></li> 
            </ul>
		</div>
		<div id="carList"> 
    	<table class="mainlist" style="width:100%; min-width:700px;">
	  			<tr>
	    			<th style="padding:0px; width:30px"><input type="checkbox" name="checkbox" onClick="reverse(this.checked)" id="Checkbox1"></th>
	    			<th><spring:message code='ezCar.shb57'/></th>
	    			<th style="width:100px"><spring:message code='ezCar.shb30'/></th>
	    			<th style="width:120px"><spring:message code='ezCar.shb58'/></th>
	    			<th style="display:none; width:120px"><spring:message code='ezCar.shb59'/></th>
	    			<th style="width:120px"><spring:message code='ezCar.shb60'/></th>		
	  			</tr>
				 <c:if test="${!empty carFormList}" >
					<c:forEach var="list"  items="${carFormList}" begin="${start}" varStatus="value">
	  					<tr>
	    					<td style="padding:0;"><input type="checkbox" name="chk" id="chk" value="${list.car_form_id}"></td>
							<td ondblclick="Item_View('${list.car_form_id}');"	style="cursor: pointer; word-wrap:break-word;" align="left">
								${list.register_name}_${fn:substring(list.rev_date,0,7)}<spring:message code='ezCar.shb61'/>
							</td>
							<td id="dept_name" style="word-wrap:break-word;">${list.register_deptname}</td>			
							<td id="register_name" style="word-wrap:break-word;">${list.register_name} </td>			
							<td id="register_id" style="display:none; word-wrap:break-word;">${list.register_id} </td>			
							<td id="register_date" style="word-wrap:break-word;">${list.register_date} </td>		
							
						</tr> 
					</c:forEach>
				</c:if>
				<c:if test="${empty carFormList}">
					<tr>
	    				<td colspan="5" style="text-align: center"><spring:message code='main.t00026' /></td>
	    			</tr>
				</c:if> 
			</table>
		</div>
			</div>		
			
    	<div id="EmptyMsg" style="display:none;">
    	<div class="warningbox">
	        <p class="warningimg"><img src="/images/notify/warning_resorce.png" width="105" height="89"></p>
	        <dl class="warningDL">
	        	<dt>WARNING</dt>
	        	<dd><spring:message code="ezResource.t9900001" /></dd>
	        </dl>
	    </div>
        	<%-- <div class="warningbox01" style="margin-top:155px;">
          		<div class="warningbox02">
  	        		<div class="warnintxt01" >
	        			<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="64" height="64" style="margin: 18px 0px 18px 34px;"></span>
	        			<dl class="warningdl">
	        				<dt><img src="/images/notify/warning01.gif" width="183" height="27"></dt>
	        				<dd>
	        					<spring:message code="ezResource.t9900001" />
	        				</dd>
	        			</dl>
	        		</div>
	        	</div>
        	</div> --%>
        </div>
        <!-- layer 팝업 -->
        <!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
        <%-- <div id="ResourceInfo" style="display: none; max-width: 700px">
        	<div class="popupJQLayer" style="padding-top:6px">
				<div class="title" id="brdNm" style="overflow:hidden; text-overflow:ellipsis; width:650px; white-space:nowrap; margin-bottom:2px;"></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span></span></a></li>
		            </ul>
		        </div>
	        	<table id="resourceDataTable" style="width:680px; /* margin-top:10px; */">
					<tr>
						<th width="22%" style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t153'/></th>
						<td colspan="2"><span id="ownerNm"><span id="ownerInfo" style="cursor:pointer"></span></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.rkms01'/></th>
						<td><span id="submanager"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t155'/></th>
						<td colspan="2"><span id="ownerCall"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t148'/></th>
						<td colspan="2" style="word-break:break-all;" id="resLocation">${resLocation}</td>
					</tr>							
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t149'/></th>
						<td colspan="2" id="approveFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.kmsr11'/></th>
						<td colspan="2" id="returnFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezBoard.t5007'/></th>
						<td colspan="2"><span id="resDate"></span></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code="ezPortal.t202"/></th>
						<td style="width:39%; border-right: 0"><img id="preview1" name="preview" src="/images/default_pic.jpg" width="120" height="120" alt="" border="0" style="margin-left: auto; margin-right: auto; display: block; border-right: 0px;"></td>
						<td style="border-left: 0"><img id="preview2" name="preview" src="/images/default_pic.jpg" width="120" height="120" alt="" border="0" style="margin-left: auto; margin-right: auto; display: block;"></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code='ezResource.t271'/></th>
						<td colspan="2"><div style="overflow-y: auto; height: 200px; word-break:break-all; white-space:pre-wrap;" id="brdExplain"></div></td>
					</tr>
	         	</table>
	         </div>	
        </div> --%>
        <iframe id="saveExcel" name="saveExcel" style="display: none" ></iframe>
	</body>
</html>
