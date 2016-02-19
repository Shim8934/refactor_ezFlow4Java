<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>BoardItemList</title>
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link href="/css/default_kr.css" rel="stylesheet" type="text/css">
		<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ListView_list.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ezBoardSTD.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript" src="/js/NameControl.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var pBoardID = "${boardInfo.boardID}";
		    var SSUserID = "${userInfo.id}";    
		    var CurPage = "${boardInfo.page}";
		    var totalPage = "${boardInfo.totalPage}";
		    var strListInfo = "";
		    var Access_FG = "${boardInfo.access_FG}";
			var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var ListView_FG = "${boardInfo.listView_FG}";
		    var Read_FG = "${boardInfo.read_FG}";
		    var Write_FG = "${boardInfo.write_FG}";
		    var Reply_FG = "${boardInfo.reply_FG}";
		    var Delete_FG = "${boardInfo.delete_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var pSortBy = "${boardInfo.sortBy}";
		    var url = "${boardInfo.url}";
		    var ShowAdjacent = "";
		    var gubun = "${boardInfo.guBun}";
		    var totalCount = "0";
		    var OrderOption = "";
		    var OrderCell = "";
		    var pBoardType = "${boardInfo.boardType}";
		    var USE_OCS = "${use_ocs}";
		    var Use_OneLineCount = "${use_oneLineCount}";
		    var previewType = "";
		    var clickPreviweType = "";
		    var CurrentHeight = 0;
		    var CurrenWidth = 0;
		    var pMailListHeightW = 0;
		    var pMailPreHeightW = 0;
		    var pMailListDiv = 0;
		    var pMailPreVDiv = 0;
		    var pMailListWidthH = 0;
		    var pMailPreWidthH = 0;
		    var pMailListDiv_H = 0;
		    var pMailPreVDiv_H = 0;
		    var p_ListorderValue = "";
		    var pPreviewShow_HOW = "OFF"
		    var onclickFlag = false;
		    var selobj = null;
		    var PreviewH_Move = false;
		    var PreviewW_Move = false;
		    var SmallSizeList = false;
		    var OldSmallSizeList = false;
		    var objMHT;
		    var g_bPrevShow = false;
		    var pMode = "new";
		    var starttime;
		    var endtime;
		    var pAdminType = "y";
		    var pButtonHidden = "${boardInfo.buttonHidden}";
		    var pNoneActiveX = "NO";
	
		    window.onresize = Window_resize;
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        var height = parseInt(document.documentElement.clientHeight - 180);
		        document.getElementById("divList").style.height = height + "px";
		        getBoardList();
		    }
		
		    function getBoardList() {
		        starttime = new Date().getTime();
		    	$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezBoard/getBoardList.do",	        			
					data : { boardType : pBoardType, boardId : pBoardID, pageNum : CurPage, orderCell : OrderCell, orderOption : OrderOption},
					success: function(result){
						getBoardList_after(result);
					}        			
				});	
		    }
		
		    var perCnt = "";
		    var firstFlag = false;
		    var allListCnt = "";
		    function getBoardList_after(result) {
		        try {
		            if (result.length == 0) {
		                if (CurPage > 1) {
		                    CurPage = CurPage - 1;
		                    getBoardList();
		                    return;
		                }
		            }
		            var headerList = result.headerList;
		            pPreviewShow_HOW = result.boardConfigVO.previewType;
		            if (headerList == null) return;

		            var lstCnt = result.boardConfigVO.totalCnt;
		            totalCount = lstCnt;
		            if (perCnt == "")
		                perCnt = result.boardConfigVO.listCount;

		            listcount.value = perCnt;

		            totalPage = Math.ceil(new Number(lstCnt / perCnt));
		            pTotalCnt = lstCnt;

		            makePageSelPage();

		            if (document.getElementById("lvBoardList").innerHTML != "") document.getElementById("lvBoardList").innerHTML = "";
		            
		            var DocList = new ListView();
		            DocList.SetID("BoardList");
		            DocList.SetHeaderOnClick("SortPage");
		            DocList.SetRowOnDblClick("ItemRead_onclick(this)");
		            DocList.SetRowOnClick("ItemPreviewRead_click");
		            DocList.SetTitleIdx(0);
		            DocList.SetSelectFlag(false);
		            DocList.DataSource(headerList);
		            DocList.DataBind("lvBoardList");
		            DocList = null;

		            allListCnt = headerList.length;
		            var tempno = 0;
// 		            for (var i = 0; i < allListCnt; i++) {
// 		                if (CrossYN()) {
// 		                    if (parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim()) > tempno)
// 		                        tempno = parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim());
// 		                }
// 		                else {
// 		                    if (parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim()) > tempno)
// 		                        tempno = parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim());
// 		                }
// 		            }
		            tempno = tempno + "";

		            if (tempno.length > 4) {
		                document.getElementById("BoardList_TH_1").style.width = tempno.length * 3 + 20 + "px";
		            }

		            if ("${use_ocs}" == "YES" && lstCnt > 0) {
		                check_presence();
		            }

		            if (!firstFlag) {
		                if(pButtonHidden == "N")
		                    PreviewRayerChange(pPreviewShow_HOW);
		                else
		                    PreviewRayerChange("NONE");
		                if (CrossYN()) {
		                    if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null)
		                        ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = "<spring:message code='ezBoard.t10022' />";
		                    if (ifrmPreViewW.document.getElementById("ifrmviewEmptyText") != null)
		                        ifrmPreViewW.document.getElementById("ifrmviewEmptyText").textContent = "<spring:message code='ezBoard.t10022' />";
		                } else {
		                    if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null)
		                        ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022' />";
		                    if (ifrmPreViewW.document.getElementById("ifrmviewEmptyText") != null)
		                        ifrmPreViewW.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022' />";
		                }
		                firstFlag = true;
		            }
		            endtime = new Date().getTime();
		            document.getElementById("runtime").innerHTML = "RunTime : <span style='color:black;font-weight:bold'>" + (endtime - starttime) / 1000 + "</span> Sec";
		        }
		        catch (e) {
		            alert("getBoardList_after : " + e.description);
		        }
		    }
		
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        if (pButtonHidden == "y")
		            document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + pTotalCnt + " </span>" + strLang42 + "]";
		        else
		            parent.document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + pTotalCnt + " </span>" + strLang42 + "]";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/Sub/btn_p_prev.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/Sub/btn_p_prev01.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
		        }
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/Sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		            PagingHTML += strtext;
		        }
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        }
		        else {
		            MaxNum = totalPage;
		        }
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/Sub/btn_next.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
		                strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
		            strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/Sub/btn_n_next.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/Sub/btn_n_next01.gif' width='16' height='16'></span>";
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
		    
		    function SortPage(strHeaderName) {
		        if (strHeaderName != "CHECK") {
		            if (OrderCell == strHeaderName) {
		                if (OrderOption == "")
		                    OrderOption = "DESC";
		                else
		                    OrderOption = "";
		            }
		            else {
		                OrderCell = strHeaderName;
		                OrderOption = "";
		            }
		            getBoardList();
		        }
		    }
		
		    function ItemRead_onclick(obj) {
		        if (Read_FG != "true") {
		        	alert("읽기 권한이 없습니다.");
		            return;
		        }
		
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
		
		        if (obj.getAttribute("DATA10") == "3" || obj.getAttribute("DATA10") == "4") {
		                window.open("BoardItemView_Photo.aspx?ShowAdjacent=" + ShowAdjacent + "&ItemID=" + obj.getAttribute("DATA2") + "&BoardID=" + obj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=770,width=765,top=" + pTop + ",left=" + pLeft, "");
		            }           
		            else {
		                if (CrossYN() || pNoneActiveX == "YES")
		                    window.open("BoardItemView_Cross.aspx?ShowAdjacent=" + ShowAdjacent + "&ItemID=" + obj.getAttribute("DATA2") + "&BoardID=" + obj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                else
		                    window.open("BoardItemView.aspx?ShowAdjacent=" + ShowAdjacent + "&ItemID=" + obj.getAttribute("DATA2") + "&BoardID=" + obj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		            }
		        //}
		        //getBoardList();
		    }   
		   
		    function CheckIfHasReplies() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "interASP/CheckIfHasReply.aspx?ItemList=" + strListInfo, false);
		        xmlhttp.send();
		        if (xmlhttp.responseText == "FALSE") {
		            xmlhttp = null;
		            return false;
		        }
		        xmlhttp = null;
		        return true;
		    }
		    function DeleteItem() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "interASP/DeleteItem.aspx?BoardID=" + pBoardID + "&ItemList=" + strListInfo, false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		        	alert("삭제 권한이 없습니다.");
		            return;
		        }
		
		        xmlhttp = null;
		        getBoardList();
		    }
		
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		
		    function CheckOwnerShip() {
		        var arrList = new Array();
		        var i = 0;
		
		        arrList = strListInfo.split(";");
		        for (i = 0; i < arrList.length - 1; i++) {
		            if (arrList[i].split(",")[1].indexOf(SSUserID) == -1) {
		                arrList = null;
		                return false;
		            }
		        }
		        arrList = null;
		        return true;
		    }
		
		    function refresh_onclick() {
		        if (setReadFlag) {
		            if (Number(allListCnt) == Number(SetReadCheckCnt)) {
		                if (CurPage > 1)
		                    CurPage = CurPage - 1;
		            }
		            setReadFlag = false;
		        }
		
		        window.location.href = window.location.href = "New_BoardItemList.aspx?Page=" + CurPage.toString() + "&BoardID=" + pBoardID + "&SortBy=&BoardType=" + pBoardType;
		    }
		    var SetReadCheckCnt = 0;
		    var setReadFlag = false;
		    function SetRead_onclick() {
		        if (Read_FG != "true") {
		            alert("읽기 권한이 없습니다.");
					return;
				}
		        if (strListInfo == "") {
		            alert("게시물을 선택해 주세요.");
					return;
				}
		        var ret = confirm("읽음 표시 하시겠습니까?");
				if (ret) {
				    var arrList = new Array();
				    var strItemList = "";
				    var i = 0;
				    arrList = strListInfo.split(";");
				    for (i = 0; i < arrList.length - 1; i++) {
				        SetReadCheckCnt++;
				        strItemList += arrList[i].split(",")[0] + ";";
				    }
				    arrList = null;
				    var xmlhttp = createXMLHttpRequest();
				    xmlhttp.open("POST", "interASP/SetRead.aspx?BoardID=" + pBoardID + "&ItemIDList=" + strItemList, false);
				    xmlhttp.send();
				    xmlhttp = null;
				    setReadFlag = true;
				    refresh_onclick();
				}
			}
			function MemberInfo_onclick(pUserID) {
				if (gubun == "2") return;
				window.open("/myoffice/common/ShowPersonInfo_cross.aspx?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
			}
			function ReservationItem_onclick() {
			    var OrgBoardParameters = "Page=" + CurPage + "&BoardID=" + pBoardID + "&SortBy=&BoardType=" + pBoardType;	
			    window.location.href = "BoardReservedItemList_Cross.aspx?OrgBoardParameters=" + escape(OrgBoardParameters) + "&BoardType=" + pBoardType;
			}
			
			function window_reload() {
				window.location.href = window.location.href;
			}
		
			function checkBox_checkAll(obj) {
		
			    var SelList = new ListView();
			    SelList.LoadFromID("BoardList");
			    var oArrRows = SelList.GetSelectedRows();
			    if (obj.checked) {
			        for (var i = 0; i < SelList.GetRowCount() ; i++) {
			            SelList.GetDataRows()[i].childNodes[0].childNodes[0].checked = true;
			            strListInfo += SelList.GetDataRows()[i].childNodes[0].childNodes[0].id;
			        }
			    }
			    else {
			        for (var i = 0; i < SelList.GetRowCount() ; i++) {
			            SelList.GetDataRows()[i].childNodes[0].childNodes[0].checked = false;
			            strListInfo = "";
			        }
			    }
			}
		
			function chk_onselect(obj)
			{
			    if (obj.checked) {
			        strListInfo += obj.id;
			    } else {
			        strListInfo = ReplaceText(strListInfo, obj.id, "");
			    }
			    listEventCheckbox = true;
			}
			function check_presence() {
			    var DocList = new ListView();
			    DocList.LoadFromID("BoardList");
			    var TRs = DocList.GetDataRows();
			    var pCNList = new Array();
			    for (var i = 0; i < TRs.length; i++) {
			        pCNList[i] = TRs[i].getAttribute("DATA3");
			    }
		
			    var writeindex;
			    var temp = document.getElementById("lvBoardList").childNodes[0].childNodes[0].childNodes[0].childNodes.length;
			    
			    for (var i = 0; i < temp; i++) {
			        if (document.getElementById("lvBoardList").childNodes[0].childNodes[0].childNodes[0].childNodes[i].getAttribute("writerindex") != null) {
			            writeindex = document.getElementById("lvBoardList").childNodes[0].childNodes[0].childNodes[0].childNodes[i].getAttribute("writerindex");
			            break;
			        }
			    }
		
			    var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
			    pCNList = null;
		
			    for (var i = 0; i < TRs.length; i++) {
			        var TD = TRs[i].childNodes[writeindex];
			        TD.innerHTML = "<div><img style ='vertical-align:middle' src='/images/Presence/unknown.gif' id ='" + GetGUID() + ",type=smtp' onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/><span style='vertical-align:middle;'> " + TD.innerHTML + "</span></div>";
			    }
			    pSIPUriList = null;;
			}
		</script>
		<style type="text/css">
		    .datepicker {
		        BEHAVIOR: url(./controls/datepicker.htc);
		    }
		    .pagetd {
		        padding-top: 6px;
		    }
		
		    .pcol {
		        padding-top: 6px;
		    }
		    .Right_Point01 {
		        font: bold;
		        color: #017bec;
		    }
		    #layer_Viewpopup { 
			z-index:1000; 
			margin:0px; 
			padding:0px;
			}
			#layer_Viewpopup .popupwrap1 {
				border:1px solid #555a64;
				padding:0px;
				margin:0px;
				
			}
			#layer_Viewpopup .shadow {
				height:2px;
				background:#d7d7d7;
				
			}
			#layer_Viewpopup .popupwrap2 {
				border:2px solid #e5e5e5;
				padding:10px;
				
			}
			#layer_Viewpopup .btn_area { border-top:1px solid #e5e5e5; margin:10px 0px 0px 0px; padding:10px 0px 0px;}
			
			#layer_Viewpopup .popupwrap3 {
				position:relative;
				padding:10px;
				background:url("../images/kr/cm/popup_layerbg.gif") repeat-x;
			}
			#layer_Viewpopup .popupwrap3 h1 {
				font-size:13px;margin:0px 0px 10px 0px;height:24px; line-height:15px; padding:0px;color:#fff; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;
			}
		</style>
	</head>
	<body class="" style="overflow:hidden;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
		<c:if test="${boardInfo.listView_FG != true}'">
			<div style="margin-top:100px;text-align:center"><spring:message code="ezBoard.t272" /></div>
		</c:if>
		<c:if test="${boardInfo.buttonHidden == N}">
			<script type="text/javascript">
			    parent.document.getElementsByTagName("h1")[0].innerHTML = "<h1>${boardInfo.boardName}<span id='mailBoxInfo'></span>";
			</script>
			<br />
			<div id="mainmenu">
			  <ul>
			    <li><span onclick="SetRead_onclick()">읽음표시</span></li>
				<li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
			    <li><span onClick="refresh_onclick()">새로고침</span></li>
			    <li><span onClick="ReservationItem_onclick()">예약게시</span></li>  
			    <li id="right">보기설정<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" /></li>      
			  </ul>
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
		</c:if>	
		<c:if test="${boardInfo.buttonHidden != N}">
		    <script type="text/javascript">
		        parent.document.getElementsByTagName("h1")[0].innerHTML = "<h1>${boardInfo.boardName}<span id='mailBoxInfo'></span>";
		    </script>
		    <br />
		</c:if>
		    <div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
		        <div class="popupwrap1">
		            <div class="popupwrap2">
		                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
		                    <caption></caption>
		                    <colgroup>
		                        <col style="width: 80px;">
		                        <col>
		                    </colgroup>
		                     <tr>
		                        <th>리스트 개수</th>
		                        <td>
		                            <select id="listcount" style="WIDTH: 40px; height: 20px;" onchange="ListCount(this.value);">
		                                <option value="10">10</option>
		                                <option value="20">20</option>
		                                <option value="30">30</option>
		                                <option value="40">40</option>
		                                <option value="50">50</option>
		                            </select>    
		                        </td>
		                    </tr>
		                    <tr>
		                        <th>미리보기</th>
		                        <td>
		                            <img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
		                            <img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
		                            <img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')"></td>
		                    </tr>
		                </table>
		            </div>
		        </div>
		        <div class="shadow">
		        </div>
		    </div>
		    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
		    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
		    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
		
		    <span id="MailListRayer" style="border: 0px solid blue; width: 0px; height: 0px; vertical-align: top; overflow: hidden; display: inline-block;">
		        <div style="width:100%; overflow:AUTO;" id="divList">
		            <div id="lvBoardList"></div>
		        </div>
		        <div id='runtime' style="color:#666;padding-top:5px"></div>
		        <div id="tblPageRayer" style="text-align:center"></div>
		    </span>
		
		
		    <span id="PreviewRayerH" style="border:0px solid red; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
		        <span id="previewmail_bar_h" class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block;">
		            <p class="hbar_dotted">
		                <img src="/images/prevview_hbar_dotted.gif">
		            </p>
		        </span>
		        <span id="PreContent_RayerH" style="position: absolute; border: 0px solid blue;">
		            <span style="width: 100%; height: 100px; display: block;">
		                <span class="previewmail_info" style="display: block; width: 100%;">
		                    <div id="Preview_HeaderH" style="border: solid 0px black; width: 100%; display: none;">
		                        <p class="mail_title" style="margin-left: 0px;">
		                            <span class="icon_btn"><span onclick="MailReadOpen();" style="cursor: pointer; padding-right: 5px;">
		                                <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreH_subject"><span id="PreH_sub_subject" class="title_blodtxt"></span></span>
		                        </p>
		                        <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreH_date"><span id="PreH_sub_date" style="display: none;"></span></span></span>
		                        <dl class="mail_item">
		                            <dt>게시자:
		                                <span id="PreH_MailReceiver" style="display: inline-block"></span>
		                            </dt>
		                        </dl>
		                    </div>
		                </span>
		                <iframe id="ifrmPreViewH_photo" name="ifrmPreViewH_photo" src="blank.html" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: none;"></iframe>
		                <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="blank.html" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
		            </span>
		        </span>
		    </span>
		
		
		    <span id="PreviewRayerW" style="border: 0px solid red; width: 100%; height: 300px; overflow: hidden; display: none;">
		        <span onmousedown="PreviewW_onMouserDown(event);" style="cursor: s-resize; width: 100%; display: list-item;" class="previewmail_bar" name="PreviewBar" id="PreviewBar">
		            <img src="/images/prevview_bar_dotted.gif">
		        </span>
		        <span id="PreContent_RayerW" style="display: block;">
		            <span style="width: 100%; height: 100px; display: block;">
		                <span class="previewmail_info" style="display: block; width: 100%;">
		                    <div id="Preview_HeaderW" style="border: solid 0px black; display: none;">
		                        <p class="mail_title">
		                            <span class="icon_btn"><span onclick="MailReadOpen();" style="cursor: pointer; padding-right: 5px;">
		                                <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreW_subject"><span id="PreW_sub_subject"></span></span>
		                        </p>
		                        <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreW_date"><span id="PreW_sub_date"></span></span></span>
		                        <dl class="mail_item">
		                            <dt>게시자:</dt>
		                            <dd><span id="PreW_MailReceiver" style="display: inline-block"></span>
		                            </dd>
		                        </dl>
		                    </div>
		                </span>
		                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="blank.html" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0; display:none;"></iframe>
		                <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="blank.html" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
		            </span>
		        </span>
		    </span>
<%-- 		<div id="ListInfo" style="display:none"><%=ListInfo%></div> --%>
	</body>
</html>