<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <script>
        function GetNewsFeedData(num) {
            Array.prototype.forEach.call(document.querySelectorAll("#divSpaceListResults > li"), function (node) {
                node.classList.remove('on');
            });
            document.getElementById("li_" + num).classList.add('on');
        }

        function workspaceChangeTab(id) {
            Array.prototype.forEach.call(document.querySelectorAll(".collaborate_listTab > dt"), function (node) {
                node.classList.remove('on');
            });
            document.getElementById(id).classList.add('on');
            Array.prototype.forEach.call(document.querySelectorAll('.listtype_txt'), function (node) {
                node.style.display = 'none';
            });
            document.getElementById(id + 'Results').style.display = '';
        }

        function GetRedirectUrl() {
            return true;
        }
    </script>
</head>
<body class="body_bg1">
<article class="box_shadow">
    <div class="layDIV">
        <dl class="portlet_title sortablePortlet" style="">
            <dt class="portletText">협업</dt>
            <dd class="portletPlus plus" id="ezWorkspacePlus"></dd>
        </dl>
        <ul class="collaborate_tab" id="divSpaceListResults" style="overflow-y: auto; height: 204px;">
            <li id="li_0" onclick="GetNewsFeedData(0,1)" class="on"><span
                    style="white-space:nowrap; text-overflow:ellipsis; overflow:hidden;" class="icon_me">ME</span></li>
            <li id="li_54" onclick="GetNewsFeedData(54,1)" class=""><span
                    style="white-space:nowrap; text-overflow:ellipsis; overflow:hidden;" class="icon_team">솔루션2팀</span>
            </li>
            <li id="li_105" onclick="GetNewsFeedData(105,1)" class=""><span
                    style="white-space:nowrap; text-overflow:ellipsis; overflow:hidden;" class="icon_team">2020년 ezEKP Java 개선</span>
            </li>
        </ul>
        <div class="collaborate_list">
            <dl class="collaborate_listTab">
                <dt onclick="workspaceChangeTab('newsTab')" id="newsTab" class="on">뉴스피드</dt>
                <dt onclick="workspaceChangeTab('taskTab')" id="taskTab" class="">할일</dt>
                <dt onclick="workspaceChangeTab('documentTab')" id="documentTab" class="">문서</dt>
                <dt onclick="workspaceChangeTab('issueTab')" id="issueTab" class="">이슈</dt>
            </dl>
            <ul class="listtype_txt" id="newsTabResults">
                <li onclick="GetRedirectUrl(13706, 4)">
                    <span class="txt">[문서] 버블.jpg</span>
                    <span class="date">ME</span>
                    <span class="name">박기범</span>
                </li>
                <li onclick="GetRedirectUrl(11246, 2)">
                    <span class="txt">[할일] 모바일 메인화면 개선</span>
                    <span class="date">고려대의료원</span>
                    <span class="name">전일권</span>
                </li>
                <li onclick="GetRedirectUrl(11245, 2)">
                    <span class="txt">[할일] 포탈 테마 추가</span>
                    <span class="date">고려대의료원</span>
                    <span class="name">전일권</span>
                </li>
                <li onclick="GetRedirectUrl(1350, 1)">
                    <span class="txt">[메시지] [공지] 사내 협업시스템 개선 내역</span>
                    <span class="date">ME</span>
                    <span class="name">김재훈</span>
                </li>
            </ul>
            <ul class="listtype_txt" id="taskTabResults" style="display: none">
                <li onclick="GetRedirectUrl(11246, 2)"><span class="date"
                                                             style="text-overflow:ellipsis; overflow:hidden;">고려대의료원</span><span
                        class="name" style="text-overflow:ellipsis; overflow:hidden;">전일권</span><span class="txt"
                                                                                                      style="text-overflow:ellipsis; overflow:hidden;">모바일 메인화면 개선</span>
                </li>
                <li onclick="GetRedirectUrl(11245, 2)"><span class="date"
                                                             style="text-overflow:ellipsis; overflow:hidden;">고려대의료원</span><span
                        class="name" style="text-overflow:ellipsis; overflow:hidden;">전일권</span><span class="txt"
                                                                                                      style="text-overflow:ellipsis; overflow:hidden;">포탈 테마 추가</span>
                </li>
                <li onclick="GetRedirectUrl(8389, 2)"><span class="date"
                                                            style="text-overflow:ellipsis; overflow:hidden;">솔루션2팀</span><span
                        class="name" style="text-overflow:ellipsis; overflow:hidden;">박기범</span><span class="txt"
                                                                                                      style="text-overflow:ellipsis; overflow:hidden;">결재연동 테스트페이지 칼럼변경용 모달 개발</span>
                </li>
                <li onclick="GetRedirectUrl(8387, 2)"><span class="date"
                                                            style="text-overflow:ellipsis; overflow:hidden;">솔루션2팀</span><span
                        class="name" style="text-overflow:ellipsis; overflow:hidden;">박기범</span><span class="txt"
                                                                                                      style="text-overflow:ellipsis; overflow:hidden;">결재연동 통합테스트</span>
                </li>
            </ul>
            <ul class="listtype_txt" id="documentTabResults" style="display: none">
                <li onclick="GetRedirectUrl(13706, 4)"><span class="date"
                                                             style="text-overflow:ellipsis; overflow:hidden;">ME</span><span
                        class="name" style="text-overflow:ellipsis; overflow:hidden;">박기범</span><span class="txt"
                                                                                                      style="text-overflow:ellipsis; overflow:hidden;">버블.jpg</span>
                </li>
            </ul>
            <ul class="listtype_txt" id="issueTabResults" style="display: none">
                <li onclick="GetRedirectUrl(3004, 5)"><span class="date"
                                                            style="text-overflow:ellipsis; overflow:hidden;">솔루션2팀</span><span
                        class="name" style="text-overflow:ellipsis; overflow:hidden;">김종원</span><span class="txt"
                                                                                                      style="text-overflow:ellipsis; overflow:hidden;">이슈처리</span>
                </li>
            </ul>
        </div>
    </div>
</article>
</body>
</html>