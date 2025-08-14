(function () {
    //추가 기능 구현
    GroupChat = function () {
        let selected = selectedList.treeview('getNodeAll', []); 
        let Uri = "";
        if (!isTeamsInitialized) {
            toastMessage(strLang71, null, "1");
            return;
        }
        if (selected.length > 100) {
            toastMessage(strLang18, null, "2");
            return;
        } else if (selected.length < 1) {
            toastMessage(strLang63, null, "2");
            return;
        }


        var selectList = $(".layerPopup_talk .selectedList");
        selectList.empty();
        if (selected.length > 1) {

            for (let i = 0; i < selected.length; i++) {
                try {
                    var objUserList = $("<span>").addClass("name").attr("cn", selected[i].data2);
                    objUserList.append(selected[i].displayName);
                    objUserList[0].addEventListener('click', e => deleteSelectedUser(e));
                    selectList[0].append(objUserList[0]);
                    objUserList = null;
                }
                catch (e) { }
            }
            var objUseCount = $("<span>").addClass("count");
            objUseCount.append($("<span>").append(strLang57 + " "));
            objUseCount.append($("<span>").attr("id", "groupCntChat").append(selected.length));
            objUseCount.append($("<span>").append(strLang58));

            selectList[0].append(objUseCount[0]);

            currLayer = ".layerPopup_talk, .Main_Panel";
            toggleClassFn(currLayer);
            
        }
        else {
            Uri += selected[0].upnName; // 여기
            currLayer = preLayer;
            btn_OpenConversation(Uri);
        }
    }

    //추가 기능 구현
    CreateTeam = function () {
        let selected = selectedList.treeview('getNodeAll', []);
        let Uri = "";

        if (selected.length > 100) {
            toastMessage(strLang69, null, "2");
            return;
        } else if (selected.length < 1) {
            toastMessage(strLang63, null, "2");
            return;
        }
        var selectList = $(".layerPopup_team .selectedList");
        selectList.empty();

        for (let i = 0; i < selected.length; i++) {
            try {
                var objUserList = $("<span>").addClass("name").attr("cn", selected[i].data2);
                objUserList.append(selected[i].displayName);
                objUserList[0].addEventListener('click', e => deleteSelectedUser(e));
                selectList[0].append(objUserList[0]);

                if (i == selected.length - 1)
                    Uri += selected[i].displayName;
                else
                    Uri += selected[i].displayName + ",";

                objUserList = null;
            }
            catch (e) { }
        }
        var objUseCount = $("<span>").addClass("count");
        objUseCount.append($("<span>").append(strLang57 + " "));
        objUseCount.append($("<span>").attr("id", "groupCntTeam").append(selected.length));
        objUseCount.append($("<span>").append(strLang58));
        selectList[0].append(objUseCount[0]);
        currLayer = ".layerPopup_team, .Main_Panel";
        toggleClassFn(currLayer);
    }

    showLoadingBar = function () {
        $('#mask').show();
        $('#loadingImg').show();
    }

    requestGraph = function (url, resource, method, dataObject, callback, isAsync, isPub = false, tokenRefreshed = false) {
        console.log("url=" + url  + ", resource=" + resource + ", method=" + method + ",dataObject=" + dataObject + ", callback=" + callback + ", isAsync=" + isAsync + ", isPub=" + isPub);
        var reqToken;
        if (isPub) {
            reqToken = publicAppToken;
        }
        else {
            reqToken = delegatedToken;  
        }

        $.ajax({
            url: resource + url,
            type: method,
            headers: {
                "Authorization": "Bearer " + reqToken,
                "content-type": "application/json",
                "accept": "application/json"
            },
            data: dataObject == "" ? "" : JSON.stringify(dataObject),
            async: isAsync,
            success: function (data, status, xhr) {
                callback(data, status, xhr);
            },
            error: function (xhr, status, error) {
                if (xhr && xhr.status == 401 && !tokenRefreshed) {
                    refreshTokens(function () {
                        requestGraph(url, resource, method, dataObject, callback, isAsync, isPub, true);
                    });

                } else {
                    callback(xhr.responseJSON || {}, status, xhr);  // 그대로 전달
                }
            },
        });
    }

    hideLoadingBar = function () {
        $('#mask, #loadingImg').hide();
        // $('#mask, #loadingImg').remove();
    }
    showAlert = function (message) {
        toastMessage(message, null, "2");
    }

}());
var graphApiUri = "https://graph.microsoft.com";

