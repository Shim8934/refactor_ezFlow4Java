const ua = navigator.userAgent.toLowerCase();
const strSearch = "";

const organPagination = new Object();
organPagination.page = "";
/*const organPagination = new Pagination("#org-pagination");
organPagination.fetchSize = 50;
organPagination.addPageChangeEventListener(() => {
    if ($(".tab_menu > p")[0].getAttribute("data-tab-id") == "org") {
        doOrganSearch();
    } else {
        orgJobMstUserList();
    }

});*/

const addressPagination = new Pagination("#address-pagination");
addressPagination.fetchSize = 25;
addressPagination.addPageChangeEventListener(() => {
    if (addrsearh)
        AddrSearch_event();
    else
        address_selectnode("page");
});

let listType = "TXT";

inputUtil.addOnEnterEvent(document.getElementById("org-keyword"), () => doOrganSearch("search"));

getOrganListType()
    .then(type => {
        listType = type;
        ListTypeChangeIcon();
    })
    .then(() => orgTreeViewListSet());

/*window.addEventListener("load", () => {
    getOrganListType();
});*/

function orgJobMstClick(i) {
    //organPagination.page = 1;
    var thisNode = document.getElementById(i);
    var thisNode_jobChk = thisNode.getAttribute("isjob");
    listContentArry = [];

    if (thisNode_jobChk != null && thisNode_jobChk) {
        orgJobMstUserList();
    } else { // company
        // document.getElementById("SelectDeptNM").innerHTML = "";
        pListXML_Info = "";
        DisplayUserImageList();
    }
}

function ChangeListView_onClick(Div) {
    listContentArry = [];
    listType = Div;
    ListTypeChangeIcon();
    DisplayUserImageList();
    setOrganListType(listType);
}

function ListTypeChangeIcon() {
	if (listType == "IMG") {
        document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
        document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
    } else {
        document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
        document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
    }
}

async function getOrganListType() {
    var organListType = "TXT";
    $.ajax({
        type: "POST",
        dataType: "text",
        url: "/ezOrgan/getListType.do",
        async: false,
        success: function (result) {
            organListType = result;
        }
    })
    return organListType;
}

function setOrganListType(listType) {
    $.ajax({
        type: "POST",
        dataType: "text",
        url: "/ezOrgan/setListType.do",
        data: {
            listType: listType
        }
    });
}

// const emailOrgan = (function () {
AddressTreeView = new window['treeview.htc'].TreeView('AddressTreeView', 'AddressTreeView');
AddressTreeView.attachEvent('requestdata', address_requestdata);
AddressTreeView.attachEvent('nodeselect', function () {
    address_selectnode("node")
});
AddressTreeView.attachEvent('nodedblclick', function () {
    AddressTreeView.toggle(AddressTreeView.selectedIndex())
});

const tabMenus = {
    org: {
        load: () => {
            resetOrgCount();
            clearOrgTab("org");
            orgTreeViewListSet();
        },
        contentSelector: "#org-content"
    },
    jobTitle: {
        load: () => {
            resetOrgCount();
            clearOrgTab("orgJobMst");
            orgJobMasterListSet("POS");
        },
        contentSelector: "#org-content"
    },
    jobRole: {
        load: () => {
            resetOrgCount();
            clearOrgTab("orgJobMst");
            orgJobMasterListSet("TIT");
        },
        contentSelector: "#org-content"
    },
    contact: {
        load: () => {
            if (!window.g_bContactLoaded) {
                g_bContactLoaded = true;
                LoadAddressTree();
            }
        },
        contentSelector: "#contact-content"
    },
    dl: {
        load: () => {
            if (useUserDefinedDL == "YES") {
                changeUserDlType();
            } else {
                distributionListSet();
            }
        },
        contentSelector: "#dl-content"
    },
    sharedMail: {
        contentSelector: "#shared-content"
    },
    manual: {
        contentSelector: "#manual-content"
    }
};

// 탭 메뉴 세팅
for (const tabDt of document.querySelectorAll(".organ.tab_menu > p[data-tab-id]")) {
    // 클릭 시 탭 전환
    tabDt.addEventListener("click", event => {
        const previousTabDt = document.querySelector(".organ.tab_menu > p.on");
        const previousTabMenu = tabMenus[previousTabDt.dataset.tabId];
        const selectedMenu = tabMenus[event.currentTarget.dataset.tabId];
        const selectedMenuId = document.querySelector(".organ.tab_menu > p.on").getAttribute("data-tab-id") == "jobTitle" || "jobRole";
        
        // 이전 탭 숨기고 선택한 탭 보이기
        document.querySelector(previousTabMenu.contentSelector).style.display = "none";
        document.querySelector(selectedMenu.contentSelector).style.display = "";
        previousTabDt.removeAttribute("class");
        event.currentTarget.classList.add("on");

        // 이전 탭 unload 동작이 있으면 호출
        if (previousTabMenu?.unload) {
            previousTabMenu.unload();
        }

        // 선택한 탭 load 동작이 있으면 호출
        if (selectedMenu?.load) {
            selectedMenu.load();
        }
        
        if(selectedMenuId){
            $(".txtlist_table_dept").css({"display":""});
        } else {
            $(".txtlist_table_name").css({"padding-left":"15px"});
        }
    });
    
    tabDt.addEventListener("mouseover", event => {
    	event.currentTarget.classList.add("tabon");
    });
    tabDt.addEventListener("mouseout", event => {
    	if (!event.currentTarget.classList.contains("on")) {
    		event.currentTarget.classList.remove("tabon");
    	}
    });
}

function resetOrgCount() {
    document.getElementById("org-user-current-count").textContent = "";
    document.getElementById("org-user-total-count-wrapper").style.display = "none";
}

function orgTreeViewListSet() {
    try {
        var topIdTmp = topCompId ? topCompId : "Top";
        var topIdData = useShowAllCompanies ? "Top/organ" : topIdTmp;
        var xmlpara = createXmlDom();
        var xmlTree = createXmlDom();
        var xmlHTTP = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", initialDeptId);
        createNodeAndInsertText(xmlpara, objNode, "TOPID", topIdData);
        createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
        if (adminDist) {
        createNodeAndInsertText(xmlpara, objNode, "ADMINDIST", adminDist);
        }
        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
        xmlHTTP.send(xmlpara);
        xmlHTTP.onreadystatechange = () => {
            if(xmlHTTP.readyState != 4) { return; }
            xmlTree = loadXMLString(xmlHTTP.responseText);
            var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
            var treeView = new TreeView();
            treeView.SetConfig(treeXML);
            treeView.SetID("FromTreeView");
            treeView.SetUseAgency(true);
            treeView.SetUseCheckBox(useOrgListCheckBox);
            treeView.SetRequestData("RequestData");
            treeView.SetNodeClick("TreeViewNodeClick");
            treeView.DataSource(xmlTree);
            treeView.DataBind("TreeView");

            if (strSearch != "") {
                document.getElementById('keyword').value = strSearch;
                searchOrgan();
            }

            changeCheckBox();
        }
    } catch (ErrMsg) {
        alert("orgTreeViewListSet : " + ErrMsg.description);
    }
}

function orgJobMasterListSet(type) {
    try {
        var xmlpara = createXmlDom();
        var xmlTree = createXmlDom();
        var xmlHTTP = createXMLHttpRequest();
        var objNode;
        var topID = useShowAllCompanies ? "Top/organ" : "Top";

        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "COMID", "");
        createNodeAndInsertText(xmlpara, objNode, "TOPID", topID);
        createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
        createNodeAndInsertText(xmlpara, objNode, "TYPE", type);

        xmlHTTP.open("POST", "/ezOrgan/getCompanyJobTreeInfo.do", false);
        xmlHTTP.send(xmlpara);
        xmlTree = loadXMLString(xmlHTTP.responseText);
        var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");

        var treeView = new TreeView();
        treeView.SetConfig(treeXML);
        treeView.SetID("FromTreeView");
        treeView.SetUseAgency(true);
        treeView.SetUseCheckBox(useOrgListCheckBox);
        treeView.SetRequestData("orgJobMstCompanyClick");
        treeView.SetNodeClick("orgJobMstClick");
        treeView.DataSource(xmlTree);
        treeView.DataBind("TreeView");

        if (strSearch != "") {
            document.getElementById('keyword').value = strSearch;
            doOrganSearch();
        }

        changeCheckBox();
    } catch (ErrMsg) {
        console.error(ErrMsg);
        alert("TreeViewinitialize : " + ErrMsg.description);
    }
}

