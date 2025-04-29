<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code='ezSchedule.t4003' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <style>
        #ListBody tr:hover {background-color: #f4f5f5;}
        #ListBody tr td {overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor:pointer;}
    </style>
    <script type="text/javascript">
        var xmlhttp = createXMLHttpRequest();
        var isToggle = false;
        var selectedCompanyID = "";
        var pCurPage       = 1;
        var pTotalPage     = 0;
        var pTotalCnt      = 0;
        var pBlockSize     = 10;
        
        document.onselectstart = function () {
            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
                return false;
            else
                return true;
        };
        
        window.onload = function () {
            var currentYear = new Date().getFullYear();
            windowResize();
            makeSelectBox(currentYear, 'select');
            COMPANY_CHANGE();
        }

        function COMPANY_CHANGE() {
            getCompanyScheduleList();
        }
        
        function getCompanyScheduleList() {
            selectedCompanyID = $("#ListCompany").val();
            var targetYear = $('#ListYear').val();
            var searchTitle = $('#txt_SearchQuery').val();
            
            $.ajax({
                type : "POST",
                dataType : "json",
                url : "/admin/ezSchedule/getCompanyScheduleList.do",
                async : false,
                data : {
                        pageNum     : pCurPage,
                        companyID : selectedCompanyID,
                        targetYear : targetYear,
                        searchTitle : searchTitle
                },
                success : function(data){
                    pCurPage   = data.pageNum;
                    pTotalPage = data.totalPage;
                    pTotalCnt  = data.totalCount;
                    
                    var html = "";
                    
                    if (pTotalCnt < 1) {
                        html += "<tr>";
                        html += "    <td colspan='7' style='text-align:center;'><spring:message code = 'main.t00026' /></td>"
                        html += "</tr>";
                    }
                    else {
                        var itemNum = ((pCurPage - 1) * 10) + 1 ;
                        
                        data.scheduleList.forEach(function(item, index){
                            var escapedTitle = item.title;
                            escapedTitle = escapedTitle.replace(/</g, "&lt;").replace(/>/g, "&gt;");
                        
                            var importance = item.importance;
                            importance = importance == "3" ? "<spring:message code = 'ezSchedule.t327' />" : importance == "2" ? "<spring:message code = 'ezSchedule.t326' />" : "<spring:message code = 'ezSchedule.t325' />";
                                             
                            var primary = data.primary;
                            var creatorName = primary == "1" ? item.creatorName : item.creatorName2 ;
                            
                            html += "<tr repeatcount=" + item.repeatCount + " ondblclick='readSchedule(" + item.scheduleId + ");'>";
                            //html += "   <td ondblclick='stopEventPropagation(event)'><input name='chk_schedule' type='checkbox' scheduleId=" + item.scheduleId + "></td>";
                            html += "   <td title='" + escapedTitle + "'>" + escapedTitle + "</td>";
                            html += "   <td>" + importance + "</td>";
                            html += "   <td>" + (item.startDate).substring(0, 16) + "</td>";
                            html += "   <td>" + (item.endDate).substring(0, 16) + "</td>";
                            html += "   <td>" + item.location + "</td>";
                            html += "   <td>" + creatorName + "</td>";
                            html += "</tr>";
                            itemNum++;
                        });
                        
                    }
                    $("#ListBody").empty().append(html);
                    makePageSelPage();
                    scroll();
                }    
                     
            });
        }
        
        function onkeydown_start_search(e) {
            if (e.keyCode == "13") {
                e.preventDefault();
                getCompanyScheduleList();
            }
        }
        
        //2018-08-06 김보미 - 페이지 위치 고정
        $(window).on("resize", function(){
            windowResize();
        });
        
        function windowResize() {
            document.getElementById("listDiv").style.height = (document.documentElement.clientHeight - 240) + "px"; 
            scroll();
        }
        
        function td_Create1(strtext) {
            document.getElementById("tblPageRayer").innerHTML = strtext;
        }
    
        // 페이지네이션 클릭시
        function goToPage(page) {
            pCurPage = page;
            getCompanyScheduleList();
        }
        
        function makePageSelPage() {
            var strtext;
            var PagingHTML = "";
            document.getElementById("tblPageRayer").innerHTML = "";
            strtext = "<div class='pagenavi'>";
            PagingHTML += strtext;
            var pageNum = pCurPage;

            if (pTotalPage > 1 && pageNum != 1) {
                strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
                PagingHTML += strtext;
            } else {
                strtext = "<span class='btnimg first disabled'></span>"
                PagingHTML += strtext;
            }

            if (pTotalPage > pBlockSize) {
                if (pageNum > pBlockSize) {
                    strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg prev disabled'></span>";
                    PagingHTML += strtext;
                }
            } else {
                strtext = "<span class='btnimg prev disabled'></span>";
                PagingHTML += strtext;
            }

            var MaxNum;
            var i;
            var startNum = (parseInt((pageNum - 1) / pBlockSize) * pBlockSize) + 1;

            if (pTotalPage >= (startNum + parseInt(pBlockSize))) {
                MaxNum = (startNum + parseInt(pBlockSize)) - 1;
            } else {
                MaxNum = pTotalPage;
            }

            for (i = startNum; i <= MaxNum; i++) {
                if (i == pageNum) {
                    strtext = "<span class='on'>" + i + "</span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span onclick='goToPageByNum(" + i + ")'>"
                            + i + "</span>";
                    PagingHTML += strtext;
                }
            }

            if (pTotalPage > pBlockSize) {
                if (pTotalPage >= parseInt(((parseInt((pageNum - 1)
                        / pBlockSize) + 1) * pBlockSize) + 1)) {
                    strtext = "";
                    strtext = strtext
                            + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "";
                    strtext = strtext
                            + "<span class='btnimg next disabled'></span>";
                    PagingHTML += strtext;
                }
            } else {
                strtext = "";
                strtext = strtext
                        + "<span class='btnimg next disabled'></span>";
                PagingHTML += strtext;
            }

            if (pTotalPage > 1 && pTotalPage != 1 && (pTotalPage != pageNum)) {
                strtext = "<span class='btnimg last' onclick='return goToPageByNum("
                        + pTotalPage
                        + ")'></span>";
                PagingHTML += strtext;
            } else {
                strtext = "<span class='btnimg last disabled'></span>";
                PagingHTML += strtext;
            }

            PagingHTML += "</div>";
            td_Create1(PagingHTML);
        }

        function goToPageByNum(Value) {
            pCurPage = Value;
            makePageSelPage();
            goToPage(pCurPage);
        }

        function selbeforeBlock() {
            var pageNum = parseInt(pCurPage);
            pageNum = ((parseInt(pageNum / pBlockSize) - 1) * pBlockSize) + 1;
            goToPageByNum(pageNum);
        }

        function selbeforeBlock_one() {
            var pageNum = parseInt(pCurPage);

            if (parseInt(pageNum - 1) > 0) {
                goToPageByNum(parseInt(pageNum - 1));
            } else {
                return;
            }
        }

        function selafterBlock() {
            var pageNum = parseInt(pCurPage);
            pageNum = ((parseInt((pageNum - 1) / pBlockSize) + 1) * pBlockSize) + 1;
            goToPageByNum(pageNum);
        }

        function selafterBlock_one() {
            var pageNum = parseInt(pCurPage);

            if (parseInt(pageNum + 1) <= pTotalPage) {
                goToPageByNum(parseInt(pageNum + 1));
            } else {
                return;
            }
        }
        
        
        // 특정 양식 엑셀 사용하여 기념일 등록
        function excelUpload() {
            var pheight = window.screen.availHeight;
            var pwidth = window.screen.availWidth;
            var pTop = (pheight - 280) / 2;
            var pLeft = (pwidth - 450) / 2;
            
            var targetCompany = document.getElementById('ListCompany').options[(document.getElementById('ListCompany')).selectedIndex].value;
            var targetYear = $('#ListYear [selected]').text();
            
            window.open("/admin/ezSchedule/scheduleExcelUploadPopup.do?targetYear="+targetYear+"&company="+targetCompany,"", "height = 280px, width = 630px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
        }
        
        //선택한 년도(혹은 현재년도) +- 10년이 표시되는 셀렉트박스
        function makeSelectBox(holidayYear, type) {
            var _html = "";
            if (type != 'select') {
                holidayYear = new Date().getFullYear(); 
            }
            // <option></option>    
            try {
                $('#ListYear').css("display", "");
                for (var j = -10; j < 11; j++) {
                    if (j == 0) {
                        _html += "<option value='"+(parseInt(holidayYear)+j)+"' selected>"+(parseInt(holidayYear)+j)+"</option>";
                    } else {
                        _html += "<option value='"+(parseInt(holidayYear)+j)+"'>"+(parseInt(holidayYear)+j)+"</option>";
                    }
                    
                }
                document.getElementById("ListYear").innerHTML = _html;
            } catch (e) {
                $('#ListYear').css("display", "none");	
                document.getElementById("ListYear").innerHTML = "";
            }
        } 
        
        function readSchedule(scheduleId) {
            var feature = GetOpenPosition(790, 670);
            var ret = "0";
            var readWindow = window.open("/ezSchedule/scheduleRead.do?id=" + encodeURIComponent(scheduleId) + "&pattern=" + ret, "",
                "height = 670px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
        }
        
        function stopEventPropagation(event) {
            event.stopPropagation();
        }
        
        function reset() {
            $(function() {
                $('#txt_SearchQuery').val('');
            });
        }
        
        function RefreshView() {
            getCompanyScheduleList();
        }
    </script>
</head>
<body class="mainbody">
    <h1>
        <spring:message code='ezSchedule.companySc01' />
        <span class="title_bar"><img src="/images/name_bar.gif"></span>
        <select class="companySelect" id="ListCompany" onChange="getCompanyScheduleList()">
            <c:forEach var="item" items="${companyList}">
                <option value="<c:out value='${item.cn}'/>" displayName2="<c:out value='${item.displayName2}'/>"
                        <c:choose>
                            <c:when test="${item.cn == userInfo.companyID}">
                                selected
                            </c:when>
                        </c:choose>>
                    <c:out value='${item.displayName}'/>
                </option>
            </c:forEach>
        </select>
    </h1>
<form id="Form1" method="post">
    <div id="mainmenu">
        <div style="width:800px">
            <ul style="margin-top: 20px;">
                <li class="important"><span onClick="excelUpload()"><spring:message code='ezSchedule.companySc02' /></span></li>
            </ul>
        </div>
    </div>
    
    <div style="margin-bottom:10px;">
        <table style="width: 100%; background-color: #f8f8f8; border-top: 1px solid #e8e8e8; border-bottom: 1px solid #e8e8e8;">
            <tr>
                <th style="background-color: #f1f3f5; height: 26px; border: 1px solid #e2e3e6;">
                    <spring:message code='ezCommunity.t1431' />
                </th>
                <td style=" border: 1px solid #e2e3e6;">
                    <span id="idSpan" class="idSpan">${idSpanValue}</span>
                    &nbsp;
                    <span id="topmenu" style="width: 500px">
                        <spring:message code='ezSchedule.shb16' /> : &nbsp;
                        <select id="ListYear" onchange="getCompanyScheduleList()" style="width:70px; margin-right:10px;"></select>
                    </span>
                    &nbsp;&nbsp;&nbsp;
                    <select id="QuerySelect" name="QuerySelect" style="width:70px; height: 22px;">
                        <option selected value="title">
                            <spring:message code='ezSchedule.t272' />
                        </option>
                    </select>
    
                    <input name="text" type="text" style="WIDTH:200px;  height: 25px;" id="txt_SearchQuery" onkeypress="onkeydown_start_search(event)">
    
                    <a class="imgbtn imgbck" style=" margin-bottom:0px;"><span onClick="getCompanyScheduleList()">
                            <spring:message code='ezCommunity.t31' /></span></a>
                    <a class="imgbtn"><span onclick="javascript:reset();">
                            <spring:message code="ezSystem.x0033"></spring:message>
                        </span></a>
                </td>
            </tr>
        </table>
    </div>
    
    <div id="contentlist" style="width: 100%; overflow: auto; margin-top: 5px;">
        <div id="listDiv">
            <table id="mainList" class="mainlist" style="width: 100%;">
                <thead style="" id="listHeader">
                    <tr>
                        <!--<th style="width: 3%;"><input id="HeaderAllCheckBox" type="checkbox" /></th>-->
                        <th style="width: 37%;"><span><spring:message code='ezSchedule.t272' /></span></th>
                        <th style="width: 5%;"><span><spring:message code='ezSchedule.t310' /></span></th>
                        <th style="width: 15%;"><span><spring:message code='ezSchedule.t274' /></span></th>
                        <th style="width: 15%;"><span><spring:message code='ezSchedule.t275' /></span></th>
                        <th style="width: 10%;"><span><spring:message code='ezSchedule.t273' /></span></th>
                        <th style="width: 15%;"><span><spring:message code='ezSchedule.t161' /></span></th>
                    </tr>
                </thead>
                <tbody id="ListBody" style="overflow:auto;"></tbody>
            </table>
        </div>
    </div>
    
    <div id="tblPageRayer" style="padding-top: 10px;"></div>
</form>
</body>
</html>