function refreshTokens(callback) {
    $.ajax({
        url: "/ezTeams/refreshAuthTokens.do",
        method: "GET",
        success: function (data) {
            publicAppToken = data.publicAppToken;
            delegatedToken = data.delegatedToken;
            if (callback) callback();
        },
        error: function () {
            console.warn("Token refresh failed.");
        }
    });
}


//Teams팀 생성
function Create_Team(teamName, ownerID, uri) {
    // console.log("Create_Team() teamName, ownerID, uri >> ", teamName, ownerID, uri);
    var visibilityVal = $(":input:radio[name=groupType]:checked").val();
    var teamObj = {
        'template@odata.bind': 'https://graph.microsoft.com/v1.0/teamsTemplates(\'standard\')',
        visibility: visibilityVal,
        displayName: teamName,
        description: teamName,
        members: [
            {
                '@odata.type': '#microsoft.graph.aadUserConversationMember',
                roles: [
                    'owner'
                ],
                'user@odata.bind': "https://graph.microsoft.com/1.0/users('" + ownerID + "')",
            }
        ]
    };

    showLoadingBar();
    requestGraph("/v1.0/teams",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "POST",
        teamObj,
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                hideLoadingBar();
                CreateTeam_cancel_onClick();
                toastMessage(strLang44, null, "2");
                // alert(strLang44);
            }
            else {
                var headerVal = xhr.getResponseHeader("Location");
                var teamId = headerVal.substring(headerVal.indexOf('\'', 0) + 1, headerVal.indexOf('\'', headerVal.indexOf('\'', 0) + 1)); //생성된 팀 객체Id 헤더에서 추출
                AddTeamsMember(teamId, uri);
            }
        },
        true,
        true,
        false
    );
}

//Teams팀 생성 후 구성원 추가
function AddTeamsMember(teamGuid, uri) {
    var guests = {
        values: []
    };

    for (var i = 0; i < uri.split(",").length; i++) {
        var userObj = {
            '@odata.type': 'microsoft.graph.aadUserConversationMember',
            roles: [

            ],
            'user@odata.bind': "https://graph.microsoft.com/v1.0/users('" + uri.split(",")[i] + "')"
        };
        guests["values"].push(userObj);
    }

    requestGraph("/v1.0/teams/" + teamGuid + "/members/add",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "POST",
        guests,
        function (data) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                hideLoadingBar();
                CreateTeam_cancel_onClick();
                alert(strLang44);
            }
            else if (data.status == "207") {
                console.log(data.responseJSON.error.message);
                hideLoadingBar();
                CreateTeam_cancel_onClick();
                alert(strLang45);
            }
            else {
                hideLoadingBar();
                CreateTeam_cancel_onClick();
                $('#inputTeamName').val("");
                showAlert(strLang28);                
            }

        },
        true,
        true,
        false
    );
}

// 관리 메뉴 추가 시작
// 채팅 관리
function GetChatList() {
    showLoadingBar();
    
    requestGraph("/v1.0/users/" + g_strUserId + "/chats?$filter=chatType eq 'group'",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "GET",
        "",
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                hideLoadingBar();
                showAlert(strLang44);
            }
            else {
                hideLoadingBar();
                MakeChatList(data);
            }
        },
        true,
        true,
        false
    );
}

function MakeChatList(groupChatData) {
    var chatListXml = "<LISTVIEWDATA><ROWS>";
    var chatCount = groupChatData.value.length;

    for (var i = 0; i < chatCount; i++) {
        chatListXml += "<ROW>";
        chatListXml += MakeSubChatList(groupChatData, i);
        chatListXml += "</ROW>";
    }
    chatListXml += "</ROWS></LISTVIEWDATA>";
    pParams = chatListXml;
    showModal("SelectList", strLang61, "", SetManageList, "chat");
}