function orgJobMstUserList() {
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    var treeViewSelectNode = treeView.GetSelectNode();

    var jobId = treeViewSelectNode.GetNodeData("cn");
    var comId = treeViewSelectNode.GetNodeData("comid");
    var jobType = treeViewSelectNode.GetNodeData("jobtype");
    var jobName = treeViewSelectNode.GetNodeData("value");

    $.ajax({
        type: "POST",
        url: "/ezOrgan/getJobMasterMemberList.do",
        dataType: "text",
        data: {
            type: jobType,
            jobID: jobId,
            pageNum: organPagination.page,
            cell: "company;description;displayName;title;telephoneNumber",
            prop: "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;userType",
            searchType: "",
            searchValue: "",
            comID: comId
        }, success: function (result) {
            pListXML_Info = loadXMLString(result);
            var totalCnt = pListXML_Info.getElementsByTagName("TOTALCOUNT")[0].textContent;

            /*document.getElementById("SelectDeptNM").innerHTML
                = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
                + "<span id='spn_deptName' title='" + jobName + "'>" + jobName + "</span>"
                + "<span id='countInfo'>&nbsp;<span class='countColor'> " + totalCnt + "</span></span>";*/
            const orgDeptName = document.getElementById("org-dept-name");
            orgDeptName.title = jobName;
            orgDeptName.textContent = jobName;

            document.getElementById("org-user-current-count").textContent = totalCnt;
            document.getElementById("org-user-total-count-wrapper").style.display = "none";

            pSeach = false;
            DisplayUserImageList();
            //organPagination.totalCount = totalCnt;
        }, error: function (error) {
            alert("error : " + error);
        }
    });
}

function orgJobMstCompanyClick(pNodeID, pTreeID) {
    var TreeIdx = pNodeID;
    var treeNode = new TreeNode();
    treeNode.LoadFromID(TreeIdx);
    var deptID = treeNode.GetNodeData("CN");
    GetCompanySubTreeInfo(deptID, TreeIdx);
}

function GetCompanySubTreeInfo(comID, TreeIdx) {
    var jobMstType = getOrganCurrentTabId() === "jobTitle" ? "POS" : "TIT";

    var xmlHTTP = createXMLHttpRequest();
    var xmlRtn = createXmlDom();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "COMID", comID);
    createNodeAndInsertText(xmlpara, objNode, "TYPE", jobMstType);
    xmlHTTP.open("POST", "/ezOrgan/getJobMasterTreeInfo.do", false);
    xmlHTTP.send(xmlpara);
    xmlRtn = loadXMLString(xmlHTTP.responseText);
    if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
        xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
    }
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    treeView.SetUseCheckBox(useOrgListCheckBox);
    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);

    changeCheckBox();
}

// 수신자설정,탭 변경 시
function changeCheckBox() {
    if (!useOrgListCheckBox) {
        return;
    }

    var selectTreeId = m_selectedTree.id;
    var emailAttr = emailAttrArr[selectTreeId];

    var receiverList = $("#" + receiverListId + " tbody tr");

    $("#" + selectTreeId + " input[type='checkbox']").prop("checked", false);
    if (selectTreeId == "orglistView") {
        $("#FromTreeView input[type='checkbox']").prop("checked", false);
    }
    $.each(receiverList, function (i, e) {
        var n_email = e.getAttribute("data2");

        if (n_email == "mailgroup") {//주소록 그룹메일
            var addrGroupMail_ID = e.getAttribute("data4").split("|")[0];
            $("#" + selectTreeId + " tr[data1='" + addrGroupMail_ID + "'] input").prop("checked", true);
        } else {
            $("#" + selectTreeId + " tr[" + emailAttr + "='" + n_email + "'] input").prop("checked", true);
        }

        if (selectTreeId == "orglistView") {
            $("#FromTreeView div[mail='" + n_email + "'] > input").prop("checked", true);
        }
    });
}

function clearOrgTab(type) { // org or orgJobMst
    document.getElementById('TreeView').innerHTML = "";
    // document.getElementById("SelectDeptNM").innerHTML = "";

    var searchSelectObj = document.getElementById('search_type');
    searchSelectObj.setAttribute("data-type", type);

    document.getElementById("org-keyword").value = "";
    issearch = false;

    var hide_orgJobMstSearchOpt = [
        {"name": "extensionAttribute10", "usedefault": "1", "msg": "직책"},
        {"name": "title", "usedefault": "1", "msg": "직위"},
        {"name": "description", "usedefault": "1", "msg": "부서"},
    ];

    const tabId = getOrganCurrentTabId();
    // 부서선택 버튼명 변경
    const deptSelectBtnNm = tabId === "org" ? strLangSelectDept : tabId === "jobTitle" ? strLangSelectTitle : strLangSelectRole;
    document.getElementById("dept_select").textContent = deptSelectBtnNm;

    $.each(hide_orgJobMstSearchOpt, function (i, e) {
        var searchOpt = $("#search_type option[value='" + e.name + "']");
        if (type == "org" && searchOpt.length < 1) {
            var tempOpt = "<option value=" + e.name + " usedefault=" + e.usedefault + ">" + e.msg + "</option>";
            $(tempOpt).insertAfter("#search_type option[value='displayname']");
        } else if (type == "orgJobMst") {
            searchOpt.remove();
        }
    });
}

var issearch = false;

function searchOrgan(type) {
    const keyword = document.getElementById("org-keyword").value;

    if (!keyword?.trim()) {
        alert(strLangPlzCheckSearchInput); keyword.focus();
        return;
    }

    if (type === "search") {
        //organPagination.page = 1;
        issearch = true;
    }

    if (document.getElementById("search_type").value === "description") {
        doDeptSearch();
        return;
    }

    let data = {
        search: document.getElementById("search_type").value + "::" + keyword.value,
        cell: "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value,
        prop: "mail;displayName;description;title;company;telephonenumber;extensionAttribute2;department;userType",
        page: CurPage,
        type: "user"
    };

    if (useShowAllCompanies) {
        data.company = "";
    }

    $.ajax({
        type: "POST",
        dataType: "text",
        url: "/ezOrgan/getSearchList.do",
        async: true,
        data: data,
        success: function (result) {
            pListXML_Info = loadXMLString(result);
            if (pListXML_Info.getElementsByTagName("ROW").length === 0) {
                issearch = false;
                alert(strLang155);
            } else {
                listContentArry = [];
                pSeach = true;
                DisplayUserImageList();
                // makePageSelPage2();
            }
        },
        error: function (error) {
            alert(strLangSearchFetchError + error);
        }
    });

    /*var usedefault;
    if (browserIE) {
        usedefault = document.getElementById("search_type").options[document.getElementById("search_type").dataset.selectedIndex].usedefault;
    }
    else {
        usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").dataset.selectedIndex], "usedefault");
    }*/
    // 2020-11-03 김은실 - [가천대길병원 voc(#66552)] 메일 수신자 설정시 선택 오류 : 검색 시 PressShiftKey = true 되는 현상 발생.
    PressShiftKey = false;
}

var mail_select_dlmember_cross_dialogArguments = new Array();

function dlmember_click() {
    const dlListView = new ListView();
    dlListView.LoadFromID("pListViewDL");
    const arrRows = dlListView.GetSelectedRows();

    if (arrRows.length < 1) {
        alert(strLangPlzSelectDistribution);
        return;
    }

    createLayerPopup(800, 600, "/ezEmail/new/mailSelectDLMember.do?cn=" + GetAttribute(arrRows[0], "DATA1"))
        .parameter("defaultParam", "")
        .on("complete", dlmember_click_Complete)
        .open();
}

function dlmember_click_Complete(members) {
    for (const member of members) {
        callOrganSelectEvent({
            type: OrganSelectType.UNKNOWN,
            id: null,
            name: member.name,
            email: member.email
        });
    }
}

function dept_select() {
    var organTree = new TreeView();
    organTree.LoadFromID("FromTreeView");
    var nodeIdx = organTree.GetSelectNode();

    var strId = nodeIdx.GetNodeData("CN");
    var strName = nodeIdx.NodeName;
    var strMail = nodeIdx.GetNodeData("mail");
    var isJob = nodeIdx.GetNodeData("isjob"); // 조직도(직위, 직책)
    var jobType = nodeIdx.GetNodeData("jobtype"); // 직위:001, 직책:002

    // 직위, 또는 직책 선택 이벤트 호출
    if (isJob === 'true') {
        callOrganSelectEvent({
            type: jobType === '001'
                ? OrganSelectType.JOB_TITLE
                : OrganSelectType.JOB_ROLE,
            id: strId,
            name: strName,
            email: strMail
        });
        return;
    }

    // 부서 선택 이벤트 호출
    callOrganSelectEvent({
        type: OrganSelectType.DEPT,
        id: strId,
        name: strName,
        email: strMail
    });
}

