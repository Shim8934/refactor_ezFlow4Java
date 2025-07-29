<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<style>
			.pagetd {
				padding-top:6px; 
			}
       		.pcol {
       			padding-top:6px;
       		}
        	.Right_Point01 {
	        	font:bold;
	        	color:#017bec;
	        }
	        .cmhomelist tr td {
	        	overflow:hidden;
	        	text-overflow:ellipsis;
	        	white-space:nowrap;
	        }
		</style>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<!-- 		data picker -->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}"/>
		<script type="text/javascript">
			var g_draftpath = window.frames.top.draftspath;
			var g_outboxpath = window.frames.top.outboxpath;
		    var CurPage = "";
		    var totalPage = "";
			var nowBlock = "";
		    var totalCount = "";
		    var code = "<c:out value = '${code}' />";
			var selGrade = "";
			var selMonth = "";
			var OrderOption = "";
			var OrderCell = "";
			var sRadio = "";
			var keyword = "";
			var startDate = "";
			var endDate = "";
			var usepostDate = false;

		    document.onselectstart = function () { return false; };
		    
		    window.onload = function () {
				getGradeList();
				getMemberList();
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

				var NowDate;
				NowDate = new Date();

				NowDate.setMonth(NowDate.getMonth());

				$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', NowDate);

				var NowDate2;
				NowDate2 = new Date();

				NowDate2.setMonth(NowDate2.getMonth());

				$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', NowDate2);

				var monthMsg = "<spring:message code='ezSchedule.t110' />";
				var monthStr = monthMsg.split(";");
				var dayMsg = "<spring:message code='ezSchedule.t108' />";
				var dayStr = dayMsg.split(";");

				$(function () {
					$.datepicker.regional["<spring:message code='main.t0619' />"] = {
						closeText: "<spring:message code='main.t3' />",
						prevText: "<spring:message code='main.t0604' />",
						nextText: "<spring:message code='main.t0605' />",
						currentText: "<spring:message code='main.t0606' />",
						monthNames: monthStr,
						monthNamesShort: monthStr,
						dayNames: dayStr,
						dayNamesShort: dayStr,
						dayNamesMin: dayStr,
						weekHeader: 'Wk',
						dateFormat: 'yy-mm-dd',
						firstDay: 0,
						isRTL: false,
						duration: 200,
						showAnim: 'show',
						showMonthAfterYear: true
					};
					$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
				});
			});

		    /* 2018-06-29 홍승비 - 커뮤니티 회원을 해당 회사에 겸직하고 있는 정보로 표출하기 */
		    // deptid = d
			function openinfo1(a,b,c, d) {
			    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=420,height=450";
			    feature = feature + GetOpenPosition(420, 450);
				rts60 = window.open("/ezCommon/showPersonInfo.do?id=" + b + "&dept=" + d, "", feature);
	            
			}
			
			//호출하는곳X
			function sendMail( toMailAddr, userDispName, fromMailAddr, fromDipName ) {
				toEmail = "\"" + userDispName + "\"" + " <" + toMailAddr + ">";
				url = "/eoffice/owa/email/newMail.aspx?cmd=new&MsgTo=" + toEmail + "&draftpath=" + g_draftpath + "&outboxpath=" + g_outboxpath;
	
				var feature = "height = 566px, width = 552px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
				feature = feature + GetOpenPosition(552, 566);
				toMail = window.open(url, "sendMail", feature);
			}
			
			function keyword_onkeydown(e) {
			    var kecode = e.keyCode;

				if (kecode==13) {
					search();
					
					return false;
				}
				
				return true;
			}
			
			function search() {
				// 키워드 검색
				if (document.getElementById("s_radio").value == "id") {
					sRadio = "id";
				} else {
					sRadio = "name";
				}
				keyword = document.getElementById("keyword").value;

				// 회원등급조회
				selGrade = document.getElementById("selGradeList").value;

				// 미작성 검색
				selMonth = document.getElementById('noWriteMonth').value;

				// 기간검색
				if (usepostDate) {
					startDate = document.getElementById("Sdatepicker").value;
					endDate = document.getElementById("Edatepicker").value;

					var start = new Date(startDate);
					var end = new Date(endDate);

					if (end < start) {
						alert("<spring:message code = 'ezCommunity.lyj55' />");
					}
				} else {
					startDate = "";
					endDate = "";
				}

				getMemberList();
			}
			
	        var BlockSize = 10;
	        
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext; 
	        }
	        
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span>";
	            strtext = "<div class='pagenavi'>";
	            PagingHTML += strtext;
	            var pageNum = CurPage;
	            
	            if (totalPage > 1 && pageNum != 1) {
	                strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg first disabled'></span>"
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='btnimg prev disabled'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='btnimg prev disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            var MaxNum;
	            var i;
	            var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	            if (totalPage >= (startNum + parseInt(BlockSize))) {
	                MaxNum = (startNum + parseInt(BlockSize)) - 1;
	            } else {
	                MaxNum = totalPage;
	            }
	            
	            for (i = startNum; i <= MaxNum; i++) {
	                if (i == pageNum) {
	                    strtext = "<span class='on'>" + i + "</span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                    PagingHTML += strtext;
	                }
	            }

				if (MaxNum == 0) {
					PagingHTML += "<span class=\"on\">" + 1 + "</span>";
				}

	            if (totalPage > BlockSize) {
	                if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                    strtext = "";
	                    strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "";
	                    strtext = strtext + "<span class='btnimg next disabled'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg last disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            PagingHTML += "</div>";
	            td_Create1(PagingHTML);
	        }
	        
	        function goToPageByNum(Value) {
	            CurPage = Value;
	            makePageSelPage();
				movePage(CurPage);
	        }
	        
	        function selbeforeBlock() {
	            var pageNum = parseInt(CurPage);
	            pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);    
	        }
	        
	        function selbeforeBlock_one() {
	            var pageNum = parseInt(CurPage);
	            
	            if (parseInt(pageNum - 1) > 0) {
	                goToPageByNum(parseInt(pageNum - 1));
	            } else {
	                return;
	            }
	        }
	        
	        function selafterBlock() {
	            var pageNum = parseInt(CurPage);
	            pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);
	        }
	        
	        function selafterBlock_one() {
	            var pageNum = parseInt(CurPage);
	            
	            if( parseInt(pageNum + 1) <= totalPage) {
	                goToPageByNum(parseInt(pageNum + 1));
	            } else {
	                return;
	            }
	        }
	        
	        function movePage(newPage) {
				if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
					CurPage = newPage;
				}
				getMemberList();
			}

			function goToPage(page) {
				if (page == "front") {
					if (parseInt(CurPage) - 1 < 1) {
						return;
					}

					CurPage = parseInt(CurPage) - 1;
				} else if (page == "next") {
					if (parseInt(CurPage) + 1 > parseInt(CurPage)) {
						return;
					}

					CurPage = parseInt(CurPage) + 1;
				} else if (page == "page") {
					if (event.keyCode == 13) {
						var goPage = document.all.txt_PageInputNum.value;
						
						if(parseInt(goPage) > 0 && parseInt(goPage) <= parseInt(totalPage)) {
							CurPage = goPage;
						}
					}
				}

				getMemberList();
			}

			var userIds = new Array();
			function selectMember(userId, checkId) {
				var checkbox = document.getElementById("checkbox" + checkId);
				if (checkbox.checked == true) {
					userIds.push(userId);
				} else {
					var index = userIds.indexOf(userId);

					if (index > -1) {
						userIds.splice(index, 1);
					}
				}
			}

			function allCheck(element) {
				var checkboxes = document.querySelectorAll('.selectMember');

				checkboxes.forEach(function(checkbox) {
					checkbox.checked = element.checked;

					var tr = checkbox.closest('tr');
					var tds = tr.querySelectorAll('td');
					var userIdtd = tds[4];

					if (userIdtd) {
						var userId = userIdtd.textContent;

						if (element.checked) {
							userIds.push(userId);
						} else {
							var index = userIds.indexOf(userId);
							if (index !== -1) {
								userIds.splice(index, 1);
							}
						}
					}
				});
			}

			var change_grade_dialogArguments = new Array();
			function changeGrade() {
				if (userIds.length == 0) {
					alert("<spring:message code = 'ezCommunity.lyj19' />");
					return;
				}

				change_grade_dialogArguments[0] = userIds;
				change_grade_dialogArguments[1] = changeGrade_complete;
				GetOpenWindow("/ezCommunity/changeGradePopup.do?code=" + encodeURIComponent(code), "", 320, 200, "no");
			}

			function changeGrade_complete() {
				alert("<spring:message code = 'ezCommunity.t282' />");

				setTimeout(function () {
					location.reload();
				}, 1000);
			}

			function getGradeList() {
				$.ajax({
					type : "GET",
					url : "/ezCommunity/getAdminMemberGrade.do",
					dataType : "json",
					data : {
						code : code
					},
					success : function(result) {
						getGradeList_after(result);
					},
					error : function(xhr, status, error) {
						console.error("Error: " + error);
					}
				});
			}

			function getGradeList_after(gradeList) {
				var selectGrade = document.getElementById("selGradeList");

				if (selectGrade) {
					for (var i = 0; i < gradeList.length-1; i++) {
						var option = document.createElement("option");

						option.value = gradeList[i].gradeCode;
						option.textContent = gradeList[i].gradeName;

						selectGrade.appendChild(option);
					}
				}
			}

			function refresh() {
				window.location.href = "/ezCommunity/commViewMember.do?code=" + encodeURIComponent(code);
			}

			function getMemberList() {
				$.ajax({
					type: "POST",
					url: "/ezCommunity/commViewMemberList.do",
					dataType: "text",
					async: false,
					data: {
						code : code,
						sRadio : sRadio,
						keyword : keyword,
						selectGrade : selGrade,
						selectMonth : selMonth,
						startdate : startDate,
						enddate : endDate,
						orderCell 	: OrderCell,
						orderOption : OrderOption,
						goToPage : CurPage
					},
					success: function (result) {
						$('#tblList').find('tbody').remove();
						$('#tblList').append('<tbody>' + ReplaceHTML(result) + '</tbody>');

						var index = ReplaceHTML(result).lastIndexOf("</tr>");

						var result2 = result.substring(index + 5);

						var parser = new DOMParser();
						var xmlDoc = parser.parseFromString(result2, "text/xml");

						totalCount = xmlDoc.getElementsByTagName("KEYWORDCOUNT")[0].textContent;
						totalPage = xmlDoc.getElementsByTagName("TOTALPAGE")[0].textContent;
						CurPage = xmlDoc.getElementsByTagName("CURPAGE")[0].textContent;
						nowBlock = xmlDoc.getElementsByTagName("NOWBLOCK")[0].textContent;

						makePageSelPage();
					},
					error: function (xhr, status, error) {
						console.error('AJAX Error: ' + error);
					}
				});
			}

			function detailSearch() { // 상세검색
				$('.detailSearch').toggleClass('on');

				if ($('.detailSearch').hasClass('on')) {
					$('.detailSearch').show();
					$('#tr1').css('border-bottom', '1px #ddd solid');

					if (!usepostDate) {
						$("#Sdatepicker").val('').datepicker('disable');
						$("#Edatepicker").val('').datepicker('disable');
					}
				} else {
					$('.detailSearch').hide();
					$('#tr1').css('border-bottom', '2px #ddd solid');
				}
			}

			function SortPage(obj) { // 정렬
				var ths = obj.parentNode.parentNode.querySelectorAll("th");
				ths.forEach(function(th) {
					var existingImg = th.querySelector("img");
					if (existingImg) {
						th.removeChild(existingImg);
					}
				});

				var img = document.createElement("IMG");
				var strHeaderName = obj.textContent;

				if (strHeaderName == "이름") {
					strHeaderName = "NAME";
				} else if (strHeaderName == "회원등급") {
					strHeaderName = "GRADE";
				} else if (strHeaderName == "가입일") {
					strHeaderName = "INDATE";
				} else {
					strHeaderName = "LASTDATE";
				}

				if (OrderCell == strHeaderName) {
					if (OrderOption == "") {
						OrderOption = "DESC";
						img.setAttribute("src", "/images/etc/view-sortdown.gif");
					} else {
						OrderOption = "";
						img.setAttribute("src", "/images/etc/view-sortup.gif");
					}
				} else {
					OrderCell = strHeaderName;
					OrderOption = "";
					img.setAttribute("src", "/images/etc/view-sortup.gif");
				}

				img.setAttribute("align", "absmiddle");
				obj.appendChild(img);

				getMemberList();
			}

			function DateSearch_Click() {
				if (usepostDate){
					usepostDate = false;
					$("#Sdatepicker").val('').datepicker('disable');
					$("#Edatepicker").val('').datepicker('disable');
				} else {
					usepostDate = true;
					$("#Sdatepicker").datepicker('enable');
					$("#Edatepicker").datepicker('enable');

					var today = new Date();

                    var year = today.getFullYear();
                    var month = String(today.getMonth() + 1).padStart(2, '0');
                    var day = String(today.getDate()).padStart(2, '0');

                    var formattedDate = year + '-' + month + '-' + day;

					$("#Sdatepicker").val(formattedDate);
					$("#Edatepicker").val(formattedDate);
				}
			}

			function excelExport() {
				var url = "/ezCommunity/excelExportOut.do";
				url += "?code=" + encodeURIComponent(code)
				url += "&sRadio=" + encodeURIComponent(sRadio);
				url += "&keyword=" + encodeURIComponent(keyword);
				url += "&selectGrade=" + encodeURIComponent(selGrade);
				url += "&selectMonth=" + encodeURIComponent(selMonth);
				url += "&startdate=" + encodeURIComponent(startDate);
				url += "&enddate=" + encodeURIComponent(endDate);
				url += "&orderCell=" + encodeURIComponent(OrderCell);
				url += "&orderOption=" + encodeURIComponent(OrderOption);

				window.frames["saveExcel"].location.href = url;
			}
		</script>
	</head>
	<body class="cmhome_body">
		<h1 class="type1_h1"><spring:message code = 'ezCommunity.t723' /><span id="mailBoxInfo"></span></h1>
		<form name="page">
			<table id="tblList2" class="cmhomelist" style="width:100%;margin-top:5px;margin-bottom:10px;">
				<tr id="tr1" style="border-top: 2px solid #ddd;border-bottom:2px solid #ddd;text-align: center;">
					<td>
						<span style="font-size:13px;"><span style="margin-right:3px;">◾</span> <spring:message code = 'ezCommunity.lyj56' />&nbsp;&nbsp;<span class='txt_color' style="font-weight:bold;"><c:out value='${totalUserCnt}'/></span><spring:message code = 'ezCommunity.lyj32' /></span>
					</td>
					<td>
						<span style="font-size:13px;"><span style="margin-right:3px;">◾</span> <spring:message code = 'ezCommunity.lyj57' />&nbsp;&nbsp;<span class='txt_color' style="font-weight:bold;"><c:out value='${todayJoinCnt}'/></span><spring:message code = 'ezCommunity.lyj32' /></span>
					</td>
					<td>
						<span style="font-size:13px;"><span style="margin-right:3px;">◾</span> <spring:message code = 'ezCommunity.lyj58' />&nbsp;&nbsp;<span class='txt_color' style="font-weight:bold;"><c:out value='${waitApprCount}'/></span><spring:message code = 'ezCommunity.lyj32' /></span>
					</td>
					<td>
						<span style="font-size:13px;"><span style="margin-right:3px;">◾</span> <spring:message code = 'ezCommunity.lyj59' />&nbsp;&nbsp;<span class='txt_color' style="font-weight:bold;"><c:out value='${todayLeaveCnt}'/></span><spring:message code = 'ezCommunity.lyj32' /></span>
					</td>
				</tr>
				<tr class="detailSearch" style="display:none;">
					<td colspan="2" style="border-right: 1px #ddd solid;">
						<span style="font-size:13px;vertical-align:middle;margin-left:30px;margin-right:30px;"><spring:message code = 'ezCommunity.lyj47' /></span>
						<select id="selGradeList" style="font-size: 13px;vertical-align: middle;cursor: pointer;MIN-WIDTH: 150px;text-align:center;">
							<option value="0"><spring:message code = 'ezCommunity.lyj30' /></option>
						</select>
					</td>
					<td colspan="2">
						<span style="font-size: 13px;margin-right: 30px;margin-left: 30px;"><spring:message code = 'ezCommunity.lyj48' /></span>
						<select id="noWriteMonth" style="font-size: 13px;cursor: pointer;text-align:center;width:150px;">
							<option value="0"><spring:message code = 'ezCommunity.lyj30' /></option>
							<option value="1"><spring:message code = 'ezCommunity.lyj60' /></option>
							<option value="2"><spring:message code = 'ezCommunity.lyj61' /></option>
							<option value="3"><spring:message code = 'ezCommunity.lyj62' /></option>
							<option value="6"><spring:message code = 'ezCommunity.lyj63' /></option>
							<option value="12"><spring:message code = 'ezCommunity.lyj64' /></option>
						</select>
					</td>
				</tr>
				<tr class="detailSearch" style="display:none;border-bottom: 2px solid #ddd;">
					<td colspan="4">
						<span style="font-size:13px;vertical-align:middle;margin-left:30px;margin-right:51px;"><spring:message code = 'ezCommunity.lyj49' /></span>
						<input type="checkbox" style="vertical-align: middle;" onclick="DateSearch_Click()">
						<label for="usedate" style="vertical-align: text-top;margin-right: 5px;"><spring:message code = 'ezCommunity.lyj54' /></label>
						<input class="inputText" type="text" id="Sdatepicker" readonly  style="vertical-align: middle;font-size:13px; text-align:center;border:1px solid #ddd;">
						<span style="vertical-align: middle;margin-left:5px;margin-right:5px;">~</span>
						<input class="inputText" type="text" id="Edatepicker" readonly style="vertical-align: middle;font-size:13px; text-align:center;border:1px solid #ddd;">&nbsp;&nbsp;&nbsp;
						<span style="vertical-align:middle;margin-right: 137px;"><spring:message code = 'ezCommunity.lyj50' /></span>
						<a class="imgbtn imgbck" style="vertical-align: middle;height:22px;margin:0px"><span onClick="javascript:search();" style="height:22px;line-height:22px;font-size: 13px;"><spring:message code = 'ezCommunity.lyj51' /></span></a>
					</td>
				</tr>
			</table>
			<table class="content" style="width:100%;border:0px">
				<tr>
					<td style="border:1px solid #ddd;border:0px;padding:0px;width:100px;">
						<select id="s_radio" name="s_radio" style="font-size: 13px;vertical-align: middle;text-align: center;height: 24px;cursor: pointer;">
							<option value="id"><spring:message code = 'ezCommunity.t512' /></option>
							<option selected value="name"><spring:message code = 'ezCommunity.t10' /></option>
						</select>						
						<input class="inputText" type="text" id="keyword" name="keyword" onKeyDown="return keyword_onkeydown(event)" style="width:200px">
						<a class="imgbtn imgbck" style="vertical-align: middle;height:22px;"><span onClick="javascript:search();" style="height:22px;line-height:22px"><spring:message code = 'ezCommunity.t31' /></span></a>
						<a class="imgbtn imgbck" style="vertical-align: middle;height:22px;"><span onClick="javascript:detailSearch();" style="height:22px;line-height:22px"><spring:message code = 'ezCommunity.lyj52' /></span></a>
						<a class="imgbtn imgbck" style="vertical-align: middle;height:22px;"><span onClick="javascript:refresh();" style="height:22px;line-height:22px"><spring:message code = 'ezCommunity.lyj53' /></span></a>
					</td>
					<td style="border:0px;width:150px;text-align: right;">
						<c:if test="${chkSysop == '1' || fn:contains(adminAuth, 'A')}">
							<a class="imgbtn imgbck" style="vertical-align: middle;height:23px;">
								<span onClick="javascript:changeGrade();" style="height:22px;line-height:23px"><spring:message code = 'ezCommunity.lyj17' /></span>
							</a>
						</c:if>
						<a class="imgbtn imgbck" style="vertical-align: middle;height:23px;"><span onClick="javascript:excelExport();" style="height:22px;line-height:23px;"><spring:message code = 'ezCommunity.lyj65' /></span></a>
					</td>
				</tr>			
			</table>
		</form>
		<div  style = "height:370px;">
		<table id="tblList" class="cmhomelist" style="width:100%;margin-top:10px">
			<thead>
				<tr>
					<c:choose>
						<c:when test="${chkSysop == '1' || fn:contains(adminAuth, 'A')}">
							<th style="width:40px"><input type="checkbox" id="HeaderAllCheckBox" class="selectMember" onclick="allCheck(this)"></th>
						</c:when>
						<c:otherwise>
							<th style="width:40px"><spring:message code = 'ezCommunity.t32' /></th>
						</c:otherwise>
					</c:choose>
					<th style="width:110px;cursor:pointer;" onclick="SortPage(this)"><spring:message code = 'ezCommunity.t10' /></th>
					<th style="width:100px;cursor:pointer;" onclick="SortPage(this)"><spring:message code = 'ezCommunity.lyj16' /></th>
					<th style="width:100px"><spring:message code = 'ezCommunity.t241' /></th>
					<th style="width:100px"><spring:message code = 'ezCommunity.t512' /></th>
					<th style="width:60px"><spring:message code = 'ezCommunity.lyj66' /></th>
					<th style="width:60px"><spring:message code = 'ezCommunity.lyj67' /></th>
					<th style="width:60px"><spring:message code = 'ezCommunity.t727' /></th>
					<th style="width:75px;cursor:pointer;" onclick="SortPage(this)"><spring:message code = 'ezCommunity.t725' /></th>
					<th style="width:75px;cursor:pointer;" onclick="SortPage(this)"><spring:message code = 'ezCommunity.t726' /></th>
				</tr>
			</thead>
			<tbody id="tblListBody">
			</tbody>
		</table>
		</div>
		<div id="tblPageRayer" style="margin-top:10px"></div>
		<iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	</body>
</html>