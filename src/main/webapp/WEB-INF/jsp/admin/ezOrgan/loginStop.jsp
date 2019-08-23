<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style>
			.selectedTR td:not(:first-child), .unselectedTR td:not(:first-child) {overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
			.selectedTR {background-color: #f1f8ff; cursor:pointer;}
			.unselectedTR:hover {background-color: #f4f5f5; cursor:pointer;}
		</style>
		<script type="text/javascript" language="javascript">
			var CurPage = 1;
			var totalPage = "${totalPage}";
			var totalCount = "${totalCount}";
			var BlockSize = 10;
			var lang = "${lang}";
			var useBizmekaSpambox = "${useBizmekaSpambox}";
			var strListInfo = "";
			var companyId = "${companyId}";
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    }
			

			var Tab1_SelectID = "";
	    	
	        window.onload = function () {
	        	Tab_init_select(document.getElementById("tagsub1"));
	        	Tab1_NewTabIni("tab1");
	        };
	        
	       function Tab_init_select(obj) {
	        	obj.setAttribute("class", "tabon");
                Tab1_SelectID = obj.id;
                ChangeTab(obj);
	        }
	        
	        function Tab1_MouseClick_more(obj, displayFlag) {
	            if (obj.className != "tabon") {
	
	                obj.className = "tabon";
	                var tabSelect = document.getElementById(Tab1_SelectID);
	                if (obj.id != Tab1_SelectID) {
	                    if (Tab1_SelectID != "" && tabSelect != null) {
	                        tabSelect.className = "";
	                    }
	                    
	                    obj.className = "tabon";
	                    Tab1_SelectID = obj.id;
	                    selValue = obj.textContent;
	                    CurPage = 1;
	                }
	                
	                var tabpartUL = document.getElementById("tabpart01UL").style.display;
	                if (!displayFlag) {
	                	tabpartUL = "";
	                } else {
	                    if (tabpartUL == "") {
	                    	tabpartUL = "none";
	                    } else {
	                    	tabpartUL = "";
	                    }
	                }
	            } else {
	                if (tabpartUL == "") {
	                	tabpartUL = "none";
	                } else {
	                	tabpartUL = "";
	                }
	            }
	        }
	        
	        function tabAllWidth() {
	            var allWidth = 0;
	            var tabP = document.getElementById("tab1").getElementsByTagName("P");
	            
	            for (var i = 0; i < tabP.length; i++) {
	                allWidth += tabP[i].offsetWidth;
	            }
	            return allWidth;
	        }
	
	        function ChangeTab(obj) {
	        	 var pSelectTab = obj.id;
	        	 switch (pSelectTab) {
		            case "tagsub1": 
		            	document.getElementById("loginStop_ifrm").src = "/admin/ezOrgan/normalUserList.do";
		            	document.getElementById("stopBtn").style.display = "";
		            	document.getElementById("releaseBtn").style.display = "none";
		            	break;
		            case "tagsub2":
		            	document.getElementById("loginStop_ifrm").src = "/admin/ezOrgan/stopUserList.do";
		            	document.getElementById("stopBtn").style.display = "none";
		            	document.getElementById("releaseBtn").style.display = "";
		            	break;
		        }
	        }
	        
	        function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
	
		    function Tab1_MouserOut(obj) {
		        if(Tab1_SelectID != obj.id) {
		            obj.className = "";
		        }
		    }
	
		    function Tab1_MouseClick(obj) {		    	
		        obj.className = "tabon";
		        var tabSelect = document.getElementById(Tab1_SelectID);
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && tabSelect != null) {
		            	tabSelect.className = "";
		            }
	
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
	        
	        function Tab1_MouseClick2(obj) {
	            ChangeTab(obj);
	        }
	
	        function Tab1_NewTabIni(pTabNodeID) {
	        	var tabNode = document.getElementById(pTabNodeID).childNodes;
	        	
	            for (var i = 0; i < tabNode.length; i++) {
	            	var tabNodeChildItem = tabNode.item(i).childNodes.item(0);
	            	var tabNodeChild = tabNode[i].childNodes[0];
	            		
	                if (tabNode.item(i).nodeName == "P") {
	                    if (tabNodeChildItem.nodeName == "SPAN") {
	                    	tabNodeChildItem.onmouseover = function () { Tab1_MouserOver(this); };
	                    	tabNodeChildItem.onmouseout = function () { Tab1_MouserOut(this); };
	                        
	                        if (tabNodeChild.id != "overSpan") {
	                        	tabNodeChild.onclick = function () { Tab1_MouseClick(this); };
	                        } else {
	                        	tabNodeChild.onclick = function () { Tab1_MouseClick_more(this, true); };
	                        }
	                        
	                        if (i == 0) {
	                        	tabNodeChildItem.className = "tabon";
	                            Tab1_SelectID = tabNodeChildItem.id;
	                        }
	                    }
	                }
	            }
	        }
	        
	        function stop_onclick() {
	        	var companyList = document.getElementById("ListCompany");
	        	var companyId = companyList[companyList.selectedIndex].value;
	        	var loginStop_ifrm = document.getElementById("loginStop_ifrm");
	        	var checkBoxArr = loginStop_ifrm.contentDocument.querySelectorAll("#userListBody tr input");
	        	var checkedCheckboxArr = [].filter.call(checkBoxArr, function(elem){
	        		return elem.checked
	        	});
			    
			    if (checkedCheckboxArr.length == 0) {
			        alert("정지할 사원을 선택해주세요."); 
			        return;
			    }			    
		        var ret = confirm("정지 시 해당 사용자는 로그인을 할 수 없습니다." + "\n" + checkedCheckboxArr.length + "명을 정지하시겠습니까?");
		        
		        if (ret) {
		        	ret = confirm("정말 정지하시겠습니까?");
		        }
		        
			    if (ret) {
			        var data = [];
			        for (var i = 0; i < checkedCheckboxArr.length; i++) {
		            	data[data.length] = checkedCheckboxArr[i].id;
		            }
					
			        $.ajax({
		            	type : "POST",
		            	dataType : "html",
		            	url : "/admin/ezOrgan/insertStopUser.do",
		            	data : {
		            		cn : data,
	            			companyId : companyId
		            	},
		            	success : function(result) {
	            	        if (result == "OK") {
	            				alert(checkedCheckboxArr.length + " 명의 사원을 정지했습니다.");
	            				refreshList();
	            	        } else {
	            	            alert("<spring:message code='ezOrgan.t30' />")
	            	        }
		            	},
		            	error : function() {
	            			alert("<spring:message code='ezOrgan.t30' />");
		            	}
		            });					
			    }
			}
	        
	        function release_onclick() {
	        	var companyList = document.getElementById("ListCompany");
	        	var companyId = companyList[companyList.selectedIndex].value;
	        	var loginStop_ifrm = document.getElementById("loginStop_ifrm");
	        	var checkBoxArr = loginStop_ifrm.contentDocument.querySelectorAll("#userListBody tr input");
	        	var checkedCheckboxArr = [].filter.call(checkBoxArr, function(elem){
	        		return elem.checked
	        	});
			    
	        	if (checkedCheckboxArr.length == 0) {
			        alert("해제할 사원을 선택해주세요."); 
			        return;
			    }			    
		        var ret = confirm("정지 해제 시 해당 사용자는 로그인을 할 수 있습니다." + "\n" + checkedCheckboxArr.length + "명을 정지 해제하시겠습니까?");
		        
// 		        if (ret) {
// 		        	ret = confirm("정말 정지하시겠습니까?");
// 		        }
		        
			    if (ret) {
			        var data = [];
			        for (var i = 0; i < checkedCheckboxArr.length; i++) {
		            	data[data.length] = checkedCheckboxArr[i].id;
		            }
					
			        $.ajax({
		            	type : "POST",
		            	dataType : "html",
		            	url : "/admin/ezOrgan/deleteStopUser.do",
		            	async : true,
		            	data : {
		            		cn : data,
	            			companyId : companyId
		            	},
		            	success : function(result) {
	            	        if (result == "OK") {
	            				alert(checkedCheckboxArr.length + " 명의 사원을 정지 해제했습니다.");
	            				refreshList();
	            	        } else {
	            	            alert("<spring:message code='ezOrgan.t30' />")
	            	        }
		            	},
		            	error : function() {
	            			alert("<spring:message code='ezOrgan.t30' />");
		            	}
		            });					
			    }
			}
	        
	        function removeCheckedCheckbox(loginStop_ifrm, checkboxArr){
	        	var idx = checkboxArr.length;
	        	var userList = loginStop_ifrm.contentDocument.getElementById("userListBody");
	        	for(var i = 0; i < idx; i++) {
	        		var targetTr = checkboxArr[i].parentElement;
	        		while(targetTr.tagName != "TR") {
						targetTr = targetTr.parentElement;
	        		}
	        		userList.removeChild(targetTr);
	        	}
	        }
	        
	      	//검색 버튼 클릭시 이벤트
		    function search() {
		    	var loginStop_ifrm = document.getElementById("loginStop_ifrm");
				CurPage = 1;
				
				if ($('#startDatepicker').val() == "" && $('#endDatepicker').val() == "" && $('#searchKeyword').val() == "") {
 					alert("<spring:message code='ezOrgan.0hun04' />");
 					return ;
				}
				
				if ($("#startDatepicker").val() != "" && $("#endDatepicker").val() == "") {
					alert("<spring:message code='ezOrgan.0hun06' />");
				    return;
				}
				 
				if ($("#endDatepicker").val() != "" && $("#startDatepicker").val() == "") {
 				 	alert("<spring:message code='ezOrgan.0hun05' />");
				    return;
				}
				 
				refreshList();
		    }
	      	
			function selectCompanyID(obj) {
				var loginStop_ifrm = document.getElementById("loginStop_ifrm");
				companyId = obj.options[obj.selectedIndex].value;
				
				loginStop_ifrm.contentWindow.companyID = companyId;
				refreshList();
			}
			
			function refreshList(){
				var loginStop_ifrm = document.getElementById("loginStop_ifrm");
				
				loginStop_ifrm.contentWindow.getUserList(1);
				loginStop_ifrm.contentWindow.makePageSelPage();
				loginStop_ifrm.contentDocument.getElementById("HeaderAllCheckBox").checked = false;
			}
			
			//**/ 검색값 입력 후 엔터키 입력 시 검색 호출
			function keyword_onkeydown(e) {
				
			    if (!window.ActiveXObject) {
			        var keyCode = e.keyCode;
			    } else {
			        var keyCode = event.keyCode;
			    }
			    
			    if (keyCode == 13) {
					search();
					return false;
				}
			    
				return true;
			}
	    </script>
	</head>
	<body class="mainbody">
		<div>
	    	<h1>사용자정지</h1>
	    	<span class="txt">▒ 특정 사용자를 사용 정지시킬 수 있습니다.</span><br><br>
		</div>
		<div>
			<span class="title_bar"><b>회사 선택 : </b></span>
			<c:if test="${rollCheck == 1}">
				<select class="companySelect" id="ListCompany" onChange="selectCompanyID(this)">
	           		<option value="">전체</option>
		        	<c:forEach var="item" items="${companylist}">
		           		<option value="<c:out value='${item.cn}'/>" ${item.cn == companyId ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		           	</c:forEach>
			    </select>
			</c:if>
			<c:if test="${rollCheck != 1}">
				<select class="companySelect" id="ListCompany" disabled>
					<c:forEach var="item" items="${companylist}">
		           		<option value="<c:out value='${item.cn}'/>" ${item.cn == companyId ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		           	</c:forEach>
			    </select>
			</c:if>
		</div>
		<div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	        	<p><span id="tagsub1">일반 사용자</span></p>
			    <p><span id="tagsub2">정지 사용자</span></p>
	        </div>
	    </div>
		<br>
		<div id="mainmenu">
			<ul>
                <li id="stopBtn" style="display:none"><span class="important" onClick="stop_onclick()">정지</span></li>
                <li id="releaseBtn" style="display:none"><span class="important" onClick="release_onclick()">해제</span></li>
		  	</ul>
		</div>
		<div style="width:100%; padding-bottom:5px;">
			<table style="width: 100%; background-color: #f8f8fa; border: 1px solid #ddd;">
				<tr>
					<td width="93%" style="margin-bottom: 10px; padding: 5px 5px;">
						<span id="topmenu" style="width: 500px"><spring:message code="ezStatistics.t1062"></spring:message>&nbsp; <!-- 검색조건 -->
							<select id="searchKeycode" style="height:22px;"> 
								<option value="userName"><spring:message code="ezStatistics.t1068"></spring:message></option> <!-- 이름 -->
								<option value="deptName"><spring:message code="ezStatistics.t113"></spring:message></option> <!-- 부서 -->
								<option value="userId"><spring:message code="ezOrgan.t218"></spring:message></option> <!-- cn -->
							</select>
							<input type="text" id="searchKeyword" style="width: 150px; height:22px;" onKeyDown="return keyword_onkeydown(event)"/>
							<a class="imgbtn" >
								<span onclick="javascript:search();"><spring:message code="ezStatistics.t36"></spring:message></span> <!-- 검색 -->
							</a>
<!-- 							<a class="imgbtn" > -->
<%-- 								<span onclick="javascript:reload();"><spring:message code="ezStatistics.t1060"></spring:message></span> <!-- 새로고침 --> --%>
<!-- 							</a> -->
						</span>
					</td>
				</tr>
			</table>
		</div>
		<iframe id="loginStop_ifrm" style="width: 100%; height:780px;" frameborder="0"></iframe>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
     	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
     	<span class="loading_layer" style="z-index:6000;position:absolute;top:350px;left:350px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>    
<!--      	<br/> -->
	</body>
</html>
