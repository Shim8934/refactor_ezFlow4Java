var xmlhttp;
function Draftinfo_ini() {
    if (!Draftinfoini) { 
        if (pItemCode == "" || pItemCode == undefined) 
            TreeViewinitializeCodeGroup("0", "1" );
        else
            TreeViewinitializeCodeGroup(pItemCode, "1");

        var treeView = new TreeView();
        treeView.LoadFromID("infotreeView");
        var selnode = treeView.GetSelectNode();
       
        var code = selnode.GetNodeData("DATA1");
        
        var result = "";
        
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
        	url : "/admin/ezApprovalG/getTaskInSubCategoryForManage.do",
        	data : {
        			sCateCode : code,
        			userFlag  : "2",
        			orgCompanyID : orgCompanyID
        			},
        	success : function(text) {
        		result = text;
        	}
    	});
    	
        try {
            var xmlDoc = loadXMLString(result);

            if (document.getElementById("infolist").innerHTML != "") document.getElementById("infolist").innerHTML = "";
            var FormList = new ListView();
            FormList.SetID("lvinfolist");
            FormList.SetMulSelectable(false);
            FormList.SetHeightFree(true);
            FormList.SetSelectFlag(false);
            FormList.SetRowOnClick("lvtinfolist_onclick");
            FormList.DataSource(xmlDoc);
            FormList.DataBind("infolist");
            FormList = null;
            Draftinfoini = true;

            if (pkeeperiod == "") {
            }
            else {
                var i = 0;
                var element = GetElementsByTagName(xmlDoc, "DATA1");
                if (CrossYN()) {
                    for (i = 0; i < element.length; i++) {
                        if (pItemCode.trim() == getNodeText(element[i]).trim()) {
                            break;
                        }
                    }
                }
                else {
                    for (i = 0; i < element.length; i++) {
                        if (pItemCode == getNodeText(element[i])) {
                            break;
                        }
                    }
                }

                getdocinfolist(i);
            }
        }
        catch (ErrMsg) {
        	showAlert(" Draftinfo_ini : " + ErrMsg.description + ErrMsg);
        }
        getMyGroupItem();
    }
}
function event_Draftinfo_ini() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        var xmlDoc = loadXMLString(xmlhttp.responseText);

        if (xmlDoc == null) {
            xmlDoc = loadXMLString(xmlhttp.responseText);
        }

        if (document.getElementById("infolist").innerHTML != "") document.getElementById("infolist").innerHTML = "";
        var FormList = new ListView();
        FormList.SetID("lvinfolist");
        FormList.SetMulSelectable(false);
        FormList.SetHeightFree(true);
        FormList.SetSelectFlag(false);
        FormList.SetRowOnClick("lvtinfolist_onclick");
        FormList.DataSource(xmlDoc);
        FormList.DataBind("infolist");
        FormList = null;
        Draftinfoini = true;
        if (pkeeperiod == "") {
        }
        else {
            var i = 0;
            var element = GetElementsByTagName(xmlDoc, "DATA1");
            if (CrossYN()) {
                for (i = 0; i < element.length; i++) {
                    if (pItemCode == getNodeText(element[i])) {
                        break;
                    }
                }
            }
            else {
                for (i = 0; i < element.length; i++) {
                    if (pItemCode == getNodeText(element[i])) {
                        break;
                    }
                }
            }
          
            getdocinfolist(i);
        }
        xmlhttp = null;
    }
    catch (ErrMsg) {
    	showAlert(" Draftinfo_ini : " + ErrMsg.description + ErrMsg);
    }
}

