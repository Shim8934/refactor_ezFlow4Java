<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t42' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">	
	    	var selectedUser;
	    	var selectedUserName;
	    	var companyId = "<c:out value='${companyId}'/>";
	    	var deptIds = [];
	    	var deptNames = [];
	    	var userDeptId;
	    	var userDeptName;
	    	var userAddIds = [];
	    
	    	//사원 세팅
	    	function setSelectedUser(userId, userName){
	    		selectedUserName = userName;
	    		selectedUser = userId;
	    		$("#txtuser").val(" " + userName);
	    	} 
	    	
	    	//사원선택
	    	function select_person(){
	    		var url = "/admin/ezJournal/authorDetail.do";
				url+="?companyId="+companyId;
				window.open(url, "authorDetail", GetOpenWindowfeature(950, 620));
	    	}
	    	
	    	//부서선택
	    	function selectDept(){
	    		if(!selectedUser){
	    			alert("<spring:message code='ezJournal.t209'/>");
	    		}else{
		    		var url = "/admin/ezJournal/selectAuthorDept.do";
					url+="?companyId=" + companyId + "&userId=" + selectedUser;
					window.open(url, "authorDept", GetOpenWindowfeature(550, 600));
	    		}
	    	}
	    	 
	    	//부서 이름 세팅
	    	function setDeptName(pdeptIds,pdeptNames){
	    		if (pdeptIds && pdeptNames) {
					deptIds = JSON.parse(pdeptIds);
					deptNames = JSON.parse(pdeptNames);
				}
				var deptString = "";
	    		for (var i = 0; i < deptNames.length; i++) {
	    			deptNames[i] = deptNames[i];
	    			if(i != 0){
			    		deptString += ", " + deptNames[i];
	    			} else {
	    				deptString = deptNames[i];
	    			}
				}
	    		$("#txtdept").html(deptString);
	    	}	  
	    	
	    	//열람권한 저장
	    	function insertAuthDept(){
	    		if(deptIds.length!=0){
					$.ajax({
		   				type:"POST",
		   				dataType:"text",
		   				url:"/admin/ezJournal/saveAuthor.do",
		   				data:{
		   					userId:selectedUser,
		   					depts:JSON.stringify(deptIds)
		   				},
		   				success: function(result) {
		   					if (result == "ok") {
			   					alert("<spring:message code='ezJournal.t137'/>");
		   						opener.location.reload();
		   						window.close();
		   					}
		   				}
		   			});
	    		} else {
   					alert("<spring:message code='ezJournal.t168'/>");
	    		}
	   		}
	    	
	    	$(document).ready(function(){
	    		<c:if test="${not empty selectedUser }">
			    	<c:forEach items="${deptList }" var="dept">
			    		<c:choose>
				    		<c:when test="${dept.mine eq 'yes' }">
				    			userDeptName = '${fn:replace(dept.deptName, "'", "\\'") }';
				    			userDeptId = '${fn:replace(dept.deptId, "'", "\\'") }';
					    	</c:when>
				    		<c:when test="${dept.mine eq 'add' }">
				    			userAddIds.push('${fn:replace(dept.deptId, "'", "\\'") }');
					    	</c:when>
					    	<c:otherwise>
								deptNames.push('${fn:replace(dept.deptName, "'", "\\'") }');
								deptIds.push('${fn:replace(dept.deptId, "'", "\\'") }');
							</c:otherwise>
						</c:choose>
			    	</c:forEach>
			    	setSelectedUser("<c:out value='${selectedUser}'/>", "<c:out value='${selectedUserName}'/>");
		    		setDeptName();
	    		</c:if>
   			});
	    	
		</script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezJournal.t42' /></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="window.close()"></span></li>
	        </ul>
	    </div>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezJournal.t141' /></th>
	            <td>
	                <input id="txtuser" value="" type="text" style="width:350px" onfocus="this.blur();" readonly="readonly" />
	                <a class="imgbtn imgbck2"><span onclick="select_person()"><spring:message code='ezJournal.t223' /></span></a>                
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezJournal.t142' /></th>
	            <td>
	                <textarea rows="3" id="txtdept" style="margin-top:2px; margin-bottom:2px; width:338px; resize: none; vertical-align:middle;" onfocus="this.blur();" readonly="readonly" ></textarea>
	                <a class="imgbtn imgbck2" style="vertical-align:middle !important;"><span onclick="selectDept()"><spring:message code='ezJournal.t223' /></span></a>                
	            </td>
	        </tr>
	    </table>
	    <div class="btnpositionNew">
	        <a class="imgbtn"><span onclick="insertAuthDept();" ><spring:message code='ezJournal.t26' /></span></a>
	    </div>
	</body>
</html>

