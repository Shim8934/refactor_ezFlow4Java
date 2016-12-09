<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t650'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript">
	        var pDeptID = "${deptID}";
	        var pDeptNm = "${deptName}";
	        var pCompanyID = "${companyID}";
	        var xmlhttp = createXMLHttpRequest();
	        var listview = new ListView();
	        var pSelectedIndex = 0;
	        var status = "no";
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        window.onload = function () {
	            try {
	                document.getElementById("NM").innerHTML = pDeptNm + "(" + pDeptID + ")";
	                document.getElementById('lvAprLine').innerHTML = "";
	                listview.SetID("lvAprLineForm");
	                listview.SetMulSelectable(false);
	                listview.SetHeightFree(true);
	                getSpecialContList()
	            } catch (e) {
	                alert("window_onload : " + e.description);
	            }
	        }
	
	        var ezapralert_cross_dialogArgument = new Array();
	        function OpenAlertUI(pAlertContent) {
	            var parameter = pAlertContent;
	            var url = "/admin/ezApproval/ezAprAlert.do";
	            ezapralert_cross_dialogArgument[0] = parameter;
	            var result = GetOpenWindow(url, "ezAPRALERT_Cross", 330, 205, "NO");
	        }
	
	        function OpenInformationUI(pInformationContent) {
	            var parameter = pInformationContent;
	            var url = "/admin/ezApproval/ezAprOpinion.do";
	            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	
	            feature = feature + GetShowModalPosition(330, 205);
	            var RtnVal = window.showModalDialog(url, parameter, feature);
	            return RtnVal;
	        }
	
	        function getSpecialContList() {
	            document.getElementById('lvAprLine').innerHTML = "";
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/admin/ezApproval/specialContListInfo.do",
		    		data : {
		    			deptID : pDeptID,
		    			companyID  : pCompanyID
		    		},
		    		success: function(text){
		    			getSpecialContList_after(text);
		    		}
		    	});
	        }
	
	        function getSpecialContList_after(text) {
	            listview.LoadFromID("lvAprLineForm");
	            try {
	                var xmlRtn = loadXMLString(text);
	
	                if (xmlRtn.getElementsByTagName("ROW").length == 0) return;
	                listview.DataSource(loadXMLString(text));
	                listview.DataBind("lvAprLine");
	
	                if (status == "up")
	                    listview.SetSelectedIndex(pSelectedIndex - 1);
	
	                if (status == "down")
	                    listview.SetSelectedIndex(Number(pSelectedIndex) + 1);
	            }
	            catch (e) {
	                alert(e.description);
	            }
	        }
	
	        function lvAprLine_DBSelChange() {
	            btnEdit_onclick();
	        }
	
	        function lvAprLine_SelChange() {
	        }
	
	        var managespecialcontinfo_dialogArguments = new Array();
	        function btnAdd_onclick() {
	            managespecialcontinfo_dialogArguments[1] = btnAdd_onclick_complete;
	            var url = "manageSpecialContInfo.do?deptID=" + escape(pDeptID) + "&companyID=" + escape(pCompanyID) + "&contType=&sn=";
	            var result = GetOpenWindow(url, "ManageSpecialContInfo", 610, 545, "NO");
	        }
	        function btnAdd_onclick_complete(retVal) {
	            if (retVal == "OK")
	                getSpecialContList();
	        }
	
	        function btnEdit_onclick() {
	            listview.LoadFromID("lvAprLineForm");
	
	            var selnode = listview.GetSelectedRows();
	            if (selnode) {
	                var CONTTYPE = trim_Cross(GetAttribute(selnode[0], "DATA2"));
	                var SN = trim_Cross(GetAttribute(selnode[0], "DATA3"));
	                var url = "manageSpecialContInfo.do?deptID=" + escape(pDeptID) + "&companyID=" + escape(pCompanyID) + "&contType=" + escape(CONTTYPE) + "&sn=" + escape(SN);
	                managespecialcontinfo_dialogArguments[1] = btnEdit_onclick_Complete;
	                var result = GetOpenWindow(url, "ManageSpecialContInfo", 610, 545, "NO");
	            }
	            else {
	                OpenAlertUI("<spring:message code='ezApproval.t651'/>");
	            }
	        }
	        function btnEdit_onclick_Complete(retVal) {
	            if (retVal == "OK")
	                getSpecialContList();
	        }
	
	        function btnDel_onclick() {
	            listview.LoadFromID("lvAprLineForm");
	
	            var selnode = listview.GetSelectedRows();
	            var result = "";
	            
	            if (selnode) {
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezApproval/specialContDelete.do",
			    		data : {
			    			deptID     : pDeptID,
			    			sn         : GetAttribute(selnode[0], "DATA3"),
			    			contType   : GetAttribute(selnode[0], "DATA2"),
			    			companyID  : pCompanyID
			    		},
			    		success: function(text){
			    			result = text;
			    		}
			    	});
	
	                if (result.indexOf("TRUE") > -1)
	                    getSpecialContList();
	                else
	                    OpenAlertUI("<spring:message code='ezApproval.t652'/>");
	            }
	            else {
	                OpenAlertUI("<spring:message code='ezApproval.t653'/>");
	            }
	        }
	
	        function btnUp_onclick() {
	            try {
	                listview.LoadFromID("lvAprLineForm");
	
	                var selnode = listview.GetSelectedRows();
	                if (selnode) {
	                    var pTotalRows = listview.GetDataRows();
	                    pSelectedIndex = listview.GetSelectedIndexes();
	                    var NIndex = pSelectedIndex - 1;
	                    var CIndex = pSelectedIndex;
	
	                    if (NIndex >= 0) {
	                        if (trim_Cross(GetAttribute(selnode[0], "DATA2")) == trim_Cross(GetAttribute(pTotalRows[NIndex], "DATA2"))) {
	                            var rtnVal = ChangeSN(trim_Cross(GetAttribute(selnode[0], "DATA2")), trim_Cross(GetAttribute(selnode[0], "DATA3")), trim_Cross(GetAttribute(pTotalRows[NIndex], "DATA2")), trim_Cross(GetAttribute(pTotalRows[NIndex], "DATA3")));
	                            if (rtnVal.indexOf("TRUE") > -1) {
	                                status = "up";
	                                getSpecialContList();
	                            }
	                            else {
	                                OpenAlertUI("<spring:message code='ezApproval.t654'/>");
	                            }
	                        }
	                        else {
	                            OpenAlertUI("<spring:message code='ezApproval.t655'/>");
	                        }
	                    }
	                    else {
	                        OpenAlertUI("<spring:message code='ezApproval.t656'/>");
	                    }
	                }
	                else {
	                    OpenAlertUI("<spring:message code='ezApproval.t657'/>");
	                }
	            } catch (e) {
	                OpenAlertUI("<spring:message code='ezApproval.t657'/>");
	            }
	        }
	
	        function btnDown_onclick() {
	            try {
	                listview.LoadFromID("lvAprLineForm");
	
	                var selnode = listview.GetSelectedRows();
	                if (selnode) {
	                    var pTotalRows = listview.GetDataRows();
	                    pSelectedIndex = listview.GetSelectedIndexes();
	                    var NIndex = Number(pSelectedIndex) + 1;
	                    var CIndex = pSelectedIndex;
	                    if (NIndex >= 0) {
	                        if (trim_Cross(GetAttribute(selnode[0], "DATA2")) == trim_Cross(GetAttribute(pTotalRows[NIndex], "DATA2"))) {
	
	                            var rtnVal = ChangeSN(trim_Cross(GetAttribute(selnode[0], "DATA2")), trim_Cross(GetAttribute(selnode[0], "DATA3")), trim_Cross(GetAttribute(pTotalRows[NIndex], "DATA2")), trim_Cross(GetAttribute(pTotalRows[NIndex], "DATA3")));
	                            if (rtnVal.indexOf("TRUE") > -1) {
	                                status = "down";
	                                getSpecialContList();
	                            }
	                            else {
	                                OpenAlertUI("<spring:message code='ezApproval.t654'/>");
	                            }
	                        }
	                        else {
	                            OpenAlertUI("<spring:message code='ezApproval.t655'/>");
	                        }
	                    }
	                    else {
	                        OpenAlertUI("<spring:message code='ezApproval.t658'/>");
	                    }
	                }
	                else {
	                    OpenAlertUI("<spring:message code='ezApproval.t657'/>");
	                }
	            } catch (e) {
	                OpenAlertUI("<spring:message code='ezApproval.t658'/>");
	            }
	        }
	
	        function ChangeSN(SContType, SSN, TContType, TSN) {
	        	var result = "";
	        	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/specialContChangeSN.do",
		    		data : {
		    			deptID     : pDeptID,
		    			sn         : SSN,
		    			contType   : SContType,
		    			sn2        : TSN,
		    			contType2  : TContType,
		    			companyID  : pCompanyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
	            return result;
	        }
	
	    </script>
	</head>
	<body class="popup">
	    <h1 id="NM"><spring:message code='ezApproval.t650'/></h1>
	    <div class="listview" style="BORDER: 1; WIDTH: 510px; HEIGHT: 140px; overflow: auto">
	        <div id="lvAprLine" style="BORDER: 0;">
	        </div>
	    </div>
	    <div class="btnposition">
	        <a class="imgbtn" onclick="btnAdd_onclick()"><span><spring:message code='ezApproval.t193'/></span></a>
	        <a class="imgbtn" onclick="btnEdit_onclick()"><span><spring:message code='ezApproval.t274'/></span></a>
	        <a class="imgbtn" onclick="btnDel_onclick()"><span><spring:message code='ezApproval.t194'/></span></a>
	        <a class="imgbtn" onclick="btnUp_onclick()"><span><spring:message code='ezApproval.t659'/></span></a>
	        <a class="imgbtn" onclick="btnDown_onclick()"><span><spring:message code='ezApproval.t660'/></span></a>
	    </div>
	</body>
</html>