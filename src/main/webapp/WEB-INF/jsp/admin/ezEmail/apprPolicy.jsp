<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='email.appr.menu.normal.policy' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
</head>
<body>
	<div>
    	<div>
    		<div>
	    		<table class="mainlist" style="width: 100%; ">
					<colgroup>
						<col width="10%">
						<col width="*">
						<col width="20%">
					</colgroup>
					<tbody>
						<tr>
							<th><spring:message code="email.appr.th.num" /></th> 			<% // 번호 %>
							<th><spring:message code="email.appr.th.description" /></th> 	<% // 설명 %>
							<th><spring:message code="email.appr.th.limit" /></th> 			<% // 제한 %>
						</tr>
					</tbody>
				</table>
				<div>
					<table class="mainlist" id="policyListTable" style="width: 100%; ">
						<colgroup>
							<col width="10%">
							<col width="*">
							<col width="20%">
						</colgroup>
						<tbody>
							<tr>
								<td>1</td>
								<td><spring:message code="email.appr.menu.normal.policy.p1" /></td>
								<td class="policyData">
									<select style="height:22px;" data-key="OUT"> 
		    							<option value="UNUSED" 	${'UNUSED' eq useApprMailOut ? 'selected' : ''}><spring:message code='email.appr.unused' /></option> <% // 사용안함 %>
		    							<option value="USAGE" 	${'USAGE' eq useApprMailOut ? 'selected' : ''}><spring:message code='email.appr.usage' /></option> <% // 사용함 %>
                                        <option value="USAGE_ATTACH" ${'USAGE_ATTACH' eq useApprMailOut ? 'selected' : ''}><spring:message code='email.appr.usage.attach' /></option> <% // 첨부파일 포함 메일 %>
		    						</select>
								</td>
							</tr>
							<tr>
								<td>2</td>
								<td><spring:message code="email.appr.menu.normal.policy.p2" /></td>
								<td class="policyData">
									<select style="height:22px;" data-key="IN"> 
		    							<option value="UNUSED" 	${'UNUSED' eq useApprMailIn ? 'selected' : ''}><spring:message code='email.appr.unused' /></option> <% // 사용안함 %>
		    							<option value="USAGE" 	${'USAGE' eq useApprMailIn ? 'selected' : ''}><spring:message code='email.appr.usage' /></option> <% // 사용함 %>
                                        <option value="USAGE_ATTACH" ${'USAGE_ATTACH' eq useApprMailIn ? 'selected' : ''}><spring:message code='email.appr.usage.attach' /></option> <% // 첨부파일 포함 메일 %>
		    						</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div> <!--  contentlist_layout END -->
						
		<div class="btnpositionJsp">
			<a class="imgbtn"><span onclick="savePolicy()"><spring:message code='common.save' /></a> <% // 저장 %>
	       	<a class="imgbtn"><span onclick="document.location.reload()"><spring:message code='common.cancel' /></a> <% // 취소 %>
		</div>	
    </div>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script>
	const COMPANYID = "<c:out value='${companyId}'/>";
	
	// 설정 저장 이벤트
	function savePolicy() {
		let policyData = {};
		$("#policyListTable tr>td.policyData>select").each(function(i, e) {
			policyData[e.dataset.key] = e.value;
		});
		
		$.ajax({
			type:"POST",
			data:{
				"companyId" : COMPANYID,
				"policyData" : JSON.stringify(policyData)
			},
			url:"/admin/ezEmail/appr/setPolicy.do",
			success:function() {
				alert("<spring:message code='main.sp10' />");
			}, error : function() {
				alert("<spring:message code='main.sp12' />");
			}
		})
	}
	</script>
</body>
</html>