﻿﻿var arrySubTab = new Array(0, 9, 4, 3, 4);
var subTabLastCol = 1;

function GetDocList(p_FormCd) {
    DocListType = "GetDocSearch";

    var pDocstate = "000";
    if (contFlag == "END")
        pDocstate = "001";
    else
        pDocstate = "011";

    if (pChackYN == "FALSE" || SelYearFlag) {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
        OrderOption = "";
        OrderCell = "";
    }

    if (approvalFlag == 'S') {
    	document.getElementById("tbtnRemoveDoc").style.display = "none";
	}
    
    var objNode, i, nodeName
    var xmlpara = createXmlDom();
    createNodeInsert(xmlpara, objNode, "PARAMETER");

    for (i = 0; i < condition.length - 1 ; i++) {
        if (typeof(condition[i]) == "undefined")
            createNodeAndInsertText(xmlpara, objNode, "Param" + i, "");
        else
            createNodeAndInsertText(xmlpara, objNode, "Param" + i, condition[i]);
    }
    if (typeof(ContainerID) == "undefined") {
    	createNodeAndInsertText(xmlpara, objNode, "Param24", "");
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "Param24", ContainerID);
    }


    createNodeAndInsertText(xmlpara, objNode, "Param25", UserID);   	        
    createNodeAndInsertText(xmlpara, objNode, "Param26", arr_userinfo[4]);  	
    createNodeAndInsertText(xmlpara, objNode, "Param27", "DETAIL");             
    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);              
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);            
    createNodeAndInsertText(xmlpara, objNode, "DocState", "");

    if (subCondition == "")
        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", condition[condition.length - 1]);
    else if (condition[condition.length - 1] == "")
        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition);
    else
        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition + " AND " + condition[condition.length - 1]);

    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    if (GamSaFlag)
        xmlhttp.open("POST", "/ezApprovalG/getGamSaSearchDocList.do", false);
    else
        xmlhttp.open("POST", "/ezApprovalG/getFormSearchDocList.do", true);

    xmlhttp.onreadystatechange = getDocList_after;
    xmlhttp.send(xmlpara);
    //document.getElementById("listcount").innerHTML = strLang788 + "";
}


function getDocList_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        Resultxml = xmlhttp.responseXML;

        if (xmlhttp.responseText != "") {
            ListViewNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
            NodeList = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
            NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");
            NodeListLen = 0;
            
            if (NodeList2 != null) {
                var cnt = getNodeText(NodeList2);
                if (cnt != "") {
                    NodeListLen = cnt;
                }
                else
                    NodeListLen = 0;
            }

            var xmlDoc;
            if (CrossYN()) {
                var xmlLIST = createXmlDom();
                var nodeToImport = xmlLIST.importNode(ListViewNode, true);
                xmlLIST.appendChild(nodeToImport);

                xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
            }
            else {
                xmlDoc = createXmlDom();
                xmlDoc.appendChild(ListViewNode);
            }

            ListViewNode = xmlDoc;

            var preDocList = new ListView();
            preDocList.LoadFromID('DocList');
            var preSelectedRow = preDocList.GetSelectedRows();

            if (NodeListLen > 10) {
                paging(curpage, nowblock, selRowChangeFlag, preSelectedRow);
            }
            else {
                if (document.getElementById("lvtDoclist").innerHTML != "")
                    document.getElementById("lvtDoclist").innerHTML = "";

                var DocList = new ListView();      
                DocList.SetID("DocList");                               
                DocList.SetMulSelectable(false);                        
                DocList.SetHeaderOnClick("lvDocList_HeaderClick");      
                DocList.SetRowOnClick("lvtDoclist_SelChange");           
                DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
                DocList.SetUrgentFlag(true);                            
                DocList.SetSecurityFlag(true);                           
                DocList.DataSource(ListViewNode);                             
                DocList.DataBind("lvtDoclist");
                if (selRowChangeFlag && preSelectedRow.length > 0) {
                    // 탭 이동 시 전 탭에서 선택된 row 선택되지 않도록 flag값 변경
                    selRowChangeFlag = false;
                    DocList.SetSelectedID(preSelectedRow[0].getAttribute('id'));
                }
                DocList = null;


                pagingCount(curpage, nowblock);
                selFirstRow(Resultxml);

            }

            //DisplayLineCnt(Resultxml, "1");

            pChackYN = "FALSE";
            makePageSelPage();
            if (USE_OCS == "YES")
                check_presence2();
        }

    }
    catch (e) { }
}

