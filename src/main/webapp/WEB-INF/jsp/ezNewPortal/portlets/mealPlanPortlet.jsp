<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>mealPlan</title>
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
				<dd id="noMealPlanDd"><spring:message code='main.t00026' /></dd>
        	</dl>
        	<div class="mealPlanlist" id="mealPlan_Portlet_List">
				<table id="mealPlanTable" class="mealTable">
					<colgroup>
						<col width="26%">
						<col width="48%">
						<col width="26%">
					</colgroup>
					<tbody>
						<tr>
							<th>코스</th>
							<th>메뉴</th>
							<th><spring:message code='ezMealPlan.jsb006' /></th>
						</tr>
						<tr id="aCourseRow">
							<td class="aCourse"><spring:message code='ezMealPlan.jsb002' /></td>
							<td class="aCourse" id="aCourseData"></td>
							<td class="totalCal" id="totalCalData" rowspan="4"></td>
						</tr>
						<tr id="bCourseRow">
							<td class="bCourse"><spring:message code='ezMealPlan.jsb003' /></td>
							<td class="bCourse" id="bCourseData"></td>
						</tr>
						<tr id="saladBarRow">
							<td><spring:message code='ezMealPlan.jsb004' /></td>
							<td id="saladBarData"></td>
						</tr>
						<tr id="dessertRow">
							<td><spring:message code='ezMealPlan.jsb005' /></td>
							<td id="dessertData"></td>
						</tr>
					</tbody>
				</table>
        	</div>
    	</div>
    </div>        
</article>
</body>
</html>