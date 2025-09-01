


var pParams;
function InitOrganInfo_New() {
    InitList();
    if (!MakeTreeView_New()) {
        SelCompanyFlag = false;
        return false;
    }    
    return true;
}
var organTree;
var userList;
var selectedList;
var selectedListM;
var searchListUser;

var g_height = 0;
function InitList() {
    $("#RowCnt").text(0);
    $("#RowCntM").text(0 + strLang58);
    selectedList = makeSelectedList([], "SelectedList", selectedList);
    selectedListM = makeSelectedList([], "SelectedListM", selectedListM);
}


// 강제로 selected 초기화 (모든 노드에서 selected: true 제거)
function clearSelectedFlag(data) {
    if (!data) return;
    for (var i = 0; i < data.length; i++) {
        if (data[i].state && data[i].state.selected === true) {
            data[i].state.selected = false;
        }
        // 재귀 하위 노드도 처리
        if (data[i].nodes && data[i].nodes.length > 0) {
            clearSelectedFlag(data[i].nodes);
        }
    }
}

function expandPathToDept(deptId, nodes) {
    function dfs(node, path) {
        if (!node) return false;
        path.push(node);

        if (node.data2 === deptId) {
            return true;
        }

        if (node.nodes) {
            for (var i = 0; i < node.nodes.length; i++) {
                if (dfs(node.nodes[i], path)) return true;
            }
        }

        path.pop();
        return false;
    }

    for (var i = 0; i < nodes.length; i++) {
        var path = [];
        if (dfs(nodes[i], path)) {
            for (var j = 0; j < path.length; j++) {
                if (!path[j].state) path[j].state = {};
                path[j].state.expanded = true;
            }
            break;
        }
    }
}

var property = "mail;presence;upnName;mobile;telephoneNumber;teamsId;extensionAttribute10;description;extensionAttribute2;chargeBusiness;physicalDeliveryOfficeName;addJob";
var option = {ignoreCase: false, exactMatch: true};

function MakeTreeView_New() {
    try {
        var topId = "";
        var listCompany = $("#ListCompany")[0];
        if (listCompany && listCompany.options.length > 0) {
            topId = listCompany.options[listCompany.selectedIndex].value;
        } else if (typeof userInfo !== "undefined" && userInfo.companyId) {
            topId = userInfo.companyId;
        } else {
            toastMessage("회사 정보가 없습니다.", null, "1");
            return false;
        }

        var jsonParam = {
            deptid: SelCompanyFlag ? "" : SELECT_DEPTID,
            topid: topId.toLowerCase(),
            prop: property
        };

        $.ajax({
            url: "/ezOrgan/getTotalTreeInfo.do",
            method: "POST",
            data: JSON.stringify(jsonParam),
            contentType: "application/json; charset=UTF-8",
            dataType: "json",
            async: false,
            success: function (response) {
                data = response;
                if ($('#TreeView').data('treeview')) {
                    $('#TreeView').treeview('remove');
                }

                clearSelectedFlag(data);
                expandPathToDept(SELECT_DEPTID, data);
                makeOrganTree(data, "TreeView");

                var initnode = findNodes(SELECT_DEPTID, "data2", organTree, {exactMatch: true, ignoreCase: false});
                if (initnode.length > 0) {
                    organTree.treeview('selectNode', [initnode[0].nodeId, {silent: false}]);
                    displayUserList(initnode[0]);
                } else {
                    initnode = findNodes(0, "nodeId", organTree);
                    organTree.treeview('selectNode', [initnode[0].nodeId, {silent: false}]);
                }
            }
        });

        return true;
    } catch (e) {
        toastMessage(" TreeViewinitialize : " + e.message, null, "1");
        return false;
    }
}



