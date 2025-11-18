<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/previewmail.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <style>
	    .mainlist_free tr td:first-child {
	    		padding-left:10px;
	    		height:25px;
	    }
	    .mainlist_free tr th:first-child {
	    		padding-left:10px;
	    }
	    .preview_info {background: #f1f3f5; margin: 0px; padding: 3px; overflow: hidden; border-bottom: 1px solid #e5e5e5; height: 36px; font-weight: bold;}
	    .preview_title {display: inline-block;margin-top: -6px;margin-left: 13px;}
	    
		/* Tooltip text */
		.concurrentLI > .tooltip_span {visibility: hidden;background-color: rgba(66, 66, 66, 0.7);color: #fff;text-align: center;padding: 10px;border-radius: 6px; position: absolute; font-weight: normal;z-index: 1; top: 6px; opacity: 0; transition: opacity 1s;line-height:0px;}
		.tooltip_span img {background-color : white; border-radius:30px; margin : 10px 10px;vertical-align:middle;}
		
		/* Show the tooltip text when you mouse over the tooltip container */
		.conlistDL:hover ~ .tooltip_span {visibility: visible;opacity: 1;}
		.concurrentLI .tooltip_span::after {  content: " ";
			position: absolute;
			bottom: 100%;  /* At the top of the tooltip */
			left: 10px;
			margin-left: -5px;
			border-width: 5px;
			border-style: solid;
			border-color: transparent transparent rgba(66, 66, 66, 0.7) transparent;
		}
		.preview_count {display: inline-block; margin-top: -6px; color: #017BEC; font-size: 11px;}
		.tooltip_span .tooltiptext {color: white; }
		.tooltip_span .tooltiptext{display:inline-block; padding-left:30px; background-repeat:no-repeat; background-position:0px 3px; position:relative; text-align:left; word-break:break-all; line-height:2; margin-right:10px; min-width:100px; box-sizing:border-box; float:left;}
		.tooltip_span .tooltiptext:before{content:""; position:absolute; width:20px; height:20px; background:#fff; border-radius:50%; left:0; top:3px; z-index:-1;}
		.tooltip_span .tooltiptext.company{background-image:url(/images/admin/admin_company.png);}
		.tooltip_span .tooltiptext.dept{background-image:url(/images/admin/admin_team.png);}
		.tooltip_span .tooltiptext.jobname{background-image:url(/images/admin/admin_user.png);}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/admin.css')}">
		<script type="text/javascript">
			var pUse_Editor = "<c:out value='${use_editor}'/>";
			var totalCnt = 0;
			var CurPage = 1;
			var totalPage = 0;
			var pageSize = 15;
			var BlockSize = 10;
			var positionX = 0;
			var positionY = 0;
			var exportingExcel = false;

	    	document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
	                return false;
	            } else {
	                return true;
	            }
	        };
	        
	        var topid = "";
	        var Tab1_flag = true;
	        var CardHeader1 = "<spring:message code='ezOrgan.t263' />";
	        var CardHeader2 = "<spring:message code='ezOrgan.t189' />";
	        var CardHeader3 = "<spring:message code='ezOrgan.t264' />";
	    	
			$(document).ready(function() {
				windowResize();
				var a = document.getElementById("previewmail").style.display = "none";
				AddJob_List();
			});

			$(window).on("resize", function(){
				 windowResize();
			});
			

			window.onmousemove = function (e) {
				positionX = e.clientX + 'px';
				positionY = (e.clientY + 20) + 'px';
			};
			
			function company_change() {
				document.getElementById("preview_nodata").style.display = "";
                document.getElementById("previewmail").style.display = "none";
		        AddJob_List();
		    }
		    
		    function AddJob_List() {
		    	
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/getAddJobList.do",
		        	data : {companyID : document.getElementById("ListCompany").value,
		        			searchType : document.getElementById("searchType").value,
		        			searchValue : document.getElementById("searchValue").value,
		        			page      : CurPage,
		        			pageSize  : pageSize},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		if (result.xml != "") {
		                    if (result.documentElement.getElementsByTagName("TOTALCNT")[0] != null) {
		                        totalCnt = getNodeText(result.documentElement.getElementsByTagName("TOTALCNT")[0]);
		                        totalPage = Math.ceil(new Number(totalCnt / pageSize));
		                    }
		                } else {
		                    totalCnt = 0;
		                    totalPage = 0;
		                }
		        		
		        		var xmldom = result;
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

		                document.getElementById("AddJobListView").innerHTML = "";

		                var listview = new ListView();
		                listview.SetID("lvAddJobList");
		                listview.SetMulSelectable(false);
		                listview.SetRowOnClick("UserAddjobList");
		                listview.SetSelectFlag(false);
		                listview.SetRowOnDblClick("User_View");
		                listview.SetHeightFree(true);
		                listview.DataSource(headerData);
		                listview.DataBind("AddJobListView");
		                checkbox_header();
		                
		                var list = document.getElementById("lvAddJobList");
		                var listLeg = list.children[1].childElementCount;
		                
		                /* totalCnt = listLeg;
                        totalPage = Math.ceil(new Number(totalCnt / pageSize)); */

						rowListSelect();
						checkItems();
		                //2018-12-28 문성업 -페이징 함수
		                makePageSelPage();
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t2' />" + error);
		        	}
		        });		        
		    }
		    //2018-12-28 문성업 -페이징
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
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
		        if (parseInt(pageNum - 1) > 0) {
		            goToPageByNum(parseInt(pageNum - 1));
		        } else {
		            return;
		        }
		    }
		    
		    function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage) {
		            goToPageByNum(parseInt(pageNum + 1));
		        } else {
		            return;
		        }
		    }

		    function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            AddJob_List();
		        }
		    }
			
			function makePageSelPage() {
				checkFlag = false;
				$("#checkAll").prop("checked", false);
				
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;<span class='txt_color'>" + totalCnt + "</span>";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        
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
			
			/*2018-12-28 문성업 -페이징 끝*/
			
		    var clickTabID = "1tab1";
		    function ChangeTab(obj) {
		        var pSelectTab = obj.getAttribute("divname");
		        clickTabID = obj.id;
		        DelType = pSelectTab;
		        type = pSelectTab + "=1";        
		    }
		    
		    var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id){
		            obj.className = "";
		        }
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
		    /* function Tab1_NewTabIni(pTabNodeID) {
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
		    } */
		    var flags = true;
		    function UserAddjobList(obj) {
				// 체크박스 클릭
				if(flags) {
					var className = "";
					try {
						window.event.target.getAttribute('class');
					} catch(e) {
						window.event.srcElement.getAttribute('class');
					}
					if(className === 'checks') {
						return;
					}
				}

		        var listview = new ListView();
		        listview.LoadFromID("lvAddJobList");		        
		        
		        var cnVal = listview.GetSelectedRows()[0].firstChild.firstChild.defaultValue;
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/getUserAddJobList.do",
		        	data : {cn : cnVal},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		document.getElementById("AddJobList").innerHTML = "";
		                var UserAddJobList = SelectNodes(result, "DATA/ROW");
		                var userCount = UserAddJobList.length;
		                
		                //2019.01.23 유은정 디자인 변경
		                var ulElement = document.createElement("ul");
		                ulElement.className = "concurrentUL";
		                
		                for (var Cnt = 0; Cnt < userCount; Cnt++) {
		                	var liElement = document.createElement("li");
		                	var companyElement = document.createElement("dl");
		                	var deptElement = document.createElement("dl");
		                	var jobNameElement = document.createElement("dl");
		                	
		                	var companyDt = document.createElement("dt");
		                	var companyImg = document.createElement("img");
		                	var companyDd = document.createElement("dd");
		                	
		                	var deptDt = document.createElement("dt");
		                	var deptImg = document.createElement("img");
		                	var deptDd = document.createElement("dd");
		                	
		                	var jobNameDt = document.createElement("dt");
		                	var jobNameImg = document.createElement("img");
		                	var jobNameDd = document.createElement("dd");
		                	
		                	var deleteElement = document.createElement("p");
		                	var deleteSpan = document.createElement("span");
		                	
		                	liElement.id = "Cardlist_" + Cnt;
		                	liElement.setAttribute("_CN", getNodeText(SelectNodes(UserAddJobList[0], "CN")[Cnt]));
		                	liElement.setAttribute("_DEPTID", getNodeText(SelectNodes(UserAddJobList[0], "DEPARTMENT")[Cnt]));
		                	liElement.setAttribute("_T1", getNodeText(SelectNodes(UserAddJobList[0], "TITLE1")[Cnt]));
		                	liElement.setAttribute("_T2", getNodeText(SelectNodes(UserAddJobList[0], "TITLE2")[Cnt]));
		                	liElement.setAttribute("_JOBID", getNodeText(SelectNodes(UserAddJobList[0], "JOBID")[Cnt])); // 2022-07-06 이사라 - 동일부서 겸직의 경우 jobId로 구분이 필요하여 추가
		                	liElement.setAttribute("_ROLEID", getNodeText(SelectNodes(UserAddJobList[0], "ROLEID")[Cnt])); 
		                	liElement.onclick = function () { event_Cardlistclick(this); };
		                	liElement.onselectstart = function () { return false; };
		                	liElement.className = "concurrentLI";
		                	
		                	companyElement.className = "conlistDL";
		                	deptElement.className = "conlistDL";
		                	jobNameElement.className = "conlistDL";
		                	
		                	companyDt.className = "conlistIcon";
		                	deptDt.className = "conlistIcon";
		                	jobNameDt.className = "conlistIcon";
		                	
		                	companyImg.src = "/images/admin/admin_company.png";
		                	deptImg.src = "/images/admin/admin_team.png";
		                	jobNameImg.src = "/images/admin/admin_user.png";
		                	
		                	companyDd.className = "conlistText";
		                	deptDd.className = "conlistText";
		                	jobNameDd.className = "conlistText";
		                	
		                	
							deleteElement.className = "conDelete";
		                	deleteElement.setAttribute("id", "Cardlist_" + Cnt);
		                	deleteElement.onclick = function () { event_DeleteClick(this) };
		                	deleteSpan.className = "icon16 icon16_delete";
		                	
		                	companyDd.textContent = getNodeText(SelectNodes(UserAddJobList[0], "COMPANY")[Cnt]);
		                	
		                    if (CrossYN()) {
		                    	deptDd.textContent = getNodeText(SelectNodes(UserAddJobList[0], "DESCRIPTION")[Cnt])
		                    } else {
		                    	deptDd.innerText = getNodeText(SelectNodes(UserAddJobList[0], "DESCRIPTION")[Cnt])
		                    }
		                    
		                    jobNameDd.textContent = getNodeText(SelectNodes(UserAddJobList[0], "DISPLAYNAME")[Cnt]) + " (" + getNodeText(SelectNodes(UserAddJobList[0], "TITLE")[Cnt]);
	                        var role = getNodeText(SelectNodes(UserAddJobList[0], "ROLE")[Cnt]);
		                        if (null != role && "" != role){
		                        	jobNameDd.textContent += " / " + role + ")";	                        	
		                        } else {
		                        	jobNameDd.textContent += ")";
	                        }
		                    
		                    ///////tooltip
		                    var tooltipDiv = document.createElement("div");
		                    tooltipDiv.className = "tooltip_span";
		                    
		                    var companySpan = document.createElement("span");
		                    companySpan.className = "tooltiptext company";
		                    
		                    var deptSpan = document.createElement("span");
		                    deptSpan.className = "tooltiptext dept";
		                    var jobNameSpan = document.createElement("span");
		                    jobNameSpan.className = "tooltiptext jobname";
		                    
		                    companySpan.textContent = getNodeText(SelectNodes(UserAddJobList[0], "COMPANY")[Cnt]);
		                    
		                    if (CrossYN()) {
		                    	deptSpan.textContent = getNodeText(SelectNodes(UserAddJobList[0], "DESCRIPTION")[Cnt])
		                    } else {
		                    	deptSpan.innerText = getNodeText(SelectNodes(UserAddJobList[0], "DESCRIPTION")[Cnt])
		                    }
		                    
		                    jobNameSpan.textContent = getNodeText(SelectNodes(UserAddJobList[0], "DISPLAYNAME")[Cnt]) + " (" + getNodeText(SelectNodes(UserAddJobList[0], "TITLE")[Cnt]);
	                        var role = getNodeText(SelectNodes(UserAddJobList[0], "ROLE")[Cnt]);
	                        if (null != role && "" != role){
		                        	jobNameSpan.textContent += " / " + role + ")";	                        	
		                        } else {
		                        	jobNameSpan.textContent += ")";
	                        }

		                    tooltipDiv.appendChild(companySpan);
		                    tooltipDiv.appendChild(deptSpan);
		                    tooltipDiv.appendChild(jobNameSpan);
		                     
		                    //company
		                    companyDt.appendChild(companyImg);
		                    companyElement.appendChild(companyDt);
		                    companyElement.appendChild(companyDd);
		                    
		                    //dept
		                    deptDt.appendChild(deptImg);
		                    deptElement.appendChild(deptDt);
		                    deptElement.appendChild(deptDd);
		                    
		                    //userName + title
		                    jobNameDt.appendChild(jobNameImg);
		                    jobNameElement.appendChild(jobNameDt);
		                    jobNameElement.appendChild(jobNameDd);
		                    
		                    //delete
		                    deleteElement.appendChild(deleteSpan);
		                    
		                    //li로 합치기
		                    liElement.appendChild(companyElement);
		                    liElement.appendChild(deptElement);
		                    liElement.appendChild(jobNameElement);
		                    liElement.appendChild(deleteElement);
		                    liElement.appendChild(tooltipDiv);
		                    
		                    document.getElementById("AddJobList").appendChild(liElement);
		                    document.getElementById("preview_nodata").style.display = "none";
		                    document.getElementById("previewmail").style.display = "block";
		                    
		                    //2018-12-28 문성업 row 이벤트 추가
		                    var header_info = listview.GetSelectedRows()[0].getAttribute("id");
		                    var headerTitle = document.getElementById(header_info).getElementsByTagName("td")[2].textContent;
		                    var headerTitle2 = document.getElementById(header_info).getElementsByTagName("td")[3].textContent;
		                    
		                    document.getElementById("preview_title").textContent = headerTitle;
		                    document.getElementById("preview_title2").textContent = headerTitle2 +" <spring:message code='ezOrgan.mse4' />";
		                    document.getElementById("preview_count").textContent =  userCount;
		                }	

	                    //tooltip addeventlistener
	                    var tooltipList = document.getElementsByClassName("conlistDL");
	                    HTMLCollection.prototype.forEach = Array.prototype.forEach;
	                    
	                    tooltipList.forEach(function(item, index) {
	                    	item.addEventListener("mouseover", function() {
	                    		var tooltip = item.parentElement.getElementsByClassName("tooltip_span")[0];
	                    		tooltip.style.top = positionY;
	                    		tooltip.style.left = positionX;
	                    	});
	                    });
		        	}
		        });

				var doc = window.document;
				if(document.getElementById(obj) == null) return;
				itemseq = document.getElementById(obj).getAttribute("DATA1");
				if(itemseq == "0" || itemseq == null || itemseq == "") {
					return;
				}
				flags = true;
				// 2023-08-08 이사라 - 체크박스 id에 '.' 이 들어가는 경우 link로 인식하여 체크되지 않는 오류 수정
				/*   : $("#" + itemseq)와 같이 id로 셀렉트하는 것이 더 명시적으로 보이나 
					   id 값에 상관없이 정상 선택이 되고 backend에 정상적으로 값을 전달하는 방법으로 수정 */
				itemNode = document.getElementById(obj).firstChild.firstChild;
				if(checkFlag) {
					if(itemNode.checked == true) {
						$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
						itemNode.checked = false;
					} else {
						$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
						itemNode.checked = true;
					}
				} else {
					$("#lvAddJobList tr td").css("background-color", "rgb(255, 255, 255)");
					$(".checks").prop("checked",false);
					if(itemNode.checked == true) {
						$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
						itemNode.checked = false;
					} else {
						$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
						itemNode.checked = true;
					}
				}

				checkItems();
		    }
		    
		    function event_DeleteClick(obj) {
		        AddJob_Del('DEL', obj);
		    }

			var listContentArry = new Array();
			var listEventCheckbox = false;
			var _RowObject = null;		    
			function AddJob_Del(mode, obj) {

				var xmlHTTP = createXMLHttpRequest();
				var xmlDom = createXmlDom();
				var xmlPara = createXmlDom();
				var objRoot, objNode;
				createNodeInsert(xmlDom, objNode, "DATA");

				// 오른쪽 프리뷰 겸직 개별 삭제
				if (mode == "DEL") {
					if (obj != null && obj != "") {
						_RowObject = document.getElementById(obj.id);
					}

					if (confirm("<spring:message code='ezOrgan.pjg01' />")) {
						if (document.getElementById("AddJobList").childNodes.length == 1) {
							var listview = new ListView();
							listview.LoadFromID("lvAddJobList");

							for (var i = 0; i < document.getElementById("AddJobList").childNodes.length ; i++) {
								createNodeAndInsertText(xmlDom, objNode, "CN", GetAttribute(_RowObject, "_CN"));
								createNodeAndInsertText(xmlDom, objNode, "DEPTID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_deptid"));
								createNodeAndInsertText(xmlDom, objNode, "TITLE", "");
								createNodeAndInsertText(xmlDom, objNode, "JOBID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_jobid"));
								createNodeAndInsertText(xmlDom, objNode, "ROLEINFO", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_roleid")); //2023-12-07 김혜지 - 동일 부서의 겸직(직위 동일, 직책만 다른 경우) JobeId와 RoleId를 둘 다 비교하도록 적용 
							}
						} else {
							for (var i = 0; i < document.getElementById("AddJobList").childNodes.length ; i++) {
								if (GetAttribute(_RowObject, "_DEPTID") == GetAttribute(document.getElementById("AddJobList").childNodes[i], "_deptid") 
										&& GetAttribute(_RowObject, "_JOBID") == GetAttribute(document.getElementById("AddJobList").childNodes[i], "_jobid")      // 2022-07-07 이사라 - 한 부서에 겸직 2개 이상인 경우 1개만 삭제 가능하도록, deptid와 jobid를 함께 비교하여 고유한 1개의 값만 적용
										&& GetAttribute(_RowObject, "_ROLEID") == GetAttribute(document.getElementById("AddJobList").childNodes[i], "_roleid")) { // 2023-12-12 김혜지 - 한 부서에 동일 겸직(직위 동일, 직책은 다른경우)인 경우  deptid, jobid, roleId를 비교하도록 수정 
									createNodeAndInsertText(xmlDom, objNode, "CN", GetAttribute(_RowObject, "_CN"));
									createNodeAndInsertText(xmlDom, objNode, "DEPTID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_deptid"));
									createNodeAndInsertText(xmlDom, objNode, "TITLE", "");
									createNodeAndInsertText(xmlDom, objNode, "JOBID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_jobid"));
									createNodeAndInsertText(xmlDom, objNode, "ROLEINFO", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_roleid"));
								} else {
									createNodeAndInsertText(xmlDom, objNode, "CN", GetAttribute(_RowObject, "_CN"));
									createNodeAndInsertText(xmlDom, objNode, "DEPTID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_deptid"));
									createNodeAndInsertText(xmlDom, objNode, "TITLE", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_t1") + ":" + GetAttribute(document.getElementById("AddJobList").childNodes[i], "_t2"));		                        
									createNodeAndInsertText(xmlDom, objNode, "JOBID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_jobid"));
									createNodeAndInsertText(xmlDom, objNode, "ROLEINFO", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_roleid"));
								}
							}
						}
					} else {
						return;	
					}
				} else { // 왼쪽 리스트 겸직 삭제
					var listview = new ListView();
					var dataList = new Array();
					listview.LoadFromID("lvAddJobList");

					$("input[name='checks']:checked").each(function(){
						dataList.push(this.parentElement.parentElement.getAttribute("DATA1"));
					});

					// 선택된 사원이 없을 경우
					if (dataList.length == 0) {
						alert("<spring:message code='ezOrgan.t9901' />");
						return;
					}

					if (confirm(strLangKJE01)) {
						var inputElmt = document.getElementsByName("checks");
						var length    = inputElmt.length;

						for (var i = 0; i < length; i++) {
							if (inputElmt[i].checked) {
								createNodeAndInsertText(xmlDom, objNode, "CN", inputElmt[i].getAttribute("id"));
								createNodeAndInsertText(xmlDom, objNode, "DEPTID", "");
								createNodeAndInsertText(xmlDom, objNode, "TITLE", "");
								createNodeAndInsertText(xmlDom, objNode, "JOBID", "");
								createNodeAndInsertText(xmlDom, objNode, "ROLEINFO", "");
							}
						}
					} else {
						return;
					}
				}

				xmlHTTP.open("POST", "/admin/ezOrgan/saveSubTitle.do", false);
				xmlHTTP.send(xmlDom);
				//UserAddjobList(_RowObject);

				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
					alert("<spring:message code='ezOrgan.t197' />");
					return;
				} else {
					// 개별 dom 삭제
					var doc = window.document;
					if (mode == "DEL") {
						var childObj = doc.getElementById(_RowObject.id);
						var parentObj = doc.getElementById(_RowObject.parentElement.id);
						var rowId = childObj.getAttribute('_cn');
						parentObj.removeChild(childObj);

						if(parentObj.childElementCount == 0) {
							// 프리뷰창 디스플레이 변경
							doc.getElementsByClassName('preview_nodata')[0].style.display = '';
							doc.getElementsByClassName('previewmail')[0].style.display = 'none';

							var leftList = doc.getElementById('lvAddJobList');
							var lstCnt = leftList.children[1].childElementCount;
							$("#" + rowId).prop("checked", false);
							rowList = [];
							checkItems();
							if(lstCnt==1) {
								checkFlag = false;
								if(CurPage != 1) {
									CurPage = CurPage -1;
								}
							}
						}
						AddJob_List();
					} else {//
						// 프리뷰창 디스플레이 변경
						doc.getElementsByClassName('preview_nodata')[0].style.display = '';
						doc.getElementsByClassName('previewmail')[0].style.display = 'none';
						
						var leftList = doc.getElementById('lvAddJobList');
						var lstCnt = leftList.children[1].childElementCount;
						var len = rowList.length
						if(lstCnt-len == 0) {
							checkFlag = false;
							if(CurPage != 1) {
								CurPage = CurPage -1;
							}
						}
						rowList = [];
						parent.left.goPage(13);
					}
					//AddJob_List();
					return;
				}
			}

		    function event_Cardlistclick(obj) {
		    	var selectList = document.getElementsByClassName("selectTR");
	    		var className = "selectTR";
	    		
		    	HTMLCollection.prototype.forEach = Array.prototype.forEach;
		    	selectList.forEach(function(item, index) {
		    		if (item.classList) {
		    			item.classList.remove(className);
		    		} else {
		    			item.className = item.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
		    		}
		    	});
		    	
		    	if (obj.classList) {
		    		obj.classList.add(className);
		    	} else {
		    		obj.className += ' ' + className;		    		
		    	}
		    			
		        /* if (!listEventCheckbox) {
		            if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    _RowObject = document.getElementById(listContentArry[Cnt]);
		                    _RowObject.className = "address_boxlist";
		                }
		                listContentArry = new Array();
		            }
		            if (PressShiftKey) {
		                var SelectedPreObj = null;
		                var PrelistContent;
		                
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    _RowObject = document.getElementById(listContentArry[Cnt]);
		                    
		                    if (Cnt == 0) {
		                        SelectedPreObj = _RowObject;
		                    }
		                    _RowObject.className = "address_boxlist";
		                }
		                listContentArry = new Array();
		                
		                if (SelectedPreObj == null) {
		                    PrelistContent = _RowObject.getAttribute("id");
		                } else {
		                    PrelistContent = SelectedPreObj.getAttribute("id");
		                }
		                _RowObject = obj;

		                var CurlistContent = obj.getAttribute("id");
		                var PrePoint = parseInt(PrelistContent.replace("Cardlist_", ""));
		                var CurPoint = parseInt(CurlistContent.replace("Cardlist_", ""));
		                
		                if (PrePoint < CurPoint) {
		                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
		                        _RowObject = document.getElementById("Cardlist_" + Cnt);
		                        _RowObject.className = "address_onboxlist";
		                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
		                    }
		                } else if (PrePoint > CurPoint) {
		                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
		                        _RowObject = document.getElementById("Cardlist_" + Cnt);
		                        _RowObject.className = "address_onboxlist";
		                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
		                    }
		                } else {
		                    return;
		                }
		            } else {
		                _RowObject = obj;
		                var insertFlag = true;
		                
		                for (var i = 0; i < listContentArry.length; i++) {
		                    if (listContentArry[i] == _RowObject.getAttribute("id")) {
		                        insertFlag = false;
		                        
		                        if (PressCtrlKey) {
		                            listContentArry.splice(i, 1);
		                            _RowObject.className = "address_boxlist";
		                        }
		                    }
		                }
		                if (insertFlag) {
		                    _RowObject.className = "address_onboxlist";
		                    listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
		                }
		            }
		        } else {
		            listEventCheckbox = false;
		        } */
		    }
		    
		    var addjob_config_dialogArguments = new Array();
		    function AddJob_Add() {        
		        var Params = new Array();
		        var result = "";
		        
		        //2016-04-25 장진혁과장 -- Cross 버전 선택 주석처리
		        //if (CrossYN()) {
	            addjob_config_dialogArguments[0] = Params;
	            addjob_config_dialogArguments[1] = AddJob_Add_Complete;
	            var OpenWin = window.open("/admin/ezOrgan/addJobConfig.do?companyID=" + document.getElementById("ListCompany").value, "AddJob_Config", GetOpenWindowfeature(970, 600));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
		        /* } else {
		            window.showModalDialog("AddJob_Config.aspx?companyid=" + document.getElementById("ListCompany").value, Params, "dialogHeight:600px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(970, 600));
		            window.location.reload(false);
		        } */
		    }
		    
		    function AddJob_Add_Complete() {
		    	AddJob_List();
		    }
		    
		    var dbClickObj;
		    function User_View(obj) {
		        var listview = new ListView();
		        listview.LoadFromID("lvAddJobList");

		        if (listview.GetSelectedRows().length == 0) {
		            alert(strLang13);
		            return;
		        }

		        var id = listview.GetSelectedRows()[0].getAttribute("DATA1");
		        var name = listview.GetSelectedRows()[0].getAttribute("DATA3");
		        dbClickObj = obj;

		      	//2016-04-25 장진혁과장 -- Cross 버전 선택 주석처리
		        //if (CrossYN()) {
		        flags = false;
	            addjob_config_dialogArguments = new Array();
	            addjob_config_dialogArguments[1] = AddJob_Add_Complete;		            
	            var OpenWin = window.open("/admin/ezOrgan/addJobUserModify.do?userID=" + encodeURI(id) + "&userName=" + encodeURI(name) + "&companyID=" + document.getElementById("ListCompany").value, "AddJob_Config", GetOpenWindowfeature(350, 570));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
		    }
		    
		    function email_onclick() {

		        /* var listview = new ListView();
		        listview.LoadFromID("lvAddJobList"); */

		        /* if (listview.GetSelectedRows().length == 0) {
		            alert(strLang13);
		            return;
		        } */
		        
		        var dataList3 = new Array();
				var dataList4 = new Array();
				
				$("input[name='checks']:checked").each(function(){
					dataList3.push(this.parentElement.parentElement.getAttribute("DATA3"));
					dataList4.push(this.parentElement.parentElement.getAttribute("DATA4"));
				});
				
				// 선택된 사원이 없을 경우
				if (dataList3.length == 0) {
					alert(strLang13);
					return;
				}
				
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var MsgTo = new Array();

		        
		        for (var i =0; i<dataList3.length; i++) {
			        MsgTo[i] = "\"" + dataList3[i]+ "\" <" +dataList4[i]+ ">";
		        }

		        /* 2017-01-02 이효민사원
		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW&msgTo=" + escape(MsgTo), "",
		                        "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        }
		        else {
		            if (pUse_Editor == "") {
		                window.open("/myoffice/ezEmail/mail_write.aspx?cmd=NEW&msgTo=" + escape(MsgTo), "",
		                        "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		            }
		            else {
		                window.open("/myoffice/ezEmail/mail_write_IE.aspx?cmd=NEW&msgTo=" + escape(MsgTo), "",
		                        "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		            }
		        } */
		        window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(MsgTo), "",
                        "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }

			// 2023-06-26 남진구 - '조직도>겸직관리>엑셀 내려받기'
			function excelExport() {
				if (exportingExcel) {
					return;
				}

				showProgress();
				exportingExcel = true;

				$.ajax({
					type: "POST",
					url: "/admin/ezOrgan/exportFileLogs.do",
					data: {
						"selectedId"  : "",
						isAddJob : "Y"
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;

						switch(code) {
							case 0:
								var url = "/admin/ezOrgan/downloadExcel.do?fileName=" + encodeURIComponent(data.path);
								AttachDownFrame.location.href = url;
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t300'/>");
								break;
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				}).complete(function() {
					hideProgress();
					exportingExcel = false;
				});
			}

			function showProgress() {
				// $('#progressPanel').width() = 220, $('#loadingLayer').width() = 168
				var leftSize = (window.innerWidth - 388)/2 + "px"
				document.getElementById("loadingLayer").style.left = leftSize;

				document.getElementById("progressPanel").style.display = "";
				document.getElementById("loadingLayer").style.display = "";

				parent.document.getElementById("left").contentWindow.showProgress();
			}

			function hideProgress() {
				document.getElementById("progressPanel").style.display = "none";
				document.getElementById("loadingLayer").style.display = "none";

				parent.document.getElementById("left").contentWindow.hideProgress();
			}

			// xml data -> input checkbox method
			var cnt;
			var checkbox_header = function() {
				var doc = window.document;
				var th = doc.getElementById("lvAddJobList_TH_0");
				var acList = doc.getElementById("lvAddJobList");
				th.innerHTML = "<input type='checkbox' id = 'checkAll' onchange='checkboxHeaderClick()'></input>";

				cnt = acList.children[1].childElementCount;
				// 데이터가 있을 경우에만
				if(acList.children[1].children[0].id !== 'lvAddJobList_TR_noItems'){
					var i = 0;
					for (i; i < cnt; i++) {
						var seq = acList.children[1].children[i].children[0].innerHTML;
						var jinhangFlag = acList.children[1].children[i].children[5].innerHTML;
						acList.children[1].children[i].children[0].innerHTML = "<input type='checkbox' name='checks' class='checks' id='" + seq + "' value='" + seq + "' onchange='inputFunc(event,"
								+ seq + ")'></input>";
					}
				}
			}

			// 체크박스 헤더 클릭 method
			var checkFlag = false;
			function checkboxHeaderClick() {
				var doc = window.document;
				var acList = doc.getElementById("lvAddJobList");
				// 데이터가 있을 경우에만
				if(acList.children[1].children[0].id !== 'lvAddJobList_TR_noItems'){
					if (checkFlag) {
						checkFlag = false;
						$(".checks").prop("checked", false);
						$("#lvAddJobList tr td").css("background-color", "rgb(255, 255, 255)");
					} else {
						checkFlag = true;
						$(".checks").prop("checked", true);
						$("#lvAddJobList tr td").css("background-color", "rgb(241, 248, 255)");
					}
					checkItems();
				}
			}
			
			var rowList = new Array();
			function checkItems() {
				rowList = [];
				$("input:checkbox[name='checks']").each(function(){
					if($(this).is(":checked")){
						rowList.push(this.value);
					}
				});
			}
			
			function inputFunc(event, itemseq) {
				checkItems();
				
				$("#lvAddJobList tr td").css("background-color", "rgb(255, 255, 255)");

				for (var i = 0; i < rowList.length; i++) {
					var objID = $("#" + rowList[i])[0].parentNode.parentNode.id;
					$("#" + objID + " td").css("background-color", "rgb(241, 248, 255)");
					$("#" + rowList[i]).prop("checked", true);
				}
			}
			
			var itemseq;

			// 사이즈 조절
			function windowResize() {
				var doc = window.document;
				var addJobListView = doc.getElementById("AddJobListView");
				var previewmailDIV = doc.getElementById("previewmail");
				var height = doc.documentElement.clientHeight-170;
				if(height>120) {
					addJobListView.style.height = height + "px";
					previewmailDIV.style.height = height + "px";
				}
			}

			// 등록, 수정 , 삭제 후 rowSelect 선택 method
			function rowListSelect() {
				var len = rowList.length;
				for (var i = 0; i < len; i++) {
					var tempItemSeq = rowList.pop();
					if (document.getElementById(tempItemSeq) != null) {
						$("#" + tempItemSeq).prop("checked", true);
						var tempID = $("#" + tempItemSeq)[0].parentNode.parentNode.id;
						$("#" + tempID + " td").css("background-color",
								"rgb(241, 248, 255)");
					}
				}

				if (checkFlag) {
					$("#checkAll").prop("checked", true);
				} else {
					$("#checkAll").prop("checked", false);
				}
			}
			function searchList() {
				CurPage = 1;
				document.getElementById("searchValue").value = document.getElementById("searchValue").value.toLowerCase();
				AddJob_List();
			}
		    function clearSearchVal () {
		    	$("#searchValue").val("");
		    }

	    </script>
	</head>
	<body class="mainbody">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		    		<HEADER>
						<WIDTH>24</WIDTH>
						<STYLE>border-top:0px;</STYLE>
					</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t218' /></NAME>
		        		<WIDTH>29%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t67' /></NAME>
		        		<WIDTH>20%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t69' /></NAME>
		        		<WIDTH>10%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t68' /></NAME>
		        		<WIDTH>30%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t123' /></NAME>
		        		<WIDTH>10%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	
	    <form id="Form1" method="post">
		    <h1>
		    	<spring:message code='ezOrgan.t00013' />
		    	<span id="mailBoxInfo"></span>
		    	<span class="title_bar"><img src="/images/name_bar.gif"></span>
		    	<select class="companySelect" id="ListCompany" onchange="company_change()">
	            	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
	            </select>
	            
	            <span class="searchForm">
	            	<select id="searchType" class="text"; style="width:80px;height: 27px; margin-right: 0px; border: 1px solid #cbcbcb;">
						<option selected="" value="displayname"><spring:message code='ezOrgan.t67' /></option>
						<option value="cn"><spring:message code='ezOrgan.t218' /></option>
						<option value="description"><spring:message code='ezOrgan.t68' /></option>
					</select>
					
					<input id="searchValue" class="searchinputBox" onkeypress="if(event.keyCode==13) {searchList(); return false;}" onfocus="clearSearchVal();" style="ime-mode: active;height: 27px;border: 1px solid #cbcbcb;">
					<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="searchList()"></a>
				</span>
		    </h1>
		    <div id="mainmenu">
		        <ul style="margin-top:15px">		            
		            <li class="important"><span onClick="AddJob_Add()"><spring:message code='ezOrgan.mse3' /></span></li>
		            <!-- <li style="padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
		            <%-- <li><span onClick="AddJob_Del('ALL', '')"><spring:message code='ezOrgan.t00016' /></span></li> --%>
		            <li><span class="icon16 icon16_delete" onClick="AddJob_Del('ALL', '')"></span></li>
		            <!-- <li><span class="icon16 icon16_delete" onClick="AddJob_Del('DEL', '')"></span></li> -->
					<!-- <li style="padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
					<c:if test="${useExternalMailServer eq 'NO'}">
		            <li onClick="email_onclick()"><span class="icon16 icon16_mail_gray"></span></li>
		            </c:if>
					<li id="btnSave"><span onClick="excelExport()"><spring:message code='ezStatistics.t1003' /></span></li>
		        </ul>
		    </div>
		    <script type="text/javascript">
		        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
		    </script>
		    <div class="portlet_tabpart01" style="padding-bottom:3px">
		        <%-- <div class="portlet_tabpart01_top" id="tab1" style="width:752px;">
	                <p id="AddJob_sub1"><span divname="AddJob1" id="1tab1"><spring:message code='ezOrgan.t00017' /></span></p>               
		        </div> --%>
		    </div> 
		    <table style="width:100%; border-spacing: 10px;">
		        <tr>
		            <td style="width:50%">
		                <div class="listview addJob">
		                    <div id="AddJobListView" style="border: 0px solid #ddd; Height:670px; overflow-x: auto; BACKGROUND-COLOR: white; overflow-y:auto; "></div>
		                    <div id="tblPageRayer" style="Width:100%;text-align:center;"></div>
		                </div>
		            </td>
		            <td class="addJobPreviewTD">
		                 <div id="preview_nodata" class="preview_nodata" style="margin-top: 70px;">
			                  <dl class="nodata_sIcon">
				              <dt><img src="/images/kr/main/noData_sIcon.png"></dt>
				              <dd id="nodata_title"><spring:message code='ezOrgan.mse5'/></dd>
			                  </dl>
		                 </div>
		              <div class="previewmail" id="previewmail" style="Height:670px; overflow-y:auto; ">
		                 <div class="preview_info">
		                     <div id="Preview_HeaderH" style="line-height: 11px;">
						<p class="preview_header">
						   <span class="preview_title" id="preview_title"></span>
						   <span class="preview_title2" id="preview_title2"></span>
						   <span class="preview_count" id="preview_count"></span>
						</p>
		              </div>
		              </div>
		                 <ul class="concurrentUL" id="AddJobList">
		                </ul>
		              </div> 
		            </td>
		        </tr>
		    </table>    
		</form>
		<iframe name="AttachDownFrame" id="AttachDownFrame" style="display:none"></iframe>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
		<span class="loading_layer" style="z-index:6000;position:absolute;top:350px;left:350px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>
	</body>
	<script type="text/javascript">
	    /* Tab1_NewTabIni("tab1"); */
	</script>
</html>