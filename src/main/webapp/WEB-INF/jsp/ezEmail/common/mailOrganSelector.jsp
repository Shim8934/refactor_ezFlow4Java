<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%-- 트리뷰 높이, rightPage 에서는 ${param.treeHeight}으로 사용하면 됨 --%>
<c:set var="treeHeight" value="${443 + param.additionalHeight}" />

<style>
    .popup .mainlist .checks input[type="checkbox"] + label::before {
        top: 4px;
    }

    .contentlayout {
        overflow: visible;
    }

    .contentlayout:after {
        content: "";
        display: block;
        clear: both;
    }

    .tree.border_box.scroll-wrapper, .content_listtype > .scroll-wrapper {
        height: 100%;
    }

    /* 테이블 hover시 배경색상 넣은 부분 - 어색한 부분이 있으면 별도로 스크립트 생성 필요 */
    .mainlist tr:hover, .content_listtype_photo li:hover {
        background-color: #f4f4f5;
        cursor: pointer;
    }

    .mainlist tr.selected, .content_listtype_photo li.selected {
        background-color: #dbe1e7;
        cursor: pointer;
    }

    <c:if test="${not empty param.leftWidth}">
    .receive_box { width: calc(100% - ${param.leftWidth}px); }
    .receives { width: ${param.leftWidth}px; }
    </c:if>
    .mail_userinfo>li:first-child > img {vertical-align:top; margin: 5px 3px;}
    .mail_userinfo li:first-child p {margin: unset;}
    .mail_userinfo li:first-child .tit{
	    display:inline-block; 
	    padding-right:10px; 
	    font-size:13px; 
	    line-height:30px; 
	    letter-spacing:-0.6px; 
	    vertical-align:2px;
    }
    .mail_userinfo li:first-child .subtxt{
    	display:inline-block; 
    	font-size:13px; 
    	line-height:30px; 
    	letter-spacing:-0.5px; 
    	font-weight:normal; 
    	vertical-align:2px;
    }
    .mail_userinfo li:last-child{float:right;}
	.mail_userinfo .mail_userinfoBtn li{list-style:none; float:left; margin:3px; }
	
	.portlet_tabpart01_top p.tabon > span {
	    position: relative;
	    border: 1px solid #999;
	    border-bottom: 1px solid #eee;
	    background: white;
	    color: #333;
	    z-index: 100;
	} 
</style>

