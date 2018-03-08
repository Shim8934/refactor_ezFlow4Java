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
    <script type="text/javascript">
    	var pCompanyId = ""; //현재 선택된 회사의 아이디
    	
    	function company_change(){
    		pCompanyId = $("select[name=ListCompany]").val();
    		getUserConfList();
    	}
    	
    	function getUserConfList(){
    		$.ajax({
    			data : "GET",
    			dataType : "json",
    			async : false,
    			url : "/admin/ezAttitude/attitudeUserConfList.do",
    			data : {companyId : pCompanyId},
    			success : function(result){
    				getUserConfList_after(result);
    			}
    		});
    	}
    	
    	function getUserConfList_after(result){
    		var resultHtml = "";
    		$(".mainlist tbody").html("");
    		
    		for(var resultLeng = 0; resultLeng < result.length; resultLeng ++){
    			resultHtml += "<tr><td><input type='checkbox' style='margin: 0px; padding: 0px; width:13px; height: 13px;'/></td>"
    			   			+ "<td>" + (resultLeng + 1) + "</td>"
    			   			+ "<td>" + result[resultLeng].userName+ "</td>"
    			   			+ "<td>" + result[resultLeng].userTitle+ "</td>"
    			   			+ "<td>" + result[resultLeng].deptName+ "</td>"
    			   			+ "<td>" + result[resultLeng].workStartTime + " ~ " + result[resultLeng].workEndTime + "</td></tr>";
    		}
    		
    		if(resultHtml == ""){
    			resultHtml = "<tr><td colspan='6' style='text-align:center'>등록된 정보가 없습니다.</td></tr>";
    		}
    		
    		$(".mainlist tbody").append(resultHtml);
    		
    		makePageSelPageAtti();
    	}
    	
    	function searchUserConf(){
    		if($("#layer_popup").css("display") == "none"){
    			$("#layer_popup").css("display", "");
    		} else {
    			$("#layer_popup").css("display", "none");
    		}
    	}
    	
    	function userConfAddModify(){
    		if (CrossYN()) {
    			//GetOpenWindow(url, target, popUpW, popUpH, resizeFlag)
    			OpenWin = GetOpenWindow("url", "", , );
    			try { OpenWin.focus();} catch (e) { }
    		} else {
    			showModalDialog("url", null, "dialogHeight:400px; dialogWidth:465px; status:no; help:no; scroll:no; edge:sunken");
    		}
    	}
    </script>
	</head>
<body>
	<body class="mainbody">
	    <h1>사용자별 근태관리</h1>
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
	  			<li class="off"><span onclick="userConfAddModify()">추가/변경</span></li>
	  			<li class="off"><span onclick="searchUserConf()">검색</span></li>
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
	  								<a class="imgbtn"><span onclick="">검색</span></a>
	  								<a class="imgbtn"><span onclick="">취소</span></a>
	  							</td>
	  						</tr>
	  					</tbody>
	  				</table>
	  			</div>
	  		</div>
	  		<div class="shadow">
	  		</div>
	  	</div>
		<table class="mainlist" style="width:100%;">
			<thead>
				<tr>
					<th style="width:20px;"><input type="checkbox" style="margin: 0px; padding: 0px; width:13px; height: 13px;"/></th>
					<th style="width:29px;">NO</th>
					<th style="width:300px">이름</th>
					<th style="width:200px">직위</th>
					<th style="width:400px">부서</th>
					<th style="width:600px">근무시간</th>
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