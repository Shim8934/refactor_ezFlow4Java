<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t100002'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/ListView_list.js')}"></script>
		<script language="javascript" type="text/javascript">
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            if (isParentCommonArgsUsed()) {
						RetValue = parent.ezCommon_cross_dialogArguments[0];
						ReturnFunction = parent.ezCommon_cross_dialogArguments[1];
					} else {
						RetValue = parent.checkname2_cross_dialogArguments[0];
						ReturnFunction = parent.checkname2_cross_dialogArguments[1];
					}
		        } catch (e) {
		            try {
		                RetValue = opener.checkname2_cross_dialogArguments[0];
		                ReturnFunction = opener.checkname2_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        var listview = new ListView();
		        listview.SetID("ListView1");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
		        listview.DataSource(loadXMLString(listviewheader.innerHTML.toUpperCase()));
		        listview.DataBind("ListViewItem");
		        listview.DataSource(RetValue["addrBook"]);
		        listview.RowDataBind();
		    }
		    function change_onClick() {
		        
		        var listview = new ListView();
		        listview.LoadFromID("ListView1");
		        var count1;
		        var selecteditemcount = listview.GetSelectedRows().length;
		        var selrow;
		        if (selecteditemcount == 0) {
		            showAlert("<spring:message code='ezPersonal.t207'/>");
		            return;
		        }
		        else if (selecteditemcount > 1) {
		            showAlert("<spring:message code='ezPersonal.t208'/>");
		            return;
		        }
		        
		        if (ReturnFunction != null) {
		            if (window.ActiveXObject)
		                RetValue["deptid"] = RetValue["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].textContent;
		            else
		                RetValue["deptid"] = RetValue["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].textContent;
		            ReturnFunction(RetValue);
		        }
		        else {
		            dialogArguments["deptid"] = RetValue["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].textContent;
		        }
		
		        window.close();
		    }
		
		    function delete_onClick() {
		        if (ReturnFunction != null) {
		            RetValue["recipientTDData"] = "delete";
		            ReturnFunction(RetValue);
		        }
		        else {
		            dialogArguments["recipientTDData"] = "delete";
		        }
		
		        window.close();
		    }
		    function cancel_onClick() {
		        if (ReturnFunction != null) {
		            RetValue["recipientTDData"] = "dontprocess";
		            ReturnFunction(RetValue);
		        }
		        else {
		            dialogArguments["recipientTDData"] = "dontprocess";
		        }
		
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display:none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t6'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezOrgan.t70'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t209'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<!-- <object style="display:none" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" id="ListViewBehave" height="0px" width="0px" VIEWASTEXT>
		</object> -->
		<h1><spring:message code='ezPersonal.t100002'/></h1>
		<div id="close">
			<ul>
		    	<li><span onClick="cancel_onClick()"></span></li>
		  	</ul>
		</div>
		<span>▒ <spring:message code='ezPersonal.t100003'/></span>
		<div class="listview" style="overflow-x:hidden;overflow-y:auto;">
			<div id="ListViewItem" style="Width:587px; Height:185px; border:0px;overflow:auto;" ></div>
		</div>
		<div class="btnpositionNew">
		    <a class="imgbtn" onClick="change_onClick()"><span><spring:message code='ezPersonal.t12'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
