<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezSchedule.ljeGs012" /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
  		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">
		    var groupid = "<c:out value='${groupID}' />";
		    var companyid = "<c:out value='${userInfo.companyID}' />";
		    var loginUserName = "<c:out value='${loginUserName}' />";
		    var loginUserName2 = "<c:out value='${loginUserName2}' />";
		    var loginUserId = "<c:out value='${loginUserId}' />";
		    var loginUserRoll = "<c:out value='${loginUserRoll}' />";
		    var g_Member; //그룹 멤버 정보
		    var OpenWin;
		    var schedule_select_attendant_dialogArguments = new Array();
		    
		    function add_member() {
		        if (CrossYN()) {
		            schedule_select_attendant_dialogArguments[0] = g_Member;
		            schedule_select_attendant_dialogArguments[1] = add_member_Complete;
		            OpenWin = window.open("/ezSchedule/scheduleSelectAttendant.do?title=" + encodeURI("<spring:message code='ezSchedule.ljeGs016' />") + "&type=gather&groupID=" + groupid,  "schedule_group_write", GetOpenWindowfeature(980, 670));
		            try {
						OpenWin.focus();
					} catch (e) {
					}
		        } else {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 535) / 2;
		            var pLeft = (pwidth - 737) / 2;
		            var rtn = window.showModalDialog("scheduleSelectAttendant.do?title=" + encodeURI("<spring:message code='ezSchedule.ljeGs016' />") + "&type=gather&groupID=" + groupid, "", "dialogHeight:670px; dialogWidth:980px; dialogLeft:" + pLeft + "; dialogTop:" + pTop + "; status:no; scroll:no; help:no; edge:sunken");
		            
		            if (typeof (rtn) != "undefined") {
			            if (rtn["id"].length == 0) {
			            	alert("<spring:message code='ezSchedule.csj01' />");
			                return;
			            }
			            
			            var memberList = new Array();
		                OpenWin.focus();
		
			            for (var i = 0; i < rtn["id"].length; i++) {
			                var isExist = false;

			                for (var j = 0; j < g_Member.id.length; j++) {
			                    if (g_Member.id[j] == rtn["id"][i] &&
			                    g_Member.departmentid[j] && rtn["departmentid"][i]) {
		                            isExist = true;
		                        }
			                }
		
			                if (isExist) continue;
			                
			                var data = new Object();
		                    data.memberID = rtn["id"][i];
		                    data.memberName = rtn["name"][i];
		                    data.memberName1 = rtn["name1"][i];
		                    data.memberName2 = rtn["name2"][i]; 
		                    data.memberDeptId = rtn["departmentid"][i]; 
		                    
		                    memberList.push(data);
			            }

		                if (memberList.length > 0) {
			                $.ajax({
					    		type : "POST",
					    		dataType : "html",				    		
					    		async : false,
					    		data : {
					    			groupID : groupid,
					    			memberList : JSON.stringify(memberList),
					    			displayName : "<c:out value='${userInfo.displayName1}' />",
									displayName2 : "<c:out value='${userInfo.displayName2}' />"
					    		},
					    		url : "/ezSchedule/scheduleGatherAddMember.do",
					    		success: function(text){
					    			OpenWin.alert("<spring:message code='ezSchedule.t174' />");
									OpenWin.close();
					    			
		 		                    window.location.reload(false);		    				    			
					    		},
					    		error: function(err){
					    			OpenWin.alert("<spring:message code='ezSchedule.t173' />");
									OpenWin.close();			    			
					    		}
					        });
		                }
		                
		                var delMemberList = [];
		                for (var k = 0; k < g_Member.id.length; k++) {
			                var tempCnt = 0;
			                
				            for (var l = 0; l < rtn["id"].length; l++) {
			                    if (g_Member.id[k] != rtn["id"][l]) {
		                        	tempCnt++;
		                        }
		                	}
				            
				            if (tempCnt == rtn["id"].length) {
				            	delMemberList.push(g_Member.id[k]);
				            }
			            }
				        $.ajax({
				    		type : "POST",
				    		dataType : "html",
				    		async : false,
				    		data : {
				    			groupID : groupid,
				    			memberID : delMemberList
				    		},
				    		url : "/ezSchedule/scheduleGatherDelMember.do",
				    		success: function(text){
						         window.location.reload(false);   			
				    		},
				    		error: function(err){
				    		}
				        });
			        }
		        }
		    }
	
		    function add_member_Complete(rtn) {
		    	if (typeof (rtn) != "undefined") {
		            if (rtn["id"].length == 0) {
		            	alert("<spring:message code='ezSchedule.csj01' />");
		                return;
		            }
		            
		            var memberList = new Array();
	                
	                OpenWin.focus();	
					
		            for (var i = 0; i < rtn["id"].length; i++) {
		                var isExist = false;

		                for (var j = 0; j < g_Member.id.length; j++) {
		                    if (g_Member.id[j] == rtn["id"][i] &&
		                    g_Member.departmentid[j] == rtn["departmentid"][i]) {
	                            isExist = true;
	                        }
		                }
	
		                if (isExist) continue;
		                
		                var data = new Object();
	                    data.memberID = rtn["id"][i];
	                    data.memberName = rtn["name"][i];
	                    data.memberName1 = rtn["name1"][i];
	                    data.memberName2 = rtn["name2"][i];
	                    data.memberDeptId = rtn["departmentid"][i];
	                    
	                    memberList.push(data);
		            }
		            
	                if (memberList.length > 0) {
		                $.ajax({
				    		type : "POST",
				    		dataType : "html",				    		
				    		async : false,
				    		data : {
				    			groupID : groupid,
				    			memberList : JSON.stringify(memberList),
				    			displayName : "<c:out value='${userInfo.displayName1}' />",
								displayName2 : "<c:out value='${userInfo.displayName2}' />"
				    		},
				    		url : "/ezSchedule/scheduleGatherAddMember.do",
				    		success: function(text){
				    			OpenWin.alert("<spring:message code='ezSchedule.t174' />");
								OpenWin.close();
				    			
	 		                    window.location.reload(false);
				    		},
				    		error: function(err){
				    			OpenWin.alert("<spring:message code='ezSchedule.t173' />");
								OpenWin.close();			    			
				    		}
				        });
	                }
	                
	                var delMemberList = [];
	                for (var k = 0; k < g_Member.id.length; k++) {
		                var tempCnt = 0;
		                
			            for (var l = 0; l < rtn["id"].length; l++) {
		                    if (g_Member.id[k] != rtn["id"][l]) {
	                        	tempCnt++;
	                        }
	                	}
			            
			            if (tempCnt == rtn["id"].length) {
			            	delMemberList.push(g_Member.id[k]);
			            }
		            }
	                
	                if (delMemberList.length > 0) {
				        $.ajax({
				    		type : "POST",
				    		dataType : "html",
				    		async : false,
				    		data : {
				    			groupID : groupid,
				    			memberID : delMemberList
				    		},
				    		url : "/ezSchedule/scheduleGatherDelMember.do",
				    		success: function(text){
						        window.location.reload(false);   			
				    		},
				    		error: function(err){
				    		}
				        });
	                }
		        }
		    }

		    function check_length(chkstr, maxlength, fieldname) {
				var length = 0;
				var i;

				length = chkstr.length;

				if (length > maxlength) {
					alert(fieldname + "<spring:message code='ezSchedule.t200' /> " + maxlength + "<spring:message code='ezSchedule.t201' />");
					return false;
				}

				return true;
		    }

		    function cancel_onclick() {
		    	window.close();
		    }

		    function save_onclick() {
		         if (document.all("groupname").value.replace(/\s/g, '') == "") {
		            alert("<spring:message code='ezSchedule.t195' />");
		            document.all("groupname").value = "";
		            document.all("groupname").focus();
		            return;
		        }

		        if (document.all("description").value.replace(/\s/g, '') == "") {
		            alert("<spring:message code='ezSchedule.t196' />");
		            document.all("description").value = "";
		            document.all("description").focus();
		            return;
		        } 
		      
		        if (!check_length(document.all("groupname").value, 50, "<spring:message code='ezSchedule.t159' />")) return;
		        if (!check_length(document.all("description").value, 250, "<spring:message code='ezSchedule.t160' />")) return;

		        $.ajax({
					url : '/ezSchedule/scheduleGatherModify.do',
					method : 'POST',
					async : false,
					dataType : "text",
					data : {
						groupId : groupid,
						groupName : document.all("groupname").value,
						description : document.all("description").value
					},
   					success : function(text) {
   						alert("<spring:message code='ezSchedule.ljeGs013' />");
   							
						window.close();
						opener.parent.parent.left.gatherRefresh();
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezSchedule.ljeGs014' />");
					}
				});
		    }

			var beforeText = '';
		    function unEscapeHtml(text) {
				beforeText = text;

		        var map = {
		            '&amp;' : '&',
		            '&lt;' : '<',
		            '&gt;' : '>',
		            '&#034;' : '"',
		            '&#039;' : "'",
					'&#92;' : '\\'
		        };

		        return text.replace(/&amp;|&lt;|&gt;|&#034;|&#039;|&#92;/g, function(m) {
					return map[m];
				});
			}

			function unEscapeHtml2(text) {
				beforeText = text;
				var afterText = unEscapeHtml(beforeText);

				while (beforeText != afterText) {
					afterText = unEscapeHtml(afterText);
				}

				beforeText = '';
				return afterText;
			}

		    //2018-08-10 김보미 - 추가
		    window.onload = function () {
		    	var groupName = "<c:out value='${groupName}' />";
	    	    var description = "<c:out value='${description}' />";
	        	$('#groupname').val(unEscapeHtml2(groupName));
	        	$('#description').val(unEscapeHtml2(description));
			    
		    	g_Member = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array(), "departmentid": new Array() };
		    	
		    	<c:forEach var="item" items="${memberList}">
		    		g_Member.id.push( "${item.memberId}");
		    		g_Member.name.push("${item.memberName}");
		    		g_Member.name1.push("${item.memberName}");
		    		g_Member.name2.push("${item.memberName2}");
		    		
		    		g_Member.departmentid.push("${item.department}");
		    		g_Member.deptname.push("${item.departmentName}");
		    		g_Member.deptname2.push("${item.departmentName2}");
		    	</c:forEach>
		    }
		</script>
	</head>
		<body class="popup">
			<form id="form1" method="post">
				<div id="menu">
					<ul>
						<li title="<spring:message code='ezSchedule.t185' />"><span onClick="add_member()"><spring:message code='ezSchedule.ljeGs015' /></span></li>
					</ul>
				</div>
			<div id="close"><ul><li><span onClick="window.close()"></span></li></ul></div>
			<br/>
			<table class="popuplist" width="100%">
				<tr>
					<th style="width:120px; white-space:nowrap; text-align:center"><spring:message code='ezSchedule.ljeGs004' /></th>
					<td>
						<input type="text" id="groupname" style="WIDTH:100%; height: 23px;">
					</td>
				</tr>
				<tr>
					<th style="width:120px; white-space:nowrap; text-align:center"><spring:message code='ezSchedule.ljeGs005' /></th>
					<td>
						<input name="text" type="text" id="description" style="WIDTH:100%; height: 23px;">
					</td>
				</tr>
			</table>

			<div id="menu" style="margin-top: 10px">
				<ul style="display: flex; justify-content: center;">
					<li title="<spring:message code='ezSchedule.shb10' />"><span onClick="save_onclick()"><spring:message code='ezSchedule.shb11' /></span></li>
					<li title="<spring:message code='ezSchedule.t5' />"><span onClick="cancel_onclick()"><spring:message code='ezSchedule.t5' /></span></li>
				</ul>
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
			</script>
			</form>
		</body>
</html>

