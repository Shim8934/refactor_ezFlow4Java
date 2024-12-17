<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>원문공개 수정이력</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <style>
        .mainlist tr th {
            border-top: 0px
        }
    </style>
    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>

    <script type="text/javascript">
        var docID;
        var OrderCell = "";
        var RetValue;
        var ReturnFunction;

        $(document).ready(function () {
            try {
                RetValue = parent.modifyOpenGovHistory_cross_dialogArguments[0];
                //                             ReturnFunction = parent.taskhistoryinfo_cross_dialogArguments[1];
            } catch (e) {
                try {
                    RetValue = opener.modifyOpenGovHistory_cross_dialogArguments[0];
                    //                                 ReturnFunction = opener.taskhistoryinfo_cross_dialogArguments[1];
                } catch (e) {
                    RetValue = window.dialogArguments;
                }
            }
            docID = RetValue[0];
            $('#docTitle').text(RetValue[1]);
            $.ajax({
                type: "POST",
                url: "/admin/ezApprovalG/getModifyOpenGovHistory.do",
                async: false,
                data: {
                    docID: docID
                },
                success: function (result) {
                    var RtnVal = loadXMLString(result);
                    var lvAprLineList = new ListView();
                    lvAprLineList.SetID("DocList");
                    lvAprLineList.SetRowOnClick("lvAprLine_SelChange");
                    lvAprLineList.SetMulSelectable(false);
                    lvAprLineList.DataSource(RtnVal);
                    lvAprLineList.DataBind("lvAprLine");
                    lvAprLineList = null;
                    lvAprLine_SelChange();
                }
            });
        });

        function lvAprLine_DBSelChange() {
        }

        function lvAprLine_SelChange() {
            var DocList = new ListView();
            DocList.LoadFromID("DocList");
            var selRow = DocList.GetSelectedRows();
            if (selRow.length != 0) {
                var tr = selRow[0];
                var sn = tr.getAttribute("DATA2");
                $.ajax({
                    type: "GET",
                    url: "/admin/ezApprovalG/getModifyOpenGovHistoryReason.do",
                    async: false,
                    datatype: "text/html",
                    data: {
                        docID: docID,
                        sn: sn
                    },
                    success: function (result) {
                        $('#modifyReason').text(result);
                    }
                });
            }
            else {
                OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
            }
        }
    </script>
</head>
<body class="popup">
    <h1>원문공개 변경이력</h1>
    <div id="close">
        <ul>
            <li><span onClick="window.close()"></span></li>
        </ul>
    </div>
    <h2 id="docTitle"></h2>
    <div class="listview" style="overflow:hidden; width: 655px;">
        <div id="lvAprLine" style="border:0;HEIGHT: 230px; WIDTH: 655px;overflow:auto;"></div>
    </div>
    <h2>변경사유</h2>
    <div style="width: 655px;">
        <textarea id="modifyReason" rows="" cols="" readonly="readonly"
                  style="cursor: default; width: 644px; height:100px;resize:none;"></textarea>
    </div>
</body>
</html>