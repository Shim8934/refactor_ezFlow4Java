<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/ListView_list.js')}"></script>	
	    <script type="text/javascript">
	    	var adminCompany = "${adminCompany}";
	    	var selectedUserId = "";
	    	var selectedUserName = "";
	    	var userList = [];
			
	    	
	    	
	        $(document).ready(function() {
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    			if (document.getElementById("ListCompany").selectedIndex < 0) {
				            document.getElementById("ListCompany").selectedIndex = 0;
		    			}
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		            company_change();
		        }
	        });
	        
	        function company_change() {
	            $.ajax({
	            	type : "GET",
	            	url : "/admin/ezAttitude/attitudeAuthList.do",
	            	dataType : "json",
	            	data : {companyId : encodeURIComponent($("#ListCompany").val())},
	            	success : function(result) {
	            		attitudeAuthListSet(result);
	            	},
	            	error : function() {
	            		alert("<spring:message code = 'ezAttitude.t175' />");
	            	}
	            });
	            selectedUserId = "";
	        }
	        
	        //권한자 리스트 셋팅
	        function attitudeAuthListSet(result) {
	        	userList = [];
	        	
                var html = "";
                if (result.length != null && result.length != 0) {
	                for (var i = 0; i < result.length; i++) {
	                    html += "<tr id='" + result[i].userId + "' onclick='listClick(this);' ondblclick='author_modify()' style='cursor: pointer;'>";
	                    html += "<td style='width:20%;color:gray;'>" + result[i].userName + "</td>";
	                    html += "<td style='width:20%;color:gray;'>" + result[i].jikwi + "</td>";
	                    html += "<td style='width:20%;color:gray;'>" + result[i].deptName + "</td>";
	                    //스크롤바 생성시 밀림현상 방지
		                if (result.length > 15) {
		                    html += "<td style='width:40%;color:gray;padding-left:15px;'>" + result[i].authDeptName + " </td>";
		                } else {
		                    html += "<td style='width:40%;color:gray;'>" + result[i].authDeptName + " </td>";
		                }
	                    html += "</tr>";
	                    
	                    var deptList = [result[i].authDeptId, result[i].authDeptName2, result[i].authType];
	                    userList.push(deptList);
	                }
                } else {
                	html = "<tr><td colspan='4' style='text-align:center'><spring:message code = 'ezAttitude.t130' /></td></tr>";
                }
                
                $("#contentlist table.mainlist").html(html);
	        }
	        
	        //리스트 tr클릭시
	        function listClick(elem) {
	        	selectedUserId = $(elem).attr('id');
	        	selectedUserName = $(elem).children('td').eq(0).text();
	        }
	        
	        //권한수정
			function author_modify() {
	        	if (selectedUserId == null || selectedUserId == "") {
	        		alert("<spring:message code = 'ezAttitude.t52' />");
	        		return;
	        	}
	        	
				var userId = selectedUserId;
				var url = "/admin/ezAttitude/saveAttitudeAuth.do?companyId=" + encodeURIComponent($("#ListCompany").val()) + "&userId=" + userId + "&userName=" + selectedUserName;
				
				if (userId) {
					window.open(url, "saveAttitudeAuth", GetOpenWindowfeature(500, 435));
				} else {
					alert("<spring:message code = 'ezAttitude.t191' />");
				}
			}
	        
	        //권한 삭제
	        function author_delete() {
	        	if (selectedUserId == null || selectedUserId == "") {
	        		alert("<spring:message code = 'ezAttitude.t52' />");
	        		return;
	        	}
	        	if (confirm("<spring:message code = 'ezAttitude.t183' />")) {
					$.ajax({
						type : "POST",
						url : "/admin/ezAttitude/deleteAttitudeAuth.do",
						dataType : "text",
						data : {
							selectUserId : selectedUserId,
							companyId : encodeURIComponent($("#ListCompany").val())
						},
		            	success : function(resultStatus) {
		            		if (resultStatus == "success") {
			            		company_change();
		            		} else {
		            			alert("<spring:message code='ezAttitude.t175' />");
		            		}
		            	},
						error : function() {
							alert("<spring:message code = 'ezAttitude.t175' />");
						}
					})
	        	}
	        }
	        
	        //권한추가
	        function author_add() {
	        	var url = "/admin/ezAttitude/saveAttitudeAuth.do?companyId=" + encodeURIComponent($("#ListCompany").val());
				window.open(url, "saveAttitudeAuth", GetOpenWindowfeature(500, 435));
	        }

		</script>
	</head>
	<body class="mainbody">
	    <h1>
	    	<spring:message code = 'ezAttitude.t8' />
		    <span class="title_bar"><img src="/images/name_bar.gif"></span>
	    	<select class="companySelect" name="ListCompany" id="ListCompany" onchange="company_change()">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
				</c:forEach>
      		</select>
	    </h1>
	    <div id="mainmenu">
		    <ul>
		        <li class="important"><span onClick="author_add()"><spring:message code='ezAttitude.t187' /></span></li>
		        <li><span onClick="author_modify()"><spring:message code='ezAttitude.t188' /></span></li>
		        <li><span class="icon16 icon16_delete" onClick="author_delete()"></span></li>
		    </ul>
		</div>
        <div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
                    <th style="width: 20%;"><span><spring:message code='ezAttitude.t10' /></span></th>
                    <th style="width: 20%;"><span><spring:message code='ezAttitude.t11' /></span></th>
                    <th style="width: 20%;"><span><spring:message code='ezAttitude.t9' /></span></th>
                    <th style="width: 40%;"><span><spring:message code='ezAttitude.t190' /></span></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 466px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
                    <tr>
                        <td style="text-align: center;">
                            <img src="/images/email/progress_img.gif" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
		<script type="text/javascript">
 		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

