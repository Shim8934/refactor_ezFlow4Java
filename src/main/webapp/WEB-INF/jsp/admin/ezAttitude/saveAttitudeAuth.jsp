<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>권한추가</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript">	
	    	var selectedUser = "${selectedUser }";
// 	    	var selectedUser;
	    	var selectedUserName= "";
	    	var companyId = "<c:out value="${companyId}" />";
	    	var deptIdStr = "";
	    	var deptIds = [];
	    	var deptNames = [];
	    	var userDeptId;
	    	var userDeptName;
	    
	    	$(document).ready(function(){
	    		//만약 권한자 선택시 권한이 있는 부서가 있으면 출력해준다.
	    		<c:if test="${not empty selectedUser }">
			    	<c:forEach items="${deptList }" var="dept">
			    		<c:choose>
				    		<c:when test="${dept.mine eq 'yes' }">
				    			userDeptName = '${fn:replace(dept.deptName, "'", "\\'") }';
				    			userDeptId = '${fn:replace(dept.deptId, "'", "\\'") }';
					    	</c:when>
					    	<c:otherwise>
								deptNames.push('${fn:replace(dept.deptName, "'", "\\'") }');
								deptIds.push('${fn:replace(dept.deptId, "'", "\\'") }');
							</c:otherwise>
						</c:choose>
			    	</c:forEach>
			    	setSelectedUser("${selectedUser }","${selectedUserName }");
		    		setDeptName();
	    		</c:if>
   			});
	    	
	    	//사원 세팅
	    	function setSelectedUser(userId, userName){
	    		selectedUserName = userName;
	    		selectedUser = userId;
	    		$("#txtuser").val(" " + userName);
	    	} 
	    	
	    	//사원선택
	    	function select_person(){
	    		var url = "/admin/ezAttitude/selectAttitudeAuthor.do";
				url+="?companyId="+companyId;
				window.open(url, "author", GetOpenWindowfeature(950, 600));
	    	}
	    	
	    	//부서선택
	    	function selectDept(){
	    		if (selectedUser == "" || selectedUser == null) {
	    			alert("권한자를 선택해주세요");
	    			return;
	    		}
	    		var url = "/admin/ezAttitude/selectAttitudeAuthorDept.do";
				url+="?companyId="+companyId+"&userId="+selectedUser;
				window.open(url, "authorDept", GetOpenWindowfeature(500, 540));
	    	}
	    	 
	    	//부서 이름 세팅
	    	function setDeptName(pdeptIds, pdeptNames){
	    		if (pdeptIds && pdeptNames) {
					deptIds = eval(pdeptIds);
					deptNames = eval(pdeptNames);
				}
				var deptString;
	    		for (var i = 0; i < deptNames.length; i++) {
	    			if(i!=0){
			    		deptString += ", " + deptNames[i];
			    		deptIdStr += "," + deptIds[i];
	    			} else {
	    				deptString = deptNames[i];
	    				deptIdStr = deptIds[i];
	    			}
				}
	    		console.log(deptIds);
	    		$("#txtdept").val(deptString);
	    	}	  
	    	
	    	//권한 저장
	    	function saveAuthDept(){
// 	    		if (selectedUser == "" || selectedUser == null) {
// 	    			alert("권한자를 선택해주세요");
// 	    			return;
// 	    		}
// 	    		if (deptIdStr == "" || deptIdStr == null) {
// 	    			alert("권한 부서를 선택해주세요");
// 	    			return;
// 	    		}
	    		if (deptIds.length!=0) {
					$.ajax({
		   				type:"post",
		   				url:"/admin/ezAttitude/saveAttitudeAuthor.do",
		   				data:{
		   					selectedUser : selectedUser,
		   					companyId : companyId,
		   					deptIds : deptIdStr
		   				},
		   				success: function(){
		   					alert("권한이 등록되었습니다.");
	   						opener.company_change();
	   						window.close();
		   				},
		   				error : function() {
		   					alert("권한을 등록하는 도중 에러 발생");
		   				}
		   			});
	    		} else {
	    			alert("권한 부서를 선택해 주세요.");
	    		}
	   		}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>권한추가</h1>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center">권한자</th>
	            <td>
	                <input id="txtuser" value="${selectedUserName }" type="text" style="margin-top:2px; width:80%" onfocus="this.blur();" readonly="readonly" />
	                <a href="#" class="imgbtn" style="margin-left: 20px; margin-top:2px;"><span onclick="select_person()">지정</span></a>                
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center">권한부서</th>
	            <td>
<!-- 	                <input id="txtdept" type="text" style="margin-bottom:2px; width:80%" onfocus="this.blur();" readonly="readonly" /> -->
	                <textarea rows="3" id="txtdept" type="text" style="margin-top:2px; width:77%; resize:none;" onfocus="this.blur();" readonly="readonly" ></textarea>
	                <a href="#" class="imgbtn" style="margin-left: 20px; margin-top: 15px;"><span onclick="selectDept()">지정</span></a>                
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="saveAuthDept();" >저장</span></a>
	        <a class="imgbtn"><span onclick="window.close();">취소</span></a>      
	    </div>
	</body>
</html>

