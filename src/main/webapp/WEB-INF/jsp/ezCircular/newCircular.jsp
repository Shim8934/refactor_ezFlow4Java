<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t2' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />
		<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCircular/PreviewItem.js"></script>
		<script type="text/javascript" src="/js/ezCircular/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezCircular/lang/ezCircular.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circular.js"></script>
		
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
	        var SSUserID = "${userInfo.id}";
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
	        window.onunload = Window_onunload;
	        var window_onunload_Event = false;
	
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
	            
	            var height = parseInt(document.documentElement.clientHeight - 180);
	            document.getElementById("divList").style.height = height + "px";
	            window_onunload_Event = true;
	            getBoardList();
	        }; 
	        var Save_unloadSave = false;
	        function Window_onunload() {
	            if (window_onunload_Event && !Save_unloadSave) {
	                var divStyle, ifrmStyle; 
	                var listCount = 0;
	
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
		            
		            if (divStyle < 24) {
		                divStyle = 24;
		            }
		            
	                $.ajax({
						type : "POST",
						dataType : "json",
						async : false,
						url : "/ezCircular/circularGeneralListSave2.do",
						data : { userID 	 : "${userInfo.id}", 
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
	
	        function getBoardList() {
	        	var searchValue = document.getElementById("txt_keyword").value;
	        	
		        starttime = new Date().getTime();
				url = "/ezCircular/getCircularList.do";
				
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : url,
					data : {
						boardType   : "M", 
						pageNum 	 : CurPage, 
						orderCell 	 : OrderCell, 
						orderOption : OrderOption,
						searchQuery : SQLPARADATA,
						searchValue : searchValue
					},
					success: function(xml){
						getBoardList_after(loadXMLString(xml));
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
                var pageCnt = getNodeText(pageNode);
                var perCnt = getNodeText(perNode);
 
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
				
                strListInfo = "";
                
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
                
                if (typeof (window.parent.frames.left) != "undefined") {
		            parent.frames["left"].getNewCircularCount();
		    	}
            }
	
	        var BlockSize = 10;
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext;
	        }
	        
	        function chk_onselect(obj) {
		        if (obj.checked) {
		            strListInfo += obj.id;
		        } else {
		            strListInfo = ReplaceText(strListInfo, obj.id, "");
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
	                strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
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
	            
	            if (totalPage > BlockSize) {
	                if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
	                    strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
	                    strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
	                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
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
                
                if (typeof (window.parent.frames.left) != "undefined") {
		            parent.frames["left"].getNewCircularCount();
		    	}
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
		    	window.location.href = "/ezCircular/newCircular.do";
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
	            }
	            else if (type == "quick") {
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
	        
	        function Confirm_onclick() {
	        	if (strListInfo.length == 0) {
	        		alert("<spring:message code='ezCircular.t75'/>");
	        		return;
	        	}
	        	
	        	var arrList = new Array();
		        var strItemList = "";
		        var i = 0;
		        
		        arrList = strListInfo.split(";");
		        
		        for (i = 0; i < arrList.length - 1; i++) {
		            strItemList += arrList[i].split(",")[1] + ";";
		        }
		        
		        arrList = null;
		        
	        	if (confirm("<spring:message code='ezCircular.t68'/>")) {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCircular/circularConfirmStatus.do",
						data : { circularIDList : strItemList
								},
						success: function(){
							alert("<spring:message code='ezCircular.t69'/>")
						}        			
					});

		            location.href = location.href;
	        	}	        	
	        }
	        
	    </script>
	</head>
	<body class="mainbody" style="overflow:hidden;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	    <h1><spring:message code='ezCircular.t2'/><span id="mailBoxInfo"></span>
	        <span style="float:right;font-weight:normal;color:black;">
			  <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search('quick')"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onClick="CircularWrite_onclick()"><spring:message code='ezCircular.t55'/></span></li>
	            <li><span onClick="Confirm_onclick()"><spring:message code='ezCircular.t38'/></span></li>
	            <li><span onClick="refresh_onclick()"><spring:message code='ezCircular.t173'/></span></li>
	            
	            <li id="right">
	            	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
	            	<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
					<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" />
				</li>
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
	                        <th><spring:message code='ezCircular.t86'/></th>
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
	        <div id="tblPageRayer" style="text-align:center"></div>
	    </span>
	
	
	    <span id="PreviewRayerH" style="border:0px solid red; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
	        <span id="previewmail_bar_h" class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block;">
	            <p class="hbar_dotted">
	                <img src="/images/prevview_hbar_dotted.gif">
	            </p>
	        </span>
	        <span id="PreContent_RayerH" style="position: absolute; border: 0px solid blue;">
	            <span style="width: 100%; height: 100px; display: block;">
	                <span class="previewmail_info" style="display: block; width: 100%;">
	                    <div id="Preview_HeaderH" style="border-bottom: solid 1px #dadada; width: 100%; display: none;">
	                        <p class="mail_title" style="margin-left: 0px;">
	                            <span class="icon_btn"><span onclick="CircularReadOpen();" style="cursor: pointer; padding-right: 5px;">
	                                <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreH_subject"><span id="PreH_sub_subject" class="title_blodtxt"></span></span>
	                        </p>
	                        <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreH_date"><span id="PreH_sub_date" style="display: none;"></span></span></span>
	                        <dl class="mail_item">
	                            <dt><spring:message code='ezCircular.t169'/> :
	                                <span id="PreH_MailReceiver" style="display: inline-block"></span>
	                            </dt>
	                        </dl>
	                    </div>
	                </span>
	                <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
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
	                            <span class="icon_btn"><span onclick="CircularReadOpen();" style="cursor: pointer; padding-right: 5px;">
	                                <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreW_subject"><span id="PreW_sub_subject"></span></span>
	                        </p>
	                        <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreW_date"><span id="PreW_sub_date"></span></span></span>
	                        <dl class="mail_item">
	                            <dt><spring:message code='ezCircular.t169'/> :</dt>
	                            <dd><span id="PreW_MailReceiver" style="display: inline-block"></span>
	                            </dd>
	                        </dl>
	                    </div>
	                </span>
	                <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
	            </span>
	        </span>
	    </span>
	</body>
</html>