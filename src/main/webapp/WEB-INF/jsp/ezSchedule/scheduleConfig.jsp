<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t133' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />		
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />			    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript">
		    var defaultview = "<c:out value='${scheduleConfigVO.defaultView}'/>";
			var startday = "<c:out value='${scheduleConfigVO.startDay}'/>";
			var starttime = "<c:out value='${scheduleConfigVO.startTime}'/>";
			var endtime = "<c:out value='${scheduleConfigVO.endTime}'/>";
			var autodelete = "<c:out value='${scheduleConfigVO.isAutoDelete}'/>";
			
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (defaultview != "") {
		            document.getElementById("DefaultViewSelect").value = defaultview;
		            document.getElementById("StartDaySelect").value = startday;
		            document.getElementById("StartTimeSelect").value = starttime;
		            document.getElementById("EndTimeSelect").value = endtime;
	
		            if (autodelete != "0") {
		                document.getElementById("CheckDelete").checked = false;
		                document.getElementById("TextDelete").value = autodelete;
		            }
		        }
		    }
					
		    function CheckDeleteClick() {
		        if (document.getElementById("CheckDelete").checked == true) {
		            document.getElementById("TextDelete").value = "";
		            document.getElementById("TextDelete").readOnly = true;
		        }
		        else
		            document.getElementById("TextDelete").readOnly = false;
		    }
					
		    function save_info() {
		        if (document.getElementById("TextDelete").value != "" && parseInt(document.getElementById("TextDelete").value) != document.getElementById("TextDelete").value ||
		            parseInt(document.getElementById("TextDelete").value) > 5000) {
			            alert("<spring:message code='ezSchedule.t134' />");
			            document.getElementById("TextDelete").focus();
			            return;
		        }
	
		        if (document.getElementById("StartTimeSelect").selectedIndex >= document.getElementById("EndTimeSelect").selectedIndex) {
		            alert("<spring:message code='ezSchedule.t135' />");
		            return;
		        }	      
		        
		        var listSecretary = new Array();		        
                var count = 0;		        
		        
		        for (var i = 0; i < document.getElementById("ListSecretary").length; i++) {		            
		            var data = new Object();
                    data.secretaryID = document.getElementById("ListSecretary").options[i].value;
                    data.secretaryName = getNodeText(document.getElementById("ListSecretary").options[i]);                     
                    
                    listSecretary.push(data);
                    count++;
		        }		        
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "html",				    		
		    		async : false,
		    		data : {
		    			DEFAULTVIEW : document.getElementById("DefaultViewSelect").value,
		    			STARTDAY : document.getElementById("StartDaySelect").value,
		    			STARTTIME : document.getElementById("StartTimeSelect").value,
		    			ENDTIME : document.getElementById("EndTimeSelect").value,
		    			AUTODELETE : (document.getElementById("TextDelete").value == "" ? "0" : document.getElementById("TextDelete").value),
		    			DISPLAYNAME : "<c:out value='${displayName1}'/>",
		    			DISPLAYNAME2 : "<c:out value='${displayName2}'/>",
		    			LISTSECRETARY : JSON.stringify(listSecretary)
		    		},
		    		url : "/ezSchedule/scheduleSaveConfig.do",
		    		success: function(text){
		    			alert("<spring:message code='ezSchedule.t137' />");		    			
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezSchedule.t136' />");
		    		}
		        });		
	
		        try {
		            if (parent.parent.frames["left"].CalendarMini != undefined)		            	
		                parent.parent.frames["left"].location = "/ezSchedule/scheduleLeft.do?funCode=11";		            	    	
		        } catch (e) { }
		    }
					
		    var schedule_select_attendant_dialogArguments = new Array();
		    function ModifySecretary() {
		        var secretary = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };
	
		        for (var i = 0; i < document.getElementById("ListSecretary").length; i++) {
		            secretary["id"][i] = document.getElementById("ListSecretary").options[i].value;
		            secretary["name"][i] = getNodeText(document.getElementById("ListSecretary").options[i]);
		            secretary["name1"][i] = getNodeText(document.getElementById("ListSecretary").options[i]);
		            secretary["name2"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "name2");
		            secretary["deptname"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "deptname");
		            secretary["deptname2"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "deptname");
		            secretary["email"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "email");
		        }
		        schedule_select_attendant_dialogArguments[0] = secretary;
		        schedule_select_attendant_dialogArguments[1] = ModifySecretary_Complete;
		        var OpenWin = window.open("/ezSchedule/scheduleSelectAttendant.do?gubun=config&title=" + encodeURI("<spring:message code='ezSchedule.t138' />"), "schedule_group_write", GetOpenWindowfeature(980, 670));
		        try { OpenWin.focus(); } catch (e) { }
		    }
	
		    function ModifySecretary_Complete(rtn) {
		        if (typeof (rtn) != "undefined") {
		            var length = document.getElementById("ListSecretary").length;
		            for (var i = 0; i < length; i++)
		                document.getElementById("ListSecretary").options[0] = null;
	
		            for (var i = 0; i < rtn["id"].length; i++) {
		                var lastindex = document.getElementById("ListSecretary").length;
		                var newoption = new Option(rtn["name"][i], rtn["id"][i]);
		                document.getElementById("ListSecretary").options[lastindex] = newoption;
		            }
		        }
		    }
		</script>
	</head>
	<body style="margin-left:10px">
		<form method="post">
		<br />   
			<table class="content" style="width:450px;">
		    	<tr>
		      		<th><spring:message code='ezSchedule.t139' /></th>
		      		<td>
		      			<select name="DefaultViewSelect" id="DefaultViewSelect" style="width:65px">
		          			<option value="0"><spring:message code='ezSchedule.t140' /></option>
		          			<option value="1"><spring:message code='ezSchedule.t141' /></option>
		          			<option value="2" selected><spring:message code='ezSchedule.t142' /></option>
		        		</select>
		      		</td>
		    	</tr>
		    	<tr>
		      		<th><spring:message code='ezSchedule.t143' /></th>
		      		<td>
		      			<select name="StartDaySelect" id="StartDaySelect" style="width:65px">
		          			<option selected value="7"><spring:message code='ezSchedule.t395' /></option>
		          			<option value="1"><spring:message code='ezSchedule.t396' /></option>
		        		</select>
		      		</td>
		    	</tr>
		    	<tr>
		      		<th><spring:message code='ezSchedule.t149' /></th>
		      		<td>
		      			<select name="StartTimeSelect" id="StartTimeSelect" style="width:65px">
			          		<option value="0">00:00</option>
					        <option value="60">01:00</option>
					        <option value="120">02:00</option>
					        <option value="180">03:00</option>
					        <option value="240">04:00</option>
					        <option value="300">05:00</option>
					        <option value="360">06:00</option>
					        <option value="420">07:00</option>
					        <option value="480">08:00</option>
					        <option value="540" selected>09:00</option>
					        <option value="600">10:00</option>
					        <option value="660">11:00</option>
					        <option value="720">12:00</option>
					        <option value="780">13:00</option>
					        <option value="840">14:00</option>
					        <option value="900">15:00</option>
					        <option value="960">16:00</option>
					        <option value="1020">17:00</option>
					        <option value="1080">18:00</option>
					        <option value="1140">19:00</option>
					        <option value="1200">20:00</option>
					        <option value="1260">21:00</option>
					        <option value="1320">22:00</option>
					        <option value="1380">23:00</option>
			        	</select>
		       			<spring:message code='ezSchedule.t150' />
				        <select name="EndTimeSelect" id="EndTimeSelect" style="width:65px">
					         <option value="0">00:00</option>
					         <option value="60">01:00</option>
					         <option value="120">02:00</option>
					         <option value="180">03:00</option>
					         <option value="240">04:00</option>
					         <option value="300">05:00</option>
					         <option value="360">06:00</option>
					         <option value="420">07:00</option>
					         <option value="480">08:00</option>
					         <option value="540">09:00</option>
					         <option value="600">10:00</option>
					         <option value="660">11:00</option>
					         <option value="720">12:00</option>
					         <option value="780">13:00</option>
					         <option value="840">14:00</option>
					         <option value="900">15:00</option>
					         <option value="960">16:00</option>
					         <option value="1020">17:00</option>
					         <option value="1080" selected>18:00</option>
					         <option value="1140">19:00</option>
					         <option value="1200">20:00</option>
					         <option value="1260">21:00</option>
					         <option value="1320">22:00</option>
					         <option value="1380">23:00</option>
				        </select>
				        <spring:message code='ezSchedule.t151' />
					</td>
				</tr>
			    <tr>
			    	<th><spring:message code='ezSchedule.t152' /></th>
			      	<td>			      		
			      		<select name="ListSecretary" id="ListSecretary" style="width:85px">
			      			<c:forEach var="item" items="${selectList}">
			      				<option value="${item.cn}" name2="${item.displayName2}" deptname="${item.description}" deptname2="${item.description2}" email="${item.mail}">
			      					${item.displayName}
			      				</option>
			      			</c:forEach>
			      		</select>			      		
			        	<a class="imgbtn"><span onClick="ModifySecretary()"><spring:message code='ezSchedule.t153' /></span></a>
			        </td>
			    </tr>
		    	<tr style="display:none">
		      		<th><spring:message code='ezSchedule.t154' /></th>
		      		<td>
		      			<input type="text" name="TextDelete" id="TextDelete" value="" size="8" readonly ="true" />
		        		<spring:message code='ezSchedule.t155' />
		        		<input type="checkbox" id="CheckDelete" value="radiobutton" onClick="CheckDeleteClick()" checked />
		        		<spring:message code='ezSchedule.t156' />
		        	</td>
		    	</tr>
		  	</table>
		  	<br/>
		  	<div align="center" style="width:450px;">
		    	<a class="imgbtn" onClick="save_info()"><span><spring:message code='ezSchedule.t157' /></span></a>
		    	<a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezSchedule.t5' /></span></a>
		  	</div>
		</form>
	</body>
</html>