// 부서 트리뷰 (모바일 화면의경우 사용자까지 보이도록 생성)
function makeOrganTree(data, divID) {
    is_init = true;
    organTree = $("#" + divID).treeview({ // 트리뷰 생성 영역
        data: data,
        showCheckbox: true,
        propertyList: property,
        useKebab : true,
        treeType : "organ",
        // 각 이벤트 함수
        onNodeSelected: function (event, node) {
            if (SELECT_DEPTID === node.data2) return;

            organTree.treeview('selectNode', [node.nodeId, { silent: true }]);
            if (node.data1.toUpperCase() == "DEPT" ) {
                
                displayUserList(node);
                if (!(node.hasDeptUser.toUpperCase() == "TRUE" || node.hasDept.toUpperCase() == "TRUE") && $('body')[0].offsetWidth < 749) {
                    toastMessage(strLang41, null, "1");
                }
            }
            SELECT_DEPTID = node.data2;
            
        },            
        onNodeChecked: function (event, node) {
            userList.treeview('checkNode', [findNodes(node.teamsId, "teamsId", userList), { silent: true }]); // 트리뷰에서 선택한 사용자 유저리스트에서도 체크처리

            var result = Check_Row(node);            
            if (!result) {                    
                organTree.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", organTree), { silent: true }]);
            } else {
                organTree.treeview('checkNode', [findNodes(node.teamsId, "teamsId", organTree), { silent: true }]);
            }
            infoBoxToggle("");
        },
        onNodeUnchecked: function (event, node) {
            organTree.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", organTree), { silent: true }]);
            userList.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", userList), { silent: true }]);
            Check_Row(node);
            infoBoxToggle("");
        },
        onClickChatIcon: function (event, node) {
            if (node.upnName && node.upnName.trim() != "" && node.teamsId && node.teamsId.trim() != "")
                btn_OpenConversation(node.upnName);
            else
                btn_OpenConversation_Fail();
        },
        onClickCallIcon: function (event, node) {
            if (isMobile()) {
                if (node.upnName && node.upnName.trim() != "" && node.mobile && node.mobile.trim() != "") {
                    btn_OpenTel(node.mobile, node.upnName);
                }
                else {
                    noTelNumber();
                }
            } else {
                if (node.upnName && node.upnName.trim() != "" && node.teamsId && node.teamsId.trim() != "") {
                    btn_OpenCall(node.upnName);
                }
                else {
                    btn_OpenConversation_Fail();
                }
            }            
        },
        onNodeExpanded: function (event, node) {
            if (node.nodes) {
                var childNodes = findNodes(node.nodeId, "parentId", organTree).filter(function (nodeFilter) { return nodeFilter.data1.toUpperCase() == "USER" && nodeFilter.presence.trim() != "" && nodeFilter.data2 != g_strUserId.split("@")[0].toLowerCase() });
                for (var i = 0; i < childNodes.length; i++) {
                    var checkedUser = findNodes("true", "state.checked", selectedList).filter(function (userFilter) { return userFilter.teamsId == childNodes[i].teamsId });
                    if (checkedUser && checkedUser.length > 0) {
                        organTree.treeview('checkNode', [findNodes(childNodes[i].nodeId, "nodeId", organTree), { silent: true }]);
                    }
                }
            }
        },
        onClickUserImg: function (event, node) { // 프로필 이미지 클릭시 유저 정보창 호출
            nameCard(node, organTree);
            currLayer = '.layerPopup_info, .Main_Panel';
            toggleClassFn(currLayer);
            organTree.treeview('unselectNode', [node.nodeId, { silent: true }]);
        },
        onClickKebabMenu: function (event, node) {
            currLayer = '.layer_kebob, .Main_Panel';
            toggleClassFn(currLayer);
            // 모바일 화면 대화, 전화 버튼 START
            $('.layer_kebob  .i_talk').removeAttr("onclick");
            $('.layer_kebob  .i_call').removeAttr("onclick");
            $('.layer_kebob .i_phone').removeAttr("onclick").off("click");

            // if (node.upnName && node.upnName.trim() != "" && node.presence && node.presence.trim() != "")
            if (node.upnName && node.upnName.trim() != "" && node.teamsId && node.teamsId.trim() != "") {
                $('.layer_kebob .i_talk').off("click").on("click", function () {
                    btn_OpenConversation(node.upnName);
                });
            } else {
                $('.layer_kebob .i_talk').on("click", function () {
                    btn_OpenConversation_Fail();
                });
            }
            /* (전화) 버튼 이벤트 설정 */
            if (isMobile()) {
                if (node.upnName && node.upnName.trim() != "" && node.mobile && node.mobile.trim() != "") {
                    $('.layer_kebob .i_phone').removeAttr("onclick").on("click", function () {
                        btn_OpenTel(node.mobile, node.upnName);
                    });
                } else {
                    $('.layer_kebob .i_phone').on("click", function () {
                        noTelNumber();
                    });
                }
            } else {
                if (node.upnName && node.upnName.trim() != "" && node.teamsId && node.teamsId.trim() != "") {
                    $('.layer_kebob .i_phone').removeAttr("onclick").on("click", function () {
                        btn_OpenCall(node.upnName);
                    });
                } else {
                    $('.layer_kebob .i_phone').on("click", function () {
                        btn_OpenConversation_Fail();
                    });
                }
            }
            // 모바일 화면 대화, 전화 버튼 END
        }
    });

    infoBoxToggle("");
    organTree.treeview('treeViewScrollTo', []);
    
    is_init = false;
}
// 유저 리스트 트리뷰 생성
function makeUserList(data, divID,mode ="user" ) {
    if (data.length == 0 || !data) {
        $("#ItemList_Div").hide();
        $("#noData_Div").show();
    } else {
        $("#ItemList_Div").show();
        $("#noData_Div").hide();
    }
    var userData = data.map(e => {
        e.nodeLevel = 0;
        if (e.data2.toLowerCase() === g_strUserId.split("@")[0].toLowerCase()) {
            if (e.state) e.state.checked = false;
        }
        return e;
    });
    userList = $("#" + divID).treeview({ // 트리뷰 생성 영역
        data: userData,
        showCheckbox: true,
        propertyList: property,
        selectable: false,
        treeType: (mode == "search"? "search" : "user"),
        // 각 이벤트 함수
        onNodeSelected: function (event, node) {
            nameCard(node,userList);
            infoBoxToggle("0");
            userList.treeview('unselectNode', [node.nodeId, { silent: true }]);
        },
        onNodeChecked: function (event, node) {
            nameCard(node, userList);
            organTree.treeview('checkNode', [findNodes(node.teamsId, "teamsId", organTree), {silent: true}]);
            var result = Check_Row(node);
            if (!result) {
                userList.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", userList), { silent: true }]);
            } else {
                userList.treeview('checkNode', [findNodes(node.teamsId, "teamsId", userList), { silent: true }]);
            }

            if ($('body')[0].offsetHeight < 450)
                infoBoxToggle("");
        },
        onNodeUnchecked: function (event, node) {
            nameCard(node, userList);
            organTree.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", organTree), { silent: true }]);
            userList.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", userList), { silent: true }]);
            Check_Row(node);

            if ($('body')[0].offsetHeight < 450)
                infoBoxToggle("");
        },
        onClickUserImg: function (event, node) { // 프로필 이미지 클릭시 유저 정보창 호출
            if (isMobile() || isTabletDevice()) {
                nameCard(node, userList);
                currLayer = '.layerPopup_info, .Main_Panel';
                toggleClassFn(currLayer);
            } else {
                nameCard(node, userList);
                infoBoxToggle("0");
            }
            userList.treeview('unselectNode', [node.nodeId, { silent: true }]);
        }
    });
    infoBoxToggle("");
}
function makeSelectedList(data, divID,obj) {
    var selectedData = data.map(e => {
        e.nodeLevel = 0;
        return e;
    });
    obj = $("#" + divID).treeview({
        data: selectedData,
        propertyList: property,
        showCheckbox: true,
        treeType: "select",
        onClickDeleteImg: function (event, node) {    
            userList.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", userList), { silent: true }]);
            organTree.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", organTree), { silent: true }]);
            Check_Row(node);
        }
    });
    return obj;
}