function lvtinfolist_onclick() {
    allUnSelectFrequency();
    
    var FormList = new ListView();
    FormList.LoadFromID("lvinfolist");
    var pSelectedRow = FormList.GetSelectedRows();
    var pTaskCode, pTaskName, pTaskName2, pTaskP, pTaskS, pTaskY, pCabinetID;
    pTaskCode = GetAttribute(pSelectedRow[0], "DATA1");
    pCabinetID = GetAttribute(pSelectedRow[0], "DATA6");
    pTaskName = GetAttribute(pSelectedRow[0], "DATA11");
    pTaskName2 = GetAttribute(pSelectedRow[0], "DATA12");
    pTaskP = GetAttribute(pSelectedRow[0], "DATA2");
    pTaskS = pSelectedRow[0].cells[4].innerText;
    pTaskY = pSelectedRow[0].cells[5].innerText;
    var Cnt = 0;

    /* 2023-08-02 민지수 - 전자결재 > 기안하기 > 결재정보 > 문서옵션 > 분류코드 다국어처리 */
    if (UserLang == 2) {
        setNodeText(document.getElementById("tbitemCodeName"), "[" + pTaskCode + "]" + pTaskName2);
    } else {
        setNodeText(document.getElementById("tbitemCodeName"), "[" + pTaskCode + "]" + pTaskName);
    }

    document.getElementById("cabinetID").value = pCabinetID;
    document.getElementById("tbItemCode").value = pTaskCode;
    document.getElementById("tbItemName").value = pTaskName
    document.getElementById("tbItemName2").value = pTaskName2;

    for (Cnt = 0; Cnt < document.getElementsByName("RSecurity").length; Cnt++) {
        if (pTaskS == document.getElementsByName("RSecurity")[Cnt].getAttribute("value2")) {
            document.getElementsByName("RSecurity")[Cnt].checked = true; break;
        }
    }
    for (Cnt = 0; Cnt < document.getElementsByName("RKeeptype").length; Cnt++) {
        if (pTaskP == document.getElementsByName("RKeeptype")[Cnt].value) {
            document.getElementsByName("RKeeptype")[Cnt].checked = true; break;
        }
    }
    for (Cnt = 0; Cnt < document.getElementsByName("isPublic").length; Cnt++) {
        if (pTaskY == document.getElementsByName("isPublic")[Cnt].value) {
            document.getElementsByName("isPublic")[Cnt].checked = true; break;
        }
    }
    checkdocinfo = true;
}

function MakeDocInfo() {
//    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var pPublicFlagcheck;
    var psecuritylevelcheck;
    var psecuritylevelvaltemp;
    var pkeeperiodcheck;
    var pkeeperiodvaltemp;
    var psecuritylevelvaltemp;

    if (document.getElementById("urgent").checked)
        pUrgentFlag = "Y";
    else
        pUrgentFlag = "N";

    pPublicFlagcheck = document.getElementsByName("isPublic");
    for (var i = 0; i < pPublicFlagcheck.length; i++) {
        if (pPublicFlagcheck[i].checked) {
            pPublicFlag = GetAttribute(pPublicFlagcheck[i], "value");
            break;
        }
    }

    psecuritylevelcheck = document.getElementsByName("RSecurity");
    for (var i = 0; i < psecuritylevelcheck.length; i++) {
        if (psecuritylevelcheck[i].checked) {
            psecuritylevel = GetAttribute(psecuritylevelcheck[i], "value");
            psecuritylevelvaltemp = GetAttribute(psecuritylevelcheck[i], "value2");
            break;
        }
    }

    pkeeperiodcheck = document.getElementsByName("RKeeptype");
    for (var i = 0; i < pkeeperiodcheck.length; i++) {
        if (pkeeperiodcheck[i].checked) {
            pkeeperiod = GetAttribute(pkeeperiodcheck[i], "value");
            pkeeperiodvaltemp = GetAttribute(pkeeperiodcheck[i], "value2");
            break;
        }
    }

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pkeeperiod", pkeeperiod);
    createNodeAndInsertText(xmlpara, objNode, "psecuritylevel", psecuritylevel);
    createNodeAndInsertText(xmlpara, objNode, "pUrgentFlag", pUrgentFlag);
    createNodeAndInsertText(xmlpara, objNode, "pPublicFlag", pPublicFlag);
    createNodeAndInsertText(xmlpara, objNode, "psecuritylevelvaltemp", psecuritylevelvaltemp);
    createNodeAndInsertText(xmlpara, objNode, "tbItemCode", document.getElementById("tbItemCode").value);
    createNodeAndInsertText(xmlpara, objNode, "tbItemName", document.getElementById("tbItemName").value);
    createNodeAndInsertText(xmlpara, objNode, "tbItemName2", document.getElementById("tbItemName2").value);
    createNodeAndInsertText(xmlpara, objNode, "pkeeperiodvaltemp", pkeeperiodvaltemp);
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
    // createNodeAndInsertText(xmlpara, objNode, "SUMMARY", document.getElementById("taSummery").value);
    
    return xmlpara;
}

