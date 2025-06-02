<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_schedule</title>
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/ezSchedule/Calendar_cross.css')}" type="text/css" />
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
			/* Hide the browser's default checkbox */
	        .IDcontainer input {display:none; cursor: pointer; }
	
	        /* Create a custom checkbox */
	        .checkmark {float:left; height: 13px; width: 13px; margin-top:9px; background-color: #eee; border-radius:3px;}
	
	        /* When the checkbox is checked, add a blue background */
	        .IDcontainer input:checked ~ .checkmark { background-color: #ccc; }
	
	        /* Create the checkmark/indicator (hidden when not checked) */
	        .checkmark:after { content: ""; display: none; }
	
	        /* Show the checkmark when checked */
	        .IDcontainer input:checked ~ .checkmark:after { display: block; }
	
	        /* Style the checkmark/indicator */
	        .IDcontainer .checkmark:after {position:relative; width: 2px; height: 6px; margin:2px auto 0px auto; border: solid white; border-width: 0 1px 1px 0; -webkit-transform: rotate(45deg); -ms-transform: rotate(45deg); transform: rotate(45deg); }
	        /* 2018-08-03 김보미 - 그룹명이 길 경우 처리 */
	        .IDcontainer { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-family: Malgun Gothic, malgun gothic; font-size: 13px; padding-top: 0px; padding-left:0px; margin: 0px; }
	
	        /* 2018-08-03 김보미 - 클릭시마다 앞의 체크박스 ui 틀어지는 현상 막기 */
	        .IDcontainer .checkSelect { display: none; }
	
	        #mCSB_1_container { margin-right: 0px; }

			.node_selected { width: inherit; }
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
// 			var isCalendarView = true;
			var useWorkspaceSchedule = "<c:out value='${useWorkspaceSchedule}'/>";
			var jsonPersonalScheConfigList = "<c:out value='${jsonPersonalScheConfigList}'/>";
			
			//2018-06-08 구해안 left checkbox checkall			
			function chk_all(){
			    if($('#select-all').is(":checked")) {			    	
			        $('.checkSelect').each(function() {
			            $(this).prop('checked',true);			            
			        });
			        /* chk_IDchange(); */
			        chk_DisplayChange();
			        chk_DisplayChange2();
			    } else {			    	
			        $('.checkSelect').each(function() {
			            $(this).prop('checked',false);  			            
			        });
			        /* chk_IDchange(); */
			        chk_DisplayChange();
			        chk_DisplayChange2();
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
				
// 				if (!isCalendarView) {
// 					isCalendarView = true;
// 					window.open("/ezSchedule/scheduleMain.do?funCode=2", "right");
// 				}
				
				var chk_str =  "";
				var chk_total = $("input[name=chk_schedule]:checked").length;
				var chk_fullLength = $("input[name=chk_schedule]").length;

				if (typeCal == 0) {
					$("input[name=chk_schedule]").each(function(index){
						var chk_eachVal1 = $(this).val();
						var chk_type = $(this).data("schedule-type")

						if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
							
							$('.td_list td[scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).addClass('chk_noneDisplay');
							});
						} else {
							
							$('.td_list td[ownerid = "' + chk_eachVal1 + '"][scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).addClass('chk_noneDisplay');
							});
						}
					});
					
					$("input[name=chk_schedule]:checked").each(function(index) {
						var test = $(this).val();
						var chk_type = $(this).data("schedule-type");
						
						if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
							
							$('.td_list td[scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){
								$(value).removeClass('chk_noneDisplay');
							});
						} else {
							
							$('.td_list td[ownerid = "' + test + '"][scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).removeClass('chk_noneDisplay');
							});
						}
					});
				} else if (typeCal == 1) {
					
					$("input[name=chk_schedule]").each(function(index){
						var chk_eachVal1 = $(this).val();
						var chk_type = $(this).data("schedule-type");

						if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
							
							$('div[scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).addClass('chk_noneDisplay');
							});
						} else {
							
							$('div[ownerid = "' + chk_eachVal1 + '"][scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).addClass('chk_noneDisplay');
							});
						}
					});
					
					$("input[name=chk_schedule]:checked").each(function(index) {
						var test = $(this).val();
						var chk_type = $(this).data("schedule-type");

						if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
							
							$('div[scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).removeClass('chk_noneDisplay');
							});
						} else {
							
							$('div[ownerid = "' + test + '"][scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).removeClass('chk_noneDisplay');
							});
						}
					});
				} else {
					
					$("input[name=chk_schedule]").each(function(index){
						var chk_eachVal1 = $(this).val();
						var chk_type = $(this).data("schedule-type");

						if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
							
							$('div[scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).addClass('chk_noneDisplay');
							});
						} else {
							
							$('div[ownerid = "' + chk_eachVal1 + '"][scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).addClass('chk_noneDisplay');
							});
						}
					});
					
					$("input[name=chk_schedule]:checked").each(function(index) {
						var test = $(this).val();
						var chk_type = $(this).data("schedule-type");

						if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
							
							$('div[scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).removeClass('chk_noneDisplay');
							});
						} else {
							
							$('div[ownerid = "' + test + '"][scheduletype = "' + chk_type + '"]', parent.frames["right"].document).each(function (index, value) {
								$(value).removeClass('chk_noneDisplay');
							});
						}
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
			
			/* select_memorialDays(uselang); */

	        document.onselectstart = function () { return false; };
	        window.onload = function () {
	        	leftResize();
	            if (pStartday == 1) {
	                DefaultView = 1;
	            } else {
	                DefaultView = 0;
	            }
				
	            var personalScheConfigList = JSON.parse(decodeHtml(jsonPersonalScheConfigList));
				
	            setUserScheduleTypeConfig(personalScheConfigList);
	            
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
	                else if ("5" == _funCode) {
	                	Function_Flag(5);
	                }
					else if ("13" == _funCode) {
						Function_Flag(13);
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
	                else if ("5" == _funCode) {
	                	Function_Flag(5);
	                }
					else if ("13" == _funCode) {
						Function_Flag(13);
					}
	            }
	            $(".scheduleListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
	        }
	        
		    function Function_Flag(v_data, subfolder) {
		    	v_data = parseInt(v_data);
		        _funCode = v_data;
		        
		        liSelected();

		        switch (v_data) {
		            case 2:		// Schedule		            
		                window.open("/ezSchedule/scheduleMain.do", "right");
		                openFolder();
		                break;

		            case 3:		// Task
		                window.open("/ezTask/taskMain.do", "right");
		                break;

		            case 6:		// schedule search
// 		            	isCalendarView = false;
		                window.open("/ezSchedule/scheduleSearch.do", "right")
		                openFolder();
		                break;

		            case 7:		// Search Task
		                window.open("/ezTask/taskSearch.do", "right");
		                break;

		            case 10:	// Search public search
// 		            	isCalendarView = false;
		                window.open("/ezSchedule/schedulePublicSearch.do", "right");
		                openFolder();
		                break;
		                
					case 5:		// schedule group management
		            case 11:	// 일정관리 환경설정
					case 13:	// 일정 모아보기, Gathering Schedule
// 		            	isCalendarView = false;
		                window.open("/ezSchedule/scheduleConfigMain.do?flag=schedule", "right");
		                
						$("h2.on").attr("class", "off");
						$(".lnbUL").attr("class", "lnbUL off");
						$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		                break;
		                
					case 12:		// Search User Calendar
// 						isCalendarView = false;
						window.open("/ezSchedule/scheduleUserCalendarSearch.do", "right");
		                openFolder();
						break;
		        }
		    }
	        
	        function WriteSchedule() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
                   
	            var feature = GetOpenPosition(790, 760);
	            
				window.open("/ezSchedule/scheduleWrite.do?defaultid=0&pageFrom=left", "", "height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
	        
	        function leftResize(){
	        	$(".scheduleListBox").height(window.innerHeight-105);
	        }
	        
	      	//2018-11-01 김보미 - 일정그룹 추가시 left바에 그룹 바로 보이도록 /* 2019-03-18 홍승비 - 단순 호출 기능을 POST -> GET 메서드로 수정 */
	        function groupRefresh() {
	        	//frm.submit();
	        	window.location.href = "/ezSchedule/scheduleLeft.do?funCode=5";
	        }

			function gatherRefresh() {
				window.location.href = "/ezSchedule/scheduleLeft.do?funCode=13";
			}

	        // 일정그룹 초대 수락 시
	        $( window ).resize(function() {
	        	leftResize();
        	});
        	
	        function leftRefresh() {
	        	//frm2.submit();
	        	window.location.href = "/ezSchedule/scheduleLeft.do";
	        } 
	        
	        function chk_DisplayChange2(obj) {
        		var chk_str =  "";
				var chk_total = $("input[name=chk_schedule]:checked").length;
				var chk_fullLength = $("input[name=chk_schedule]").length;

        		var chk_type = 4;//$
        		if (typeCal == 0) {
        			
        			$('.td_list td[scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){							
						$(value).toggleClass('chk_noneDisplay');
					});
        		} else {
        			
        			$('div[scheduletype = "'+chk_type+'"]',parent.frames["right"].document).each(function(index, value){
						$(value).toggleClass('chk_noneDisplay');
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

	        // 2023-06-30 황인경 - 디자인 개선 > 일정관리 > 좌측메뉴 > 일정검색, 공개일정검색 선택 항목 클래스 제어
	        function liSelected() {
	        	$(".list_text.node_selected").removeClass("node_selected");

	        	var liSelected = $(event.target);

	            if ((liSelected.prop("tagName") == "SPAN") && (liSelected.hasClass('list_text'))) {
	            	liSelected.addClass("node_selected");
	            }
	        }

			/* 2023-10-05 임정은 - 모아보기 그룹 클릭 이벤트 추가 (기존 참석자 초대 버튼 이벤트 참고 및 수정) */
			var schedule_add_user_cross_dialogArguments = new Array();
			function Add_UserInfo_onclick(obj) {
// 				$('.checkSelect').each(function() {
// 					$(this).prop('checked',false);
// 				});
				liSelected();
// 				isCalendarView = false;
// 				$('#select-all').prop('checked',false);

				var rtn = {"id": new Array(), "name": new Array(), "deptname": new Array()};
				var g_param = new Array();
				g_param["groupName"] = obj.getAttribute('data2');

				$.ajax({
					type: "GET",
					dataType: "xml",
					async: false,
					data: {
						groupID: obj.getAttribute('data1')
					},
					url: "/ezSchedule/getGatherDetail.do",
					success: function (text) {
						var totalLen = SelectNodes(text, "MEMBERID").length;

						for (var i = 0; i < totalLen; i++) {
							rtn["id"][i] = SelectNodes(text, "MEMBERID").item(i).textContent;
							if (uselang == "1") {
								rtn["name"][i] = SelectNodes(text, "MEMBERNAME").item(i).textContent;
								rtn["deptname"][i] = SelectNodes(text, "DESCRIPTION").item(i).textContent;
							} else {
								rtn["name"][i] = SelectNodes(text, "MEMBERNAME2").item(i).textContent;
								rtn["deptname"][i] = SelectNodes(text, "DESCRIPTION2").item(i).textContent;
							}
						}
					}
				});

				g_param["startTime"] = "";
				g_param["endTime"] = "";
				g_param["entryList"] = rtn;

				schedule_add_user_cross_dialogArguments[0] = g_param;
				schedule_add_user_cross_dialogArguments[1] = Add_UserInfo_onclick_Complete;

				if (CrossYN()) {
					window.open("/ezSchedule/scheduleShowGatherList.do", "right");
				} else {
					var reParam = window.open("/ezSchedule/scheduleShowGatherList.do", "right");
					if (typeof (reParam) != "undefined" && reParam != null) {
						idDatepicker.vtLocalDate = reParam["startTime"];
						idDatepicker.vtLocalEndDate = reParam["endTime"];

						if (reParam["entryList"] != "") {
							xmpEntryEmailList.innerText = reParam["entryList"];
							DisplayEntryList();
						}
					}
				}
			}
			function Add_UserInfo_onclick_Complete(reParam) {
				idDatepicker.vtLocalDate = reParam["startTime"];
				idDatepicker.vtLocalEndDate = reParam["endTime"];

				if (reParam["entryList"] != "") {
					xmpEntryEmailList.innerText = reParam["entryList"];
					DisplayEntryList();
				}
			}

			function openFolder() {
				var h2Title;

				if (event.type == 'load') {
					return;
				}

				if ($(event.target).get(0).nodeName == 'H2') {
					h2Title = $(event.target);
				} else {
					h2Title = $(event.target).parent();
				}
				
				$("h2.on").attr("class", "off");
				$(".lnbUL").attr("class", "lnbUL off");
				h2Title.attr("class", "on");
				h2Title.next().removeClass("off");
				$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
				h2Title.children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
			}
			
			// 2025-04-21 조수빈 - 사용자의 설정에 따라 기본 일정 설정 내용 및 일정 조회 체크 여부 값을 세팅함
			// personalScheConfigList는 json형태로 수정한 list객체
			function setUserScheduleTypeConfig(personalScheConfigList) {
				
				if (personalScheConfigList.length > 0) {
					
					for (var i = 0; i < personalScheConfigList.length; i++) {
						try {
							var config = personalScheConfigList[i];
							var scheduleType = (config.scheduleType !== undefined) ? config.scheduleType : 1;
							var relatedId = (config.relatedId !== undefined) ? config.relatedId : config.userId;
							var tagColor = (config.tagColor !== undefined) ? config.tagColor : null;
							var isChecked = (config.isChecked !== undefined) ? config.isChecked : false;

							// 기본 셀렉터 구성
							var selector = "input[type='checkbox'][data-schedule-type='" + scheduleType + "']";

							// scheduleType이 1(개인), 4(협업)가 아닌 경우에는 relatedID가 필요함
							if (scheduleType !== 1 && scheduleType !== 4) {
								selector += "[value='" + relatedId + "']";
							}

							var targetElem = document.querySelector(selector);

							if (!targetElem) {
								// 일치하는 일정 요소가 없다 = 삭제 대상 ? 삭제 array 만들어야 하나
								// (겸직 해제됨 || 일정그룹에서 제외됨 || 공개부서가 없어짐)
								continue;
							}

							// 스타일 적용
							if ((scheduleType === 1 || scheduleType === 2 || scheduleType === 3 || scheduleType === 4)
								&& tagColor && targetElem.nextElementSibling
							) {
								targetElem.nextElementSibling.style.backgroundColor = tagColor;
							} else if (scheduleType !== 7 && scheduleType !== 10 && tagColor) {
								targetElem.style.backgroundColor = tagColor;
							}

							// 체크 여부 설정
							targetElem.checked = (isChecked == 1);
						} catch (e) {
							console.log("Error at index", i, e);
        					continue;
						}
					}
				}

				// 값 세팅이 모두 끝난 뒤 체크 박스 상태가 달라질 때마다 해당 상태를 저장할 함수를 이벤트 등록하기
				var scheBoxs = document.querySelectorAll("input[name='chk_schedule']");

				for (var i = 0; i < scheBoxs.length; i++) {
					scheBoxs[i].addEventListener('change', function(event) {
						saveIsTagChecked(event.target);
						// 전체 체크박스 체크/해제 되었을 때 ''.select-all' 이 놈이 체크/해제 되도록 하기
					});
				}
			}
			
			function saveIsTagChecked(target) {
				
		        $.ajax({
		            type: "POST",
		            url: "/ezSchedule/saveIsTagChecked.do",
		            data: {
		            	scheduleType : target.dataset.scheduleType,
		            	relatedID : target.value,
		            	isChecked : (target.checked ? 1 : 0)
		            },
		            success: function(res) {
		            	if (res == "FALSE") {
			            	console.log("method saveIsTagChecked() return 'false'");
			            	target.checked = !target.checked; 
		            	}
		            },
		            error: function(e) {
		            	console.log("Error occurred while executing method saveIsTagChecked(): " + e);
		            	target.checked = !target.checked; 
		            }
		        });
			}
		</script>
	</head>

	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<input type="hidden" id="chk_str" value="" />
	    	<%-- <div class="lnb_btn"></div> --%>
	        <%-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼 --%>
	    	<div class="left_title" title="<spring:message code='ezSchedule.t1010'/>">
	    		<spring:message code='ezSchedule.t1010'/>
	        	<span id='Schedule_Config' onClick="Function_Flag('11')" class="sub_iconLNB tree_leftconfig" title="<spring:message code='ezPersonal.t999900007'/>"></span>
	        </div>
	        <div class="btn_writeBox" onclick="WriteSchedule()">
	        	<p class="btn_write01"><spring:message code='ezSchedule.t214'/></p>
	        </div>
        	<div class="scheduleListBox" style="overflow:hidden; padding-right: 0;">
		        <%-- 2023-06-23 황인경 - 디자인 개선 > 일정관리 > 좌측메뉴 > 최상위 '일정관리' 메뉴 표시 추가 --%>
	        	<h2 class="on">
			            <span class="sub_iconLNB tree_arrow_down"></span><span class="h2Title" id="" onclick="Function_Flag(2)"><spring:message code='ezSchedule.t1010'/></span>
		        </h2>
		        <ul class="lnbUL">
		        	<li>
			    		<label class="IDcontainer" onchange="chk_all()">
							<input type="checkbox" checked="checked" name="select-all" id="select-all" value="chkAllFalse" style="left:0px">
					  		<span class="checkmark mr5" style="background:rgb(125, 125, 125); margin-top: 7px;"></span>
					  		<span class="list_text"><spring:message code='ezSchedule.t220'/></span>
						</label>
					</li>
					<li>
						<label class="IDcontainer" onchange="chk_DisplayChange()">
					  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="1" value="${loginVO.id}" class="checkSelect">
					  		<span class="checkmark mr5" style="background:rgb(1, 138, 249); margin-top: 7px;"></span>
					  		<span class="list_text"><spring:message code='ezSchedule.t221'/></span>
						</label>
					</li>	
					<%--<c:if test='${!empty scheSec}'>
						<c:forEach var="sec" items="${scheSec}">
							<li>
								<label class="IDcontainer" onchange="chk_DisplayChange()">
							 	 	<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="1" value="${sec.secId }" class="checkSelect">
								  	<span class="checkmark mr5" style="background-color:rgb(1, 138, 249); margin-top: 7px;"></span>
								  	<span class="list_text" title="${sec.secName }"><spring:message code='ezSchedule.t372'/>${sec.secName }</span>
								</label>
							</li>	
						</c:forEach>
					</c:if>--%>
					<c:if test="${isGoogleSync == 'Y'}">
						<li>
							<label class="IDcontainer" onchange="chk_DisplayChange()">
						  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="9" value="${loginVO.id}" class="checkSelect">
						  		<span class="checkmark mr5" style="background:rgb(1, 138, 249); margin-top: 7px;"></span>
						  		<span class="list_text"><spring:message code='ezSchedule.google03'/></span>
							</label>
						</li>
					</c:if>
					<li>
						<label class="IDcontainer" onchange="chk_DisplayChange()">
							<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${loginVO.deptID}" isSharedDept='N' class="checkSelect">
						  	<span class="checkmark mr5" style="background:rgb(1, 179, 63); margin-top: 7px;"></span>
						  	<span class="list_text"><spring:message code='ezSchedule.t222'/></span>
						</label>
					</li>					
					<c:if test='${!empty scheCum}'>
						<c:forEach var="cum" items="${scheCum}">
							<c:if test="${cum.deptId ne loginVO.deptID}">
								<li>
									<label class="IDcontainer" onchange="chk_DisplayChange()">
										<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${cum.deptId }" isSharedDept='N' class="checkSelect">
									  	<span class="checkmark mr5" style="background-color:rgb(1, 179, 63); margin-top: 7px;"></span>
									  	<span class="list_text" title="${cum.titleName }"><spring:message code='ezSchedule.t373'/>${cum.titleName }</span>
									</label>
								</li>	
							</c:if>
						</c:forEach>
					</c:if>
					<c:if test='${!empty scheDept}'>
						<c:forEach var="dep" items="${scheDept}">
							<li>
								<label class="IDcontainer" onchange="chk_DisplayChange()">
							  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${dep.deptId }" isSharedDept='Y' class="checkSelect">
							  		<span class="checkmark mr5" style="background-color:#b200ff; margin-top: 7px;"></span>
							  		<span class="list_text" title="${dep.deptName }"><spring:message code='ezSchedule.t373'/>${dep.deptName }</span>
								</label>
							</li>	
						</c:forEach>
					</c:if>
					<li>
						<label class="IDcontainer" onchange="chk_DisplayChange()">
					  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="3" value="${loginVO.companyID}" class="checkSelect">
					  		<span class="checkmark mr5" style="background:rgb(254, 28, 113); margin-top: 7px;"></span>
					  		<span class="list_text"><spring:message code='ezSchedule.t223'/></span>
						</label>
					</li>	
					<c:if test="${useWorkspaceSchedule eq 'YES'}">
					<li>
						<label class="IDcontainer" onchange="chk_DisplayChange2(this)">
					  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="4" value="collaboration" class="checkSelect">
					  		<span class="checkmark mr5" style="background:rgb(63, 81, 181); margin-top: 7px;"></span>
					  		<span class="list_text">협업일정</span>
						</label>
					</li>	
					</c:if>
					<c:if test='${!empty groupList}'>
						<c:forEach var="group" items="${groupList}">
							<li>
								<label class="IDcontainer" onchange="chk_DisplayChange()">
							  		<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="7" value="${group.groupId }" class="checkSelect">
							  		<span class="checkmark mr5" style="background-color: ${group.groupColor }; margin-top: 7px;"></span>
							  		<span class="list_text" title="${fn:escapeXml(group.groupName)}"><spring:message code='ezSchedule.t375'/>${fn:escapeXml(group.groupName)}</span>
								</label>
							</li>	
						</c:forEach>
					</c:if>
					<li>
						<label class="IDcontainer" onchange="chk_DisplayChange()">
							<input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="10" value="${loginVO.id}" class="checkSelect">
							<span class="checkmark mr5" style="background:rgb(255, 174, 0); margin-top: 7px;"></span>
							<span class="list_text"><spring:message code='ezSchedule.lyj14'/></span>
						</label>
					</li>
					<%-- 2023-06-23 황인경 - 디자인 개선 > 일정관리 > 좌측메뉴 > LNB 이미지, 구조 수정 --%>
                  	<li class="ul_2Box"></span><span class="list_text" onClick="Function_Flag(6)"><spring:message code='ezSchedule.t1018'/></span></li>
                  	<li><span class="list_text" onClick="Function_Flag(10)"><spring:message code='ezSchedule.t1021'/></span></li>
					<li><span class="list_text" onClick="Function_Flag(12)"><spring:message code='ezSchedule.kmh01'/></span></li>
		        </ul>
				<%-- 2024-06-05 임정은 - 일정 모아보기 기능 --%>
				<h2 class="off" onclick="openFolder()">
					<span class="sub_iconLNB tree_plus"></span>
					<span class="h2Title">
						<spring:message code='ezSchedule.ljeGs001'/>
						<span onclick="Function_Flag(13)" class="sub_iconLNB tree_manage doNotOpen"></span>
					</span>
				</h2>
				<ul class="lnbUL off">
					<c:if test='${!empty gatherList}'>
						<c:forEach var="group" items="${gatherList}">
							<li>
								<label class="IDcontainer">
									<span class="list_text" data1="${fn:escapeXml(group.groupId)}" data2="${fn:escapeXml(group.groupName)}" onclick="Add_UserInfo_onclick(this)">${fn:escapeXml(group.groupName)}</span>
								</label>
							</li>
						</c:forEach>
					</c:if>
				</ul>
<%-- 		    <ul class="lnbUL">
	            	<li><span class="sub_iconLNB tree_search"></span><span class="list_text" onClick="Function_Flag(6)"><spring:message code='ezSchedule.t1018'/></span></li>
    	        	<li><span class="sub_iconLNB tree_pims_search_open"></span><span class="list_text" onClick="Function_Flag(10)"><spring:message code='ezSchedule.t1021'/></span></li>
	 		    </ul> --%>
				<h2 class="off">
					<span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="" onclick="Function_Flag(6)"><spring:message code='ezSchedule.t1018'/></span>
				</h2>
				<h2 class="off">
					<span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="" onclick="Function_Flag(10)"><spring:message code='ezSchedule.t1021'/></span>
				</h2>
				<h2 class="off">
					<span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="" onclick="Function_Flag(12)"><spring:message code='ezSchedule.kmh01'/></span>
				</h2>
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
						  <span class="checkmark" style="background-color:#b200ff;"></span>
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
						<label class="IDcontainer" onchange="chk_DisplayChange()"><span class="chk_tooltip" title="<c:out value='${group.groupName}'/>" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><spring:message code='ezSchedule.t375'/><c:out value="${group.groupName }" escapeXml="true"/></span>
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
	    </script>
	    <%--
	    <!-- 2018-11-01 김보미 - 일정그룹 추가시 left바에 그룹 바로 보이도록 -->
	    <form id="frm" action="/ezSchedule/scheduleLeft.do?funCode=5"></form>
	    <form id="frm2" action="/ezSchedule/scheduleLeft.do?"></form>
	    --%>
	</body>
</html>