function makeSearchList(data, divID, mode) {
    
    var searchedData = data.map(e => {
        e.nodeLevel = 0;
        return e;
    });
    var deptNodes = searchedData.filter(function (deptNode) { return deptNode.data1.toUpperCase() == "DEPT" });
    var userNodes = searchedData.filter(function (deptNode) { return deptNode.data1.toUpperCase() == "USER" });
    
    $("#searchedDeptCnt").text(deptNodes.length);
    $("#searchedDeptCntM").text(deptNodes.length);
    $("#searchedUserCntM").text(userNodes.length);

    searchList = $("#" + divID).treeview({ // 웹화면 부서 검색결과
        data: deptNodes,
        propertyList: property,
        treeType: "searchDept"
    });
    searchListDept = $("#" + divID + "MDept").treeview({ // 모바일 화면 부서 검색결과
        data: deptNodes,
        propertyList: property,
        treeType: "searchDeptM",
        onNodeSelected: function (event, node) {
            searchListDept.treeview('unselectNode', [node, {silent:true}]);
            ReturnFunction(node.data2);
            searchM = false;
        }
    });
    searchListUser = $("#" + divID + "MUser").treeview({ // 모바일 화면 사용자 검색결과
        data: userNodes,
        propertyList: property,
        showCheckbox: true,
        treeType: "searchUserM",
        selectable: false,
        onNodeSelected: function (event, node) {
            searchListUser.treeview('unselectNode', [node, {silent:true}]);
        },
        onNodeChecked: function (event, node) {
            if (node.data2.toLowerCase() == g_strUserId.split("@")[0].toLowerCase()) {
                toastMessage(strLang14, null, "1");
                searchListUser.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", searchListUser), {silent: true}]);
            } else {
                searchListUser.treeview('checkNode', [findNodes(node.teamsId, "teamsId", searchListUser), {silent: true}]);
            }
            toggleCheckSearchedUser();

        },
        onNodeUnchecked: function (event, node) {
            searchListUser.treeview('uncheckNode', [findNodes(node.teamsId, "teamsId", searchListUser), {silent: true}]);

            toggleCheckSearchedUser();
        },
        onClickUserImg: function (event, node) { // 프로필 이미지 클릭시 유저 정보창 호출
            searchM = true;
            nameCard(node, searchListUser);
            currLayer = '.layerPopup_info';
            toggleClassFn(currLayer);
            searchListUser.treeview('unselectNode', [node.nodeId, { silent: true }]);
        }
    });
    
    if (userNodes.length > 0) {
        if (mode == "MOB" ) {
            makeUserList(userNodes, "ItemList_Div", "search");
            SetCheckBox();
            Control_View("SEARCH");
        }
    }
}
var findNodes = function (searchValue, attr, obj, options) {
    // displayneme 의 경우 attr 빈값
    var modifier = 'g';
    if (!options || options == '') {
        searchValue = '^' + searchValue + '$';
        modifier += 'i';
    } else {
        if (options.exactMatch) {
            searchValue = '^' + searchValue + '$';
        }
        if (options.ignoreCase) {
            modifier += 'i';
        }
    }
    return obj.treeview('findNodes', [searchValue, modifier, attr]);
};
function search_press() {
    if (window.event.keyCode == 13) {
        search_click();
    }
}

