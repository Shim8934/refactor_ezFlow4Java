const ConstantsConstant = Object.freeze({
    LIST_VIEW_USER_ID: "lvUserList",
    TREE_VIEW_DEPT_ID: "FromTreeView",
});

const CommonUtilsMsg = {
    SEARCH_INSERT_PLZ: "", SEARCH_NO_DEPT: "", SEARCH_NO_USER: "",
}

var _initStatChartFn;
var _mode;
var _unit = "month";


function initCommonStatistics(initMsgFn, initFn, mode) {
    _initStatChartFn = initFn;
    _mode = mode;
    initMsgFn();
    initDate();
    initMenus();
    initTab();
    changeCompany(companySelectID);
    document.getElementById("goBackDou").addEventListener("click", (function () {
        _initStatChartFn();
    }));
}

function changeCompany(companyId) {
    callOrganTree(companyId);
    changeMenus();
}

function initDate() {
    var selYear = document.getElementById("searchYear");
    if (!!selYear) {
        makeOptionYear();
        selYear.addEventListener("change", (function () {
            makeOptionYear();
            makeOptionDate();
            _initStatChartFn();
        }));
    }
    var selMonth = document.getElementById("searchMonth");
    if (!!selMonth) selMonth.addEventListener("change", function () {
        makeOptionDate();
        _initStatChartFn()
    });
    var selDay = document.getElementById("searchDay");
    if (!!selDay) selDay.addEventListener("change", function () {
        _initStatChartFn()
    });
}

function callOrganTree(companyId) {
    ConstantsConstant.COMPANY_ID = companyId;
    var xmlpara = createXmlDom();
    var xmlTree = createXmlDom();
    var xmlHTTP = createXMLHttpRequest();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", "");
    createNodeAndInsertText(xmlpara, objNode, "TOPID", companyId + "/organ");
    createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2");
    createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
    xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
    xmlHTTP.send(xmlpara);
    xmlTree = loadXMLString(xmlHTTP.responseText);
    var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
    document.getElementById('TreeView').innerHTML = "";
    var treeView = new TreeView();
    treeView.SetConfig(treeXML);
    treeView.SetID(ConstantsConstant.TREE_VIEW_DEPT_ID);
    treeView.SetUseAgency(true);
    treeView.SetRequestData("RequestData");
    treeView.SetNodeClick(TreeViewNodeClick);
    treeView.DataSource(xmlTree);
    treeView.DataBind("TreeView");
}

function TreeViewNodeClick() {
    var treeView = new TreeView();
    treeView.LoadFromID(ConstantsConstant.TREE_VIEW_DEPT_ID);
    var selnode = treeView.GetSelectNode();
    DeptID = selnode.GetNodeData("CN");
    if (_mode === "user") {
        displayUserList(DeptID);
    } else {
        _initStatChartFn();
    }
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
    createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName");
    createNodeAndInsertText(xmlpara, objNode, "DISPLAY_TRASH_DEPT", "");

    xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
    xmlHTTP.send(xmlpara);
    xmlRtn = loadXMLString(xmlHTTP.responseText);
    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);

    var treeView = new TreeView();
    treeView.LoadFromID(ConstantsConstant.TREE_VIEW_DEPT_ID);
    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

function displayUserList(DeptID) {
    $.ajax({
        type: "POST",
        dataType: "text",
        url: "/ezOrgan/getDeptMemberList.do",
        async: false,
        data: {
            deptID: DeptID,
            cell: "displayName;description",
            prop: "department;displayName;description;title",
            type: "user"
        },
        success: function (result) {
            var retXml = createXmlDom();

            if (document.getElementById("UserList").innerHTML != "")
                document.getElementById("UserList").innerHTML = "";

            var headerData = createXmlDom();
            headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
            if (result != "") {
                var xmlDom = loadXMLString(result);
                if (CrossYN()) {
                    var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                    var Node = headerData.importNode(xmlRtn, true);
                    headerData.documentElement.appendChild(Node);
                } else {
                    var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                    headerData.documentElement.appendChild(xmlRtn);
                }
            }
            var pUserList = new ListView();
            pUserList.SetID(ConstantsConstant.LIST_VIEW_USER_ID);
            pUserList.SetRowOnClick(_initStatChartFn);
            pUserList.SetSelectFlag(false);
            pUserList.SetHeightFree(true);
            pUserList.DataSource(headerData);
            pUserList.DataBind("UserList");
        },
        error: function (error) {
            OpenAlertUI(linealt2 + error)
        }
    });
}

