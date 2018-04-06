<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/Common.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
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
    	var searchUserName = ""; // 검색조건 (사원명)
    	var searchDeptName = ""; // 검색조건 (부서명)
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
    	
    	function company_change(){
    		if($("#HeaderAllCheckBox").is(":checked") == true) {
    			$("#HeaderAllCheckBox").prop("checked", false);
    		}
    		
    		pCompanyId = $("select[name=ListCompany]").val();
    		getUserConfList();
    	}
    	
    	function getUserConfList(){
    		$.ajax({
    			data : "GET",
    			dataType : "json",
    			async : false,
    			url : "/admin/ezAttitude/attitudeUserConfList.do",
    			data : {companyId : pCompanyId, 
    					userName : searchUserName, 
    					deptName : searchDeptName, 
    					pageNum : pageNum, 
    					listSize : listSize,
    					orderCell : orderCell,
    					orderOption : orderOption},
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
    			resultHtml += "<tr userid='" + result[resultLeng].userId + "'><td><input type='checkbox' style='margin: 0px; padding: 0px; width:13px; height: 13px;'/></td>"
    			   			+ "<td>" + result[resultLeng].userName+ "</td>"
    			   			+ "<td>" + result[resultLeng].userTitle+ "</td>"
    			   			+ "<td>" + result[resultLeng].deptName+ "</td>"
    			   			+ "<td>" + result[resultLeng].workStartTime + " ~ " + result[resultLeng].workEndTime + "</td></tr>";
    		}
    		
    		if (resultHtml == "") {
    			resultHtml = "<tr><td colspan='5' style='text-align:center'>등록된 정보가 없습니다.</td></tr>";	
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
    	
    	//추가/변경 버튼 클릭시
    	function userConfSave(userid){
    		if(userid == null) {
	    		selectedCheck();
    		}
    		var url = "";
    		if(selecUserList == "" || selecUserList == null) {
    			url = "/admin/ezAttitude/saveAttitudeUserConf.do?companyId=" + $('#ListCompany').val();
    		} else {
    			url = "/admin/ezAttitude/saveAttitudeUserConf.do?companyId=" + $('#ListCompany').val() + "&userList=" + selecUserList;
    		}
    		
    		if (CrossYN()) {
    			//GetOpenWindow(url, target, popUpW, popUpH, resizeFlag)
    			OpenWin = GetOpenWindow(url, "", "1140", "630");
    			try { OpenWin.focus();} catch (e) { }
    		} else {
    			showModalDialog("/admin/ezAttitude/saveAttitudeUserConf.do?companyId=" + $('#ListCompany').val(), null, "dialogHeight:400px; dialogWidth:465px; status:no; help:no; scroll:no; edge:sunken");
    		}
    	}
    	
    	//리스트에 체크박스 selected 체크
    	function selectedCheck(){
    		selecUserList = "";
    		var trIdx = $('#attiBoardList').find('tr').length;
   			for (var i = 1; i < trIdx; i++) {
   				if ($('#attiBoardList tr').eq(i).find("input[type='checkbox']").is(":checked")) {
   					selecUserList += $('#attiBoardList tr').eq(i).attr('userid') + ",";
   				}
   			}
   			//마지막 ',' 지우기
   			selecUserList = selecUserList.slice(0, -1);
    	}
    	//삭제버튼
    	function delUserConf() {
    		selectedCheck();
    		if(selecUserList == "" || selecUserList == null) {
    			alert('사원을 선택해 주세요!');
    		} else {
				if (confirm("삭제하시면 선택한 사용자는 회사 설정시간에 따르게됩니다")) {
		    		$.ajax({
		    			data : "POST",
		    			async : false,
		    			url : "/admin/ezAttitude/delAttitudeUserConf.do",
		    			data : {
		    				companyId : pCompanyId,
		    				selecUserList : selecUserList
		    			},
		    			success : function(){
		    				company_change();
		    			},
		    			error : function() {
		    				alert('삭제하는도중 에러 발생');
		    			}
		    		});
				}	
    		}
    	}
    	
    	function userDbClick() {
    		selecUserList = $(this).attr('userid');
    		userConfSave(selecUserList);
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
	    <h1>사용자별 근태관리<span id="mailBoxInfo"></span></h1>
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
	  			<li class="off"><span onclick="userConfSave()">추가/변경</span></li>
	  			<li class="off"><span onclick="searchUserConf(false)">검색</span></li>
	  			<li class="off"><span onclick="delUserConf()">삭제</span></li>
	  		</ul>
	  	</div>
	  	<div id="layer_popup" style="width: 500px; position: absolute; left: 10px; top: 130px; background-color: rgb(255, 255, 255); display:none;">
	  		<div class="popupwrap1">
	  			<div class="popupwrap2">
	  				<table class="content">
	  					<tbody>
	  						<tr>
	  							<th style="text-align:center">부서명</th>
	  							<td><input type="text" id="txtDeptName" style="width:98%" value=""/></td>
	  						</tr>
	  						<tr>
	  							<th style="text-align:center">사원명</th>
	  							<td><input type="text" id="txtUserName" style="width:98%" value=""/></td>
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
					<th style="width:10%;"><input id="HeaderAllCheckBox" type="checkbox" style="margin: 0px; padding: 0px; width:13px; height: 13px;"/></th>
					<th style="width:20%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname">이름</th>
					<th style="width:15%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title">직위</th>
					<th style="width:30%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description">부서</th>
					<th style="width:25%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="work_starttime">근무시간</th>
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