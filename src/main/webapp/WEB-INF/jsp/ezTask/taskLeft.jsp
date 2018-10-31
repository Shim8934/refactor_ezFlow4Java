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
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>

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
	        }
	        function skinChange(v_data) {
	            if (v_data == "2") {
	                //document.getElementById("pims1").style.display = "block";
	                //document.getElementById("pims2").style.display = "none";
	                //document.getElementById("pims3").style.display = "none";
	            }
	            else if (v_data == "4") {
	                //document.getElementById("pims1").style.display = "none";
	                //document.getElementById("pims2").style.display = "block";
	                //document.getElementById("pims3").style.display = "none";
	            }
	            else if (v_data == "3") {
	            //    document.getElementById("pims1").style.display = "none";
	               // document.getElementById("pims2").style.display = "block";
	              //  document.getElementById("pims3").style.display = "none";
	            }
	            else {
	               // document.getElementById("pims1").style.display = "none";
	             //   document.getElementById("pims2").style.display = "none";
	              //  document.getElementById("pims3").style.display = "block";
	            }
	        }
	        
		    function Function_Flag(v_data, subfolder) {
		        skinChange(v_data);

		        v_data = parseInt(v_data);
		        _funCode = v_data;

		        switch (v_data) {
		            case 3:		// Task
		                window.open("/ezTask/taskMain.do", "right");		                
		                break;

		            case 7:		// Search Task
		                window.open("/ezTask/taskSearch.do", "right");
		                break;
		            
		            case 11:		// Search public calendar
		            	$('.checkSelect').each(function() {
				            $(this).prop('checked',true);			            
				        });
		            	$('#select-all').prop('checked',true);
		            	$('#IDClick').css('pointer-events','none');
		                window.open("/ezSchedule/scheduleConfigMain.do", "right");
		                break;
		                
		            case 12:		// repeat task
		            	window.parent.frames["right"].ChangeTab(window.parent.frames["right"].document.getElementById('1tab3'));		            	
		            	break;
		            	
		            case 13:		// send task
		            	window.parent.frames["right"].ChangeTab(window.parent.frames["right"].document.getElementById('1tab2'));
		            	break;
		        }
		    }		   
		
	        function WebPartToggle(obj) {
	            /* if (obj.listNum && currentListNum != obj.listNum + 1) {
	                level1El.item(currentListNum - 1).className = null;
	                level2El.item(currentListNum - 1).className = "off";
	            }

	            if (level2El.item(obj.listNum).className == "on") {
	                level1El.item(obj.listNum).className = null;
	                level2El.item(obj.listNum).className = "off";
	            }
	            else {
	                level1El.item(obj.listNum).className = "on";
	                level2El.item(obj.listNum).className = "on";
	            }

	            currentListNum = obj.listNum + 1;

	            setMenu(level2El.item(obj.listNum)); */
	        }
	        
	        // 업무작성창 load
	        function WritePopup() {
	        	window.parent.frames["right"].WriteTask();
	        }
	        
	        function cntLoad() {
	        	if (window.parent.frames["right"].cnt > 0) {
	        		$("#taskCnt").html(window.parent.frames["right"].cnt);
	        	}
	        	if (window.parent.frames["right"].cnt3 > 0) {
	        		$("#task2Cnt").html(window.parent.frames["right"].cnt3);	
	        	}
	        	if (window.parent.frames["right"].cnt2 > 0) {
	        		$("#task3Cnt").html(window.parent.frames["right"].cnt2);	        		
	        	}
	        }
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezSchedule.t1011'/>"><spring:message code='ezSchedule.t1011'/>
	        	<span class="sub_iconLNB tree_leftconfig" title="업무관리환경설정"></span>
	        </div>
	        <div class="btn_writeBox" onclick="WritePopup()">
	        	<p class="btn_write01"><span class="sub_iconLNB tree_write"></span><spring:message code='ezTask.t113' /></p>
	        </div>
	        <ul class="lnbUL">
	        	<div class="tree">
	            	<span>
	                	<span>
	                    	<span>
	                        	<div class="node_div" id='Task' onclick="Function_Flag(3)">
	                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_task_general"></span><span class="h2_text"><spring:message code='ezTask.t200901' /><span id="taskCnt" style="padding-left:5px"></span></span>
	                            </div>
	                    	</span>
	                        <span>
	                        	<div class="node_div" id="Task2" onclick="Function_Flag(12)">
	                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_task_repeat"></span><span class="h2_text"><spring:message code='ezTask.t200902' /><span id="task2Cnt" style="padding-left:5px"></span></span>
	                            </div>
	                    	</span>
	                        <span>
	                        	<div class="node_div" id="Task3" onclick="Function_Flag(13)">
	                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_task_out"></span><span class="h2_text"><spring:message code='ezTask.t200903' /><span id="task3Cnt" style="padding-left:5px"></span></span>
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
	</body>
