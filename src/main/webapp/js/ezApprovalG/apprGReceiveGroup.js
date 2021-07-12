function clickTab(e) {
    var clickTab = e.target;
    
    var currTab = document.querySelector("#tab .tabon");
    currTab.removeAttribute("class");
    clickTab.setAttribute("class", "tabon");

    document.querySelector("#" + currTab.getAttribute("divname")).style.display = "none";
    document.querySelector("#" + clickTab.getAttribute("divname")).style.display = "";
}

function initReceptOuter() {
    try {
        var xhr = new XMLHttpRequest();
        xhr.open("post", "/ezOrgan/getOrganTreeInfo.do");
        xhr.send();
        xhr.onload = function() {
            if (xhr.responseText == "Error") {
                return;
            }

            var treeView = new TreeView();
            treeView.SetID("tvTreeView2");
            treeView.SetUseAgency(true);
            treeView.SetUseSusinColor4AprG(true);
            treeView.SetRequestData("RequestDataG");
            treeView.SetNodeClick("TreeViewNodeClick");
            treeView.DataSource(xhr.responseXML);
            treeView.DataBind("TreeView2");
        }
    } catch (e) {
        alert("initReceptOuter :: " + e.description);
    }
}
function RequestDataG(pNodeID, pTreeID) {
    try {
        var TreeIdx = pNodeID;

        var treeNode = new TreeNode();
        treeNode.LoadFromID(TreeIdx);

        var xmlpara = createXmlDom();
        createNodeInsert(xmlpara, null, "PARA");
        createNodeAndInsertText(xmlpara, null, "DEPTID", treeNode.GetNodeData("DATA2"));

        var xhr = new XMLHttpRequest();
        xhr.open("post", "/ezOrgan/getOrganSubTreeInfo.do");
        xhr.send(xmlpara);
        xhr.onload = function() {
            var xmlRtn = loadXMLString(xhr.responseText);
    
            if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
            }
    
            var treeView = new TreeView();
            treeView.LoadFromID("tvTreeView2");
    
            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
        }
    } catch (e) {
        alert("RequestDataG :: " + e.description);
    }
}

function AprDeptOuterAdd_onclick() {
    if (isExistDept(false)) {
        var pAlertContent = "내부 수신자가 존재합니다.\n내부 수신자외 외부 수신자는 동시에 등록할 수 없습니다.";
        alert(pAlertContent);
        return;
    }

    var treeView = new TreeView();
    treeView.LoadFromID("tvTreeView2");
    var selectnode = treeView.GetSelectNode();
    if (!selectnode) {
        var pAlertContent = strLang584;
        alert(pAlertContent);
        return;
    }

    var ouDeptID = selectnode.GetNodeData("DATA1");
    var ouReceiveDocumentYN = selectnode.GetNodeData("DATA3");

    if (ouReceiveDocumentYN != "Y") {
        alert(strLang1104);
        return;
    }

    var duplicateFlag = DuplicateAprDeptCheck(ouDeptID);
    if (!duplicateFlag) {
        var pAlertContent = strLang247;
        alert(pAlertContent);
        return;
    }

    var ouDeptName = getOutDeptName(ouDeptID);
    AprLineAddOuDept(ouDeptID, ouDeptName);
}

function AprDeptOuterAddAll_onclick() {
    if (isExistDept(false)) {
        var pAlertContent = "내부 수신자가 존재합니다.\n내부 수신자외 외부 수신자는 동시에 등록할 수 없습니다.";
        alert(pAlertContent);
        return;
    }

    var treeView = new TreeView();
    treeView.LoadFromID("tvTreeView2");
    var selectnode = treeView.GetSelectNode();
    insertOuterAll(selectnode.GetNodeData("DATA1"), selectnode.GetNodeData("DATA2"), selectnode.GetNodeData("DATA3"));
}

