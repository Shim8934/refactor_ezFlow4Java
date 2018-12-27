<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			전체 연차 등록/수정
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">	
	    
	    	$(document).ready(function(){
   			});
	    	 
	    	//권한 라디오 체크
	        function authRadioSet(pauthTypes) {
	            if (pauthTypes) {
	            	authTypes = pauthTypes.split(',');
		        }
	            
	        	for (var i = 0; i < deptIds.length; i++) {
	        		var authType = "";
	        		if (authTypes[i] == "" || authTypes[i] == null) {
	        			authType = "R";
	        		} else {
	        			authType = authTypes[i];
	        		}
	        		$("#contentlist .mainlist input[name='"+ deptIds[i] +"']:input[value='" + authType + "']").prop('checked', true);
 	        	}
	        }
	    	
	    	//권한 저장
	    	function saveAuthDept() {
	    		if (deptIdStr == "" || deptIdStr == null) {
	    			alert("<spring:message code='ezAttitude.t196' />");
	    			return;
	    		}

	        	var length = $('#contentlist .mainlist input[type=radio]').length / 2;
	        	var authlist = "";
	        	var pdeptIds = deptIdStr.split(",");
	        	for (var i = 0; i < length; i++) {
	        		var type = $("#contentlist .mainlist input[name='"+ pdeptIds[i] +"']:checked").val();
	        		authlist += type + ",";
	        		if (i == (length-1)) {
	        			authlist = authlist.slice(0, -1);
	        		}
	        	}
				$.ajax({
	   				type:"post",
	   				url:"/admin/ezAttitude/saveAttitudeAuthor.do",
	   				dataType : "text",
	   				data:{
	   					selectedUser : selectedUser,
	   					companyId : companyId,
	   					deptIds : deptIdStr,
	   					authTypes : authlist
	   				},
					success : function(resultStatus) {
	            		if (resultStatus == "success") {
	   						opener.company_change();
	   						window.close();
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
	            	},
	   				error : function() {
	   					alert("<spring:message code='ezAttitude.t175' />");
	   				}
	   			});
	   		}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	전체 연차 등록/수정
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center" rowspan="2">총 연차수</th>
	            <td>
	            	<input name="flagCheck" id="Radio1" type="radio" value="all" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange=""/><label for="Radio1">&nbsp;총 연차수를 변경하기</label>
	            </td>
	        </tr>
	        <tr>
	            <td>
					<input name="flagCheck" id="Radio2" type="radio" value="0" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange=""/><label for="Radio2">&nbsp;현재 총 연차수에서 더하기</label>
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center">연차수</th>
	            <td>
	            	<input id="annualCnt" type="text" style="width:100%" value="">
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center">수정사유</th>
	            <td>
	            	<textarea rows="5" id="modifyReason" style="height: 100px; width:338px; resize:none; overflow: auto;" ></textarea>
	            </td>
	        </tr>
	    </table>
	    <br/>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="saveAuthDept();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>