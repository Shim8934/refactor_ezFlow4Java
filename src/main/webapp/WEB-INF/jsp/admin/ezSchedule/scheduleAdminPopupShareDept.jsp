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
		    var userid = "";
	        var userdeptid = "";
	        var deptid = "";
	        var ReturnFunction;
	        
	        var schedule_select_secretary_cross_dialogArguments = new Array();
	        function select_person() {
	            if (CrossYN()) {
	                schedule_select_secretary_cross_dialogArguments[1] = select_person_Complete;
	
	                if (navigator.appName.indexOf("Microsoft") > -1) {
	                    var OpenWin = window.open("/ezSchedule/scheduleSelectSecretary.do", "scheduleSelectSecretary", GetOpenWindowfeature(735, 580));
	                    try { OpenWin.focus(); } catch (e) { }
	                } else {
	                    var OpenWin = window.open("/ezSchedule/scheduleSelectSecretary.do", "scheduleSelectSecretary", GetOpenWindowfeature(735, 555));
	                    try { OpenWin.focus(); } catch (e) { }
	                }
	            } else {
	                var rtnValue = "";
	                var feature = GetShowModalPosition(735, 580);
	                
	                if (navigator.appName.indexOf("Microsoft") > -1) {
	                    rtnValue = window.showModalDialog("/ezSchedule/scheduleSelectSecretary.do", "","dialogHeight:580px;dialogwidth:735px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                } else {
	                    rtnValue = window.showModalDialog("/ezSchedule/scheduleSelectSecretary.do", "","dialogHeight:555px;dialogwidth:735px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                }
	                if (typeof (rtnValue) != "undefined") {
	                    userid = rtnValue.split(":")[0];
	                    document.getElementById("txtuser").value = rtnValue.split(":")[1];
	                    userdeptid = rtnValue.split(":")[2]
	                }
	            }
	        }
	
	        function select_person_Complete(retVal) {
	            if (typeof (retVal) != "undefined") {
	                userid = retVal.split(":")[0];
	                document.getElementById("txtuser").value = retVal.split(":")[1];
	                userdeptid = retVal.split(":")[2]
	            }
	        }
	
	        var schedule_select_sharedept_cross_dialogArguments = new Array();
	        function select_sharedept() {
	            if (CrossYN()) {
	                schedule_select_sharedept_cross_dialogArguments[1] = select_sharedept_Complete;
	
	                var OpenWin = window.open("/ezSchedule/scheduleSelectShareDept.do", "scheduleSelectShareDept", GetOpenWindowfeature(280, 435));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	                var rtnValue = "";
	                var feature = GetShowModalPosition(280, 435);
	                
	                if (navigator.appName.indexOf("Microsoft") > -1) {
	                    rtnValue = window.showModalDialog("/ezSchedule/scheduleSelectShareDept.do", "","dialogHeight:435px;dialogwidth:280px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                } else {
	                    rtnValue = window.showModalDialog("/ezSchedule/scheduleSelectShareDept.do", "","dialogHeight:435px;dialogwidth:280px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                }
	                if (typeof (rtnValue) != "undefined") {
	                    if (rtnValue.split(":").length > 1) {
	                        deptid = rtnValue.split(":")[0];
	                        document.getElementById("txtdept").value = rtnValue.split(":")[1];
	                    } else {
	                        deptid = "";
	                        document.getElementById("txtdept").value = "";
	                    }
	                }
	            }
	        }
	
	        function select_sharedept_Complete(retVal) {
	            if (typeof (retVal) != "undefined") {
	                if (retVal.split(":").length > 1) {
	                    deptid = retVal.split(":")[0];
	                    document.getElementById("txtdept").value = retVal.split(":")[1];
	                } else {
	                    deptid = "";
	                    document.getElementById("txtdept").value = "";
	                }
	            }
	        }
	
	        function save_info() {
	            if (userid == "") {
	                alert(strLang93);
	                return;
	            }	
	            if (deptid == "") {
	                alert(strLang94);
	                return;
	            }	
	            if (deptid == userdeptid) {
	                alert(strLang95);
	                return;
	            }	
	      	        	
	        	$.ajax({
	        		method : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/admin/ezSchedule/scheduleSaveShareDept.do",
	        		data : {
	        			userID : userid,
	        			deptID : deptid
	        		},
	        		success : function(){
	        			alert("<spring:message code='ezSchedule.t30' />");
	        			
		                if (ReturnFunction != null) {
		                    ReturnFunction("OK");
		                } else {
		                    window.returnValue = "OK";
		                }	                
		                window.close();
	        		},
	        		error : function(err){
	        			alert("<spring:message code='ezSchedule.t31' />");
	        		}
	        	});	        	
	        }
	
	        window.onload = function () {
	            try {
	                ReturnFunction = opener.schedule_admin_popup_sharedept_dialogArguments[1];
	            } catch (e) {}
	
	            if ("<c:out value='${lang}' />" == "2") {
	                document.getElementById("txtuser").style.width = "54%";
	                document.getElementById("txtdept").style.width = "54%";
	            }
	        }
		</script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezSchedule.t6' /></h1>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t999' /></th>
	            <td>
	                <input id="txtuser" type="text" style="margin-bottom:2px; width:70%" onfocus="this.blur();" readonly="readonly" />
	                <a href="#" class="imgbtn"><span onclick="select_person()"><spring:message code='ezSchedule.t1000' /></span></a>                
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t1004' /></th>
	            <td>
	                <input id="txtdept" type="text" style="margin-bottom:2px; width:70%" onfocus="this.blur();" readonly="readonly" />
	                <a href="#" class="imgbtn"><span onclick="select_sharedept()"><spring:message code='ezSchedule.t1000' /></span></a>                
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="save_info()" ><spring:message code='ezSchedule.t157' /></span></a>
	        <a class="imgbtn"><span onclick="window.close()"><spring:message code='ezSchedule.t5' /></span></a>      
	    </div>
	</body>
</html>