function DisplayLineCnt(Resultxml, viewtype) {
    var deptName;

    deptName = arr_userinfo[5];

    if (viewtype == "1") {
        if (GamSaFlag)
            document.getElementById("listcount").innerHTML = strLang789 + "<span class='point'>" + NodeListLen + "</span> " + strLang445;
        else
            document.getElementById("listcount").innerHTML = "<b>" + deptName + "</b> " + strLang790 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else
        document.getElementById("listcount").innerHTML = strLang791 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
}

function GetDocSearch() {
    DocListType = "GetDocSearch";

    var pDocstate = "000";
    if (contFlag == "END")
        pDocstate = "001";
    else
        pDocstate = "011";

    if (pChackYN == "FALSE" || SelYearFlag)
    {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
        OrderOption = "";
        OrderCell = "";
    }

    var objNode, i, nodeName
    var xmlpara = createXmlDom();
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    
    if (approvalFlag == 'S') {
    	document.getElementById("tbtnRemoveDoc").style.display = "none";
    	for (i = 0; i < 12 ; i++) {
            if (typeof (condition[i]) == "undefined") {
                createNodeAndInsertText(xmlpara, objNode, "Param" + i, "");
            } else {
                createNodeAndInsertText(xmlpara, objNode, "Param" + i, condition[i]);
            }
        }
        
        if (typeof (ContainerID) == "undefined")
            createNodeAndInsertText(xmlpara, objNode, "Param12", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "Param12", ContainerID);

        createNodeAndInsertText(xmlpara, objNode, "Param13", UserID);
        createNodeAndInsertText(xmlpara, objNode, "Param14", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "Param15", "DETAIL");
        createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);
        createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
        createNodeAndInsertText(xmlpara, objNode, "DocState", "");
        
        /* 2021-02-01 홍승비 - 개인문서함 > 문서함검색의 경우 '상태'값이 없으므로 undefined & null 처리 추가 */
        var searchStatus = $("#sel_status option:selected").val();
        if (typeof(searchStatus) == "undefined" || searchStatus == null) {
        	searchStatus = "ALL";
        }
        createNodeAndInsertText(xmlpara, objNode, "searchStatus", searchStatus);
        
        createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
        createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);

        // 2021-03-16 박기범 - 키워드 추가
        // if (typeof (condition[24]) != "undefined" && (condition[24].indexOf("KAPR;") === 0 || condition[24].indexOf("KEND;") === 0)) {
        //     if (condition[24].indexOf("KAPR;") === 0) {
        //         SQLPARADATA = SQLPARADATA.substring(0, SQLPARADATA.indexOf("<TYPE>")+6) + "KAPR;" + SQLPARADATA.substring(SQLPARADATA.indexOf("<TYPE>")+6);
        //     } else if (condition[24].indexOf("KEND;") === 0) {
        //         SQLPARADATA = SQLPARADATA.substring(0, SQLPARADATA.indexOf("<TYPE>")+6) + "KEND;" + SQLPARADATA.substring(SQLPARADATA.indexOf("<TYPE>")+6);
        //     }
        //     SQLPARADATA = SQLPARADATA.substring(0, SQLPARADATA.indexOf("<DATA>")+6) + "<KEYWORD>" + condition[24].substring(5) + "</KEYWORD>" + SQLPARADATA.substring(SQLPARADATA.indexOf("<DATA>")+6);
        // }

        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition);
        
        createNodeAndInsertText(xmlpara, objNode, "SearchQuery", SQLPARADATA);
        createNodeAndInsertText(xmlpara, objNode, "shareDeptId", shareDeptId);

        listLoading(true);

	    if (GamSaFlag){
	    	xmlhttp.open("POST", "/ezApprovalG/getGamSaSearchDocList.do", false);
	    } else {
	    	xmlhttp.open("POST", "/ezApprovalG/getFormSearchDocListS.do", true);
	    }
	    xmlhttp.onreadystatechange = getsearchDocListS_after;		
	    xmlhttp.send(xmlpara);
	    
	    listLoading(false);
	} else {
        for (i = 0; i < condition.length - 1 ; i++) {
	        if (typeof(condition[i]) == "undefined") {
                createNodeAndInsertText(xmlpara, objNode, "Param" + i, "");
            } else {
                createNodeAndInsertText(xmlpara, objNode, "Param" + i, condition[i]);
            }
	    }
	    if (typeof(ContainerID) == "undefined") {
	    	createNodeAndInsertText(xmlpara, objNode, "Param24", "");
	    } else {
	    	createNodeAndInsertText(xmlpara, objNode, "Param24", ContainerID);
	    }
	    createNodeAndInsertText(xmlpara, objNode, "Param25", UserID);   	        
	    createNodeAndInsertText(xmlpara, objNode, "Param26", arr_userinfo[4]);  	
	    createNodeAndInsertText(xmlpara, objNode, "Param27", "DETAIL");             
	    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);              
	    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);            
	    createNodeAndInsertText(xmlpara, objNode, "DocState", "");

	    if (subCondition == "")
	        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", condition[condition.length - 1]);
	    else if (condition[condition.length - 1] == "")
	        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition);
	    else
	        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition + " AND " + condition[condition.length - 1]);

	    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
	    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);

        listLoading(true);

	    if (GamSaFlag){
	    	xmlhttp.open("POST", "/ezApprovalG/getGamSaSearchDocList.do", false);
	    } else {
	    	xmlhttp.open("POST", "/ezApprovalG/getFormSearchDocList.do", false);
	    }
	    xmlhttp.onreadystatechange = getsearchDocList_after;		
	    xmlhttp.send(xmlpara);
		
		listLoading(false);
	}

    //ShowMailProgress();
    //document.getElementById("listcount").innerHTML = "<b><font color='#e67802'>" + strLang796 + "</font></b>";
}

function GetUserContList() {
    xmlDocListHttp = createXMLHttpRequest();
    DocListType = "UserContDocList";
    if (pChackYN == "FALSE") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
        OrderOption = "";
        OrderCell = "";
    }
    document.getElementById("tbtnRemoveDoc").style.display = "";

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "ID", ContainerID);
    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "SearchQuery", SQLPARADATA);
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition);

    xmlDocListHttp.open("POST", "/ezApprovalG/getUserContList.do", true);
    xmlDocListHttp.onreadystatechange = getDocListS_after;
    xmlDocListHttp.send(xmlpara);
}

function GetUserContListSave(AllFG) {
    xmlDocListHttp = createXMLHttpRequest();
    DocListType = "UserContDocList";
    
    /* 2024-05-31 홍승비 - 개인문서함 리스트 표출 후 getDocListS_after 함수에서 반드시 pChackYN값이 "FALSE"로 설정됨 > 엑셀파일 내보내기 시 정렬 초기화되지 않도록 수정  */
    if (pChackYN == "FALSE") {
        nowblock = 0;
        totalPage = 0;
        //OrderOption = "";
        //OrderCell = "";
    }
    // document.getElementById("tbtnRemoveDoc").style.display = "";

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "ID", ContainerID);
    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "SearchQuery", SQLPARADATA);
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition);
    createNodeAndInsertText(xmlpara, objNode, "AllFG", AllFG);
    
    xmlDocListHttp.open("post", "/ezApprovalG/getUserContListSave.do", true);
    xmlDocListHttp.responseType='blob';
    xmlDocListHttp.send(xmlpara);
    xmlDocListHttp.onload = function(e) {
        if (this.status == 200) {
            // Create a new Blob object using the 
            //response data of the onload object
            var blob = new Blob([this.response] ,{ type: "application/vnd.ms-excel" });
            //Create a link element, hide it, direct 
            //it towards the blob, and then 'click' it programatically
            var a = document.createElement("a");
            a.setAttribute("type", "hidden");
            //Create a DOMString representing the blob 
            //and point the link element towards it
            var ua = window.navigator.userAgent;
            if(ua.indexOf('MSIE') > 0 || ua.indexOf('Trident') > 0) {
            	navigator.msSaveOrOpenBlob(blob,excelFileName+'.xls');
            } else {
	            var url = window.URL.createObjectURL(blob);
	            a.href = url;
	            a.download = excelFileName+'.xls';
	            document.body.appendChild(a);
	            //programatically click the link to trigger the download
	            a.click();
	            //release the reference to the file by revoking the Object URL
	            window.URL.revokeObjectURL(url);
            }
        } else {
            //deal with your error state here
        }
    };
}

