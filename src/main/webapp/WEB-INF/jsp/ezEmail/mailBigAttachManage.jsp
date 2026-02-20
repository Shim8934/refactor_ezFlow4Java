<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
        <title>big_Attach_manage</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css">
        <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
        <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/newMail_Cross.js')}"></script>
        <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/date_component.js')}"></script>
        <script  type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
        <script  type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
        <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
        <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
        <script type="text/javascript">
            var shareId = "${shareId}";
            var m_strColorSelect = "#f1f8ff";
            var m_strColorDefault = "#ffffff";
            var listContentArray =  new Array();
            var curPage = 1; // 현재페이지
            var totalPage = 0;
            var totalCount = 0;
            var BlockSize = 10;
    
            window.onload = function(){
                getBigFileList(curPage);
                makePageSelPage();
                windowResize();
            }
    
    
            var currentPage = 1;
            var itemsPerPage = 5; // 한 페이지에 표시할 파일 수
            var totalItems = 0; // 전체 파일 수
            var bigAttachFileList = []; // 전체 파일 목록
    
            function getBigFileList (pageNum) {
                listContentArray = [];
                var pURL = "/ezEmail/getBigAttachList.do";
    
                var data = {
                    'shareId' : shareId,
                    'prop' : 'uploadDate',
                    'orderBy' : 'DESC',
                    'curPage' :  pageNum,
                    'maxItemPerPage' : 15
                }
    
                $.ajax({
                    url : pURL,
                    type : "POST",
                    async : false,
                    contentType: 'application/json; charset=utf-8',
                    data : JSON.stringify(data),
                    success : function(res) {
                        totalCount = res.totalCount;
                        totalPage = res.totalPage;
                        makePage(res);
                    },
                    error : function(err) {
                        alert(err);
                    }
                });
            }
    
            var p_ListOrderObject;
            var p_ListOrderOption;
            var FirstClick = false;
            function event_HeaderClick(obj) {
                if (p_ListOrderObject != null) {
                    FirstClick = false;
                    if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG")
                        p_ListOrderObject.childNodes.item(1).outerHTML = "";
                }
                else
                    FirstClick = true;
                p_ListOrderObject = obj;
                p_ListOrderOption = p_ListOrderObject.getAttribute("orderoption");
                if (p_ListOrderOption == "DESC")
                    p_ListOrderOption = "ASC";
                else if (p_ListOrderOption == "ASC")
                    p_ListOrderOption = "DESC";
                else
                    p_ListOrderOption = "DESC";
    
                p_ListOrderObject.setAttribute("orderoption", p_ListOrderOption);
    
                if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG") {
                    if (p_ListOrderOption == "DESC")
                        p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortdown.gif");
                    else
                        p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortup.gif");
                }
                else {
                    var _HeaderSpanimg = document.createElement("IMG");
                    if (p_ListOrderOption == "DESC")
                        _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
                    else
                        _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");
    
                    _HeaderSpanimg.setAttribute("align", "absmiddle");
                    obj.appendChild(_HeaderSpanimg);
                }
                if (!FirstClick)
                    getBigAttachListByOrder(obj);
            }
    
            function getBigAttachListByOrder(obj) {
                var pURL = "/ezEmail/getBigAttachList.do";
                var prop = obj.getAttribute("prop");
                var orderBy = obj.getAttribute("orderoption");
                curPage = 1;
    
                var data = {
                    'shareId' : shareId,
                    'prop'  : prop,
                    'orderBy' : orderBy,
                    'curPage' :  curPage,
                    'maxItemPerPage' : 15
    
                }
    
                $.ajax({
                    url : pURL,
                    type : "POST",
                    async : false,
                    contentType: 'application/json; charset=utf-8',
                    data : JSON.stringify(data),
                    success : function(res) {
                        makePage(res);
                        makePageSelPage();
                    },error(){
    
                    }
                });
            }
    
            function makePage(res) {
                var html = "";
                document.getElementById('Checkbox1').checked = false;
                if (res.code !== 0) {
                    alert("<spring:message code='ezAttitude.t175' />");
                }
    
                const bigAttachFileList = res.data;
                const bigSizeMailAttachDelDay = res.bigSizeMailAttachDelDay;
    
                if (bigAttachFileList.length < 1) {
                    html += "<tr><td colspan=\"9\" style=\"text-align:center;\">" + strLang360 + "</td></tr>";
                } else {
                    bigAttachFileList.forEach(function(vo, index) {
                        var fileName = vo.fileName;
                        fileName = fileName.replace(/ /g,"_");
    
                        var fileSize = vo.fileSize;
    
                        if (fileSize / 1024 / 1024 / 1024 > 1) {
                            fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 / 1024 * 10)) / 10).toFixed(1) + "GB";
                        }
                        else if (fileSize / 1024 / 1024 > 1) {
                            fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
                        }
                        else if (fileSize / 1024 > 1) {
                            fileSize = parseInt(fileSize / 1024) + "KB";
                        }
                        else {
                            fileSize = fileSize + "B";
                        }

                        const uploadDate = vo.uploadDate;
                        const [year, month, day] = uploadDate.split('-').map(Number);
                        const date = new Date(year, month -1, day); // 로컬기준

                        date.setDate(date.getDate() + bigSizeMailAttachDelDay);
                        const yyyy = date.getFullYear();
                        const mm = String(date.getMonth() +1).padStart(2, '0');
                        const dd = String(date.getDate()).padStart(2, '0');

                        const endDate = yyyy + '-' + mm + '-' + dd;
                        
                        const limitCountFild = vo.limitCount === 0 ? strUnLimit : vo.downloadCount + " / " + vo.limitCount + strDownloadsCount;
                        
                        html += "<tr onclick='single_check_change(this)'>";
                        html += "   <td style='width: 50px; padding-left: 19px; cursor: pointer;'><div class='custom_checkbox'><input type='checkbox' id="+ vo.fileId +" date="+ vo.uploadDate +" tId="+ vo.tenantId +" name="+ fileName +"></div></td>";
                        html += "	<td onclick='downloadOne(this)' style=' white-space: nowrap; overflow: hidden; cursor: pointer; text-overflow: ellipsis;'title=\'" + fileName + "' id="+ vo.fileId +" date="+ vo.uploadDate +" tId="+ vo.tenantId +" name="+ fileName +">"	+ fileName + "</td>";
                        html += "	<td>" + fileSize + "</td>";
                        html += "    <td>" + limitCountFild +"</td>";
                        html += "    <td>" + endDate + " <spring:message code='ezEmail.bigAttach.kdh02' /></td>";
                        html += "	<td>" + vo.uploadDate + "</td>";
                        html += "</tr>";
                    });
    
                }
    
                $('#bigAttachListBody').empty().append(html);
                document.getElementById("totalCount").innerHTML = "<span style='color:#017BEC; padding-left: 8px'>" + totalCount + "</span>";
            }
    
    
            /*function check_change(checkbox) {
    
                var bigAttachListElement = bigAttachListBody.childNodes.item(0);
    
                if (isEmptyBigAttachList(bigAttachListElement)) {
                    return;
                }
    
                // tr 노드들 (메일 리스트의 전체 행)
                var bigAttachNodes = bigAttachListBody.childNodes;
                var bigAttachNode;
                // tr 노드 개수
                var nodeCount = bigAttachNodes.length;
    
                if (checkbox.checked) {
    
                    for (var i = 0; i < nodeCount; i++) {
                        bigAttachNode = bigAttachNodes.item(i);
                        var bigAttachNodeCheckBox = bigAttachNode.childNodes.item(1).childNodes.item(0);
    
                        bigAttachNodeCheckBox.checked = true;
                        bigAttachNode.style.backgroundColor = m_strColorSelect;
                        listContentArray[i] = bigAttachNodeCheckBox.getAttribute('id');
                    }
                } else {
    
                    for (var i = 0; i < nodeCount; i++) {
                        bigAttachNode = bigAttachNodes.item(i);
    
                        bigAttachNode.childNodes.item(1).childNodes.item(0).checked = false;
                        bigAttachNode.style.backgroundColor = m_strColorDefault;
                    }
    
                    listContentArray = [];
                }
            }*/
            function check_change(checkbox) {
                if (!bigAttachListBody.hasChildNodes() || bigAttachListBody.children.length === 0) {
                    return;
                }
            
                const rows = bigAttachListBody.querySelectorAll('tr');
                const checkboxes = bigAttachListBody.querySelectorAll('input[type="checkbox"]');
            
                if (checkbox.checked) {
                    // '전체 선택'이 체크된 경우
                    listContentArray = [];
                    rows.forEach(row => {
                        row.style.backgroundColor = m_strColorSelect;
                    });
            
                    checkboxes.forEach(cb => {
                        cb.checked = true;
                        listContentArray.push(cb.getAttribute('id'));
                    });
            
                } else {
                    // '전체 선택'이 해제된 경우
                    rows.forEach(row => {
                        row.style.backgroundColor = m_strColorDefault;
                    });
            
                    checkboxes.forEach(cb => {
                        cb.checked = false;
                    });
            
                    listContentArray = [];
                }
            }
    
            function isEmptyBigAttachList(bigAttachListElement) {
    
                if (bigAttachListElement === undefined || bigAttachListElement === null) {
                    return true;
                }
    
                if (bigAttachListElement.childElementCount > 1) {
                    return false;
                }
    
                var firstMailNode = bigAttachListElement.childNodes.item(0);
    
                return firstMailNode.childElementCount === 1;
            }
    
            function deleteBigAttach() {
                if (listContentArray.length === 0) {
                    alert("<spring:message code='ezCabinet.t141' />");
                    return;
                }
                if (!confirm("<spring:message code='ezEmail.t668'/>")) {
                    return;
                }
                var pURL = '/ezEmail/deleteBigAttachFile.do';
    
                var deleteBigAttachList = new Array();
    
                for (var deleteBigAttachId of listContentArray) {
    
                    var deleteAttachElement = document.getElementById(deleteBigAttachId);
                    var deleteAttachDate = deleteAttachElement.getAttribute("date");
    
                    var fileid = encodeURIComponent(deleteBigAttachId);
                    var filedate = encodeURIComponent(deleteAttachDate);
    
                    var fileInfoMap = new Map();
                    fileInfoMap.set('fileId', fileid);
                    fileInfoMap.set('fileDate', filedate);
    
                    var fileInfoObj = Object.fromEntries(fileInfoMap);
                    deleteBigAttachList.push(fileInfoObj);
                }
    
                var data = {'deleteBigAttachList':deleteBigAttachList};
    
                $.ajax({
                    url : pURL,
                    type : "POST",
                    async : false,
                    contentType: 'application/json; charset=utf-8',
                    data : JSON.stringify(data),
                    success : function(res) {
    
                        if (res !== "OK") {
                            alert("<spring:message code='ezAttitude.t175' />");
                            return;
                        }
    
                        getBigFileList(1);
    
                    },
                    error : function(err) {
                        alert(err);
                    }
                });
    
            }
    
            /*function single_check_change(bigAttachNode) {
    
                var bigAttachNodeCheckBox = bigAttachNode.childNodes.item(1).childNodes.item(0);
                if (bigAttachNodeCheckBox.checked) {
    
                    bigAttachNodeCheckBox.checked = true;
                    bigAttachNode.style.backgroundColor = m_strColorSelect;
                    listContentArray[listContentArray.length] = bigAttachNodeCheckBox.getAttribute('id');
                } else {
                    var TemplistArray = new Array();
    
                    for (var i = 0; i < listContentArray.length; i++) {
    
                        if (bigAttachNodeCheckBox.getAttribute('id') === listContentArray[i]) {
                            bigAttachNodeCheckBox.checked = false;
                            bigAttachNode.style.backgroundColor = m_strColorDefault;
                        } else {
                            TemplistArray[TemplistArray.length] = listContentArray[i];
                        }
                    }
    
                    listContentArray = TemplistArray;
                }
    
                // 체크 박스 누를때 이벤트 두번 발생하는 현상 수정
                event.stopPropagation();
            }*/
            function single_check_change(bigAttachNode, event) {
                const checkbox = bigAttachNode.querySelector('input[type="checkbox"]');
                if (!checkbox) return; // 체크박스가 없으면 함수 종료
            
                const checkboxId = checkbox.getAttribute('id');
            
                if (checkbox.checked) {
                    bigAttachNode.style.backgroundColor = m_strColorSelect;
                    listContentArray.push(checkboxId);
            
                } else {
                    bigAttachNode.style.backgroundColor = m_strColorDefault;
                    listContentArray = listContentArray.filter(id => id !== checkboxId);
                }

                if (event) {
                    event.stopPropagation();
                }
            }
    
    
            function downloadBigAttach() {
                if (listContentArray.length === 0) {
                    alert("<spring:message code='ezCabinet.t141' />");
                    return;
                }
    
                var pURL = '/ezEmail/downloadAttachCommon.do?';
                var promises = [];
    
                // 파일을 비동기적으로 다운로드하는 내부 함수
                function downloadFile(downLoadAttachId) {
                    return new Promise((resolve, reject) => {
                        var downloadAttachElement = document.getElementById(downLoadAttachId);
                        var downloadAttachDate = downloadAttachElement.getAttribute("date").replaceAll("-", "");
                        var downloadAttachTenentId = downloadAttachElement.getAttribute("tid");
    
                        var fileid = encodeURIComponent(downLoadAttachId);
                        var filedate = encodeURIComponent(downloadAttachDate);
                        var tid = encodeURIComponent(downloadAttachTenentId);
    
                        var _url = pURL + "fileid=" + fileid + "&filedate=" + filedate + "&tid=" + tid;
    
                        // iframe을 사용하여 파일 다운로드
                        var iframe = document.createElement('iframe');
                        iframe.style.display = 'none';
                        iframe.src = _url;
                        document.body.appendChild(iframe);
    
                        // 다운로드 완료 후 iframe 제거
                        iframe.onload = () => {
                            // 서버에서 에러 메시지가 있는 경우 처리
                            try {
                                var responseText = iframe.contentWindow.document.body.innerText;
                                if (responseText) {
                                    reject(responseText); // reject로 에러 처리
                                } else {
                                    resolve(); // 정상 처리
                                }
                            } catch (e) {
                                reject("<spring:message code='ezCommunity.t47'/>");
                            } finally {
                                document.body.removeChild(iframe);
                            }
                        };
    
                        iframe.onerror = () => {
                            document.body.removeChild(iframe);
                            reject(new Error("<spring:message code='ezCommunity.t47'/>"));
                        };
                    });
                }
    
                // 모든 파일 다운로드 요청을 Promise 배열에 추가
                for (var i = 0; i < listContentArray.length; i++) {
                    promises.push(downloadFile(listContentArray[i]));
                }
    
                // 모든 파일 다운로드 후 처리
                Promise.all(promises)
                    .then(() => {
                        getBigFileList(1);
                    })
                    .catch((error) => {
                        alert(error);
                        getBigFileList(1);
                    });
            }
    
            function goToPageByNum(Value) {
                curPage = Value;
                makePageSelPage();
                getBigFileList(curPage);
            }
    
            // 페이징처리
            function td_Create1(strtext) {
                document.getElementById("tblPageRayer").innerHTML = strtext;
            }
    
            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                document.getElementById("tblPageRayer").innerHTML = "";
                document.getElementById("totalCount").innerHTML = "<span style='color:#017BEC; padding-left: 8px'>" + totalCount + "</span>";
                strtext = "<div class='pagenavi'>";
                PagingHTML += strtext;
                var pageNum = curPage;
    
                if (totalPage > 1 && pageNum != 1) {
                    strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg first disabled'></span>"
                    PagingHTML += strtext;
                }
    
                if (totalPage > BlockSize) {
    
                    if (pageNum > BlockSize) {
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
                var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
    
                if (totalPage >= (startNum + parseInt(BlockSize))) {
                    MaxNum = (startNum + parseInt(BlockSize)) - 1;
                } else {
                    MaxNum = totalPage;
                }
    
                for (i = startNum; i <= MaxNum; i++) {
    
                    if (i == pageNum) {
                        strtext = "<span class='on'>" + i + "</span>";
                        PagingHTML += strtext;
                    } else {
                        strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
                        PagingHTML += strtext;
                    }
    
                }
    
                if (totalPage > BlockSize) {
    
                    if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
                        strtext = "";
                        strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
                        PagingHTML += strtext;
                    } else {
                        strtext = "";
                        strtext = strtext + "<span class='btnimg next disabled'></span>";
                        PagingHTML += strtext;
                    }
    
                } else {
                    strtext = "";
                    strtext = strtext + "<span class='btnimg next disabled'></span>";
                    PagingHTML += strtext;
                }
    
                if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
                    strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg last disabled'></span>";
                    PagingHTML += strtext;
                }
    
                PagingHTML += "</div>";
                td_Create1(PagingHTML);
            }
    
            function selbeforeBlock() {
                CurPage = ((parseInt(CurPage / BlockSize) - 1) * BlockSize) + 1;
                goToPageByNum(CurPage);
            }

            function windowResize() {
                var height = document.documentElement.clientHeight - 153;
                if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
                    height = height - 30;
                }
                document.getElementById("MailListRayer").style.height = height + "px";
                document.getElementById("MailListRayer").style.overflow = "auto";
            }

            $(window).on("resize", function(){
                windowResize();
            });

            function downloadOne (obj) {
                const id = obj.getAttribute('id');
                const date = obj.getAttribute('date').replaceAll("-", "");
                const tid = obj.getAttribute('tid');

                var fileid = encodeURIComponent(id);
                var filedate = encodeURIComponent(date);
                var filetid = encodeURIComponent(tid);

                var pURL = '/ezEmail/downloadAttachCommon.do?';
                var _url = pURL + "fileid=" + fileid + "&filedate=" + filedate + "&tid=" + filetid;

                // iframe을 사용하여 파일 다운로드
                var iframe = document.createElement('iframe');
                iframe.style.display = 'none';
                iframe.src = _url;
                document.body.appendChild(iframe);

                // 다운로드 완료 후 iframe 제거
                iframe.onload = () => {
                    // 서버에서 에러 메시지가 있는 경우 처리
                    try {
                        var responseText = iframe.contentWindow.document.body.innerText;
                        if (responseText) {
                            alert(responseText);
                        }
                    } catch (e) {
                        alert("<spring:message code='ezCommunity.t47'/>");
                    } finally {
                        document.body.removeChild(iframe);
                    }
                };
                getBigFileList(1);
            }

            function refreshPage() {
                getBigFileList(1);
            }
            
        </script>
    </head>

    <body style="overflow:hidden; margin-bottom: 0px" id="theBody" class="mainbody">
        <span id="normalblock"> </span>
        <h1><spring:message code="ezEmail.bigAttach.kdh03"/> <span id="totalCount"></span> </h1>
        <div id="mainmenu">
            <ul>
        
                <li class="important"><span onClick="downloadBigAttach()"><spring:message code="ezWebFolder.t161" /></span></li>
                <li onClick="deleteBigAttach()"><span class="icon16 icon16_delete"></span></li>
                <li onClick="refreshPage()"><span class="icon16 icon16_refresh"></span></li>
            </ul>
        </div>

        <span id="MailListRayer" style="border: 0px solid blue; width: 100%; height: 681px; vertical-align: top; overflow: auto; display: inline-block">
            <table  class="mainlist" style="width:100%;table-layout:fixed;" >
                <thead id="mailHeader">
                <tr>
                    <th style="width: 50px; padding: 0px; color: black;padding-left:20px;" align="center" nowrap title><div class='custom_checkbox'><input type="checkbox" onClick="check_change(this)" id="Checkbox1"></div></th>
                    <th style="width:100%;cursor:pointer;overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"  align="left" onclick="event_HeaderClick(this)" prop="fileName" orderoption="ASC"><spring:message code="ezEmail.t556" /></th>
                    <th style="width:63px;cursor:pointer" align="left" valign="center" id="tofromname" onclick="event_HeaderClick(this)" prop="size" orderoption="ASC"><spring:message code="ezEmail.t617" /></th>
                    <th style="width:180px;cursor:pointer" align="left" id="tofromdate" onclick="event_HeaderClick(this)" prop="downloadCount" orderoption="ASC"><spring:message code="ezEmail.bigAttach.kdh04" /></th>
                    <th style="width:190px;cursor:pointer" align="left" prop="endDate" onclick="event_HeaderClick(this)" ><spring:message code="ezEmail.bigAttach.kdh05" /></th>
                    <th style="width:190px;cursor:pointer" align="left" onclick="event_HeaderClick(this)" prop="uploadDate" orderoption="ASC"><spring:message code="ezEmail.bigAttach.kdh06" /></th>
                </tr>
                </thead>
                <tbody id="bigAttachListBody" ></tbody>
            </table>
        </span>
        <div id="tblPageRayer" style="width:100%;"></div>
        
        <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" onclick="ContextMenuHidden();" ></div>
        <div style="width:200px; padding:20px 0; border-radius:8px; text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
            <img src="/images/email/progress_img.gif"/>
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
            <a class="btnposition" id="cancleProgressBtn" style="display: none; padding-top: 10px; width: 50px; height:20px;
                        cursor:pointer; margin:0 auto;" onclick="cancleProgress();">
                <input type="button" value="<spring:message code="ezEmail.t39" />"/></a>
        </div>
        <iframe name="AttachDownFrame" id="AttachDownFrame" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none"></iframe>
        <div style="border:1px solid gray;width:450px;position:absolute;background-color:#ffffff;z-index:8000;text-align:center;display:none;" id="progressviewerRayer">
            <iframe src="<spring:message code='main.kms4' />" style="width:450px;height:170px;border:none" id="progressviewer"></iframe>
        </div>
        <script type="text/javascript">
            selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
        </script>
        <div class="layerpopup"  style="z-index: 10000; position: absolute;display: none;" id="iFramePanel">
            <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
        </div>
    </body>
</html>