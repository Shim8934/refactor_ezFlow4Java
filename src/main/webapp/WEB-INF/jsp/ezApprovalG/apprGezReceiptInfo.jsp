<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1217'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript">
		    var pDocID = "${docID}";
		    var listview = new ListView();
		    var OrderCell = "";
		    var NonActiveX = "YES";
		    var RtnVal = "";
		    window.onload = function () {
		        try {
		            $.ajax({
		        		type : "POST",
		        		dataType : "xml",
		        		async : false,
		        		url : "/ezApprovalG/getReceiptinfo.do",
		        		data : {
		        				docID : pDocID,
		        				mode  : "APR"
		        				},
		        		success: function(xml){
		        			 RtnVal = xml;
		        		}        			
		        	});
		            
		            listview.SetID("lvtAprLine");
		            listview.DataSource(RtnVal);
		            listview.DataBind("lvAprLine");
		        }
		        catch (e) {
		            alert("window_onload : " + e.description);
		        }
		    };
		    function OpenAlertUI(pAlertContent) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		    }
		    function window_close() {
		        if (CrossYN() || NonActiveX == "YES")
		            parent.DivPopUpHidden();
		        else
		            window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1217'/></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window_close()"><spring:message code='ezApprovalG.t64'/></span></li>
		  </ul>
		</div>
		<div class="listview">
		    <DIV id="lvAprLine" style="BORDER:0;WIDTH:auto; HEIGHT: 150px; overflow-x:hidden;overflow-y:auto"></DIV>
		</div>
					
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	
	</body>
</html>