function getDocListS_after() {

    if (xmlDocListHttp == null || xmlDocListHttp.readyState != 4) return;
    try {

        hideProgress();
        Resultxml = loadXMLString(xmlDocListHttp.responseText);

        if (Resultxml.xml == "") return;


        ListViewNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
        NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");

        NodeListLen = 0;

        if (NodeList2 != null) {
            var dataNode = getNodeText(NodeList2);

            if (dataNode != "")
                NodeListLen = dataNode;
            else
                NodeListLen = 0;
        }

        if (NodeListLen > 10) {
            paging(curpage, nowblock);
        }
        else {

            if (document.getElementById("lvtDoclist").innerHTML != "")
                document.getElementById("lvtDoclist").innerHTML = "";

            var DocList = new ListView();
            DocList.SetID("DocList");
            DocList.SetMulSelectable(true);
            DocList.SetHeaderOnClick("lvDocList_HeaderClick");
            DocList.SetRowOnClick("lvtDoclist_SelChange");
            DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");
            DocList.SetUrgentFlag(false);
            DocList.DataSource(ListViewNode);
            DocList.DataBind("lvtDoclist");
            DocList = null;

            pagingCount(curpage, nowblock);
            selFirstRow(Resultxml);
        }
        pChackYN = "FALSE";
//        if (USE_OCS == "YES")
//            check_presence_DocList();

        makePageSelPage();
        xmlDocListHttp = null;

    } catch (e) { }

}

function btnRemoveDoc_onclick() {
    if (DocListType != "UserContDocList" && DocListType != "DeptContDocList")
        return;

    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    var orgCompanyID = "";

    if (tr.length <= 0) {
        var InformationString = strLangS385;
        //2018-09-19 김보미 - 알럿창으로 변경
//        OpenAlertUI(InformationString);
        showAlert(InformationString);
        return;
    } else {
	    var OpinionContent = strLangS387;
//	    var rtn = OpenInformationUI(OpinionContent, RemoveDoc_Complete, "OPEN");
	     showConfirm(OpinionContent, RemoveDoc_Complete);
//	    if (rtn) {
//	        RemoveDoc_Complete(rtn);
//	    }
    }
}

function RemoveDoc_Complete(RtnVal)
{
	hideConfirm();
    if (!RtnVal)
        return;

    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();

    for (i = 0; i < selRow.length; i++) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        var tr = selRow[i];
        
        var orgCompanyID = tr.getAttribute("ORGCOMPANYID");

        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DocID", GetAttribute(tr, "DATA1"));
        createNodeAndInsertText(xmlpara, objNode, "ContID", ContainerID);
        createNodeAndInsertText(xmlpara, objNode, "orgCompanyID", orgCompanyID);

        if (DocListType == "UserContDocList")
            xmlhttp.open("POST", "/ezApprovalG/delUserContDoc.do", false);
        else
            xmlhttp.open("POST", "/ezApprovalG/delDeptContDoc.do", false);
        xmlhttp.send(xmlpara);
    }
     	
    var InformationString = strLang802;
    showAlertUI(InformationString, RemoveDoc_Complete_afterAlert);
}
function RemoveDoc_Complete_afterAlert(){
	DivPopUpHidden();
    if (DocListType == "UserContDocList") {
    	GetUserContList();
    } else if (DocListType == "DeptContDocList"){
        GetDeptContList();
    } else {
    	showAlert(strLang803); 
    }	
}

function getsearchDocList_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;

    try {
    	Resultxml = xmlhttp.responseXML;

        if (Resultxml.xml != "") {
            SelYearFlag = false;
            ListViewNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
            NodeList = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
            NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");
            Haders = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/HEADERS/HEADER");
            NodeListLen = 0;

            
            if (NodeList2 != null) {
                var cnt = getNodeText(NodeList2);
                if (cnt != "")
                    NodeListLen = cnt;
                else
                    NodeListLen = 0;
            }

            var xmlDoc;
            if (CrossYN()) {
                var xmlLIST = createXmlDom();
                var nodeToImport = xmlLIST.importNode(ListViewNode, true);
                xmlLIST.appendChild(nodeToImport);

                xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
            }
            else {
                xmlDoc = createXmlDom();
                xmlDoc.appendChild(ListViewNode);
            }

            ListViewNode = xmlDoc;

            if (NodeListLen > 10) {

                paging(curpage, nowblock);
            }
            else {
                if (document.getElementById("lvtDoclist").innerHTML != "")
                    document.getElementById("lvtDoclist").innerHTML = "";

                var DocList = new ListView();      
                DocList.SetID("DocList");                               
                DocList.SetMulSelectable(false);                        
                DocList.SetHeaderOnClick("lvDocList_HeaderClick");      
                DocList.SetRowOnClick("lvtDoclist_SelChange");           
                DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
                DocList.SetUrgentFlag(true);                            
                DocList.SetSecurityFlag(true);                           
                DocList.DataSource(ListViewNode);                             
                DocList.DataBind("lvtDoclist");                          
                DocList = null;

                pagingCount(curpage, nowblock);
                selFirstRow(Resultxml);
            }

            //DisplayLineCnt(Resultxml, "2");
            makePageSelPage();
            pChackYN = "FALSE";
        }
        else {
            prompt(xmlhttp.responseText, xmlhttp.responseText);
        }
        HiddenMailProgress();
    }
    catch (e) { 
        console.log(e);
    }
}

