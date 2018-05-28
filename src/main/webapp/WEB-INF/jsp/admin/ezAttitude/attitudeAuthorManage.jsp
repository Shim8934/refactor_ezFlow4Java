<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
<%-- 		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" /> --%>
<!-- 		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />		 -->
<%-- 		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	     --%>
	    <link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
	    <link rel="stylesheet" href="/css/ezSchedule/Calendar_cross.css" type="text/css">
	    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>	
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
	            	data : {companyId : encodeURI($("#ListCompany").val())},
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
	                    html += "<td style='width:19%;color:gray;'>" + result[i].userName + "</td>";
	                    html += "<td style='width:19%;color:gray;'>" + result[i].jikwi + "</td>";
	                    html += "<td style='width:19%;color:gray;'>" + result[i].deptName + "</td>";
	                    html += "<td style='width:18%;color:gray;'>" + result[i].authDeptName + " </td>";
	                    html += "<td style='width:25%;color:gray;padding-left: 15px;'><i class='fas fa-info-circle' style='margin-left: 5px; font-size: 14px;'></i></td>";
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
				var url = "/admin/ezAttitude/saveAttitudeAuth.do";
				var companyId = encodeURI($("#ListCompany").val());
				url+="?companyId="+companyId;
				if (userId) {
					url+="&userId="+userId+"&userName="+selectedUserName;
					window.open(url, "saveAttitudeAuth", GetOpenWindowfeature(500, 420));
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
							companyId : encodeURI($("#ListCompany").val())
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
	        	var url = "/admin/ezAttitude/saveAttitudeAuth.do";
				var companyId = $("#ListCompany").val();
				url+="?companyId="+companyId;
				window.open(url, "saveAttitudeAuth", GetOpenWindowfeature(500, 420));
	        }
	        
	        //권한부서 정보 hover로
	        $(document).on('mouseover', '#contentlist table.mainlist i', function(e) {
				var trNum = $(this).closest('tr').prevAll().length;
				var deptIdStr = userList[trNum][0];
				var deptNameList = userList[trNum][1];
				var authTypeStr = userList[trNum][2];
				showTooltip(deptNameList, authTypeStr);
			})
	        $(document).on('mouseout', '#contentlist table.mainlist i', function(e) {
	        	hideTooltip();
			})
	        
	/////////////////툴팁//////////////////////////////////////////////////////////////
			function showTooltip(deptNameList, authTypeStr, e) {
 			    //tip = (!e.target ? event.srcElement.value : e.target.value)

				var authTypeList = authTypeStr.split(",");
				
			    var html = "";
			    html += "<table name='tooltip' class='calendar_layer' cellpadding='0' cellspacing='0' border='0' width='100%'>";
				html += "<tr class='selectTR' style='background-color: rgb(237, 244, 253);'>";
				html += "<th scope='col'><spring:message code = 'ezAttitude.t192' /></th>";
				html += "</tr>";
				html += "<tr class='' style='background-color: rgb(255, 255, 255);'>";
				html += "<td class='text'>";
				html += "<table class='td_list' cellpadding='0' cellspacing='0' border='0' width='100%'>";
				for (var i = 0; i < deptNameList.length; i++) {
					var authName = "";
					if (authTypeList[i] == "R") {
						authName = "<spring:message code = 'ezAttitude.t193' />";
					} else {
						authName = "<spring:message code = 'ezAttitude.t194' />";
					}
					html += "<tr class='' style='background-color: rgb(255, 255, 255);'>";
					html += "<td>" + deptNameList[i] + " (" + authName + ")</td>";
					html += "</tr>";
				}
				html += "</table>";
				html += "</td>";
				html += "</tr>";
				html += "</table>";
			    $('#tooltip').html(html);
			    $('#tooltip').css('left',getMouseXLocation(e) + 'px');
			    $('#tooltip').css('top',getMouseYLocation(e) + 'px');
			    $('#tooltip').css('visibility', 'visible');
			}
			
	        //툴팁숨기기
			function hideTooltip() {
				$('#tooltip').css('visibility', 'hidden');
			}
			
	        //마우스 X축 위치
			function getMouseXLocation(e) {
			    if (e)
			        var E = e;
			    else
			        var E = window.event;

			    var tTip = document.getElementById("tooltip");
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        if (E.clientX > 1000) {
			            var locationX = E.clientX + document.documentElement.scrollLeft - tTip.clientWidth;
			        } else {
			            if (E.clientX > 300) {
			                var locationX = E.clientX + document.documentElement.scrollLeft - tTip.clientWidth;
			            }
			            else
			                var locationX = E.clientX + document.documentElement.scrollLeft;
			        }
			    }
			    else {
			        if (E.clientX > 1000) {
			            var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
			        } else {
			            if (E.clientX > 300) {
			                var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
			            }
			            else
			                var locationX = E.clientX + document.body.scrollLeft;
			        }
			    }

			    return locationX
			}

			//마우스 Y축 위치
			function getMouseYLocation(e) {
			    if (e)
			        var E = e;
			    else
			        var E = window.event;

			    var tTip = document.getElementById("tooltip");
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        if (E.clientY > 500) {
			            var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
			            locationY -= 12;
			        }
			        else {
			            if (document.documentElement.scrollTop > 0) {
			                
			                var locationY
			                
			                if (tTip.clientHeight > E.clientY) {
			                    locationY = E.clientY + document.documentElement.scrollTop;
			                } else {
			                    locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
			                }
			            }
			            else {
			                var locationY = E.clientY + document.documentElement.scrollTop;
			            }
			            locationY += 12;
			        }
			    }
			    else {
			        if (E.clientY > 500) {
			            var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
			            locationY -= 12;
			        }
			        else {
			            if (document.body.scrollTop > 0) {
			                var locationY
			                
			                if (tTip.clientHeight > E.clientY) {
			                    locationY = E.clientY + document.body.scrollTop;
			                } else {
			                    locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
			                }
			            }
			            else {
			                var locationY = E.clientY + document.body.scrollTop;
			            }
			            locationY += 12;
			        }
			    }

			    return locationY
			}

		</script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code = 'ezAttitude.t8' /></h1>
	    <div id="mainmenu">
			<ul>
	        	<li style="background: none;">
				<span style="border: none;"><b><spring:message code='ezAttitude.t15' /></b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
					<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
					</c:forEach>
	      		</select>
	      		</li>
	      	</ul>
		    <ul>
		        <li><span onClick="author_add()"><spring:message code='ezAttitude.t187' /></span></li>
		        <li><span onClick="author_modify()"><spring:message code='ezAttitude.t188' /></span></li>
		        <li><span onClick="author_delete()"><spring:message code='ezAttitude.t189' /></span></li>
		    </ul>
		</div>
        <div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
                    <th style="width: 19%;"><span><spring:message code='ezAttitude.t10' /></span></th>
                    <th style="width: 19%;"><span><spring:message code='ezAttitude.t11' /></span></th>
                    <th style="width: 19%;"><span><spring:message code='ezAttitude.t9' /></span></th>
                    <th style="width: 18%;"><span><spring:message code='ezAttitude.t190' /></span></th>
                    <th style="width: 25%;"><span>권한정보</span></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 460px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
                    <tr>
                        <td style="text-align: center;">
                            <img src="/images/email/progress_img.gif" />
                        </td>
                    </tr>
                    <div id="tooltip" style="position: absolute;visibility: hidden; z-index: 1000; background-color: white;"></div>
                </table>
            </div>
        </div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

