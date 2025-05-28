<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezTask.t143' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezTask/circularProgressBar.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezTask.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachItem_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/circularProgressBar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>
		
		<style type="text/css">
			.ui-datepicker { font-size:9.5pt !important}
			
			.css-class-to-highlight a{
			   		color: #3498db !important;
			}
			 
			u {
				text-decoration: none;
			}
	   		
			.percentCount {
				width: 40px;
    			padding-right: 5px;
			}   
			   
			th {
				background-color: #fff;
			}
			 
			.content2 {
				width: 100%;
			}
			
			.content2 td {
				padding: 0px 2px 0px 2px;
				height: 29px;
				word-break: break-all;
			}	  
			 
			#printDocument p, #message2 p{
				MARGIN-TOP: 0mm; 
				MARGIN-BOTTOM: 0mm; 
				line-height: 1.6;
			}
			#printDocument div, #message2 div{
				MARGIN-TOP: 0mm; 
				MARGIN-BOTTOM: 0mm;
				line-height:20px;
				font-size:10pt;
			}
			    
			body {
				padding:10px;
				overflow: auto;
			}
			    
			.popup_title_img {
				margin: 0px 5px;
			}
			
			.popup_title_txt {
				padding-top: 15px;
			}
			
			#repCount {
			    width: 50px;
			}
		</style>
		
		<script type="text/javascript">
			var taskid = "<c:out value='${taskInfoVO.taskID }'/>";
			var contentpath = "${taskInfoVO.contentPath }";
			var personContentpath = "${taskInfoVO.personContentPath }";
			var taskstatus = "<c:out value='${taskInfoVO.taskStatus }'/>";
			var completerate = "<c:out value='${taskInfoVO.completeRate }'/>";
			var duration = 0;
			var delayColor = "<c:out value='${delayColor }'/>";
			var completeColor = "<c:out value='${completeColor }'/>";
		    var tasktype = "<c:out value='${taskInfoVO.taskType }'/>";
		    var content = "${contentPerson }";
		    var date = "<c:out value='${date}'/>";
		    var selectedDate = "<c:out value='${selectedDate}'/>";
		    var type = "<c:out value='${type}'/>";
		    var hasTaskAttach = "<c:out value='${taskInfoVO.hasAttach}'/>";
		    var taskAttachList = "${taskAttachList }";
		    var hasTaskWorkAttach = "${taskInfoVO.personAttach}";
		    var taskWorkAttachList = "${taskWorkAttachList }";
		    var useTodoMemo = "<c:out value='${useTodoMemo }'/>";
		    var startdate = "<c:out value='${taskInfoVO.startDate}'/>";
		    var repeatCount = "<c:out value='${repeatCount}'/>";
		    var createDate = "<c:out value='${taskInfoVO.createDate}'/>";
		    var repetition = "<c:out value='${repetition}'/>";
		    var endDate = "<c:out value='${taskInfoVO.endDate}'/>";
		    var dateList = "${dateList}";
		    var completeRateList = "${completeRateList}";
		    var statusList = "${statusList}";
		    var repeatCntList = "${repeatCntList}";
		    var dateArray = null;
		    var completeRateArray = null;
		    var statusArray = null;
		    var repeatCntArray = null;
		    
		    $(document).ready(function() {	
		    	preStepForRepeatTask();
				load_bodyhtml();
				
				if (hasTaskAttach == 'Y') {
					document.getElementById('printAttach').innerHTML = taskAttachList;
		    	}
				
				load_bodyhtml2(personContentpath);
				if (hasTaskWorkAttach == 'Y') {
					document.getElementById('printAttach2').innerHTML = taskWorkAttachList
		    	}
		    	
		        setTimeout(scrollTop, 2000);

		        if (tasktype == "1" || tasktype == "4") {
		            $(".taskType").html("<spring:message code='ezTask.t2000' />");
		        } else if (tasktype == "2" || tasktype == "5") {
		        	$(".taskType").html("<spring:message code='ezTask.t2001' />");
		        } else {
		        	$(".taskType").html("<spring:message code='ezTask.t2002' />");
		        }
		        
		        if (dateArray != null) {
		        	renderTable();
		        }

				/* 의견카운트 */
				getCommentList();			
				
				/* 반복일정 progressbar 설정 */
				if(taskstatus == 0) {
					dayOnMouseClick(selectedDate);
				}
				
				//프로그래스바 그리기
				initProgressBar(taskstatus, completerate);
		
			    if(tasktype == 4 || tasktype == 5 ||  tasktype == 6) {
				    document.getElementById("reptr").style.display = "block";
				    document.getElementById("taskRep").style.display = "";			   
			    }
				
			    var status = "";
				switch (taskstatus) {
					case "1":
			            status = "<spring:message code='ezTask.t97' />";
						break;
					case "2":
						status = "<spring:message code='ezTask.t98' />";
						break;
					case "3":
						status = "<spring:message code='ezTask.t9001' />";
						break;
					case "4":
						status = "<spring:message code='ezTask.t100' />";
						break;
				}
			
				status += ", <spring:message code='ezTask.t144' />" + completerate + "%";
				
			    if (tasktype != "1" && tasktype != "4") {
			    	$("#printTaskWork").show();
			    	$("#printTaskWorkContent").show();
			    	
				    var content2 = message2.document.body.innerHTML;
				    document.getElementById("printDocument2").innerHTML = content2;
			    }
			    
			    var checks = document.getElementById("printAttach").childNodes;
			    for (var i = 0; i < checks.length; i++) {
			        if (checks[i].type == "checkbox")
			            checks[i].style.display = "none";
			    }
			
			    checks = document.getElementById("printAttach2").childNodes;
			    for (var i = 0; i < checks.length; i++) {
			        if (checks[i].type == "checkbox")
			            checks[i].style.display = "none";
			    }

			    if (document.getElementById("printAttach").innerHTML.trim() != "")
			        printattachView.style.display = "";
			
			    if (tasktype != "1" && document.getElementById("printAttach2").innerHTML.trim() != "")
			    	printattachViewProgress.style.display = "";
		    });
		    
		    function preStepForRepeatTask() {
		    	if (dateList !== "") {
		    		dateArray = dateList.split(",");
		    	}
		    	
		    	if (completeRateList !== "") {
		    		completeRateArray = completeRateList.split(",");
		    	}
		    	
		    	if (statusList !== "") {
		    		statusArray = statusList.split(",");
		    	}
		    	
		    	if (repeatCntList !== "") {
		    		repeatCntArray = repeatCntList.split(",");
		    	}    			    	    	
		    }
		    
			/* 지시사항 본문 */
			function load_bodyhtml() {
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : {
							type : "TASKCONTENT",
							itemID : contentpath
					},
					success: function(result){
						html = result;
						document.getElementById('printDocument').innerHTML = '<div>' + html + '</div>';
					}
				});
			}
			
			/* 진행사항 본문 */
			function load_bodyhtml2(personContentpath) {
				if (personContentpath != "") {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommon/mhtToHTMLContent.do",
						data : {
								type : "TASKCONTENT2",
								itemID : personContentpath
						},
						success: function(result){
							html = result;
							
							var doc = document.getElementById('message2').contentWindow.document;
							doc.open();
							if(html != null || html != ""){
								doc.write(html);								
								}else{
									doc.write(" ");
								}
								
								doc.close();
					
							$("#message2").contents().find("body").css("word-wrap", "break-word");
						}
					});
				}
			}
			
			function scrollTop() {
				try {
					window.scroll(0, 1);
					
					window.print();
				} catch (e) { }
			}
			
			function renderTable() {
				$("#new_list_body").empty();
				
				var defaultTag = "<tr >";
				defaultTag += "<th style='width:  100px; text-align: center;'><spring:message code='ezTask.t1221' /></th>"
				defaultTag += "<th style='width: 320px; text-align: center;'><spring:message code='ezTask.t200914' /></th>"
				defaultTag += "<th style='width: 320px; text-align: center;'><spring:message code='ezTask.t120' /></th>"
				defaultTag += "</tr>"	
				defaultTag += "<tr class='new_row_body' id='new_row_body' style='display:none;' repeatcount='0' startdate='' >"
				defaultTag += "<td class='tr_Read' style='white-space:nowrap; width: 100px;' ></td>"
				defaultTag += "<td class='tr_Read' style='white-space:nowrap; width: 320px;' ></td>"
				defaultTag += "<td class='tr_Read' style='white-space:nowrap; width: 320px;' ></td>"
				defaultTag += "</tr>"
				
				$("#new_list_body").append(defaultTag);				
				
				var new_list_body = document.getElementById("new_list_body");						
				
				for (var i = 0; i < completeRateArray.length; i++) {					
					tr = new_row_body.cloneNode(true);				    

				    tr.style.display = "";
			        tr.id = "taskID_" + i;

			        tr.setAttribute("taskid", taskid);			        

			        var startdate = dateArray[i];
			        var enddate = startdate;
			        var span = document.createElement("SPAN");
			        
			        span.innerHTML += parseInt(repeatCntArray[i] + "");
			        tr.cells[0].appendChild(span);

			        tr.setAttribute("startdate", startdate);			        
			        tr.cells[1].innerHTML = "<u>" + startdate + "</u>";
			        (function(sd) { tr.cells[1].onclick = function () {rowClicked(sd);}})(startdate);		        			        			        	
			        
			        //Process complete rate
			        var taskstatus = parseInt(statusArray[i] + "");			        
			        var completerate = parseInt(completeRateArray[i] + "");
			        var span = document.createElement("SPAN");
			        span.className = "workProgressBar";
			        span.innerHTML += "<span class='bar' taskID='taskProgressBar" + i + "'></span>&nbsp;"

					var span2 = document.createElement("SPAN");
			        span2.style.display = "inline-block";

			        span.appendChild(span2);

			        tr.cells[2].appendChild(span);
			        new_list_body.appendChild(tr);
			        
			        initProgressBar2("taskProgressBar" + i, taskstatus, completerate);			        
				}
				
				$(".progressbar").css("display", "inline-table");
				$(".progressbar").css("margin-left", "15px");
			}
			
			/* progressBar 조회 */
			function initProgressBar2(barID, taskstatus, completerate) {
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
			
			function getCommentList() {
				$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezTask/getTaskCommentList.do",
					data : {							
							taskID : taskid
					},
					success: function(result){
						var list = result.taskCommentList;
						var taskCommentList = "<table class='content2'>";
						
						if (list != null && list.length != 0) {
							list.forEach(function(vo, index) {
								taskCommentList += "<tr>";
								taskCommentList += "<td style='min-width: 120px; width: 120px; text-align: center; white-space:nowrap; vertical-align: middle; padding: 0px 10px;'>&nbsp;<span>" + vo.commentorName + "</span></td>";	
								taskCommentList += "<td style='vertical-align: middle; padding: 0px 10px;'>" + vo.comment + "&nbsp;&nbsp;</td>";
								taskCommentList += "<td style='min-width: 120px; width: 120px; text-align: center; white-space:nowrap; vertical-align: middle; padding: 0px 10px;'>" + vo.commentDate.substring(0, 16) + "</td>";
								taskCommentList += "</tr>";
							}); 	
						} else {
							taskCommentList += "<tr><td colspan='3' style='border: 1px solid #ddd;'></tr>";
						}
						taskCommentList += "</table>"	
						
						$("#printCommentView").append(taskCommentList);
						printCommentView.style.display = "";
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
			}
			
			function dayOnMouseClick(changeDate) {								
				$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezTask/taskRepGetList.do",
					data : {
						taskID	    : taskid,
						currentDate : changeDate												
					},
					success : function(xml) {				
						date = changeDate;
						renderPage(xml);
					},
					error : function() {
						alert("<spring:message code='ezTask.t992' />");
					}
				});
				
			}
			
			function renderPage(xml) {
				listdom = loadXMLString(xml);
				var node = GetChildNodesByNodeName(listdom.documentElement, "ROW")[0];
				contentpath = SelectSingleNodeValue(node, "CONTENTPATH");
				personContentpath = SelectSingleNodeValue(node, "PERSONALCONTENTPATH");
				completerate = SelectSingleNodeValue(node, "COMPLETERATE");
				taskstatus = SelectSingleNodeValue(node, "TASKSTATUS");	
				repeatCount = SelectSingleNodeValue(node, "REPEATCOUNT");
				
				document.getElementById("prog1").innerHTML = date;
				document.getElementById("repCount").innerHTML = repeatCount;
				
				load_bodyhtml();
			}
			
			/* progressBar 조회 */
			function initProgressBar(taskstatus, completerate) {
				if (taskstatus == '4') {
					$('.progress_graph').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: delayColor},
						size: 135,
						animation: false
					});
				} else if (taskstatus == '3' || completerate == '100') {	
					$('.progress_graph').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: completeColor},
						size: 135,
						animation: false
					});
				} else {
					$('.progress_graph').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: '#3498db'},
						size: 135,
						animation: false
					});
				}
				
				//프로그래스바 안의 퍼센트 글자
				var canvas = $('.circle');
				var strong = canvas.find("strong");
				var color = "";
				
				if (taskstatus == '4') {
					color = delayColor;
				}
				
				strong.html(completerate + '%');
				strong.css("color", "");
			}
			
			/* datepicker
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
					showMonthAfterYear: false
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
			
			$(function () {
				if (tasktype == "4" || tasktype == "5" || tasktype == "6" ) {
					$("#Sdatepicker").datepicker({
			            changeMonth: true,
			            changeYear: true,
			            autoSize: true,
			            format: 'yyyy-mm-dd',
			            beforeShowDay: function(date) {	
			            	if (dateArray != null) {
				                var m = date.getMonth() + 1;
				                var d = date.getDate();
				                var y = date.getFullYear();		                
				                
				                var test = y + "-" + ("0" + m).slice(-2) + "-" + ("0" + d).slice(-2);		                
				                
				                for (i = 0; i < dateArray.length; i++) {		                	
				                    if($.inArray(test, dateArray) != -1) {		                        
				                        return [true, 'css-class-to-highlight', 'tooltipText'];
				                    }
				                }
				                return [true];
			            	}	            	
			            },
			            onSelect: function(dateText, inst) {
			            	showResult(dateText);
			            }
			        });

			        var SDate;

			        if (date != "") {
			            SDate = new Date(date);
			        } else {
			            SDate = new Date();
			        }
			        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#Sdatepicker").datepicker('setDate', SDate);
				}		        
		    });
			
			function showResult(dateText) {
		        var SDate;
		        if (dateText != "") {
		            SDate = new Date(dateText);
		        } else {
		            SDate = new Date();
		        }
		        
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
				
        		var test = 0;
				for (var i = 0; i < dateArray.length; i++) {					
					if (dateArray[i] ==  dateText) {
						test = 1;
						break;
					}
				}						
				
				if (test == 0) {
					dateArray = dateList.split(",");
					alert("<spring:message code='ezTask.t200912' />");
					$("#Sdatepicker").datepicker("setDate", date);
				}				
			}
			*/
		</script>
	</head>
	
	<body>
		<div class="wrap_progress" style="height:245px;">
			<h4 style="-webkit-print-color-adjust:exact;print-color-adjust: exact;" title="<c:out value='${taskInfoVO.title}'/>"><c:out value='${taskInfoVO.title}'/></h4>
			<div style="">
				<div class="circle progress_graph" style="width:30%; margin: 10px 20px; top:15px;">
					<strong></strong>
				</div>
				<div class="progress_txt" style="magin-left:20px;margin-top:40px;">
					<ul>
						<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 5 || taskInfoVO.taskType == 6}">
							<!-- <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly" > -->
							<li><span class="txt_title"><spring:message code='ezTask.t200914' /></span><span class="txt_content" id="prog1"><c:out value = '${date}' /></span></li>
							<li><span class="txt_title"><spring:message code='ezTask.t1221' /></span><span class="txt_content" id="repCount"><c:out value = '${repeatCount}' /></span></li>
						
						</c:if>
						<c:if test="${taskInfoVO.taskType == 1 || taskInfoVO.taskType == 2 || taskInfoVO.taskType == 3}">
							<li><span class="txt_title"><spring:message code='ezTask.t121' /></span><span class="txt_content"><c:out value = '${fn:substring(taskInfoVO.startDate, 0, 10) }' /></span></li>
							<li><span class="txt_title"><spring:message code='ezTask.t9002' /></span><span class="txt_content"><c:out value = '${fn:substring(taskInfoVO.endDate, 0, 10) }' /></span></li>
						</c:if>
					</ul>
				</div>
				<div id="Sdatepicker" style="float:right;"></div>
			</div>
		</div>
		
		<table id="tablework" class="layout" style="height:100%; display:none;">
			<tr style="vertical-align:top">
				<td colspan="3" style="padding-bottom:4px; height:440px;">
					<iframe id="message2" class="viewbox" name="message2" style="padding:0; height:100%; width:99.7%; overflow:auto; border: 1px solid #e2e2e2; margin-top: 3px;"></iframe>
				</td>
			</tr>
		</table>
		<div id="printScreen" style="display: block;">
			<table id="printTable" class="layout" >
				<tr>
					<td class="popup_title_txt">
						<img src="/images/kr/left/left_dot02.gif" class="popup_title_img">
						<spring:message code='ezTask.lhj02' />
					</td>
				</tr>
				<tr>
					<td>
						<table class="content">
							<tr>
								<th><spring:message code='ezTask.t117' /></th>
								<td style="white-space:nowrap">
									<div>
										<c:out value = '${taskInfoVO.creatorName }' />&nbsp;(<c:out value = '${taskInfoVO.creatorDeptName }' />)
									</div>
								</td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t155' /></th>
								<td style="padding-right:15px;white-space:nowrap"><c:out value='${fn:substring(taskInfoVO.createDate, 0, 10) }'/></td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t2003' /></th>
								<td style="width:100%">
									<div>
										<span class="taskType"></span>
									</div>
								</td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t156' /></th>
								<td>
									<div>
										<c:choose>
											<c:when test="${taskInfoVO.importance == '1' }">
												<spring:message code = 'ezTask.t171' />
											</c:when>
											<c:when test="${taskInfoVO.importance == '2' }">
												<spring:message code = 'ezTask.t172' />
											</c:when>
											<c:otherwise>
												<spring:message code = 'ezTask.t173' />
											</c:otherwise>
										</c:choose>
									</div>
								</td>
							</tr>
							<tr id ="persontr">
								<th><spring:message code='ezTask.t2005' /></th>
								<td colspan="3" width="100%">
									<div>
										<c:out value = '${taskInfoVO.personName }' />&nbsp;(<c:out value = '${taskInfoVO.personDeptName }' />)
									</div>
								</td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t157' /></th>
								<td colspan="3" style="width:100%">
									<div id="taskShareList" style="overflow-Y: auto; line-height: 1.5em;">
										<c:forEach var="taskShareVO" varStatus="status" items="${taskShareList}">
											<span style="margin-top: 0px;margin-bottom: 0px;" >
												<c:out value = '${taskShareVO.sharerName }' />&nbsp;(<c:out value = '${taskShareVO.sharerDeptName }' />)
											</span>
											<c:if test="${not status.last }">,&nbsp;</c:if>
										</c:forEach>
									</div>
								</td>
							</tr>
							
							<c:if test="${useTodoMemo == 'YES'}">
								<tr>
					            	<th><spring:message code='ezTask.t170' /></th>
					            	<td id="TextMemo" colspan="3">
					            		<div style="overflow-y:auto;padding-top:2px;">
					            			<c:out value = '${taskInfoVO.memo }' />
					            		</div>
					            	</td>
								</tr>
							</c:if>
						</table>
					</td>
				</tr>				
				<!-- 주석 -->
				<tr>
					<td>
						<div>
							<ul style="padding-left: 0px; list-style:none;">
								<li style="padding-top: 10px; font-size:11px;"> ▒ <spring:message code='ezTask.t200906' /></li>
								<li style="padding-top: 10px; font-size:11px;"> ▒ <spring:message code='ezTask.t200907' /></li>
								<li style="padding-top: 10px; font-size:11px;"> ▒
									<c:if test="${taskInfoVO.taskType != 4 && taskInfoVO.taskType != 1}"><spring:message code='ezTask.jjh03' /></c:if>
									<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 1}"><spring:message code='ezTask.t200908' /></c:if> 
								</li>
								<li style="padding-top: 10px; font-size:11px;"> ▒ <spring:message code='ezTask.t200909' /></li>				
								<li style="padding-top: 10px; font-size:11px;"> ▒ <spring:message code='ezTask.t200910' /></li>				
							</ul>
						</div>
					</td>
				</tr>
				<tr style="height:20px;">
					<td class="popup_title_txt"><img src="/images/kr/left/left_dot02.gif" class="popup_title_img">
						<c:choose>
							<c:when test="${taskInfoVO.taskType == '1' || taskInfoVO.taskType == '4'}">
								<spring:message code='ezTask.t2011' />
							</c:when>
							<c:otherwise>
								<spring:message code='ezTask.t2010' />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td><div class='margin' id="printDocument" style="padding:10px;BORDER: #ddd 1px solid;height:100%;background-color: white"></div></td>
				</tr>
				<tr id="printattachView" style="display:none;">
					<td style="height:20px; padding-top:10px;">
						<table class="file">
							<tr>
								<th><spring:message code='ezTask.t160' /></th>
								<td style="width:100%"><div id="printAttach" style="margin-top:0px;padding-top:0px;overflow:visible; height: auto; background-color:white;text-align:left;"></div></td>
							</tr>
						</table>
					</td>
				</tr>
				
				<!-- 진행사항 -->
				<tr id="printTaskWork" style="display:none; height:20px;">
					<td class="popup_title_txt"><img src="/images/kr/left/left_dot02.gif" class="popup_title_img">
						<spring:message code='ezTask.t2011' />
					</td>
				</tr>
				<tr id="printTaskWorkContent" style="display:none;">
					<td><div class='margin' id="printDocument2" style="padding:10px;BORDER: #ddd 1px solid;height:100%;background-color: white"></div></td>
				</tr>
				<tr id="printattachViewProgress" style="display:none;">
					<td style="height:20px; padding-top:10px;">
						<table class="file">
							<tr>
								<th><spring:message code='ezTask.t160' /></th>
								<td style="width:100%"><div id="printAttach2" style="margin-top:0px;padding-top:0px;overflow:visible; height: auto; background-color:white;text-align:left"></div></td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- 의견 -->
				<tr id ="optiontr" style="height:20px">
					<td class="popup_title_txt"><img src="/images/kr/left/left_dot02.gif" class="popup_title_img">
						<spring:message code='ezTask.t2013' />
					</td>
				</tr>
				
				<tr id="printCommentView" style="display:none">
				</tr>				
				<!-- 반복업무현황 -->
				<tr id ="reptr" style="height:20px;padding-bottom:20px;display:none;">
					<td class="popup_title_txt"><img src="/images/kr/left/left_dot02.gif" class="popup_title_img">
						<spring:message code='ezTask.t200904' />
					</td>
				</tr>
				
				<tr id="repTable">
					<table id="taskRep" class="layout" style="display:none;">
					 	<tr>
							<td>
								<div id="new_div_body" style="overflow-y: auto;">
									<table class="content" id="new_list_body" style="text-align: center;">
										<tr >
											<th style="width:  100px; text-align: center;"><spring:message code='ezTask.t1221' /></th>
											<th style="width: 320px; text-align: center;"><spring:message code='ezTask.t200914' /></th>
											<th style="width: 320px; text-align: center;"><spring:message code='ezTask.t120' /></th>
										</tr>	
										<tr class="new_row_body" id="new_row_body" style="display:none;" repeatcount="0" startdate="" >
											<td class="tr_Read" style="white-space:nowrap; width: 100px;" ></td>
											<td class="tr_Read" style="white-space:nowrap; width: 320px;" ></td>
											<td class="tr_Read" style="white-space:nowrap; width: 320px;" ></td>
										</tr>
										<tr id="noDataTag"><td colspan='3' style='text-align: center;'><spring:message code='ezTask.t200912' /></td></tr>					
									</table>
								</div>
							</td>
						</tr>		
					</table>
				</tr>			
			</table>
		</div>

		<table id="tablecomment" class="layout" style="height:0%;width:100%;table-layout: fixed; overflow:auto;margin-top:6px;display:none;">
		</table>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>

</html>
