<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/admin/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
	<style>
		.mainview {margin-top: 5px; width:50%; float:left;}
		.previewH {margin-top: 5px; width:50%; height: 690px; float:right; overflow: hidden;}
		.previewmail_info {border-bottom: 1px solid #e5e5e5; min-width: 300px;}
		.previewmail_bar_h {position: relative; float: left; display: inline-block; width: 5px; height: 100%;}
		.preContent_RayerH {position: absolute; display: inline-block; width: 49%;}
		.preview_header {padding: 0px; font-weight: bold; height:auto; line-height:normal;}
		.preview_title {display: inline-block; max-width:calc(100% - 40px); white-space:nowrap; text-overflow:ellipsis; overflow:hidden; float:left; margin:0 10px 0 13px;}
		.preview_count {display: inline-block; margin-top: -6px; color: #017BEC; font-size: 11px;}
		.preview_content {width: 97%; height: 630px; border: solid 0px green; display: inline-block; padding:10px;}
		.preview_nodata {position: absolute; display: inline-block; width: 49%; vertical-align: middle; text-align: center; padding-top: 70px; border-top: 1px solid #e5e5e5;}
		#lvJobList tr td:nth-child(4) {padding-left: 12px;}
		#lvJobList {min-width: 400px;}
		#lvJobList tr th:nth-child(4), tr th:nth-child(5) {width: 15%;} 
		#lvJobUserList {min-width: 360px;}
		.countColor {color:#017BEC;}
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
		
		var pCompanyID = "${userInfo.companyID}";
		var pCompanyNM = "${userInfo.companyName}";
		var isPrimary = "<c:out value='${userInfo.primary}'/>"; // 다국어 처리용 primary값
		
		document.onselectstart = function () {
            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
                return false;
            } else {
                return true;
            }
        };
		
		$(document).ready(function() {
			companyChange();
		});
		
		/* 회사선택 이벤트 */
		function companyChange() {
			pCompanyID = $("#ListCompany option:selected").val();
			pCompanyNM = $("#ListCompany option:selected").text();
			
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
		    
		    var titleCnt = Number(SelectSingleNodeValueNew(xmlDom, "LISTVIEWDATA/TOTALCOUNT"));
		    document.getElementById("title_info").textContent = titleCnt;
		    
            document.getElementById("jobListView").innerHTML = "";
            
            var listview = new ListView();
            listview.SetID("lvJobList");
            listview.SetMulSelectable(true);
            listview.SetRowOnClick("job_userList_click");
            listview.SetSelectFlag(false);
            listview.SetRowOnDblClick("job_view");
            listview.SetHeightFree(true);
            listview.DataSource(headerData);
            listview.DataBind("jobListView");
            
            makeUseSwitch();
			$("#jobListView").sortable({
				items: "tbody > tr",
				opacity: 0.3,
				cancel: "thead" // 헤더는 drag & drop 되지 않도록 설정
			});
		}
		
		function job_userList_click() {
			pCurPage = 1;
			pSearchValue = "";
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
				var pJobNM = "";
				
				/* 2020-01-22 홍승비 - 직위관리 및 직책관리 우측의 표기이름에 다국어 적용 */
				if (Tab1_SelectID == "001") { // 직위
					if (isPrimary == "1") { // 기본 언어
						pJobNM = oArrRows[0].childNodes[1].textContent;
					} else {
						pJobNM = oArrRows[0].childNodes[2].textContent;
					}
				} else { // 직책
					if (isPrimary == "1") { // 기본 언어
						pJobNM = oArrRows[0].childNodes[1].textContent;
					} else {
						pJobNM = oArrRows[0].childNodes[2].textContent;
					}
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
				
				document.getElementById("PreContent_RayerH").style.display = "";
				document.getElementById("preview_nodata").style.display = "none";
				
		    	pTotalCnt = Number(SelectSingleNodeValueNew(xmlDom, "LISTVIEWDATA/TOTALCOUNT"));
				
				var oRows = SelectNodes(xmlDom, "LISTVIEWDATA/ROWS/ROW");
				var orgPosition = "";
			    if (oRows.length > 0) {
			    	xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
			    	$(xmlRtn.getElementsByTagName("ROW")).each(function(index) {
		            	if($(this).find("DATA5").text() == "addJob") {
							if(Tab1_SelectID == "001") {
		            			orgPosition = $(this).find("CELL").eq(3).find("VALUE").text();
							} else {
								orgPosition = pJobNM;
							}
		            		$(this).find("CELL").eq(3).find("VALUE").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
		            	}
		            });
			    	
			    	Node = headerData.importNode(xmlRtn, true);
		            headerData.documentElement.appendChild(Node);
			    }
				
				document.getElementById("preview_title").textContent = pJobNM;
				document.getElementById("preview_count").textContent = pTotalCnt;
				
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
			} else {
				document.getElementById("PreContent_RayerH").style.display = "none";
				document.getElementById("preview_nodata").style.display = "";
				
				if (Tab1_SelectID == "001") {
					document.getElementById("nodata_title").textContent = "<spring:message code = 'ezOrgan.khj01'/>";
				}
				else {
					document.getElementById("nodata_title").textContent = "<spring:message code = 'ezOrgan.khj02'/>";
				}
			}
		}

		function MoveUp_onclick(){
			var listview = new ListView();
			listview.LoadFromID("lvJobList");
			listview.RowMoveUp();
		}

		function MoveDown_onclick(){
			var listview = new ListView();
			listview.LoadFromID("lvJobList");
			listview.RowMoveDown();
		}

		function MoveConfirm_onclick(){
			var jobID = "";
			var sort = "";

			var listview = new ListView();
			listview.LoadFromID("lvJobList");

			if (listview.GetDataRows().length == 0){
				return;
			}

			for (var i = 0 ; i < listview.GetDataRows().length ; i++){
				jobID += listview.GetDataRows()[i].getAttribute("DATA1"); // jobid
				sort += listview.GetDataRows()[i].getAttribute("DATA3"); // sort

				if(i != listview.GetDataRows().length -1){
					jobID += ",";
					sort +=",";
				}
			}

			$.ajax({
				type: "POST",
				dataType: "text",
				url: "/admin/ezOrgan/saveJobTitleListOrder.do",
				async: false,
				data: { jobID: jobID, sort: sort },
				success: function(result) {
					if (result === "OK") {
						alert("<spring:message code='ezOrgan.t49' />");
						job_list();
						job_userList();
					} else if (result === "ERROR") {
						alert("<spring:message code='ezOrgan.t48' />");
					} 
				},
				error: function() {
					alert("<spring:message code='ezOrgan.t48' />");
				}
			});
		}
		
		/* (직위/직책) Row 더블클릭 이벤트 */
		function job_view() {
			BtnAction('Mod');
		}
		
		/* (추가/수정/삭제) 버튼 이벤트 */
		var titleInfo_dialogArguments = new Array();
		function BtnAction(mode) {
			var type = Tab1_SelectID;
			var jobIDList = [];
			var jobList = new ListView();
				jobList.LoadFromID("lvJobList");
			
			var oArrRows = jobList.GetSelectedRows();
			for (var i = 0; i < oArrRows.length; i ++) {
				jobIDList.push(oArrRows[i].getAttribute("DATA1"));
			}
			
			/* 수정, 삭제의 경우 선택된 Row가 있나 체크  */
			if (mode == "Mod" || mode == "Del") {
				var oArrRows = jobList.GetSelectedRows();
				if (oArrRows == 0) {
					if (Tab1_SelectID == "001") {
						alert("<spring:message code = 'ezOrgan.csj07'/>");
					} else {
						alert("<spring:message code = 'ezOrgan.csj18'/>");
					}
					return;
				} 
			}
			
			if (mode == "Add" || mode == "Mod") {
				// 수정의 경우 선택된 Row 가 하나 이상인지 확인
				if (mode == "Mod" && jobIDList.length > 1) {
					if (type == "001") {
						alert("<spring:message code = 'ezOrgan.khj03'/>");
					} else if (type == "002") {
						alert("<spring:message code = 'ezOrgan.khj04'/>");
					}
					return;
				}
				
				var maxSort = 0;
				for (var i = 0; i < jobList.GetDataRows().length; i++) {
					var sortValue = parseInt(jobList.GetDataRows()[i].getAttribute("DATA3"), 10);
					if (sortValue > maxSort) {
						maxSort = sortValue;
					}
				}
				maxSort += 1;
				
				var url = "/admin/ezOrgan/jobTitlePopupUI.do?type=" + type + "&mode=" + mode + "&companyID=" + pCompanyID + "&maxSort=" + maxSort;
				var args = new Array();
				args[0] = pCompanyNM;
				args[1] = jobIDList[0];
				
				titleInfo_dialogArguments[0] = args;
			    titleInfo_dialogArguments[1] = titleInfo_complete;
			    
			    var OpenWin = window.open(url, "jobPopupUI", GetOpenWindowfeature(460, 260));
				try { OpenWin.focus(); } catch (e) {console.log(e);}
				
			} else if (mode == "Del") {
				var length = jobIDList.length;
				for (var i = 0; i < length; i++) {
					if (!checkTitleUserCnt(jobIDList[i])) {
						if (type == "001") {
							alert("<spring:message code = 'ezOrgan.csj13'/>");
						} else if (type == "002") {
							alert("<spring:message code = 'ezOrgan.csj22'/>");
						}
						return;
					}
				}
				
				if (confirm("<spring:message code = 'ezOrgan.pjg01'/>")) {
					$.ajax({
		            	type : "POST",
		            	dataType: "text",
		            	url : "/admin/ezOrgan/jobTitleDelete.do",
		            	async : false,
		            	data : 
		            	{
		            		jobIDList : jobIDList.length == 1 ? jobIDList += ";" : jobIDList.join(";"),
		            		type : type,
		            		companyID : pCompanyID
		            	},
		            	success : function (result) {
		            		if (result == "TRUE") {
		            			alert("<spring:message code = 'ezBoard.t54'/>");
		            		} else {
			            		alert("<spring:message code = 'ezBoard.t55'/>");
		            		}
		            		
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
	        	// 2024.07.05 한슬기 : alert위치 변경(safari에서 alert이 팝업창에 가려 안보이는 현상이 있어 변경)
	        	/*if (rtnVal[0] == "TRUE") {
	        		if (rtnVal[1] == "Add") { 
		        		alert("<spring:message code = 'ezBoard.t269'/>");
	        		} else {
		        		alert("<spring:message code = 'ezCommunity.t8'/>");
	        		}
	        	} else {
	        		alert("<spring:message code = 'main.sp12'/>");
	        	}*/
	        	
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
			    
			    var OpenWin = window.open("/admin/ezOrgan/userInfo.do", "UserInfo", GetOpenWindowfeature(830, 470));
			    try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
		}
		
		/* 유저수정 팝업창 완료 이벤트 */
		function info_user_complete(rtnValue) {
			// 2024.07.05 한슬기 : alert위치 변경(safari에서 alert이 팝업창에 가려 안보이는 현상이 있어 변경)
			/*if (typeof (rtnValue) != "undefined") {
	        	alert("<spring:message code='ezOrgan.t11' />");
	        }*/
	        
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
            		rtnFlag = false;
            	}
            });
			
			return rtnFlag;
		}
		
		/* (직위/직책) 탭 이동 관련 이벤트 1 [리스트 변경] */
		function ChangeTab(obj) {
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
	    /* Tab관련 메소드들 ↑ */
		
		/* 사용여부  스위치  추가 메소드 */
		function makeUseSwitch() {
			var table  = document.getElementById("lvJobList");
			var length = table.rows.length;
			for (var i = 1; i < length; i++) {
				var useTd     = table.rows[i].cells[3];
				if (!useTd) { break; }
				
				var labelElmt = document.createElement("label");
				var inputElmt = document.createElement("input");
				var spanElmt  = document.createElement("span");
				var wrapperDiv = document.createElement("div");
				wrapperDiv.className = "custom_checkbox";
				
				labelElmt.className = "switch";
				spanElmt.className = "slider round";
				
				inputElmt.setAttribute("type", "checkbox");
				
				if (useTd.textContent == "Y") {
					inputElmt.setAttribute("checked", "checked");
				}
				
				labelElmt.onclick = function(event) {inUseUpdate(event, this);};
				
				useTd.textContent = "";
				
				labelElmt.appendChild(inputElmt);
				labelElmt.appendChild(spanElmt);
				
				wrapperDiv.appendChild(labelElmt);
				useTd.appendChild(wrapperDiv);
			}
		}
		
		/* 사용여부 업데이트 */
		function inUseUpdate(event, obj) {
			event.stopPropagation();
			//console.log("tagName" + event.target.tagName);
			
			if (event.target.tagName == "INPUT") {
				var selectedTr    = obj.parentElement.parentElement;
				var selectedInput = obj.firstElementChild;
				var useFlag;
				
				if (selectedInput.getAttribute("checked")) {
					useFlag = "N";
				}
				else {
					useFlag = "Y";
				}
				
				$.ajax({
					type : "POST",
					dataType: "text",
					url : "/admin/ezOrgan/jobTitleAction.do",
					async : false,
					data :
					{
						jobID : selectedTr.getAttribute("DATA1"),
						type : selectedTr.getAttribute("DATA2"),
						mode : "Mod",
						sort : selectedTr.getAttribute("DATA3"),
						useFlag : useFlag,
						companyID : selectedTr.getAttribute("DATA4"),
						displayName1 : selectedTr.children[1].textContent,
						displayName2 : selectedTr.children[2].textContent
					},
					success : function(result) {
						if (useFlag == "Y") {
							selectedInput.setAttribute("checked", "checked");
						} else {
							selectedInput.setAttribute("checked", "");
						}
					},
					error : function(e) {
						alert("<spring:message code='main.sp12' />");
					}
				});
			}
		}
		
		$(window).on("resize", function(){
			windowResize();
		});
		
		function windowResize() {
			var height = document.documentElement.clientHeight;
			
			document.getElementById("previewH").style.height = (height - 200) + "px";
			document.getElementById("jobListView").style.height = (height - 225)+ "px";
			document.getElementById("jobUserListView").style.height = (height - 273) + "px";
		}
		
		$(function(){
			windowResize();
		});
		
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
	    		_html += "<span class='btnimg first' onclick='return goToPageNum(1)'></span>";
	    	} else {
	    		_html += "<span class='btnimg first disabled'></span>";
	    	}
	    	
	    	if (parseInt((pCurPage - 1) / pBlockSize) > 0) {
	    		_html += "<span class='btnimg prev' onclick='return goToPrevBlock()'></span>";
	    	} else {
	    		_html += "<span class='btnimg prev disabled'></span>";
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
	    		_html += "<span class='btnimg next' onclick='return goToNextBlock()'></span>";
	    	} else {
	    		_html += "<span class='btnimg next disabled'></span>";
	    	}
	    	
	    	if (pCurPage < pTotalPage) {
	    		_html += "<span class='btnimg last' onclick='return goToPageNum(" + pTotalPage + ")'></span>";
	    	} else {
	    		_html += "<span class='btnimg last disabled'></span>";
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
<body class="mainbody" style="overflow: hidden;">
	<h1>
		<spring:message code='ezOrgan.csj01' />
		<span>&nbsp;<span class="txt_color" id="title_info"></span></span>
		<span class="title_bar"><img src="/images/name_bar.gif"></span>
		<select class="companySelect" id="ListCompany" onChange="companyChange()">
			<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
			</c:forEach>
		</select>
	</h1>
	<div id="mainmenu">
		<ul>
			<li class="important"><span onClick="BtnAction('Add')"><spring:message code = 'ezAddress.t173'/></span></li>
			<li><span onClick="BtnAction('Mod')"><spring:message code = 'ezAddress.t174'/></span></li>
			<li><span class="icon16 icon16_delete" onClick="BtnAction('Del')"></span></li>
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
			<div id="jobListView" style="height: 658px; width: 100%; overflow:auto;"></div>
		</div>
		<div id="jobListBottom" style="width:100%; float:left; box-sizing: border-box;  border: 1px solid #ddd; ">
			<div class="moveWrap" style="width:100%; vertical-align:middle; text-align:center; float:right; background-color: #f8f8fa; padding:5px 0px;">
				<span class="upBtn" id="upBtn" onclick="MoveUp_onclick()"><img src="/images/admin/arrowUp.png"/></span>
				<span class="downBtn" id="downBtn" onclick="MoveDown_onclick()"><img src="/images/admin/arrowDown.png"/></span>
				<span class="btnpositionJsp"><a class="imgbtn" id="saveBtn" onclick="MoveConfirm_onclick()"><span><spring:message code='ezOrgan.t104'/></span></a></span>
			</div>
		</div>
	</div>
	
	<div id="previewH" class="previewH">
		<div class="previewmail_bar_h"></div>
		<div id="PreContent_RayerH" class="preContent_RayerH" style="display: none;">
			<div class="previewmail">
				<div class="previewmail_info">
					<div id="Preview_HeaderH">
						<div class="preview_header">
							<span id="userSearchRayer" style="float:right; display: block; margin-right: 2px; margin-top: 4px;">
								<select id="searchType" style="height: 26px; width: 60px;"><option value="displayname"><spring:message code='main.t76' /></option></select>
								<input id="searchValue" onkeypress="if(event.keyCode==13) {search(); return false;}" onfocus="keyword_Clear(this);" autocomplete="off" style="height: 26px; border: 1px solid #cbcbcb; border-right:0px; margin-top:2px; height:26px !important; margin-right:-1px;">
								<a style="float:right; cursor: pointer;"><img src="/images/bsearch_new.gif" style="width: 26px; height: 26px; margin-top:2px;" border="0" onClick="search()"></a>
							</span>
							<div style="float:none; display:block; overflow:hidden; line-height:37px;">
								<span class="preview_title" id="preview_title"></span>
								<span class="preview_count" id="preview_count"></span>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="preview_content">
				<div class="listview" style="border-top: 1px solid #ddd; border-left: none; border-right: none; border-bottom: none;">
					<div id="jobUserListView" style="height: 610px; width: 100%; overflow: auto;"></div>
				</div>
				
				<div id="jobUserListPageRayer" style="border-top: 0px;"></div>
			</div>
		</div>
		
		<div id="preview_nodata" class="preview_nodata">
			<dl class="nodata_sIcon">
				<dt><img src="/images/kr/main/noData_sIcon.png"></dt>
				<dd id="nodata_title"></dd>
			</dl>
		</div>
	</div>
	
<xml id="listviewheader" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
			<HEADER>
			<NAME></NAME>
			<WIDTH>20</WIDTH>
			<COLNAME>CHECKBOX</COLNAME>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj04' />(${primary})</NAME>
			<WIDTH></WIDTH>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj04' />(${secondary})</NAME>
			<WIDTH></WIDTH>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj05' /></NAME>
			<WIDTH></WIDTH>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
<xml id="userlistviewheader" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
     		<HEADER>
       		<NAME><spring:message code='ezOrgan.t218' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t67' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t68' /></NAME>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t69' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t285' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
<xml id="listviewheader2" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
			<HEADER>
			<NAME></NAME>
			<WIDTH>20</WIDTH>
			<COLNAME>CHECKBOX</COLNAME>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj17' />(${primary})</NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj17' />(${secondary})</NAME>
			<WIDTH>100</WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.csj05' /></NAME>
			<WIDTH>50</WIDTH>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
<xml id="userlistviewheader2" style="display:none">
	<LISTVIEWDATA>
	   	<HEADERS>
     		<HEADER>
       		<NAME><spring:message code='ezOrgan.t218' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t67' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t68' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t1500' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
			<HEADER>
			<NAME><spring:message code='ezOrgan.t285' /></NAME>
			<WIDTH></WIDTH>
			<STYLE>border-top:0px;</STYLE>
			</HEADER>
    	</HEADERS>
  	</LISTVIEWDATA>
</xml>
</body>
</html>