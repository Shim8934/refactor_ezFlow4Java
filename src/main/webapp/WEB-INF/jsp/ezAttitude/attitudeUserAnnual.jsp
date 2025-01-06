<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
		<style>
			#attiStatis table td {
				color : #777;
				font-size : 13px;
				text-align : center;
				border : 1px solid #dedede;
			}
			#attiStatis {
				border : 1px solid #dedede;
			}
			.statsP {
				text-align: center;
    			border: 0px;
    			text-decoration: none;
    			font-weight: normal;
    			color: #333;
    			font-size: 12px;
/*     			border-top: 1px solid #e2e3e6; */
    			border-bottom: 1px solid #e2e3e6;
    			background-color: #f1f3f5;
    			height: 23px;
    			margin-top: 0px;
  				margin-bottom: 0px;
    			padding-top: 8px;
    			padding-bottom: 8px;
    			padding-left: 4px;
    			height: 17px;
    			width: 151px;
			}
			dl {
				display: inline-block;
			}
			.time_stats .statsUL {
/* 				border-left: 1px solid #eaeaea; */
				margin: 0px 0px 0px 0px;
    			padding: 0px 0px;
    			list-style: none;
    			box-sizing: border-box;
			}
			.time_stats .statsUL li .statsDL {
			    margin: 0px;
			    padding: 5px 10px;
			    overflow: hidden;
			    /* border-bottom: 1px solid #f1f1f1; */
			    box-sizing: border-box;
			    height: 40px;
			}
			.time_stats .statsUL li .statsDL dt {
			    margin: 0px;
			    float: left;
			    font-family: malgun gothic, Meiryo UI;
			    font-size: 12px;
			    color: #000;
			    padding: 4px 0px 0px 21px;
			}
			.time_stats .statsUL li .statsDL dd {
			    margin: 0px;
			    padding: 2px 5px;
			    float: right;
			    font-size: 12px;
			    color: #0470e4;
			    font-family: malgun gothic, Meiryo UI;
			    font-weight: bold;
			    height: 21px;
			    line-height: 21px;
			    box-sizing: border-box;
			    /* background: rgb(243, 245, 247); */
			    /* border: 1px solid #c8ccd0; */
			    border-radius: 25px;
			    -webkit-border-radius: 25px;
			    -moz-border-radius: 20px;
			}
			.timecheck_info .timeInfo {
				float: left;
				position: static;
				margin-right: 20px;
				margin-top: 20px;
			}
			.countDL {
				margin: 35px 0px 0px 0px;
			}
			.mainlist th, td{
			    overflow: hidden;
			    text-overflow: ellipsis;
			    white-space: nowrap;
			}
			.mainlist tr:hover{
				background : rgb(244,245,245);
				cursor : pointer;
			}
		</style>	
	    <script type="text/javascript">
	    	var date = new Date()
        	var year = date.getFullYear(); //현재년도
        	var todayMonth = (date.getMonth() + 1); //현재년도
        	var todayDate = date.getDate(); //현재년도
        	var selyear = year; //선택한 년도
	    	var companyId = "<c:out value="${companyId}" />";
	    	var userId = "<c:out value="${userId}" />";
	    	var useAnnualAutoGnrt = "<c:out value="${annualconfig.useAnnualAutoGnrt}" />";
	    	var annualGnrtStd = "<c:out value="${annualconfig.annualGnrtStd}" />";
	    	var initialDate = "<c:out value="${annualconfig.initialDate}" />";
	    	var joinDate = "<c:out value="${joinDate}" />";
	    	var userDeptId;
	    	var userDeptName;
	    	var yearLength = Number(year) - Number(joinDate.split("-")[0]) + 1;
	    	var orderCell = ""; //정렬 명
	    	var orderOption = ""; //정렬 형식(ASC, DESC)
   			var src = "";
	    	var selAttitudeId = "";
	    	var holiDays = new Array();
	    
	    	$(document).ready(function() {
    			if(joinDate == null || joinDate == "" || joinDate == "0") {
           			joinDate = "0000-01-01";
           			yearLength = 20;
           		}
	    		//헤더 클릭 시 정렬
	    		$(document).on('click', '.mainlist th', function(){
	    			if ($(this).attr("colname") != "") {
	    				if (!$(this).find("img").length) { // 새로운 th를 클릭한 경우
	    					src = "";
	    					orderOption = "";
	    					orderCell = $(this).attr("colname");
	    				}
	    			
		    			if (orderOption == "" || orderOption == "DESC") {
		    				src = '/images/etc/view-sortup.gif';
		    				orderOption = "ASC";
		    			} else {
		    				src = '/images/etc/view-sortdown.gif';
		    				orderOption = "DESC";
		    			}
		    			
		    			$(".mainlist th").find("img").remove();
		    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
	    			}
	    			getUserAnnualList();	    		
	    		});
	    		
	    		makeoptionyear();
	    		getUserAnnualList();
	    		
	    		var height = parseInt(document.documentElement.clientHeight - 235);
	        	$("#contentlist").css("height", height +"px");
   			});
	    	
	    	$(window).on("resize", function() {        	
	        	//테이블 리스트 resize조정.
	        	var height = parseInt(document.documentElement.clientHeight - 235);
	        	$("#contentlist").css("height", height +"px");
	        });
	    	
    		$(document).on('click', '.mainlist > tr', function(){
    			$(".mainlist > tr").attr("style","background-color:;");
    			$(this).attr("style","background-color:rgb(241,245,255);");
    			
    		})
    		
    		function caldate(date, day){
 
 				var caledmonth, caledday, caledYear;
 				var loadDt = date;
 				var v = new Date(Date.parse(loadDt) - day*1000*60*60*24);
 
 				caledYear = v.getFullYear();
 
			 	if ( v.getMonth() < 9 ){
			  		caledmonth = '0'+(v.getMonth()+1);
			 	} else {
			  		caledmonth = v.getMonth()+1;
			 	}
			 	if ( v.getDate() < 9 ){
			  		caledday = '0'+v.getDate();
			 	} else {
			  		caledday = v.getDate();
			 	}
			 	return caledYear+'-'+caledmonth+'-'+caledday;
			}
    		
	    	//년도 selectBox
	    	function makeoptionyear() {
	            var tempyear = year;
	            var startDate = "";
	            var endDate = "";
	    		
				if ($("#searchYear").val() == null || $("#searchYear").val() == "") {
					selyear = year;
	    		}

	    		if ($("#searchYear").val() != null && $("#searchYear").val() != "") {
	    			selyear = Number($("#searchYear").val());
	    			tempyear = year;
	    		}
		        
                if (tempyear <= year || selyear == year) {
		    		//초기화
		    		$("#searchYear").html("");
		    		
		    		var optionHtml = "";
	                for (var i = 0; i < yearLength; i++) {
	                	optionHtml += "<option value='" + tempyear + "' ";
	                	if (annualGnrtStd == 1) {
	                		if(initialDate.substring(5, 7) < todayMonth || (initialDate.substring(5, 7) == todayMonth && initialDate.substring(8, 10) < todayDate)) {
	                			startDate = tempyear + "-" + initialDate.substring(5, 10);
	                			endDate = caldate(new Date(tempyear + 1, initialDate.substring(5, 7) - 1, initialDate.substring(8, 10)), 1);
	                		} else {
	                			startDate = (tempyear - 1) + "-" + initialDate.substring(5, 10);
	                			endDate = caldate(new Date(tempyear, initialDate.substring(5, 7) - 1, initialDate.substring(8, 10)), 1);
	                		}
	                		optionHtml += "startDate='" + startDate + "' endDate='" + endDate + "'>";
		                	optionHtml += startDate + " ~ " + endDate + "</option>";
	                	} else {
	                		if(joinDate.substring(5, 7) < todayMonth || (joinDate.substring(5, 7) == todayMonth && joinDate.substring(8, 10) < todayDate)) {
	                			startDate = tempyear + "-" + joinDate.substring(5, 10);
	                			endDate = caldate(new Date(tempyear + 1, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10)), 1);
	                		} else {
	                			startDate = (tempyear - 1) + "-" + joinDate.substring(5, 10);
	                			endDate = caldate(new Date(tempyear, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10)), 1);
	                		}
	                		optionHtml += "startDate='" + startDate + "' endDate='" + endDate + "'>";
		                	optionHtml += startDate + " ~ " + endDate + "</option>";
	                	}
	                	
	                	tempyear--;
	                }
	                $("#searchYear").html(optionHtml);
	                $("#searchYear").val(selyear);
	    		}

	    		//리스트
	    		getUserAnnualList();
	    		//통계
	    		//getMonthlyAnnualList();
	    	}
	    	
	    	//연차 리스트
	    	function getUserAnnualList() {
	    		var startDate = $("#searchYear option:selected").attr("startDate");
	    		var endDate = $("#searchYear option:selected").attr("endDate");
	    		var secondYear = "N";
	    		
    			var startYear = startDate.substring(0, 4);
    			var joinYear = joinDate.substring(0, 4);
    			
    			var startDate2 = new Date(startDate);
    			var endDate2 = new Date(endDate);
    			var joinDate2 = new Date(Number(joinDate.substring(0, 4)) + 1, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10));
    			var joinDate3 = new Date(Number(joinDate.substring(0, 4)) + 2, joinDate.substring(5, 7) - 1, joinDate.substring(8, 10));
	    		if(annualGnrtStd == 0) {
	    			if(startYear - joinYear == 1) {
	    				secondYear = "Y";
	    			}
	    		} else {
	    			if(startDate2 <= joinDate2 && endDate2 >= joinDate2) {
	    				secondYear = "Y";
	    			} else if(startDate2 <= joinDate3 && endDate2 >= joinDate3) {
	    				secondYear = "T";
	    			}
	    		}
	    		
			    $.ajax({
			    	type:"GET",
			       	dataType : "json",
			       	async : false,
			       	url : "/ezAttitude/getHoliDays.do",
			       	data : {
			          	startDate : startDate,
			          	endDate : endDate
			       	},
			       	success : function(result) {
			       		holiDays = [];
			       		result.forEach(function(resultDateStr, index) {
			          		holiDays.push(resultDateStr);
			       		})
			       	},
			       	error : function(jqXHR, textStatus, errorThrown) {
 			  			alert("에러발생! " + jqXHR.status + ", " + jqXHR.readyState);
					}
				})
	    		
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			url : "/ezAttitude/getUserAnnualList.do",
	    			data : {
	   					startDate : startDate,
	   					endDate : endDate,
	   					orderCell : orderCell,
	   					orderOption : orderOption,
	   					secondYear : secondYear
    				},
	    			success : function(result) {
	    				$("#userName").text(result.list[0].userName);
	    				$("#userTitle").text(result.list[0].userTitle);
	    				$("#userDept").text(result.list[0].deptName);
	    				if (result.list[0].imgPath != null && result.list[0].imgPath != "") {
		    				$("#userImage").attr("src","/admin/ezOrgan/getPersonalInfo.do?fileName=" + result.list[0].imgPath);
	    				} 
	    				var totalAnnualCnt = 0;
		    			if (Number(result.list[0].totalAnnualCnt.split(".")[1]) > 0) {
		    				totalAnnualCnt = result.list[0].totalAnnualCnt;
		    			} else {
		    				totalAnnualCnt = result.list[0].totalAnnualCnt.split(".")[0];
		    			}
	    				$("#totalAnnualCnt").text(totalAnnualCnt);
	    				
	    				userAnnualListSet(result.list);
	    				
	    				//스크롤 생길시
	    				if(result.list.length > 15) {
	    		    		var addTh = "<th style='width: 9px;'></th>";
	    		    		$(".mainlist tr th:eq(4)").after(addTh);
	    				}
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			}
	    		});
	    	}
	    	
	    	function getHolidayCnt(startDate, endDate) {
    			var returnCnt = 0;
   		    	var subDate = calDateRange(startDate, endDate);      
   		    	var betweenDate = new Date(startDate);
   		    	for (var i = 0; i <= subDate; i++) {
   		        	betweenDate.setDate(betweenDate.getDate() + (i == 0 ? 0 : 1));
   		         
   		         	var year = betweenDate.getFullYear();
   		         	var month = (betweenDate.getMonth() + 1) + "";
   		         	var date = betweenDate.getDate() + "";
   		         	if(month.length == 1) {
   		            	month = "0" + month;
   		         	}
   		         	if(date.length == 1) {
   		            	date = "0" + date;
   		         	}
   		         
   		         	for (var j = 0; j < holiDays.length; j++) {
   		            	if($.inArray(year + '-' + month + '-' + date,holiDays) != -1) {
   		               		returnCnt++;
 	  		               	break;
   			            } 
   			        }
   		    	}
    			return returnCnt;
	    	}
	    	
	    	/**
	    	* 두 날짜의 차이를 구하는 메소드
	    	* val1 = startDate, val2 = endDate
	    	*/
	    	function calDateRange(val1, val2)
	    	{
	    	   var FORMAT = "-";

	    	   // 년도, 월, 일로 분리
	    	   var start_dt = val1.split(FORMAT);
	    	   var end_dt = val2.split(FORMAT);

	    	   // Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
	    	   start_dt[1] = (Number(start_dt[1]) - 1) + "";
	    	   end_dt[1] = (Number(end_dt[1]) - 1) + "";

	    	   var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
	    	   var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

	    	   return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
	    	}
	    	
	    	function userAnnualListSet(list) {
	    		var html = "";
	    		var accumCnt = 0;
	    		var annualCnt = 0;//연차 수
	    		var morningCnt = 0;//오전반차 수
	    		var afternoonCnt = 0;//오후반차 수
	    		//2020-03-12 김정언
	    		var halfOffCnt = 0; //반반차 수
	    		var i = 1; //NO
	    		
	    		$("#contentlist .mainlist tr").remove();
	    		
	    		if (Number(list[0].annualCnt) > 0) {
		    		list.forEach(function(vo, index) {
		    			var holidayCnt = 0;
		    			if(vo.endDate != null) {
			    			holidayCnt = getHolidayCnt(vo.startDate.substr(0,10), vo.endDate.substr(0,10));
		    			}
		    			var useAnnualCnt = (Number(vo.annualCnt) - (vo.annualApprStatus == -1 ? 0 : holidayCnt));
		    			var content = $.trim($("<p></p>").html(vo.content).text());
		    			html = "<tr id='" + vo.attitudeId + "' typeId='" + vo.typeId + "' ondblclick=attitudeItemView('" + vo.attitudeId + "','" + vo.typeId + "') style='background-color:;'>";
			    		html += "<td style='width:60px'>" + i + "</td>";
			    		html += "<td style='width:25%'>";
		 	    		html += "<a class='link attitudeView'>";
		    			if (vo.typeId === "A11") { //연차
			    			html += vo.startDate.substr(0,10) + " ~ " + vo.endDate.substr(0,10);
			    			annualCnt += useAnnualCnt;
		    			} else if (vo.typeId === "A12") { //오전반차
			    			html += vo.startDate.substr(0,10);
			    			morningCnt += useAnnualCnt;
		    			} else if (vo.typeId === "A13"){ //오후반차
		    				html += vo.startDate.substr(0,10);
		    				afternoonCnt += useAnnualCnt;
		    			} else if (vo.typeId === "A21") { //반반차
		    				html += vo.startDate.substr(0,10) + " ~ " + vo.endDate.substr(0,10);
		    				halfOffCnt += useAnnualCnt;
		    			}
		    			
		    			html += "</a>";
		    			html += "</td>";
		    			html += "<td style='width:15%'>" + vo.typeName + "</td>";
		    			html += "<td style='width:12%'>" + useAnnualCnt + "</td>";
		    			html += "<td style='width:20%'>" + content + "</td>";
		    			if(vo.annualApprStatus == -1) {
			    			html += "<td style='width:12%'>" + "<spring:message code='ezAttitude.t267' />" + "</td>";
		    			} else if (vo.annualApprStatus == 0) {
		    				if(vo.docApprStatus == '005') {
				    			html += "<td style='width:12%'>" + "<spring:message code='ezAttitude.t268' />" + "</td>";
		    				} else if(vo.docApprStatus == '011') {
				    			html += "<td style='width:12%'>" + "<spring:message code='ezAttitude.t269' />" + "</td>";
		    				} else {
				    			html += "<td style='width:12%'>" + "<spring:message code='ezAttitude.t270' />" + "</td>";
		    				}
		    			} else if (vo.annualApprStatus == 1) {
			    			html += "<td style='width:12%'>" + "<spring:message code='ezAttitude.t271' />" + "</td>";
		    			}
		    			if(vo.modAppl == "0") {
		    				if(vo.annualApprStatus == 1) {
			    				html += "<td style='width:12%'><a class='imgbtn' id='mailInBtn' onclick=\"attitudeCancelAnnual('" + vo.attitudeId + "','" + vo.typeId + "')\"><span><spring:message code='ezAttitude.t272' /></span></a>" +"</td>";
		    				} else {
			    				html += "<td style='width:12%'><spring:message code='ezAttitude.t273' /></td>";
		    				}
			    			//html += "<td style='width:12%'><a class='imgbtn' id='mailInBtn' onclick=\"openDraftUI('DRAFT', '" + vo.attitudeId + "')\"><span>취소신청</span></a>" +"</td>";
		    			} else if(vo.modAppl == "4") {
		    				html += "<td style='width:12%'><spring:message code='ezAttitude.t211' /></td>";
		    			} 
						else if(vo.modAppl == "3") {
		    				html += "<td style='width:12%'><a class='imgbtn' id='mailInBtn' onclick=\"attitudeCancelAnnual('" + vo.attitudeId + "','" + vo.typeId + "')\"><span><spring:message code='ezAttitude.t272' /></span></a>" +"</td>";
		    			} 
						else {
		    				html += "<td style='width:12%'><spring:message code='ezAttitude.t209' /></td>";
		    			}
		    			html += "</tr>";
			    		$("#contentlist .mainlist tbody").after(html);
			    		
		    			//누적 연차 수
		    			accumCnt += useAnnualCnt;
		    			i++;
		    		});
	    		} else {
		    			html = "<tr id='List_TR_noItems'>";
			    		html += "<td colspan='5' style='text-align: center'><spring:message code='ezAttitude.t130' /></td>";
		    			html += "</tr>";
			    		$("#contentlist .mainlist tbody").html(html);
	    		}
	    		
	    		$("#accumCnt").text(accumCnt);
	    		$("#remainCnt").text(Number($("#totalAnnualCnt").text()) - accumCnt);	    		
	    		
	    		$("#FA11").text(annualCnt);
	    		$("#FA12").text(morningCnt);
	    		$("#FA13").text(afternoonCnt);
	    		$("#FA21").text(halfOffCnt);
	    	}
	    	
	    	/**
			* 월별 통계
			*/
			function getMonthlyAnnualList() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getMonthlyAnnualList.do",
					data : {
						year : selyear
					},
					success : function(result) {
						getMonthlyAnnualList_After(result);
					}
				})
			}
	    	
	    	/**
			* 월별 통계바 메소드
			*/
			function getMonthlyAnnualList_After(result) {
	    		//초기화
	    		$(".statsP").remove();
	    		$(".statsUL").remove();
	    		
	    		
				//, "height":$("#attiCalendar").css("height")
				var objDiv = $("<div></div>").addClass("time_stats");
				$("#attiStatis").html("");
				var objP = $("<p></p>").addClass("statsP").text("월별통계");
				var objUl = $("<ul></ul>").addClass("statsUL");
				var objLi = $("<li></li>");
				var objDl = "";
				var objDt = "";
				var objDd = "";
				
				objDiv.append(objP);
				for (var i = 0; i < result.length; i++) {
					objDl = $("<dl></dl>").addClass("statsDL");
					objDt = $("<dt></dt>");
					
					objDt.html($("<div style='width:70px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' title='" + result[i].month + "'></div>").html(Number(result[i].month) + "월"));
					objDd = $("<dd></dd>")
					 .text(result[i].annualCount + "일")
					 .attr("id", result[i].month)
					
					objDl.append(objDt);
					objDl.append(objDd);
					objLi.append(objDl);
				}
				
				objUl.append(objLi);
				$("#attiStatis").append(objP);
				$("#attiStatis").append(objUl);				
			}
	    	
			//월별 통계바 슬라이드 이벤트
			function slideTd() {
				if ($("#slideImg").attr("src") == "/images/ImgIcon/slideLeft.png") {
					$("#attiStatis").css("height", "");
					
					$("#attiStatis").animate({
						width: "151px"
					}, 500);
					
					$("#slideBtn").animate({
						right: "147px"
					}, 500, function(){
						$("#slideImg").attr("src", "/images/ImgIcon/slideRight.png");
					});
				} else {
					$("#attiStatis").animate({
						width: "0px"
					}, 500, function(){
						$("#attiStatis").css("height", "0px");
					});
					
					$("#slideBtn").animate({
						right: "2px"
					}, 500, function(){
						$("#slideImg").attr("src", "/images/ImgIcon/slideLeft.png");
					});
				}
			}
	    	
			//엑셀 다운로드
			function exportExcel() {
				if ($('#contentlist table.mainlist tr').eq(0).attr('id') == 'List_TR_noItems') {
					alert("<spring:message code='ezAttitude.t56'/>");
					return;
				}
				
		    	exportExcelframe.location.href="/ezAttitude/excelUserAnnualExport.do?year=" + selyear;
		    	exportExcelframe.target="_blank";
			}
			
			/**
			* [개인근태현황, 부서근태현황] 연차취소신청
			*/
			function attitudeCancelAnnual(attitudeId, typeId) {
				var pAttitudeId = attitudeId; 
				var pTypeId = typeId;
				if (CrossYN()) {
					var OpenWin = window.open("/ezAttitude/attitudeCancelAnnual.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", GetOpenWindowfeature(672, 640));
					
					try { OpenWin.focus(); } catch (e) { }
				} else {
					rtnValue = window.showModalDialog("/ezAttitude/attitudeCancelAnnual.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
				}
			}
			
			/**
			* [개인근태현황, 부서근태현황] 근태상세보기
			*/
			function attitudeItemView(attitudeId, typeId) {
				var pAttitudeId = attitudeId; 
				var pTypeId = typeId;
				if (CrossYN()) {
					var OpenWin = window.open("/ezAttitude/attitudeItemView.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "attitudeItemView", GetOpenWindowfeature(672, 640));
					
					try { OpenWin.focus(); } catch (e) { }
				} else {
					rtnValue = window.showModalDialog("/ezAttitude/attitudeItemView.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
				}
			}
			
			function openDraftUI(pDraftFlag, pSelAttitudeId) {
				selAttitudeId = pSelAttitudeId;
				var windowName = "";
				var formURL = "/fileroot/1/files/upload_approvalG/S907001/form/2019000090.mht";
				var formDocType = "001";

			    var pArgument = new Array();
			    pArgument[0] = userId;
			    pArgument[1] = formURL;
			    pArgument[2] = pDraftFlag;
			    pArgument[3] = formDocType;
			    
			    var openLocation = "";
			    pArgument[4] = "0";
			    pArgument[5] = "";
			    pArgument[6] = "";
			    pArgument[7] = "";
			  
			    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
			    	openLocation = "/ezApprovalG/draftui.do?formURL=";
			        openLocation = openLocation + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
			        openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI("1") + "&aprState=" + encodeURI(pArgument[6]);
			        openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
			        
//			        // FormBuilder
//			        if (window.reformflag == null) {
//			        	// reformflag null 값이라면
//			        	reformflag = GetAttribute(pCurSelRow, "REFORMFLAG");
//			        }
//			        
//			    	if (reformflag.length > 0) {
//			            openLocation += "&reformflag=" + encodeURI(reformflag);
//			    	}
			    } else {
			    	if (!isIE()) {
			            alert("한글양식은 IE에서만 기안 할 수 있습니다.");
			            return;
			        } else {
			        	openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
			            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
			            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
			        }
			    }

			    openwindow(openLocation, windowName, 890, 560);
			}
			
			function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
			    try {
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;

			        var left = 0;
			        var top = 0;

			        if (window.screen.width > 800) {
			            var pleftpos;

			            pleftpos = parseInt(width) - 1150;
			            heigth = parseInt(heigth) - 30;

			            if (CrossYN())
			                heigth = parseInt(heigth) - 25;

			            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
			                heigth = parseInt(heigth) - 40;

			            width = parseInt(width) - pleftpos;

			            left = pleftpos / 2;
			        }
			        else {

			            heigth = parseInt(heigth) - 30;

			            if (CrossYN())
			                heigth = parseInt(heigth) - 25;

			            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
			                heigth = parseInt(heigth) - 40;

			            width = parseInt(width) - 10;
			        }

			        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
			    }
			    catch (e) {
			        alert("openwindow :: " + e.description);
			    }
			}
			
		</script>
	</head>
	<body class="mainbody" style="overflow:auto; min-width: 975px;" marginwidth="0" marginheight="0">
	    <h1>
	    	<spring:message code='ezAttitude.t265' />
	    </h1>
			<div class="timecheck_info">
		    	<dl class="timeInfo">
		        	<dt class="timeInfoPic" style="margin: 0px;">	
						<img id="userImage" src="/images/kr/main/bestEmployee_pic_none.png" width="48px" height="48px">
		        	</dt>
		            <dd class="timeInfoText"><span id="userName"></span><span id="userTitle"></span><span id="userDept" style="color:#aaa9a9"></span></dd>
		        </dl>
			     <dl class="countDL">
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_day.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t239' /><span class="timeCountR" id="totalAnnualCnt">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_am.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t238' /><span class="timeCountR" id="accumCnt">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t253' /><span class="timeCountR" id="remainCnt">0</span></dd>
			        </dl>
			     </dl>
		        <dl class="countDL">
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_day.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t254' /><span class="timeCountR" id="FA11">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_am.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t255' /> <span class="timeCountR" id="FA12">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.t256' /> <span class="timeCountR" id="FA13">0</span></dd>
			        </dl>
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm02.png"></dt>
			            <dd class="timeIconDD"><spring:message code='ezAttitude.kje04' /> <span class="timeCountR" id="FA21">0</span></dd>
			        </dl>
			     </dl>
		    </div>
		    <div id="mainmenu">
			    <ul id="tb_Parent">
			    	<li>
				    	<select id="searchYear" onchange="makeoptionyear();" style="padding-right:50px;height:24px">
				    	</select>			    	
			    	</li>
			    	<%-- <li id="reply"><span onclick="exportExcel()"><spring:message code='ezAttitude.t145' /></span></li> --%>
		    </div>
	    <!-- 리스트 -->
	    <table>
			<tr>
				<td style="vertical-align:top; width:100%;">
			        <div style="width: 100%; height: 100%;">
			            <table class="mainlist" style="width: 100%;">
			                <tr>
			                    <th style="width: 60px;"><span>NO.</span></th>
			                    <th style="width: 25%; padding-left:15px; cursor: pointer;" colname="startDate"><span><spring:message code='ezAttitude.t276' /></span></th>
			                    <th style="width: 15%; cursor: pointer;" colname="typeName"><span><spring:message code='ezAttitude.t35' /></span></th>
			                    <th style="width: 12%; cursor: pointer;" colname="annualCnt"><span><spring:message code='ezAttitude.t238' /></span></th>
			                    <th style="width: 20%;"><span><spring:message code='ezAttitude.t230' /></span></th>
			                    <th style="width: 12%; cursor: pointer;" colname="annualApprStatus"><span><spring:message code='ezAttitude.t274' /></span></th>
			                    <th style="width: 12%; cursor: pointer;" colname="modAppl"><span><spring:message code='ezAttitude.t272' /></span></th>
			                </tr>
			            </table>
			            <div id="contentlist" name="contentlist" style="height: 520px; overflow-y: auto;">
			                <table class="mainlist" style="width: 100%;">
			                	<tbody></tbody>
			                </table>
			            </div>
			        </div>
				</td>
				<!-- <td style="vertical-align:top;white-space: normal;">
					<div style="vertical-align:top;width:0px;height:0px;overflow:hidden;" class="time_stats" id="attiStatis"></div>
					<div id="slideBtn" style="position:absolute;top:164px;right:2px;"><img id="slideImg" onclick="javascript:slideTd()" src="/images/ImgIcon/slideLeft.png"></div>
				</td> -->
			</tr>
		</table>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>

