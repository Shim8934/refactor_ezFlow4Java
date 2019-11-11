<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code="ezTotalSearch.t0001" /></title>
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css">
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css">
<link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezSearch/convertZenHankaku.js')}"></script>
</head>
<style type="text/css">
/*datepicker를 맨 위에 있는 것처럼 보이기.*/
.ui-datepicker {
	z-index:999 !important
}
#approvalResult tr{
	cursor:pointer
}

#boardResult tr{
	cursor:pointer
}

#selectedRow {
	background-color : rgb(237, 244, 253)
}

#mouseoverRow {
	background-color : rgb(244, 245, 245)
}

/* loading progress bar */

.wrap-loading {
	position : fixed;
	left : 0;
	right : 0;
	top : 0;
	bottom : 0;
	background: rgba(0,0,0,0.5);
	z-index : 999;
}
.loading_layer {
    z-index: 999;
    position: relative;
    top: 50%;
    left: 45%;
    margin: -100px 0 0 -200px;
}
.display_none {
	display: none;
}



.point5 { color: #017BEC ; font-weight:bold;}
.btnpositionUL { list-style: none; margin: 0px; padding: 0px; text-align: center; }

.portlet_tabpart01 {position:relative; clear:both; margin:15px 0px 0px; z-index:100;}
.portlet_tabpart01_top { height: 30px; list-style: none; margin: 0px; padding: 0px; border-bottom:1px solid rgb(153, 153, 153); }
.portlet_tabpart01_top p {float:left; margin:0px; padding:0px;}
.portlet_tabpart01_top p span { display: block; float: left; height: 29px; line-height: 27px; font-weight: bold; color: rgb(153, 153, 153); cursor: pointer; padding: 0px 20px; margin: 0px 1px 0px 0px; border-width: 1px 1px 0px; border-style: solid solid none; border-color: rgb(209, 209, 209) rgb(209, 209, 209) rgb(209, 209, 209); border-image: initial; border-bottom: 0px none; }
.portlet_tabpart01_top p .tabover { position: relative; color: rgb(51, 51, 51); z-index: 100; border-width: 1px; border-style: solid; border-color: rgb(153, 153, 153) rgb(153, 153, 153) rgb(238, 238, 238); border-image: initial; border-bottom: 1px solid rgb(238, 238, 238); background: white; }
.portlet_tabpart01_top p span:hover { position: relative; color: rgb(51, 51, 51); z-index: 100; border-width: 1px; border-style: solid; border-color: rgb(153, 153, 153) rgb(153, 153, 153) rgb(238, 238, 238); border-image: initial; border-bottom: 1px solid rgb(238, 238, 238); background: white; }

.divAprList td{height:22px;}
</style>
<script type="text/javascript">

/*
 	namespace pattern. 
 	전역변수의 최소화.
 */
if(typeof totalSearch === 'undefined') {
	var totalSearch = {};
	
	totalSearch.data = {};
	
	totalSearch.approval = {};
	
	totalSearch.board = {};
}

/*
 * Jquery ReadyFunc.
 */
$(document).ready(function(){
	/* datepicker setting start. */
	var monthMsg = "<spring:message code='ezSchedule.t110' />";
	var monthStr = monthMsg.split(";");		    
	var dayMsg = "<spring:message code='ezSchedule.t108' />";
	var dayStr = dayMsg.split(";");
	var dt = new Date();
	var year = dt.getFullYear();
	var month = dt.getMonth() + 1;
	var day = dt.getDate();
	var today = year + "-" + month + "-" + day;

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
	
	$("#sDatepicker").datepicker({
    	changeMonth: true,
    	changeYear: true,
    	autoSize: true,
    	showOn: "both",
    	buttonImage: "/images/ImgIcon/calendar-month.gif",
    	buttonImageOnly: true
    });
	
	$("#eDatepicker").datepicker({
    	changeMonth: true,
    	changeYear: true,
    	autoSize: true,
    	showOn: "both",
    	buttonImage: "/images/ImgIcon/calendar-month.gif",
    	buttonImageOnly: true
    });	
    
    $("#sDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
    $("#sDatepicker").datepicker('setDate', today);
    $("#eDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
    $("#eDatepicker").datepicker('setDate', today);    
   	$("#sDatepicker").datepicker('disable');
	$("#eDatepicker").datepicker('disable');
	// 최초 datepicker는 disabled로 설정
	$("#sDatepicker").prop("disabled", true);
	$("#eDatepicker").prop("disabled", true);
    
	/* datepicker setting end.*/
	
    var isTop = chkTopSearch();
    
    // 처음엔 '모든'탭을 열기
    $(".portlet_tabpart01_top span#all").prop("class", "tabover");
    
    // 클릭하면 해당 탑을 tabover 하기
    $(".portlet_tabpart01_top span").on("click", function(){
    	clickTab(this.id);
    });
    
    if(!isTop) {
    	$("#approvalResult").append(noData());
    	$("#boardResult").append(noData());
    }
    
    $("#tblPageRayer").css("display", "none");

    
    /* 전자결재리스트 관련 이벤트 시작 */
    $("#approvalResult").delegate("tr", "click", function(){
		selectTR(this);
    });
    
    $("#approvalResult").delegate("tr", "mouseover", function(){
		mouseoverTR(this);
    });
    
    $("#approvalResult").delegate("tr", "mouseout", function(){
		$("#mouseoverRow").prop("id", "");
    });        
    
    $("#approvalResult").delegate("tr", "dblclick", function(){
		if(this.id !== "noData") {
    		dblClickApproval($(this).attr("docid"));
		}
    });
    /* 전자결재리스트 관련 이벤트 끝 */
    
    /* 게시판 관련 이벤트 시작 */
    $("#boardResult").delegate("tr", "click", function(){
		selectTR(this);
    });
    
    $("#boardResult").delegate("tr", "mouseover", function(){
		mouseoverTR(this);
    });
    
    $("#boardResult").delegate("tr", "mouseout", function(){
		$("#mouseoverRow").prop("id", "");
    });      
    
    $("#boardResult").delegate("tr", "dblclick", function(){
    	if(this.id !== "noData") {
    		dblClickBoard($(this).attr("boardid"), $(this).attr("itemid"));
    	}
    });
    /* 게시판 관련 이벤트 끝 */
    
    /* pagenation 관련 이벤트 시작 */
    $("#pagenavi").delegate("#pageCnt", "click", function() {
    	totalSearch.data.page = this.innerHTML;                // 페이지 재설정
    	callSearchController();
    });
    
    $("#pagenavi").delegate("#next", "click", function() {
    	totalSearch.data.page = (totalSearch.data.lastPage*1 + 1)+"";
    	callSearchController();
    });
    
    $("#pagenavi").delegate("#pre", "click", function() {
    	totalSearch.data.page = (totalSearch.data.startPage*1 - 10)+"";
    	callSearchController();
    });    
    
    $("#pagenavi").delegate("#n_next", "click", function() {
    	totalSearch.data.page = (totalSearch.data.totalPage)+"";
    	callSearchController();
    });
    
    $("#pagenavi").delegate("#p_pre", "click", function() {
    	totalSearch.data.page = 1+"";
    	callSearchController();
    });
    /* pagenation 관련 이벤트 끝 */
    
    $("#chkTitleRange").prop("checked", true);
})

/*
 	pagenation에 필요한 객체 생성. 
 */
function pageObj(cnt) {
	
	var listRowCnt = totalSearch.data.automax;        // 한 페이지에 뿌려질 row 갯수
	var underPageCnt = 10;                            // 하단 페이지 갯수 ex)1~10, 1~5....
	var curPage = totalSearch.data.page               // 현재 페이지
	var totalCnt = cnt                                // 전체 row 갯수 ex) 총 100개의 데이터를 10개 페이지에 출력-> rowCnt : 100
	
	var obj = {
			curPage : curPage                                 // 현재 페이지
			,pageCnt : Math.ceil(totalCnt/listRowCnt)          // 총 페이지 갯수 계산.
			,startPage : (Math.floor((curPage*1-1) / underPageCnt) * underPageCnt) + 1    // 시작 페이지 ex) 1~10, 11~20 에서 1, 11
			,lastPage : (Math.floor((curPage*1-1) / underPageCnt) + 1) * underPageCnt     // 마지막페이지 ex) 1~10, 11~20 에서 10, 20
				
	};
	
	totalSearch.data.totalPage = obj.pageCnt; // 총 페이지 번호 저장.
	totalSearch.data.startPage = obj.startPage; // 시작 페이지 번호 저장.
	totalSearch.data.lastPage = obj.lastPage; // 마지막 페이지 번호 저장.
	
	return obj;
}

/*
 *	pagenation. 
 */
function pagenation(obj) {
	
	var curPage = obj.curPage;
	var pageCnt = obj.pageCnt; 
	var startPage = obj.startPage;
	var lastPage = obj.lastPage;
	
	if(lastPage*1 >= pageCnt*1) lastPage = pageCnt; 
	
	$("#pagenavi").empty();
	
	var str = "";
	
	if(startPage == 1) {
		if(startPage == curPage) str += '<span id="" class="btnimg"><a><img src="/images/kr/cm/btn_p_prev01.gif"></a></span>';
		else str += '<span id="p_pre" class="btnimg"><a><img src="/images/kr/cm/btn_p_prev.gif"></a></span>';
		
		str += '<span id="" class="btnimg"><img src="/images/kr/cm/btn_prev01.gif"></span>';
	} else {
		str += '<span id="p_pre" class="btnimg"><a><img src="/images/kr/cm/btn_p_prev.gif"></a></span>';
		str += '<span id="pre" class="btnimg"><img src="/images/kr/cm/btn_prev.gif"></span>';			
	}
	
	// 선택된 페이지 효과 넣기.
	for(var i=startPage; i<=lastPage; i++) {
		if(curPage == i) {
			str += '<span class="on">' + i + '</span>';
		}else {
			str += '<span id="pageCnt">'+ i +'</span>';	
		}
	}
	
	
	if(lastPage == pageCnt) {
		str += '<span id="" class="btnimg"><img src="/images/kr/cm/btn_next01.gif"></span>';
		
		if(lastPage == curPage) str += '<span id="" class="btnimg"><img src="/images/kr/cm/btn_n_next01.gif"></span>';		
		else str += '<span id="n_next" class="btnimg"><img src="/images/kr/cm/btn_n_next.gif"></span>';
	} else {
		str += '<span id="next" class="btnimg"><img src="/images/kr/cm/btn_next.gif"></span>';
		str += '<span id="n_next" class="btnimg"><img src="/images/kr/cm/btn_n_next.gif"></span>';
	}
	
	
	$("#pagenavi").append(str);
	
} 

/**
  	게시판 상세 팝업
 */
function dblClickBoard(boardID, itemID) {
	var boardList = totalSearch.board;
	var pheight = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - 720) / 2;
	var pLeft = (pwidth - 790) / 2;
	var url = "";
	var gubun = "";
	var readAuthor = "";
	
/* 	$(boardList).each(function() {
		if(this.BoardID === boardID && this.ItemID === itemID) {
			gubun = this.GUBUN;
		}
	});
	
	console.log(boardList); */
	
	/**
		게시판 읽기 권한 체크
	*/
	$.ajax({
		method: "POST",
		url: "/ezPortal/chkBoardReadAuthor.do",
		type: "json",
		async: false,
		contentType: "application/json",
		data : JSON.stringify({
			boardID: boardID
		}),
		success: function (result) {
			readAuthor = result;
		}
	});
	
	if(readAuthor === "true") {
		boardList.filter(function(e){
			return e.boardId === boardID && e.itemId === itemID ? gubun = e.gubun : "";
		});
	
		//포토게시판:3, 썸네일게시판:4
		if(gubun == "3" || gubun == "4") {
			url = "/ezBoard/boardItemViewPhoto.do";
		} else {
			url = "/ezBoard/boardItemView.do";
		}
		
		url += "?itemID=" + itemID +"&boardID=" + boardID + "&location=GENERAL";
		window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=790,top=" + pTop + ",left=" + pLeft, "");		
	} else {
		alert("<spring:message code='ezBoard.t194' />");		
	}
}

/**
	전자결재 상세 팝업
 */
function dblClickApproval(docID) {
	var appList  = totalSearch.approval;
	var docInfo;
	var url = "/ezApprovalG/contDocView.do";
	
/* 	$(appList).each(function() {
		if(this.DocID === docID) {
			docInfo = this;	
		}
	}); */
	
	appList.filter(function(e){
		e.docId === docID ? docInfo = e : null;
	});

	url += "?docID=" + encodeURI(docInfo.docId) + "&docHref=" + encodeURI(docInfo.href);
	
	openwindow(url, "", "", "");
}

/**
 	mouseover
 */
function mouseoverTR(tr) {
	if(tr.id !== "selectedRow" && tr.id !=="noData") {
		$("#mouseoverRow").prop("id", "");
		$(tr).prop("id", "mouseoverRow");
	} 
	
	if(tr.id === "noData") {
	}
}

/**
 	셀을 선택했을 경우
 */
function selectTR(tr) {
	if(tr.id!=="noData"){
		$("#selectedRow").prop("id", "");
		$(tr).prop("id", "selectedRow");
	}
}

/**
 *	특정 tab을 선택했을 경우
 */
function clickTab(tabId) {
	
	$(".portlet_tabpart01_top span").prop("class", "");
	$(".portlet_tabpart01_top span#"+tabId).prop("class", "tabover");
	
	tabId === "all" ? selectAllTab() : selectOtherTab(tabId);
}

/**
 *	'모든' 탭을 선택한 경우 
 */
function selectAllTab() {
	$("#totalCntPrint").css("display", "block");
	$("#approvalListDiv").css("display", "");
	$("#boardListDiv").css("display", "");
	$(".moreResult").css("display", "");
	$("#tblPageRayer").css("display", "none");
	
	totalSearch.data.type = 'all';
	totalSearch.data.automax = '5';             // 한 페이지에 출력하는 갯수.
	totalSearch.data.page = '1';                // 페이지.
	callSearchController();
}
 
/**
 *  다른 탭을 선택한 경우
 */
function selectOtherTab(tabId) {
	
	$("#totalCntPrint").css("display", "none");
	
	if(tabId === "approval") {
		$("#approvalListDiv").css("display", "");	
		$("#boardListDiv").css("display", "none");
		$(".moreResult").css("display", "none");
		$("#tblPageRayer").css("display", "");
		
		totalSearch.data.type = "approval";
	} else if (tabId === "board") {
		$("#boardListDiv").css("display", "");
		$("#approvalListDiv").css("display", "none");	
		$(".moreResult").css("display", "none");
		$("#tblPageRayer").css("display", "");
		
		totalSearch.data.type = "board";
	}
	// '더보기' 페이지에선 10개씩 뿌리기	
	totalSearch.data.automax = "10";          // 한 페이지에 출력하는 갯수.
	totalSearch.data.page = '1';              // 페이지.
	
	callSearchController();
}

/*
 *	상단메뉴바에서 검색을 했을 경우 처리
 *	true or false 리턴
 */
function chkTopSearch() {
	var initKeyword = "${keyword}";
	if(initKeyword !== null && initKeyword !== "") {
		$("#txtKeyword").val(initKeyword.trim());
		$("#chkTitleRange").prop("checked", true);
		
		btn_searchStart();
		return true;
	}
	return false;
}

function convertSpecialChar(pOrgString) {
    if (pOrgString == "undefined" || pOrgString == undefined) {
        return "";
    }
    return ReplaceText(ReplaceText(ReplaceText(ReplaceText(pOrgString, "<", "&lt;"), ">", "&gt;"), "'", "&apos;"), "\"", "&quot;");
}

/*
 *	검색버튼 클릭 이벤트 
 */
function btn_searchStart() {
	var txtKeyword = convertSpecialChar($("#txtKeyword").val()).trim(); // 검색어
	var startDate = "";
	var endDate = "";
	var searchRange="";
	var type =""; //전체검색 || 전자결재 || 게시판
	/**
		검색기간 확인
	*/
	var isUseDate = $("#chkWriteDate").prop("checked");
	if(isUseDate) {
		startDate = $("#sDatepicker").val();
		endDate = $("#eDatepicker").val();
		
		var sDate = new Date(startDate);
		var eDate = new Date(endDate);
		
		if (sDate > eDate) { 
			alert("<spring:message code='ezCommunity.t1058'/>");
			return ;
		}
	}
	
	/*
		검색범위 확인
	*/
	var isAllChk = $("#chkAllRange").prop("checked");
	if(isAllChk) {
		searchRange = "ALL";
	} else {
		$("#chkRange input").each(function(i, elem){
			$(elem).prop("checked") && i > 1 ? searchRange += "|" : "";
			$(elem).prop("checked") ? searchRange += $(elem).prop("value") : "";
		});	
	}
	
	/*
		vaildation Check
	*/
	if(txtKeyword === "" || txtKeyword === null || txtKeyword.length < 2) {
		alert("<spring:message code='ezTotalSearch.t0002'/>");		
		return;
	} else if(searchRange === "" || searchRange === null) {
		alert("<spring:message code='ezTotalSearch.t0003'/>");
		return;
		
	} else if(isUseDate && ( startDate === "" || endDate === "" )) {
		alert("<spring:message code='ezTotalSearch.t0004'/>");
		return;
	}

	/*
		전각 반각 둘다 반환해서 한꺼번에 처리하기
	*/
	var changeToHenkaku = mbConvertKana(txtKeyword, 'rnask');;
	var changeToZenkaku = mbConvertKana(txtKeyword, 'RNASKV');
	
	$("#resultKeyword").html(txtKeyword);
	
	txtKeyword = changeToHenkaku + ' | ' + changeToZenkaku;
	
	totalSearch.data = {
		 keyword : txtKeyword
		,startDate : startDate
		,endDate : endDate
		,searchRange : searchRange
		,automax : "5"     //한페이지에 출력하는 양.
		,page : "1"        //페이지정보도 받아서 처리하는 거로 변경해야함.
		,type : type
		,btnStart : true  // 검색버튼으로 실행했을 경우.
	}
	
	clickTab("all");
}

/**
	검색리스트 controller 호출 
*/
function callSearchController() {
	var data = totalSearch.data;
	
	// 검색어 데이터가 있을 때만 동작
	if(data.keyword !== undefined) {
		/**
			검색 시작
		*/
		$.ajax({
			method : "POST",
			url : "/ezPortal/getTotalSearchList.do",
			type : "json",
			contentType : "application/json",
			data : JSON.stringify(data),
			success : function (res) {
				
				console.log(res);
				
				if (res == null) {
					alert("에러가 발생하였습니다.");
					return;
				}
				
				if (res.error != null) {
					console.log(res.error);
					alert("에러가 발생하였습니다.");
					return;
				}
				
				var approvalList = [];
				var boardList = [];
				
				if (data.type == "all") {
					for (var i = 0; i < res.result.length; i++) {
						if (res.result[i].type == "board") {
							boardList = res.result[i];
						} else {
							approvalList = res.result[i];
						}
					}
				} else if (data.type == "board") {
					boardList = res.result[0];
				} else {
					approvalList = res.result[0];
				}
				
				var listCnt = 1;
				
				$("#approvalResult").empty();
				$("#boardResult").empty();	
				
				//리스트에 출력하는 로직.
				if(approvalList !== undefined && approvalList.list.length > 0) {
					$("#approvalResultCnt").empty().append(approvalList.totcnt);
 					$(approvalList.list).each(function(i, e){
						$("#approvalResult").append(approvalDataAssembler(this));
					});
/* 					approvalList.list.map(function(e){
						$("#approvalResult").append(approvalDataAssembler(e));
					}); */
					
					//리스트 갯수
					listCnt = approvalList.totcnt*1;
					
					//결과 담아두기.
					totalSearch.approval = approvalList.list;
				} else {
					$("#approvalResultCnt").empty().append("0");
					$("#approvalResult").append(noData());
				}
				
				if(boardList != undefined && boardList.list.length > 0) {
					$("#boardResultCnt").empty().append(boardList.totcnt);
 					$(boardList.list).each(function(i, e){
						$("#boardResult").append(boardDataAssembler(this));
					});
					
/* 					boardList.list.map(function(e){
						$("#boardResult").append(boardDataAssembler(e));
					}); */
					
					//리스트 갯수
					listCnt = boardList.totcnt*1;
					
					//결과 담아두기.
					totalSearch.board = boardList.list;				
				} else {
					$("#boardResultCnt").empty().append("0");
					$("#boardResult").append(noData());
				}
				
				if (data.type !== "all") {
					// pagenation.
					pagenation(pageObj(listCnt));
				}
				
				//전체 검색량
				if(approvalList !== undefined && boardList !== undefined) {
					var totalCount = approvalList.totcnt*1 + boardList.totcnt*1;
					$("#totalCnt").empty().append(totalCount);				
				}
			},
			beforeSend : function() {
				setTimeout(function(){ //순식간에 나오는 데이터들은 딱히 보여줄 필요가 없을 것 같아서 settimeout 처리
					if(totalSearch.data.btnStart) { // 탭 이동간에는 보여줄 필요가 없다고 판단. 검색버튼으로 접근했을 경우에만 처리.
						$(".wrap-loading").removeClass('display_none');
						$(".wrap-loading", parent.frames['left'].document).removeClass('display_none'); // iframe 밖에 있는 leftMenu도 컨트롤.
					}					
				},300);
			},
			complete : function() {
				$(".wrap-loading").addClass('display_none');	
				$(".wrap-loading", parent.frames['left'].document).addClass('display_none');
				totalSearch.data.btnStart = undefined;
			}
		});	
	
	}
}

/**
  	리스트에 데이터가 없을 경우.
 */
function noData() {
	var str = "";
	
	str += "<tr id='noData'>";
	str += "<td align='center' colspan='6'>"+ "<spring:message code='ezTotalSearch.t0005'/>"+"</td>"
	str += "</tr>";
	
	return str;
}

/**
 	게시판 리스트 출력
 */
function boardDataAssembler(data) {
	var str = "";	

	str += "<tr boardid='"+ data.boardId +"' itemid='"+ data.itemId +"'>";
	str += "<td>"+ data.boardName + "</td>";
	str += "<td>"+ data.title + "</td>";
	str += "<td>"+ data.writerDeptName + "</td>";
	str += "<td>"+ data.writerName + "</td>";
	
	var writeDate = data.writeDate;
	var writeDateStr = writeDate.substring(0,4); //년도
	writeDateStr += "-" + writeDate.substring(4,6); //월
	writeDateStr += "-" + writeDate.substring(6,8); //일
	str += "<td>"+ writeDateStr + "</td>";
	
	if(data.attachments != 0) {
		str += "<td><img src='/images/newAttach.gif'></td>";	
	} else {
		str += "<td></td>";
	}
	str += "</tr>";	
	
	return str;
}
	
/**
	결재 리스트 출력
*/
function approvalDataAssembler(data) {
	var str = "";

	str += "<tr docid='"+ data.docId +"'>";
	str += "<td>"+ data.docNo + "</td>";
	str += "<td>"+ data.docTitle + "</td>";
	str += "<td>"+ data.writerDeptName + "</td>";
	str += "<td>"+ data.writerName + "</td>";
	
	var endDate = data.endDate;
	var endDateStr = endDate.substring(0,4); //년도
	endDateStr += "-" + endDate.substring(4,6); //월
	endDateStr += "-" + endDate.substring(6,8); //일
	
	str += "<td>"+ endDateStr + "</td>";
	
	if(data.hasAttachYN === "Y") {
		str += "<td><img src='/images/newAttach.gif'></td>";
	} else {
		str += "<td></td>";
	}
	str += "</tr>";
	
	return str;
}


/*
 *	검색범위 설정 
 */
function chkSearchRange(value) {
	/*
		1. '모든'을 했을 경우 뒤에 내용도 선택
		2. 나머지를 다 선택했을 때 '모든'도 선택
	*/
	if(value ==="ALL") {
		var isCheck = $("#chkAllRange").prop("checked");
		
		$("#chkRange input").each(function(i, elem){
			if(isCheck) {
				$(elem).prop("checked", true);	
			} else {
				$(elem).prop("checked", false);
			}
		});
	} else {
		var isTitleChk = $("#chkTitleRange").prop("checked");
		var isContentChk = $("#chkContentsRange").prop("checked");
		var isAttachChk = $("#chkAttachsRange").prop("checked");
		var isWriterChk = $("#chkWriterRange").prop("checked");
		
		if(isTitleChk && isContentChk && isAttachChk && isWriterChk) {
			$("#chkAllRange").prop("checked", true);	
		} else {
			$("#chkAllRange").prop("checked", false);	
		}
	}
}

/*
 *	검색기간 설정
 */
function chkWriteDateOnclick(elem) {
	/*
		검색기간 활성화, 비활성화
	*/
	var isChk = $("#"+elem).prop("checked");
	
	if(isChk) { //showDatePicker
		$(".hasDatepicker").prop("disabled", false);
		$("#sDatepicker").datepicker('enable');
		$("#eDatepicker").datepicker('enable');
	} else {
		$(".hasDatepicker").prop("disabled", true);
		$("#sDatepicker").datepicker('disable');
		$("#eDatepicker").datepicker('disable');
	}
}

/**
 * openWindow 	
 */
function openwindow(wfileLocation, wName, wWidth, wHeight) {
	try {
		var heigth;
		var width;
		
		if (wWidth === "" || wHeight === "") {
			heigth = window.screen.availHeight;
			width = window.screen.availWidth;						
		} else {
			heigth = wHeight;
			width = wWidth;
		}
		
		var left = 0;
		var top = 0;
		
		if (window.screen.width > 800) {
			var pleftpos;
			
			pleftpos = parseInt(width) - 967;
			heigth = parseInt(heigth) - 30;
			if (CrossYN()) {
				heigth = parseInt(heigth) - 25;
			}
			
			if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
				heigth = parseInt(heigth) - 40;
			}
			
			width = parseInt(width) - pleftpos;
			left = Math.abs(pleftpos / 2);
		} else {
			heigth = parseInt(heigth) - 30;
			if (CrossYN()) {
				heigth = parseInt(heigth) - 25;
			}
			
			if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
				heigth = parseInt(heigth) - 40;
			}
			
			width = parseInt(width) - 10;
		}
		
		window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
		
		} catch (e) {
			alert("openwindow :: " + e.description);
		}
}