var myChart

function drawChart(labelArr, dataArr) {
    turnDouArea(false);
    var ctx = document.getElementById('chartCanvas');
    if (!!ctx) ctx.remove();
    Array.prototype.forEach.call(document.getElementsByClassName("chartjs-size-monitor"), function (node) {
        node.remove();
    });

    var chartDiv = document.getElementById("chartDiv");
    ctx = document.createElement("canvas");
    ctx.id = 'chartCanvas';
    chartDiv.append(ctx);

    dataArr[0].backgroundColor = genRotateColor();
    dataArr[0].borderWidth = 1;
    if (dataArr.length > 1) {
        dataArr[1].borderColor = genRotateColor();
        dataArr[1].fill = false;
    }


    myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labelArr,
            datasets: dataArr
        },
        options: {
            onClick: function (event, elements) {
                if (!!elements && !!elements[0]) {
                    var element = elements[0];
                    element.labels = labelArr;
                    element.datasets = dataArr;
                    drawInMenuChart(element);
                }
            },
            onHover: function (event, elements) {
                if (!!elements && elements.length > 0) {
                    event.target.style.cursor = 'pointer';
                } else {
                    event.target.style.cursor = 'default';
                }
            },
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: true
                    },
                    stacked: false
                }]
            }
        }
    });
    onChartArea();
}

function drawInMenuChart(element) {
    var curIdx = element._index;
    if (!!element.datasets && element.datasets.length > 1 && element.datasets[1].data[curIdx] == 0) return;
    var dataJson = {
        companyId: companySelectID,
        year: document.getElementById("searchYear").value,
    };
    var selTab = document.querySelector('#tabStatistics .tabover').id;
    var yearNode = $("#searchYear option:selected")[0];
    var monthNode = $("#searchMonth option:selected")[0];
    var dayNode = $("#searchDay option:selected")[0];
    dataJson.year = yearNode.value;
    dataJson.month = monthNode.value;
    dataJson.day = dayNode.value;

    var callUrl = "";
    var titleHead = document.querySelector("#statisticstable tr:nth-child(1) th:nth-child(1)").innerText;
    var titleTexts = [];
    var titleTextCells = document.querySelector("#statisticstable tr:nth-child(2) td:nth-child(1)").children;
    titleTexts.push(titleTextCells[0].innerText + ' ' + element.labels[curIdx]);
    for (var i = 1; i < titleTextCells.length - 1; i++) {
        titleTexts.push(titleTextCells[i].innerText)
    }

    if (_mode === "user") {
        dataJson.userId = getSelUserData("DATA2");
    } else if (_mode === "dept") {
        var treeView = new TreeView();
        treeView.LoadFromID(ConstantsConstant.TREE_VIEW_DEPT_ID);
        var selnode = treeView.GetSelectNode();
        if (!selnode) return;
        dataJson.deptId = selnode.GetNodeData("CN");
    }

    switch (selTab) {
        case "tabMonthly" :
            callUrl = _mode === "user" ? "/ezStatistics/statMenuUserForMonth.do" : "/ezStatistics/statMenuDeptForMonth.do";
            dataJson.month = (curIdx + 1);
            break;
        case "tabDaily" :
            callUrl = _mode === "user" ? "/ezStatistics/statMenuUserForDay.do" : "/ezStatistics/statMenuDeptForDay.do";
            dataJson.day = (curIdx + 1);
            break;
        case "tabHourly" :
            callUrl = _mode === "user" ? "/ezStatistics/statMenuUserForHour.do" : "/ezStatistics/statMenuDeptForHour.do";
            dataJson.hour = curIdx;
            break;
    }

    $.ajax({
        type: "GET",
        url: callUrl,
        async: false,
        datatype: 'json',
        data: dataJson,
        success: function (json) {
            var ctx = document.getElementById('chartCanvas');
            if (!!ctx) ctx.remove();
            Array.prototype.forEach.call(document.getElementsByClassName("chartjs-size-monitor"), function (node) {
                node.remove();
            });

            var chartDiv = document.getElementById("chartDiv");
            ctx = document.createElement("canvas");
            ctx.id = 'chartCanvas';
            chartDiv.append(ctx);
            var datasetsArr = json.datasets;
            datasetsArr[0].backgroundColor = [];
            _defaultColorHis = [];
            for (var i = 0; i < json.labels.length; i++) {
                datasetsArr[0].backgroundColor.push(genRotateColor());
            }

            var douChart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: json.labels,
                    datasets: datasetsArr
                }
            });

            drawTable(json.labels, datasetsArr[0].data, Math.ceil(json.labels.length/8), titleHead, titleTexts);
            turnDouArea(true);
        },
        error: function (e) {
            frontLogging("drawDouChart error:", e, e.stack)
            onNoDataArea();
        }
    });
}

