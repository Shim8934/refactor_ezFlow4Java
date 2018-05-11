<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
<%-- 		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" /> --%>
<!-- 		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />		 -->
<%-- 		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	     --%>
	    <link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
	    <link rel="stylesheet" href="/css/ezSchedule/Calendar_cross.css" type="text/css">
	    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>	
	    <script type="text/javascript">
	    	var adminCompany = "${adminCompany}";
	    	var selectedUserId = "";
	    	var selectedUserName = "";
	    	var userList = [];
			
	        $(document).ready(function() {
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		            company_change();
		        }
	        });
	        
	        function company_change() {
	            $.ajax({
	            	type : "GET",
	            	url : "/admin/ezAttitude/attitudeAuthList.do",
	            	dataType : "json",
	            	data : {companyId : encodeURI($("#ListCompany").val())},
	            	success : function(result) {
	            		attitudeAuthListSet(result);
	            	},
	            	error : function() {
	            		alert("리스트를 가져오는 도중 에러 발생");
	            	}
	            });
	        }
	        
	        //권한자 리스트 셋팅
	        function attitudeAuthListSet(result) {
	        	userList = [];
	        	
                var html = "";
                if (result.length != null && result.length != 0) {
	                for (var i = 0; i < result.length; i++) {
	                    html += "<tr id='" + result[i].userId + "' onclick='listClick(this);' ondblclick='author_modify()' style='cursor: pointer;'>";
	                    html += "<td style='width:20%;color:gray;'>" + result[i].userName + "</td>";
	                    html += "<td style='width:20%;color:gray;'>" + result[i].userTitle + "</td>";
	                    html += "<td style='width:20%;color:gray;'>" + result[i].userDeptName + "</td>";
	                    html += "<td style='width:40%;color:gray;'>" + result[i].authDeptName + " <i class='fas fa-info-circle' style='margin-left: 5px; font-size: 14px;'></i></td>";
	                    html += "</tr>";
	                    
	                    var deptList = [result[i].authDeptId, result[i].authDeptName2, result[i].authDeptType];
	                    userList.push(deptList);
	                }
                } else {
                	html = "<tr><td colspan='4' style='text-align:center'>등록된 정보가 없습니다.</td></tr>";
                }
                
                $("#contentlist table.mainlist").html(html);
	        }
	        
	        //리스트 tr클릭시
	        function listClick(elem) {
	        	selectedUserId = $(elem).attr('id');
	        	selectedUserName = $(elem).children('td').eq(0).text();
	        }
	        
	        //권한수정
			function author_modify() {
	        	if (selectedUserId == null || selectedUserId == "") {
	        		alert("사원을 먼저 선택해 주세요");
	        		return;
	        	}
				var userId = selectedUserId;
				var url = "/admin/ezAttitude/saveAttitudeAuth.do";
				var companyId = encodeURI($("#ListCompany").val());
				url+="?companyId="+companyId;
				if (userId) {
					url+="&userId="+userId+"&userName="+selectedUserName;
					window.open(url, "saveAttitudeAuth", GetOpenWindowfeature(500, 420));
				} else {
					alert("권한설정할 대상을 선택해 주십시오.");
				}
			}
	        
	        //권한 삭제
	        function author_delete() {
	        	if (selectedUserId == null || selectedUserId == "") {
	        		alert("사원을 먼저 선택해 주세요");
	        		return;
	        	}
	        	if (confirm("정말로 삭제하시겠습니까?")) {
					$.ajax({
						type : "POST",
						url : "/admin/ezAttitude/deleteAttitudeAuth.do",
						data : {
							selectUserId : selectedUserId,
							companyId : encodeURI($("#ListCompany").val())
						},
						success : function() {
							alert("삭제되었습니다.");
							company_change();
						},
						error : function() {
							alert("삭제하는 도중 오류 발생");
						}
					})
	        	}
	        }
	        
	        //권한추가
	        function author_add() {
	        	var url = "/admin/ezAttitude/saveAttitudeAuth.do";
				var companyId = $("#ListCompany").val();
				url+="?companyId="+companyId;
				window.open(url, "saveAttitudeAuth", GetOpenWindowfeature(500, 420));
	        }
	        
	        //권한부서 정보 hover로
	        $(document).on('mouseover', '#contentlist table.mainlist i', function(e) {
				var trNum = $(this).closest('tr').prevAll().length;
				var deptIdStr = userList[trNum][0];
				var deptNameList = userList[trNum][1];
				var authTypeStr = userList[trNum][2];
				showTooltip(deptNameList, authTypeStr);
			})
	        $(document).on('mouseout', '#contentlist table.mainlist i', function(e) {
	        	hideTooltip();
			})
	        
	/////////////////툴팁//////////////////////////////////////////////////////////////
			function showTooltip(deptNameList, authTypeStr, e) {
// 			    tip = (!e.target ? event.srcElement.value : e.target.value)

				var authTypeList = authTypeStr.split(",");
				
			    var html = "";
			    html += "<table name='tooltip' class='calendar_layer' cellpadding='0' cellspacing='0' border='0' width='100%'>";
				html += "<tr class='selectTR' style='background-color: rgb(237, 244, 253);'>";
				html += "<th scope='col'>권한부서정보</th>";
				html += "</tr>";
				html += "<tr class='' style='background-color: rgb(255, 255, 255);'>";
				html += "<td class='text'>";
				html += "<table class='td_list' cellpadding='0' cellspacing='0' border='0' width='100%'>";
				for (var i = 0; i < deptNameList.length; i++) {
					var authName = "";
					if (authTypeList[i] == "R") {
						authName = "열람";
					} else {
						authName = "관리";
					}
					html += "<tr class='' style='background-color: rgb(255, 255, 255);'>";
					html += "<td>" + deptNameList[i] + " (" + authName + ")</td>";
					html += "</tr>";
				}
				html += "</table>";
				html += "</td>";
				html += "</tr>";
				html += "</table>";
			    $('#tooltip').html(html);
			    $('#tooltip').css('left',getMouseXLocation(e) + 'px');
			    $('#tooltip').css('top',getMouseYLocation(e) + 'px');
			    $('#tooltip').css('visibility', 'visible');
			}
			
			function hideTooltip() {
				$('#tooltip').css('visibility', 'hidden');
			}
			/*
			function TooltipMouseOver(obj, event) {			
			    showTooltip_MouseOver();
			}
			
			function showTooltip_MouseOver(e, pLocation) {
			    tip = (!e.target ? event.srcElement.value : e.target.value)
			
			    var tTip = document.getElementById('tooltip'); 
			    tTip.innerHTML = ""; // 
			    var tTable = document.createElement("TABLE");
			    var tTr = document.createElement("TR");
			    var tTh = document.createElement("TH");
			    tTable.className = "calendar_layer";
			    tTable.setAttribute("cellpadding", "0");
			    tTable.setAttribute("cellspacing", "0");
			    tTable.setAttribute("border", "0");
			    tTable.setAttribute("width", "100%");
			    tTh.setAttribute("scope", "col");
			    tTh.style.background = "#edf4fd";
			    tTh.style.border = "1px solid #d1ddec";
			    var oText = document.createTextNode("text");
			    //tTh.innerHTML = pSubject;
			    tTh.appendChild(oText);
			    tTr.appendChild(tTh);
			    tTable.appendChild(tTr);
			
			    var tTr = document.createElement("TR");
			    var tTd = document.createElement("TD");
			    tTd.className = "text";
			    tTd.style.borderTop = "0px";
			
			    var sTable = document.createElement("TABLE");
			    var sTr = document.createElement("TR");
			    var sTd = document.createElement("TD");
			    sTable.className = "td_list";
			    sTable.setAttribute("cellpadding", "0");
			    sTable.setAttribute("cellspacing", "0");
			    sTable.setAttribute("border", "0");
			    sTable.setAttribute("width", "100%");
			
			    
			    var sTr = document.createElement("TR");
			    var sTd = document.createElement("TD");
			    var sSpan = document.createElement("SPAN");
			    
			    sTd.appendChild(sSpan);
			    sTd.innerHTML += "[strLang270]<br/>";
			    sTr.appendChild(sTd);
			    sTable.appendChild(sTr);
			
			    
			    if (pLocation != "") {
			        var sTr = document.createElement("TR");
			        var sTd = document.createElement("TD");
			        var sSpan = document.createElement("SPAN");
			        var oText2 = document.createTextNode(pLocation); 
			        
			        sTd.appendChild(sSpan);
			        //sTd.innerHTML += "[" + strLang11 + "]<br/>" + pLocation;
			        sTd.innerHTML += "[strLang11]<br/>";
			        sTd.appendChild(oText2);
			        sTr.appendChild(sTd);
			        sTable.appendChild(sTr);
			    }
			    
			    tTd.appendChild(sTable);
			    tTr.appendChild(tTd);
			    tTable.appendChild(tTr);
			
			    
			    tTip.appendChild(tTable);
			    tTip.style.left = getMouseXLocation(e) + 'px';
			    tTip.style.top = getMouseYLocation(e) + 'px';
			    tTip.style.visibility = 'visible';
			}
			*/
			function getMouseXLocation(e) {
			    if (e)
			        var E = e;
			    else
			        var E = window.event;

			    var tTip = document.getElementById("tooltip");
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        if (E.clientX > 1000) {
			            var locationX = E.clientX + document.documentElement.scrollLeft - tTip.clientWidth;
			        } else {
			            if (E.clientX > 300) {
			                var locationX = E.clientX + document.documentElement.scrollLeft - tTip.clientWidth;
			            }
			            else
			                var locationX = E.clientX + document.documentElement.scrollLeft;
			        }
			    }
			    else {
			        if (E.clientX > 1000) {
			            var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
			        } else {
			            if (E.clientX > 300) {
			                var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
			            }
			            else
			                var locationX = E.clientX + document.body.scrollLeft;
			        }
			    }

			    return locationX
			}

			function getMouseYLocation(e) {
			    if (e)
			        var E = e;
			    else
			        var E = window.event;

			    var tTip = document.getElementById("tooltip");
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        if (E.clientY > 500) {
			            var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
			            locationY -= 12;
			        }
			        else {
			            if (document.documentElement.scrollTop > 0) {
			                
			                var locationY
			                
			                if (tTip.clientHeight > E.clientY) {
			                    locationY = E.clientY + document.documentElement.scrollTop;
			                } else {
			                    locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
			                }
			            }
			            else {
			                var locationY = E.clientY + document.documentElement.scrollTop;
			            }
			            locationY += 12;
			        }
			    }
			    else {
			        if (E.clientY > 500) {
			            var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
			            locationY -= 12;
			        }
			        else {
			            if (document.body.scrollTop > 0) {
			                var locationY
			                
			                if (tTip.clientHeight > E.clientY) {
			                    locationY = E.clientY + document.body.scrollTop;
			                } else {
			                    locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
			                }
			            }
			            else {
			                var locationY = E.clientY + document.body.scrollTop;
			            }
			            locationY += 12;
			        }
			    }

			    return locationY
			}

		</script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code = 'ezAttitude.t8' /></h1>
	    <div id="mainmenu">
			<ul>
	        	<li style="background: none;">
				<span style="border: none;"><b><spring:message code='ezAttitude.t15' /></b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
					<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
					</c:forEach>
	      		</select>
	      		</li>
	      	</ul>
		    <ul>
		        <li><span onClick="author_add()">권한등록</span></li>
		        <li><span onClick="author_modify()">권한수정</span></li>
		        <li><span onClick="author_delete()">권한삭제</span></li>
		    </ul>
		</div>
        <div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
                    <th style="width: 20%;"><span>이름</span></th>
                    <th style="width: 20%;"><span>직위</span></th>
                    <th style="width: 20%;"><span>부서</span></th>
                    <th style="width: 40%;"><span>권한부서</span></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 460px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
                    <tr>
                        <td style="text-align: center;">
                            <img src="/images/email/progress_img.gif" />
                        </td>
                    </tr>
                    <div id="tooltip" style="position: absolute;visibility: hidden; z-index: 1000; background-color: white;"></div>
                </table>
            </div>
        </div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

