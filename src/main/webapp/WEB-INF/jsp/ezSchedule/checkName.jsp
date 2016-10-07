<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/ezemail/js_cross/ListView_list.js"></script>
		<title><spring:message code='ezSchedule.t53'/></title>
		<script language="javascript">
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
		            alert("<spring:message code='ezSchedule.t54'/>");
				    return;
				}
				else if (selectedItemCount > 1) {
				    alert("<spring:message code='ezSchedule.t55'/>");
					    return;
					}
		
		        if (ReturnFunction != null) {
		            var returnvalue = new Array();
		            returnvalue["id"] = arrRows[0].getAttribute("DATA2");
		            returnvalue["name"] = arrRows[0].cells[3].innerText;
		            returnvalue["deptname"] = arrRows[0].getAttribute("DATA7");
		            returnvalue["name1"] = arrRows[0].getAttribute("DATA5");
		            returnvalue["name2"] = arrRows[0].getAttribute("DATA6");
		            returnvalue["deptname2"] = arrRows[0].getAttribute("DATA8");
		            ReturnFunction(returnvalue);
		        }
		        else {
		            dialogArguments["id"] = arrRows[0].getAttribute("DATA2");
		            dialogArguments["name"] = arrRows[0].cells[3].innerText;
		            dialogArguments["deptname"] = arrRows[0].getAttribute("DATA7");
		            dialogArguments["name1"] = arrRows[0].getAttribute("DATA5");
		            dialogArguments["name2"] = arrRows[0].getAttribute("DATA6");
		            dialogArguments["deptname2"] = arrRows[0].getAttribute("DATA8");
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
	</head>
	
	<body class="popup"> 
		<xml id="listviewheader" style ="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		        	<HEADER>
		        		<TYPE>NONE</TYPE>
		        		<NAME><spring:message code="ezBoard.t608" /></NAME>
		        		<WIDTH>20</WIDTH>
		        		<SORTABLE>TRUE</SORTABLE>
		        		<RESIZIBLE>TRUE</RESIZIBLE>
		        		<MINSIZE>10</MINSIZE>
		        		<MAXSIZE>100</MAXSIZE>
		        		<NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
		
		<xml id="listviewheader" style="display:none"> 
			<LISTVIEWDATA> 
				<HEADERS> 
					<HEADER> 
						<TYPE>NONE</TYPE> 
						<NAME><spring:message code='ezSchedule.t56'/></NAME> 
						<WIDTH>100</WIDTH> 
						<SORTABLE>TRUE</SORTABLE> 
						<RESIZIBLE>FALSE</RESIZIBLE> 
						<MINSIZE>10</MINSIZE> 
						<MAXSIZE>200</MAXSIZE> 
						<NOWRAP>TRUE</NOWRAP> 
					</HEADER> 
					<HEADER> 
						<NAME><spring:message code='ezSchedule.t12'/></NAME> 
						<WIDTH>100</WIDTH> 
					</HEADER> 
					<HEADER> 
						<NAME><spring:message code='ezSchedule.t57'/></NAME> 
						<WIDTH>100</WIDTH> 
					</HEADER> 
					<HEADER> 
						<NAME><spring:message code='ezSchedule.t18'/></NAME> 
						<WIDTH>70</WIDTH> 
					</HEADER> 
					<HEADER> 
						<NAME>E-MAIL</NAME> 
						<WIDTH>200</WIDTH> 
					</HEADER> 
				</HEADERS> 
			</LISTVIEWDATA> 
		</xml> 
		
		<object style="display:none" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" id="ListViewBehave" height="0px" width="0px" VIEWASTEXT> </object> 
		<h1><spring:message code='ezSchedule.t53'/></h1>
		<h2><spring:message code='ezSchedule.t58'/></h2>
		<div class="listview" style="overflow:auto;"><%--<div id="ListView" STYLE="BEHAVIOR: url(#ListViewBehave#ListView); Width:570px; Height:195px; border:0px" onRowDblClick="change_onClick()"></div>--%>
		<div id="ListViewid" STYLE="Width:570px; Height:195px; border:0px;overflow:auto"></div>
		</div>
		<div class="btnposition">
		    <a class="imgbtn" name="button2" onClick="change_onClick()" ><span><spring:message code='ezSchedule.t4'/></span></a>
		    <a class="imgbtn" name="button3" onClick="cancel_onClick()" ><span><spring:message code='ezSchedule.t5'/></span></a>
		</div>
	</body>
</html>