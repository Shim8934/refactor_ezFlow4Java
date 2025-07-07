<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code = 'ezAttitude.t292' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    
	    <!-- date picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<style>
			.content th {
				white-space: normal;
			}
			.ui-datepicker-year {
				display: none;
			}
	    </style>
	    
	    <script type="text/javascript">
	    	var adminCompany = "${adminCompany}";
	    	var initialDate = "";
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
	    	var nowYear = new Date().getFullYear();
	    	
	        $(document).ready(function() {
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    			if (document.getElementById("ListCompany").selectedIndex < 0) {
				            document.getElementById("ListCompany").selectedIndex = 0;
		    			}
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		            company_change();
		        }
		        
	    		$(function () {
			        $("#Sdatepicker").datepicker({
			            changeMonth: true,
			            changeYear: true,
			            autoSize: true,
			            showOn: "both",
			            buttonImage: "/images/ImgIcon/calendar-month.png",
			            buttonImageOnly: true
			        });
			        var NowDate;
			        if (initialDate != "") {
			        	/* 2018-12-28 김민성 - 달력 날짜 가져오는 부분 수정 */
			            NowDate = new Date(initialDate.substring(0, 4), initialDate.substring(5, 7)-1, initialDate.substring(8, 10));
			        }
			        else
			            NowDate = new Date();
			        $("#Sdatepicker").datepicker("option", "dateFormat", "mm-dd");
			        $("#Sdatepicker").datepicker('setDate', NowDate);
			    });
			    
			    $(function () {
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
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
			    });
	        });
	        
	        function company_change() {
	            $.ajax({
	            	type : "GET",
	            	url : "/admin/ezAttitude/attitudeAnnualConfigInfo.do",
	            	dataType : "json",
	            	data : {companyId : encodeURIComponent($("#ListCompany").val())},
	            	success : function(result) {
		            	attitudeConfigSet(result);
	            	},
	            	error : function() {
	            		alert("<spring:message code='ezAttitude.t329' />");
	            		$("#Sdatepicker").datepicker('setDate', new Date());
	            		$('input[name=use_annual_auto_gnrt]').eq(1).prop('checked', true);
	            		$('input[name=use_minus_annual]').eq(1).prop('checked', true);
	            		type_change('0');
	            	}
	            });
	        }
	        
	        function type_change(val){
	        	if(val == 0) {
		        	$("#ags").css('display', 'none');
		        	$("#sdp").css('display', 'none');
		        	$("#uat").css('display', 'none');
		        	$("#ror").css('display', 'none');
	        	} else if(val == 1) {
		        	$("#ags").css('display', '');
		        	if($('input[name=annual_gnrt_std]:checked').val() == 1) {
			        	$("#sdp").css('display', '');
		        	}
		        	$("#uat").css('display', '');
		        	$("#ror").css('display', '');
	        	} else if(val == 2) {
	        		if($('input[name=use_annual_auto_gnrt]').eq(0).prop('checked') == true) {
			        	$("#sdp").css('display', '');
	        		}
	        	} else {
		        	$("#sdp").css('display', 'none');
	        	}
		    }
	        
	        function attitudeConfigSet(result) {
	        	$('input:radio').prop('checked', false);
	        	
        		/* //연차취소신청방식
        		var annualCancelRule = result.annualCancelRule;
        		if (annualCancelRule == 0) {
        			$('input[name=annual_cancel_rule]').eq(2).prop('checked', true);
        		} else if (annualCancelRule == 1) {
        			$('input[name=annual_cancel_rule]').eq(0).prop('checked', true);
        		} else {
        			$('input[name=annual_cancel_rule]').eq(1).prop('checked', true);
        		} */
        		
        		//연차자동발생
        		var useAnnualAutoGnrt = result.useAnnualAutoGnrt;
        		if (useAnnualAutoGnrt == 0) {
        			$('input[name=use_annual_auto_gnrt]').eq(1).prop('checked', true);
	        		type_change(0);
        		} else {
        			$('input[name=use_annual_auto_gnrt]').eq(0).prop('checked', true);
	        		type_change(1);
        		}
        		
        		//연차발생기준
        		var annualGnrtStd = result.annualGnrtStd;
        		if (annualGnrtStd == 0) {
        			$('input[name=annual_gnrt_std]').eq(1).prop('checked', true);
	        		type_change(3);
        		} else {
        			$('input[name=annual_gnrt_std]').eq(0).prop('checked', true);
	        		type_change(2);
        		}
        		
        		//회계년도 기산일
        		initialDate = result.initialDate;
				$("#Sdatepicker").datepicker("option", "changeYear", false);
				$("#Sdatepicker").datepicker("option", "dateFormat", "mm-dd");
        		$("#Sdatepicker").datepicker('setDate', initialDate.split("-")[1]+"-"+initialDate.split("-")[2]);
        		//잔여연차 음수허용
        		var useMinusAnnual = result.useMinusAnnual;
        		if (useMinusAnnual == 0) {
        			$('input[name=use_minus_annual]').eq(1).prop('checked', true);
        		} else {
        			$('input[name=use_minus_annual]').eq(0).prop('checked', true);
        		}
        		
        		//연차소멸여부
        		var useAnnualTmnt = result.useAnnualTmnt;
        		if (useAnnualTmnt == 0) {
        			$('input[name=use_annual_tmnt]').eq(1).prop('checked', true);
        		} else {
        			$('input[name=use_annual_tmnt]').eq(0).prop('checked', true);
        		}
        		
        		//소수점처리
        		var roundOffRule = result.roundOffRule;
        		if (roundOffRule == 0) {
        			$('input[name=round_off_rule]').eq(1).prop('checked', true);
        		} else {
        			$('input[name=round_off_rule]').eq(0).prop('checked', true);
        		}
	        }
	        
	        function save_config() {
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezAttitude/updateAnnualConfInfo.do",
	            	dataType : "text",
	            	data : {
	            			companyId : encodeURIComponent($("#ListCompany").val()),
	            			annualCancelRule : $('input[name=annual_cancel_rule]:checked').val(),
	            			useAnnualAutoGnrt : $('input[name=use_annual_auto_gnrt]:checked').val(),
	            			annualGnrtStd : $('input[name=annual_gnrt_std]:checked').val(),
	            			initialDate : nowYear+"-"+$("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
	            			useMinusAnnual : $('input[name=use_minus_annual]:checked').val(),
	            			useAnnualTmnt : $('input[name=use_annual_tmnt]:checked').val(),
	            			roundOffRule : $('input[name=round_off_rule]:checked').val()
	            	},
	            	success : function(resultStatus) {
	            		if (resultStatus == "success") {
		            		alert("<spring:message code='ezAttitude.t155' />");
		            		company_change();
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
	<body class="mainbody">
	    <h1>
	    	<spring:message code = 'ezAttitude.t292' />
		    <span class="title_bar"><img src="/images/name_bar.gif"></span>
	    	<select class="companySelect" name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
				<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
				</c:forEach>
      		</select>
	    </h1>
		<table class="content" style="width:600px;margin-top:30px">
			<!-- <tr style="height:30px;">
	        	<th style="width: 40%; text-align:center">
	        		연차취소신청방식
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<input type="radio" name="annual_cancel_rule" value="1"/>근태관리자
	            	<input type="radio" name="annual_cancel_rule" value="2"/>전자결재
	            	<input type="radio" name="annual_cancel_rule" value="0"/>사용안함
	            </td>
	        </tr> -->
	        <tr style="height:30px;">
	        	<th style="width: 40%; text-align:center">
					<spring:message code = 'ezAttitude.t293' />
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<div class="custom_radio"><input type="radio" name="use_annual_auto_gnrt" value="1" onchange="type_change('1');"/></div><spring:message code = 'ezAttitude.t36' />
	            	<div class="custom_radio"><input type="radio" name="use_annual_auto_gnrt" value="0" onchange="type_change('0');"/></div><spring:message code = 'ezAttitude.t37' />
	            </td>
	        </tr>
	        <tr id="ags" style="height:30px;">
	        	<th style="width: 40%; text-align:center">
					<spring:message code = 'ezAttitude.t296' />
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<div class="custom_radio"><input type="radio" name="annual_gnrt_std" value="1" onchange="type_change('2');"/></div><spring:message code = 'ezAttitude.t297' />
	            	<div class="custom_radio"><input type="radio" name="annual_gnrt_std" value="0" onchange="type_change('3');"/></div><spring:message code = 'ezAttitude.t289' />
	            </td>
	        </tr>
	        <tr id="sdp" style="height:30px;">
	        	<th style="width: 40%; text-align:center">
					<spring:message code = 'ezAttitude.t298' />
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<input type="text" id="Sdatepicker" style="width: 80px; text-align: center" />
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 40%; text-align:center">
					<spring:message code = 'ezAttitude.t299' />
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<div class="custom_radio"><input type="radio" name="use_minus_annual" value="1"/></div><spring:message code = 'ezAttitude.t29' />
	            	<div class="custom_radio"><input type="radio" name="use_minus_annual" value="0"/></div><spring:message code = 'ezAttitude.t30' />
	            </td>
	        </tr>
	        <tr id="uat" style="height:30px;">
	        	<th style="width: 40%; text-align:center">
					<spring:message code = 'ezAttitude.t302' />
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<div class="custom_radio"><input type="radio" name="use_annual_tmnt" value="1"/></div><spring:message code = 'ezAttitude.t36' />
	            	<div class="custom_radio"><input type="radio" name="use_annual_tmnt" value="0"/></div><spring:message code = 'ezAttitude.t37' />
	            </td>
	        </tr>
	        <tr id="ror" style="height:30px;">
	        	<th style="width: 40%; text-align:center">
					<spring:message code = 'ezAttitude.t303' />
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<div class="custom_radio"><input type="radio" name="round_off_rule" value="1"/></div><spring:message code = 'ezAttitude.t304' />
	            	<div class="custom_radio"><input type="radio" name="round_off_rule" value="0"/></div><spring:message code = 'ezAttitude.t305' />
	            </td>
	        </tr>
		</table>
		<table style="border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px; width: 500px;">
	        <tbody>
	        	<tr>
		            <td>
		            	<div class="btnpositionJsp">
		                	<a class="imgbtn"><span onclick="save_config()"><spring:message code='ezAttitude.t16' /></span></a>
		                	<a class="imgbtn"><span onclick="company_change()"><spring:message code='ezAttitude.t34' /></span></a>
		                </div>	
		            </td>
	        	</tr>
	    	</tbody>
	    </table>
	</body>
</html>