function drawTable(p_labelArr, p_dataArr, divisor, titleHead, titleTexts) {
    var $table = $("#statisticstable");
    if (!$table[0]) return;
    $table.empty();
    
    var labelArr = [...p_labelArr];
    var dataArr = [...p_dataArr];
    var divNum = divisor || 1;
    var dataLen = labelArr.length;
    var diff = Math.ceil(dataLen / divNum);
    var emptyLen = diff * divNum - dataLen;

    for (var i = 0; i < emptyLen; i++) {
        labelArr.push('');
        dataArr.push('');
    }

    var table = document.createElement("TABLE");
    table.style.textAlign = "center";
    table.style.width = "100%";
    table.className = "tstyle2";
    table.style.border = "1px solid #dadada"

    var trHead1 = document.createElement("tr");
    var trData1 = document.createElement("tr");
    table.append(trHead1, trData1);

    if (!!titleHead) {
        var userHead = document.createElement("th");
        userHead.innerText = titleHead;
        var userData = document.createElement("td");
        userData.setAttribute("rowspan", (divNum * 2 - 1) + "");

        for (var i = 0; i < titleTexts.length; i++) {
            var p = document.createElement("p");
            p.innerText = titleTexts[i] + ' ';
            userData.append(p);
            if (i===1) p.classList.add("accent_font");
        }

        trHead1.append(userHead);
        trData1.append(userData);
    }

    for (var i = 0; i < diff; i++) {
        var th = document.createElement("th");
        th.innerText = labelArr[i];
        var td = document.createElement("td");
        td.innerText = dataArr[i];
        trHead1.append(th);
        trData1.append(td);
    }

    for (var n = 1; n < divNum; n++) {
        var trHead2 = document.createElement("tr");
        var trData2 = document.createElement("tr");
        table.append(trHead2, trData2);
        var start = diff * n;
        var end = start + diff;

        for (var i = start; i < end; i++) {
            var th = document.createElement("th");
            th.innerText = labelArr[i];
            var td = document.createElement("td");
            td.innerText = dataArr[i];
            trHead2.append(th);
            trData2.append(td);
        }
    }

    $table.append(table);
}

function onChartArea() {
    document.getElementById("viewdata").style.display = "";
    document.getElementById("seluser").style.display = "none";
    document.getElementById("nodata").style.display = "none";
}

function onSelUserArea() {
    document.getElementById("viewdata").style.display = "none";
    document.getElementById("seluser").style.display = "";
    document.getElementById("nodata").style.display = "none";
}

