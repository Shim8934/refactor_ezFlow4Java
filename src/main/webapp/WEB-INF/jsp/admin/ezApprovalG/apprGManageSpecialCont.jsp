<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t650'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/control_Cross/ListView_list.js')}" ></script>
	    <script type="text/javascript">
	        var pDeptID = "<c:out value='${deptID}'/>";
	        var pDeptNm = "<c:out value='${deptName}'/>";
	        var pCompanyID = "<c:out value='${companyID}'/>";
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
	
	        var ezapralert_cross_dialogArguments = new Array();
	        function OpenAlertUI(pAlertContent) {
	            var parameter = pAlertContent;
	            var url = "/ezApprovalG/ezAprAlert.do";
	            ezapralert_cross_dialogArguments[0] = parameter;
	            var result = GetOpenWindow(url, "ezAPRALERT_Cross", 330, 205, "NO");
	        }
	
	        function OpenInformationUI(pInformationContent) {
	            var parameter = pInformationContent;
	            var url = "/ezApprovalG/ezAprOpinion.do";
	            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	
	            feature = feature + GetShowModalPosition(330, 205);
	            var RtnVal = window.showModalDialog(url, parameter, feature);
	            return RtnVal;
	        }
	
	        function getSpecialContList() {
	            document.getElementById('lvAprLine').innerHTML = "";
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : true,
		    		url : "/admin/ezApprovalG/specialContListInfo.do",
		    		data : {
		    			deptID : pDeptID,
		    			companyID  : pCompanyID
		    		},
		    		success: function(result){
		    			getSpecialContList_after(result.resultXML);
		    		}
		    	});
	        }
	
	        function getSpecialContList_after(result) {
	            listview.LoadFromID("lvAprLineForm");

                var xmlRtn = loadXMLString(result);

                if (xmlRtn.getElementsByTagName("ROW").length == 0) return;
                listview.DataSource(xmlRtn);
                listview.DataBind("lvAprLine");

                if (status == "up")
                    listview.SetSelectedIndex(pSelectedIndex - 1);

                if (status == "down")
                    listview.SetSelectedIndex(Number(pSelectedIndex) + 1);
	        }
	
	        function lvAprLine_DBSelChange() {
	            btnEdit_onclick();
	        }
	
	        function lvAprLine_SelChange() {
	        }
	
	        var managespecialcontinfo_dialogArguments = new Array();
	        function btnAdd_onclick() {
	            managespecialcontinfo_dialogArguments[1] = btnAdd_onclick_complete;
	            var url = "/admin/ezApprovalG/manageSpecialContInfo.do?deptID=" + encodeURIComponent(pDeptID) + "&companyID=" + encodeURIComponent(pCompanyID) + "&contType=&sn=";
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
	                var url = "/admin/ezApprovalG/manageSpecialContInfo.do?deptID=" + encodeURIComponent(pDeptID) + "&companyID=" + encodeURIComponent(pCompanyID) + "&contType=" + encodeURIComponent(CONTTYPE) + "&sn=" + encodeURIComponent(SN);
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
	            var resultVal = "";
	            
	            if (selnode) {
			    	$.ajax({
			    		type : "POST",
			    		dataType : "json",
			    		async : false,
			    		url : "/admin/ezApprovalG/specialContDelete.do",
			    		data : {
			    			deptID     : pDeptID,
			    			sn         : GetAttribute(selnode[0], "DATA3"),
			    			contType   : GetAttribute(selnode[0], "DATA2"),
			    			companyID  : pCompanyID
			    		},
			    		success: function(result){
			    			resultVal = result.result;
			    		}
			    	});
	
	                if (resultVal.indexOf("TRUE") > -1) {
	                    getSpecialContList();
	                } else {
	                    OpenAlertUI("<spring:message code='ezApprovalG.t280'/>");
	                }
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
	        	var resultVal = "";
	        	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/admin/ezApprovalG/specialContChangeSN.do",
		    		data : {
		    			deptID     : pDeptID,
		    			sn         : SSN,
		    			contType   : SContType,
		    			sn2        : TSN,
		    			contType2  : TContType,
		    			companyID  : pCompanyID
		    		},
		    		success: function(result){
		    			resultVal = result.result;
		    		}
		    	});
		    	
	            return resultVal;
	        }
	
	    </script>
	</head>
	<body class="popup">
	    <h1 id="NM"><spring:message code='ezApproval.t650'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <div class="listview" style="BORDER: 1; WIDTH: 510px; HEIGHT: 140px; overflow: auto">
	        <div id="lvAprLine" style="BORDER: 0;">
	        </div>
	    </div>
	    <div class="btnposition">
	        <a class="imgbtn" onclick="btnAdd_onclick()"><span><spring:message code='ezApprovalG.t268'/></span></a>
	        <a class="imgbtn" onclick="btnEdit_onclick()"><span><spring:message code='ezApprovalG.t269'/></span></a>
	        <a class="imgbtn" onclick="btnDel_onclick()"><span><spring:message code='ezApprovalG.t266'/></span></a>
	        <a class="imgbtn" onclick="btnUp_onclick()"><span><spring:message code='ezApprovalG.t403'/></span></a>
	        <a class="imgbtn" onclick="btnDown_onclick()"><span><spring:message code='ezApprovalG.t404'/></span></a>
	    </div>
	</body>
</html>