function totalSearchEnterEevnt() {
	if(window.event.keyCode === 13) {
		btn_searchStart();	
	}
}
</script>
<body class="mainbody">
    <h1><spring:message code="ezTotalSearch.t0001" /></h1>
    <table border="0" cellpadding="0" cellspacing="0">
        <tbody>
            <tr>
                <td class="page">&nbsp; </td>
            </tr>
        </tbody>
    </table>
    <table class="content" border="0" cellpadding="0" cellspacing="0" style="width:100%">

        <tbody>
            <tr style="height:30px;">
                <th width="100" align="center"><spring:message code="ezTotalSearch.t0006" /></th>
                <td>
                    <span class="spanText" style="margin-left:0px;">
                        <input type="text" name="txtKeyword" id="txtKeyword" onkeyup="totalSearchEnterEevnt()" style="width:220px">
                        <font class="point5"><spring:message code="ezTotalSearch.t0007" /></font>
                    </span>
                </td>
            </tr>

            <tr style="display:none">
                <th height="30" align="center"><spring:message code="ezTotalSearch.t0008" /></th>
                <td>
                    <span class="spanText" style="margin-left:0px;">
                        <input type="text" name="txtSearchWriter" id="txtSearchWriter" onkeydown="Search_onkeydown()">
                    </span>
                </td>
            </tr>

            <tr style="height:30px;">
                <th align="center"><spring:message code="ezTotalSearch.t0009" /></th>
                <td>
                    <span class="spanText" style="margin-left:0px;">
                        <input type="checkbox" name="chkWriteDate" id="chkWriteDate" value="" onclick="chkWriteDateOnclick(this.id)">
                        <span><spring:message code="ezTotalSearch.t0010" />&nbsp;</span>
                        <span id="showDatePicker">
                        <input type="text" id="sDatepicker" style="width:80px;text-align:center" readonly>
		                 ~
		                <input type="text" id="eDatepicker" style="width:80px;text-align:center" readonly>
		                </span>
                    </span>
                </td>
            </tr>
            <tr style="height:30px;">
                <th align="center"><spring:message code="ezTotalSearch.t0011" /></th>
                <td>
                    <span class="spanText" id="chkRange" style="margin-left:0px;">
                        <input type="checkbox" name="chkAllRange" id="chkAllRange" value="ALL" onclick="chkSearchRange(this.value);">
                        <spring:message code="ezTotalSearch.t0012" /> &nbsp;&nbsp; &nbsp;&nbsp;
                        <input type="checkbox" name="chkTitleRange" id="chkTitleRange" value="TITLE" onclick="chkSearchRange(this.value);">
                        <spring:message code="ezTotalSearch.t0013" />&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" name="chkContentsRange" id="chkContentsRange" value="CONTENTS" onclick="chkSearchRange(this.value);">
                        <spring:message code="ezTotalSearch.t0014" />&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" name="chkAttachsRange" id="chkAttachsRange" value="ATTACH" onclick="chkSearchRange(this.value);">
                        <spring:message code="ezTotalSearch.t0015" />&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" name="chkWriterRange" id="chkWriterRange" value="WRITER" onclick="chkSearchRange(this.value);">
                        <spring:message code="ezTotalSearch.t0008" />
                    </span>
                </td>
            </tr>
        </tbody>
    </table>
    <div class="btnposition">
        <ul class="btnpositionUL">
            <li class="on"><a class="imgbtn"><span style="cursor:pointer;" onclick="btn_searchStart();"><spring:message code="ezTotalSearch.t0016" /></span></a></li>
        </ul>
    </div>
    <div id="Result_AllList" style="display: block;">
        <table cellspacing="0" cellpadding="0" border="0">
            <tbody>
                <tr>
                    <td>
                        <spring:message code="ezTotalSearch.t0017" />
                    </td>
                </tr>
            </tbody>
        </table>
        <div id="tabnav" class="portlet_tabpart01" style="width:100%">
            <div class="portlet_tabpart01_top">
                <p><span id="all" class=""><spring:message code="ezTotalSearch.t0012" /></span></p>
                <p><span id="approval" class=""><spring:message code="ezTotalSearch.t0018" /></span></p>
                <p><span id="board" class=""><spring:message code="ezTotalSearch.t0019" /></span></p>
            </div>
        </div>

        <div id="totalCntPrint" class="divAprList" style="margin-top: 15px; margin-bottom: 15px; display: block;">
            <table cellspacing="0" cellpadding="5" border="0">
                <tbody>
                    <tr>
                        <td style="font-size:11pt">
                            &nbsp;"
                            <span class="point5" id="resultKeyword" style="font-size:11pt"></span>"&nbsp;<spring:message code="ezTotalSearch.t0020" />&nbsp; 
                            <span class="point5" id="totalCnt" style="font-size:11pt">0</span>&nbsp;<spring:message code="ezTotalSearch.t0021" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <br />
        <!-- 전자결재 -->
        <div id="approvalListDiv"">
	        <table cellspacing="0" cellpadding="7" width="100%" border="0" class="divAprList" id="Aprmenulist">
	            <tbody>
	                <tr>
	                    <td>
	                        <img  src="/images/totalsearch/total_search_icon01.png"  width="16" height="16" style="vertical-align:middle;">
	                        <b><spring:message code="ezTotalSearch.t0018" /></b> <spring:message code="ezTotalSearch.t0028" /> (<span class="point5" id="approvalResultCnt">0</span><spring:message code="ezTotalSearch.t0032" />)
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	        <div id="">
	            <table id="approvalTable" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="" rowondblclick="test" width="100%" border="0" class="mainlist">
	                <thead id="">
	                    <tr id="">
	                        <!-- <th id="" class="h4_center" bgcolor="#CCCCCC" width="30px" height="15px">번호</th> -->
	                        <th id="" class="h5_center" width="200px" height="15px"><spring:message code="ezTotalSearch.t0022" /></th>
	                        <th id="" class="h5_center" width="auto" height="15px"><spring:message code="ezTotalSearch.t0013" /></th>
	                        <th id="" class="h5_center" width="15%" height="15px"><spring:message code="ezTotalSearch.t0023" /></th>
	                        <th id="" class="h5_center" width="15%" height="15px"><spring:message code="ezTotalSearch.t0024" /></th>
	                        <th id="" class="h5_center" width="10%" height="15px"><spring:message code="ezTotalSearch.t0025" /></th>
	                        <th id="" class="h5_center" width="50px" height="15px"><spring:message code="ezTotalSearch.t0026" /></th>
	                    </tr>
	                </thead>
	                <tbody id ="approvalResult" style="background-color: rgb(255, 255, 255);"></tbody>
	            </table>
	        </div>
	        <div id="moreApprovalResult" class="moreResult" style="">
	            <table cellspacing="0" cellpadding="0" border="0" width="100%">
	                <tbody>
	                    <tr>
	                        <td align="right" height="23px">
	                            <a onclick="clickTab('approval')"><img src="/images/totalsearch/total_search_icon02.png" width="16" height="16" style="vertical-align:top; border:0px none;" /><spring:message code="ezTotalSearch.t0027" /></a>
	                        </td>
	                    </tr>
	                </tbody>
	            </table>
	        </div>
        </div>
        <!-- //전자결재 -->        
        <!-- 게시판 -->
        <div id="boardListDiv">
	        <table cellspacing="0" cellpadding="7" width="100%" border="0" class="divAprList" id="Aprmenulist">
	            <tbody>
	                <tr>
	                    <td>
	                        <img src="/images/totalsearch/total_search_icon01.png" width="16" height="16" style="vertical-align:middle;" />
	                        <b><spring:message code="ezTotalSearch.t0019" /></b> <spring:message code="ezTotalSearch.t0028" /> (<span class="point5" id="boardResultCnt">0</span><spring:message code="ezTotalSearch.t0032" />)
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	        <div id="">
	            <table id="boardTable" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="" rowondblclick="" width="100%" border="0" class="mainlist">
	                <thead id="">
	                    <tr id="">
	                        <!-- <th id="" class="h4_center" bgcolor="#CCCCCC" width="30px" height="15px">번호</th> -->
	                        <th id="" class="h5_center" width="200px" height="15px"><spring:message code="ezTotalSearch.t0029" /></th>
	                        <th id="" class="h5_center" width="auto" height="15px"><spring:message code="ezTotalSearch.t0013" /></th>
	                        <th id="" class="h5_center" width="15%" height="15px"><spring:message code="ezTotalSearch.t0023" /></th>
	                        <th id="" class="h5_center" width="15%" height="15px"><spring:message code="ezTotalSearch.t0008" /></th>
	                        <th id="" class="h5_center" width="10%" height="15px"><spring:message code="ezTotalSearch.t0009" /></th>
	                        <th id="" class="h5_center" width="50px" height="15px"><spring:message code="ezTotalSearch.t0015" /></th>
	                    </tr>
	                </thead>
	                <tbody id="boardResult" style="background-color: rgb(255, 255, 255);"></tbody>
	            </table>
	        </div>
	        <div id="moreBoardResult" class="moreResult" style="">
	            <table cellspacing="0" cellpadding="0" border="0" width="100%">
	                <tbody>
	                    <tr>
	                        <td align="right" height="23px">
	                            <a onclick="clickTab('board')"><img src="/images/totalsearch/total_search_icon02.png" width="16" height="16" style="vertical-align:top; border:0px none;" /><spring:message code="ezTotalSearch.t0027" /></a>
	                        </td>
	                    </tr>
	                </tbody>
	            </table>
	        </div>
        </div>
        <!-- //게시판 -->
        <br />
        <br>
        <div id="tblPageRayer">
			<div class="pagenavi" id="pagenavi"></div>        
        </div>        
    </div>
	<div class="wrap-loading display_none">
		<span class="loading_layer" id="loadingLayer">
			<span class="right"><img src="/images/loading/loading.gif" width="24" height="24">
				<span id="messageInSending"><spring:message code="ezTotalSearch.t0030" /></span>
			</span>
		</span>
	</div>
</body>
</html>