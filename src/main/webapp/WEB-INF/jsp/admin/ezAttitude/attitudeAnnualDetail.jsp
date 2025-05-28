<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezAttitude.t5' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css"/>
	    <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" > 
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/> 
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/ListView_list.js')}"></script>
	    <style>
	    	body::-webkit-scrollbar {
    			display: none !important;
			}
			body {
				-ms-overflow-style: none !important;
			}
	    	#contentlist table.mainlist tr:not(.tr_noItems) td {
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    	}
	    	tr.hover:hover {background:#eee; color:#fff;}
			.selectTR {background-color: #f1f8ff;}
			#searchTable {
				border: 1px solid #e8e8e8;
				background-color: #f8f8fa;
			}
			#searchTable td {padding: 8px 5px;}
			.mainlist a.imgbtn {
				background: none;
			}
			.mainlist a.imgbtn:hover {
				border: 1px solid #8e8e8e;
				background: white;
			}
			.mainlist a.link {
				text-decoration: underline;
			}
			.mainlist a.link:hover {
				font-weight: bold;
			}
	    </style>
	    
	    <script type="text/javascript">
	    	var date = new Date()
    		var year = date.getFullYear(); //현재년도
    		var g_userLang = "${userLang}";
    		var g_timezone = "${userTimeSet}";
    		var offsetMin = "${offsetMin}";
    		var initialDate = "<c:out value="${annualconfig.initialDate}" />";
	    	var pCompanyId = ""; //현재 선택된 회사의 아이디
	    	//검색조건 저장 변수
	    	//var searchYear = ""; //검색조건 (년도)
	    	var searchUserName = ""; //검색조건 (사원명)
	    	var searchDeptName = ""; //검색조건 (부서명)
	    	var searchTitle = ""; //검색조건 (직위)
	    	var searchAttitudeType = "ALL"; //검색조건(근태유형)
	    	var pageNum = 1; //페이지 ==> 초기값 설정
	    	var totalCount = "" //게시물 총 갯수
	    	var totalPage = ""; //게시판의 총 페이지갯수
	    	var orderCell = ""; //정렬 명
	    	var orderOption = ""; //정렬 형식(ASC, DESC)
	    	var adminCompany = "${adminCompany}";
	    	var listSize = 15;
	    	//년도 셀렉트 박스
			var isfirst = true;
            var maxyear = "";
            
	    	$(function(){
	    		windowResize();
	    		
	    		//회사리스트
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    			if (document.getElementById("ListCompany").selectedIndex < 0) {
				            document.getElementById("ListCompany").selectedIndex = 0;
		    			}
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		    		
		    		company_change();
		        }
	    		
	    		//헤더 클릭 시 정렬
	    		$(document).on('click', '#contentlist table.mainlist th', function(){
	    			var order = $(this).attr("colname");
	    			if (order != "" && order != "NO") {
	    				if (!$(this).find("img").length) { // 새로운 th를 클릭한 경우
	    					src = "";
	    					orderOption = "";
	    					orderCell = order;
	    				}
	    			
		    			if (orderOption == "" || orderOption == "DESC") {
		    				src = '/images/etc/view-sortup.gif';
		    				orderOption = "ASC";
		    			} else {
		    				src = '/images/etc/view-sortdown.gif';
		    				orderOption = "DESC";
		    			}
		    			
		    			$("#contentlist table.mainlist th").find("img").remove();
		    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
		    			
		    			getAnnualList();
	    			}
	    		});
	    		
	    		//총 연차 수 링크 클릭
	    		$(document).on('click', '.mainlist .additionalAnnualCnt', function(){
	    			var userId = $(this).closest("tr").attr("userid");
	    			var userName = $(this).closest("tr").children("td:eq(1)").text();
	    			var userTitle = $(this).closest("tr").children("td:eq(2)").text();
	    			var userDeptName = $(this).closest("tr").children("td:eq(3)").text();
	    			var additionalAnnualCnt = $(this).closest("tr").children("td:eq(6)").text();
	    			modifyPrsnAnnualPop(userId , userName, userTitle, userDeptName, additionalAnnualCnt);
	    		})
	    		//입사일 클릭
	    		$(document).on('click', '.mainlist .joinDate', function(){
	    			var userId = $(this).closest("tr").attr("userid");
	    			var mode = "modify";
	    			var date = $(this).closest("tr").children("td:eq(4)").text();
	    			setJoinDatePop(userId , mode , date);
	    		})
	    	});
			
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
		    //리사이즈
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 216 - document.getElementById("mainmenu").clientHeight;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
			
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
		    
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var NowDate = utcDate2(offsetMin);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', NowDate);
				
		        $("#Sdatepicker").val(year + initialDate.substring(4, 10));
	    		$("#Edatepicker").val(caldate(new Date(year + 1, initialDate.substring(5, 7) - 1, initialDate.substring(8, 10)), 1));
		        
				// ie인 경우, 달력 이미지 위치 수정
				if (navigator.userAgent.toLowerCase().indexOf("chrome") == -1) {
					$('#sDateSpan').children('img.ui-datepicker-trigger').first().attr("style", "margin-top:2px;");
					$('#eDateSpan').children('img.ui-datepicker-trigger').first().attr("style", "margin-bottom:2px;");
	    	    }
		    });
		    
		    $(function () {
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
		    
		    //회사변경시
	    	function company_change() {
	    		pCompanyId = document.getElementById("ListCompany").value;
	    		getAnnualList();
	    	}
	        
	        function ShowMailProgress() {
				var CurrenWidth = window.innerWidth;
	        	
			    document.getElementById("mailPanel").style.display = "";
			    document.getElementById("MailProgress").style.top = "330px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
			    document.getElementById("MailProgress").style.display = "";
			}
	    	
	    	function HiddenMailProgress() {
			    document.getElementById("mailPanel").style.display = "none";
			    document.getElementById("MailProgress").style.display = "none";
			}
	    	
		    //리스트 가져오기
	    	function getAnnualList() {
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			url : "/admin/ezAttitude/attitudeAnnualList.do",
	    			data : {
	    				companyId : pCompanyId,
	   					userName : searchUserName,
	   					deptName : searchDeptName,
	   					title : searchTitle,
	   					pageNum : pageNum,
	   					listSize : listSize,
	   					orderCell : orderCell,
	   					orderOption : orderOption
    				},
    				beforeSend : function() {
    					ShowMailProgress();
    				},
	    			success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				getAnnualList_after(result.list);
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			},
	    			complete : function() {
	    				HiddenMailProgress();
	    			}
	    		});
	    	}
	    	
	    	function date_reset() {
		    	$("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var NowDate = utcDate2(offsetMin);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        
		        if (checkAdmin == 'true') {
		        	$("#Sdatepicker").val("${startDate}");
		    		$("#Edatepicker").val("${endDate}");
		        } else {
		        	$(usepostdate).prop('checked', false);
			        usepostDate = false;
			        $("#Sdatepicker").datepicker('setDate', NowDate);
			        $("#Edatepicker").datepicker('setDate', NowDate);
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        }
		    }
	    	
	    	function getAnnualList_after(result){
	    		var resultHtml = "";
	    		
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr userid='" + vo.userId + "'>";
	    			resultHtml += "<td style='padding-left: 15px;'>" + i + "</td>";
	    			resultHtml += "<td>" + vo.userName + "</td>";
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.userDeptName + "</td>";
	    			
	    			resultHtml += "<td>";
	    			if (Number(vo.basicAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.basicAnnualCnt;
	    			} else {
		    			resultHtml += vo.basicAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</td>";
	    			resultHtml += "<td>";
	    			if (Number(vo.basicAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.basicAnnualCnt;
	    			} else {
		    			resultHtml += vo.basicAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</td>";
	    			resultHtml += "<td>";
	    			if (Number(vo.basicAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.basicAnnualCnt;
	    			} else {
		    			resultHtml += vo.basicAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</td>";
	    			resultHtml += "<td>";
	    			if (Number(vo.basicAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.basicAnnualCnt;
	    			} else {
		    			resultHtml += vo.basicAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</td>";
	    			resultHtml += "<td>";
	    			if (Number(vo.basicAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.basicAnnualCnt;
	    			} else {
		    			resultHtml += vo.basicAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</td>";
	    			resultHtml += "<td>";
	    			if (Number(vo.basicAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.basicAnnualCnt;
	    			} else {
		    			resultHtml += vo.basicAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</td>";
	    			resultHtml += "<td>";
	    			if (Number(vo.basicAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.basicAnnualCnt;
	    			} else {
		    			resultHtml += vo.basicAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</td>";

	    			i++;
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems' class='tr_noItems'><td colspan='7' style='text-align:center'><spring:message code='ezAttitude.t130' /></td></tr>";	
	    		}
	    		
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    		makePageSelPageAtti();
	    	}
	    	
	    	//페이지 이동 함수
	    	function goToPageByNum(pCurPage){
	    		if (pCurPage == 0 || totalPage < pCurPage) {
	    			return;
	    		} else {
		    		pageNum = pCurPage;
	    		}
	    		
	    		getAnnualList();
	    	}
	    	
	    	//엔터로 검색되도록
			function searchPress(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	searchAnnualList('search');
		            }
		        } else {
		            if (evt.which == 13)
		            	searchAnnualList('search');
		        }
		    }
			
	    	//검색시 조건
			function searchAnnualList(searchType){
	    		if (searchType == "search") { //검색
	    			//searchYear = document.getElementById("searchYear").value;
	    			searchUserName = $("#searchUserName").val();
	    			searchDeptName = $("#searchDeptName").val();
	    			searchTitle = $("#searchTitle").val();
	    		} else { //새로고침
	    			//searchYear = maxyear - 2;
	    			$("#searchUserName").val("");
	    			$("#searchDeptName").val("");
	    			$("#searchTitle").val("");
	    			
	    			searchUserName = "";
	    			searchDeptName = "";
	    			searchTitle = "";
	    		}
	    		
	    		$("#contentlist table.mainlist th").find("img").remove();
	    		orderOption = "";
	    		orderCell = "";
	    		
	    		pageNum = 1;
    			getAnnualList();
	    	}
			
			//엑셀 다운로드
			function exportExcel() {
				if ($('#contentlist table.mainlist tbody tr').eq(0).attr('id') == 'List_TR_noItems') {
					alert("<spring:message code='ezAttitude.t56'/>");
					return;
				}
				
		    	exportExcelframe.location.href="/admin/ezAttitude/excelAnnualListExport.do?companyId=" + encodeURIComponent(pCompanyId) + "&userName=" + encodeURIComponent(searchUserName) + "&deptName=" + encodeURIComponent(searchDeptName) + "&title=" + encodeURIComponent(searchTitle) + "&orderCell=" + encodeURIComponent(orderCell) + "&orderOption=" + encodeURIComponent(orderOption);
		    	exportExcelframe.target="_blank";
			}
			
	    </script>
	</head>
	<body class="mainbody">
	    <h1>
	    	<spring:message code='ezAttitude.t237' /><span id="mailBoxInfo"></span>
	    	<select class="companySelect" name="ListCompany" id="ListCompany" onchange="company_change()">
				<c:forEach var = "companyItem" items="${list }">
					<option value="<c:out value = '${companyItem.cn }' />"><c:out value = '${companyItem.displayName }'/></option>
				</c:forEach>
      		</select>
	    </h1>
		<div id="mainmenu"></div>
	  	
	  	<table id="searchTable" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 3%;"><spring:message code='ezAttitude.t10' /></td>
					<td style="width: 12%;"><input type="text" id="searchUserName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t9'/></td>
					<td style="width: 12%;"><input type="text" id="searchDeptName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;"></td>
					<td style="width: 12%;">
				</tr>
				<tr>
					<td style="width: 3%;"><spring:message code='ezAttitude.t11' /></td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50" onkeypress="searchPress()"></td>
					</td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t137'/></td>
					<td style="width: 9%;">
						<span id="sDateSpan"><input type="text" id="Sdatepicker" style="width:80px;text-align:center; float:left"/></span> <span style="vertical-align:middle;">~</span> <span id="eDateSpan"><input type="text" id="Edatepicker" style="width:80px;text-align:center;"/></span>
					</td>
					<td colspan=2>
						<a class="imgbtn"><span onclick="searchAnnualList('search');"><spring:message code='ezAttitude.t121' /></span></a>
						<a class="imgbtn"><span onclick="searchAnnualList('refresh');"><spring:message code='ezAttitude.t122' /></span></a>
						<a class="imgbtn"><span onclick="exportExcel();"><spring:message code='ezAttitude.t145' /></span></a>
					</td>
				</tr>
			</tbody>
		</table>
		
	  	<div id="contentlist" style="width:100%; height:610px;margin-top:5px">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr>
						<th style="padding-left: 15px; width: 60px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;" colname="NO">NO.</th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname"><spring:message code='ezAttitude.t10' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title"><spring:message code='ezAttitude.t11' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description"><spring:message code='ezAttitude.t9' /></th>
						<th style="width:8%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname=""><spring:message code='ezAttitude.t239' /></th>
						<th style="width:8%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname=""><spring:message code='ezAttitude.t238' /></th>
						<th style="width:8%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname=""><spring:message code='ezAttitude.t253' /></th>
						<th style="width:8%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname=""><spring:message code='ezAttitude.t254' /></th>
						<th style="width:8%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname=""><spring:message code='ezAttitude.t255' /></th>
						<th style="width:8%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname=""><spring:message code='ezAttitude.t256' /></th>
						<th style="width:8%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname=""><spring:message code='ezAttitude.kje04' /></th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
	  	</div>
	  		  	
		<div id="tblPageRayer"></div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>