<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<c:choose>
				<c:when test="${not empty selectedUser }">
					권한수정
				</c:when>
				<c:otherwise>
					권한등록
				</c:otherwise>
			</c:choose>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript">	
	    	var selectedUser = "${selectedUser }";
	    	var selectedUserName= "";
	    	var companyId = "<c:out value="${companyId}" />";
	    	var deptIdStr = "";
	    	var deptIds = [];
	    	var deptNames = [];
	    	var authTypes = [];
	    	var userDeptId;
	    	var userDeptName;
	    
	    	$(document).ready(function(){
	    		//만약 권한자 선택시 권한이 있는 부서가 있으면 출력해준다.(수정시)
	    		<c:if test="${not empty selectedUser }">
	    			var html = "";
			    	<c:forEach items="${deptList }" var="dept">
			    		<c:choose>
				    		<c:when test="${dept.mine eq 'yes' }">
				    			userDeptName = '${fn:replace(dept.deptName, "'", "\\'") }';
				    			userDeptId = '${fn:replace(dept.deptId, "'", "\\'") }';
					    	</c:when>
					    	<c:otherwise>
								deptNames.push('${fn:replace(dept.deptName, "'", "\\'") }');
								deptIds.push('${fn:replace(dept.deptId, "'", "\\'") }');
								authTypes.push('${fn:replace(dept.authType, "'", "\\'") }');
								html += "<tr>";
								html += "<td style='width:50%;color:gray;padding-left:15px;'>${dept.deptName }</td>";
								html += "<td style='width:25%;color:gray;text-align: center;'><input type='radio' name='${dept.deptId }' value='R' /></td>";
								html += "<td style='width:25%;color:gray;text-align: center;'><input type='radio' name='${dept.deptId }' value='M' /></td>";
								html += "</tr>";
							</c:otherwise>
						</c:choose>
			    	</c:forEach>
			    	setSelectedUser("${selectedUser }","${selectedUserName }");
		    		setDeptName();
		    		$('#contentlist .mainlist').html(html);
		    		authRadioSet(authTypes);
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
				window.open(url, "author", GetOpenWindowfeature(705, 575));
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
	    		
				var deptString = "";
				deptIdStr = "";
				var html = "";
				
				if (deptIds.length == 0) {
					html = "<tr></tr>";
				} else {
		    		for (var i = 0; i < deptIds.length; i++) {
	    				deptString += deptNames[i] + ", "; //이름
	    				deptIdStr += deptIds[i] + ","; //아이디 필요한가?
		    
	    				//리스트
						html += "<tr>";
						html += "<td style='width:50%;color:gray;padding-left:15px;'>"+deptNames[i]+"</td>";
						html += "<td style='width:25%;color:gray;text-align: center;'><input type='radio' name='"+deptIds[i]+"' value='R' /></td>";
						html += "<td style='width:25%;color:gray;text-align: center;'><input type='radio' name='"+deptIds[i]+"' value='M' /></td>";
						html += "</tr>";
					}
		    		//마지막 ',' 제거
		   			deptString = deptString.slice(0, -2);
		   			deptIdStr = deptIdStr.slice(0, -1);
				}
	   			//권한부서란에 부서명 출력
	    		$("#txtdept").val(deptString);
	   			//리스트 출력
	    		$('#contentlist .mainlist').html(html);
	   			
	   			alert($("#contentlist").scrollHeight);
	   			alert($("#contentlist").clientHeight);
	    	}	  
	    	
	    	//권한 라디오 체크
	        function authRadioSet(pauthTypes) {
	            if (pauthTypes) {
	            	authTypes = eval(pauthTypes);
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
	    	function saveAuthDept(){
	    		if (deptIdStr == "" || deptIdStr == null) {
	    			alert("권한 부서를 선택해주세요");
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
	    		if (deptIds.length != 0) {
					$.ajax({
		   				type:"post",
		   				url:"/admin/ezAttitude/saveAttitudeAuthor.do",
		   				data:{
		   					selectedUser : selectedUser,
		   					companyId : companyId,
		   					deptIds : deptIdStr,
		   					authTypes : authlist
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
	    <h1>
	    	<c:choose>
				<c:when test="${not empty selectedUser }">
					권한수정
				</c:when>
				<c:otherwise>
					권한등록
				</c:otherwise>
			</c:choose>
	    </h1>
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
	    <br/>
	    <!-- 리스트 -->
		<div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
                    <th style="width: 50%; padding-left:15px;"><span>부서</span></th>
                    <th style="width: 25%; text-align: center;"><span>열람</span></th>
                    <th style="width: 25%; text-align: center;"><span>관리</span></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 160px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
                    <tr>
                        <td style="text-align: center;">
<!--                             <img src="/images/email/progress_img.gif" /> -->
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="btnposition">
	        <a class="imgbtn"><span onclick="saveAuthDept();" >저장</span></a>
	        <a class="imgbtn"><span onclick="window.close();">취소</span></a>      
	    </div>
	</body>
</html>

