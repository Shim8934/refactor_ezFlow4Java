<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t680'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var labelcolor = "gray"
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var gFContID, gFormID, gState, gRtnVal;
	        var P_companyID
	        var listview = new ListView();
	
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        window.onload = function () {
	            try {
	                dialogArguments = opener.mconttype_dialogArguments[0];
	            } catch (e) { }
	            try {
	
	                var ua = navigator.userAgent;
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    var input = document.getElementsByTagName("input");
	                    for (var i = 0; i < input.length; i++) {
	                        if (GetAttribute(input[i], "type") == "text")
	                            KeEventControl(input[i]);
	                    }
	                }
	            }
	            catch (e)
	            { }
	            P_companyID = dialogArguments["P_companyID"];
	
	            document.getElementById('lvDocTypeList').innerHTML = "";
	            listview.SetID("lvDocTypeListForm");
	            listview.SetMulSelectable(false);
	            if(document.getElementById("FORMLIST") != null)
	                listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
	            else
	                listview.DataSource();
	            getDocType();
	        }
	
	        function getDocType() {
	            document.getElementById('lvDocTypeList').innerHTML = "";
	            listview.LoadFromID("lvtDocForm");
	            var xmlRtn = createXmlDom();
	            
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/MLgetDoctype.do",
		    		data : {
		    			comID  : P_companyID
		    		},
		    		success: function(xml){
			            xmlRtn = loadXMLString(xml);
			            listview.DataSource(xmlRtn);
			            listview.DataBind("lvDocTypeList");
		    		}
		    	});
	        }
	
	
	        function SelContName_Check() {
	            var j;
	            listview.LoadFromID("lvtDocForm");
	            var i = listview.GetRowCount();
	            var k = 0;
	
	            for (j = 0; j < i; j++) {
	                if (document.getElementById("DocTypeName").value == getNodeText(listview.GetDataRows()[j].cells[0]))
	                    k++;
	            }
	            return k;
	        }
	
	        function btnOk_onclick() {
	            var cnt = SelContName_Check();
	            if (cnt == 0) {
	                if (document.getElementById("DocTypeName").value != "") {
	                    var xmlpara = createXmlDom();
	                    var xmlRtn = createXmlDom();
	                    var ParaName, ParaValue;
	
	                    var objNode;
	                    createNodeInsert(xmlpara, objNode, "PARAMETER");
	                    createNodeAndInsertText(xmlpara, objNode, "DocTypeName", document.getElementById("DocTypeName").value);
	                    createNodeAndInsertText(xmlpara, objNode, "DocTypeName2", document.getElementById("DocTypeName2").value);
	                    createNodeAndInsertText(xmlpara, objNode, "ComID", P_companyID);
	
	
	                    xmlhttp.open("POST", "/myoffice/ezApproval/manage/aspx/InsertContType.aspx", false);
	                    xmlhttp.send(xmlpara);
	
	                    xmlRtn = loadXMLString(xmlhttp.responseText);
	                    var RtnDocType = xmlRtn.getElementsByTagName("RESULT")[0].childNodes[0].nodeValue;
	
	                    if (RtnDocType == "FALSE") {
	                        alert("<spring:message code='ezApproval.t691'/>");
	                    }
	                    else {
	                        alert("<spring:message code='ezApproval.t692'/>");
	                        getDocType();
	                        document.getElementById("DocTypeName").value = "";
	                        document.getElementById("DocTypeName2").value = "";
	                    }
	                }
	                else {
	                    alert("<spring:message code='ezApproval.t693'/>");
	                }
	            }
	            else {
	                alert("<spring:message code='ezApproval.t694'/>");
	                document.getElementById("DocTypeName").value = "";
	                document.getElementById("DocTypeName2").value = "";
	                document.getElementById("DocTypeName").focus();
	            }
	        }
	
	        function btnDel_onclick() {
	            var i, ContDocInfo, NodeName;
	            listview.LoadFromID("lvtDocForm");
	            if (listview.GetSelectedIndexes() > 0);
	            ContDocInfo = listview.GetDataRows()[listview.GetSelectedIndexes()];
	
	            var xmlpara = createXmlDom();
	            var xmlRtn = createXmlDom();
	            var ParaName, ParaValue;
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "DocTypeID", GetAttribute(ContDocInfo, "DATA1"));
	            createNodeAndInsertText(xmlpara, objNode, "ComID", P_companyID);
	
	            xmlhttp.open("POST", "/myoffice/ezApproval/manage/aspx/DeleteContType.aspx", false);
	            xmlhttp.send(xmlpara);
	            if (xmlhttp.responseText == "TRUE") {
	                alert("<spring:message code='ezApproval.t695'/>");
	                getDocType();
	            }
	            else if (xmlhttp.responseText == "FALSE")
	                alert("<spring:message code='ezApproval.t696'/>");
	            else if (xmlhttp.responseText == "USE")
	                alert("<spring:message code='ezApproval.t697'/>");
	        }
	
	        function btncancel_onclick() {
	            window.close();
	        }
	
	        function lvDocTypeList_onSel_Changed() {
	
	        }
	
	        function lvDocTypeList_onSel_Click() {
	
	        }
	
	        function lvDocTypeList_onSel_DBclick() {
	
	        }
	
	        function lvDocTypeList_onclick() {
	
	        }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApproval.t690'/></h1>
	    <div class="listview" style="width: 100%; overflow-x: hidden; overflow-y: auto">
	        <div id="lvDocTypeList" style="BORDER: 0; HEIGHT: 200px; WIDTH: 100%" onclick="lvDocTypeList_onclick()" onselchanged="lvDocTypeList_onSel_Changed()" onrowclick="lvDocTypeList_onSel_Click()" onselclick="lvDocTypeList_onSel_Click()" onseldblclick="lvDocTypeList_nSel_DBclick()" onrowdblclick="lvDocTypeList_onSel_DBclick()"></div>
	    </div>
	    <table class="content" style="margin-top: 5px">
	        <tr>
	            <th><spring:message code='ezApproval.t611'/></th>
	            <td>
	                <table style="width: 100%">
	                    <tr class="primary">
	                        <th>${langPrimary}</th>
	                        <td>
	                            <input type="text" id="DocTypeName" name="DocTypeName" style="width: 99%" maxlength="50"></td>
	                    </tr>
	                    <tr class="secondary">
	                        <th>${langSecondary}</th>
	                        <td>
	                            <input type="text" id="DocTypeName2" name="DocTypeName2" style="width: 99%" maxlength="50"></td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnposition">
	        <a class="imgbtn" onclick="btnOk_onclick()"><span><spring:message code='ezApproval.t574'/></span></a>
	        <a class="imgbtn" onclick="btnDel_onclick()"><span><spring:message code='ezApproval.t194'/></span></a>
	        <a class="imgbtn" onclick="btncancel_onclick()"><span><spring:message code='ezApproval.t70'/></span></a>
	    </div>
	</body>
</html>