function getsearchDocListS_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;

    try {
        hideProgress();
        
        Resultxml = xmlhttp.responseXML;

        if (Resultxml.xml != "") {

            SelYearFlag = false;
            ListViewNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
            NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");
            NodeListLen = 0;
            if (NodeList2 != null) {
                var dataNode = getNodeText(NodeList2);

                if (dataNode != "")
                    NodeListLen = dataNode;
                else
                    NodeListLen = 0;
            }
            var preDocList = new ListView();
            preDocList.LoadFromID('DocList');
            var preSelectedRow = preDocList.GetSelectedRows();

            if (NodeListLen > 10) {
                paging(curpage, nowblock, selRowChangeFlag, preSelectedRow);
            }
            else {
                if (document.getElementById("lvtDoclist").innerHTML != "")
                    document.getElementById("lvtDoclist").innerHTML = "";

                var DocList = new ListView();
                DocList.SetID("DocList");
                DocList.SetMulSelectable(true);
                DocList.SetHeaderOnClick("lvDocList_HeaderClick");
                DocList.SetRowOnClick("lvtDoclist_SelChange");
                DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");
                DocList.SetTitleIdx(0);
                DocList.SetUrgentFlag(false);
                DocList.DataSource(ListViewNode);
                DocList.DataBind("lvtDoclist");
                if (selRowChangeFlag && preSelectedRow.length > 0) {
                    // 탭 이동 시 전 탭에서 선택된 row 선택되지 않도록 flag값 변경
                    selRowChangeFlag = false;
                    DocList.SetSelectedID(preSelectedRow[0].getAttribute('id'));
                }
                DocList = null;

                pagingCount(curpage, nowblock);
                selFirstRow(Resultxml);
            }
            if (USE_OCS == "YES")
                check_presence_DocList();

            pChackYN = "FALSE"

            makePageSelPage();
        }        
    }
    catch (e) { }
}

function selFirstRow(Resultxml) {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];

    if (oArrRows.length != 0) {
    	if (!!document.getElementById("tbtnExcel")) {
    		document.getElementById("tbtnExcel").style.display = "";
    	}
    	if (!!document.getElementById("tbtnExcelAll")) {
    		document.getElementById("tbtnExcelAll").style.display = "";
    	}
        DocID = tr.getAttribute("DATA1");
        pURL = tr.getAttribute("DATA2");
        WriterID = tr.getAttribute("DATA3");
        orgCompanyID = tr.getAttribute("ORGCOMPANYID");
        
        if (approvalFlag == "S") {
        	DocType = GetAttribute(tr, "DATA9");
            DocState = GetAttribute(tr, "DATA12");
            
            if (DocType == strDocType4) {
                document.getElementById("tenforce").style.display = "none";
                document.getElementById("tresend").style.display = "none";
            }

            if (DocState != strDocState1) {
	        	document.getElementById("tsendCir").style.display = "none";
	        } else {
	        	document.getElementById("tsendCir").style.display = "";
	        }
            
            if (DocState == strDocState31) {
                document.getElementById("tenforce").style.display = "none";
            }

            var CheckContainerType = CheckResend(DocID);

            var pExt = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
            if (CheckContainerType == "610") {
                if (pExt == "hwp" || pExt == "doc") {
                    document.getElementById("tresend").style.display = "none";
                } else {
                    if (DocType == strDocType4) {
                        document.getElementById("tresend").style.display = "none";
                    }
                    else {
                        document.getElementById("tresend").style.display = "";
                    }
                }
            } else {
                document.getElementById("tresend").style.display = "none";
            }
        }
        
        if (!!document.getElementById("tSearchCondi")) {
        	document.getElementById("tSearchCondi").style.display = "";
        }
        
        if (!!document.getElementById("tViewDoc")) {
        	document.getElementById("tViewDoc").style.display = "";
        }
        //if((share || share == 'share') || DocListType == "UserContDocList"){
        //	document.getElementById("tbtnExcel").style.display = "none";
        //	document.getElementById("tbtnExcelAll").style.display = "none";
        //	document.getElementById("tbtnRegUserCont").style.display = "none";
        //	document.getElementById("tenforce").style.display = "none";
        //    document.getElementById("tresend").style.display = "none";
        //    document.getElementById("tbtnSelContainer").style.display = "none";
        //}

        /* 2024-12-17 홍승비 - 전자결재G > 결재완료문서 리스트 상에서 선택 > 현재 선택한 문서의 ORGDOCID가 존재하지 않더라도 공람정보 버튼을 표출하도록 수정 */
    	// ORGDOCID가 존재하는 문서(수신문 등) 선택 시에만 공람정보 버튼이 표출되는 오류 수정 (현재 선택한 문서의 DOCID로 공람문서가 존재하는지 여부는 getInnerLineInfo 쿼리에서 체크함)
        if (approvalFlag == "G") {
        	if (!!document.getElementById("tDocInfo")) {
        		document.getElementById("tDocInfo").style.display = "";
        	}
        }
    }
    else {
        DocID = "";
        pURL = "";
        
        if (!!document.getElementById("tSearchCondi")) {
        	document.getElementById("tSearchCondi").style.display = "";
        }
        
        if (!!document.getElementById("tViewDoc")) {
        	document.getElementById("tViewDoc").style.display = "none";
        }
        
        if (!!document.getElementById("tbtnExcel")) {
        	document.getElementById("tbtnExcel").style.display = "none";
        }
        
        if (!!document.getElementById("tbtnExcelAll")) {
        	document.getElementById("tbtnExcelAll").style.display = "none";
        }
        if (approvalFlag == "G" && !!document.getElementById("tDocInfo")) {
        	document.getElementById("tDocInfo").style.display = "none";
        }
        
        if(DocListType == "UserContDocList"){
        	if (!!document.getElementById("tbtnExcel")) {
        		document.getElementById("tbtnExcel").style.display = "none";
        	}
        	
        	if (!!document.getElementById("tbtnExcelAll")) {
        		document.getElementById("tbtnExcelAll").style.display = "none";
        	}
        	
        	if (!!document.getElementById("tbtnRegUserCont")) {
        		document.getElementById("tbtnRegUserCont").style.display = "none";
        	}
        	
        	if (!!document.getElementById("tenforce")) {
        		document.getElementById("tenforce").style.display = "none";
        	}
        	
        	if (!!document.getElementById("tresend")) {
        		document.getElementById("tresend").style.display = "none";
        	}
        	
        	if (!!document.getElementById("tbtnSelContainer")) {
        		document.getElementById("tbtnSelContainer").style.display = "none";
        	}
        }
    }

    switch (jobState) {
        case "ATTACH":
            Attach_onclick();
            break;

        case "OPINION":
            Opinion_onclick();
            break;

        case "APPROVAL":
            Approval_onclick();
            break;

        case "RECIPENT":
            Recipent_onclick();
            break;
            
        case "CIRCUL":
        	Circulation_onclick();
        	break;
    }
    
    /* 2022-07-04 홍승비 - 결재완료문서가 존재하는 경우 */
    if ($("#PreviewRayerH").length && $("#PreviewRayerH").css("display") != "none") {
    // 2023-06-30 전인하 - 전자결재G > 기록물대장 미리보기 - 미리보기 레이어 팝업 호출 메소드를 타입에 따라 나눔
        if (typeof cabinetPreviewItemFlagArr != 'undefined' && typeof g_sFlag != 'undefined' && cabinetPreviewItemFlagArr.includes(g_sFlag)) {
            PreviewRayerChange("H", 'Cabinet'); // 기록물
        } else {
            PreviewRayerChange("H", 'Container'); // 완료문서
        }
    	if (CrossYN()) {
    		if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
        		ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = strLang930;	        			
    		}
        } else {
        	if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
            	ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLang930;		            		
        	}
        }
    } else if ($("#PreviewRayerH").length) {
        // 2023-07-13 전인하 - 전자결재 > 문서 미리보기 > 미리보기영역 사용하지 않는 메뉴일 경우 미리보기창을 닫는 것이 아니라 프리뷰 레이어 영역을 display: none 처리함
        $("#PreviewRayerH").css("display", "none");
    }
}

