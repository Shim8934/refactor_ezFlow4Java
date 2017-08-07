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
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezCircular.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			$(function() {
				// 전체 체크박스 선택, 해제
				$("#checkboxAll").on("click", function() {
					if ($("#checkboxAll").is(":checked")) {
						$(".myCheckbox").prop("checked", true);
						$("#circularDeptList tr").css("background", "#EDEDED");
					} else {
						$(".myCheckbox").prop("checked", false);
						$("#circularDeptList tr").css("background", "#FFFFFF");
					}
				})
				
				getCircularDeptList();
			});
			
			function getCircularDeptList() {
				$.ajax({
					type : "POST",
					url : "/ezCircular/getcircularDeptList.do",
					dataType : "json",
					data : {
						
					},
					success : function(result) {
						var list = result.circularDeptList;
						
						circularDeptList = "<colgroup><col width='7%' /><col width='47%' /><col width='18%' /><col width='15%' /><col width='13%' /></colgroup>";
						
						list.forEach(function(vo, index) {
							circularDeptList += "<tr id=" + vo.circularBMID + " style='cursor:pointer' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='modify_circularDept(this);'>";
							circularDeptList += "<td style='padding-left:5px;'><input class='myCheckbox' name='myCheckbox' value=" + vo.circularBMID + " type='checkbox'></td>";
							circularDeptList += "<td style='color:gray;' title=" + vo.title + ">" + vo.title + "</td>";
							circularDeptList += "<td style='color:gray;'>" + vo.regDate.substring(0,16) + "</td>";
							
							if (vo.memberNameCount == 0) {
								circularDeptList += "<td style='color:gray;'>" + vo.memberName + "</td>";
								circularDeptList += "<td id='pop'><a href='javascript:memberList();' style='color:gray;'>[<spring:message code='ezCircular.t92' />]</a></td>";
							} else {
								circularDeptList += "<td style='color:gray;'>" + vo.memberName + "<spring:message code='ezCircular.t50' />" + vo.memberNameCount + "<spring:message code='ezCircular.t51' /></td>"
								circularDeptList += "<td id='pop'><a href='javascript:memberList();' style='color:gray;'>[<spring:message code='ezCircular.t92' />]</a></td>";
							}
								
							circularDeptList += "</tr>";
						});
						
						if (list.length == 0) {
							circularDeptList += "<tr>";
							circularDeptList += "<td style='text-align: center;'><spring:message code='ezCircular.t47'/></td>";
							circularDeptList += "</tr>";
						}
						
						$("#circularDeptList").html(circularDeptList);
						
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
			}
			
			function event_Mover(obj) {
	            if (obj != _RowObject) {
    	            obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
        	        obj.childNodes.item(1).style.backgroundColor = "#EDEDED";
            	    obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
            	    obj.childNodes.item(3).style.backgroundColor = "#EDEDED";
            	    obj.childNodes.item(4).style.backgroundColor = "#EDEDED";
            	}	
        	}
			
        	function event_Mout(obj) {
            	if (obj != _RowObject) {
                	obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
                	obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
                	obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
                	obj.childNodes.item(3).style.backgroundColor = "#FFFFFF";
                	obj.childNodes.item(4).style.backgroundColor = "#FFFFFF";
            	}
        	}
		    
		    var _RowObject = null;
		    
		    function event_click(obj) {
            	if (_RowObject != null) {
                	_RowObject.childNodes.item(0).style.backgroundColor = "#FFFFFF";
                	_RowObject.childNodes.item(1).style.backgroundColor = "#FFFFFF";
                	_RowObject.childNodes.item(2).style.backgroundColor = "#FFFFFF";
                	_RowObject.childNodes.item(3).style.backgroundColor = "#FFFFFF";
                	_RowObject.childNodes.item(4).style.backgroundColor = "#FFFFFF";
            	}
            	
            	_RowObject = obj;
            	obj.childNodes.item(0).style.backgroundColor = "rgb(233, 241, 244)";
            	obj.childNodes.item(1).style.backgroundColor = "rgb(233, 241, 244)";
            	obj.childNodes.item(2).style.backgroundColor = "rgb(233, 241, 244)";
            	obj.childNodes.item(3).style.backgroundColor = "rgb(233, 241, 244)";
            	obj.childNodes.item(4).style.backgroundColor = "rgb(233, 241, 244)";
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
		</script>
	</head>
	<body> 
		<form id="Form1" method="post">
			<br />
			<div id="mainmenu" style="width: 750px;">
			    <ul>
			        <li style=><span onClick="add_circularDept()"><spring:message code='ezCircular.t77' /></span></li>
			        <li style=><span onClick="delete_circularDept()"><spring:message code='ezCircular.t30' /></span></li>
			    </ul>
			</div>
			<table style="width: 750px; height: 385px;" border="0">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 750px; height: 385px; display: inline-table;">
		                    <table class="mainlist" style="width: 100%;">
		                    	<colgroup><col width='7%' /><col width='47%' /><col width='18%' /><col width='18%' /><col width='10%' /></colgroup>
		                    	
		                        <tr>
		                        	<th><input id="checkboxAll" type="checkbox"></th>
		                            <th><spring:message code='ezCircular.t32' /></th>
		                            <th><spring:message code='ezCircular.t33' /></th>
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