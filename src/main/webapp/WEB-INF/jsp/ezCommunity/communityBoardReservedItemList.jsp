<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${boardName }</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" type="text/css" href="/css/community.css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<style type="text/css"> 
	        .pagetd{padding-top:6px; }
	        .pcol{padding-top:6px; }
	        .Right_Point01 {
		        font:bold;
		        color:#017bec;
	        }
        </style>
        
        <script type="text/javascript">
	        var pOrgBoardParameters = "${pOrgBoardParameters}";
			var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.displayName1}";
			var CurPage = "${pPage}";
			var totalPage = "${totalPage}";
			var strListInfo = "";
			var pSortBy = "${pSortBy}";
			var totalCount = "${totalCount}";
// 			var pUse_Editor = "${ Use_Editor }";
			
			$(function () {
    			var xmldoc = loadXMLString('${strXML}');
    			var listXML = '';
    			
    			for (i = 0; i < SelectNodes(xmldoc,"NODES/NODE").length; i++) {
    				var bTag = '';
					var strSpace = '';
					
					listXML += "<TR>";
					listXML += "<TD align=center style=\"padding:0;width:20px;\"><input type='checkbox' name='chk' id='chk' onclick='checkBox_checked(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID") + "\",event)'></TD>";
					listXML += "<TD>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardName") + "</TD>";
					listXML += "<TD title='" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").replace("'", "`") + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick='ItemRead_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardID") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardName") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID") + "\")'><nobr>" + bTag + strSpace + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Title") + "</nobr></TD>";
					listXML += "<TD>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "StartDate") + "</TD>";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "EndDate").trim().split('-')[0] == "9999") {
						listXML += "<TD>" + "<spring:message code = 'ezCommunity.t930' />" + "</TD>";
					} else {
						listXML += "<TD>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "EndDate").trim().split(' ')[0] + "</TD>";
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Attachments").trim() != "0") {
						listXML += "<TD align=center><img src='/images/i_save01.gif'></TD>";
					} else {
						listXML += "<TD></TD>";
					}
					
					listXML += "</TR>";
					
					ListInfo += SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "," + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + ";";
    			}
    			
