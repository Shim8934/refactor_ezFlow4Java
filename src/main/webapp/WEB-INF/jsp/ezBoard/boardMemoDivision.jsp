<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezMemo.t0040" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
    	<link rel="stylesheet" href="/css/Tab.css" type="text/css" />	
    	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    	<script>
	    	$(function() {
	    		memoFoldersInfo();
			});
		
    	
    		/**
    		 * memo분류함을 조회
    		 */
	    	function memoFoldersInfo() {
	    		$.ajax({type : "GET",
	    			dataType : "json",
	    			async : false,
	    			url : "/ezMemo/getMemoFoldersInfo.do",
	    			success: function(result){
	    				var html="";
						var folderList = result["folders"];
						memoFolderList = "<colgroup><col width='7%' /><col width='55%' /><col width='38%' /></colgroup>";							
							 
						folderList.forEach(function(list, index){
							memoFolderList += "<tr id=" + list.folder_id + " style='cursor:pointer' onclick='event_click(this);'>";
							memoFolderList += "<td style='padding-left:5px;'><input class='myCheckbox' name='myCheckbox' value=" + list.folder_id + " type='checkbox' onclick='selectRow(this)'></td>";
							memoFolderList += "<td class='title' style='color:gray;' title='" + list.folder_name + "'>" + list.folder_name + "</td>";
							memoFolderList += "<td style='color:gray;'>" + list.reg_date.substring(0,16) + "</td>";  
							memoFolderList += "</tr>";
						});
						
						$("#memoFolderList").html(memoFolderList);
							
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
						$(obj).css("backgroundColor", "#edf4fd");
					}
				} else {
					if (_RowObject != null) {
						$("input[name=myCheckbox]").prop("checked", false);
						$("input[name=myCheckbox]").parent().parent().css("backgroundColor", "#FFFFFF");
					}
	
					_RowObject = obj;
					$(obj).find("input").prop("checked", true);
					$(obj).css("backgroundColor", "#edf4fd");
				}
	    	}
    	
	    	function selectRow(obj) {
				var num = $(obj).attr("value");
				if ($(obj).prop("checked") != true) {
					$(obj).prop("checked", false);
					$(obj).parent().parent("tr[id = '" + num + "']").css("backgroundColor", "#FFFFFF");
				} else {
					$(obj).prop("checked", true);
					$(obj).parent().parent("tr[id = '" + num + "']").css("backgroundColor", "#edf4fd");
				}
	
				event.stopPropagation();
			}

    	</script>
	</head>
		<body style="margin-left: 10px; margin-right: 10px;">
			<br/>	
    		<%-- <h2><spring:message code="ezMemo.t0040" /></h2>
    		<span class="txt">▒ <spring:message code="ezMemo.t002" /></span>   
    		<br />
    		<span class="txt">▒ <spring:message code="ezMemo.t003" /></span>
        	<br />
        	<span class="txt">▒ <spring:message code="ezMemo.t004" /></span>
        	<br /> --%>
     
			<div id="mainmenu" style="width: 750px;">
			    <ul>
			        <li style=><span onClick="add_onclick()"><spring:message code='ezMemo.t0027' /></span></li>
			        <li style=><span onClick="modify_onclick()"><spring:message code='ezMemo.t0028' /></span></li>
			        <li style=><span onClick="delete_onclick()"><spring:message code='ezMemo.t0029' /></span></li>
			    </ul>
			</div>
        	<table style="width: 450px; height: 385px;">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 450px; height: 385px; display: inline-table;">
		                    <table class="mainlist" style="width: 100%;">
		                    	<colgroup><col width='7%' /><col width='55%' /><col width='38%' /></colgroup>
		                        <tr>
									<th><input id="checkboxAll" type="checkbox" onclick="selectAll()"></th>
		                            <th><spring:message code='ezMemo.t0041' /></th>
		                            <th><spring:message code='ezMemo.t0042' /></th>
		                        	<th></th>
		                        </tr>
		                    </table>
		                    <div id="contentlist" style="height: 365px; overflow-y: auto;">
		                        <table id="memoFolderList" class="mainlist" style="width: 100%;">
		                        </table>
		                    </div>
		                </div>
		            </td>
		        </tr>
		    </table>
		</body>
</html>