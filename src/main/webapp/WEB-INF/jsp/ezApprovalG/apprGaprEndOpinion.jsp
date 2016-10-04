<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t55'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var pDocID;
	        var pDisplay;
	        var OrderCell = "";
	        var Resultxml = createXmlDom();
	        var xmlhttp = createXMLHttpRequest();
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            };
	        }
	        var ReturnFunction;
	        var NonActiveX = "YES";
	        window.onload = function () {
	            try {
	                dialogArguments = parent.aprendopinion_dialogArgument[0];
	                ReturnFunction = parent.aprendopinion_dialogArgument[1];
	            } catch (e) {
	                try {
	                    dialogArguments = parent.aprendopinion_dialogArgument[0];
	                    ReturnFunction = parent.aprendopinion_dialogArgument[1];
	                } catch (e) {
	                }
	            }                            
	            pDocID = dialogArguments[0];
	            pDisplay = dialogArguments[1];
	
	            getEndOpinionInfo();
	            DisplayFirstOpinionInfo();
	
	            document.getElementById("txt_OpinionContent").readOnly = true;
	            document.getElementById("bbtn_OpinionAdd").style.display = "none";
	            document.getElementById("bbtn_OpinionDel").style.display = "none";
	
	            if (pDisplay == "Show") {
	                document.getElementById("bbtn_OpinionAdd").style.display = "none";
	                document.getElementById("bbtn_OpinionDel").style.display = "none";
	            }
	            if (!CrossYN() && NonActiveX == "NO")
	                window.returnValue = "cancel";
	        };
	        function DisplayFirstOpinionInfo() {
	            var listview = new ListView();
	            listview.LoadFromID("optionForm");
	            var TotRow = listview.GetDataRows();
	            var TotRowLen = listview.GetRowCount();
	
	            if (TotRow[0].id.indexOf("noItems") == -1) {
	                document.getElementById("txt_OpinionContent").value = TotRow[0].getAttribute("DATA3");
	            }
	        }
	        function getEndOpinionInfo() {
	            document.getElementById("OPINION").innerText = "";
	            
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "xml",
		    		async : false,
		    		url : "/ezApprovalG/getEndOpinionInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}
		    	});
		    	
	            Resultxml = result;
	            var listview = new ListView();
	            listview.SetID("optionForm");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnClick("OPINIONOnSelChange_onclick");
	            listview.DataSource(Resultxml);
	            listview.DataBind("OPINION");
	        }
	        function btn_OpinionCancel_onclick() {
	            if (ReturnFunction != null)
	            {
	                ReturnFunction("OK");
	            }
	            else
	            {
	                window.returnValue = "cancel";
	                window.close();
	            }
	        }
	        function btn_OpinionSave_onclick() {
	            if (ReturnFunction != null) {
	                ReturnFunction("OK");
	            }
	            else {
	                window.close();
	            }
	        }
	        function OPINIONOnSelChange_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("optionForm");
	            var Selcur = listview.GetSelectedRows();
	            if (Selcur != null) {
	                document.getElementById("txt_OpinionContent").value = GetAttribute(Selcur[0], "DATA3");
	            }
	        }
	        function txt_OpinionContent_onfocus() {
	            if (pDisplay == "Show") {
	                document.getElementById("btn_OpinionCancel").focus();
	                document.getElementById("txt_OpinionContent").blur();
	            }
	        }
	        function txt_OpinionContent_onchange() { }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t55'/></h1>
	    <div class="listview">
	        <div id="OPINION" style="border: 0; Height: 190px;" onselchanged="OPINIONOnSelChange_onclick()"></div>
	    </div>
	
	    <h2 style="margin-top:10px;margin-bottom:3px" ><spring:message code='ezApprovalG.t423'/></h2>
	
	    <textarea id="txt_OpinionContent" name="txt_OpinionContent" class="textarea" style="width: 498px; Height: 150px;" onfocus="return txt_OpinionContent_onfocus()" onchange="return txt_OpinionContent_onchange()"></textarea>
	
	  	<div class="btnposition">
	      <a class="imgbtn" id="bbtn_OpinionAdd" ><span id="btn_OpinionAdd" onClick="return btn_OpinionAdd_onclick()" ><spring:message code='ezApprovalG.t268'/></span></a>
	      <a class="imgbtn" id="bbtn_OpinionDel"><span id="btn_OpinionDel" onClick="return btn_OpinionDel_onclick()" ><spring:message code='ezApprovalG.t266'/></span></a>
	      <a class="imgbtn" id="bbtn_OpinionCancel"><span id="btn_OpinionCancel" onClick="return btn_OpinionCancel_onclick()"><spring:message code='ezApprovalG.t64'/></span></a>
		</div>
	</body>
</html>