<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t3' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/PreviewItem.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/circular.js')}"></script>
		
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
	        var SSUserID = "<c:out value='${userInfo.id}'/>";  
	        var pBoardType = "";
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
	        var pMailListDiv = 0;
	        var pMailPreVDiv = 0;
	        var pMailListDiv_H = 0;
	        var pMailPreVDiv_H = 0;
	        var pPreviewShow_HOW = "OFF";
	        var onclickFlag = false;
	        var SQLPARADATA = "";
	        var pAdminType = "n";
	        var starttime;
	        var endtime;
	        var strListInfo = "";
	        var strMemberListInfo = "";
	        var pageCnt = "";
            var perCnt = "";
	        window.onunload = Window_onunload;
	        var window_onunload_Event = false;
            //2018-07-17 김보미 - 프로그래스바
            var startTime = "";
            var endTime = "";
	
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
            
	            var height = parseInt(document.documentElement.clientHeight - 200);
	            document.getElementById("divList").style.height = height + "px";
	            
	            getBoardList();
	            window_onunload_Event = true;
	        };
	        
		    $(document).ready(function() {
		    	var clickOutside;
		    	
		    	if (navigator.userAgent.toLowerCase().indexOf("msie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { 
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].document);
		    	} else {
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].contentWindow.document);
		    	}	    	
		    	
		    	clickOutside.mouseup(function (e) {
		    		console.log("1")
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(window.parent.frames['left'].document).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(parent.document).mouseup(function (e) {
		    		console.log("2")
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(document).mouseup(function (e) {
		    		console.log("3")
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
	                var divStyle, ifrmStyle, listCount;
	
	                if (document.getElementById("listcount") != null){
		            	listCount = document.getElementById("listcount").value;
	                } else {
		            	listCount = 20;
	                }
	                
					if (pPreviewShow_HOW == "W") {
		                divStyle = Math.round(pMailListDiv);
		            } else if (pPreviewShow_HOW == "H") {
		                divStyle = Math.round(pMailListDiv_H)
		            } else {
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
	        	if (strHeaderName != "ITEMID" && strHeaderName != "CONFIRM") {
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
				//2018-07-17 김보미 - 프로그레스바
				ShowMailProgress();
				
	        	var searchType = $("#searchType").val();
	        	var searchValue = document.getElementById("txt_keyword").value;
	        	
		        starttime = new Date().getTime();
				url = "/ezCircular/getCircularCompleteList.do";
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : url,
					data : {
						pageNum : CurPage, 
						orderCell : OrderCell, 
						orderOption : OrderOption,
						searchQuery : SQLPARADATA,
						searchValue : searchValue,
						searchType  : searchType,
						sdate : "",
						edate : ""
					},
					success: function(xml){
						getBoardList_after(loadXMLString(xml));
						
						var imgTag = "";
						
	                    if (OrderOption == "") {
	                    	imgTag = '<img src="/images/view-sortup.gif" width="9" height="9">';
	                    	}
	                    else {
	                    	imgTag = '<img src="/images/view-sortdown.gif" width="9" height="9">';
	                    	}
						
	                    if (OrderCell == 'IMPORTANCE') {
							$('#BoardList_TH_1').append(imgTag);
						} else if (OrderCell == 'CONFIRMSTATUS') {
							$('#BoardList_TH_2').append(imgTag);
						} else if (OrderCell == 'HASFILE') {
							$('#BoardList_TH_3').append(imgTag);
						} else if(OrderCell == 'TITLE') {
		                	$('#BoardList_TH_4').append(imgTag);
		                } else if(OrderCell == 'MEMBERNAME') {
		                	$('#BoardList_TH_5').append(imgTag);
		                } else if(OrderCell == 'REGDATE') {
		                	$('#BoardList_TH_6').append(imgTag);
		                } else if(OrderCell == 'STATUS') {
		                	$('#BoardList_TH_8').append(imgTag);
		                }
					},
					complete: function(){
				        //2018-07-17 김보미 - 프로그레스바
				        endTime = new Date();//프로그래스바 종료시간
						var timeDiff = endTime - startTime;
						timeDiff /= 1000;
						var seconds = (timeDiff % 60).toFixed(1);
						
						if (seconds <= 0.3) { //0.3초보다 적으면
							seconds = 300 - (timeDiff * 1000);
							setTimeout(function() {
								HiddenMailProgress();
							}, seconds);
						} else {
					        HiddenMailProgress();
						}
					}
				});
	        }
	
	        var firstFlag = false;
	        function getBoardList_after(xml) {
                var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
                var pageNode = SelectSingleNodeNew(xml, "DOCLIST/PAGECNT");
                var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
                var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
                
                pMailListDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWLISTVALUE")));
	            pMailPreVDiv = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWCONTENTVALUE")));
	            pMailListDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWLISTVALUE")));
	            pMailPreVDiv_H = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWWCONTENTVALUE")));
	            pPreviewShow_HOW = parseInt(getNodeText(SelectSingleNodeNew(xml, "DOCLIST/PREVIEWTYPE")));

                switch (pPreviewShow_HOW) {
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

                if (listNode == null) return;

                var lstCnt = getNodeText(cntNode);
                pageCnt = getNodeText(pageNode);
                perCnt = getNodeText(perNode);
 
                listcount.value = perCnt;
                totalPage = Math.ceil(new Number(pageCnt / perCnt));
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
                
                tempno = tempno + "";
                
                if (tempno.length > 10) {
                    document.getElementById("BoardList_TH_1").style.width = (tempno.length * 10) + "px";
                }

                if (!firstFlag) {
                    PreviewRayerChange(pPreviewShow_HOW);
                    if (CrossYN()) {
                        if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null)
                            ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = "<spring:message code='ezCircular.t88'/>";
                        if (ifrmPreViewW.document.getElementById("ifrmviewEmptyText") != null)
                            ifrmPreViewW.document.getElementById("ifrmviewEmptyText").textContent = "<spring:message code='ezCircular.t88'/>";
                    } else {
                        if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null)
                            ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezCircular.t88'/>";
                        if (ifrmPreViewW.document.getElementById("ifrmviewEmptyText") != null)
                            ifrmPreViewW.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezCircular.t88'/>";
                    }
                    firstFlag = true;
                }
                endtime = new Date().getTime();
                strListInfo = "";

                $("#lstCnt").html("");
                $("#lstCnt").append("&nbsp;&nbsp;<span class='txt_color'>" + lstCnt + "</span>");
	        }
	        
	
	        var BlockSize = 10;
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext;
	        }
	        
	        function chk_onselect(obj) {
		        if (obj.checked) {
		            strListInfo += $(obj).closest("tr").attr("circularID") + ";";
		        } else {
		            strListInfo = ReplaceText(strListInfo, $(obj).closest("tr").attr("circularID") + ";", "");
		        }
		        
		        listEventCheckbox = true;
		    }
	
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            
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
	            
	            if (i == 1) {
	            	strtext = "<span class='on'>" + i + "</span>";
                    PagingHTML += strtext;
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
	            if(pageNum%BlockSize==0) {
	            	pageNum = pageNum -1;
	            }
	            pageNum = ((parseInt(pageNum / BlockSize)) * BlockSize) ;
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

	        //상세보기 
	        function ItemRead_onclick(obj) {
	        	var circularID = obj.getAttribute("CIRCULARID");

                if (CrossYN()) {
		            var feature = GetOpenPosition(820, 900);
	            	window.open("/ezCircular/circularRead.do?circularID=" + circularID, "", "width=820, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	        	} else {
	            	var feature = GetOpenPosition(790, 900);
	            	window.open("/ezCircular/circularRead.do?circularID=" + circularID, "", "width=790, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	        	}
	        }
	        
	        function CircularDelete_onclick() {
	        	if (strListInfo.length == 0) {
	        		alert("<spring:message code='ezCircular.t75'/>");
	        		return;
	        	}
	        	
	        	if (confirm("<spring:message code='ezCircular.t46'/>")) {
					$.ajax({
						type : "POST",
						dataType : "json",
						async : false,
						url : "/ezCircular/circularDeleteTemp.do",
						data : { circularIDList : strListInfo
								},
						success: function() {
							refresh_onclick();
						},
						error: function() {
							alert("<spring:message code='ezCircular.t102'/>");
						}
					});
	        	}
	        }
	        
	        function CircularMove_onclick() {
	        	if (strListInfo.length == 0) {
	        		alert("<spring:message code='ezCircular.t75'/>");
	        		return;
	        	}

	        	var feature = GetOpenPosition(500, 375);
				url = "/ezCircular/circularMove.do?circularIdList=" + strListInfo;
	        	var OpenWin = window.open(url, "", "width=500, height=375, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
		    }
		
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }

		    function getLeftCount() {
		    	if (typeof (window.parent.frames.left) != "undefined") {
		    		parent.frames["left"].getNewCircularCount();
		    	}
		    }
		    
		    function refresh_onclick() {
		    	var strListArr = new Array();
	        	strListArr = strListInfo.split(";");

	        	//2018-02-19 김보미
	        	if ((pageCnt - strListArr.length + 1) % perCnt == 0 && CurPage != 1) {						
					CurPage = CurPage - 1;
				}
// 	        	if ((pageCnt - strListArr.length + 1) % 10 == 0) {						
// 					CurPage = CurPage - 1;
// 				}

		    	prevShow_Clear();
		    	getBoardList();
		    }
		
	        function search(type) {
	            if (type == "basic") {
	
	                if (document.getElementById("txtTitle").value == "" && document.getElementById("txtAbstract").value == "" && document.getElementById("idDatepicker").value == "") {
	                    alert("<spring:message code='ezCircular.t91'/>");
	                    return;
	                }
	
	                if (document.getElementById("idDatepicker").value != "" && document.getElementById("_D2").value == "") {
	                    alert("<spring:message code='ezCircular.t89'/>");
	                    return;
	                }
	                if (document.getElementById("idDatepicker").value == "" && document.getElementById("_D2").value != "") {
	                    alert("<spring:message code='ezCircular.t89'/>");
	                    return;
	                }
	                if (Number(ReplaceText(document.getElementById("idDatepicker").value.substring(0, 10), "-", "")) > Number(ReplaceText(document.getElementById("_D2").value.substring(0, 10), "-", ""))) {
	                    alert("<spring:message code='ezCircular.t90'/>");
	                    return;
	                }
	            } else if (type == "quick") {
	            	if ($.trim($("#txt_keyword").val()) == "") {
			        	alert("<spring:message code='ezCircular.t189' />");
			            return;
			        }

	                if (document.getElementById("txt_keyword").value == "") {
	                    alert("<spring:message code='ezCircular.t91'/>");
	                    return;
	                }
	            }

	            CurPage = "1";
	            getBoardList();
	        }

	        function onkeydown_start_search(evt) {
	            if (evt.keyCode == "13") {
	                search("quick");
	            }
	        }
	
	        function keyword_Clear() {
	            document.getElementById('txt_keyword').value = "";
	        }
	        
	        //2018-07-17 김보미 - 프로그래스바		
			function ShowMailProgress() {
	        	startTime = new Date();//프로그래스바 시작시간
				CurrenWidth = document.body.clientWidth;
	        	
			    document.getElementById("mailPanel").style.display = "";
			    document.getElementById("MailProgress").style.top = "400px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
			    document.getElementById("MailProgress").style.display = "";
			}
			function HiddenMailProgress() {
			    document.getElementById("mailPanel").style.display = "none";
			    document.getElementById("MailProgress").style.display = "none";
			}
	    </script>
	</head>
	<body class="mainbody" style="overflow:hidden;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	    <h1><spring:message code='ezCircular.t3'/><span id="lstCnt"></span><span id="mailBoxInfo"></span>
	        <span class="searchForm">
	        	<!-- 2018-07-12 김민성 - 회람판 검색 select box로 수정 -->
	       		<select id="searchType" class="text" style="width: 65px; height: 27px; border: 1px solid #c8c8c8;">
	        		<option value="subject"><spring:message code='ezCircular.t32'/></option>
	        		<option value="writer"><spring:message code='ezCircular.t166'/></option>
	        	</select>
	        	<%-- <input name="searchType" id="Radio1" type="radio" value="subject" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle;">&nbsp;<spring:message code='ezCircular.t32'/>
				<input name="searchType" id="Radio2" type="radio" value="writer" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle;">&nbsp;<spring:message code='ezCircular.t166'/> --%>
				<input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
				<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search('quick')"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul>
	            <li class="important"><span onClick="CircularWrite_onclick()"><spring:message code='ezCircular.t55'/></span></li>
	            <li><span onClick="CircularMove_onclick()"><spring:message code='ezCircular.t56'/></span></li>
	            <li onClick="CircularDelete_onclick()"><span class="icon16 icon16_delete"></span></li>
	            <!-- <li id="right">
	            	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
	            	<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
					<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" />
				</li> -->
				<div class="sub_frameIcon" style="float:right">	
					<div class="sub_frameIconUL">
					   	<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE')"></span></p>
					    <p class="frameIconLI"><span class="icon16 btn_bottomframe" id="PreViewBottom" onclick="PreviewRayerChange('W')"></span></p>
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
	                        <th><spring:message code='ezCircular.t18'/></th>
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
	        <div class="shadow"></div>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
	
	    <span id="MailListRayer" style="border: 0px solid blue; width: 0px; height: 0px; vertical-align: top; overflow: hidden; display: inline-block;">
	        <div style="width:100%; overflow-x:auto; overflow-y:hidden;" id="divList">
	             <div id="lvBoardList"></div> 
	        </div>
	        <div id="tblPageRayer" style="text-align:center"></div>
	    </span>
	
	    <div id="PreviewRayerH" style="border:0px; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
	        <div id="previewmail_bar_h" class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block;">
	            <p class="hbar_dotted">
	                <img src="/images/prevview_hbar_dotted.gif" draggable="false">
	            </p>
	        </div>
	        <div id="PreContent_RayerH" style="position: absolute; border: 0px; margin-left:7px;">
	            <div class="previewmail">
	                <div class="previewmail_info">
	                	<dl class="previewmailDL" id="Preview_HeaderH" style="display:none;">
							<dt class="prepic" id="PreH_userPic"><img src='/images/kr/main/bestEmployee_pic_none.png' width='55px' height='55px'></dt>
							<dd class="pretext">
								<ul class="pretextUL">
									<li class="preSubject"><span class="popup_open" onclick="CircularReadOpen();"><img src="/images/kr/cm/btn_newpopup.gif" title="<spring:message code='ezEmail.t99000001' />" alt="<spring:message code="ezEmail.t99000001" />"></span><span class="subjectText" id="PreH_subject"><span class="subjectText" id="PreH_sub_subject"></span></span></li>
									<li class="preT_list"><span class="t_left"><span class="cblack"><spring:message code="ezBoard.t207" /></span> : <span id="PreH_MailReceiver"></span></span><span class="t_right"><span class="cblack"><spring:message code="ezBoard.t5007" /> : </span><span id="PreH_date"><span id="PreH_sub_date" style="display:none;"></span></span></span></li>
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
							<dt class="prepic" id="PreW_userPic"><img src="/images/kr/main/bestEmployee_pic_none.png" width="55px" height="55px"></dt>
							<dd class="pretext">
								<ul class="pretextUL">
									<li class="preSubject"><span class="popup_open" onclick="CircularReadOpen();"><img src="/images/kr/cm/btn_newpopup.gif" title="<spring:message code='ezEmail.t99000001' />" alt="<spring:message code="ezEmail.t99000001" />"></span><span class="subjectText" id="PreW_subject"><span class="subjectText" id="PreW_sub_subject"></span></span></li>
									<li class="preT_list"><span class="t_left"><span class="cblack"><spring:message code="ezBoard.t207" /></span> : <span id="PreW_MailReceiver"></span></span><span class="t_right"><span class="cblack"><spring:message code="ezBoard.t5007" /> : </span><span id="PreW_date"><span id="PreW_sub_date" style="display:none;"></span></span></span></li>
								</ul>
							</dd>
						</dl>
	                </div>
	                <iframe id="ifrmPreViewW_photo" name="ifrmPreViewW_photo" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0; display:none;"></iframe>
	                <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
	            </div>
	        </div>
	    </div>
	    
	    <!-- 2018-07-17 김보미 - 프로그레스바 -->
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" >&nbsp;</div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
	</body>
</html></body>
</html>