<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>BoardItemThumbnailList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_thumbnail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
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
		    var pBoardID = "${boardID}";
		    var pBoardName = "${boardName}";
		    var SSUserID = "${userInfo.id}";
		    var SSUserName = "${userInfo.displayName1}";
		    var CurPage = "${page}";
		    var totalPage = "0";
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
		    var pSortBy = "${sortBy}";
		    var ShowAdjacent = "";
		    var gubun = "${boardInfo.guBun}";
		    var totalCount = "0";
		    var OrderOption = "";
		    var OrderCell = "";
		    var pBoardType = "${boardType}";
		    var USE_OCS = "${useOCS}";
		    var useRunTime = "${useRunTime}"
		    var SQLPARADATA = "";
		    var pAdminType = "${adminType}";
		    var lang = "${userInfo.lang}";
		    var previewType = "MOVIE";
		    var clickPreviweType = "MOVIE";
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
		
		        if (document.documentElement.clientWidth < 1300) {
		            document.getElementById("right").style.display = "none";
		        }
		    };
		    
	        /* 2018-08-11 장진혁 - 레이어팝업 생성된 상태에서 backspace 누를시 왼쪽프레임 부분 딤 처리 없애기 */
	        window.onunload = function () {
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
		    
		    $(document).ready(function() {
		    	var clickOutside;
		    	
		    	if (navigator.userAgent.toLowerCase().indexOf("m sie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { 
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].document);
		    	} else {
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].contentWindow.document);
		    	}	    	
		    	
		    	clickOutside.mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	//즐겨찾기 게시판의 썸네일게시판 스크립트 오류 수정
		    	if (window.parent.frames['left'] == undefined) {
		    		$(parent.parent.frames['left']).mouseup(function (e) {
			    		MailOptionHiddenOutside(e);
			    	});
		    	} else {
			    	$(window.parent.frames['left'].document).mouseup(function (e) {
				    	MailOptionHiddenOutside(e);
			    	});
		    	}
		    	
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
		    
		    /* 2018-06-14 김민성 - 게시판 검색 레이어 팝업 리사이징 설정 추가 */
		    /* $(window).on("resize", function(){
		    	if (parent.frames["FBoard_ifrm"]) {
		    		var popupX = parent.parent.document.body.clientWidth/2 - (500/2) - 220;
		    		$("#srarchpopup").css("left", popupX).css("bottom", "66px");
		    	} else {
					var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
					$("#srarchpopup").css("left", popupX);
		    	}
				
	        	
	        	$("#srarchpopup").css("left", popupX);	        
		    }); */
		    
		    $(window).on("resize", function(){
		    	if (parent.frames['left'] == undefined && parent.frames["BoardEnv_ifrm"] == undefined) {
		    		var popupX = parent.parent.document.body.clientWidth/2 - (500/2) - 220;
		    		$("#srarchpopup").css("left", popupX).css("bottom", "66px");
		    	} else if (parent.frames["BoardEnv_ifrm"] != undefined) {
		    		var popupX = parent.parent.document.body.clientWidth/2 - (500/2) - 220;
		    		$("#srarchpopup").css("left", popupX).css("bottom", "26px");
		    	} else {
					var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
					$("#srarchpopup").css("left", popupX);
		    	}					        	
	        });
		
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', "");
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', "");
		    });
		    
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		        	closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		
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
					dataType : "text",
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
						getBoardList_after(loadXMLString(xml));
					}        			
				});	
		    }
		
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
	            var perCnt = getNodeText(perNode);
	            listcount.value = perCnt;
	            totalPage = Math.ceil(new Number(pageCnt / perCnt));
	            pTotalCnt = lstCnt;
	            makePageSelPageBrd();
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
                    document.getElementById("BoardList_TH_1").style.width = tempno.length * 3 + 22 + "px";
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
		
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
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
		        	var selectSearch = document.getElementById('selectType');
	                if (selectSearch.item(0).selected) {
	                    TYPE += "TITLE;";
	                    DATA += "<TITLE>" + document.getElementById("txt_keyword").value + "</TITLE>";
	                }
	                else if (selectSearch.item(1).selected) {
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
		
		            /* if (document.getElementById("txtAbstract").value != "")		// ABSTRACT
		            {
		                TYPE += "ABSTRACT;";
		                DATA += "<ABSTRACT>" + document.getElementById("txtAbstract").value + "</ABSTRACT>";
		            } */
		
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
		        var pTop = (pheight - 700) / 2;
		        var pLeft = (pwidth - 765) / 2;
		        window.open("/ezBoard/newBoardItemMovie.do?boardID=" + pBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=700,width=765,top=" + pTop + ",left=" + pLeft, "");
		    }
		
		    function ItemRead_onclick(obj) {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t194'/>");
		            return;
		        }
		
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 679) / 2;
		        var pLeft = (pwidth - 764) / 2;
	    	    if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
	    	    	var height = 679;
	    	    } else {
	    	    	var height = 675;
	    	    }
		
	    	    /* 2018-07-09 홍승비 - 게시물 클릭 시 spn_content의 아이디를 사용해 폰트를 변경하도록 수정함 */
	    	    if (document.getElementById('spn_title' + obj.id.split('_')[2]).style.fontWeight == "bold") {
		            document.getElementById('spn_title' + obj.id.split('_')[2]).style.fontWeight = "normal";
					document.getElementById('spn_content' + obj.id.split('_')[2]).style.fontWeight = "normal";
		        }
	    	    for (var i = 0; i < obj.childNodes.length; i++) {
			        if (obj.childNodes[i].style.fontWeight == "bold") {
			            obj.childNodes[i].style.fontWeight = "normal";
					}
		        }
	    	    
		        window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + obj.getAttribute("DATA2") + "&boardID=" + obj.getAttribute("DATA1") + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
		    }
		
		    var checkpassword_dialogArguments = new Array();
		    var strItemList = "";
		    function DeleteItem_onclick() {
	            if (strListInfo == "" || strListInfo === "undefined") {
	                alert("<spring:message code='ezBoard.t195'/>");
	                return;
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
		        
	            var ret = confirm("<spring:message code='ezBoard.t197'/>");
	            if (ret) {
	                DeleteItem();
	            }
	            
		        try {
                	leftCountRf();
				} catch (e) {
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
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + strListInfo + "&mode=MOVIE", false);
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
		        if (CurPage == 0) {
		        	CurPage = 1;
		        }
		        
		        /* 2018-10-23 홍승비 - 게시물을 삭제한 경우, 미리보기가 열려있으면 새로고침하도록 수정 (썸네일게시판) */
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
		        window.location.href = "/ezBoard/boardItemListMovie.do?page=" + CurPage.toString() + "&boardID=" + pBoardID + "&sortBy=&boardType=" + pBoardType + "&adminType=" + pAdminType;
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
		    
		    function SetRead_onclick() {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t194'/>");
		            return;
		        }
		        if (strListInfo == "" || strListInfo === "undefined") {
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
		    /* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		    function MemberInfo_onclick(pUserID, pDeptID) {
		        if (gubun == "2") return;
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
		    
		    function search_onclick() {
		        var OrgBoardParameters = "page=" + CurPage + "&boardID=" + pBoardID + "&sortBy=&boardType=" + pBoardType;
		        window.location.href = "/ezBoard/searchBoardItem.do?boardID=" + pBoardID + "&boardType=" + pBoardType + "&orgBoardParameters=" + escape(OrgBoardParameters);
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
		
		
		    /* 2018-06-12 김민성 - 게시판 검색 레이어팝업 변경 */ 
		    function doLayerPopup(obj) {    	 									// 즐겨찾기 검색
		    	if (window.parent.frames['left'] == undefined && parent.frames["BoardEnv_ifrm"] == undefined) {	// 2018-06-15 김민성 - 즐겨찾기 내 게시판일때 기존 팝업으로 변경
		    		$("<div id='blockLeft' class='blockLeft' style='position:fixed; width:100%;height:100%; overflow:hidden;' onclick='parent.frames[\"right\"].frames[\"FBoard_ifrm\"].BoardSearchOptionHidden()'></div>").appendTo(parent.parent.frames["left"].document.body);
		    		$("<div id='blockTop' class='blockTop' onclick='parent.frames[\"right\"].frames[\"FBoard_ifrm\"].BoardSearchOptionHidden()'></div>").appendTo(parent.parent.frames["right"].document.body);
		    		
		    		parent.parent.frames["left"].document.body.style.overflow = "hidden";		    		
		    				    		
			    	var popupX = parent.parent.document.body.clientWidth/2 - (500/2) - 220;			    	

			    	$("#srarchpopup").css("left", popupX).css("bottom", "66px");
			    	$("#srarchpopup").modal();
			    	
		        	/* btn_PostDate_Clear();
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
			        } */
		    	}
		    	else if (parent.frames["BoardEnv_ifrm"] != undefined) {			// 관리자 모드 검색
		    		$("<div id='blockLeft' class='blockLeft' style='position:fixed; width:100%;height:100%; overflow:hidden;' onclick='parent.frames[\"board_main\"].frames[\"BoardEnv_ifrm\"].BoardSearchOptionHidden()'></div>").appendTo(parent.parent.frames["board_menu"].document.body);
		    		$("<div id='blockTop' class='blockTop' onclick='parent.frames[\"board_main\"].frames[\"BoardEnv_ifrm\"].BoardSearchOptionHidden()'></div>").appendTo(parent.parent.frames["board_main"].document.body);
		    		
		    		parent.parent.frames["board_menu"].document.body.style.overflow = "hidden";		    		
		    				    		
			    	var popupX = parent.parent.document.body.clientWidth/2 - (500/2) - 220;			    	

			    	$("#srarchpopup").css("left", popupX).css("bottom", "26px");
			    	$("#srarchpopup").modal();
		    	}
		    	else {																				// 일반 게시판 검색
			    	$("<div id='blockLeft' class='blockLeft' style='position:fixed; width:100%;height:100%; overflow:hidden;' onclick='parent.frames[\"right\"].BoardSearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);
			    	parent.frames["left"].document.body.style.overflow = "hidden";
			    	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
			    	$("#srarchpopup").css("left", popupX);
			    	$("#srarchpopup").modal();
		    	}
		    }
		    function BoardSearchOptionHidden() {
		    	document.getElementById("layer_popup").style.display = "none";
			    document.getElementById("SearchOption").setAttribute("mode", "off");
			     
			    if (window.parent.frames['left'] != undefined) {
			       $.modal.close();			       		
			    }
			    
			    if (parent.parent.frames['left'] != undefined) {
			       $.modal.close();
			    }
		    }
		
		    function search(type) {
		        if (type == "basic") {
		        	if (document.getElementById("txtWriterName").value == "" && document.getElementById("txtTitle").value == "" && $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
		                alert("<spring:message code='ezBoard.t192' />");
		                return;
		            }
		            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
		        		alert("<spring:message code='ezSystem.x0035' />");	
		                return;
		            }
		            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
		                alert("<spring:message code='ezSystem.x0036' />");
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
		            var OpenWin = GetOpenWindow("/ezBoard/myBoardConfig.do?type=ADD&boardID=" + pBoardID, "MyBoardConfig", 525, 418);
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else
		            showModalDialog("/ezBoard/myBoardConfig.do?type=ADD&boardID=" + pBoardID, null, "dialogHeight:418px; dialogWidth:525px; status:no; help:no; scroll:no; edge:sunken");
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
		<c:when test="${adminType != 'y'}">
			<body class="mainbody" style="overflow:hidden">
		</c:when>
		<c:otherwise>
			<body class="tabbody" style="overflow:hidden">
		</c:otherwise>
	</c:choose>
	<c:if test="${boardInfo.listView_FG != 'true'}">
		<div style="margin-top:100px;text-align:center"><spring:message code='ezBoard.t272'/></div>
	</c:if>
	<c:if test="${boardInfo.listView_FG == true}">
		<c:choose>
			<c:when test="${adminType != 'y'}">
				<h1>${boardName}<span id="mailBoxInfo"></span>
				     <span style="float:right;font-weight:normal;color:black;">
						<select id="selectType" style="width:80px; height:27px; border-color: #c8c8c8;">
				    		<option selected value="rad_Subject"><spring:message code='ezBoard.t208'/></option>
				    		<option value="rad_Writer"><spring:message code='ezBoard.t223'/></option>
				    	</select>
						<input id="txt_keyword" style="height: 27px;border: 1px solid #cbcbcb; border-right:0px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
				        <a href="#" style="float:right"><img src="../../images/bsearch_new.gif" border="0" onClick="search('quick')"></a>
					</span>
				</h1>
			</c:when>
			<c:otherwise>
			    <script type="text/javascript">
			        parent.document.getElementsByTagName("h1")[0].innerHTML = "${boardName}"+"<span id='mailBoxInfo'></span>";
			    </script>
			    <br />
			    <span style="display:none; float:right;font-weight:normal;color:black;">
			          <select id="selectType" style="width:80px; height:27px; border-color: #c8c8c8;">
			    		<option selected value="rad_Subject"><spring:message code='ezBoard.t208'/></option>
			    		<option value="rad_Writer"><spring:message code='ezBoard.t223'/></option>
			    	</select>
					<input id="txt_keyword" style="height: 27px;border: 1px solid #cbcbcb; border-right:0px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
					<a href="#" style="float:right"><img src="../../images/bsearch_new.gif" border="0" onClick="search('quick')"></a>
			        </span>
			</c:otherwise>
		</c:choose>
	<c:if test="${buttonHidden == 'N'}">
		<div id="mainmenu">
		  <ul>
		        <li><span onClick="NewItem_onclick()"><spring:message code='ezBoard.t321'/></span></li>
		        <li><span onclick="SetRead_onclick()"><spring:message code='ezBoard.t204'/></span></li>
			    <!-- <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->
		        <li><span onClick="DeleteItem_onclick()"><spring:message code='ezBoard.t89'/></span></li>
			    <!-- <li id="Li1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->
		        <li><span onClick="refresh_onclick()"><spring:message code='ezBoard.t205'/></span></li>
		        <li><span id="SearchOption" mode="off" onClick="doLayerPopup(this)"><spring:message code='ezBoard.t188'/></span></li>
		        <li><span onClick="AddToMyBoards()"><spring:message code='ezBoard.t10051'/></span></li>
		        <li><span onClick="SaveMyBoard()"><spring:message code='ezBoard.t10052'/></span></li> 
		        <!-- <li id="right">
	            	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
					<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" />
				</li> -->
				<div class="sub_frameIcon" style="float:right">	
					<div class="sub_frameIconUL" style="width:57px !important">
					   	<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE')"></span></p>
					    <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H')"></span></p>
					</div>
					<div class="sub_frameIconUL02">
					  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="maillistoptiondiv" onclick="MailOptionView(this);"></span></p>  
					</div>
				 </div>
		        <c:if test="${boardInfo.boardAdmin_FG == true}">
			        <li><span onClick="SetBoardAcl()"><spring:message code='ezBoard.t63' /></span></li> 
		        </c:if>
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
	                        <th><spring:message code="ezEmail.t99000035" /></th>
	                        <td>
	                            <select id="viewtype" onchange="getBoardList('1')">
					                <option value="1"><spring:message code='ezBoard.t4001' /></option>
					                <option value="2"><spring:message code='ezBoard.t4002' /></option>
<%-- 					                <option value="3"><spring:message code='ezBoard.t4003' /></option> --%>
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
	
	    <span id="PreviewRayerH" style="border:0px solid red; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
	        <span class="previewmail_bar_h" display: inline-block;">
	            <p class="hbar_dotted">
	                <img src="/images/prevview_hbar_dotted.gif">
	            </p>
	        </span>
	        <span id="PreContent_RayerH" style="position: absolute; border: 0px solid blue;">
	            <span style="width: 100%; height: 100px; display: block;">
	                <span class="previewmail_info" style="display: block; width: 100%;">
	                    <div id="Preview_HeaderH" style="border-bottom: solid 1px #e8e8e8; width: 100%; display: none;">
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
	                <iframe id="ifrmPreViewH_photo" name="ifrmPreViewH_photo" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
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
	                    <div id="Preview_HeaderW" style="border-bottom: solid 1px #e8e8e8; display: none;">
	                        <p class="mail_title">
	                            <span class="icon_btn"><span onclick="MailReadOpen();" style="cursor: pointer; padding-right: 5px;">
	                                <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreW_subject"><span id="PreW_sub_subject" class="title_blodtxt"></span></span>
	                        </p>
	                        <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreW_date"><span id="PreW_sub_date"></span></span></span>
	                        <dl class="mail_item">
	                            <dt><spring:message code='ezBoard.t223'/>:</dt>
	                            <dd style="padding-left:44px; margin-top:-20px;"><span id="PreW_MailReceiver" style="display: inline-block"></span>
	                            </dd>
	                        </dl>
	                    </div>
	                </span>
	                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
	            </span>
	        </span>
	    </span>
	
	<div id="ListInfo" style="display:none"></div>
	<!-- 2018-06-12 김민성 - 게시판 검색 레이어팝업 변경 -->
	<%-- <c:choose>
	<c:when test="${adminType != 'y'}"> --%>
	<div class="jquery-modal blocker current" id="layer_popup" style="display: none;">
		<div id="srarchpopup" class="popupwrap1 modal" style="margin-bottom: 70px; left: 297.5px; display: inline-block;">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezBoard.t188' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="BoardSearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content">
					<tr>
						<th style="text-align: center">
							<spring:message code='ezBoard.t185' />
						</th>
						<td>${boardName} 
		      				<input type="checkbox" id="chkSearchSub" ><spring:message code='ezBoard.t498' />
		    			</td>
					</tr>
					<tr>
			            <th style="text-align:center"><spring:message code='ezBoard.t223' /></th>
			            <td><input type="text" id="txtWriterName" style="width:100%" value=""></td>
			        </tr>
			        <tr>
			            <th style="text-align:center"><spring:message code='ezBoard.t208' /></th>
			            <td><input type="text" id="txtTitle" style="width:100%" value=""></td>
			        </tr>  
			        <%--  <tr>
			            <th style="text-align:center"><spring:message code='ezBoard.t209' /></th>
			            <td><input type="text" id="txtAbstract" style="width:98%" value=""></td>
			        </tr>     --%>
			       <tr>
			            <th style="text-align:center"><spring:message code='ezBoard.t210' /></th>
			           <td>
			               <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
			                ~
			               <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"> 
			           </td>
			  		</tr>
				</table>
				<br />
				<table style="width: 100%">
			        <tr>
			            <td style="text-align:center;">
			            	<div class="btnpositionLayer">
			                	<a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezBoard.t220' /></span></a>
			                	<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezBoard.t188' /></span></a>
			                </div>	
			            </td>
			        </tr>
				</table>
			</div>	
		</div>
	</div>
	<%-- </c:when>
	<c:otherwise>
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
	   </c:otherwise>
		</c:choose>    --%>  
		</c:if>
	</body>
</html>