function getdocinfolist(i) {
    var FormList = new ListView();
    FormList.LoadFromID("lvinfolist");
   
    selectedid = "lvinfolist_TR_" + i;
    
    FormList.SetSelectedID(selectedid);
    var Cnt = 0;

    if (pUrgentFlag == "Y")
        document.getElementById("urgent").checked = true;
    else
        document.getElementById("urgent").checked = false;

    var temptRSecurity = document.querySelector("#RSecurity");
    var temptRKeeptype = document.getElementsByName("RKeeptype");
    var temptisPublic = document.getElementsByName("isPublic");
    temptRSecurity.value = psecuritylevel;
         
    for (Cnt = 0; Cnt < temptRKeeptype.length; Cnt++) {
        if (pkeeperiod == temptRKeeptype[Cnt].value) {
            temptRKeeptype[Cnt].checked = true; break;
        }
    }
    for (Cnt = 0; Cnt < temptisPublic.length; Cnt++) {
        if (pPublicFlag == temptisPublic[Cnt].value) {
            temptisPublic[Cnt].checked = true; break;
        }
    }

    setNodeText(document.getElementById("tbitemCodeName"),"[" + pItemCode + "]" + pItemName);
    document.getElementById("tbItemCode").value = pItemCode;
    document.getElementById("tbItemName").value = pItemName;
    document.getElementById("tbItemName2").value = pItemName2;
    // document.getElementById("taSummery").value = vSummery;
    //    GetExtraDocInfo();
    // 2023-08-24 조수빈 - 문서옵션의 키워드에 기존 값이 없을 경우 undifined로 출력되는 문제 처리를 위해 변경.
    document.querySelector("input[name=keyword]").value = pkeyword ? pkeyword : "";
}

function Draftinfo_reload() {
    Draftinfoini = false;
    Draftinfo_ini();
}
function CodeSearch_onclick() {
    var SearchOPtion = GetAttribute(document.getElementById("selSearchOption")[document.getElementById("selSearchOption").selectedIndex], "id");
    var SearchValue = document.getElementById("txtCodeSearch").value;
    if (SearchValue.trim() == "") {
    	showAlert(strLangS554);
        return;
    }

    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/findTaskList.do",
		data : {
			deptCode   : SearchOPtion,
			title 	   : SearchValue
		},
		success: function(text){
			result = text;
		}        			
	});
    
//    try {
        var xmlDoc = loadXMLString(result);

        if (document.getElementById("infolist").innerHTML != "") document.getElementById("infolist").innerHTML = "";
        var FormList = new ListView();
        FormList.SetID("lvinfolist");
        FormList.SetMulSelectable(false);
        FormList.SetHeightFree(true);
        FormList.SetSelectFlag(false);
        FormList.SetRowOnClick("lvtinfolist_onclick");
        FormList.DataSource(xmlDoc);
        FormList.DataBind("infolist");
        FormList = null;
        Draftinfoini = true;
        if (pkeeperiod == "") {
        }
        else {
            var i = 0;
            var element = GetElementsByTagName(xmlDoc, "DATA1");
            if (CrossYN()) {
                for (i = 0; i < element.length; i++) {
                    if (pItemCode == getNodeText(element[i])) {
                        break;
                    }
                }
            }
            else {
                for (i = 0; i < element.length; i++) {
                    if (pItemCode == getNodeText(element[i])) {
                        break;
                    }
                }
            }
            
        }
//    }
//    catch (ErrMsg) {
//        alert(" CodeSearch_onclick : " + ErrMsg.description + ErrMsg);
//    }

}
function CodeSearch_Press(e) {
    if (window.event) {
        if (window.event.keyCode != 13)
            return;
    }
    else {
        if (e.which != 13)
            return;
    }
    CodeSearch_onclick();
}

