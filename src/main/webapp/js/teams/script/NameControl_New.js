// createLayer객체
var g_newlayer = null;
function getAllPresence_DB() {   
    var objNode;
    var xmlpara = createXmlDom();
    createNodeInsert(xmlpara, objNode, "DATA");
    var userList = findNodes("USER", "data1", organTree);
    for (var i = 0; i < userList.length; i++) {
        if (userList[i].data2 && userList[i].presence != "") {
            createNodeAndInsertText(xmlpara, objNode, "USERID", userList[i].data2);
        }
    }
    if (xmlpara.getElementsByTagName("USERID").length > 0) {
        xmlHTTPreq = createXMLHttpRequest();
        xmlHTTPreq.open("POST", "/ezTeams/getPresenceList.do", true);
        xmlHTTPreq.onreadystatechange = event_updateUserList_s;
        xmlHTTPreq.setRequestHeader("Content-Type", "text/xml");
        xmlHTTPreq.send(xmlpara);
    }
}

function event_updateUserList_s() {
    if (xmlHTTPreq != null && xmlHTTPreq.readyState == 4) {
        if (xmlHTTPreq.status == "200") {
            var xmldom = GetChildNodes(xmlHTTPreq.responseXML)[0]; //ROWS 추출
            for (var i = 0; i < GetChildNodes(xmldom).length; i++) {
                var node = GetChildNodes(xmldom)[i];
                var cn = SelectSingleNodeValue(node, "CN");
                var presence = SelectSingleNodeValue(node, "PRESENCE");
                var teamsID = SelectSingleNodeValue(node, "TEAMSID");
                var upnname = SelectSingleNodeValue(node, "UPNNAME");
                var obj;

                if ($("span .user_photo[DATA2='" + cn + "'] .presenceState ")[0] != null) {
                    obj = $("span .user_photo[DATA2='" + cn + "'] .presenceState ");
                    obj.each(i => {
                        GetStatusImg(obj[i], presence);
                    })

                }
                
            }
        }
    }
}

function GetStatusImg(obj,status) {
    switch (status) {   //상태값
        case "Available":
            obj.setAttribute("src", "/images/Presence/Presence_Available.jpg")
            break;
        case "Busy":
            obj.setAttribute("src", "/images/Presence/Presence_Busy.jpg");
            break;
        case "DoNotDisturb":
            obj.setAttribute("src", "/images/Presence/Presence_DoNotDisturb.jpg");
            break;
        case "BeRightBack":
            obj.setAttribute("src", "/images/Presence/Presence_Away.jpg");
            break;
        case "Away":
            obj.setAttribute("src", "/images/Presence/Presence_Away.jpg");
            break;
        default:
            obj.setAttribute("src", "/images/Presence/Presence_Default.jpg");
    }

}
function event_updateUserList() {
  if (xmlHTTPreq != null && xmlHTTPreq.readyState == 4) {
    if (xmlHTTPreq.status == "200") {
        var xmldom = SelectSingleNode(GetChildNodes(xmlHTTPreq.responseXML)[0], "ROWS");
            for (var i = 0; i < GetChildNodes(xmldom).length; i++) {
                var rows = GetChildNodes(xmldom)[i];
                var presence_id = SelectSingleNodeValue(GetChildNodes(rows)[0], "VALUE");

                tableVisible = $("#Selected_Div tr[DATA2='" + presence_id + "'] img")[0];
                if (tableVisible != null || tableVisible != undefined) {
                    switch (SelectSingleNodeValue(GetChildNodes(rows)[0], "DATA4")) {
                        case "Available":
                            $("#Selected_Div tr[DATA2='" + data.responses[id].id + "'] img")[0].setAttribute("src", "/images/Presence/Presence_Available.jpg");
                            break;
                        case "Busy":
                            $("#Selected_Div tr[DATA2='" + data.responses[id].id + "'] img")[0].setAttribute("src", "/images/Presence/Presence_Busy.jpg");
                            break;
                        case "DoNotDisturb":
                            $("#Selected_Div tr[DATA2='" + data.responses[id].id + "'] img")[0].setAttribute("src", "/images/Presence/Presence_DoNotDisturb.jpg");
                            break;
                        case "BeRightBack":
                            $("#Selected_Div tr[DATA2='" + data.responses[id].id + "'] img")[0].setAttribute("src", "/images/Presence/Presence_Away.jpg");
                            break;
                        case "Away":
                            $("#Selected_Div tr[DATA2='" + data.responses[id].id + "'] img")[0].setAttribute("src", "/images/Presence/Presence_Away.jpg");
                            break;
                        case "":
                            $("#Selected_Div tr[DATA2='" + data.responses[id].id + "'] img")[0].setAttribute("style", "display:none");
                            break;
                        default:
                            $("#Selected_Div tr[DATA2='" + data.responses[id].id + "'] img")[0].setAttribute("src", "/images/Presence/Presence_Default.jpg");
                    }
                }
            }
        }
    }
    xmlHTTPreq = null;
}


function cardClick(obj) {
    obj.style.display = "none";
    nameCardFlag = false;
}

var _befrotElm;



