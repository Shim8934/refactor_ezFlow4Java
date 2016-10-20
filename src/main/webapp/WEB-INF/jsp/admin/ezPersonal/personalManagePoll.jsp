<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var totalCount = "";
	        var progressPollFlag = "";
	        var TotalCount;
	        var totalPage = "";
	        var BlockSize = 10;
	        var pageNum = 1;
	        var PageSize = 12;
	        var progressPollFlag = "false";
	
	        var strLang1 = "<spring:message code = 'ezPersonal.t10002' />";
	        var strLang2 = "<spring:message code = 'ezPersonal.t10000' />";
	        var strLang3 = "<spring:message code = 'ezPersonal.t10001' />";
	        var strLang4 = "<spring:message code = 'ezPersonal.t223' />";
	
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
			};
			
			$(document).ready(function() {
	            if (document.getElementById("ListCompany").length == 0)
	                alert("<spring:message code = 'ezPersonal.t106' />");
	            else {
	                document.getElementById("ListCompany").selectedIndex = 0;
	            }
	
	            makelist();
	        });
			
	        function makelist() {
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezPersonal/managePollList.do",
	            	async : true,
	            	data : {companyID : encodeURIComponent(document.getElementById("ListCompany").value), page : pageNum},
	            	success : function (result) {
	            		event_PollList(result);
	            	}
	            });
	        }
	        
		    function event_PollList(result) {
		        try {
		            document.getElementById("AccessList").innerHTML = "";
		            var xmldom = result
		            var headerData = createXmlDom();
		            headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		
		            if (CrossYN()) {
		                var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                var Node = headerData.importNode(xmlRtn, true);
		                headerData.documentElement.appendChild(Node);
		            } else {
		                var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                headerData.documentElement.appendChild(xmlRtn);
		            }
		            
		            var listview = new ListView();
		            listview.SetID("AccessListView");
		            listview.SetSelectFlag(false);
		            listview.SetMulSelectable(true);
		            listview.SetRowOnDblClick("PollList_onDblclick");
		            listview.DataSource(headerData);
		            listview.DataBind("AccessList");
		            //listview.DataSource(xmldom);
		            listview.RowDataBind();
		            xmldomNode = null;
		
		            if (CrossYN()) {
		                TotalCount = parseInt(SelectSingleNodeValueNew(xmldom, "TOTALCNT"));
		                pageNum = parseInt(SelectSingleNodeValueNew(xmldom, "CURPAGE"));
		            } else {
		                TotalCount = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "TOTALCNT"));
		                pageNum = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "CURPAGE"));
		            }
		            
		            totalPage = Math.ceil(new Number(TotalCount / PageSize));
		            
		            if (CrossYN()) {
		                progressPollFlag = SelectSingleNodeValueNew(xmldom, "PROFLAG");
		            } else {
		                progressPollFlag = SelectSingleNodeValueNew(xmldom.documentElement, "PROFLAG");
		            }
		            
		            makePageSelPage();
		        } catch (e) {
		
		        }
		    }
		    
		    function PollList_onDblclick(obj) {
		        var itemseq = document.getElementById(obj).getAttribute("DATA1");
		        if (itemseq == "0") {
		            return;
		        }
		        
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 455) / 2;
		        var top = (heigth - 400) / 2;
		
		        window.open("/ezPersonal/pollResult.do?itemSeq=" + itemseq, "", "height=400px,width=455px, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=" + top + ",left = " + left);
		    }
		    
		    function company_change() {
		        makelist();
		    }
		    
		    var addpoll_cross_dialogArguments = new Array();
		    function add_poll() {
		        if (totalCount != "0" && progressPollFlag == "true") {
		            if (!confirm("<spring:message code = 'ezPersonal.t234' />")) {
		                return;
		            }
		        }
		        
		        if (CrossYN()) {
		            addpoll_cross_dialogArguments[0] = document.getElementById("ListCompany").value;
		            addpoll_cross_dialogArguments[1] = add_poll_Complete;
		            var AddPoll_Cross = window.open("/admin/ezPersonal/addPoll.do", "AddPoll_Cross", GetOpenWindowfeature(450, 490));
		            try { AddPoll_Cross.focus(); } catch (e) {
		            }
		        } else {
		            rtnValue = window.showModalDialog("/admin/ezPersonal/addPoll.do", document.getElementById("ListCompany").value, "dialogHeight:490px;dialogwidth:430px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(430, 490));
		
		            if (typeof (rtnValue) != "undefined") {
		                company_change();
		            }
		        }
		    }
	
	        function add_poll_Complete(rtv) {
	            if (typeof (rtv) != "undefined") {
	                company_change();
	            }
	        }
	
	        function del_poll(poll_number) {
	            if (!confirm(poll_number + "<spring:message code = 'ezPersonal.t236' />")) {
	                return;
	            }
	            
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezPersonal/delPoll.do",
	            	async : false,
	            	data : {itemSeq : poll_number},
	            	dataType : "text",
	            	success : function(result) {
	            		if (result != "OK") {
	            			alert("<spring:message code = 'ezPersonal.t237' />");
	            		} else {
	            			alert("<spring:message code = 'ezPersonal.t238' />");
	            			
	    	                if (document.getElementById("rowdata") != null && typeof (document.getElementById("rowdata").length) == "undefined" && page != 1) {
	    	                    pagemove(-1);
	    	                } else {
	    	                    makelist();
	    	                }
	            		}
	            	}
	            });
	        }
	        
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = " &nbsp;[" + strLang1 + "<span style='color:#017BEC;'> " + TotalCount + " </span>" + strLang4 + "]";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang2 + "</span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang2 + "</span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang2 + "</span>";
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
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang3 + "</span>";
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang3 + "</span>";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang3 + "</span>";
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
		        pageNum = Value;
		        makePageSelPage();
		        makelist();
		    }
		    
		    function selbeforeBlock() {
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selbeforeBlock_one() {
		        if (parseInt(pageNum - 1) > 0) {
		            goToPageByNum(parseInt(pageNum - 1));
		        } else {
		            return;
		        }
		    }
		    
		    function selafterBlock() {
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selafterBlock_one() {
		        if (parseInt(pageNum + 1) <= totalPage) {
		            goToPageByNum(parseInt(pageNum + 1));
		        } else {
		            return;
		        }
		    }
		    
		    function selNum(pselNum) {
		        pageNum = pselNum;
		        makelist();
		    }
		    
		    function selNext() {
		        pageNum = pageNum + 1;
		        makelist();
		    }
		    
		    function selPrev() {
		        pageNum = pageNum - 1;
		        makelist();
		    }
		    
		    function td_Create(strtext) {
		        tblPageNum.innerHTML = tblPageNum.innerHTML + strtext;
		    }
		</script>
	</head>
	<body class = "mainbody">
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
	    		<HEADERS>
	      			<HEADER>
	        			<NAME><spring:message code = 'ezPersonal.t166' /></NAME>
	        			<WIDTH>40</WIDTH>
	      			</HEADER>
	      			<HEADER>
	        			<NAME><spring:message code = 'ezPersonal.t240' /></NAME>
	        			<WIDTH></WIDTH>
	      			</HEADER>
	      			<HEADER>
	        			<NAME><spring:message code = 'ezPersonal.t241' /></NAME>
	        			<WIDTH>100</WIDTH>
	      			</HEADER>
	      			<HEADER>
	        			<NAME><spring:message code = 'ezPersonal.t242' /></NAME>
	        			<WIDTH>100</WIDTH>
	      			</HEADER>
	     			<HEADER>
	        			<NAME><spring:message code = 'ezPersonal.t99' /></NAME>
	        			<WIDTH>60</WIDTH>
	      			</HEADER>
    			</HEADERS>
  			</LISTVIEWDATA>
		</xml>
		
	    <form method="post">
	        <h1>Quick Poll<span id="mailBoxInfo"></span></h1>
	        <div id="mainmenu">
	            <ul>
	                <li style="background: none">
	                    <SELECT id="ListCompany" name="ListCompany" onChange="company_change()">
			        	<c:forEach var="item" items="${list}">
		            		<option value="<c:out value='${item.cn}'/>" ><c:out value='${item.displayName}'/></option>
		            	</c:forEach>
			        	</SELECT>
	                </li>
	                <li><span onclick="add_poll()"><spring:message code = 'ezPersonal.t235' /></span></li>
	            </ul>
	        </div>
	        
	        <script type="text/javascript">
	            selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        </script>
	        
	        <table class="mainlist" style="width: 100%;">
	            <div id="AccessList" style="BORDER: 0; WIDTH: 100%"></div>
	        </table>
	        
	        <div id="tblPageRayer" style="margin-bottom: 10px;"></div>
	    </form>
	</body>
</html>