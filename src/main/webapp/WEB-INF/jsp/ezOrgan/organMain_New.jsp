<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height: 100%;">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><spring:message code="main.t8" /></title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
    
    <!-- CSS -->
    <link rel="stylesheet" href="${util.addVer('/css/teams/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('/css/teams/teams_common.css')}" />
    <link rel="stylesheet" href="${util.addVer('/css/teams/teams_content.css')}" />
    <link rel="stylesheet" href="${util.addVer('/css/teams/teams_jquery.scrollbar.css')}" />
    <link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" />
    <link rel="stylesheet" href="${util.addVer('/css/teams/default_kr.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('/css/teams/bootstrap.min.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('/css/teams/organ_tree.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('/css/teams/messenger_pop.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('/css/teams/namecard.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('/css/teams/Layer.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('/css/teams/tab.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('/css/teams/teams_organ.css')}">
    <link rel="stylesheet" href="${util.addVer('/css/teams/toastr.css')}">

    <!-- JS -->
    <script type="text/javascript" src="${util.addVer('/js/ezConn/MicrosoftTeams.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/teams/script/jquery-3.3.1.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/teams/script/bootstrap.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/teams/treeview/TreeView_New.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/teams/script/organInfo_New.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/teams/listview/OrganView_list.js')}"></script>
    
    
    <script type="text/javascript" src="${util.addVer('/js/teams/script/NameControl_New.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/teams/script/Common.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/teams/script/appOrg_New.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/teams/toastr.js')}"></script>
    <!-- Language Pack -->
    <script type="text/javascript" src="${util.addVer('ezTeams.e2', 'msg')}"></script>

</head>

    <script type="text/javascript">
        var appId = "${teamsOrganInfo.appId}";
        var tenant = "${teamsOrganInfo.tenant}";
        var config, company, mode;
        var organization = new Object, domains = new Object, me = new Object, groups = new Object, orgObject = new Object;
        var device = "${teamsOrganInfo.device}";
        var delegatedToken = "${teamsOrganInfo.delegatedAuthToken}";
        var publicAppToken = "${teamsOrganInfo.publicAuthToken}";
        var usePresence = "${teamsOrganInfo.usePresence}";
        var presenceInterval = "${teamsOrganInfo.presenceInterval}";
        var g_strUserId = "${userInfo.upnname}";
        var g_UserTeamsId = "${userInfo.teamsId}";
        var nameCardFlag = false;
        var g_strUserLanguage = "${userInfo.lang}";
        var g_strKeyword = "";
        var g_OrganXml;
        var g_IsSearch = false;
        var g_ListType = "TXT";
        var UserInfo = "<c:out value='${userInfo}'/>";
        var deptID = "<c:out value='${userInfo.deptID}'/>";
        var SELECT_DEPTID = "<c:out value='${userInfo.deptID}'/>";
        var companyID = "<c:out value='${userInfo.companyID}'/>";
        
    </script>
</head>