function getDataInfo() {
	var pUrl = "";

    var DocList = new ListView();
    DocList.LoadFromID("DocList");

    var selectedRows = DocList.GetSelectedRows();
    
    if(selectedRows.length > 0) {
    	var tr = selectedRows[0];

        if (tr.getAttribute("DATA10") != "" && tr.getAttribute("DATA10") >= GetTodayDate()) {
            if (CheckAprLine(tr.getAttribute("DATA1")) != "TRUE") {
                getdoclistSub_after("NOTPERMISSION");
                return;
            }
        }
    }
	
    switch (jobState) {
        case "ATTACH":
        	pUrl = "/ezApprovalG/getTotalAttachInfo.do";
            break;

        case "OPINION":
        	pUrl = "/ezApprovalG/getOpinionInfo.do";
            break;

        case "APPROVAL":
        	pUrl = "/ezApprovalG/getLineList.do";
            break;

        case "RECIPENT":
        	pUrl = "/ezApprovalG/getReceiptinfo.do";
            break;
            
        case "CIRCUL":
        	pUrl = "/ezApprovalG/getCirculationinfo.do";
        	break;
    }

    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : pUrl,
		data : {
				docID : DocID,
				mode  : "END",
				orgCompanyID : orgCompanyID
				},
		success: function(xml){
			getdoclistSub_after(xml);
		}        			
	});
}

function getdoclistSub_after(xml) {
    try {
        if (document.getElementById("lvtDetail").innerHTML != "")
            document.getElementById("lvtDetail").innerHTML = "";

        if (xml == "NOTPERMISSION") {
            document.getElementById("lvtDetail").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
            document.getElementById("lvtDetail").style.textAlign = "center";
            return;
        }
        
        Resultxml = loadXMLString(xml);

        var DocList = new ListView();      
        DocList.SetID("SubDocList");                               
        DocList.SetMulSelectable(false);                     
//        DocList.SetTitleIdx(arrySubTab[pDocInfoValue]);
        DocList.SetRowOnDblClick("lvtDetail_onSel_DBclick");      
        DocList.DataSource(Resultxml);
        DocList.DataBind("lvtDetail");

        if (USE_OCS == "YES" && jobState == "APPROVAL") {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                setTimeout(check_presence, 100);
            }
            else {
                check_presence();
            }
        }
    }
    catch (e) { }
}

