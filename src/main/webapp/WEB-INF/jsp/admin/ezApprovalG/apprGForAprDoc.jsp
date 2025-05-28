<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1310' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" type="text/css"/>
		<style>
			#div_AprLine .mainlist tr th {
				border-top:0px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/FormMain_Cross.js')}"></script>
		<script type="text/javascript">
			var labelcolor = "gray";
	        var OrderCell = "";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var DocID, pURL
	        var jobState = "APPROVAL";
	        var pChackYN = "FALSE";
	        var g_tagSelectsub = "1";
	        var pageSize = 10, Block_Size, pTotalCnt = "";
	        var curpage, totalPage, block, p_page, NodeListLen;
	        var pageNum = "1";
	        var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
	        var approvalFlag = "<c:out value = '${approvalFlag}' />";
	        var SearchCond = new Array();
	        var type = "<c:out value ='${type}' />";
	        var useEditApprDoc = "<c:out value='${useEditApprDoc}'/>";
	        var nowDate = "<c:out value = '${nowDateUTC}'/>";
			var pOpenYear = "<c:out value = '${openYear}'/>";
			var useWebHWP = "<c:out value ='${useWebHWP}'/>";
			var selectYear = "ALL";
			var useReceiveInfoName = "<c:out value ='${useReceiveInfoName}'/>"; // 수신처 뒤에 "장"을 붙이는지 여부 (0 : 안붙임 / 1 : 붙임 / 2: 상위부서 + 수신처장)       
			
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
	            //document.getElementById('div_AprLine').style.height = reheight + "px";
	            
	            if (type == 'admin') {
	            	document.getElementById("SCompID").value = pCompanyID;
	            }
	            
	            var toDayYear = parseInt(nowDate.substring(0,4));
	            var minusYear = parseInt(nowDate.substring(0,4)) - parseInt(pOpenYear);
	            for (var i = toDayYear; i >= toDayYear - minusYear ; i--)
	                AddOption(sel_year, i, i);
	            
	            pChackYN = "INIT";
	            
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
	            
	            /* 2021-03-24 홍승비 - 제목 클릭 시 원클릭 이벤트로 전자결재 읽기, 결재 팝업창을 표출 */
	            var headerNameTD = $(event.target).attr("headerName");
	            if (headerNameTD != null && typeof(headerNameTD) != "undefined" && headerNameTD == "DOCTITLE") {
	            	lvtDoclist_onSel_DBclick();
	            }
	        }
	        
	        function GetDocList() {
	            var pDocstate = "000";
	            if (pChackYN == "FALSE") {
	                for (var i = 0; i < 20; i++) {
	                    SearchCond[i] = "";
	                }
	            } else if (pChackYN == "SEARCH") {
	           
	            } else if (pChackYN == "INIT") {
	            	for (var i = 0; i < 20; i++) {
	                    SearchCond[i] = "";
	                }
	            	
	            	var nowyear = nowDate.substring(0,4);
			        var nowmonth = nowDate.substring(5,7);
			        var nowday = nowDate.substring(8,10);
			        
					SearchCond[3] = nowyear-1;
	            	SearchCond[4] = nowmonth;
	            	SearchCond[5] = nowday;
	            	SearchCond[6] = nowyear
	            	SearchCond[7] = nowmonth;
	                SearchCond[8] = nowday;
	            	
	            	pChackYN == "FALSE";
	            }
	            
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezApprovalG/getStatSearchAprDocList.do",
	            	async : true,
	            	dataType : "text",
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
						formName : SearchCond[16],
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
	
	                listNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
	                cntNode = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");
	                if (listNode == null) {
	                	return;
	                }
	
	                var lstCnt = getNodeText(cntNode);
	                if (lstCnt == "") {
	                	lstCnt = 0;
	                }
	                totalPage = Math.ceil(new Number(lstCnt / pageSize));
	                
	                pTotalCnt = lstCnt;
	                makePageSelPage();
	
	                var xmlDoc;
	                xmlDoc = createXmlDom();
	                xmlDoc.appendChild(listNode);
	                
	                if (document.getElementById("lvtDoclist").innerHTML != "") {
	                    document.getElementById("lvtDoclist").innerHTML = "";
	                }
	                
	                /* if (CrossYN()) {
	                    var xmlLIST = createXmlDom();
	                    var nodeToImport = xmlLIST.importNode(ListViewNode, true);
	                    xmlLIST.appendChild(nodeToImport);
	                    xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
	                } else {
	                    xmlDoc = createXmlDom();
	                    xmlDoc.appendChild(ListViewNode);
	                }
	
	                ListViewNode = xmlDoc; */
	                
	                var DocList = new ListView();
	                DocList.SetID("DocList");
	                DocList.SetMulSelectable(false);
	                DocList.SetRowOnClick("lvtDoclist_SelChange");
	                DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");
	                DocList.SetUrgentFlag(true);
	                DocList.SetSecurityFlag(false);
	                DocList.DataSource(xmlDoc);
	                DocList.DataBind("lvtDoclist");
	                DocList = null;
	            }
	            catch (e) {
	            }
	            selFirstRow2();
	        }
	        
	        function selFirstRow2() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var tr = oArrRows[0];

	            if (oArrRows.length != 0) {
	                DocID = GetAttribute(tr, "DATA1");
	                pURL = GetAttribute(tr, "DATA2");
	            } else {
	                DocID = "";
	                pURL = "";
	            }

	            getDataInfo();
	        }
	
	        function DisplayLineCnt(NodeListLen) {
	        	setNodeText(listcount , "<spring:message code = 'ezApprovalG.t1312' />" + NodeListLen + "<spring:message code = 'ezApprovalG.t1313' />");
	        }

	        //미사용
	        /* function paging(p_page, p_nowblock) {
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
	
	            $("#td_pTotalCount").html(totalPages);
	            $("#txt_PageInputNum").val(curpage);
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
	                    var goPage = $("#txt_PageInputNum").val();
	                    
	                    if (parseInt(goPage) != goPage || parseInt(goPage) == "" || parseInt(goPage) < 1 || parseInt(goPage) > parseInt(totalPages)) {
	                        return;
	                    }
	                    
	                    curpage = parseInt(goPage);
	                    pChackYN = "TRUE";
	                    GetDocList();
	                }
	            }
	        } */
	
	        var BlockSize = 10;
	        function td_Create1(strtext) {
	            $("#tblPageRayer").html(strtext);
	        }
	        
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + pTotalCnt + "</span>";
	            strtext = "<div class='pagenavi'>";
	            PagingHTML += strtext;
	            
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
	                DocID = GetAttribute(tr, "DATA1");
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
	            	dataType : "text",
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
	                    openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=&pageType=admin";
	                } else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") { //한글양식 읽기
		                if (useWebHWP == "NO") {
	                		if (isIE()) {
			                    var openLocation = "/ezApprovalG/ezviewAprHWP.do?docID=" + escape(DocID) + "&docHref=" + escape(pURL);
			                    openLocation = openLocation + "&opinionFlag=&docState=&listSusin=&oDoc=&isOpinion=&listType=&pageType=admin";
		                    } else {
		                    	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
		                    	alert(pAlertContent);
		                        
		                        return;
		                    }
		                } else {
		                	var isGroupDoc = checkIsGroupDoc(encodeURI(DocID), ""); // 현재 소속한 회사의 문서가 보이므로, companyID 전달 없어도 됨
		                	var openLocation = "";
		            		
		            		if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우 (결재진행문서, 기안한문서 메뉴에서 접근 시 지원)
		            			openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do?docID=" + escape(DocID) + "&docHref=" + escape(pURL);
		            		} else {
		            			openLocation = "/ezApprovalG/ezviewAprWHWP.do?docID=" + escape(DocID) + "&docHref=" + escape(pURL);
		            		}
		            		
		                    openLocation = openLocation + "&opinionFlag=&docState=&listSusin=&oDoc=&isOpinion=&listType=&pageType=admin";
		                }
	                } else {
                        var isGroupDoc = checkIsGroupDoc(encodeURI(DocID), ""); // 현재 소속한 회사의 문서가 보이므로, companyID 전달 없어도 됨
                        var openLocation = "";

                        if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우 (결재진행문서, 기안한문서 메뉴에서 접근 시 지원)
                            openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do?docID=" + escape(DocID) + "&docHref=" + escape(pURL);
                        } else {
                            var openLocation = "/ezApprovalG/aprDocView.do?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL);
                        }
                        openLocation = openLocation + "&opinionFlag=&docState=&listSusin=&oDoc=&isOpinion=&listType=&pageType=admin";
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
		                if (CrossYN())
		                    heigth = parseInt(heigth) - 25;

		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		                    heigth = parseInt(heigth) - 40;
		                width = parseInt(width) - pleftpos;
		                left = pleftpos / 2;
		            }
		            else {
		                heigth = parseInt(heigth) - 30;
		                if (CrossYN())
		                    heigth = parseInt(heigth) - 25;

		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		                    heigth = parseInt(heigth) - 40;
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
			        	if (GetAttribute(tr, "DATA5") == "Y") {
			        		var heigth = window.screen.availHeight;
			                var width = window.screen.availWidth;
			                var left = (parseInt(width) - 1155) / 2;
			                var top = (parseInt(heigth) - 460) / 2;
			                window.open("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + encodeURI(GetAttribute(tr, "DATA1")) + "&docState=012", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			            } else {
			            	var heigth = window.screen.availHeight;
			                var width = window.screen.availWidth;
			                var left = (parseInt(width) - 420) / 2;
			                var top = (parseInt(heigth) - 450) / 2;
			                window.open("/ezCommon/showPersonInfo.do?id=" + GetAttribute(tr, "DATA4"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1, left=" + left + "px, top=" + top);
			            }
			        } else if (jobState == "RECIPENT") {
			            var heigth = window.screen.availHeight;
			            var width = window.screen.availWidth;
			            var left = (parseInt(width) - 540) / 2;
			            var top = (parseInt(heigth) - 220) / 2;
			            var isExtYN = GetAttribute(tr, "DATA3");  //TODO 외부부서일때 isExtYN ==Y

			            if (isExtYN.toUpperCase() == "Y") {
			            	var url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + DocID + "&deptID=" + encodeURIComponent(GetAttribute(tr, "DATA1"));
			                var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
			                feature = feature + GetShowModalPosition(555, 240);
			                var ret = window.showModalDialog(url, "", feature);
			            } else {
			            	left = (parseInt(width) - 1155) / 2;
					        top = (parseInt(heigth) - 460) / 2;
			                window.open("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + encodeURI(GetAttribute(tr, "DATA1")) + "&docState=011", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
			            }
			        } else if (jobState == "ATTACH") {
			    		var AttachfilenameA1 = tr.cells[1].innerHTML;
                        if (AttachfilenameA1 != null) {
                            var AttachfilenameN1 = AttachfilenameA1.lastIndexOf(".");
                            var AttachfilenameA2 = AttachfilenameA1.substr(AttachfilenameN1, AttachfilenameA1.length);
                            var AttachUrlA1 = GetAttribute(tr,"DATA1");
                            var AttachUrlN1 = AttachUrlA1.lastIndexOf(".");
                            var AttachUrlA2 = AttachUrlA1.substr(AttachUrlN1, AttachUrlA1.length);
                            AttachUrl = encodeURIComponent(GetAttribute(tr,"DATA1"));
                            
                            if (AttachfilenameN1 < 0) {
                                Attachfilename = encodeURIComponent(tr.cells[1].innerText + AttachUrlA2);
                            } else {
                                Attachfilename = encodeURIComponent(tr.cells[1].innerText);
                            }

                            if (AttachUrl != "null") {
                                var tempINGFlag = "";
                                /* if (GetAttribute(tr,"data4") == "file") {
                                    window.open(document.location.protocol + "//" + document.location.hostname + "/approvalG/downloadAttach.do?type=APPROVAL&docID=" + GetAttribute(tr, "data3") + "&docStatus=" + tempINGFlag + "&docAttachSn=" + GetAttribute(tr,"data2"));
                                } else {
                                    window.open("/ezApprovalG/downloadAttach.do?fileName=" + Attachfilename + "&filePath=" + AttachUrl, "_self");
                                } */
                                
                              	//2018-09-12 천성준 - 전자결재 결재문서리스트 하단 첨부탭에서 첨부파일이 문서첨부일경우 문서보기로 열수있게
								try {
									if (GetAttribute(tr,"data4") == strLangCSJ01 || GetAttribute(tr,"data4") == "Document") {
	                                	var tempStr = AttachUrlA1.split("/");
	                                    var docID = tempStr[tempStr.length - 1].replace(AttachUrlA2, '');
	                                    var openLocation;
	                                    
	                                    if (AttachUrlA2 == ".hwp" || AttachUrlA2 == ".ezd") {
	                                    	if(useWebHWP == "NO") {
		                                    	if (isIE()) {
		                                    		openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
		                                    	} else {
		                                    		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
		                		                	alert(pAlertContent);
		                		                	return;
		                                    	}
	                                    	} else {
	                                    		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
	                                    	}
	                                    } else {
	                                    	openLocation = "/ezApprovalG/contDocView.do";
	                                    }
	                                    openLocation += "?docID=" + docID + "&docHref=" + AttachUrl + "&formID=&orgDocID=";
	                                    openwindow(openLocation, "", 880, 570);
									} else {
	                                    window.open("/ezApprovalG/downloadAttach.do?fileName=" + Attachfilename + "&filePath=" + AttachUrl, "_self");
	                                }
								} catch(e) {
									console.log(e);
								}
                            }
                        }
			    	}
			    }
			}
			
			function selectCompanyID() {
			    if (pCompanyID != document.getElementById("ListCompany").value) {
			        pCompanyID = document.getElementById("ListCompany").value;
			        pChackYN = "FALSE";
			        pageNum = "1"; // 회사 선택 시 페이징 초기화
			        
			        GetDocList();
			    }
			}
			
			var ezStatisticsSearch_Cross_dialogArguments = new Array();
			function SearchCondi_onclick() {
			    var para;
			    
			    $('#sel_year').val("ALL");
			    
			    if (CrossYN()) {
			        ezStatisticsSearch_Cross_dialogArguments[0] = para;
			        ezStatisticsSearch_Cross_dialogArguments[1] = SearchCondi_onclick_Complete;
					
			        var ezStatisticsSearch_Cross;
			        
			        if (approvalFlag == "S") {
				        ezStatisticsSearch_Cross = window.open("/admin/ezApprovalG/search.do?ingFlag=APR", "ezStatisticsSearch", GetOpenWindowfeature(510, 314));
			        } else {
				        ezStatisticsSearch_Cross = window.open("/admin/ezApprovalG/search.do?ingFlag=APR", "ezStatisticsSearch", GetOpenWindowfeature(510, 404));
			        }

			        try { ezStatisticsSearch_Cross.focus(); } catch (e) {
			        }
			    } else {
			        var url = "/admin/ezApprovalG/search.do?ingFlag=APR";
			        var feature = "";
			        
			        if (approvalFlag == "S") {
			        	feature = "dialogWidth:500px;dialogHeight:314px;status:no;scroll:no;edge:sunken";
			        } else {
			        	feature = "dialogWidth:500px;dialogHeight:334px;status:no;scroll:no;edge:sunken";
			        }
			
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
			    //document.getElementById('div_AprLine').style.height = reheight + "px";
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
			        var selectSearch = document.getElementById('selectType');

					/*
			        for (var i = 0; i < 20; i++) {
			            SearchCond[i] = "";
			        } */
			
			        if (selectSearch.item(0).selected) {
			            SearchCond[1] = document.getElementById("txt_keyword").value;
			        } else if (selectSearch.item(1).selected) {
			            SearchCond[2] = document.getElementById("txt_keyword").value;
			        } else if (selectSearch.item(2).selected) {
			        	SearchCond[17] = document.getElementById("txt_keyword").value;
			        } //2019.12.30 김정언 - 기안부서 검색 추가
			        
			    } else {
			        alert(strLang1106);
			        return;
			    }
			    
			    pageNum = 1;
			    GetDocList();
			    
			    $('#sel_year').val(selectYear);
			}
			
			var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
	
		    function Tab1_MouserOut(obj) {
		        if(Tab1_SelectID != obj.id)
		            obj.className = "";
		    }
	
		    function Tab1_MouseClick(obj) {		    	
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
	
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    
		    function ChangeTab(obj) {
		        var pSelectTab = obj.id;

		        switch (pSelectTab) {
		            case "tagsub1": pDocInfoValue='1';Approval_onclick(); break;
		            case "tagsub2": pDocInfoValue='2';Recipent_onclick(); break;
		            case "tagsub3": pDocInfoValue='4';Attach_onclick(); break;
		            case "tagsub4": pDocInfoValue='3';Opinion_onclick(); break;
		            case "tagsub5": pDocInfoValue='5';Circulation_onclick(); break;
		        }
		    }
		    
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };

		                    if (i == 1) {
		                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).id;
		                    }	
		                }
		            }
		        }
		    }
		    // 관리자 문서편집 기능 추가
		    function modifyDocumnet() {
				var url = "/admin/ezApprovalG/modifyAprDoc.do";
				var selList = new ListView();
				selList.LoadFromID("DocList");
				var oArrRows = selList.GetSelectedRows();
				
				if (oArrRows.length != 0) {
					var tr = oArrRows[0];
					
					docID = tr.getAttribute("DATA1");
					pURL = tr.getAttribute("DATA3");
				
					var param = "?docID=" + docID + "&url=" + encodeURIComponent(pURL) + "&companyID=" + pCompanyID;
					GetOpenWindow(url + param, "", 825, 850, "no");
				} else {
					var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
					alert(pAlertContent);
				}
		    }
		    
		    function onSelect_Year() {
	            pChackYN = "SEARCH";
	            pageNum = 1;
				selectYear = GetSelectVal("sel_year");
	            
	            if (selectYear != "ALL") {
	            	SearchCond[3] = selectYear;
	            	SearchCond[4] = "01";
	            	SearchCond[5] = "01";
	            	SearchCond[6] = selectYear;
	            	SearchCond[7] = "12";
	                SearchCond[8] = "31";
	            }
	            else {
	            	var nowyear = nowDate.substring(0,4);
			        var nowmonth = nowDate.substring(5,7);
			        var nowday = nowDate.substring(8,10);
	            	SearchCond[3] = nowyear-1;
	            	SearchCond[4] = nowmonth;
	            	SearchCond[5] = nowday;
	            	SearchCond[6] = nowyear
	            	SearchCond[7] = nowmonth;
	                SearchCond[8] = nowday;
                }
	            
	            GetDocList();
	        }
		    
		    /* 2022-01-27 홍승비 - 일괄기안된 문서인지 판별하는 ajax 함수 (Y/N) */
		    function checkIsGroupDoc(pDocID, pOrgCompanyID) {
		        var res = "";
		        
		        $.ajax({
		            type : "GET",
		            dataType : "text",
		            async : false,
		            url : "/ezApprovalG/checkIsGroupDoc.do",
		            data : {
		                docID : pDocID,
		                orgCompanyID : pOrgCompanyID
		            },
		            success: function(result) {
		                res = result;
		            }        			
		        });
		        
		        return res;
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
		<h1>
			<spring:message code = 'ezApprovalG.t1315' /><span id="mailBoxInfo"></span>
	        <span class="searchForm">
	        	<select id="selectType" class="text"; style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezApprovalG.t106'/></option>
		    		<option value="rad_Writer"><spring:message code='ezApprovalG.t445'/></option>
		    		<option value="rad_Department"><spring:message code='ezApproval.t437'/></option>
		    	</select>
				<input id="txt_keyword" class="searchinputBox searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	        	<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search()"></a>
	        </span>
    	</h1>
    	<div id="mainmenu">
    		<c:if test="${type == 'admin' }">
    			<input type="hidden" id="SCompID" value="${userInfo.companyID }" >
			</c:if>
        	<ul>
        		<c:if test="${not empty list}">
				    <li>
                        <select id="ListCompany" onChange="selectCompanyID()">
                            <c:forEach var="item" items="${list}">
                                <option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
                            </c:forEach>
                        </select>
        		    </li>
        		</c:if>
            	<li id="SearchCondi"><span class="icon16 icon16_search" onclick="return SearchCondi_onclick()"></span></li>
            	<c:if test="${useEditApprDoc == 'YES' }">
            		<li id="modifyButton"><span onclick="return modifyDocumnet()"><spring:message code= 'ezApprovalG.t44' /></span></li>
            	</c:if>
            	<!-- 전체 문서 조회 년도별 select box 추가 -->
	      	 	<li style="vertical-align: middle; float:right">
	            	<select id="sel_year" name="sel_year" style="height:29px;" onchange="onSelect_Year(this);">
		            	<option value="ALL"><spring:message code ='ezApprovalG.kmsg01'/></option>
		        	</select>
		        </li>
        	</ul>
    	</div>
    	<div class="div_scroll" style="width: 100%; HEIGHT: 375px; overflow: AUTO" id="divList">
        	<div id="lvtDoclist"></div>
    	</div>
    	<div id="tblPageRayer"></div>    	

    	<%-- <div id="tabnav" style="width: 100%">
        	<ul>
            	<li id="tagsub1"><span onclick="pDocInfoValue='1'; MM_swapImagesub('1', event);Approval_onclick()"><spring:message code = 'ezApprovalG.t1769' /></span></li>
            	<li id="tagsub2">
            		<span onclick="pDocInfoValue='2'; MM_swapImagesub('2', event);Recipent_onclick()">
            			<c:choose>
            				<c:when test="${approvalFlag == 'S' }">
            					<spring:message code = 'ezApprovalG.t999932' />
            				</c:when>
            				<c:otherwise>
            					<spring:message code = 'ezApprovalG.t950' />
            				</c:otherwise>
            			</c:choose>
            		</span>
            	</li>
            	<li id="tagsub3"><span onclick="pDocInfoValue='4'; MM_swapImagesub('3', event);Attach_onclick()"><spring:message code = 'ezApprovalG.t56' /></span></li>
            	<li id="tagsub4"><span onclick="pDocInfoValue='3'; MM_swapImagesub('4', event);Opinion_onclick()"><spring:message code = 'ezApprovalG.t55' /></span></li>
        	</ul>
    	</div> --%>
    	
    	<div id="tabnav" class="portlet_tabpart01" style="width:100%">
			<div class="portlet_tabpart01_top" id="tab1">
			    <p><span id="tagsub1"><spring:message code='ezApprovalG.t1769'/></span></p>
			    <c:if test="${approvalFlag == 'S'}">
			    	<%-- <p><span id="tagsub2"><spring:message code = 'ezApprovalG.t999932' /></span></p> --%>
			    	<p><span id="tagsub2"><spring:message code = 'ezApprovalG.t950' /></span></p>
			    </c:if>
			    <c:if test="${approvalFlag != 'S'}">
			    	<p><span id="tagsub2"><spring:message code = 'ezApprovalG.t950' /></span></p>
			    </c:if>			    
			    <p><span id="tagsub3"><spring:message code='ezApprovalG.t56'/></span></p>
			    <p><span id="tagsub4"><spring:message code='ezApprovalG.t55'/></span></p>
			    <%-- <c:if test="${approvalFlag != 'G'}">
				   	<p><span id="tagsub5"><spring:message code='ezApprovalG.hyj24'/></span></p>
			    </c:if> --%>
		  	</div>	
		</div>

    	<div style="WIDTH:100%;HEIGHT:204px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
        	<div id="lvAprLine"></div>
    	</div>

    	<script type="text/javascript">
        	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
        	//selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
        	Tab1_NewTabIni("tab1");
    	</script>
	</body>
</html>
