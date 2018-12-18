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
	<style>
		.mainview {margin-top: 5px; width:50%; float:left;}
		.previewH {margin-top: 5px; width:50%; height: 690px; float:right; overflow: hidden;}
		.previewmail_info {border-bottom: 1px solid #e5e5e5;}
		.previewmail_bar_h {display: inline-block; width: 5px; height: 690px;}
		.preContent_RayerH {position: absolute; display: inline-block; width: 49%;}
		.preview_header {margin: 0px 0px 5px 0px; padding: 10px 0px 0px 0px; font-weight: bold; height: 36px; line-height: 37px;}
		.preview_title {display: inline-block; margin-top: -6px; margin-left: 13px;}
		.preview_count {display: inline-block; margin-top: -6px; color: #017BEC;}
		.preview_content {width: 97%; height: 630px; border: solid 0px green; display: inline-block; padding:10px;}
		.preview_nodata {position: absolute; display: inline-block; width: 49%; vertical-align: middle; text-align: center; margin-top: 70px;}
	</style>
	<script type="text/javascript">
		var Tab1_flag = true;
		var Tab1_SelectID = "";	//001:직위관리, 002:직책관리
		var totalCount;
		var totalPage = "";
		var blockSize = 10;
		var pageNum = 1;
		var pageSize = 15;
		
		$(document).ready(function() {
			compChange();
		});
		/* 회사선택 SelectBox Action */
		function compChange() {
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
            		companyID : companyID,
            		page: pageNum
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
            listview.SetSelectFlag(false);
            listview.SetRowOnDblClick("JobTitleView");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("JobListView");
			
			totalCount = parseInt(SelectSingleNodeValueNew(xmldom, "TOTALCNT"));
			pageNum = parseInt(SelectSingleNodeValueNew(xmldom, "CURPAGE"));
			totalPage = Math.ceil(new Number(totalCount / pageSize));
			
			makePageSelPage();
		}
		/* 추가, 수정, 삭제 Button Action (mode=Add,Mod,Del) */
		var titleInfo_dialogArguments = new Array();
		function BtnAction(mode) {
			var companyID = $("#ListCompany option:selected").val();
			var companyNM = $("#ListCompany option:selected").text();
			var type = Tab1_SelectID;
// 			var cn;
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
// 					cn = oArrRows[0].getAttribute("DATA1");
					jobID = oArrRows[0].getAttribute("DATA1");
				}
			}
			/* 추가, 수정의 경우 팝업창 호출 */
			if (mode == "Add" || mode == "Mod") {
				var url = "/admin/ezOrgan/jobTitlePopupUI.do?type=" + type + "&mode=" + mode + "&companyID=" + companyID;
				/* 수정의 경우 CN 추가 GET 파라미터 전송 */
// 				if (mode == "Mod") {
// 					url += "&cn=" + encodeURIComponent(cn);
// 				}
				
				var args = new Array();
				args[0] = companyNM;
// 				args[1] = cn;
				args[1] = jobID;
				
				titleInfo_dialogArguments[0] = args;
			    titleInfo_dialogArguments[1] = titleInfo_Complete;
			    
			    var OpenWin = window.open(url, "jobTitlePopupUI", GetOpenWindowfeature(460, 290));
				try { OpenWin.focus(); } catch (e) { }
			/* 삭제의 경우 직위가 사용중인지 확인 후, 삭제처리 */
			} else if (mode == "Del") {
// 				if (!checkTitleUserCnt(cn)) {
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
// 		            		cn : cn,
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
				document.getElementById("PreContent_RayerH").style.display = "";
				document.getElementById("preview_nodata").style.display = "none";
				
				$.ajax({
	            	type : "POST",
	            	dataType: "text",
	            	url : "/admin/ezOrgan/jobTitleUserListView.do",
	            	async : false,
	            	data : 
	            	{
// 	            		cn : oArrRows[0].getAttribute("DATA1"),
	            		jobID : oArrRows[0].getAttribute("DATA1"),
	            		type : Tab1_SelectID,
	            		companyID : $("#ListCompany option:selected").val()
	            	},
	            	success : function (result) {
	            		xmldom = loadXMLString(result);
	            	},
	            	error : function(e) {
	            	}
	            });
				
				var selectedId = oArrRows[0].getAttribute("id");
				var selectedTitle = document.getElementById(selectedId).getElementsByTagName("td")[0].textContent;
				var count = SelectSingleNodeValueNew(xmldom, "TOTALCNT");
				
				document.getElementById("preview_title").textContent = selectedTitle + " 리스트";
				document.getElementById("preview_count").textContent = count;
				
				var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
			    if (oRows.length > 0) {
					xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		            Node = headerData.importNode(xmlRtn, true);
		            headerData.documentElement.appendChild(Node);
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
			}
			else {
				document.getElementById("PreContent_RayerH").style.display = "none";
				document.getElementById("preview_nodata").style.display = "";
				document.getElementById("nodata_title").textContent = "선택된 직책이 없습니다.";
			}
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
//             		cn : cn,
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
            		companyID : companyID,
            		page: pageNum
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
            listview.SetSelectFlag(false);
            listview.SetRowOnDblClick("JobTitleView");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("JobListView");
			
			totalCount = parseInt(SelectSingleNodeValueNew(xmldom, "TOTALCNT"));
			pageNum = parseInt(SelectSingleNodeValueNew(xmldom, "CURPAGE"));
			totalPage = Math.ceil(new Number(totalCount / pageSize));
			
			makePageSelPage();
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
				document.getElementById("PreContent_RayerH").style.display = "";
				document.getElementById("preview_nodata").style.display = "none";
				
				$.ajax({
	            	type : "POST",
	            	dataType: "text",
	            	url : "/admin/ezOrgan/jobTitleUserListView.do",
	            	async : false,
	            	data : 
	            	{
// 	            		cn : oArrRows[0].getAttribute("DATA1"),
 	            		jobID : oArrRows[0].getAttribute("DATA1"),
	            		type : Tab1_SelectID,
	            		companyID : $("#ListCompany option:selected").val()
	            	},
	            	success : function (result) {
	            		xmldom = loadXMLString(result);
	            	},
	            	error : function(e) {
	            	}
	            });
				
				var selectedId = oArrRows[0].getAttribute("id");
				var selectedTitle = document.getElementById(selectedId).getElementsByTagName("td")[0].textContent;
				var count = SelectSingleNodeValueNew(xmldom, "TOTALCNT");
				
				document.getElementById("preview_title").textContent = selectedTitle + " 리스트";
				document.getElementById("preview_count").textContent = count;
				
				var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
			    if (oRows.length > 0) {
					xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		            Node = headerData.importNode(xmlRtn, true);
		            headerData.documentElement.appendChild(Node);
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
			}
			else {
				document.getElementById("PreContent_RayerH").style.display = "none";
				document.getElementById("preview_nodata").style.display = "";
				document.getElementById("nodata_title").textContent = "선택된 직위가 없습니다.";
			}
		}
		
		/* Tab관련 메소드들 ↓ */
		function ChangeTab(obj) {
			document.getElementById("JobListView").innerHTML = "";
			document.getElementById("JobUserListView").innerHTML = "";
			pageNum = 1;
			
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
		
		/* 페이징 관련 메소드 */
		function makePageSelPage() {
			var strtext;
			var pagingHTML = "<div class='pagenavi'>";
			
			document.getElementById("tblPageRayer").innerHTML = "";
			//document.getElementById("mailBoxInfo").innerHTML = "<span style='color:#017BEC;'> " + totalCount + " </span>";
			
			if (totalPage > 1 && pageNum != 1) {
				strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' ></span>";
				pagingHTML += strtext;
			} else {
				strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' ></span>";
				pagingHTML += strtext;
			}	

			if (totalPage > blockSize) {
				if (pageNum > blockSize) {
					strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' ></span>";
					pagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
					pagingHTML += strtext;
				}
			} else {
				strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
				pagingHTML += strtext;
			}

			var MaxNum;
			var i;
			var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1;
			
			if (totalPage >= (startNum + parseInt(blockSize))) {
				MaxNum = (startNum + parseInt(blockSize)) - 1;
			} else {
				MaxNum = totalPage;
			}
			
			for (i = startNum; i <= MaxNum; i++) {
				if (i == pageNum) {
					strtext = "<span class='on'>" + i + "</span>";
					pagingHTML += strtext;
				} else {
					strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
					pagingHTML += strtext;
				}
			}
			
			if (i == 1) {
				strtext = "<span class='on'>" + i + "</span>";
				pagingHTML += strtext;
			}
			
			if (totalPage > blockSize) {
				if (totalPage >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
					strtext = "";
					strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' ></span>";
					pagingHTML += strtext;
				} else {
					strtext = "";
					strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
					pagingHTML += strtext;
				}
			} else {
				strtext = "";
				strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
				pagingHTML += strtext;
			}
			
			if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
				strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' ></span>";
				pagingHTML += strtext;
			} else {
				strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' ></span>";
				pagingHTML += strtext;
			}
					
			pagingHTML += "</div>";
			td_Create(pagingHTML);
		}
		
		function td_Create(strtext) {
			document.getElementById("tblPageRayer").innerHTML = strtext;
		}
		
		function goToPageByNum(Value) {
			pageNum = Value;
			compChange();
			makePageSelPage();
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
		
		/* 체크박스 컬럼 추가 메소드 */
		function makeCheckBoxCol() {
			
		}
	</script>
</head>
<body class="mainbody">
	<h1>
		<spring:message code='ezOrgan.csj01' />
		<select class="companySelect" id="ListCompany" onChange="compChange()">
			<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
			</c:forEach>
		</select>
	</h1>
	<div id="mainmenu">
		<ul>
			<li class="important"><span onClick="BtnAction('Add')"><spring:message code = 'ezAddress.t173'/></span></li>
			<li><span onClick="BtnAction('Mod')"><spring:message code = 'ezAddress.t174'/></span></li>
			<li><span class="icon16 icon16_delete" onClick="BtnAction('Del')"><spring:message code = 'ezAddress.t175'/></span></li>
		</ul>
	</div>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
	</script>
	<div class="portlet_tabpart01" style="width: 100%;">
		<div class="portlet_tabpart01_top" id="tab1">
			<p><span id="001"><spring:message code='ezOrgan.csj02' /></span></p>
			<p><span id="002"><spring:message code='ezOrgan.csj15' /></span></p>
	    </div>
	</div>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
	<div class="mainview">
		<div class="listview" style="border: 0px;">
			<div id="JobListView" style="height: 600px; width: 792px; overflow-y:auto;"></div>
			<div id="tblPageRayer"></div>
		</div>
	</div>
	
	<div class="previewH">
		<div class="previewmail_bar_h"></div>
		<div id="PreContent_RayerH" class="preContent_RayerH" style="display: none;">
			<div class="previewmail">
				<div class="previewmail_info">
					<div id="Preview_HeaderH">
						<p class="preview_header">
							<span class="preview_title" id="preview_title"></span>
							<span class="preview_count" id="preview_count"></span>
						</p>
					</div>
				</div>
			</div>
			
			<div class="preview_content">
				<div class="listview">
					<div id="JobUserListView" style="height: 610px; width: 806px; overflow-y:auto;"></div>
				</div>
			</div>
		</div>
		
		<div id="preview_nodata" class="preview_nodata">
			<dl class="nodata_sIcon">
				<dt><img src="/images/kr/main/noData_sIcon.png"></dt>
				<dd id="nodata_title" style="font-family: malgun gothic"></dd>
			</dl>
		</div>
	</div>
	
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
			<WIDTH>240</WIDTH>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj04' />(<spring:message code='ezApprovalG.t1765'/>)</NAME>
			<WIDTH>240</WIDTH>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj05' /></NAME>
			<WIDTH>140</WIDTH>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj06' /></NAME>
			<WIDTH>140</WIDTH>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
<xml id="userlistviewheader" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
     		<HEADER>
       		<NAME><spring:message code='ezOrgan.t218' /></NAME>
			<WIDTH>190</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t67' /></NAME>
			<WIDTH>190</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t69' /></NAME>
			<WIDTH>190</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t285' /></NAME>
			<WIDTH>190</WIDTH>
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
			<WIDTH>240</WIDTH>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj17' />(<spring:message code='ezApprovalG.t1765'/>)</NAME>
			<WIDTH>240</WIDTH>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj05' /></NAME>
			<WIDTH>140</WIDTH>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj06' /></NAME>
			<WIDTH>140</WIDTH>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
<xml id="userlistviewheader2" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
     		<HEADER>
       		<NAME><spring:message code='ezOrgan.t218' /></NAME>
			<WIDTH>190</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t67' /></NAME>
			<WIDTH>190</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t1500' /></NAME>
			<WIDTH>190</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t285' /></NAME>
			<WIDTH>190</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
</body>
</html>