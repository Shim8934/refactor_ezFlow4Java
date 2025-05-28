<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<script type="text/javascript">
    $(function() {
        var portletName = "<c:out value='${portletName }'/>";
        var portletId = "<c:out value='${resPortletId}'/>";
        ellipsisTitle(portletName, portletId);
    });
</script>
<body>
<article class="resources_portlet box_shadow">
    <div class="layDIV">
        <dl class="portlet_title sortablePortlet">
            <dt class="portletText"></dt>
            <dd class="portletPlus plus" id="resourcePlus"></dd>
            <dd class="portletPlus setting" id="resourceSetting"></dd>
            <dd class="resources_calendal">
                <input type="text" class="DatePicker_class" name="Datepicker_name" id="Sdatepicker" style="padding-right:18px;" size="10" readonly="readonly">
            </dd>
        </dl>
        <div class="resource_listBox">
        	<ul class="resource_listBoxUL" id="Resource_Portlet_List">

        	</ul>
    	</div>
    </div>        
</article>



		<input id='_T1' class='datepicker_time' readonly style="display:none">
		<IMG align="absmiddle" border="0" height="16" id="img_StartTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative; display:none;" width="16">


<script>
	
</script>
</body>
</html>