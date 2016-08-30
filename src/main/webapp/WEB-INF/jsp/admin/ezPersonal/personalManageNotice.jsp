<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>ManageNotice</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var pUse_Editor = "<c:out value = '${useEditor}' />";
	        var p_Use_IE11Browser = "<c:out value = '${useIE11Browser}' />";
	        var xmlhttp = null;
	
	        var TotalCount;
	        var totalPage = "";
	        var BlockSize = 10;
	        var pageNum = 1;
	        var PageSize = 12;
	
	        var strLang1 = "<spring:message code = 'ezPersonal.t10002' />";
	        var strLang2 = "<spring:message code = 'ezPersonal.t10000' />";
	        var strLang3 = "<spring:message code = 'ezPersonal.t10001' />";
	        var strLang4 = "<spring:message code = 'ezPersonal.t223' />";
	
	        $(document).ready(function(){
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezPersonal.t106' />");
		        } else {
		            document.getElementById("ListCompany").selectedIndex = 0;
		            company_change();
		        }
	
// 	       		makelist();
	        });
	        
	        function makelist() {
// 	            xmlhttp = null;
// 	            xmlhttp = createXMLHttpRequest();
// 	            xmlhttp.open("POST", "/admin/ezPersonal/manageNoticeList.do?id=" + escape(document.getElementById("ListCompany").value) + "&page=" + pageNum, true);
// 	            xmlhttp.onreadystatechange = event_NoticeList;
// 	            xmlhttp.send();
	            
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezPersonal/manageNoticeList.do",
	            	async : true,
	            	data : {id : encodeURI(document.getElementById("ListCompany").value), page : pageNum},
	            	success : function(result) {
	            		eventNoticeList(result);
	            	}
	            });
	        }
	        
	        function eventNoticeList(result) {
	            try {
	                document.getElementById("AccessList").innerHTML = "";
	                var xmldom = loadXMLString(result);

	                var headerData = createXmlDom();
	                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

	                if (CrossYN()) {
	                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
	                    var Node = headerData.importNode(xmlRtn, true);
	                    headerData.documentElement.appendChild(Node);
	                } else {
	                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
	                    headerData.documentElement.appendChild(xmlRtn);
	                }

	                var listview = new ListView();
	                listview.SetID("AccessListView");
	                listview.SetSelectFlag(false);
	                listview.SetMulSelectable(true);
	                listview.SetRowOnDblClick("NoticeList_onDblclick");
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

	                makePageSelPage();
	            } catch (e) {
	            }
	        }

	        function company_change() {
	        	pageNum = 1;
	        	makelist();
	        }
	        
	        var AddNotice_dialogArguments = new Array();
	        function add_notice() {
	            if (CrossYN()) {
	                if (pUse_Editor == "TAGFREE") {
	                    //rtnValue = window.showModalDialog("AddNotice_TFX.aspx", document.getElementById("ListCompany").value,
	                    //    "dialogHeight:510px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 510));
	                    AddNotice_dialogArguments[0] = document.all("ListCompany").value;
	                    AddNotice_dialogArguments[1] = add_notice_Complete;
	                    var OpenWin = window.open("AddNotice_TFX.aspx", "AddNotice_TFX", GetOpenWindowfeature(800, 510));
	                    try { OpenWin.focus(); } catch (e) { }
	                } else {
	                    //rtnValue = window.showModalDialog("AddNotice_CK.aspx", document.getElementById("ListCompany").value,
	                    //"dialogHeight:510px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 510));
	                    AddNotice_dialogArguments[0] = document.all("ListCompany").value;
	                    AddNotice_dialogArguments[1] = add_notice_Complete;
	                    var OpenWin = window.open("AddNotice_CK.aspx", "AddNotice_CK", GetOpenWindowfeature(800, 510));
	                    try { OpenWin.focus(); } catch (e) { }
	                }
	            } else {
	                if (pUse_Editor == "TAGFREE") {
	                    rtnValue = window.showModalDialog("AddNotice_TFI.aspx", document.all("ListCompany").value,
	                        "dialogHeight:510px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 510));
	                } else {
	                    if (p_Use_IE11Browser == "CK") {
	                        rtnValue = window.showModalDialog("AddNotice_CK.aspx", document.all("ListCompany").value,
	                        "dialogHeight:510px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 510));
	                    } else {
	                        rtnValue = window.showModalDialog("AddNotice.aspx", document.all("ListCompany").value,
	                        "dialogHeight:510px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 510));
	                    }
	                }
	                
	                if (typeof (rtnValue) != "undefined") {
	                    company_change();
	                }
	            }
	        }
	        
	        function add_notice_Complete(rtnValue) {
	            if (typeof (rtnValue) != "undefined") {
	                company_change();
	            }
	        }

	        function del_notice(popup_number, pnumber) {
	            if (!confirm(pnumber + " <spring:message code = 'ezPersonal.t159' />")) {
	                return;
	            }

	            var xmlHTTP = createXMLHttpRequest();
	            var xmlDom = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlDom, objNode, "DATAlist");
	            createNodeAndInsertText(xmlDom, objNode, "DATA", popup_number);
	            xmlHTTP.open("POST", "DelNotice.aspx", false);
	            xmlHTTP.send(xmlDom);
	            
	            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
	                alert("<spring:message code = 'ezPersonal.t160' />");
	            } else {
	                alert("<spring:message code = 'ezPersonal.t161' />");
	                makelist();
	            }
	        }

	        function mod_notice(notice_number) {
	            if (pUse_Editor == "TAGFREE") {
	                rtnValue = window.showModalDialog("AddNotice_TFX.aspx?itemseq=" + notice_number, escape(document.getElementById("ListCompany").value), "dialogHeight:500px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 500));
	            } else {
	                rtnValue = window.showModalDialog("AddNotice_ck.aspx?itemseq=" + notice_number, escape(document.getElementById("ListCompany").value), "dialogHeight:500px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 500));
	            }
	            
	            if (typeof (rtnValue) != "undefined") {
	                makelist();
	            }
	        }

	        function NoticeList_onDblclick(obj) {
	            var itemseq = document.getElementById(obj).getAttribute("DATA1");

	            if (itemseq == "0") {
	                return;
	            }
	            
	            window.open("/myoffice/ezpersonal/Notice/ShowNotice_Cross.aspx?itemseq=" + itemseq, "", "height=550px,width=550px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(550, 550));
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
	                strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/Sub/btn_p_prev.gif' width='16' height='16'></span>"
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/Sub/btn_p_prev01.gif' width='16' height='16'></span>"
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/Sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang2 + "</span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang2 + "</span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang2 + "</span>";
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
	                    strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/Sub/btn_next.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang3 + "</span>";
	                    strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang3 + "</span>";
	                strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/Sub/btn_n_next.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/Sub/btn_n_next01.gif' width='16' height='16'></span>";
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
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
			  			<NAME><spring:message code = 'ezPersonal.t167' /></NAME>
			  			<WIDTH></WIDTH>
					</HEADER>
					<HEADER>
			  			<NAME><spring:message code = 'ezPersonal.t168' /></NAME>
			  			<WIDTH>100</WIDTH>
					</HEADER>
					<HEADER>
			  			<NAME><spring:message code = 'ezPersonal.t169' /></NAME>
			   			<WIDTH>60</WIDTH>
			 		</HEADER>
					<HEADER>
			   			<NAME><spring:message code = 'ezPersonal.t99' /></NAME>
		        		<WIDTH>60</WIDTH>
			      	</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<form method="post" runat="server">
	        <h1><spring:message code = 'ezPersonal.t157' /><span id="mailBoxInfo"></span></h1>
	        <div id="mainmenu">
	            <ul>
	            	<li style="background: none">
		                <SELECT id="ListCompany" name="ListCompany" onChange="company_change()">
			        	<c:forEach var="item" items="${list}">
		            		<option value="<c:out value='${item.cn}'/>" ><c:out value='${item.displayName}'/></option>
		            	</c:forEach>
			        	</SELECT>
		        	</li>
	                <li><span onclick="add_notice()"><spring:message code = 'ezPersonal.t158' /></span></li>
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