<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
    	<style type="text/css">
    		.pollImgbtn1{ white-space:nowrap; display:inline-block; cursor: pointer; height:17px; vertical-align:top; cursor:pointer; margin-top: 0px;}
			.pollImgbtn1 span{ display:inline-block; border:1px solid #d0d0d0; border-radius:3px; padding:0px 10px; height:16px; letter-spacing:-1; vertical-align:top; line-height:17px;}
    	</style>    	
    	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var g_windowReference = null;
			var checkFlag = "<c:out value='${hasConfig}'/>";
			var lang = "<c:out value='${lang}'/>";
			
         	document.onselectstart = function () { return false; };
         	
        	window.onload = function () {        		
           		if (navigator.userAgent.indexOf('Firefox') != -1) {
               		document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
       		        document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
               		document.body.style.UserSelect = 'none';
           		}	
           		
           		/* 2020-01-28 홍승비 - 다국어 환경인 경우, 투표 대상자 정렬 조정 */
           		if (lang == "2") { // 영어
           			document.getElementById("newTargetDiv").style.left = "137px";
           			document.getElementById("newTargetDiv").style.maxWidth = "325px";
           		} else if (lang == "3") { // 일본어
           			document.getElementById("newTargetDiv").style.left = "134px";
           		}
           		
           		preProcess();
        	}   
        	
        	function preProcess() {
        		if (checkFlag == "1") {
        			//Set target
        			document.getElementById("RangeXMLStr").value = sigBody.innerHTML;
        			
        			//Set time
        			var _sTime = "<c:out value='${startTime}'/>";
        			var _eTime = "<c:out value='${endTime}'/>";
        			
        			_sTime = _sTime.replace(":", "");
        			_eTime = _eTime.replace(":", "");

    	        	$("#sTimePicker").val(_sTime).change();
    	        	$("#eTimePicker").val(_eTime).change();            	 	
        		} 
        		
        		$('#set_Target').on('change', function(e) {					
    			    if ($(this).val() == '1') {    			    	
    			    	var listTarget = "<c:out value='${listOfTarget}'/>";
    			    	
   			    		if (listTarget != "") {
    			    		document.getElementById("RangeXMLStr").value = sigBody.innerHTML;
    			    		
            				var newTargetDiv = document.getElementById("newTargetDiv");
                	    	newTargetDiv.innerHTML = listTarget;
                	    	newTargetDiv.setAttribute("title", listTarget);
                	    	newTargetDiv.style.display = "";
   			    		}
   			    		
    			    	$('#receiverBttn').show();
    			    }
    			    else {			    	
    			    	document.getElementById("newTargetDiv").style.display = "none";	
    			    	$('#receiverBttn').hide();
    			    	
			    		document.getElementById("RangeXMLStr").value = "<RANGE></RANGE>";			    
    			    }
    			}); 
        	}
        	
        	function Cancel_Click() {
        		if (checkFlag == "1") {
	    			//Set target
	    			var listTarget = "<c:out value='${listOfTarget}'/>";
	    			if (listTarget != "") {
	    				$("#set_Target").val("1").change();
	    				$("#receiverBttn").show();
	    				
	    				var newTargetDiv = document.getElementById("newTargetDiv");
	        	    	newTargetDiv.innerHTML = listTarget;
	        	    	newTargetDiv.setAttribute("title", listTarget);
	        	    	newTargetDiv.style.display = "";    
	        	    	document.getElementById("RangeXMLStr").value = sigBody.innerHTML;
	    			}
	    			else {	    				
	    				$("#receiverBttn").hide();
	    				document.getElementById("RangeXMLStr").value = "<RANGE></RANGE>";
	    				$("#set_Target").val("0").change();
	    			}	
	        		
	    			//Set time
	    			var _sTime = "<c:out value='${startTime}'/>";
	    			var _eTime = "<c:out value='${endTime}'/>";
	    			
	    			_sTime = _sTime.replace(":", "");
	    			_eTime = _eTime.replace(":", "");
	
		        	$("#sTimePicker").val(_sTime).change();
		        	$("#eTimePicker").val(_eTime).change(); 
        		}
        		else {
        			//Set target
        			var newTargetDiv = document.getElementById("newTargetDiv");
	        	    newTargetDiv.innerHTML = "";
	        	    newTargetDiv.setAttribute("title", "");
	        	    newTargetDiv.style.display = "none";
        			document.getElementById("RangeXMLStr").value = "<RANGE></RANGE>";     			
        			$("#set_Target").val("0").change();
        			$("#receiverBttn").hide();
        			
        			//Set time
		        	$("#sTimePicker").val("0900").change();
		        	$("#eTimePicker").val("1800").change(); 
        		}
        	}
        	function Change_Click() {        		        		
        		var rangeSelect = document.getElementById("RangeXMLStr").value;
        		var sTimePickerElmt = document.getElementById("sTimePicker");        		
     			var startTime = sTimePickerElmt.options[sTimePickerElmt.selectedIndex].text;     			
        		var eTimePickerElmt = document.getElementById("eTimePicker");        		
     			var endTime = eTimePickerElmt.options[eTimePickerElmt.selectedIndex].text;
     			
     			if ($("#set_Target").val() == "1") {
     				if (rangeSelect == null || rangeSelect == "" || rangeSelect == "<RANGE></RANGE>") {
     					alert('<spring:message code="ezPoll.t235"/>');
         				return;
     				}
     			}
     		
     			$.ajax({
     				url : '/ezBoard/boardPollConfigSave.do',
     				method : 'POST',
     				dataType : 'text',
     				data : {
     					rangeSelect : rangeSelect,
     					startTime : startTime,
     					endTime : endTime	
     				} ,
	     			success : function(data, textStatus, jqXHR) {
	     				alert('<spring:message code="ezEmail.t42" />');
	     				window.location.reload();
     				},
     				error : function(jqXHR, textStatus, errorThrown) {
                	    alert('Error : ' + jqXHR.status + ", " + textStatus);
     				}
     			});       
        	}        
        	
        	function menu_SelectRange() {
	   	         if (CrossYN()) {   	            	   	   	            
	   	            var szUrl = "/ezPoll/qstRangeSelect.do?brdID=6";  	  
	   	            var _MSIE = 'MSIE';
	   	            var useragentstr = navigator.userAgent;
	   	            
	   	            if (useragentstr.indexOf(_MSIE) != -1) {	            	
	   	                var szParam = "dialogHeight:705px;dialogWidth:562px;edge:sunken;status:no;resizable:no;help:no;center:yes;scroll:no" + GetShowModalPosition(562, 705);
	   	                var rv = window.showModalDialog(szUrl, document.getElementById("RangeXMLStr").value, szParam);
	   	                
	   	                if (rv[0] == "OK") {
	   	                    //document.getElementById("set_Target").selectedIndex = 1;
	   	                    //document.getElementById("hidTarget").value = "1";
	   	                    //document.getElementById("select_YN").value = "YES";
	   	                    document.getElementById("RangeXMLStr").value = rv[1];
	   	                } 
	   	                else if (rv[0] == "NO") {
	   	                    //document.getElementById("set_Target").selectedIndex = 0;
	   	                    //document.getElementById("hidTarget").value = "0";
	   	                    //document.getElementById("selectYN").value = "NO";
	   	                    document.getElementById("RangeXMLStr").value = "";
	   	                }
	   	            } 
	   	            else {	            	
	   	                if ((g_windowReference == null) || (g_windowReference.closed == true)) {
	   	                    if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
	   	                        var feature = GetOpenPosition(560, 730);
	   	                        g_windowReference = window.open(szUrl, "SelectRange", "height=730,width=560,resizable=no,center=yes" + feature);
	   	                    } 
	   	                    else {
	   	                        var feature = GetOpenPosition(614, 720);
	   	                        g_windowReference = window.open(szUrl, "SelectRange", "height=720,width=614,resizable=no,center=yes" + feature);
	   	                    }
	   	                }
	   	                
	   	                g_windowReference.focus();
	   	            }
	   	         } 
	   	         else {
	   	             menu_SelectRange_IE();
	   	         } 
   	    	}
        	
    	    function menu_SelectRange_IE() {
    	        //var item_no = document.all("item_no").value;
    	        var szUrl = "/ezPoll/qstRangeSelect.do?brdID=6"; 
    	        
    	        if ((g_windowReference == null) || (g_windowReference.closed == true)) {
    	            if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
    	                var feature = GetOpenPosition(560, 630);
    	                g_windowReference = window.open(szUrl, "SelectRange", "height=630,width=560,resizable=no,center=yes" + feature);
    	            } 
    	            else {
    	                var feature = GetOpenPosition(560, 700);
    	                g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
    	            }
    	        }
    	        
    	        g_windowReference.focus();
    	    }
    	    
        	function GetRangeValue() {
    	        return document.getElementById("RangeXMLStr").value;
    	    }
        	
    	    function updateTarget(listOfTarget) {
    	    	var newTargetDiv = document.getElementById("newTargetDiv");
    	    	newTargetDiv.innerHTML = listOfTarget;
    	    	newTargetDiv.setAttribute("title", listOfTarget);
    	    	newTargetDiv.style.display = "";	    	
    	    }
    	    
    	    function updateParent(_element, _value, _Type) {
    	        var elementRef = document.getElementsByName(_element);
    	
    	        if (elementRef && elementRef.length > 0) {
    	            switch (_Type) {
    	                case "selectedIndex":
    	                    elementRef[0].selectedIndex = _value;
    	                    break;
    	                case "value":
    	                    elementRef[0].value = _value;    	                    
    	                    break;
    	            }
    	        }
    	    }
    	    
    	    function closeWindow() {
    	        if ((g_windowReference != null) && (g_windowReference.closed == false)) {
    	            g_windowReference.close();
    	            g_windowReference = null;
    	        }
    	    }
    	</script>
	</head>
		<xmp id="sigBody" style="display: none;">${xmlRange}</xmp>
		<body style="margin-left: 10px; margin-right: 10px;">
			<br/>	
    		<span class="txt">▒ <spring:message code="ezBoard.t00071" /></span>   
    		<br />  		
    		<span class="txt">▒ <spring:message code="ezBoard.t00072" /></span>
        	<br />    
        	<table class="content" style="width: 623px;margin-top:5px">
            	<tr>
                	<th><spring:message code="ezBoard.t00073" /></th>
                	<td>               
						<span style="padding-left: 5px;"><spring:message code="ezPoll.t246"/></span> 
						<select id="sTimePicker">
							<option value="0000">00:00</option>
							<option value="0030">00:30</option>
							<option value="0100">01:00</option>
							<option value="0130">01:30</option>
							<option value="0200">02:00</option>
							<option value="0230">02:30</option>
							<option value="0300">03:00</option>
							<option value="0330">03:30</option>
							<option value="0400">04:00</option>
							<option value="0430">04:30</option>
							<option value="0500">05:00</option>
							<option value="0530">05:30</option>
							<option value="0600">06:00</option>
							<option value="0630">06:30</option>
							<option value="0700">07:00</option>
							<option value="0730">07:30</option>
							<option value="0800">08:00</option>
							<option value="0830">08:30</option>							
							<c:if test="${hasConfig != '1'}">
								<option value="0900" selected="selected">09:00</option>
							</c:if>
							<c:if test="${hasConfig == '1'}">
								<option value="0900">09:00</option>
							</c:if>
							<option value="0930">09:30</option>
							<option value="1000">10:00</option>
							<option value="1030">10:30</option>
							<option value="1100">11:00</option>
							<option value="1130">11:30</option>
							<option value="1200">12:00</option>
							<option value="1230">12:30</option>
							<option value="1300">13:00</option>
							<option value="1330">13:30</option>
							<option value="1400">14:00</option>
							<option value="1430">14:30</option>
							<option value="1500">15:00</option>
							<option value="1530">15:30</option>
							<option value="1600">16:00</option>
							<option value="1630">16:30</option>
							<option value="1700">17:00</option>
							<option value="1730">17:30</option>
							<option value="1800">18:00</option>
							<option value="1830">18:30</option>
							<option value="1900">19:00</option>
							<option value="1930">19:30</option>
							<option value="2000">20:00</option>
							<option value="2030">20:30</option>
							<option value="2100">21:00</option>
							<option value="2130">21:30</option>
							<option value="2200">22:00</option>
							<option value="2230">22:30</option>
							<option value="2300">23:00</option>
							<option value="2330">23:30</option>
						</select>
						<span style="padding-left: 5px;"><spring:message code="ezPoll.t247"/></span> 
						<select id="eTimePicker">
							<option value="0000">00:00</option>
							<option value="0030">00:30</option>
							<option value="0100">01:00</option>
							<option value="0130">01:30</option>
							<option value="0200">02:00</option>
							<option value="0230">02:30</option>
							<option value="0300">03:00</option>
							<option value="0330">03:30</option>
							<option value="0400">04:00</option>
							<option value="0430">04:30</option>
							<option value="0500">05:00</option>
							<option value="0530">05:30</option>
							<option value="0600">06:00</option>
							<option value="0630">06:30</option>
							<option value="0700">07:00</option>
							<option value="0730">07:30</option>
							<option value="0800">08:00</option>
							<option value="0830">08:30</option>
							<option value="0900">09:00</option>
							<option value="0930">09:30</option>
							<option value="1000">10:00</option>
							<option value="1030">10:30</option>
							<option value="1100">11:00</option>
							<option value="1130">11:30</option>
							<option value="1200">12:00</option>
							<option value="1230">12:30</option>
							<option value="1300">13:00</option>
							<option value="1330">13:30</option>
							<option value="1400">14:00</option>
							<option value="1430">14:30</option>
							<option value="1500">15:00</option>
							<option value="1530">15:30</option>
							<option value="1600">16:00</option>
							<option value="1630">16:30</option>
							<option value="1700">17:00</option>
							<option value="1730">17:30</option>
							<c:if test="${hasConfig != '1'}">
								<option value="1800" selected="selected">18:00</option>
							</c:if>
							<c:if test="${hasConfig == '1'}">
								<option value="1800">18:00</option>
							</c:if>
							<option value="1830">18:30</option>
							<option value="1900">19:00</option>
							<option value="1930">19:30</option>
							<option value="2000">20:00</option>
							<option value="2030">20:30</option>
							<option value="2100">21:00</option>
							<option value="2130">21:30</option>
							<option value="2200">22:00</option>
							<option value="2230">22:30</option>
							<option value="2300">23:00</option>
							<option value="2330">23:30</option>
						</select>
                   	</td>                   	
            	</tr>
            	<tr>
                	<th><spring:message code="ezBoard.t00074" /></th>
                	<td style="position: relative; background-clip: padding-box;">
               			<c:choose>
               				<c:when test="${hasConfig == '1' && listOfTarget != ''}">
               					<select id="set_Target" style="margin-left: 5px;">							
									<option value="0"><spring:message code="ezPoll.t237" /></option>
									<option value="1" selected="selected"><spring:message code="ezPoll.t238" /></option>							
								</select>
								<a class="pollImgbtn1" id="receiverBttn" style=""><span onclick="menu_SelectRange();"><spring:message code="ezPoll.t163"/></span></a>
								<div style="position: absolute; left: 125px; top: 0px; height: 30px; line-height: 30px; overflow: hidden; text-overflow: ellipsis; max-width: 380px; white-space: nowrap;" id="newTargetDiv" title="<c:out value='${listOfTarget}'/>" ><c:out value='${listOfTarget}'/></div>
               				</c:when>
							<c:otherwise>
								<select id="set_Target" style="margin-left: 5px;">
									<option value="0" selected="selected"><spring:message code="ezPoll.t237" /></option>
									<option value="1"><spring:message code="ezPoll.t238" /></option>
								</select>
								<a class="pollImgbtn1" id="receiverBttn" style="display: none;"><span onclick="menu_SelectRange();"><spring:message code="ezPoll.t163"/></span></a>
								<div style="display:none; position: absolute; left: 125px; top: 0px; height: 30px; line-height: 30px; overflow: hidden; text-overflow: ellipsis; max-width: 380px; white-space: nowrap;" id="newTargetDiv" ></div>
							</c:otherwise>
               			</c:choose>
                	</td>
            	</tr>
        	</table>
    		<div class="btnpositionJsp" style="width:609px;">      
        		<a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezBoard.t98" /></span></a>
        		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezBoard.t15" /></span></a>
    		</div>
    		
    		<div style="display:none">
				<input type="text" name="RangeXMLStr" id="RangeXMLStr" style="display:none">					
			</div>
		</body>
</html>