function onNoDataArea() {
    document.getElementById("viewdata").style.display = "none";
    document.getElementById("seluser").style.display = "none";
    document.getElementById("nodata").style.display = "";
}

function turnDouArea(onOff) {
    document.getElementById("goBackDou").style.display = onOff ? "" : "none";
    document.getElementById("areaSelMenu").style.display = onOff ? "none" : "";
}

function makeOptionYear() {
    // 인풋창 표시할 년도 갯수. 변경시 이것만 변경하시오.
    var optionSize = 5;

    var date = new Date()
    var nowYear = date.getFullYear();
    var searchSelect = document.getElementById("searchYear");
    var yearSelected = parseInt(searchSelect.value) || nowYear;
    var endYear = Math.min(yearSelected + Math.floor(optionSize / 2), nowYear);
    var startYear = endYear - optionSize + 1;

    searchSelect.innerHTML = "";
    for (var y = endYear; y >= startYear; y--) {
        var option = document.createElement("OPTION");
        option.value = y;
        option.innerText = y;
        searchSelect.appendChild(option);
    }
    searchSelect.value = yearSelected;
}

function makeOptionDate() {
    var $selDay = $("#searchDay");
    var year = document.getElementById("searchYear").value;
    var month = document.getElementById("searchMonth").value;
    var dateCnt = new Date(year, month, 0).getDate();
    var textNode, option;
    var before = parseInt($selDay.val());

    $selDay.empty();

    for (var i = 1; i <= dateCnt; i++) {
        option = document.createElement('option');
        option.setAttribute('value', i);
        $selDay.append(option);
        textNode = document.createTextNode(i);
        option.appendChild(textNode);
    }

    if (before && !isNaN(before)) {
        if (before > dateCnt) {
            $selDay.val(dateCnt);
        } else {
            $selDay.val(before);
        }
    } else {
        $selDay.val(1);
    }
}

function search_press(e) {
    const event = e || window.event;
    if ((event.keyCode || event.which) === 13) {
        search();
    }
}

function search() {
    if (document.getElementById("searchopt").value == "1")
        searchuser();
    else
        searchdept();
}

var searchdept_cross_dialogArguments = new Array();

function searchdept() {
    if (keyword.value.trim() == "") {
        alert(CommonUtilsMsg.SEARCH_INSERT_PLZ);
        keyword.focus();
        return;
    }

    var xmlDom = createXmlDom();

    $.ajax({
        type: "POST",
        dataType: "text",
        url: "/ezOrgan/getSearchList.do",
        async: false,
        data: {
            search: "displayname::" + keyword.value,
            cell: "extensionAttribute3;displayName;extensionAttribute9",
            prop: "",
            type: "group",
            adminOrgan: adminOrganVal
        },
        success: function (result) {
            xmlDom = loadXMLString(result);
            adCount = xmlDom.getElementsByTagName("ROW").length;
        },
        error: function (error) {
            alert(strLang17 + error);
            xmlDom = null;
        }
    });

    if (adCount == 0) {
        alert(CommonUtilsMsg.SEARCH_NO_DEPT);
        return;
    } else if (adCount == 1) {
        bSearch = true;
        g_xmlHTTP = createXMLHttpRequest();

        if (CrossYN())
            var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>" + ConstantsConstant.COMPANY_ID + "</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
        else
            var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>" + ConstantsConstant.COMPANY_ID + "</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";

        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
        g_xmlHTTP.send(strQuery);
    } else {
        var rgParams = new Array();
        rgParams["addrBook"] = xmlDom;
        rgParams["deptid"] = "";

        var agent = navigator.userAgent.toLowerCase();
        if (CrossYN()) {
            searchdept_cross_dialogArguments[0] = rgParams;
            searchdept_cross_dialogArguments[1] = SelelctDept_complite;
            var OpenWin = window.open("/ezStatistics/statisticsCheckName2.do", "", GetOpenWindowfeature(609, 372));
            try {
                OpenWin.focus();
            } catch (e) {
            }
        } else {
            var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
            feature = feature + GetShowModalPosition(540, 460);
            window.showModalDialog("/ezStatistics/statisticsCheckName2.do", rgParams, feature);
        }
        if (rgParams["deptid"] != "") {
            bSearch = true;
            g_xmlHTTP = createXMLHttpRequest();
            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + ConstantsConstant.COMPANY_ID + "</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
            g_xmlHTTP.send(strQuery);
        }
    }
}

