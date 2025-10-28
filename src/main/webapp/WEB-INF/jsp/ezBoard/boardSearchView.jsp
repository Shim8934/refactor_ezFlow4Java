<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code="ezBoard.khj1" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<style>
			.h2_dot {
				background: url(/images/kr/left/left_dot02.gif) no-repeat 0px 70%;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		
		<script type="text/javascript">
			var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.name}";
			var Use_OneLineCount = "";
			var CurPage = "";
			var totalPage = "";
			var strListInfo = "";
			var OrderCell = "";
			var OrderOption = "";
			var pBoardType = "N";   //새 게시물 타입
			var SQLPARADATA = "";
			var pAdminType = "";   //mailboxInfo
			var ShowAdjacent = ""; //더블클릭
			var startdate = "";
			var enddate = "";
			var usepostDate = false;
			var isSearchPage = true;
			var g_bPrevShow = false; // 게시물 검색회면에는 미리보기 없음
			var keyType = "<c:out value='${keyType}'/>";
			var keyData = "<c:out value='${keyData}'/>";
			
			document.onselectstart = function () { return false; };
			
			window.onload = function () {
				if (navigator.userAgent.indexOf('Firefox') != -1) {
			        document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
				$("#Sdatepicker").datepicker('disable');
		        $("#Edatepicker").datepicker('disable');
		        
		        var height = parseInt(document.documentElement.clientHeight - 340);
		        document.getElementById("divList").style.height = height + "px";
		        getBoardList_after(loadXMLString("${listHeader}"));
				
				if(document.getElementById("BoardList_TR_noItems") != null) {
                	document.getElementById("BoardList_TR_noItems").outerHTML = "";
                }
				
				document.getElementById("mailBoxInfo").innerHTML = "";
				
				/* 2018-07-20 홍승비 - 게시판검색 > 검색결과 좌측네모 IE에서 높이조절 */
		        if (navigator.userAgent.toLowerCase().indexOf('chrome') == -1) {
					document.getElementsByClassName("h2_dot")[0].style.background = "url(/images/kr/left/left_dot02.gif) no-repeat 0px 67%";
		        }
		        
		        if (keyType != "" && keyData != "") {
                    CurPage = "1";
                    var tempData = "<" + keyType + "><![CDATA[" + keyData + "]]></" + keyType + ">";
                    SQLPARADATA = "<ROOT><TYPE>" + "SEARCHALLBOARD;" + keyType + ";" + "</TYPE><DATA>" + tempData + "</DATA></ROOT>";
                    document.querySelector('#searchCondition').style.display = "none";
                    document.querySelector('#divList').style.height = "auto";
                    document.querySelector('#divList').style.maxHeight = "350px";
                    document.querySelector('#searchTitle').innerText = "<spring:message code='ezApprovalG.t1200' /> <spring:message code='ezBoard.khj1' />"
                    getBoardList();
		        }
			};
			
			$(document).ready(function() {
				if(document.getElementById("selectedBoardName").value == undefined) {
					document.getElementById("selectedBoard").value = "all";
					document.getElementById("selectedBoardName").innerHTML = "<spring:message code='ezBoard.khj5' />";
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
			    var SDate;
		        var EDate;
		        
	            SDate = new Date(startdate);
	            EDate = new Date(enddate);
		        
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
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
					monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					           "<spring:message code='main.t0627' />"],
					dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                "<spring:message code='main.t0627' />"],
					dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					              "<spring:message code='main.t0627' />"],
					weekHeader: "Wk",
					dateFormat: "yy-mm-dd",
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: "show",
					showMonthAfterYear: true
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		    
		    function DateSearch_Click() {
		        if(usepostDate){
		            usepostDate = false;
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        } else {
		            usepostDate = true;
		            $("#Sdatepicker").datepicker('enable');
		            $("#Edatepicker").datepicker('enable');
		        }
		    }
			
			function getBoardList(type) {
			    if (SQLPARADATA != ""){
			    	url = "/ezBoard/getSearchBoardList.do";
			    }
			    else{
			    	url = "/ezBoard/getBoardList.do";
			    }
			    ShowProgress();
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
						hideProgress();
						getBoardList_after(loadXMLString(xml));
					}
				});	
			}
			
			function getBoardList_after(xml) {
			    try { 
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
			        
			    }
			    catch (e) {
			    	alert("getBoardList_after : " + e.description);
			    }         
			}
			
			function selectBoard() {
				if (CrossYN()) {
			        OpenWin = GetOpenWindow("/ezBoard/selectBoardItem.do", "selectBoardItem", 457, 600);
			        try { OpenWin.focus(); } catch (e) { }
			    } else { }
			}
			
			function search(type) {
				
				if (type == "basic") {
					if(usepostDate == false){

			        if (document.getElementById("txtWriterName").value == "" && document.getElementById("txtTitle").value == "" && document.getElementById("txtAbstract").value == ""
			         && document.getElementById("txtKeyword").value == "" && document.getElementById("txtContent").value == "") {
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
					
					if(usepostDate == true){
						
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
			    }
			    
			    CurPage = "1";
			    MakeSubCondition();
			    getBoardList();
			}
			
			function MakeSubCondition() {
			    var TYPE = "";
			    var DATA = "";
			    
			  	if (document.getElementById("selectedBoard").value == "all") {					  //SearchAllBoard   	
			    	TYPE += "SEARCHALLBOARD;";
			    } else if(document.getElementById('selectedBoardParentBoardID').value == "top") { //SearchGroupBoard  
			    	TYPE += "SEARCHGROBOARD;";
			    } else { 																		  //SearchSubSubBoard (하위검색default)
			    	TYPE += "SEARCHSUBSUBBOARD;";
			    }
			   
			        if (document.getElementById("txtTitle").value != "")			// DocTitle
			        {
			            TYPE += "TITLE;";
			            DATA += "<TITLE><![CDATA[" + MakeXMLString(document.getElementById("txtTitle").value.replace("'", "''")) + "]]></TITLE>";
			        }
			        
			    	if (document.getElementById("txtContent").value != "") 			// DocContent
			    	{		
						    TYPE += "CONTENT;";
					        DATA += "<CONTENT><![CDATA[" + MakeXMLString(document.getElementById("txtContent").value.replace("'", "''")) + "]]></CONTENT>";
			    	}
			        if (document.getElementById("txtWriterName").value != "")		// DrafterName
			        {
			            TYPE += "WRITERNAME;";
			            DATA += "<WRITERNAME><![CDATA[" + MakeXMLString(document.getElementById("txtWriterName").value.replace("'", "''")) + "]]></WRITERNAME>";
			        }
			
                    if (document.getElementById("txtKeyword").value != "") {	    // KEYWORD	
                            TYPE += "KEYWORD;";
                            DATA += "<KEYWORD><![CDATA[" + MakeXMLString(document.getElementById("txtKeyword").value.replace("'", "''")) + "]]></KEYWORD>";
                    }
			
			        if (document.getElementById("txtAbstract").value != "")			// ABSTRACT
			        {
			            TYPE += "ABSTRACT;";
			            DATA += "<ABSTRACT><![CDATA[" + MakeXMLString(document.getElementById("txtAbstract").value.replace("'", "''")) + "]]></ABSTRACT>";
			        }
			
			        if ($("#Sdatepicker").is(":enabled")) 		// StartDate
			        {
			        	TYPE += "STARTDATE;";
			            DATA += "<STARTDATE><![CDATA[" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + "]]></STARTDATE>";
			        }
			
			        if ($("#Edatepicker").is(":enabled")) 	// EndDate
			        {
			            TYPE += "ENDDATE;";
			            DATA += "<ENDDATE><![CDATA[" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + "]]></ENDDATE>";
			        }
			    
			   		SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";

			}
			
			/* 2018-07-16 홍승비 - 체크박스를 사용하지 않는 게시판검색 전용 선택해제 함수 */
			function tr_unselectedAll(pTableID) {
			    var oList = document.getElementById(pTableID);
			    if (!oList) {
			        return;
			    }
		        var SelList = new ListView();
		        SelList.LoadFromID("BoardListDiv");
		
		        for (var i = 0; i < SelList.GetRowCount() ; i++) {
		            SelList.GetDataRows()[i].childNodes[0].childNodes[0].childNodes[0].checked = false; 
		            SelList.GetDataRows()[i].style.backgroundColor = m_strColorDefault;
		            strListInfo = "";
		        }
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
				if(obj.getAttribute("data13") != "true") { //읽기권한
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
					window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=770,width=790,top=" + pTop + ",left=" + pLeft, "");
				} else if (obj.getAttribute("DATA10") == "7") {
					window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=679,width=764,top=" + pTop + ",left=" + pLeft, "");
	            } else {
					window.open("/ezBoard/boardItemView.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=790,top=" + pTop + ",left=" + pLeft, "");
				}
			}
			
			function ShowProgress() {
			    document.getElementById("MailListRayer").style.display = "";
			    document.getElementById("MailProgress").style.top = "300px";
			    document.getElementById("MailProgress").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";
			    document.getElementById("MailProgress").style.display = "";
			}

			function hideProgress() {
				document.getElementById("MailProgress").style.display = "none";
			}
			
			function search_keypress() {
	            if (window.event.keyCode == "13") {
	            	search('basic');
	            }
	        }
	</script>
</head>
<body class="mainbody"> 
	<h1 id="searchTitle"><spring:message code="ezBoard.khj1" /></h1>	
	<table id="searchCondition" class="content" style="width:100%;">
		<tr>
			<th style="text-align: center"><spring:message code='ezBoard.t185' /></th>
			<td style="text-align: left">
				<a class="imgbtn imgbck" style="vertical-align:middle"><span onClick="selectBoard()"><spring:message code='ezBoard.khj2' /></span></a>
				<span id="selectedBoardName" style="height: 100%; vertical-align: middle; overflow: hidden; display: inline-block; line-height: 27px"></span> 
				<input type ="text" id="selectedBoard" style="display:none;" value="">
				<input type ="text" id="selectedBoardParentBoardID" style="display:none;" value="">
			</td>
		</tr>
		<tr>
			<th style="text-align: center"><spring:message code='ezBoard.t223' /></th>
			<td style="width:50%; white-space:nowrap"><input type="text" id="txtWriterName" style="width: 100%" value="" onkeypress="return search_keypress()"></td>
		</tr>
		<tr>	
			<th style="text-align: center"><spring:message code='ezBoard.t208' /></th>
			<td style="width:50%; white-space:nowrap"><input type="text" id="txtTitle" style="width: 100%" value="" onkeypress="return search_keypress()"></td>
		</tr>
		<tr>
			<th style="text-align: center"><spring:message code='ezBoard.garm01' /></th>
			<td style="width:50%; white-space:nowrap"><input type="text" id="txtContent" style="width: 100%" value="" onkeypress="return search_keypress()"></td>
		</tr>
		<tr>
            <th style="text-align: center"><spring:message code='ezApprovalG.t1200' /></th>
            <td style="width:50%; white-space:nowrap"><input type="text" id="txtKeyword" style="width: 100%" value="" onkeypress="return search_keypress()"></td>
        </tr>
		<tr>	
			<th style="text-align: center"><spring:message code='ezBoard.t209' /></th>
			<td style="width:50%; white-space:nowrap"><input type="text" id="txtAbstract" style="width: 100%" value="" onkeypress="return search_keypress()"></td>
		</tr>
		<tr>
			<th style="text-align: center"><spring:message code='ezBoard.t210' /></th>
			<td>
				<div class="custom_checkbox">
					<input type="checkbox" value="1" id="usepostdate" onclick="DateSearch_Click()">
					<label for="usepostdate"><spring:message code='ezCircular.t138'/></label>
				</div>
				<input type="text" id="Sdatepicker" style="width: 80px; text-align: center" readonly="readonly"> ~
				<input type="text" id="Edatepicker" style="width: 80px; text-align: center" readonly="readonly">
				<a class="imgbtn imgbck" style="vertical-align:middle;margin-left:10px;"><span onClick="search('basic')" style="vertical-align: middle; line-height: 20px;"><spring:message code='ezBoard.t188' /></span></a>
			</td>
		</tr>
	</table>
	
	<br>
	<h2 class="h2_dot"><spring:message code="ezEmail.t655" /><span id="mailBoxInfo"></span></h2>
	    
	<span id="MailListRayer" style="border: 0px solid blue; width:100%; height: 100%; vertical-align: top; overflow: hidden; display: inline-block;">
		<div style="width:100%;" id="divList">
			<div id="lvBoardList"></div>
		</div>
		<div id="tblPageRayer" style="text-align:center"></div>
	</span>
	
	<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		<img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
	</div>
	
</body>
</html>