function MakeSubChatList(chatData, index) {
    var subChatList;

    requestGraph("/v1.0/chats/" + chatData.value[index].id + "/members",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "GET",
        "",
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                showAlert(strLang44);
            }
            else {
                var memberStr = "";
                for (var i = 0; i < data.value.length; i++) {
                    if (data.value[i].userId == g_UserTeamsId) // 사용자 자신 제외
                    {
                        if (i == data.value.length - 1) { // 사용자 자신이 마지막 인덱스인 경우 처리
                            memberStr = memberStr.substring(0, memberStr.length-1);
                            continue;
                        }
                        else {
                            continue;
                        }
                    }

                    if (i == data.value.length - 1) {
                        memberStr += data.value[i].displayName
                    }
                    else {
                        memberStr += data.value[i].displayName + ",";
                    }
                }

                var chatTitle = chatData.value[index].topic == null ? memberStr : chatData.value[index].topic;
                subChatList = "<CELL>" + "<DATA1>" + chatData.value[index].id + "</DATA1>";
                subChatList += "<DATA2>" + chatTitle + "</DATA2>";
                subChatList += "<VALUE>" + chatTitle + "</VALUE>" + "</CELL>"
                subChatList += "<CELL>" + "<VALUE>" + memberStr + "</VALUE>" + "</CELL>";
            }
        },
        false,
        true,
        false
    );

    //subChatList = "<CELL>" + "<DATA1>" + chatData.value[index].id + "</DATA1>" + "<VALUE>" + chatData.value[index].topic + "</VALUE>" + "</CELL>";
    //subChatList += "<CELL>" + "<VALUE>" + GetLocalTime(groupChatData.value[i].lastUpdatedDateTime) + "</VALUE>" + "</CELL>";

    return subChatList;
}

function ModifyChatInit(chatId, chatName) {
    $("#ModifyBtn").attr('onclick', "ModifyGroupConfig('" + chatId + "', '" + chatName + "')");

    requestGraph("/v1.0/chats/" + chatId + "/members",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "GET",
        "",
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                showAlert(strLang44);
            }
            else {
                SetUserList(data, "chat");
            }
        },
        false,
        true,
        false
    );
}

var addedMemberArr = new Array();
function ModifyGroupConfig(chatChannelId, chatName) {
    var chatMemberList = new OrganView();
    chatMemberList.LoadFromID("SetMemberList");
    var chatMember = chatMemberList.GetDataRows();

    for (var i = 0; i < chatMember.length; i++) {
        if (chatMember[i].getAttribute("data2").toUpperCase() == "NEW") {
            addedMemberArr.push(chatMember[i].getAttribute("data1"));
        }
    }

    if (addedMemberArr.length == 0) {
        hideLoadingBar();
        showAlert(strLang63);
    }
    else {
        showModal("ChatConfig", strLang61, "", ModifyGroupConfigInit, chatChannelId + "/" + chatName);
    }
}

function ModifyGroupConfigInit(chatInfo) {
    var chatId = chatInfo.split('/')[0];
    var chatName = chatInfo.split('/')[1];

    document.getElementById('chatNameInput').value = chatName;
    $("#ModifyBtn").attr("onClick", "ModifyGroupChat('" + chatId + "')");
}

function ModifyGroupChat(chatChannelId) {
    var RenameRtn = RenameChat(chatChannelId);
    if (RenameRtn == "OK") {
        AddMemberToChat(chatChannelId, addedMemberArr);
    }
    else {
        showAlert("ERROR");
    }
    
    addedMemberArr = new Array();
}

function RenameChat(chatId) {
    var rtnStr = "";

    var chatTopic = document.getElementById("chatNameInput").value;
    var chatTopicData = {
        "topic": chatTopic
    }

    requestGraph("/v1.0/chats/" + chatId,
        // config.endpoints.graphApiUri,
        graphApiUri,
        "PATCH",
        chatTopicData,
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                showAlert(strLang44);
            }
            else {
                rtnStr = "OK";
            }
        },
        false,
        true,
        false
    );

    return rtnStr;
}

