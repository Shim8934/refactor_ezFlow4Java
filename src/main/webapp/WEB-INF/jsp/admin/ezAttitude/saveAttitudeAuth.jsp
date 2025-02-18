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
					<spring:message code='ezAttitude.t188' />
				</c:when>
				<c:otherwise>
					<spring:message code='ezAttitude.t187' />
				</c:otherwise>
			</c:choose>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
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
		    		setDeptName(deptIds.toString(), deptNames.toString());
		    		$('#contentlist .mainlist').html(html);
		    		authRadioSet(authTypes.toString());
	    		</c:if>
   			});
	    	
	    	//사원 세팅
	    	function setSelectedUser(userId, userName) {
	    		selectedUserName = userName;
	    		selectedUser = userId;
	    		$("#txtuser").val(" " + userName);
	    	} 
	    	
	    	//사원선택
	    	function select_person() {
	    		var url = "/admin/ezAttitude/selectAttitudeAuthor.do?companyId=" + companyId;
				window.open(url, "author", GetOpenWindowfeature(705, 615));
	    	}
	    	
	    	//부서선택
	    	var ezattitude_dialogArguments = new Array();
	    	function selectDept() {
	    		if (selectedUser == "" || selectedUser == null) {
	    			alert("<spring:message code='ezAttitude.t195' />");
	    			return;
	    		}
	    		
	    		var para = new Array();
	    		
	    		para[0] = deptIds;
	    		para[1] = deptNames;
	    		para[2] = authTypes;
	    		
	    		ezattitude_dialogArguments[0] = para;
	    		
	    		var url = "/admin/ezAttitude/selectAttitudeAuthorDept.do?companyId=" + companyId + "&userId=" + selectedUser;
				var SelectTarget = window.open(url, "authorDept", GetOpenWindowfeature(500, 575));
				try { SelectTarget.focus(); } catch (e) {
	            }
	    	}
	    	 
	    	//부서 이름 세팅
	    	function setDeptName(pdeptIds, pdeptNames) {
	            if (pdeptIds && pdeptNames) {
	               deptIds = pdeptIds.split(',');
	               deptNames = pdeptNames.split(',');
	            } 
	            else if (pdeptNames == "" || pdeptNames == null) {
	            	deptIds = [];
		            deptNames = [];
	            }
	            
				var deptString = "";
				deptIdStr = "";
				var html = "";
				
				if (deptIds.length == 0) {
					html = "<tr><td colspan='3' style='text-align: center;'><spring:message code='ezAttitude.t130' /></td></tr>";
				} else {
		    		for (var i = 0; i < deptIds.length; i++) {
	    				deptString += deptNames[i] + ", "; //이름
	    				deptIdStr += deptIds[i] + ","; //아이디
		    
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
	   			//스크롤바로 인한 밀림현상 막기
	   			if (deptIds.length > 5) {
	   				$(".mainlist th:eq(1)").css("padding-right", "20px");
	   				$(".mainlist th:eq(2)").css("padding-right", "30px");
	   			} else {
	   				$(".mainlist th:eq(1)").css("padding-right", "");
	   				$(".mainlist th:eq(2)").css("padding-right", "");
	   			}
	    	}	  
	    	
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
	    	<c:choose>
				<c:when test="${not empty selectedUser }">
					<spring:message code='ezAttitude.t188' />
				</c:when>
				<c:otherwise>
					<spring:message code='ezAttitude.t187' />
				</c:otherwise>
			</c:choose>
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezAttitude.t198' /></th>
	            <td style="padding: 2px 5px;">
	                <input id="txtuser" value="${selectedUserName }" type="text" style="margin-top:1px; width:318px" onfocus="this.blur();" readonly="readonly" />
	                <a class="imgbtn imgbck2" style="margin-top:1px;"><span onclick="select_person()"><spring:message code='ezAttitude.t199' /></span></a>                
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezAttitude.t190' /></th>
	            <td style="height: 60px; width: 400px; padding-top: 4px;">
	                <textarea rows="3" id="txtdept" style="height: 43px; width:306px; resize:none; overflow: auto; border-radius: 3px;" onfocus="this.blur();" readonly="readonly" ></textarea>
	                <a class="imgbtn imgbck2" style="margin-top: 15px;"><span onclick="selectDept()"><spring:message code='ezAttitude.t199' /></span></a>                
	            </td>
	        </tr>
	    </table>
	    <br/>
	    <!-- 리스트 -->
		<div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
                    <th style="width: 50%; padding-left:15px;"><span><spring:message code='ezAttitude.t9' /></span></th>
                    <th style="width: 25%; text-align: center;"><span><spring:message code='ezAttitude.t193' /></span></th>
                    <th style="width: 25%; text-align: center;"><span><spring:message code='ezAttitude.t194' /></span></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 160px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
                    <tr>
                        <td colspan="3" style="text-align: center;"><spring:message code='ezAttitude.t130' /></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="saveAuthDept();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>

