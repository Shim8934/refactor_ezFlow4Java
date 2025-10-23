<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezSchedule.t170" /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
	    <script type="text/javascript">
		    var groupid = "<c:out value='${groupID}' />";
		    var companyid = "<c:out value='${userInfo.companyID}' />";
		    var loginUserName = "<c:out value='${loginUserName}' />";
		    var loginUserName2 = "<c:out value='${loginUserName2}' />";
		    var loginUserId = "<c:out value='${loginUserId}' />";
		    var loginUserRoll = "<c:out value='${loginUserRoll}' />";
		    var g_Member; //그룹 멤버 정보
		 
		    function show_personinfo(userid) {
		    	var deptID = "";
		    	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleGetCumDeptID.do",
					data : { 						
						userID : userid,
						companyID : companyid
					},
					success: function(result){
						deptID = result;
					}
				});
		    	
		        var feature = GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + userid+"&dept="+deptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);		        
		    }
					
		    var OpenWin;
		    var schedule_select_attendant_dialogArguments = new Array();
		    
		    function add_member() {
		        if (CrossYN()) {
		        	//2018-08-10 김보미 - 그룹멤버 담은 변수 추가 및 url에 파라메타 추가
					//schedule_select_attendant_dialogArguments[0] = "";
					//schedule_select_attendant_dialogArguments[1] = add_member_Complete;
					//OpenWin = window.open("/ezSchedule/scheduleSelectAttendant.do?title=" + encodeURI("<spring:message code='ezSchedule.t171' />") + "&type=group", "schedule_group_write", GetOpenWindowfeature(980, 670));
		            schedule_select_attendant_dialogArguments[0] = g_Member;
		            schedule_select_attendant_dialogArguments[1] = add_member_Complete;
		            OpenWin = window.open("/ezSchedule/scheduleSelectAttendant.do?title=" + encodeURI("<spring:message code='ezSchedule.t171' />") + "&type=group&groupID=" + groupid,  "schedule_group_write", GetOpenWindowfeature(980, 670));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 535) / 2;
		            var pLeft = (pwidth - 737) / 2;
		            //2018-08-10 김보미 - url에 파라메타 추가
					//var rtn = window.showModalDialog("scheduleSelectAttendant.do?title=" + encodeURI("<spring:message code='ezSchedule.t171' />") + "&type=group", "", "dialogHeight:670px; dialogWidth:980px; dialogLeft:" + pLeft + "; dialogTop:" + pTop + "; status:no; scroll:no; help:no; edge:sunken");
		            var rtn = window.showModalDialog("scheduleSelectAttendant.do?title=" + encodeURI("<spring:message code='ezSchedule.t171' />") + "&type=group&groupID=" + groupid, "", "dialogHeight:670px; dialogWidth:980px; dialogLeft:" + pLeft + "; dialogTop:" + pTop + "; status:no; scroll:no; help:no; edge:sunken");
		            
		            //2018-08-10 김보미 - 변경
		            /*
		            if (typeof (rtn) != "undefined") {
		                if (rtn["id"].length == 0)
		                    return;	
		                
		                var memberList = new Array();
		                var count = 0;
		                
		                for (var i = 0; i < rtn["id"].length; i++) {
		                    var isExist = false;
		                    var checks = document.getElementsByTagName("input");
		                    for (var j = 0; j < checks.length; j++) {
		                        if (GetAttribute(checks.item(j), "memberid") == rtn["id"][i]) {
		                            alert("'" + rtn["name"][i] + "'<spring:message code='ezSchedule.t172' />");
		                            isExist = true;
		                            break;
		                        }
		                    }
	
		                    if (isExist) continue;		                    
		                    
		                    var data = new Object();
		                    data.memberID = rtn["id"][i];
		                    data.memberName = rtn["name"][i];
		                    data.memberName1 = rtn["name1"][i];
		                    data.memberName2 = rtn["name2"][i]; 
		                    
		                    memberList.push(data);
		                    count++;
		                }
	
		                if (count == 0) {
		                    return;
		                }
		                
		                $.ajax({
				    		type : "POST",
				    		dataType : "html",				    		
				    		async : false,
				    		data : {
				    			groupID : groupid,
				    			memberList : JSON.stringify(memberList)
				    		},
				    		url : "/ezSchedule/scheduleAddMember.do",
				    		success: function(text){
				    			alert("<spring:message code='ezSchedule.t174' />");
			                    window.location.reload(false);		    				    			
				    		},
				    		error: function(err){
				    			alert("<spring:message code='ezSchedule.t173' />");
				    		}
				        });	
		            }
		            */
		            if (typeof (rtn) != "undefined") {
			            if (rtn["id"].length == 0) {
			            	alert("<spring:message code='ezSchedule.csj01' />");
			                return;
			            }
			            
			            var memberList = new Array();
		                
		                OpenWin.focus();	
		
			            for (var i = 0; i < rtn["id"].length; i++) {
			                var isExist = false;
			                var checks = document.getElementsByName("members");
			                for (var j = 0; j < checks.length; j++) {
			                    if (GetAttribute(checks.item(j), "memberid") == rtn["id"][i]) {
		                            isExist = true;
		                        }
			                }
		
			                if (isExist) continue;
			                
			                var data = new Object();
		                    data.memberID = rtn["id"][i];
		                    data.memberName = rtn["name"][i];
		                    data.memberName1 = rtn["name1"][i];
		                    data.memberName2 = rtn["name2"][i];
		                    data.writePermission = rtn["writepermission"][i];
		                    
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
					    		url : "/ezSchedule/scheduleAddMember.do",
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
		                for (var k = 0; k < checks.length; k++) {
			                var tempCnt = 0;
			                
				            for (var l = 0; l < rtn["id"].length; l++) {
			                    if (GetAttribute(checks.item(k), "memberid") != rtn["id"][l]) {
		                        	tempCnt++;
		                        }
		                	}
				            
				            if (tempCnt == rtn["id"].length) {
				            	delMemberList.push(GetAttribute(checks.item(k), "memberid"));
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
				    		url : "/ezSchedule/scheduleDelMember.do",
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
		    	//2018-08-10 김보미 - 변경
		    	/*
		        if (typeof (rtn) != "undefined") {
		            if (rtn["id"].length == 0)
		                return;
		            
		            var memberList = new Array();
	                var count = 0;
	                
	                OpenWin.focus();	
	
		            for (var i = 0; i < rtn["id"].length; i++) {
		                var isExist = false;
		                var checks = document.getElementsByTagName("input");
		                for (var j = 0; j < checks.length; j++) {
		                    if (GetAttribute(checks.item(j), "memberid") == rtn["id"][i]) {
		                        alert("'" + rtn["name"][i] + "'<spring:message code='ezSchedule.t172' />");
		                        isExist = true;
		                        break;
		                    }
		                }
	
		                if (isExist) continue;
		                
		                var data = new Object();
	                    data.memberID = rtn["id"][i];
	                    data.memberName = rtn["name"][i];
	                    data.memberName1 = rtn["name1"][i];
	                    data.memberName2 = rtn["name2"][i]; 
	                    
	                    memberList.push(data);
	                    count++;
		            }
	
		            if (count == 0) {
	                    return;
	                }
	                
	                $.ajax({
			    		type : "POST",
			    		dataType : "html",				    		
			    		async : false,
			    		data : {
			    			groupID : groupid,
			    			memberList : JSON.stringify(memberList)
			    		},
			    		url : "/ezSchedule/scheduleAddMember.do",
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
		    	*/
		    	if (typeof (rtn) != "undefined") {
		            if (rtn["id"].length == 0) {
		            	alert("<spring:message code='ezSchedule.csj01' />");
		                return;
		            }
		            
		            var memberList = new Array();
	                
	                OpenWin.focus();	
	
		            for (var i = 0; i < rtn["id"].length; i++) {
		                var isExist = false;
		                var checks = document.getElementsByName("members");
		                for (var j = 0; j < checks.length; j++) {
		                    if (GetAttribute(checks.item(j), "memberid") == rtn["id"][i]) {
	                            isExist = true;
	                        }
		                }
	
		                if (isExist) continue;
		                
		                var data = new Object();
	                    data.memberID = rtn["id"][i];
	                    data.memberName = rtn["name"][i];
	                    data.memberName1 = rtn["name1"][i];
	                    data.memberName2 = rtn["name2"][i];
	                    data.writePermission = rtn["writepermission"][i];
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
				    		url : "/ezSchedule/scheduleAddMember.do",
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
	                for (var k = 0; k < checks.length; k++) {
		                var tempCnt = 0;
		                
			            for (var l = 0; l < rtn["id"].length; l++) {
		                    if (GetAttribute(checks.item(k), "memberid") != rtn["id"][l]) {
	                        	tempCnt++;
	                        }
	                	}
			            
			            if (tempCnt == rtn["id"].length) {
			            	delMemberList.push(GetAttribute(checks.item(k), "memberid"));
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
			    		url : "/ezSchedule/scheduleDelMember.do",
			    		success: function(text){
					         window.location.reload(false);   			
			    		},
			    		error: function(err){
			    		}
			        });
			        
			        <%-- 2024-07-18 조소정 - 일정관리 > 구성원 추가 시 그룹일정 작성 권한 저장 --%>
			        var updateList = [];
			        
			        for (var i = 0; i < rtn["id"].length; i++) {
		                var data = new Object();
	                    data.memberId = rtn["id"][i];
	                    data.writePermission = rtn["writepermission"][i];
	                    
	                    updateList.push(data);
		            }

			        var data = {
			            groupId: groupid,
			            memberList: updateList
			        };
			        
			        $.ajax({
			            type: "POST",
			            url: "/ezSchedule/scheduleSaveWritePermission.do",
			            contentType: "application/json",
			            data: JSON.stringify(data),
			            success: function() {
			            	window.location.reload(false);
			            },
			            error: function() {
			                alert("<spring:message code='ezSchedule.t198' />");
			            }
			        });
		        }
		    }
					
		    function del_member() {
		        var checks = document.getElementsByName("members");
		        var memberId = [];
		        var count = 0;
		        
		        for (var i = 0; i < checks.length; i++) {
		            if (checks.item(i).checked == true) {		                
		                memberId[i] = GetAttribute(checks.item(i), "memberid");
		                count++;
		            }
		        }
   
		        if (count == 0) {
		            alert("<spring:message code='ezSchedule.t175' />");
		            return;
		        }
		        
		        if ("${fn:length(memberList)}" == count) {
		        	alert("<spring:message code='ezSchedule.csj01' />");
		        	return;
		        }
	
		        if (!confirm(count + " <spring:message code='ezSchedule.t176' />"))
		            return;
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		async : false,
		    		data : {
		    			groupID : groupid,
		    			memberID : memberId
		    		},
		    		url : "/ezSchedule/scheduleDelMember.do",
		    		success: function(text){
		    			 alert(count + " <spring:message code='ezSchedule.t178' />");
				         window.location.reload(false);   			
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.t177' />");
		    		}
		        });
		    }
					
		    function renew_member() {
		        var checks = document.getElementsByName("members");
		        var memberId = [];
		        var count = 0;
		        
		        for (var i = 0; i < checks.length; i++) {
		            if (checks.item(i).checked == true) {
		                if (GetAttribute(checks.item(i), "memberstatus") != 2) {
		                    alert("<spring:message code='ezSchedule.t17901' />");
		                    return;
		                }
		                memberId[i] = GetAttribute(checks.item(i), "memberid");
		                count++;
		            }
		        }
		        if (count == 0) {
		            alert("<spring:message code='ezSchedule.t181' />");
		            return;
		        }
	
		        if (!confirm(count + " <spring:message code='ezSchedule.t182' />"))
		            return;
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		async : false,
		    		data : {
		    			groupID : groupid,
		    			status : 3,
		    			memberID : memberId
		    		},
		    		url : "/ezSchedule/scheduleUpdateMember.do",
		    		success: function(text){
		    			alert(count + " <spring:message code='ezSchedule.t184' />");
			            window.location.reload(false);
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.t183' />");
		    		}
		        });		
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
		    	location.reload(true);
		    }
		  
		    function save_onclick() {
		        /* if (specialChk(document.all("groupname").value) || specialChk(document.all("description").value)) {
		    		alert("<spring:message code='ezResource.special' />");
		    		return;
		    	} */		    	
		    	
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
					url : '/ezSchedule/scheduleModifyGroup.do',
					method : 'POST',
					async : false,
					dataType : "text",
					data : {
						groupId : groupid,
						groupName : document.all("groupname").value,
						description : document.all("description").value,
						displayName : "<c:out value='${userInfo.displayName1}' />",
						displayName2 : "<c:out value='${userInfo.displayName2}' />",
						groupColor : document.getElementById("groupColorText").innerHTML
					} ,
   					success : function(text) {
   						alert("<spring:message code='ezSchedule.shb08' />");
  							
						window.close();
						
						// 2023-09-06 조소정 - 관리자단과 사용자단의 부모창이 달라 분기처리함
						var pathName = opener.parent.location.pathname;
							
						if (pathName.includes('admin')) {
							opener.parent.lef.groupRefresh();
						}
						else {
							opener.parent.parent.left.groupRefresh();
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezSchedule.shb09' />");
					}
				});
		    }
		 
		    function give_permission() {
		    	var checks = document.getElementsByName("members");
		        var memberId;
		        var memberName;
		        var memberName2;
		        var status;
		        
		        var count = 0;
		        
		        for (var i = 0; i < checks.length; i++) {
		            if (checks.item(i).checked == true) {
		                memberId = checks[i].getAttribute("memberid");
		                memberName = g_Member.name1[i];
		                memberName2 = g_Member.name2[i];
		                status = checks[i].getAttribute("memberstatus");
		                count++;
		            }
		        }

		        if (count == 0) {
		            alert("<spring:message code='ezSchedule.shb02' />");
		            return;
		        }else if(count > 1){
		        	alert("<spring:message code='ezSchedule.shb03' />");
		        	return;
		        }else if(status != 1){
		        	alert("<spring:message code='ezSchedule.shb22' />");
		        	return;
		        }
		        
		        if (!confirm("<spring:message code='ezSchedule.shb05' />"))
		            return; 
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "html",
		    		async : false,
		    		data : {
		    			groupID : groupid,
		    			memberID : memberId,
		    			memberNAME : memberName,
		    			memberNAME2 : memberName2,
		    			loginUserId : loginUserId,
		    			loginUserName : loginUserName,
		    			loginUserName2 : loginUserName2		
		    		},
		    		url : "/ezSchedule/scheduleGiveManagement.do",
		    		success: function(text){
		    			opener.location.reload(); 
		    			window.close();
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.shb14' />");
		    		}
		        });
		        
	    	}
		    
		    <%-- 2024-07-18 조소정 - 일정관리 > 그룹 관리 화면에서 그룹일정 작성 권한 저장 --%>
		    function update_writePermission() {
		        var checks = document.getElementsByName("memberaccess");
		        var memberList = [];
		        var count = 0;

		        for (var i = 0; i < checks.length; i++) {
		            var memberId = checks[i].getAttribute("memberid");
		            var writePermission = checks[i].checked ? "Y" : "N";
		            
		            memberList.push({ memberId: memberId, writePermission: writePermission });
		            count++;
		        }

		        if (count == 0) {
		            return;
		        }

		        var data = {
		            groupId: groupid,
		            memberList: memberList
		        };
		        
		        $.ajax({
		            type: "POST",
		            url: "/ezSchedule/scheduleSaveWritePermission.do",
		            contentType: "application/json",
		            data: JSON.stringify(data),
		            success: function() {
		            	alert("<spring:message code='ezSchedule.groupSchedule.csj02' />");
		            },
		            error: function() {
		                alert("<spring:message code='ezSchedule.t198' />");
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
	        	
	        	<%-- 2024-07-18 조소정 - 일정관리 > 그룹 관리 창에서 작성 권한 여부 표출 --%>
		        var checks = document.getElementsByName("memberaccess");
	            for (var i = 0; i < checks.length; i++) {
	                if (checks[i].getAttribute("writepermission") == "Y") {
	                	checks[i].checked = true;
	                }
	                else {
	                	checks[i].checked = false;
	                }
	            }
			    
		    	g_Member = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array(), "writepermission": new Array(), "departmentid":new Array() };
		    	
		    	<c:forEach var="item" items="${memberList}">
		    		g_Member.id.push( "${item.memberId}");
		    		g_Member.name.push("${item.memberName}");
		    		g_Member.name1.push("${item.memberName}");
		    		g_Member.name2.push("${item.memberName2}");
		    		g_Member.departmentid.push("${item.department}");
		    	</c:forEach>
		    }
		</script>
	</head>
	<body class="popup"> 
		<form id="form1" method="post"> 
			<div id="menu">
				<ul>
				    <li title="<spring:message code='ezSchedule.t185' />"><span onClick="add_member()"><spring:message code='ezSchedule.t186' /></span></li>
				    <li title="<spring:message code='ezSchedule.t187' />"><span onClick="del_member()"><spring:message code='ezSchedule.t188' /></span></li>
				    <li title="<spring:message code='ezSchedule.t189' />"><span onClick="renew_member()"><spring:message code='ezSchedule.t169' /></span></li>
				    <li title="<spring:message code='ezSchedule.t189' />"><span onClick="update_writePermission()"><spring:message code='ezSchedule.groupSchedule.csj03' /></span></li>
				    <li title="<spring:message code='ezSchedule.shb01' />"><span onClick="give_permission()"><spring:message code='ezSchedule.shb01' /></span></li>
			  	</ul>
			</div>
			<div id="close"><ul><li><span onClick="window.close()"></span></li></ul></div>
			
			<!-- 2023-09-06 조소정 - 일정 그룹 구성원 관리 팝업창에 일정그룹색상 지정할 수 있도록 셀 추가 -->
			<table class="popuplist" width="100%">
				<tr> 
			    	<th style="width:20%; white-space:nowrap; text-align:center;"><spring:message code='ezSchedule.t202' /></th> 
			      	<!-- 	<td style="width:200px"> -->
			       	<td style="width: 35%; height: 23px; white-space:nowrap; text-align:center;">
			        	<!-- <input type="text" id="groupname" style="WIDTH:200px; height: 23px;" maxlength=50> -->
			        	<input type="text" id="groupname" style="WIDTH:100%; height: 23px;">
			       	</td>
			     	<!--  	</td> -->
			    	<th style="width:20%; white-space:nowrap; text-align:center"><spring:message code='ezSchedule.jsb01' /></th> 
			      	<td style="width: 100%;">
			      		<div id="groupColor" style="width: 20px; height: 20px; float: left; margin-top: 1.5px; margin-left: 2px; background-color: ${groupColor};"></div>
			      		<div id="groupColorText" style="width: 60px; height: 20px; float: left; margin-top: 3px; margin-left: 5px; font-size: 13px;">${groupColor}</div>
			        	<a class="imgbtn" onclick="select_groupcolor()" style="float: right;"><span ><spring:message code='ezSchedule.csj02' /></span></a>
			      	</td>
			    </tr>
			    <tr style="width: 100%;">
			    	<th style="width:20%; white-space:nowrap; text-align:center"><spring:message code='ezSchedule.t203' /></th> 
			      	<td colspan=3>
			        	<input name="text" type="text" id="description" style="width:100%; height: 23px; colspan: 3;">
			      	</td>
			    </tr> 
			    
			</table>
			<div id="menu" style="width: 100%; display: flex; justify-content: center; gab:3px; margin-top:1%; ">
				<ul>
				    <li title="<spring:message code='ezSchedule.shb10' />"><span onClick="save_onclick()"><spring:message code='ezSchedule.shb11' /></span></li>
				    <li title="<spring:message code='ezSchedule.t5' />"><span onClick="cancel_onclick()"><spring:message code='ezSchedule.t5' /></span></li>
			  	</ul>
			</div>
			
			<br />
			<span class="txt" style="color:red">▒ <spring:message code="ezSchedule.t17902" /></span>
			<br />
			<span class="txt" style="color:red">▒ <spring:message code="ezSchedule.shb21" /></span>
			<div id="receivelist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; HEIGHT:300px;"> 
				<table width="100%" class="popuplist">
			    	<tr>
				    	<th style="width:30px; text-align:center"><spring:message code='ezSchedule.t190' /></th>
				      	<th style="width:150px; text-align:center"><spring:message code='ezSchedule.t163' /></th>
				      	<th style="width:30px; text-align:center"><spring:message code='ezSchedule.groupSchedule.csj04' /></th>
				      	<th style="width:30px; text-align:center"><spring:message code='ezSchedule.t164' /></th>
				      	<th style="width:70px; text-align:center"><spring:message code='ezSchedule.t165' /></th>
				  	</tr>
				  	<c:forEach var="item" items="${memberList}">
				  	<tr>
				  		<td style="text-align:center">
		                	<input type='checkbox' value="1" name="members" memberid="${item.memberId}" memberstatus="${item.status}">
		                </td> 
		                <td style="cursor:pointer; white-space:nowrap; text-align:center" title="<spring:message code='ezSchedule.t162' />" onClick="show_personinfo('${item.memberId}')">
		                    <c:choose>
                               <c:when test="${primaryData == '1'}"> ${item.memberName} </c:when>
                               <c:otherwise> ${item.memberName2} </c:otherwise>
		                    </c:choose>
		                </td> 
		                <td style="text-align:center">
		                	<input type="checkbox" name="memberaccess" memberid="${item.memberId}" writePermission="${item.writePermission}">
		                </td>
		                <td style="text-align:center">
		                	<c:if test="${item.status == '0'}"><spring:message code='ezSchedule.t166' /></c:if>
		                	<c:if test="${item.status == '1'}"><spring:message code='ezSchedule.t167' /></c:if>
		                	<c:if test="${item.status == '2'}"><spring:message code='ezSchedule.t168' /></c:if>
		                	<c:if test="${item.status == '3'}"><spring:message code='ezSchedule.t169' /></c:if>		                	
		                </td> 
		                <td style="text-align:center">
		                	<c:if test="${item.status == '0'}">&nbsp;</c:if>
		                	<c:if test="${item.status != '0'}">${fn:substring(item.responseDate,0,10)}</c:if>
		                </td>
				  	</tr>
				  	</c:forEach>		            
				</table> 
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
			</script> 
		</form>
		<!-- 2023-09-06 조소정 - 색상선택표 표출 시 뒷배경 회색 처리 -->
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>