/** @parm {KeyboardEvent} event */
function onClickOrganUser(event) {
    setTimeout(((parentEl) => () => {
        const selectedRows = parentEl.querySelectorAll(".selected");
        if (selectedRows.length > 1) {
            return;
        }

        // 기존 first-selected 삭제
        parentEl.querySelector(".first-selected")?.classList.remove("first-selected");

        if (selectedRows.length === 1) {
            selectedRows[0].classList.add("first-selected");
        }
    })(event.currentTarget.parentElement), 0);

    // 다중 선택 사용 시
    if (useMultipleSelectable) {
        // 컨트롤 키 눌렀을 때 선택 토글
        if (event.ctrlKey) {
            event.currentTarget.classList.toggle("selected");
            return;
        }

        if (event.shiftKey) {
            const parentEl = event.currentTarget.parentElement;
            const firstSelectedLi = parentEl.querySelector(".first-selected");

            // 기존에 선택된 게 없으면 클릭한 것만 선택
            if (!firstSelectedLi) {
                event.currentTarget.classList.add("selected");
                return;
            }

            // 범위 선택 시작
            let startIndex = index(firstSelectedLi), endIndex = index(event.currentTarget);

            if (startIndex > endIndex) {
                const maxValue = startIndex;
                startIndex = endIndex;
                endIndex = maxValue;
            }

            // 초기화
            for (const li of parentEl.querySelectorAll(".selected")) {
                li.classList.remove("selected");
            }

            // 범위 선택 (start, end 둘다 inclusive)
            for (let i = startIndex; i <= endIndex; i++) {
                const li = parentEl.children.item(i);
                li.classList.add("selected");
            }

            return;
        }
    }

    event.currentTarget.parentElement.querySelectorAll(".selected")
        .forEach(row => row.classList.remove("selected"));
    event.currentTarget.classList.add("selected");
}

/** @param {KeyboardEvent} event */
function onSelectOrganUser(event) {
    for (const user of getSelectedOrganUsers()) {
        callOrganSelectEvent(user);
    }
}

/**
 * 현재 조직도에서 선택된 유저를 선택한다.
 * @return OrganSelectData[]
 */
function getSelectedOrganUsers() {
    return Array.from(document.querySelectorAll(".selected"))
        .map(userElem => ({
            type: OrganSelectType.USER,
            id: userElem.getAttribute("_data2"),
            email: userElem.getAttribute("_data3"),
            name: userElem.getAttribute("_data4"),
            // 사용자는 추가로 부서까지 포함함
            deptId: userElem.getAttribute("_data10")
        }));
}

/** @param {Element} el */
function index(el) {
    if (!el) return -1;
    let i = 0;
    while ((el = el.previousElementSibling)) {
        i++;
    }
    return i;
}

var pSeach = false;

