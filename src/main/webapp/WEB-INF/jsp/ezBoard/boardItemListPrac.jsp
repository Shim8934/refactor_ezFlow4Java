<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
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
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<!-- layer popup -->
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>

<style>
#divList {
	width: 100%;
	height: 80vh;
	overflow-x: auto;
	overflow-y: hidden;
}

#page_navi {
    padding: 10px 0px 0px 0px;
    text-align: center;
}

.pgBtnClass {
  display:inline-block;
  width: 25px;
  height: 25px;
  line-height: 25px;
  margin: 2px;
  border: 1px solid gray;
  border-radius: 5px;
  text-align: center;
  font-color: black;
  font-weight: 700;
  font-size: 12px;
  cursor:pointer;
}

.numBtn:hover {
  background-color: #017BEC;
  color: white;
}

.mainbody h1 #mailBoxInfo {
    padding: 0 0 0 10px;
    font-weight: 700;
    color:#017BEC;
}
</style>

<script type="text/javascript">
	var pBoardID = "<c:out value='${boardID}'/>";
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
	var pSortBy = "<c:out value='${boardInfo.sortBy}'/>";
	var url = "${boardInfo.url}";
	var ShowAdjacent = "";
	var gubun = "${boardInfo.guBun}";
	var OrderOption = "";
	var OrderCell = "";
	var pBoardType = "<c:out value='${boardInfo.boardType}'/>";
	var USE_OCS = "${use_ocs}";
	var useRunTime = "${useRunTime}"
	var Use_OneLineCount = "${use_oneLineCount}";
	var pUse_Editor = "${use_Editor}";
	var SQLPARADATA = "";
	var pAdminType = "<c:out value='${boardInfo.adminType}'/>";
	var pButtonHidden = "<c:out value='${boardInfo.buttonHidden}'/>";

	if (url != "") {
		window.location.href = url;
	}

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
	var xmlhttp = createXMLHttpRequest();
	var xmlhttp2 = createXMLHttpRequest();
	var onclickFlag = false;
	var selobj = null;
	var SmallSizeList = false;
	var OldSmallSizeList = false;
	var objMHT;
	var g_bPrevShow = false;
	var pMode = "new";
	var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
	var likeFlag = "${boardInfo.likeFlag}";
	var useNotReadCnt = "${useNotReadCnt}";
	var BoardGroupID = "${boardInfo.boardGroupID}";
	var stringFnParam = "SortPage"; // 2021-04-27 홍승비 - 문자열인 함수명에 접근하기 위한 변수
	
	// 페이지가 로드될 때 실행
	window.onload = function() {
		CurPage = 1;
		
		if (navigator.userAgent.indexOf('Firefox') != -1) {
			document.body.style.MozUserSelect = 'none';
			document.body.style.WebkitUserSelect = 'none';
			document.body.style.khtmlUserSelect = 'none';
			document.body.style.oUserSelect = 'none';
			document.body.style.UserSelect = 'none';
		}

		var height = parseInt(document.documentElement.clientHeight - 200);

		if (ListView_FG == "true") {
			getBoardList();
		} else {
			alert("잘못된 요청입니다. 접근권한이 없습니다.");
		}		
	}

	// 게시판 리스트뷰 생성
	var xmlhttp = createXMLHttpRequest();
	var viewtypeChangeFlag = false;
	function getBoardList(type) {

		SQLPARADATA = "";
		viewtypeChangeFlag = true;

		if (document.getElementById("viewtype") != null) {
			type = document.getElementById("viewtype").value;
		}
		if (SQLPARADATA != "") {
			url = "/ezBoard/getSearchBoardList.do";
		} else {
			url = "/ezBoard/getBoardList.do";
		}
		
		$.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : url,
			data : {
				boardType : pBoardType,
				boardId : pBoardID,
				pageNum : CurPage,
				orderCell : OrderCell,
				orderOption : OrderOption,
				searchQuery : SQLPARADATA,
				type : type,
				likeFlag : likeFlag
			},
			success : function(xml) {
				getBoardList_after(loadXMLString(xml));
			}
		});
	}

	// XML 매핑
	var firstFlag = false;
	function getBoardList_after(xml) {
		try {
			// 맨앞에 들어가는 몇 수치들. 게시판의 토탈 게시물 수라던가... 머 그런
			var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
			var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
			var pagenode = SelectSingleNodeNew(xml, "DOCLIST/PAGECNT");
			var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");

			pMailListDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWLIST")));
			pMailPreVDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWCONTENT")));
			pMailListDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHLIST")));
			pMailPreVDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWHCONTENT")));

			pPreviewShow_HOW = getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWTYPE"));
			if (listNode == null) {
				return;
			}
			
			// 여기부터 게시물 수, 페이징 관련 기능
			var lstCnt = getNodeText(cntNode);
			var pageCnt = getNodeText(pagenode);
			var perCnt = getNodeText(perNode);

			document.getElementById("mailBoxInfo").innerHTML = lstCnt;
			totalPage = Math.ceil(new Number(pageCnt / perCnt));	
			
			makePaging();
			// 페이징 끝			

			// xml을 dom 객체로 만들고 리스팅
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
			if (document.getElementById("lvBoardList").innerHTML != "") {
				document.getElementById("lvBoardList").innerHTML = "";
			}
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
				} else {

					if (parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim()) > tempno)
						tempno = parseInt(GetElementsByTagName(GetElementsByTagName(xmlDoc, "ROW")[i], "CELL")[1].text.trim());
				}
			}
			
			tempno = tempno + "";

			if (tempno.length > 4) {
				document.getElementById("BoardList_TH_1").style.width = tempno.length * 3 + 22 + "px"; // +  tempno.length * 3 + 20
			}
			if (USE_OCS == "YES" && lstCnt > 0 && gubun != 2) {
				check_presence();
			}

		} catch (e) {
			alert("getBoardList_after : " + e.description);
			console.dir(e);
		}
	}

	// 게시글 조회기능
	function ItemRead_onclick() {
		var obj = event.currentTarget.parentNode;
		
        var pheight = window.screen.availHeight;
        var pwidth = window.screen.availWidth;
        var pTop = (pheight - 720) / 2;
        var pLeft = (pwidth - 765) / 2;
        
		window.open("/ezBoard/boardItemView.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	}
	
	// paging 버튼 만들기
	function makePaging() {
		var parentDiv = document.getElementById("page_navi");
		if (parentDiv.innerHTML != "") {
			parentDiv.innerHTML = "";
		}
		
		if (CurPage%10==0) {
			var startNum = Math.floor(CurPage/10 - 1)*10;
		} else {
			var startNum = Math.floor(CurPage/10)*10;
		}

		parentDiv.appendChild(makeBtn("◀◀", "first", "goFirstPage()"));
		parentDiv.appendChild(makeBtn("◀", "before", "goBeforePage()"));
		
		for (var i=1; i<=10; i++) {			
			if (totalPage<startNum+i) {
				break;
			}
			parentDiv.appendChild(makeBtn(startNum+i, startNum+i, "goNumberPage()"));
		}
		
		parentDiv.appendChild(makeBtn("▶", "after", "goAfterPage()"));
		parentDiv.appendChild(makeBtn("▶▶", "last", "goLastPage()"));
	}
	
	// 페이징할때 버튼 만들어주는 메소드
	function makeBtn(property, id, funcName) {
		let newElem = document.createElement("span");
		newElem.textContent = property;
		newElem.setAttribute("id","pgBtnId_"+id);

		if (property == id) {
			newElem.setAttribute("class", "pgBtnClass numBtn");
		} else {
			newElem.setAttribute("class", "pgBtnClass");
		}		
		newElem.setAttribute("onclick", funcName);
		newElem.setAttribute("data", property);
		
		if (CurPage == property) {
			newElem.setAttribute("style", "color:white; background-color:#017BEC;");
		}
		return newElem;
	}
	
	// paging버튼 온클릭 메소드들	
	function goFirstPage() {
		CurPage = 1;
		getBoardList();
	}
	
	function goLastPage() {
		CurPage = totalPage;
		getBoardList();
	}
	
	function goBeforePage() {
		pageTemp = CurPage - CurPage%10 - 9
		if (pageTemp>=1) {
			CurPage = pageTemp;
			getBoardList();
		}
	}
	
	function goAfterPage() {
		pageTemp = CurPage - CurPage%10 + 11
		if (pageTemp<totalPage) {
			CurPage = pageTemp;
			getBoardList();
		}
	}
	
	function goNumberPage() {
		CurPage = event.target.getAttribute("data");
		getBoardList();
	}
	
</script>
</head>

<body class="mainbody" style="overflow: hidden;">
<!-- 없앤 속성:  onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);" -->

  <!-- // 게시판열람권한 XX -->
  <c:if test="${boardInfo.listView_FG != true}">
    <div style="margin-top: 100px; text-align: center">
      <spring:message code='ezBoard.t272' />
    </div>
  </c:if>

  <header>
    <h1>실습:: ${boardName}<span id="mailBoxInfo"></span>
    </h1>
  </header>

  <section id="divList">
    <div id="lvBoardList"></div>
  </section>

  <section id="page_navi">
  </section>
  
</body>
</html>
