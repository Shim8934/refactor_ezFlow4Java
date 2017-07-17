<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />		
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>	    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/ezCircular/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezCircular/lang/ezCircular.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	    <script type="text/javascript">
	    	var CurPage = "1";
	    	var OrderCell = "";
	    	var OrderOption = "";
	    	var checkval = "f";
	    	var keyword = "";
	        var filter = "";
	        var result = ""
			var startdate = "<c:out value='${startDate}' />";
			var enddate = "<c:out value='${endDate}' />";
			var offSetMin = "<c:out value='${offSetMin}' />";

		    document.onselectstart = function () { return false; };
		    
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }

		        var height = parseInt(document.documentElement.clientHeight - 240);
		        document.getElementById("divList").style.height = height + "px";
		        $("keyword").text = "";
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
		        var SDate;
		        var EDate;
		        
		        if (startdate != "") {	
		            SDate = new Date(startdate);
		            EDate = new Date(enddate);
		        } else {
		            SDate = utcDate(offSetMin);
		            EDate = utcDate(offSetMin);		            
		        }
		        
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
		        $.datepicker.regional["<spring:message code='ezCircular.t130' />"] = {
		        	closeText: "<spring:message code='ezCircular.t84' />",
		            prevText: "<spring:message code='ezCircular.t131' />",
		            nextText: "<spring:message code='ezCircular.t132' />",
					currentText: "<spring:message code='ezCircular.t133' />",
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
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='ezCircular.t130' />"]);
		    });
		    
		    var usepostDate = false;
		    function DateSearch_Click() {
		        if(usepostDate){
		            usepostDate = false;
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        }
		        else {
		            usepostDate = true;
		            $("#Sdatepicker").datepicker('enable');
		            $("#Edatepicker").datepicker('enable');
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
	                search();
	            }
	        }
		
		    function search() {		    	
		    	if (specialChk(document.getElementById("keyword").value)) {
		    		alert("<spring:message code='ezCircular.t134' />");
		    		return;
		    	}
		    	
		        if (document.getElementById("keyword").value == "") {
		            alert("<spring:message code='ezCircular.t135'/>");
		            document.getElementById("keyword").focus();
		            return;
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

		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : url,
		        	data : {
		        		sdate : sdate,
		        		edate : edate,
		        		pageNum : CurPage,
		        		searchValue : keyword,
		        		orderCell : OrderCell,
		        		orderOption : OrderOption
		        	},
		        	success : function(xml) {
		        		getSearchList_after(loadXMLString(xml));
		        		$("[name='mainlist']").css("display", "none");
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
                var pageCnt = getNodeText(pageNode);
                var perCnt = getNodeText(perNode);
 
                $(".point").text(lstCnt);

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

                endtime = new Date().getTime();
                strListInfo = "";
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
	                search();
	            }
	        }
	
	        function prevPage_onclick() {
	            newPage = parseInt(CurPage) - 1;
	            if (newPage > 0) {
	                CurPage = newPage;
	                search();
	            }
	        }
	
	        function nextPage_onclick() {
	            newPage = parseInt(CurPage) + 1;
	            if (newPage <= parseInt(totalPage)) {
	                CurPage = newPage;
	                search();
	            }
	        }

		    function ItemRead_onclick(circularID) {
		        var circularID = circularID;

		        if (CrossYN()) {
		            var feature = GetOpenPosition(820, 900);
	            	window.open("/ezCircular/circularRead.do?circularID=" + circularID, "", "width=820, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	        	} else {
	            	var feature = GetOpenPosition(790, 900);
	            	window.open("/ezCircular/circularRead.do?circularID=" + circularID, "", "width=790, height=900, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
	        	}
		    }
			
		    function RefreshView() {
		        window.location.href = "/ezCircular/circularSearchView.do?sdate=" + startdate + "&edate=" + enddate + "&filter=" + encodeURIComponent(filter) + "&keyword=" + encodeURIComponent(keyword);
		    }
			
		    function onmouseOver(elem) {
		        elem.style.color = "blue";
		        elem.style.backgroundColor = "rgb(233, 241, 244)";
		    }
		
		    function onmouseOut(elem) {
		        elem.style.color = "";
		        elem.style.backgroundColor = "#FFFFFF";
		    }
			
		    function search_keypress(evt) {
		        var evtKeyCode = (window.event) ? event.keyCode : evt.which;
		
		        if (evtKeyCode == "13") {
		            search();
		        }
		    }
		</script>
	</head>
	<body class="mainbody"> 
		<form method="post"> 
			<h1><spring:message code='ezCircular.t8' /></h1> 
		  	<table style="width:100%" class="content">  
		    	<tr> 
		      		<th><spring:message code='ezCircular.t139' /></th> 
		      		<td style="width:100%">
		      			<select name="search_field" id="search_field" style="WIDTH: 130px"> 
		          			<option value="circularNew" ${filter == 'circularNew' ? 'selected' : ''}><spring:message code='ezCircular.t2' /></option> 
		          			<option value="circularComplete" ${filter == 'circularComplete' ? 'selected' : ''}><spring:message code='ezCircular.t3' /></option>
		          			<option value="circularMy" ${filter == 'circularMy' ? 'selected' : ''}><spring:message code='ezCircular.t4' /></option>
		          			<option value="circularTemp" ${filter == 'circularTemp' ? 'selected' : ''}><spring:message code='ezCircular.t5' /></option>
		          			<option value="circularFolder" ${filter == 'circularFolder' ? 'selected' : ''}><spring:message code='ezCircular.t7' /></option> 
		        		</select>
		        		<input type="text" id="keyword" size="21" onkeypress="return search_keypress(event)" /> 
		        		<a href="#" class="imgbtn"><span onClick="search()"><spring:message code='ezCircular.t85' /></span></a>
		        	</td> 
		    	</tr> 
		    	<tr> 
		      		<th><spring:message code='ezCircular.t137' /></th>
		      		<td>
						<input type="checkbox" value="1" id="usepostdate" style="display:none;"><a class="imgbtn"><span onclick="DateSearch_Click();"><spring:message code='ezCircular.t138' /></span></a>
		            	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" disabled/> ~
		      			<input type="text" id="Edatepicker" style="width:80px;text-align:center" disabled/>
			  		</td>
			  	</tr>
		  	</table> 
		 	<br/>
		 	<h2 class="h2_dot">
		 		<spring:message code='ezCircular.t146'/>&nbsp;<span class="point"></span>&nbsp;<span id="resultCount"></span><spring:message code='ezCircular.t145'/>
		    </h2>
		  	<table class="mainlist" name="mainlist" style="width:100%">
		    	<tr> 
		      		<th style="width:20px; color: black;" nowrap title><input type="checkbox" id="Checkbox" onClick="check_change(this)"></th>
			        <th style="width:28px; color: black;cursor:pointer;" nowrap class="image" onclick="event_HeaderClick(this)"><img src="/images/ImgIcon/view-importance.gif" border="0"></th>
			        <th style="width:28px; color: black;cursor:pointer;" nowrap class="image" onclick="event_HeaderClick(this)"><img src="/images/ImgIcon/circular_new.gif" border="0"></th>
					<th style="width:28px;cursor:pointer;" class="image" onclick="event_HeaderClick(this)"><img src="/images/newAttach.gif" border="0"></th> 
					<th style="width:350px;cursor:pointer;" id="tofromname" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t32' /></th>
					<th style="width:150px;cursor:pointer" align="left" id="tofromdate" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t122' /></th> 
					<th style="width:60px;" align="left"><spring:message code='ezCircular.t33' /></th> 
					<th style="width:80px;cursor:pointer;text-align:center" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t65' /></th>
					<th style="width:20px;cursor:pointer" align="left" onclick="event_HeaderClick(this)"><spring:message code='ezCircular.t124' /></th>
				</tr>
				<tr>
					<td colspan="9" style="text-align:center"><spring:message code='ezCircular.t144' /></td>
				</tr>
		  	</table>		    
		</form>
		<span id="MailListRayer" style="border: 0px solid blue; width: 100%; height: 100%; vertical-align: top; overflow: hidden; display: inline-block;">
	        <div style="width:100%; overflow:AUTO;" id="divList">
	             <div id="lvBoardList"></div> 
	        </div>
	        <div id="tblPageRayer" style="text-align:center"></div>
	    </span> 
	</body>
</html>