function DisplayUserImageList() {
    p_ListOrderObject = "";
    var xmlRtn = pListXML_Info;
    document.getElementById("DeptUserImgList").innerHTML = "";
    document.getElementById("txtlist_Layer").scrollTop = "0";
    document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
    const totalCount = Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]));
    //organPagination.totalCount = totalCount;
    // totalPage2 = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));

    var tabMenuId = document.querySelector(".organ.tab_menu > p.on").getAttribute("data-tab-id");
    var tbody = document.getElementById("txtlist_table").getElementsByTagName("TBODY");

    while (tbody.item(0).childNodes.length > 1) {
        tbody.item(0).removeChild(tbody.item(0).childNodes.item(1));
    }

    var searchTbody = document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY");
    while (searchTbody.item(0).childNodes.length > 1) {
        searchTbody.item(0).removeChild(searchTbody.item(0).childNodes.item(1));
    }

    var UserListHTML = "";
    /* if (SelectDeptNM.getAttribute("countinfo") != "1" && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) != null && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0])!= "") {
        if (getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
            SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang300 + "</span>]";
        } else {
            SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang300 + "</span>]";
        }

        SelectDeptNM.setAttribute("countinfo", "1")
    } */
    if (listType === "IMG") {
        document.getElementById("DeptUserImgList").style.display = "";
        document.getElementById("txtlist_Layer").style.display = "none";
        document.getElementById("txtlist_table_div").style.display = "none";
        document.getElementById("Search_txtlist_table_div").style.display = "none";

        if (typeof pSeach !== "undefined") {
            if (pSeach) {
                document.getElementById("org-user-current-count").textContent = totalCount;
                document.getElementById("org-user-total-count").textContent = totalCount;
            }
        }
    } else {
        document.getElementById("DeptUserImgList").style.display = "none";
        document.getElementById("txtlist_Layer").style.display = "";
        document.getElementById("org-pagination").style.display = "";

        if (typeof pSeach !== "undefined") {
            if (!pSeach) {
                document.getElementById("txtlist_table_div").style.display = "";
                document.getElementById("txtlist_table_TH").style.display = "";
                document.getElementById("Search_txtlist_table_div").style.display = "none";
                document.getElementById("Search_txtlist_table_TH").style.display = "none";
            } else {
                document.getElementById("Search_txtlist_table_div").style.display = "";
                document.getElementById("Search_txtlist_table_TH").style.display = "";
                document.getElementById("txtlist_table_div").style.display = "none";
                document.getElementById("txtlist_table_TH").style.display = "none";
                document.getElementById("org-user-current-count").textContent = totalCount;
                document.getElementById("org-user-total-count").textContent = totalCount;
                /*<c:if test="${useShowAllCompanies eq 'YES'}">
                    resizeWindowWidth();
                </c:if>*/
            }
        }
    }

    var row = SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW");

    for (var i = 0; i < row.length; i++) {
        if (listType === "IMG") {
            const li = document.createElement("li");
            li.className = "contentlayout_none";
            li.id = "MailUserlist_" + i;
            li.setAttribute("draggable", true);
            li.onclick = onClickOrganUser;
            li.ondblclick = onSelectOrganUser;
            li.onselectstart = function () {
                return false;
            };
            li.ondragstart = function (event) {
                event_listdragstart(this);
                event.dataTransfer.setData('text/plain', 'dragged');
            };

            for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
                if (row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
                    li.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
                        trim_Cross(row.item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
                }
            }

            const table = document.createElement("TABLE");
            table.className = "organwrap";
            table.setAttribute("cellspacing", "0");
            table.setAttribute("cellpadding", "0");
            table.setAttribute("style", "margin-top: 5px;margin-left: auto;margin-right: auto;width: 96%;");
            
            const firstTr 		= table.insertRow();
            const profileTd 	= firstTr.insertCell();
            const profileUrl 	= li.getAttribute("_DATA9");
            profileTd.className = "pictd";
            profileTd.setAttribute("style", "width: 100px;");
            if (profileUrl === undefined || profileUrl == "") {
            	profileTd.innerHTML = `<div class="pic"></div>`;
            } else {
                profileTd.innerHTML = `<div class="pic">
											<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${profileUrl}" onerror="this.style.display='none'" width="90px" height="90px">
										</div>`;
            }
        
        	const organInfoTd = firstTr.insertCell();
            const organInfoTable = document.createElement("table");
            	  organInfoTable.className = "organinfo";
            	  organInfoTd.appendChild(organInfoTable);
            
            // 이름
            let pDisplayName = "";
            /*if (useOcs) {
                pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + li.getAttribute("_DATA3") + "\",this);'/></span>";
            }*/
            if (!pSeach && $(li).attr("_DATA11") == "addJob") {
                pDisplayName += strLangAddJobSimplyMark;
            } else if (pSeach && $(li).attr("_DATA10") == "addJob") {
                pDisplayName += strLangAddJobSimplyMark;
            }

            pDisplayName += li.getAttribute("_DATA4") == "" ? "" : li.getAttribute("_DATA4");
            pDisplayName += li.getAttribute("_DATA6") == "" ? "" : " / " + li.getAttribute("_DATA6");

            // 부서
            let deptValue = MakeXMLString(li.getAttribute("_DATA5"));

            if (useShowAllCompanies) {
                if (pSeach) {
                    deptValue += " (" + strLangCompany + ": " + MakeXMLString(li.getAttribute("_DATA7")) + ")";
                }
            }
            
            // 전화번호
            let callNum = li.getAttribute("_DATA8") == "" ? "-" : li.getAttribute("_DATA8")

            // 이메일
            let emailAddr = li.getAttribute("_DATA3");

            organInfoTable.innerHTML = `<tr><td class="name" style="text-align: left;">${replaceEntityCodeToStr(pDisplayName)}</td></tr>
							            <tr><td style="text-align: left;">${replaceEntityCodeToStr(deptValue)}</td></tr>
							            <tr>
							            	<td style="text-align: left;">
							            	<img class="icon" src="/images/OrganTree/icon_hp.gif">${callNum}
							            	</td>
							            </tr>
							            <tr>
								            <td style="text-align: left;">
							            	<img class="icon" src="/images/OrganTree/icon_mail.gif">${emailAddr}
							            	</td>
							            </tr>
							            `;
            
            li.appendChild(table);
            document.getElementById("DeptUserImgList").appendChild(li);
        } else {
            var M_TR = document.createElement("TR");
            M_TR.setAttribute("id", "MailUserlist_" + i);
            M_TR.style.cursor = "pointer";
            M_TR.onclick = onClickOrganUser;
            M_TR.ondblclick = onSelectOrganUser;
            M_TR.onselectstart = function () {
                return false;
            };
            M_TR.setAttribute("draggable", true);
            M_TR.ondragstart = function (event) {
                event_listdragstart(this);
                event.dataTransfer.setData('text/plain', 'dragged');
            };

            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
                M_TR.ondragend = function (event) {
                    event_listdragend(event);
                };
            }

            for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
                if (row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
                    M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
                        trim_Cross(row.item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
                }
            }

            if (pSeach) {
                var M_TR_TD1 = document.createElement("TD");
                M_TR_TD1.style.overflow = "hidden";
                M_TR_TD1.style.textOverflow = "ellipsis";
                M_TR_TD1.style.whiteSpace = "nowrap";
                M_TR_TD1.style.width = "110px";
                M_TR_TD1.style.paddingLeft = "15px";
                M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA5");

                var M_TR_TD2 = document.createElement("TD");
                M_TR_TD2.style.overflow = "hidden";
                M_TR_TD2.style.textOverflow = "ellipsis";
                M_TR_TD2.style.whiteSpace = "nowrap";
                M_TR_TD2.style.width = "115px";
                if (useOcs)
                    M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
                else
                    M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");

                var M_TR_TD3 = document.createElement("TD");

                var jobName = "";
                if ($(M_TR).attr("_DATA11") == "addJob") {
                    jobName += strLangAddJobSimplyMark;
                }

                jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
                M_TR_TD3.innerHTML = jobName;
                M_TR_TD3.style.overflow = "hidden";
                M_TR_TD3.style.textOverflow = "ellipsis";
                M_TR_TD3.style.whiteSpace = "nowrap";
                M_TR_TD3.style.width = "120px";

                var M_TR_TD4 = document.createElement("TD");
                M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
                M_TR_TD4.style.overflow = "hidden";
                M_TR_TD4.style.textOverflow = "ellipsis";
                M_TR_TD4.style.whiteSpace = "nowrap";
                M_TR_TD4.style.width = "120px";

                if (useOrgListCheckBox) {
                    var M_TR_TD_Chk = document.createElement("TD");
                    M_TR_TD_Chk.style.padding = "5px";
                    M_TR_TD_Chk.innerHTML = "<input type='checkbox' class='checkUser'/>";
                    M_TR.appendChild(M_TR_TD_Chk);
                }

                if (useShowAllCompanies) {
                    var companyTd = document.createElement("TD");
                    companyTd.style.overflow = "hidden";
                    companyTd.style.textOverflow = "ellipsis";
                    companyTd.style.whiteSpace = "nowrap";
                    companyTd.style.width = "110px";
                    companyTd.style.display = "none";
                    companyTd.innerHTML = M_TR.getAttribute("_DATA7");
                    M_TR.appendChild(companyTd);
                }

                M_TR.appendChild(M_TR_TD1);
                M_TR.appendChild(M_TR_TD2);
                M_TR.appendChild(M_TR_TD3);
                M_TR.appendChild(M_TR_TD4);

                document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
            } else {
                var M_TR_TD1 = document.createElement("TD");
                M_TR_TD1.style.overflow = "hidden";
                M_TR_TD1.style.textOverflow = "ellipsis";
                M_TR_TD1.style.whiteSpace = "nowrap";
                M_TR_TD1.style.width = "100px";
                
                if (useOcs)
                    M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
                else
                    M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");

                var M_TR_TD2 = document.createElement("TD");
                M_TR_TD2.style.width = "120px";

                var jobName = "";
                if ($(M_TR).attr("_DATA11") == "addJob") {
                    jobName += strLangAddJobSimplyMark;
                }

                jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
                M_TR_TD2.innerHTML = jobName;
                M_TR_TD2.style.overflow = "hidden";
                M_TR_TD2.style.textOverflow = "ellipsis";
                M_TR_TD2.style.whiteSpace = "nowrap";

                var M_TR_TD3 = document.createElement("TD");
                M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
                M_TR_TD3.style.overflow = "hidden";
                M_TR_TD3.style.textOverflow = "ellipsis";
                M_TR_TD3.style.whiteSpace = "nowrap";

                if (useOrgListCheckBox) {
                    var M_TR_TD_Chk = document.createElement("TD");
                    M_TR_TD_Chk.style.padding = "5px";
                    M_TR_TD_Chk.innerHTML = "<input type='checkbox' class='checkUser'/>";
                    M_TR.appendChild(M_TR_TD_Chk);
                }

                if (getOrganCurrentTabId().indexOf("job") > -1) {
                    var M_TR_DEPT_TD = document.createElement("TD");
                    M_TR_DEPT_TD.style.overflow = "hidden";
                    M_TR_DEPT_TD.style.textOverflow = "ellipsis";
                    M_TR_DEPT_TD.style.whiteSpace = "nowrap";
                    M_TR_DEPT_TD.style.width = "115px";
                    M_TR_DEPT_TD.style.paddingLeft = "15px";
                    M_TR_DEPT_TD.innerHTML = M_TR.getAttribute("_DATA5");

                    M_TR.appendChild(M_TR_DEPT_TD);
                }

                if (tabMenuId == "org") {
                    M_TR_TD1.style.paddingLeft = "15px";
                }
                
                if (tabMenuId == "org" || tabMenuId == "contact") {
                    M_TR_TD1.style.width = "150px";
                    M_TR_TD2.style.width = "150px";
                    $(".txtlist_table_dept").css("display", "none");
                    $(".txtlist_table_name").css({"padding-left":"15px"});
                } else {
                    M_TR_TD1.style.width = "115px";
                    $(".txtlist_table_dept").css("display", "");
                }
                
                M_TR.appendChild(M_TR_TD1);
                M_TR.appendChild(M_TR_TD2);
                M_TR.appendChild(M_TR_TD3);
                document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
            }
            changeCheckBox();
        }

    }

    /*if (selTab == "orglistView" && $(".txtlist_DeptTD").length > 0) {
        $(".txtlist_DeptTD").css("display", "none");
        $(".txtlist_DeptTD").css("padding-left", "4px");

        $(".mainlist > tbody > tr:first-child > td:nth-child(2)").css("padding-left", "15px");
    }*/
}

function address_requestdata(event) {
    if (!event) {
        event = window.event;
    }

    var nodeIdx = event.nodeIdx;

    if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
        nodeIdx = arguments[0].nodeIdx;
    }

    var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"))
    AddressTreeView.putchildxml(nodeIdx, childxml);
}

function address_requestdata_(pNodeID, pTreeID) {
    var nodeIdx = window.event.nodeIdx;
    var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"));
    AddressTreeView.putchildxml(nodeIdx, childxml);
}


function TreeViewNodeClick() {
    issearch = false;
    //organPagination.page = 1;
    listContentArry = [];
    p_ListOrderObject = "";
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    treeView.SetUseCheckBox(useOrgListCheckBox);
    var nodeIdx = treeView.GetSelectNode();
    const orgDeptName = document.getElementById("org-dept-name");
    orgDeptName.title = nodeIdx.GetNodeData("VALUE");
    orgDeptName.textContent = nodeIdx.GetNodeData("VALUE");
    /*document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
        + "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
        + "<span id='countInfo'></span>";*/
    displayUserList(nodeIdx.GetNodeData("CN"));
}

