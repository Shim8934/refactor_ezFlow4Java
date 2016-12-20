function CheckDateInput() {
    if (selYear.value == "" || selMonth.value == "" || selDay.value == "") {
        alert(strLang424);
        return false;
    }
    else {
        return true;
    }
}

function CheckSpecialInfo() {
    if (rdoSpecialFlag[1].checked || rdoSpecialFlag[2].checked)
    {
        if (txtList1.value == "" && txtList2.value == "" && txtList3.value == "") {
            alert(strLang426);
            return false;
        }
        else if (txtList1.value == "") {
            alert(strLang427);
            return false;
        }
        else if (txtList2.value == "" && txtList3.value != "") {
            alert(strLang428);
            return false;
        }
    }
    return true;
}

function InitDateToCurrent() {
    var curDate = new Date();
    var iMonth = curDate.getMonth() + 1;

    SelectOption(selYear, curDate.getFullYear().toString());
    SelectOption(selMonth, iMonth.toString());
    SelectOption(selDay, curDate.getDate().toString());
}

function TaskRequest(DataXml, pFlag, ApplyDate, TaskCode, TaskName) {
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
    var objRoot = xmlpara.createNode(1, "PARAMETERS", "");	
    xmlpara.appendChild(objRoot);
    xmlpara.documentElement.appendChild(DataXml.documentElement);

    var objNode = xmlpara.createNode(1, "FLAG", "");
    objNode.text = pFlag;
    xmlpara.documentElement.appendChild(objNode);

    var objNode = xmlpara.createNode(1, "DEPTCODE", "");	
    objNode.text = DeptID;
    xmlpara.documentElement.appendChild(objNode);

    var objNode = xmlpara.createNode(1, "COMPANYID", "");	
    objNode.text = CompanyID;
    xmlpara.documentElement.appendChild(objNode);

    var objNode = xmlpara.createNode(1, "APPLYDATE", "");
    objNode.text = ApplyDate;
    xmlpara.documentElement.appendChild(objNode);

    var objNode = xmlpara.createNode(1, "TASKCODE", "");
    objNode.text = TaskCode;
    xmlpara.documentElement.appendChild(objNode);

    var objNode = xmlpara.createNode(1, "TASKNAME", "");
    objNode.text = TaskName;
    xmlpara.documentElement.appendChild(objNode);

    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/Manage/aspx/API_TaskRequest.aspx", false);
    xmlhttp.send(xmlpara);

    var rtnXml = xmlhttp.responseXML;
    try {
        if (rtnXml.documentElement.selectSingleNode("ERRCODE").text == "00000") {
            alert(strLang433);
            return true;
        }
        else {
            alert(strLang434);
            return false;
        }
    } catch (e) {
        alert(strLang435);
        return false;
    }
}

function GetTaskInfo() {
    if (TaskCode != "") {
        if (TaskCode.substring(0, 2).toLowerCase() == "zz")
            DeptID = "";
    }
    var tempRet = "";
    $.ajax({
    	type : "POST",
    	url : "/admin/ezApprovalG/getTaskInfo.do",
    	async : false,
    	data : {taskCode : TaskCode, deptCode : DeptID, companyID : CompanyID},
    	success : function(result) {
    		tempRet = result;
    	}
    });
    
    return tempRet;
    /*var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETERS");
    var objNode = createNodeAndInsertText(xmlpara, objRoot, "TASKCODE", TaskCode);
    objNode = createNodeAndInsertText(xmlpara, objRoot, "DEPTCODE", DeptID);
    objNode = createNodeAndInsertText(xmlpara, objRoot, "COMPANYID", CompanyID);
    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_GetTaskInfo.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseXML;*/
}
