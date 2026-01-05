<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t6' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>	    
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">			
		    var userid = "";
	        var userdeptid = "";
	        var deptid = "";
	        var ReturnFunction;
	        var companyID = opener.selectedCompanyID
	        
	        var schedule_select_secretary_cross_dialogArguments = new Array();
	        function select_person() {
	            if (CrossYN()) {
	                schedule_select_secretary_cross_dialogArguments[1] = select_person_Complete;
	
	                if (navigator.appName.indexOf("Microsoft") > -1) {
	                    var OpenWin = window.open("/ezSchedule/scheduleSelectSecretary.do", "scheduleSelectSecretary", GetOpenWindowfeature(1000, 580));
	                    try { OpenWin.focus(); } catch (e) { }
	                } else {
	                    var OpenWin = window.open("/ezSchedule/scheduleSelectSecretary.do", "scheduleSelectSecretary", GetOpenWindowfeature(1000, 590));
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
	
	                var OpenWin = window.open("/ezSchedule/scheduleSelectShareDept.do", "scheduleSelectShareDept", GetOpenWindowfeature(300, 590));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	                var rtnValue = "";
	                var feature = GetShowModalPosition(280, 435);
	                
	                if (navigator.appName.indexOf("Microsoft") > -1) {
	                    rtnValue = window.showModalDialog("/ezSchedule/scheduleSelectShareDept.do", "","dialogHeight:435px;dialogwidth:275px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                } else {
	                    rtnValue = window.showModalDialog("/ezSchedule/scheduleSelectShareDept.do", "","dialogHeight:435px;dialogwidth:275px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
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
	        			deptID : deptid,
	        			companyID : companyID
	        		},
	        		success : function(text){
	        			if (text == "SUCCESS") {
		        			alert("<spring:message code='ezSchedule.t30' />");
		        			
			                if (ReturnFunction != null) {
			                    ReturnFunction("OK");
			                } else {
			                    window.returnValue = "OK";
			                }
			                window.close();
	        			} else {
	        				alert(strLang1003);
	        			}		                
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
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t999' /></th>
	            <td>
					<div style="display:flex; align-items: center; gap:3px;">
	                <input id="txtuser" type="text" style="width:84%" onfocus="this.blur();" readonly="readonly" />
	                <a class="imgbtn imgbck"><span onclick="select_person()"><spring:message code='ezSchedule.t1000' /></span></a>
					</div>
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t1004' /></th>
	            <td>
					<div style="display:flex; align-items: center; gap:3px;">
	                <input id="txtdept" type="text" style="width:84%" onfocus="this.blur();" readonly="readonly" />
	                <a class="imgbtn imgbck"><span onclick="select_sharedept()"><spring:message code='ezSchedule.t1000' /></span></a>
					</div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnpositionNew">
	        <a class="imgbtn"><span onclick="save_info()" ><spring:message code='ezSchedule.t157' /></span></a>
	    </div>
	</body>
</html>

