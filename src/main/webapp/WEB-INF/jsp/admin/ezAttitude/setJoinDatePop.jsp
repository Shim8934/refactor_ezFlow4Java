<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t288'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<!-- date picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		
		<style>
			.ui-datepicker {
				width: 220px;
				padding: .2em .2em 0;
				display: none;
				margin-top: 20px;
				font-size: 14px;
			}
			
			.ui-datepicker td span, .ui-datepicker td a{
			    font-size: 16px;
			}
			
			.ui-state-click {
				border: 1px solid #3d8fea;
			    background: rgb(241, 248, 255);
			    color: #fff;
			}
			
			
		</style>
		
	    <script type="text/javascript">
	    
	    	var userId = "<c:out value="${userId}" />";
	    	var companyId = "<c:out value="${companyId}" />";
	    	var date = "<c:out value="${date}" />";
	    	var mode = "<c:out value="${mode}" />";
	    	
	    	var monthMsg = "<spring:message code='ezAttitude.t139'/>";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezAttitude.t140'/>";
		    var dayStr = dayMsg.split(";");
	    
	    	$(document).ready(function(){
	    		
	    		setDatePicker();
	    		
	    		$.datepicker._showDatepicker(document.getElementById("datepicker"));
	    		
	    		$(".ui-datepicker-trigger").css({display: "none"});
	    		
   			});
	    	
	    	function setDatePicker() {
	    		var todayDate = new Date();
	    		var rangeEndYear = todayDate.getFullYear() + 1;
	    		var yearRange = rangeEndYear - 50  + ":" + rangeEndYear;
				$("#datepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            yearRange : yearRange
		        });
		        var uploadJoinDate = date;
		        
		        modFirstFlag = false;
		        
				var year = uploadJoinDate.substring(0, 4);
				var month = uploadJoinDate.substring(5, 7);
				var day = uploadJoinDate.substring(8, 10);
				
		        var SDate = new Date();
		        SDate.setFullYear(year, month-1, day);
		        
		        $("#datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#datepicker").datepicker('setDate', SDate);
		        
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
			        	closeText: "<spring:message code='main.t3' />",
			            prevText: "<spring:message code='main.t0604' />",
			            nextText: "<spring:message code='main.t0605' />",
						currentText: "<spring:message code='main.t0606' />",
			            monthNames: monthStr,
			            monthNamesShort: monthStr,
			            dayNames: dayStr,
			            dayNamesShort: dayStr,
			            dayNamesMin: dayStr,
			            weekHeader: 'Wk',
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true,
			            onSelect: function (obj) {
			                $('a.ui-state-default').removeClass('ui-state-click');
			                $('a.ui-state-default').removeClass('ui-state-active');
			                $('a.ui-state-hover').addClass('ui-state-click');
			                $('a.ui-state-default').removeClass('ui-state-hover');
			                inst.preventDefault(); // onSelect의 중복 호출 방지
			            }
			        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		        $.datepicker._hideDatepicker = function() {};
		        
			}
	    	
	    	
	    	//전체 연차 등록/수정
	    	function saveJoinDate() {
	    		date = $("#datepicker").val();
				
				$.ajax({
	   				type:"post",
	   				url:"/admin/ezAttitude/saveJoinDate.do",
	   				dataType : "text",
	   				data:{
	   					userId : userId,
	   					companyId : companyId,
	   					mode : mode,
	   					date : date
	   				},
					success : function(resultStatus) {
	            		if (resultStatus == "success") {
	   						opener.getAnnualList();
	   						window.close();
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
	            	},
	   				error : function() {
	   					alert("<spring:message code='ezAttitude.t175' />");
	   				}
	   			});
	   		}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	<spring:message code='ezAttitude.t288'/>
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	            <td>
	            	<input type="text" id="datepicker" style="width:225px;text-align:center;font-size: 15px;" readonly="readonly">
	            </td>
	        </tr>
	    </table>
	    <br/>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="saveJoinDate();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>