<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
		<script type="text/javascript">
			var pBoardID = '<c:out value="${boardID}"/>';
		    var SSUserID = "${userInfo.id}";    
		    var CurPage = "${boardInfo.page}";
		    var totalPage = "${boardInfo.totalPage}";
		    var strListInfo = "";
		    var strBoardListInfo = "";
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
		    var pBoardType = '<c:out value="${boardInfo.boardType}"/>';
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
		    var pAdminType = "n";
		    var pButtonHidden = '<c:out value="${boardInfo.buttonHidden}"/>';
		    var pNoneActiveX = "YES";
		    var useRunTime = "${useRunTime}"
		    var useNotReadCnt = "${useNotReadCnt}";
		    	
			var window_onunload_Event = false;
			window.onunload = Window_onunload;
			
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
		        getBoardList();
		        window_onunload_Event = true;
		        
		        /* 2020-02-03 홍승비 - 아무것도 선택하지 않은 상태의 하단 미리보기 영역 마진 수정 */
		      	ifrmPreViewW.document.getElementById("ifrmPreViewW_div").style.marginTop = "-2px";
		    }
		    
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
		    
		    /* 2018-09-17 홍승비 - 새게시물탭에서 설정한 미리보기 비율 저장 */
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
		
		    function getBoardList() {
		        starttime = new Date().getTime();
		        
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/getBoardList.do",
					data : { boardType   : pBoardType, 
							 boardId 	 : pBoardID, 
							 pageNum 	 : CurPage, 
							 orderCell 	 : OrderCell, 
							 orderOption : OrderOption
							},
					success: function(xml){
						getBoardList_after(loadXMLString(xml));
					}        			
				});	
		    }
		
		    var firstFlag = false;
		    var allListCnt = "";
		    function getBoardList_after(xml) {
// 		        try {
		            if (GetElementsByTagName(SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA"), "ROW").length == 0) {
		                if (CurPage > 1) {
		                    CurPage = CurPage - 1;
		                    getBoardList();
		                    return;
		                }
		            }
		            var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
		            var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
		            var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
		            
		            /* 2018-09-17 홍승비 - 새게시물탭에서도 저장된 미리보기 비율 적용 */
		            pMailListDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWLIST")));
		            pMailPreVDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWCONTENT")));
		            pMailListDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHLIST")));
		            pMailPreVDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHCONTENT")));
		
		            pPreviewShow_HOW = getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWTYPE"));
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
		            } else {
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

		            allListCnt = GetElementsByTagName(xmlDoc, "ROW").length;

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
		                document.getElementById("BoardList_TH_1").style.width = tempno.length * 3 + 22 + "px";
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
// 		        }
// 		        catch (e) {
// 		            alert("getBoardList_after : " + e.description);
// 		        }
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
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
		
		        if (obj.getAttribute("DATA10") == "3" || obj.getAttribute("DATA10") == "4") {
		        	pLeft = (pwidth - 790) / 2;
					window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=793,width=790,top=" + pTop + ",left=" + pLeft, "");
	            } else if (obj.getAttribute("DATA10") == "7") {
					window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=679,width=764,top=" + pTop + ",left=" + pLeft, "");
	            } else {
					window.open("/ezBoard/boardItemView.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	            }
		        //}
		        //getBoardList();
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
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(strListInfo), false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		        	alert(strLang176);
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
		        /*if (setReadFlag) {
		            if (Number(allListCnt) == Number(SetReadCheckCnt)) {
		                if (CurPage > 1)
		                    CurPage = CurPage - 1;
		            }
		            setReadFlag = false;
		        }*/
		        window.location.href = "/ezBoard/boardItemList_all.do?page=" + CurPage.toString() + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=&boardType=" + pBoardType;
		    }
		    
		    /* 2019-07-04 홍승비 - 읽음표시 시 strListInfo가 아닌 실시간 체크박스를 확인하도록 수정 */
		    /*var SetReadCheckCnt = 0;
		    var setReadFlag = false;
		    function SetReadNew_onclick() {
		        var checkedItemChkBox = $("#BoardListDiv").find("input:checkbox:checked");
		        var checkedBoxLength = checkedItemChkBox.length;
		        
		        if (checkedBoxLength <= 0) {
		            alert(strLang177);
					return;
				}
		        
		        var ret = confirm(strLang178);
				if (ret) {
					var checkedItemTR = checkedItemChkBox.parent().parent();
				 	var strItemIDList = "";
				 	var strBoardIDList = "";
				 	
				 	for (var i = 0; i < checkedBoxLength; i++) {
				 		strItemIDList += (checkedItemTR.get(i).getAttribute("data2") + ";");
				 		strBoardIDList += (checkedItemTR.get(i).getAttribute("data1") + ";");
				 	}
				 	
				    var xmlhttp = createXMLHttpRequest();
				    xmlhttp.open("POST", "/ezBoard/setReadNew.do?pBoardIDList=" + encodeURIComponent(strBoardIDList) + "&itemIDList=" + encodeURIComponent(strItemIDList), false);		    
				    xmlhttp.send();
				    xmlhttp = null;
				    setReadFlag = true;
				    refresh_onclick();
				    
				    /!* 2019-07-04 홍승비 -  게시물 읽음표시 할 경우 좌측메뉴의 미독건수 갱신하도록 수정 *!/
				    if (useNotReadCnt == "YES") {
						var boardLeftFrame;
						
			            if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1) { // 즐겨찾기에서 읽기창 진입
							boardLeftFrame = window.parent.parent.frames["left"];
						} else { // 해당 게시판 내부에서 읽기창 진입
			        		boardLeftFrame = window.parent.frames["left"];
			        	}
			            
			            if (boardLeftFrame != null && boardLeftFrame != undefined && boardLeftFrame.location.href.indexOf("/ezBoard/boardLeft.do")> -1) {
			            	for (var i = 0; i < checkedBoxLength; i++) {
			     				boardLeftFrame.getBoardNotReadCountByID(checkedItemTR.get(i).getAttribute("boardgroupid"), "", "GROUP");
			     				boardLeftFrame.getBoardNotReadCountByID(checkedItemTR.get(i).getAttribute("data1"), checkedItemTR.get(i).getAttribute("data10"), "SUB");
			            	}
				    	}
				    }
				}
			}*/
		    
		    /* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
			function MemberInfo_onclick(pUserID, pDeptID) {
				if (gubun == "2") return;
				window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
			}
			function ReservationItem_onclick() {
			    var OrgBoardParameters = "page=" + CurPage + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=&boardType=" + pBoardType;	
			    window.location.href = "/ezBoard/boardReservedItemList.do?orgBoardParameters=" + escape(OrgBoardParameters) + "&boardType=" + pBoardType;
			}
			
			function window_reload() {
				window.location.href = window.location.href;
			}
			//체크박스 모두선택 함수. js파일에서 이 함수명이 HeaderAllCheckBox와 연결됨
 			function event_HeaderCheckBoxClick(obj) {
 			    var SelList = new ListView();
 			    SelList.LoadFromID("BoardListDiv");

 			    if (obj.checked) {
 			        for (var i = 0; i < SelList.GetRowCount() ; i++) {
 			            SelList.GetDataRows()[i].childNodes[0].childNodes[0].childNodes[0].checked = true;
 			            SelList.GetDataRows()[i].style.backgroundColor = m_strColorSelect;
 			            strListInfo += SelList.GetDataRows()[i].childNodes[0].childNodes[0].childNodes[0].id;
 			            strBoardListInfo += SelList.GetDataRows()[i].getAttribute("DATA1") + "," +  SelList.GetDataRows()[i].getAttribute("DATA2") + ";";
 			        }
 			    }
 			    else {
 			        for (var i = 0; i < SelList.GetRowCount() ; i++) {
 			            SelList.GetDataRows()[i].childNodes[0].childNodes[0].childNodes[0].checked = false;
 			            SelList.GetDataRows()[i].style.backgroundColor = m_strColorDefault;
 			            strListInfo = "";
 			            strBoardListInfo = "";
 			        }
 			    }
 			}
		
			function chk_onselect(obj)
			{
			    if (obj.checked) {
			        strListInfo += obj.id;
			      //같은 게시판에 속한 게시물의 정보가 지워지지 않도록, BoardID와 ItemID의 쌍으로 구분한다.
			        strBoardListInfo += obj.parentNode.parentNode.getAttribute("DATA1") + ","+obj.parentNode.parentNode.getAttribute("DATA2")+";";			        
			    } else {
			        strListInfo = ReplaceText(strListInfo, obj.id, "");
			        strBoardListInfo = ReplaceText(strBoardListInfo, obj.parentNode.parentNode.getAttribute("DATA1") + ","+obj.parentNode.parentNode.getAttribute("DATA2")+";", "");        
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
			
			/* 2020-02-03 홍승비 - 하단 미리보기 사용 시 아무 게시물도 선택되지 않은 상태라면 최소 높이 설정 */
		    function checkPreViewWSrc() {
	    	  if (document.getElementById("ifrmPreViewW").src.indexOf("/blank") > -1) {
	            	document.getElementById("ifrmPreViewW").style.minHeight = "130px";
	            } else { // 게시물 선택 시 최소 높이 해제
	            	document.getElementById("ifrmPreViewW").style.minHeight = "";
	            }
		    }
			
		</script>
		<style type="text/css">
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
	</head>
	<body class="mainbody" style="overflow:hidden;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
		<c:if test="${boardInfo.listView_FG != true}'">
			<div style="margin-top:100px;text-align:center"><spring:message code="ezBoard.t272" /></div>
		</c:if>
		<h1><spring:message code='ezBoard.allboard.hth01'/><span id="mailBoxInfo"></span></h1>
		<c:if test="${boardInfo.buttonHidden == 'N'}">
			<div id="mainmenu">
			  <ul>
			    <li style="display:none;"><span onclick="SetReadNew_onclick()"><spring:message code="ezBoard.t204"/></span></li>
				<!-- <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->
			    <li><span class="icon16 icon16_refresh" onClick="refresh_onclick()"></span></li>
			    <%-- <li><span onClick="ReservationItem_onclick()"><spring:message code="ezBoard.t276"/></span></li> --%>  
			    <!-- <li id="right">
	            	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
	            	<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
					<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" class="maillistoptiondivbtn" onclick="MailOptionView(this, 'N');" />
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
		</c:if>	
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
		                        <th><spring:message code="ezBoard.t10021"/></th>
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
		        <div style="width:100%; overflow-x:auto; overflow-y:hidden;" id="divList">
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
<%-- 		<div id="ListInfo" style="display:none"><%=ListInfo%></div> --%>
	</body>
</html>