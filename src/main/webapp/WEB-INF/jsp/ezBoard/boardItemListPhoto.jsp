<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>BoardItemListPhoto</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
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
		
			<%-- 2020-06-15 홍승비 - 즐겨찾기 아이콘 스타일 추가 --%>
			.no_yellowStar {
				background:url(../images/ImgIcon/view-flag.gif) no-repeat;
				background-color: transparent;
				vertical-align: top;
				overflow: hidden;
				width:18px;
				height:16px;
				display:inline-block;
				margin: 6px 0px 0px 0px;
				cursor:pointer;
				margin-left: 3px;
				margin-right: 3px;
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
			var Edit_FG = "${boardInfo.edit_FG}";
		    var BrdName = "${boardName}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var pSortBy = "<c:out value='${boardInfo.sortBy}'/>";
		    var url = "${boardInfo.url}";
		    var ShowAdjacent = "";
		    var gubun = "${boardInfo.guBun}";
		    var totalCount = "0";
			var lang = "${userInfo.lang}";
		    var OrderOption = "";
		    var OrderCell = "";
		    var pBoardType = "<c:out value='${boardInfo.boardType}'/>";
		    var USE_OCS = "${use_ocs}";
		    var useRunTime = "${useRunTime}"
		    var SQLPARADATA = "";
		    var Use_OneLineCount = "${use_oneLineCount}";
		    var pAdminType = "<c:out value='${boardInfo.adminType}'/>";
		    if (url != "")
		        window.location.href = url;
		
		    var previewType = "PHOTO";
		    var clickPreviweType = "PHOTO";
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
		    var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
		    var likeFlag = "${boardInfo.likeFlag}";
		    var disLikeFlag = "${boardInfo.disLikeFlag}";
		    var useNotReadCnt = "${useNotReadCnt}";
		    var BoardGroupID = "${boardInfo.boardGroupID}";
            var boardViewType = '1'; // 2024-05-24 전인하 - 기본보기(1) / 안읽은 게시물(2) / 만료게시물(3) 확인 플래그
		    var isOpenWindow;
            var useKeywordFlag = "<c:out value='${useKeyword}'/>"; // 키워드 사용여부 (Y/N)
            var myBoardScrapFlag = "<c:out value='${MyBoardScrapFlag}'/>" // 스크랩 테넌트 컨피그 (TYPE1 / TYPE2 /NONE)
			var SSDeptID = "<c:out value='${userInfo.deptID}'/>";
		    
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
		        
		        /* 2019-01-30 홍승비 - 그룹사게시판의 경우, 사용자단에서 권한설정 버튼 숨김 */
		        if (BoardAdmin_FG == "true" && isAllGroupBoard == "Y") {
			        if (parent.document.location.href != null && parent.document.location.href.indexOf("/admin/") < 0) {
						document.getElementById("btn_acl").style.display = "none";
			        }
		        }
		        
		        var height = parseInt(document.documentElement.clientHeight - 180);
		        getBoardList();
		
		        if (document.documentElement.clientWidth < 1300) {
		            document.getElementById("right").style.display = "none";
		        }

				// VOC #163284 관리자 탭 선택 오류 
				if (window.parent && window.parent !== window) {
					try {
						const parentUrl = window.parent.location.href;

						if (parentUrl.includes("admin/ezBoard/boardConfig.do")) {
							const parentDoc = window.parent.document;

							const container = parentDoc.querySelector(".portlet_tabnew01_top");

							if (container) {
								const spans = container.querySelectorAll('span[divname="BoardEnv_div1"], span[divname="BoardEnv_div2"], span[divname="BoardEnv_div3"], span[divname="BoardEnv_div4"], span[divname="BoardEnv_div5"]');

								spans.forEach(span => {
									span.removeAttribute("class");
								});

								const targetSpan = container.querySelector('span[divname="BoardEnv_div1"]');
								if (targetSpan) {
									targetSpan.classList.add("tabon");
									window.parent.Tab1_SelectID = "1tab1";
								}
							}
						}
					} catch (e) {
						console.log(e);
					}
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
		    	
		    	//즐겨찾기 게시판의 포토게시판 스크립트 오류 수정
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
		    function getBoardList() {    
		        starttime = new Date().getTime();
		        
		        if (SQLPARADATA != "") {
		            document.getElementById('viewtype')[0].selected = true;
		            boardViewType = '1';
		        	url = "/ezBoard/getSearchBoardList.do";
		        } else {
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
							 type 		 : boardViewType,
							 likeFlag 	 : likeFlag,
							 disLikeFlag : disLikeFlag,
							 listShowType : usrListShowType
							},
					success: function(xml){
						getBoardList_after(loadXMLString(xml));
					},
					/* 2018-08-07 홍승비 - 포토게시판 안읽은게시물 정렬 시 500에러 확인용 콘솔 로그 */
					error:function(request, status, error){
						alert("code : " + request.status + "\n" + "message : " + request.responseText + "\n" + "error : " + error);
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
	            scroll();
                MailOptionHidden();
				Window_resize();
		    }
		
		
		    function MakeSubCondition(type) {
		        var TYPE = "";
		        var DATA = "";
		
		        //하위 게시판 검색할 건지에 대한 조건
		        if (document.getElementById("chkSearchSub").checked)		// SearchSubBoard
		        {
		            TYPE += "SEARCHSUBBOARD;";
		        }
		
		        if (type == "quick") {
		        	var selectSearch = document.getElementById('selectType');
	                if (selectSearch.value == 'rad_Subject') {
	                    TYPE += "TITLE;";
	                    DATA += "<TITLE><![CDATA[" + document.getElementById("txt_keyword").value + "]]></TITLE>";
	                }
	                else if (selectSearch.value == 'rad_Writer') {
	                    TYPE += "WRITERNAME;";
	                    DATA += "<WRITERNAME><![CDATA[" + MakeXMLString(document.getElementById("txt_keyword").value) + "]]></WRITERNAME>";
	                }
	                 else if (selectSearch.value == 'rad_Keyword') {
                        TYPE += "KEYWORD;";
                        DATA += "<KEYWORD><![CDATA[" + document.getElementById("txt_keyword").value.replace("'", "''") + "]]></KEYWORD>";
                    }
                     else if (selectSearch.value == 'rad_Subject_Content') {
 		                TYPE += "TNC;";
 	                    DATA += "<TNC><![CDATA[" + document.getElementById("txt_keyword").value.replace("'", "''") + "]]></TNC>";
                      }
		        }
		        else {
		            if (document.getElementById("txtTitle").value != "")		// DocTitle
		            {
		                TYPE += "TITLE;";
		                DATA += "<TITLE><![CDATA[" + document.getElementById("txtTitle").value + "]]></TITLE>";
		            }
		
		            if (document.getElementById("txtWriterName").value != "")		// DrafterName
		            {
		                TYPE += "WRITERNAME;";
		                DATA += "<WRITERNAME><![CDATA[" + MakeXMLString(document.getElementById("txtWriterName").value) + "]]></WRITERNAME>";
		            }
		
		            if (document.getElementById("txtKeyword") != null) { // KEYWORD
                        if (document.getElementById("txtKeyword").value != "") {
                             TYPE += "KEYWORD;";
                             DATA += "<KEYWORD><![CDATA[" + document.getElementById("txtKeyword").value.replace("'", "''") + "]]></KEYWORD>";
                        }
                    }
                   
		            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "")		// StartDate
		            {
		                TYPE += "STARTDATE;";
		                DATA += "<STARTDATE><![CDATA[" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + "]]></STARTDATE>";
		            }
		
		            if ($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "")		// EndDate
		            {
		                TYPE += "ENDDATE;";
		                DATA += "<ENDDATE><![CDATA[" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + "]]></ENDDATE>";
		            }
		        }
		        SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
		    }
		
		    function btn_PostDate_Clear() {
		        $("#Sdatepicker").datepicker('setDate', "");
		        $("#Edatepicker").datepicker('setDate', "");
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
		
		    function NewItem_onclick() {
		        if (Write_FG != "true") {
		            alert("<spring:message code='ezBoard.t262'/>");
		            return;
		        }
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 700) / 2;
		        var pLeft = (pwidth - 765) / 2;
		        window.open("/ezBoard/newBoardItemPhoto.do?boardID=" + encodeURIComponent(pBoardID) + "&gubun=3" + "&mode=new", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=700,width=765,top=" + pTop + ",left=" + pLeft, "");
		        
		    }
		    
		    function ItemRead_onclick(obj) {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t194'/>");
		            return;
		        }
		
		        //var SelList = new ListView();
		        //SelList.LoadFromID("BoardList");
		        //var oArrRows = SelList.GetSelectedRows();
		        //var tr = oArrRows[0];
		
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 789) / 2;
		        var pLeft = (pwidth - 790) / 2;
	    	    if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
	    	    	var height = 789;
	    	    } else {
	    	    	var height = 785;
	    	    }
		
		        for (var i = 0; i < obj.childNodes.length; i++) {
			        if (obj.childNodes[i].style.fontWeight == "bold")
			            obj.childNodes[i].style.fontWeight = "normal";
		        }	
		        // if (tr != null && oArrRows.length > 0) {
		
		        isOpenWindow = window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardID=" + encodeURIComponent(obj.getAttribute("DATA1")) + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=890,top=" + pTop + ",left=" + pLeft, "");
		        //}       
		    }
		    /*  2019-04-12 홍승비 - 사용되지 않는 함수 주석처리 */