var searchFlag = false;

function search_click() {
    // 입력 포커스 해제
    $("input").blur();
    g_IsSearch = true;

    var keywordVal = document.getElementById("keyword").value.trim();
    var searchType = document.getElementById("search_type").value;

    // 공백 체크
    if (keywordVal === "") {
        toastMessage(strLang5, null, "1");
        document.getElementById("keyword").focus();
        return;
    }

    g_strKeyword = keywordVal;

    $.ajax({
        type: "POST",
        dataType: "json",
        async: true,
        url: "/ezOrgan/getTeamsSearchListJson.do",
        data: {
            search: searchType + "::" + keywordVal,
            cell: "cn;extensionAttribute2;displayName;extensionAttribute10;title;description;telephoneNumber;mail;teamsId;chargeBusiness",
            prop: property,
            type: "user",
            companyid: $("#ListCompany").val()
        },
        success: function (jsonData) {
            // var dom = loadXMLString(xml);
            // event_displayUserList(dom);
            event_displayUserList(jsonData);  // xml 그대로 넘기기

            // Presence 체크 (OCS 사용 시)
            if ("${useOcs}" === "YES") {
                check_presence();
            }
        },
        error: function (err) {
            toastMessage(err.statusText, null, "2");
        }
    });

    // Shift 키 초기화 방지 조치
    PressShiftKey = false;
}

function deptsearch_press(mode) {
    if (window.event.keyCode == "13")
        deptsearch_click(mode);
}

var g_selectedDeptId = "";

