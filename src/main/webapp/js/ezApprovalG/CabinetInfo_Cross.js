function GetCabinetSimpleList(pDeptCode, pProduceYear, pTaskCode, pCabID, pFlag) {
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCabinetSimpleList.do",
		data : {
			processDeptCode   : pDeptCode,
			companyID         : CompanyID,
			produceYear 	  : pProduceYear,
			langType		  : UserLang,
			flag			  : pFlag,
			taskCode		  : pTaskCode
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var rtnXml = loadXMLString(result);

    var iSeledtedIdx = 0;
    if (result == "FALSE") {
        alert(strLang482);
    }
    else {
        if (document.getElementById("CabinetList").innerHTML != "") document.getElementById("CabinetList").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DivCabinetList");                               
        DocList.SetMulSelectable(false);                        
        DocList.SetRowOnDblClick("CabinetList_rowdblclick");      
        DocList.SetUrgentFlag(false);                                    
        DocList.DataSource(rtnXml);                             
        DocList.DataBind("CabinetList");                          	


        var Rows = DocList.GetDataRows();
        var len = DocList.GetRowCount();
        if (len > 0) {
            if (typeof (pCabID) != "undefined") {
                if (pCabID != "") {
                    iSeledtedIdx = GetSelIdxForCabinet(Rows, len, pCabID);
                }
            }
            selectRow("DivCabinetList", iSeledtedIdx);
        }

        DocList = null;

    }
}

function GetSelIdxForCabinet(Rows, len, pCabID) {
    var i;
    for (i = 0; i < len; i++) {
        if (trim_Cross(Rows[i].getAttribute("DATA1")) == pCabID)
            return i;
    }
    return 0;
}

function GetCabinetClassInfo(pCabID) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCabinetInfo.do",
		data : {
			cabinetID : pCabID,
			companyID : CompanyID,
			strType   : UserLang
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var dataNodes = GetChildNodes(loadXMLString(result));
    var rtnXml = getNodeText(dataNodes[0]);

    if (rtnXml == "FALSE") {
        alert(strLang483);
    }
    return result;
}

var addvolume_cross_dialogArguments = new Array();
var temppCabClassNo;
function NewVolume(pCabID, pCabClassNo, opentype, CompleteFunction) {
    var para = new Array();
    para[0] = pCabID;
    para[1] = pCabClassNo;

    var url = "/ezApprovalG/addVolume.do";

    if (CrossYN()) {
        addvolume_cross_dialogArguments[0] = para;
        if (CompleteFunction == undefined)
            addvolume_cross_dialogArguments[1] = NewVolume_Complete;
        else
            addvolume_cross_dialogArguments[1] = CompleteFunction;
        temppCabClassNo = pCabClassNo;

        if (opentype == "OPEN") {
            var OpenWin = window.open(url, "AddVolume_Cross", GetOpenWindowfeature(360, 310));
            try { OpenWin.focus(); } catch (e) { }
        }
        else
            DivPopUpShow(360, 310, url);
    }
    else {
        var feature = "dialogWidth:360px;dialogHeight:310px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
        feature = feature + GetShowModalPosition(360, 310);

        if (url != "")
            var rtn = window.showModalDialog(url, para, feature);

        if (rtn[0] == "TRUE")
            return AddNewVolume(pCabClassNo, rtn[1]);
        else
            return "FALSE";
    }
}

function NewVolume_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], AddNewVolume(temppCabClassNo, rtn[1]), "1");
    }
}

function AddNewVolume(pCabClassNo, pNewVolNo) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/addNewVolume.do",
		data : {
			cabClassNO : pCabClassNo,
			companyID  : CompanyID,
			newVolNO   : pNewVolNo
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var dataNodes = GetChildNodes(loadXMLString(result));
    var rtn = getNodeText(dataNodes[0]);

    if (rtn == "FALSE") {
        alert(strLang486);
    }
    return rtn;
}

function EndCabProduce(pCabClassNo, pExpYear, pFlag) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/endCabProduce.do",
		data : {
			companyID  : CompanyID,
			cabClassNO : pCabClassNo,
			expYear    : pExpYear,
			flag       : pFlag
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var dataNodes = GetChildNodes(loadXMLString(result));
    var rtn = getNodeText(dataNodes[0]);

    if (rtn != "TRUE")
        return false;
    else
        return true;
}