function AddMemberToChat(chatChannelId, newMemberArr) {
    var visibleHistory;
    var chatRecordVal = $(":input:radio[name=chatType]:checked").val();
    if (chatRecordVal == null) {
        showAlert(strLang65);
    }

    if (chatRecordVal.toUpperCase() == "ALL") {
        visibleHistory = "0001-01-01T00:00:00Z";
    }
    else if (chatRecordVal.toUpperCase() == "SINCE") {
        var sinceDate = new Date();
        var recordDate = document.getElementById('chatRecordDate').value;
        sinceDate.setDate(sinceDate.getDate() - recordDate);
        visibleHistory = sinceDate.toISOString();
    }
    else {
        visibleHistory = "";
    }
    
    var newMemberCnt = newMemberArr.length;
    showLoadingBar();
    for (var i = 0; i < newMemberCnt; i++) {
        var newMember = {
            "@odata.type": "#microsoft.graph.aadUserConversationMember",
            "user@odata.bind": "https://graph.microsoft.com/v1.0/users/" + newMemberArr[i],
            "visibleHistoryStartDateTime": visibleHistory,
            "roles": ["owner"]
        };

        requestGraph("/v1.0/chats/" + chatChannelId + "/members",
            // config.endpoints.graphApiUri,
            graphApiUri,
            "POST",
            newMember,
            function (data, status, xhr) {
                if (data.status == "404" || data.status == "400") {
                    console.log(data.responseJSON.error.message);
                    showAlert("add: " + newMemberArr[i] + " FAILED");
                    if (i == newMemberCnt - 1) {
                        hideLoadingBar();
                        ClearList("SetMemberList");
                        ClearList("SelectedList");
                        ShowSelAddList();
                        Control_View();
                        TreeViewNodeClick();
                    }
                }
                else {
                    if (i == newMemberCnt - 1) {
                        showAlert(strLang64);
                        hideLoadingBar();
                        ClearList("SetMemberList");
                        ClearList("SelectedList");
                        ShowSelAddList();
                        Control_View();
                        TreeViewNodeClick();
                    }
                }
            },
            false,
            true,
            false
        );
    }
    $("#result").modal("hide");
}

// 소유한 팀 관리
function GetOwnedTeamsList() {
    showLoadingBar();

    // 사용자 소유 obj 조회
    requestGraph("/v1.0/users/" + g_strUserId + "/ownedObjects?$select=displayName,id,resourceProvisioningOptions",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "GET",
        "",
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                hideLoadingBar();
                showAlert(strLang44);
            }
            else {
                hideLoadingBar();
                MakeTeamList(data);
            }
        },
        true,
        true,
        false
    );
}

function MakeTeamList(teamData) {
    var teamListXml = "<LISTVIEWDATA><ROWS>";
    var teamCount = teamData.value.length;

    for (var i = 0; i < teamCount; i++) {
        if (teamData.value[i].resourceProvisioningOptions.find(isTeam)) { // 사용자 소유 obj중 Team만 리스트에 추가
            teamListXml += "<ROW>";
            teamListXml += MakeSubTeamList(teamData, i);
            teamListXml += "</ROW>";
        }
    }
    teamListXml += "</ROWS></LISTVIEWDATA>";
    pParams = teamListXml;
    showModal("SelectList", strLang62, "", SetManageList, "team");
}

function isTeam(index) {
    if (index.toUpperCase() === 'TEAM') {
        return true;
    }
}