function deptsearch_click(mode) {
    $("input").blur();

    var keywordvalue = (mode === "WEB" ? deptkeyword.value : keywordM.value).trim();
    if (keywordvalue === "") {
        toastMessage(strLang5, null, "1");
        return;
    }

    deptkeyword.value = keywordvalue;
    keywordM.value = keywordvalue;

    var adCount = 0;
    var resultData = [];

    $.ajax({
        type: "POST",
        url: "/ezOrgan/getTeamsSearchListJson.do",
        dataType: "json",
        async: false,
        data: {
            search: "displayName::" + encodeURIComponent(keywordvalue),
            cell: "extensionAttribute3;displayName;extensionAttribute9",
            prop: "",
            type: (mode === "WEB" ? "DEPT" : "all"),
            adminOrgan: "y"
        },
        success: function (result) {
            resultData = result;
            adCount = result.length;
        },
        error: function (error) {
            toastMessage(strLang8 + e.description, null, "1");
        }
    });

    if (mode === "MOB") {
        keyword.value = keywordM.value; // 모바일에서만 복사
    }

    if (adCount === 0) {
        if (mode === "WEB") {
            toastMessage(strLang9, null, "1");
        } else {
            keywordM.value = "";
            toastMessage(strLang67, null, "1");
        }
        return;

    } else if (adCount === 1 && mode === "WEB") {
        bSearch = true;
        var deptId = resultData[0].data2;
        g_selectedDeptId = deptId;
        var jsonParam = {
            deptid: deptId,
            topid: $("#ListCompany").val(),
            prop: property,
            type: "DEPT"
        };

        $.ajax({
            url: "/ezOrgan/getTotalTreeInfo.do",
            method: "POST",
            data: JSON.stringify(jsonParam),
            contentType: "application/json; charset=UTF-8",
            dataType: "json",
            async: true,
            success: function (response) {
                event_getDeptFullTree(response);
            }
        });

    } else {
        if (mode === "WEB") {
            currLayer = '.layerPopup_serch, .Main_Panel';
            toggleClassFn(currLayer);
        }

        $("#searchValue").text('"' + keywordvalue + '"');


        makeSearchList(resultData, "searchList", mode);
        SetCheckBox();
    }
}

function event_getDeptFullTree(response) {
    try {
        $("#TreeView")[0].innerHTML = "";

        data = response;
        makeOrganTree(data, "TreeView");

        var initnode = findNodes(g_selectedDeptId, "data2", organTree, {
            exactMatch: true,
            ignoreCase: false
        });

        if (initnode.length > 0) {
            if (!(((initnode[0].hasDeptUser || "FALSE").toUpperCase() === "TRUE") || ((initnode[0].hasDept || "FALSE").toUpperCase() === "TRUE")) && $('body')[0].offsetWidth < 749) {
                toastMessage(strLang41, null, "1");
            }
            displayUserList(initnode[0]);
        }
        SetCheckBox();
    } catch (e) {
        toastMessage(strLang10, null, "1");
    }
}

function ReturnFunction(selectedID) {
    if (!selectedID) {
        var selected = findNodes("true", "state.selected", searchList);
        if (selected) {
            selectedID = selected[0].data2;
        }
    }
    g_selectedDeptId = selectedID;

    var topId = $("#ListCompany")[0].options[$("#ListCompany")[0].selectedIndex].value;

    var jsonParam = {
        deptid: selectedID,
        topid: topId,
        prop: property,
        type: "DEPT"
    };

    $.ajax({
        url: "/ezOrgan/getTotalTreeInfo.do",
        method: "POST",
        data: JSON.stringify(jsonParam),
        contentType: "application/json; charset=UTF-8",
        dataType: "json",
        async: false,
        success: function(response) {
            event_getDeptFullTree(response);
        }
    });

    currLayer = '.layerPopup_serch, .Main_Panel';
    toggleClassFn(currLayer);
}

function ReturnFunction_User(userid, deptID) {
    if (userid !== "") {
        var jsonParam = {
            deptid: deptID,
            topid: $("#ListCompany")[0].options[$("#ListCompany")[0].selectedIndex].value,
            userid: userid,
            prop: property,
            type: "USER"
        };

        $.ajax({
            url: "/ezOrgan/getTotalTreeInfo.do",
            method: "POST",
            data: JSON.stringify(jsonParam),
            contentType: "application/json; charset=UTF-8",
            dataType: "json",
            async: false,
            success: function(response) {
                event_getDeptFullTree(response);
            }
        });

        currLayer = '.layerPopup_serch, .Main_Panel';
        toggleClassFn(currLayer);
    }
}