function TreeViewinitializeCodeGroup(code, level) {
//    try {
        Tree_setconfig();

        var xmlTree = createXmlDom();
        var objNode;
        var result = "";
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getCodeTreeInfo.do",
    		data : {
    			code  : code,
    			level : level,
    			orgCompanyID : orgCompanyID
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});
        
        xmlTree = loadXMLString(result);
        
        if (xmlTree.childNodes.length > 0) {
            var xmlRtn = loadXMLString(result).documentElement;
            if (GetChildNodes(GetChildNodes(xmlTree)[0])[0] == null)
                TreeViewinitializeCodeGroup("0", "1");
            GetChildNodes(GetChildNodes(xmlTree)[0])[0].appendChild(xmlRtn);
        }

        if (document.getElementById("infotree").innerHTML != "") document.getElementById("infotree").innerHTML = "";
        var treeView = new TreeView();
        treeView.SetID("infotreeView");
        treeView.SetUseAgency(true);
        treeView.SetNodeClick("TreeViewCodeNodeClick");
        treeView.SetRequestData("TreeViewCodeRequestData");
        treeView.DataSource(xmlTree);
        treeView.DataBind("infotree");
//    }
//    catch (ErrMsg) {
//        alert(" TreeViewinitialize : " + ErrMsg.description);
//    }
}

function TreeViewCodeRequestData(pNodeID, pTreeID) {
    var TreeIdx = pNodeID;
    var treeNode = new TreeNode();
    treeNode.LoadFromID(TreeIdx);
    var code = treeNode.GetNodeData("DATA1");
    var level = treeNode.GetNodeData("DATA2");
    GetDeptSubCodeTreeInfo(code, level, TreeIdx);
}


function GetDeptSubCodeTreeInfo(code, level, TreeIdx) {
    var xmlRtn = createXmlDom();
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCodeSubTreeInfo.do",
		data : {
			code  : code,
			level : level
		},
		success: function(text){
			result = text;
		}        			
	});

    xmlRtn = loadXMLString(result);
    
    if (xmlRtn.childNodes.length > 0) {
        if (CrossYN()) {
            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
        } else {
            xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
        }
    }

    var treeView = new TreeView();
    treeView.LoadFromID("infotreeView");
    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

function TreeViewCodeNodeClick() {
    var treeView = new TreeView();
    treeView.LoadFromID("infotreeView");
    var selnode = treeView.GetSelectNode();
    
    var code = selnode.GetNodeData("DATA1");
    var level = selnode.GetNodeData("DATA2");
    
    var result = "";
    
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
    	url : "/admin/ezApprovalG/getTaskInSubCategoryForManage.do",
    	data : {
    			sCateCode : code,
    			userFlag  : "2",
    			orgCompanyID : orgCompanyID
    			},
    	success : function(text) {
    		result = text;
    	}
	});
	
//    try {
        var xmlDoc = loadXMLString(result);

        if (document.getElementById("infolist").innerHTML != "") document.getElementById("infolist").innerHTML = "";
        var FormList = new ListView();
        FormList.SetID("lvinfolist");
        FormList.SetMulSelectable(false);
        FormList.SetHeightFree(true);
        FormList.SetSelectFlag(false);
        FormList.SetRowOnClick("lvtinfolist_onclick");
        FormList.DataSource(xmlDoc);
        FormList.DataBind("infolist");
        FormList = null;
        Draftinfoini = true;
        if (pkeeperiod == "") {
        }
        else {
            var i = 0;
            var element = GetElementsByTagName(xmlDoc, "DATA1");
            if (CrossYN()) {
                for (i = 0; i < element.length; i++) {
                    
                    if (pItemCode.trim() == getNodeText(element[i]).trim()) {
                        break;
                    }
                }
            }
            else {
                for (i = 0; i < element.length; i++) {
                    if (pItemCode == getNodeText(element[i])) {
                        break;
                    }
                }
            }
            getdocinfolist(i);
        }
//    }
//    catch (ErrMsg) {
//        alert(" Draftinfo_ini : " + ErrMsg.description + ErrMsg);
//    }
}

