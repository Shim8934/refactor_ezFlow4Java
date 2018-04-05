<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
    <link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/Common.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
    <!-- data picker-->		
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
    <style>
    	#attiBoardList td {
    		overflow : hidden;
    		white-space : nowrap;
    		text-overflow : ellipsis;
    		cursor : pointer;
    	}
    </style>
    
    <script type="text/javascript">
    	var pCompanyId = ""; //현재 선택된 회사의 아이디
    	var pageNum = 1; // 페이지 ==> 초기값 설정
    	var totalCount = "" // 게시물 총 갯수
    	var totalPage = ""; // 게시판의 총 페이지갯수
    	var orderCell = ""; // 정렬 명
    	var orderOption = ""; // 정렬 형식(ASC, DESC)
    	var selecUserList = "";//리스트에 선택된 userList(,로 구분)

    	
    	//"overflow":"hidden", "white-space":"nowrap", "text-overflow":"ellipsis", "cursor":"pointer"
    	
    	$(function(){
    		company_change();
    		
    		//헤더 클릭 시 정렬
    		$(document).on('click', '#attiBoardList th', function(){
    			if (!$(this).find("input[type=checkbox]").length) { // checkbox는 sort에서 제외
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
	    			$("#attiBoardList th").find("img").remove();
	    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
	    			
	    			getUserConfList();
    			}
    		})   		
    	})
    	
    	//datepicker
    	$(function () {
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
// 			var uploadSDate = date + " 00:00:00";
// 			var sYear = uploadSDate.substring(0, 4);
// 			var sMonth = uploadSDate.substring(5, 7);
// 			var sDay = uploadSDate.substring(8, 10);
// 			var sHour = uploadSDate.substring(11, 13);
// 			var sMin = uploadSDate.substring(14, 16);
						
// 			var uploadEDate = date + " 23:59:59";
// 			var eYear = uploadEDate.substring(0, 4);
// 			var eMonth = uploadEDate.substring(5, 7);
// 			var eDay = uploadEDate.substring(8, 10);
// 			var eHour = uploadEDate.substring(11, 13);
// 			var eMin = uploadEDate.substring(14, 16);
		
// 		    var SDate = new Date();
// 		    SDate.setFullYear(sYear, sMonth-1, sDay);
// 		    SDate.setHours(sHour, sMin, 0, 0);
		    
// 		    var EDate = new Date();
// 		    EDate.setFullYear(eYear, eMonth-1, eDay);
// 		    EDate.setHours(eHour, eMin, 0, 0);
		    
// 		    $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
// 		    $("#Sdatepicker").datepicker('setDate', SDate);

// 		    $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
// 		    $("#Edatepicker").datepicker('setDate', EDate);
		});
		    
		var monthMsg = "1월;2월;3월;4월;5월;6월;7월;8월;9월;10월;11월;12월";
		var monthStr = monthMsg.split(";");		    
		var dayMsg = "일;월;화;수;목;금;토";
		var dayStr = dayMsg.split(";");
		    
		$(function () {
		    $.datepicker.regional["ko"] = {
		    	closeText: "닫기",
		        prevText: "이전달",
		        nextText: "다음달",
			currentText: "오늘",
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
    	//
    	
    	function company_change(){
    		$('#receiverlist').empty();
    		pCompanyId = $("select[name=ListCompany]").val();
    		getUserConfList();
    	}
    	
    	function getUserConfList(){
    		$.ajax({
    			data : "GET",
    			dataType : "json",
    			async : false,
    			url : "/admin/ezAttitude/attitudeCheckList.do",
    			data : {companyId : pCompanyId, 
//     					userName : searchUserName, 
    					pageNum : pageNum, 
    					listSize : listSize,
    					orderCell : orderCell,
    					orderOption : orderOption,
    					startDate : $('#Sdatepicker').val(),
    					endDate : $('#Edatepicker').val()},
    			success : function(result){
    				totalCount = result.totalCount;
    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
    				getUserConfList_after(result.list);
    				//더블클릭 이벤트
    				addTrDblclickEvent(userDbClick);
    			}
    		});
    	}
    	
    	function getUserConfList_after(result){
    		var resultHtml = "";
    		$("#attiBoardList tbody").html("");
    		
    		for (var resultLeng = 0; resultLeng < result.length; resultLeng ++) {
    			resultHtml += "<tr userid='" + result[resultLeng].userId + "'><td></td>"
    			   			+ "<td>" + result[resultLeng].userName+ "</td>"
    			   			+ "<td>" + result[resultLeng].userTitle+ "</td>"
    			   			+ "<td>" + result[resultLeng].deptName+ "</td>"
    			   			+ "<td>" + result[resultLeng].workStartTime + " ~ " + result[resultLeng].workEndTime + "</td></tr>";
    		}
    		
    		if (resultHtml == "") {
    			resultHtml = "<tr><td colspan='9' style='text-align:center'>등록된 정보가 없습니다.</td></tr>";	
    		}
    		
    		$("#attiBoardList tbody").append(resultHtml);
    		makePageSelPageAtti();
    	}
    	
    	function searchUserConf(searchFlag){
    		if ($("#layer_popup").css("display") == "none") {
    			$("#layer_popup").css("display", "");
    		} else {
    			$("#layer_popup").css("display", "none");
    		}
    		
    		if (searchFlag) {
    			searchUserName = $("#txtUserName").val();
    			searchDeptName = $("#txtDeptName").val();
    			$("#txtUserName").val("");
    			$("#txtDeptName").val("");
    			pageNum = 1;
    			
    			getUserConfList();
    		}
    	}
    	
    	//페이지 이동 함수
    	function goToPageByNum(pCurPage){
    		if (pCurPage == 0 || totalPage < pCurPage) {
    			return;
    		} else {
	    		pageNum = pCurPage;    			
    		}
    		
    		getUserConfList();
    	}
    	
//     	function userDbClick() {
//     		selecUserList = $(this).attr('userid');
//     		userConfSave(selecUserList);
//     	}
    	
    	//검색 > 조회자검색 버튼 클릭시
    	function search_user() {
        	var searchIdList = ""; // 조회자 id 리스트
        	var searchNameList = ""; // 조회자 name 리스트
   			
        	var spanIdx = $('#receiverlist').find('span').length;
   			for (var i = 0; i < spanIdx; i++) {
   				searchIdList += $('#receiverlist span').eq(i).attr('id') + ",";
   				searchNameList += $('#receiverlist span').eq(i).text() + ",";
   			}
   			//마지막 ',' 제거
   			searchIdList = searchIdList.slice(0, -1);
   			searchNameList = searchNameList.slice(0, -1);
    		
			var url = "/admin/ezAttitude/getSearchList.do?companyId=" + $('#ListCompany').val() + "&searchIdList=" + searchIdList + "&searchNameList=" + searchNameList;
    		window.open(url, "view", "width=940, height=580");
    	}
    </script>
	<style>
		tr.hover:hover{background:#eee; color:#fff;}
			
		.selectTR{
			background-color: rgb(233, 241, 255);
		}
	</style>
	</head>
<body>
	<body class="mainbody">
	    <h1>근태조회<span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
	        	<li style="background: none;">
				<span style="border: none;"><b>회사선택</b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-top:4px; padding-right:40px;">
					<c:forEach var = "companyItem" items="${list }">
						<option value="<c:out value = '${companyItem.cn }' />"><c:out value = '${companyItem.displayName }'/></option>
					</c:forEach>
	      		</select>
	      		</li>
	      	</ul>
	  	</div>
	  	<div id="mainmenu">
	  		<ul class="on">
	  			<li class="off"><span onclick="searchUserConf(false)">검색</span></li>
	  			<li class="off"><span onclick="">엑셀다운로드</span></li>
	  		</ul>
	  	</div>
	  	<div id="layer_popup" style="width: 500px; position: absolute; left: 10px; top: 130px; background-color: rgb(255, 255, 255); display:none;">
	  		<div class="popupwrap1">
	  			<div class="popupwrap2">
	  				<table class="content">
	  					<tbody>
	  						<tr>
	  							<th style="text-align:center">구분</th>
	  							<td>
	  								<select name="attitudeType" id="attitudeType" onchange="attitudeType_change()" style="margin-top:4px; padding-right:40px;">
	  								</select>
	  							</td>
	  						</tr>
	  						<tr>
	  							<th style="text-align:center;" rowspan="2"><a href="#" id="imgbutton" class="imgbtn"><span onclick="search_user()">조회자</span></a></th>
	  							<td><input type="text" id="txt" style="width:98%" value=""/></td>
	  						</tr>
	  						<tr>
	  							<td><div id="receiverlist" style="OVERFLOW-Y: auto; height: 17px;"></div></td>
	  						</tr>
	  						<tr>
	  							<th style="text-align:center">검색기간</th>
	  							<td>                        
	  								<span id="periodblock">
			                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
			                        ~
			                        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
			                        </span>
                        		</td>
	  						</tr>
	  					</tbody>
	  				</table>
	  				<br>
	  				<table style="width:100%">
	  					<tbody>
	  						<tr>
	  							<td style="text-align:center">
	  								<a class="imgbtn"><span onclick="searchUserConf(true)">검색</span></a>
	  								<a class="imgbtn"><span onclick="searchUserConf(false)">취소</span></a>
	  							</td>
	  						</tr>
	  					</tbody>
	  				</table>
	  			</div>
	  		</div>
	  		<div class="shadow">
	  		</div>
	  	</div>
		<table id="attiBoardList" class="mainlist" style="width:100%;">
			<thead>
				<tr>
					<th style="width:5%;">NO</th>
					<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname">이름</th>
					<th style="width:15%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description">부서</th>
					<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="workstarttime">출근시각</th>
					<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="workendtime">퇴근시각</th>
					<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="typename">구분</th>
					<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="date">날짜</th>
					<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="starttime">시작시간</th>
					<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="endtime">종료시간</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<div id="tblPageRayer">
		</div>
	</body>
</body>
</html>