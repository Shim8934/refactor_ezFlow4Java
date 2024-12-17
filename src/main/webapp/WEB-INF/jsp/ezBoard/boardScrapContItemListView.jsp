<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>BoardScrapContItemList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- layer popup -->
		<link rel="stylesheet"  href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>

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
		        var useRunTime = "${useRunTime}"
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
		        var pMode = "scrap";
		        var starttime;
		        var endtime;
		        var pAdminType = "n";
		        var Use_OneLineCount = "${use_oneLineCount}";
		        var pUse_Editor = "${useEditor}";
		        var pNoneActiveX = "YES";
		        var strListInfo = "";
		        var scrapContID = "${scrapContID}";
		        var scrapContTitle = "<c:out value='${scrapContTitle}'/>";
		        var g_bPrevShow = false;
		        window.onunload = Window_onunload;
		        var window_onunload_Event = false;
				var isOpenWindow;
				var scrapBoard = "YES";
				var pBoardID = "";
				var Read_FG = 'true';

		        window.onresize = function () {
		            var height = parseInt(document.documentElement.clientHeight - 320);
		            Window_resize();
		
		        };
		        document.onselectstart = function () { return false; };
		        window.onload = function () {
		        	if (useRunTime != "YES") {
		        		$("#runtime").css("display", "none");
		        	}
		        	
		            if (navigator.userAgent.indexOf('Firefox') != -1) {
		                document.body.style.MozUserSelect = 'none';
		                document.body.style.WebkitUserSelect = 'none';
		                document.body.style.khtmlUserSelect = 'none';
		                document.body.style.oUserSelect = 'none';
		                document.body.style.UserSelect = 'none';
		            }

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
		        
			    /* 2019-08-06 홍승비 - 게시물 삭제 등 리프레시 동작 시 미리보기 영역 틀어짐 수정 */
		        var Save_unloadSave = false;
		        function Window_onunload() {
		            if (window_onunload_Event && !Save_unloadSave) {
		              /*   var divStyle, ifrmStyle, listCount; */
						var divStyle;
						var listCount = 0;
		
		                if (document.getElementById("listcount") != null){
			            	listCount = document.getElementById("listcount").value;
			            } else {
			            	listCount = 20;
			            }
		                
		                if (pPreviewShow_HOW == "W") {
		                    /* divStyle = parseInt(document.getElementById("divList").style.height);
		                    ifrmStyle = parseInt(document.getElementById("ifrmPreViewW").style.height);
		                    divStyle = parseInt((divStyle * 100) / (divStyle + ifrmStyle)); */
		                	divStyle = Math.round(pMailListDiv);
		                }
		                else if (pPreviewShow_HOW == "H") {
		                 /*    divStyle = parseInt(document.getElementById("divList").scrollWidth);
		                    ifrmStyle = parseInt(document.getElementById("ifrmPreViewH").scrollWidth);
		                    divStyle = parseInt((divStyle * 100) / (divStyle + ifrmStyle)); */
		                	divStyle = Math.round(pMailListDiv_H);
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
		                
		    		    /* 2018-08-11 장진혁 - 레이어팝업 생성된 상태에서 backspace 누를시 왼쪽프레임 부분 딤 처리 없애기 */
	    	        	if (parent.frames["left"]) {
	    	        		if (parent.frames["left"].document.getElementById("blockLeft")) {
	    	        			$(parent.frames["left"].document.body).css("overflow", "");
	    	        	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
	    	        		}
	    	        	} else if (parent.frames["attitude_menu"]) {
	    	        		if (parent.frames["attitude_menu"].document.getElementById("blockLeft")) {
	    	        	    	$(parent.frames["attitude_menu"].document.getElementById("blockLeft")).remove();
	    	        		}
	    	        	}
	    	        	      
	    	        	if (parent.parent.frames["left"]) {
	    	        		if (parent.parent.frames["board_menu"]) {  		  
	    	        			$(parent.parent.frames["board_menu"].document.body).css("overflow", "");
	    	        			$(parent.parent.frames["board_menu"].document.getElementById("blockLeft")).remove();
	    	        			$(parent.parent.frames["board_main"].document.getElementById("blockTop")).remove();
	    	        		} else if (parent.parent.frames["left"].document.getElementById("blockLeft")) {  		  
	    	        			$(parent.parent.frames["left"].document.body).css("overflow", "");
	    	        			$(parent.parent.frames["left"].document.getElementById("blockLeft")).remove();
	    	        			$(parent.parent.frames["right"].document.getElementById("blockTop")).remove();
	    	        		}
	    	        	}
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
						data : { boardType   : "M", 
								 pageNum 	 : CurPage, 
								 orderCell 	 : OrderCell, 
								 orderOption : OrderOption,
								 searchQuery : SQLPARADATA,
								 mode        : "scrap",
								 scrapContID : scrapContID
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
		
		                /* 2019-08-06 홍승비 - 게시물 리스트 호출 후  strListInfo 초기화 */
		                strListInfo = "";
		                var scrapNo = 0;
		                for (var i = 0; i < GetElementsByTagName(xmlDoc, "ROW").length; i++) {
		                    if (CrossYN()) {
		                        if (parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim()) > scrapNo)
		                        	scrapNo = parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].textContent.trim());
		                    }
		                    else {
		                        if (parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim()) > scrapNo)
		                        	scrapNo = parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim());
		                    }
		                }
		                scrapNo = scrapNo + "";
		
		                if (scrapNo.length > 4) {
		                    document.getElementById("BoardList_TH_1").style.width = scrapNo.length * 3 + 22 + "px";
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
		            document.getElementById("tblPageRayer").innerText = "";
		            document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span style='color:#017BEC;'>" + totalCount + "</span>";
		            strtext = "<div class='pagenavi'>";
		            PagingHTML += strtext;
		            var pageNum = CurPage;
		            if (totalPage > 1 && pageNum != 1) {
		                strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg first disabled'></span>"
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
		            
			        if (MaxNum == 0) {
			        	PagingHTML += "<span class='on'>" + 1 + "</span>";
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
					if(obj.getAttribute("DATA13") == "N"){
						alert("<spring:message code='ezBoard.t501'/>");
						return;
					}
					
			        var pheight = window.screen.availHeight;
			        var pwidth = window.screen.availWidth;
			        var pTop = (pheight - 720) / 2;
			        var pLeft = (pwidth - 790) / 2;
			        
			        for (var i = 0; i < obj.childNodes.length; i++) {
			        	if (obj.getAttribute("DATA9") != "1" && obj.childNodes[i].style.fontWeight == "bold")
			        		obj.childNodes[i].style.fontWeight = "normal";
			        }

			        if (obj.getAttribute("DATA10") == "4" || obj.getAttribute("DATA10") == "3") {
						isOpenWindow = window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL" + "&scrapContID=" + scrapContID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=770,width=920,top=" + pTop + ",left=" + pLeft, "");
			        } else if (obj.getAttribute("DATA10") == "7") {
						isOpenWindow = window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL" + "&scrapContID=" + scrapContID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=679,width=890,top=" + pTop + ",left=" + pLeft, "");
		            } else {
						isOpenWindow = window.open("/ezBoard/boardItemView.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL" + "&scrapContID=" + scrapContID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=890,top=" + pTop + ",left=" + pLeft, "");
			        }
		        }
		        
		        function DeleteItem() {
		            var xmlhttp = createXMLHttpRequest();
		            xmlhttp.open("POST", "/ezBoard/deleteScrapContItemList.do?itemList=" + encodeURIComponent(strListInfo) + "&mode=" + pMode + "&scrapContID=" + scrapContID, false);
		            xmlhttp.send();

					if (xmlhttp.responseText == "error") {
						alert("<spring:message code='ezBoard.t1020'/>");
						return;
					}
		
		            xmlhttp = null;
		            
	                if ((document.getElementById("PreviewRayerH").style.display != "none" && document.getElementById("PreviewRayerH").style.display != "") ||
	                		(document.getElementById("PreviewRayerW").style.display != "none" && document.getElementById("PreviewRayerW").style.display != "")) {
			        	refresh_onclick();
			        	return;
					}
		            
		            getBoardList();
		        }
		
		        function ReplaceText(orgStr, findStr, replaceStr) {
		            var re = new RegExp(findStr, "gi");
		            return (orgStr.replace(re, replaceStr));
		        }
		
		        function refresh_onclick() {
		            window.location.href = "/ezBoard/getBoardScrapContItemListView.do?scrapContID=" + scrapContID + "&scrapContTitle=" +  encodeURIComponent(scrapContTitle) + "&page=" + CurPage;
		        }

		    function MemberInfo_onclick(pUserID, pDeptID) {
				if(pUserID == "null"){
					return;
				}

		        var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
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
		        var scrap = document.getElementById("lvBoardList").childNodes[0].childNodes[0].childNodes[0].childNodes.length;
		
		        for (var i = 0; i < scrap; i++) {
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
		            alert("<spring:message code='ezBoard.kmh15'/>");
		            return;
		        }
		     
		        var ret = confirm("<spring:message code='ezBoard.kmh16'/>");
		        if (ret)
		            DeleteItem();
		
		    }

			function search(type) {
				if (type == "quick") {
					if (document.getElementById("txt_keyword").value == "") {
						alert("<spring:message code='ezBoard.t192' />");
						return;
					}
				}
				CurPage = "1";
				MakeSubCondition();
				getBoardList();
			}
		
		    function MakeSubCondition() {
		        var TYPE = "";
		        var DATA = "";
		        if (document.getElementById("txt_keyword").value != "") {
					var selectSearch = document.getElementById('selectType');
	                if (selectSearch.item(0).selected) {
	                    TYPE += "TITLE;";
	                    DATA += "<TITLE><![CDATA[" + document.getElementById("txt_keyword").value + "]]></TITLE>";
	                }
	                else if (selectSearch.item(1).selected) {
	                    TYPE += "WRITERNAME;";
	                    DATA += "<WRITERNAME><![CDATA[" + MakeXMLString(document.getElementById("txt_keyword").value) + "]]></WRITERNAME>";
	                }
	            }
		        SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
		    }
		    
		    function keyword_Clear() {
		        document.getElementById('txt_keyword').value = "";
		    }
		    function onkeydown_start_search(evt) {
		        if (evt.keyCode == "13") {
		            search("quick");
		        }
		    }
		    
		    function MailReadOpen_scrap() {
	    	    var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
		        

		        if (previewType == "PHOTO" || (selobj.getAttribute("DATA10") == "3" || selobj.getAttribute("DATA10") == "4")) {
		    		if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
		    				var height = 789;
		    		} else {
		    				var height = 785;
		    		}
		    		
		    		pTop = (pheight - 789) / 2;
		    		pLeft = (pwidth - 790) / 2;
		    		window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")) + "&scrapContID=" + scrapContID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height +",width=920,top=" + pTop + ",left=" + pLeft, "");
		        } else if (previewType == "MOVIE" || selobj.getAttribute("DATA10") == "7" ) {
		        	 pTop = (pheight - 679) / 2;
		             window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")) + "&scrapContID=" + scrapContID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=679,width=890,top=" + pTop + ",left=" + pLeft, "");
		        } else {
		            window.open("/ezBoard/boardItemView.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(selobj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(selobj.getAttribute("DATA1")) + "&scrapContID=" + scrapContID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=890,top=" + pTop + ",left=" + pLeft, "");
		        }
		    }
		    
			/* 2020-02-03 홍승비 - 하단 미리보기 사용 시 아무 게시물도 선택되지 않은 상태라면 최소 높이 설정 */
		    function checkPreViewWSrc() {
	    	  if (document.getElementById("ifrmPreViewW").src.indexOf("/blank") > -1) {
	            	document.getElementById("ifrmPreViewW").style.minHeight = "130px";
	            } else { // 게시물 선택 시 최소 높이 해제
	            	document.getElementById("ifrmPreViewW").style.minHeight = "";
	            }
		    }

			/* 2023-04-06 기민혁 - itemview창이 열려있을때 미리보기 창이 열려 있으면  미리보기에서 좋아요 싫어요 이미지 및 개수 변경  */
			function refreshLikeAndDisLike(result,checked,gubun) {
				if($("#PreviewRayerH").css("display") == "none" && $("#PreviewRayerW").css("display") == "none"){
					return;
				}else if ($("#PreviewRayerH").css("display") != "none" && $("#PreviewRayerW").css("display") == "none"){
					if($("#ifrmPreViewH").css("display") != "none"){
						var refreshLikeAndDisLikeH = document.getElementById("ifrmPreViewH");
					}else{
						var refreshLikeAndDisLikeH = document.getElementById("ifrmPreViewH_photo");
					}
					refreshLikeAndDisLikeH.contentWindow.refreshLikeAndDisLike(result,checked,gubun);
				}else if ($("#PreviewRayerW").css("display") != "none" && $("#PreviewRayerH").css("display") == "none"){
					var refreshLikeAndDisLikeW = document.getElementById("ifrmPreViewW");
					refreshLikeAndDisLikeW.contentWindow.refreshLikeAndDisLike(result,checked,gubun);
				}
			}

			/* 2023-04-06 기민혁 - itemview창이 열려있을때 미리보기 에서 좋아요 싫어요 클릭시 itemview 이미지 및 개수 변경  */
			function refreshLikeAndDisLikeOpen(result,checked,gubun) {
				if(isOpenWindow != undefined ){
					isOpenWindow.refreshLikeAndDisLikeOpen(result,checked,gubun);
				}else{
					return;
				}
			}
			
	    </script>
	</head>
	<body class="mainbody" style="overflow:hidden;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	    <h1><c:out value='${scrapContTitle}'/><span id="mailBoxInfo"></span>
	        <span class="searchForm">
	         	<select id="selectType" class="text" style="width:80px; height:27px; border-color: #c8c8c8;">
					<option selected value="rad_Subject"><spring:message code='ezBoard.t208'/></option>
		    		<option value="rad_Writer"><spring:message code='ezBoard.t223'/></option>
		    	</select>
			  <input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	          <a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search('quick')"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onClick="DeleteItem_onclick()"><spring:message code='ezBoard.kmh14'/></span></li>
	            <li><span class="icon16 icon16_refresh" onClick="refresh_onclick()"></span></li>
				<div id="right" class="sub_frameIcon" style="float:right">	
					<div class="sub_frameIconUL" style="width: 58px !important;">
					   	<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE')"></span></p>
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
	        <div id='runtime' style="color:#666;padding-top:5px"></div>
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
										<li class="preSubject"><span class="popup_open" onclick="MailReadOpen_scrap();"><img src="/images/kr/cm/btn_newpopup.gif" title="<spring:message code='ezEmail.t99000001' />" alt="<spring:message code="ezEmail.t99000001" />"></span><span class="subjectText" id="PreH_subject"><span class="subjectText" id="PreH_sub_subject"></span></span></li>
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
	</body>
</html>