function btnAddCode_onclick() {

    var FormList = new ListView();
    FormList.LoadFromID("lvinfolist");
    var pAprRow = FormList.GetSelectedRows();

    if (pAprRow.length == 0) {
        var pAlertContent = strLangS600;
        OpenAlertUI(pAlertContent);
        return;
    }
    
    var dup = false;
    var curSelGroupCode = GetAttribute(pAprRow[0], "DATA6");
    var curSelCode = GetAttribute(pAprRow[0], "DATA1");
    
    var frequencyList = new ListView();
    frequencyList.LoadFromID("lvinfofrequencylist");
    var frequencyRow = frequencyList.GetDataRows();
    for(var i = 0 ; i < frequencyRow.length;i++)
    {
        if (curSelCode == GetAttribute(frequencyRow[i],"DATA1")) {
            var pAlertContent = strLangS601;
            OpenAlertUI(pAlertContent);

            dup = true;
            break;

        }
    }
    if (dup == true)
        return;
    else
        InsMyGroupItem(curSelCode, curSelGroupCode);
}

function InsMyGroupItem(curSelCode, curSelGroupCode) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/setMyTaskCode.do",
		data : {
			cabinetID : curSelGroupCode,
			taskCode  : curSelCode,
			type      : "INS"
		},
		success: function(result){
			if (result == "OK") {
		        var pAlertContent = strLangS602;
		        OpenAlertUI(pAlertContent);

		        getMyGroupItem();
		    }
		},
		error : function() {
			var pAlertContent = strLangS604;
	        OpenAlertUI(pAlertContent);
		}
	});
}

function btnDelCode_onclick() {

    var frequencyList = new ListView();
    frequencyList.LoadFromID("lvinfofrequencylist");

    var pAprRow = frequencyList.GetSelectedRows();

    if (pAprRow.length == 0) {
        var pAlertContent = strLangS600;
        OpenAlertUI(pAlertContent);
        return;
    }

    var curSelCode = GetAttribute(pAprRow[0],"DATA1");
    var curSelGroupCode = GetAttribute(pAprRow[0],"DATA7");
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/setMyTaskCode.do",
		data : {
			cabinetID : curSelGroupCode,
			taskCode  : curSelCode,
			type      : "DEL"
		},
		success: function(result){
			if (result == "OK") {
		        var pAlertContent = strLangS603;
		        OpenAlertUI(pAlertContent);

		        getMyGroupItem();
		    }
		},
		error : function() {
			var pAlertContent = strLangS605;
	        OpenAlertUI(pAlertContent);
		}
	});
}
function getMyGroupItem()
{
    var result = "";
    
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getFrequencyClassList.do",
		success: function(xml){
			result = xml;
		}
	});
    try {
        var xmlDoc = loadXMLString(result);

        if (document.getElementById("infofrequencylist").innerHTML != "") document.getElementById("infofrequencylist").innerHTML = "";
        var FormList = new ListView();
        FormList.SetID("lvinfofrequencylist");
        FormList.SetMulSelectable(false);
        FormList.SetHeightFree(true);
        FormList.SetSelectFlag(false);
        FormList.SetRowOnClick("lvinfofrequencylist_onclick");
        FormList.DataSource(xmlDoc);
        FormList.DataBind("infofrequencylist");
        FormList = null;
        Draftinfoini = true;
       
    }
    catch (ErrMsg) {
    	showAlert(" Draftinfo_ini : " + ErrMsg.description + ErrMsg);
    }
}
function lvinfofrequencylist_onclick() {
    allUnSelect();

    var FrequencyFormList = new ListView();
    FrequencyFormList.LoadFromID("lvinfofrequencylist");
    var pSelectedRow = FrequencyFormList.GetSelectedRows();
    var pTaskCode, pTaskName, pTaskP, pTaskS, pTaskY, pCabinetID;
    pTaskCode = GetAttribute(pSelectedRow[0],"DATA1");
    pCabinetID = GetAttribute(pSelectedRow[0], "DATA7");
    pTaskName = GetAttribute(pSelectedRow[0],"DATA2");
    pTaskP = GetAttribute(pSelectedRow[0],"DATA3");
    pTaskS = pSelectedRow[0].cells[4].innerText;
    pTaskY = GetAttribute(pSelectedRow[0],"DATA5");
    var Cnt = 0;
    setNodeText(document.getElementById("tbitemCodeName"), "[" + pTaskCode + "]" + pTaskName);
    document.getElementById("cabinetID").value = pCabinetID;
    document.getElementById("tbItemCode").value = pTaskCode;
    document.getElementById("tbItemName").value = pTaskName
    document.getElementById("tbItemName2").value = pTaskName;

    for (Cnt = 0; Cnt < document.getElementsByName("RSecurity").length; Cnt++) {
        if (pTaskS == document.getElementsByName("RSecurity")[Cnt].getAttribute("value2")) {
            document.getElementsByName("RSecurity")[Cnt].checked = true; break;
        }
    }
    for (Cnt = 0; Cnt < document.getElementsByName("RKeeptype").length; Cnt++) {
        if (pTaskP == document.getElementsByName("RKeeptype")[Cnt].value) {
            document.getElementsByName("RKeeptype")[Cnt].checked = true; break;
        }
    }
    for (Cnt = 0; Cnt < document.getElementsByName("isPublic").length; Cnt++) {
        if (pTaskY == document.getElementsByName("isPublic")[Cnt].value) {
            document.getElementsByName("isPublic")[Cnt].checked = true; break;
        }
    }
    checkdocinfo = true;
}