<%-- 	<body class="leftbody">
        <div class="left_pims" title="<spring:message code='ezSchedule.t1010'/>"><span><spring:message code='ezSchedule.t1010'/></span></div>
        <input type="hidden" id="chk_str" value="">
	    <div id="left">
	    	
	        <div class="left_pims1" title="<spring:message code='ezSchedule.t1010'/>" id='pims1'></div>
		    <div class="left_pims2" title="<spring:message code='ezSchedule.t1017'/>" id='pims2' style="display:none"></div>
		    <div class="left_pims3" title="<spring:message code='ezSchedule.t1011'/>" id='pims3' style="display:none"></div>
		    <h2 class="on"><span id="Schedule" onclick="Function_Flag(2)" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1010'/></span></h2>
		    <ul>		
		    	<!-- 2018-06-07 구해안 mini 호출하는 부분 삭제하고 체크박스 생성 -->    	
		    	<!-- <div id="CalendarMini" style="padding-top:5px;margin:0px 10px 10px 10px;"></div> -->
		    	<div id="IDClick">
		    	<!-- 2018-07-11 구해안 left 체크박스 label에 title 삽입 -->
		    	<label class="IDcontainer" onchange="chk_all()"><spring:message code='ezSchedule.t220'/>
				  <input type="checkbox" checked="checked" name="select-all" id="select-all" value="chkAllFalse">
				  <span class="checkmark"></span>
				</label>
				<label class="IDcontainer" onchange="chk_DisplayChange()"><spring:message code='ezSchedule.t221'/>
				  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="1" value="${loginVO.id}" class="checkSelect">
				  <span class="checkmark" style="background:#018bfa;"></span>
				</label>
				<c:if test='${!empty scheSec}'>
					<c:forEach var="sec" items="${scheSec}">
						<label class="IDcontainer" onchange="chk_DisplayChange()"><span class="chk_tooltip" title="${sec.secName }"style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><spring:message code='ezSchedule.t372'/>${sec.secName }</span>
						  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="1" value="${sec.secId }" class="checkSelect">
						  <span class="checkmark" style="background-color:#018bfa;"></span>
						</label>
					</c:forEach>
				</c:if>
					<label class="IDcontainer" onchange="chk_DisplayChange()"><spring:message code='ezSchedule.t222'/>
					  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${loginVO.deptID}" class="checkSelect">
					  <span class="checkmark" style="background:#01b43f;"></span>
					</label>
				
				<c:if test='${!empty scheDept}'>
					<c:forEach var="dep" items="${scheDept}">
						<label class="IDcontainer" onchange="chk_DisplayChange()"><span class="chk_tooltip" title="${dep.deptName }"style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><spring:message code='ezSchedule.t373'/>${dep.deptName }</span>
						  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${dep.deptId }" class="checkSelect">
						  <span class="checkmark" style="background-color:#01b43f;"></span>
						</label>
					</c:forEach>
				</c:if>
				<c:if test='${!empty scheCum}'>
					<c:forEach var="cum" items="${scheCum}">
						<c:if test="${cum.deptId ne loginVO.deptID}">
							<label class="IDcontainer" onchange="chk_DisplayChange()"><span class="chk_tooltip" title="${cum.titleName }" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><spring:message code='ezSchedule.t373'/>${cum.titleName }</span>
							  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${cum.deptId }" class="checkSelect">
							  <span class="checkmark" style="background-color:#01b43f;"></span>
							</label>
						</c:if>
					</c:forEach>
				</c:if>
				<label class="IDcontainer" onchange="chk_DisplayChange()"><spring:message code='ezSchedule.t223'/>
				  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="3" value="${loginVO.companyID}" class="checkSelect">
				  <span class="checkmark" style="background:#ff1c71;"></span>
				</label>
				<c:if test='${!empty groupList}'>
					<c:forEach var="group" items="${groupList}">
						<label class="IDcontainer" onchange="chk_DisplayChange()"><span class="chk_tooltip" title="${group.groupName }" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><spring:message code='ezSchedule.t375'/>${group.groupName }</span>
						  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="7" value="${group.groupId }" class="checkSelect">
						  <span class="checkmark" style="background-color:#e9de13;"></span>
						</label>
					</c:forEach>
				</c:if>
		    	</div>
		    	<!-- 2018-06-08 구해안 일정관리 탭 삭제 -->
			    <li style="border-top:1px solid #dedede" evt="0"><span id='Schedule_Main' onClick="Function_Flag(2)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1010'/></span></li>	            
				<li style="border-top:1px solid #eaeaea" evt="0"><span id='Schedule_Group' onClick="Function_Flag(5)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t252'/></span></li>
			    <li evt="0"><span id='Schedule_Search' onClick="Function_Flag(6)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1018'/></span></li>
			    <li evt="0"><span id='Schedule_Public_Search' onClick="Function_Flag(10)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1021'/></span></li>
		    </ul>
		    <h2><span id='Task' onClick="Function_Flag(3)" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1011'/></span></h2>
		    <ul>
			    <li><span id='Task_Main' onClick="Function_Flag(3)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1011'/></span></li>
			    <li><span id='Task_Search' onClick="Function_Flag(7)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1019'/></span></li>
		    </ul>
	        <h3><span id='Schedule_Config' onClick="Function_Flag('11')" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1012'/></span></h3>
		</div>		
	    <script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script> --%>
	    
	</body>
</html>