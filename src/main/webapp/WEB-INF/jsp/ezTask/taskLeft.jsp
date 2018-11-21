<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_task</title>
		<link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style type="text/css">
	    	#mCSB_1_container {
				margin-right: 0px;
			}  	
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>

	    <script type="text/javascript">	    	
	        var _funCode = "<c:out value='${funCode}'/>";
	        var _subCode = "<c:out value='${subCode}'/>";
	        var defaultView = "<c:out value='${defaultView}'/>";
	        var uselang = "<c:out value='${lang}'/>";
	        var xmlDom_treeview = createXmlDom();	        
	        var ch_selected = false;
			var totalCnt = 0;
			var sStartDate;
			var sEndDate;
			var typeCal;			
			
	        document.onselectstart = function () { return false; };
	        window.onload = function () {	            

	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {	    
	                if ("3" == _funCode) {
	                    //document.getElementById('Task').parentElement.onclick();
	                    document.getElementById('Task').onclick();
	                }
	                else if ("7" == _funCode) {
	                    //document.getElementById('Task').parentElement.onclick();
	                    document.getElementById('Task').onclick();
	                    //document.getElementById('Task_Search').parentElement.onclick();
	                    document.getElementById('Task_Search').onclick();
	                }
	                else if ("11" == _funCode) {
	                	//document.getElementById('Schedule_Config').parentElement.onclick();
	                    document.getElementById('Schedule_Config').onclick();
	                }
	            }
	            else {	                
	                if ("3" == _funCode) {
	                    document.getElementById('Task').click();
	                }
	                else if ("7" == _funCode) {
	                    document.getElementById('Task').click();
	                    document.getElementById('Task_Search').click();
	                }	            	               
	                else if ("11" == _funCode) {
	                    document.getElementById('Schedule_Config').click();	                    
	                }
	            }
	            
	            leftResize();
		        $(".taskListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});
	        }
	        
	        var taskFlag = true;
		    function Function_Flag(v_data, subfolder) {

		        switch (v_data) {
		            case 3:		// Task
		            	window.open("/ezTask/taskMain.do?taskFlag=normal", "right");
		            
		            	taskFlag = false;
		                break;

		            case 7:		// Search Task
		                window.open("/ezTask/taskSearch.do", "right");
		                getTaskList();
		            	taskFlag = true;
		                break;
		            
		            case 11:		// Search public calendar
		                window.open("/ezSchedule/scheduleConfigMain.do?flag=task", "right");
		                getTaskList();
		                taskFlag = true;
		                break;
		                
		            case 12:		// repeat task
		           		window.open("/ezTask/taskMain.do?taskFlag=repeat", "right");
		            	taskFlag = false;
		            	break;
		            	
		            case 13:		// send task
		            	window.open("/ezTask/taskMain.do?taskFlag=send", "right");
		            	taskFlag = false;
		            	break;
		            	
		        }
		    }		   
		
	        // 업무작성창 load
	        function WritePopup() {// 왼쪽(일반업무, 반복업무, 보낸업무) => 왼쪽 업무작성 버튼 입력
	        	if(window.parent.frames["right"].document.getElementById("portlet_tabpart01")) {
	        		window.parent.frames["right"].WriteTask("left");
	        		return;
	        	} 
	        	// 환경설정, 업무검색 페이지 => 업무작성
	        	feature = GetOpenPosition(790, 775);
                window.open("/ezTask/taskWrite.do?flag=other", "", "height=775px, width=790px, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
	        }
	        
	        function cntLoad() {
	        	// 일반업무
	        	if (window.parent.frames["right"].cnt > 0) {
	        		$("#taskCnt").html(window.parent.frames["right"].cnt);
	        	} else if(window.parent.frames["right"].cnt == 0) {
	        		$("#taskCnt").html("");
	        	}
	        	// 반복업무
	        	if (window.parent.frames["right"].cnt3 > 0) {
	        		$("#task2Cnt").html(window.parent.frames["right"].cnt3);	
	        	} else if(window.parent.frames["right"].cnt3 == 0) {
	        		$("#task2Cnt").html("");
	        	}
	        	// 보낸업무
	        	if (window.parent.frames["right"].cnt2 > 0) {
	        		$("#task3Cnt").html(window.parent.frames["right"].cnt2);	        		
	        	} else if(window.parent.frames["right"].cnt2 == 0) {
	        		$("#task3Cnt").html("");
	        	}
	        }
	        
	        function getTaskList() {		    	
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezTask/taskGetList.do",
					data : {
						"startDate" : "",
						"endDate" : "",
						type : 1,
						"filter" : "",
						"chkValue" : "",
						"searchClass" : "",
						taskStatusCount : 2,
						useDate : "",
						pSelectTab : "taskprog"
					},
					success : function(xml) {
						listdom = loadXMLString(xml);
						count = getNodeText(listdom.documentElement.getElementsByTagName("CNT")[0]);
			            count2 = getNodeText(listdom.documentElement.getElementsByTagName("CNT2")[0]);
			            count3 = getNodeText(listdom.documentElement.getElementsByTagName("CNT3")[0]);
			            $("#taskCnt").html(count);
			            $("#task2Cnt").html(count3);
			            $("#task3Cnt").html(count2);
					},
					error : function() {
						alert("<spring:message code='ezTask.t992' />");
					}
				});
		    }
	        
	        function leftResize(){
	        	$(".taskListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<div class="left_title" title="<spring:message code='ezSchedule.t1011'/>"><spring:message code='ezSchedule.t1011'/>
	        	<span onClick="Function_Flag(11)" class="sub_iconLNB tree_leftconfig" title="<spring:message code='ezTask.hyh001'/>"></span>
	        </div>
	        <div class="btn_writeBox" onclick="WritePopup()">
	        	<p class="btn_write01"><span class="sub_iconLNB tree_write"></span><spring:message code='ezTask.t113' /></p>
	        </div>
	        <div class="taskListBox" style="overflow:hidden; padding-right: 0;">
		        <ul class="lnbUL">
		        	<div class="tree">
		            	<span>
		                	<span>
		                    	<span>
		                        	<div class="node_div" id='Task' onclick="Function_Flag(3)">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_task_general"></span><span class="h2_text"><spring:message code='ezTask.t200901' /><span id="taskCnt" style="padding-left:10px"></span></span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div" id="Task2" onclick="Function_Flag(12)">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_task_repeat"></span><span class="h2_text"><spring:message code='ezTask.t200902' /><span id="task2Cnt" style="padding-left:10px"></span></span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div" id="Task3" onclick="Function_Flag(13)">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_task_out"></span><span class="h2_text"><spring:message code='ezTask.t200903' /><span id="task3Cnt" style="padding-left:10px"></span></span>
		                            </div>
		                    	</span>
		                    </span>        
		                </span>
		            </div>
		        </ul>
		        <ul class="lnbUL">
		        	<div class="tree">
		            	<span>
		                	<span>
		                    	<span>
		                        	<div class="node_div" onclick="Function_Flag(7)">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_search"></span><span class="h2_text"><spring:message code='ezTask.t180' /></span>
		                            </div>
		                    	</span>
		                    </span>        
		                </span>
		            </div>
		        </ul>
	        </div>
	    </div>
	</body>
	</body>
</html>