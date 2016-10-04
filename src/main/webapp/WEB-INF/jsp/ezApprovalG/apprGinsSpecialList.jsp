<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1025'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SpecialList_Cross.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var OrderCell = "";
		    var rtnVal = new Array();
		    var RetValue;
		    var ReturnFunction;
		    window.onbeforeunload = onunload;
		    window.onload = function () {
		        try {
		            RetValue = parent.AddSpecialCatalog_Cross_dialogArguments[0];
		            ReturnFunction = parent.AddSpecialCatalog_Cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.AddSpecialCatalog_Cross_dialogArguments[0];
		                ReturnFunction = opener.AddSpecialCatalog_Cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        var szSCListXml = RetValue[0];
		        g_arrSCInfo[0] = RetValue[1];
		        g_arrSCInfo[1] = RetValue[2];
		        g_arrSCInfo[2] = RetValue[3];
		        InitSCInputBox();
		        InitSCList(szSCListXml);
		        rtnVal[0] = "FALSE";
		    };
		    function InitSCList(szSCListXml) {
		        if (szSCListXml != "") {
		            oList = createXmlDom();
		            oList = loadXMLString(szSCListXml);
		            var SpecialListView = new ListView();
		            SpecialListView.SetID("SpecialListdiv");
		            SpecialListView.SetMulSelectable(false);
		            SpecialListView.SetRowOnDblClick("");
		            SpecialListView.DataSource(oList);
		            SpecialListView.DataBind("SpecialList");
		        }
		        else {
		            InitSpecialList();
		        }
		    }
		    function btnAddSCList_onclick() {
		        if (document.getElementById("txtSpecial1").value == "" && document.getElementById("txtSpecial2").value == "" && document.getElementById("txtSpecial3").value == "") {
		            alert("<spring:message code='ezApprovalG.t1035'/>");
		        }
		        else if (document.getElementById("txtSpecial1").value.value == "") {
		            alert("<spring:message code='ezApprovalG.t589'/>");
		        }
		        else if (document.getElementById("txtSpecial2").value == "" && txtSpecial3.value != "") {
		            alert("<spring:message code='ezApprovalG.t590'/>");
		        }
		        else {
		            InsertSpecialList(document.getElementById("txtSpecial1").value, document.getElementById("txtSpecial2").value, document.getElementById("txtSpecial3").value);
		            btnReset_onclick();
		        }
		    }
		    function btnDelSCList_onclick() {
		        DelRowOfSpecialList();
		    }
		    function btnReset_onclick() {
		        document.getElementById("txtSpecial1").value = "";
		        document.getElementById("txtSpecial2").value = "";
		        document.getElementById("txtSpecial3").value = "";
		    }
		    function btnOK_onclick() {
		        var szRtnVal = GetSCListXml();
		        if (szRtnVal == "") {
		            alert("<spring:message code='ezApprovalG.t1036'/>");
		        }
		        else {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = szRtnVal;
		            ReturnFunction(rtnVal);
		            window.close();
		        }
		    }
		    function btnClose_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		            window.close();
		        }
		        else
		            window.close();
		    }
		    function onunload() {
		        window.returnValue = rtnVal;
		    }
		</script>
	</head>
	<body class="popup" style="margin-left:0px;margin-top:0px;">
		<h1><spring:message code='ezApprovalG.t1025'/></h1>
		<table class="content">   
		  <tr id="trSC1" >           
		    <th   id="tdSC1Title" >&nbsp;</th>
		    <td  > 
		      <input type="text"  style="width:100%" name="txtSpecial1" id="txtSpecial1">       
		    </td>
		  </tr>        
		  <tr id="trSC2" style="Display:none"  >           
		    <th   id="tdSC2Title">&nbsp;</th>
		    <td > 
		      <input type="text"  style="width:100%" name="txtSpecial2" id="txtSpecial2">       
		    </td>
		  </tr>        
		  <tr id="trSC3" style="Display:none"  >           
		    <th   id="tdSC3Title">&nbsp;</th>
		    <td> 
		      <input type="text"  style="width:100%" name="txtSpecial3" id="txtSpecial3">       
		    </td>
		  </tr>   
		  <tr  > 
		    <th colspan="2" style="text-align:right"> 
		      <a class="imgbtn"><span id="btnAdd" onClick="return btnAddSCList_onclick()" ><spring:message code='ezApprovalG.t268'/></span></a>
		      <a class="imgbtn"><span id="btnDel" onClick="return btnDelSCList_onclick()" ><spring:message code='ezApprovalG.t266'/></span></a>
		     </th>
		  </tr>      
		</table>
		<br />
		<h2><spring:message code='ezApprovalG.t94'/></h2>
		<div class="listview" >
			<div id="SpecialList" style="BACKGROUND-COLOR: #ffffff;border:0px solid #B6B6B6;HEIGHT: 120px; WIDTH: 100%; overflow:auto;margin-left:2px;margin-top:1px;margin-right:1px;margin-bottom:1px;">
			</div>
		</div>
		<div class="btnposition" >
		      <a class="imgbtn"><span id="btnOK" onClick="return btnOK_onclick()" ><spring:message code='ezApprovalG.t20'/></span></a>
		      <a class="imgbtn"><span id="btnCancel" onClick="return btnClose_onclick()" ><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
	</body>
</html>