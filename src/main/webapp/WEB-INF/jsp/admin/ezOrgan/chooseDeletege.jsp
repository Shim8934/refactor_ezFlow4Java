<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezOrgan.t00008' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript">
		var ReturnFunction;
		var data1 = window.opener.testObj.dataList;
		var data2 = window.opener.testObj.dataList2;
		var data3 = window.opener.testObj.dataList3;
		var data4 = window.opener.testObj.dataList4;
		var type = "<c:out value='${type}'/>";
		var lang = "<c:out value='${lang}'/>";
		
		// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 > 삭제 - 겸직/부서 별 권한 설정 기능을 위한 변수 추가				
		var permissionBasisDeptYN = "<c:out value='${permissionBasisDeptYN}' />" // 겸직/부서 별 권한 부여 옵션 사용여부 

	    window.onload = function () {
			if(lang == "2"){
				$('#radio1').next().text("Delete" + " <c:out value='${type}'/> " + " <spring:message code='ezOrgan.mse6' />");
			}
		}
		function Schedule_Confirm(id) {
			if (radio1.checked) {
				ReturnFunction = "MODE";
			} else {
				ReturnFunction = "ALL";
			}
			
			// 2023-07-31 전인하 - 비직관적인 변수명 (cData) 수정
			var optionCheckText = "";
            if (ReturnFunction == "ALL") {
                optionCheckText = strLang33 + "<spring:message code='ezAddress.kje01' />" + strLang20;
            } else {
                optionCheckText = strLang33 + type + strLang20;
            }
			
			var checked = confirm(optionCheckText);
			
			if (checked == true) {
                try {
                    window.opener.Permissions_Del(ReturnFunction);
                } catch (e) {
                    console.log(e);
                }
			    end_confirm();
		    }
	    }
	     
		//팝업창 닫기
		function end_confirm() {
			window.close();
		}
				
	    </script>
	</head>
	<body class="popup">
	<h1><spring:message code='ezOrgan.t00008' /></h1>
		<div id="close">
	  		<ul>
          		<li><span onclick="end_confirm()"></span></li>
        	</ul>
	  	</div>
	  	<!-- <table class="contentList" id="contentList" style="width:100%;">
	  		<th>이름</th>
	  		<th>부서</th>
	  	</table> -->
		<table class="content" style="width:100%">
			<tr>
		    	<td>
		    		<input type="radio" id="radio1" name="radiobutton" value="radiobutton"  checked>
		    		<c:if test="${lang eq  '3'}">
		      			<label for="radio1"><c:out value='${type}'/><spring:message code='ezOrgan.mse6' /></label>
		      		</c:if>
		      		<c:if test="${lang ne '3'}">
		      			<label for="radio1"><c:out value='${type}'/> <spring:message code='ezOrgan.mse6' /></label>
		      		</c:if>
		      	</td>
		  	</tr>
		  	<tr>
		    	<td>
		    		<input type="radio" id="radio2" name="radiobutton" value="radiobutton" >
		      		<label for="radio2"><spring:message code='ezOrgan.mse7' /></label>
		      	</td>
		  	</tr>  
		</table>
		<%-- 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 > 삭제 - 겸직/부서 별 권한 설정 기능 사용 시 안내문구 추가 --%>
		<c:if test="${permissionBasisDeptYN eq 'Y'}">
		<div class ="content" style="width:100%; margin:0px; border:none; color:red">
           <span><spring:message code='ezOrgan.JIH001' /></span>
		</div>
        </c:if>
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="ContactOutButton" onClick="Schedule_Confirm()" ><span><spring:message code='ezOrgan.t142' /></span></a>
		</div> 
	</body>
</html>