<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code ='ezAttitude.i1' />" type="text/css"/>
	    <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
	    <link rel="stylesheet" href='/css/Tab.css' type="text/css" />
	    <link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
	    
	    <style>
	    	.portlet_tabpart01{position:relative; margin:15px 0px 0px 0px; clear: both; z-index: initial;}
	    	.portlet_tabpart01_top p .tabover{position: relative; border:1px solid #999; border-bottom:1px solid #eee; background:white; color:#333; z-index: initial;}
			.portlet_tabpart01_top p .tabon {position: relative; border:1px solid #999; border-bottom:1px solid #eee; background:white; color:#333; z-index: initial;}
	    </style>
	    
		<script type="text/javascript" language="javascript">
			var Tab1_SelectID = "modify";
			var pCompanyId = "${adminCompany}";
	    	var pDeptId = ""; //현재 선택된 부서의 아이디
	    	//검색조건 저장 변수
	    	var searchUserName = ""; // 검색조건 (사원명)
	    	var searchDeptName = ""; // 검색조건 (부서명)
	    	var searchTitle = ""; // 검색조건 (직위)
	    	var searchAttitudeType = "total"; // 검색조건(근태유형)
	    	//검색조건 (근무시간) Hr,Min 묶음으로
	    	var searchStartDate = "${searchStartDate}";
	    	var searchEndDate = "${searchEndDate}";
	    	var pageNum = 1; // 페이지 ==> 초기값 설정
	    	var totalCount = "" // 게시물 총 갯수
	    	var totalPage = ""; // 게시판의 총 페이지갯수
	    	var orderCell = ""; // 정렬 명
	    	var orderOption = ""; // 정렬 형식(ASC, DESC)
	    	var selectedDept = "${selectedDept}";
	    	var listSize = 19;
	    	
	        document.onselectstart = function () { return false; };
	        
	        $(document).ready(function(){
	        	if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	        	
	            document.getElementById(Tab1_SelectID).setAttribute("class", "tabon");
	            
	            if (document.getElementById("ListDept").length == 0) {
		            alert("부서 정보가 없습니다.");
		        } else {
		    		if (selectedDept != null) {
		    			$('#ListDept').val(selectedDept);
		    		} else {
			            document.getElementById("ListDept").selectedIndex = 0;
		    		}
		        }

	            ChangeTab(document.getElementById(Tab1_SelectID));
	        });
	        
	        function ChangeTab(obj) {
	        	pSelectTab = obj.getAttribute("id");

	            getFullList();
	        }
	        
	        function dept_change() {
	    		$('#receiverlist').empty();
	    		
	    		getList();
	    	}
	        
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        
	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id){
	                obj.className = "";
	            }
	        }
	        
	        function Tab1_MouseClick(obj) {
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null){
	                    document.getElementById(Tab1_SelectID).className = "";
	                }
	                
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                
	                ChangeTab(obj);
	            }
	        }
	        
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	                    }
	                }
	            }
	        }
	        
	        function getFullList() {
	        	var resultHtml = "";
	        	switch (Tab1_SelectID) {
	    		case "modify":
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='displayname'><spring:message code='ezAttitude.t10' /></th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='title'><spring:message code='ezAttitude.t11' /></th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='description'><spring:message code='ezAttitude.t9' /></th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='start_date'><spring:message code='ezAttitude.lhj17' /></th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='type_name'><spring:message code='ezAttitude.lhj18' /></th>";
	    			break;
	    		case "absent":
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='displayname'><spring:message code='ezAttitude.t10' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='title'><spring:message code='ezAttitude.t11' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='description'><spring:message code='ezAttitude.t9' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='start_date'><spring:message code='ezAttitude.lhj17' /></th>";
	    			break;
	    		case "history":
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='writer_Name'><spring:message code='ezAttitude.t10' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='writer_Title'><spring:message code='ezAttitude.t11' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='writer_Dept_Name'><spring:message code='ezAttitude.t9' /></th>";
	    			resultHtml += "<th style='width:15%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='change_Startdate'>일시</th>";
	    			resultHtml += "<th style='width:18%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='change_Startdate'></th>";
	    			resultHtml += "<th style='width:6%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='change_Type_Name'><spring:message code='ezAttitude.lhj18' /></th>";
	    			resultHtml += "<th style='width:8%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='change_Type_Name'></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='appr_User_Name'>수정자</th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='appr_Date'>수정일시</th>";
	    			break;
	    		}
	        	
	        	$("#contentlist .mainlist thead tr").html(resultHtml);
	        	getList();
	        }
	        
	        function getList() {
	        	switch (Tab1_SelectID) {
	    		case "modify":
	    			//근태관리//list가져와서 tbodyhtml();
	    			break;
	    		case "absent":
	    			//근태입력//list가져와서 tbodyhtml();
	    			break;
	    		case "history":
	    			//관리내역//list가져와서 tbodyhtml();
// 	    			getAttitudeHistoryList();
	    			break;
	    		}
	        }
	        
	        function goToPageByNum(pCurPage){
	    		if (pCurPage == 0 || totalPage < pCurPage) {
	    			return;
	    		} else {
		    		pageNum = pCurPage;
	    		}
	    		
	    		getList();
	    	}
	        
	        function searchPopup() {
	        	//searchPopup 안에 OK넣고 온클릭에  전역변수:Tab1_SelectID로 구분해서 list가져오는거 분기
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#searchPopup").css("left", popupX);
	        	
	        	$("#searchPopup").modal();
	        }
	        
	        function layerHidden() {
		        $.modal.close();
		    }
	    </script>
	</head>
	<body class="mainbody">
		<h1><p style="padding-left:5px">전체근태관리</p></h1>
	    <div class="portlet_tabpart01" style="margin-bottom:16px;">
	        <div class="portlet_tabpart01_top" id="tab1">
	            <p><span id="modify" style="width:100px; text-align: center;">근태관리</span></p>
	            <p><span id="absent" style="width:100px; text-align: center;">근태입력</span></p>
	            <p><span id="history" style="width:100px; text-align: center;">관리내역</span></p>
	        </div>
	    </div>
	    <div>
	    	<div id="mainmenu">
				<ul>
		      		<li><span onclick="searchPopup();">검색</span></li>
					<li style="background:none; padding-right:2px; cursor:default;" class="off"><img src="/images/i_bar.gif" alt=""></li>
					<li>
		      			<select name="ListDept" id="ListDept" onchange="dept_change()" style="margin-top:4px; padding-right:40px; width:100%">
							<c:forEach var = "dept" items="${deptList}">
								<c:if test="${dept.mine ne 'yes' }">
									<option value="<c:out value='${dept.deptId}'/>" auth="${dept.authType}"><c:out value='${dept.deptName}'/></option>
								</c:if>
							</c:forEach>
			      		</select>
		      		</li>
		      	</ul>
		  	</div>
	    </div>
	    
	    <div id="contentlist" style="width:100%; height:620px;">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr>
