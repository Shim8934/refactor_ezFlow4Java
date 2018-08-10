<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
    	<link rel="stylesheet" href="/css/Tab.css" type="text/css" />
    	<style type="text/css">
    		.pollImgbtn1{ white-space:nowrap; display:inline-block; cursor: pointer; height:17px; vertical-align:top; cursor:pointer; margin-top: 0px;}
			.pollImgbtn1 span{ display:inline-block; border:1px solid #d0d0d0; border-radius:3px; padding:0px 10px; height:16px; font:12px gulim; letter-spacing:-1; vertical-align:top; line-height:17px;}
    	</style>    	
    	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var g_windowReference = null;
			var checkFlag 		  = "<c:out value='${hasConfig}'/>";
			
         	document.onselectstart = function () { return false; };
         	
        	window.onload = function () {        		
           		if (navigator.userAgent.indexOf('Firefox') != -1) {
               		document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
       		        document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
               		document.body.style.UserSelect = 'none';
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
	   	                        var feature = GetOpenPosition(730, 700);
	   	                        g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
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
    		<h2><spring:message code="ezMemo.t001" /></h2>
    		<span class="txt">▒ <spring:message code="ezMemo.t002" /></span>   
    		<br />
    		<span class="txt">▒ <spring:message code="ezMemo.t003" /></span>
        	<br />
        	<span class="txt">▒ <spring:message code="ezMemo.t004" /></span>
        	<br />
        	<table class="content" style="width: 623px;margin-top:5px">
            	<tr>
                	<th><spring:message code="ezMemo.t005" /></th>
                	<td> 
						<select id="set_quickFlag" style="margin-left: 5px;">
							<option value="0000"><spring:message code="ezMemo.t008"/></option>
							<option value="0030"><spring:message code="ezMemo.t009"/></option>
						</select>
                   	</td>                   	
            	</tr>
            	<tr>
                	<th><spring:message code="ezMemo.t006" /></th>
                	<td>
                		<select id="set_DateFlag" style="margin-left: 5px;">							
							<option value="0"><spring:message code="ezMemo.t008"/></option>
							<option value="1"><spring:message code="ezMemo.t009"/></option>							
						</select>
                	</td>
            	</tr>
            	<tr>
                	<th><spring:message code="ezMemo.t007" /></th>
                	<td>
               			<select id="set_fontSize" style="margin-left: 5px;">							
							<option value="33"><spring:message code="ezMemo.t0010"/></option>
							<option value="44"><spring:message code="ezMemo.t0011"/></option>
							<option value="55"><spring:message code="ezMemo.t0012"/></option>							
						</select>
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