/* 		    function NoticeRead_onclick(pItemBoardID, pItemBoardName, pItemID, pUserID, evt) {
		        if (Read_FG != "true") {
		            OpenAlertUI("<spring:message code='ezBoard.t194'/>");
		            return;
		        }
		        if (CrossYN())
		            var e = evt.currentTarget;
		        else
		            var e = event.srcElement;
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 790) / 2;
		
		        window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=780,width=890,top=" + pTop + ",left=" + pLeft, "");
		
		    } */
		    
		    /* 2020-02-14 홍승비 - 불필요한 구분값 체크 코드 정리 (포토게시판의 구분값은 "3") */
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
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
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
			        leftCountRf(pBoardID);
				} catch (e) {
				}
		    }
		    function DeleteItem_onclick_Complete(ret) {
		        if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") return;
		
		        if (ret == "NO") {
		            alert("<spring:message code='ezBoard.t267'/>");
		            return;
		        }
		        else {
		            var xmlhttp = createXMLHttpRequest();
		            xmlhttp.open("POST", "/ezBoard/deleteItem.do?mode=PHOTO&boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(strItemList[0]) + ";", false);
		            xmlhttp.send();
		
		            if (xmlhttp.responseText == "NO") {
		                alert("<spring:message code='ezBoard.t265'/>");
		                return;
		            } else if (xmlhttp.responseText == "ERROR") {
		                alert("<spring:message code='ezBoard.t1020'/>");
		                return;
		            }
		
		            xmlhttp = null;
		            alert("<spring:message code='ezBoard.t268'/>");
		
                    if (CurPage == totalPage) {
                        var SelList = new ListView();
                        SelList.LoadFromID("BoardList");
                        var DeleteCount = strListInfo.split(';').length - 1;
                        if (SelList.GetRowCount() == DeleteCount) {
                            CurPage = CurPage - 1;
                        }
                    }
                    if (CurPage == 0) CurPage = 1;
                    getBoardList();
                    
                    try {
                    	leftCountRf(pBoardID);
    				} catch (e) {
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
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?mode=PHOTO&boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(strListInfo), false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		            alert("<spring:message code='ezBoard.t265'/>");
		            return;
		        } else if (xmlhttp.responseText == "ERROR") {
	                alert("<spring:message code='ezBoard.t1020'/>");
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
		        
		        /* 2018-10-23 홍승비 - 게시물을 삭제한 경우, 미리보기가 열려있으면 새로고침하도록 수정 (포토게시판) */
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
					if (arrList[i].split(",")[3] == '1') {
						if (arrList[i].split(",")[2] != SSDeptID) {
							arrList = null;
							return false;
						}
					} else {
						if (arrList[i].split(",")[1] != SSUserID) {
							arrList = null;
							return false;
						}
					}
				}
		        arrList = null;
		        return true;
		    }
		
		    function refresh_onclick() {
		        window.location.href = window.location.href = "/ezBoard/boardItemListPhoto.do?page=" + CurPage.toString() + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=&boardType=" + pBoardType + "&adminType=" + pAdminType;
		    }
		
		    function AddToMyBoards() {
				var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/addToMyBoards.do?boardID=" + encodeURIComponent(pBoardID), false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText.indexOf("OK") > -1) {
		            alert("<spring:message code='ezBoard.t269'/>");
				} else {
		            var ret = confirm("<spring:message code='ezBoard.t270' />\n<spring:message code='ezBoard.hsbFv01' />");
		        	if (ret) { // 이미 즐겨찾기된 경우, 즐겨찾기 해제
		        		deleteMyBoards();
		        	}
				}
				xmlhttp = null;
				
				// 즐겨찾기 동작 이후 별모양 아이콘 갱신
		        changeMyboardIcon();
			}            
/* 		
		    function CopyItem_onclick() {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t202'/>");
					return;
				}
		
		        if (strListInfo == "") {
		            alert("<spring:message code='ezBoard.t201'/>");
					return;
				}
		
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
		            alert("<spring:message code='ezBoard.t202'/>");
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
		
		        window.open("/ezBoard/copyBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(pBoardID) + "&mode=COPY", "", "height=600px,width=355px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth, "");
		
		    } */
		    
		   /*  var moveboarditem_cross_dialogArguments = new Array();
		    function MoveItem_onclick() {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t202'/>");
					return;
				}
		        if (strListInfo == "") {
		            alert("<spring:message code='ezBoard.t497'/>");
					return;
				}
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
		            alert("<spring:message code='ezBoard.t202'/>");
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
		            var OpenWin = window.open("/ezBoard/moveBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(pBoardID) + "&guBun=" + gubun, "MoveBoardItem", GetOpenWindowfeature(355, 600));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var pheigth = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            pheigth = parseInt(pheigth) / 2;
		            pwidth = parseInt(pwidth) / 2;
		            pheigth = pheigth - 200;
		            pwidth = pwidth - 127;
		            var ret = window.showModalDialog("/ezBoard/moveBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(pBoardID) + "&guBun=" + gubun, "", "DialogHeight:600px;DialogWidth:355px;status:no;help:no;edge:sunken;scroll:no");
		
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
		    } */
		    
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
				    xmlhttp.open("POST", "/ezBoard/setRead.do?boardID=" + encodeURIComponent(pBoardID) + "&itemIDList=" + encodeURIComponent(strItemList), false);
				    xmlhttp.send();
				    xmlhttp = null;
				    getBoardList();
				    
				     /* 2019-07-03 홍승비 - 게시물 읽음표시 할 경우 좌측메뉴의 미독건수 갱신하도록 수정 */
		            if (useNotReadCnt == "YES") {
			            var boardLeftFrame;
			            
			            if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1) { // 즐겨찾기에서 읽기창 진입
							boardLeftFrame = window.parent.parent.frames["left"];
						} else { // 해당 게시판 내부에서 읽기창 진입
			        		boardLeftFrame = window.parent.frames["left"];
			        	}
			            
			            if (boardLeftFrame != null && boardLeftFrame != undefined && boardLeftFrame.location.href.indexOf("/ezBoard/boardLeft.do")> -1) {
			     			boardLeftFrame.getBoardNotReadCountByID(BoardGroupID, "", "GROUP");
			     			boardLeftFrame.getBoardNotReadCountByID(pBoardID, gubun, "SUB");
				    	}
		            }
				}
			}
		    
		    /* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
			function MemberInfo_onclick(pUserID, pDeptID) {
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			    var left = (width - 500) / 2;
			    var top = (heigth - 400) / 2;
			    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
			}
			function ReservationItem_onclick() {
			    var OrgBoardParameters = "page=" + CurPage + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=&boardType=" + pBoardType;
			    window.location.href = "/ezBoard/boardReservedItemList.do?orgBoardParameters=" + escape(OrgBoardParameters) + "&boardType=" + pBoardType;
			}
			function search_onclick() {
			    var OrgBoardParameters = "page=" + CurPage + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=&boardType=" + pBoardType;
			    window.location.href = "/ezBoard/searchBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&boardType=" + pBoardType + "&orgBoardParameters=" + escape(OrgBoardParameters);
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
			    	var txtKeywordVal = document.getElementById("txtKeyword") != null ? document.getElementById("txtKeyword").value : "";
			    	if (document.getElementById("txtWriterName").value == "" && document.getElementById("txtTitle").value == "" && txtKeywordVal == "" 
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
		
		    /* 2020-11-05 홍승비 - 크롬 브라우저에서 부모창의 XMLHTTPRequest를 호출한 자식창이 닫히는 경우, send() 이후가 동작하지 않는 오류 수정(지원종료) */
		    var configmyboard_dialogArguments = new Array();
		    function SaveMyBoard() {
		    	configmyboard_dialogArguments[0] = "";
		    	
		        if (CrossYN()) {
		            var OpenWin = GetOpenWindow("/ezBoard/myBoardConfig.do?type=ADD&boardID=" + encodeURIComponent(pBoardID), "MyBoardConfig", 600, 418);
		            try { 
		            	OpenWin.focus();
		            	
			            var parentHref = window.parent.location.href;
						var winTimer = window.setInterval(function() {
				            if (OpenWin.closed !== false) {
				                window.clearInterval(winTimer);
				                if (configmyboard_dialogArguments[0] == "Y") {
				                	if (parentHref.indexOf("admin/ezBoard") < 0 && parentHref.indexOf("boardItemList_favorite") < 0) { // 일반 게시판에서 접근
				                		window.parent.frames["left"].ShowMyBoardItemNew();
				                	}
				                	else if (parentHref.indexOf("admin/ezBoard") < 0 && parentHref.indexOf("boardItemList_favorite") > -1) { // 새게시물 탭에서 접근
				                		window.parent.parent.frames["left"].ShowMyBoardItemNew();
				                	}
						    	}
				            }
				        }, 500);
					} catch (e) { }
		        }
		        else
		            showModalDialog("/ezBoard/myBoardConfig.do?type=ADD&boardID=" + encodeURIComponent(pBoardID), null, "dialogHeight:418px; dialogWidth:600px; status:no; help:no; scroll:no; edge:sunken");
		    }
		
		    function SetBoardAcl() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/getParentBoardID.do", false);
		        xmlhttp.send(pBoardID);
		
		        if (xmlhttp.status == 200) {
					var parentNeed = (parent.window.document.getElementsByTagName("h1").length == 0) ? "Y" : "N";
					location.href = "/admin/ezBoard/boardConfig.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(getNodeText(xmlhttp.responseText))
							+ "&boardType=" + pBoardType + "&boardName=" + encodeURIComponent(BrdName)
							+ "&adminType=y&parentNeed=" + parentNeed + "&userPageYN=Y";
		        }
		        else {
		            alert("ERROR");
		        }
		    }
		    
	    	/* 2020-06-15 홍승비 - 게시판 즐겨찾기 여부에 따라 별모양 아이콘 스타일 변경 */
	    	function changeMyboardIcon() {
				$.ajax({
					type : "GET",
					dataType : "text",
					async : true,
					url : "/ezBoard/getIsMyBoard.do",
					data : {
						boardID : pBoardID
					},
					success: function(result){
						if (result == "YES") { // 즐겨찾기된 게시판
							document.getElementById("myBoardIconSpan").className = "icon16 icon16_star";
						} else {
							document.getElementById("myBoardIconSpan").className = "no_yellowStar";
						}
					}
				});
	    	}
	    	
	    	/* 2020-06-15 홍승비 - 즐겨찾기 아이콘 클릭으로 즐겨찾기 해제 가능 */
	    	function deleteMyBoards() {
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/deleteMyBoards.do",
					data : {
						boardID : pBoardID
					},
					success: function(result){
			            if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1) {
							boardLeftFrame = window.parent.parent.frames["left"];
							boardLeftFrame.favoriteList();
						}
					}
				});
	    	}
	    	
	    	// 2024-05-29 전인하 - 리스트설정 셀렉트박스 선택 동작 메서드
            function selectBoardViewType(obj) {
                boardViewType = obj.value;
                CurPage = 1;
                SQLPARADATA = "";
                getBoardList();
            }
	    	
	    	/* 2023-04-06 기민혁 - 좋아요/싫어요 리스트 출력 openWindow 호출 메소드 */
		    function likeAndDisLikeList() {
		    	
		    	var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 450) / 2;
		        var pLeft = (pwidth - 315) / 2;
		        
		        var arrList = new Array();
	            var strItemList = "";
	            var i = 0;
	            arrList = strListInfo.split(";");
	            console.log(arrList);
	            if(arrList.length == "1"){
	            	alert("<spring:message code='ezBoard.kmh01'/>");
	            	return;
	            } 
	            
	            for (i = 0; i < arrList.length - 1; i++) {
	                strItemList += arrList[i].split(",")[0] + ";";
	            }
	            arrList = null;
		        
		        GetOpenWindow("/ezBoard/boardLikeAndDisLikeList.do?boardID=" + encodeURIComponent(pBoardID)+ "&itemIDList=" + encodeURIComponent(strItemList), "likeAndDisLikeList", 920, 850);
		    	
		    }
	    	
		    /* 2023-04-06 기민혁 - itemview창이 열려있을때 미리보기 창이 열려 있으면  미리보기에서 좋아요 싫어요 이미지 및 개수 변경  */
	    	function refreshLikeAndDisLike(result,checked,gubun) {
	    		if($("#PreviewRayerH").css("display") == "none"){
	    			return;
	    		}else if ($("#PreviewRayerH").css("display") != "none"){
					var refreshLikeAndDisLikeH = document.getElementById("ifrmPreViewH_photo");
	    			refreshLikeAndDisLikeH.contentWindow.refreshLikeAndDisLike(result,checked,gubun);    			    			
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
	    	
		    /*  2023-05-22 기민혁 - 나의스크랩함 나의스크랩 추가 버튼 클릭시 동작 */
    	    function SaveScrapMyBoard() {
    	    	var arrList = new Array();
	            var strItemList = "";
	            var i = 0;
	            arrList = strListInfo.split(";");

				if (Read_FG != "true") {
					alert("<spring:message code='ezBoard.t202' />");
					return;
				}
	            
	            if(arrList.length == "1"){
	            	alert("<spring:message code='ezBoard.kmh15'/>");
	            	return;
	            }
	            
	            for (i = 0; i < arrList.length - 1; i++) {
		            strItemList += arrList[i].split(",")[0] + ";";
		        }
	            
               if (myBoardScrapFlag == "TYPE1") {
                   $.ajax({
                       type : "GET",
                       dataType : "json",
                       async : false,
                       url : "/ezBoard/setScrapItemAll.do",
                       data : { 
                               itemIDList  : strItemList,
                               boardID     : pBoardID
                               },
                       success: function(result) {
                            if (result.status != "error") {
                                if (result.failCount > 0) {
                                    var pAlertContent = "<spring:message code='ezBoard.kmh44'/> " + result.failCount + "<spring:message code='ezBoard.kmh45'/>";
                                    alert(pAlertContent);
                                } else {
                                    alert("<spring:message code='ezBoard.kmh47' />");
                                }
                            } else {
                                alert("<spring:message code='ezBoard.kmh46' />");
                            }
                       },
                       error : function(error) {
                           console.log(error);
                       }			
                   });
               
               } else if (myBoardScrapFlag == "TYPE2") {
                   var url = "/ezBoard/selUserScrapCont.do";
                   ContOpen = GetOpenWindow(url + "?itemID=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(pBoardID), "selUserCont", 500, 460, "NO");
                   try { 
                       ContOpen.focus()
                   } catch (e) { 
                       console.log(e);
                   }
               }
    	    }
	    	
	    	var usrListShowType = "";
            function listShow(type) {
                var general	= document.getElementById("listShowGeneral");
                var expand = document.getElementById("listShowExpand");
                
                if (type == "G") {
                    general.className = "icon16 icon16_onlist";
                    expand.className = "icon16 icon16_clip";
                } else {
                    general.className = "icon16 icon16_list";
                    expand.className = "icon16 icon16_onclip";
                }
                
                usrListShowType = type;
                getBoardList();
            }
		</script>
	</head>
	<c:choose>
		<c:when test="${boardInfo.adminType != 'y'}">
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
			<c:when test="${boardInfo.adminType != 'y'}">
				<h1>${boardName}<span id="mailBoxInfo"></span>
					<span class="searchForm">
				    	<select id="selectType" class="text" style="width:80px; height:27px; border-color: #c8c8c8;">
				    		<option selected value="rad_Subject"><spring:message code='ezBoard.t208'/></option>
				    		<option value="rad_Writer"><spring:message code='ezBoard.t223'/></option>
				    		<c:if test ="${useKeyword eq 'Y'}">
                                <option value="rad_Keyword"><spring:message code='ezApprovalG.t1200'/></option>
                            </c:if>
                            <option value="rad_Subject_Content"><spring:message code='ezBoard.t208'/> + <spring:message code='ezBoard.garm01'/></option>
				    	</select>
						<input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
				        <a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search('quick')"></a>
				    </span>
				</h1>
			</c:when>
			<c:otherwise>
			    <script type="text/javascript">
			        parent.document.getElementsByTagName("h1")[0].innerHTML = "${boardName}" +"<span id='mailBoxInfo'></span>";
			    </script>
			    <br />
			    <span class="searchForm" style="display:none;">
					<select id="selectType" class="text" style="width:80px; height:27px; border-color: #c8c8c8;">
						<option selected value="rad_Subject"><spring:message code='ezBoard.t208'/></option>
			    		<option value="rad_Writer"><spring:message code='ezBoard.t223'/></option>
                        <c:if test ="${useKeyword eq 'Y'}">
                            <option value="rad_Keyword"><spring:message code='ezApprovalG.t1200'/></option>
                        </c:if>
                        <option value="rad_Subject_Content"><spring:message code='ezBoard.t208'/> + <spring:message code='ezBoard.garm01'/></option>
			    	</select>
					<input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
			        <a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search('quick')"></a>
		        </span>
			</c:otherwise>
		</c:choose>
	<c:if test="${boardInfo.buttonHidden == 'N'}">
		<div id="mainmenu">
		  <ul>
		        <li class="important"><span onClick="NewItem_onclick()"><spring:message code='ezBoard.hsbJP02'/></span></li>
		        <li><span onclick="SetRead_onclick()"><spring:message code='ezBoard.t204'/></span></li>
		        <li><span onClick="SaveMyBoard()"><spring:message code='ezBoard.t10052'/></span></li>
		        <c:if test="${boardInfo.boardAdmin_FG == true && (boardInfo.likeFlag == 'Y' || boardInfo.disLikeFlag == 'Y')}">
		        	<li id="likeAndDisLikeBtn" ><span onClick="likeAndDisLikeList()"><spring:message code='ezBoard.kmh09' /></span></li> 
		        </c:if>
		        <c:if test="${MyBoardScrapFlag ne 'NONE'}">
		        	<li><span onClick="SaveScrapMyBoard()"><spring:message code='ezBoard.kmh13' /></span></li>
			    </c:if>
			    <!-- <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->		        
			    <!-- <li id="Li1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" align="absmiddle"></li> -->
			    <c:if test="${boardInfo.boardAdmin_FG == 'true'}">
			    	<li id="btn_acl"><span onClick="SetBoardAcl()"><spring:message code='ezBoard.boardManage01'/></span></li> 
		        </c:if>
		        
				<%-- 2020-06-15 홍승비 - 즐겨찾기 여부에 따라 별모양 아이콘 스타일 수정 --%>
		        <c:choose>
					<c:when test="${isMyBoard == 'YES'}">
			        	<li onClick="AddToMyBoards()"><span class="icon16 icon16_star switchIcon" id="myBoardIconSpan"></span><span class="iconTexts"><spring:message code='ezBoard.t10051'/></span></li>
					</c:when>
					<c:otherwise>
			        	<li onClick="AddToMyBoards()"><span class="no_yellowStar switchIcon" id="myBoardIconSpan"></span><span class="iconTexts"><spring:message code='ezBoard.t10051'/></span></li>
			        </c:otherwise>
		        </c:choose>
		        
		        <li onClick="doLayerPopup(this)"><span class="icon16 icon16_search switchIcon" id="SearchOption" mode="off"></span><span class="iconTexts"><spring:message code='ezBoard.t188'/></span></li>
		        <li onClick="DeleteItem_onclick()"><span class="icon16 icon16_delete switchIcon"></span><span class="iconTexts"><spring:message code='ezBoard.t113'/></span></li>
		        <li onClick="refresh_onclick()"><span class="icon16 icon16_refresh switchIcon"></span><span class="iconTexts"><spring:message code='ezBoard.t205'/></span></li> 
		        <!-- <li id="right">
	            	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
					<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" />
				</li> -->
		        <div id="right" class="sub_frameIcon" style="float:right">
                    <div class="sub_frameIconUL00">
                        <p class="frameIconLI">
                            <span <c:if test="${admlistShowType == 'G'}">class="icon16 icon16_onlist"</c:if>
                                  <c:if test="${admlistShowType == 'E'}">class="icon16 icon16_list"</c:if>
                                  id="listShowGeneral" onclick="listShow('G')"></span>
                        </p>
                        <p class="frameIconLI">
                            <span <c:if test="${admlistShowType == 'G'}">class="icon16 icon16_clip"</c:if>
                                  <c:if test="${admlistShowType == 'E'}">class="icon16 icon16_onclip"</c:if>
                                  id="listShowExpand" onclick="listShow('E')"></span>
                        </p>
                    </div>	
					<div class="sub_frameIconUL" style="width:57px !important">
					   	<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE')"></span></p>
					    <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H')"></span></p>
					</div>
					<div class="sub_frameIconUL02">
					  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="maillistoptiondiv" onclick="MailOptionView(this);"></span></p>  
					</div>
				 </div>
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
	                            <select id="viewtype" onchange="selectBoardViewType(this)">
					                <option value="1"><spring:message code='ezBoard.t4001' /></option>
					                <option value="2"><spring:message code='ezBoard.t4002' /></option>
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
								<li class="preSubject"><span class="popup_open" onclick="MailReadOpen();"><img src="/images/kr/cm/btn_newpopup.gif" title="<spring:message code='ezEmail.t99000001' />" alt="<spring:message code="ezEmail.t99000001" />"></span><span class="subjectText" id="PreH_subject" style="max-width:570px;"><span class="subjectText" id="PreH_sub_subject"></span></span></li>
								<li class="preT_list"><span class="t_left"><span class="cblack"><spring:message code="ezBoard.t223" /></span> : <span id="PreH_MailReceiver"></span></span><span class="t_right"><span class="cblack"><spring:message code="ezBoard.t224" /> : </span><span id="PreH_date"><span id="PreH_sub_date" style="display:none;"></span></span></span></li>
								
							</ul>
						</dd>
					</dl>
                </div>
                <iframe id="ifrmPreViewH_photo" name="ifrmPreViewH_photo" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
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
                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
            </div>
        </div>
    </div>
	
	    
	<div id="ListInfo" style="display:none"></div>
	     
		<!-- 2018-06-12 김민성 - 게시판 검색 레이어팝업 변경 -->
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
                        <c:if test ="${useKeyword eq 'Y'}">
                            <tr>
                                <th style="text-align:center"><spring:message code='ezApprovalG.t1200' /></th>
                                <td><input type="text" id="txtKeyword" style="width:100%" value=""></td>
                            </tr> 
                        </c:if>
				        <%--  포토게시판 -> 내용, 게시요약 없고 앨범소개, 사진소개 있음
				         <tr>
				            <th style="text-align:center"><spring:message code='ezBoard.garm01' /></th>
				            <td><input type="text" id="txtContent" style="width:98%" value=""></td>
				        </tr> 
				         <tr>
				            <th style="text-align:center"><spring:message code='ezBoard.t209' /></th>
				            <td><input type="text" id="txtAbstract" style="width:98%" value=""></td>
				        </tr>    --%>   
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
	<%-- </c:otherwise>
	</c:choose> --%>
	</c:if>
	</body>
</html>