<body>
    <!-- wrap layout -->
    <div class="teams_wrap">
        
        <div  class="teams_organ">
            <!-- 부서,이름 검색 -->
            <div class="organ_top">
                <span class="inp_search">
                    <input id="deptkeyword" type="search" onkeypress="deptsearch_press('WEB')" placeholder="<spring:message code="ezTeams.t122"/>" autocomplete="off"  required/>
                    <button class="btnClear" onclick="clear_input('deptkeyword')"></button>
                    <button onclick="deptsearch_click('WEB')" type="button" id="searchPopup" class="icon_organ i_search"></button>
                </span>
                <span class="icon_organ i_organ"></span>
                <span class="title_h2" id="selecterPopupM"><span id="RowCntM">0</span><span><spring:message code="ezTeams.t35"/></span><spring:message code="ezTeams.t104"/></span>
                <button type="button" id="talkPopupM"><span class="icon_organ i_talk"></span></button>
                <button type="button" id="teamPopupM"><span class="icon_organ i_team"></span></button>
                <button type="button" id="searchPopupM"><span class="icon_organ i_search"></span></button>
            </div>
            <!-- //부서,이름 검색 -->
            <!-- teams tree -->
            <div>
                <select id="ListCompany" title="<spring:message code='ezTeams.t00006'/>" style="width:100%; height:30px; display:none;">
                    <c:forEach var="company" items="${teamsOrganInfo.companyList}">
                        <option value="${company.companyId}">${company.companyName}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div id="organizationDiv" class="organizationDiv">
                <div id="TreeView" class="treeview">
                    
                </div>
                <div class="layer_kebob">
                    <button type="button" name="layer_close" class="i_talk"><spring:message code="ezTeams.t107"/></button>
                    <button type="button" name="layer_close" class="i_phone"><spring:message code="ezTeams.t108"/></button>
                </div>
            </div>
            <!-- //teams tree -->
        </div>
        <div class="teams_container">
            <div class="listview_container">
                <div class="listview_cont">
                    <div class="listview_top">
                        <h1 id="selectedDeptName"></h1>
                        <div class="user_search">
                            <select id="search_type" data-width="100px">
                                <option selected="selected" value="displayName" usedefault="1"><spring:message code="ezTeams.Displayname"/></option>
                                <option value="title" usedefault="1"><spring:message code="ezTeams.Title"/></option>
                                <option value="description" usedefault="1"><spring:message code="ezTeams.Department"/></option>
                                <option value="extensionAttribute10" usedefault="1"><spring:message code="ezTeams.Role"/></option>
                                <option value="mail" usedefault="1"><spring:message code="ezTeams.Mail"/></option>
                                <option value="mobile" usedefault="1"><spring:message code="ezTeams.Mobile"/></option>
                            </select>
                            <div class="inp_search">
                                <input id="keyword" type="search" onkeypress="search_press()" placeholder="<spring:message code="ezTeams.t123"/>" autocomplete="off" required />
                                <button class="btnClear" onclick="clear_input('keyword')"></button>
                                <button type="button" onclick="search_click()" class="icon_organ i_search"></button>
                            </div>
                        </div>
                    </div>
                    <div class="listview_user">
                        <div class="listview_header">
                            <span class="listview-check checks">
                                <input onclick="Check_AllRows()" type="checkbox" name="" value="" id="HeaderAllCheckBox">
                                <label for="HeaderAllCheckBox"><spring:message code="ezTeams.t106"/></label>
                            </span>
                            <span class="icon_organ i_department"></span>
                            <span id="userCnt" class="count"></span>
                        </div>
                        <div id="ItemList_Div">
                            <ul id="OrganList">
                            
                            </ul>
                        </div>
                        <div id="noData_Div" class="noData_text" style="display:none;">
                            <span><strong id="noDataDept"></strong><spring:message code="ezTeams.t121"/></span>
                        </div>
                    </div>
                    <div id="infobox" class="infobox_user">
                        <div  class="infobox_user_cont">
                            <button type="button" name="infobox_close"><span class="icon_organ i_close"></span></button>
                            <div class="info_simple">
                                <span class="node_flex">
                                    <span class="user_photo" data1="" data2="" data3="" data4="" data5="">
                                        <img class="userImg" namecard="Y" src="/images/teams/user_photo.png">
                                        <img class="presenceState" onclick="" src="/images/teams/Presence_Available.jpg">
                                    </span>
                                    <span class="user_list_info">
                                        <span class="nameBox">
                                            <span class="name"></span>
                                            <span class="concurrent"></span><!-- 겸직이있을겨우만 span태그 생성 또는 display:none; 처리 -->
                                        </span>
                                        <span class="rank"></span>
                                        <span class="department"></span>
                                    </span>
                                </span>
                                <ul class="info_btn">
                                    <li><button id="goConversation" type="button" class="i_talk"><spring:message code="ezTeams.t107"/></button></li>
                                    <li><button id="goCalling" type="button" class="i_call"><spring:message code="ezTeams.t108"/></button></li>
                                </ul>
                            </div>
                            <div class="info_detail">
                                <ul>
                                    <li>
                                        <span><spring:message code="ezTeams.Company"/></span>
                                        <span class="company"></span>
                                    </li>
                                    <li>
                                        <span><spring:message code="ezTeams.mh003"/></span>
                                        <span class="title"></span>
                                    </li>
                                    <li>
                                        <span><spring:message code="ezTeams.Mail"/></span>
                                        <span class="mail"></span>
                                    </li>
                                    <li>
                                        <span><spring:message code="ezTeams.t90"/></span>
                                        <span class="company_phone"></span>
                                    </li>
                                    <li>
                                        <span><spring:message code="ezTeams.Mobile"/></span>
                                        <span class="phone"></span>
                                    </li>
                                    <li>
                                        <span><spring:message code="ezTeams.t91"/></span>
                                        <span class="work"></span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="select_user">
                    <button type="button" class="select_toggle"></button>
                    <div class="select_user_toggle">
                        <div class="select_user_top">
                            <h1><spring:message code="ezTeams.t32"/></h1>
                            <span class="icon_organ i_department"></span>
                            <span id="RowCnt" class="count" >0</span>
                            <button onclick="delete_onClick()" class="btn_text" type="button"><spring:message code="ezTeams.t109"/></button>
                        </div>
                        <div id="SelectedList" class="select_user_list">
                            
                        </div>
                        <div class="select_user_btn">
                            <button type="button" id="talkPopup" class="i_talk"><spring:message code="ezTeams.t110"/></button>
                            <button type="button" id="teamPopup" class="i_team"><spring:message code="ezTeams.t111"/></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- search layerPopup -->
        <div class="layerPopup layerPopup_serch">
            <div class="layer_top">
                <h2><spring:message code="ezTeams.t4"/></h2>
                <button type="button" name="layer_close"><span class="icon_organ i_close"></span></button>
            </div>
            <div class="layer_text">
                <span id="searchValue"></span> <p id="searchedDeptCnt">0</p> <spring:message code="ezTeams.t112"/>
            </div>
            <div id="searchList" class="layer_list">
                
            </div>
            <div class="layer_btn">
                <button onclick="ReturnFunction()" type="button" class="ok"><spring:message code="ezTeams.t9"/></button>
                <button type="button" name="layer_close"><spring:message code="ezTeams.t10"/></button>
            </div>
            <div class="layerPopup_serchM">
                <div class="organ_top">
                    <button type="button" class="btn_top_close" name="layer_close"><span class="icon_organ i_close"></span></button>
                    <span class="title_h2"><spring:message code="ezTeams.t7"/></span>
                    <button type="button" class="btn_text" onclick="addCheckedNodes()"><spring:message code="ezTeams.t32"/></button> <!-- 선택시 나타나게 -->
                </div>
                <div class="organ_search">
                    <div class="inp_search">
                        <input id="keywordM" type="search" onkeypress="deptsearch_press('MOB')" placeholder="<spring:message code="ezTeams.t105"/>" autocomplete="off" required />
                        <button class="btnClear" onclick="clear_input('keywordM')"></button>
                        <button type="button" onclick="deptsearch_click('MOB')" class="icon_organ i_search"></button>
                    </div>
                </div>
                <div id="searchListM" class="layerM_list">
                    <p><spring:message code="ezTeams.t115"/><span><spring:message code="ezTeams.t113"/></span> <span id="searchedDeptCntM">0</span><span><spring:message code="ezTeams.t114"/></span></p>
                    <div id="searchListMDept" class="dept">
                    </div>
                    
                    <p><spring:message code="ezTeams.t116"/><span><spring:message code="ezTeams.t113"/></span> <span id="searchedUserCntM">0</span><span><spring:message code="ezTeams.t114"/></span>
                        <span id="allCheckSearchedUser" class="textBtn"><spring:message code="ezTeams.t106"/></span>
                    </p>
                    
                    <div id="searchListMUser" class="user">
                    </div>
                </div>
            </div>
        </div>
        <!-- //search layerPopup -->
        <!-- talk layerPopup -->
        
        <!-- info layerPopup -->
        <div class="layerPopup layerPopup_info">
            <div class="layerPopup_infoM">
                <div class="layer_top">
                    <h2><spring:message code="ezTeams.mh001"/></h2>
                    <button type="button" name="layer_close"><span class="icon_organ i_close"></span></button>
                </div>
                <div class="infobox_user_cont">
                    <div class="info_simple">
                        <span class="node_flex">
                            <span class="user_photo" data1="" data2="" data3="" data4="" data5="">
                                <img class="userImg" namecard="Y" src="/images/teams/user_photo.png">
                                <img class="presenceState" onclick="" src="/images/teams/Presence_Available.jpg">
                            </span>
                            <span class="user_list_info">
                                <span class="nameBox">
                                    <span class="name"></span>
                                    <span class="concurrent"></span>
                                </span>
                                <span class="rank"></span>
                                <span class="department"></span>
                            </span>
                        </span>
                        <ul class="info_btn">
                            <li><button type="button" class="i_talk"><spring:message code="ezTeams.t107"/></button></li>
                            <li><button type="button" class="i_call"><spring:message code="ezTeams.t108"/></button></li>
                        </ul>
                    </div>
                    <div class="info_detail">
                        <ul>
                            <li>
                                <span><spring:message code="ezTeams.Company"/></span>
                                <span class="company"></span>
                            </li>
                            <li>
                                <span><spring:message code="ezTeams.mh003"/></span>
                                <span class="title"></span>
                            </li>
                            <li>
                                <span><spring:message code="ezTeams.Mail"/></span>
                                <span class="mail"></span>
                            </li>
                            <li>
                                <span><spring:message code="ezTeams.t90"/></span>
                                <span class="company_phone"></span>
                            </li>
                            <li>
                                <span><spring:message code="ezTeams.Mobile"/></span>
                                <span class="phone"></span>
                            </li>
                            <li>
                                <span><spring:message code="ezTeams.t91"/></span>
                                <span class="work"></span>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="organ_top">
                    <button type="button" class="btn_top_close" name="layer_close"><span class="icon_organ i_close"></span></button>
                    <span class="title_h2"><spring:message code="ezTeams.mh001"/></span>
                </div>
            </div>
        </div>
        <div class="layerPopup layerPopup_selecter">
            <div class="layerPopup_selecterM">
                <div class="layer_top">
                    <h2><spring:message code="ezTeams.t117"/></h2>
                    <button type="button" name="layer_close"><span class="icon_organ i_close"></span></button>
                </div>
                <div class="select_user_list">
                    <div class="select_user_top">
                        <span class="icon_organ i_department"></span>
                        <span id="selCntM" class="count">0</span>
                        <button onclick="delete_onClick()" class="btn_text" type="button"><spring:message code="ezTeams.t109"/></button>
                    </div>
                    <div id="SelectedListM">

                    </div>
                    
                </div>
                <div class="organ_top">
                    <button type="button" class="btn_top_close" name="layer_close"><span class="icon_organ i_close"></span></button>
                    <span class="title_h2"><spring:message code="ezTeams.t118"/></span>
                    <button type="button" id="talkPopupM2" ><span class="icon_organ i_talk"></span></button>
                    <button type="button" id="teamPopupM2"><span class="icon_organ i_team"></span></button>
                </div>
            </div>
        </div>
        <div class="layerPopup layerPopup_talk">
            <div class="layerPopup_talkM">
                <div class="layer_top">
                    <h2><spring:message code="ezTeams.t110"/></h2>
                    <button type="button" name="layer_close"><span class="icon_organ i_close"></span></button>
                </div>
                <h3 class="layer_subtext"><spring:message code="ezTeams.t61"/></h3>
                <div class="inp_text">
                    <input id="groupName" type="text" placeholder="<spring:message code="ezTeams.t60"/>" autocomplete="off" required />
                    <button class="btnClear" onclick="clear_input('groupName')"></button>
                </div>
                <div class="layer_table">
                    <dl>
                        <dt><spring:message code="ezTeams.t117"/></dt>
                        <dd class="selectedList">
                        </dd>
                    </dl>
                </div>
                <div class="layer_btn">
                    <button id="groupChat" onclick="regist()" type="button" class="ok"><spring:message code="ezTeams.t9"/></button>
                    <button type="button" name="layer_close"><spring:message code="ezTeams.t10"/></button>
                </div>

                <div class="organ_top">
                    <button type="button" class="btn_top_close" name="layer_close"><span class="icon_organ i_close"></span></button>
                    <span class="title_h2"><spring:message code="ezTeams.t110"/></span>
                    <button id="groupChatM" onclick="regist()" type="button" class="btn_text"><spring:message code="ezTeams.t9"/></button> <!-- 선택시 나타나게 -->
                </div>
            </div>
        </div>

        <!-- team layerPopup -->
        <div class="layerPopup layerPopup_team">
            <div class="layerPopup_teamM">
                <div class="layer_top">
                    <h2><spring:message code="ezTeams.t111"/></h2>
                    <button type="button" name="layer_close"><span class="icon_organ i_close"></span></button>
                </div>
                <div class="inp_text">
                    <input id="inputTeamName" type="text" autocomplete="off" placeholder="<spring:message code="ezTeams.t124"/>" required />
                    <button class="btnClear" onclick="clear_input('inputTeamName')"></button>
                </div>
                <div class="layer_table">
                    <dl>
                        <dt><spring:message code="ezTeams.t120"/></dt>
                        <dd>
                            <span class="radios">
                                <input type="radio" name="groupType" id="jb-radio-1" title="<spring:message code="ezTeams.t64"/>" class="custom-control-input" value="Public" checked />
                                <label for="jb-radio-1">Pubilc</label>
                            </span>
                            <span class="radios">
                                <input type="radio" name="groupType" id="jb-radio-2" title="<spring:message code="ezTeams.t65"/>" class="custom-control-input" value="Private" />
                                <label for="jb-radio-2">Private</label>
                            </span>
                        </dd>
                    </dl>
                    <dl>
                        <dt><spring:message code="ezTeams.t117"/></dt>
                        <dd class="selectedList">
                        </dd>
                    </dl>
                </div>
                <div class="layer_btn">
                    <button id="createTeam" onclick="Team_regist()" type="button" class="ok"><spring:message code="ezTeams.t9"/></button>
                    <button type="button" name="layer_close"><spring:message code="ezTeams.t10"/></button>

                </div>

                <div class="organ_top">
                    <button type="button" class="btn_top_close" name="layer_close"><span class="icon_organ i_close"></span></button>
                    <span class="title_h2"><spring:message code="ezTeams.t111"/></span>
                    <button id="createTeamM" onclick="Team_regist()" type="button" class="btn_text"><spring:message code="ezTeams.t9"/></button> <!-- 선택시 나타나게 -->
                </div>
            </div>

        </div>
        <div id="mask" style="position:absolute; z-index:11000; background-color:#000000; display:none; left:0; top:0; width:100%; height: 100%; opacity:0.3;"></div>
        <div id="loadingImg" style="position:absolute; left:45%; top:40%; display:none;  z-index:11001;">
            <img src="/images/loading/loading.gif" />
        </div>
        <div class="Main_Panel">&nbsp;</div>
    </div>
    <!-- //wrap layout -->
   

    <script type="text/javascript">
        var is_init = false;
        var searchM = false;
        var selectM = false;
        var closeFlag = false;
        var preLayer = '';
        var currLayer = '';
        var initialX = null;
        var initialY = null;
        var container = $("#mainBody")[0];
        // var SELECT_DEPTID = "";
        var companyName = $("#ListCompany")[0].options[$("#ListCompany")[0].options.selectedIndex].text;
        
        var allCheckSearchFlag = false;
        var inFoFlag = false;
        var isTeamsInitialized = false;
        
         $(window).bind("hashchange", function () {
            if (isMobile() || isTabletDevice()) {
                if (currLayer != '') {
                    $(currLayer).removeClass('active');
                    if (selectM) {
                        currLayer = preLayer;
                        selectM = false;
                    }
                    if (searchM) {
                        currLayer = preLayer;
                        searchM = false;
                    }
                } else {
                    $('div .active').removeClass('active');
                }
            }
        });


        window.onload = function () {
           
            "use strict";

            var config = {
                tenant: tenant,
                clientId: appId,
                cacheLocation: "localStorage",
                navigateToLoginRequestUrl: false,
                endpoints: {
                graphApiUri: "https://graph.microsoft.com"
                }
            };

            if (window.microsoftTeams?.app?.initialize) {
                microsoftTeams.app.initialize().then(function () {
                    microsoftTeams.app.getContext().then(function (context) {
                        var upn = context?.user?.userPrincipalName;

                        if (upn) {
                        config.extraQueryParameters = "scope=openid+profile&login_hint=" + encodeURIComponent(upn);
                        } else {
                            config.extraQueryParameters = "scope=openid+profile";
                        }
                        showDiv("organization_New");
                        $("#mainBody").hide();
                        isTeamsInitialized = true;
                        microsoftTeams.appInitialization.notifySuccess();
                    }).catch(function (err) {
                        microsoftTeams.appInitialization.notifyFailure({
                            reason: microsoftTeams.appInitialization.FailedReason.Other,
                            message: err.message
                        });
                    });
                }).catch(function (err) {
                    isTeamsInitialized = false;
                    var mockUPN = "e3gisa1@kaonicloud.com";
                    config.extraQueryParameters = "scope=openid+profile&login_hint=" + encodeURIComponent(mockUPN);
                    showDiv("organization_New");
                    $("#mainBody").hide();
                    microsoftTeams.appInitialization.notifyFailure({
                        reason: microsoftTeams.appInitialization.FailedReason.Other,
                        message: err.message
                    });
                });
            } else {
                // Teams SDK가 없는 경우에만 실행
                isTeamsInitialized = false;
                var mockUPN = "e3gisa1@kaonicloud.com";
                config.extraQueryParameters = "scope=openid+profile&login_hint=" + encodeURIComponent(mockUPN);
                showDiv("organization_New");
                $("#mainBody").hide();
            }

            setInterval(getAllPresence_DB, presenceInterval);

            SELECT_DEPTID = deptID;
          
            /* 레이어팝업 채팅생성 active */
            $("#talkPopup , #talkPopupM").click(function () {
                currLayer = ".layerPopup_talk, .Main_Panel";
                GroupChat();
            });
            $("#talkPopupM2").click(function () {
                currLayer = '.layerPopup_talk, .Main_Panel';
                selectM = false;
                GroupChat();
                selectM = true;
            });
            /* 레이어팝업 팀생성 active */
            $('#teamPopup , #teamPopupM').click(function () {
                currLayer = '.layerPopup_team, .Main_Panel';
                if (!isTeamsInitialized) {
                    toastMessage(strLang71, null, "1");
                    return;
                }
                CreateTeam();
            });
            $('#teamPopupM2').click(function () {
                currLayer = '.layerPopup_team, .Main_Panel';
                if (!isTeamsInitialized) {
                    toastMessage(strLang71, null, "1");
                    return;
                }
                selectM = false;
                CreateTeam();
                selectM = true;
            });

            /* 레이어팝업 검색 active */
            $('#searchPopupM').click(function () {
                currLayer = '.layerPopup_serch, .Main_Panel';
                toggleClassFn(currLayer);
                preLayer = currLayer;
            });

            /* 레이어팝업 직원조회 active */
            $('#infoPopupM').click(function () {
                currLayer = '.layerPopup_info, .Main_Panel';
                toggleClassFn(currLayer);
                preLayer = currLayer;
            }); 
            /* 선택인원확인 active */
            $('#selecterPopupM > span').click(function () {
                currLayer = '.layerPopup_selecter';
                toggleClassFn(currLayer);
                preLayer = currLayer;
                selectM = true;
            });
            /* 선택창 토글 레이아웃 active */
            $('.select_toggle').click(function () {
                currLayer = '.select_toggle, .select_user_toggle';
                toggleClassFn(currLayer);
                preLayer = currLayer;
            });
            /* 레이어팝업 remove active */
            $('button[name=layer_close]').click(function () {
                if (currLayer != '') {
                    $(currLayer).removeClass('active');
                    if (selectM) {
                        currLayer = preLayer;
                        selectM = false;
                        if (isMobile() || isTabletDevice()) {
                            history.replaceState(null, null, "#active");
                        }
                    }
                    if (searchM) {
                        currLayer = preLayer;//'.layerPopup_serch, .Main_Panel';
                        searchM = false;
                        if (isMobile() || isTabletDevice()) {
                            history.replaceState(null, null, "#active");
                        }
                    }
                    
                }else{
                    $('div .active').removeClass('active');
                }
                if (isMobile() || isTabletDevice()) {
                    history.back();
                }
            });
            $("button[name=infobox_close]").on("click", function () {
                infoBoxToggle("");
            });
            $('#allCheckSearchedUser').click(function () {
                Check_AllSearchedRows();
                
            });
            /* 모바일 kebob button remove active 20241023 */
            $('button[name=layer_close], .Main_Panel').click(function () {
                if (currLayer.indexOf('.layer_kebob') > -1) {
                    $('.layer_kebob, .Main_Panel').removeClass('active');

                    if (isMobile() || isTabletDevice()) {
                        history.back();
                    }
                }
            });
        }
        function isMobile() {
            if (
                navigator.userAgent.match(/Phone/i) ||
                navigator.userAgent.match(/DROID/i) ||
                navigator.userAgent.match(/Android/i) ||
                navigator.userAgent.match(/webOS/i) ||
                navigator.userAgent.match(/iPhone/i) ||
                navigator.userAgent.match(/iPod/i) ||
                navigator.userAgent.match(/BlackBerry/) ||
                navigator.userAgent.match(/Windows Phone/i) ||
                navigator.userAgent.match(/ZuneWP7/i) ||
                navigator.userAgent.match(/IEMobile/i)
            ) { return true; }
            return false;
        }

        function isTabletDevice() {
            if (
                navigator.userAgent.match(/Tablet/i) ||
                navigator.userAgent.match(/iPad/i) ||
                navigator.userAgent.match(/Kindle/i) ||
                navigator.userAgent.match(/Playbook/i) ||
                navigator.userAgent.match(/Nexus/i) ||
                navigator.userAgent.match(/Xoom/i) ||
                navigator.userAgent.match(/SM-N900T/i) || //Samsung Note 3
                navigator.userAgent.match(/GT-N7100/i) || //Samsung Note 2
                navigator.userAgent.match(/SAMSUNG-717/i) || //Samsung Note
                navigator.userAgent.match(/SM-T/i) //Samsung Tab 4
            ) { return true }
            return false;
        }
        //////////////////////////////////////////////////////채팅 만들기///////////////////////////////////////
        function regist() {
            var groupName = $("#groupName").val();

            let selected = selectedList.treeview('getNodeAll', []);
            let Uri = "";

            if (selected.length > 100) {
                toastMessage(strLang18, null, "2");
                return;
            } else if (selected.length < 1) {
                toastMessage(strLang63, null, "2");
                return;
            }
            Uri = makeUri();
            
            if (groupName == "" || selected.length == 1) {
                btn_OpenConversation(Uri);
            }
            else {
                btn_OpenConversationWithTopicName(Uri, groupName, $("#groupName"));
            }


        }
        //////////////////////////////////////////////////////채팅 끝///////////////////////////////////////

        function enterKey() {
            if (window.event.keyCode == "13")
                regist();
        }
        function CreateChatRoom_cancel_onClick() {
            $("#result").modal("hide");
        }

        //////////////////////////////팀 생성////////////////////////////////////////////
        function Team_regist() {
            var userID = g_strUserId;
            let Uri = "";
            Uri = makeUri();

            var teamName = $('#inputTeamName').val();
            
            var pattern = /\D/g;
            
            if (teamName != "") {
                //Create365Group(teamName, userID, Uri); // 그룹 반영시간이 오래걸려 방식 변경
                Create_Team(teamName, userID, Uri);
            }else{
                toastMessage("<spring:message code="ezTeams.t124"/>", null, "2");
            }
        }

        function Team_enterKey() {
            if (window.event.keyCode == "13")
                Team_regist();
        }

        ////////////////////////////////팀 생성끝/////////////////////////////////////////

        /////////////////////검색 부서 선택창 시작////////////////////////////////
        var ReturnFunction;
        var cancelfunction;

        var SelCompanyFlag = false;
        
        function company_change(obj) {
            onClickeDropdown();
            
            if ($("#ListCompany")[0].options.selectedIndex != obj.id) {
                SelCompanyFlag = true;
                $("#ListCompany")[0].options[obj.id].selected = true;
            } else {
                return;
            }
            
            MakeTreeView_New();
            SelCompanyFlag = false;
        }
        function onClickeDropdown() {
            currLayer = '.btn_company, .droupdown_menu';
            toggleClassFn(currLayer);
            preLayer = currLayer;
        }
       
        function toggleClassFn(target) { 
            if (isMobile() || isTabletDevice()) {
                if (location.hash == "") {
                    history.pushState(null, null, "#active");
                } else if (location.hash == "#active") {
                    history.pushState(null, null, "#activeLayer");
                }
            }

            if (target != '')
                $(target).toggleClass('active');
            else
                $('div .active').toggleClass('active');

            if (selectM) { 
                currLayer = '.layerPopup_selecter';
                selectM = false;
            }
            
        }
        function HtmlDecode(str){
	        str = ReplaceText(str, "&amp;", "&");
            str = ReplaceText(str, "&amp;", "&");
            str = ReplaceText(str, "&lt;", "<");
            str = ReplaceText(str, "&gt;", ">");    
            str = ReplaceText(str, "&#39;", "'");
	        str = ReplaceText(str, "&quot;", "\"");
            str = ReplaceText(str, "&#92;", "\\");	
            str = ReplaceText(str, "&#47;", "/");	
            str = ReplaceText(str, "&#124;", "|");
            str = ReplaceText(str, "&#183;", "·");
            str = ReplaceText(str, "&#x27;", "'");
            str = ReplaceText(str, "&#x2B;", "+");
            return str;
        }
        function CreateTeam_cancel_onClick(){
            currLayer = ".layerPopup_team, .Main_Panel";
            toggleClassFn(currLayer);
            preLayer = currLayer;
        }
        function makeUri() {
            var Uri = '';
            let selected = selectedList.treeview('getNodeAll', []);
            var selectList = $(".layerPopup_talk .selectedList");
            if (selected.length > 1) {

                for (let i = 0; i < selected.length; i++) {
                    try {
                        if (i == selected.length - 1)
                            Uri += selected[i].upnName;
                        else
                            Uri += selected[i].upnName + ",";

                        objUserList = null;
                    }
                    catch (e) { }
                }

            } else {
                Uri += selected[0].upnName;
            }
            return Uri;
        }

        var input = document.getElementById('inputTeamName');

        function infoBoxToggle(pos) {
            $(".infobox_user").css({ "margin-bottom": pos });
            if (pos != "") {
                inFoFlag = false;
            }else{
                inFoFlag = true;
            }
        }
        function clear_input(obj) { 
            $("#" + obj).val("");
        }
        
    </script>
</body>
</html>