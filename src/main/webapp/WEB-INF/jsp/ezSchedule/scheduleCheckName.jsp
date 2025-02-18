<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>        
        <script type="text/javascript" src="${util.addVer('/js/ezSchedule/ListView_list.js')}"></script>
		<title><spring:message code='ezSchedule.t53'/></title>
		<script>
			var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            RetValue = parent.checkname_cross_dialogArguments[0];
		            ReturnFunction = parent.checkname_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.checkname_cross_dialogArguments[0];
		                ReturnFunction = opener.checkname_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
	
		        var listview = new ListView();
		        listview.SetID("DLList");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
		        listview.DataSource(loadXMLString(document.getElementById("listviewheader").innerHTML.toUpperCase()));
		        listview.DataBind("ListViewid");
		        listview.RowDataBind("")
	
		        initializeReceiverList();
		    }
	
		    function initializeReceiverList() {
		        var listview = new ListView();
		        listview.SetID("DLList");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
		        listview.DataSource(RetValue["addrBook"]);
		        listview.RowDataBind();
		    }
	
		    function change_onClick() {
		        var count1;
		        var selectedItemCount;
		        var selRow;
	
		        var pListViewDL = new ListView();
		        pListViewDL.LoadFromID("DLList");
	
		        var arrRows = pListViewDL.GetSelectedRows();
		        selectedItemCount = arrRows.length;
	
		        if (selectedItemCount == 0) {
		            alert("<spring:message code='ezSchedule.t54' />");
				    return;
				}
				else if (selectedItemCount > 1) {
				    alert("<spring:message code='ezSchedule.t55' />");
					    return;
					}
	
		        if (ReturnFunction != null) {
		            var returnvalue = new Array();
		            returnvalue["id"] = GetAttribute(arrRows[0], "DATA2");
		            returnvalue["name"] = getNodeText(arrRows[0].cells[3]);
		            returnvalue["deptname"] = GetAttribute(arrRows[0], "DATA7");
		            returnvalue["name1"] = GetAttribute(arrRows[0], "DATA5");
		            returnvalue["name2"] = GetAttribute(arrRows[0], "DATA6");
		            returnvalue["deptname2"] = GetAttribute(arrRows[0], "DATA8");
		            ReturnFunction(returnvalue);
		        }
		        else {
		            dialogArguments["id"] = GetAttribute(arrRows[0], "DATA2");
		            dialogArguments["name"] = getNodeText(arrRows[0].cells[3]);
		            dialogArguments["deptname"] = GetAttribute(arrRows[0], "DATA7");
		            dialogArguments["name1"] = GetAttribute(arrRows[0], "DATA5");
		            dialogArguments["name2"] = GetAttribute(arrRows[0], "DATA6");
		            dialogArguments["deptname2"] = GetAttribute(arrRows[0], "DATA8");
		            window.close();
		        }
		    }
	
		    function delete_onClick() {
		        if (ReturnFunction != null) {
		            var returnvalue = new Array();
		            returnvalue["recipientTDData"] = "delete";
		            ReturnFunction(returnvalue);
		            parent.DivPopUpHidden();
		        }
		        else {
		            dialogArguments["recipientTDData"] = "delete";
		            window.close();
		        }
		    }
	
		    function cancel_onClick() {
		        if (ReturnFunction != null) {
		            var returnvalue = new Array();
		            returnvalue["recipientTDData"] = "dontprocess";
		            returnvalue["name"] = "";
	
		            ReturnFunction(returnvalue);
		            parent.DivPopUpHidden();
		        }
		        else {
		            dialogArguments["recipientTDData"] = "dontprocess";
		            window.close();
		        }
		    }
		</script>
		<style>
			.mainlist tr th { border-top:0px }
		</style>
	</head>	
	<body class="popup"> 
	    <xml id="listviewheader" style="display: none"> 
	        <LISTVIEWDATA> 
	            <HEADERS> 
	                <HEADER> 
	                    <TYPE>NONE</TYPE> 
	                    <NAME><spring:message code='ezSchedule.t56' /></NAME> 
	                    <WIDTH>100</WIDTH> 
	                    <SORTABLE>TRUE</SORTABLE> 
	                    <RESIZIBLE>FALSE</RESIZIBLE> 
	                    <MINSIZE>10</MINSIZE> 
	                    <MAXSIZE>200</MAXSIZE> 
	                    <NOWRAP>TRUE</NOWRAP>
	                </HEADER> 
	                <HEADER> 
	                    <NAME><spring:message code='ezSchedule.t12' /></NAME> 
	                    <WIDTH>90</WIDTH>
	                </HEADER> 
	                <HEADER> 
	                    <NAME><spring:message code='ezSchedule.t57' /></NAME> 
	                    <WIDTH>50</WIDTH>
	                </HEADER> 
	                <HEADER> 
	                    <NAME><spring:message code='ezSchedule.t18' /></NAME> 
	                    <WIDTH>60</WIDTH>
	                </HEADER> 
	                <HEADER> 
	                    <NAME>EMAIL</NAME> 
	                    <WIDTH>200</WIDTH>
	                </HEADER>
	            </HEADERS>
	        </LISTVIEWDATA>
	    </xml>
		<h1><spring:message code='ezSchedule.t53' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel_onClick()"></span></li>
            </ul>
        </div>
		<h2><spring:message code='ezSchedule.t58' /></h2>
		<div class="listview" style="overflow:auto;">
			<div id="ListViewid" STYLE="Height:195px; border:0px;overflow:auto"></div>
		</div>
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" name="button2" onClick="change_onClick()" ><span><spring:message code='ezSchedule.t4' /></span></a>
		</div>
	</body>
</html>