function MakeSubTeamList(teamData, index) {
    var subTeamList;

    requestGraph("/v1.0/teams/" + teamData.value[index].id + "/members",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "GET",
        "",
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                showAlert(strLang44);
            }
            else {
                var memberStr = "";
                for (var i = 0; i < data.value.length; i++) {
                    if (data.value[i].userId == g_UserTeamsId) // 사용자 자신 제외
                    {
                        if (i == data.value.length - 1) { // 사용자 자신이 마지막 인덱스인 경우 처리
                            memberStr = memberStr.substring(0, memberStr.length - 1);
                            continue;
                        }
                        else {
                            continue;
                        }
                    }

                    if (i == data.value.length - 1) {
                        memberStr += data.value[i].displayName
                    }
                    else {
                        memberStr += data.value[i].displayName + ",";
                    }
                }

                var teamTitle = teamData.value[index].displayName == null ? memberStr : teamData.value[index].displayName;
                subTeamList = "<CELL>" + "<DATA1>" + teamData.value[index].id + "</DATA1>";
                subTeamList += "<DATA2>" + teamTitle + "</DATA2>";
                subTeamList += "<VALUE>" + teamTitle + "</VALUE>" + "</CELL>"
                subTeamList += "<CELL>" + "<VALUE>" + memberStr + "</VALUE>" + "</CELL>";
            }
        },
        false,
        true,
        false
    );

    return subTeamList;
}

function ModifyTeamInit(teamId) {
    $("#ModifyBtn").attr('onclick', "ModifyTeam('" + teamId + "')");

    requestGraph("/v1.0/groups/" + teamId + "/members",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "GET",
        "",
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                showAlert(strLang44);
            }
            else {
                SetUserList(data, "team");
            }
        },
        false,
        true,
        false
    );
}

function ModifyTeam(teamId) {
    var teamMemberList = new OrganView();
    teamMemberList.LoadFromID("SetMemberList");
    var teamMember = teamMemberList.GetDataRows();
    var addedMemberArr = new Array();

    for (var i = 0; i < teamMember.length; i++) {
        if (teamMember[i].getAttribute("data2").toUpperCase() == "NEW") {
            addedMemberArr.push(teamMember[i].getAttribute("data1"));
        }
    }
    
    if (addedMemberArr.length == 0) {
        hideLoadingBar();
        showAlert(strLang63);
    }
    else {
        AddMemberToTeam(teamId, addedMemberArr);
    }
}

function AddMemberToTeam(teamId, newMemberArr) {
    var newMemberCnt = newMemberArr.length;
    showLoadingBar();
    for (var i = 0; i < newMemberCnt; i++) {
        var newMember = {
            "@odata.type": "#microsoft.graph.aadUserConversationMember",
            "user@odata.bind": "https://graph.microsoft.com/v1.0/users/" + newMemberArr[i],
            "roles": []
        };

        requestGraph("/v1.0/teams/" + teamId + "/members",
            // config.endpoints.graphApiUri,
            graphApiUri,
            "POST",
            newMember,
            function (data, status, xhr) {
                if (data.status == "404" || data.status == "400") {
                    console.log(data.responseJSON.error.message);
                    showAlert("add: " + newMemberArr[i] + " FAILED");
                    if (i == newMemberCnt - 1) {
                        hideLoadingBar();
                        ClearList("SetMemberList");
                        ClearList("SelectedList");
                        ShowSelAddList();
                        Control_View();
                        TreeViewNodeClick();
                    }
                }
                else {
                    if (i == newMemberCnt - 1) {
                        showAlert(strLang64);
                        hideLoadingBar();
                        ClearList("SetMemberList");
                        ClearList("SelectedList");
                        ShowSelAddList();
                        Control_View();
                        TreeViewNodeClick();
                    }
                }
            },
            false,
            true,
            false
        );
    }
}