function AddContact() {
    var listview = new OrganView();
    listview.LoadFromID("SelectedList");
    var Selected = listview.GetDataRows();

    if (Selected.length == 0) {
        toastMessage(strLang13, null, "1");
    } else if (Selected.length == 1) {
        try {
            var selectID = Selected[0].getAttribute("DATA3");
            if (selectID == "") {
                toastMessage(strLang16, null, "1");
            }
            else if (selectID.toLowerCase() != g_strUserId.toLowerCase()) {
                executeComponent("AddContactList.exe", selectID + " " + g_strUserLanguage)
            } else {
                toastMessage(strLang14, null, "1");
            }
        } catch (e) {
            toastMessage(strLang15, null, "1");
        }
    } else {
        var friendList = "";
        for (var i = 0; i < Selected.length; i++) {
            try {
                var selectID = Selected[i].getAttribute("DATA3");
                if (selectID.toLowerCase() != g_strUserId.toLowerCase()) {
                    friendList += selectID + ";";
                }
            } catch (e) {
            }
        }
        // 마지막 ';' 제거
        if (friendList.indexOf(';') > -1) {
            friendList = friendList.substring(0, friendList.length - 1);
        }
        executeComponent("AddContactList.exe", friendList + " " + g_strUserLanguage)
    }
} //AddContact

function MailSend(pEmail) {
    if (pEmail.tagName == "SPAN") {
        document.location.href = "mailto:" + pEmail.innerText;
    }
}

function Check_Row(checkbox) {
    var rtnValue = true;
    if (checkbox.state.checked) {
        if (checkbox.data2.toLowerCase() != g_strUserId.split("@")[0].toLowerCase()) { // 본인인지 확인
            // 선택영역 사용자 추가
            ExtUserAdd(checkbox);
            checkbox.state.checked = true;
            setTimeout(function() { Control_View("SEL"); }, 0);
        } else {
            toastMessage(strLang14, null, "1");
            checkbox.state.checked = false;
            rtnValue = false;
            return rtnValue;
        }
    } else {
        // 선택영역에 사용자 삭제
        ExtUserDel(checkbox);
        Control_View("DEL");
    }

    return rtnValue;
}

function Check_AllRows() {
    if ($("#HeaderAllCheckBox").is(":checked")) {
        var userNodes = userList.treeview("getNodeAll");
        for (var i = 0; i < userNodes.length; i++) {
            if (userNodes[i].data2.trim() != g_strUserId.split("@")[0].toLowerCase()) {
                if (userNodes[i].teamsId.trim() != "") {
                    organTree.treeview('checkNode', [findNodes(userNodes[i].teamsId, "teamsId", organTree), {silent: true}]);
                    userList.treeview('checkNode', [findNodes(userNodes[i].teamsId, "teamsId", userList), {silent: true}]);
                    ExtUserAdd(userNodes[i]);
                }
            }
        }
    } else {
        var userNodes = userList.treeview("getNodeAll");
        for (var i = 0; i < userNodes.length; i++) {
            if (userNodes[i].data2.trim() != g_strUserId.split("@")[0].toLowerCase()) {
                if (userNodes[i].teamsId.trim() != "") {
                    organTree.treeview('uncheckNode', [findNodes(userNodes[i].teamsId, "teamsId", organTree), {silent: true}]);
                    userList.treeview('uncheckNode', [findNodes(userNodes[i].teamsId, "teamsId", userList), {silent: true}]);
                    ExtUserDel(userNodes[i]);
                }
            }
        }
    }
    Control_View("ALL");
}


function Check_AllSearchedRows() {
    if (searchListUser) {

        var userNodes = searchListUser.treeview('getNodeAll').filter(
            function (allUserNode) {
                return allUserNode.teamsId.trim() != "" && allUserNode.data1.toUpperCase() == "USER" && allUserNode.data2 != g_strUserId.split("@")[0].toLowerCase()
            }
        );
        if (userNodes.length > 0) {
            $("#allCheckSearchedUser").toggleClass('clicked');
            for (var i = 0; i < userNodes.length; i++) {
                if (userNodes[i].data2.trim() != g_strUserId.split("@")[0].toLowerCase() && userNodes[i].teamsId.trim() != "") {
                    if (!allCheckSearchFlag) {
                        searchListUser.treeview('checkNode', [findNodes(userNodes[i].teamsId, "teamsId", searchListUser), {silent: true}]);
                    } else {
                        searchListUser.treeview('uncheckNode', [findNodes(userNodes[i].teamsId, "teamsId", searchListUser), {silent: true}]);
                    }
                }
            }
            allCheckSearchFlag = !allCheckSearchFlag;
        }

    } else {
        toastMessage(strLang67, null, "1");
    }

}