function insertOuterAll(outerdeptid, outerdeptoupath, ouReceiveDocumentYN) {
    var result = "";
    var XmlDoc = null;

    try {
        var DuplicateFlag = DuplicateAprDeptCheck(outerdeptid);
        if (DuplicateFlag && ouReceiveDocumentYN == "Y") {
            var outerDeptName = getOutDeptName(outerdeptid);
            AprLineAddOuDept(outerdeptid, outerDeptName)
        }
        
        $.ajax({
            type : "POST",
            dataType : "text",
            async : false,
            url : "/ezOrgan/insertAllOrganSubTreeInfo.do",
            data : {
                deptID  : outerdeptoupath
            },
            success: function(text){
                result = text;
            }                   
        });

        XmlDoc = loadXMLString(result);
        var objNodes = SelectNodes(XmlDoc, "NODES/NODE");
        for (var i = 0; i < objNodes.length; i++) {
            insertOuterAll(objNodes[i].getElementsByTagName("DATA1")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("DATA2")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("DATA3")[0].childNodes[0].nodeValue);
        }

        return;
    } catch (e) {
        alert("insertOuterAll() :: " + e.description);
    }
}

function isExistDept(ExtFlag) {
    var rows = lvtDeptSelect.GetDataRows();
    var rtnVal = false;

    if (rows.length > 0) {
        if (ExtFlag) {
            rtnVal = GetAttribute(rows[0], "DATA7") == "Y";
        } else {
            rtnVal = GetAttribute(rows[0], "DATA7") == "N";
        }
    }
    
    return rtnVal;
}

function getOutDeptName(outDeptID) {
    var outDeptName = "";
    var oXmlDom = getExtLdapInfo_New(outDeptID);
    if (oXmlDom) {
        var ldapDeptInfo = "";
        var oSelNode = GetChildNodes(SelectNodes(oXmlDom, "ORGAN")[0]);
        if (oSelNode.length > 0) {
            if ((getNodeText(oSelNode[0]) == getNodeText(oSelNode[4])) || getNodeText(oSelNode[10]) == "Y") {
                if (getNodeText(oSelNode[8]) == "") {
                    ldapDeptInfo = getNodeText(oSelNode[2]) + strLang93;
                } else {
                    ldapDeptInfo = getNodeText(oSelNode[8]);
                }
            } else {
                var pSelNode; 
                var tempCode = getNodeText(oSelNode[5]);
                for (var i = 0; i < getNodeText(oSelNode[6]); i++) {
                    pSelNode = GetChildNodes(SelectNodes(getExtLdapInfo_New(tempCode), "ORGAN")[0]);
                    
                    if (pSelNode.length > 0) {
                        if (getNodeText(pSelNode[10]) == "Y") {
                            break;
                        } else {
                            tempCode = getNodeText(pSelNode[5]);
                        }
                    }
                }
                //상위 기관명
                if (getNodeText(pSelNode[8]) == "") {
                    ldapDeptInfo = getNodeText(pSelNode[2]) + strLang93;
                } else {
                    ldapDeptInfo = getNodeText(pSelNode[8]);
                }
                //문서를 수신받는 부서명 
                if (getNodeText(oSelNode[8]) == "") {
                    ldapDeptInfo = ldapDeptInfo + " (" + getNodeText(oSelNode[2]) + strLang93 + ")";
                } else {
                    ldapDeptInfo = ldapDeptInfo + " (" + getNodeText(oSelNode[8]) + ")";
                }
            }

            outDeptName = ldapDeptInfo;
        }
    }

    return outDeptName;
}

function getExtLdapInfo_New(OrganCode) {
    var result = "";

    if (!OrganCode) {
        return result;
    }
    
    try {
        $.ajax({
            type : "POST",
            dataType : "text",
            async : false,
            url : "/ezOrgan/getOrgInfo.do",
            data : {
                orgID : OrganCode
            },
            success: function(text) {
                result = text;
            }
        });

        return loadXMLString(result);
    } catch (e) {
        return result;
    }
}

function AprLineAddOuDept(deptID, deptName) {
    var param = new FormData();
    param.append("node1", p_groupid);
    param.append("node2", deptID);
    param.append("node3", deptName);
    param.append("node4", document.getElementById("SCompID").value);
    param.append("node6", deptName);
    param.append("node7", "Y");

    var xhr = new XMLHttpRequest();
    xhr.open("post", "/admin/ezApprovalG/setGroupSubItemInfo.do", false);
    xhr.send(param);

    if(p_groupid == "9999") {
        getDeptRejectList();
    } else {
        getAdminReceivItem(p_groupid);
    }
}