function SelelctDept_complite(deptid) {
    if (deptid != "") {
        bSearch = true;
        g_xmlHTTP = createXMLHttpRequest();
        var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>" + ConstantsConstant.COMPANY_ID + "</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
        g_xmlHTTP.send(strQuery);
    }
}

function event_getDeptFullTree() {
    if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
        if (g_xmlHTTP.status == 200) {
            if (!bSearch) {
                try {
                    if (CrossYN())
                        opener.opener.top.organview = g_xmlHTTP.responseXML;
                    else
                        window.dialogArguments["window"].opener.top.organview = g_xmlHTTP.responseXML;
                } catch (e) {
                }
            }

            var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
            document.getElementById('TreeView').innerHTML = "";

            var treeView = new TreeView();
            treeView.SetConfig(treeXML);
            treeView.SetID(ConstantsConstant.TREE_VIEW_DEPT_ID);
            treeView.SetUseAgency(true);
            treeView.SetRequestData("RequestData");
            treeView.SetNodeClick("TreeViewNodeClick");
            treeView.DataSource(g_xmlHTTP.responseXML);
            treeView.DataBind("TreeView");
        } else {
            alert(g_xmlHTTP.statusText)
            g_xmlHTTP = null;
        }
    }
}

function searchuser() {
    if (keyword.value == "") {
        alert(CommonUtilsMsg.SEARCH_INSERT_PLZ);
        keyword.focus();
        return;
    }

    $.ajax({
        type: "POST",
        dataType: "text",
        url: "/ezOrgan/getSearchList.do",
        async: true,
        data: {
            search: "displayname::" + keyword.value,
            cell: "displayName;description",
            prop: "department;displayName;description;title",
            type: "user",
            adminOrgan: adminOrganVal
        },
        success: function (result) {
            var xmlDom = loadXMLString(result);
            if (xmlDom.getElementsByTagName("ROW").length == 0)
                alert(CommonUtilsMsg.SEARCH_NO_USER);
            else {
                var retXml = createXmlDom();

                if (document.getElementById("UserList").innerHTML != "")
                    document.getElementById("UserList").innerHTML = "";

                var headerData = createXmlDom();
                headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
                if (result != "") {
                    if (CrossYN()) {
                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                        var Node = headerData.importNode(xmlRtn, true);
                        headerData.documentElement.appendChild(Node);
                    } else {
                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                        headerData.documentElement.appendChild(xmlRtn);
                    }
                }
                var pUserList = new ListView();
                pUserList.SetID(ConstantsConstant.LIST_VIEW_USER_ID);
                pUserList.SetRowOnClick(_initStatChartFn);
                pUserList.SetSelectFlag(false);
                pUserList.SetHeightFree(true);
                pUserList.DataSource(headerData);
                pUserList.DataBind("UserList");
            }
        },
        error: function (error) {
            alert(error);
        }
    });
}

function getSelUserData(dataStr) {
    var listView = new ListView();
    listView.LoadFromID(ConstantsConstant.LIST_VIEW_USER_ID);
    if (listView.GetSelectedRows().length < 1) return "";
    return listView.GetSelectedRows()[0].getAttribute(dataStr);
}

function getSelDeptData(dataStr) {
    var treeView = new TreeView();
    treeView.LoadFromID(ConstantsConstant.TREE_VIEW_DEPT_ID);
    return treeView.GetSelectNode().GetNodeData(dataStr);
}

