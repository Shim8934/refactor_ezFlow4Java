<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			<%-- 2018-07-20 홍승비 - 예약게시물 헤더 스타일 등 수정 --%>
			#chk, #HeaderAllCheckBox {
				margin: 0px;
				padding: 0px;
				width: 13px;
				height: 13px;
			}
			#chk {
				vertical-align:middle;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script>
			var pOrgBoardParameters = "<c:out value='${orgBoardParameters}'/>";
			var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.displayName}";
			var CurPage = "<c:out value='${page}'/>";
			var totalPage = "<c:out value='${totalPage}'/>";
			var strListInfo = "";
			var pSortBy = "<c:out value='${sortBy}'/>";
		    var pTotalCnt = "<c:out value='${totalCount}'/>";
		    var pUse_Editor = "<c:out value='${useEditor}'/>";
		    var pAdminType = "<c:out value='${adminType}'/>";
		    var useRunTime = "<c:out value='${useRunTime}'/>";
	        // 2024-10-04 조수빈 - 마이게시판, 게시물 승인 화면의 경우 게시판 id가 없어 오류가 발생하여 추가
        	var pBoardID = "";
        	var Read_FG = 'true';
		    window.onload = function ()
		    {
		    	if (useRunTime != "YES") {
		    		$("#runtime").css("display", "none");
		    	}
		    	var height = parseInt(document.documentElement.clientHeight - 200);
	            document.getElementById("divList").style.height = height + "px";
		    	makePageSelPageBrd();
		    };
		    
		    window.onresize = function () {
	            var height = parseInt(document.documentElement.clientHeight - 200);
	            document.getElementById("divList").style.height = height + "px";
	            // 예약게시물은 Preview.js 사용하지 않으므로, 스크립트 주석처리함
	            // Window_resize();
	        };
	        
		    function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID) {
		        var feature = GetOpenWindowfeature(765, 820);
	            window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pItemBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify" + "&reservedItem=true", "", feature, "");
		    }
		
		    function checkBox_checked(pBoardID, pItemID, evt) {
		        if (CrossYN()) {
		            if (evt.currentTarget.checked) {
		                strListInfo += pBoardID + "@" + pItemID + "," + SSUserID + ";";
					} else {
		                strListInfo = ReplaceText(strListInfo, pBoardID + "@" + pItemID + "," + SSUserID + ";", "");
					}
		        }
		        else {
		            if (window.event.srcElement.checked) {
		                strListInfo += pBoardID + "@" + pItemID + "," + SSUserID + ";";
		            } else {
		                strListInfo = ReplaceText(strListInfo, pBoardID + "@" + pItemID + "," + SSUserID + ";", "");
		            }
		        }
		    }
		    
		    function checkBox_checkAll() {
		        var i = 0;
		        var checkObj = document.getElementsByName("chk");
		        
		        for (i = 1; i < document.frmOutbox.length; i++) {
		            if (document.frmOutbox[i].type == 'checkbox') {
		                if (document.frmOutbox.checkbox.checked) {
		                    document.frmOutbox[i].checked = true;
		                    strListInfo = document.getElementById("ListInfo").innerHTML;
		                } else {
		                    document.frmOutbox[i].checked = false;
		                    strListInfo = "";
		                }
		            }
		        }
		    }
		    function DeleteItem_onclick() {
		        if (strListInfo == "") {
		            alert("<spring:message code='ezBoard.t195'/>");
		            return;
		        }
		        var ret = confirm("<spring:message code='ezBoard.t197'/>");
		        if (ret) DeleteItem();
		    }
		    function DeleteItem() {
		        // EzBoardServiceImpl 에서 deleteItem 매서드에서 이미 Split으로 ;로 나눠주고 있음. 그래서 이 형식에 맞춰서
		        //형태를 바꿔주는게 좋음!
		        var strListInfoSplit = strListInfo.split(";");
		        var boardList = "";
		        strListInfoSplit = strListInfoSplit.filter(Boolean);
		        
		        for (var i = 0; i < strListInfoSplit.length; i++) {
		        	var boardId = strListInfoSplit[i].split("@")[0];
		        	
		        	if (boardList.indexOf(boardId) == -1) {
		        		boardList += boardId + ";";
		        	}
		        }
		    	
		        var boardArrayList = boardList.split(";");
		        boardArrayList = boardArrayList.filter(Boolean);
		        
	        	var xmlhttp = createXMLHttpRequest();
		        
		        for (var i = 0; i < boardArrayList.length; i++) {
		        	var itemList = "";
					
		        	for (var j = 0; j < strListInfoSplit.length; j++) {
						if (boardArrayList[i] === strListInfoSplit[j].split("@")[0]) {
							itemList += strListInfoSplit[j].split("@")[1] + ";";
						}
			        }
		        	
					/* console.log("boardArrayList[" + i + "] = " + boardArrayList[i]);
					console.log("itemList = " + itemList); */
					
					xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(boardId) + "&itemList=" + encodeURIComponent(itemList), false);
		        	xmlhttp.send();
			        if (xmlhttp.responseText == "NO") {
			            alert("<spring:message code='ezBoard.t265'/>");
			            return;
			        } else if (xmlhttp.responseText == "ERROR") {
		                alert("<spring:message code='ezBoard.t1020'/>");
		                return;
		            }
		        }
		        
		        xmlhttp = null;
		        
		        try {
			        leftCountRf();
				} catch (e) {
				}
		        window.location.reload();
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function refresh_onclick() {
		        window.location.reload(false);
		    }
		    function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
		            window.location.href = "/ezBoard/boardReservedItemList.do?page=" + newPage.toString() + "&sortBy=" + pSortBy + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		        }
		    }
		    function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
		            window.location.href = "/ezBoard/boardReservedItemList.do?page=" + newPage.toString() + "&sortBy=" + pSortBy + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		        }
		    }
		    function moveToPage(evt) {
		        if (CrossYN()) {
		            if (evt.which == 13) {
		                var newPage = txt_PageInputNum.value;
		                if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		                    window.location.href = "/ezBoard/boardReservedItemList.do?page=" + parseInt(newPage.toString()) + "&sortBy=" + pSortBy + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		                }
		            }
		        }
		        else {
		            if (window.event.keyCode == 13) {
		                var newPage = txt_PageInputNum.value;
		                if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		                    window.location.href = "/ezBoard/boardReservedItemList.do?page=" + parseInt(newPage.toString()) + "&sortBy=" + pSortBy + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		                }
		            }
		        }
		    }
		    function SortPage(SortBy) {
		        window.location.href = "/ezBoard/boardReservedItemList.do?page=" + CurPage + "&sortBy=" + SortBy + "&boardType=" + "${boardType}" + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		    }
		    function BoardItemList() {
		        if ("${boardType}" == "0" || "${boardType}" == "1" || "${boardType}" == "2") {
		            window.location.href = "/ezBoard/boardItemList.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        } else if ("${boardType}" == "3") {
		            window.location.href = "/ezBoard/BoardItemListPhoto.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        } else if ("${boardType}" == "4") {
		              window.location.href = "/ezBoard/boardItemListThumbnail.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        } else if ("${boardType}" == "N") {
		            window.location.href = "/ezBoard/boardItemList_new.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        } else {
		            window.location.href = "/ezBoard/boardItemList.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        }
		    }
		
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		
		    function goToPageByNum(Value) {
		        CurPage = Value;
		        makePageSelPageBrd();
		        movePage(CurPage);
		    }
		    function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
		        else
		            return;
		    }
		    function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }
		
		    function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		
		    function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		
		    function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		
		    function getBoardList() {
		        window.location.href = "/ezBoard/boardReservedItemList.do?orgBoardParameters=" + escape(pOrgBoardParameters) + "&page=" + CurPage + "&sortBy=" + pSortBy;
		    }
		
		    function ReplaceString(pOrgString) {
		        return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&amp;", "&"), "&lt;", "<"), "&gt;", ">");
		    }
		    
		    function downloadBoardFile(boardID, itemID, downURL) {
		    	
		        if (Read_FG != "true") {
		        	alert(strLang175);
		            return;
		        }
		        
		    	window.location = downURL;
		    }

		    function selectToDownloadFiles(boardID, itemID) {
		    	
		    	if (Read_FG != "true") {
		    		alert(strLang175);
		    		return;
		    	}
		        
		    	var url = "/ezBoard/selectToDownloadFiles.do?boardID=" + javaURLEncode(boardID) + "&itemID=" + javaURLEncode(itemID);
		        window.open(url, "", "status=no,help=no,width=580px,height=480px" + GetOpenPosition(580, 480));
		    }
		</script>
	</head>
	<c:choose>
		<c:when test="${adminType != 'y'}">
			<body class="mainbody">
			<h1>${boardName}<span id="mailBoxInfo"></span></h1>
		</c:when>
		<c:otherwise>
		    <script type="text/javascript">
		        parent.document.getElementsByTagName("h1")[0].innerHTML = "${boardName}" + "<span id='mailBoxInfo'></span>";
		    </script>
		    <br />
		</c:otherwise>
	</c:choose>
	<c:choose>
		<c:when test="${isVpn != 1}">
			<div id="mainmenu">
			  <ul>
			    <li><span class="icon16 icon16_delete" onClick="DeleteItem_onclick()"></span></li>
			    <li><span class="icon16 icon16_refresh" onClick="refresh_onclick()"></span></li>
			    	<c:if test="${orgBoardParameters != ''}">
					    <li><span onClick="BoardItemList()"><spring:message code='ezBoard.t206'/></span></li>
			    	</c:if>
			  </ul>
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
		</c:when>
		<c:otherwise>
			<table border="0" cellspacing="0" cellpadding="0" class="micon">
			  <tr>
			    <td><span onClick="DeleteItem_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezBoard.t89'/></span></td>
			    <td><span  onclick="refresh_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezBoard.t205'/></span></td>
			    <td><span style="cursor:pointer" onClick="BoardItemList()" class="ic"><spring:message code='ezBoard.t206'/></span></td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
		</c:otherwise>
	</c:choose>
	 <div style="width:100%; overflow:AUTO;" id="divList">
	<table class="mainlist" style ="width:100%; min-width: 640px;">
	  <form name="frmOutbox" action="/ezBoard/boardReservedItemList.do" method="post">
	    <tr>
	      <th width="20px"><div class="custom_checkbox"><input type='checkbox' id="HeaderAllCheckBox" name="checkbox" onclick='checkBox_checkAll()'></div></th>
	      <c:choose>
	      	<c:when test="${sortBy == 'A.Attachments'}">
		      <th style="cursor:pointer;text-align:center;" width="20px" onClick="SortPage('A.Attachments desc')"><img src="/images/newAttach.gif"><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'A.Attachments desc'}">
		      <th style="cursor:pointer;text-align:center;" width="20px" onClick="SortPage('A.Attachments')"><img src="/images/newAttach.gif"><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer;text-align:center;" width="20px" onClick="SortPage('A.Attachments')"><img src="/images/newAttach.gif"></th>
	      	</c:otherwise>
	      </c:choose>
	      <c:choose>
	      	<c:when test="${sortBy == 'B.BoardName'}">
		      <th style="cursor:pointer" width="100px" onClick="SortPage('B.BoardName desc')"><spring:message code='ezBoard.t142'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'B.BoardName desc'}">
		      <th style="cursor:pointer" width="100px" onClick="SortPage('B.BoardName')"><spring:message code='ezBoard.t142'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer" width="100px" onClick="SortPage('B.BoardName')"><spring:message code='ezBoard.t142'/></th>
	      	</c:otherwise>
	      </c:choose>    
	      <c:choose>
	      	<c:when test="${sortBy == 'A.Title'}">
		      <th style="cursor:pointer;width:50%;" onClick="SortPage('A.Title desc')"><spring:message code='ezBoard.t208'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'A.Title desc'}">
		      <th style="cursor:pointer;width:50%;" onClick="SortPage('A.Title')"><spring:message code='ezBoard.t208'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer;width:50%;" onClick="SortPage('A.Title')"><spring:message code='ezBoard.t208'/></th>
	      	</c:otherwise>
	      </c:choose>    
	      <c:choose>
	      	<c:when test="${sortBy == 'A.StartDate'}">
		      <th style="cursor:pointer" width="120px" onClick="SortPage('A.StartDate desc')"><spring:message code='ezBoard.t342'/>
		        <spring:message code='ezBoard.t343'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'A.StartDate desc'}">
		      <th style="cursor:pointer" width="120px" onClick="SortPage('A.StartDate')"><spring:message code='ezBoard.t344'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer" width="120px" onClick="SortPage('A.StartDate')"><spring:message code='ezBoard.t344'/></th>
	      	</c:otherwise>
	      </c:choose>    
	      <c:choose>
	      	<c:when test="${sortBy == 'A.EndDate'}">
		      <th style="cursor:pointer" width="80px" onClick="SortPage('A.EndDate desc')"><spring:message code='ezBoard.t342'/>
		        <spring:message code='ezBoard.t345'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'A.EndDate desc'}">
		      <th style="cursor:pointer" width="80px" onClick="SortPage('A.EndDate')"><spring:message code='ezBoard.t346'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer" width="80px" onClick="SortPage('A.EndDate')"><spring:message code='ezBoard.t346'/></th>
	      	</c:otherwise>
	      </c:choose>
	    </tr>
	    <c:set var="count" value="${totalCount}" />
	    <c:if test="${count eq 0 }" >
	    <tr>
	    <td align="center" colspan="6">
	    <spring:message code='ezBoard.t281'/>
	    </td>
	    </tr>
	    </c:if>
	    <c:set var="ListInfo"/>
	    <c:forEach var="reservedList" items="${reservedList}" varStatus="status">
	    	<tr>
		    	<td <c:if test="${status.first}">style="height:23px;"</c:if>><div class="custom_checkbox"><input type='checkbox' name='chk' id='chk' onclick='checkBox_checked("${reservedList.boardID}", "${reservedList.itemID}", event)'></div></td>
		    	<c:choose>
		    		<c:when test="${reservedList.attachments != '0'}">
		    			<td style="text-align:center;">
				    	<c:choose>
				    		<c:when test="${!fn:contains(reservedList.fileName, 'MANY')}">
				    	    <c:url value="/ezBoard/boardAttachDown.do" var="url">
				    	    	<c:param name="filePath" value="${reservedList.filePath}"/>
				    	    	<c:param name="fileName" value="${reservedList.fileName}"/>
			    	    	</c:url>
						        <a href="${url}">
						        <c:choose>
					    		<c:when test="${fn:contains(reservedList.fileName, '.jpg') || fn:contains(reservedList.fileName, '.jpeg') || fn:contains(reservedList.fileName, '.bmp') || fn:contains(reservedList.fileName, '.gif') || fn:contains(reservedList.fileName, '.png') || fn:contains(reservedList.fileName, '.tif') || fn:contains(reservedList.fileName, '.tiff')}">
							        <img src='/images/image.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:when>
					    		<c:when test="${fn:contains(reservedList.fileName, '.doc') || fn:contains(reservedList.fileName, '.docx')}">
							        <img src='/images/doc.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:when>
					    		<c:when test="${fn:contains(reservedList.fileName, '.xls') || fn:contains(reservedList.fileName, '.xlsx')}">
							        <img src='/images/xls.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:when>
					    		<c:when test="${fn:contains(reservedList.fileName, '.ppt') || fn:contains(reservedList.fileName, '.pptx')  || fn:contains(reservedList.fileName, '.pps') || fn:contains(reservedList.fileName, '.ppsx')}">
							        <img src='/images/ppt.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:when>
					    		<c:when test="${fn:contains(reservedList.fileName, '.txt')}">
							        <img src='/images/txt.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:when>
					    		<c:when test="${fn:contains(reservedList.fileName, '.zip')}">
							        <img src='/images/zip.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:when>
					    		<c:when test="${fn:contains(reservedList.fileName, '.pdf')}">
							        <img src='/images/pdf.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:when>
								<c:when test="${fn:contains(reservedList.fileName, '.hwp')}">
									<img src='/images/hwp.svg' style='width:20px; height:20px; vertical-align:middle;'>
								</c:when>
					    		<c:when test="${fn:contains(reservedList.fileName, '.ecm')}">
							        <img src='/images/ecm.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:when>
					    		<c:otherwise>
							        <img src='/images/etc.svg' style='width:20px; height:20px; vertical-align:middle;'>
					    		</c:otherwise>
					    	    </c:choose>
					    	    </a>
				    	    </c:when>
				    	    <c:otherwise>
				    	    	<img src='/images/disk.svg' style='cursor:pointer;width:20px; height:20px; vertical-align:middle;' onclick="selectToDownloadFiles('<c:out value="${reservedList.boardID}"/>', '<c:out value="${reservedList.itemID}"/>')">
				    	    </c:otherwise>
				    	</c:choose>
		    			</td>
		    		</c:when>
		    		<c:otherwise>
		    			<td></td>
		    		</c:otherwise>
		    	</c:choose>
		    	<td>${reservedList.boardName}</td>
		    	<td title="${fn:replace(reservedList.ABSTRACT, '\'', '`') }" style='cursor:pointer;white-space: nowrap; text-overflow:ellipsis; overflow:hidden' onclick="ItemRead_onclick('${reservedList.boardID}', '${reservedList.boardName}', '${reservedList.itemID}')">${reservedList.title}</td>
		    	<td>${fn:substring(reservedList.startDate, 0, 16)}</td>
		    	<c:choose> 
		    		<c:when test="${fn:substring(reservedList.endDate, 0, 4) == '9999'}">
		    			<td><spring:message code='ezBoard.t287'/></td>
		    		</c:when>
		    		<c:otherwise>
		    			<td>${fn:split(reservedList.endDate , ' ')[0]}</td>
		    		</c:otherwise>
		    	</c:choose>
	    	</tr>
<%-- 	    	<c:set target="${ListInfo}">${ListInfo} + ${reservedList.itemID} + "," + ${userInfo.id} + ";"}</c:set> --%>
	    </c:forEach>
	  </form>
	</table>
	</div>
	<br />
	<div id="tblPageRayer" style="text-align:center"></div>
	<div id="ListInfo" style="display:none">${listInfo }</div>
	</body>
</html>