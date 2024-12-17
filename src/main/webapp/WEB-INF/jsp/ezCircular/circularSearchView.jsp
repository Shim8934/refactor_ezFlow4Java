<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t8' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<%-- <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>	     --%>
		<script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/PreviewItem.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		
	    <script type="text/javascript">
	    	var CurPage = "1";
	    	var OrderCell = "";
	    	var OrderOption = "";
	    	var checkval = "f";
	    	var keyword = "";
	        var filter = "";
	        var searchType = "";
	        var result = ""
			var startdate = "";
			var enddate = "";
			var pageCnt = "";
			var strListInfo = "";
		    var usepostDate = false;
            //2018-07-17 김보미 - 프로그래스바
            var startTime = "";
            var endTime = "";
            var listHeader = "<c:out value='${listHeader}'/>";
            var isSearchPage = true;
            var g_bPrevShow = false; // 회람판 검색메뉴에는 미리보기 없음
		    
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

		        var height = parseInt(document.documentElement.clientHeight - 234);
		        document.getElementById("divList").style.height = height + "px";
		        getSearchList_after(loadXMLString(ReplaceText(ReplaceText(listHeader, "&lt;", "<"), "&gt;", ">")));
		    }
		    
		    window.onresize = function () {
	            var height = parseInt(document.documentElement.clientHeight - 320);
	            Window_resize2();
	        };
			
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

		    
		    var monthMsg = "<spring:message code='ezCircular.t129' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezCircular.t128' />";
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
		    
		    function SortPage(strHeaderName) {
		    	if (strHeaderName != "ITEMID" && strHeaderName != "CONFIRM") {
	                if (OrderCell == strHeaderName) {
	                    if (OrderOption == "")
	                        OrderOption = "DESC";
	                    else
	                        OrderOption = "";
	                } else {
	                    OrderCell = strHeaderName;
	                    OrderOption = "";
	                }

	                search("");        
	            }
	        }
		
		    function search(type) {		    	
		    	if (specialChk(document.getElementById("keyword").value)) {
		    		alert("<spring:message code='ezCircular.t134' />");
		    		return;
		    	}
		    	
		    	var keyword = document.getElementById("keyword").value.trim();
		    	
		        if (keyword.length == 0) {
		            alert("<spring:message code='ezCircular.t135'/>");
		            document.getElementById("keyword").focus();
		            return;
		        }

				if (type == "new") {
					CurPage = "1";
				}

		        var sdate = "";
		        var edate = "";
		        var url = "";

		        if ($("#Sdatepicker").is(":enabled")) {
		            sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        }		

		        if (sdate > edate) {
		        	alert("<spring:message code='ezCircular.t136' />");
		        	return;
		        }

		        if (document.getElementById("keyword").value != "") {
		            filter = document.getElementsByName("search_field")[0].value;
		            searchType = document.getElementById("search_type").value;
		            keyword = document.getElementById("keyword").value;
		        }

		        if (filter == "circularNew") {
		        	url = "/ezCircular/getCircularList.do"
		        } else if (filter == "circularComplete") {
		        	url = "/ezCircular/getCircularCompleteList.do"
		        } else if (filter == "circularMy") {
		        	url = "/ezCircular/getMyCircularList.do"
		        } else if (filter == "circularTemp") {
		        	url = "/ezCircular/getCircularTempList.do"
		        } else {
		        	url = "/ezCircular/getFolderCircularList.do"
		        }
		        
		        console.log("sDate :: "+sdate + "edate :: "+edate);
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : url,
		        	data : {
		        		sdate : sdate,
		        		edate : edate,
		        		pageNum : CurPage,
		        		searchValue : keyword,
		        		searchType : searchType,
		        		orderCell : OrderCell,
		        		orderOption : OrderOption,
		        		folderId : ""
		        	},
		        	success : function(xml) {
			        	//2018-07-17 김보미 - 프로그레스바
						ShowMailProgress();
			        	
		        		getSearchList_after(loadXMLString(xml));
		        		
						var imgTag = "";
						
	                    if (OrderOption == "") {
	                    	imgTag = '<img src="/images/view-sortup.gif" width="9" height="9">';
                    	} else {
	                    	imgTag = '<img src="/images/view-sortdown.gif" width="9" height="9">';
                    	}
						
	                    if (filter == "circularNew") {
	                    	if (OrderCell == 'IMPORTANCE') {
								$('#BoardList_TH_1').append(imgTag);
							} else if (OrderCell == 'CONFIRMSTATUS') {
								$('#BoardList_TH_2').append(imgTag);
							} else if (OrderCell == 'COMMENTSTATUS') {
								$('#BoardList_TH_3').append(imgTag);
							} else if (OrderCell == 'HASFILE') {
								$('#BoardList_TH_4').append(imgTag);
							} else if(OrderCell == 'TITLE') {
			                	$('#BoardList_TH_5').append(imgTag);
			                } else if(OrderCell == 'MEMBERNAME') {
			                	$('#BoardList_TH_6').append(imgTag);
			                } else if(OrderCell == 'REGDATE') {
			                	$('#BoardList_TH_7').append(imgTag);
			                } else if(OrderCell == 'STATUS') {
			                	$('#BoardList_TH_9').append(imgTag);
			                }
	                    } else {
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
		        })
		    }
		    
		    function getSearchList_after(xml) {
                var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
                var pageNode = SelectSingleNodeNew(xml, "DOCLIST/PAGECNT");
                var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
                var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");

                if (listNode == null) return;
            	
                var lstCnt = getNodeText(cntNode);
                pageCnt = getNodeText(pageNode);
                var perCnt = getNodeText(perNode);

                if (lstCnt != "") {
                	$("#resultCount").html(": " + "<spring:message code='main.t252' />" + lstCnt + " <spring:message code='ezCircular.t104' />");
                } else {
                	$("#resultCount").html("");
                }

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
                DocList.SetTitleIdx(0);
                DocList.SetSelectFlag(false);
                DocList.DataSource(xmlDoc);
                DocList.DataBind("lvBoardList");
                DocList = null;
				
                strListInfo = "";
                
                /* 2018-04-25 홍승비 - 회람판 검색메뉴 디폴트 로우 삭제 */
                if(document.getElementById("BoardList_TR_noItems") != null && lstCnt == "") {
                	document.getElementById("BoardList_TR_noItems").outerHTML = "";
                }
                
                var tempno = 0;
                tempno = tempno + "";
                
                if (tempno.length > 10) {
                    document.getElementById("BoardList_TH_1").style.width = (tempno.length * 10) + "px";
                }

                endtime = new Date().getTime();
                strListInfo = "";
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
	            } else {
	                strtext = "<span class='btnimg first disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='btnimg prev disabled'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='btnimg prev disabled'></span>";
	                PagingHTML += strtext;
	            }
	            var MaxNum;
	            var i;
	            var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	            if (totalPage >= (startNum + parseInt(BlockSize))) {
	                MaxNum = (startNum + parseInt(BlockSize)) - 1;
	            } else {
	                MaxNum = totalPage;
	            }
	            
	            for (i = startNum; i <= MaxNum; i++) {
	                if (i == pageNum) {
	                    strtext = "<span class='on'>" + i + "</span>";
	                    PagingHTML += strtext;
	                } else {
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
	                } else {
	                    strtext = "";
	                    strtext = strtext + "<span class='btnimg next disabled'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
	                PagingHTML += strtext;
	            } else {
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
	                search("");
	            }
	        }
	
	        function prevPage_onclick() {
	            newPage = parseInt(CurPage) - 1;
	            if (newPage > 0) {
	                CurPage = newPage;
	                search("");
	            }
	        }
	
	        function nextPage_onclick() {
	            newPage = parseInt(CurPage) + 1;
	            if (newPage <= parseInt(totalPage)) {
	                CurPage = newPage;
	                search("");
	            }
	        }

		    function ItemRead_onclick(obj) {
		    	var circularID = obj.getAttribute("CIRCULARID");
		    	var type = "";
		    	
		    	/* 2018-08-08 김민성 - 회람판 검색 > 신규회람판 검색시 삭제 버튼 안뜨도록 수정  */
		    	if(filter == "circularNew") {	
		    		type = "&type=new";
		    	}
		    	
		        if (CrossYN()) {
		            var feature = GetOpenPosition(820, 900);
	            	window.open("/ezCircular/circularRead.do?circularID=" + circularID + type, "", "width=820, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	        	} else {
	            	var feature = GetOpenPosition(790, 900);
	            	window.open("/ezCircular/circularRead.do?circularID=" + circularID + type, "", "width=790, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	        	}
		    }
			
		    function search_keypress(evt) {
		        var evtKeyCode = (window.event) ? event.keyCode : evt.which;
		
		        if (evtKeyCode == "13") {
		            search("new");
		        }
		    }
		    
		    // 2018-02-14 주홍선 수정 및 재사용에 대한 액션 뒤 창이 닫히지 않는 것 수정
		    function getLeftCount() {
		    	if (typeof (window.parent.frames.left) != "undefined") {
		    		parent.frames["left"].getNewCircularCount();
		    	}
		    }
		    
		    function refresh_onclick() {
		    	var strListArr = new Array();
	        	strListArr = strListInfo.split(";");

	        	if ((pageCnt - strListArr.length + 1) % 20 == 0 && CurPage != 1) {						
					CurPage = CurPage - 1;
				}

	        	search();
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
	<body class="mainbody" style="overflow:hidden;"> 
		<form method="post"> 
			<h1><spring:message code='ezCircular.t8' /></h1> 
		  	<table style="width:100%" class="content">  
		    	<tr> 
		      		<th><spring:message code='ezCircular.t139' /></th> 
		      		<td style="width:100%">
		      			<select name="search_field" id="search_field" style="width: 130px; height: 22px; vertical-align: middle"> 
		          			<option value="circularNew"><spring:message code='ezCircular.t2' /></option> 
		          			<option value="circularComplete"><spring:message code='ezCircular.t3' /></option>
		          			<option value="circularMy"><spring:message code='ezCircular.t4' /></option>
		          			<option value="circularTemp"><spring:message code='ezCircular.t5' /></option>
		          			<option value="circularFolder"><spring:message code='ezCircular.t7' /></option> 
		        		</select>
		        		<select name="search_type" id="search_type" style="width: 65px; height: 22px; vertical-align: middle"> 
		          			<option value="subject"><spring:message code='ezCircular.t32' /></option> 
		          			<option value="writer"><spring:message code='ezCircular.t166' /></option>
		        		</select>
		        		<input type="text" id="keyword" size="21" onkeypress="return search_keypress(event)" style="height:22px" /> 
		        		<a class="imgbtn imgbck"><span onClick="search('new')"><spring:message code='ezCircular.t85' /></span></a>
		        	</td> 
		    	</tr> 
		    	<tr> 
		      		<th><spring:message code='ezCircular.t137' /></th>
		      		<td>
						<input type="checkbox" value="1" id="usepostdate" onclick="DateSearch_Click()"><label for="usepostdate"><spring:message code='ezCircular.t138'/></label>
		            	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" disabled/> ~
		      			<input type="text" id="Edatepicker" style="width:80px;text-align:center" disabled/>
			  		</td>
			  	</tr>
		  	</table> 
		 	<br/>
		 	<h2 class="h2_dot">
		 		<spring:message code='ezCircular.t146'/>&nbsp;<span id="resultCount"></span>
		    </h2>
		  	<%-- <table class="mainlist" style="width:100%">
		    	<thead id="BoardList_THEAD">
		    		<tr id="BoardList_TH">
		    			<th id="BoardList_TH_0" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;cursor:pointer;" class="h4_center" bgcolor="#CCCCCC" width="20px">
		    				<input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;">
		    			</th>
		    			<th id="BoardList_TH_1" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="28px">
		    				<img src="/images/ImgIcon/view-importance.gif" border="0" align="absmiddle"></th>
		    				<th id="BoardList_TH_2" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="28px">
		    					<img src="/images/ImgIcon/msg-unrd.gif" border="0" align="absmiddle">
		    				</th>
		    				<th id="BoardList_TH_3" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="28px">
		    					<img src="/images/ImgIcon/circular_share2.gif" border="0" align="absmiddle">
		    				</th>
		    				<th id="BoardList_TH_4" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="28px">
		    					<img src="/images/newAttach.gif" border="0" align="absmiddle">
		    				</th>
		    				<th id="BoardList_TH_5" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 70%;" class="h5_center" width="350px">제목</th>
		    				<th id="BoardList_TH_6" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="100px">작성자</th>
		    				<th id="BoardList_TH_7" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="140px">작성일</th>
		    				<th id="BoardList_TH_8" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="55px">확인</th>
		    				<th id="BoardList_TH_9" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="75px">상태</th>
		    			</tr>
		    		</thead>
				<tr>
					<td colspan="9" style="text-align:center"><spring:message code='ezCircular.t144' /></td>
				</tr>
		  	</table> --%>
		</form>
		<span id="MailListRayer" style="border: 0px solid blue; width: 100%; height: 100%; vertical-align: top; overflow: hidden; display: inline-block;">
	        <div style="width:100%; overflow-x:auto; overflow-y:hidden;" id="divList">
	             <div id="lvBoardList"></div> 
	        </div>
	        <div id="tblPageRayer" style="text-align:center"></div>
	    </span> 
	    
	    <!-- 2018-07-17 김보미 - 프로그레스바 -->
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" >&nbsp;</div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
	</body>
</html>

