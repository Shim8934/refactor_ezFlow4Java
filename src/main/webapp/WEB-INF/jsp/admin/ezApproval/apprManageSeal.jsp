<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t369'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript">
	        var g_xmlHTTP;
	        var pUserID = "${userInfo.id}";
	        var pUserName = "${userInfo.displayName}";
	        var companyID = "${userInfo.companyID}";
	        var pUserName1 = "${userInfo.displayName1}";
	        var pUserName2 = "${userInfo.displayName2}";
	        var parameter = new Array();
	        window.onload = function () {
	            var listview = new ListView();
	            listview.SetID("lvtFormID");
	            listview.DataSource(loadXMLString(document.getElementById("LISTHEADER").innerHTML.toUpperCase()));
	            listview.DataBind("lvtForm");
	            getSealList();
	        }
	        var ezapralert_cross_dialogArgument = new Array();
	        function OpenAlertUI(pAlertContent) {
	            var parameter = pAlertContent;
	            var url = "";
	            url = "/admin/ezApproval/ezAprAlert.do?type=OPEN";
	
	            if (CrossYN()) {
	                ezapralert_cross_dialogArgument[0] = parameter;
	                ezapralert_cross_dialogArgument[1] = "OPEN";
	                var OpenWin = GetOpenWindow(url, "", 330, 205, "NO");
	            }
	            else {
	                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	                feature = feature + GetShowModalPosition(330, 205);
	                var RtnVal = window.showModalDialog(url, parameter, feature);
	            }
	        }
	        function getSealList() {
                var result = "";
                
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/admin/ezApproval/getSealList.do",
		    		data : {
		    			listFlag   : "ADMIN",
		    			companyID  : document.getElementById("ListCompany").value
		    		},
		    		success: function(text){
		    			getSealList_after(text);
		    		},
		    		error: function() {
		    			alert("<spring:message code='ezApproval.t168'/>");
		    		}
		    	});
	        }
	        
	        function getSealList_after(text) {
                var listview = new ListView();
                listview.LoadFromID("lvtFormID");
                listview.SetRowOnDblClick("lvtForm_onDblclick");
                listview.DataSource(loadXMLString(text));
                listview.RowDataBind("lvtForm");

                if (listview.GetDataRows()[0].id.indexOf("noItems") > -1) {
                    var listview = new ListView();
                    listview.SetID("lvtFormID");
                    listview.DataSource(loadXMLString(document.getElementById("LISTHEADER").innerHTML.toUpperCase()));
                    listview.RowDataBind("lvtForm");
                }
	        }
	        
	        function InsertSealInfo(pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight) {
				var result = "";
                
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/insertSealInfo.do",
		    		data : {
		    			sealName   : pSealName,
		    			sealPath   : pSealPath,
		    			sealWidth  : pSealWidth,
		    			sealHeight : pSealHeight,
		    			regUserID  : pUserID,
		    			regUserName : pUserName1,
		    			regUserName2 : pUserName2,
		    			companyID  : document.getElementById("ListCompany").value
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
	
	            return getNodeText(loadXMLString(result).documentElement);
	
	        }
	        
	        function DeleteSealInfo() {
                var result = "";
                
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/deleteSealInfo.do",
		    		data : {
		    			companyID  : document.getElementById("ListCompany").value
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
	            return getNodeText(loadXMLString(result).documentElement);
	        }
	        
	        function lvtForm_onclick() {
	        }
	
	        function lvtForm_onSel_Changed() {
	        }
	        
	        function lvtForm_onDblclick() {
	            btnInfo_onclick();
	        }
	
	        var ezSealInfo_dialogArguments = new Array();
	        function btnInfo_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvtFormID");
	
	            var oArrRows = listview.GetSelectedRows();
	            var length = oArrRows.length;
	            if (length > 0) {
	                parameter[0] = GetAttribute(oArrRows[0], "DATA1");
	                parameter[1] = getNodeText(oArrRows[0].cells[0]);
	                parameter[2] = escape(GetAttribute(oArrRows[0], "DATA2"));
	                parameter[3] = getNodeText(oArrRows[0].cells[1]);
	                parameter[4] = getNodeText(oArrRows[0].cells[2]);
	                parameter[5] = getNodeText(oArrRows[0].cells[3]);
	                parameter[6] = getNodeText(oArrRows[0].cells[4]);
	                parameter[7] = GetAttribute(oArrRows[0], "DATA3");
	                parameter[8] = getNodeText(oArrRows[0].cells[5]);
	
	                var url = "/admin/ezApproval/sealInfo.do";
	                ezSealInfo_dialogArguments[0] = parameter;
	                var OpenWin = window.open(url, "ezSealInfo", GetOpenWindowfeature(500, 420));
// 	                var OpenWin = GetOpenWindow(url, "ezSealInfo", 500, 420, "NO");
	            }
	            else {
	                var pInformationString = "<spring:message code='ezApproval.t370'/>";
	                OpenAlertUI(pInformationString);
	                return;
	            }
	        }
	
	        var AddSealInfo_dialogArguments = new Array();
	        function btnAdd_onclick() {
	            var parameter = new Array();
	            parameter[0] = pUserID;
	            parameter[1] = pUserName;
	            parameter[2] = document.getElementById("ListCompany").value;
	
	            if (CrossYN()) {
	                AddSealInfo_dialogArguments[0] = parameter;
	                AddSealInfo_dialogArguments[1] = btnAdd_onclick_Complete;
	
	                var ezSealInfo = window.open("/admin/ezApproval/addSealInfo.do", "AddSealInfo", GetOpenWindowfeature(450, 380));
	                try { ezSealInfo.focus(); } catch (e) {
	                }
	            } else {
	                var url = "/admin/ezApproval/addSealInfo.do";
	                var feature = "status:no;dialogWidth:450px;dialogHeight:380px;edge:sunken;scroll:no;help:no"
	                feature = feature + GetShowModalPosition(450, 380);
	                var ret = window.showModalDialog(url, parameter, feature);
	
	                if (ret[0] == "OK") {
	                    var RtnVal = InsertSealInfo(ret[1], ret[2], ret[3], ret[4], ret[5]);
	                    
                        if (RtnVal == "TRUE") {
                            var pInformationString = "<spring:message code='ezApproval.t371'/>";
                            OpenAlertUI(pInformationString);
                            getSealList();
                        }
                        else {
                            var pInformationString = "<spring:message code='ezApproval.t372'/>";
                            OpenAlertUI(pInformationString);
                            return;
                        }
	                } else {
	                	var pInformationString = "<spring:message code='ezApproval.t372'/>";
                        OpenAlertUI(pInformationString);
                        return;
	                }
	            }
	        }
	
	        function btnAdd_onclick_Complete(RtnVal) {
	            if (RtnVal[0] == "OK") {
                    RtnVal = InsertSealInfo(RtnVal[1], RtnVal[2], RtnVal[3], RtnVal[4], RtnVal[5]);
                    if (RtnVal == "TRUE") {
                        var pInformationString = "<spring:message code='ezApproval.t371'/>";
                        OpenAlertUI(pInformationString);
                        getSealList();
                    }
                    else {
                        var pInformationString = "<spring:message code='ezApproval.t372'/>";
                        OpenAlertUI(pInformationString);
                        return;
                    }
	            }
	        }
	
	        function changeCompID() {
	            getSealList();
	        }
	    </script>
	</head>
	<body class="mainbody">
	    <xml id='LISTHEADER' style="display: none">
	    <LISTVIEWDATA>
	        <HEADERS>
	            <HEADER>
	                <NAME><spring:message code='ezApproval.t373'/></NAME>
	                <WIDTH>100</WIDTH>
	            </HEADER>
	            <HEADER>
	                <NAME><spring:message code='ezApproval.t374'/></NAME>
	                <WIDTH>100</WIDTH>
	            </HEADER>
	            <HEADER>
	                <NAME><spring:message code='ezApproval.t375'/></NAME>
	                <WIDTH>100</WIDTH>
	            </HEADER>
	            <HEADER>
	                <NAME><spring:message code='ezApproval.t367'/></NAME>
	                <WIDTH>120</WIDTH>
	            </HEADER>
	            <HEADER>
	                <NAME><spring:message code='ezApproval.t368'/></NAME>
	                <WIDTH>120</WIDTH>
	            </HEADER>
	            <HEADER>
	                <NAME><spring:message code='ezApproval.t376'/></NAME>
	                <WIDTH>100</WIDTH>
	            </HEADER>
	        </HEADERS>
	    </LISTVIEWDATA>
	</xml>
	    <h1><spring:message code='ezApproval.t377'/></h1>
	    <div id="mainmenu">
	        <ul>
	            <span><b><spring:message code='ezApproval.t378'/></b>
                  	<select id="ListCompany" name="ListCompany" onchange="return changeCompID()">
		    			${companySel}
					</select>
	            </span>
	            <br />
	            <br />
	            <li id="SearchCondi"><span onclick="return btnInfo_onclick()"><spring:message code='ezApproval.t379'/></span></li>
	            <li id="GetEDMSXML"><span onclick="return btnAdd_onclick()"><spring:message code='ezApproval.t360'/></span></li>
	        </ul>
	    </div>
	
	    <div class="listview" style="width: 790px">
	        <div id="lvtForm" style="BEHAVIOR: url(#behave1#ListView); border: 0; HEIGHT: 300px; WIDTH: 790px" onclick="lvtForm_onclick()"></div>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	</body>
</html>