function SetUserList(listData, manageFlag) {
    var listview = new OrganView();
    listview.LoadFromID("SetMemberList");

    for (var i = 0; i < listData.value.length; i++) {
        var xmldom = new createXmlDom();
        var objRoot = createNode(xmldom, "LISTVIEWDATA");
        var objRow = createNode(xmldom, "ROW");
        var objCell = createNode(xmldom, "CELL");

        // 사용자 이름, id
        var objDisplayName = manageFlag.toLowerCase() == "chat" ? listData.value[i].displayName : listData.value[i].displayName;
        var objId = manageFlag.toLowerCase() == "chat" ? listData.value[i].userId.trim() : listData.value[i].id.trim();
        var objCellValue = createNode(xmldom, "VALUE");
        appendChildText(objCell, objCellValue, objDisplayName);
        var objCellData = createNode(xmldom, "DATA1");
        appendChildText(objCell, objCellData, objId);
        objRow.appendChild(objCell);
        var objCellData = createNode(xmldom, "DATA2");
        appendChildText(objCell, objCellData, "PRE");
        objRow.appendChild(objCell);

        // 신규 추가 사용자: NEW
        var objCell = createNode(xmldom, "CELL");
        var objCellValue = createNode(xmldom, "VALUE");
        appendChildText(objCell, objCellValue, "");
        objRow.appendChild(objCell);

        // 삭제 버튼
        var objCell = createNode(xmldom, "CELL");
        var objCellValue = createNode(xmldom, "VALUE");
        appendChildText(objCell, objCellValue, "");
        objRow.appendChild(objCell);

        xmldom = objRoot.appendChild(objRow);
        
        var objTr = listview.AddRow(listview.GetRowCount());
        listview.AddDataRow(objTr, xmldom);
    }

    var memberArr = listview.GetDataRows();
    var memberIdArr = new Array(memberArr.length)
    for (var i = 0; i < memberArr.length; i++) {
        memberIdArr[i] = memberArr[i].getAttribute("data1");
    }

    var OrgList = document.getElementById("OrganList");
    var OrgTR = OrgList.getElementsByTagName("TR");
    for (var tr of OrgTR) {
        if (tr.getAttribute('teamsId')) {
            for (var j = 0; j < memberIdArr.length; j++) {
                if (tr.getAttribute('teamsId') == memberIdArr[j]) {
                    tr.getElementsByTagName("input")[0].checked = true;
                    tr.getElementsByTagName("input")[0].disabled = true;
                }
            }
        }
    }

    Control_View_Modify(listData);
}



function Control_View_Modify(listData) {

    ShowModifyList();
    $("#CustomView").show(0, function () {
        if ($("#CustomTable").is(":hidden") == true) {
        }
        else { }
    });
}

function ShowModifyList() {
    $("#CreateChanel").hide();
    $("#Groupchat").hide();
    $("#Selected_TD").hide();
    $("#SetMember_TD").show();
    $("#ModifyBtn").show();
}

function ShowSelAddList() {
    $("#CreateChanel").show();
    $("#Groupchat").show();
    $("#Selected_TD").show();
    $("#SetMember_TD").hide();
    $("#ModifyBtn").hide();
}
// 관리 메뉴 추가 끝

//TEST
function InviteGuest(dispName, mailAddr) {

    const invitation = {
        invitedUserDisplayName : dispName,
        invitedUserEmailAddress: mailAddr,
        //inviteRedirectUrl: 'https://teams.microsoft.com',
        inviteRedirectUrl: 'https://myapplications.microsoft.com/?tenandid=' + tenantId,
        sendInvitationMessage : true
    };

    showLoadingBar();
    requestGraph("/v1.0/invitations",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "POST",
        invitation,
        function (data, status, xhr) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                hideLoadingBar();
                showAlert(strLang44);
            }
            else {
                hideLoadingBar();
                showAlert("InviteGuest SS");
            }
        },
        true,
        true,
        false
    );
}
//TEST

//365 그룹 생성
function Create365Group(teamName, ownerID, uri) {
    var dataObject = { "requests": [] };
    let data = new Object();
    data.id = "1";
    data.method = "POST";
    data.url = "/groups";
    var visibilityVal = $(":input:radio[name=groupType]:checked").val();
    data["headers"] = { "Content-Type": "application/json" };
    data["body"] = {
        "displayName": teamName,
        "description": teamName,
        "groupTypes": ["Unified"],
        "mailEnabled": true,
        "mailNickname": teamName,
        "visibility": visibilityVal,
        "securityEnabled": false,
        "owners@odata.bind": ["https://graph.microsoft.com/1.0/users('" + ownerID + "')"],
        "members@odata.bind": []
    };

    for (var i = 0; i < uri.split(",").length - 1; i++) {
        data["body"]["members@odata.bind"].push("https://graph.microsoft.com/1.0/users('" + uri.split(",")[i] + "')");
    }
    dataObject["requests"].push(data);
    showLoadingBar();

    requestGraph("/v1.0/$batch",
        // config.endpoints.graphApiUri,
        graphApiUri,
        "POST",
        dataObject,
        function (data) {
            if (data.status == "404" || data.status == "400") {
                console.log(data.responseJSON.error.message);
                hideLoadingBar();
                CreateTeam_cancel_onClick();
                showAlert(strLang44);
            }
            else {
                //그룹 생성 후 그룹이 365에 반영 시간이 필요 -> MS추천: 10초간격으로 3번 호출 // https://docs.microsoft.com/en-us/graph/api/team-put-teams?view=graph-rest-1.0&tabs=http
                setTimeout(function () {
                    CreateGroup_Callback(data);
                }, 7000);
            }
        },
        true,
        true,
        false
    );
}

