<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>BoardItemList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ezBoardSTD.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript" src="/js/NameControl.js"></script>
		<!-- data picker-->
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<style>
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
		<script type="text/javascript">
			var pBoardID = "${boardID}";
	    	var SSUserID = "${userInfo.id}";
		    var SSUserName = "${userInfo.name}";
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
		    var BrdName = "${boardName}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var pSortBy = "${boardInfo.sortBy}";
		    var url = "${boardInfo.url}";
		    var ShowAdjacent = "";
		    var gubun = "${boardInfo.guBun}";
		    var totalCount = "0";
			var lang = "${userInfo.lang}";
		    var OrderOption = "";
		    var OrderCell = "";
		    var pBoardType = "${boardInfo.boardType}";
		    var USE_OCS = "${use_ocs}";
		    var SQLPARADATA = "";
		    var Use_OneLineCount = "${use_oneLineCount}";
		    var pAdminType = "${boardInfo.adminType}";
		    if (url != "")
		        window.location.href = url;
		
		    var previewType = "PHOTO";
		    var clickPreviweType = "PHOTO";
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
		    var pPreviewShow_HOW = "OFF";
		    var xmlhttp = createXMLHttpRequest();
		    var xmlhttp2 = createXMLHttpRequest();
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
		        getBoardList();
		
		        if (document.documentElement.clientWidth < 1300) {
		            document.getElementById("right").style.display = "none";
		        }
		    };
		
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', "");
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', "");
		    });
		    if(lang == "1"){
			    $(function () {
			        $.datepicker.regional['ko'] = {
			            closeText: '닫기',
			            prevText: '이전달',
			            nextText: '다음달',
			            currentText: '오늘',
			            monthNames: ['1월', '2월', '3월', '4월', '5월', '6월',
			            '7월', '8월', '9월', '10월', '11월', '12월'],
			            monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
			            '7월', '8월', '9월', '10월', '11월', '12월'],
			            dayNames: ['일', '월', '화', '수', '목', '금', '토'],
			            dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
			            dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
			            weekHeader: 'Wk',
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional['ko']);
			    });
		    }else {
			    $(function () {
			        $.datepicker.regional['en'] = {
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional['en']);
			    });
		    }
		
		
		    var xmlhttp = createXMLHttpRequest();
		    function getBoardList(type) {
		        if (type == "1") {
		            SQLPARADATA = "";
		        }
		        starttime = new Date().getTime();
		        if(document.getElementById("viewtype") != null)
		        	type = document.getElementById("viewtype").value;
		        if (SQLPARADATA != ""){
		        	url = "/ezBoard/getSearchBoardList.do";
		        }
		        else{
		        	url = "/ezBoard/getBoardList.do";
		        }
		        $.ajax({
					type : "POST",
					dataType : "xml",
					async : true,
					url : url,
					data : { boardType   : pBoardType, 
							 boardId 	 : pBoardID, 
							 pageNum 	 : CurPage, 
							 orderCell 	 : OrderCell, 
							 orderOption : OrderOption,
							 searchQuery : SQLPARADATA,
							 type 		 : type
							},
					success: function(xml){
						getBoardList_after(xml);
					}        			
				});	
		    }
		
		    var perCnt = "";
		    var firstFlag = false;
		    function getBoardList_after(xml) {
	            var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
	            var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
	            var pagenode = SelectSingleNodeNew(xml, "DOCLIST/PAGECNT");
	            var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
	            pPreviewShow_HOW = getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWTYPE"));
	            if (listNode == null) return;
	
	            var lstCnt = getNodeText(cntNode);            
	            var pageCnt = getNodeText(pagenode);
	            if (perCnt == "")
	                perCnt = getNodeText(perNode);
	
	            listcount.value = perCnt;
	            totalPage = Math.ceil(new Number(pageCnt / perCnt));
	            pTotalCnt = lstCnt;
	
	            makePageSelPage();
	
	
	            var xmlDoc;
	            if (CrossYN()) {
	                var xmlLIST = createXmlDom();
	                var nodeToImport = xmlLIST.importNode(listNode, true);
	                xmlLIST.appendChild(nodeToImport);
	
	                xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
	            }
	            else {
	                xmlDoc = createXmlDom();
	                xmlDoc.appendChild(listNode);
	            }
	            if (document.getElementById("lvBoardList").innerHTML != "") document.getElementById("lvBoardList").innerHTML = "";
	            var DocList = new ListView();
	            DocList.SetID("BoardList");
	            DocList.SetHeaderOnClick("SortPage");
	            DocList.SetRowOnDblClick("ItemRead_onclick(this)");
	            DocList.SetRowOnClick("ItemPreviewRead_click");
	            DocList.SetTitleIdx(0);
	            DocList.SetSelectFlag(false);
	            DocList.DataSource(xmlDoc);
	            DocList.DataBind("lvBoardList");
	            DocList = null;
	            strListInfo = "";
	
	            var tempno = 0;
	            for (var i = 0; i < GetElementsByTagName(xmlDoc, "ROW").length; i++) {
	                if (CrossYN()) {
	                    if (parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim()) > tempno)
	                        tempno = parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim());
	                }
	                else {
	                    if (parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim()) > tempno)
	                        tempno = parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim());
	                }
	            }
	            tempno = tempno + "";
	
	            if (tempno.length > 4) {
	                document.getElementById("BoardList_TH_1").style.width = tempno.length * 3 + 20 + "px";
	            }
	
	            if (USE_OCS == "YES" && lstCnt > 0) {
	                check_presence();
	            }
	
	            if (!firstFlag) {
	                PreviewRayerChange(pPreviewShow_HOW);
	                //if (pAdminType != "y")
	                //    PreviewRayerChange(pPreviewShow_HOW);
	                //else
	                //    PreviewRayerChange("NONE");
	                if (ifrmPreViewH_photo.document.getElementById("ifrmviewEmptyText") != null)
	                    ifrmPreViewH_photo.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022'/>";
	                firstFlag = true;
	            }
	            endtime = new Date().getTime();
	            document.getElementById("runtime").innerHTML = "RunTime : <span style='color:black;font-weight:bold'>" + (endtime - starttime) / 1000 + "</span> Sec";
		    }
		
		
		    function MakeSubCondition() {
		        var TYPE = "";
		        var DATA = "";
		
		        //하위 게시판 검색할 건지에 대한 조건
		        if (document.getElementById("chkSearchSub").checked)		// SearchSubBoard
		        {
		            TYPE += "SEARCHSUBBOARD;";
		        }
		
		        if (document.getElementById("txt_keyword").value != "") {
		            var radiosearch = document.getElementsByName('searchCheck');
		            if (radiosearch.item(0).checked) {
		                TYPE += "TITLE;";
		                DATA += "<TITLE>" + document.getElementById("txt_keyword").value + "</TITLE>";
		            }
		            else if (radiosearch.item(1).checked) {
		                TYPE += "WRITERNAME;";
		                DATA += "<WRITERNAME>" + document.getElementById("txt_keyword").value + "</WRITERNAME>";
		            }
		        }
		        else {
		            if (document.getElementById("txtTitle").value != "")		// DocTitle
		            {
		                TYPE += "TITLE;";
		                DATA += "<TITLE>" + document.getElementById("txtTitle").value + "</TITLE>";
		            }
		
		            if (document.getElementById("txtWriterName").value != "")		// DrafterName
		            {
		                TYPE += "WRITERNAME;";
		                DATA += "<WRITERNAME>" + document.getElementById("txtWriterName").value + "</WRITERNAME>";
		            }
		
		            if (document.getElementById("txtAbstract").value != "")		// ABSTRACT
		            {
		                TYPE += "ABSTRACT;";
		                DATA += "<ABSTRACT>" + document.getElementById("txtAbstract").value + "</ABSTRACT>";
		            }
		
		            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "")		// StartDate
		            {
		                TYPE += "STARTDATE;";
		                DATA += "<STARTDATE>" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + "</STARTDATE>";
		            }
		
		            if ($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "")		// EndDate
		            {
		                TYPE += "ENDDATE;";
		                DATA += "<ENDDATE>" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + "</ENDDATE>";
		            }
		        }
		        SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
		    }
		
		    function btn_PostDate_Clear() {
		        $("#Sdatepicker").datepicker('setDate', "");
		        $("#Edatepicker").datepicker('setDate', "");
		    }
		
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        if(pAdminType != "y")
		            document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + pTotalCnt + " </span>" + strLang42 + "]";
		        else
		            parent.document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + pTotalCnt + " </span>" + strLang42 + "]";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
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
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        else {
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
		
		    function NewItem_onclick() {
		        if (Write_FG != "true") {
		            alert("<spring:message code='ezBoard.t262'/>");
		            return;
		        }
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
		        window.open("/ezBoard/newBoardItemPhoto.do?boardID=" + pBoardID + "&mode=new", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		        
		    }
		    
		    function ItemRead_onclick(obj) {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t194'/>");
		            return;
		        }
		
		        //var SelList = new ListView();
		        //SelList.LoadFromID("BoardList");
		        //var oArrRows = SelList.GetSelectedRows();
		        //var tr = oArrRows[0];
		
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
		
		        if (obj.childNodes[2].style.fontWeight == "bold")
		            obj.childNodes[2].style.fontWeight = "normal";
		        // if (tr != null && oArrRows.length > 0) {
		
		        window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + obj.getAttribute("DATA2") + "&boardID=" + obj.getAttribute("DATA1") + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
		        //}       
		    }
		
		    function NoticeRead_onclick(pItemBoardID, pItemBoardName, pItemID, pUserID, evt) {
		        if (Read_FG != "true") {
		            OpenAlertUI("<spring:message code='ezBoard.t194'/>");
		            return;
		        }
		        if (CrossYN())
		            var e = evt.currentTarget;
		        else
		            var e = event.srcElement;
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
		
		        window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
		
		    }
		    
		    var checkpassword_dialogArguments = new Array();
		    var strItemList = "";
		    function DeleteItem_onclick() {
		        if (gubun == "2") {
		            if (strListInfo == "") {
		                alert("<spring:message code='ezBoard.t195'/>");
						return;
					}
		
		            if (CrossYN()) {
		                arrList2 = strListInfo.split(";");
		                for (var i = 0; i < arrList2.length - 1; i++) {
		                    strItemList += arrList2[i].split(",")[0] + ";";
		                }
		                strItemList = strItemList.split(";");
		                if (strItemList.length > 2) {
		                    alert("<spring:message code='ezBoard.t264'/>");
		                    return;
		                }
		            } else {
		                arrList = strListInfo.split(",;");
		                if (arrList.length > 2) {
		                    alert("<spring:message code='ezBoard.t264'/>");
		                    return;
		                }
		            }
		        }
		        else {
		            if (strListInfo == "") {
		                alert("<spring:message code='ezBoard.t195'/>");
						return;
					}
		        }
		
		        if (Delete_FG != "true") {
		            alert("<spring:message code='ezBoard.t265'/>");
					return;
				}
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false && gubun != "2") {
		            alert("<spring:message code='ezBoard.t202'/>");
					return;
				}
		
		        if (CheckIfHasReplies()) {
		            alert("<spring:message code='ezBoard.t196'/>");
					return;
				}
		        if (gubun == "2" && BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
		            if (CrossYN()) {
		                checkpassword_dialogArguments[1] = DeleteItem_onclick_Complete;
		                var OpenWin = window.open("/ezBoard/checkPassWord.do?itemID=" + strItemList[0], "CheckPassWord", GetOpenWindowfeature(340, 200));
		                try { OpenWin.focus(); } catch (e) { }
		            } else {
		                var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
		                feature = feature + GetShowModalPosition(330, 200);
		                var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + arrList[0], "", "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no");
		
		                if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") return;
		
		                if (ret == "NO") {
		                    alert("<spring:message code='ezBoard.t267'/>");
		                    return;
		                }
		                else {
		                    var xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + arrList[0] + ";", false);
		                    xmlhttp.send();
		
		                    if (xmlhttp.responseText == "NO") {
		                        alert("<spring:message code='ezBoard.t265'/>");
		                        return;
		                    }
		
		                    xmlhttp = null;
		                    alert('<spring:message code='ezBoard.t268'/>');
		
		                    if (CurPage == totalPage) {
		                        var SelList = new ListView();
		                        SelList.LoadFromID("BoardList");
		                        var DeleteCount = strListInfo.split(';').length - 1;
		                        if (SelList.GetRowCount() == DeleteCount) {
		                            CurPage = CurPage - 1;
		                        }
		                    }
		                    if (CurPage == 0) CurPage = 1;
		                    getBoardList();
		                }
		            }
		        }
		        else {
		            var ret = confirm("<spring:message code='ezBoard.t197'/>");
					if (ret)
					    DeleteItem();
				}
		    }
		    function DeleteItem_onclick_Complete(ret) {
		        if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") return;
		
		        if (ret == "NO") {
		            alert("<spring:message code='ezBoard.t267'/>");
		            return;
		        }
		        else {
		            var xmlhttp = createXMLHttpRequest();
		            xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + strItemList[0] + ";", false);
		            xmlhttp.send();
		
		            if (xmlhttp.responseText == "NO") {
		                alert("<spring:message code='ezBoard.t265'/>");
		                return;
		            }
		
		            xmlhttp = null;
		            alert('<spring:message code='ezBoard.t268'/>');
		
		                    if (CurPage == totalPage) {
		                        var SelList = new ListView();
		                        SelList.LoadFromID("BoardList");
		                        var DeleteCount = strListInfo.split(';').length - 1;
		                        if (SelList.GetRowCount() == DeleteCount) {
		                            CurPage = CurPage - 1;
		                        }
		                    }
		                    if (CurPage == 0) CurPage = 1;
		                    getBoardList();
		                }
		            }
		    function CheckIfHasReplies() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/checkIfHasReply.do?itemList=" + strListInfo, false);
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
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + strListInfo, false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		            alert("<spring:message code='ezBoard.t265'/>");
		            return;
		        }
		
		        xmlhttp = null;
		
		        if (CurPage == totalPage) {
		            var SelList = new ListView();
		            SelList.LoadFromID("BoardList");
		            var DeleteCount = strListInfo.split(';').length - 1;
		            if (SelList.GetRowCount() == DeleteCount) {
		                CurPage = CurPage - 1;
		            }
		        }
		        if (CurPage == 0) CurPage = 1;
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
		        window.location.href = window.location.href = "/ezBoard/boardItemListPhoto.do?page=" + CurPage.toString() + "&boardID=" + pBoardID + "&sortBy=&boardType=" + pBoardType + "&adminType=" + pAdminType;
		    }
		
		    function AddToMyBoards() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/addToMyBoards.do?boardID=" + pBoardID, false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText.indexOf("OK") > -1) {
		            alert("<spring:message code='ezBoard.t269'/>");
				} else {
					alert("<spring:message code='ezBoard.t270'/>");
				}
		        xmlhttp = null;
		    }            
		
		    function CopyItem_onclick() {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t202'/>");
					return;
				}
		
		        if (strListInfo == "") {
		            alert("<spring:message code='ezBoard.t201'/>");
					return;
				}
		
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
		            alert("<spring:message code='ezBoard.t202'/>");
					return;
				}
		
		        var arrList = new Array();
		        var strItemList = "";
		        var i = 0;
		
		        arrList = strListInfo.split(";");
		        for (i = 0; i < arrList.length - 1; i++) {
		            strItemList += arrList[i].split(",")[0] + ";";
		        }
		        arrList = null;
		
		        var pheigth = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        pheigth = parseInt(pheigth) / 2;
		        pwidth = parseInt(pwidth) / 2;
		        pheigth = pheigth - 200;
		        pwidth = pwidth - 127;
		
		        window.open("/ezBoard/copyBoardItem.do?itemIDList=" + strItemList + "&boardID=" + pBoardID + "&mode=COPY", "", "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth, "");
		
		    }
		    var moveboarditem_cross_dialogArguments = new Array();
		    function MoveItem_onclick() {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t202'/>");
					return;
				}
		        if (strListInfo == "") {
		            alert("<spring:message code='ezBoard.t497'/>");
					return;
				}
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
		            alert("<spring:message code='ezBoard.t202'/>");
					return;
				}
		        if (CheckIfHasReplies()) {
		            alert(strLang26);
		            return;
		        }
		        var arrList = new Array();
		        var strItemList = "";
		        var i = 0;
		        arrList = strListInfo.split(";");
		        for (i = 0; i < arrList.length - 1; i++) {
		            strItemList += arrList[i].split(",")[0] + ";";
		        }
		        arrList = null;
		        if (CrossYN()) {
		            moveboarditem_cross_dialogArguments[1] = MoveItem_onclick_Complete;
		            var OpenWin = window.open("/ezBoard/moveBoardItem.do?itemIDList=" + strItemList + "&boardID=" + pBoardID, "MoveBoardItem", GetOpenWindowfeature(340, 600));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var pheigth = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            pheigth = parseInt(pheigth) / 2;
		            pwidth = parseInt(pwidth) / 2;
		            pheigth = pheigth - 200;
		            pwidth = pwidth - 127;
		            var ret = window.showModalDialog("/ezBoard/moveBoardItem.do?itemIDList=" + strItemList + "&boardID=" + pBoardID, "", "DialogHeight:656px;DialogWidth:340px;status:no;help:no;edge:sunken;scroll:no");
		
		            if (typeof (ret) != "undefined") {
		                if (ret == "OK") {
		                    window.location.reload();
		                    window.close();
		                }
		            }
		        }
		    }
		
		    function MoveItem_onclick_Complete(ret) {
		        if (typeof (ret) != "undefined") {
		            if (ret == "OK") {
		                window.location.reload();
		                window.close();
		            }
		        }
		    }
		    function SetRead_onclick() {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t194'/>");
					return;
				}
		        if (strListInfo == "") {
		            alert("<spring:message code='ezBoard.t198'/>");
					return;
				}
		        var ret = confirm("<spring:message code='ezBoard.t199'/>");
				if (ret) {
				    var arrList = new Array();
				    var strItemList = "";
				    var i = 0;
				    arrList = strListInfo.split(";");
				    for (i = 0; i < arrList.length - 1; i++) {
				        strItemList += arrList[i].split(",")[0] + ";";
				    }
				    arrList = null;
				    var xmlhttp = createXMLHttpRequest();
				    xmlhttp.open("POST", "/ezBoard/setRead.do?boardID=" + pBoardID + "&itemIDList=" + strItemList, false);
				    xmlhttp.send();
				    xmlhttp = null;
				    getBoardList();
				}
			}
			function MemberInfo_onclick(pUserID) {
			    if (gubun == "2") return;
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			    var left = (width - 500) / 2;
			    var top = (heigth - 400) / 2;
			    window.open("/myoffice/common/ShowPersonInfo_cross.aspx?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
			}
			function ReservationItem_onclick() {
			    var OrgBoardParameters = "Page=" + CurPage + "&BoardID=" + pBoardID + "&SortBy=&BoardType=" + pBoardType;
			    window.location.href = "/ezBoard/boardReservedItemList.do?orgBoardParameters=" + encodeURI(OrgBoardParameters) + "&boardType=" + pBoardType;
			}
			function search_onclick() {
			    var OrgBoardParameters = "Page=" + CurPage + "&BoardID=" + pBoardID + "&SortBy=&BoardType=" + pBoardType;
			    window.location.href = "/ezBoard/searchBoardItem.do?boardID=" + pBoardID + "&boardType=" + pBoardType + "&orgBoardParameters=" + encodeURI(OrgBoardParameters);
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
		
			function chk_onselect(obj) {
		
			    if (obj.checked) {
			        strListInfo += obj.id;
			    } else {
			        strListInfo = ReplaceText(strListInfo, obj.id, "");
			    }
			    listEventCheckbox = true;
			}
		
			function doLayerPopup(obj) {
			    btn_PostDate_Clear();
			    document.getElementById("chkSearchSub").checked = false;
			    document.getElementById("txtTitle").value = "";
			    document.getElementById("txtWriterName").value = "";
			    document.getElementById("txtAbstract").value = "";
		
			    if (obj.getAttribute("mode") == "off") {
			        document.getElementById("layer_popup").style.left = "10px";
			        if (pAdminType == "y")
			            document.getElementById("layer_popup").style.top = "56px";
			        else
			            document.getElementById("layer_popup").style.top = "100px";
			        document.getElementById("layer_popup").style.display = "";
			        obj.setAttribute("mode", "on");
			    }
			    else {
			        BoardSearchOptionHidden();
			    }
			}
			function BoardSearchOptionHidden() {
			    document.getElementById("layer_popup").style.display = "none";
			    document.getElementById("SearchOption").setAttribute("mode", "off");
			}
		
			function search(type) {
		
			    if (type == "basic") {
			        if (document.getElementById("txtWriterName").value == "" && document.getElementById("txtTitle").value == "" && document.getElementById("txtAbstract").value == "" && $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
			            alert("<spring:message code='ezBoard.t192'/>");
			            return;
			        }
		
			        if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
			            alert("<spring:message code='ezBoard.t189'/>");
			            return;
			        }
			        if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
			            alert("<spring:message code='ezBoard.t189'/>");
			            return;
			        }
			        if (new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
			            alert("<spring:message code='ezBoard.t191'/>");
			            return;
			        }
			    }
			    else if (type == "quick") {
			        if (document.getElementById("txt_keyword").value == "") {
			            alert("<spring:message code='ezBoard.t192'/>");
			            return;
			        }
			    }
			    CurPage = "1";
			    BoardSearchOptionHidden();
		
			    MakeSubCondition();
			    getBoardList();
			}
		    function check_presence() {
		        var DocList = new ListView();
		        DocList.LoadFromID("BoardList");
		
		        var TRs = DocList.GetDataRows();
		        if (TRs[0].getAttribute("id") == "BoardList_TR_noItems") {
		            return;
		        }
		
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
		        pSIPUriList = null;
		    }
		
		    function keyword_Clear() {
		        document.getElementById('txt_keyword').value = "";
		    }
		
		    function onkeydown_start_search() {
		        if (window.event.keyCode == "13")
		            search("quick");
		    }
		
		    function SaveMyBoard() {
		        if (CrossYN()) {
		            var OpenWin = GetOpenWindow("/ezBoard/myBoardConfig.do?type=ADD&boardID=" + pBoardID, "MyBoardConfig", 450, 415);
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else
		            showModalDialog("/ezBoard/myBoardConfig.do?type=ADD&boardID=" + pBoardID, null, "dialogHeight:400px; dialogWidth:465px; status:no; help:no; scroll:no; edge:sunken");
		    }
		
		    function SetBoardAcl() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/getParentBoardID.do", false);
		        xmlhttp.send(pBoardID);
		
		        if (xmlhttp.status == 200) {
		            if (parent.window.document.getElementsByTagName("h1").length == 0)
		                location.href = "/admin/ezBoard/boardACL.do?adminType=y&parentNeed=Y&boardID=" + pBoardID + "&parentBoardID=" + getNodeText(xmlhttp.responseText) + "&boardType=" + pBoardType + "&boardName=" + encodeURI(BrdName);
		            else
		                location.href = "/admin/ezBoard/boardACL.do?adminType=y&parentNeed=N&boardID=" + pBoardID + "&parentBoardID=" + getNodeText(xmlhttp.responseText) + "&boardType=" + pBoardType + "&boardName=" + encodeURI(BrdName);
		        }
		        else {
		            alert("ERROR");
		        }
		    }
		
		</script>
	</head>
	<c:choose>
		<c:when test="${boardInfo.adminType != 'y'}">
			<body class="mainbody" style="overflow:hidden">
		</c:when>
		<c:otherwise>
			<body class="" style="overflow:hidden">
		</c:otherwise>
	</c:choose>
	<c:if test="${boardInfo.listView_FG != 'true'}">
		<div style="margin-top:100px;text-align:center"><spring:message code='ezBoard.t272'/></div>
	</c:if>
	<c:choose>
		<c:when test="${boardInfo.adminType != 'y'}">
			<h1>${boardName}<span id="mailBoxInfo"></span>
			      <span style="float:right;font-weight:normal;color:black;">
			          <input name="searchCheck" id="Radio1" type="radio" value="rad_Subject" checked style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezBoard.t208'/>
					  <input name="searchCheck" id="Radio2" type="radio" value="rad_Writer" style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezBoard.t223'/>
					  &nbsp;
					  <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
			          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search('quick')"></a>
			        </span>
			</h1>
		</c:when>
		<c:otherwise>
		    <script type="text/javascript">
		        parent.document.getElementsByTagName("h1")[0].innerHTML = "<h1>"+ "${boardName}" +"<span id='mailBoxInfo'></span></h1>";
		    </script>
		    <br />
		    <span style="display:none; float:right;font-weight:normal;color:black;">
		          <input name="searchCheck" id="Radio1" type="radio" value="rad_Subject" checked style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezBoard.t208'/>
				  <input name="searchCheck" id="Radio2" type="radio" value="rad_Writer" style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezBoard.t223'/>
				  &nbsp;
				  <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
		          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search('quick')"></a>
	        </span>
		</c:otherwise>
	</c:choose>
	<c:if test="${boardInfo.buttonHidden == 'N'}">
		<div id="mainmenu">
		  <ul>
		        <li><span onclick="SetRead_onclick()"><spring:message code='ezBoard.t204'/></span></li>
		        <li><span onClick="NewItem_onclick()"><spring:message code='ezBoard.t273'/></span></li>
			    <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
		        <li><span onClick="DeleteItem_onclick()"><spring:message code='ezBoard.t89'/></span></li>
			    <li id="Li1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" align="absmiddle"></li>
		        <li><span onClick="refresh_onclick()"><spring:message code='ezBoard.t205'/></span></li>
		        <li><span id="SearchOption" mode="off" onClick="doLayerPopup(this)"><spring:message code='ezBoard.t188'/></span></li>
		        <li><span onClick="AddToMyBoards()"><spring:message code='ezBoard.t10051'/></span></li>
		        <li><span onClick="SaveMyBoard()"><spring:message code='ezBoard.t10052'/></span></li> 
		        <li id="right"><spring:message code='ezBoard.t10020'/><img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" /></li>
		        <c:if test="${boardInfo.boardAdmin_FG == 'true'}">
			      <li><span onClick="SetBoardAcl()"><spring:message code='ezBoard.t63'/></span></li> 
		        </c:if>         
		        <li style="background:none">
		            <select id="viewtype" onchange="getBoardList('1')">
		                <option value="1"><spring:message code='ezBoard.t4001'/></option>
		                <option value="2"><spring:message code='ezBoard.t4002'/></option>
		            </select>
		        </li>
		  </ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
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
                        <th><spring:message code='ezBoard.t10021'/></th>
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
                        <th><spring:message code='ezBoard.t431'/></th>
                        <td>
                            <img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
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
        <span class="previewmail_bar_h" display: inline-block;">
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
                            <dt><spring:message code='ezBoard.t223'/>:
                                <span id="PreH_MailReceiver" style="display: inline-block"></span>
                            </dt>
                        </dl>
                    </div>
                </span>
                <iframe id="ifrmPreViewH_photo" name="ifrmPreViewH_photo" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
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
                            <dt><spring:message code='ezBoard.t223'/>:</dt>
                            <dd><span id="PreW_MailReceiver" style="display: inline-block"></span>
                            </dd>
                        </dl>
                    </div>
                </span>
                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
            </span>
        </span>
    </span>
	
	    
	<div id="ListInfo" style="display:none"></div>
	         <div id="layer_popup" style="width:700px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
	          <div class="popupwrap1">
	            <div class="popupwrap2">
	        <table class="content">  
	            <tr>
	    <th  style="text-align:center"><spring:message code='ezBoard.t185'/></th>
	    <td>${boardName}
	      <input type="checkbox" id="chkSearchSub" ><spring:message code='ezBoard.t498'/>
	    </td>
	  </tr>
	        <tr>
	            <th style="text-align:center"><spring:message code='ezBoard.t223'/></th>
	            <td><input type="text" id="txtWriterName" style="width:98%" value=""></td>
	        </tr>
	        <tr>
	            <th style="text-align:center"><spring:message code='ezBoard.t208'/></th>
	            <td><input type="text" id="txtTitle" style="width:98%" value=""></td>
	        </tr>  
	         <tr>
	            <th style="text-align:center"><spring:message code='ezBoard.t209'/></th>
	            <td><input type="text" id="txtAbstract" style="width:98%" value=""></td>
	        </tr>    
	       <tr>
	            <th style="text-align:center"><spring:message code='ezBoard.t210'/></th>
	           <td>
	               <input type="text" id="Sdatepicker" style="width:80px;text-align:center">
	                ~
	               <input type="text" id="Edatepicker" style="width:80px;text-align:center"> 
	           </td>
	  </tr>
	    </table>
	    <br />
	    <table style="width:100%">
	        <tr>
	            <td style="text-align:center;">
	                <a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezBoard.t220'/></span></a>
	                <a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezBoard.t188'/></span></a>
	                <a class="imgbtn"><span onClick="BoardSearchOptionHidden()"><spring:message code='ezBoard.t15'/></span></a>
	            </td>
	        </tr>
	    </table>
	            </div>
	          </div>
		        <div class="shadow">
	            </div>
	        </div>
	</body>
</html>