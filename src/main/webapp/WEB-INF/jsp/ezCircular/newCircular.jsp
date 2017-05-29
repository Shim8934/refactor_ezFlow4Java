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
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
		<script type="text/javascript" src="/js/ezCircular/ListView_list.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
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
	        //var CurPage = "${page}";
	        //var CurPage = "${totalCount}";
	        var CurPage = "1";
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
	        var pMode = "new";
	        var pAdminType = "n";
	        var pUse_Editor = "${useEditor}";
	        var pNoneActiveX = "YES";
	        var pUse_IE11Browser = "CK";
	        var starttime;
	        var endtime;
	        var strListInfo = "";
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
	            
	            var height = parseInt(document.documentElement.clientHeight - 180);
	            document.getElementById("divList").style.height = height + "px";
	            window_onunload_Event = true;
	            getBoardList();
	        }; 
	        var Save_unloadSave = false;
	        function Window_onunload() {
	            if (window_onunload_Event && !Save_unloadSave) {
	                var divStyle, ifrmStyle, listCount;
	
	                if (document.getElementById("listcount") != null){
		            	listCount = document.getElementById("listcount").value;
		            } else {
		            	listCount = 20;
		            }
	                
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
						url : "/ezCircular/circularGeneralListSave2.do",
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

	        	var keyword = document.getElementById("txt_keyword").value;
	        	
		        starttime = new Date().getTime();
		        if (keyword != ""){
		        	//url = "/ezBoard/getSearchBoardList.do";
		        	url = "/ezCircular/getSearchCircularList.do";
		        }
		        else{
		        	//url = "/ezBoard/getBoardList.do";
		        	url = "/ezCircular/getCircularList.do";
		        }
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : url,
					data : { boardType   : "M", 
							 pageNum 	 : CurPage, 
							 orderCell 	 : OrderCell, 
							 orderOption : OrderOption,
							 searchQuery : SQLPARADATA,
							 keyword : keyword
							},
					success: function(xml){
						getBoardList_after(loadXMLString(xml));
					}     			
				});
	        }
	
	        var firstFlag = false;
	        function getBoardList_after(xml) {
	                var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
	                var pntNode = SelectSingleNodeNew(xml, "DOCLIST/PAGECNT");
	                var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
	                var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
	                
	                
	/*                 pPreviewShow_HOW = getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWTYPE"));
	
	                pMailListDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWLIST")));
	                pMailPreVDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWCONTENT")));
	                pMailListDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHLIST")));
	                pMailPreVDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHCONTENT"))); */
	                
	
	                pPreviewShow_HOW = "${config.isPreview}";

	                switch (parseInt("${config.isPreview}")) {
					case 0:
						pPreviewShow_HOW = "OFF";
						break;
					case 1:
						pPreviewShow_HOW = "H";
						break;
					case 2:
						pPreviewShow_HOW = "W";
						break;
					}
	                
	                pMailListDiv = "${config.previewListValue}";
	                pMailPreVDiv = "${config.previewContentValue}";
	                pMailListDiv_H = "${config.previewListValue}";
	                pMailPreVDiv_H = "${config.previewContentValue}";
	
	                if (listNode == null) return;
	
	                var lstCnt = getNodeText(cntNode);
	                //var pstCnt = getNodeText(pntNode);
	                var pstCnt = "${totalCount}";
	                totalCount = lstCnt;
	                //var perCnt = getNodeText(perNode);
	                var perCnt = "${config.listCnt}";
	
	                //listcount.value = perCnt;
	                listcount.value = "${config.listCnt}";

	                totalPage = Math.ceil(new Number(pstCnt / perCnt));
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
	            /*     for (var i = 0; i < GetElementsByTagName(xmlDoc, "ROW").length; i++) {
	                    if (CrossYN()) {
	                        if (GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim().length > 10) {
	                            tempno = GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim();
	                        }
	                    }
	                    else {
	                        if (GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim().length > 10) {
	                            tempno = GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim();
	                        }
	                    }
	                } */
	                tempno = tempno + "";
	                
	                if (tempno.length > 10) {
	                    document.getElementById("BoardList_TH_1").style.width = (tempno.length * 10) + "px";
	                }
	                
	                //document.getElementById("BoardList_TH_2").style.textalign = 'center';
	
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
	                strListInfo = "";
	            }
	        
	
	        var BlockSize = 10;
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext;
	        }
	
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            /* document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang42 + "]"; */
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
			
	        //상세보기 
	        function ItemRead_onclick(obj) {
	            
	        	/* url = "/ezCircular/circularRead.do?cmd=mod&from=schedule&selsd=&seled=&dayView=&ownerID=&brdName=";
	        	var OpenWin = window.open(url, "", "width=800, height=800, status=1");
                OpenWin.focus(); */
                
				var circularId = obj.getAttribute("CIRCULARID");

                if (CrossYN()) {
		            var feature = GetOpenPosition(820, 600);
	            	window.open("/ezCircular/circularRead.do?cmd=mod&from=schedule&" + "num=&ownerID=&type=&startDate=&endDate&brdName=&circularID="+circularId, "", "width=820, height=600, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        	} else {
	            	var feature = GetOpenPosition(790, 700);
	            	window.open("/ezCircular/circularRead.do?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate + "&brdName=" + encodeURIComponent("${brdNm}"), "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        	}
                
                //클릭했을때 그아이디에 해당하는 
                $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCircular/confirmStatus.do",
					data : { circularId 	: circularId 
							},
					success: function(xml){
						
					}     			
				});
                
	        }
		
		    function event_HeaderCheckBoxClick(obj) {
		        var SelList = new ListView();
		        SelList.LoadFromID("BoardList");
		        if (obj.checked) {
		            for (var i = 0; i < SelList.GetRowCount() ; i++) {
		                SelList.GetDataRows()[i].childNodes[0].childNodes[0].checked = true;
		                SelList.GetDataRows()[i].setAttribute("selected", true);
		                SelList.GetDataRows()[i].style.backgroundColor = m_strColorSelect;
		                strListInfo += SelList.GetDataRows()[i].childNodes[0].childNodes[0].id;
		            }
		        }
		        else {
		            for (var i = 0; i < SelList.GetRowCount() ; i++) {
		                SelList.GetDataRows()[i].childNodes[0].childNodes[0].checked = false;
		                SelList.GetDataRows()[i].setAttribute("selected", false);
		                SelList.GetDataRows()[i].style.backgroundColor = m_strColorDefault;
		                strListInfo = "";
		            }
		        }
		    }
		
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		
		    function refresh_onclick() {
		        //window.location.href = "/ezBoard/boardItemListMyList.do";
		    	window.location.href = "/ezcircular/newCircular.do";
		    }
		
		    function MemberInfo_onclick(pUserID) {
		        if (gubun == "2") return;
		        var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
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
	            //BoardSearchOptionHidden();
	            getBoardList();
	        }

	        function onkeydown_start_search(evt) {
	            if (evt.keyCode == "13") {
	                search("quick");
	            }
	        }
	
	        var writeboardselect_modal_dialogArguments = new Array();
	        function CircularWrite_onclick() {
	        	var feature = GetOpenPosition(820, 700);
	        	url = "/ezCircular/circularWrite.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=&brdName=";
	        	var OpenWin = window.open(url, "", "width=800, height=800, status=no, toolbar=no, menubar=no,location=no,resizable=1"+feature);
                OpenWin.focus();     
	        }
	
	        function keyword_Clear() {
	            document.getElementById('txt_keyword').value = "";
	        } 
	    </script>
	</head>
	<body class="mainbody" style="overflow:hidden;">
	    <h1>신규 회람판<span id="mailBoxInfo"></span>
	        <span style="float:right;font-weight:normal;color:black;">
			  <input id="txt_keyword" style="width:150px;" value='' onfocus="if(this.value == '제목/댓글 검색') this.value='';" onblur="if(this.value == '') this.value='제목/댓글 검색';" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search('quick')"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onClick="CircularWrite_onclick()">회람작성</span></li>
	            <li><span onClick="Confirm_onclick()">확인완료</span></li>
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
	    <%--     	<table width="100%" class="mainlist" id="BoardList" border="0" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="ItemPreviewRead_click" rowondblclick="ItemRead_onclick(this)">
					<thead id="BoardList_THEAD">
	        			<tr id="BoardList_TH">
	        				<th width="1" class="h4_center" id="BoardList_TH_0" style="overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;" bgcolor="#cccccc">
	        					<input id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;" type="checkbox">
	        				</th>
	        				<th width="20" class="h5_center" id="BoardList_TH_1" style="text-align: center; overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;">
	        					중요
	        				</th>
	        				<th width="20" class="h5_center" id="BoardList_TH_2" style="text-align:center; overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;">
	        					첨부
	        				</th>
	        				<th width="20" class="h5_center" id="BoardList_TH_3" style="text-align:center; overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;">
	        					상태
	        				</th>
	        				<th width="400" class="h5_center" id="BoardList_TH_4" style="overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;" writerindex="4">
	        					제목
	        				</th>
	        				<th width="20" class="h5_center" id="BoardList_TH_5" style="overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;">
	        					작성자
	        				</th>
	        				<th width="50" class="h5_center" id="BoardList_TH_6" style="text-align: center; overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;">
	        					작성일
	        				</th>
	        				<th width="20" class="h5_center" id="BoardList_TH_7" style="text-align: center; overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;">
	        					확인
	        				</th>
	        				<th width="50" class="h5_center" id="BoardList_TH_8" style="text-align: center; overflow: hidden; white-space: nowrap; cursor: pointer; -ms-text-overflow: ellipsis;">
	        					확인일
	        				</th>
	        				</tr>
	        			</thead>
	        			<tbody style="background-color: rgb(255, 255, 255);">
	        			<c:forEach var="item" items="${list}" varStatus="status">
	        				<tr id="BoardList_TR_0" style="cursor: pointer; background-color: rgb(255, 255, 255);" DATA1="{9716dd3d-09b9-6b24-4621-598be6cabfae}" DATA2="{ee093f1b-364c-4f65-84c6-30fba5bd3362}" selected="false" DATA3="kkk" DATA4="0" DATA5="0" DATA6="" DATA7="N" DATA8="1" DATA9="" DATA10="5" DATA11="0">
	        				
	        					<td style="text-align: left; overflow: hidden; white-space: nowrap; -ms-text-overflow: ellipsis;">
	        						<input id="{ee093f1b-364c-4f65-84c6-30fba5bd3362},kkk;" style="margin: 0px; padding: 0px; width: 13px; height: 13px; vertical-align: middle;" type="checkbox" value="${item.circularId}">
	        					</td>
	        					<td id="circularId"  style="text-align: left; overflow: hidden; display:none;" onclick="ItemRead_onclick(this)">
	        						${item.circularId}
	        					</td>
	        					<td style="text-align: center; overflow: hidden; white-space: nowrap; -ms-text-overflow: ellipsis;" onclick="ItemRead_onclick(this)">
	        						${item.importance == '0' ? '일반' : '중요'}
	        					</td>
	        					<td style="margin: 0px; padding: 0px; width: 80%; text-align: center; overflow: hidden; font-weight: bold; white-space: nowrap; -ms-text-overflow: ellipsis;" onclick="ItemRead_onclick(this)">
	        						${item.hasFile == '0' ? ' ' : "<img src='/images/newAttach.gif'>"}
	        					</td>
	        					<td style="text-align: center; overflow: hidden; white-space: nowrap; -ms-text-overflow: ellipsis;" onclick="ItemRead_onclick(this)">
	        						${item.status == '0' ? '진행중' : '종료'}
	        					</td>
	        					<td style="text-align: left; overflow: hidden; white-space: nowrap; -ms-text-overflow: ellipsis;" onclick="ItemRead_onclick(this)">
	        						${item.title}
	        					</td>
	        					<td style="width: 120px; text-align: left; overflow: hidden; white-space: nowrap;" onclick="ItemRead_onclick(this)">
	        						${item.memberId}
	        					</td>
	        					<td style="text-align: center; overflow: hidden; white-space: nowrap; -ms-text-overflow: ellipsis;" onclick="ItemRead_onclick(this)">
	        						${item.regDate}
	        					</td>
	        					<td style="text-align: center; overflow: hidden; white-space: nowrap; -ms-text-overflow: ellipsis;" onclick="ItemRead_onclick(this)">
	        						${item.confirmStatus}
	        					</td>
	        					<td style="text-align: center; overflow: hidden; white-space: nowrap; -ms-text-overflow: ellipsis;" onclick="ItemRead_onclick(this)">
	        						${item.confirmDate}
	        					</td>
	        				</tr>
	        			</tbody>
	        			</c:forEach>
	        		</table> --%>
	             <div id="lvBoardList">
	            </div> 
	        </div>
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
	                    <div id="Preview_HeaderH" style="border-bottom: solid 1px #dadada; width: 100%; display: none;">
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
	                    <div id="Preview_HeaderW" style="border-bottom: solid 1px #dadada; display: none;">
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
	                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0; display:none;"></iframe>
	                <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
	            </span>
	        </span>
	    </span>
	
	
	   <%--  <div id="layer_popup" style="width:700px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
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
		</div> --%>
	</body>
</html>