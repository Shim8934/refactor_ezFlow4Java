<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezStatistics.t1013'/></title>
		<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.mainlist tr th {
				border-top:0px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezStatistics/control_Cross/ListView_list.js')}"></script>
		<script language="javascript" type="text/javascript">
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var ReturnFunction;
		    var RgParams;
		    
		    window.onload = function () {
		    	 try {
		    		RgParams = opener.searchdept_cross_dialogArguments[0];
			       	ReturnFunction = opener.searchdept_cross_dialogArguments[1];			       	
			    } catch (e) { }
			        
		        var listview = new ListView();
		        listview.SetID("ListView1");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
		        listview.DataSource(listviewheader);
		        listview.DataBind("ListViewItem");
		        
		        if (CrossYN()) {
		        	listview.DataSource(RgParams["addrBook"]);
		        } else { 
		        	listview.DataSource(dialogArguments["addrBook"]);
		        }
		        listview.RowDataBind();
		    }
		    
		    window.onunload = function () {
		        if (ReturnFunction != null)
		            ReturnFunction(deptid);
		    }
		    
		    var deptid = "";
		    function change_onClick() {
		        var listview = new ListView();
		        listview.LoadFromID("ListView1");
		 //       var count1;
		        var selecteditemcount = listview.GetSelectedRows().length;
		  //      var selrow;
		        if (selecteditemcount == 0) {
		            alert("<spring:message code='ezOrgan.t106' />");
		            return;
		        }
		        else if (selecteditemcount > 1) {
		            alert("<spring:message code='ezOrgan.t107' />");
		            return;
		        }
		        if (browserIE) {
		            dialogArguments["deptid"] = dialogArguments["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].text;
		        } else {
		        	deptid = RgParams["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].textContent;
		        }
		        window.close();
		    }
		    
		    function delete_onClick() {
		   		if (CrossYN()) {
		   			RgParams["recipientTDData"] = "delete";
		   		} else {
		        	dialogArguments["recipientTDData"] = "delete";
		    	 }
		        window.close();
		    }
		    function cancel_onClick() {
		    	if (CrossYN()) {
		   			RgParams["recipientTDData"] = "dontprocess";
		   		} else {
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
		        <NAME><spring:message code='main.t74' /></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='main.t75' /></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezOrgan.t71' /></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezPersonal.t100002' /></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="cancel_onClick()"></span></li>
		  </ul>
		</div>
		<h2><spring:message code='ezOrgan.t109' /></h2>
		<div class="listview">
		  <div id="ListViewItem" style="width:100%; min-width:587px; Height:210px; border:0px;overflow:auto" ></div>
		</div>
		<div class="btnpositionNew">
		    <a class="imgbtn" onClick="change_onClick()"><span><spring:message code='ezResource.t15' /></span></a>
		</div>
	</body>
</html>


