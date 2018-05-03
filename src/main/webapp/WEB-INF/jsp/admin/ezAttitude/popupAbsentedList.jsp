<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>미입력자 목록조회</title>
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
	    <!-- data picker-->
	    <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	</head>
	
	<script type="text/javascript">
		var companyId = "${companyId}";
		var searchUserName = "${searchUserName}";
		var searchDeptName = "${searchDeptName}";
		var searchTitle = "${searchTitle}";
		var searchStartDate = "${searchStartDate}";
		var searchEndDate = "${searchEndDate}";
		var pageNum = 1; // 페이지 ==> 초기값 설정
    	var totalCount = "" // 게시물 총 갯수
    	var totalPage = ""; // 게시판의 총 페이지갯수
    	var orderCell = ""; // 정렬 명
    	var orderOption = ""; // 정렬 형식(ASC, DESC)
		
		$(function() {
			$("#Sdatepicker").val("${searchStartDate}");
    		$("#Edatepicker").val("${searchEndDate}");
    		
			getAbsentedList();
			
			$(document).on('click', '#contentlist table.mainlist th', function(){
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
    			
    			getAbsentedList();
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
		
    	function getAbsentedList() {
    		if (!checkPattern()) {
    			alert("날짜를 다시 지정해주세요.");
    			return;
    		}
    		
    		searchUserName = $("#searchUserName").val();
			searchDeptName = $("#searchDeptName").val();
			searchTitle = $("#searchTitle").val();
    		searchStartDate = $("#Sdatepicker").val();
    		searchEndDate = $("#Edatepicker").val();
    		
    		$.ajax({
				type : "post",
				dastaType : "json",
				async : false,
				url : "/admin/ezAttitude/getAbsentedList.do",
				data : {
					companyId : companyId,
   					userName : searchUserName,
   					deptName : searchDeptName,
   					title : searchTitle,
   					startDate : searchStartDate,
   					endDate : searchEndDate,
   					orderCell : orderCell,
   					orderOption : orderOption,
   					duplicated : "duplicated"
				},
				success : function(result) {
					getAbsentedList_after(result.list);
				}
				
			});
    	}
    	
		function getAbsentedList_after(result){
    		var resultHtml = "";
    		$("#contentlist table.mainlist tbody").html("");
    		
    		result.forEach(function(vo, index) {
    			resultHtml += "<tr userid='" + vo.userId + "'>";
    			resultHtml += "<td>" + vo.userName + "</td>";
    			resultHtml += "<td>" + vo.userTitle + "</td>";
    			resultHtml += "<td>" + vo.deptName + "</td></tr>";
    		});
    		
    		if (resultHtml == "") {
    			resultHtml = "<tr id='List_TR_noItems'><td colspan='3' style='text-align:center'>미입력자가 없습니다.</td></tr>";	
    		}
    		
    		$("#contentlist table.mainlist tbody").append(resultHtml);
    	}
		
		//2018-05-03 이효진 메일작성부분 수정필요함
		function btnSendMail_onclick() {
// 			var MsgTo = "\"" + GetAttribute(listview.GetSelectedRows()[0], "DATA3") + "\" <" + GetAttribute(listview.GetSelectedRows()[0], "DATA4") + ">";
			/* for () {
				MsgTo = 
			} */
			
			//임시
			var msgTo = "\"" + "이름1" + "\" <" + "hyojin0414@kaoni.com" + ">";
			msgTo += "\"" + "이름1" + "\" <" + "hyojin0414@kaoni.com" + ">";
			
			var pheight = window.screen.availHeight;
		    var conHeight = pheight * 0.8;
		    var pwidth = window.screen.availWidth;
		    var conWidth = pwidth * 0.8;
		    if (conWidth > 890)
		        conWidth = 890;
		    var pTop = (pheight - conHeight) / 2;
		    var pLeft = (pwidth - 890) / 2;
	        var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px,width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
	        
	        window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(msgTo), "", feature);
		}
		
		function btnClose_onclick() {
			window.close();
		}
		
		function searchPress(evt) {
	        if (window.event) {
	            if (window.event.keyCode == 13) {
	            	getAbsentedList();
	            }
	        } else {
	            if (evt.which == 13)
	            	getAbsentedList();
	        }
	    }
		
		function checkPattern() {
			var datePattern =  /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
			/* var timePattern = /^([01][0-9]|2[0-3]):([0-5][0-9])$/; */
			
			if (datePattern.test($("#Sdatepicker").val()) && datePattern.test($("#Edatepicker").val())) {
				return true;
			} else {
				if (!datePattern.test($("#Sdatepicker").val())&& !datePattern.test($("Edatepicker").val())) {
					$("#Sdatepicker").focus();
					return false;
				} else if (!datePattern.test($("#Sdatepicker").val())) {
					$("#Sdatepicker").focus();
					return false;
				} else if (!datePattern.test($("#Edatepicker").val())) {
					$("#Edatepicker").focus();
					return false;
				}
			}
		}
		
		function exportExcel() {
			if ($('#contentlist table.mainlist tbody tr').eq(0).attr('id') == 'List_TR_noItems') {
				alert('출력할 내용이 없습니다');
				return;
			}
			
	    	exportExcelframe.location.href="/admin/ezAttitude/excelAbsentedListExport.do?companyId=" + companyId + "&userName=" + searchUserName + "&deptName=" + searchDeptName + "&title=" + searchTitle + "&startDate=" + searchStartDate + "&endDate=" + searchEndDate + "&orderCell=" + orderCell + "&orderOption=" + orderOption + "&duplicated=duplicated";
	    	exportExcelframe.target="_blank";
		}
	</script>
	
	<body class="popup">
		<h1>미입력자 목록</h1>
		
		<table id="searchTable" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 3%;">부서</td>
					<td style="width: 12%;"><input type="text" id="searchDeptName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;">이름</td>
					<td style="width: 12%;"><input type="text" id="searchUserName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;">직위</td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50" onkeypress="searchPress()"></td>
				</tr>
				<tr>
					<td style="width: 5%;">검색기간</td>
					<td colspan=4>
						<input type="text" id="Sdatepicker" style="width:80px;text-align:center"/> ~
						<input type="text" id="Edatepicker" style="width:80px;text-align:center"/>
					</td>
					<td style=" width:*;">
						<a class="imgbtn"><span onclick="getAbsentedList();">검색</span></a>&nbsp;
					</td>
				</tr>
			</tbody>
		</table>
		
		<div id="contentlist">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname">이름</th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title">직위</th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description">부서</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
		
		<div class="btnposition">
			<a class="imgbtn"><span onclick="return btnSendMail_onclick()">메일발송</span></a>
			<a class="imgbtn"><span onclick="exportExcel();">엑셀저장</span></a>
			<a class="imgbtn"><span onclick="return btnClose_onclick()">닫기</span></a>
		</div>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>