var oArrRowsid = "";
function lvtDoclist_SelChange() {
    var SelList = new ListView();
    SelList.LoadFromID("DocList");
    var oArrRows = SelList.GetSelectedRows();
    ext = oArrRows[0].getAttribute("DATA3").substr(oArrRows[0].getAttribute("DATA3").lastIndexOf(".")+1);

    if (oArrRows.length != 0) {
        var tr = oArrRows[0];
        oArrRowsid = tr.id;
        
        /* 2024-12-17 홍승비 - 전자결재G > 결재완료문서 리스트 상에서 선택 > 현재 선택한 문서의 ORGDOCID가 존재하지 않더라도 공람정보 버튼을 표출하도록 수정 */
    	// ORGDOCID가 존재하는 문서(수신문 등) 선택 시에만 공람정보 버튼이 표출되는 오류 수정 (현재 선택한 문서의 DOCID로 공람문서가 존재하는지 여부는 getInnerLineInfo 쿼리에서 체크함)
        if (approvalFlag == "G") {
			if (!!document.getElementById("tDocInfo")) {
				document.getElementById("tDocInfo").style.display = "";
			}
        }
        
        DocID = tr.getAttribute("DATA1");
        pURL = tr.getAttribute("DATA2");
        WriterID = tr.getAttribute("DATA3");
        orgCompanyID =  tr.getAttribute("ORGCOMPANYID");
        if (approvalFlag == "S") {
        	DocType = GetAttribute(tr, "DATA9");
            DocState = GetAttribute(tr, "DATA12");

	        if (DocType == strDocType4) {
	            document.getElementById("tenforce").style.display = "none";
	            document.getElementById("tresend").style.display = "none";
	        } else {
	            document.getElementById("tenforce").style.display = "";
	            document.getElementById("tresend").style.display = "";
	        }
	        
	        if (DocState != strDocState1) {
	        	document.getElementById("tsendCir").style.display = "none";
	        } else {
	        	document.getElementById("tsendCir").style.display = "";
	        }
	
	        if (DocState == strDocState31) {
	            document.getElementById("tenforce").style.display = "none";
	        }
	
	        var CheckContainerType = CheckResend(DocID);
	
	        var pExt = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
	        if (CheckContainerType == "610") {
	            if (pExt == "hwp" || pExt == "doc") {
	                document.getElementById("tresend").style.display = "none";
	            } else {
	                if (DocType == strDocType4) {
	                    document.getElementById("tresend").style.display = "none";
	                }
	                else {
	                    document.getElementById("tresend").style.display = "";
	                }
	            }
	        } else {
	            document.getElementById("tresend").style.display = "none";
	        }
        }
        switch (jobState) {
            case "ATTACH":
                Attach_onclick();
                break;

            case "OPINION":
                Opinion_onclick();
                break;

            case "APPROVAL":
                Approval_onclick();
                break;

            case "RECIPENT":
                Recipent_onclick();
                break;
                
            case "CIRCUL":
            	Circulation_onclick();
            	break;
        }
    }
    
    if ($("#PreviewRayerH").length && $("#PreviewRayerH").css("display") != "none") {
    	PreviewRayerChange("H", 'Container');
    	if (CrossYN()) {
    		if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
        		ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = strLang930;
    		}
        } else {
        	if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
            	ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLang930;
        	}
        }
    }
    // 원클릭 이벤트는 미리보기 영역이 열려있지 않은 경우에만 동작함
    else if ($("#PreviewRayerH").length) {
        /* 2021-03-24 홍승비 - 제목 클릭 시 원클릭 이벤트로 전자결재 읽기, 결재 팝업창을 표출 */
        var headerNameTD = $(event.target).attr("headerName");
        if (tr.length != 0 && headerNameTD != null && typeof(headerNameTD) != "undefined" && headerNameTD == "DOCTITLE") {
        	lvtDoclist_onSel_DBclick();
        }
        
    	PreviewRayerChange("NONE", 'Container');
    }
}

function paging(p_page, p_nowblock, selRowChangeFlag, preSelectedRow) {
    var h, j, x_NAME, x_WIDTH, x_HEADER, x_CELL2, x_VALUE2, count;

    if (document.getElementById("lvtDoclist").innerHTML != "")
        document.getElementById("lvtDoclist").innerHTML = "";

    var DocList = new ListView();      
    DocList.SetID("DocList");                               
    DocList.SetMulSelectable(false);                        
    DocList.SetHeaderOnClick("lvDocList_HeaderClick");      
    DocList.SetRowOnClick("lvtDoclist_SelChange");           
    DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
    DocList.SetUrgentFlag(true);
    //2019-03-07 천성준 - 개인문서함에 페이징이 생기면 보안결재문서처럼 ROW색이 회색이 되는현상 시간없어서 임시로 처리함
    if (typeof(LoadSquery) != "undefined") {
	    if (LoadSquery != "usercontlist")
	    	DocList.SetSecurityFlag(true);
    } 
    else 
    	DocList.SetSecurityFlag(true);
    DocList.DataSource(ListViewNode);                             
    DocList.DataBind("lvtDoclist");
    if (selRowChangeFlag && preSelectedRow.length > 0) {
        selRowChangeFlag = false;
        DocList.SetSelectedID(preSelectedRow[0].getAttribute('id'));
    }
    DocList = null;

    pagingCount(p_page, p_nowblock);
    selFirstRow(Resultxml);
    pChackYN = "FALSE";
}

var totalPages;
function pagingCount(p_page, p_nowblock) {
    totalPages = parseInt(NodeListLen / PageSize);
    if (((totalPages * PageSize) != NodeListLen) && ((NodeListLen % PageSize) != 0))
        totalPages = totalPages + 1;

    //document.getElementById("td_pTotalCount").innerHTML = totalPages;
    //document.getElementById("txt_PageInputNum").value = curpage;
    return;

    var td;

    document.getElementById("PageNum").innerHTML = "";

    curpage = p_page;

    nowblock = p_nowblock;

    var Gopage;
    var comNoPerPage = PageSize;

    var nextPage, mychoice, prevPage, total_block;

    totalPage = parseInt(NodeListLen / comNoPerPage);

    var strtext = "";

    if (((totalPage * comNoPerPage) != NodeListLen) && ((NodeListLen % comNoPerPage) != 0)) {
        totalPage = totalPage + 1;
    }

    if (curpage < totalPage)
        nextPage = parseInt(curpage) + 1;
    else
        nextPage = totalPage;

    if (curpage > 1)
        prevPage = parseInt(curpage) - 1;
    else
        prevPage = 1;

    mychoice = Block_Size;

    total_block = parseInt(totalPage / mychoice);

    if (totalPage % mychoice == 0)
        total_block = total_block - 1;

    if (totalPage > 1) {
        if (nowblock > 0) {
            strtext = "<a onclick= 'return Block_Check(" + ((nowblock - 1) * mychoice + 1) + "," + (nowblock - 1) + ")' style='cursor:pointer'>";
            strtext = strtext + "<img src='/images/page_previous.gif' border='0' align='absmiddle'>&nbsp;</a>";

            td_Create(strtext);
        }

        if (curpage != 1 && NodeListLen != 0) {
            if (((curpage - 1) % mychoice) == 0) {
                block = nowblock - 1;
                strtext = "<a onclick= 'return Block_Check(" + prevPage + "," + block + ")' style='cursor:pointer'>&nbsp";
            }
            else {
                block = nowblock;
                strtext = "<a onclick= 'return Page_Click(" + prevPage + "," + block + ")' style='cursor:pointer'>&nbsp";
            }

            strtext = strtext + "<img src='/images/page_previous.gif' border='0' align='absmiddle'></a>&nbsp;";

            td_Create(strtext);
        }

        if (total_block != nowblock) {
            for (Gopage = 1; Gopage <= mychoice; Gopage++) {
                if (curpage != nowblock * mychoice + Gopage) {
                    strtext = "<a onclick='return Page_Click(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer'>";
                    strtext = strtext + "" + "<span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></a>&nbsp;";

                    td_Create(strtext);
                }
                else
                {
                    strtext = "<b><span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></b>&nbsp;";

                    td_Create(strtext);
                }
            }
        }
        else {
            for (Gopage = 1; Gopage <= totalPage - mychoice * nowblock; Gopage++) {
                if (curpage != nowblock * mychoice + Gopage) {
                    strtext = "<a onclick='return Page_Click(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer'>";
                    strtext = strtext + "" + "<span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></a>&nbsp;";

                    td_Create(strtext);
                }
                else
                {
                    strtext = "<b><span style = font-size:'10pt';>" + ((nowblock * mychoice) + Gopage) + "</span></b>&nbsp;";

                    td_Create(strtext);
                }
            }
        }

        if ((curpage != totalPage) && (NodeListLen != 0)) {
            if ((curpage % mychoice) == 0) {
                block = (nowblock + 1);
                strtext = "&nbsp<a onclick='return Block_Check(" + nextPage + "," + block + ")' style='cursor:pointer' >";
            }
            else {
                block = nowblock;
                strtext = "&nbsp<a onclick='return Page_Click(" + nextPage + "," + block + ")' style='cursor:pointer' >";
            }
            strtext = strtext + "<img src='/images/page_next.gif' border='0' align='absmiddle'></a>&nbsp;";
            td_Create(strtext);
        }

        if ((total_block > 0) && (nowblock < total_block)) {
            strtext = "<a onclick='return Block_Check(" + ((nowblock + 1) * mychoice + 1) + "," + (nowblock + 1) + ")' style='cursor:pointer'>";
            strtext = strtext + "<img src='/images/page_next.gif' border='0' align='absmiddle'></a>";

            td_Create(strtext);
        }
    }
}