var tempDeptID = "";

function displayUserList(DeptID) {
    if (DeptID != undefined)
        tempDeptID = DeptID;
    listContentArry = [];

    document.getElementById("org-user-total-count-wrapper").style.display = "none";
    document.getElementById("org-user-current-count").textContent = "";

    $.ajax({
        type: "POST",
        dataType: "text",
        url: "/ezOrgan/getDeptMemberList.do",
        data: {
            deptID: tempDeptID,
            cell: "company;description;displayName;title;telephoneNumber",
            prop: "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;userType",
            //page: organPagination.page,
            type: "user"
        },
        success: function (result) {
            pListXML_Info = loadXMLString(result);

            pSeach = false;
            DisplayUserImageList();
            // makePageSelPage2();
        },
        error: function (error) {
            alert(strLangDistributionAdd + error);
        }
    });

    $.ajax({
        url: "/ezOrgan/getDeptMemberListCount.do",
        method: "POST",
        dataType: "json",
        data: {
            deptID: tempDeptID
        },
        success: function (result) {
            if (SelectDeptNM.getAttribute("countinfo") !== "1" && !pSeach) {
                var strIsLeaf = $(`div.node_div[cn='${tempDeptID}']`).attr("isleaf");

                if (result.containLow === "YES" && strIsLeaf !== "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
                    document.getElementById("org-user-total-count-wrapper").style.display = "";
                    document.getElementById("org-user-current-count").textContent = result.totalCount;
                    document.getElementById("org-user-total-count").textContent = parseInt(result.totalCount + result.totalCount2);
                } else {
                    document.getElementById("org-user-total-count-wrapper").style.display = "none";
                    document.getElementById("org-user-current-count").textContent = result.totalCount;
                }
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert(error);
        }
    });
}

function RequestData(pNodeID, pTreeID) {
    var TreeIdx = pNodeID;
    var treeNode = new TreeNode();
    treeNode.LoadFromID(TreeIdx);
    var deptID = treeNode.GetNodeData("CN");
    GetDeptSubTreeInfo(deptID, TreeIdx);
}

function GetDeptSubTreeInfo(deptID, TreeIdx) {
    var xmlHTTP = createXMLHttpRequest();
    var xmlRtn = createXmlDom();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
    createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayName");
    xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
    xmlHTTP.send(xmlpara);
    xmlRtn = loadXMLString(xmlHTTP.responseText);
    if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
        xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
    }
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    treeView.SetUseCheckBox(useOrgListCheckBox);
    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

function LoadAddressTree() {
    var treeXML = loadXMLFile("/xml/common/organtree_config2.xml");
    AddressTreeView.config(treeXML);
    get_Address_FullTree();
}

function get_Address_FullTree() {
    xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("POST", "/ezAddress/addressGetFullTree.do", true);
    xmlHTTP.onreadystatechange = event_get_Address_FullTree;
    xmlHTTP.send();
}

function event_get_Address_FullTree() {
    if (xmlHTTP.readyState === 4 && xmlHTTP !== null) {
        if (xmlHTTP.status === 200) {
            var treexmldom = loadXMLString(xmlHTTP.responseText);
            var IDNodes = treexmldom.getElementsByTagName("FOLDERID");
            var ChangeKeyNodes = treexmldom.getElementsByTagName("CHANGEKEY");
            var OwnerNodes = treexmldom.getElementsByTagName("OWNERID");
            var TypeNodes = treexmldom.getElementsByTagName("FOLDERTYPE");
            var NameNodes = treexmldom.getElementsByTagName("FOLDERNAME");
            var ChildNodes = treexmldom.getElementsByTagName("CHILDCOUNT");
            xmlHTTP = null;

            var childXML = "<tree><nodes>";

            for (var i = 0; i < NameNodes.length; i++) {
                var strFolderName = NameNodes[i].firstChild.nodeValue;

                childXML += "<node imgidx='1' caption=\"";
                childXML += (strFolderName + "\" ");

                childXML += ("ownerid=\"" + MakeRightField(OwnerNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("type=\"" + MakeRightField(TypeNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("folderid=\"" + MakeRightField(IDNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("changekey=\"" + MakeRightField(ChangeKeyNodes[i].firstChild.nodeValue) + "\" ");

                if (ChildNodes[i].firstChild.nodeValue != "0")
                    childXML += "hassub='1' ";

                childXML += "/>";
            }
            childXML += "</nodes></tree>";

            AddressTreeView.source(childXML);
            AddressTreeView.update();
            //AddressTreeView.toggle(1);address Loading turing
            AddressTreeView.select(1);
        } else {
            xmlHTTP = null;
        }
    }
}

var tempfolderid = "";
var searchgubun = "N";

function address_selectnode(pGubun) {
    var nodeIdx = AddressTreeView.selectedIndex();
    var folderid = AddressTreeView.getvalue(nodeIdx, "folderid");
    var ownerid = AddressTreeView.getvalue(nodeIdx, "ownerid");
    var foldertype = AddressTreeView.getvalue(nodeIdx, "type");
    document.getElementById("addressFolderName").textContent = AddressTreeView.selectedNode().textContent;

    var xmlDom = null;
    if (tempfolderid != folderid) {
        addressPagination.page = 1;
    }
    xmlDom = call_page_address_get_list_mailCall(folderid, ownerid, foldertype,
        "ADDRESSID,STYPE,SNAME,SCOMPANY,SCOMPANYPHONE,SEMAIL", "NOT SEMAIL=''", addressPagination.page, "25", searchgubun, strLangAddressFetchError);
    tempfolderid = folderid;

    // document.getElementById('totalcount').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
    document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
    // document.getElementById('txt_PageInputNum').value = pGubun == "page" ? xmlDom.getElementsByTagName("CURRENTPAGE").item(0).firstChild.nodeValue : "1";
    // page = document.getElementById('txt_PageInputNum').value;

    // totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue / 25);
    // pageNum = page;

    addressPagination.totalCount = Number(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue);

    document.getElementById("AddressListView").innerHTML = "";
    var addressList = new ListView();
    addressList.SetID("Address");
    addressList.SetSelectFlag(false);
    // addressList.SetHeightFree(true);
    addressList.SetMulSelectable(true);
    addressList.SetUseCheckBox(useOrgListCheckBox);
    addressList.SetRowOnDblClick("addressDblClick");
    addressList.DataSource(loadXMLString(document.getElementById("listviewheader4").innerHTML.toUpperCase()));
    addressList.DataBind("AddressListView");
    addressList.DataSource(get_xmldom_addresslistview(xmlDom));
    addressList.RowDataBind();
    for (var i = 0; i < addressList.GetRowCount(); i++) {
        addressList.GetDataRows()[i].draggable = true;
        if (CrossYN())
            addressList.GetDataRows()[i].ondragstart = function (event) {
                event_listdragstart(this);
                event.dataTransfer.setData('text/plain', 'dragged');
            };
        else
            addressList.GetDataRows()[i].ondragstart = function (event) {
                event_listdragstart(this);
            };

        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            addressList.GetDataRows()[i].ondragend = function (event) {
                event_listdragend(event);
            };
        }
    }
    addressList = null;
    addrsearh = false;
    // makePageSelPage();
    changeCheckBox();
}

function call_page_address_get_list_mailCall(folderid, ownerid, foldertype, field, filter, page, pagesize, searchgubun, errormesg) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", folderid);
    createNodeAndInsertText(xmlpara, objNode, "OWNERID", ownerid);
    createNodeAndInsertText(xmlpara, objNode, "FOLDERTYPE", foldertype);
    createNodeAndInsertText(xmlpara, objNode, "FIELD", field);
    createNodeAndInsertText(xmlpara, objNode, "FILTER", filter);
    createNodeAndInsertText(xmlpara, objNode, "PAGE", page);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", pagesize);
    createNodeAndInsertText(xmlpara, objNode, "SEARCHGUBUN", searchgubun);

    /* if(foldertype =="P")
        xmlhttp.open("POST", "/myoffice/ezAddress/remoteEWS/address_get_list_mailCall.aspx", false);
    else
        xmlhttp.open("POST", "/myoffice/ezAddress/remote/address_get_list_mailCall.aspx", false); */
    xmlhttp.open("POST", "/ezAddress/addressGetListMailCall.do", false);

    xmlhttp.send(xmlpara);
    return xmlhttp.responseXML;
}

function get_xmldom_addresslistview(xmlDom) {
    var XmlRows = SelectNodes(xmlDom, "RTNDATA/DATA/ROW");
    var xmlpara = createXmlDom();
    var objRoot, objNode, objHeader, HEADERS, HEADER, ROWS, ROW, CELL, CELLVALUE;
    objRoot = createNodeInsert(xmlpara, objRoot, "LISTVIEWDATA");
    ROWS = createNodeAndAppandNode(xmlpara, objRoot, ROWS, "ROWS");
    for (var count = 0; count < XmlRows.length; count++) {
        ROW = createNodeAndAppandNode(xmlpara, ROWS, ROW, "ROW");
        CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SNAME"));
        if (SelectSingleNodeValue(XmlRows[count], "STYPE") === "G") {
            createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA1", SelectSingleNodeValue(XmlRows[count], "ADDRESSID"));
            createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA2", "mailgroup");
        } else {
            createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA1", "");
            createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA2", "email");
        }
        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA3", SelectSingleNodeValue(XmlRows[count], "SEMAIL"));
        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA4", SelectSingleNodeValue(XmlRows[count], "FOLDERTYPE"));
        CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SCOMPANY"));
        CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SEMAIL"));
    }
    return xmlpara;
}

function addressDblClick(nodeId) {
    const pListViewDL = new ListView();
    pListViewDL.LoadFromID("Address");
    const arrRows = pListViewDL.GetSelectedRows();

    if (arrRows.length === 0) {
        return;
    }

    for (var i = 0; i < arrRows.length; i++) {
        var pAddressID = GetAttribute(arrRows[i], "DATA1");
        var pAddressType = GetAttribute(arrRows[i], "DATA2");
        var strName = arrRows[i].cells[0].innerText
        var strEmail = GetAttribute(arrRows[i], "DATA3");

        if (strEmail.trim() == "") {
            alert(strName + " " + strLang301)
            continue;
        }

        if (strName.trim() == "") {
            strName = strEmail;
        }

        if (strEmail.trim() == "mail") {
            continue;
        }

        if (pAddressType === "mailgroup") {
            callOrganSelectEvent({type: OrganSelectType.GROUP_ADDRESS, id: pAddressID, name: strName, email: null});
        } else {
            callOrganSelectEvent({type: OrganSelectType.ADDRESS, id: null, name: strName, email: strEmail});
        }
    }
}

function distributionListSet(url) {
    // useShowAllCompanies config가 YES일 경우 그룹사 전체 조직도를 대상으로 검색하기 위해 company 패러메터를 빈 값으로 추가함.
    var dlList_URL = "/admin/ezEmail/mailGetDistribution.do?company=";
    if (typeof url != "undefined" && url.trim() !== "") {
        dlList_URL = url;
    }

    try {
        var xmlDom = createXmlDom();
        var xmlHTTP = createXMLHttpRequest();

        var objRoot;
        createNodeInsert(xmlDom, objRoot, "DATA");
        createNodeAndInsertText(xmlDom, objRoot, "CN", document.getElementById("TextId").value);
        createNodeAndInsertText(xmlDom, objRoot, "COMPID", new URLSearchParams(window.location.search).get("companyId"));
        
        xmlHTTP.open("POST", dlList_URL, false);
        xmlHTTP.send(xmlDom);

        if (xmlHTTP.status !== 200) {
            alert(strLangDistributionFetchError + xmlHTTP.statusText);
        } else {
            document.getElementById("ListViewDL").innerHTML = "";
            var pListViewDL = new ListView();
            pListViewDL.SetID("pListViewDL");
            pListViewDL.SetSelectFlag(false);
            pListViewDL.SetMulSelectable(true);
            pListViewDL.SetUseCheckBox(useOrgListCheckBox);
            pListViewDL.SetRowOnDblClick("ListViewNodeDblClick");
            pListViewDL.DataSource(loadXMLString(document.getElementById("listviewheader3").innerHTML.toUpperCase()));
            pListViewDL.DataBind("ListViewDL");
            pListViewDL.DataSource(loadXMLString(xmlHTTP.responseText));
            pListViewDL.RowDataBind();

            var dataRows = pListViewDL.GetDataRows();
            var dataRowCount = pListViewDL.GetRowCount();

            for (var i = 0; i < dataRowCount; i++) {
                dataRows[i].draggable = true;
                if (CrossYN())
                    dataRows[i].ondragstart = function (event) {
                        event_listdragstart(this);
                        event.dataTransfer.setData('text/plain', 'dragged');
                    };
                else
                    dataRows[i].ondragstart = function (event) {
                        event_listdragstart(this);
                    };

                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
                    dataRows[i].ondragend = function (event) {
                        event_listdragend(event);
                    };
                }
            }

            changeCheckBox();
        }

        xmlHTTP = null;
    } catch (e) {
        alert(strLangDistributionFetchError + e.description);
        xmlHTTP = null;
    }
}

function changeUserDlType() {
    var dlList_URL = "/ezEmail/searchUserDistribution.do?searchValue=&listType=mailUser";
    const dlCaseSelect = document.getElementById("dlSearch_case");
    var userDlType = dlCaseSelect.value;
    dlCaseSelect.value = "";

    if (userDlType === "include") {
        dlList_URL = "/ezEmail/mailGetUserDistribution.do?type=include&listType=mailUser";
    } else if (userDlType === "owner") {
        dlList_URL = "/ezEmail/mailGetUserDistribution.do?type=owner&listType=mailUser";
    } else {
        var pListViewDL = new ListView();
        pListViewDL.SetID("pListViewDL");
        pListViewDL.SetSelectFlag(false);
        pListViewDL.SetMulSelectable(true);
        pListViewDL.SetRowOnDblClick("ListViewNodeDblClick");
        pListViewDL.DataBind("ListViewDL");
        pListViewDL.DataSource("");
        pListViewDL.RowDataBind();

        return;
    }

    distributionListSet(dlList_URL);
}

function ListViewNodeDblClick() {
    for (const dl of getDistributionSelectedRows()) {
        callOrganSelectEvent(dl);
    }
}

/**
 * 공용배포그룹에서 선택된 rows 구하기
 * @return OrganSelectData[]
 */
function getDistributionSelectedRows() {
    const pListViewDL = new ListView();
    pListViewDL.LoadFromID("pListViewDL");
    const rows = pListViewDL.GetSelectedRows();
    return rows.map(row => ({
        type: OrganSelectType.DISTRIBUTION,
        id: row.getAttribute("data1"),
        name: row.textContent,
        email: row.getAttribute("data2")
    }));
}

function dlSearch_press(e) {
    if (e.which === 13)
        dlSearch_click("search");
}

function dlSearch_click() {
    var userDlType = document.getElementById("dlSearch_case").value;
    var searchValue = document.getElementById("dlSearch_text").value;
    var dlList_URL = "/ezEmail/searchUserDistribution.do";
    var param = "?searchValue=" + encodeURIComponent(searchValue) + "&searchRange=" + userDlType + "&listType=mailUser";

    if (userDlType === "search") {
        dlList_URL = "/ezEmail/mailGetUserDistributionSearchAll.do"; // 전체 검색
    }

    if (searchValue.trim() === "") {
        alert(strLangPlzCheckSearchInput);
        keyword.focus();
        changeUserDlType();

        return;
    }

    distributionListSet(dlList_URL + param);
}

// 그룹주소록 멤버 목록/선택 팝업 띄우기
function groupmember_click() {
    var AdddressList = new ListView();
    AdddressList.LoadFromID("Address");
    var listview = AdddressList.GetSelectedRows();

    if (listview.length < 1) {
        alert(strLangPlzSelectGroupMail);
        return;
    }

    var type = GetAttribute(listview[0], "DATA2");
    if (type != "mailgroup") {
        alert(strLangPlzSelectGroupMail);
        return;
    }

    var FolderType = GetAttribute(listview[0], "DATA4");
    var ID = GetAttribute(listview[0], "DATA1");
    var Url = "";
    /* if(FolderType =="P")
        Url = "../ezAddress/RemoteEWS/address_select_groupemaillist.aspx?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType);
    else
        Url = "../ezAddress/Remote/address_select_groupemaillist.aspx?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType); */
    Url = "/ezAddress/addressSelectGroupMailListnew.do?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType);
    createLayerPopup(600, 600, Url)
        .on("complete", groupmember_click_Complete)
        .open();
}

// 그룹주소록 멤버 선택 콜백
function groupmember_click_Complete(members) {
    for (const member of members) {
        callOrganSelectEvent({
            type: OrganSelectType.UNKNOWN,
            id: null,
            name: member.name,
            email: member.email
        });
    }
}

function doOrganSearch(type) {
    const keyword = document.getElementById("org-keyword").value.trim();

    if (keyword === "") {
        alert(strLangPlzCheckSearchInput);
        document.getElementById("org-keyword").focus();
        return;
    }

    if (type === "search") {
        //organPagination.page = 1;
        issearch = true;
    }

    const searchType = document.getElementById("search_type").value;
    if (searchType === "description") {
        doDeptSearch();
        return;
    }

    const data = {
        search : searchType+ "::" + keyword,
        cell : "company;description;displayName;title;telephoneNumber;" + searchType,
        prop : "mail;displayName;description;title;company;telephonenumber;extensionAttribute2;department;userType",
        //page : organPagination.page,
        type : "user"
    };

    if (useShowAllCompanies) {
        data.company = "";
    }

    $.ajax({
        type: "POST",
        dataType: "text",
        url: "/ezOrgan/getSearchList.do",
        async: true,
        data: data,
        success: function (result) {
            pListXML_Info = loadXMLString(result);
            if (pListXML_Info.getElementsByTagName("ROW").length == 0) {
                issearch = false;
                alert(strLang155);
            } else {
                listContentArry = [];
                pSeach = true;
                DisplayUserImageList();
            }
        },
        error: function (error) {
            alert(strLangSearchFetchError + error);
        }
    });

    PressShiftKey = false;
}

function cnsearch_press() {
    if (window.event.keyCode == "13")
        cnsearch_click();
}
function cnsearch_click() {
    if (document.getElementById("cnkeyword").value == "") {
        alert(strLangPlzCheckSearchNameInput, () => document.getElementById("cnkeyword").focus());
        return;
    }

    const data = {
        search : "displayname::" + document.getElementById("cnkeyword").value,
        cell : "displayName;description;title;telephoneNumber",
        prop : "mail",
        type : "user"
    };

    if (useShowAllCompanies) {
        data.company = "";
    }

    $.ajax({
        type : "POST",
        dataType : "text",
        url : "/ezOrgan/getSearchList.do",
        async : true,
        data : data,
        success : function(result){
            pListXML_Info = loadXMLString(result);
            if (pListXML_Info.getElementsByTagName("ROW").length == 0) {
                issearch = false;
                alert(strLang155);
            } else {
                listContentArry = [];
                pSeach = true;
                DisplayUserImageList();
            }
        },
        error : function(error){
            alert(strLangSearchFetchError + error);
        }
    });
}

function doDeptSearch() {
    const keyword = document.getElementById("org-keyword").value.trim();

    if (keyword === "") {
        alert(strLangPlzCheckSearchInput);
        document.getElementById("org-keyword").focus();
        return;
    }

    const xmlDom = createXmlDom();
    const data = {
        search: "displayname::" + keyword,
        cell: "extensionAttribute3;displayName;extensionAttribute9",
        prop: "",
        type: "group"
    };

    if (useShowAllCompanies) {
        data.company = "";
    }

    let resultXmlDom = null;

    $.ajax({
        type : "POST",
        dataType : "text",
        url : "/ezOrgan/getSearchList.do",
        async : false,
        data : data,
        success : function(result){
            resultXmlDom = loadXMLString(result);
            adCount = resultXmlDom.getElementsByTagName("ROW").length;
        },
        error : function(error){
            alert(strLangOrgFetchError + error);
        }
    });

    if (adCount === 0) {
        alert(strLangNoSuchDept);
    } else if (adCount === 1) {
        bSearch = true;
        g_xmlHTTP = createXMLHttpRequest();

        const topId = useShowAllCompanies ? "Top/organ" : "Top";
        const strQuery = `<DATA><DEPTID>${resultXmlDom.getElementsByTagName("DATA2").item(0).textContent}</DEPTID><TOPID>${topId}</TOPID><PROP>mail</PROP></DATA>`;

        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
        g_xmlHTTP.send(strQuery);
    } else {
        createLayerPopup(600, 570, "/admin/ezOrgan/new/checkName2.do")
            .parameter("addrBook", resultXmlDom)
            .on("complete", completeDeptSearch)
            .open();
    }
}

function completeDeptSearch(deptId) {
    bSearch = true;
    g_xmlHTTP = createXMLHttpRequest();

    const topId = useShowAllCompanies ? "Top/organ" : "Top";
    const strQuery = `<DATA><DEPTID>${deptId}</DEPTID><TOPID>${topId}</TOPID><PROP>mail</PROP></DATA>`;

    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
    g_xmlHTTP.send(strQuery);
}

function event_getDeptFullTree(event) {
    if (g_xmlHTTP != null && g_xmlHTTP.readyState === 4) {
        if (g_xmlHTTP.status === 200) {
            if (!bSearch) {
                try {
                    getTopLayerWindow().organview = loadXMLString(g_xmlHTTP.responseText);
                } catch (e) { }
            }

            var treeXML = loadXMLFile("/xml/common/organtree_config2.xml");
            document.getElementById('TreeView').innerHTML = "";

            var treeView = new TreeView();
            treeView.SetConfig(treeXML);
            treeView.SetID("FromTreeView");
            treeView.SetUseAgency(true);
            treeView.SetUseCheckBox(useOrgListCheckBox);
            treeView.SetRequestData("RequestData");
            treeView.SetNodeClick("TreeViewNodeClick");
            treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
            treeView.DataBind("TreeView");
        } else {
            alert(strLangSelectProxyApproverWarning + g_xmlHTTP.statusText);
            g_xmlHTTP = null;
        }
    }
}

function AddrSearch_press() {
    if (window.event.keyCode == "13")
        AddrSearch_click();
}
function AddrSearch_click() {
    addressPagination.page = 1;
    AddrSearch_event();
}
function AddrSearch_event() {
    var objSel = "SNAME";
    var objText = document.getElementById("search_text");
    if (objText.value === "") {
        alert(strLangPlzCheckSearchNameInput);
        objText.focus();
        return;
    }

    var nodeIdx = AddressTreeView.selectedIndex();
    var parentFolderId = AddressTreeView.getvalue(nodeIdx, "folderid");
    var ownerid = AddressTreeView.getvalue(nodeIdx, "ownerid");
    var foldertype = AddressTreeView.getvalue(nodeIdx, "type");

    if (addrsearh) {
        addressPagination.page = 1;
    }

    var strXML = "<DATA>"
        + "<FOLDERID>" + parentFolderId + "</FOLDERID>"
        + "<FOLDERTYPE>" + foldertype + "</FOLDERTYPE>"
        + "<OWNERID>" + ownerid + "</OWNERID>"
        + "<CASE>" + document.getElementById("search_case").value + "</CASE>"
        + "<FILTER>" + MakeXMLString(document.getElementById("search_text").value) + "</FILTER>"
        + "<PAGE>" + addressPagination.page + "</PAGE>"
        + "<PAGESIZE>25</PAGESIZE>"
        + "</DATA>";

    addrsearh = true;
    var xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("POST", "/ezAddress/addressGetListMailSearchCall.do", false);
    xmlHTTP.send(strXML);

    if (xmlHTTP.status != 200 || xmlHTTP.responseText == "ERROR") {
        alert(strLangAddressFetchError);
        objText.focus();
        return;
    }

    const xmlDom = xmlHTTP.responseXML;
    const arrRows = GetElementsByTagName(xmlDom, "ROW");

    const addressList = new ListView();
    addressList.SetID("Address");
    addressList.SetSelectFlag(false);
    addressList.SetHeightFree(true);
    addressList.SetMulSelectable(true);
    addressList.SetRowOnDblClick("ListViewNodeDblClick");
    addressList.SetUseCheckBox(useOrgListCheckBox);
    addressList.DataBind("AddressListView");
    addressList.DataSource(get_xmldom_addresslistview(xmlDom));
    addressList.RowDataBind();

    for (var i = 0; i < addressList.GetRowCount() ; i++) {
        addressList.GetDataRows()[i].draggable = true;
        addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };

        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            addressList.GetDataRows()[i].ondragend = function (event) { event_listdragend(event); };
        }
    }

    document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
    addressPagination.totalCount = Number(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue);
    changeCheckBox();
}


/**
 * 현재 조직도 탭 ID 구하기
 * @return string
 */
function getOrganCurrentTabId() {
    return document.querySelector(".organ.tab_menu > p.on").dataset.tabId;
}

function infoview_click() {
    const rows = getOrganSelectedRows();

    if (rows.length !== 1) {
        return;
    }

    const row = rows[0];
    show_personinfo(`${row.email}`);
    //createLayerPopup(650, 670, `/ezCommon/new/showPersonInfo.do?id=${row.id}&dept=${row.deptId}`).open();
}

/**
 * 조직도에서 선택된 rows 구하기
 * @param {boolean} withAlerts - 이메일이 없는 단일주소록 등 경고 alert 사용 여부
 * @return OrganSelectData[]
 */
function getOrganSelectedRows(withAlerts = true) {
    switch (getOrganCurrentTabId()) {
        // 조직도
        case "org": {
            const users = getSelectedOrganUsers();

            // 사용자 리턴
            if (users.length > 0) {
                return users;
            }

            // 선택된 사용자가 없으면 부서 리턴
            const deptTree = new TreeView();
            deptTree.LoadFromID("FromTreeView");
            const selectedDept = deptTree.GetSelectNode();

            if (selectedDept) {
                return [{
                    type: OrganSelectType.DEPT,
                    id: selectedDept.GetNodeData("cn"),
                    name: selectedDept.GetNodeData("value"),
                    email: selectedDept.GetNodeData("mail")
                }];
            }

            return [];
        }
        // 조직도 직위
        case "jobTitle": {
            const users = getSelectedOrganUsers();

            // 사용자 리턴
            if (users.length > 0) {
                return users;
            }

            // 선택된 사용자가 없으면 부서 또는 직위 리턴
            const deptTree = new TreeView();
            deptTree.LoadFromID("FromTreeView");
            const selectedNode = deptTree.GetSelectNode();

            if (selectedNode) {
                return [{
                    // 부서 선택이면 부서 리턴, 아니면 직위로 리턴
                    type: selectedNode.GetNodeData("isjob")
                        ? OrganSelectType.JOB_TITLE
                        : OrganSelectType.DEPT,
                    id: selectedNode.GetNodeData("cn"),
                    name: selectedNode.GetNodeData("value"),
                    email: selectedNode.GetNodeData("mail")
                }];
            }

            return [];
        }
        // 조직도 직책
        case "jobRole": {
            const users = getSelectedOrganUsers();

            // 사용자 리턴
            if (users.length > 0) {
                return users;
            }

            // 선택된 사용자가 없으면 부서 또는 직책 리턴
            const deptTree = new TreeView();
            deptTree.LoadFromID("FromTreeView");
            const selectedNode = deptTree.GetSelectNode();

            if (selectedNode) {
                return [{
                    // 부서 선택이면 부서 리턴, 아니면 직책로 리턴
                    type: selectedNode.GetNodeData("isjob")
                        ? OrganSelectType.JOB_ROLE
                        : OrganSelectType.DEPT,
                    id: selectedNode.GetNodeData("cn"),
                    name: selectedNode.GetNodeData("value"),
                    email: selectedNode.GetNodeData("mail")
                }];
            }

            return [];
        }
        case "contact": {
            const pListViewDL = new ListView();
            pListViewDL.LoadFromID("Address");
            /** @type HTMLTableRowElement[] */
            const rows = pListViewDL.GetSelectedRows();

            if (rows.length === 0) {
                return [];
            }

            return rows.map(row => {
                const email = row.getAttribute("DATA3");
                const name = row.cells[0].textContent.trim() || email;

                // 이메일이 없는 주소록 경고
                if (!email.trim()) {
                    if (withAlerts) {
                        alert(name + " " + strLang301);
                    }
                    return null;
                }

                // 이름이 없으면 이메일을 이름으로 씀
                const addressId = row.getAttribute("DATA1");
                const addressType = row.getAttribute("DATA2");

                if (addressType === "mailgroup") {
                    return {
                        type: OrganSelectType.GROUP_ADDRESS,
                        id: addressId,
                        name: name,
                        email: null
                    };
                }

                return {
                    type: OrganSelectType.ADDRESS,
                    id: null,
                    name: name,
                    email: email
                };
            }).filter(array => array !== null);
        }
        case "dl": {
            const dlList = new ListView();
            dlList.LoadFromID("pListViewDL");
            const rows = dlList.GetSelectedRows();

            if (rows.length === 0) {
                return [];
            }

            return rows.map(row => ({
                type: OrganSelectType.DISTRIBUTION,
                id: row.getAttribute("data1"),
                name: row.textContent,
                email: row.getAttribute("data2")
            }));
        }
        case "sharedMail":
            break;
        case "manual":
            const strName = document.getElementById("emailname").value.trim();
            const strEmail = document.getElementById("emailaddr").value.trim();

            if (strName === "") {
                if (withAlerts) {
                    alert(strLang196)
                    document.getElementById("emailname").focus();
                }

                return [];
            }

            if (strEmail === "") {
                if (withAlerts) {
                    alert(strLang197)
                    document.getElementById("emailaddr").focus();
                }

                return [];
            }

            if (strName.indexOf("&") > -1 || strName.indexOf("<") > -1 || strName.indexOf(">") > -1
                || strName.indexOf("\"") > -1 || strName.indexOf("'") > -1 || strName.indexOf(";") > -1) {
                if (withAlerts) {
                    alert(`${strLangNotAllowedSpecialChar} [ & < > " ' ; ]`)
                    document.getElementById("emailname").focus();
                }
                return [];
            }

            if (!/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9_-]+\.[a-zA-Z0-9_.-]+$/.test(strEmail)) {
                if (withAlerts) {
                    alert(strLang198)
                    document.getElementById("emailaddr").focus();
                }

                return [];
            }

            return [{
                type: OrganSelectType.MANUAL,
                id: null,
                name: strName,
                email: strEmail
            }];
    }
}

function clearOrganSelectFocus() {
    switch (getOrganCurrentTabId()) {

    }
}

/*


    /!** 수출용 시작 *!/
    function setMultiple(bool) {

    }

    function showDeptSelectButton() {

    }

    function getOrganCurrentTabId() {
        return document.querySelector(".organ.tab_menu > dt.on").dataset.tabId;
    }

    function getSelectedRows() {

    }

    function addSelectEventListener(listener) {

    }

    return {
        setMultiple: setMultiple,
        showDeptSelectButton: showDeptSelectButton,
        getOrganCurrentTabId: getOrganCurrentTabId,
        getSelectedRows: getSelectedRows,
        addSelectEventListener: addSelectEventListener
    }
}).bind(window)();*/


/**
 * 조직도 선택 유형(사용자, 부서, 주소록, 직위, 직책 등)
 * @readonly
 * @enum {string}
 */
const OrganSelectType = Object.freeze({
    USER: "user",
    DEPT: "dept",
    JOB_TITLE: "title",
    JOB_ROLE: "role",
    /** 주소록 */
    ADDRESS: "address",
    /** 그룹주소록 */
    GROUP_ADDRESS: "groupaddress",
    /** 공용배포그룹 */
    DISTRIBUTION: "distribution",
    /** 직접 입력 */
    MANUAL: "manual",
    /** 그룹주소록 구성원 또는 공용배포그룹 구성원 등 */
    UNKNOWN: "unknown"
});

/**
 * 조직도에서 선택한 데이터를 담는 데이터 구조
 * @typedef {Object} OrganSelectData
 * @property {OrganSelectType} type - 선택 유형
 * @property {string} [id] - 아이디(사용자 또는 부서의 CN)
 * @property {string} [name] - 이름
 * @property {string} [email] - 이메일 주소
 */

/**
 * 조직도에서 사용자나 부서를 선택할 때 호출되는 이벤트의 리스너 콜백 함수 구조
 * @callback OrganSelectEventListener
 * @param {OrganSelectData} data - 선택한 조직도 데이터
 */

/**
 * 조직도 선택 이벤트 리스너를 저장하는 배열
 * @type {OrganSelectEventListener[]} */
const organSelectListeners = [];

/**
 * 조직도 선택 이벤트 리스너 추가하기
 * @param {OrganSelectEventListener} listener - 이벤트 발생 시 호출되는 리스너
 */
function addOnOrganSelectEvent(listener) {
    organSelectListeners.push(listener);
}

/**
 * 조직도 선택 이벤트 콜
 * @param {OrganSelectData} data
 * @private
 */
function callOrganSelectEvent(data) {
    for (const listener of organSelectListeners) {
        listener(data);
    }
}