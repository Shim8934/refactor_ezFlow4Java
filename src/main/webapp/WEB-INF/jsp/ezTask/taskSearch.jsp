<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezTask.t180' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>
		<STYLE type="text/css"> 
			.pagetd{padding-top:6px; }
			.pcol{padding-top:6px; }
			.Right_Point01 {
				font:bold;
				color:#017bec;
			}
			.h2_dot {
				background: url(/images/kr/left/left_dot02.gif) no-repeat 0px 70%;
			}
		</STYLE>
		<script type="text/javascript">
			var startdate = "_startdate";
			var enddate = "_enddate";
			var filter = "_filter";
		    var orgfilter = "_OrgFilter";
		    var pUse_Editor = "Use_Editor";
		    var pSearchType = "pSearchType";
		    var primary = "<c:out value='${userInfo.primary}'/>";
		    var delayColor = "<c:out value='${delayColor}'/>";
		    var completeColor = "<c:out value='${completeColor}'/>"
		    var selectelem = null;
		    var useTodoMemo = "<c:out value='${useTodoMemo }'/>";
		    
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
// 				if (startdate != "")
// 				{
// 					document.getElementById("usedate").checked = true;
// 					document.getElementById('search_class').value = "_tclass";
// 				    document.getElementById("keyword").value = "_OrgFilter";
// 				}
// 		        if (pSearchType != "") {
// 		            if (pSearchType == "person")
// 		                document.getElementById("search_field").selectedIndex = 1;
// 		        }

		        $("#Sdatepicker").datepicker('disable');
		        $("#Edatepicker").datepicker('disable');
		        
		        /* 2018-07-20 홍승비 - 업무검색(to-do) > 검색결과 좌측네모 IE에서 높이조절 */
		        if (navigator.userAgent.toLowerCase().indexOf('chrome') == -1) {
					document.getElementsByClassName("h2_dot")[0].style.background = "url(/images/kr/left/left_dot02.gif) no-repeat 0px 67%";
		        }
		        
		        var height = parseInt(document.documentElement.clientHeight - 245);
		        document.getElementById("todo_BODY").style.height = height + "px";
		    }
		    
		    window.onresize = function () {
		    	if (navigator.userAgent.indexOf("Chrome") > -1) {
		            document.getElementById("todo_BODY").style.height = document.documentElement.clientHeight - 245 + "px";
		    	}
		    	else {
	    	        document.getElementById("todo_BODY").style.height = document.documentElement.clientHeight - 250 + "px";
		    	}
    	        scroll();
		    }

		    function select_row(elem) {
		    	// 전체체크박스 선택 후 목록에서 하나 선택 시 전체체크 해제
				if ($("#checkboxAll").is(":checked")) {
					$("input[type=checkbox]").prop("checked", false);
		    		$(".row_body td").css("background", "");
				}

				// 목록에서 하나씩 다른거 선택할 때
		    	if (selectelem != null) {
			    	if (selectelem != elem) {
						$("input[type=checkbox]").prop("checked", false);
						$(selectelem).css("background", "#ffffff");
						$(selectelem).siblings().css("background", "#ffffff");

			        	selectelem = null;
			    	}
		    	}

				// 체크 후 체크박스 눌러서 체크 해제할 때
		        if (selectelem != null) {
		        	selectelem.style.backgroundColor = "#ffffff";
		        	$("input[id='" + "inputID" + $(selectelem).attr("id") + "']").prop("checked", false);
		            selectelem = null;
		            return;
		        }

		        selectelem = elem;
		        elem.style.backgroundColor = "#f1f8ff";
		        $("input[taskID='" + "inputID" + $(elem).attr("id") + "']").prop("checked", true);
		    }
		    
		    function selectAll() {
		    	$(selectelem).css("background", "#ffffff");

				if ($("#checkboxAll").is(":checked")) {
					$(":checkbox[name=myCheckbox]").prop("checked", true);
					$(".row_body td").css("background", "#f1f8ff");
				} else {
					$(":checkbox[name=myCheckbox]").prop("checked", false);
					$(".row_body td").css("background", "");
				}
		    }

		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var SDate;
		        var EDate;
		        if (startdate != "") {
		            SDate = new Date(startdate);
		            EDate = new Date(enddate);
		        }
		        else {
		            SDate = new Date();
		            EDate = new Date();
		        }
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
		    });

		    $(function () {
		    	$.datepicker.regional["<spring:message code='main.t0619' />"] = {
					closeText: "<spring:message code='main.t3' />",
					prevText: "<spring:message code='main.t0604' />",
					nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
					monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					           "<spring:message code='main.t0627' />"],
					dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                "<spring:message code='main.t0627' />"],
					dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					              "<spring:message code='main.t0627' />"],
					weekHeader: "Wk",
					dateFormat: "yy-mm-dd",
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: "show",
					showMonthAfterYear: true
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });

			function search()
			{
				var sdate = "";
				var edate = "";

				var filter = "";
				var useDate = document.getElementById("usedate").checked;
				if (document.getElementById("usedate").checked)
				{
				    sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				    edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				}

				if ($.trim($("#keyword").val()) == "") {
		        	alert("<spring:message code='ezTask.t990' />");
		            return;
		        }

				if (sdate > edate) {
					alert("<spring:message code='ezTask.jsh01' />");
		            return;
				}

				/* 2020-09-15 홍승비 - 제목과 메모는 특수문자를 그대로 저장하도록 수정되어 주석처리 */
				/* 2018-05-30 김민성 - 업무 검색 특수문자 태그 검색 수정 */
				if (document.getElementById("keyword").value != "") {
					filter = document.getElementById("keyword").value;			
					//filter = MakeXMLString(filter);
				}

				if (filter.indexOf("%") != -1) {
		            alert("'%'" + "<spring:message code='ezTask.jsh08' />");
		            return;
		        }

				var searchClass = $("#search_class").val();
				var chkValue = $("#search_field").val();

				$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezTask/taskGetList.do",
					data : {
						startDate : sdate,
						endDate : edate,
						filter : filter,
						chkValue : chkValue,
						searchClass : searchClass,
						useDate : useDate
					},
					success : function(xml) {
						after_DateChange(xml);
					},
					error : function() {
						alert("<spring:message code='ezTask.t992' />");
					}
				});
			}

			var pagesize = 500;
			function after_DateChange(xml) {
	            listdom = loadXMLString(xml);

	            totalcount = GetChildNodes(listdom.documentElement).length - 4;
	            totalpage = Math.ceil(new Number(totalcount / pagesize));

                currentpage = 1;
	
	            if (currentpage == 0) {
	                currentpage = 1;	            	
	            }
	
	            show_page();

				cntAdd = "";

	            return;
		    }
			
			function show_page() {
// 			    makePageSelPage();				

			    var length = list_body2.children[1].rows.length;

			    for (var i = 1; i < length; i++) {
			        list_body2.children[1].removeChild(list_body2.children[1].rows[1]);			    	
			    }

			    var tr = "";
			    var searchCount = "";

			    for (var i = (currentpage - 1) * pagesize; i < currentpage * pagesize; i++) {
					if (totalcount == 0 || i == totalcount) {
			            break;
			        }
			        var node = GetChildNodesByNodeName(listdom.documentElement, "ROW")[i];			        

				    tr = row_body.cloneNode(true);
				    document.getElementById("tr_ing").style.display = "none";

				    tr.style.display = "";
			        tr.id = SelectSingleNodeValue(node, "TASKID") + "_" + i;

			        tr.setAttribute("taskid", SelectSingleNodeValue(node, "TASKID"));
			        tr.setAttribute("creatorid", SelectSingleNodeValue(node, "CREATORID"));

			        var startdate = SelectSingleNodeValue(node, "STARTDATE").substr(0, 10);
			        var enddate = SelectSingleNodeValue(node, "ENDDATE").substr(0, 10);

			        tr.setAttribute("startdate", startdate);

			        tr.cells[0].innerHTML += "<div class='custom_checkbox'><input name='myCheckbox' type='checkbox' taskID='" + "inputID" + SelectSingleNodeValue(node, "TASKID") + "_" + i + "' creatorID='" + SelectSingleNodeValue(node, "CREATORID") + "' style='width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle'>"

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
			            tr.cells[3].setAttribute("title", SelectSingleNodeValue(node, "PERSONNAME"));
			        } else {
			            setNodeText(tr.cells[3], SelectSingleNodeValue(node, "PERSONNAME2"));
			            tr.cells[3].setAttribute("title", SelectSingleNodeValue(node, "PERSONNAME2"));
			        }

			        tr.cells[3].style.overflow = "hidden";
		            tr.cells[3].style.textOverflow = "ellipsis";

		            var commentCount = SelectSingleNodeValue(node, "HASCOMMENT");
			        if (SelectSingleNodeValue(node, "HASCOMMENT") != "0") {
			            tr.cells[4].innerHTML = "<span id='titleid" + i + "'>" + MakeXMLString(SelectSingleNodeValue(node, "TITLE")) + "</span>" + "<span><font color = '#c64200'>&nbsp;[" + commentCount + "]</font></span>";
			            tr.cells[4].setAttribute("title", SelectSingleNodeValue(node, "TITLE") + " [" + commentCount + "]");
			        } else {
						tr.cells[4].innerHTML = MakeXMLString(SelectSingleNodeValue(node, "TITLE"));
			            tr.cells[4].setAttribute("title", SelectSingleNodeValue(node, "TITLE"));
			        }
			        tr.cells[4].style.overflow = "hidden";
		            tr.cells[4].style.textOverflow = "ellipsis";

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

			        switch (SelectSingleNodeValue(node, "TASKTYPE")) {
			            case "1":
			            case "4":	
			                div.style.background = "url(/images/icon/section_Individualbg.png)";
			                break;
			            case "2":
			            case "5":
			                div.style.background = "url(/images/icon/section_orderbg.png)";
			                break;
			            case "3":
			            case "6":
			                div.style.background = "url(/images/icon/section_Cooperativebg.png)";
			                break;
			        }

	                tr.cells[7].appendChild(div);

			        var taskstatus = SelectSingleNodeValue(node, "TASKSTATUS");
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

			        initProgressBar("taskProgressBar" + i, taskstatus, completerate);
			        
			        searchCount++;

			        if (useTodoMemo == 'YES') {
						if ($("#titleid" + i + "").outerWidth() > 900) {
							$("#titleid" + i + "").css("vertical-align", "middle").css("overflow", "hidden").css("textOverflow", "ellipsis").css("display", "inline-block").css("width", "100%");
						} else {
					        $("#titleid" + i + "").css("width", $("#titleid" + i + "").outerWidth());
						}
			        } else {
						if ($("#titleid" + i + "").outerWidth() > 1000) {
							$("#titleid" + i + "").css("vertical-align", "middle").css("overflow", "hidden").css("textOverflow", "ellipsis").css("display", "inline-block").css("width", "100%");
						} else {
					        $("#titleid" + i + "").css("width", $("#titleid" + i + "").outerWidth());
						}
			        }
				}

			    if (totalcount == 0) {
			        document.getElementById("tr_ing").style.display = "";
			        $("#resultCount").empty();
			    } else {
			    	$("#resultCount").empty();
					$("#resultCount").append(" : <span id='searchCount' style='color:#CC3300'>" + searchCount + "&nbsp;</span>");
					$("#searchCount").after("<spring:message code='ezTask.t191' />");
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
					$(".bar[taskid='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: delayColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else if (taskstatus == '3' || completerate == '100') {
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

			function ReplaceText( orgStr, findStr, replaceStr )
			{
				var re = new RegExp( findStr, "gi" );
				return ( orgStr.replace( re, replaceStr ) );
			}

			/* 2021-03-24 홍승비 - 원클릭으로 업무관리 읽기팝업창 표출 */
			function ReadTask(obj)
			{
				var taskid = $(obj).closest("tr").attr("taskid");
				var feature = "";
				var startD = obj.parentElement.getAttribute("startdate");

				feature = GetOpenPosition(790, 820);
	        	
	        	if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/ezTask/taskRead.do?taskID=" + taskid + "&date=" + startD + "&mode=search", "", "height = 822px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
		        } else {
	                window.open("/ezTask/taskRead.do?taskID=" + taskid + "&date=" + startD + "&mode=search", "", "height = 822px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1" + feature);
		        }
			}

			function onmouseOver(elem)
			{
				elem.style.color = "blue";
				elem.style.backgroundColor = "#ECF3BA";
			}

			function onmouseOut(elem)
			{
				elem.style.color = "";
				elem.style.backgroundColor = "#FFFFFF";
			}

			function search_keypress(evt)
			{	
			    if(window.event)
			    {
			        if(evt.keyCode != 13)
			            return;
			    }
		        else
		        {
			        if(evt.which != 13)
			            return;
		        }
		        search();
			}

			var usedate = false;
			function DateSearch_Click() {
		        if(usedate){
		        	usedate = false;
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        } else {
		        	usedate = true;
		            $("#Sdatepicker").datepicker('enable');
		            $("#Edatepicker").datepicker('enable');
		        }
		    }

		    function RefreshView() {
		        search();
		    }
		    
		    function scroll() {
		    	var BoardList_BODYHeight = document.getElementById("list_body2").clientHeight;
		    	var BoardListDivHeight = document.getElementById("todo_BODY").clientHeight;
		    	
		    	 if (BoardList_BODYHeight < BoardListDivHeight) {
		    		if ($("#todo_HEAD tr th#forScroll").length > 0) {
		    			$("#todo_HEAD tr th#forScroll").remove();
		    		}
		    	} else {
		    		if ($("#todo_HEAD tr th#forScroll").length < 1) {
		    			
		    			$("#todo_HEAD tr").append("<th id='forScroll' style='width:8px'></th>");
		    			
		    				var lastTh = $("#todo_HEAD tr th").last();
		    				lastTh.attr("id", "forScroll");
		    				lastTh.css("width", "8px");
		    		}
		    	}
		    }
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezTask.t180' /></h1>
		<table class="content">
			<tr>
				<th style="height:auto"><spring:message code='ezTask.t181' /></th>
				<td>
					<select name="search_class" id="search_class" style="WIDTH: 80px;vertical-align:middle;height:22px">
						<option  value="" selected ><spring:message code='ezTask.t240' /></option>
						<%-- <option  value="1" ><spring:message code='ezTask.t97' /></option> --%>
						<option  value="2"><spring:message code='ezTask.t98' /></option>
						<option  value="3"><spring:message code='ezTask.t9001' /></option>
						<option  value="4"><spring:message code='ezTask.t100' /></option>
					</select>
					<select id="search_field" name="search_field" style="WIDTH: 70px;vertical-align:middle;height:22px">
						<option  value="title" selected><spring:message code='ezTask.t118' /></option>
						<option  value="personName" ><spring:message code='ezTask.t2005' /></option>
					</select>
					<input name="text" type="text" id="keyword" onKeyPress="return search_keypress(event)" size="21" style="vertical-align:middle;height:22px">
					<span style="vertical-align:middle"><a class="imgbtn imgbck" style="vertical-align:middle;margin-top:1px"><span onClick="search()"><spring:message code='ezTask.t183' /></span></a></span>
				</td>
			</tr>
			<tr>
				<th style="height:auto"><spring:message code='ezTask.t184' /></th>
				<td>
					<div class="custom_checkbox"><input type="checkbox" id="usedate" value="1" onclick="DateSearch_Click();"></div><label for="usedate"><spring:message code='ezTask.t185' /></label>
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
	          		<span>&nbsp;<spring:message code='ezTask.t188'/></span> 
				</td>
			</tr>
		</table>
		<br>
		<div class="txt">
			<h2 class="h2_dot"><spring:message code='ezTask.t190' />
			<span class="point"></span><span id="resultCount"></span></h2>
		</div>
		
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
			<col style ="width:130px;">
			<col style ="width:120px;">
			<col style ="width:120px;">
			<tbody id="todo_HEAD">
			<tr>
				<th style="text-align:center"><div class="custom_checkbox"><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle"/></div></th>
				<th style="text-align:center"><img src="/images/ImgIcon/view-importance.gif"></th>
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
                <th style="padding-left:14px"><spring:message code='ezTask.t2003' /></th>
				<th style="text-align:center;"><spring:message code='ezTask.t120' /></th>
				<th style="text-align:center;"><spring:message code='ezTask.t121' /></th>
				<th style="text-align:center;"><spring:message code='ezTask.t9002' /></th>
			</tr>
			</tbody>
			<!-- 18-05-24 김민성 - 중요도 이미지로 수정 -->
			<tr class="row_body" id="row_body" style="display:none;" repeatcount="0" startdate="" onclick="select_row(this);">
				<td class="tr_Read" style ="white-space:nowrap;cursor:pointer;text-align:center;" ondblclick="ReadTask(this);"></td>
				<td class="tr_Read" style ="white-space:nowrap;cursor:pointer;text-align:center;" ondblclick="ReadTask(this);"></td>
				<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this);"></td>
				<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this);"></td>
                <td class="tr_Read" style="cursor:pointer;white-space:nowrap;" onclick="ReadTask(this);"></td>
				<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this);"></td>
				<td class="tr_Read" style="cursor:pointer;white-space:nowrap;" ondblclick="ReadTask(this);"></td>
				<td class="tr_Read" style="cursor:pointer;white-space:nowrap;text-align:center;" ondblclick="ReadTask(this);"></td>
				<td class="tr_Read" style="cursor:pointer;white-space:nowrap;text-align:center;" ondblclick="ReadTask(this);"></td>
				<td class="tr_Read" style="cursor:pointer;white-space:nowrap;text-align:center;" ondblclick="ReadTask(this);"></td>
				<td class="tr_Read" style="cursor:pointer;white-space:nowrap;text-align:center;" ondblclick="ReadTask(this);"></td>
			</tr>
		</table>
		<div id="todo_BODY" style="height:300px; overflow-y:auto;">
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
			<col style ="width:130px;">
			<col style ="width:120px;">
			<col style ="width:120px;">
			<tr id="tr_ing" style="text-align:center; display: none;">
				<td colspan="11" style="height:25px;background-color:white;text-align:center"><spring:message code='ezTask.t192' /></td>
			</tr>
		</table>
		</div>
		<br>
		<br>
	</body>
</html>