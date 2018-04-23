<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>사용자별 근태관리</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
	    
	    <style>
	    	#attiBoardList td {
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		cursor : pointer;
	    	}
	    	tr.hover:hover {background:#eee; color:#fff;}
			.selectTR  {background-color: rgb(233, 241, 255);}
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
	    	var searchUserName = ""; // 검색조건 (사원명)
	    	var searchDeptName = ""; // 검색조건 (부서명)
	    	var searchTitle = ""; // 검색조건 (직위)
	    	var searchCompareValue = ""; // 검색조건(구분)
	    	//검색조건 (근무시간) Hr,Min 묶음으로
	    	var searchStartTime = "";
	    	var searchEndTime = "";
	    	var pageNum = 1; // 페이지 ==> 초기값 설정
	    	var totalCount = "" // 게시물 총 갯수
	    	var totalPage = ""; // 게시판의 총 페이지갯수
	    	var orderCell = ""; // 정렬 명
	    	var orderOption = ""; // 정렬 형식(ASC, DESC)
	    	var selecUserList = "";//리스트에 선택된 userList(,로 구분)
	    	var adminCompany = "${adminCompany}";
	    	
	    	//"overflow":"hidden", "white-space":"nowrap", "text-overflow":"ellipsis", "cursor":"pointer"
	    	//레이어 만들고 업데이트하는 로직 추가, 추가,삭제 기존로직 타고 다지우고
	    	$(function(){
	    		$('#searchStartTime').timepicker({ 'timeFormat': 'H:i' });
        		$('#searchEndTime').timepicker({ 'timeFormat': 'H:i' });
        		
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
	    		});
	    	});
	    	
	    	function company_change(){
	    		
	    		pCompanyId = $("select[name=ListCompany]").val();
	    		
	    		getUserConfList();
	    	}
	    	
	    	function getUserConfList(){
	    		$.ajax({
	    			data : "POST",
	    			dataType : "json",
	    			async : false,
	    			url : "/admin/ezAttitude/attitudeUserConfList.do",
	    			data : {
	    				companyId : pCompanyId,
	   					userName : searchUserName,
	   					deptName : searchDeptName,
	   					title : searchTitle,
	   					startTime : searchStartTime,
	   					endTime : searchEndTime,
	   					compareValue : searchCompareValue,
	   					pageNum : pageNum,
	   					listSize : listSize,
	   					orderCell : orderCell,
	   					orderOption : orderOption
	   				},
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
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr userid='" + vo.userId + "'>";
// 	    			resultHtml += "<tr userid='" + vo.userId + "'><td><input type='checkbox' style='margin: 0px; padding: 0px; width:13px; height: 13px;'/></td>"
	    			resultHtml += "<td>" + vo.userName + "</td>";
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.deptName + "</td>";
	    			resultHtml += "<td>" + vo.workStartTime + " ~ " + vo.workEndTime + "</td>";
	    			resultHtml += "<td>" + vo.compareTime + "</td></tr>";
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr><td colspan='5' style='text-align:center'>등록된 정보가 없습니다.</td></tr>";	
	    		}
	    		
	    		$("#attiBoardList tbody").append(resultHtml);
	    		makePageSelPageAtti();
	    	}
	    	
	    	function searchUserConfList(searchType){
	    		if (searchType == "search") {
	    			searchUserName = $("#searchUserName").val();
	    			searchDeptName = $("#searchDeptName").val();
	    			searchTitle = $("#searchTitle").val();
	    			searchStartTime = $("#searchStartTime").val();
	    			searchEndTime = $("#searchEndTime").val();
	    			searchCompareValue = $("[type='radio']:checked").val();
	    		} else {
	    			//새로고침
	    			$("#searchUserName").val("");
	    			$("#searchDeptName").val("");
	    			$("#searchTitle").val("");
	    			$("#searchStartTime").val("");
	    			$("#searchEndTime").val("");
	    			$("[type='radio']:checked").val("");
	    			
	    			searchUserName = "";
	    			searchDeptName = "";
	    			searchTitle = "";
	    			searchStartTime = "";
	    			searchEndTime = "";
	    			searchCompareValue = "";
	    		}
	    		
	    		pageNum = 1;
    			getUserConfList();
    			
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
	    	/* function userConfSave(userid) {
	    		var url = "";
	    		
	    		if(userid == null) {
		    		selectedCheck();
	    		}
	    		
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
	    	} */
	    	
	    	function editUserConf(selectUserId) {
    			var url = "/admin/ezAttitude/editAttitudeUserConf.do?selectUserId=" + selectUserId;
	    		
	    		if (CrossYN()) {
	    			OpenWin = GetOpenWindow(url, "", "340", "180");
	    			
	    			try { OpenWin.focus();} catch (e) { }
	    		} else {
	    			showModalDialog(url, null, "dialogWidth:340px; dialogHeight:180px; status:no; help:no; scroll:no; edge:sunken");
	    		}
	    	}
	    	
	    	//삭제버튼
	    	/* function delUserConf() {
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
	    	} */
	    	
	    	function userDbClick() {
	    		editUserConf($(this).attr('userid'));
	    	}
	    </script>
	</head>
	
	<body class="mainbody">
	    <h1>사용자별 근태관리<span id="mailBoxInfo"></span></h1>
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
<!-- 	  	<div id="mainmenu"> -->
<!-- 	  		<ul class="on"> -->
<!-- 	  			<li class="off"><span onclick="userConfSave()">추가/변경</span></li> -->
<!-- 	  			<li class="off"><span onclick="searchUserConf(false)">검색</span></li> -->
<!-- 	  			<li class="off"><span onclick="delUserConf()">삭제</span></li> -->
<!-- 	  		</ul> -->
<!-- 	  	</div> -->
	  	<!-- <div id="layer_popup" style="width: 500px; position: absolute; left: 10px; top: 130px; background-color: rgb(255, 255, 255); display:none;">
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
	  	</div> -->
	  	
	  	<table id="searchTable" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 5%;">부서</td>
					<td style="width: 12%;"><input type="text" id="searchDeptName" style="width: 90%;"></td>
					<td style="width:5.5%;">이름</td>
					<td style="width: 11%;"><input type="text" id="searchUserName" style="width: 90%;"></td>
					<td style="width: 5%;">근무시간</td>
					<td style="width: 20%;"><span id="topmenu"><input id="searchStartTime" type="text" style="width:80px;"/>&nbsp; ~ <input id="searchEndTime" type="text" style="width:80px;"/></span></td>
				</tr>
				<tr>
					<td style="width: 5%;">직위</td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50"></td>
					<td style="width: 5.5%;">회사규율이랑비교</td>
					<td style="width: 11%;">
						<span style="width: 90%;">
							<input type="radio" name="searchCompareValue" id="searchCompareValueAll" value="" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle;" checked="checked"/>&nbsp;모두
							<input type="radio" name="searchCompareValue" id="searchCompareValue0" value="0" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle;"/>&nbsp;같은
							<input type="radio" name="searchCompareValue" id="searchCompareValue1" value="1" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle;"/>&nbsp;다른
						</span>
					</td>
					<td style=" width:*;" colspan=2>
						<a class="imgbtn"><span onclick="searchUserConfList('search');">검색</span></a>&nbsp;
						<a class="imgbtn"><span onclick="searchUserConfList('refresh');">새로고침</span></a>&nbsp;
					</td>
				</tr>
			</tbody>
		</table>
		
		<table id="attiBoardList" class="mainlist" style="width:100%;">
			<thead>
				<tr>
<!-- 					<th style="width:10%;"><input id="HeaderAllCheckBox" type="checkbox" style="margin: 0px; padding: 0px; width:13px; height: 13px;"/></th> -->
					<th style="width:20%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname">이름</th>
					<th style="width:15%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title">직위</th>
					<th style="width:25%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description">부서</th>
					<th style="width:25%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="work_starttime">근무시간</th>
					<th style="width:5%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="compareTime">1이면다름</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<div id="tblPageRayer">
		</div>
	</body>
</html>