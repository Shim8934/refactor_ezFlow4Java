<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1310' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		
		<script type="text/javascript">
			var labelcolor = "gray";
	        var OrderCell = "";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var DocID, pURL, jobState = "";
	        var pChackYN = "FALSE";
	        var g_tagSelectsub = "1";
	        var NodeList2, pageSize = 10, ListViewNode, Block_Size, pTotalCnt = "";
	        var NodeList, curpage, nowblock, totalPage, totalPages, block, p_page, p_nowblock, NodeListLen;
	        var pageNum = "1";
	        var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
	        var SearchCond = new Array();
	
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
			};
			
			$(document).ready(function(){
	            var height = parseInt(divList.style.height.replace('px', '')) + 200;
	            var reheight = document.documentElement.clientHeight - parseInt(height);
	            document.getElementById('div_AprLine').style.height = reheight + "px";
	
	            document.getElementById("SCompID").value = pCompanyID;
	            GetDocList();
	        });
	
	        function lvtDoclist_SelChange() {
	            var SelList = new ListView();
	            SelList.LoadFromID("DocList");
	            var oArrRows = SelList.GetSelectedRows();
	
	            if (oArrRows.length != 0) {
	                var tr = oArrRows[0];
	
	                DocID = tr.getAttribute("DATA1");
	                pURL = tr.getAttribute("DATA3");
	
	                switch (jobState) {
	                    case "ATTACH":
	                        Attach_onclick();
	                        break;
	
	                    case "OPINION":
	                        Opinion_onclick();
	                        break;
	
	                    case "APPROVAL":
	                        Approval_onclick();
	                        break;
	
	                    case "RECIPENT":
	                        Recipent_onclick();
	                        break;
	                }
	            }
	        }
	        
	        function GetDocList() {
	            var pDocstate = "000";
	            if (pChackYN == "FALSE") {
	                for (var i = 0; i < 20; i++) {
	                    SearchCond[i] = "";
	                }
	                //curpage = 1;
	                //nowblock = 0;
	                //totalPage = 0;
	            } else if (pChackYN == "SEARCH") {
	                //curpage = 1;
	                //nowblock = 0;
	                //totalPage = 0;
	            }
	            
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezApprovalG/getStatSearchAprDocList.do",
	            	async : true,
	            	data : {
	            		docNumber : SearchCond[0],
	            		docTitle : SearchCond[1],
	            		drafter : SearchCond[2],
	            		drafter2 : SearchCond[2],
	            		draftFromYear : SearchCond[3],
	            		draftFromMonth : SearchCond[4],
	            		draftFromDay : SearchCond[5],
	            		draftToYear : SearchCond[6],
	            		draftToMonth : SearchCond[7],
	            		draftToDay : SearchCond[8],
	            		apprFromYear : SearchCond[9],
	            		apprFromMonth : SearchCond[10],
	            		apprFromDay : SearchCond[11],
	            		apprToYear : SearchCond[12],
	            		apprToMonth : SearchCond[13],
	            		apprToDay : SearchCond[14],
	            		formID : SearchCond[15],
	            		deptName1 : SearchCond[17],
	            		deptName2 : SearchCond[17],
	            		pageNum : pageNum,
	            		pageSize : pageSize,
	            		docState : "",
	            		subQuery : SearchCond[18],
	            		orderCell : "",
	            		orderOption : "",
	            		approvUser : SearchCond[19],
	            		companyID : pCompanyID
	            	},
	            	success : function(result) {
	            		getDocList_after(result);
	            	}
	            });
	        }
	        
	        function getDocList_after(result) {
	            try {
	                if (result == "") {
	                	return;
	                }
	
	                Resultxml = loadXMLString(result);
	
	                ListViewNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
	                NodeList = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
	                NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");
	                Haders = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/HEADERS/HEADER");
	                NodeListLen = 0;
	
	                var lstCnt = getNodeText(NodeList2);
	                totalPage = Math.ceil(new Number(lstCnt / pageSize));
	                pTotalCnt = lstCnt;
	                makePageSelPage();
	
	                var xmlDoc;
	
	                if (CrossYN()) {
	                    var xmlLIST = createXmlDom();
	                    var nodeToImport = xmlLIST.importNode(ListViewNode, true);
	                    xmlLIST.appendChild(nodeToImport);
	                    xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
	                } else {
	                    xmlDoc = createXmlDom();
	                    xmlDoc.appendChild(ListViewNode);
	                }
	
	                ListViewNode = xmlDoc;
	
	                if (document.getElementById("lvtDoclist").innerHTML != "") {
	                    document.getElementById("lvtDoclist").innerHTML = "";
	                }
	
	                var DocList = new ListView();
	                DocList.SetID("DocList");
	                DocList.SetMulSelectable(false);
	                DocList.SetRowOnClick("lvtDoclist_SelChange");
	                DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");
	                DocList.SetUrgentFlag(true);
	                DocList.SetSecurityFlag(false);
	                DocList.DataSource(ListViewNode);
	                DocList.DataBind("lvtDoclist");
	                DocList = null;
	                selFirstRow(Resultxml);
	            }
	            catch (e) {
	            }
	        }
	
	        function DisplayLineCnt(NodeListLen) {
	            listcount.innerText = "<spring:message code = 'ezApprovalG.t1312' />" + NodeListLen + "<spring:message code = 'ezApprovalG.t1313' />";
	        }

	        function paging(p_page, p_nowblock) {
	            var h, j, x_NAME, x_WIDTH, x_HEADER, x_CELL2, x_VALUE2, count;
	
	            if (document.getElementById("lvtDoclist").innerHTML != "") {
	                document.getElementById("lvtDoclist").innerHTML = "";
	            }
	
	            var DocList = new ListView();
	            DocList.SetID("DocList");
	            DocList.SetMulSelectable(false);
	            DocList.SetRowOnClick("lvtDoclist_SelChange");
	            DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");
	            DocList.SetUrgentFlag(true);
	            DocList.SetSecurityFlag(false);
	            DocList.DataSource(ListViewNode);
	            DocList.DataBind("lvtDoclist");
	            DocList = null;
	
	            pagingCount(p_page, p_nowblock);
	            selFirstRow(Resultxml);
	            pChackYN = "FALSE";
	        }
	
	        function pagingCount(p_page, p_nowblock) {
	            totalPages = parseInt(NodeListLen / PageSize);
	            if (((totalPages * PageSize) != NodeListLen) && ((NodeListLen % PageSize) != 0)) {
	            	totalPages = totalPages + 1;
	            }
	
	            document.getElementById("td_pTotalCount").innerHTML = totalPages;
	            document.getElementById("txt_PageInputNum").value = curpage;
	        }
	        
	        function goToPage(page) {
	            if (page == "front") {
	                if (parseInt(curpage) - 1 < 1) {
	                    return;
	                }
	                
	                curpage = curpage - 1;
	                pChackYN = "TRUE";
	                GetDocList();
	            } else if (page == "next") {
	                if (parseInt(curpage) + 1 > parseInt(totalPages)) {
	                    return;
	                }
	                
	                curpage = curpage + 1;
	                pChackYN = "TRUE";
	                GetDocList();
	            } else if (page == "page") {
	                if (event.keyCode == 13) {
	                    var goPage = document.all.txt_PageInputNum.value;
	                    
	                    if (parseInt(goPage) != goPage || parseInt(goPage) == "" || parseInt(goPage) < 1 || parseInt(goPage) > parseInt(totalPages)) {
	                        return;
	                    }
	                    
	                    curpage = parseInt(goPage);
	                    pChackYN = "TRUE";
	                    GetDocList();
	                }
	            }
	        }
	
	        var BlockSize = 10;
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext;
	        }
	        
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            document.getElementById("mailBoxInfo").innerHTML = " &nbsp;[" + strLang942 + "<span style='color:#017BEC;'> " + pTotalCnt + " </span>" + strLang943 + "]";
	            strtext = "<div class='pagenavi'>";
	            PagingHTML += strtext;
	            
	            if (totalPage > 1 && pageNum != 1) {
	                strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
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
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang941 + "</span>";
	                    strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang941 + "</span>";
	                    strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang941 + "</span>";
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
	            currentpage = Value;
	            pageNum = currentpage;
	            makePageSelPage();
	            GetDocList();
	        }
	        
	        function selbeforeBlock() {
	            var pageNum = currentpage;
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
	            var pageNum = currentpage;
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
	            GetDocList();
	        }
	        
	        function selNext() {
	            pageNum = pageNum + 1;
	            GetDocList();
	        }
	        
	        function selPrev() {
	            pageNum = pageNum - 1;
	            GetDocList();
	        }
	        
	        function selbeforeBlock() {
	            pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	            GetDocList();
	        }
	        
	        function selafterBlock() {
	            pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	            GetDocList();
	        }
	        
	        function td_Create(strtext) {
	            tblPageNum.innerHTML = tblPageNum.innerHTML + strtext;
	        }
	
	        function selFirstRow(Resultxml) {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var tr = oArrRows[0];
	
	            if (oArrRows.length != 0) {
	                DocID = tr.getAttribute("DATA1");
	            } else {
	                DocID = "";
	            }
	
	            if (jobState == "APPROVAL") {
	                Approval_onclick();
	            } else if (jobState == "ATTACH") {
	                Attach_onclick();
	            } else if (jobState == "RECIPENT") {
	                Recipent_onclick();
	            } else if (jobState == "OPINION") {
	                Opinion_onclick();
	            } else {
	                Approval_onclick();
	            }
	        }
	
	        function getDataInfo() {	            
	            var ajaxURL = "";
	            var ajaxAsync = false;
	            
	            switch (jobState) {
	                case "ATTACH":
	                	ajaxURL = "/admin/ezApprovalG/getStatAttachList.do";
	                	ajaxAsync = true;
	                    break;
	
	                case "OPINION":
	                	ajaxURL = "/admin/ezApprovalG/getStatOpinionList.do";
	                	ajaxAsync = true;
	                    break;
	
	                case "APPROVAL":
	                	ajaxURL = "/admin/ezApprovalG/getStatLineList.do";
	                	ajaxAsync = false;
	                    break;
	
	                case "RECIPENT":
	                	ajaxURL = "/admin/ezApprovalG/getStatReceiptList.do";
	                	ajaxAsync = true;
	                    break;
	            }
	            
	            $.ajax({
	            	type : "POST",
	            	url : ajaxURL,
	            	async : ajaxAsync,
	            	data : {docID : DocID, flag : "APR", companyID : pCompanyID},
	            	success : function (result) {
	            		getdoclistSub_after(result);
	            	}
	            });
	        }
	
	        function getdoclistSub_after(result) {
	            try {
	                Resultxml = loadXMLString(result);
	                if (document.getElementById("lvAprLine").innerHTML != "") {
	                    document.getElementById("lvAprLine").innerHTML = "";
	                }
	
	                var DocList = new ListView();
	                DocList.SetID("SubDocList");
	                DocList.SetMulSelectable(false);
	                DocList.SetRowOnDblClick("lvtDetail_onSel_DBclick");
	                DocList.SetUrgentFlag(false);
	                DocList.DataSource(Resultxml);
	                DocList.DataBind("lvAprLine");
	            }
	            catch (e) { }
	        }
	
	        function Approval_onclick() {
	            jobState = "APPROVAL";
	            getDataInfo();
	        }
	        function Attach_onclick() {
	            jobState = "ATTACH";
	            getDataInfo();
	        }
	        function Recipent_onclick() {
	            jobState = "RECIPENT";
	            getDataInfo();
	        }
	        function Opinion_onclick() {
	            jobState = "OPINION";
	            getDataInfo();
	        }
	        function MM_swapImagesub(nSel, evt) {
	            if (nSel != g_tagSelectsub) {
	                g_tagSelectsub = nSel;
	                var Element = window.event.srcElement;
	
	                Element.src = "/images/tab_appsub" + nSel + ".gif";
	                Element.height = "23";
	
	                var i;
	                for (i = 1 ; i <= 4; i++) {
	                    if (g_tagSelectsub != i) {
	                        var str = "tagsub" + i + ".src" + "=" + "\"/images/tab_appsub" + i + "a.gif\"";
	                        eval(str);
	                        var str = "tagsub" + i + ".height" + "=" + "23";
	                        eval(str);
	                    }
	                }
	            }
	        }
	        
	        function lvtDoclist_onSel_DBclick() {
	            ViewDoc_onclick();
	        }
	        
	        function ViewDoc_onclick() {
	            if (DocID == "") {
	                alert("<spring:message code = 'ezApprovalG.t633' />");
	            } else {
	                var para = new Array();
	                para[0] = DocID;
	                para[1] = pURL;
	                
	                if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "doc") {
	                    var openLocation = "/myoffice/ezApprovalG/ezViewWord/ezViewApr_Word.aspx?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL);
	                    openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=";
	                } else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	                    var openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewApr_HWP.aspx?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL);
	                    openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=";
	                } else {
	                    if (CrossYN()) {
	                        var openLocation = "/ezApprovalG/aprDocView.do?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL);
	                        openLocation = openLocation + "&opinionFlag=&docState=&listSusin=&oDoc=&isOpinion=&listType=";
	                    } else {
	                        var openLocation = "/myoffice/ezApprovalG/AprDocView.aspx?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL);
	                        openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=";
	                    }
	                }
	                openwindow(openLocation, "", 880, 550);
	            }
	        }
	        
			function ResizeTableWidth() {
			    lvAprLine.headers.headerTable.style.width = 790;
			    lvAprLine.rows.rowTable.style.width = 790;
			}
			
			function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
			    try {
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
			        var left = 0;
			        var top = 0;
			
			        if (window.screen.width > 800) {
			            var pleftpos;
			
			            pleftpos = parseInt(width) - 967;
			            heigth = parseInt(heigth) - 30;
			            width = parseInt(width) - pleftpos;
			            left = pleftpos / 2;
			        } else {
			            heigth = parseInt(heigth) - 30;
			            width = parseInt(width) - 10;
			        }
			
			        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
			    } catch (e) {
			        alert("openwindow :: " + e.description);
			    }
			}
			
			var g_progresswin = null;
			function showProgress() {
			    g_progresswin = window.showModelessDialog("/ezApprovalG/showProgress.do?fileInfo=" + encodeURI("<spring:message code = 'ezApprovalG.t628' />"), "", "dialogWidth=390px; dialogHeight:155px; center:yes; status:no; help:no; edge:sunken;");
			}
			
			function hideProgress() {
			    try {
			        if (g_progresswin) {
			            g_progresswin.close();
			        }
			    } catch (e) { }
			}
			
			function lvtDetail_onSel_DBclick() {
			    var DocList = new ListView();
			    DocList.LoadFromID("SubDocList");
			    var selRow = DocList.GetSelectedRows();
			    var tr = selRow[0];
			
			    if (tr != null && typeof (selRow.length) != "undefined" && selRow.length > 0) {
			        if (jobState == "APPROVAL") {
			            if (tr.getAttribute("DATA5") == "Y") {
			                var heigth = window.screen.availHeight;
			                var width = window.screen.availWidth;
			                var left = (parseInt(width) - 525) / 2;
			                var top = (parseInt(heigth) - 220) / 2;
			                window.open("../ezDocInfo/ezLineInfo_Cross.aspx?pDocID=" + tr.getAttribute("DATA3") + "&pDeptID=" + escape(tr.getAttribute("DATA4")) + "&pDocState=012", "", "height=270px,width=600px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			            } else {
			                var heigth = window.screen.availHeight;
			                var width = window.screen.availWidth;
			                var left = (parseInt(width) - 420) / 2;
			                var top = (parseInt(heigth) - 450) / 2;
			                window.open("/ezCommon/showPersonInfo.do?id=" + tr.getAttribute("DATA4"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1, left=" + left + "px, top=" + top);
			            }
			        } else if (jobState == "RECIPENT") {
			            var heigth = window.screen.availHeight;
			            var width = window.screen.availWidth;
			            var left = (parseInt(width) - 540) / 2;
			            var top = (parseInt(heigth) - 220) / 2;
			            var isExtYN = tr.getAttribute("DATA3");
//TODO 외부부서일때 isExtYN ==Y
			            if (isExtYN.toUpperCase() == "Y") {
			                var url = "/myoffice/ezApprovalG/ezDocInfo/ezReceiptHistoryInfo_Cross.aspx?pDocID=" + DocID + "&pDeptID=" + escape(tr.getAttribute("DATA1"));
			                var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
			                feature = feature + GetShowModalPosition(555, 240);
			                var ret = window.showModalDialog(url, "", feature);
			            } else {
			                window.open("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + encodeURI(tr.getAttribute("DATA1")) + "&docState=011", "", "height=270px,width=600px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			            }
			        }
			    }
			}
			
			function selectCompanyID() {
			    if (pCompanyID != document.getElementById("SCompID").value) {
			        pCompanyID = document.getElementById("SCompID").value;
			        pChackYN = "FALSE";
			
			        GetDocList();
			    }
			}
			
			var ezStatisticsSearch_Cross_dialogArguments = new Array();
			function SearchCondi_onclick() {
			    var para;
			    
			    if (CrossYN()) {
			        ezStatisticsSearch_Cross_dialogArguments[0] = para;
			        ezStatisticsSearch_Cross_dialogArguments[1] = SearchCondi_onclick_Complete;
			
			        var ezStatisticsSearch_Cross = window.open("/admin/ezApprovalG/search.do?ingFlag=APR", "ezStatisticsSearch", GetOpenWindowfeature(500, 340));
			        try { ezStatisticsSearch_Cross.focus(); } catch (e) {
			        }
			    } else {
			        var url = "ezStatisticsSearch_Cross.aspx?INGFLAG=APR";
			        var feature = "dialogWidth:500px;dialogHeight:280px;status:no;scroll:no;edge:sunken";
			
			        var condition = window.showModalDialog(url, para, feature);
			        if (condition) {
			            pChackYN = "SEARCH";
			            
			            for (var i = 0; i < 20; i++) {
			                SearchCond[i] = condition[i];
			            }
			
			            pageNum = 1;
			            GetDocList();
			        }
			    }
			}
			
			function SearchCondi_onclick_Complete(condition) {
			    if (condition) {
			        pChackYN = "SEARCH";
			        
			        for (var i = 0; i < 20; i++) {
			            SearchCond[i] = condition[i];
			        }
			
			        pageNum = 1;
			        GetDocList();
			    }
			}
			
			window.onresize = function () {
			    var height = parseInt(divList.style.height.replace('px', '')) + 200;
			    var reheight = document.documentElement.clientHeight - parseInt(height);
			    document.getElementById('div_AprLine').style.height = reheight + "px";
			};
			
			function onkeydown_start_search() {
			    if (window.event.keyCode == "13") {
			        search();
			    }
			}
			
			function keyword_Clear() {
			    document.getElementById('txt_keyword').value = "";
			}
			
			function search() {
			    pChackYN = "SEARCH";
			    
			    if (document.getElementById("txt_keyword").value != "") {
			        var radiosearch = document.getElementsByName('searchCheck');
			
			        for (var i = 0; i < 20; i++) {
			            SearchCond[i] = "";
			        }
			
			        if (radiosearch.item(0).checked) {
			            SearchCond[1] = document.getElementById("txt_keyword").value;
			        } else if (radiosearch.item(1).checked) {
			            SearchCond[2] = document.getElementById("txt_keyword").value;
			        }
			    } else {
			        alert(strLang1106);
			        return;
			    }
			    
			    pageNum = 1;
			    GetDocList();
			}
		</script>
	</head>
	<body class = "mainbody">
		<xml id='FORMLIST' style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code = 'ezApprovalG.t1314' /></NAME>
						<WIDTH>300</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		
		<h1><spring:message code = 'ezApprovalG.t1315' /><span id="mailBoxInfo"></span>
	        <span style="float:right;font-weight:normal;color:black;">
	        	<input name="searchCheck" id="Radio1" type="radio" value="rad_Subject" checked style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code = 'ezApprovalG.t106' />
				<input name="searchCheck" id="Radio2" type="radio" value="rad_Writer" style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code = 'ezApprovalG.t445' />
				&nbsp;
				<input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	        	<a href="#"><img src="/images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search()"></a>
	        </span>
    	</h1>    

    	<div id="mainmenu">
        	<ul>
            	<b><spring:message code = 'ezApprovalG.t1276' /></b>
	            <SELECT id="SCompID" name="SCompID" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
		        </SELECT><br /><br />
            	<li id="SearchCondi"><span onclick="return SearchCondi_onclick()"><spring:message code = 'ezApprovalG.t111' /></span></li>
        	</ul>
    	</div>

    	<div class="div_scroll" style="width: 100%; HEIGHT: 300px; overflow: AUTO" id="divList">
        	<div id="lvtDoclist"></div>
    	</div>
    	<div id="tblPageRayer" style="margin-bottom: 10px;"></div>
    	<br />

    	<div id="tabnav" style="width: 100%">
        	<ul>
            	<li id="tagsub1"><span onclick="pDocInfoValue='1'; MM_swapImagesub('1', event);Approval_onclick()"><spring:message code = 'ezApprovalG.t1769' /></span></li>
            	<li id="tagsub2"><span onclick="pDocInfoValue='2'; MM_swapImagesub('2', event);Recipent_onclick()"><spring:message code = 'ezApprovalG.t950' /></span></li>
            	<li id="tagsub3"><span onclick="pDocInfoValue='4'; MM_swapImagesub('3', event);Attach_onclick()"><spring:message code = 'ezApprovalG.t56' /></span></li>
            	<li id="tagsub4"><span onclick="pDocInfoValue='3'; MM_swapImagesub('4', event);Opinion_onclick()"><spring:message code = 'ezApprovalG.t55' /></span></li>
        	</ul>
    	</div>

    	<div style="WIDTH:100%;HEIGHT:320px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
        	<div id="lvAprLine"></div>
    	</div>

    	<script type="text/javascript">
        	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
        	selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
    	</script>
	
	</body>
</html>