function td_Create(strtext) {
    document.getElementById("PageNum").innerHTML = document.getElementById("PageNum").innerHTML + strtext;
}

function Page_Click(PageNum, block) {
    curpage = PageNum;
    nowblock = block;
    pChackYN = "TRUE";

    if (DocListType == "DocList")
        GetDocList();
    else if (DocListType == "GetDocSearch")
        GetDocSearch();
}

function Block_Check(PageNum, BlockNum) {
    curpage = PageNum;
    nowblock = BlockNum;
    pChackYN = "TRUE";

    if (DocListType == "DocList")
        GetDocList();
    else if (DocListType == "GetDocSearch")
        GetDocSearch();
}

//var ezapralert_cross_dialogArguments = new Array();
//function OpenAlertUI(pAlertContent, CompleteFunction) {
//    var parameter = pAlertContent;
//    var url = "/ezApprovalG/ezAprAlert.do";
//
//    if (CrossYN()) {
//        ezapralert_cross_dialogArguments[0] = parameter;
//        if (CompleteFunction != "") {
//            ezapralert_cross_dialogArguments[1] = CompleteFunction;
//            var OpenWin = window.open(url, "ezAPRALERT_Cross", GetOpenWindowfeature(330, 205));
//            try { OpenWin.focus(); } catch (e) { }
//        }
//        else {
//            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
//            var OpenWin = window.open(url, "ezAPRALERT_Cross", GetOpenWindowfeature(330, 205));
//            try { OpenWin.focus(); } catch (e) { }
//        }
//    }
//    else {
//        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
//        feature = feature + GetShowModalPosition(330, 205);
//        var RtnVal = window.showModalDialog(url, parameter, feature);
//    }
//}
//
//function OpenAlertUI_Complete() {
//    DivPopUpHidden();
//}

