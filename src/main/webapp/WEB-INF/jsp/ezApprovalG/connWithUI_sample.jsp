<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css">
<title>UI연동 샘플</title>
</head>
<body class="popup">
    <table class="layout">
        <tr>
            <td>
                <h1>UI연동 샘플</h1>
                <div id="close">
                    <ul>
                        <li>
                            <span id="btn_close"></span>
                        </li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <table class="content">
                </table>
            </td>
        </tr>
    </table>
    <div class="btnpositionNew">
        <a id="btn_ok" class="imgbtn"><span>확인</span></a>
        <a id="btn_cancel" class="imgbtn"><span>취소</span></a>
    </div>

    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_ui.js')}"></script>
    <script type="text/javascript">
        window.onload = function() {
            init(function(paramData) {
                // 초기에 셋팅해줄 내용 작성
                // paramData는 keyData를 의미한다
                var keyDate = loadXMLString(paramData);
            }, function(xmlDom, rootNode) {
                // 리턴하여 문서에 매핑해줄 내용 작성
                // xmlDom은 <RETURNDATA><PARAMETER></PARAMETER></RETURNDATA> 형태고 rootNode는 PARAMETER를 의미함
                // createNodeAndAppandNodeCDataText(xmlDom, rootNode, null, {필드이름}, {필드내용}); 으로 작성하면 됨
            });
        }
    </script>
</body>
</html>