<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code = 'ezAttitude.t2' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <!-- time picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	    <script type="text/javascript">
	    	var adminCompany = "${adminCompany}";
	    
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
	            		alert("<spring:message code='ezAttitude.t175' />");
	            	}
	            });
	        }
	        
	        function attitudeConfigSet(result) {
	        	$('input:radio').prop('checked', false);
	        	
        		//연차취소신청방식
        		var annualCancelRule = result.annualCancelRule;
        		if (annualCancelRule == 0) {
        			$('input[name=annual_cancel_rule]').eq(2).prop('checked', true);
        		} else if (annualCancelRule == 1) {
        			$('input[name=annual_cancel_rule]').eq(0).prop('checked', true);
        		} else {
        			$('input[name=annual_cancel_rule]').eq(1).prop('checked', true);
        		}
        		
        		//연차자동발생
        		var useAnnualAutoGnrt = result.useAnnualAutoGnrt;
        		if (useAnnualAutoGnrt == 0) {
        			$('input[name=use_annual_auto_gnrt]').eq(1).prop('checked', true);
        		} else {
        			$('input[name=use_annual_auto_gnrt]').eq(0).prop('checked', true);
        		}
        		
        		//연차발생기준
        		var annualGnrtStd = result.annualGnrtStd;
        		if (annualGnrtStd == 0) {
        			$('input[name=annual_gnrt_std]').eq(1).prop('checked', true);
        		} else {
        			$('input[name=annual_gnrt_std]').eq(0).prop('checked', true);
        		}
        		
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
	    	연차설정관리
		    <span class="title_bar"><img src="/images/name_bar.gif"></span>
	    	<select class="companySelect" name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
				<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
				</c:forEach>
      		</select>
	    </h1>
		<table class="content" style="width:500px;margin-top:5px">
			<tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
	        		연차취소신청방식
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<input type="radio" name="annual_cancel_rule" value="1"/>근태관리자
	            	<input type="radio" name="annual_cancel_rule" value="2"/>전자결재
	            	<input type="radio" name="annual_cancel_rule" value="0"/>사용안함
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					연차자동발생
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<input type="radio" name="use_annual_auto_gnrt" value="1"/>사용
	            	<input type="radio" name="use_annual_auto_gnrt" value="0"/>사용안함
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					연차발생기준
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<input type="radio" name="annual_gnrt_std" value="1"/>회계년도
	            	<input type="radio" name="annual_gnrt_std" value="0"/>입사일
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					잔여연차 음수허용
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<input type="radio" name="use_minus_annual" value="1"/>허용
	            	<input type="radio" name="use_minus_annual" value="0"/>허용안함
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					1개월 만근시 발생연차 1년경과 시 소멸
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<input type="radio" name="use_annual_tmnt" value="1"/>사용
	            	<input type="radio" name="use_annual_tmnt" value="0"/>사용안함
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					연차 소수점 계산 처리
	            </th>
	            <td style="width: 700px; text-align:left">
	            	<input type="radio" name="round_off_rule" value="1"/>0.5일
	            	<input type="radio" name="round_off_rule" value="0"/>1일
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
