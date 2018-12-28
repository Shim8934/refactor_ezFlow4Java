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
		
		var searchType = "";
		var searchValue = "";
		
		var lastClickRow;
		
		$(document).ready(function() {
			compChange();
		});
		/* 회사선택 SelectBox Action */
		function compChange() {
			document.getElementById("jobTotalInfoRayer").innerHTML = "";
			
			if (Tab1_SelectID == "001") {
				JobTitle_List();
				JobTitle_UserList();
			} else if (Tab1_SelectID == "002") {
				JobPosition_List();				
				JobPosition_UserList();				
			}
		}
		/* 직위리스트 호출 Method */
		function JobTitle_List() {
			var xmldom;
			var companyID = $("#ListCompany option:selected").val();
			var type = Tab1_SelectID;
			
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezOrgan/jobTitleListView.do",
            	async : false,
            	data : 
            	{
            		type : type,
            		companyID : companyID
            	},
            	success : function (result) {
            		xmldom = loadXMLString(result);
            	},
            	error : function(e) {
            	}
            });
			
			var headerData = createXmlDom();
            headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
			
            var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
		    if (oRows.length > 0) {
	            var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
	            var Node = headerData.importNode(xmlRtn, true);
	            headerData.documentElement.appendChild(Node);
		    }
            
            document.getElementById("JobListView").innerHTML = "";
            
            var listview = new ListView();
            listview.SetID("lvJobTitleList");
            listview.SetMulSelectable(false);
            listview.SetRowOnClick("JobTitle_UserList");
            listview.SetSelectFlag(true);
            listview.SetRowOnDblClick("JobTitleView");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("JobListView");
		}
		/* 추가, 수정, 삭제 Button Action (mode=Add,Mod,Del) */
		var titleInfo_dialogArguments = new Array();
		function BtnAction(mode) {
			var companyID = $("#ListCompany option:selected").val();
			var companyNM = $("#ListCompany option:selected").text();
			var type = Tab1_SelectID;
			var jobID;
			
			var jobList = new ListView();
			
			if (type == "001") {
				jobList.LoadFromID("lvJobTitleList");
			} else if (type == "002") {
				jobList.LoadFromID("lvJobPositionList");
			}
			
			var oArrRows = jobList.GetSelectedRows();
			
			/* 수정, 삭제의 경우 선택된 Row가 있나 체크후 CN 추출 */
			if (mode == "Mod" || mode == "Del") {
				if (oArrRows == 0) {
					if (type == "001") {
						alert("<spring:message code = 'ezOrgan.csj07'/>");
					} else {
						alert("<spring:message code = 'ezOrgan.csj18'/>");
					}
					return;
				} else {
					jobID = oArrRows[0].getAttribute("DATA1");
				}
			}
			/* 추가, 수정의 경우 팝업창 호출 */
			if (mode == "Add" || mode == "Mod") {
				var url = "/admin/ezOrgan/jobTitlePopupUI.do?type=" + type + "&mode=" + mode + "&companyID=" + companyID;
				
				var args = new Array();
				args[0] = companyNM;
				args[1] = jobID;
				
				titleInfo_dialogArguments[0] = args;
			    titleInfo_dialogArguments[1] = titleInfo_Complete;
			    
			    var OpenWin = window.open(url, "jobTitlePopupUI", GetOpenWindowfeature(460, 290));
				try { OpenWin.focus(); } catch (e) { }
			/* 삭제의 경우 직위가 사용중인지 확인 후, 삭제처리 */
			} else if (mode == "Del") {
				if (!checkTitleUserCnt(jobID)) {
					if (type == "001") {
						alert("<spring:message code = 'ezOrgan.csj13'/>");
					} else if (type == "002") {
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
		            		jobID : jobID,
		            		type : type,
		            		companyID : companyID
		            	},
		            	success : function (result) {
		            		if (result == "TRUE") {
		            			alert("<spring:message code = 'ezBoard.t54'/>");
		            		} else {
			            		alert("<spring:message code = 'ezBoard.t55'/>");
		            		}
		            		
		            		if (type == "001") {
		    		        	JobTitle_List();
		    		        	JobTitle_UserList();
		    	        	} else {
		    		        	JobPosition_List();
		    		        	JobPosition_UserList();
		    	        	}
		            	},
		            	error : function(e) {
		            		alert("<spring:message code = 'ezBoard.t55'/>");
		            	}
		            });
				}
			}
		}
		/* 직위관리 팝업 return Complete Method */
		function titleInfo_Complete(rtnVal) {
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
	        	if (rtnVal[3] == "001") {
		        	JobTitle_List();
		        	JobTitle_UserList();
	        	} else {
		        	JobPosition_List();
		        	JobPosition_UserList();
	        	}
	        }
	    }
		/* 직위리스트 Row더블클릭 Action */
		function JobTitleView() {
			BtnAction('Mod');
		}
		/* 직위를 사용중인 유저리스트 호출 Method */
		function JobTitle_UserList() {
			var xmldom, xmlRtn, Node;
			var headerData = createXmlDom();
            headerData = loadXMLString(userlistviewheader.innerHTML.toUpperCase());
			
			var jobList = new ListView();
			jobList.LoadFromID("lvJobTitleList");
			var oArrRows = jobList.GetSelectedRows();
			if (oArrRows != 0) {
				var pJobID = oArrRows[0].getAttribute("DATA1");
				var pJobNM = oArrRows[0].firstChild.innerText;
				var pCompanyID = $("#ListCompany option:selected").val();
				
				if (lastClickRow != oArrRows[0]) {
					pCurPage = 1;
					searchValue = "";
					document.getElementById("searchValue").value = "";
				}
				
				$.ajax({
	            	type : "POST",
	            	dataType: "text",
	            	url : "/admin/ezOrgan/jobTitleUserListView.do",
	            	async : false,
	            	data : 
	            	{
	            		jobID : pJobID,
	            		type : Tab1_SelectID,
	            		companyID : pCompanyID,
	            		pageSize : pPageSize,
	            		pageNum : pCurPage,
	            		searchType : searchType,
	            		searchValue : searchValue
	            	},
	            	success : function (result) {
	            		xmldom = loadXMLString(result);
	            	},
	            	error : function(e) {
	            	}
	            });
				
				var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
			    if (oRows.length > 0) {
					xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
					$(xmlRtn.getElementsByTagName("ROW")).each(function(index){
		            	if($(this).find("DATA5").text() == "ADDJOB"){
		            		var orgPosition = $(this).find("CELL").eq(2).find("VALUE").text();
		            		$(this).find("CELL").eq(2).find("VALUE").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
		            	}
		            });
		            Node = headerData.importNode(xmlRtn, true);
		            headerData.documentElement.appendChild(Node);
		            
		            pTotalCnt = Number(SelectSingleNodeValueNew(xmldom, "LISTVIEWDATA/TOTALCOUNT"));
			    } else {
			    	pTotalCnt = 0;
			    }
			    
			    var _html = "<span>&nbsp;" + pJobNM + "-[" + "<span class='countColor'>" + pTotalCnt + "<spring:message code = 'main.t20000'/></span>]</span>";
			    document.getElementById("jobTotalInfoRayer").innerHTML = _html;
			    
			    lastClickRow = oArrRows[0];
			}
			
			document.getElementById("JobUserListView").innerHTML = "";
            
            var listview = new ListView();
            listview.SetID("lvJobTitleUserList");
            listview.SetMulSelectable(false);
            listview.SetSelectFlag(false);
            listview.SetRowOnDblClick("info_user");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("JobUserListView");
            
            makePageRayer();
		}
		/* 유저리스트 Row더블클릭 Action */
		function info_user() {
	        var listview = new ListView();
	        
	        if (Tab1_SelectID == "001") {
		        listview.LoadFromID("lvJobTitleUserList");
	        } else {
		        listview.LoadFromID("lvJobPositionUserList");
	        }
	        
	        var oArrRows = listview.GetSelectedRows();
	        if (oArrRows != 0) {
	        	if (oArrRows[0].getAttribute("DATA5") != "ADDJOB") {
					var args = new Array();
					args[0] = oArrRows[0].getAttribute("DATA1");
					args[1] = oArrRows[0].getAttribute("DATA2");
					args[2] = oArrRows[0].getAttribute("DATA4");
					args[3] = oArrRows[0].getAttribute("DATA3");
					args[4] = $("#ListCompany option:selected").val();
					
				    userinfo_dialogArguments = new Array();
				    userinfo_dialogArguments[0] = args;
				    userinfo_dialogArguments[1] = info_user_Complete;
				    var OpenWin = window.open("/admin/ezOrgan/userInfo.do", "UserInfo", GetOpenWindowfeature(830, 520));
				    try { OpenWin.focus(); } catch (e) { }
	        	} else {
	        		alert("<spring:message code='ezOrgan.psb02' />");
	        	}
	        }
		}
		/* 유저정보 팝업 return Complete Method */
		function info_user_Complete(rtnValue) {
	        if (typeof (rtnValue) != "undefined") {
	        	alert("<spring:message code='ezOrgan.t11' />");
	        }
	        if (Tab1_SelectID == "001") {
		        JobTitle_UserList();
	        } else if (Tab1_SelectID == "002") {
	        	JobPosition_UserList();
	        }
	    }
		/* 삭제 시, 직위를 사용중인 유저 유무를 체크하는 Method */
		function checkTitleUserCnt(jobID) {
			var rtnFlag = true;
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezOrgan/jobTitleUserListCnt.do",
            	async : false,
            	data : 
            	{
            		jobID : jobID,
            		type : Tab1_SelectID,
            		companyID : $("#ListCompany option:selected").val()
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
		
		/* 직책관리 리스트 호출 */
		function JobPosition_List() {
			var xmldom;
			var companyID = $("#ListCompany option:selected").val();
			var type = Tab1_SelectID;
			
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezOrgan/jobTitleListView.do",
            	async : false,
            	data : 
            	{
            		type : type,
            		companyID : companyID
            	},
            	success : function (result) {
            		xmldom = loadXMLString(result);
            	},
            	error : function(e) {
            	}
            });
			
			var headerData = createXmlDom();
            headerData = loadXMLString(listviewheader2.innerHTML.toUpperCase());
			
            var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
		    if (oRows.length > 0) {
	            var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
	            var Node = headerData.importNode(xmlRtn, true);
	            headerData.documentElement.appendChild(Node);
		    }
            
            document.getElementById("JobListView").innerHTML = "";
            
            var listview = new ListView();
            listview.SetID("lvJobPositionList");
            listview.SetMulSelectable(false);
            listview.SetRowOnClick("JobPosition_UserList");
            listview.SetSelectFlag(true);
            listview.SetRowOnDblClick("JobTitleView");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("JobListView");
		}
		
		/* 직책을 사용중인 유저리스트 호출 Method */
		function JobPosition_UserList() {
			var xmldom, xmlRtn, Node;
			var headerData = createXmlDom();
            headerData = loadXMLString(userlistviewheader2.innerHTML.toUpperCase());
			
			var jobList = new ListView();
			jobList.LoadFromID("lvJobPositionList");
			var oArrRows = jobList.GetSelectedRows();
			if (oArrRows != 0) {
				var pJobID = oArrRows[0].getAttribute("DATA1");
				var pJobNM = oArrRows[0].firstChild.innerText;
				var pCompanyID = $("#ListCompany option:selected").val();
				
				if (lastClickRow != oArrRows[0]) {
					pCurPage = 1;
					searchValue = "";
					document.getElementById("searchValue").value = "";
				}
				
				$.ajax({
	            	type : "POST",
	            	dataType: "text",
	            	url : "/admin/ezOrgan/jobTitleUserListView.do",
	            	async : false,
	            	data : 
	            	{
 	            		jobID : pJobID,
	            		type : Tab1_SelectID,
	            		companyID : pCompanyID,
	            		pageSize : pPageSize,
	            		pageNum : pCurPage,
	            		searchType : searchType,
	            		searchValue : searchValue
	            	},
	            	success : function (result) {
	            		xmldom = loadXMLString(result);
	            	},
	            	error : function(e) {
	            	}
	            });
				
				var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
			    if (oRows.length > 0) {
					xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		            Node = headerData.importNode(xmlRtn, true);
		            headerData.documentElement.appendChild(Node);
		            
		            pTotalCnt = Number(SelectSingleNodeValueNew(xmldom, "LISTVIEWDATA/TOTALCOUNT"));
			    } else {
			    	pTotalCnt = 0;
			    }
			    
			    var _html = "<span>&nbsp;" + pJobNM + "-[" + "<span class='countColor'>" + pTotalCnt + "<spring:message code = 'main.t20000'/></span>]</span>";
			    document.getElementById("jobTotalInfoRayer").innerHTML = _html;
			    
			    lastClickRow = oArrRows[0];
			}
			
			document.getElementById("JobUserListView").innerHTML = "";
            
            var listview = new ListView();
            listview.SetID("lvJobPositionUserList");
            listview.SetMulSelectable(false);
            listview.SetSelectFlag(false);
            listview.SetRowOnDblClick("info_user");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("JobUserListView");
            
            makePageRayer();
		}
		
		/* Tab관련 메소드들 ↓ */
		function ChangeTab(obj) {
			document.getElementById("JobListView").innerHTML = "";
			document.getElementById("JobUserListView").innerHTML = "";
			document.getElementById("jobTotalInfoRayer").innerHTML = "";
			
			pCurPage = 1;
			searchValue = "";
			document.getElementById("searchValue").value = "";
			
			if (obj.id == "001") {
				JobTitle_List();
				JobTitle_UserList();
			} else if (obj.id == "002") {
				JobPosition_List();
				JobPosition_UserList();
			}
		}
		
	    function Tab1_MouserOver(obj) {
	        obj.className = "tabover";
	    }
	    
	    function Tab1_MouserOut(obj) {
	        if (Tab1_SelectID != obj.id) {
	            obj.className = "";
	        }
	    }
	    
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
	    /* Tab관련 메소드들 ↑ */
	    
	    //2018-12-27 천성준 직함관리 유저리스트 페이징
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
	    	
	    	document.getElementById("JobUserListPageRayer").innerHTML = _html;
	    }
	    function goToPageNum(page) {
	    	pCurPage = page;
	    	
	    	if (Tab1_SelectID == "001") {
				JobTitle_UserList();
			} else {
				JobPosition_UserList();
			}
	    }
	    function goToNextBlock() {
	    	pCurPage = parseInt((pCurPage - 1) / pBlockSize ) * pBlockSize + pBlockSize + 1;
	    	
	    	if (Tab1_SelectID == "001") {
				JobTitle_UserList();
			} else {
				JobPosition_UserList();
			}
	    }
	    function goToPrevBlock() {
	    	pCurPage = parseInt((pCurPage - 1) / pBlockSize ) * pBlockSize - pBlockSize + 1;
	    	
	    	if (Tab1_SelectID == "001") {
				JobTitle_UserList();
			} else {
				JobPosition_UserList();
			}
	    }
	    function search() {
	    	searchType = document.getElementById("searchType").value;
	    	searchValue = document.getElementById("searchValue").value;
	    	
	    	if (Tab1_SelectID == "001") {
				JobTitle_UserList();
			} else {
				JobPosition_UserList();
			}
	    }
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
			<select id="ListCompany" onChange="compChange()">
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
					<div id="JobListView" style="height: 435px; width: 500px; overflow-y:auto;"></div>
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
				<div class="listview" style="border-bottom: 0px;">
					<div id="JobUserListView" style="height: 356px; width: 700px; overflow-y:auto;"></div>
				</div>
				<div id="JobUserListPageRayer" style="border: 1px solid #ddd; border-top: 0px;"></div>
			</td>
		</tr>
	</table>
	
<xml id="listviewheader" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
     		<%-- <HEADER>
       		<NAME><spring:message code='ezOrgan.csj03' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER> --%>
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
     		<%-- <HEADER>
       		<NAME><spring:message code='ezOrgan.csj16' /></NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER> --%>
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