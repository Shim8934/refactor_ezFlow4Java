<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezSchedule.t170" /></title>
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />			    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">
		    var groupid = "<c:out value='${groupID}' />";
		    var g_Member; //그룹 멤버 정보
		    
		    function show_personinfo(userid) {
		        var feature = GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);		        
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
			                var checks = document.getElementsByTagName("input");
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
		                    
		                    memberList.push(data);
			            }

		                if (memberList.length > 0) {
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
		                var checks = document.getElementsByTagName("input");
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
	                    
	                    memberList.push(data);
		            }
	
	                if (memberList.length > 0) {
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
					
		    function del_member() {
		        var checks = document.getElementsByTagName("input");
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
	
		        if (!confirm(count + "<spring:message code='ezSchedule.t176' />"))
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
		    			 alert(count + "<spring:message code='ezSchedule.t178' />");
				         window.location.reload(false);   			
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.t177' />");
		    		}
		        });
		    }
					
		    function renew_member() {
		        var checks = document.getElementsByTagName("input");
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
	
		        if (!confirm(count + "<spring:message code='ezSchedule.t182' />"))
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
		    			alert(count + "<spring:message code='ezSchedule.t184' />");
			            window.location.reload(false);
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.t183' />");
		    		}
		        });		
		    }
		    
		    //2018-08-10 김보미 - 추가
		    window.onload = function () {
		    	g_Member = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
		    	
		    	<c:forEach var="item" items="${memberList}">
		    		g_Member.id.push( "${item.memberId}");
		    		g_Member.name.push("${item.memberName}");
		    		g_Member.name1.push("${item.memberName}");
		    		g_Member.name2.push("${item.memberName2}");
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
			  	</ul>
			</div>
			<div id="close"><ul><li><span onClick="window.close()"></span></li></ul></div>
			<span class="txt">▒ <spring:message code="ezSchedule.t17902" /></span>
			<div id="receivelist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:440px; HEIGHT:277px"> 
				<table width="100%" class="popuplist">
			    	<tr>
				    	<th style="width:40px; text-align:center"><spring:message code='ezSchedule.t190' /></th>
				      	<th style="text-align:center"><spring:message code='ezSchedule.t163' /></th>
				      	<th style="width:80px; text-align:center"><spring:message code='ezSchedule.t164' /></th>
				      	<th style="width:100px; text-align:center"><spring:message code='ezSchedule.t165' /></th>
				  	</tr>
				  	<c:forEach var="item" items="${memberList}">
				  	<tr>
				  		<td style="text-align:center">
		                	<input type='checkbox' value="1" memberid="${item.memberId}" memberstatus="${item.status}">
		                </td> 
		                <td style="cursor:pointer; white-space:nowrap; text-align:center" title="<spring:message code='ezSchedule.t162' />" onClick="show_personinfo('${item.memberId}')">
			                <c:if test="${userInfo.primary == '1'}">${item.memberName}</c:if>
			                <c:if test="${userInfo.primary != '1'}">${item.memberName2}</c:if>		                 
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
	</body>
</html>

