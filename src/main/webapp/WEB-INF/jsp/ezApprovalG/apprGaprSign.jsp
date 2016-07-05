<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t435'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/ezApprovalG/AprSign_Cross.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ImageView.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var OrderCell = "";
		    var pUserID;
		    var BaseURL;
		    var pDeptID = "${userInfo.deptID}";
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        var pSingFlag = true;
		
		        try {
		            RetValue = parent.aprsign1_cross_dialogArguments[0];
		            ReturnFunction = parent.aprsign1_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.aprsign1_cross_dialogArguments[0];
		                ReturnFunction = opener.aprsign1_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        pUserID = RetValue;
		        if (pUserID == "seal") {
		            window.document.title = "<spring:message code='ezApprovalG.t436'/>";
		            btn_Save.style.display = "none";
		        }
		        GetImageXml(pUserID, pDeptID);
		        if ("${userInfoApprovalG}" == "BOTH")
		            BaseURL = "/upload_Approval/signimgs/" + "${userInfo.id}/";
		        else
		            BaseURL = "/upload_ApprovalG/signimgs/" + "${userInfo.id}/";
		        var listview = new ListView();
		        listview.LoadFromID("listSIGNLIST");
		        var pCurSelRow = listview.GetDataRows();
		        if (pCurSelRow) {
		            if (listview.GetDataRows().length > 0) {
		                var pSignSelcur = listview.GetDataRows()[0];
		                listview.SetSelectedIndex(0);
		                if (pSignSelcur != null && trim_Cross(pSignSelcur.getAttribute("DATA1")) != "NAME") {
		                    var tempImg = document.createElement("img");
		                    tempImg.style.width = document.getElementById("SIGNVIEW").style.width;
		                    tempImg.style.height = document.getElementById("SIGNVIEW").style.height;
		                    tempImg.setAttribute("width", document.getElementById("SIGNVIEW").style.width);
		                    tempImg.setAttribute("height", document.getElementById("SIGNVIEW").style.height);
		                    tempImg.src = "/ezApprovalG/approvalGSign.do?fileName=" + pSignSelcur.getAttribute("DATA1");
		                    document.getElementById("SIGNVIEW").appendChild(tempImg);
		                }
		            }
		        }
		    };
		    function btn_ImageSave_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("listSIGNLIST");
		        var AprSign = listview.GetSelectedRows();
		        if (AprSign.length != 0) {
		            if (trim_Cross(AprSign[0].getAttribute("DATA1")) == "NAME") {
		                if (ReturnFunction != null) {
		                    ReturnFunction(AprSign[0].getAttribute("DATA1"));
		                }
		                else {
		                    parent.window.returnValue = AprSign[0].getAttribute("DATA1");
		                }
		            }
		            else {
		                var AprSignName = AprSign[0].cells[0].innerText;
		                var AprSignURL = AprSign[0].getAttribute("DATA1");
		                var AprSignInfo = BaseURL + AprSignURL;
		
		                if (ReturnFunction != null) {
		                    ReturnFunction(AprSignInfo);
		                }
		                else {
		                    window.returnValue = AprSignInfo;
		                    parent.window.close();
		                }
		            }
		        }
		        else if (trim_Cross(AprSign[0].getAttribute("DATA1")) == "NAME") {
		            if (ReturnFunction != null) {
		                ReturnFunction(AprSign[0].getAttribute("DATA1"));
		            }
		            else {
		                window.returnValue = AprSign[0].getAttribute("DATA1");
		                parent.window.close();
		            }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t437'/>");
		        }
		    }
		    function btn_ImageCancel_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction("cancel");
		        }
		        else {
		            window.returnValue = "cancel";
		            window.close();
		        }
		    }
		    function btn_Save_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction("NAME");
		        }
		        else {
		            window.returnValue = "NAME";
		            window.close();
		        }
		    }
		    function SIGNLIST_onfocus() {
		        document.getElementById("SIGNVIEW").innerHTML = "";
		        var listview = new ListView();
		        listview.LoadFromID("listSIGNLIST");
		        var pSignSelcur = listview.GetSelectedRows()[0];
		        if (pSignSelcur != null && trim_Cross(pSignSelcur.getAttribute("DATA1")) != "NAME") {
		            var tempImg = document.createElement("img");
		            tempImg.style.width = document.getElementById("SIGNVIEW").style.width;
		            tempImg.style.height = document.getElementById("SIGNVIEW").style.height;
		            tempImg.setAttribute("width", document.getElementById("SIGNVIEW").style.width);
		            tempImg.setAttribute("height", document.getElementById("SIGNVIEW").style.height);
		            tempImg.src = "/ezApprovalG/approvalGSign.do?fileName=" + pSignSelcur.getAttribute("DATA1");
		            document.getElementById("SIGNVIEW").appendChild(tempImg);
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t435'/></h1>		
		<table> 
		  <tr> 
		    <td><div class="listview" >
		            <div id="SIGNLIST"  style="BORDER:0;WIDTH:150px;HEIGHT:160px;overflow:auto;margin:1px 1px 1px 1px;"></div>
				</div>
			  </td> 
		    <td> <div id="SIGNVIEW" class="IMAGEVIEW" style="background-color:white; margin-left:5px; BORDER:#b6b6b6 1px solid; WIDTH:150px; HEIGHT:160px; overflow:hidden;"></div></td> 
		  </tr> 
		</table> 
		
		<div class="btnposition">
		        <a class="imgbtn" id="btn_ImageSave" onClick="return btn_ImageSave_onclick()"><span><spring:message code='ezApprovalG.t413'/></span></a>
		        <a class="imgbtn" id="btn_Save" onClick="return btn_Save_onclick()"><span><spring:message code='ezApprovalG.t438'/></span></a>
		        <a class="imgbtn" id="ImageCancel" onClick="return btn_ImageCancel_onclick()"><span><spring:message code='ezApprovalG.t414'/></span></a>
		</div>
	</body>
</html>