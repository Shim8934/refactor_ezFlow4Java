<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t35' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var lang = "${userInfo.lang}";
			
			$(function() {
				getCircularDeptList();
			});
			
			function getCircularDeptList() {
				$.ajax({
					type : "GET",
					url : "/ezCircular/getcircularDeptList.do",
					dataType : "json",
					data : {
						
					},
					success : function(result) {
						var list = result.circularDeptList;
						
						if ( lang == "2" || lang == "6") {
							circularDeptList = "<colgroup><col width='7%' /><col width='40%' /><col width='18%' /><col width='18%' /><col width='17%' /></colgroup>";
						} else {
							circularDeptList = "<colgroup><col width='7%' /><col width='47%' /><col width='18%' /><col width='15%' /><col width='13%' /></colgroup>";
						}
						
						// 2018-02-13 주홍선 String replaceAll function 선언
						String.prototype.replaceAll = function (search, replacement) {
							var target = this;
							return target.split(search).join(replacement);
						}
						
						list.forEach(function(vo, index) {
							// 2018-02-13 주홍선 title '<', '>' html entity로 변환
							var title = vo.title.replaceAll('<', '&lt;').replaceAll('>', '&gt;');
							// 2018-05-02 김보미 title에 '&lt;','&gt;'문자 html적용되지 않게. 
							if (vo.title.indexOf('&') != -1) {
								title = vo.title.replaceAll('&', '&amp;');
							}
							
							circularDeptList += "<tr id=" + vo.circularBMID + " style='cursor:pointer' onclick='event_click(this);' ondblclick='modify_circularDept(this);'>";
							circularDeptList += "<td style='padding-left:5px;'><input class='myCheckbox' name='myCheckbox' value=" + vo.circularBMID + " type='checkbox' onclick='selectRow(this)'></td>";
							if ( lang == "2" || lang == "6") {
								circularDeptList += "<td class='title' style='color:gray; width:40%;' title='" + title + "'>" + title + "</td>";
							} else {
								circularDeptList += "<td class='title' style='color:gray; width:47%;' title='" + title + "'>" + title + "</td>";
							}
							
							circularDeptList += "<td style='color:gray;'>" + vo.regDate.substring(0,16) + "</td>";
							
							if (vo.memberNameCount == 0) {
								circularDeptList += "<td style='color:gray;'>" + vo.memberName + "</td>";
								circularDeptList += "<td id='pop'><a href='javascript:memberList();' style='color:gray;'>[<spring:message code='ezCircular.t82' />]</a></td>";
							} else {
								circularDeptList += "<td style='color:gray;'>" + vo.memberName + "&nbsp;<spring:message code='ezCircular.t50' />&nbsp;" + vo.memberNameCount + "<spring:message code='ezCircular.t51' /></td>"
								circularDeptList += "<td id='pop'><a href='javascript:memberList();' style='color:gray;'>[<spring:message code='ezCircular.t82' />]</a></td>";
							}
								
							circularDeptList += "</tr>";
						});
						
						if (list.length == 0) {
							circularDeptList += "<tr>";
							circularDeptList += "<td colspan='5' style='text-align: center;'><spring:message code='ezCircular.t47'/></td>";
							circularDeptList += "</tr>";
						}
						
						$("#circularDeptList").html(circularDeptList);
						
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
			}

		    var _RowObject = null;
		    function event_click(obj) {
				if ($("#checkboxAll").prop("checked") == true) {
					if ($(obj).find("input").prop("checked") == true) {
						$(obj).find("input").prop("checked", false);
						$(obj).css("backgroundColor", "#FFFFFF");
					} else {
						$(obj).find("input").prop("checked", true);
						$(obj).css("backgroundColor", "#f1f8ff");
					}
				} else {
					if (_RowObject != null) {
						$("input[name=myCheckbox]").prop("checked", false);
						$("input[name=myCheckbox]").parent().parent().css("backgroundColor", "#FFFFFF");
					}

					_RowObject = obj;
					$(obj).find("input").prop("checked", true);
					$(obj).css("backgroundColor", "#f1f8ff");
				}
        	}

		    function memberList() {
		    	var circularBMId = _RowObject.id;
		    	var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;
		    	
		    	window.open("/ezCircular/circularCheckName.do?circularBMId=" + circularBMId, "", "height = 300px, width = 650px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status=no, toolbar=no, menubar=no, location=no, resizable=no");
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
	                	getCircularDeptList();
	                }
	            }
			}

			function share_new_Complete(retVal) {
	            if (typeof (retVal) != "unlimited" && retVal == "OK") {
	            	getCircularDeptList();
	            }
	        }

			function modify_circularDept(obj) {
				var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;

		        var circularBMId = obj.id;

		        window.open("/ezCircular/circularDeptModify.do?id=" + circularBMId, "", "height = 280px, width = 450px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status=no, toolbar=no, menubar=no, location=no, resizable=no");		        			        
			}
			
			var circularBMIdList = new Array();
			
			function delete_circularDept() {
				var deleteList = [];
				
				$(":checkbox[name=myCheckbox]:checked").each(function(){
					deleteList.push($(this).val());
				});
				
				if (deleteList.length == 0) {
		        	alert("<spring:message code='ezCircular.t44' />");
		            return;
		        }

				if (confirm("<spring:message code='ezCircular.t46' />")) {
					$.ajax({
			    		type : "POST",
			    		dataType : "json",
			    		async : false,
			    		url : "/ezCircular/circularDeptDel.do",
			    		data : {
			    			circularBMIdList : deleteList.join()
			    		}, success: function() {
			    			getCircularDeptList();
			    		}, error: function(err) {
			    			alert(strLang1);
			    		}
			        });					
				}
			}

			function selectAll() {
				// 전체 체크박스 선택, 해제
				if ($("#checkboxAll").prop("checked") == true) {
					$(".myCheckbox").prop("checked", true);
					$("#circularDeptList tr").css("background", "#f1f8ff");
				} else {
					$(".myCheckbox").prop("checked", false);
					$("#circularDeptList tr").css("background", "#FFFFFF");
				}
			}

			function selectRow(obj) {
				var num = $(obj).attr("value");
				if ($(obj).prop("checked") != true) {
					$(obj).prop("checked", false);
					$(obj).parent().parent("tr[id = '" + num + "']").css("backgroundColor", "#FFFFFF");
				} else {
					$(obj).prop("checked", true);
					$(obj).parent().parent("tr[id = '" + num + "']").css("backgroundColor", "#f1f8ff");
				}

				event.stopPropagation();
			}

		</script>
	</head>
	<body> 
		<form id="Form1" method="post">
			<br />
			<div id="mainmenu" style="width: 750px;">
			    <ul>
			        <li class="important"><span onClick="add_circularDept()"><spring:message code='ezCircular.t77' /></span></li>
			        <li><span class="icon16 icon16_delete" onClick="delete_circularDept()"></span></li>
			    </ul>
			</div>
			<table style="width: 750px; height: 385px;" border="0">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 750px; height: 385px; display: inline-table;">
		                    <table class="mainlist" style="width: 100%;">
		                    <c:if test="${userInfo.lang ne 2 and userInfo.lang ne 6}">
		                    	<colgroup><col width='7%' /><col width='47%' /><col width='18%' /><col width='15%' /><col width='13%' /></colgroup>
		                    </c:if>
		                    <c:if test="${userInfo.lang eq 2 or userInfo.lang eq 6}">
		                    	<colgroup><col width='7%' /><col width='40%' /><col width='18%' /><col width='18%' /><col width='17%' /></colgroup>
		                    </c:if>
		                    	<!-- 18-05-24 김민성 - 회람판 > 즐겨찾기 단어 수정 -->
		                        <tr>
									<th><input id="checkboxAll" type="checkbox" onclick="selectAll()"></th>
		                            <th><spring:message code='ezCircular.t32' /></th>
		                            <th><spring:message code='ezBoard.t5007' /></th>
		                            <th><spring:message code='ezCircular.t34' /></th>
		                        	<th></th>
		                        </tr>
		                    </table>
		                    <div id="contentlist" style="height: 365px; overflow-y: auto;">
		                        <table id="circularDeptList" class="mainlist" style="width: 100%;">
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