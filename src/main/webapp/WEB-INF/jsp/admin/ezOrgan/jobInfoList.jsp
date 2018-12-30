<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">	    
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<style type="text/css">
		.countColor {
	    		color:#017BEC;
    	}
	</style>
	<script type="text/javascript">
		var Tab1_flag = true;
		var Tab1_SelectID = "";	//001:직위관리, 002:직책관리
		
		var pTotalPage = 0;
		var pTotalCnt = 0;
		var pPageSize = 10;
		var pBlockSize = 10;
		var pCurPage = 1;
		
		var pSearchType = "";
		var pSearchValue = "";
		
		var pLastClickRow;
		
		var pCompanyID = "${userInfo.companyID}";
		var pCompanyNM = "${userInfo.companyName}";
		
		$(document).ready(function() {
			companyChange();
		});
		
		/* 회사선택 이벤트 */
		function companyChange() {
			pCompanyID = $("#ListCompany option:selected").val();
			pCompanyNM = $("#ListCompany option:selected").text();
			
			$("#jobTotalInfoRayer").html("");
				
			job_list();
			job_userList();
		}
		
		/* (직위/직책) 리스트 호출 */
		function job_list() {
			var xmlDom, xmlRtn, Node;
			var headerData = createXmlDom();
			
			if (Tab1_SelectID == "001") {
				headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
			} else {
				headerData = loadXMLString(listviewheader2.innerHTML.toUpperCase());
			}
			
			$.ajax({
				type : "POST",
            	dataType: "text",
            	url : "/admin/ezOrgan/jobTitleListView.do",
            	async : false,
            	data : 
            	{
            		type 		: Tab1_SelectID,
            		companyID 	: pCompanyID
            	},
            	success : function (result) {
            		xmlDom = loadXMLString(result);
            	},
            	error : function(e) {
            	}
			});
			
            var oRows = SelectNodes(xmlDom, "LISTVIEWDATA/ROWS/ROW");
		    if (oRows.length > 0) {
	            xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
	            Node = headerData.importNode(xmlRtn, true);
	            headerData.documentElement.appendChild(Node);
		    }
            
            document.getElementById("jobListView").innerHTML = "";
            
            var listview = new ListView();
            listview.SetID("lvJobList");
            listview.SetMulSelectable(false);
            //listview.SetRowOnClick("job_userList");
            listview.SetRowOnClick("job_userList_click");
            listview.SetSelectFlag(true);
            listview.SetRowOnDblClick("job_view");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("jobListView");
		}
		
		function job_userList_click() {
			pCurPage = 1;
			pSearchValue = "";
			$("#searchValue").val("");
			job_userList();
		}
		
		/* (직위/직책) 사용중인 유저리스트 호출 */
		function job_userList() {
			var xmlDom, xmlRtn, Node;
			var headerData = createXmlDom();
			
			if (Tab1_SelectID == "001") {
				headerData = loadXMLString(userlistviewheader.innerHTML.toUpperCase());
			} else {
				headerData = loadXMLString(userlistviewheader2.innerHTML.toUpperCase());
			}
			
			var jobList = new ListView();
				jobList.LoadFromID("lvJobList");
				
			var oArrRows = jobList.GetSelectedRows();
			if (oArrRows != 0) {
				var pJobID = oArrRows[0].getAttribute("DATA1");
				var pJobNM = oArrRows[0].firstChild.innerText;
				
				if (pLastClickRow != oArrRows[0]) {
					pCurPage = 1;
					pSearchValue = "";
					$("#searchValue").val("");
				}
				
				$.ajax({
	            	type : "POST",
	            	dataType: "text",
	            	url : "/admin/ezOrgan/jobTitleUserListView.do",
	            	async : false,
	            	data : 
	            	{
	            		jobID 		: pJobID,
	            		type 		: Tab1_SelectID,
	            		companyID 	: pCompanyID,
	            		pageSize 	: pPageSize,
	            		pageNum 	: pCurPage,
	            		searchType 	: pSearchType,
	            		searchValue : pSearchValue
	            	},
	            	success : function (result) {
	            		xmlDom = loadXMLString(result);
	            	},
	            	error : function(e) {
	            	}
	            });
				
		    	pTotalCnt = Number(SelectSingleNodeValueNew(xmlDom, "LISTVIEWDATA/TOTALCOUNT"));
				
				var oRows = SelectNodes(xmlDom, "LISTVIEWDATA/ROWS/ROW");
			    if (oRows.length > 0) {
			    	xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
			    	$(xmlRtn.getElementsByTagName("ROW")).each(function(index) {
		            	if($(this).find("DATA5").text() == "addJob") {
		            		var orgPosition = $(this).find("CELL").eq(3).find("VALUE").text();
		            		$(this).find("CELL").eq(3).find("VALUE").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
		            	}
		            });
			    	
			    	Node = headerData.importNode(xmlRtn, true);
		            headerData.documentElement.appendChild(Node);
			    }
			    
			    var _html = "<span>&nbsp;" + pJobNM + "-[" + "<span class='countColor'>" + pTotalCnt + "<spring:message code = 'main.t20000'/></span>]</span>";
			    $("#jobTotalInfoRayer").html(_html);
			    
			    pLastClickRow = oArrRows[0];
			}
			
			document.getElementById("jobUserListView").innerHTML = "";
			
			var listview = new ListView();
            listview.SetID("lvJobUserList");
            listview.SetMulSelectable(false);
            listview.SetSelectFlag(false);
            listview.SetRowOnDblClick("info_user");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("jobUserListView");
            
            makePageRayer();
		}
		
		/* (직위/직책) Row 더블클릭 이벤트 */
		function job_view() {
			BtnAction('Mod');
		}
		
		/* (추가/수정/삭제) 버튼 이벤트 */
		var titleInfo_dialogArguments = new Array();
		function BtnAction(mode) {
			var pJobID;
			
			var jobList = new ListView();
				jobList.LoadFromID("lvJobList");
			
			if (mode == "Mod" || mode == "Del") {
				var oArrRows = jobList.GetSelectedRows();
				if (oArrRows == 0) {
					if (Tab1_SelectID == "001") {
						alert("<spring:message code = 'ezOrgan.csj07'/>");
					} else {
						alert("<spring:message code = 'ezOrgan.csj18'/>");
					}
					return;
				} else {
					pJobID = oArrRows[0].getAttribute("DATA1");
				}
			}
			
			if (mode == "Add" || mode == "Mod") {
				var url = "/admin/ezOrgan/jobTitlePopupUI.do?type=" + Tab1_SelectID + "&mode=" + mode + "&companyID=" + pCompanyID;
				
				var args = new Array();
				args[0] = pCompanyNM;
				args[1] = pJobID;
				
				titleInfo_dialogArguments[0] = args;
			    titleInfo_dialogArguments[1] = titleInfo_complete;
			    
			    var OpenWin = window.open(url, "jobPopupUI", GetOpenWindowfeature(460, 290));
				try { OpenWin.focus(); } catch (e) { }
				
			} else if (mode == "Del") {
				if (!checkTitleUserCnt(pJobID)) {
					if (Tab1_SelectID == "001") {
						alert("<spring:message code = 'ezOrgan.csj13'/>");
					} else {
						alert("<spring:message code = 'ezOrgan.csj22'/>");
					}
					return;
				}
				
				if (confirm("<spring:message code = 'ezOrgan.pjg01'/>")) {
					$.ajax({
		            	type : "POST",
		            	dataType: "text",
		            	url : "/admin/ezOrgan/jobTitleDelete.do",
		            	async : false,
		            	data : 
		            	{
		            		jobID 		: pJobID,
		            		type 		: Tab1_SelectID,
		            		companyID 	: pCompanyID
		            	},
		            	success : function (result) {
		            		if (result == "TRUE") {
		            			alert("<spring:message code = 'ezBoard.t54'/>");
		            		} else {
			            		alert("<spring:message code = 'ezBoard.t55'/>");
		            		}
		            		
		            		$("#jobTotalInfoRayer").html("");
		            		
		            		job_list();
		            		job_userList();
		            	},
		            	error : function(e) {
		            		alert("<spring:message code = 'ezBoard.t55'/>");
		            	}
		            });
				}
			}
		}
		
		/* (추가/수정) 팝업창 작업 완료 이벤트 */
		function titleInfo_complete(rtnVal) {
	        if (typeof (rtnVal) != "undefined") {
	        	if (rtnVal[0] == "TRUE") {
	        		if (rtnVal[1] == "Add") {
		        		alert("<spring:message code = 'ezBoard.t269'/>");
	        		} else {
		        		alert("<spring:message code = 'ezCommunity.t8'/>");
	        		}
	        	} else {
	        		alert("<spring:message code = 'main.sp12'/>");
	        	}
	        	
	        	job_list();
	        	job_userList();
	        }
	    }
		
		/* (직위/직책) 사용중인 유저Row 더블클릭 이벤트 */
		var userinfo_dialogArguments = new Array();
		function info_user() {
	        var listview = new ListView();
		        listview.LoadFromID("lvJobUserList");
	        
	        var oArrRows = listview.GetSelectedRows();
	        if (oArrRows != 0) {
				var args = new Array();
					args[0] = oArrRows[0].getAttribute("DATA1");
					args[1] = oArrRows[0].getAttribute("DATA2");
					args[2] = oArrRows[0].getAttribute("DATA4");
					args[3] = oArrRows[0].getAttribute("DATA3");
					args[4] = pCompanyID;
					args[5] = oArrRows[0].getAttribute("DATA5");
				
			    userinfo_dialogArguments[0] = args;
			    userinfo_dialogArguments[1] = info_user_complete;
			    
			    var OpenWin = window.open("/admin/ezOrgan/userInfo.do", "UserInfo", GetOpenWindowfeature(830, 520));
			    try { OpenWin.focus(); } catch (e) { }
	        }
		}
		
		/* 유저수정 팝업창 완료 이벤트 */
		function info_user_complete(rtnValue) {
	        if (typeof (rtnValue) != "undefined") {
	        	alert("<spring:message code='ezOrgan.t11' />");
	        }
	        
	        job_userList();
	    }
		
		/* (직위/직책) 삭제 시, 사용중인 유저가 있는지 체크로직 */
		function checkTitleUserCnt(jobID) {
			var rtnFlag = true;
			
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezOrgan/jobTitleUserListCnt.do",
            	async : false,
            	data : 
            	{
            		jobID 		: jobID,
            		type 		: Tab1_SelectID,
            		companyID 	: pCompanyID
            	},
            	success : function (result) {
            		if (parseInt(result) > 0) {
            			rtnFlag = false;
            		}
            	},
            	error : function(e) {
            	}
            });
			
			return rtnFlag;
		}
		
		/* (직위/직책) 탭 이동 관련 이벤트 1 [리스트 변경] */
		function ChangeTab(obj) {
			$("#jobTotalInfoRayer").html("");
			$("#searchValue").val("");
			
			pSearchValue = "";
			pCurPage = 1;
			
			job_list();
			job_userList();
		}
		/* (직위/직책) 탭 이동 관련 이벤트 2 [마우스오버] */
	    function Tab1_MouserOver(obj) {
	        obj.className = "tabover";
	    }
	    /* (직위/직책) 탭 이동 관련 이벤트 3 [마우스아웃] */
	    function Tab1_MouserOut(obj) {
	        if (Tab1_SelectID != obj.id) {
	            obj.className = "";
	        }
	    }
	    /* (직위/직책) 탭 이동 관련 이벤트 4 [마우스클릭] */
	    function Tab1_MouseClick(obj) {
	        obj.className = "tabon";
	        
	        if (obj.id != Tab1_SelectID) {
	            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null) {
	                document.getElementById(Tab1_SelectID).className = "";
	            }
	            
	            obj.className = "tabon";
	            Tab1_SelectID = obj.id;
	            ChangeTab(obj);
	        }
	    }
	    /* (직위/직책) 탭 이동 관련 이벤트 5 [탭 init이벤트] */
	    function Tab1_NewTabIni(pTabNodeID) {
	        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
	                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;
	
	                    if (Tab1_flag) {
	                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
	                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
	                        Tab1_flag = false;
	                    }
	                }
	            }
	        }
	    }
	    
	    /* 유저리스트 페이징 만드는 함수 */
	    function makePageRayer() {
	    	var _html = "<div class='pagenavi'>";
	    	
	    	var startPageNum = parseInt((pCurPage - 1) / pBlockSize ) * pBlockSize + 1;
	    	var endPageNum = parseInt((pCurPage - 1) / pBlockSize ) * pBlockSize + pBlockSize;
	    	
	    	if ((pTotalCnt % pPageSize) > 0) {
	    		pTotalPage = parseInt(pTotalCnt / pPageSize) + 1;
	    	} else {
	    		pTotalPage = parseInt(pTotalCnt / pPageSize);
	    	}
	    	
	    	if (endPageNum > pTotalPage) {
	    		endPageNum = pTotalPage;
	    	}
	    	
	    	if (pCurPage > 1) {
	    		_html += "<span class='btnimg' onclick='return goToPageNum(1)'><img src='/images/sub/btn_p_prev.gif'></span>";
	    	} else {
	    		_html += "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif'></span>";
	    	}
	    	
	    	if (parseInt((pCurPage - 1) / pBlockSize) > 0) {
	    		_html += "<span class='btnimg' onclick='return goToPrevBlock()'><img src='/images/sub/btn_prev.gif'></span>";
	    	} else {
	    		_html += "<span class='btnimg'><img src='/images/sub/btn_prev01.gif'></span>";
	    	}
	    	
	    	if (pTotalCnt > 0) {
		    	for (var i = startPageNum; i <= endPageNum; i++) {
		    		if (pCurPage == i) {
		    			_html += "<span class='on'>" + i + "</span>";
		    		} else {
			    		_html += "<span onclick='goToPageNum(" + i + ")'>" + i + "</span>";
		    		}
		    	}
	    	} else {
	    		_html += "<span class='on'>1</span>";
	    	}
	    	
	    	if (pTotalPage >= parseInt(((parseInt((pCurPage - 1) / pBlockSize) + 1) * pBlockSize) + 1)) {
	    		_html += "<span class='btnimg' onclick='return goToNextBlock()'><img src='/images/sub/btn_next.gif'></span>";
	    	} else {
	    		_html += "<span class='btnimg'><img src='/images/sub/btn_next01.gif'></span>";
	    	}
	    	
	    	if (pCurPage < pTotalPage) {
	    		_html += "<span class='btnimg' onclick='return goToPageNum(" + pTotalPage + ")'><img src='/images/sub/btn_n_next.gif'></span>";
	    	} else {
	    		_html += "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif'></span>";
	    	}
	    	
	    	_html += "</div>";
	    	
	    	$("#jobUserListPageRayer").html(_html);
	    }
	    
	    /* 페이징 숫자 버튼 클릭 이벤트 */
	    function goToPageNum(page) {
	    	pCurPage = page;
	    	job_userList();
	    }
	    
	    /* 페이징 다음블럭 이동 클릭 이벤트 */
	    function goToNextBlock() {
	    	pCurPage = parseInt((pCurPage - 1) / pBlockSize ) * pBlockSize + pBlockSize + 1;
	    	job_userList();
	    }
	    
	    /* 페이징 이전블럭 이동 클릭 이벤트 */
	    function goToPrevBlock() {
	    	pCurPage = parseInt((pCurPage - 1) / pBlockSize ) * pBlockSize - pBlockSize + 1;
	    	job_userList();
	    }
	    
	    /* 유저 검색 이벤트 */
	    function search() {
	    	pSearchType = $("#searchType").val();
	    	pSearchValue = $("#searchValue").val();
	    	
	    	pCurPage = 1;
	    	
	    	job_userList();
	    }
	    
	    /* 검색input 클릭 시, input창 비우기 이벤트 */
	    function keyword_Clear(obj) {
		    obj.value = "";
		}
	</script>
