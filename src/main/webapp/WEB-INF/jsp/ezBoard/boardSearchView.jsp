<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<!-- data picker-->
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
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
		</style>
		<script type="text/javascript">
			var pBoardID = "";
			var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.name}";
			var USE_OCS = "${use_ocs}";				
			var pUse_Editor = "${use_Editor}";
			var CurPage = "";
			var totalPage = "";
			var strListInfo = "";
			var Use_OneLineCount = "";
			var OrderOption = "";
			var OrderCell = "";
			var pBoardType = "N";
			var SQLPARADATA = "";
			
			var pAdminType = "";
			//var pButtonHidden = "N"; //N 설정
			//var gubun = "${boardInfo.guBun}";
			//var Access_FG = "${boardInfo.access_FG}";
			//var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
			//var ListView_FG = "${boardInfo.listView_FG}";
			
			var previewType = "TEXT";
			var clickPreviweType = "TEXT";
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
			var onclickFlag = false;
			var selobj = null;
			var PreviewH_Move = false;
			var PreviewW_Move = false;
			var g_bPrevShow = false;
			var pMode = "new";
					
			var ShowAdjacent = "";
			
			var readFgList = [];
			var attributeYNList = [];
			var BoardAdminFgList = [];
			var BoardGroupAdminFgList = [];
			var boardIdList = [];
			var ItemIdList = [];
			var gubunList = [];
			var writerIdList = [];
			
			window.onunload = Window_onunload;
			var window_onunload_Event = false;
			
			window.onresize = function ()
			{
			    document.onselectstart = function () { return false; };
			    var height = parseInt(document.documentElement.clientHeight - 200);
			    
			    MailOptionHidden();
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
				
				var height = parseInt(document.documentElement.clientHeight - 320);
				
				getBoardList_after(loadXMLString("${listHeader}"));
				
				if(document.getElementById("BoardList_TR_noItems") != null) {
                	document.getElementById("BoardList_TR_noItems").outerHTML = "";
                }
				
				document.getElementById("mailBoxInfo").innerHTML = "";
				
				window_onunload_Event = true;
				
			};
			$(document).ready(function() {
				$("input:checkbox[id='chkSearchAll']").on('click', function() {
					if($(this).prop('checked')) {
						document.getElementById("selectedBoardName").innerHTML = "전체 게시판";
					}else{
						if(document.getElementById("selectedBoardName").value == undefined) {
							document.getElementById("selectedBoardName").innerHTML = "";
						}
					}
				});
			});	
			var Save_unloadSave = false;
			function Window_onunload() {
		        if (window_onunload_Event && !Save_unloadSave) {
		        	var divStyle;
		            var listCount = 0;
		            var pPreviewShow_HOW = "OFF";
		            
		            if (document.getElementById("listcount") != null){
		            	listCount = 20;
		            } else {
		            	listCount = 20;
		            }
		            
		            if (pPreviewShow_HOW == "W") {
		                divStyle = Math.round(pMailListDiv);
		            } else if (pPreviewShow_HOW == "H") {
		                divStyle = Math.round(pMailListDiv_H);
		            } else {
		                divStyle = 0;
		            }
		            
		            if (divStyle < 24) {
		                divStyle = 24;
		            }
					
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
			
			function getBoardList(type) {
			    if (type == "1") {
			        SQLPARADATA = "";
			        CurPage = 1;
			    }
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
							 boardId 	 : document.getElementById('selectedBoard').value,
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
			    /* try { */
			        var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
			        var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
			        var pagenode = SelectSingleNodeNew(xml, "DOCLIST/PAGECNT");
			        var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
			
			        pMailListDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWLIST")));
			        pMailPreVDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWCONTENT")));
			        pMailListDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHLIST")));
			        pMailPreVDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHCONTENT")));
			
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
			        }
			        else {
			            xmlDoc = createXmlDom();
			            xmlDoc.appendChild(listNode);
			        }
			        if (document.getElementById("lvBoardList").innerHTML != "")
			            document.getElementById("lvBoardList").innerHTML = "";
			        
			        var DocList = new ListView();
			        DocList.SetID("BoardList");
			        DocList.SetMulSelectable(false);
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
			            document.getElementById("BoardList_TH_1").style.width = tempno.length * 3 + 22 + "px"; // +  tempno.length * 3 + 20
			        }
			       	
			        if (!firstFlag) {
			            PreviewRayerChange("OFF");
			            if (CrossYN()) {
			                if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
			                    ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = "<spring:message code='ezBoard.t10022'/>";
			                }
			                if (ifrmPreViewW.document.getElementById("ifrmviewEmptyText") != null){
			                    ifrmPreViewW.document.getElementById("ifrmviewEmptyText").textContent = "<spring:message code='ezBoard.t10022' />";
			                }
			            } else {
			                if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
			                    ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022' />";
			                }
			                if (ifrmPreViewW.document.getElementById("ifrmviewEmptyText") != null){
			                    ifrmPreViewW.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022' />";
			                }
			            }
			            firstFlag = true;
			        } 
			}
			function selectBoard() {
				if (CrossYN()) {
			        OpenWin = GetOpenWindow("/ezBoard/selectBoardItem.do", "selectBoardItem", 457, 600);
			        try { OpenWin.focus(); } catch (e) { }
			    } else {
			       /*  var pheigth = window.screen.availHeight;
			        var pwidth = window.screen.availWidth;
			        pheigth = parseInt(pheigth) / 2;
			        pwidth = parseInt(pwidth) / 2;
			        pheigth = pheigth - 200;
			        pwidth = pwidth - 127;
			        var ret = window.showModalDialog("/ezBoard/moveBoardItem.do?itemIDList=" + strItemList + "&boardID=" + pBoardID + "&guBun=" + gubun, "", "DialogHeight:656px;DialogWidth:340px;status:no;help:no;edge:sunken;scroll:no");
			
			        if (typeof (ret) != "undefined") {
			            if (ret == "OK") {
			            	try {
								leftCountRf();
							} catch (e) {}
							
			                window.location.reload();
			                window.close();
			            }
			        } */
			    }
			}
			// 검색클릭시
			function search(type) {
			    if (type == "basic") {
			    	if(!document.getElementById("chkSearchAll").checked && document.getElementById("selectedBoard").value == "") {
			    		alert("<spring:message code='ezBoard.khj4' />");
			    		return;
			    	}
			        if (document.getElementById("txtWriterName").value == "" && document.getElementById("txtTitle").value == "" && document.getElementById("txtAbstract").value == "" && document.getElementById("txtContent").value == ""
			        		&& $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
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
			            alert("<spring:message code='ezBoard.t191' />");
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
			    
			    //게시판검색조건 
			    if (document.getElementById("chkSearchAll").checked) {		// SearchAllBoard   	
			    	TYPE += "SEARCHALLBOARD;";
			    } else { 
			    	if (document.getElementById('selectedBoardParentBoardID').value == "top")  {  //SearchGroupBoard  
			    		TYPE += "SEARCHGROBOARD;";
			    	} else {
			    		if (document.getElementById("chkSearchSub").checked) {		// SearchSubBoard
			    	        TYPE += "SEARCHSUBBOARD;";
			    	    }		
			    	}
			    }
			    
			        if (document.getElementById("txtTitle").value != "")		// DocTitle
			        {
			            TYPE += "TITLE;";
			            DATA += "<TITLE>" + MakeXMLString(document.getElementById("txtTitle").value.replace("'", "''")) + "</TITLE>";
			        }
			        
			    	if (document.getElementById("txtContent").value != "") {		// DocContent
						    TYPE += "CONTENT;";
					        DATA += "<CONTENT>" + MakeXMLString(document.getElementById("txtContent").value.replace("'", "''")) + "</CONTENT>";
			
			        if (document.getElementById("txtWriterName").value != "")		// DrafterName
			        {
			            TYPE += "WRITERNAME;";
			            DATA += "<WRITERNAME>" + MakeXMLString(document.getElementById("txtWriterName").value.replace("'", "''")) + "</WRITERNAME>";
			        }
			
			        if (document.getElementById("txtAbstract").value != "")		// ABSTRACT
			        {
			            TYPE += "ABSTRACT;";
			            DATA += "<ABSTRACT>" + MakeXMLString(document.getElementById("txtAbstract").value.replace("'", "''")) + "</ABSTRACT>";
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
			function chk_onselect(obj) {
			    if (obj.checked) {
			        strListInfo += obj.id;
			    } else {
			        strListInfo = ReplaceText(strListInfo, obj.id, "");
			    }
			
			    listEventCheckbox = true;
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
			
			function ItemRead_onclick(obj) { //더블클릭
				if(obj.getAttribute("data15") != "true") {
					alert("<spring:message code='ezBoard.t194' />");
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
					window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + obj.getAttribute("DATA2") + "&boardID=" + obj.getAttribute("DATA1") + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=770,width=790,top=" + pTop + ",left=" + pLeft, "");
				} else {
					window.open("/ezBoard/boardItemView.do?showAdjacent=" + ShowAdjacent + "&itemID=" + obj.getAttribute("DATA2") + "&boardID=" + obj.getAttribute("DATA1") + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=790,top=" + pTop + ",left=" + pLeft, "");
				}
			}
			
			var strItemList = "";
			function DeleteItem_onclick() { 
				strItemList = "";
				
				if (CheckIfHasReplies()) {
			        alert("<spring:message code='ezBoard.t196' />");
			        return;
			    }
			}
			var moveboarditem_cross_dialogArguments = new Array();
			function MoveItem_onclick() { 
				readFgList = [];
				BoardAdminFgList = [];
				attributeYNList = [];
				BoardGroupAdminFgList = [];
				boardIdList = [];
				ItemIdList = [];
				gubunList = [];
				
				$('input:checkbox:checked').each(function() {
					var gubunItem = $(this).parent().parent().attr("data10");
					var attributeYNItem = $(this).parent().parent().attr("data13");
					var BoardAdminFgItem = $(this).parent().parent().attr("data14"); 	   		//게시판관리자
					var readFgItem = $(this).parent().parent().attr("data15"); 			  		//읽기권한
					var BoardGroupAdminFgItem = $(this).parent().parent().attr("data19"); 		//게시판그룹관리자 
					
					var boardIdItem = $(this).parent().parent().attr("data1"); 
					var ItemIdItem = $(this).parent().parent().attr("data2"); 
					
					if(typeof readFgItem != "undefined") {
						readFgList.push(readFgItem);	
					}
					
					if(typeof attributeYNItem != "undefined" || attributeYNItem != null) {
						attributeYNList.push(attributeYNItem);	
					}
					
					if(typeof BoardAdminFgItem != "undefined") {
						BoardAdminFgList.push(BoardAdminFgItem);	
					}
					
					if(typeof BoardGroupAdminFgItem !== "undefined") {
						BoardGroupAdminFgList.push(BoardGroupAdminFgItem);	
					}
					
					if(typeof boardIdItem !== "undefined") {
						boardIdList.push(boardIdItem);
					}
					
					if(typeof ItemIdItem !== "undefined") {
						ItemIdList.push(ItemIdItem);
					}
					
					if(typeof gubunItem !== "undefined") {
						gubunList.push(gubunItem);
					}
					
				 });
				
				for(var i = 0; i < readFgList.length ; i++) { 
					if (readFgList[i] != "true") {
						
						alert("<spring:message code='ezBoard.t194' />");
						return;
					}
				}
				
				if (strListInfo == "" || strListInfo === "undefined") {
		            alert("<spring:message code='ezBoard.t497' />");
		            return;
		        }
				
				for(var i = 0; i < BoardAdminFgList.length ; i++) { 
					if (BoardAdminFgList[i] != "true" && BoardAdminFgList[i] != "OK" && CheckOwnerShip() == false) {
						alert("<spring:message code='ezBoard.t202' />");
						return;
					}
				}
				
			    for(var i = 0; i < attributeYNList.length ; i++) {
					if (attributeYNList[i] == "Y") {
						
						alert("<spring:message code='ezBoard.t999071' />");
						return;
					}
				}
			    
			    if (CheckIfHasReplies()) {
			        alert("<spring:message code='ezBoard.bhs01'/>");
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
			        for(var i = 0; i < boardIdList.length; i++) {
						
						var pBoardID = boardIdList[i];
						var strItemList = ItemIdList[i];
						var gubun = gubunList[i];
			   			
						console.log(pBoardID + ", " + strItemList + ", " + gubun);
						OpenWin = GetOpenWindow("/ezBoard/moveBoardItem.do?itemIDList=" + strItemList + "&boardID=" + pBoardID + "&guBun=" + gubun, "MoveBoardItem", 340, 600);
				        try { OpenWin.focus(); } catch (e) { }
			        }
			   
			    } else {
			        var pheigth = window.screen.availHeight;
			        var pwidth = window.screen.availWidth;
			        pheigth = parseInt(pheigth) / 2;
			        pwidth = parseInt(pwidth) / 2;
			        pheigth = pheigth - 200;
			        pwidth = pwidth - 127;
			        
			        
			        for(var i = 0; i < boardIdList.length ; i++) {
						var pBoardID = boardIdList[i];
						var strItemList = ItemIdList[i];
					
						var ret = window.showModalDialog("/ezBoard/moveBoardItem.do?itemIDList=" + strItemList + "&boardID=" + pBoardID + "&guBun=" + gubun, "", "DialogHeight:656px;DialogWidth:340px;status:no;help:no;edge:sunken;scroll:no");
						
				        if (typeof (ret) != "undefined") {
				            if (ret == "OK") {
				            	try {
									leftCountRf();
								} catch (e) {}
								
				                window.location.reload();
				                window.close();
				            }
				        }
			        }
			    }	
			}
			
			function MoveItem_onclick_Complete(ret) {
			    if (typeof (ret) != "undefined") {
			        if (ret == "OK") {
			            try {
							leftCountRf();
						} catch (e) {}
			            window.location.reload();
			            window.close();
			        }
			    }
			}
			
			function CopyItem_onclick() {
				readFgList = [];
				BoardAdminFgList = [];
				attributeYNList = [];
				BoardGroupAdminFgList = [];
				boardIdList = [];
				ItemIdList = [];
				writerIdList = [];
				
				$('input:checkbox:checked').each(function() {
					var attributeYNItem = $(this).parent().parent().attr("data13"); 			//확장컬럼
					var BoardAdminFgItem = $(this).parent().parent().attr("data14"); 	   		//게시판관리자
					var readFgItem = $(this).parent().parent().attr("data15"); 			  		//읽기권한
					var BoardGroupAdminFgItem = $(this).parent().parent().attr("data19"); 		//게시판그룹관리자 
					
					var boardIdItem = $(this).parent().parent().attr("data1"); 
					var ItemIdItem = $(this).parent().parent().attr("data2");
					var writerIdItem = $(this).parent().parent().attr("data3");
					
					if(typeof readFgItem != "undefined") {
						readFgList.push(readFgItem);	
					}
					
					if(typeof attributeYNItem != "undefined" || attributeYNItem != null) {
						attributeYNList.push(attributeYNItem);	
					}
					
					if(typeof BoardAdminFgItem != "undefined") {
						BoardAdminFgList.push(BoardAdminFgItem);	
					}
					
					if(typeof BoardGroupAdminFgItem !== "undefined") {
						BoardGroupAdminFgList.push(BoardGroupAdminFgItem);	
					}
					
					if(typeof BoardGroupAdminFgItem !== "undefined") {
						BoardGroupAdminFgList.push(BoardGroupAdminFgItem);	
					}
					
					if(typeof boardIdItem !== "undefined") {
						boardIdList.push(boardIdItem);
					}
					
					if(typeof ItemIdItem !== "undefined") {
						ItemIdList.push(ItemIdItem);
					}
					
					if(typeof writerIdItem !== "undefined") {
						writerIdList.push(writerIdItem);
					}
					
				 });
				
				for(var i = 0; i < readFgList.length ; i++) { 
					if (readFgList[i] != "true") {
						
						alert("<spring:message code='ezBoard.t194' />");
						return;
					}
				}
				
				if (strListInfo == "" || strListInfo === "undefined") {
			        alert("<spring:message code='ezBoard.t201' />");
			        return;
			    }
				
				for(var i = 0; i < BoardAdminFgList.length ; i++) {
					console.log(writerIdList[i].indexOf(SSUserID) != -1);
					if (BoardAdminFgList[i] != "true" && BoardGroupAdminFgList[i] != "OK" && writerIdList[i].indexOf(SSUserID) != -1) {
						alert("<spring:message code='ezBoard.t202' />");
						return;
					}
				}
				
			    for(var i = 0; i < attributeYNList.length ; i++) {
					if (attributeYNList[i] == "Y") {
						
						alert("<spring:message code='ezBoard.t999071' />");
						return;
					}
				}

			
			    var pheigth = window.screen.availHeight;
			    var pwidth = window.screen.availWidth;
			    pheigth = parseInt(pheigth) / 2;
			    pwidth = parseInt(pwidth) / 2;
			    pheigth = pheigth - 200;
			    pwidth = pwidth - 127;
			    var feature = "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth;
			    feature = feature += GetOpenPosition(340,656);
			    
		        var strItemList = "";
			    for(var i = 0; i < boardIdList.length ; i++) {
					strItemList += ItemIdList[i] + ";";
					console.log(strItemList);
				}
			    
			    window.open("/ezBoard/copyBoardItem.do?itemIDList=" + strItemList + "&boardID=" + boardIdList[1] + "&mode=COPY", "", feature, "");	
			    
			    
			    
			}
			function SetRead_onclick() {
				readFgList = [];
				boardIdList = [];
				ItemIdList = [];
				
				$('input:checkbox:checked').each(function() {
					var boardIdItem = $(this).parent().parent().attr("data1"); 
					var ItemIdItem = $(this).parent().parent().attr("data2"); 
					var readFgItem = $(this).parent().parent().attr("data15");
					
					if(typeof readFgItem != "undefined") {
						readFgList.push(readFgItem);	
					}	
					
					if(typeof boardIdItem !== "undefined") {
						boardIdList.push(boardIdItem);
					}
					
					if(typeof ItemIdItem !== "undefined") {
						ItemIdList.push(ItemIdItem);
					}
				 });
				
				if(readFgList.length == 0) {
					alert("<spring:message code='ezBoard.t194' />");
					return;
				}
				
				for(var i = 0; i < readFgList.length ; i++) { 
					if (readFgList[i] != "true") {
						
						alert("<spring:message code='ezBoard.t194' />");
						return;
					}
				}
				
				if (strListInfo == "" || strListInfo === "undefined") {
			        alert("<spring:message code='ezBoard.t198' />");
			        return;
			    }
				
				var ret = confirm("<spring:message code='ezBoard.t199' />");
				
				if(ret) {
					console.log("읽기버튼");
					console.log(boardIdList.length);
					for(var i = 0; i < boardIdList.length ; i++) {
						var pBoardID = boardIdList[i];
						var strItemList = ItemIdList[i];
						console.log(pBoardID + ", " + strItemList);
					
						var xmlhttp = createXMLHttpRequest();
				        xmlhttp.open("POST", "/ezBoard/setRead.do?boardID=" + pBoardID + "&itemIDList=" + strItemList, false);
				        xmlhttp.send();
				        xmlhttp = null;
					}
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
		</script>
</head>
<body class="mainbody" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	<h1><spring:message code="ezBoard.khj1" /></h1>
			<div id="mainmenu">
			  <ul>
			  	<%-- <li><span id="SearchOption" mode="off" onClick="doLayerPopup(this)"><spring:message code='ezBoard.t188' /></span></li> --%>
		        <li><span onclick="SetRead_onclick()"><spring:message code='ezBoard.t204' /></span></li>
			    <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
		        <li><span onClick="DeleteItem_onclick()"><spring:message code='ezBoard.t89' /></span></li>
		        <li id="btn_copy"><span onClick="CopyItem_onclick()"><spring:message code='ezBoard.t274' /></span></li>
		        <li id="btn_move"><span onClick="MoveItem_onclick()"><spring:message code='ezBoard.t134' /></span></li>
		        <li id="right">
	            	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
	            	<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
					<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" />
				</li>
				<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
			  </ul>
			</div>
			<script type="text/javascript">
			    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
	<table class="content" style="width:100%;">
		<tr>
			<th style="text-align: center"><spring:message code='ezBoard.t185' /></th>
			<td style="text-align: left" colspan="4">
			<span id="selectedBoardName"></span>
			<input type ="text" id="selectedBoard" style="width: 65%;display:none;" value="">
			<input type ="text" id="selectedBoardtype" style="width: 65%;display:none;" value="">
			<input type ="text" id="selectedBoardParentBoardID" style="width: 65%;display:none;" value="">
			<a class="imgbtn"><span onClick="selectBoard()"><spring:message code='ezBoard.khj2' /></span></a>
			<input type="checkbox" id="chkSearchSub" ><spring:message code='ezBoard.t498' /> <%-- 하위검색 --%>
			<input type="checkbox" id="chkSearchAll" ><spring:message code='ezBoard.khj3' /> <%-- 전체검색 --%>
			</td>
		</tr>
		<tr>
			<th style="text-align: center"><spring:message code='ezBoard.t223' /></th>
			<td style="width:50%; white-space:nowrap"><input type="text" id="txtWriterName" style="width: 100%" value=""></td>
			<th style="text-align: center"><spring:message code='ezBoard.t208' /></th>
			<td style="width:50%; white-space:nowrap"><input type="text" id="txtTitle" style="width: 100%" value=""></td>
		</tr>
		<tr>
			<th style="text-align: center"><spring:message code='ezBoard.garm01' /></th>
			<td style="width:50%; white-space:nowrap"><input type="text" id="txtContent" style="width: 100%" value=""></td>
			<th style="text-align: center"><spring:message code='ezBoard.t209' /></th>
			<td style="width:50%; white-space:nowrap"><input type="text" id="txtAbstract" style="width: 100%" value=""></td>
		</tr>
		<tr>
			<th style="text-align: center"><spring:message code='ezBoard.t210' /></th>
			<td colspan="4">
				<input type="text" id="Sdatepicker" style="width: 80px; text-align: center" readonly="readonly">
				~
				<input type="text" id="Edatepicker" style="width: 80px; text-align: center" readonly="readonly">
				<a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezBoard.t220' /></span></a>
			</td>
		</tr>
	</table>
	<br>
	<table style="width:100%;">
	<tr>
		<td style="text-align:center;">
		<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezBoard.t188' /></span></a>
		</td>
	</tr>
	</table>
	<br>
	<h2 class="h2_dot"><spring:message code="ezEmail.t655" /><span id="mailBoxInfo"></span></h2>

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
						<th><spring:message code='ezBoard.t10021' /></th>
						<td><select id="listcount" style="WIDTH: 40px; height: 20px;" onchange="ListCount(this.value);">
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
	<span id="PreviewRayerH" style="border:0px solid red; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
		<span class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block;">
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
							<dt>
								<spring:message code='ezBoard.t223' />: 
								<span id="PreH_MailReceiver" style="display: inline-block"></span>
							</dt>
						</dl>
					</div>
				</span> 
			
				<iframe id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
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
		                	<dt><spring:message code='ezBoard.t223' />:</dt>
		                    <dd><span id="PreW_MailReceiver" style="display: inline-block"></span>
		                    </dd>
		                </dl>
					</div>
				</span>
		                
		       	<iframe id="ifrmPreViewW" name="ifrmPreViewW" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
			</span>
		 </span>
	</span>
</body>
</html>