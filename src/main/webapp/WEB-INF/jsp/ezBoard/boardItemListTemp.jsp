<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>BoardItemList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ezBoardSTD.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript" src="/js/ezBoard/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/ezBoard/composeappt.js"></script>
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
		        var ShowAdjacent = "";
		        var USE_OCS = "${useOcs}";
		        var SSUserID = "${userInfo.id}";
		        var pBoardType = "";
		        var CurPage = "${page}";
		        var Use_OneLineCount = "NO";
		        var OrderCell = "";
		        var OrderOption = "";
		        var PreviewH_Move = false;
		        var PreviewW_Move = false;
		        var clickPreviweType = "";
		        var selobj = null;
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
		        var pPreviewShow_HOW = "OFF";
		        var SmallSizeList = false;
		        var OldSmallSizeList = false;
		        var onclickFlag = false;
		        var SQLPARADATA = "";
		        var pMode = "temp";
		        var starttime;
		        var endtime;
		        var pAdminType = "n";
		        var pUse_Editor = "${useEditor}";
		        var pNoneActiveX = "YES";
		        var pUse_IE11Browser = "CK";
		        var strListInfo = "";
		        var g_bPrevShow = false;
		        window.onunload = Window_onunload;
		        var window_onunload_Event = false;
		        window.onresize = function () {
		            var height = parseInt(document.documentElement.clientHeight - 320);
		            Window_resize();
		
		        };
		        document.onselectstart = function () { return false; };
		        window.onload = function () {
		            if (navigator.userAgent.indexOf('Firefox') != -1) {
		                document.body.style.MozUserSelect = 'none';
		                document.body.style.WebkitUserSelect = 'none';
		                document.body.style.khtmlUserSelect = 'none';
		                document.body.style.oUserSelect = 'none';
		                document.body.style.UserSelect = 'none';
		            }
		            initdatepicker();
		            var height = parseInt(document.documentElement.clientHeight - 180);
		            document.getElementById("divList").style.height = height + "px";
		            window_onunload_Event = true;
		            getBoardList();
		        };
		        var Save_unloadSave = false;
		        function Window_onunload() {
		            if (window_onunload_Event && !Save_unloadSave) {
		                var divStyle, ifrmStyle;
		                var listCount = document.getElementById("listcount").value;
		
		                if (pPreviewShow_HOW == "W") {
		                    divStyle = parseInt(document.getElementById("divList").style.height);
		                    ifrmStyle = parseInt(document.getElementById("ifrmPreViewW").style.height);
		                    divStyle = parseInt((divStyle * 100) / (divStyle + ifrmStyle));
		                }
		                else if (pPreviewShow_HOW == "H") {
		                    divStyle = parseInt(document.getElementById("divList").scrollWidth);
		                    ifrmStyle = parseInt(document.getElementById("ifrmPreViewH").scrollWidth);
		                    divStyle = parseInt((divStyle * 100) / (divStyle + ifrmStyle));
		                }
		                else {
		                    divStyle = 0;
		                }
		                if (divStyle < 24)
		                    divStyle = 24;
		                
		                $.ajax({
							type : "POST",
							dataType : "json",
							async : false,
							url : "/ezBoard/boardGeneralListSave2.do",
							data : { userID 	 : SSUserID, 
									 listCount 	 : listCount, 
									 previewMode : pPreviewShow_HOW,
									 list 		 : divStyle,
									 content 	 : (100 - divStyle)
									},
							success: function(){
							}        			
						});
		                Save_unloadSave = true;
		            }
		        }
		
		        function initdatepicker() {
		            var idDatepicker = new datepicker('idDatepicker', 'idDatepicker');
		            idDatepicker.attachEvent('datechange', onStartDateChanged);
		            idDatepicker.attachEvent('enddatechange', onEndDateChanged);
		            idDatepicker.elemDateButtons = "img_StartCalDisp;img_EndCalDisp";
		            idDatepicker.elemDateInputs = "idDatepicker;_D2";
		            idDatepicker.elemTimeButtons = "img_StartTime;img_EndTime";
		            idDatepicker.elemTimeInputs = "_T1;_T2";
		            idDatepicker.popupType = "both";
		            idDatepicker.pickerDateFormat = "[yyyy]"+"<spring:message code='ezBoard.t211'/>" +"[MM]"+"<spring:message code='ezBoard.t10000'/>";
		            idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
		            idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
		            idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
		            idDatepicker.firstDayOfWeek = "0";
		            idDatepicker.textAM = "<spring:message code='ezBoard.t212'/>";
		            idDatepicker.textPM = "<spring:message code='ezBoard.t213'/>";
		            idDatepicker.textDecimal = ".";
		            idDatepicker.textHoursAbbrev = "<spring:message code='ezBoard.t214'/>";
		            idDatepicker.textMustSpecifyValidTime = "<spring:message code='ezBoard.t215'/>";
		            idDatepicker.daynameLetters = "<spring:message code='ezBoard.t216'/>";
		            idDatepicker.daynamesShort = "<spring:message code='ezBoard.t216'/>";
		            idDatepicker.daynamesLong = "<spring:message code='ezBoard.t217'/>";
		            idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
		            idDatepicker.monthnamesLong = "<spring:message code='ezBoard.t218'/>";
		            idDatepicker.ready();
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
		
		        var xmlhttp = createXMLHttpRequest();
		        function getBoardList() {
		        	starttime = new Date().getTime();
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
						data : { boardType   : "M", 
								 pageNum 	 : CurPage, 
								 orderCell 	 : OrderCell, 
								 orderOption : OrderOption,
								 searchQuery : SQLPARADATA,
								 mode        : "temp"
								},
						success: function(xml){
							getBoardList_after(xml);
						}		
					});
		        }
		
		        var perCnt = "";
		        var firstFlag = false;
		        function getBoardList_after(xml) {
		            try {
		                var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
		                var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
		                var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
		
		                pPreviewShow_HOW = getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWTYPE"));
		                pMailListDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWLIST")));
		                pMailPreVDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWCONTENT")));
		                pMailListDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHLIST")));
		                pMailPreVDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHCONTENT")));
		
		                if (listNode == null) return;
		
		                var lstCnt = getNodeText(cntNode);
		                totalCount = lstCnt;
		                if (perCnt == "")
		                    perCnt = getNodeText(perNode);
		
		                listcount.value = perCnt;
		
		                totalPage = Math.ceil(new Number(lstCnt / perCnt));
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
		
		                if ("${useOcs}" == "YES" && lstCnt > 0) {
		                    check_presence();
		                }
		
		                if (!firstFlag) {
		                    PreviewRayerChange(pPreviewShow_HOW);
		                    if (CrossYN()) {
		                        if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null)
		                            ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = "<spring:message code='ezBoard.t10022'/>";
		                        if (ifrmPreViewW.document.getElementById("ifrmviewEmptyText") != null)
		                            ifrmPreViewW.document.getElementById("ifrmviewEmptyText").textContent = "<spring:message code='ezBoard.t10022'/>";
		                    } else {
		                        if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null)
		                            ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022'/>";
		                        if (ifrmPreViewW.document.getElementById("ifrmviewEmptyText") != null)
		                            ifrmPreViewW.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022'/>";
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
		            document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang42 + "]";
		            strtext = "<div class='pagenavi'>";
		            PagingHTML += strtext;
		            var pageNum = CurPage;
		            if (totalPage > 1 && pageNum != 1) {
		                strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
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
		
		        function ItemRead_onclick(obj) {
		            var feature = GetOpenWindowfeature(765, 820);
		            if(obj.getAttribute("DATA10") == "3" || obj.getAttribute("DATA10") == "4") {
		                window.open("/ezBoard/boardNewItemTempPhoto.do?boardID=" + obj.getAttribute("DATA1") + "&itemID=" + obj.getAttribute("DATA2") + "&mode=temp" + "&location=TEMP", "", feature, "");
		            }
		            else{
                    	window.open("/ezBoard/boardNewItem.do?boardID=" + obj.getAttribute("DATA1") + "&itemID=" + obj.getAttribute("DATA2") + "&mode=temp" + "&location=TEMP", "", feature, "");
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
		            xmlhttp.open("POST", "/ezBoard/deleteItem.do?itemList=" + strListInfo + "&mode=" + pMode, false);
		            xmlhttp.send();
		
		            if (xmlhttp.responseText == "NO") {
		                alert("<spring:message code='ezBoard.t265'/>");
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
		            window.location.href = "/ezBoard/boardItemListTemp.do";
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
		            refresh_onclick();
		        }
		    }
		    function MemberInfo_onclick(pUserID) {
		        var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
		    }
		    function ReservationItem_onclick() {
		        var OrgBoardParameters = "page=" + CurPage + "&boardID=" + pBoardID + "&sortBy=&boardType=" + pBoardType;
		        window.location.href = "/ezBoard/boardReservedItemList.do?orgBoardParameters=" + encodeURI(OrgBoardParameters) + "&boardType=" + pBoardType;
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
		
		    function DeleteItem_onclick() {
		
		        if (strListInfo == "") {
		            alert("<spring:message code='ezBoard.t195'/>");
		            return;
		        }
		
		        if (CheckIfHasReplies()) {
		            alert("<spring:message code='ezBoard.t196'/>");
		            return;
		        }
		        var ret = confirm("<spring:message code='ezBoard.t197'/>");
		        if (ret)
		            DeleteItem();
		
		    }
		    
		
		
		        function doLayerPopup(obj) {
		            btn_PostDate_Clear();
		            //document.getElementById("chkSearchSub").checked = false;
		            document.getElementById("txtTitle").value = "";
		            document.getElementById("txtAbstract").value = "";
		            //document.getElementById("txtWriterName").value = "";
		
		            if (obj.getAttribute("mode") == "off") {
		                document.getElementById("layer_popup").style.left = "10px";
		                document.getElementById("layer_popup").style.top = "100px";
		                document.getElementById("layer_popup").style.display = "";
		                obj.setAttribute("mode", "on");
		            }
		            else {
		                BoardSearchOptionHidden();
		            }
		        }
		        function btn_PostDate_Clear() {
		            document.getElementById("idDatepicker").value = "";
		            document.getElementById("_D2").value = "";
		        }
		        function BoardSearchOptionHidden() {
		            document.getElementById("layer_popup").style.display = "none";
		            document.getElementById("SearchOption").setAttribute("mode", "off");
		        }
		        function search(type) {
		            if (type == "basic") {
		
		                if (document.getElementById("txtTitle").value == "" && document.getElementById("txtAbstract").value == "" && document.getElementById("idDatepicker").value == "") {
		                    alert("<spring:message code='ezBoard.t192'/>");
		                    return;
		                }
		
		                if (document.getElementById("idDatepicker").value != "" && document.getElementById("_D2").value == "") {
		                    alert("<spring:message code='ezBoard.t189'/>");
		                    return;
		                }
		                if (document.getElementById("idDatepicker").value == "" && document.getElementById("_D2").value != "") {
		                    alert("<spring:message code='ezBoard.t189'/>");
		                    return;
		                }
		                if (Number(ReplaceText(document.getElementById("idDatepicker").value.substring(0, 10), "-", "")) > Number(ReplaceText(document.getElementById("_D2").value.substring(0, 10), "-", ""))) {
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
		
		    function MakeSubCondition() {
		        var TYPE = "";
		        var DATA = "";
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
		
		            if (document.getElementById("txtAbstract").value != "")		// ABSTRACT
		            {
		                TYPE += "ABSTRACT;";
		                DATA += "<ABSTRACT>" + document.getElementById("txtAbstract").value + "</ABSTRACT>";
		            }
		
		            if (document.getElementById("idDatepicker").value != "")		// StartDate
		            {
		                TYPE += "STARTDATE;";
		                DATA += "<STARTDATE>" + document.getElementById("idDatepicker").value.substring(0, 10) + "</STARTDATE>";
		            }
		
		            if (document.getElementById("_D2").value != "")		// EndDate
		            {
		                TYPE += "ENDDATE;";
		                DATA += "<ENDDATE>" + document.getElementById("_D2").value.substring(0, 10) + "</ENDDATE>";
		            }
		        }
		        SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
		    }
		    function onkeydown_start_search(evt) {
		        if (evt.keyCode == "13") {
		            search("quick");
		        }
		    }
		
		    var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
		        if (CrossYN()) {
		            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(345, 660));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var wWeight = "345";
		            var wHeight = "660";
		
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		
		            var left = (width - wWeight) / 2;
		            var top = (heigth - wHeight) / 2;
		            var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
		                "DialogHeight:660px;DialogWidth:345px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
		
		            if (typeof (ret) != "undefined") {
		                var feature = GetOpenWindowfeature(765, 820);
		                pBoardID = ret[0];
		                if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                    return;
		                }
		
		                if (ret[2] == "3" || ret[2] == "4") {
		                    window.open("/ezBoard/newBoardItemPhoto.do?boardID=" + pBoardID + "&mode=new", "", feature, "");
		                }
		                else{
	                        window.open("/ezBoard/boardNewItem.do?boardID=" + pBoardID + "&mode=new", "", feature, "");
		                }
		            }
		        }
		    }
		
		    function NewItem_onclick_Complete(ret) {
		        if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
		            var feature = GetOpenWindowfeature(765, 820);
		            if(ret[2] == "3" || ret[2] == "4") {
		                window.open("/ezBoard/newBoardItemPhoto.do?boardID=" + pBoardID + "&mode=new", "", feature, "");
		            }else{
	                    window.open("/ezBoard/boardNewItem.do?boardID=" + pBoardID + "&mode=new", "", feature, "");
		            }
		        }
		    }
		    
		    function MailReadOpen_temp() {
		        obj = selobj;
		        var feature = GetOpenWindowfeature(765, 820);
		        if (obj.getAttribute("DATA10") == "3" || obj.getAttribute("DATA10") == "4") {
		            window.open("/ezBoard/boardNewItemTempPhoto.do?boardID=" + obj.getAttribute("DATA1") + "&itemID=" + obj.getAttribute("DATA2") + "&mode=temp" + "&location=TEMP", "", feature, "");
		        }else {
	                window.open("/ezBoard/boardNewItem.do?boardID=" + obj.getAttribute("DATA1") + "&itemID=" + obj.getAttribute("DATA2") + "&mode=temp" + "&location=TEMP", "", feature, "");
		        }
		    }
	    </script>
	</head>
	<body class="mainbody" style="overflow:hidden;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	    <h1><spring:message code='ezBoard.t10030'/><span id="mailBoxInfo"></span>
	        <span style="float:right;font-weight:normal;color:black;">
	          <input name="searchCheck" id="Radio1" type="radio" value="rad_Subject" checked style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezBoard.t208'/>
			  <input name="searchCheck" id="Radio2" type="radio" value="rad_Writer" style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezBoard.t223'/>
			  &nbsp;
			  <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search('quick')"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onClick="NewItem_onclick()"><spring:message code='ezBoard.t273'/></span></li>
	            <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
	            <li><span onClick="DeleteItem_onclick()"><spring:message code='ezBoard.t89'/></span></li>
	            <li id="Li1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
	            <li><span onClick="refresh_onclick()"><spring:message code='ezBoard.t205'/></span></li>
	            <li><span id="SearchOption" mode="off" onClick="doLayerPopup(this)"><spring:message code='ezBoard.t188'/></span></li>
	            <li id="right"><spring:message code='ezBoard.t10020'/><img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" /></li>      
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
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
	                            <span class="icon_btn"><span onclick="MailReadOpen_temp();" style="cursor: pointer; padding-right: 5px;">
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
	                <iframe id="ifrmPreViewH_photo" name="ifrmPreViewH_photo" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: none;"></iframe>
	                <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
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
	                            <span class="icon_btn"><span onclick="MailReadOpen_temp();" style="cursor: pointer; padding-right: 5px;">
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
	                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0; display:none;"></iframe>
	                <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
	            </span>
	        </span>
	    </span>
	
	
	    <div id="layer_popup" style="width:700px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
	          <div class="popupwrap1">
	            <div class="popupwrap2">
	        <table class="content">
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
	           <td><input	readonly type='text'
						class='datepicker' 
						id='idDatepicker'
						style="width:95px"
						name="text">
	      <img id=img_StartCalDisp src="../../images/i_scheduler.gif" width="19" height="15" style="CURSOR: pointer; POSITION: relative; vertical-align:middle" tabindex=0 popupLocation='bottomright'  forcemarginleft="-40"  forceMarginTop="30">
	      <input	type="text" 
						id='_T1' 
						class='datepicker_time' 
						name="textfield22522" 
						readonly style="font-size:9pt ; width:95px; display:none">
	      <img id=img_StartTime src="../../images/i_time.gif" width="17" height="15" style="CURSOR: pointer; POSITION: relative; z-index:15; display:none" popupLocation='bottomright' forcemarginleft="-40"  forceMarginTop="30"> ~
	      <input type="text" id='_D2' class='datepicker_date' name="txtPermanence" readonly style="width:95px">
	      <img id=img_EndCalDisp src="../../images/i_scheduler.gif" width="19" height="15" style="CURSOR: pointer; POSITION:  relative; z-index:15; vertical-align:middle"  tabindex=0 popupLocation='bottomright'>
	      <input id='_T2'  type = hidden class='datepicker_time' readonly="true" style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 100px" name="hidden" >
	      <img border=0 height=20 id=img_EndTime src="../../images/i_time.gif" style="CURSOR: pointer; POSITION:  relative; z-index:15; display:none" width=20 popupLocation='bottomright'> </td>
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