function btnexportexcel_onclick(message) {
    document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;

    if (document.getElementById("saveExcelData").value == "" && !!message) {
        alert(message);
        return;
    }

    document.getElementById("formAgent").target = "saveExcel";
    document.getElementById("formAgent").submit();

}

function initMenus() {
    changeMenus();
    document.getElementById('menuId').addEventListener('change', function (event) {
        _initStatChartFn();
    });
}

function changeMenus() {
    $.ajax({
        type: "POST",
        url: "/admin/ezNewPortal/getMenus.do",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: JSON.stringify({
            companyId: companySelectID,
            type: ""
        }),
    }).done(function (response) {
        var selMenu = document.getElementById("menuId");
        if (!selMenu) return;

        if (!!response.list) {
            var menuList = response.list;
            var options = selMenu.options;

            if (options.length > 1) {
                const firstOption = options[0];
                selMenu.innerHTML = '';
                selMenu.appendChild(firstOption);
            }

            menuList.forEach(function (vo) {
                if (vo.menuId < 1 || vo.menuUsed === false) return;

                var option = document.createElement("option");
                option.value = vo.menuId;
                var text = document.createTextNode(vo.menuName);
                option.append(text);
                selMenu.append(option);
            });

            document.querySelector('input[name="menuId"]')
        }
    });
}

function initTab() {
    var overClassName = "tabover";
    var tab = document.getElementById("tabStatistics");
    if (!tab) return;
    tab.addEventListener("click", function (e) {
        if (!e.target.tagName || e.target.tagName.toLowerCase() !== "span") return;
        tab.getElementsByClassName(overClassName)[0].classList.remove(overClassName);
        e.target.classList.add(overClassName);
        turnDouArea(false);
        switch (e.target.id) {
            case "tabMonthly" :
                setDateForMonthly();
                break;
            case "tabDaily" :
                setDateForDaily();
                break;
            case "tabHourly" :
                setDateForHourly();
                break;
        }
    });
}

function setDateForMonthly() {
    var selMonth = document.getElementById("searchMonth");
    if (!!selMonth) selMonth.style.display = "none";
    var selDay = document.getElementById("searchDay");
    if (!!selDay) selDay.style.display = "none";
    _initStatChartFn();
}

function setDateForDaily() {
    var selMonth = document.getElementById("searchMonth");
    if (!!selMonth) selMonth.style.display = "";
    var selDay = document.getElementById("searchDay");
    if (!!selDay) selDay.style.display = "none";
    _initStatChartFn();
}

function setDateForHourly() {
    var selMonth = document.getElementById("searchMonth");
    if (!!selMonth) selMonth.style.display = "";
    var selDay = document.getElementById("searchDay");
    if (!!selDay) selDay.style.display = "";
    _initStatChartFn();
}

var _defaultColorHis = [];
var _defaultColor = (function () {
    var arr = new Uint32Array(1);
    var crypto = window.crypto || window.msCrypto;
    crypto.getRandomValues(arr);
    return (arr[0] % 72) * 5;
})();

var genRotateColor = function () {
    var colorSet = ",50%,50%,0.7";
    var rotate = 60;
    var twist = 215;
    _defaultColor += rotate;
    _defaultColor = _defaultColor % 360;

    // 중복체크를 너무 길면 주기를 돌아 무한루프 하므로 제거.
    if (_defaultColorHis.length > 20) _defaultColorHis = [];

    if (_defaultColorHis.indexOf(_defaultColor) > -1) {
        _defaultColor += twist;
        return genRotateColor();
    } else {
        _defaultColorHis.push(_defaultColor);
        return "hsla(" + _defaultColor + colorSet + ")";
    }
}

function refreshDate() {
    var todayDate = new Date();
    document.getElementById('searchYear').value = todayDate.getFullYear();
    document.getElementById('searchYear').innerText = todayDate.getFullYear();
    changeSelectBoxByVal('searchMonth', todayDate.getMonth()+1);
    changeSelectBoxByVal('searchDay', todayDate.getDate());
    makeOptionYear();
    _initStatChartFn();
}
