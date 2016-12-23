<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title>${title}</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
		<script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/TreeViewCtrl_Cross.js"></script>    
	    <script type="text/javascript">
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var gManageID, gFContID, gParant, Flag, RtnState, gParantName;
	        var companyID;
	        var gParantName2 = "";
	        var gMultiDataNum = "";
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        var ReturnFunction;
	        window.onload = function () {
	            var RtnVal = new Array()
	
	            try {
	                dialogArguments = opener.FormContMain_dialogarguments[0];
	                ReturnFunction = opener.FormContMain_dialogarguments[1];
	            } catch (e) {
	                try {
	                    dialogArguments = parent.FormContMain_dialogarguments[0];
	                    ReturnFunction = parent.FormContMain_dialogarguments[1];
	                } catch (e) {
	                }
	            }
	
	            var Para = dialogArguments;
	            Flag = Para[0];
	            gParant = Para[1];
	            gParantName = Para[2];
	            companyID = Para[3];
	            gParantName2 = Para[4];
	
	            if (Flag == "I")
	                gMultiDataNum = Para[5];
	            else if (Flag == "U") {
	                gMultiDataNum = Para[9];
	                InitValue(Para);
	            }
	
	            if (gMultiDataNum == "")
	                document.getElementById("ParantName").innerHTML = " <font color='gray'> " + gParantName + " </font> ";
	            else
	                document.getElementById("ParantName").innerHTML = " <font color='gray'> " + gParantName2 + " </font> ";
	
	            initTreeInfo();
	        }
	
	        function InitValue(Para) {
	            var Cnt;
	            var contID = new Array();
	            var name = new Array();
	            gParantName = Para[2];
	            gParantName2 = Para[8];
	
	            document.getElementById("tbFormContID").value = Para[1];
	            document.getElementById("tbFormContName").value = gParantName;
	            document.getElementById("tbFormContName2").value = gParantName2;
	            document.getElementById("tbDescript").value = Para[5];
	            gParant = Para[4];
	            gManageID = Para[3];
	            companyID = Para[7];
	
	            if (Para[3] != "ALL") {
	                document.getElementById("rdGroup").checked = true;
	                rdGroup_onclick();
	
	                document.getElementById("tbManage").value = Para[6];
	                var xmlpara = createXmlDom();
	                var xmlRtn = createXmlDom();
	
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                createNodeAndInsertText(xmlpara, objNode, "FContID", document.getElementById("tbFormContID").value);
	                createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
	
	                xmlhttp.open("POST", "/myoffice/ezApproval/manage/FormMaker/aspx/Get_GroupDept.aspx", false);
	                xmlhttp.send(xmlpara);
	
	                xmlRtn = loadXMLString(xmlhttp.responseText);
	                var objNode = xmlRtn.documentElement.childNodes;
	                for (Cnt = 0; Cnt < objNode.length - 1; Cnt++) {
	                    var nodevalue = SelectSingleNodeValueNew(xmlRtn, "PARAMETER/ID" + Cnt);
	
	                    if (nodevalue != null && nodevalue != "" && nodevalue && "undefine") {
	                        contID[Cnt] = SelectSingleNodeValueNew(xmlRtn, "PARAMETER/ID" + Cnt);
	                        name[Cnt] = SelectSingleNodeValueNew(xmlRtn, "PARAMETER/NAME" + Cnt);
	                        Add_Item(name[Cnt], contID[Cnt]);
	                    }
	                }
	            }
	        }
	
	        function Add_Item(Name, ID) {
	            var oOption = document.createElement("OPTION");
	            setNodeText(oOption , Name);
	            oOption.value = ID;
	            if (CrossYN())
	                document.getElementById("selDept").add(oOption, null);
	            else
	                document.getElementById("selDept").add(oOption);
	        }
	
	        function InsFContTotal() {
	            if (document.getElementById("tbFormContName").value == "") {
	                RtnState = false;
	                return;
	            }
	
				var result = "";
                var formContName2 = "";
	            if (document.getElementById("tbFormContName2").value == "")
	            	formContName2 = document.getElementById("tbFormContName").value;
	            else
	            	formContName2 = document.getElementById("tbFormContName2").value;
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/setFormContIns.do",
		    		data : {
		    			formContName     : document.getElementById("tbFormContName").value,
		    			formContName2    : formContName2,
		    			formContDescript : document.getElementById("tbDescript").value,
		    			formContParents  : gParant,
		    			formContDept     : "ALL",
		    			companyID  		 : companyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
	            xmlRtn = loadXMLString(result);
	
	            if (result.indexOf("FALSE") > -1) {
	                RtnState = false;
	            }
	            else {
	                RtnState = true;
	                gFContID = SelectSingleNodeValueNew(xmlRtn, "PARAMETER/FContID");
	            }
	        }
	
	        function InsFContGroup() {
	            if (document.getElementById("tbFormContName").value == "") {
	                RtnState = false;
	                return;
	            }
	
	            var xmlpara = createXmlDom();
	            var xmlRtn = createXmlDom();
	            var ParaName, ParaValue
	            var objNode;
	            var objRoot = createNodeInsert(xmlpara, objNode, "PARAMETER");
	            objRoot.setAttribute("COMPANYID", companyID);
	            createNodeAndInsertText(xmlpara, objNode, "FContName", document.getElementById("tbFormContName").value);
	            createNodeAndInsertText(xmlpara, objNode, "FContDescript", document.getElementById("tbDescript").value);
	            createNodeAndInsertText(xmlpara, objNode, "FContparant", gParant);
	            createNodeAndInsertText(xmlpara, objNode, "FContDept", gManageID);
	            if (document.getElementById("tbFormContName2").value == "")
	                createNodeAndInsertText(xmlpara, objNode, "FContName2", document.getElementById("tbFormContName").value);
	            else
	                createNodeAndInsertText(xmlpara, objNode, "FContName2", document.getElementById("tbFormContName2").value);
	
	            var Count = document.getElementById("selDept").length;
	            for (i = 0; i < Count; i++) {
	                ParaName = "Dept" + i;
	                ParaValue = document.getElementById("selDept").item(i);
	                createNodeAndInsertText(xmlpara, objNode, ParaName, ParaValue.value);
	            }
	
	            xmlhttp.open("POST", "/myoffice/ezApproval/manage/FormMaker/aspx/Set_FormCont_Ins.aspx", false);
	            xmlhttp.send(xmlpara);
	            xmlRtn = loadXMLString(xmlhttp.responseText);
	            if (xmlhttp.responseText.indexOf("FALSE") > -1) {
	                RtnState = false;
	            }
	            else {
	                RtnState = true;
	                gFContID = SelectSingleNodeValueNew(xmlRtn, "PARAMETER/FContID");
	            }
	        }
	
	        function UpFcontTotal() {
	            var xmlpara = createXmlDom();
	            var xmlRtn = createXmlDom();
	
	            var objNode;
	            var objRoot = createNodeInsert(xmlpara, objNode, "PARAMETER");
	            objRoot.setAttribute("COMPANYID", companyID);
	            createNodeAndInsertText(xmlpara, objNode, "FContName", document.getElementById("tbFormContName").value);
	            createNodeAndInsertText(xmlpara, objNode, "FContDescript", document.getElementById("tbDescript").value);
	            createNodeAndInsertText(xmlpara, objNode, "FContparant", gParant);
	            createNodeAndInsertText(xmlpara, objNode, "FContDept", "ALL");
	            createNodeAndInsertText(xmlpara, objNode, "FContID", document.getElementById("tbFormContID").value);
	            createNodeAndInsertText(xmlpara, objNode, "FContName2", document.getElementById("tbFormContName2").value);
	            xmlhttp.open("POST", "/myoffice/ezApproval/manage/FormMaker/aspx/Set_FormCont_Mod.aspx", false);
	            xmlhttp.send(xmlpara);
	            xmlRtn = loadXMLString(xmlhttp.responseText);
	            if (xmlhttp.responseText.indexOf("FALSE") > -1) {
	                RtnState = false;
	            }
	            else {
	                RtnState = true;
	            }
	        }
	
	        function UpFContGroup() {
	            var xmlpara = createXmlDom();
	            var xmlRtn = createXmlDom();
	            var ParaName, ParaValue
	            var objNode;
	            var objRoot = createNodeInsert(xmlpara, objNode, "PARAMETER");
	            objRoot.setAttribute("COMPANYID", companyID);
	            createNodeAndInsertText(xmlpara, objNode, "FContName", document.getElementById("tbFormContName").value);
	            createNodeAndInsertText(xmlpara, objNode, "FContDescript", document.getElementById("tbDescript").value);
	            createNodeAndInsertText(xmlpara, objNode, "FContparant", gParant);
	            createNodeAndInsertText(xmlpara, objNode, "FContDept", gManageID);
	            createNodeAndInsertText(xmlpara, objNode, "FContID", document.getElementById("tbFormContID").value);
	            createNodeAndInsertText(xmlpara, objNode, "FContName2", document.getElementById("tbFormContName2").value);
	
	            var Count = document.getElementById("selDept").length;
	            for (i = 0; i < Count; i++) {
	                ParaName = "Dept" + i
	                ParaValue = document.getElementById("selDept").item(i)
	                createNodeAndInsertText(xmlpara, objNode, ParaName, ParaValue.value);
	            }
	            xmlhttp.open("POST", "/myoffice/ezApproval/manage/FormMaker/aspx/Set_FormCont_Mod.aspx", false);
	            xmlhttp.send(xmlpara);
	            xmlRtn = loadXMLString(xmlhttp.responseText);
	            if (xmlhttp.responseText.indexOf("FALSE") > -1) {
	                RtnState = false;
	            }
	            else {
	                RtnState = true;
	            }
	        }
	
	        function initTreeInfo() {
	            var sstart, send;
	            var compDeptid = "";
	            Tree_setconfig();
	            TreeViewinitialize("", "${topID}", "extensionAttribute2;extensionAttribute3", "${userInfo.serverName}");
	        }
	
	        function Tree_setconfig() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
	            }
	        }
	
	        function rdGroup_onclick() {
	            document.getElementById("rdTotal").checked = false;
	            gManageID = "";
	            document.getElementsByName("btnUseDept")[0].style.display = "";
	            document.getElementsByName("btnDelDept")[0].style.display = "";
	        }
	
	        function rdTotal_onclick() {
	            document.getElementById("rdGroup").checked = false;
	            gManageID = "ALL";
	            document.getElementsByName("btnUseDept")[0].style.display = "none";
	            document.getElementsByName("btnDelDept")[0].style.display = "none";
	        }
	
	        function btnUseDept_onclick() {
	            var selDeptID, selDeptName
	            var oOption = document.createElement("OPTION");
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);
	
	            if (nodeIdx != "") {
	                selDeptName = treeNode.GetNodeData("VALUE");
	                selDeptID = treeNode.GetNodeData("CN");
	
	                setNodeText(oOption , selDeptName);
	                oOption.value = selDeptID;
	
	                if (document.getElementById("selDept").length > 0) {
	                    for (var i = 0 ; i < document.getElementById("selDept").length ; i++) {
	                        if (document.getElementById("selDept").item(i).value == oOption.value) {
	                            alert("<spring:message code='ezApproval.t735'/>");
	                            return;
	                        }
	                    }
	                }
	                if (CrossYN())
	                    document.getElementById("selDept").add(oOption, null);
	                else
	                    document.getElementById("selDept").add(oOption);
	            }
	            else {
	                alert("<spring:message code='ezApproval.t736'/>");
	            }
	        }
	
	        function btnDelDept_onclick() {
	            var index;
	            index = document.getElementById("selDept").selectedIndex;
	            if (index != -1)
	                document.getElementById("selDept").remove(index)
	            else
	                alert("<spring:message code='ezApproval.t745'/>");
	        }
	
	        function btnOK_onclick() {
	            var RtnVal = new Array();
	            if (Flag == "I") {
	                if (document.getElementById("rdTotal").checked) {
	                    InsFContTotal();
	                }
	                else {
	                    InsFContGroup();
	                }
	                if (RtnState) {
	                    if (document.getElementById("rdTotal").checked)
	                        gManageID = "ALL";
	
	                    RtnVal[0] = "TRUE";
	                    RtnVal[1] = gFContID;
	                    RtnVal[2] = document.getElementById("tbFormContName").value;
	                    RtnVal[3] = gManageID;
	                    RtnVal[4] = gParant;
	                    RtnVal[5] = document.getElementById("tbDescript").value;
	                    RtnVal[6] = document.getElementById("tbManage").value;
	
	                    if (document.getElementById("tbFormContName2").value == "")
	                        RtnVal[7] = document.getElementById("tbFormContName").value;
	                    else
	                        RtnVal[7] = document.getElementById("tbFormContName2").value;
	                }
	                else {
	                    RtnVal[0] = "FALSE";
	                }
	            }
	            else {
	                if (document.getElementById("rdTotal").checked) {
	                    UpFcontTotal();
	                }
	                else {
	                    UpFContGroup();
	                }
	
	                if (RtnState) {
	                    RtnVal[0] = "TRUE";
	                    RtnVal[1] = document.getElementById("tbFormContName").value;
	                    RtnVal[2] = document.getElementById("tbDescript").value;
	                    RtnVal[3] = gManageID;
	                    RtnVal[4] = document.getElementById("tbManage").value;
	                    RtnVal[5] = document.getElementById("tbFormContName2").value;
	                }
	                else {
	                    RtnVal[0] = "FALSE";
	                }
	            }
	            ReturnFunction(RtnVal);
	            window.close();
	        }
	
	        function btncancel_onclick() {
	            var RtnVal = new Array()
	
	            RtnVal[0] = "FALSE";
	            ReturnFunction(RtnVal);
	            window.close();
	        }
	
	        function TreeViewNodeClick() {
	        }
	
	        function TreeViewNodeDbClick()
	        { }
	
	    </script>
	</head>
	
	<body oncontextmenu="return false" class="popup">
	    <xml id="data" style="display:none">
			<TREEVIEWDATA>
				<NODE>
					<TEXT></TEXT>
					<NODES></NODES>
				</NODE>
			</TREEVIEWDATA>
		</xml>
	    <h1>${title}</h1>
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezApproval.t746'/></th>
	            <td id="ParantName">&nbsp;</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t747'/></th>
	            <td style="padding: 0;">
	                <table width="100%">
	                    <tr class="primary">
	                        <th>${langPrimary}</th>
	                        <td>
	                            <input type="text" id="tbFormContName" name="tbFormContName" maxlength="25" style="WIDTH: 100%">
	                            <input type="hidden" id="tbFormContID" name="tbFormContID">
	                        </td>
	                    </tr>
	                    <tr class="secondary">
	                        <th>${langSecondary}</th>
	                        <td>
	                            <input type="text" id="tbFormContName2" name="tbFormContName2" maxlength="25" style="WIDTH: 100%"></td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t748'/></th>
	            <td>
	                <input type="text" id="tbDescript" name="tbDescript" style="WIDTH: 100%" maxlength="50">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t749'/></th>
	            <td>
	                <span><input type="radio" id="rdTotal" name="rdTotal" value="radiobutton" checked onclick="return rdTotal_onclick()"><spring:message code='ezApproval.t750'/></span>
	                <span><input type="radio" id="rdGroup" name="rdGroup" value="radiobutton" onclick="return rdGroup_onclick()"><spring:message code='ezApproval.t751'/></span>
	            </td>
	        </tr>
	    </table>
	    <table style="margin-top: 10px; width:100%">
	        <tr>
	            <td style="width:55%;height:400px;">
	                <div id="TreeView" style="BORDER: #b6b6b6 1px solid;WIDTH: 100%; HEIGHT: 400px; BACKGROUND-COLOR: #ffffff"></div>
	            </td>
	            <td style="width:5%; text-align:center">               
	               <img name="btnUseDept" style="cursor:pointer; display:none" src="/images/arr_r.gif" width="24" height="24" onclick="btnUseDept_onclick()"><br /><br />
	               <img name="btnDelDept" style="cursor:pointer; display:none" src="/images/arr_l.gif" width="24" height="24" onclick="btnDelDept_onclick()">              
	            </td>
	            <td style="width:50%">
	                <input type="text" id="tbManage" name="tbManage" style="Width: 295px;display:none" readonly>
	                <select id="selDept" name="selDept" size="2" style="BORDER: #b6b6b6 1px solid; HEIGHT: 400px; WIDTH: 100%; Z-INDEX: 100">
	                </select>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span id="btnInsFcont" onclick="btnOK_onclick()"><spring:message code='ezApproval.t84'/></span></a>
	        <a class="imgbtn"><span id="Span1" onclick="btncancel_onclick()"><spring:message code='ezApproval.t85'/></span></a>
	    </div>
	</body>
</html>