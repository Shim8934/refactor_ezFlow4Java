<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezResource.t13"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezResource/organtreeview.htc.js"></script>
		<script type="text/javascript" src="/js/ezResource/control/ListView_list.js"></script>
		<script type="text/javascript">
		 	var ReturnFunction;
		    var retVal = new Array();
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        }
		    }

		    window.onload = function () {
		        try {
		            dialogArguments = parent.checkdeptname_cross_dialogArguments[0];
		            ReturnFunction = parent.checkdeptname_cross_dialogArguments[1];
		            retVal["deptid"] = "";
		        }
		        catch (e) {
		        }
		        initializeReceiverList();        
		    }

		    function initializeReceiverList() {
		        document.getElementById("ListView").innerHTML = "";
		        var listview = new ListView();
		        listview.SetID("OrganListView");
		        listview.SetRowOnDblClick("change_onClick");
		        listview.SetSelectFlag(false);
		        listview.SetHeightFree(false);
		        listview.DataSource(loadXMLString(document.getElementById("listviewheader").innerHTML.toUpperCase()));
		        listview.DataBind("ListView");
		        listview.DataSource(dialogArguments["addrBook"]);
		        listview.RowDataBind();
		    }

		    function change_onClick() {
		        var count1;
		        var selectedItemCount;
		        var selRow;
		        var listview = new ListView();

		        listview.LoadFromID("OrganListView");
		        var GetListRow = listview.GetSelectedRows();

		        if (!GetListRow[0]) {
		            alert("<spring:message code="ezResource.t163"/>");
				    return;
		        }
		        if (ReturnFunction != null) {
		            retVal["deptid"] = GetListRow[0].getAttribute("DATA2");
		            ReturnFunction(retVal);
		        } else {
		            dialogArguments["deptid"] = GetListRow[0].getAttribute("DATA2");
		            window.close();
		        }
		    }

		    function delete_onClick() {
		        if (ReturnFunction != null) {
		            retVal["recipientTDData"] = "delete";
		            ReturnFunction(retVal);
		        } else {
		            dialogArguments["recipientTDData"] = "delete";
		            window.close();
		        }
		    }

		    function cancel_onClick() {
		        if (ReturnFunction != null) {
		            retVal["recipientTDData"] = "dontprocess";
		            ReturnFunction(retVal);
		        } else {
		            dialogArguments["recipientTDData"] = "dontprocess";
		            window.close();
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display:none">
  			<LISTVIEWDATA>
    			<HEADERS>
      				<HEADER>
        				<NAME><spring:message code="ezResource.t165"/></NAME>
        				<WIDTH>100</WIDTH>
      				</HEADER>
      				<HEADER>
        				<NAME><spring:message code="ezResource.t135"/></NAME>
        				<WIDTH>100</WIDTH>
      				</HEADER>
      				<HEADER>
        				<NAME><spring:message code="ezResource.t166"/></NAME>
        				<WIDTH>100</WIDTH>
      				</HEADER>
    			</HEADERS>
  			</LISTVIEWDATA>
		</xml>
		
		<object style="display: none" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" id="ListViewBehave" height="0px" width="0px" viewastext/>
		
		<h1><spring:message code="ezResource.t13"/></h1>
		<h2><spring:message code="ezResource.t167"/></h2>

		<div id="ListView" style="behavior: url(#ListViewBehave#ListView); width: 570px; height: 200px; overflow-y:auto" onrowdblclick="change_onClick()"> </div>
		<div class="btnposition">
    		<a class="imgbtn" onClick="change_onClick()"><span><spring:message code="ezResource.t15"/></span></a>
    		<a class="imgbtn" onClick="cancel_onClick()"><span><spring:message code="ezResource.t16"/></span></a>
		</div>
	</body>
</html>