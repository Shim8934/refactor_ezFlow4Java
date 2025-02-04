<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>mealPlan</title>
	<style type="text/css">
		.mealPlanlist th, .mealPlanlist td{
			border: 1px solid #dedede;
		}
		.mealPlanlist th {
			width: 30%
		}
	</style>
</head>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/mealPlanPortlet.js')}"></script>
<script type="text/javascript">
	var portletName = "<c:out value='${portletName }'/>";
	var portletId = "<c:out value='${portletId}'/>";
	var companyID = "<c:out value='${companyID}'/>";
	var tenantID = "<c:out value='${tenantID}'/>";
	
	$(function() {
		ellipsisTitle(portletName, portletId);
		settingMealPlanCalendar();
		getMealData();
	});
</script>
<body>
<article class="mealPlan_portlet box_shadow">
    <div class="layDIV">
        <dl class="portlet_title sortablePortlet">
            <dt class="portletText"></dt>
            <dd class="portletPlus plus" id="mealPlanPlus"></dd>
            <dd class="mealPlan_calendal">
                <input type="text" class="DatePicker_class" name="Datepicker_name" id="mealPlanDatePicker" style="padding-right:18px;" size="10" readonly="readonly">
            </dd>
        </dl>
        <div class="mealPlan_contents">
        	<dl class="nodata" id="noMealPlanDl" style="display:none">
        		<dt>
        			<img src="/images/kr/main/noData_sIcon.png" style="width: auto; height: auto;">
        		</dt>
        		<dd><spring:message code='main.t00026' /></dd>
        	</dl>
        	<div class="mealPlanlist" id="mealPlan_Portlet_List">
				<table id="mealPlanTable" style="border-collapse: collapse;	width: 100%">
					<tr id="aCourseRow">
						<th>
							<spring:message code='ezMealPlan.jsb002' />
						</th>
						<td id="aCourseData">
						</td>
					</tr>
					<tr id="bCourseRow">
						<th>
							<spring:message code='ezMealPlan.jsb003' />
						</th>
						<td id="bCourseData">
						</td>
					</tr>
					<tr id="saladBarRow">
						<th>
							<spring:message code='ezMealPlan.jsb004' />
						</th>
						<td id="saladBarData">
						</td>
					</tr>
					<tr id="dessertRow">
						<th>
							<spring:message code='ezMealPlan.jsb005' />
						</th>
						<td id="dessertData">
						</td>
					</tr>
					<tr id="totalCalRow">
						<th>
							<spring:message code='ezMealPlan.jsb006' />
						</th>
						<td id="totalCalData">
						</td>
					</tr>
				</table>
        	</div>
    	</div>
    </div>        
</article>
</body>
</html>