function isViewDoc(pDocID) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "UserID", UserID);

    xmlhttp.open("POST", "aspx/isViewDoc.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}

//START
var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd(pUserID, CompleteFunction) {
    var parameter = pUserID;
    ezchkpasswd_cross_dialogArguments[0] = parameter;
    
    if (CompleteFunction != undefined) {
    	ezchkpasswd_cross_dialogArguments[1] = CompleteFunction;
    } else {
    	ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;
    }

    ezchkpasswd_cross_dialogArguments[2] = true;
    var url = "/ezApprovalG/ezchkPasswd.do?mode=SEC";
    var OpenWin = window.open(url, "ezchkPasswd_Cross", GetOpenWindowfeature(460, 225)); // 결재완료문서/부서문서함 리스트에서 보안결재문서 접근
    try { OpenWin.focus(); } catch (e) { }
}
//END

function CheckAprLine(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/checkAprLineUser.do",
		data : {
			companyID : CompanyID,
			docID     : pDocID,
			mode  	  : "END",
			userID    : UserID
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    var dataNodes = GetChildNodes(loadXMLString(result));
    return getNodeText(dataNodes[0]);
}

function check_presence() {
    try{
        var DocList = new ListView();
        DocList.LoadFromID("SubDocList");
        var selRow = DocList.GetDataRows();
        var pCNList = new Array();
        for (var i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            pCNList[i] = tr.getAttribute("DATA4");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (var i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            tr.cells[1].innerHTML = "<span><img src='/images/presence/unknown.gif' id= '" + GetGUID() + "'  onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/>" + tr.cells[1].innerHTML + "</span>";
        }
    } catch (e) { }
}

function check_presence2() {
    try{
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetDataRows();
        var pCNList = new Array();
        for (var i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            pCNList[i] = tr.getAttribute("DATA3");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            tr.cells[2].innerHTML = "<span><img src='/images/presence/unknown.gif' id= '" + GetGUID() + "'  onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/>" + tr.cells[2].innerHTML + "</span>";

        }
    } catch (e) { }
}   
    function MakeSubCondition() {
        var TYPE = "";
        var DATA = "";
        if (condition[0] != "" && condition[0] !== undefined) {
            TYPE += "DOCNO;"
            DATA += "<DOCNO>" + condition[0] + "</DOCNO>";
        }

        if (condition[1] != "" && condition[0] !== undefined) {
            TYPE += "DOCTITLE;"
            DATA += "<DOCTITLE>" + condition[1] + "</DOCTITLE>";
        }

        if (condition[2] != "" && condition[0] !== undefined) {
            TYPE += "WRITERNAME;"
            DATA += "<WRITERNAME>" + condition[2] + "</WRITERNAME>";
        }

        if (condition[3] != ""  && condition[0] !== undefined) {
            TYPE += "STARTDATEAF;"
            DATA += "<STARTDATEAF>" + condition[3] + "</STARTDATEAF>";
        }

        if (condition[4] != ""  && condition[0] !== undefined) {
            TYPE += "STARTDATEBF;"
            DATA += "<STARTDATEBF>" + condition[4] + "</STARTDATEBF>";
        }

        if (condition[5] != ""  && condition[0] !== undefined) {
            TYPE += "ENDDATEAF;"
            DATA += "<ENDDATEAF>" + condition[5] + "</ENDDATEAF>";
        }

        if (condition[6] != ""  && condition[0] !== undefined) {
            TYPE += "ENDDATEBF;"
            DATA += "<ENDDATEBF>" + condition[6] + "</ENDDATEBF>";
        }

        if (condition[9] != ""  && condition[0] !== undefined) {
            TYPE += "FORMID;"
            DATA += "<FORMID>" + condition[9] + "</FORMID>";
        }

        if (condition[11] != ""  && condition[0] !== undefined) {
            TYPE += "WRITERDEPTNAME;"
            DATA += "<WRITERDEPTNAME>" + condition[11] + "</WRITERDEPTNAME>";
        }

        if (condition[12] != ""  && condition[0] !== undefined) {
            TYPE += condition[12];
            DATA += condition[13];
        }
//        else if (pItemCD != "") {
//            TYPE += "CAPR;";
//            DATA += "<ITEMCODE>" + pItemCD + "</ITEMCODE>";
//        }
        if (typeof (condition[14]) != "undefined" && condition[14] != "") {
            TYPE += condition[14];
            DATA += condition[15];
        }
        if (typeof (condition[16]) != "undefined" && condition[16] != "") {
            TYPE += condition[16];
            DATA += condition[17];
        }

        if (typeof (condition[24]) != "undefined" && condition[24] != "") {
            TYPE += condition[24].slice(0,5);
            DATA += "<KEYWORD>" + condition[24].slice(5) + "</KEYWORD>";
        }

        SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
    }

    // var SelUserCont_dialogArgument = new Array();
    function btnRegUserCont_onclick() {
    	//2018-09-19 김보미 - 선택된 문서 없을 경우
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length <= 0) {
            var InformationString = strLangS385;
            //OpenAlertUI(InformationString);
            showAlert(InformationString);
            return;
        }
    	
        // SelUserCont_dialogArgument[0] = "";
        // SelUserCont_dialogArgument[1] = RegUserCont_Complete;
        var url = "/ezApprovalG/selUserCont.do";
        // ContOpen = GetOpenWindow(url, "selUserCont", 340, 460, "NO");
        // try { ContOpen.focus() } catch (e) { }
        var feature = "status=no,toolbar=no,scroll=no,menubar=no,location=no,width=340px,height=460px,resizable=no";
        ezCommon_cross_dialogArguments[0] = "";
        showPopup(url, 340, 460, "selUserCont", feature, RegUserCont_Complete);
    }
    
    function RegUserCont_Complete(RtnVal) {
        if (typeof ContOpen != "undefined") {
            ContOpen.close();
        } else {
            hidePopup();
        }
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();

        if (selRow.length <= 0) {
            var InformationString = strLangS385;
            OpenAlertUI(InformationString);
            return;
        }
        if (RtnVal != "cancel") {
            for (i = 0; i < selRow.length; i++) {
                var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();
                var objNode;
                var tr = selRow[i];
                createNodeInsert(xmlpara, objNode, "PARAMETER");
                if ("${listType}" == 10) {
                	createNodeAndInsertText(xmlpara, objNode, "DocID", GetAttribute(tr, "DATA2"));
                } else {
                	createNodeAndInsertText(xmlpara, objNode, "DocID", GetAttribute(tr, "DATA1"));
                }
                
                createNodeAndInsertText(xmlpara, objNode, "ContID", RtnVal);
                createNodeAndInsertText(xmlpara, objNode, "Desc", "");

                var orgCompnayID = tr.getAttribute("ORGCOMPANYID");
                if (orgCompanyID != null && orgCompanyID != "") {
                	createNodeAndInsertText(xmlpara, objNode, "orgCompanyID", orgCompanyID);
                } else {
                	createNodeAndInsertText(xmlpara, objNode, "orgCompanyID", "");
                }
                
                xmlhttp.open("POST", "/ezApprovalG/setUserContDoc.do", false);
                xmlhttp.send(xmlpara);
            }
            var InformationString
            if (xmlhttp.responseText.indexOf("TRUE") > -1)
                InformationString = strLangS386;
            else
                InformationString = strLangS1124;
            showAlert(InformationString);
        }
    }
    
    function CheckResend(pDocID) {
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objRoot;

        objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
        createNodeAndInsertText(xmlpara, objRoot, "DOCID", pDocID);
        xmlhttp.open("Post", "/ezApprovalG/checkResend.do", false);
        xmlhttp.send(xmlpara);

        return xmlhttp.responseText.trim();
    }

function openergetDocInfo() {
    try {
        // 선택한 row 유지를 위한 Flag 설정
        selRowChangeFlag = true;
        // page 유지를 위한 Flag 설정
        pChackYN = "TRUE";
        if (LoadSquery == "usercontlist") {
            GetUserContList();
        } else if (contFlag == "END" && approvalFlag == 'G') {
            GetDocList("END");
        } else if (contFlag == "END" && approvalFlag == 'S') {
            GetDocSearch();
        } else {
            return;
        }
    } catch (e) {
    	showAlert("openergetDocInfo :: " + e.description);
    }
}