function initNameCard() {
    $('.infobox_user_cont .i_talk').removeAttr("onclick");
    $('.infobox_user_cont .i_call').removeAttr("onclick");
    
    $(".infobox_user_cont .info_simple > span").empty();
    $(".infobox_user_cont .nameBox").empty();
    $(".infobox_user_cont .rank").text("");
    $(".infobox_user_cont .department").text("");
    $(".infobox_user_cont .work").text("");
    $(".infobox_user_cont .mail").text("");   // mail
    $(".infobox_user_cont .title").text("");
    $(".infobox_user_cont .phone").text("");
    $(".infobox_user_cont .company_phone").text("");
}

function nameCard(node, obj) {

    initNameCard();
    // 사용자 사진 처리
    var photoFileName = node.extensionAttribute2;

    var photo = obj[0].querySelector("li[data-nodeid='" + node.nodeId + "'] .user_photo img");

    if (photo) {
        if (photoFileName && photoFileName.trim() !== "") {
            photo.setAttribute("src", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + photoFileName);
        } else {
            photo.setAttribute("src", "/images/teams/NoPhoto.png");
        }
    }
    
    $($(obj)[0].querySelector("li[data-nodeid='" + node.nodeId + "'] .user_photo")).clone().appendTo(".infobox_user_cont .info_simple > span");
    $($(obj)[0].querySelector("li[data-nodeid= '" + node.nodeId + "'] .user_list_info")).clone().appendTo(".infobox_user_cont .info_simple > span");
    $(".infobox_user_cont .company").text(companyName); 
    $(".infobox_user_cont .rank").text(node.title);
    $(".infobox_user_cont .department").text(node.description);
    $(".infobox_user_cont .work").text(node.chargeBusiness); 
    $(".infobox_user_cont .mail").text(node.mail);
    $(".infobox_user_cont .title").text(node.title + (((node.title||"").trim().length > 0 ? "/" : "") + node.description));
    $(".infobox_user_cont .phone").text(node.mobile);
    $(".infobox_user_cont .company_phone").text(node.telephoneNumber);

    
    if (node.upnName && node.upnName.trim() != "" && node.teamsId && node.teamsId.trim() != "")
        $('.infobox_user_cont .i_talk').attr("onclick", "btn_OpenConversation(\"" + node.upnName + "\")");
    else
        $('.infobox_user_cont .i_talk').attr("onclick", "btn_OpenConversation_Fail()");


    /* (전화) 버튼 이벤트 설정 */
    if (isMobile()) {
        if (node.upnName && node.upnName.trim() != "" && node.mobile && node.mobile.trim() != "")
            $('.infobox_user_cont .i_call').attr("onclick", "btn_OpenTel('" + node.mobile + "', '" + node.upnName + "')");
        else
            $('.infobox_user_cont .i_call').attr("onclick", "noTelNumber()");
    }
    else {
        if (node.upnName && node.upnName.trim() != "" && node.teamsId && node.teamsId.trim() != "") 
            $('.infobox_user_cont .i_call').attr("onclick", "btn_OpenCall(\"" + node.upnName + "\")");
        else 
            $('.infobox_user_cont .i_call').attr("onclick", "btn_OpenConversation_Fail()");
        
    }
    
}


function btn_OpenCall(UPN) {
    if (!isTeamsInitialized) {
        toastMessage(strLang71, null, "1");
        return;
    }
    if (UPN.indexOf("@") == -1) {
        toastMessage(strLang48, null, "1");
        return;
    }

    if (UPN.trim().toLowerCase() == g_strUserId.trim().toLowerCase()) {
        toastMessage(strLang49, null, "1");
        return;
    }
    microsoftTeams.executeDeepLink("https://teams.microsoft.com/l/call/0/0?users=" + UPN);
}

function btn_OpenTel(number, UPN) {
    if (!isTeamsInitialized) {
        toastMessage(strLang71, null, "1");
        return;
    }
    if (number.replace("-","") == "") {
        return;
    }
    if (UPN.trim().toLowerCase() == g_strUserId.trim().toLowerCase()) {
        toastMessage(strLang49, null, "1");
        return;
    }
    location.href = 'tel:' + number;
}

function noTelNumber() {
    toastMessage(strLang56, null, "1");
}

//현재 발생한 이벤트가 IE인지 타브라우저인지 확인하는 함수
function GetCurrentEvent(objEvent) {
    if (BroswerAndNonActiveXCheck() == "IE")
        return window.event;
    else
        return objEvent;
    return window.event;
}

function btn_OpenConversation(pUri) {
    if (!isTeamsInitialized) {
        toastMessage(strLang71, null, "1");
        return;
    }
    if (pUri.indexOf("@") == -1) {
        toastMessage(strLang50, null, "1");
        return;
    }
    
    if (pUri.trim().toLowerCase() == g_strUserId.trim().toLowerCase()) {
        toastMessage(strLang51, null, "1");
        return;
    }
    microsoftTeams.executeDeepLink("https://teams.microsoft.com/l/chat/0/0?users=" + pUri);
}

/**
 * 문자열의 길이를 계산 (한글은 2, 영문은 1)
 */