<!-- 					근태관리 -->
						<%-- <th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname"><spring:message code='ezAttitude.t10' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title"><spring:message code='ezAttitude.t11' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description"><spring:message code='ezAttitude.t9' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="start_date"><spring:message code='ezAttitude.lhj17' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="type_name"><spring:message code='ezAttitude.lhj18' /></th> --%>
						
<!-- 						근태입력 -->
						<%-- <th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname"><spring:message code='ezAttitude.t10' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title"><spring:message code='ezAttitude.t11' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description"><spring:message code='ezAttitude.t9' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="start_date"><spring:message code='ezAttitude.lhj17' /></th> --%>
						
<!-- 						근태내역 -->
						<%-- <th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="writer_Name"><spring:message code='ezAttitude.t10' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="writer_Title"><spring:message code='ezAttitude.t11' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="writer_Dept_Name"><spring:message code='ezAttitude.t9' /></th>
						<th style="width:15%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="change_Startdate">일시</th>
						<th style="width:18%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="change_Startdate"></th>
						<th style="width:6%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="change_Type_Name"><spring:message code='ezAttitude.lhj18' /></th>
						<th style="width:8%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="change_Type_Name"></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="appr_User_Name">수정자</th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="appr_Date">수정일시</th> --%>
						
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
	  	</div>
	    
	    <div style="color: #666; padding-top: 10px"></div>
		<div id="tblPageRayer"></div>
	    
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
	    <div id="searchPopup" class="popupwrap2" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:50px;">
			<div class="popupwrap3">
				<!-- 내용 -->
			    <table class="popuplist" id="addpopup_list" style="width:440px;margin:10px 0px 0px 1px;">
			    	<tr>
						<th class="layerHeader" colspan="2"><img src="/images/kr/left/left_mail.png" style="vertical-align: middle;padding-bottom:1px"/>&nbsp;간단주소록 추가</th>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">이름</th>
						<td><input type="text" id="qname" name="qname" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="24"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">회사</th>
						<td><input type="text" id="qcompany" name="qcompany" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="24"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">전화번호</th>
						<td><input type="text" id="qcomphone" name="qcomphone" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="20"></td>
					</tr>
					<tr>
						<th style="width:90px;height:30px">휴대폰</th>
						<td><input type="text" id="qmobile" name="qmobile" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="20"></td>
					</tr>
					<tr>
						<th style="height:30px">이메일</th>
						<td><input type="text" id="qemail" name="qemail" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="100"></td>
					</tr>
				</table>
				<!-- /내용 -->
				<br />
				<div style="text-align:center;">
<!-- 					<a class="imgbtn"><span onclick="quick_add()" >추가</span></a> -->
<!-- 					<a class="imgbtn" rel="modal:close"><span onclick="quick_add_close();">취소</span></a> -->
			    </div>
			</div>
		</div>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>