function ExtUserAdd(node) {
    if ($(selectedList)[0].querySelectorAll("li[data2='" + node.data2 + "']").length == 0) {
        selectedList.treeview("ExtUserAdd", [node]);
        selectedListM.treeview("ExtUserAdd", [node]);
    }
}

function ExtUserDel(node) {
    if ($(selectedList)[0].querySelectorAll("li[data2='" + node.data2 + "']").length > 0) {
        selectedList.treeview("ExtUserDel", [node]);
        selectedListM.treeview("ExtUserDel", [node]);
    }
}

function Control_View(mode) {                 
    // mode > "ALL" : 전체선택 , 부서선택시 /  "SEL" : 각 사용자 선택시
    var rowcnt = $(selectedList)[0].querySelectorAll("li").length;                  // 전체 선택된 사용자 수
    var allUserList = userList.treeview('getNodeAll');                              // 현재 부서 전체 사용자
    var selectedUserList = findNodes("true", "state.checked", userList);            // 현재 부서에서 선택된 사용자 수
    var checkableUserCnt = allUserList.filter(                                      // 현재 부서 사용자중 체크박스 활성화된 사용자 수
        function (allUserNode) {
            return allUserNode.teamsId.trim() != "" && allUserNode.data1.toUpperCase() == "USER" && allUserNode.data2 != g_strUserId.split("@")[0].toLowerCase();
        }
    ).length;
    if (mode == "SEARCH") {
        $("#selectedDeptName").text("");
    }

    $("#RowCnt").text(rowcnt);
    $("#RowCntM").text(rowcnt);
    $("#userCnt").text(allUserList.length);
    $("#selCntM").text(rowcnt);

    if (rowcnt == 0) {
        $("#HeaderAllCheckBox").prop("checked", false);
        $('.select_toggle, .select_user_toggle').removeClass('active'); // 전체 선택된 사용자 수 0명일때 선택영역 숨김        
    } else if (rowcnt > 1) { 
        if ($('body')[0].offsetWidth > 920)
            $('.select_toggle, .select_user_toggle').addClass('active'); // 선택된 사용자 2명 이상일경우 선택영역 표시
    }

    if (selectedUserList.length != checkableUserCnt || checkableUserCnt == 0) {
        $("#HeaderAllCheckBox").prop("checked", false);
        $("#allCheckSearchedUser").removeClass("clicked");
    } else {
        $("#HeaderAllCheckBox").prop("checked", true);
        $("#allCheckSearchedUser").addClass("clicked");
    }
}

function delete_onClick() {
    selectedList = makeSelectedList([], "SelectedList", selectedList);
    selectedListM = makeSelectedList([], "SelectedListM", selectedListM);
    organTree.treeview('uncheckAll', [{silent: true}]); // 체크박스 전부 해제
    userList.treeview('uncheckAll', [{silent: true}]);  // 체크박스 전부 해제
    Control_View("ALL");
}

function event_displayUserList(jsonData) {
    if (!jsonData || jsonData.length === 0) {
        toastMessage(strLang67, null, "1");
        return;
    }
    if (g_IsSearch === true) {
        var selectedDept = findNodes("true", "state.selected", organTree);
        if (selectedDept.length > 0) {
            organTree.treeview("unselectNode", [selectedDept[0]], { silent: true });
            SELECT_DEPTID = "";
        }
        g_IsSearch = false;
    } else {
        // 검색이 아닐 때만 원래대로 toggle
        var selectedDept = findNodes("true", "state.selected", organTree);
        if (selectedDept.length > 0) {
            if (selectedDept[0].data1.toUpperCase() === "DEPT") {
                organTree.treeview("toggleSelectedState", [selectedDept[0]], { silent: true });
                SELECT_DEPTID = "";
            }
        }
    }
    
    makeUserList(jsonData, "ItemList_Div", "search");
    makeSearchList(jsonData, "searchList", "WEB");
    SetCheckBox();
    setTimeout(function() { Control_View("SEARCH"); }, 0);
}

// ######## 조직도 개선 ############

