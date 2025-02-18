<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>BoardItemList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/datepicker.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/composeappt.js')}"></script>
		<style>
		#layer_Viewpopup { 
			z-index:1000; 
			margin:0px; 
			padding:0px;
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
		        var pMode = "new";
		        var pAdminType = "n";
		        var pUse_Editor = "${useEditor}";
		        var pNoneActiveX = "YES";
		        var starttime;
		        var endtime;
		        var strListInfo = "";
		        // 2024-10-04 조수빈 - 마이게시판, 게시물 승인 화면의 경우 게시판 id가 없어 오류가 발생하여 추가
            	var pBoardID = "";
            	var Read_FG = 'true';
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
		            var height = parseInt(document.documentElement.clientHeight - 200);
		            document.getElementById("divList").style.height = height + "px";
		            window_onunload_Event = true;
		            getBoardList();
		            
			        /* 2020-02-03 홍승비 - 아무것도 선택하지 않은 상태의 하단 미리보기 영역 마진 수정 */
			      	ifrmPreViewW.document.getElementById("ifrmPreViewW_div").style.marginTop = "-2px";
		        };
		        
			    $(document).ready(function() {
			    	var clickOutside;
			    	
			    	if (navigator.userAgent.toLowerCase().indexOf("msie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { 
			    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].document);
			    	} else {
			    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].contentWindow.document);
			    	}	    	
			    	
			    	clickOutside.mouseup(function (e) {
			    		MailOptionHiddenOutside(e);
			    	});
			    	
			    	$($(window.parent.frames['left'].document)).mouseup(function (e) {
			    		MailOptionHiddenOutside(e);
			    	});
			    	
			    	$(parent.document).mouseup(function (e) {
			    		MailOptionHiddenOutside(e);
			    	});
			    	
			    	$(document).mouseup(function (e) {
			    		MailOptionHiddenOutside(e);
			    	});
			    	
			    	$(window.frames['ifrmPreViewH']).mouseup(function (e) {
			    		MailOptionHiddenOutside(e);
			    	});
			    	
			    	$(window.frames['ifrmPreViewW']).mouseup(function (e) {
			    		MailOptionHiddenOutside(e);
			    	});
			    });
		        
		        var Save_unloadSave = false;
		        function Window_onunload() {
		            if (window_onunload_Event && !Save_unloadSave) {
		                var objNode, divStyle, ifrmStyle,listCount;
		                
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
							url : "/ezBoard/boardGeneralListSave2.do",
							data : { userID 	 : SSUserID, 
									 listCount   : listCount,
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
		            idDatepicker.pickerDateFormat = "[yyyy]" + "<spring:message code='ezBoard.t211'/>" + " [MM]" + "<spring:message code='ezBoard.t10000'/>";
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
<%-- 		            idDatepicker.isoDateUTF = "<%=DateTime.Parse(GetLocalTime(System.DateTime.UtcNow.ToShortDateString())).ToString("o")%>"; --%>
<%-- 		            idDatepicker.isoEndDateUTF = "<%=DateTime.Parse(GetLocalTime(System.DateTime.UtcNow.ToShortDateString())).ToString("o")%>"; --%>
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
						dataType : "text",
						async : true,
						url : url,
						data : { boardType   : "A", 
								 pageNum 	 : CurPage, 
								 orderCell 	 : OrderCell, 
								 orderOption : OrderOption,
								 searchQuery : SQLPARADATA
								},
						success: function(xml){
							getBoardList_after(loadXMLString(xml));
						}     			
					});
		        }
		
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
		                var perCnt = getNodeText(perNode);
		
		                listcount.value = perCnt;
		                
		                totalPage = Math.ceil(new Number(lstCnt / perCnt));
		                
		                if (CurPage > totalPage && totalPage != 0) {
		                    CurPage = totalPage;
		                    getBoardList();
		                    return;
		                }
		
		                pTotalCnt = lstCnt;
		
		                makePageSelPage();
		
		                var xmlDoc;
		                if (CrossYN()) {
		                    var xmlLIST = createXmlDom();
		                    var nodeToImport = xmlLIST.importNode(listNode, true);
		                    xmlLIST.appendChild(nodeToImport);
		
		                    xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
		                }else {
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
		                    }else {
		                        if (parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim()) > tempno)
		                            tempno = parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim());
		                    }
		                }
		                tempno = tempno + "";
		
		                if (tempno.length > 4) {
		                    document.getElementById("BoardList_TH_1").style.width = tempno.length * 3 + 22 + "px";
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
		                /* document.getElementById("runtime").innerHTML = "RunTime : <span style='color:black;font-weight:bold'>" + (endtime - starttime) / 1000 + "</span> Sec"; */
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
		            document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span>";
		            strtext = "<div class='pagenavi'>";
		            PagingHTML += strtext;
		            var pageNum = CurPage;
		            if (totalPage > 1 && pageNum != 1) {
		                strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg first disabled'></span>";
		                PagingHTML += strtext;
		            }
		            if (totalPage > BlockSize) {
		                if (pageNum > BlockSize) {
		                    strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
		                    PagingHTML += strtext;
		                }
		                else {
		                    strtext = "<span class='btnimg prev disabled'></span>";
		                    PagingHTML += strtext;
		                }
		            }
		            else {
		                strtext = "<span class='btnimg prev disabled'></span>";
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
		                    strtext = "";
		                    strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
		                    PagingHTML += strtext;
		                }
		                else {
		                    strtext = "";
		                    strtext = strtext + "<span class='btnimg next disabled'></span>";
		                    PagingHTML += strtext;
		                }
		            }
		            else {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg next disabled'></span>";
		                PagingHTML += strtext;
		            }
		            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		                strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg last disabled'></span>";
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
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;
		
		            if (obj.getAttribute("DATA10") == "3" || obj.getAttribute("DATA10") == "4") {
		            	pLeft = (pwidth - 790) / 2;
		                window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=793,width=790,top=" + pTop + ",left=" + pLeft, "");
		            } else if (obj.getAttribute("DATA10") == "7") {
						window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=679,width=764,top=" + pTop + ",left=" + pLeft, "");
		            } else {
	                    window.open("/ezBoard/boardItemView.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		            }
		            
		            /* 2018-07-09 홍승비 - 승인게시판 게시물 읽기 시 즉각적으로 폰트 변화하도록 수정 */
		            for (var i = 0; i < obj.childNodes.length; i++) {
				        if (obj.childNodes[i].style.fontWeight == "bold") {
				            obj.childNodes[i].style.fontWeight = "normal";
						}
			        }
		        }
		
		        function CheckIfHasReplies() {
		            var xmlhttp = createXMLHttpRequest();
		            xmlhttp.open("POST", "/ezBoard/checkIfHasReply.do?itemList=" + encodeURIComponent(strListInfo), false);
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
		            xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")) + "&itemList=" + encodeURIComponent(strListInfo), false);
		            xmlhttp.send();
		
		            if (xmlhttp.responseText == "NO") {
		                alert("<spring:message code='ezBoard.t265'/>");
			            return;
			        } else if (xmlhttp.responseText == "ERROR") {
		                alert("<spring:message code='ezBoard.t1020'/>");
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
		            if (arrList[i].split(",")[1] != SSUserID) {
		                arrList = null;
		                return false;
		            }
		        }
		        arrList = null;
		        return true;
		    }
		
		    function refresh_onclick() {
		        window.location.href = "/ezBoard/boardItemListAppr.do";
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
		            xmlhttp.open("POST", "/ezBoard/setRead.do?boardID=" + encodeURIComponent(pBoardID) + "&itemIDList=" + encodeURIComponent(strItemList), false);
		            xmlhttp.send();
		            xmlhttp = null;
		            refresh_onclick();
		        }
		    }
		    /* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		    // 승인게시물에는 익명게시물이 나타나지 않으므로, gubun 분기 제거함
		    function MemberInfo_onclick(pUserID, pDeptID) {
		        var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
		    }
		    function ReservationItem_onclick() {
		        var OrgBoardParameters = "page=" + CurPage + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=&boardType=" + pBoardType;
		        window.location.href = "/ezBoard/boardReservedItemList.do?orgBoardParameters=" + escape(OrgBoardParameters) + "&boardType=" + pBoardType;
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
		        pSIPUriList = null;
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
/* 		    function CopyItem_onclick() {
	        if (strListInfo == "") {
	            alert("<spring:message code='ezBoard.t201'/>");
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
	            var feature = "height=600px,width=355px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth;
	            feature = feature += GetOpenPosition(355, 600);
	            window.open("/ezBoard/copyBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")), "", feature, "");
	        }
	        var moveboarditem_cross_dialogArguments = new Array();
	        function MoveItem_onclick() {
	            if (strListInfo == "") {
	                alert("<spring:message code='ezBoard.t497'/>");
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
	                var OpenWin = window.open("/ezBoard/moveBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")), "MoveBoardItem_Cross", GetOpenWindowfeature(355, 600));
	                try { OpenWin.focus(); } catch (e) { }
	            }
	            else {
	                var pheigth = window.screen.availHeight;
	                var pwidth = window.screen.availWidth;
	                pheigth = parseInt(pheigth) / 2;
	                pwidth = parseInt(pwidth) / 2;
	                pheigth = pheigth - 200;
	                pwidth = pwidth - 127;
	                var ret = window.showModalDialog("/ezBoard/moveBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")), "", "DialogHeight:600px;DialogWidth:355px;status:no;help:no;edge:sunken;scroll:no");
	
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
	 */
	
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
	            	var txtKeywordVal = document.getElementById("txtKeyword") != null ? document.getElementById("txtKeyword").value : "";
	                if (document.getElementById("txtTitle").value == "" && document.getElementById("txtAbstract").value == "" 
	                && txtKeywordVal == "" && document.getElementById("idDatepicker").value == "" && document.getElementById("_D2").value == "") {
	                    alert("<spring:message code='ezBoard.t192'/>");
	                    return;
	                }
	
	                if (document.getElementById("idDatepicker").value != "" && document.getElementById("_D2").value == "") {
	                    alert("<spring:message code='ezSystem.x0035'/>");
	                    return;
	                }
	                if (document.getElementById("idDatepicker").value == "" && document.getElementById("_D2").value != "") {
	                    alert("<spring:message code='ezSystem.x0036'/>");
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
	            MakeSubCondition(type);
	            getBoardList();
	        }
	
		    function MakeSubCondition(type) {
		        var TYPE = "";
		        var DATA = "";
		        if (type == "quick") {
		        	var selectSearch = document.getElementById('selectType');
	                if (selectSearch.item(0).selected) {
	                    TYPE += "TITLE;";
	                    DATA += "<TITLE><![CDATA[" + document.getElementById("txt_keyword").value.replace("'", "''") + "]]></TITLE>";
	                }
	                else if (selectSearch.item(1).selected) {
	                    TYPE += "WRITERNAME;";
	                    DATA += "<WRITERNAME><![CDATA[" + MakeXMLString(document.getElementById("txt_keyword").value.replace("'", "''")) + "]]></WRITERNAME>";
	                }
	                else if (selectSearch.item(2).selected) {
	                    TYPE += "CONTENT;";
	                    DATA += "<CONTENT><![CDATA[" + document.getElementById("txt_keyword").value.replace("'", "''") + "]]></CONTENT>";
	                }
	                else if (selectSearch.item(3).selected) {
                        TYPE += "KEYWORD;";
                        DATA += "<KEYWORD><![CDATA[" + document.getElementById("txt_keyword").value.replace("'", "''") + "]]></KEYWORD>";
                    }
		        }
		        else {
		            if (document.getElementById("txtTitle").value != "")		// DocTitle
		            {
		                TYPE += "TITLE;";
		                DATA += "<TITLE><![CDATA[" + document.getElementById("txtTitle").value.replace("'", "''") + "]]></TITLE>";
		            }
		
		            if (document.getElementById("txtAbstract").value != "")		// ABSTRACT
		            {
		                TYPE += "ABSTRACT;";
		                DATA += "<ABSTRACT><![CDATA[" + document.getElementById("txtAbstract").value.replace("'", "''") + "]]></ABSTRACT>";
		            }
			                
		            if (document.getElementById("txtKeyword") != null) { // KEYWORD
                        if (document.getElementById("txtKeyword").value != "") {
                             TYPE += "KEYWORD;";
                             DATA += "<KEYWORD><![CDATA[" + document.getElementById("txtKeyword").value.replace("'", "''") + "]]></KEYWORD>";
                        }
                    }
		
		            if (document.getElementById("idDatepicker").value != "")		// StartDate
		            {
		                TYPE += "STARTDATE;";
		                DATA += "<STARTDATE><![CDATA[" + document.getElementById("idDatepicker").value.substring(0, 10) + "]]></STARTDATE>";
		            }
		
		            if (document.getElementById("_D2").value != "")		// EndDate
		            {
		                TYPE += "ENDDATE;";
		                DATA += "<ENDDATE><![CDATA[" + document.getElementById("_D2").value.substring(0, 10) + "]]></ENDDATE>";
		            }
		        }
		        SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
		    }
		    
		    /* 2018-06-28 홍승비 - 승인게시판 스크립트 오류 수정 */
		    function keyword_Clear() {
		        document.getElementById('txt_keyword').value = "";
		    }
		    function onkeydown_start_search(evt) {
		        if (evt.keyCode == "13") {
		            search("quick");
		        }
		    }
		
		    function NewItem_onclick() {
		        var feature = GetOpenWindowfeature(765, 820);
		           window.open("/ezBoard/newBoardItem.do?mode=new&bType=SELECT", "", feature, "");
		    }
		
		    function Appr_onclick(pFlag) {
		        if (strListInfo == ""|| strListInfo === "undefined") {
		            alert("<spring:message code='ezBoard.t198'/>");
		            return;
		        }
		        
		        var strItemList = "";
		        var arrListSet = new Set(); // 좌측 게시물 카운트 갱신을 위한 게시판ID Set
		        arrList = strListInfo.split(";");
		        
		        for (i = 0; i < arrList.length - 1; i++) {
		            strItemList += arrList[i].split(",")[0] + ";";
		            arrListSet.add(document.getElementById(arrList[i] + ";").parentNode.parentNode.getAttribute("DATA1") + ";");
		        }
		        
		        if (pFlag == "C") { // 반려
		        	if(confirm("<spring:message code='ezBoard.pjg02'/>")){
			            var OpenWin = window.open("/ezBoard/boardApprOpinion.do?itemList=" + encodeURIComponent(strItemList) + "&mode=" + pFlag, "BoardApprOpinion", GetOpenWindowfeature(540, 300));
			            try { OpenWin.focus(); } catch (e) { }
		        	}
		        }
		        else { // 승인
		        	if (confirm("<spring:message code='ezBoard.pjg01'/>")) {
			            var xmlhttp = createXMLHttpRequest();
			            xmlhttp.open("POST", "/ezBoard/apprBoardItem.do?itemList=" + encodeURIComponent(strItemList) + "&mode=" + pFlag, false);
			            xmlhttp.send();
			
			            if (xmlhttp.responseText == "OK") {
			                if (pFlag == "Y") {
			                	/* 2023-11-17 홍승비 - 승인게시판의 게시물 승인 시 게시알림메일 발송 기능 추가 */
			                	sendMailForApprList(strItemList);
			                	
			                    alert("<spring:message code='ezBoard.t999002'/>");
			                } else {
			                    alert("<spring:message code='ezBoard.t999009'/>");
			                }
			                
			                if (CurPage == totalPage) {
			                    var SelList = new ListView();
			                    SelList.LoadFromID("BoardList");
			                    var DeleteCount = strItemList.split(';').length - 1;
			                    if (SelList.GetRowCount() == DeleteCount) {
			                        CurPage = CurPage - 1;
			                    }
			                }
			                if (CurPage == 0) CurPage = 1;
			                
	// 		                getBoardList();
							/* 2019-04-03 홍승비 - 게시물 승인 리스트에서 승인하는 경우에도 좌측 게시물 카운트 갱신되도록 수정 */
							var arrListStr = "";
					        arrListSet.forEach(function callback (value1, value2, Set) {
					        	arrListStr += value1;
					        });
							try { // try ~ catch로 감싸지 않으면 연속된 함수가 동작하지 않음
								leftCountRf(arrListStr);
							} catch (e) {}
				            try {
				                refresh_onclick();
				            } catch (e) {}
						}
		        	}
		        }
		        
		        var applyCount = "0";
		        
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getApplyCount.do",
					success: function(text){
						applyCount = text;
					}     			
				});
		        
		       	$(window.parent.frames['left'].document.getElementById("applyCount")).text(" " + applyCount);
		    }
		    function Appr_onclick_Complete() {
		
		    }
		    
			/* 2020-02-03 홍승비 - 하단 미리보기 사용 시 아무 게시물도 선택되지 않은 상태라면 최소 높이 설정 */
		    function checkPreViewWSrc() {
	    	  if (document.getElementById("ifrmPreViewW").src.indexOf("/blank") > -1) {
	            	document.getElementById("ifrmPreViewW").style.minHeight = "130px";
	            } else { // 게시물 선택 시 최소 높이 해제
	            	document.getElementById("ifrmPreViewW").style.minHeight = "";
	            }
		    }
			
		    /* 2023-11-17 홍승비 - 승인게시판의 게시물 승인 시 게시알림메일 발송 기능 추가, 메일발송을 위한 총괄함수 구현 */
        	function sendMailForApprList(pStrItemList) {
		   		var itemIDs = pStrItemList.split(";"); // 게시물의 ID 배열
		   		
		   		// 각 게시물마다 필요한 파라미터를 전달하여 메일발송 루프 진행
		   		for (var i = 0; i < itemIDs.length; i++) {
		   			var tItemID = itemIDs[i];
		   			var itemTR = $("tr[data2='" + tItemID + "']"); // 게시물 TR
		   			
		   			if (itemTR.length > 0) {
			   			var tBoardID = itemTR.attr("data1");
			   			var tIsAllGroupBoard = itemTR.attr("isallgroupboard");
			   			var tStrUpperItemIDTree = itemTR.attr("upperitemidtree");
			   			var tParentWriteDate = itemTR.attr("parentwritedate");
			   			var tDocNo = itemTR.attr("docno");
			   			
			   			// 해당 게시판의 관리자에게 게시알림 발송 (게시판 권한설정 > 관리자 권한자인 경우 '게시 알림' 옵션)
			   			sendPostNotiForAdmin(tBoardID, tItemID);
			   			
			   			// 답변게시물이 아닌 경우
			   			if (tParentWriteDate == tDocNo) {
			   				// 해당 게시판의 일반 사용자(접근 권한자)에게 게시알림 발송 (게시판 일반설정 > '게시알림' 옵션)
			   				sendBoardAlert("new", tBoardID, tItemID, tIsAllGroupBoard);
			   			}
			   			else { // 답변게시물인 경우
			   				// 해당 게시물의 부모게시물 작성자에게 답변알림 발송 (게시판 일반설정 > '답변알림' 옵션)
			   				sendReplyNotice(tBoardID, tItemID, tStrUpperItemIDTree);
			   			}
		   			}
		   		}
		    }
			
        	/* 2023-11-17 홍승비 - 관리자 권한자의 '게시 알림' 옵션에 대한 게시 알림 함수 추가, 비동기로 백그라운드 동작 */
        	function sendPostNotiForAdmin(pBoardID, pItemID) {
        		$.ajax({
        			type : "POST",
        			dataType : "text",
        			async : true,
        			url : "/ezBoard/sendPostNotiForAdmin.do",
        			data : {
        				boardID : pBoardID,
        				itemID : pItemID
        			}
        		});
        	}
        	
        	/* 2023-11-17 홍승비 - 일반 사용자(접근 권한자)의 '게시알림' 옵션에 대한 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
        	function sendBoardAlert(pMode, pBoardID, pItemID, pIsAllGroupBoard) {
        		$.ajax({
        			type : "POST",
        			dataType : "text",
        			async : true,
        			url : "/ezBoard/sendBoardAlert.do",
        			data : {
        				mode : pMode,
        				boardID : pBoardID,
        				itemID : pItemID,
        				isAllGroupBoard : pIsAllGroupBoard
        			}
        		});
        	}
        	
        	/* 2023-11-17 홍승비 - 답변게시물의 부모게시물 작성자의 '답변알림' 옵션에 대한 게시판 알림 함수 추가, 비동기로 백그라운드 동작 */
        	function sendReplyNotice(pBoardID, pItemID, pStrUpperItemIDTree) {
        		$.ajax({
        			type : "POST",
        			dataType : "text",
        			async : true,
        			url : "/ezBoard/sendReplyNotice.do",
        			data : {
        				boardID : pBoardID,
        				itemID : pItemID,
        				itemTreeID : pStrUpperItemIDTree
        			}
        		});
        	}
        	
	    </script>
	</head>
	<body class="mainbody" style="overflow:hidden;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	    <h1><spring:message code='ezBoard.t999001'/><span id="mailBoxInfo"></span>
	        <span class="searchForm">
				<select id="selectType" class="text" style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezBoard.t208'/></option>
		    		<option value="rad_Writer"><spring:message code='ezBoard.t223'/></option>
		    		<option value="rad_Content"><spring:message code='ezBoard.garm01'/></option>
		    		<option value="rad_Keyword"><spring:message code='ezApprovalG.t1200'/></option>
		    	</select>
				<input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
				<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search('quick')"></a>
			</span>
	    </h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onClick="Appr_onclick('Y')"><spring:message code='ezBoard.t999005'/></span></li>
	            <li><span onClick="Appr_onclick('C')"><spring:message code='ezBoard.t999014'/></span></li>
	            <li style="display:none;"><span id="SearchOption" mode="off" onClick="doLayerPopup(this)"><spring:message code='ezBoard.t188'/></span></li>
	            <!-- <li id="right">
	            	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
	            	<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
					<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this, 'N');" />
				</li> -->      
				<div id="right" class="sub_frameIcon" style="float:right">	
					<div class="sub_frameIconUL">
					   	<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE')"></span></p>
					    <p class="frameIconLI"><span class="icon16 btn_bottomframe" id="PreViewBottom" onclick="PreviewRayerChange('W')"></span></p>
					    <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H')"></span></p>
					</div>
					<div class="sub_frameIconUL02">
					  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="maillistoptiondiv" onclick="MailOptionView(this, 'N');"></span></p>  
					</div>
				 </div>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	    <div id="layer_Viewpopup" style="width: 150px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
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
	        <!-- <div id='runtime' style="color:#666;padding-top:5px"></div> -->
	        <div id="tblPageRayer" style="text-align:center"></div>
	    </span>
	    <div id="PreviewRayerH" style="border:0px; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
		        <div class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block;">
		            <p class="hbar_dotted">
		                <img src="/images/prevview_hbar_dotted.gif">
		            </p>
		        </div>
		        <div id="PreContent_RayerH" style="position: absolute; border: 0px; margin-left:7px;">
		            <div class="previewmail">
		                <div class="previewmail_info">
		                	<dl class="previewmailDL" id="Preview_HeaderH" style="display:none;">
								<dt class="prepic"><img id="userImgH" src="/images/kr/main/bestEmployee_pic_none.png" width="55px" height="55px"></dt>
								<dd class="pretext">
									<ul class="pretextUL">
										<li class="preSubject"><span class="popup_open" onclick="MailReadOpen();"><img src="/images/kr/cm/btn_newpopup.gif" title="<spring:message code='ezEmail.t99000001' />" alt="<spring:message code="ezEmail.t99000001" />"></span><span class="subjectText" id="PreH_subject"><span class="subjectText" id="PreH_sub_subject"></span></span></li>
										<li class="preT_list"><span class="t_left"><span class="cblack"><spring:message code="ezBoard.t223" /></span> : <span id="PreH_MailReceiver"></span></span><span class="t_right"><span class="cblack"><spring:message code="ezBoard.t224" /> : </span><span id="PreH_date"><span id="PreH_sub_date" style="display:none;"></span></span></span></li>
										
									</ul>
								</dd>
							</dl>
		                </div>
	                <iframe id="ifrmPreViewH_photo" name="ifrmPreViewH_photo" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: none;"></iframe>
	                <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
	            </div>
	        </div>
	    </div>
		<div id="PreviewRayerW" style="border: 0px; width: 100%; height: 300px; overflow: hidden; display: none;">
		        <div onmousedown="PreviewW_onMouserDown(event);" style="cursor: s-resize; width: 100%; display: list-item;" class="previewmail_bar" name="PreviewBar" id="PreviewBar">
		            <img src="/images/prevview_bar_dotted.gif">
		        </div>
		        <div id="PreContent_RayerW" style="display: block;">
		            <div class="previewmail">
		                <div class="previewmail_info" style="display: block; width: 100%;">
		                	<dl class="previewmailDL" id="Preview_HeaderW" style="display:none;">
								<dt class="prepic"><img id="userImgW" src="/images/kr/main/bestEmployee_pic_none.png" width="55px" height="55px"></dt>
								<dd class="pretext">
									<ul class="pretextUL">
										<li class="preSubject"><span class="popup_open" onclick="MailReadOpen();"><img src="/images/kr/cm/btn_newpopup.gif" title="<spring:message code='ezEmail.t99000001' />" alt="<spring:message code="ezEmail.t99000001" />"></span><span class="subjectText" id="PreW_subject"><span class="subjectText" id="PreW_sub_subject"></span></span></li>
										<li class="preT_list"><span class="t_left"><span class="cblack"><spring:message code="ezBoard.t223" /></span> : <span id="PreW_MailReceiver"></span></span><span class="t_right"><span class="cblack"><spring:message code="ezBoard.t224" /> : </span><span id="PreW_date"><span id="PreW_sub_date" style="display:none;"></span></span></span></li>
										
									</ul>
								</dd>
							</dl>
		                </div>
	                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0; display:none;"></iframe>
	                <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="<spring:message code='main.kms4' />" onLoad="checkPreViewWSrc();" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
	            </div>
	        </div>
	    </div>
	
	    <div id="layer_popup" style="width:700px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
	          <div class="popupwrap1">
	            <div class="popupwrap2">
	        <table class="content">
	        <tr>
	            <th style="text-align:center"><spring:message code='ezBoard.t208'/></th>
	            <td><input type="text" id="txtTitle" style="width:98%" value=""></td>
	        </tr>  
            <tr>
                <th style="text-align:center"><spring:message code='ezApprovalG.t1200' /></th>
                <td><input type="text" id="txtKeyword" style="width:100%" value=""></td>
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