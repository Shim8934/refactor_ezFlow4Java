<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>task_main</title>
		<link type="text/css" rel="stylesheet" href="${util.addVer('/css/olstyle_nonIE.css')}" />
		<link rel="stylesheet" href="${util.addVer('ezTask.e1', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('/css/Tab.css')}" />
		<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>
		<STYLE type="text/css"> 
			.pagetd{padding-top:6px; }
			.pcol{padding-top:6px; }
			.Right_Point01 {
				font:bold;
				color:#017bec;
			}
		</STYLE>
		<script type="text/javascript">
			var delayColor = "<c:out value='${delayColor}'/>";
			var completeColor = "<c:out value='${completeColor}'/>"
			var userid = "<c:out value='${userInfo.id}'/>";
			var listdom = "";
			var pagecount = 0;
			var allCnt = 0;
			var currentpage = 0;
			var pagesize = "<c:out value='${taskGeneralVO.listCount}'/>";
			var changeTab = "<c:out value='${taskGeneralVO.selectTaskStatus}'/>";
			var isrefresh = false;
			var selectelem = null;
			var initdate = "";
		    var startdate = "";
		    var enddate = "";
		    var type = "";
		    var userlang = "<c:out value='${userInfo.lang}'/>";
		    var primary = "<c:out value='${userInfo.primary}'/>";
		    var useTodoMemo = "<c:out value='${useTodoMemo }'/>";
		    var taskFlag = "<c:out value='${taskFlag}' />";
		    var currentTab;
		    
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }

		        var height = parseInt(document.documentElement.clientHeight - 245);

		        document.getElementById("list").style.height = height + "px";
		        
		        if (changeTab == "taskre") {
			        ChangeTab(document.getElementById("1tab3"));
			        $("#1tab3").click();
		        } else if (changeTab == "taskdi") {
		        	ChangeTab(document.getElementById("1tab2"));
		        	$("#1tab2").click();
		        } else {
		        	ChangeTab(document.getElementById("1tab1"));
		        	$("#1tab1").click();
		        }

		        document.getElementById("todo_BODY").style.height = height + "px";
		        scroll();
		        
		        switch(taskFlag) {
		        	case "normal":
		        		ChangeTab(document.getElementById("1tab1"));
		        		//currentTab = "1tab1";
			        	$("#1tab1").click();
			        	break;
		        	case "repeat":
		        		ChangeTab(document.getElementById("1tab3"));
			        	$("#1tab3").click();
			        	break;
		        	case "send":
		        		ChangeTab(document.getElementById("1tab2"));
			        	$("#1tab2").click();
			        	break;
		        }
		        selectelem = "";
		    }
		    
		    document.onselectstart = function () {
		        event.cancelBubble = true;
		        event.returnValue = false;
		    }
		    
		    window.onresize = function () {
		    	if (navigator.userAgent.indexOf("Chrome") > -1) {
		            document.getElementById("todo_BODY").style.height = document.documentElement.clientHeight - 245 + "px";
		            document.getElementById("list").style.height = document.documentElement.clientHeight - 211 + "px";
		    	}
		    	else {
	    	        document.getElementById("todo_BODY").style.height = document.documentElement.clientHeight - 250 + "px";
	    	        document.getElementById("list").style.height = document.documentElement.clientHeight - 216 + "px";
		    	}
    	        scroll();
		    }
		    
