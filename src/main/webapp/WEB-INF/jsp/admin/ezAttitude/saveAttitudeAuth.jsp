<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t6' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />		
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript">	
	    	var selectedUser = "<c:out value="${selectedUser }" />"
	    	var companyId = "<c:out value="${companyId}" />";
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
		    		setDeptName();
    			</c:if>
   			});
	    	
	    	//사원선택
	    	function select_person(){
	    		var url = "/admin/ezAttitude/selectAttitudeAuthor.do";
				url+="?companyId="+companyId;
				window.open(url, "author", "width=735, height=560");
	    	}
	    	
	    	//부서선택
	    	function selectDept(){
	    		var url = "/admin/ezAttitude/selectAttitudeAuthorDept.do";
				url+="?companyId="+companyId+"&userId="+selectedUser;
				window.open(url, "authorDept", "width=500, height=550");
	    	}
	    	 
	    	//부서 이름 세팅
	    	function setDeptName(){
				var deptString;
				if(deptNames.length<4){
		    		for (var i = 0; i < deptNames.length; i++) {
		    			if(i!=0){
				    		deptString += " ,"+deptNames[i];
		    			} else {
		    				deptString=deptNames[i];
		    			}
					}
				} else {
					deptString = deptNames[0]+" <spring:message code='ezJournal.t124' /> "+ (deptNames.length-1);
				}
	    		$("#txtdept").val(deptString);
	    	}	  
	    	
	    	//권한 저장
	    	function insertAuthDept(){
	   			var jsonString = JSON.stringify({"userId":selectedUser,"depts":deptIds});
	   			alert(jsonString);
				$.ajax({
	   				type:"post",
	   				url:"/admin/ezAttitude/saveAttitudeAuthor.do",
	   				contentType:"application/json;",
	   				data:jsonString,
	   				success: function(){
   						opener.location.reload();
   						window.close();
	   				},
	   				error : function() {
	   					alert("권한을 추가하는 도중 에러 발생");
	   				}
	   			});
	   		}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>권한추가</h1>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center">권한자</th>
	            <td>
	                <input id="txtuser" value="${selectedUserName }" type="text" style="margin-bottom:2px; width:80%" onfocus="this.blur();" readonly="readonly" />
	                <a href="#" class="imgbtn"><span onclick="select_person()">지정</span></a>                
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center">권한부서</th>
	            <td>
	                <input id="txtdept" type="text" style="margin-bottom:2px; width:80%" onfocus="this.blur();" readonly="readonly" />
	                <a href="#" class="imgbtn"><span onclick="selectDept()">지정</span></a>                
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="insertAuthDept();" >저장</span></a>
	        <a class="imgbtn"><span onclick="window.close();">취소</span></a>      
	    </div>
	</body>
</html>