</head>
<body class="mainbody">
	<h1><spring:message code='ezOrgan.csj01' /></h1>
	<div id="mainmenu">
		<span>
			<b><spring:message code = 'ezApprovalG.t1512' /></b> 
			<select id="ListCompany" onChange="companyChange()">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
			<br/><br/>
		</span>
		<ul>
			<li><span onClick="BtnAction('Add')"><spring:message code = 'ezAddress.t173'/></span></li>
			<li><span onClick="BtnAction('Mod')"><spring:message code = 'ezAddress.t174'/></span></li>
			<li><span onClick="BtnAction('Del')"><spring:message code = 'ezAddress.t175'/></span></li>
		</ul>
	</div>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
	</script>
	<div class="portlet_tabpart01" style="width: 1210px;">
		<div class="portlet_tabpart01_top" id="tab1">
			<p><span id="001"><spring:message code='ezOrgan.csj02' /></span></p>
			<p><span id="002"><spring:message code='ezOrgan.csj15' /></span></p>
	    </div>
	</div>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
	<table style="margin-top: 5px;">
		<tr>
			<td>
				<div class="listview">
					<div id="jobListView" style="height: 435px; width: 500px; overflow-y:auto;"></div>
				</div>
			</td>
			<td>
				<div style="width: 5px;"></div>
			</td>
			<td>
				<div style="border: 1px solid #e8e8e8; border-bottom: 0px; height: 30px;">
					<div id="jobTotalInfoRayer" style="line-height: 30px; display: inline-block;"></div>
					<div id="userSearchRayer" style="float:right; display: inline-block; margin-right: 2px;">
						<select id="searchType" style="height: 26px; width: 50px;"><option value="displayname"><spring:message code='main.t76' /></option></select>
						<input id="searchValue" onkeypress="if(event.keyCode==13) {search(); return false;}" onfocus="keyword_Clear(this);" style="height: 26px; border: 1px solid #cbcbcb; border-right:0px; margin-top:2px;">
						<a style="float:right; cursor: pointer;"><img src="/images/bsearch_new.gif" style="width: 26px; height: 26px; margin-top:2px;" border="0" onClick="search()"></a>
					</div>
				</div>
				<div class="listview" style="width: 700px; border-bottom: 0px;">
					<div id="jobUserListView" style="height: 356px; width: 100%; overflow-y:auto;"></div>
				</div>
				<div id="jobUserListPageRayer" style="border: 1px solid #ddd; border-top: 0px;"></div>
			</td>
		</tr>
	</table>
	
<xml id="listviewheader" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj04' />(<spring:message code='ezApprovalG.t1764'/>)</NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj04' />(<spring:message code='ezApprovalG.t1765'/>)</NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj05' /></NAME>
			<WIDTH>50</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj06' /></NAME>
			<WIDTH>50</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
<xml id="userlistviewheader" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
     		<HEADER>
       		<NAME><spring:message code='ezOrgan.t218' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t67' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t68' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t69' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t285' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
<xml id="listviewheader2" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj17' />(<spring:message code='ezApprovalG.t1764'/>)</NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj17' />(<spring:message code='ezApprovalG.t1765'/>)</NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj05' /></NAME>
			<WIDTH>50</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj06' /></NAME>
			<WIDTH>50</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
<xml id="userlistviewheader2" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
     		<HEADER>
       		<NAME><spring:message code='ezOrgan.t218' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t67' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t68' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t1500' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t285' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
</body>
</html>