function CreateGroup_Callback(data) {
    LinkTeams(data);
}

//365 그룹 생성 후 Teams팀 연결
function LinkTeams(data) {
    var groupID = data.responses[0].body.id;
    if (groupID != undefined) {
        const team = {
            memberSettings: {
                allowCreateUpdateChannels: true
            },
            messagingSettings: {
                allowUserEditMessages: true,
                allowUserDeleteMessages: true
            },
            funSettings: {
                allowGiphy: true,
                giphyContentRating: "strict"
            }
        };
        requestGraph("/v1.0/groups/" + groupID + "/team",
            // config.endpoints.graphApiUri,
            graphApiUri,
            "PUT",
            team,
            function (callback_data) {
                if (callback_data.status == "404" || callback_data.status == "400") {
                    console.log(callback_data.responseJSON.error.message);
                    setTimeout(function () {
                        CreateGroup_Callback(data);
                    }, 5000);
                }
                else {
                    hideLoadingBar();
                    CreateTeam_cancel_onClick();
                    showAlert(strLang28);
                }
            },
            true,
            true,
            false
        );
    }
    else {
        hideLoadingBar();
        var errorMessage = data.responses[0].body.error.message;
        if (errorMessage == "Another object with the same value for property mailNickname already exists.") {
            showAlert(strLang27);
        }
        if (errorMessage == "Invalid value specified for property 'mailNickname' of resource 'Group'.") {
            showAlert(strLang26);
        }
        if (errorMessage != "" || errorMessage != undefined) {
            showAlert(strLang25);
        }
    }
}

function startTouch(e) {
    initialX = e.touches[0].clientX;
    initialY = e.touches[0].clientY;
};

function moveTouch(e) {
    if (initialX === null) {
        return;
    }

    if (initialY === null) {
        return;
    }

    var currentX = e.touches[0].clientX;
    var currentY = e.touches[0].clientY;

    var diffX = initialX - currentX;
    var diffY = initialY - currentY;

    if (Math.abs(diffX) > Math.abs(diffY)) {
        // 수평
        if (diffX > 0) {
            // 왼쪽으로 Swipe
            ShowUserList(true);
        } else {
            // 오른쪽으로 Swipe
            ShowUserList(false);
        }
    } else {
        // 수직
        if (diffY > 0) {
            // 위으로 Swipe
        } else {
            // 아래으로 Swipe
        }
    }

    initialX = null;
    initialY = null;

    e.preventDefault();
};

function showDiv(expr) {
    switch (expr) {
        case "organization":
            $("#organizationDiv").show();
            InitOrganInfo();
            break;
        case "sharedWithMe":
            $("#organizationDiv").hide();
            break;
        case "sharedByMe":
            $("#organizationDiv").hide();
            break;
        case "organization_New":
            $("#organizationDiv").show();
            InitOrganInfo_New();
            break;
    }
}

function ClearList(listId) {
    var listview = new OrganView();
    listview.LoadFromID(listId);
    var arrRows = listview.GetDataRows();
    for (var i = 0; i < arrRows.length; i++) {
        listview.DeleteRow(arrRows[i].id);
    }
}

function GetLocalTime(time) {
    var date = new Date(time);
    date.setHours(date.getHours() + 9);
    let rtnTime = date.toISOString().replace('T', ' ').substring(0, 19);
    return rtnTime;
}

