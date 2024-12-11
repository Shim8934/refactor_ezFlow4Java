<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body class="popup">
    <div id="mainmenu">
        <ul class="user_option_horizontal_list" style="display: none;">
            <li id="memberInfoButton" class=""><span onclick="MemberInfo_onclick()"><spring:message code='ezCommunity.jje01' /></span></li>
            <li id="postsViewButton" class=""><span onclick="PostsView_onclick()"><spring:message code='ezCommunity.jje02' /></span></li>
        </ul>
    </div>    
</body>
<script type="text/javascript">
    var selectedUserId = "";
    var selectedUserDeptId = "";
    
    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");

    function WriterName_onclick(elem, pUserID, pDeptID) {
        var optionList = document.getElementsByClassName('user_option_horizontal_list').item(0);

        if (elem.getAttribute('mode') == "off") {

            OrganBtnListHidden();

            // optionList를 elem 근처에 위치시키기 위한 스타일 설정
            optionList.style.display = 'block';
            optionList.style.position = 'absolute';

            // elem의 위치와 크기를 가져옴
            var rect = elem.getBoundingClientRect();

            // optionList의 위치를 elem 바로 아래에 설정 (화면 기준)
            optionList.style.top = (rect.bottom + window.scrollY) + 'px'; // elem의 하단에 위치
            optionList.style.left = (rect.left + window.scrollX) + 'px'; // ele0m의 좌측 정렬

            elem.setAttribute("mode","on");
            // list를 펼치고 이벤트 끝내는 부분
            event.stopPropagation();
        } else {
            optionList.style.display = 'none';
            elem.setAttribute("mode","off");
        }

        selectedUserId = pUserID;
        selectedUserDeptId = pDeptID;
    }
    
    function MemberInfo_onclick() {

        OrganBtnListHidden();

        if (typeof UserLevel != "undefined" && (UserLevel == "0" || UserLevel == "9")) {
            alert("<spring:message code='ezCommunity.t431' />");
            return;
        }
        
        var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
        feature = feature + GetOpenPosition(420, 450);
        window.open("/ezCommon/showPersonInfo.do?id=" + selectedUserId + "&dept=" + selectedUserDeptId, "", feature);
    }

    function PostsView_onclick() {
        OrganBtnListHidden();
        
        document.getElementById("searchWord").value = selectedUserId;
        document.getElementById("searchType").value = "writerInfo";
        document.getElementById("postsViewFlag").value = "Y";
        if (document.getElementById("pageNum") != null) {
            document.getElementById("pageNum").value = 1;  
        }
        if (document.getElementById("sortBy") != null) {
            document.getElementById("sortBy").value = "";
        }
        document.getElementById("totalSearchForm").submit();
    }

    function OrganBtnListHidden() {
        var list = document.getElementsByClassName('newSelectView');

        for (var i = 0; i < list.length; i++) {
            var btnObj = list[i];

            if (btnObj.getAttribute('mode') == 'on') {
                document.getElementsByClassName('user_option_horizontal_list').item(0).style.display = 'none';
                btnObj.setAttribute("mode","off");
            }
        }
    }
    
</script>
</html>