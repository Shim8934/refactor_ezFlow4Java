<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>근태조회</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
	    <link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
	    <!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	    <style>
	    	#contentlist table.mainlist td {
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		cursor : pointer;
	    	}
	    	tr.hover:hover {background:#eee; color:#fff;}
			.selectTR {background-color: rgb(233, 241, 255);}
			#searchTable {
				border-top: 1px solid #e8e8e8;
				border-left: 1px solid #e8e8e8;
				border-right: 1px solid #e8e8e8;
				background-color: #fcfcfc;
			}
			#searchTable td {padding: 8px 5px;}
	    </style>
	    
	    <script type="text/javascript">
	    	var pCompanyId = ""; //현재 선택된 회사의 아이디
	    	//검색조건 저장 변수
	    	var searchUserName = ""; // 검색조건 (사원명)
	    	var searchDeptName = ""; // 검색조건 (부서명)
	    	var searchTitle = ""; // 검색조건 (직위)
	    	var searchAttitudeType = ""; // 검색조건(구분)
	    	//검색조건 (근무시간) Hr,Min 묶음으로
	    	var searchStartDate = "${searchStartDate}";
	    	var searchEndDate = "${searchEndDate}";
	    	var pageNum = 1; // 페이지 ==> 초기값 설정
	    	var totalCount = "" // 게시물 총 갯수
	    	var totalPage = ""; // 게시판의 총 페이지갯수
	    	var orderCell = ""; // 정렬 명
	    	var orderOption = ""; // 정렬 형식(ASC, DESC)
	    	var adminCompany = "${adminCompany}";
	    	var listSize = 19;
	    	
	    	$(function(){
	    		//회사리스트
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		    		
		            company_change();
		        }
	    		
	    		$("#Sdatepicker").val("${searchStartDate}");
	    		$("#Edatepicker").val("${searchEndDate}");
	    		
	    		//헤더 클릭 시 정렬
	    		$(document).on('click', '#contentlist table.mainlist th', function(){
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
		    			
		    			$("#contentlist table.mainlist th").find("img").remove();
		    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
		    			
		    			getUserConfList();
	    			}
	    		});
	    	});
	    	
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
			
	    	function company_change(){
	    		$('#receiverlist').empty();
	    		pCompanyId = $("select[name=ListCompany]").val();
	    		getUserConfList();
	    	}
	    	
	    	function getUserConfList(){
	    		//구분
	    		var typeId = $('#attitudeType').val();
	    		
	    		if (typeId == "total") {
	    			typeId = "";
	    		}
	    		
    			searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
	    		
	    		if (searchStartDate > searchEndDate) {
					alert("시작일을 종료일보다 빠르게 지정해주십시오.");
		            return;
				}
	    		
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			async : false,
	    			url : "/admin/ezAttitude/attitudeCheckList.do",
	    			data : {
	    				companyId : pCompanyId,
	   					userName : searchUserName,
	   					deptName : searchDeptName,
	   					title : searchTitle,
	   					startDate : searchStartDate,
	   					endDate : searchEndDate,
	   					attitudeType : searchAttitudeType,
	   					pageNum : pageNum,
	   					listSize : listSize,
	   					orderCell : orderCell,
	   					orderOption : orderOption
    				},
	    			success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				getUserConfList_after(result.list);
	    				//구분 리스트
	    				getAttitudeTypeList(result.typeList, result.typeId);
	    			},
	    			error : function() {
	    				alert('리스트를 가져오는중 오류 발생');
	    			}
	    		});
	    	}
	    	
	    	//검색 > 구분selectBox
	    	function getAttitudeTypeList(typeList, typeId) {
	    		var html = "<option value=''>전체</option>";
	    		
	    		for (var i = 0; i < typeList.length; i ++) {
	    			html += "<option value='" + typeList[i].typeId + "'>" + typeList[i].typeName +  "</option>";
	    		}
	    		
	    		$('#searchAttitudeType').html(html);
	    		
	    		if (typeId != "") {
	    			$('#searchAttitudeType').val(typeId);
	    		}
	    	}
	    	
	    	function getUserConfList_after(result){
	    		var resultHtml = "";
	    		
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		for (var i = 0; i < result.length; i ++) {
	    			resultHtml += "<tr userid='" + result[i].writerId + "'>"
	    			   			+ "<td>" + result[i].userName + "</td>"
	    			   			+ "<td>" + result[i].userTitle + "</td>"
	    			   			+ "<td>" + result[i].deptName + "</td>"
	    						+ "<td>" + result[i].typeName + "</td>";
	    						
	    			if (result[i].endDate == null || result[i].endDate == "") {
	    				resultHtml += "<td>" + result[i].startDate + "</td>";
	    			} else {
	    				resultHtml += "<td>" + result[i].startDate + " ~ " + result[i].endDate + "</td>";
	    			}
	    			
	    			if (result[i].endTime == null || result[i].endTime == "") {
	    				resultHtml += "<td>" + result[i].startTime + "</td></tr>";
	    			} else {
	    				resultHtml += "<td>" + result[i].startTime + " ~ " + result[i].endTime + "</td></tr>";
	    			}
	    		}
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='6' style='text-align:center'>등록된 정보가 없습니다.</td></tr>";	
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
	    		
	    		getUserConfList();
	    	}
	    	
			function searchUserConfList(searchType){
	    		if (searchType == "search") {
	    			searchUserName = $("#searchUserName").val();
	    			searchDeptName = $("#searchDeptName").val();
	    			searchTitle = $("#searchTitle").val();
	    			searchStartDate = $("#searchStartDate").val();
	    			searchEndDate = $("#searchEndDate").val();
	    			searchAttitudeType = $("select[id='searchAttitudeType']").val();
	    		} else {
	    			//새로고침
	    			$("#searchUserName").val("");
	    			$("#searchDeptName").val("");
	    			$("#searchTitle").val("");
	    			$("#searchStartDate").val("${searchStartDate}");
	    			$("#searchEndDate").val("${searchEndDate}");
	    			$("select[id='searchAttitudeType']").val('all');
	    			
	    			searchUserName = "";
	    			searchDeptName = "";
	    			searchTitle = "";
	    			searchStartDate = "${searchStartDate}";
	    			searchEndDate = "${searchEndDate}";
	    			searchAttitudeType = "all";
	    		}
	    		
	    		pageNum = 1;
    			getUserConfList();
	    	}
			
			function popupAbsentList() {
				searchUserName = $("#searchUserName").val();
    			searchDeptName = $("#searchDeptName").val();
    			searchTitle = $("#searchTitle").val();
    			searchStartDate = $("#searchStartDate").val();
    			searchEndDate = $("#searchEndDate").val();
    			
    			var url = "/admin/ezAttitude/popupAbsentedList.do?companyId=" + pCompanyId + "&searchUserName=" + searchUserName + "&searchDeptName=" + searchDeptName + "&searchTitle=" + searchTitle + "&searchStartDate=" + searchStartDate + "&searchEndDate=" + searchEndDate;
	    		
	    		if (CrossYN()) {
	    			OpenWin = GetOpenWindow(url, "", "600", "700");
	    			
	    			try { OpenWin.focus();} catch (e) { }
	    		} else {
	    			showModalDialog(url, null, "dialogWidth:600px; dialogHeight:700px; status:no; help:no; scroll:no; edge:sunken");
	    		}
	    	}
			
			//엑셀 다운로드
			function exportExcel() {
				if ($('#contentlist table.mainlist tbody tr').eq(0).attr('id') == 'List_TR_noItems') {
					alert('출력할 내용이 없습니다');
					return;
				}
				
		    	exportExcelframe.location.href="/admin/ezAttitude/excelFileExport.do?companyId=" + pCompanyId + "&userName=" + searchUserName + "&deptName=" + searchDeptName + "&title=" + searchTitle + "&startDate=" + searchStartDate + "&endDate=" + searchEndDate + "&attitudeType=" + searchAttitudeType + "&orderCell=" + orderCell + "&orderOption=" + orderOption;
		    	exportExcelframe.target="_blank";
			}
	    </script>
	</head>
	<body class="mainbody">
	    <h1>근태조회<span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
	        	<li style="background: none;"><span style="border: none;"><b>회사선택</b></span></li>
				<li>
					<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-top:4px; padding-right:40px;">
						<c:forEach var = "companyItem" items="${list }">
							<option value="<c:out value = '${companyItem.cn }' />"><c:out value = '${companyItem.displayName }'/></option>
						</c:forEach>
		      		</select>
	      		</li>
	      	</ul>
	  	</div>
	  	
	  	<table id="searchTable" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 3%;">부서</td>
					<td style="width: 12%;"><input type="text" id="searchDeptName" style="width: 90%;"></td>
					<td style="width: 3%;">이름</td>
					<td style="width: 11%;"><input type="text" id="searchUserName" style="width: 90%;"></td>
					<td style="width: 3%">구분</td>
					<td style="width: 20%;"><select name="searchAttitudeType" id="searchAttitudeType" style="padding-right:40px;"></select></td>
				</tr>
				<tr>
					<td style="width: 3%;">직위</td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50"></td>
					<td style="width: 3%;">검색기간</td>
					<td>
						<input type="text" id="Sdatepicker" style="width:80px;text-align:center"/> ~
						<input type="text" id="Edatepicker" style="width:80px;text-align:center"/>
					</td>
					<td style=" width:*;" colspan=2>
						<a class="imgbtn"><span onclick="searchUserConfList('search');">검색</span></a>&nbsp;
						<a class="imgbtn"><span onclick="searchUserConfList('refresh');">새로고침</span></a>&nbsp;
						<a class="imgbtn"><span onclick="exportExcel();">엑셀저장</span></a>&nbsp;
						<a class="imgbtn"><span onclick="popupAbsentList();">미입력자 목록</span></a>&nbsp;
					</td>
				</tr>
			</tbody>
		</table>
		
	  	<div id="contentlist" style="width:100%; height:620px;">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr>
						<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname">이름</th>
						<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title">직위</th>
						<th style="width:15%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description">부서</th>
						<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="type_name">구분</th>
						<th style="width:20%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="start_date">날짜</th>
						<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="starttime">시간</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
	  	</div>
		<div id="runtime" style="color: #666; padding-top: 10px"></div>
		<div id="tblPageRayer">
		</div>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>