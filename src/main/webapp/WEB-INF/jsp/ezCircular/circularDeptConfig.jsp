<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t35' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />
		<link rel="stylesheet" href="<spring:message code='ezCircular.e1' />" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			$(function() {
				// 전체 체크박스 선택, 해제
				$("#checkboxAll").on("click", function(){
					if ($("#checkboxAll").is(":checked")) {
						$(".myCheckbox").prop("checked", true);
					} else {
						$(".myCheckbox").prop("checked", false);
					}
				})
				// 개별 체크박스 선택, 해제
				$(".myCheckbox").on("click", function(){
					if ($(this).is(":checked")) {
						$(this).prop("checked", false);
					} else {
						$(this).prop("checked", true);
					}
					
				})
				
			});
			
			function event_Mover(obj) {
		        if (obj != _RowObject) {
		        	obj.style.backgroundColor = "#EDEDED";
		        }
		    }
			
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		        	obj.style.backgroundColor = "#FFFFFF";
		        }
		    }
		    
		    var _RowObject = null;
		    
		    function event_click(obj) {
		    	if (_RowObject != null) {
		    		_RowObject.style.backgroundColor = "#ffffff";
		    	}
		    	
		    	if (_RowObject == obj) {
		    		obj.style.backgroundColor = "#FFFFFF";
		    	}

		    	if ($("input[value=" + obj.id + "]").is(":checked")) {
		    		$("input[value=" + obj.id + "]").prop("checked", false);
		    	} else {
		    		$("input[value=" + obj.id + "]").prop("checked", true);
		    		$("input[value!=" + obj.id + "]").prop("checked", false);
		    	}

		    	if (_RowObject != obj) {
			    	obj.style.backgroundColor = "rgb(233, 241, 244)";		    		
		    	}

		        _RowObject = obj;
		    }

		    function event_dbclick() {
		    	modify_circularDept();
		    }

		    function memberList() {
		    	var circularBMId = _RowObject.id;
		    	
		    	var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;
		    	
		    	window.open("/ezCircular/circularCheckName.do?id=" + circularBMId, "", "height = 300px, width = 650px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status=no, toolbar=no, menubar=no, location=no, resizable=no");
		    }
			
			var schedule_admin_popup_sharedept_dialogArguments = new Array();
			
			function add_circularDept() {
		        if (CrossYN()) {
	                schedule_admin_popup_sharedept_dialogArguments[1] = share_new_Complete;
	                var OpenWin = window.open("/ezCircular/circularDeptadd.do", "", GetOpenWindowfeature(360, 180));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	                var feature = GetShowModalPosition(360, 180);
	                var rtnValue = window.showModalDialog("/ezCircular/circularDeptadd.do", "","dialogHeight:180px;dialogwidth:360px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                
	                if (typeof (rtnValue) != "unlimited" && rtnValue == "OK") {
	                    window.location.reload(false);
	                }
	            }
			}

			function share_new_Complete(retVal) {
	            if (typeof (retVal) != "unlimited" && retVal == "OK") {
	                window.location.reload(false);
	            }
	        }

			function modify_circularDept() {
				if (_RowObject == null) {
		        	alert("<spring:message code='ezCircular.t44' />");
		            return;
		        }

				if ($(".myCheckbox:checked").length > 1) {
					alert("<spring:message code='ezCircular.t49' />");
					return;
				}

				var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;

		        var circularBMId = _RowObject.id;

		        window.open("/ezCircular/circularDeptModify.do?id=" + circularBMId, "", "height = 280px, width = 450px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status=no, toolbar=no, menubar=no, location=no, resizable=no");		        			        
			}
			
			var circularBMIdList = new Array();
			
			function delete_circularDept() {
				var deleteList = [];
				
				if (_RowObject == null) {
		        	alert("<spring:message code='ezCircular.t44' />");
		            return;
		        }
				
				$(":checkbox[name=myCheckbox]:checked").each(function(){
					deleteList.push($(this).val());
				});

				var url = "/ezCircular/circularDeptDel.do?deleteList=" + deleteList.join();
				
				if (confirm("<spring:message code='ezCircular.t46' />")) {
					$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : url,
			    		success: function() {
			    			alert("<spring:message code='ezCircular.t45' />");
							window.location.reload(false);
			    		},
			    		error: function(err) {
			    			alert(strLang1);
			    		}
			        });					
				}
			}
		</script>
	</head>
	<body> 
		<form id="Form1" method="post">
			<br />
			<div id="mainmenu" style="width: 750px;">
			    <ul>
			        <li style=><span onClick="add_circularDept()"><spring:message code='ezCircular.t28' /></span></li>
			        <li style=><span onClick="modify_circularDept()"><spring:message code='ezCircular.t29' /></span></li>
			        <li style=><span onClick="delete_circularDept()"><spring:message code='ezCircular.t30' /></span></li>
			    </ul>
			</div>
			<table style="width: 750px; height: 385px;" border="0">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 750px; height: 385px; display: inline-table;">
		                    <table class="mainlist" style="width: 100%;">
		                        <tr>
		                        	<th style="width: 7%; "><input id="checkboxAll" type="checkbox"></th>
		                            <th style="width: 40%; "><span><spring:message code='ezCircular.t32' /></span></th>
		                            <th style="width: 27%; "><span><spring:message code='ezCircular.t33' /></span></th>
		                            <th style="width: 12%; "><span><spring:message code='ezCircular.t34' /></span></th>
		                        	<th style="width: 14%; "></th>
		                        </tr>
		                    </table>   
		                    <div id="contentlist" name="contentlist" style="height: 365px; overflow-y: auto;">
		                        <table class="mainlist" style="width: 100%;">
		                            <c:forEach var="item" items="${result}">
			                            <tr id="${item.circularBMID }" title="${item.title }" style="cursor:pointer" onmouseover="event_Mover(this);" onmouseout="event_Mout(this);" onclick="event_click(this);" ondblclick="event_dbclick(this);">
			                            	<td style='width:7%;padding-left:5px;'><input class="myCheckbox" name="myCheckbox" value="${item.circularBMID }" type='checkbox' onclick='event_statuschange(this);'></td>
			                            	<td style="width:40%;color:gray;">${item.title }</td>
			                            	<td style="width:27%;color:gray;">${item.regDate.substring(0,16) }</td>
			                            	<c:if test="${item.memberNameCount != 0}">
			                        			<td style="width: 12%;color:gray;">${item.memberName } <spring:message code='ezCircular.t50' /> ${item.memberNameCount } <spring:message code='ezCircular.t51' /></td>    		
			                            		<td id="pop" style="width: 14%;"><a href="javascript:memberList();" style="color:gray;">[<spring:message code='ezCircular.t92' />]</a></td>
			                            	</c:if>
		                            		<c:if test="${item.memberNameCount == 0}">
		                            			<td style='width: 12%;color:gray;'>${item.memberName }</td>
		                            			<td id="pop" style="width: 14%;"><a href="javascript:memberList();" style="color:gray;">[<spring:message code='ezCircular.t92' />]</a></td>
		                            		</c:if>
			                            </tr>
		                            </c:forEach>
		                            <c:if test="${circularbmid == 0 }">
			                            <tr>
			                                <td style="text-align: center;">
			                                    <spring:message code='ezCircular.t47'/>
			                                </td>
			                            </tr>	                            
		                            </c:if>
		                        </table>
		                    </div>
		                </div>
		            </td>
		        </tr>
		    </table>
			<script type="text/javascript">
			    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
		</form>
	</body>
</html>