function getTextLength(str) {
    var len = 0;
    for (var i = 0; i < str.length; i++) {
        var chr = str.charCodeAt(i);
        if (chr > 127) len += 2;
        else len += 1;
    }
    return len;
}

var toastMessage_DialogArgument = [];

function toastMessage(pAlertContent, CompleteFunction, Type, pWidth, pHeight, pCompleteFunctionParamArray) {
    try {
        if (Type == "O" || Type === "0") throw "O";
        
        //한글15글자, 영어30글자 이상일시, 2초를 넘어서는 시간을 유지함 
        var timeoutsec = 2000;

        if (getTextLength(pAlertContent) > 30) {
            timeoutsec = getTextLength(pAlertContent) * 0.07 * 1000;
        }

        toastr.options = {
            "positionClass": "toast-top-center",
            "progressBar": false,
            "timeOut": timeoutsec,
            "onShown": undefined,
            "onHidden": undefined
        };

        DivPopUpHidden();

        if (Type && Type.length > 1) {
            var locationposition = Type.substring(1).toLowerCase();

            switch (locationposition) {
                case "tr": toastr.options.positionClass = "toast-top-right"; break;
                case "tl": toastr.options.positionClass = "toast-top-left"; break;
                case "br": toastr.options.positionClass = "toast-bottom-right"; break;
                case "bl": toastr.options.positionClass = "toast-bottom-left"; break;
                case "bf": toastr.options.positionClass = "toast-bottom-full-width"; break;
                case "tf": toastr.options.positionClass = "toast-top-center"; break;
            }

            Type = Type.substring(0, 1);
        }

        if (CompleteFunction != null) {
            var fname = (CompleteFunction.name || "").toUpperCase();
            if (fname.indexOf("CLOSE") > -1 || fname.indexOf("SAVE") > -1) {
                if (checkLoaderLayer()) {
                    var mailPanel = document.getElementById("Main_mailPanel");
                    if (mailPanel) mailPanel.style.display = "";
                }

                if (document.getElementById("toast-container") != null) {
                    var mailPanel = document.getElementById("Main_mailPanel");
                    if (mailPanel) mailPanel.style.display = "none";
                }

                if (typeof GetPageType === "function" && GetPageType() === "POPUP") {
                    toastr.options.progressBar = true;
                    toastr.options.onHidden = function () {
                        CompleteFunction(true);
                        var mailPanel = document.getElementById("Main_mailPanel");
                        if (mailPanel) mailPanel.style.display = "none";
                    };
                } else {
                    toastr.options.onShown = function () {
                        CompleteFunction(true);
                        var mailPanel = document.getElementById("Main_mailPanel");
                        if (mailPanel) mailPanel.style.display = "none";
                    };
                }
            } else {
                toastr.options.progressBar = false;
                toastr.options.onShown = function () { CompleteFunction(true); };
            }
        }

        // 메시지 타입 (1:info, 2:success, 3:warning, 4:error)
        switch (Type) {
            case "1": case 1: toastr.info(pAlertContent); break;
            case "2": case 2: toastr.success(pAlertContent); break;
            case "3": case 3: toastr.warning(pAlertContent); break;
            case "4": case 4: toastr.error(pAlertContent); break;
            default: toastr.warning(pAlertContent); break;
        }
    } catch (e) {
        var parameter = pAlertContent;
        var url = "/ezApprovalG/ezAprAlert.do";

        toastMessage_DialogArgument[0] = parameter;
        toastMessage_DialogArgument[1] = CompleteFunction || toastMessage_Complete;

        if (typeof pCompleteFunctionParamArray !== "undefined") {
            toastMessage_DialogArgument[2] = pCompleteFunctionParamArray;
        }

        var winWidth = 450, winHeight = 260;
        if (pWidth && winWidth < pWidth) winWidth = pWidth;
        if (pHeight && winHeight < pHeight) winHeight = pHeight;

        DivPopUpShow(winWidth, winHeight, url);
    }
}

function toastMessage_Complete() {
    DivPopUpHidden();
    return;
}
function btn_OpenConversation_Fail() {
    toastMessage(strLang52, null, "1");
}

function btn_OpenConversationWithTopicName(pUri, topicName, input) {
    var pattern = /\D/g;
    if (checkSpecial(topicName)) {
        toastMessage(strLang53, null, "1");
        input[0].value="";
        return false;
    }

    microsoftTeams.executeDeepLink("https://teams.microsoft.com/l/chat/0/0?users=" + pUri+"&topicName=" +topicName);
}

function checkSpace(str) { if (str.search(/\s/) != -1) { return true; } else { return false; } }
function checkSpecial(str) { var special_pattern = /[`~!@#$%^&*|\\\'\";:\/?]/gi; if (special_pattern.test(str) == true) { return true; } else { return false; } }


// orgStr 의 문자열 중에 findStr 에 해당하는 문자열을 replaceStr 로 바꿉니다.
// 이 때 findStr 에는 정규식에 해당하는 문자열 경우 "\\" + findStr 형식으로 주어야 합니다.
function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");

    return (orgStr.replace(re, replaceStr));
}


function truebody() {
    return (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement : document.body
}