<ul class="contentlayout mt15">
    <div class="portlet_tabpart01_top organ tab_menu">
    	<p data-tab-id="org" class="on tabon"><span><spring:message code='ezEmail.t591'/></span></p>
    	<p data-tab-id="jobTitle"<c:if test="${param.hideJobTitleTab}"> style="display: none;"</c:if>><span><spring:message code='ezOrgan.ksaOrganList01'/></span></p>
        <p data-tab-id="jobRole"<c:if test="${param.hideJobRoleTab}"> style="display: none;"</c:if>><span><spring:message code='ezOrgan.ksaOrganList02'/></span></p>
        <p data-tab-id="contact"<c:if test="${param.hideContactTab}"> style="display: none;"</c:if>><span><spring:message code='ezEmail.t592'/></span></p>
        <p data-tab-id="dl"<c:if test="${param.hideDlTab}"> style="display: none;"</c:if>><span><spring:message code='ezEmail.t593'/></span></p>
        <p data-tab-id="sharedMail"<c:if test="${useSharedMailbox ne 'YES'}"> style="display: none;"</c:if>><span><spring:message code='ezEmail.sharedMailbox02'/></span></p>
        <p data-tab-id="manual"<c:if test="${param.hideManualTab}"> style="display: none;"</c:if>><span><spring:message code='ezEmail.t244'/></span></p>
    </div>
    <ul class="contentlayout mt15">
    	<c:set var="receive_box_w" value="${empty param.rightPage ? '100%' : '70%'}" />
        <li class="contentlayout_left receive_box" style="width: ${receive_box_w};" >
            <!-- 조직도 -->
            <div id="org-content" style="">
            	<!-- 검색  -->
                <ul class="contentlayout" style="background: #f8f8f8; border: 1px solid #eaeaea; box-sizing: border-box; padding: 2px 5px;">
                    <li class="contentlayout_left receive_search">
                        <select id="search_type" class="select-box type01 new_sel linebox" data-type="org">
	                        <option value="displayname" selected><spring:message code='ezEmail.t31'/></option>
	                        <option value="description"><spring:message code='ezEmail.t26'/></option>
	                        <option value="title"><spring:message code='ezEmail.t28'/></option>
	                        <option value="extensionAttribute10"><spring:message code='ezEmail.t281'/></option>
	                        <option value="telephonenumber"><spring:message code='ezEmail.t99000045'/></option>
	                        <option value="mobile"><spring:message code='ezEmail.t99000046'/></option>
	                        <option value="HomePhone"><spring:message code='ezEmail.t29'/></option>
	                        <option value="facsimileTelephoneNumber"><spring:message code='ezEmail.t99000047'/></option>
	                        <option value="mail"><spring:message code='ezEmail.t99000048'/></option>
	                        <c:if test="${primaryLang eq '3' }">
	                            <option value="extensionPhone"><spring:message code='main.ksa02'/></option>
	                            <option value="officeMobile"><spring:message code='main.ksa03'/></option>
	                            <option value="extensionPhone" usedefault="0"><spring:message code='main.ksa02'/></option>
	                            <option value="officeMobile" usedefault="0"><spring:message code='main.ksa03'/></option>
	                        </c:if>
                        </select>
                        
                        <input id="org-keyword" type="text" placeholder="">
                        <a class="imgbtn" onclick="doOrganSearch('search');"><span><spring:message code='ezEmail.t37'/></span></a>
                    </li>
                    <li class="contentlayout_right">
                        <div class="mainmenu_btn">
							<div style="float: right; margin-right: 5px; position: relative;">
								<a class="imgbtn" id="dept_select" <c:if test="${param.selectOnlyUser}"> style="display: none;"</c:if>><span onclick="dept_select()" style="z-index:10"><spring:message code='ezEmail.t596'/></span></a>
	                            <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezEmail.t597'/></span></a>
							</div>
                        </div>
                    </li>
                </ul>
				<!-- 리스트ul -->
                <ul class="contentlayout" style="border: 1px solid #ddd; margin-top: 3px;">
                    <li class="contentlayout_left receive_chart" style="height:${treeHeight}px; width: 220px; border-right: 1px solid #ddd;"">
                        <div class="tree border_box scrollbar-inner" style="height:100%;">
                            <ul id="TreeView" class="leftList">
                            </ul>
                        </div>
                    </li>

                    <li class="contentlayout_none receive_info">
                        <div id="orglistView" class="border_box line_rds3">
                        	<!-- <div style="height: 30px;">
                        		<span id="SelectDeptNM" style="font-weight: normal;white-space: nowrap;overflow: hidden;display: inline-block;vertical-align: middle;margin-top:-4px;/* text-align: center; */" countinfo="1">
	                        		<img src="/images/OrganTree_cross/ic-open.gif" style="vertical-align:top;padding-right:3px;">
	                        		<span id="spn_deptName" title="수컴퍼니">수컴퍼니</span>
	                        		<span id="countInfo">&nbsp;&nbsp;<span class="countColor">1</span>
	                        		</span>
                        		</span>
                                <span style="float:right; position: relative;">
                                    <span onclick="ChangeListView_onClick('TXT');">
                                        <img src="/images/kr/cm/btn_onlist.gif" class="icon_btn" id="txtlist"></span>
                                    <span onclick="ChangeListView_onClick('IMG');">
                                        <img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
                                </span>
							</div> -->
                            <ul id="SelectDeptNM" class="contentlayout mail_userinfo" style="border-bottom: 1px solid #ddd;">
                                <li style="float:left; ">
                                	<img src="/images/OrganTree_cross/ic-open.gif" style="vertical-align:top;padding-right:3px;">
                                    <p id="org-dept-name" class="tit"></p>
                                    <p class="subtxt">
                                        <span id="org-user-current-count" class="c_blue"></span>
                                        <span id="org-user-total-count-wrapper" style="display:none;">&nbsp;&nbsp;/&nbsp;&nbsp;<span id="org-user-total-count" class="c_blue"></span></span>
                                    </p>
                                </li>
                                <li style="float:right; ">
                                    <ul class="mail_userinfoBtn">
                                        <li onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></li>
                                        <li onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></li>
                                    </ul>
                                </li>
                            </ul>
                            <div class="content_listtype" style="height:${430 + param.additionalHeight}px">
                                <div class="scrollbar-inner">
                                    <div id="txtlist_Layer">
                                        <!-- 리스트타입 -->
                                        <div id="txtlist_table_div">
	                                        <table id="txtlist_table_TH" class="mainlist" style="display:none; width:100%;">
	                                            <thead>
                                                    <th class="txtlist_table_dept" style="padding-left:15px;"><spring:message code='ezOrgan.t68'/></th> <% // 부서 %>
	                                            	<th class="txtlist_table_name"><spring:message code='ezEmail.t31'/></th> <% // 이름 %>
	                                            	<th><spring:message code='ezEmail.t28'/></th> <% // 직위 %>
	                                            	<th><spring:message code='ezOrgan.t95'/></th> <% // 회사전화 %>
	                                            </thead>
	                                        </table>
	                                        <div style="height:${430 + param.additionalHeight - 35}px; overflow: auto;">
		                                        <table id="txtlist_table" class="mainlist" style="width:100%;">
		                                            <tbody>
		                                            </tbody>
		                                        </table>
	                                        </div>
                                        </div>
                                        <!-- 리스트타입(검색) -->
                                        <div id="Search_txtlist_table_div">
	                                        <table id="Search_txtlist_table_TH" class="mainlist" style="display:none; width:100%;">
	                                            <thead>
	                                            	<th style="padding-left:15px;"><spring:message code='ezOrgan.t68'/></th> <% // 부서 %>
	                                            	<th><spring:message code='ezEmail.t31'/></th> <% // 이름 %>
	                                            	<th><spring:message code='ezEmail.t28'/></th> <% // 직위 %>
	                                            	<th><spring:message code='ezOrgan.t95'/></th> <% // 회사전화 %>
	                                            </thead>
	                                        </table>
	                                        <div style="height:${430 + param.additionalHeight - 35}px; overflow: auto;">
		                                        <table id="Search_txtlist_table" class="mainlist" style="width:100%;">
		                                            <tbody>
		                                            </tbody>
		                                        </table>
	                                        </div>
	                                    </div>
                                    </div>

                                    <!-- 앨범타입 -->
	                                <div style="height:${430 + param.additionalHeight - 35}px; overflow: auto;">
                                        <ul id="DeptUserImgList" class="contentlayout content_listtype_photo" style="display:none;">
                                            <li class="contentlayout_none">
                                                <table class="content_listtype_photo_list" style="width:100%;">
                                                    <tbody>

                                                    </tbody>
                                                </table>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div id="org-pagination"></div>
                        </div>
                    </li>
                </ul>
            </div>

            <!-- 주소록 -->
            <div id="contact-content" style="display:none;">
                <ul id="AddrSearch" class="contentlayout">
                    <li class="contentlayout_left receive_search">
                        <div id="search_case" class="select-box type01 new_sel linebox">
                            <a href="javascript:void(0);"><spring:message code='ezEmail.t31'/></a>
                            <ul>
                                <li data-value="S_NAME"><spring:message code='ezEmail.t31'/></li>
                                <li data-value="S_COMPANY"><spring:message code='ezEmail.t712'/></li>
                                <li data-value="S_EMAIL"><spring:message code='ezEmail.t713'/></li>
                            </ul>
                        </div>

                        <div class="input_wrap">
                            <input id="search_text" type="text" placeholder="" onkeyup="AddrSearch_press()">
                            <a href="javascript:void(0);" class="btn_search20" onclick="AddrSearch_click()"><span class="newSubicon newSubicon079"></span></a>
                        </div>
                    </li>
                    <li class="contentlayout_right">
                        <div class="mainmenu_btn">
                            <ul class="mainmenu_btnUL">
                                <li onclick="groupmember_click()"onclick="layer('../ezAddress/addressSelectGroupMailList.html','600','600')"><spring:message code='ezEmail.t598'/></li>
                            </ul>
                        </div>
                    </li>
                </ul>

                <ul class="contentlayout">
                    <li class="contentlayout_left receive_chart">
                        <div class="tree border_box" style="height:${treeHeight}px; overflow:auto;">
                            <ul id="AddressTreeView" class="leftList">
                            </ul>
                        </div>
                    </li>

                    <li class="contentlayout_none receive_info">
                        <div class="border_box line_rds3">
                            <ul class="contentlayout mail_userinfo">
                                <li>
                                    <p id="addressFolderName" class="tit"></p>
                                    <p class="subtxt"><span id="addressFolderCnt" class="c_blue"></span></p>
                                </li>
                                <li>

                                </li>
                            </ul>
                            <div class="content_listtype" style="height:${431 + param.additionalHeight}px">
                                <div class="scrollbar-inner">
                                    <div id="AddressListView"></div>
                                </div>

                            </div>
                            <div id="address-pagination"></div>
                        </div>
                    </li>
                </ul>
            </div>

            <!-- 공용그룹 -->
            <div id="dl-content" style="display:none;">
                <ul class="contentlayout">
                    <c:if test="${useUserDefinedDL eq 'YES' }">
                        <li class="contentlayout_left receive_search">
                            <div id="dlSearch_case" class="select-box type01 new_sel linebox" style="width:145px;" onchange="changeUserDlType()">
                                <a href="javascript:void(0);"><spring:message code='ezEmail.userDL17'/></a>
                                <ul>
                                    <li data-value="include"><spring:message code='ezEmail.userDL17'/></li>
                                    <li data-value="owner"><spring:message code='ezEmail.userDL16'/></li>
                                    <li data-value="search"><spring:message code='ezEmail.userDL40'/></li>
                                </ul>
                            </div>

                            <div class="input_wrap">
                                <input id="dlSearch_text" type="text" placeholder="" onkeyup="dlSearch_press()">
                                <a href="javascript:void(0);" class="btn_search20" onclick="dlSearch_click()"><span class="newSubicon newSubicon079"></span></a>
                            </div>
                        </li>
                    </c:if>
                    <li class="contentlayout_right">
                        <div class="mainmenu_btn">
                            <ul class="mainmenu_btnUL">
                                <li id="dlmember" onclick="dlmember_click()"onclick="layer('mailSelectDLMember.html','800','600')"><spring:message code='ezEmail.t598'/></li>
                            </ul>
                        </div>
                    </li>
                </ul>

                <ul class="contentlayout">
                    <li class="contentlayout_none receive_info">
                        <div class="border_box">
                            <div class="content_listtype" style="height:${treeHeight}px">
                                <div class="scrollbar-inner">
                                    <table id="ListViewDL" class="mainlist">
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>

            <!-- 공유사서함 -->
            <div id="shared-content" style="display:none;">
                <ul id="sharedMailboxMember" class="contentlayout">
                    <li class="contentlayout_right">
                        <div class="mainmenu_btn">
                            <ul class="mainmenu_btnUL">
                                <li onclick="sharedMailboxMember_click()"onclick="layer('mailShowSharedMailboxMember.html','800','600')"><spring:message code='ezEmail.sharedMailbox21'/></li>
                            </ul>
                        </div>
                    </li>
                </ul>

                <ul class="contentlayout">
                    <li class="contentlayout_none receive_info">
                        <div class="border_box">
                            <div class="content_listtype" style="height:${treeHeight}px">
                                <div class="scrollbar-inner">
                                    <table id="ListViewSharedMailbox" class="mainlist" data-type="shared">
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>

            <!-- 직접입력 -->
            <div id="manual-content" style="display:none">
                <div id="ManualView" class="border_box" style="height:${587 + param.additionalHeight}px;">
                    <div style="margin:-1px">
                        <table class="content">
                            <tbody>
                            <tr>
                                <th><spring:message code='ezEmail.t31'/></th>
                                <td><input id="emailname" type="text" style="width:100%;"></td>
                            </tr>
                            <tr>
                                <th><spring:message code='ezEmail.t35'/></th>
                                <td><input id="emailaddr" type="text" style="width:100%;" onkeyup="return on_keydown()"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </li>
        <c:if test="${not empty param.rightPage}">
            <jsp:include page="${param.rightPage}">
                <jsp:param name="treeHeight" value="${treeHeight}"/>
                <jsp:param name="rightPageType" value="${param.rightPageType}"/>
            </jsp:include>
        </c:if>
    </ul>
