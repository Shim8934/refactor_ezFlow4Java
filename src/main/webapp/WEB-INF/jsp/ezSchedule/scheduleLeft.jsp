<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_schedule</title>
		<link rel="stylesheet" href="${util.addVer('/css/email_tree.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />		
	    <link rel="stylesheet" href="${util.addVer('/css/ezSchedule/Calendar_cross.css')}" type="text/css" />
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
			/* Hide the browser's default checkbox */
			.IDcontainer input {
			    position: absolute;
			    opacity: 0;
			    cursor: pointer;
			}
			
			/* Create a custom checkbox */
			.checkmark {
			    position: absolute;
			    top: 10px;
			    left: 16px;
			    height: 13px;
			    width: 13px;
			    background-color: #eee;
			}
									
			/* When the checkbox is checked, add a blue background */
			.IDcontainer input:checked ~ .checkmark {
			    background-color: #ccc;
			}
			
			/* Create the checkmark/indicator (hidden when not checked) */
			.checkmark:after {
			    content: "";
			    position: absolute;
			    display: none;
			}
			
			/* Show the checkmark when checked */
			.IDcontainer input:checked ~ .checkmark:after {
			    display: block;
			}
			
			/* Style the checkmark/indicator */
			.IDcontainer .checkmark:after {
			    left: 5px;
			    top: 1px;
			    width: 2px;
			    height: 6px;
			    border: solid white;
			    border-width: 0 2px 2px 0;
			    -webkit-transform: rotate(45deg);
			    -ms-transform: rotate(45deg);
			    transform: rotate(45deg);
			}
			/* 2018-08-03 김보미 - 그룹명이 길 경우 처리 */
			.IDcontainer {
			    white-space: nowrap;
			    overflow: hidden;
			    text-overflow: ellipsis;
			    font-family:Malgun Gothic, malgun gothic;
			    font-size: 13px;
			    padding-top:0px;
			    margin:0px;
			    width:150px
			}
			
			.IDcontainer span {
				font-family:Malgun Gothic, malgun gothic;
			}
			
			/* 2018-08-03 김보미 - 클릭시마다 앞의 체크박스 ui 틀어지는 현상 막기 */
			.IDcontainer .checkSelect {
				display: none;
			}
			
			.IDcontainer .h2_text {
				width: 150px;
				margin-left:7px;
			}
			#mCSB_1_container {
				margin-right: 0px;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/address_tree_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/Controls/treeview.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarView_Cross.js')}"></script>  
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarDataPro_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    
	    <script type="text/javascript">
	    	var UserOffset = "${userOffset}";
	        var _funCode = "<c:out value='${funCode}'/>";
	        var _subCode = "<c:out value='${subCode}'/>";
	        var defaultView = "<c:out value='${defaultView}'/>";
	        var pStartday = "<c:out value='${startDay}'/>";
	        var uselang = "<c:out value='${lang}'/>";
	        var xmlDom_treeview = createXmlDom();	        
	        var ch_selected = false;
			var totalCnt = 0;
			var sStartDate;
			var sEndDate;
			var typeCal;
			
			//2018-06-08 구해안 left checkbox checkall			
			function chk_all(){
			    if($('#select-all').is(":checked")) {			    	
			        $('.checkSelect').each(function() {
			            $(this).prop('checked',true);			            
			        });
			        /* chk_IDchange(); */
			        chk_DisplayChange();
			    } else {			    	
			        $('.checkSelect').each(function() {
			            $(this).prop('checked',false);  			            
			        });
			        /* chk_IDchange(); */
			        chk_DisplayChange();
			    }
			}   
			function FindByAttributeValue(attribute, value, element_type)    {
				element_type = element_type || "*";
			   	var All = document.getElementsByTagName(element_type);
			   
			   	for (var i = 0; i < All.length; i++) {
					if (All[i].getAttribute(attribute) == value) { 
			    		 return All[i]; 
					}
			   	}
			}
			
			//2018-06-18 구해안 checkbox에 대한 css 변환 함수
			function chk_DisplayChange() {
				var chk_str =  "";
				var chk_total = $("input[name=chk_schedule]:checked").length;
				var chk_fullLength = $("input[name=chk_schedule]").length;

				if (typeCal == 0) {		
					$("input[name=chk_schedule]").each(function(index){
						var chk_eachVal1 = $(this).val();
						var chk_type=$(this).data("schedule-type")
						
						$('.td_list td[ownerid = "'+chk_eachVal1+'"][scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){							
							$(value).addClass('chk_noneDisplay');
						});
					});
					$("input[name=chk_schedule]:checked").each(function(index) {
						var test = $(this).val();
						var chk_type = $(this).data("schedule-type");
						
						$('.td_list td[ownerid = "'+test+'"][scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){
							$(value).removeClass('chk_noneDisplay');
						});
					});					
				} else if (typeCal == 1) {
					$("input[name=chk_schedule]").each(function(index){
						var chk_eachVal1 = $(this).val();
						var chk_type = $(this).data("schedule-type");
						
						$('div[ownerid = "'+chk_eachVal1+'"][scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){
							$(value).addClass('chk_noneDisplay');
						});
					});
					$("input[name=chk_schedule]:checked").each(function(index) {
						var test = $(this).val();
						var chk_type = $(this).data("schedule-type");
						
						$('div[ownerid = "'+test+'"][scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){
							$(value).removeClass('chk_noneDisplay');
						});
					});	
				} else {
					$("input[name=chk_schedule]").each(function(index){
						var chk_eachVal1 = $(this).val();
						var chk_type = $(this).data("schedule-type");
						
						$('div[ownerid = "'+chk_eachVal1+'"][scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){
							$(value).addClass('chk_noneDisplay');
						});
					});
					$("input[name=chk_schedule]:checked").each(function(index) {
						var test = $(this).val();
						var chk_type = $(this).data("schedule-type");
						
						$('div[ownerid = "'+test+'"][scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){
							$(value).removeClass('chk_noneDisplay');
						});						
					});	
				}
				
				if(chk_total > 0 && chk_total < chk_fullLength) {
					$('#select-all').prop('checked',false);					
				} else if(chk_total == chk_fullLength) {
					$('#select-all').prop('checked',true);	
				} else if(chk_total == 0){
					chk_str += $('#select-all').val();
				}
			}
			
			//2018-06-08 구해안 left checkbox 함수
			function chk_IDchange() {
				if($(parent.frames["left"].document.getElementById("secretarySelect")).val() != "" && $(parent.frames["left"].document.getElementById("secretarySelect")).val() != null){
					$("input[name=chk_schedule]:checked").each(function(index) {
						var test = $(this).val();
						chk_str += "\'"+test+"\',";
						
						if (index === chk_total-1){
							chk_str += "\'"+test+"\'";
						}					
					});
					
					if(chk_total > 0 && chk_total < chk_fullLength) {
						$('#select-all').prop('checked',false);					
					} else if(chk_total == chk_fullLength) {
						$('#select-all').prop('checked',true);	
					} else if(chk_total == 0){
						chk_str += $('#select-all').val();
					}
					
					/* sStartDate = parent.frames["right"].document.getElementById("hiddensStartDate").value;
					sEndDate = parent.frames["right"].document.getElementById("hiddensEndDate").value; */
					$('#chk_str').val(chk_str);
					parent.frames["right"].CalendarView("Calendar",chk_str);
					/* CalendarDataSource(chk_str, sStartDate, sEndDate); */
					
				}else{					
					$("input[name=chk_schedule]:checked").each(function(index) {
						var test = $(this).val();
						chk_str += "\'"+test+"\',";
						
						if (index === chk_total-1){
							chk_str += "\'"+test+"\'";
						}					
					});
					
					if(chk_total > 0 && chk_total < chk_fullLength) {
						$('#select-all').prop('checked',false);					
					} else if(chk_total == chk_fullLength) {
						$('#select-all').prop('checked',true);	
					} else if(chk_total == 0){
						chk_str += $('#select-all').val();
					}
										
					/* sStartDate = parent.frames["right"].document.getElementById("hiddensStartDate").value;
					sEndDate = parent.frames["right"].document.getElementById("hiddensEndDate").value; */
					$('#chk_str').val(chk_str);
					parent.frames["right"].CalendarView("Calendar",chk_str);
					/* CalendarDataSource(chk_str, sStartDate, sEndDate); */
				}
			}
				
			select_memorialDays(uselang);
	
	        document.onselectstart = function () { return false; };
	        window.onload = function () {
	        	leftResize();
	            if (pStartday == 1) {
	                DefaultView = 1;
	            } else {
	                DefaultView = 0;
	            }

	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }

	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {	    
	                if ("2" == _funCode) {
	                    //document.getElementById('Schedule_Main').parentElement.onclick();
	                    Function_Flag(2);
	                }
	                else if ("6" == _funCode) {
	                    //document.getElementById('Schedule_Search').parentElement.onclick();
	                    document.getElementById('Schedule_Search').onclick();
	                }
	                else if ("10" == _funCode) {
	                    //document.getElementById('Schedule_Public_Search').parentElement.onclick();
	                    document.getElementById('Schedule_Public_Search').onclick();
	                }
	                else if ("3" == _funCode) {
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
	                if ("2" == _funCode) {
	                	Function_Flag(2);
	                }
	                else if ("6" == _funCode) {
	                    document.getElementById('Schedule_Search').click();
	                }
	                else if ("10" == _funCode) {
	                    document.getElementById('Schedule_Public_Search').click();
	                }
	                else if ("3" == _funCode) {
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
	            $(".scheduleListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
	        }
	        
		    function Function_Flag(v_data, subfolder) {
		        v_data = parseInt(v_data);
		        _funCode = v_data;

		        switch (v_data) {
		            case 2:		// Schedule
		            	$('#IDClick').css('pointer-events','');		            
		                window.open("/ezSchedule/scheduleMain.do?funCode=2", "right");
		                break;

		            case 3:		// Task
		                window.open("/ezTask/taskMain.do", "right");
		                break;

		            case 5:		// schedule group management 
		            	$('.checkSelect').each(function() {
				            $(this).prop('checked',true);			            
				        });
		            	$('#select-all').prop('checked',true);
		            	$('#IDClick').css('pointer-events','none');
		                window.open("/ezSchedule/scheduleManageGroup.do", "right")
		                break;

		            case 6:		// schedule search
		            	$('.checkSelect').each(function() {
				            $(this).prop('checked',true);			            
				        });
		            	$('#select-all').prop('checked',true);
		            	$('#IDClick').css('pointer-events','none');
		                window.open("/ezSchedule/scheduleSearch.do", "right")
		                break;

		            case 7:		// Search Task
		                window.open("/ezTask/taskSearch.do", "right");
		                break;

		            case 10:	// Search public search
		            	$('.checkSelect').each(function() {
				            $(this).prop('checked',true);			            
				        });
		            	$('#select-all').prop('checked',true);
		            	$('#IDClick').css('pointer-events','none');
		                window.open("/ezSchedule/schedulePublicSearch.do", "right");
		                break;
		            case 11:		// Search public calendar
		            	$('.checkSelect').each(function() {
				            $(this).prop('checked',true);			            
				        });
		            	$('#select-all').prop('checked',true);
		            	$('#IDClick').css('pointer-events','none');
		                window.open("/ezSchedule/scheduleConfigMain.do?flag=schedule", "right");
		                break;
		        }
		    }
	        
	        function WriteSchedule() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
                   
	            var feature = GetOpenPosition(790, 760);
	            
				window.open("/ezSchedule/scheduleWrite.do?defaultid=0", "", "height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
	        
	        function leftResize(){
	        	$(".scheduleListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
		</script>
	</head>

	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<input type="hidden" id="chk_str" value="" />
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezSchedule.t1010'/>">
	    		<spring:message code='ezSchedule.t1010'/>
	        	<span id='Schedule_Config' onClick="Function_Flag('11')" class="sub_iconLNB tree_leftconfig" title="<spring:message code='ezSchedule.t1012'/>"></span>
	        </div>
	        <div class="btn_writeBox" onclick="WriteSchedule()">
	        	<p class="btn_write01"><span class="sub_iconLNB tree_write"></span><spring:message code='ezSchedule.t214'/></p>
	        </div>
        	<div class="scheduleListBox" style="overflow:hidden; padding-right: 0;">
		        <ul class="lnbUL">
		        	<div class="tree" style="overflow:hidden;">
			    		<!-- 2018-07-11 구해안 left 체크박스 label에 title 삽입 -->
			    		<label class="IDcontainer" onchange="chk_all()">
			    			<span class="h2_text"><spring:message code='ezSchedule.t220'/></span>
							<input type="checkbox" checked="checked" name="select-all" id="select-all" value="chkAllFalse" style="left:0px">
					  		<span class="checkmark" style="background:rgb(125, 125, 125);"></span>
						</label>
						<span class="sub_iconLNB tree_manage" style="position:absolute;top:10px;right:11px" onClick="Function_Flag(5)"></span>
						<label class="IDcontainer" onchange="chk_DisplayChange()">
							<span class="h2_text"><spring:message code='ezSchedule.t221'/></span>
					  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="1" value="${loginVO.id}" class="checkSelect">
					  		<span class="checkmark" style="background:rgb(1, 138, 249);"></span>
						</label>
						<c:if test='${!empty scheSec}'>
							<c:forEach var="sec" items="${scheSec}">
								<label class="IDcontainer" onchange="chk_DisplayChange()">
									<span class="h2_text" title="${sec.secName }"><spring:message code='ezSchedule.t372'/>${sec.secName }</span>
							 	 	<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="1" value="${sec.secId }" class="checkSelect">
								  	<span class="checkmark" style="background-color:rgb(1, 138, 249);"></span>
								</label>
							</c:forEach>
						</c:if>
						<label class="IDcontainer" onchange="chk_DisplayChange()">
							<span class="h2_text"><spring:message code='ezSchedule.t222'/></span>
							<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${loginVO.deptID}" class="checkSelect">
						  	<span class="checkmark" style="background:rgb(1, 179, 63);"></span>
						</label>				
						<c:if test='${!empty scheDept}'>
							<c:forEach var="dep" items="${scheDept}">
								<label class="IDcontainer" onchange="chk_DisplayChange()">
									<span class="h2_text" title="${dep.deptName }"><spring:message code='ezSchedule.t373'/>${dep.deptName }</span>
							  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${dep.deptId }" class="checkSelect">
							  		<span class="checkmark" style="background-color:rgb(1, 179, 63);"></span>
								</label>
							</c:forEach>
						</c:if>
						<c:if test='${!empty scheCum}'>
							<c:forEach var="cum" items="${scheCum}">
								<c:if test="${cum.deptId ne loginVO.deptID}">
									<label class="IDcontainer" onchange="chk_DisplayChange()">
										<span class="h2_text" title="${cum.titleName }"><spring:message code='ezSchedule.t373'/>${cum.titleName }</span>
										<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${cum.deptId }" class="checkSelect">
									  	<span class="checkmark" style="background-color:rgb(1, 179, 63);"></span>
									</label>
								</c:if>
							</c:forEach>
						</c:if>
						<label class="IDcontainer" onchange="chk_DisplayChange()">
							<span class="h2_text"><spring:message code='ezSchedule.t223'/></span>
					  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="3" value="${loginVO.companyID}" class="checkSelect">
					  		<span class="checkmark" style="background:rgb(254, 28, 113);"></span>
						</label>
						<c:if test='${!empty groupList}'>
							<c:forEach var="group" items="${groupList}">
								<label class="IDcontainer" onchange="chk_DisplayChange()">
									<span class="h2_text" title="${group.groupName }"><spring:message code='ezSchedule.t375'/>${group.groupName }</span>
							  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="7" value="${group.groupId }" class="checkSelect">
							  		<span class="checkmark" style="background-color:#e9de13;"></span>
								</label>
							</c:forEach>
						</c:if>
			    	</div>
		        </ul>
		        <ul class="lnbUL">
		        	<div class="tree" style="overflow:hidden;">
		            	<span>
		                	<span>
		                    	<span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_search"></span><span class="h2_text" onClick="Function_Flag(6)"><spring:message code='ezSchedule.t1018'/></span>
		                            </div>
		                    	</span>
		                        <span>
		                        	<div class="node_div">
		                            	<span class="sub_iconLNB tree_blank"></span><span class="sub_iconLNB tree_pims_search_open"></span><span class="h2_text" onClick="Function_Flag(10)"><spring:message code='ezSchedule.t1021'/></span>
		                            </div>
		                    	</span>
		                    </span>        
		                </span>
		            </div>
		        </ul>
	        </div>
	    </div>
	    
	    <%-- 2018-10-18 장진혁 / 기존 schedule left 백업 --%>
        <%-- <div class="left_pims" title="<spring:message code='ezSchedule.t1010'/>"><span><spring:message code='ezSchedule.t1010'/></span></div>
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
					  <span class="checkmark" style="background:rgb(1, 179, 63);"></span>
					</label>
				
				<c:if test='${!empty scheDept}'>
					<c:forEach var="dep" items="${scheDept}">
						<label class="IDcontainer" onchange="chk_DisplayChange()"><span class="chk_tooltip" title="${dep.deptName }"style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><spring:message code='ezSchedule.t373'/>${dep.deptName }</span>
						  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${dep.deptId }" class="checkSelect">
						  <span class="checkmark" style="background-color:rgb(1, 179, 63);"></span>
						</label>
					</c:forEach>
				</c:if>
				<c:if test='${!empty scheCum}'>
					<c:forEach var="cum" items="${scheCum}">
						<c:if test="${cum.deptId ne loginVO.deptID}">
							<label class="IDcontainer" onchange="chk_DisplayChange()"><span class="chk_tooltip" title="${cum.titleName }" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><spring:message code='ezSchedule.t373'/>${cum.titleName }</span>
							  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${cum.deptId }" class="checkSelect">
							  <span class="checkmark" style="background-color:rgb(1, 179, 63);"></span>
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