function allUnSelectFrequency() {
    var FrequencyFormList = new ListView();
    FrequencyFormList.SetUnSelected("lvinfofrequencylist");

}

function allUnSelect() {
    var FormList = new ListView();
    FormList.SetUnSelected("lvinfolist");

}
function exceptionDocInfo()
{

    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();

    var objRoot, objNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "ROW");
    createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pOrgDocID);
    
    xmlhttp.open("POST", "/myoffice/ezApproval/ezLine/aspx/getexpaprdocinfo.aspx", false);
    xmlhttp.send(xmlpara);

    var ResultXML = loadXMLString(xmlhttp.responseText);

    if (ResultXML.getElementsByTagName("ITEMCODE").length > 0)
    {
        
        psecuritylevel = getNodeText(SelectNodes(ResultXML, "SECURITYCODE")[0]);
        pkeeperiod = getNodeText(SelectNodes(ResultXML, "STORAGEPERIOD")[0]);
        pPublicFlag = getNodeText(SelectNodes(ResultXML, "ISPUBLIC")[0]);

        pkeyword = getNodeText(SelectNodes(ResultXML, "KEYWORD")[0]);
        pItemName = getNodeText(SelectNodes(ResultXML, "ITEMNAME")[0]);
        pItemName2 = getNodeText(SelectNodes(ResultXML, "ITEMNAME2")[0]);
        pItemCode = getNodeText(SelectNodes(ResultXML, "ITEMCODE")[0]);

        var temptRSecurity = document.getElementsByName("RSecurity");
        var temptRKeeptype = document.getElementsByName("RKeeptype");
        var temptisPublic = document.getElementsByName("isPublic");

        for (Cnt = 0; Cnt < temptRSecurity.length; Cnt++) {
            if (psecuritylevel == temptRSecurity[Cnt].value) {
                temptRSecurity[Cnt].checked = true; break;
            }
        }
        
        for (Cnt = 0; Cnt < temptRKeeptype.length; Cnt++) {
            if (pkeeperiod == temptRKeeptype[Cnt].value) {
                temptRKeeptype[Cnt].checked = true; break;
            }
        }
        
        for (Cnt = 0; Cnt < temptisPublic.length; Cnt++) {
            if (pPublicFlag == temptisPublic[Cnt].value) {
                temptisPublic[Cnt].checked = true; break;
            }
        }
        
        setNodeText(document.getElementById("tbitemCodeName"),"[" + pItemCode + "]" + pItemName);
        document.getElementById("tbItemCode").value = pItemCode;
        document.getElementById("tbItemName").value = pItemName;
        document.getElementById("tbItemName2").value = pItemName2;
        document.getElementById("keyword").value = pkeyword;
    }
}