</ul>

<%-- jsp:include로 이 페이지를 사용할 때 jsp:param으로 넘길 수 있는 파라미터 목록 --%>
<script>
    /**
     * 회사 아이디, 지정안하면 top
     * @type string
     * @default ""
     */
    const topCompId = "${param.topCompId}";
    
    /**
     * adminDist 
     * 특정 회사의 조직도만 보이게 하기 위해 true로 설정 후 topCompId를 회사아이디로 설정하기
     * @type boolean
     * @default ""
     */
    const adminDist = "${param.adminDist}";
    
    /**
     * 초기 조직도 로드 시 선택될 부서의 아이디
     * @type string
     * @default ""
     */
    const initialDeptId = "${param.initialDeptId}";

    /**
     * 다중 선택 여부
     * @type boolean
     * @default true
     */
    const useMultipleSelectable = <c:out value="${param.useMultipleSelectable}" default="true" />;

    /**
     * 모든 회사의 조직도를 표시할지 여부
     * @type boolean
     * @default false
     */
    const useShowAllCompanies = <c:out value="${param.useShowAllCompanies}" default="false" />;

    /**
     * 사용자 정의 배포그룹 사용 여부
     * @type boolean
     * @default false
     */
    const useUserDefinedDL = <c:out value="${param.useUserDefinedDL}" default="false" />;

    /**
     * 조직도 트리 옆에 체크박스 사용 여부
     * @type boolean
     * @default false
     */
    const useOrgListCheckBox = <c:out value="${param.useOrgListCheckBox}" default="false" />;

    /**
     * OCS 사용 여부
     * @type boolean
     * @default false
     */
    const useOcs = <c:out value="${param.useOcs}" default="false" />;

    /**
     * 조직도(직위) 탭 숨김 여부
     * @type boolean
     * @default false
     */
    const isHidingJobTitleTab = <c:out value="${param.hideJobTitleTab}" default="false" />;

    /**
     * 조직도(직책) 탭 숨김 여부
     * @type boolean
     * @default false
     */
    const isHidingJobRoleTab = <c:out value="${param.hideJobRoleTab}" default="false" />;

    /**
     * 주소록 탭 숨김 여부
     * @type boolean
     * @default false
     */
    const isHidingContactTab = <c:out value="${param.hideContactTab}" default="false" />;

    /**
     * 공용그룹 탭 숨김 여부
     * @type boolean
     * @default false
     */
    const isHidingDlTab = <c:out value="${param.hideDlTab}" default="false" />;

    /**
     * 직접입력 탭 숨김 여부
     * @type boolean
     * @default false
     */
    const isHidingManualTab = <c:out value="${param.hideManualTab}" default="false" />;

    /**
     * 부서 선택, 직위선택 체크박스 삭제 여부
     * @type boolean
     * @default false
     */
    const selectOnlyUser = <c:out value="${param.selectOnlyUser}" default="false" />;
</script>