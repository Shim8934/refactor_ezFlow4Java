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
			var delaycolor = "_delaycolor";
			var completecolor = "_completecolor";
			var userid = "${userInfo.id}";
			var listdom = "";
			var pagecount = 0;
			var totalcount = 0;
			var currentpage = 0;
			var pagesize = 10;
			var isrefresh = false;
			var selectelem = null;
			var initdate = "_initdate";
			var ownerid = "";
		    var offSetNum = "timeZoneStr";
		    var startdate = "_initdate";
		    var enddate = "_initdate";
		    var type = "";
		    var userlang = "${userInfo.lang}";
		    var pUse_Editor = "Use_Editor";
		    var primary = "${userInfo.primary}";
		    document.onselectstart = function () { return false; };
		    function select_row(elem) {
		        if (selectelem != null) {
		            selectelem.style.backgroundColor = "#ffffff";
		        }
	
		        selectelem = elem;
		        selectelem.style.backgroundColor = "#DBE1E7";
		    }
	
		    function ReadTask(elem) {
		        var taskID = GetAttribute(elem.parentElement, "taskid");
		        var parentid = GetAttribute(elem.parentElement, "parentid");
// 		        var repeatcount = GetAttribute(elem.parentElement, "repeatcount")
		        var date = GetAttribute(elem.parentElement, "startdate")
		        var feature = GetOpenPosition(780, 920);
		        if (parentid != "0")
		            taskid = parentid;

		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/ezTask/taskRead.do?taskID=" + taskID, "", "height = 935px, width = 780px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        } else {
		            if (pUse_Editor == "" || pUse_Editor == "CK") {
		                window.open("/ezTask/taskRead.do?taskID=" + taskID, "", "height = 935px, width = 780px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            } else {
		                window.open("/ezTask/taskRead.do?taskID=" + taskID, "", "height = 935px, width = 780px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            }
		        }
		    }
	
		    function WriteTask() {
                var feature = GetOpenPosition(760, 660);
                window.open("/ezTask/taskWrite.do", "", "height=715px, width=760px, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
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
		        } else {
		            strListInfo = ReplaceText(strListInfo, $(obj).attr("taskID") + ";", "");
		            strListIdInfo = ReplaceText(strListIdInfo, $(obj).attr("creatorID") + ";", "");
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
			    
			    for (var i = 3; i < length; i++) {
			        list_body.children[1].removeChild(list_body.children[1].rows[3]);			    	
			    }

			    for (var i = (currentpage - 1) * pagesize; i < currentpage * pagesize; i++) {
			    	if (totalcount == 0 || i == totalcount) {
			            break;
			        }

			        document.getElementById("tr_ing").style.display = "none";
			        var node = GetChildNodesByNodeName(listdom.documentElement, "ROW")[i];

			        var tr = row_body.cloneNode(true);

			        tr.style.display = "";
			        tr.id = "";
		
			        tr.setAttribute("taskid", SelectSingleNodeValue(node, "TASKID"));
			        tr.setAttribute("parentid", SelectSingleNodeValue(node, "PARENTID"));
			        tr.setAttribute("creatorid", SelectSingleNodeValue(node, "CREATORID"));

			        if (SelectSingleNode(node, "REPEATCOUNT") != null)
			            tr.setAttribute("repeatcount", SelectSingleNodeValue(node, "REPEATCOUNT"));
		
			        var startdate = SelectSingleNodeValue(node, "STARTDATE").substr(0, 10);
			        var enddate = SelectSingleNodeValue(node, "ENDDATE").substr(0, 10);

			        tr.setAttribute("startdate", startdate);

			        tr.cells[0].innerHTML += "<input type='checkbox' taskID='" + SelectSingleNodeValue(node, "TASKID") + "' creatorID='" + SelectSingleNodeValue(node, "CREATORID") + "'onclick='chk_onselect(this)' style='width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle'>"

			        if (SelectSingleNodeValue(node, "IMPORTANCE") == "3")
			            tr.cells[1].innerHTML += "<img src='/images/ImgIcon/icon-highimportance.gif'>";
			        else if (SelectSingleNodeValue(node, "IMPORTANCE") == "1")
			            tr.cells[1].innerHTML += "<img src='/images/ImgIcon/icon-lowimportance.gif'>";

			        tr.cells[1].style.textAlign = "center";

			        if (SelectSingleNodeValue(node, "HASATTACH") == "Y")
			            tr.cells[2].innerHTML += "<img src='/images/newAttach.gif' >";
			        else
			            tr.cells[2].innerHTML += "&nbsp;";
		
			        if (primary == "1") {
			            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "PERSONNAME"));
			        }
			        else {
			            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "PERSONNAME2"));
			        }
		
			        if (SelectSingleNodeValue(node, "HASCOMMENT") != "N") {
			            tr.cells[4].innerHTML = SelectSingleNodeValue(node, "TITLE") + "<font color = '#c64200'>&nbsp;&nbsp[" + SelectSingleNodeValue(node, "HASCOMMENT") + "]</font>";;
			        }
			        else
			            setNodeText(tr.cells[4], SelectSingleNodeValue(node, "TITLE"));
			        tr.cells[4].style.overflow = "hidden"
			        tr.cells[4].style.textOverflow = "ellipsis"
		
			        switch (SelectSingleNodeValue(node, "TASKTYPE")) {
			            case "1":
			                var div = document.createElement("DIV");
			                div.style.background = "url(/images/icon/section_Cooperativebg.gif)";
			                div.style.width = "72px";
			                div.style.lineHeight = "18px";
			                div.style.height = "17px";
			                div.style.textAlign = "center";
			                div.style.color = "white";
			                setNodeText(div, "<spring:message code='ezTask.t2000' />");
			                tr.cells[6].appendChild(div);
			                break;
			            case "2":
			                var div = document.createElement("DIV");
			                div.style.background = "url(/images/icon/section_orderbg.gif)";
			                div.style.width = "72px";
			                div.style.lineHeight = "18px";
			                div.style.height = "17px";
			                div.style.textAlign = "center";
			                div.style.color = "white";
			                setNodeText(div, "<spring:message code='ezTask.t2001' />");
			                tr.cells[6].appendChild(div);
			                break;
			            case "3":
			                var div = document.createElement("DIV");
			                div.style.background = "url(/images/icon/section_Individualbg.gif)";
			                div.style.width = "72px";
			                div.style.lineHeight = "18px";
			                div.style.height = "17px";
			                div.style.textAlign = "center";
			                div.style.color = "white";
			                setNodeText(div, "<spring:message code='ezTask.t2002' />");
			                tr.cells[6].appendChild(div);
			                break;
			        }

			        // ì§íë¨ê³
// 			        switch (SelectSingleNodeValue(node, "TASKSTATUS")) {
// 			            case "1":
// 			                var div = document.createElement("DIV");
// 			                div.style.background = "url(/images/icon/status_nothing.gif)";
// 			                div.style.width = "61px";
// 			                div.style.lineHeight = "18px";
// 			                div.style.height = "17px";
// 			                div.style.textAlign = "center";
// 			                div.style.color = "white";
// 			                setNodeText(div, "<spring:message code='ezTask.t97' />"); 
// 			                tr.cells[4].appendChild(div);
// 			                break;
// 			            case "2":
// 			                var div = document.createElement("DIV");
// 			                div.style.background = "url(/images/icon/status_working.gif)";
// 			                div.style.width = "61px";
// 			                div.style.lineHeight = "18px";
// 			                div.style.height = "17px";
// 			                div.style.textAlign = "center";
// 			                div.style.color = "white";
// 			                setNodeText(div, "<spring:message code='ezTask.t98' />"); 
// 			                tr.cells[4].appendChild(div);
// 			                break;
// 			            case "3":
// 			                var div = document.createElement("DIV");
// 			                div.style.background = "url(/images/icon/status_finish.gif)";
// 			                div.style.width = "61px";
// 			                div.style.lineHeight = "18px";
// 			                div.style.height = "17px";
// 			                div.style.textAlign = "center";
// 			                div.style.color = "white";
// 			                setNodeText(div, "<spring:message code='ezTask.t99' />"); 
// 			                tr.cells[4].appendChild(div);
// 			                break;
// 			            case "4":
// 			                var div = document.createElement("DIV");
// 			                div.style.background = "url(/images/icon/status_delay.gif)";
// 			                div.style.width = "61px";
// 			                div.style.lineHeight = "18px";
// 			                div.style.height = "17px";
// 			                div.style.textAlign = "center";
// 			                div.style.color = "white";
// 			                setNodeText(div, "<spring:message code='ezTask.t100' />"); 
// 			                tr.cells[4].appendChild(div);
// 			                break;
// 			        }

			        var taskstatus = SelectSingleNodeValue(node, "TASKSTATUS");
			        var completerate = SelectSingleNodeValue(node, "COMPLETERATE");
			        var span = document.createElement("SPAN");
			        span.className = "workProgressBar";
			        span.innerHTML += "<span class='bar' taskID='taskProgressBar" + i + "'></span>&nbsp;"

					var span2 = document.createElement("SPAN");
			        span2.style.width = "30px";
			        span2.style.display = "inline-block";
			        setNodeText(span2, completerate + "%");

			        span.appendChild(span2);

			        tr.cells[7].appendChild(span);
			        setNodeText(tr.cells[8], startdate);
			        tr.cells[9].innerHTML = "<B>" + enddate + "</B>";

			        if (SelectSingleNodeValue(node, "TASKSTATUS") == "4") {
			            for (var j = 2; j < 9; j++)
			                tr.cells[j].style.color = delaycolor;
			        }

			        if (SelectSingleNodeValue(node, "TASKSTATUS") == "3") {
			            for (var j = 2; j < 9; j++)
			                tr.cells[j].style.color = completecolor;
			        }

			        list_body.children[1].appendChild(tr);

			        initProgressBar("taskProgressBar" + i, taskstatus, completerate);
				}

			    if (totalcount == 0) {
			        document.getElementById("tr_ing").style.display = "";
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

			function selectTab(num) {
				if (num == 2) {
					list_body.style.display = "";
					list_body2.style.display = "none";
				} else {
					list_body.style.display = "none";
					list_body2.style.display = "";
				}
			}

		    function update_status(elem) {
		        var taskid = GetAttribute(elem.parentElement.parentElement, "taskid")
		        var parentid = GetAttribute(elem.parentElement.parentElement, "parentid");
		        var repeatcount = GetAttribute(elem.parentElement.parentElement, "repeatcount");
		
		        if (parentid != "0") {
		            alert("<spring:message code='ezTask.t101' />");
		            return;
		        }
		
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		
		        var objRoot, objNode;
		        objRoot = createNodeInsert(xmlDom, objRoot, "DATA");
		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TASKID", taskid);
		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "REPEATCOUNT", repeatcount);
		        if (elem.checked == true) {
		            objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TASKSTATUS", "3");
		            objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "COMPLETERATE", "100");
		        }
		        else {
		            objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TASKSTATUS", "1");
		            objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "COMPLETERATE", "0");
		        }
		
		
		        xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_update_instance.aspx", false);
		        xmlHTTP.send(xmlDom);
		
		        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
		            alert("<spring:message code='ezTask.t102' />");
		        else
		            RefreshView();
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
		        DateChange(startdate, enddate);
		    }
		    function MoveTask() {
		        if (selectelem == null) {
		            alert("<spring:message code='ezTask.t103' />");
		            return;
		        }
		
		        var taskid = selectelem.taskid;
		        var repeatcount = selectelem.repeatcount;
		        var date = selectelem.startdate;
		
		        var feature = GetOpenPosition(790, 660);
		        if (CrossYN()) {
		            var win = window.open("/myoffice/ezSchedule/schedule_write_CK.aspx?taskid=" + taskid + "&datetype=2&sdate=" + date + " 00:00&edate=" + date + " 23:30", "",
		            "height = 660px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        }
		        else {
		            var win = window.open("/myoffice/ezSchedule/schedule_write.aspx?taskid=" + taskid + "&datetype=2&sdate=" + date + " 00:00&edate=" + date + " 23:30", "",
		            "height = 660px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        }
		    }

		    var deltaskid = "";
		    var delparentid = "";
		    var delrepeatcount = "";
		    function DeleteTask() {
		        if (selectelem == null) {
		            alert("<spring:message code='ezTask.t104' />");
		            return;
		        }

		        deltaskid = GetAttribute(selectelem, "taskid")
		        delparentid = GetAttribute(selectelem, "parentid");
// 		        delrepeatcount = GetAttribute(selectelem, "repeatcount");
		        var creatorId = GetAttribute(selectelem, "creatorid");

				var idArr = new Array();
				idArr = strListIdInfo.split(";");

				for (var i = 0; i < idArr.length - 1; i++) {
			        if (idArr[i] != userid) {
			            alert("<spring:message code='ezTask.t146' />");

			            return;
			        }
				}

		        if (delparentid != "0") {
		            alert("<spring:message code='ezTask.t105' />");
		            return;
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
		    function v_MoveToSelectedDate(v_kind, v_movNum, v_dateStr) {
		        var tmpdt = new Date(v_dateStr);
		        switch (v_kind) {
		            case 'd':
		                tmpdt.setDate(tmpdt.getDate() + v_movNum);
		                break;
		            case 'm':
		                tmpdt.setMonth(tmpdt.getMonth() + v_movNum);
		                break;
		            case 'y':
		                tmpdt.setFullYear(tmpdt.getFullYear() + v_movNum);
		                break;
		        }
		        return tmpdt.getFullYear().toString(10) + '-' + (tmpdt.getMonth() + 1).toString() + '-' + tmpdt.getDate().toString(10) + ' ' + tmpdt.toTimeString().substring(0, 8);
		    }
		    function v_GetChangedDateTime2_nonIE(v_dateTime, hourNum, minuteNum) {
		        return (navigator.userAgent.indexOf('Firefox') != -1) ?
		        (function(v_dateTime, hourNum, minuteNum) {
		            
		            var dt = new Date(v_dateTime);  
		            
		            var offset = dt.getTimezoneOffset(); 
		            var dt2 = new Date(dt.getTime() + (offset + (hourNum * 60) + minuteNum) * 60 * 1000);
		
		            return dt2.getFullYear().toString(10) + '-' + v_AppendZero(dt2.getMonth() + 1) + '-' + v_AppendZero(dt2.getDate()) + ' ' + dt2.toTimeString().substring(0, 8);
		        }).call(this, v_dateTime, hourNum, minuteNum)
		        : (navigator.userAgent.indexOf('MSIE') == -1) ?
		        (function(v_dateTime, hourNum, minuteNum) {
		            var dt = new Date(
		            Date.UTC(
		            parseInt(v_dateTime.substring(0, 4), 10),
		            parseInt(v_dateTime.substring(5, 7), 10) - 1,
		            parseInt(v_dateTime.substring(8, 10), 10), 
		            parseInt(v_dateTime.substring(11, 13), 10),
		            parseInt(v_dateTime.substring(15, 17), 10),
		            parseInt(v_dateTime.substring(18, 20), 10),
		            parseInt(v_dateTime.substring(21, 24), 10)
		            ))
		            
		            var offset = dt.getTimezoneOffset();
		
		            var dt2 = new Date(dt.getTime() + (offset + (hourNum * 60) + minuteNum) * 60 * 1000);
		
		            return dt2.getFullYear().toString(10) + '-' + v_AppendZero(dt2.getMonth() + 1) + '-' + v_AppendZero(dt2.getDate()) + ' ' + dt2.toTimeString().substring(0, 8);
		        }).call(this, v_dateTime, hourNum, minuteNum)
		        :
		        (function(v_dateTime, hourNum, minuteNum) {
		    }).call(this, v_dateTime, hourNum, minuteNum)
		        ;
		    }
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

		    function DateChange(start, end) {
		        var startYearMontgday = start.split("-");
		        var endYearMontgday = end.split("-");
		        var startMonth = startYearMontgday[1];
		        var endMonth = endYearMontgday[1];
		        var startDay = startYearMontgday[2];
		        var endDay = endYearMontgday[2];

// 		        if (startMonth.length == 1) {
// 		            startMonth = "0" + startMonth;
// 		        }
// 		        if (endMonth.length == 1) {
// 		            endMonth = "0" + endMonth;
// 		        }
// 		        if (startDay.length == 1) {
// 		            startDay = "0" + startDay;
// 		        }
// 		        if (endDay.length == 1) {
// 		            endDay = "0" + endDay;
// 		        }
		
// 		        startdate = startYearMontgday[0] + "-" + startMonth + "-" + startDay;
// 		        enddate = endYearMontgday[0] + "-" + endMonth + "-" + endDay;



		
// 		        xmlHTTP2 = createXMLHttpRequest();
// 		        var xmlDom = createXmlDom();
		
// 		        var objRoot, objNode;
// 		        objRoot = createNodeInsert(xmlDom, objRoot, "DATA");
// 		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "STARTDATE", startdate);
// 		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "ENDDATE", enddate);
// 		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "APP", "1");
// 		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "IDLIST", ownerid);
// 		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TYPE", type);
		
// 		        xmlHTTP2.open("POST", "/myoffice/ezTask/remote/task_get_list.aspx", true);
// 		        xmlHTTP2.onreadystatechange = after_DateChange;
// 		        xmlHTTP2.send(xmlDom);

				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezTask/taskGetList.do",
					data : {
						startDate : startdate,
						endDate : enddate,
						app : 1,
						type : type
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
	            var cnt2 = getNodeText(listdom.documentElement.getElementsByTagName("CNT2")[0]);
	
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
		        var pSelectTab = GetAttribute(obj, "divname");
		
		        switch (pSelectTab) {
		            case "taskprog":
		                type = "1";
		                DateChange(startdate, enddate);
		                break;
		            case "taskdictate":
		                type = "2";
		                DateChange(startdate, enddate);
		                break;
		            case "taskcomplete":
		                type = "3";
		                DateChange(startdate, enddate);
		                break;
		        }
		    }
		
		    function onkeydown_start_search(evt) {
		        if (evt.keyCode == "13") {
		            search();
		        }
		
		    }
		    function keyword_Clear() {
		        document.getElementById('txt_keyword').value = "";
		    }
		    function search() {
		        if (document.getElementById("txt_keyword").value.trim() == "") {
		            alert("<spring:message code='ezTask.t194' />");
		            return;
		        }
		
		        var startYearMontgday = startdate.split("-");
		        var endYearMontgday = enddate.split("-");
		        var startMonth = startYearMontgday[1];
		        var endMonth = endYearMontgday[1];
		        var startDay = startYearMontgday[2];
		        var endDay = endYearMontgday[2];
		
		        if (startMonth.length == 1) {
		            startMonth = "0" + startMonth;
		        }
		        if (endMonth.length == 1) {
		            endMonth = "0" + endMonth;
		        }
		        if (startDay.length == 1) {
		            startDay = "0" + startDay;
		        }
		        if (endDay.length == 1) {
		            endDay = "0" + endDay;
		        }
		
		        startdate = startYearMontgday[0] + "-" + startMonth + "-" + startDay;
		        enddate = endYearMontgday[0] + "-" + endMonth + "-" + endDay;
		
		        var chkValue;
		        for (var i = 0; i < document.getElementsByName("searchCheck").length; i++) {
		            if (document.getElementsByName("searchCheck")[i].checked == true)
		                chkValue = document.getElementsByName("searchCheck")[i].value;
		
		        }
		        var filter = chkValue + " LIKE N'%" + document.getElementById("txt_keyword").value + "%'";
		        if (userlang != "1" && chkValue == "TaskPersonName")
		            filter = chkValue + "2 LIKE N'%" + document.getElementById("txt_keyword").value + "%'";
		
		        xmlHTTP2 = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		
		        var objRoot, objNode;
		        objRoot = createNodeInsert(xmlDom, objRoot, "DATA");
		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "STARTDATE", startdate);
		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "ENDDATE", enddate);
		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "APP", "1");
		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "IDLIST", ownerid);
		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TYPE", type);
		        objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "FILTER", filter);
		
		        xmlHTTP2.open("POST", "/myoffice/ezTask/remote/task_get_searchlist.aspx", true);
		        xmlHTTP2.onreadystatechange = after_search;
		        xmlHTTP2.send(xmlDom);
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
		            if(type == "1") {
		                document.getElementById("1tab1").innerHTML = "<spring:message code='ezTask.t2007' />" + " (" + cnt + ")";
		            } else if(type =="2") {
		                document.getElementById("1tab2").innerHTML = "<spring:message code='ezTask.t2008' />" + " (" + cnt + ")";   	
		            } else {
	// 	                document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t99' />" + " (" + cnt + ")";	
		            }
	
		            xmlHTTP2 = null;
		            return;
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
<%-- 		        <p><span id="1tab3" divname="taskcomplete"><spring:message code='ezTask.t99' /></span></p> --%>
		            
		    </div>
		</div>
		<br />
		<div id="mainmenu">
			<ul>
				<li><span id="pn_img" onClick="WriteTask()"><spring:message code='ezTask.t113' /></span></li>
				<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
				<li><span onClick="DeleteTask()"><spring:message code='ezTask.t115' /></span></li>
				<li><span onClick="RefreshView()"><spring:message code='ezTask.t116' /></span></li>
				<li id="right" style="float:right;font-weight:normal;color:black;padding-right: 20px;">
					<input name="check" id="radio4" type="radio" value="finish" onClick="selectTab(1)" style="width:13px;height:13px;vertical-align:middle ">
					<label for="radio4" style="vertical-align:middle"><spring:message code='ezTask.t99' /></label>
				</li>
				<li id="right" style="float:right;font-weight:normal;color:black;">
					<input name="check" id="radio3" type="radio" value="ongoing" checked onClick="selectTab(2)" style="width:13px;height:13px;vertical-align:middle ">
					<label for="radio3" style="vertical-align:middle"><spring:message code='ezTask.t98' /></label>
				</li>
			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table style="WIDTH: 100%;overflow:AUTO;" id="list">
			<tr>
				<td style="WIDTH: 100%;HEIGHT: 100%;vertical-align:top">
					<table class="mainlist" id="list_body" style="WIDTH: 100%;table-layout:fixed;">
						<col style ="width:30px;">
						<col style ="width:50px;">
						<col style ="width:20px;">
						<col style ="width:60px;">
						<col >
						<col style ="width:90px;">
		                <col style ="width:90px;">
						<col style ="width:110px;">
						<col style ="width:80px;">
						<col style ="width:97px;">
						<tr>
							<th ><input id="checkboxAll" type="checkbox" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle"/></th>
							<th ><spring:message code='ezTask.t156' /></th>
							<th ><img src="/images/newAttach.gif"></th>
							<th ><spring:message code='ezTask.t2005' /></th>
							<th ><spring:message code='ezTask.t118' /></th>
<%-- 							<th ><spring:message code='ezTask.t170' /></th> --%>
							<th ></th>
		                    <th ><spring:message code='ezTask.t2003' /></th>
							<th ><spring:message code='ezTask.t120' /></th>
							<th ><spring:message code='ezTask.t121' /></th>
							<th ><spring:message code='ezTask.t122' /></th>
						</tr>
						<tr id="row_body" style="display:none;" taskid="" parentid="" repeatcount="0" startdate="" onclick="select_row(this)">
							<td style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
		                    <td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
						</tr>
						<tr id="tr_ing" style="text-align:center">
							<td colspan="10" style="padding-top:4px;height:24px"><spring:message code='ezTask.t204' /></td>
						</tr>
				    </table>
				    <table class="mainlist" id="list_body2" style="WIDTH: 100%;table-layout:fixed; display:none">
						<col style ="width:30px;">
						<col style ="width:50px;">
						<col style ="width:20px;">
						<col style ="width:60px;">
						<col >
						<col style ="width:90px;">
		                <col style ="width:90px;">
						<col style ="width:110px;">
						<col style ="width:80px;">
						<col style ="width:97px;">
						<tr>
							<th ><input id="checkboxAll2" type="checkbox" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle"/></th>
							<th ><spring:message code='ezTask.t156' /></th>
							<th ><img src="/images/newAttach.gif"></th>
							<th ><spring:message code='ezTask.t2005' /></th>
							<th ><spring:message code='ezTask.t118' /></th>
<%-- 							<th ><spring:message code='ezTask.t170' /></th> --%>
							<th ></th>
		                    <th ><spring:message code='ezTask.t2003' /></th>
							<th ><spring:message code='ezTask.t120' /></th>
							<th ><spring:message code='ezTask.t121' /></th>
							<th ><spring:message code='ezTask.t122' /></th>
						</tr>
						<tr id="row_body2" style="display:none;" taskid="" parentid="" repeatcount="0" startdate="" onclick="select_row(this)">
							<td style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td style ="white-space:nowrap;cursor:pointer;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
		                    <td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
							<td style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this)"></td>
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