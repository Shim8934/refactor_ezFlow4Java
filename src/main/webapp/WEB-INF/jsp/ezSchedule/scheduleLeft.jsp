<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_community</title>
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />		
	    <link rel="stylesheet" href="/css/ezSchedule/Calendar_cross.css" type="text/css" />
	    <style>
	    	#iYear {
	    		width:60px;
	    	}
	    	#iMon {
	    		width:40px;
	    	}	    				
			
			/* Hide the browser's default checkbox */
			.IDcontainer input {
			    position: absolute;
			    opacity: 0;
			    cursor: pointer;
			}
			
			/* Create a custom checkbox */
			.checkmark {
			    position: absolute;
			    top: 0;
			    left: 0;
			    height: 16px;
			    width: 16px;
			    background-color: #eee;
			    border-radius: 4px;
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
			    width: 3px;
			    height: 7px;
			    border: solid white;
			    border-width: 0 3px 3px 0;
			    -webkit-transform: rotate(45deg);
			    -ms-transform: rotate(45deg);
			    transform: rotate(45deg);
			}
			
	    </style>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/Holiday.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/address_tree_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/Controls/treeview.htc.js"></script>
	    <!-- <script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarMini_Cross.js"></script> -->
	    <script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarView_Cross.js"></script>  
	    <script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarDataPro_Cross.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>

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
			
			/* var chk_total = $("input[name=chk_schedule]:checked").length;
			var chk_fullLength = $("input[name=chk_schedule]").length; */
			
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
			   for (var i = 0; i < All.length; i++)       {
			     if (All[i].getAttribute(attribute) == value) { return All[i]; }
			   }
			}
			
			//2018-06-18 구해안 checkbox에 대한 css 변환 함수
			function chk_DisplayChange() {
				var chk_str =  "";
				var chk_total = $("input[name=chk_schedule]:checked").length;
				var chk_fullLength = $("input[name=chk_schedule]").length;

				if(typeCal == 0) {		
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
				}else if(typeCal == 1) {
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
				}else{
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
			
			/* 2018-06-11 left에서 holiday 호출할 필요 없어서 주석처리 */	   	    
		    /* function schedule_get_holiday() {
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezSchedule/scheduleGetHoliday.do",
		    		data : {
		    			COMPANYID  : "VIEW"		    			
		    		},
		    		success: function(text){
		    			XmlNodeText = text;
			            XmlNode = loadXMLString(XmlNodeText);
			            
			            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
			                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1") {
			                    var issolar;
			                    var holiday;
			                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1")
			                        issolar = "1";
			                    else
			                        issolar = "2";
			                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1")			                    	
			                        holiday = true;			                    
			                    else
			                        holiday = false;
			                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1") {
			                        memorialDays.push(new memorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
			                    }
			                    else {                   	
			                        yearmemorialDays.push(new yearmemorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
			                    }
			                }
			            }			            
			            CalendarMiniDataSource(XmlNode);
		    		}
		    	});
		    } */
	
	        document.onselectstart = function () { return false; };
	        window.onload = function () {	        	
	        	
	            if (pStartday == 1)
	                DefaultView = 1
	            else
	                DefaultView = 0
	            /* CalendarMiniView("CalendarMini"); */

	            /* schedule_get_holiday(); */

	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }

	            if ("WEB" == _subCode) {
	                if ("3" == _funCode) {
	                    WebPartToggle(level1El.item(1));
	                }
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
	        }
	        function skinChange(v_data) {
	            if (v_data == "2") {
	                document.getElementById("pims1").style.display = "block";
	                document.getElementById("pims2").style.display = "none";
	                document.getElementById("pims3").style.display = "none";
	            }
	            else if (v_data == "4") {
	                document.getElementById("pims1").style.display = "none";
	                document.getElementById("pims2").style.display = "block";
	                document.getElementById("pims3").style.display = "none";
	            }
	            else if (v_data == "3") {
	                document.getElementById("pims1").style.display = "none";
	                document.getElementById("pims2").style.display = "block";
	                document.getElementById("pims3").style.display = "none";
	            }
	            else {
	                document.getElementById("pims1").style.display = "none";
	                document.getElementById("pims2").style.display = "none";
	                document.getElementById("pims3").style.display = "block";
	            }
	        }
	        
		    function Function_Flag(v_data, subfolder) {
		        skinChange(v_data);

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
		                window.open("/ezSchedule/scheduleConfigMain.do", "right");
		                break;
		        }
		    }		   
		
	        function WebPartToggle(obj) {
	            if (obj.listNum && currentListNum != obj.listNum + 1) {
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

	            setMenu(level2El.item(obj.listNum));
	        }		       

	        function MonthMiniDbClick(obj) {
	            if (_funCode == 2)
	                parent.frames["right"].WriteDateSchedule_left(obj)
	        }
		</script>
	</head>

	<body class="leftbody">
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
						<label class="IDcontainer" onchange="chk_DisplayChange()"><spring:message code='ezSchedule.t372'/>${sec.secName }
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
						<label class="IDcontainer" onchange="chk_DisplayChange()"><spring:message code='ezSchedule.t373'/>${dep.deptName }
						  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${dep.deptId }" class="checkSelect">
						  <span class="checkmark" style="background-color:#01b43f;"></span>
						</label>
					</c:forEach>
				</c:if>
				<c:if test='${!empty scheCum}'>
					<c:forEach var="cum" items="${scheCum}">
						<c:if test="${cum.deptId ne loginVO.deptID}">
							<label class="IDcontainer" onchange="chk_DisplayChange()"><spring:message code='ezSchedule.t373'/>${cum.titleName }
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
						<label class="IDcontainer" onchange="chk_DisplayChange()"><spring:message code='ezSchedule.t375'/>${group.groupName }
						  <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="7" value="${group.groupId }" class="checkSelect">
						  <span class="checkmark" style="background-color:#e9de13;"></span>
						</label>
					</c:forEach>
				</c:if>
		    	</div>
		    	<!-- 2018-06-08 구해안 일정관리 탭 삭제 -->
			    <%-- <li style="border-top:1px solid #dedede" evt="0"><span id='Schedule_Main' onClick="Function_Flag(2)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1010'/></span></li> --%>
	            <li style="border-top:1px solid #f0f0f0" evt="0"><span id='Schedule_Group' onClick="Function_Flag(5)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t252'/></span></li>
			    <li evt="0"><span id='Schedule_Search' onClick="Function_Flag(6)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1018'/></span></li>
			    <li evt="0"><span id='Schedule_Public_Search' onClick="Function_Flag(10)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1021'/></span></li>
		    </ul>
		    <h2><span id='Task' onClick="Function_Flag(3)" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1011'/></span></h2>
		    <ul>
			    <%-- <li><span id='Task_Main' onClick="Function_Flag(3)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1011'/></span></li> --%>
			    <li><span id='Task_Search' onClick="Function_Flag(7)" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezSchedule.t1019'/></span></li>
		    </ul>
	        <h3><span id='Schedule_Config' onClick="Function_Flag('11')" style="width:100%;display:inline-block;"><spring:message code='ezSchedule.t1012'/></span></h3>
		</div>		
	    <script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    
	</body>
</html>