//     			$('#tblList tbody:first').append(listXML);
    			$('#tblList').html($('#tblList').html()+listXML);
    			makePageSelPage();
    		});
			
			
			function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID) {
				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 720) / 2;
				var pLeft = (pwidth - 765) / 2;
				
			    window.open("/ezCommunity/newBoardItem.do?boardID=" + pItemBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=true", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
			}

			function checkBox_checked(pItemID, e) {
			    if (e.target.checked) {
			    	strListInfo += pItemID + "," + SSUserID + ";";	
			    } else {
			    	strListInfo = ReplaceText(strListInfo, pItemID + "," + SSUserID + ";", "");
			    }
			}
			
			function checkBox_checkAll() {
    			var i=0;
    			
    			for(i=0;i<$("input[name='chk']").length;i++) {
    				if($("input[name='chk']")[i].type == 'checkbox') {
    					if($("input[name='checkbox']")[0].checked) {
    					$("input[name='chk']")[i].checked = true;
                            strListInfo = ListInfo;
                        } else {
                        	$("input[name='chk']")[i].checked = false;
    						strListInfo = "";
    					}				
    				}
    			}
    		}
			
			function DeleteItem_onclick() {	
				if(strListInfo == "") {
					alert("<spring:message code = 'ezCommunity.t424'/>");
					return;
				}

				if(confirm("<spring:message code = 'ezCommunity.t426'/>"))	{
					DeleteItem();	
				}
			}

			function DeleteItem() {
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + strListInfo, false);
				xmlhttp.send();
				xmlhttp = null;
				window.location.reload();
			}
			
			function ReplaceText( orgStr, findStr, replaceStr ) {
				var re = new RegExp( findStr, "gi" );
				return ( orgStr.replace( re, replaceStr ) );
			}

			function refresh_onclick() {
				window.location.reload(false);
			}

			var BlockSize = 10;
			function td_Create1(strtext) {
			    document.getElementById("tblPageRayer").innerHTML = strtext; 
			}
			
			function makePageSelPage() {
			    var strtext;
			    var PagingHTML = "";
			    document.getElementById("tblPageRayer").innerHTML = "";
			    document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang82 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang83 + "]";
			    strtext = "<div class='pagenavi'>";
			    PagingHTML += strtext;
			    var pageNum = CurPage;
			    
			    if (totalPage > 1 && pageNum != 1) {
			        strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
			        PagingHTML += strtext;
			    } else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
			        PagingHTML += strtext;
			    }
			    
			    if (totalPage > BlockSize) {
			        if (pageNum > BlockSize) {
			            strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
			            PagingHTML += strtext;
			        } else {
			            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
			            PagingHTML += strtext;
			        }
			    } else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
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
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
			            strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        } else {
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
			            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			    } else {
			        strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
			        strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    
			    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
			        strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    } else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    
			    PagingHTML += "</div>";
			    td_Create1(PagingHTML);
			}
			
			function goToPageByNum(Value) {
			    CurPage = Value;
			    makePageSelPage();
			    movePage(CurPage);
			}
			
			function selbeforeBlock() {
			    var pageNum = parseInt(CurPage);
			    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
			    goToPageByNum(pageNum);
			}
			
			function selbeforeBlock_one() {
			    var pageNum = parseInt(CurPage);
			    if (parseInt(pageNum - 1) > 0) {
			    	goToPageByNum(parseInt(pageNum - 1));
			    } else {
			    	return;
			    }
			}
			
			function selafterBlock() {
			    var pageNum = parseInt(CurPage);
			    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
			    goToPageByNum(pageNum);
			}
			
			function selafterBlock_one() {
			    var pageNum = parseInt(CurPage);
			    
			    if (parseInt(pageNum + 1) <= totalPage) {
			        goToPageByNum(parseInt(pageNum + 1));
			    } else {
			        return;
			    }
			}
			
			function movePage(newPage) {
			    if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
			        window.location.href = "/ezCommunity/boardReservedItemList.do?page=" + newPage.toString() + "&sortBy=" + pSortBy + "&orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
			    }
			}

			function prevPage_onclick() {
				newPage = parseInt(CurPage) - 1;
				
				if(newPage > 0) {
					window.location.href = "/ezCommunity/boardReservedItemList.do?page=" + newPage.toString() + "&sortBy=" + pSortBy + "&orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				}
			}

			function nextPage_onclick() {
				newPage = parseInt(CurPage) + 1;
				
				if(newPage <= parseInt(totalPage)) {
					window.location.href = "/ezCommunity/boardReservedItemList.do?page=" + newPage.toString() + "&sortBy=" + pSortBy + "&orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				}
			}

			function moveToPage() {
				if(window.event.keyCode == 13) {
					var newPage = txt_PageInputNum.value;
					
					if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
						window.location.href = "/ezCommunity/boardReservedItemList.do?page=" + newPage.toString() + "&sortBy=" + pSortBy + "&orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
					}
				}
			}
			
			function SortPage(SortBy) {
				window.location.href = "/ezCommunity/boardReservedItemList.do?page=" + CurPage + "&sortBy=" + SortBy + "&orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
			}

			function BoardItemList() {
				window.location.href = "/ezCommunity/boardItemList.do?" + pOrgBoardParameters;
			}
        </script>
	</head>
	
	<body class = "cmhome_body">
		<h1 class="type1_h1">${boardName}<span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
			    <li><span onClick="DeleteItem_onclick()"><spring:message code='ezCommunity.t208' /></span></li>
			    <li><span onClick="refresh_onclick()"><spring:message code='ezCommunity.t912' /></span></li>
			    <li><span onClick="BoardItemList()"><spring:message code='ezCommunity.t987' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="mainlist" id ="tblList" style="margin-top:3px;width:100%">
			<tr>
				<th align="center" style="padding:0;width:20px;"><input type='checkbox' name="checkbox" onclick='checkBox_checkAll()'></th>
				<c:choose>
					<c:when test="${pSortBy == 'BoardName'}">
						<th style="cursor:pointer"  width="80" onClick="SortPage('BoardName desc')" ><spring:message code='ezCommunity.t418' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
					</c:when>
					<c:when test="${pSortBy == 'BoardName desc'}">
						<th style="cursor:pointer"  width="80" onClick="SortPage('BoardName')"><spring:message code='ezCommunity.t418' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					</c:when>
					<c:otherwise>
						<th style="cursor:pointer"  width="80" onClick="SortPage('BoardName')"><spring:message code='ezCommunity.t418' /></th>
					</c:otherwise>
				</c:choose>
  					
				<c:choose>
					<c:when test="${pSortBy == 'A.Title'}">
						<th style="cursor:pointer"  onClick="SortPage('A.Title desc')" width="170"><spring:message code='ezCommunity.t124' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
					</c:when>
					<c:when test="${pSortBy == 'A.Title desc'}">
						<th style="cursor:pointer"  onClick="SortPage('A.Title')" width="170"><spring:message code='ezCommunity.t124' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					</c:when>
					<c:otherwise>
						<th style="cursor:pointer"  onClick="SortPage('A.Title')" width="170"><spring:message code='ezCommunity.t124' /></th>
					</c:otherwise>
				</c:choose>
					
				<c:choose>
					<c:when test="${pSortBy == 'A.StartDate'}">
						<th style="cursor:pointer"  onClick="SortPage('A.StartDate desc')" width="100"><spring:message code='ezCommunity.t989' /><spring:message code='ezCommunity.t990' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
					</c:when>
					<c:when test="${pSortBy == 'A.StartDate desc'}">
						<th style="cursor:pointer"  onClick="SortPage('A.StartDate')" width="100"><spring:message code='ezCommunity.t991' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					</c:when>
					<c:otherwise>
						<th style="cursor:pointer"  onClick="SortPage('A.StartDate')" width="100"><spring:message code='ezCommunity.t991' /></th>
					</c:otherwise>
				</c:choose>
					
				<c:choose>
					<c:when test="${pSortBy == 'A.EndDate'}">
						<th style="cursor:pointer"  onClick="SortPage('A.EndDate desc')" width="100"><spring:message code='ezCommunity.t989' /><spring:message code='ezCommunity.t992' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
					</c:when>
					<c:when test="${pSortBy == 'A.EndDate desc'}">
						<th style="cursor:pointer"  onClick="SortPage('A.EndDate')" width="100"><spring:message code='ezCommunity.t993' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					</c:when>
					<c:otherwise>
						<th style="cursor:pointer"  onClick="SortPage('A.EndDate')" width="100"><spring:message code='ezCommunity.t993' /></th>
					</c:otherwise>
				</c:choose>
					
				<c:choose>
					<c:when test="${pSortBy == 'A.Attachments'}">
						<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments desc')"><img src="/images/file.gif" width="13" height="12"><img src="/images/view-sortup.gif" width="9" height="9"></th>
					</c:when>
					<c:when test="${pSortBy == 'A.Attachments desc'}">
						<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments')"><img src="/images/file.gif" width="13" height="12"><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					</c:when>
					<c:otherwise>
						<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments')"><img src="/images/file.gif" width="13" height="12"></th>
					</c:otherwise>
				</c:choose>
			</tr>
		</table>
		
		<div id="tblPageRayer"></div>
		<div id="ListInfo" style="DISPLAY:none">${ListInfo}</div>
	</body>
</html>