// 		    document.onselectstart = function () { return false; };
		    
		    function select_row(elem) {		    
		    	
				if ($("#checkboxAll").is(":checked")) {					
					if ($("input[taskid='" + $(elem).attr("taskid") + "']").prop("checked") == true && selectelem != null) {//전체 선택 후 개별 선택 시 선택한것 해제
						$("input[taskid='" + $(elem).attr("taskid") + "']").prop("checked", false);
						$(".row_body[taskid='" + $(elem).attr("taskid") + "']").css("background", "#ffffff");
						strListInfo = ReplaceText(strListInfo, $(elem).attr("taskID") + ";", "");
			            strListIdInfo = ReplaceText(strListIdInfo, $("input[taskid='" + $(elem).attr("taskid") + "']").attr("creatorid") + ";", "");
			    		return;
					}
					
					// 목록에서 하나씩 다른거 선택할 때
					if ((selectelem != null && selectelem != elem)) {
						strListInfo += $(elem).attr("taskID") + ";";
			            strListIdInfo += $(elem).find("input").attr("creatorID") + ";";
			        	selectelem = null;
			    	}
				} else {					
					// 목록에서 하나씩 다른거 선택할 때
			    	if ((selectelem != null && selectelem != elem)) {
	 					$("input[type=checkbox]").prop("checked", false);
	 					$(".row_body").css("background", "#ffffff");	 					
						strListInfo = $(elem).attr("taskID") + ";";
			            strListIdInfo = $(elem).find("input").attr("creatorID") + ";";			            
			        	selectelem = null;
			    	}
				}

				// 체크 후 체크박스 눌러서 체크 해제할 때
		        if (selectelem != null && selectelem != elem) {
					if ($("#checkboxAll").is(":checked")) {
			        	$("input[taskid='" + $(elem).attr("taskid") + "']").prop("checked", false);
			        	$(".row_body[taskid='" + $(elem).attr("taskid") + "']").css("background", "#ffffff");
						return;
					} else {
			        	selectelem.style.backgroundColor = "#ffffff";
			        	$("input[taskid='" + $(selectelem).attr("taskid") + "']").prop("checked", false);
			            selectelem = null;
			            return;
					}
		        }

		        selectelem = elem;
		        elem.style.backgroundColor = "#f1f8ff";
		        $("input[taskid='" + $(elem).attr("taskid") + "']").prop("checked", true);

		        // 목록화면 나오고 처음 선택할 때 strListInfo 값 셋팅
		        if (strListInfo == "") {
		        	strListInfo = $(elem).attr("taskID") + ";";
		        	strListIdInfo = $(elem).find("input").attr("creatorID") + ";";
		        }		        
		    }

		    /* 2021-03-24 홍승비 - 원클릭으로 업무관리 읽기팝업창 표출 */
		    function ReadTask(elem) {
		        var taskid = GetAttribute(elem.parentElement, "taskid");
		        var repeatcount = GetAttribute(elem.parentElement, "repeatcount");
		        var date = GetAttribute(elem.parentElement, "startdate");
		        var feature = "";
		        
		        if (repeatcount == "") {
		        	repeatcount = 1;
		        }
		        
	        	feature = GetOpenPosition(790, 820);
	        	
                window.open("/ezTask/taskRead.do?taskID=" + taskid + "&repeatCount=" + repeatcount + "&date=" + date, "", "height = 822px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
		    }
	
		    function WriteTask(flag) {
		    	var feature = "";
		    	taskFlag = currentTab;
		    	if (useTodoMemo == 'YES') {
		    		feature = GetOpenPosition(790, 830);
	                window.open("/ezTask/taskWrite.do?flag=" + flag, "", "height=830px, width=790px, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
		    	} else {
		    		feature = GetOpenPosition(790, 775);
	                window.open("/ezTask/taskWrite.do?flag=" + flag, "", "height=775px, width=790px, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
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
			    
			    strtext = "<div class='pagenavi'>";
			    PagingHTML += strtext;
			    var totalPage = totalpage;
			    var pageNum = currentpage;
			    if (totalPage > 1 && pageNum != 1) {
			        strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg first disabled'></span>"
			        PagingHTML += strtext;
			    }
			    if (totalPage > BlockSize) {
			        if (pageNum > BlockSize) {
			            strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='btnimg prev disabled'></span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='btnimg prev disabled'></span>";
			        PagingHTML += strtext;
			    }
			    var MaxNum;
			    var i;
			    var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
			    if (totalPage >= (startNum + parseInt(BlockSize))) {
			        MaxNum = (startNum + parseInt(BlockSize)) - 1;
			    }
			    else {
			        MaxNum = totalPage;
			    }
			    for (i = startNum; i <= MaxNum; i++) {
			        if (i == pageNum) {
			            strtext = "<span class='on'>"+i+"</span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
			            PagingHTML += strtext;
			        }
			    }
		        
		        if (MaxNum == 0) {
		        	PagingHTML += "<span class='on'>" + 1 + "</span>";
		        }
		        
			    if (totalPage > BlockSize) {
			        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
			            strtext = "";
			            strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "";
			            strtext = strtext + "<span class='btnimg next disabled'></span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "";
			        strtext = strtext + "<span class='btnimg next disabled'></span>";
			        PagingHTML += strtext;
			    }
			    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
			        strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg last disabled'></span>";
			        PagingHTML += strtext;
			    }
			    PagingHTML += "</div>";
			    td_Create1(PagingHTML);
			}

			function goToPageByNum(Value) {
				// 페이지 이동할 때 체크되어있는게 있으면 모두 해제
				if ($("#checkboxAll").is(":checked")) {
		    		$("#checkboxAll").prop("checked", false);
		    		$(".row_body").css("background", "");
		    	}

				// 페이지 이동 시 이전에 체크되어있던 값 삭제
				strListIdInfo = "";
				strListInfo = "";

			    currentpage = Value;
			    makePageSelPage();
			    show_page();
			}
	
			function selbeforeBlock() {
			    var pageNum = currentpage;
			    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
			    goToPageByNum(pageNum);
			}
	
			function selbeforeBlock_one() {
			    var pageNum = currentpage;
			    var totalPage = totalpage;
			    if (parseInt(pageNum - 1) > 0) {
			        goToPageByNum(parseInt(pageNum - 1));		    	
			    }
			    else {
			        return;
			    }
			}
	
			function selafterBlock() {
			    var pageNum = currentpage;
			    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
			    goToPageByNum(pageNum);
			}
	
			function selafterBlock_one() {
			    var pageNum = currentpage;
			    var totalPage = totalpage;
			    if (parseInt(pageNum + 1) <= totalPage) {
			        goToPageByNum(parseInt(pageNum + 1));		    	
			    }
			    else {
			        return;		    	
			    }
			}

			var strListInfo = "";
			var strListIdInfo = "";

			function chk_onselect(obj, event) {
				event.stopPropagation();
				if (obj.checked) {
		            strListInfo += $(obj).attr("taskID") + ";";
		            strListIdInfo += $(obj).attr("creatorID") + ";";
		            selectelem = obj.parentNode.parentNode.parentNode;
		            obj.parentNode.parentNode.parentNode.style.backgroundColor = "#edf4fd";
		        } else {
		            strListInfo = ReplaceText(strListInfo, $(obj).attr("taskID") + ";", "");
		            strListIdInfo = ReplaceText(strListIdInfo, $(obj).attr("creatorID") + ";", "");
		            selectelem = null;
		            obj.parentNode.parentNode.parentNode.style.backgroundColor = "#ffffff";
		        }
		    }
			

			function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");		        
		        return (orgStr.replace(re, replaceStr));
		    }

			function show_page() {
// 			    selectelem = null;				
			    var length = list_body2.children[1].rows.length;
			    var progress_th = document.getElementById("_thprogress");
			    var progress_td = document.getElementById("_tdprogress");
				var column_prg = document.getElementById("col_progress");
				var column_prg2 = document.getElementById("col_progress2");
				var flagType = 0;

			    // 리스트 다시 가져올때 기존에 있던 것 삭제
			    for (var i = 3; i < length; i++) {
			        list_body2.children[1].removeChild(list_body2.children[1].rows[3]);			    	
			    }

			    var tr = "";
			    var onTaskCount = 0;   
			    		    
			    if (currentCount == 0) {
			    	 if (type === "3") {
			    		 column_prg.style.width = "0px";
			    		 progress_th.innerHTML = "";
			    	 }
			    	 else {
			    		 column_prg.style.width = "130px";
			    		 column_prg2.style.width = "130px";
			    		 progress_th.innerHTML = "<spring:message code='ezTask.t120' />";
			    	 }
			    }
			    else {
				    for (var i = (currentpage - 1) * pagesize; i < currentpage * pagesize; i++) {
				        if (i == currentCount) {
				        	break;
				        }
				        
				        flagType = 0;
				        
				        var node = GetChildNodesByNodeName(listdom.documentElement, "ROW")[i];
	
				        tr = row_body.cloneNode(true);
				        document.getElementById("tr_ing").style.display = "none";
	
				        tr.style.display = "";
				        tr.id = "taskID_" + SelectSingleNodeValue(node, "TASKID");
	
				        tr.setAttribute("taskid", SelectSingleNodeValue(node, "TASKID"));
				        tr.setAttribute("creatorid", SelectSingleNodeValue(node, "CREATORID"));
	      
				        if (SelectSingleNodeValue(node, "REPEATCOUNT") != "0") {
				        	tr.setAttribute("repeatcount", SelectSingleNodeValue(node, "REPEATCOUNT"));
				        }
			
				        var startdate = SelectSingleNodeValue(node, "STARTDATE").substr(0, 10);
				        var enddate = SelectSingleNodeValue(node, "ENDDATE").substr(0, 10);
				        var taskstatus = SelectSingleNodeValue(node, "TASKSTATUS");
	
				        tr.setAttribute("startdate", startdate);
	
				        tr.cells[0].innerHTML += "<div class='custom_checkbox'><input name='myCheckbox' type='checkbox' taskID='" + SelectSingleNodeValue(node, "TASKID") + "' creatorID='" + SelectSingleNodeValue(node, "CREATORID") + "_" + i + 
				        "'onclick='chk_onselect(this, event)' style='width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle'></div>"
	
				        if (SelectSingleNodeValue(node, "IMPORTANCE") == "3")
				            tr.cells[1].innerHTML += "<img src='/images/ImgIcon/icon-highimportance.gif'>";
				        else if (SelectSingleNodeValue(node, "IMPORTANCE") == "1")
				            tr.cells[1].innerHTML += "<img src='/images/ImgIcon/icon-lowimportance.gif'>";
	
				        tr.cells[1].style.textAlign = "center";
	
				        if (SelectSingleNodeValue(node, "HASATTACH") == "Y")
				            tr.cells[2].innerHTML += "<img src='/images/newAttach.gif' >";
				        else
				            tr.cells[2].innerHTML += "&nbsp;";
	
			            if (SelectSingleNodeValue(node, "TASKTYPE") == 1) {
					        if (primary == "1") {
					            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "CREATORNAME"));
					            tr.cells[3].setAttribute("title", SelectSingleNodeValue(node, "CREATORNAME"));
					        } else {
					            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "CREATORNAME2"));
					            tr.cells[3].setAttribute("title", SelectSingleNodeValue(node, "CREATORNAME2"));
					        }			        	
				        } else {
				        	if (primary == "1") {
					            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "PERSONNAME"));
					            tr.cells[3].setAttribute("title", SelectSingleNodeValue(node, "PERSONNAME"));
					        } else {
					            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "PERSONNAME2"));
					            tr.cells[3].setAttribute("title", SelectSingleNodeValue(node, "PERSONNAME2"));
					        }
				        }
			            
			            tr.cells[3].style.overflow = "hidden";
			            tr.cells[3].style.textOverflow = "ellipsis";
	
			            /* 2018-04-24 김민성 - 업무명 길이 조절 */
			            var commentCount = SelectSingleNodeValue(node, "HASCOMMENT");
				        if (SelectSingleNodeValue(node, "HASCOMMENT") != "0") {
				           // tr.cells[4].innerHTML = "<div id='titleid" + i + "' style='float:left; max-width: 500px; overflow: hidden; text-overflow: ellipsis; display: block;'>" + SelectSingleNodeValue(node, "TITLE") + "</div>" + "<div style='display: block;'><font color = '#c64200'>&nbsp;[" + commentCount + "]</font></div>"; 
				            tr.cells[4].innerHTML = "<div id='titleid" + i + "' style='float:left; overflow: hidden; text-overflow: ellipsis; display: block; max-width: 100%;'>" + MakeXMLString(SelectSingleNodeValue(node, "TITLE")) + "</div><font color = '#c64200'>&nbsp;[" + commentCount + "]</font>";
				            tr.cells[4].setAttribute("title", SelectSingleNodeValue(node, "TITLE") + " [" + commentCount + "]");
				        } else {
				        	// tr.cells[4].innerHTML = SelectSingleNodeValue(node, "TITLE");
				        	tr.cells[4].innerHTML = "<div id='titleid" + i + "' style='float:left; overflow: hidden; text-overflow: ellipsis; display: block; max-width: 100%;'>" + MakeXMLString(SelectSingleNodeValue(node, "TITLE")) + "</div>";
				            tr.cells[4].setAttribute("title", SelectSingleNodeValue(node, "TITLE"));
	
				            //tr.cells[4].style.overflow = "hidden";
				            //tr.cells[4].style.textOverflow = "ellipsis";
				        }
	
				        if (useTodoMemo == "YES") {
					        setNodeText(tr.cells[6], SelectSingleNodeValue(node, "MEMO"));
					        tr.cells[6].style.overflow = "hidden";
					        tr.cells[6].style.textOverflow = "ellipsis";
					        tr.cells[6].setAttribute("title", SelectSingleNodeValue(node, "MEMO"));
				        }
	
				        var div = document.createElement("DIV");
				        div.style.width = "72px";
		                div.style.lineHeight = "18px";
		                div.style.height = "17px";
		                div.style.textAlign = "center";
		                div.style.color = "white";
		                div.style.verticalAlign = "top";
	
				        switch (SelectSingleNodeValue(node, "TASKTYPE")) {
				            case "1":
				            case "4":
				                div.style.background = "url(/images/icon/section_Individualbg.png)";
				                break;
				            case "2":			            			            	
				                div.style.background = "url(/images/icon/section_orderbg.png)";
				                break;
				            case "3":				            
				                div.style.background = "url(/images/icon/section_Cooperativebg.png)";
				                break;
				            case "5":
				            	flagType = 1;
				                div.style.background = "url(/images/icon/section_orderbg.png)";
				                break;
				            case "6":
				            	flagType = 1;
				                div.style.background = "url(/images/icon/section_Cooperativebg.png)";
				                break;				            	
				        }
	
				        tr.cells[7].appendChild(div);
				        
				        if (type !== "3") {			        	
				    		column_prg.style.width = "130px";
				    		column_prg2.style.width = "130px";
				    		progress_th.innerHTML = "<spring:message code='ezTask.t120' />";
				        	var completerate = SelectSingleNodeValue(node, "COMPLETERATE");
					        var span = document.createElement("SPAN");
					        span.className = "workProgressBar";
					        span.innerHTML += "<span class='bar' taskID='taskProgressBar" + i + "'></span>&nbsp;"
	
							var span2 = document.createElement("SPAN");
					        span2.style.display = "inline-block";
					        span.appendChild(span2);
					        tr.cells[8].appendChild(span);  				        
					        
					        setNodeText(tr.cells[9], startdate);
					        tr.cells[10].innerHTML = "<B>" + enddate + "</B>";
					        list_body2.children[1].appendChild(tr);
					        
					        if (type == "2" && flagType == 1) {
					        	span.innerHTML= "<spring:message code='ezTask.t999' />";
					        }
					        else {
					        	initProgressBar("taskProgressBar" + i, taskstatus, completerate);
					        }
					        
					        /* 2018-04-24 김민성 - 업무명 길이 조절 */
					        /* if (useTodoMemo == 'YES') {
								if ($("#titleid" + i + "").outerWidth() > 900) {
									$("#titleid" + i + "").css("vertical-align", "middle").css("overflow", "hidden").css("textOverflow", "ellipsis").css("display", "inline-block").css("width", "100%");
								} else {
							        //$("#titleid" + i + "").css("width", $("#titleid" + i + "").outerWidth());
								} 
					        } else {
								if ($("#titleid" + i + "").outerWidth() > 1000) {
									$("#titleid" + i + "").css("vertical-align", "middle").css("overflow", "hidden").css("textOverflow", "ellipsis").css("display", "inline-block").css("width", "100%");
								} else {
							        //$("#titleid" + i + "").css("width", $("#titleid" + i + "").outerWidth());
								} 
					        } */
	
							if (taskstatus == '4' && completerate == '0') {
								$(".bar[taskid=taskProgressBar" + i + "]").find(".percentCount").css("color", delayColor);
							}
				        }
				        else {			        	
				    		column_prg.style.width = "0px";
				    		progress_th.innerHTML = "";				
				    		column_prg2.style.width = "0px";
				    		progress_td.innerHTML = "";		
					        setNodeText(tr.cells[9], startdate);
					        tr.cells[10].innerHTML = "<B>" + enddate + "</B>";
					        list_body2.children[1].appendChild(tr);
				        }
				        
						onTaskCount++;
					}
			    }
			    
			    if (onTaskCount == 0) {
			    	

					var notRep = "<td colspan='11' style='padding-top:4px;height:24px'><spring:message code='ezTask.t204' /></td>";

					var rep = "<td colspan='11' style='padding-top:4px;height:24px'><spring:message code='ezTask.t200912' /></td>";
					
					var toSend = "<td colspan='11' style='padding-top:4px;height:24px'><spring:message code='ezTask.t200915' /></td>";

			    	$('#tr_ing').empty();
					
		            if ($(".tabon").attr("divname") == "taskrepetition") {
		            	$('#tr_ing').append(rep);	
		            } else if ($(".tabon").attr("divname") == "taskdictate") {
		            	$('#tr_ing').append(toSend);
		            } else {
		            	$('#tr_ing').append(notRep);	
		            }
		            
		            document.getElementById("tr_ing").style.display = "";
		            
			    }

			    scroll();
			    $(".progressbar").css("display", "inline-table");	
			    
			}

			/* progressBar 조회 */
			function initProgressBar(barID, taskstatus, completerate) {
				if (completerate == '0') {
					duration = 0;
				} else {
					duration = 500;
				}

				if (taskstatus == '4') {
					$(".bar[taskid='" + barID + "']").find("div[class=percentCount]").css("color", delayColor);
					$(".bar[taskid='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: delayColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else if (taskstatus == '3') {
					$(".bar[taskid='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: completeColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else {
					$(".bar[taskid='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: '#3498db',
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				}
			}

			// 진행중, 완료 리스트 따로가져오기 위한 값
			var taskStatusCount = "";
			function selectTab(num) {
				if (num == 3) {
					taskStatusCount = 3;
				} else if (num == 2) {
					taskStatusCount = 2;
				} else {
					taskStatusCount = 1;
				}

				filter = document.getElementById("txt_keyword").value;

				if (filter != "") {
					search();
				} else {
					DateChange();
				}
			}

		    function page_move(which, evt) {
		        if (CrossYN()) {
		            if (which == 0) {
		                if (evt.which == 13) {
		                    var newpage = txt_page.value;
		                    if (parseInt(newpage) == newpage) {
		                        newpage = parseInt(newpage);
		
		                        if (newpage > 0 && newpage <= totalpage) {
		                            currentpage = newpage;
		                            show_page();
		                        }
		                    }
		                }
		            }
		            else if (currentpage + which > 0 && currentpage + which <= totalpage) {
		                currentpage = currentpage + which;
		                show_page();
		            }
		        }
		        else {
		            if (which == 0) {
		                if (window.event.keyCode == 13) {
		                    var newpage = txt_page.value;
		                    if (parseInt(newpage) == newpage) {
		                        newpage = parseInt(newpage);
		
		                        if (newpage > 0 && newpage <= totalpage) {
		                            currentpage = newpage;
		                            show_page();
		                        }
		                    }
		                }
		            }
		            else if (currentpage + which > 0 && currentpage + which <= totalpage) {
		                currentpage = currentpage + which;
		                show_page();
		            }
		        }
		    }
		    function RefreshView() {
		        isrefresh = true;
		        selectelem = null;
		        if(filter !== "" ) {
		        	searchFlag = true;
		        }
		        DateChange();
		    }
			
		    function DeleteTask() {
		        if (strListIdInfo == null || strListIdInfo == "") {
		            alert("<spring:message code='ezTask.t104' />");
		            return;
		        }

				var idArr = new Array(); 
				idArr = strListIdInfo.split(";");
				if (idArr.length < 1) {
		            alert("<spring:message code='ezTask.t104' />");
		            return;
		        }

				var loc = "";
				var idArrList = new Array();
				for (var i = 0; i < idArr.length - 1; i++) {
					loc = idArr[i].indexOf("_");
					idArrList += idArr[i].substring(0, loc) + ";";
				}

				idArr = null;
				idArr = idArrList.split(";");

				for (var i = 0; i < idArr.length - 1; i++) {
					if (idArr[i] != userid) {
			            alert("<spring:message code='ezTask.t146' />");

			            return;
			        }
				}							

				if (confirm("<spring:message code='ezTask.t106' />")) {
					$.ajax({
						type : "POST",
						dataType : "json",
						url : "/ezTask/taskDelete.do",
						data : {
							taskIDList : strListInfo
						},
						success : function() {
							RefreshView();
						},
						error : function() {
							alert("<spring:message code='ezTask.t107' />");
						}
					})
				}
		    }

		    function DateChange() {
		        var filter = "";
		        var chkValue = "";
				
		        getTaskList();
		    }

		    var cnt, cnt2, cnt3;
		    function after_DateChange(xml) {
	            listdom = loadXMLString(xml);

// 	            totalcount = GetChildNodes(listdom.documentElement).length - 3;
	            currentCount = GetChildNodes(listdom.documentElement).length - 4;
	            totalpage = Math.ceil(new Number(currentCount / pagesize));

	            if (isrefresh) {
	                isrefresh = false;	            	
	            } else {
	                currentpage = 1;
	            }

	            if (currentpage > totalpage) {
	                currentpage = totalpage;	            	
	            }

	            if (currentpage == 0) {
	                currentpage = 1;	            	
	            }

	            
	            if(!searchFlag){
	            	cnt = getNodeText(listdom.documentElement.getElementsByTagName("CNT")[0]);
		            cnt2 = getNodeText(listdom.documentElement.getElementsByTagName("CNT2")[0]);
		            cnt3 = getNodeText(listdom.documentElement.getElementsByTagName("CNT3")[0]);
		            allCnt = getNodeText(listdom.documentElement.getElementsByTagName("ALLCNT")[0]);
	            }
	            
	            // 왼쪽메뉴 카운트 수
	            if ($(".tabon").attr("divname") == "taskprog") {
	            	document.getElementById("1tab1").innerHTML = "<spring:message code='ezTask.t200901' />" + " (" + currentCount + ")";
		            document.getElementById("1tab2").innerHTML = "<spring:message code='ezTask.t200903' />" + " (" + cnt2 + ")";
		            document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t200902' />" + " (" + cnt3 + ")";
		            $(".sort_radio").show();
	            } else if ($(".tabon").attr("divname") == "taskdictate") {
	            	document.getElementById("1tab1").innerHTML = "<spring:message code='ezTask.t200901' />" + " (" + cnt + ")";
		            document.getElementById("1tab2").innerHTML = "<spring:message code='ezTask.t200903' />" + " (" + currentCount + ")";
		            document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t200902' />" + " (" + cnt3 + ")";
		            $(".sort_radio").show();
	            } else {
	            	document.getElementById("1tab1").innerHTML = "<spring:message code='ezTask.t200901' />" + " (" + cnt + ")";
		            document.getElementById("1tab2").innerHTML = "<spring:message code='ezTask.t200903' />" + " (" + cnt2 + ")";
		            document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t200902' />" + " (" + currentCount + ")";
		            $(".sort_radio").show();
	            }
	            
	            // 업무 작성, 삭제시 카운트 refresh
	            switch (currentTab) {
		            case "normal":
		                type = "1";
		                cnt = getNodeText(listdom.documentElement.getElementsByTagName("CNT")[0]);
		                document.getElementById("presentcell").innerHTML = "<spring:message code='ezTask.t200901' />";
		                document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + currentCount + "</span>";
		                currentTab = "normal";
		                if(chkValue === "memo") {
		                	cnt = currentCount;
		                }
		                break;
		            case "send":
		                type = "2";
		                cnt2 = getNodeText(listdom.documentElement.getElementsByTagName("CNT2")[0]);
		                document.getElementById("presentcell").innerHTML = "<spring:message code='ezTask.t200903' />";
		                document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + currentCount + "</span>";
		                currentTab = "send";
		                if(chkValue === "memo") {
		                	cnt2 = currentCount;
		                }
		                break;
		            case "repeat":
		                type = "3";
		                cnt3 = getNodeText(listdom.documentElement.getElementsByTagName("CNT3")[0]);
		                document.getElementById("presentcell").innerHTML = "<spring:message code='ezTask.t200902' />";
		                document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + currentCount + "</span>";
		                currentTab = "repeat"
		                if(chkValue === "memo") {
			                cnt3 = currentCount;
						}
		                break;
		        }
				
	            show_page();
	            makePageSelPage();
	            window.parent.frames["left"].cntLoad();
	            searchFlag = false;
	            return;
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
		
		    var Tab1_SelectID = "";
		    var Tab1_flag = true;
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id) {
		            obj.className = "";
		        } else {
		        	obj.className = "tabon";
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
		    
		    var pSelectTab;
		    function ChangeTab(obj) {
		        pSelectTab = GetAttribute(obj, "divname");

		        switch (pSelectTab) {
		            case "taskprog":
		                type = "1";
		                document.getElementById("presentcell").innerHTML = "<spring:message code='ezTask.t200901' />";
		                document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + cnt + "</span>";
		                currentTab = "normal";
		                break;
		            case "taskdictate":
		                type = "2";
		                document.getElementById("presentcell").innerHTML = "<spring:message code='ezTask.t200903' />";
		                document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + cnt2 + "</span>";
		                currentTab = "send";
		                break;
		            case "taskrepetition":
		                type = "3";
		                document.getElementById("presentcell").innerHTML = "<spring:message code='ezTask.t200902' />";
		                document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + cnt3 + "</span>";
		                currentTab = "repeat"
		                break;
		        }

		        $("#checkRadio2").click();
		    }

		    function onkeydown_start_search(evt) {
		        if (evt.keyCode == "13") {
		            search();
		        }
		    }
		    
		    function keyword_Clear() {
		        document.getElementById('txt_keyword').value = "";
		    }

		    var chkValue = "";
		    var filter = "";
		    searchFlag = false;
		    function search() {
		        if ($.trim($("#txt_keyword").val()) == "") {
		        	alert("<spring:message code='ezTask.t990' />");
		            return;
		        }
		        
		        chkValue = $("#formId option:selected").val();

		       /*  for (var i = 0; i < document.getElementsByName("searchCheck").length; i++) {
		            if (document.getElementsByName("searchCheck")[i].checked == true)
		                chkValue = document.getElementsByName("searchCheck")[i].value;
		        } */

		        filter = document.getElementById("txt_keyword").value;

		        if (filter.indexOf("%") != -1) {
		            alert("'%'" + "<spring:message code='ezTask.jsh08' />");
		            return;
		        }
		        
		        searchFlag = true;
		        getTaskList();
		    }
		    
		    function getTaskList() {		    	
		    	if ($("#checkboxAll").is(":checked")) {
		    		$("#checkboxAll").prop("checked", false);
		    		$(".row_body").css("background", "");
		    	}
		    	
		    	/* 2020-09-15 홍승비 - 제목과 메모는 특수문자를 그대로 저장하도록 수정되어 주석처리 */
		    	/* 18-05-07 김민성 - 특수문자 검색 수정 */
		    	//filter = MakeXMLString(filter);
		    	
		    	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezTask/taskGetList.do",
					data : {
						startDate : "",
						endDate : "",
						type : type,
						filter : filter,
						chkValue : chkValue,
						searchClass : "",
						taskStatusCount : taskStatusCount,
						useDate : "",
						pSelectTab : pSelectTab
					},
					success : function(xml) {
						after_DateChange(xml);
					},
					error : function() {
						alert("<spring:message code='ezTask.t992' />");
					}
				});

				strListInfo = "";
				strListIdInfo = "";
		    }

		    function selectAll() {
				$(selectelem).css("background", "#ffffff");

				var deleteList = [];
				var deleteListID = [];			
				if ($("#checkboxAll").is(":checked")) {
					strListIdInfo = "";
					strListInfo = "";

					$(":checkbox[name=myCheckbox]").prop("checked", true);
					$(".row_body").css("background", "#f1f8ff");

					$(":checkbox[name=myCheckbox]:checked").each(function(){
						deleteList.push($(this).attr("creatorid") + ";");
						deleteListID.push($(this).attr("taskID") + ";")
					});

					for (var i = 0; i < deleteList.length; i++) {
						strListIdInfo += deleteList[i];
						strListInfo += deleteListID[i];
					}
				} else {
					strListIdInfo = "";
					strListInfo = "";
					selectelem = null;

					$(":checkbox[name=myCheckbox]").prop("checked", false);
					$(".row_body").css("background", "");
				}
		    }
		    
		    function scroll() {
		    	var BoardList_BODYHeight = document.getElementById("list_body2").clientHeight;
		    	var BoardListDivHeight = document.getElementById("list").clientHeight;
		    	
		    	 if (BoardList_BODYHeight + 34 < BoardListDivHeight) {
		    		if ($("#todo_HEAD tr th#forScroll").length > 0) {
		    			$("#todo_HEAD tr th#forScroll").remove();
		    		}
		    	} else {
		    		if ($("#todo_HEAD tr th#forScroll").length < 1) {
		    			
		    			$("#todo_HEAD tr").append("<th></th>");
		    			
		    				var lastTh = $("#todo_HEAD tr th").last();
		    				lastTh.attr("id", "forScroll");
		    				lastTh.css("width", "8px");
		    		}
		    	}
		    }
		</script>
	</head>
	<body class="mainbody">
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	
		<h1><span id="presentcell"></span><span id="mailBoxInfo"></span>
		    <span class="searchForm">
		    <!-- 2018-07-17 구해안 라디오박스 검색창 select box로 변경 및 스타일 다른 모듈과 같도록 수정-->
			    <select id="formId" class="text" name="searchCheck" style="width:80px; height:27px; border-color: #c8c8c8;">
			    	<option id="Radio2" value="title"><spring:message code='ezTask.t118' /></option>
			    	<option id="Radio1" value="personName"><spring:message code='ezTask.t2005' /></option>
			    	<option id="Radio3" value="creatorname"><spring:message code='ezTask.t162' /></option>
			    	<option id="Radio4" value="memo"><spring:message code='ezTask.t170' /></option>
			    </select>
		         <%--  <input name="searchCheck" id="Radio2" type="radio" value="title" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle "><label for="Radio2" style="vertical-align:middle">&nbsp;<spring:message code='ezTask.t118' /></label>
		          <input name="searchCheck" id="Radio1" type="radio" value="personName"  style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle "><label for="Radio1" style="vertical-align:middle">&nbsp;<spring:message code='ezTask.t2005' /></label> --%>				  
				  <input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
		          <a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search()"></a>
		    </span>
		</h1>
		
		<div class="portlet_tabpart01" id="portlet_tabpart01" style="margin-top:3px;text-align:right;display:none">
		    <div class="portlet_tabpart01_top" id="tab1">
		        <p><span id="1tab1" divname="taskprog"><spring:message code='ezTask.t200901' /></span></p>
		        <p><span id="1tab3" divname="taskrepetition"><spring:message code='ezTask.t200902' /></span></p>
		        <p><span id="1tab2" divname="taskdictate"><spring:message code='ezTask.t200903' /></span></p>		        
		    </div>
		    <br />
		</div>
		<div id="mainmenu">
			<ul>
				<!-- 2018-05-24 구해안 이미지 이동 -->
				<li class="important"><span id="pn_img" onClick="WriteTask('right')"><spring:message code='ezTask.t113' /></span></li>
				<li onClick="DeleteTask()"><span class="icon16 icon16_delete"></span></li>
				<li onClick="RefreshView()"><span class="icon16 icon16_refresh"></span></li>

				<!-- 완료 -->
				<li id="right" class="sort_radio" style="float:right;font-weight:normal;color:black;padding-right: 7px;">
					<div class="custom_radio">
						<input name="check" id="checkRadio1" type="radio" value="finish" onClick="selectTab(1)" style="width:13px;height:13px;vertical-align:middle ">
						<label for="checkRadio1" style="vertical-align:middle"><spring:message code='ezTask.t9001' /></label>
					</div>
				</li>

				<!-- 진행중 -->
				<li id="right" class="sort_radio" style="float:right;font-weight:normal;color:black;margin-right:5px">
					<div class="custom_radio">
						<input name="check" id="checkRadio2" type="radio" value="ongoing" checked onClick="selectTab(2)" style="width:13px;height:13px;vertical-align:middle ">
						<label for="checkRadio2" style="vertical-align:middle"><spring:message code='ezTask.t98' /></label>
					</div>
				</li>

				<!-- 전체보기 -->
				<li id="right" class="sort_radio" style="float:right;font-weight:normal;color:black;margin-right:5px">
					<div class="custom_radio">
						<input name="check" id="checkRadio3" type="radio" value="all" onClick="selectTab(3)" style="width:13px;height:13px;vertical-align:middle ">
						<label for="checkRadio3" style="vertical-align:middle"><spring:message code='ezTask.jsh07' /></label>
					</div>
				</li>

			</ul>
		</div>
		
		<script type="text/javascript">
			//selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table style="WIDTH: 100%;" id="list">
			<tr>
				<td style="WIDTH: 100%;HEIGHT: 100%;vertical-align:top">
					<%-- 2018-04-24 김민성 - 업무명, 메모 길이 조절  --%>
					<div>
					<table class="mainlist" id="list_body" style="WIDTH: 100%;table-layout:fixed; min-width:800px;">
						<col style ="width:30px;">
						<col style ="width:50px;">
						<col style ="width:20px;">
						<col style ="width:100px;">
						<c:if test="${useTodoMemo == 'YES'}">
							<col style = "width:80%;">
							<col style ="width:30px;">
							<col style ="width:25%;">
						</c:if>
						<c:if test="${useTodoMemo == 'NO'}">
							<col style = "width:80%;">
							<col style = "width:30px;">
							<col style = "width:25%;">
						</c:if>
		                <col style ="width:120px;">
						<col style ="width:130px;" id="col_progress">
						<col style ="width:120px;">
						<col style ="width:120px;">
						<tbody id="todo_HEAD">
						<tr>
							<th style="text-align:center"><div class="custom_checkbox"><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding: 0px; margin-top: 0px; margin: 0px; vertical-align:middle;"/></div></th>
							<th style="text-align:center;"><img src="/images/ImgIcon/view-importance.gif"></th>
							<th ><img src="/images/newAttach.gif"></th>
							<th ><spring:message code='ezTask.t2005' /></th>
							<th ><spring:message code='ezTask.t118' /></th>
							<th ></th>
							<c:if test="${useTodoMemo == 'YES'}">
								<th ><spring:message code='ezTask.t170' /></th>
							</c:if>
							<c:if test="${useTodoMemo == 'NO'}">
								<th ></th>
							</c:if>
		                    <!-- 18-05-24 김민성 - 중요도 이미지로 수정 -->
		                    <th style="padding-left:14px"><spring:message code='ezTask.t2003'/></th>		                    
							<th id="_thprogress"  style="text-align:center;padding-right: 12px;"><spring:message code='ezTask.t120' /></th>						
							<th style="text-align:center;"><spring:message code='ezTask.t121'/></th>
							<th style="text-align:center;"><spring:message code='ezTask.t9002'/></th>
						</tr>
						</tbody>
						<tr class="row_body" id="row_body" style="display:none;" startdate="" onclick="select_row(this);">
							<td class="tr_Read" style="white-space:nowrap;cursor:pointer;text-align:center;" ondblclick="ReadTask(this);"></td>
							<td class="tr_Read" style="white-space:nowrap;cursor:pointer;text-align:center;" ondblclick="ReadTask(this);"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this);"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this);"></td>
		                    <td class="tr_Read" style="cursor:pointer;white-space:nowrap;" onclick="ReadTask(this);"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this);"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this);"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;text-align:center;" ondblclick="ReadTask(this);"></td>							
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;text-align:center;" id="_tdprogress" ondblclick="ReadTask(this);"></td>							
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;text-align:center;" ondblclick="ReadTask(this);"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;text-align:center;" ondblclick="ReadTask(this);"></td>
						</tr>
				    </table>
				    </div>
				    <div id="todo_BODY" style="overflow-y:auto;">
				    <table class="mainlist" id="list_body2" style="WIDTH: 100%;table-layout:fixed; min-width:800px;">
						<col style ="width:30px;">
						<col style ="width:50px;">
						<col style ="width:20px;">
						<col style ="width:100px;">
						<c:if test="${useTodoMemo == 'YES'}">
							<col style = "width:80%;">
							<col style ="width:30px;">
							<col style ="width:25%;">
						</c:if>
						<c:if test="${useTodoMemo == 'NO'}">
							<col style = "width:80%;">
							<col style = "width:30px;">
							<col style = "width:25%;">
						</c:if>
		                <col style ="width:120px;">
						<col style ="width:130px;" id="col_progress2">
						<col style ="width:120px;">
						<col style ="width:120px;">
						<tr id="tr_ing" style="text-align:center;">
							<td colspan="11" style="padding-top:4px;height:24px"><spring:message code='ezTask.t204' /></td>
						</tr>
						<tr id="tr_rep" style="text-align:center;display:none;">
							<td colspan="11" style="padding-top:4px;height:24px"><spring:message code='ezTask.t200912' /></td>
						</tr>
						<tr id="tr_send" style="text-align:center;display:none;">
							<td colspan="11" style="padding-top:4px;height:24px"><spring:message code='ezTask.t200915' /></td>
						</tr>
				    </table>
				    </div>
				</td>
				<td style="width:5px;">&nbsp;</td>
				<td style="vertical-align:top;width:182px"></td>
			</tr>
		</table>
		
		<div id="tblPageRayer"></div>
	</body>
</html>