function displayUserList(node) {
    keyword.value = "";
    g_strKeyword = "";
    if (!node || typeof node.nodeId === "undefined") {
        console.error("displayUserList: 잘못된 node", node);
        return;
    }
    // 선택부서 하위 사용자
    var childNodeData = [];
    findNodes(node.nodeId, "parentId", organTree).filter(function (nodeFilter) {
        if (nodeFilter.data1.toUpperCase() == "USER")
            childNodeData.push(nodeFilter);
    });
    $("#selectedDeptName").text(node.displayName); // 선택한 부서 이름 표시
    $("#noDataDept").text("\"" + node.displayName + "\""); // 선택한 부서 이름 표시
    makeUserList(childNodeData, "ItemList_Div");
    SetCheckBox();
    setTimeout(function() { Control_View("ALL"); }, 0);
}

function SetCheckBox() {
    var selectedNodes = findNodes("true", "state.checked", selectedList);
    if (selectedNodes.length > 0) {
        for (var i = 0; i < selectedNodes.length; i++) {
            try {
                var selectID = selectedNodes[i].teamsId;
                organTree.treeview('checkNode', [findNodes(selectID, "teamsId", organTree), {silent: true}]);
                userList.treeview('checkNode', [findNodes(selectID, "teamsId", userList), {silent: true}]);
                if (searchListUser)
                    searchListUser.treeview('checkNode', [findNodes(selectID, "teamsId", searchListUser), {silent: true}]);
            } catch (e) {
            }
        }
    } else {
        organTree.treeview('uncheckAll');
        userList.treeview('uncheckAll');

    }
}

function deleteSelectedUser(e) {

    var targetNode = findNodes(e.target.getAttribute("cn"), "data2", organTree);
    if (targetNode.length > 0) {
        userList.treeview('uncheckNode', [findNodes(targetNode[0].teamsId, "teamsId", userList), {silent: true}]);
        organTree.treeview('uncheckNode', [findNodes(targetNode[0].teamsId, "teamsId", organTree), {silent: true}]);
    } else {
        targetNode = findNodes(e.target.getAttribute("cn"), "data2", userList);
        userList.treeview('uncheckNode', [findNodes(targetNode[0].teamsId, "teamsId", userList), {silent: true}]);
        organTree.treeview('uncheckNode', [findNodes(targetNode[0].teamsId, "teamsId", organTree), {silent: true}]);
    }


    Check_Row(targetNode[0]);
    let selected = selectedList.treeview('getNodeAll', []);
    $("#groupCntChat").text(selected.length);
    $("#groupCntTeam").text(selected.length);

    $(e.target).remove();
}

function addCheckedNodes() {
    var allNodes = searchListUser ? searchListUser.treeview('getNodeAll') : [];
    var selectedNodes = findNodes("true", "state.selected", searchListDept);
    var addCount = 0;

    for (var i = 0; i < allNodes.length; i++) {
        var node = allNodes[i];
        var teamsId = node.teamsId;
        if (node.state && node.state.checked === true) {
            organTree.treeview('checkNode', [findNodes(teamsId, "teamsId", organTree), {silent: true}]);
            userList.treeview('checkNode', [findNodes(teamsId, "teamsId", userList), {silent: true}]);
            ExtUserAdd(node);
            addCount++;
        } else if (node.teamsId) {
            organTree.treeview('uncheckNode', [findNodes(teamsId, "teamsId", organTree), {silent: true}]);
            userList.treeview('uncheckNode', [findNodes(teamsId, "teamsId", userList), {silent: true}]);
            ExtUserDel(node);
        }
    }
    Control_View("ALL");
    toastMessage(strLang70, null, "1");
    searchM = false;
}

function toggleCheckSearchedUser() {
    var allUserList = searchListUser.treeview('getNodeAll');

    var checkedUserList = findNodes("true", "state.checked", searchListUser);

    var checkableUserCnt = allUserList.filter(
        function (allUserNode) {
            return allUserNode.teamsId.trim() != "" && allUserNode.data1.toUpperCase() == "USER" && allUserNode.data2 != g_strUserId.split("@")[0].toLowerCase();
        }
    ).length;

    if (checkedUserList.length != checkableUserCnt || checkedUserList.length == 0) {
        allCheckSearchFlag = false;
        $("#allCheckSearchedUser").removeClass('clicked');
    } else {
        allCheckSearchFlag = true;
        $("#allCheckSearchedUser").addClass('clicked');
    }
}
