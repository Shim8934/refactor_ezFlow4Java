<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>task_main</title>
		<link type="text/css" rel="stylesheet" href="/css/olstyle_nonIE.css" />
		<link rel="stylesheet" href="<spring:message code='ezTask.e1' />" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<link type="text/css" rel="stylesheet" href="/css/Tab.css" />
		<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
		<STYLE type="text/css"> 
		.pagetd{padding-top:6px; }
		.pcol{padding-top:6px; }
		.Right_Point01 {
		font:bold;
		color:#017bec;
		}
		</STYLE>
		<script type="text/javascript">
			var delayColor = "${delayColor}";
			var completeColor = "${completeColor}"
			var userid = "${userInfo.id}";
			var listdom = "";
			var pagecount = 0;
			var totalcount = 0;
			var currentpage = 0;
			var pagesize = 10;
			var isrefresh = false;
			var selectelem = null;
			var initdate = "";
			var ownerid = "";
		    var offSetNum = "timeZoneStr";
		    var startdate = "";
		    var enddate = "";
		    var type = "";
		    var userlang = "${userInfo.lang}";
		    var pUse_Editor = "Use_Editor";
		    var primary = "${userInfo.primary}";
		    var useTodoMemo = "${useTodoMemo }";
		    document.onselectstart = function () { return false; };
		    function select_row(elem) {
		    	// 전체체크박스 선택 후 목록에서 하나 선택 시 전체체크 해제
				if ($("#checkboxAll").is(":checked")) {
					$("input[type=checkbox]").prop("checked", false);
		    		$(".row_body td").css("background", "");
		    		strListInfo = "";
		    		strListIdInfo = "";
				}

				if ($("#checkboxAll2").is(":checked")) {
					$("input[type=checkbox]").prop("checked", false);
		    		$(".row_body2 td").css("background", "");
		    		strListInfo = "";
		    		strListIdInfo = "";
				}

				if ($("#checkboxAll3").is(":checked")) {
					$("input[type=checkbox]").prop("checked", false);
		    		$(".row_body3 td").css("background", "");
		    		strListInfo = "";
		    		strListIdInfo = "";
				}

				// 목록에서 하나씩 다른거 선택할 때
		    	if (selectelem != null) { 		
			    	if (selectelem != elem) {
						$("input[type=checkbox]").prop("checked", false);
// 						$(selectelem).siblings("input[type=checkbox]").prop("checked", false);
// 						$(".row_body").css("background", "#ffffff");
// 						$(".row_body2").css("background", "#ffffff");
						$(selectelem).css("background", "#ffffff");
						$(selectelem).siblings().css("background", "#ffffff");
						strListInfo = $(elem).attr("taskID") + ";";
			            strListIdInfo = $(elem).find("input").attr("creatorID") + ";";
						
			        	selectelem = null;
			    	}
		    	}

				// 체크 후 체크박스 눌러서 체크 해제할 때
		        if (selectelem != null) {
		        	selectelem.style.backgroundColor = "#ffffff";
		        	$("input[taskid='" + $(selectelem).attr("taskid") + "']").prop("checked", false);
		            selectelem = null;
		            return;
		        }

		        selectelem = elem;
		        elem.style.backgroundColor = "rgb(233, 241, 244)";
		        $("input[taskid='" + $(elem).attr("taskid") + "']").prop("checked", true);

		        // 목록화면 나오고 처음 선택할 때 strListInfo 값 셋팅
		        if (strListInfo == "") {
		        	strListInfo = $(elem).attr("taskID") + ";";
		        	strListIdInfo = $(elem).find("input").attr("creatorID") + ";";
		        }
		    }

		    function ReadTask(elem) {
		        var taskid = GetAttribute(elem.parentElement, "taskid");
		        var parentid = GetAttribute(elem.parentElement, "parentid");
		        var date = GetAttribute(elem.parentElement, "startdate")
		        var feature = "";
		        
		        if (parentid != "0")
		            taskid = parentid;
		        
	        	feature = GetOpenPosition(780, 640);
	        	
	        	if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/ezTask/taskRead.do?taskID=" + taskid, "", "height = 640px, width = 750px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        } else {
		            if (pUse_Editor == "" || pUse_Editor == "CK") {
		                window.open("/ezTask/taskRead.do?taskID=" + taskid, "", "height = 640px, width = 750px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            } else {
		                window.open("/ezTask/taskRead.do?taskID=" + taskid, "", "height = 640px, width = 750px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            }
		        }
		    }
	
		    function WriteTask() {
		    	var feature = "";
		    	
		    	if (useTodoMemo == 'YES') {
		    		feature = GetOpenPosition(780, 940);
	                window.open("/ezTask/taskWrite.do", "", "height=940px, width=780px, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
		    	} else {
		    		feature = GetOpenPosition(780, 885);
	                window.open("/ezTask/taskWrite.do", "", "height=885px, width=780px, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
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
			    document.getElementById("mailBoxInfo").innerHTML = " - [" + "<spring:message code='ezTask.t109' />" + "<span style='color:#017BEC;'> " + totalcount + "</span>" + "<spring:message code='ezTask.t110' />" + "]";
			    strtext = "<div class='pagenavi'>";
			    PagingHTML += strtext;
			    var totalPage = totalpage;
			    var pageNum = currentpage;
			    if (totalPage > 1 && pageNum != 1) {
			        strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
			        PagingHTML += strtext;
			    }
			    if (totalPage > BlockSize) {
			        if (pageNum > BlockSize) {
			            strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezTask.t997' />" + "</span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezTask.t997' />" + "</span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezTask.t997' />" + "</span>";
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
			    if (totalPage > BlockSize) {
			        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezTask.t998' />" + "</span>";
			            strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezTask.t998' />" + "</span>";
			            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezTask.t998' />" + "</span>";
			        strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
			        strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    PagingHTML += "</div>";
			    td_Create1(PagingHTML);
			}

			function goToPageByNum(Value) {
				// 페이지 이동할 때 체크되어있는게 있으면 모두 해제
				if ($("#checkboxAll").is(":checked")) {
		    		$("#checkboxAll").prop("checked", false);
		    		$(".row_body td").css("background", "");
		    	}

		    	if ($("#checkboxAll2").is(":checked")) {
		    		$("#checkboxAll2").prop("checked", false);
		    		$(".row_body2 td").css("background", "");
		    	}

		    	if ($("#checkboxAll3").is(":checked")) {
		    		$("#checkboxAll3").prop("checked", false);
		    		$(".row_body3 td").css("background", "");
		    	}

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

			function chk_onselect(obj) {
				if (obj.checked) {
		            strListInfo += $(obj).attr("taskID") + ";";
		            strListIdInfo += $(obj).attr("creatorID") + ";";
		            selectelem = null;
		        } else {	        	
		            strListInfo = ReplaceText(strListInfo, $(obj).attr("taskID") + ";", "");
		            strListIdInfo = ReplaceText(strListIdInfo, $(obj).attr("creatorID") + ";", "");
		            selectelem = obj.parentNode.parentNode;
		        }
		    }

			function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");		        
		        return (orgStr.replace(re, replaceStr));
		    }

			function show_page() {
			    selectelem = null;
			    makePageSelPage();

			    var length = list_body.children[1].rows.length;
			    var length2 = list_body2.children[1].rows.length;
			    var length3 = list_body3.children[1].rows.length;

			    // 리스트 다시 가져올때 기존에 있던 것 삭제
			    for (var i = 3; i < length; i++) {
			        list_body.children[1].removeChild(list_body.children[1].rows[3]);			    	
			    }

			    for (var i = 3; i < length2; i++) {
			        list_body2.children[1].removeChild(list_body2.children[1].rows[3]);			    	
			    }

			    for (var i = 3; i < length3; i++) {
			        list_body3.children[1].removeChild(list_body3.children[1].rows[3]);
			    }

			    var tr = "";
			    var onTaskCount = 0; // 진행중업무 Count
			    var finishTaskCount = 0; // 완료업무 Count
			    var allTaskCount = 0; // 전체업무 Count

			    for (var i = (currentpage - 1) * pagesize; i < currentpage * pagesize; i++) {
			    	if (totalcount == 0 || i == totalcount) {
			            break;
			        }
			        var node = GetChildNodesByNodeName(listdom.documentElement, "ROW")[i];

					if (type == 1) { // 개인
						if (showAll == 0) {
					        if (SelectSingleNodeValue(node, "COMPLETERATE") != 100) {
						        tr = row_body.cloneNode(true);
						        document.getElementById("tr_ing").style.display = "none";
					        } else {
					        	tr = row_body2.cloneNode(true);
						        document.getElementById("tr_ing2").style.display = "none";
					        }
						} else {
							tr = row_body3.cloneNode(true);
					        document.getElementById("tr_ing3").style.display = "none";
						}
					} else { // 지시, 협조
						if (showAll == 0) {
					        if (SelectSingleNodeValue(node, "COMPLETERATE") != 100) {
						        tr = row_body.cloneNode(true);
						        document.getElementById("tr_ing").style.display = "none";
					        } else {
					        	tr = row_body2.cloneNode(true);
						        document.getElementById("tr_ing2").style.display = "none";
					        }
						} else {
							tr = row_body3.cloneNode(true);
					        document.getElementById("tr_ing3").style.display = "none";
						}
					}

			        tr.style.display = "";
			        tr.id = "taskID_" + SelectSingleNodeValue(node, "TASKID");

			        tr.setAttribute("taskid", SelectSingleNodeValue(node, "TASKID"));
			        tr.setAttribute("parentid", SelectSingleNodeValue(node, "PARENTID"));
			        tr.setAttribute("creatorid", SelectSingleNodeValue(node, "CREATORID"));
		
			        var startdate = SelectSingleNodeValue(node, "STARTDATE").substr(0, 10);
			        var enddate = SelectSingleNodeValue(node, "ENDDATE").substr(0, 10);
			        var taskstatus = SelectSingleNodeValue(node, "TASKSTATUS");

			        tr.setAttribute("startdate", startdate);

			        tr.cells[0].innerHTML += "<input name='myCheckbox' type='checkbox' taskStatus='" + taskstatus + "' taskID='" + SelectSingleNodeValue(node, "TASKID") + "' creatorID='" + SelectSingleNodeValue(node, "CREATORID") + "_" + i + 
			        "'onclick='chk_onselect(this)' style='width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle'>"

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
				            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "TASKPERSONNAME"));
				            tr.cells[3].setAttribute("title", SelectSingleNodeValue(node, "TASKPERSONNAME"));
				        } else {
				            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "TASKPERSONNAME2"));
				            tr.cells[3].setAttribute("title", SelectSingleNodeValue(node, "TASKPERSONNAME2"));
				        }
			        }
		            
		            tr.cells[3].style.overflow = "hidden";
		            tr.cells[3].style.textOverflow = "ellipsis";

			        if (SelectSingleNodeValue(node, "HASCOMMENT") != "0") {
			            tr.cells[4].innerHTML = SelectSingleNodeValue(node, "TITLE") + "<font color = '#c64200'>&nbsp;&nbsp[" + SelectSingleNodeValue(node, "HASCOMMENT") + "]</font>";;
			        } else {
			            setNodeText(tr.cells[4], SelectSingleNodeValue(node, "TITLE"));
			        }
			        tr.cells[4].style.overflow = "hidden";
			        tr.cells[4].style.textOverflow = "ellipsis";
			        
			        if (useTodoMemo == "YES") {
				        setNodeText(tr.cells[6], SelectSingleNodeValue(node, "MEMO"));
				        tr.cells[6].style.overflow = "hidden";
				        tr.cells[6].style.textOverflow = "ellipsis";
				        tr.cells[6].setAttribute("title", SelectSingleNodeValue(node, "MEMO"));
			        }
		
			        switch (SelectSingleNodeValue(node, "TASKTYPE")) {
			            case "1":
			                var div = document.createElement("DIV");
			                div.style.background = "url(/images/icon/section_Individualbg.gif)";
			                div.style.width = "72px";
			                div.style.lineHeight = "18px";
			                div.style.height = "17px";
			                div.style.textAlign = "center";
			                div.style.color = "white";
			                div.style.verticalAlign = "top";
			                tr.cells[7].appendChild(div);
			                break;
			            case "2":
			                var div = document.createElement("DIV");
			                div.style.background = "url(/images/icon/section_orderbg.gif)";
			                div.style.width = "72px";
			                div.style.lineHeight = "18px";
			                div.style.height = "17px";
			                div.style.textAlign = "center";
			                div.style.color = "white";
			                div.style.verticalAlign = "top";
			                tr.cells[7].appendChild(div);
			                break;
			            case "3":
			                var div = document.createElement("DIV");
			                div.style.background = "url(/images/icon/section_Cooperativebg.gif)";
			                div.style.width = "72px";
			                div.style.lineHeight = "18px";
			                div.style.height = "17px";
			                div.style.textAlign = "center";
			                div.style.color = "white";
			                div.style.verticalAlign = "top";
			                tr.cells[7].appendChild(div);
			                break;
			        }

			        var completerate = SelectSingleNodeValue(node, "COMPLETERATE");
			        var span = document.createElement("SPAN");
			        span.className = "workProgressBar";
			        span.innerHTML += "<span class='bar' taskID='taskProgressBar" + i + "'></span>&nbsp;"

					var span2 = document.createElement("SPAN");
			        span2.style.width = "30px";
			        span2.style.display = "inline-block";
			        setNodeText(span2, completerate + "%");

			        span.appendChild(span2);

			        tr.cells[8].appendChild(span);
			        setNodeText(tr.cells[9], startdate);
			        tr.cells[10].innerHTML = "<B>" + enddate + "</B>";

			        if (showAll == 0) {
				        if (SelectSingleNodeValue(node, "COMPLETERATE") != 100) {
					        list_body.children[1].appendChild(tr);
					        onTaskCount++;
				        } else {
				        	list_body2.children[1].appendChild(tr);
				        	finishTaskCount++;
				        }
			        } else {
			        	list_body3.children[1].appendChild(tr);
			        	allTaskCount++;
			        }

			        initProgressBar("taskProgressBar" + i, taskstatus, completerate);
				}

			    if (onTaskCount == 0) {
			        document.getElementById("tr_ing").style.display = "";
			    }

			    if (finishTaskCount == 0) {
			        document.getElementById("tr_ing2").style.display = "";			    	
			    }

			    if (allTaskCount == 0) {
			        document.getElementById("tr_ing3").style.display = "";
			    }

			    $(".progressbar").css("display", "inline-table");
			    $(".percentCount").remove();
			}

			/* progressBar 조회 */
			function initProgressBar(barID, taskstatus, completerate) {
				if (completerate == '0') {
					duration = 0;
				} else {
					duration = 500;
				}

				if (taskstatus == '4') {
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
			// 전체보기
			var showAll = "";
			function selectTab(num) {
				if (num == 3) {
					showAll = 1;
					taskStatusCount = 2;
					filter = document.getElementById("txt_keyword").value

					if (filter != "") {
						search();
					} else {
						DateChange();
					}

					list_body.style.display = "none";
					list_body2.style.display = "none";
					list_body3.style.display = "";
				} else if (num == 2) {
					showAll = 0;
					taskStatusCount = 0;
					filter = document.getElementById("txt_keyword").value

					if (filter != "") {
						search();
					} else {
						DateChange();
					}

					list_body.style.display = "";
					list_body2.style.display = "none";
					list_body3.style.display = "none";
				} else if (num == 1) {
					showAll = 0;
					taskStatusCount = 1;
					filter = document.getElementById("txt_keyword").value

					if (filter != "") {
						search();
					} else {
						DateChange();
					}

					list_body.style.display = "none";
					list_body2.style.display = "";
					list_body3.style.display = "none";
				} else {
					if ($("input[value=ongoing]").is(":checked")) {
						taskStatusCount = 0;
					} else {
						taskStatusCount = 1;
					}

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

		        DateChange();
		    }

		    var deltaskid = "";
		    var delparentid = "";
		    var delrepeatcount = "";
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
		</script>
		<script>
		    function v_AppendZero(v_str) {
		        if (isNaN(v_str)) {
		            switch (v_str.toString().length) {
		                case 0:
		                    return "00";
		                case 1:
		                    return "0" + v_str.toString();
		                default:
		                    return v_str.toString();
		            }
		        }
		
		        if (v_str < 10) {
		            return "0" + v_str.toString();
		        }
		
		        return v_str.toString();
		    }

		    function DateChange() {
		    	// 전체체크 후 다른거선택 후 다시 돌아왔을 때 체크되어있는것 해제
		    	if ($("#checkboxAll").is(":checked")) {
		    		$("#checkboxAll").prop("checked", false);
		    		$(".row_body td").css("background", "");
		    	}

		    	if ($("#checkboxAll2").is(":checked")) {
		    		$("#checkboxAll2").prop("checked", false);
		    		$(".row_body2 td").css("background", "");
		    	}

		    	if ($("#checkboxAll3").is(":checked")) {
		    		$("#checkboxAll3").prop("checked", false);
		    		$(".row_body3 td").css("background", "");
		    	}

		        var filter = "";
		        var chkValue = "";
		        var searchClass = "";

				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezTask/taskGetList.do",
					data : {
						startDate : startdate,
						endDate : enddate,
						app : 1,
						type : type,
						filter : filter,
						chkValue : chkValue,
						searchClass : searchClass,
						taskStatusCount : taskStatusCount
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

		    function after_DateChange(xml) {
	            listdom = loadXMLString(xml);

	            totalcount = GetChildNodes(listdom.documentElement).length - 2;
	            totalpage = Math.ceil(new Number(totalcount / pagesize));

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

	            var cnt = getNodeText(listdom.documentElement.getElementsByTagName("CNT")[0]);
	            var cnt2 = getNodeText(listdom.documentElement.getElementsByTagName("CNT2")[0]);

	            show_page();
	            makePageSelPage();

	            document.getElementById("1tab1").innerHTML = "<spring:message code='ezTask.t2007' />" + " (" + cnt + ")";
	            document.getElementById("1tab2").innerHTML = "<spring:message code='ezTask.t2008' />" + " (" + cnt2 + ")";

	            return;
		    }

		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }

		        var height = parseInt(document.documentElement.clientHeight - 200);

		        document.getElementById("list").style.height = height + "px";
		        ChangeTab(document.getElementById("1tab1"));
		    }
		    document.onselectstart = function () {
		        event.cancelBubble = true;
		        event.returnValue = false;
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
		        if (Tab1_SelectID != obj.id)
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
		    	var num = "";
		        var pSelectTab = GetAttribute(obj, "divname");

		        if (filter != "") {
		        	num = 2;
		        } else {
		        	num = 0;
		        }

		        switch (pSelectTab) {
		            case "taskprog":
		                type = "1";
						selectTab(num);
		                break;
		            case "taskdictate":
		                type = "2";
						selectTab(num);
		                break;
		        }

		        $("#radio5").click();
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
		    function search() {
		        if ($.trim($("#txt_keyword").val()) == "") {
		        	alert("<spring:message code='ezTask.jsh01' />");
		            return;
		        }

		        for (var i = 0; i < document.getElementsByName("searchCheck").length; i++) {
		            if (document.getElementsByName("searchCheck")[i].checked == true)
		                chkValue = document.getElementsByName("searchCheck")[i].value;
		
		        }

		        filter = document.getElementById("txt_keyword").value;

		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezTask/taskGetList.do",
					data : {
						startDate : startdate,
						endDate : enddate,
						app : 1,
						type : type,
						filter : filter,
						chkValue : chkValue,
						taskStatusCount : taskStatusCount
					},
					success : function(xml) {
						after_DateChange(xml);
					},
					error : function() {
						alert("<spring:message code='ezTask.t992' />");
					}
				});
		    }
		    function after_search() {
		        if (xmlHTTP2.readyState == 4 && xmlHTTP2 != null) {
		
		            listdom = loadXMLString(xmlHTTP2.responseText);
		            totalcount = GetChildNodes(listdom.documentElement).length - 1;
		            totalpage = Math.ceil(new Number(totalcount / pagesize));
		
		            if (isrefresh)
		                isrefresh = false;
		            else
		                currentpage = 1;
		
		            if (currentpage > totalpage)
		                currentpage = totalpage;
		
		            if (currentpage == 0)
		                currentpage = 1;
		
		            makePageSelPage();
		            show_page();
		            var cnt = getNodeText(listdom.documentElement.getElementsByTagName("CNT")[0]);
		            if (type == "1") {
		                document.getElementById("1tab1").innerHTML = "<spring:message code='ezTask.t2007' />" + " (" + cnt + ")";
		            } else {
		                document.getElementById("1tab2").innerHTML = "<spring:message code='ezTask.t2008' />" + " (" + cnt + ")";   	
		            }

		            xmlHTTP2 = null;
		            return;
		        }
		    }
		    
		    function selectAll() {
		    	$(".row_body td").css("background", "");

				var deleteList = [];
				var deleteListID = [];			
				if ($("#checkboxAll").is(":checked")) {
					strListIdInfo = "";
					strListInfo = "";

					if ($("#checkboxAll").is(":checked")) {
						$(":checkbox[taskstatus != 3]").prop("checked", true);
						$(".row_body td").css("background", "rgb(233, 241, 244)");
					} else {
						$(":checkbox[taskstatus != 3]").prop("checked", false);
						$(".row_body td").css("background", "");
						selectelem = null;
					}
					
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
					$("input[type=checkbox]").prop("checked", false);
					$(".row_body").css("background", "");
				}
		    }
		    
		    function selectAll2() {
		    	$(".row_body2 td").css("background", "");

				var deleteList = [];
				var deleteListID = [];

				if ($("#checkboxAll2").is(":checked")) {
					strListIdInfo = "";
					strListInfo = "";

					if ($("#checkboxAll2").is(":checked")) {
						$(":checkbox[taskstatus = 3]").prop("checked", true);
						$(".row_body2 td").css("background", "rgb(233, 241, 244)");
					} else {
						$(":checkbox[taskstatus = 3]").prop("checked", false);
						$(".row_body2 td").css("background", "");
						selectelem = null;
					}
					
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
					$("input[type=checkbox]").prop("checked", false);
					$(".row_body2").css("background", "");
				}
		    }

		    function selectAll3() {
		    	$(".row_body3 td").css("background", "");

				var deleteList = [];
				var deleteListID = [];

				if ($("#checkboxAll3").is(":checked")) {
					strListIdInfo = "";
					strListInfo = "";

					if ($("#checkboxAll3").is(":checked")) {
						$(".row_body3 td input[type = checkbox]").prop("checked", true);
						$(".row_body3 td").css("background", "rgb(233, 241, 244)");
					} else {
						$(".row_body3 td input[type = checkbox]").prop("checked", false);
						$(".row_body3 td").css("background", "");
						selectelem = null;
					}
					
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
					$("input[type=checkbox]").prop("checked", false);
					$(".row_body3").css("background", "");
				}
		    }
		</script>
	</head>
	<body class="mainbody">
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	
		<h1><spring:message code='ezTask.t84' /><span id="mailBoxInfo"></span>
		    <span style="float:right;font-weight:normal;color:black;">
		          <input name="searchCheck" id="Radio2" type="radio" value="title" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle "><label for="Radio2" style="vertical-align:middle"><spring:message code='ezTask.t118' /></label>
		          <input name="searchCheck" id="Radio1" type="radio" value="TaskPersonName"  style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle "><label for="Radio1" style="vertical-align:middle"><spring:message code='ezTask.t2005' /></label>
				  &nbsp;
				  <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search(event)" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
		          <a href="#"><img src="/images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search()"></a>
		    </span>
		</h1>
		<div class="portlet_tabpart01" style="margin-top:3px;text-align:right">
		    <div class="portlet_tabpart01_top" id="tab1">
		        <p><span id="1tab1" divname="taskprog"><spring:message code='ezTask.t2007' /></span></p>
		        <p><span id="1tab2" divname="taskdictate"><spring:message code='ezTask.t2008' /></span></p>
		    </div>
		</div>
		<br />
		<div id="mainmenu">
			<ul>
				<li><span id="pn_img" onClick="WriteTask()"><spring:message code='ezTask.t113' /></span></li>
				<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
				<li><span onClick="DeleteTask()"><spring:message code='ezTask.t115' /></span></li>
				<li><span onClick="RefreshView()"><spring:message code='ezTask.t116' /></span></li>

				<!-- 진행중 -->
				<li id="right" style="float:right;font-weight:normal;color:black;padding-right: 20px;">
					<input name="check" id="radio4" type="radio" value="finish" onClick="selectTab(1)" style="width:13px;height:13px;vertical-align:middle ">
					<label for="radio4" style="vertical-align:middle"><spring:message code='ezTask.t99' /></label>
				</li>

				<!-- 완료 -->
				<li id="right" style="float:right;font-weight:normal;color:black;">
					<input name="check" id="radio3" type="radio" value="ongoing" onClick="selectTab(2)" style="width:13px;height:13px;vertical-align:middle ">
					<label for="radio3" style="vertical-align:middle"><spring:message code='ezTask.t98' /></label>
				</li>

				<!-- 전체보기 -->
				<li id="right" style="float:right;font-weight:normal;color:black;">
					<input name="check" id="radio5" type="radio" value="ongoing" checked onClick="selectTab(3)" style="width:13px;height:13px;vertical-align:middle ">
					<label for="radio5" style="vertical-align:middle"><spring:message code='ezTask.jsh07' /></label>
				</li>

			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table style="WIDTH: 100%;overflow:AUTO;" id="list">
			<tr>
				<td style="WIDTH: 100%;HEIGHT: 100%;vertical-align:top">

					<!-- 진행중 -->
					<table class="mainlist" id="list_body" style="WIDTH: 100%;table-layout:fixed;">
						<col style ="width:30px;">
						<col style ="width:50px;">
						<col style ="width:20px;">
						<col style ="width:100px;">
						<col >
						<col style ="width:50px;">
						<col style ="width:140px;">
		                <col style ="width:90px;">
						<col style ="width:110px;">
						<col style ="width:80px;">
						<col style ="width:97px;">
						<tr>
							<th ><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle"/></th>
							<th ><spring:message code='ezTask.t156' /></th>
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
		                    <th ><spring:message code='ezTask.t2003' /></th>
							<th ><spring:message code='ezTask.t120' /></th>
							<th ><spring:message code='ezTask.t121' /></th>
							<th ><spring:message code='ezTask.t122' /></th>
						</tr>
						<tr class="row_body" id="row_body" style="display:none;" repeatcount="0" startdate="" onclick="select_row(this)">
							<td class="tr_Read" style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
		                    <td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
						</tr>
						<tr id="tr_ing" style="text-align:center">
							<td colspan="11" style="padding-top:4px;height:24px"><spring:message code='ezTask.t204' /></td>
						</tr>
				    </table>

				    <!-- 완료 -->
				    <table class="mainlist" id="list_body2" style="WIDTH: 100%;table-layout:fixed; display:none">
						<col style ="width:30px;">
						<col style ="width:50px;">
						<col style ="width:20px;">
						<col style ="width:100px;">
						<col >
						<col style ="width:50px;">
						<col style ="width:140px;">
		                <col style ="width:90px;">
						<col style ="width:110px;">
						<col style ="width:80px;">
						<col style ="width:97px;">
						<tr>
							<th ><input id="checkboxAll2" type="checkbox" onclick="selectAll2()" taskstatus="3" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle"/></th>
							<th ><spring:message code='ezTask.t156' /></th>
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
		                    <th ><spring:message code='ezTask.t2003' /></th>
							<th ><spring:message code='ezTask.t120' /></th>
							<th ><spring:message code='ezTask.t121' /></th>
							<th ><spring:message code='ezTask.t122' /></th>
						</tr>
						<tr class="row_body2" id="row_body2" style="display:none;" repeatcount="0" startdate="" onclick="select_row(this)">
							<td class="tr_Read" style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
		                    <td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
						</tr>
						<tr id="tr_ing2" style="text-align:center">
							<td colspan="11" style="padding-top:4px;height:24px"><spring:message code='ezTask.t204' /></td>
						</tr>
				    </table>

				    <!-- 전체 -->
				    <table class="mainlist" id="list_body3" style="WIDTH: 100%;table-layout:fixed; display:none">
						<col style ="width:30px;">
						<col style ="width:50px;">
						<col style ="width:20px;">
						<col style ="width:100px;">
						<col >
						<col style ="width:50px;">
						<col style ="width:140px;">
		                <col style ="width:90px;">
						<col style ="width:110px;">
						<col style ="width:80px;">
						<col style ="width:97px;">
						<tr>
							<th ><input id="checkboxAll3" type="checkbox" onclick="selectAll3()" taskstatus="3" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle"/></th>
							<th ><spring:message code='ezTask.t156' /></th>
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
		                    <th ><spring:message code='ezTask.t2003' /></th>
							<th ><spring:message code='ezTask.t120' /></th>
							<th ><spring:message code='ezTask.t121' /></th>
							<th ><spring:message code='ezTask.t122' /></th>
						</tr>
						<tr class="row_body3" id="row_body3" style="display:none;" repeatcount="0" startdate="" onclick="select_row(this)">
							<td class="tr_Read" style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
		                    <td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
						</tr>
						<tr id="tr_ing3" style="text-align:center">
							<td colspan="11" style="padding-top:4px;height:24px"><spring:message code='ezTask.t204' /></td>
						</tr>
				    </table>

				</td>
				<td style="width:5px;">&nbsp;</td>
				<td style="vertical-align:top;width:182px"></td>
			</tr>
		</table>
		<div id="tblPageRayer"></div>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>