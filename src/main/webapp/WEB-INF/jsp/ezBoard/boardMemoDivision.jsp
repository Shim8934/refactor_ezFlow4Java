<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezMemo.t0040" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />	
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezMemo.e1', 'msg')}"></script>
    	<script>
	    	$(function() {
	    		memoFoldersInfo();
			});
		
	    	var inputNameDlg_cross_dialogArguments = new Array();
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
						memoFolderList = "<colgroup><col width='7%' /><col width='60%' /><col width='33%' /></colgroup>";							
							 
						folderList.forEach(function(list, index){
							if(index == 0) {
								inputNameDlg_cross_dialogArguments[4] = list.folder_id;
								inputNameDlg_cross_dialogArguments[5] = list.folder_name;
							}
							memoFolderList += "<tr id=" + list.folder_id + " style='cursor:pointer' onclick='event_click(this);' ondblclick='modify_onclick(this);' data1='" + list.folder_id + "' data2='" + list.folder_name +"'>";
							memoFolderList += "<td style='padding-left:5px;'><input class='myCheckbox' name='myCheckbox' data2='" + list.folder_name +"' data3='" + list.count + "' value=" + list.folder_id + " type='checkbox' onclick='selectRow(this)'></td>";

							if (parseInt(list.orders) === 0) {
								memoFolderList += "<td class='title' style='color:gray;' title='" + memoMessages.strLangMemo22 + "'>" + memoMessages.strLangMemo22 + "</td>";
							} else {
								memoFolderList += "<td class='title' style='color:gray;' title='" + list.folder_name + "'>" + list.folder_name + "</td>";
							}
							memoFolderList += "<td style='color:gray;'>" + list.reg_date.substring(0,10) + "</td>";  
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
	    	
	    	function selectAll() {
				// 전체 체크박스 선택, 해제
				if ($("#checkboxAll").prop("checked") == true) {
					$(".myCheckbox").prop("checked", true);
					$("#memoFolderList tr").css("background", "#f1f8ff");
				} else {
					$(".myCheckbox").prop("checked", false);
					$("#memoFolderList tr").css("background", "#FFFFFF");
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
			
	    	function onclick_Complete(szName) {
		    	DivPopUpHidden();
		    }
	    	
	    	// 메모분류함 추가
	    	function add_onclick() {
	    		inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
			    inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
			    inputNameDlg_cross_dialogArguments[2] = "";
			    inputNameDlg_cross_dialogArguments[3] = "";
				var OpenWin = window.open("/ezMemo/memoInputName.do", "", GetOpenWindowfeature(500, 200));        
				try { OpenWin.focus(); } catch (e) { }
			}
	    	
	    	// 메모분류함 수정
	    	function modify_onclick(obj) {
	    		if($(obj).attr('data2') === "") {
		     		alert("<spring:message code='ezMemo.t0038' />");
		     		return;
		     	}
	    		
	    		if($(obj).attr('data1') == inputNameDlg_cross_dialogArguments[4] ) {
	    			// var strLangTemp = "<spring:message code='ezMemo.t0050' arguments='" + inputNameDlg_cross_dialogArguments[5].trim() + "' />"
	    			var strLangTemp = "<spring:message code='ezMemo.t0050' arguments='" + memoMessages.strLangMemo22 + "' />"
					alert(strLangTemp);
		     		return;
		     	}
	    		
	    		inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
			    inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
			    inputNameDlg_cross_dialogArguments[2] = $(obj).attr('data2');
			    inputNameDlg_cross_dialogArguments[3] = $(obj).attr('data1');
			    var OpenWin = window.open("/ezMemo/memoInputName.do", "", GetOpenWindowfeature(500, 200));        
				try { OpenWin.focus(); } catch (e) { }
			}
	    	
	    	// 메모분류함 삭제
	    	function delete_onclick() {
				var deleteList = [];
				var deleteAble = "on";
				var hasMemo="on";
				
				$(":checkbox[name=myCheckbox]:checked").each(function(){
					if($(this).attr("data3")>0) {	// 메모분류함의 메모 갯수 체크
						hasMemo="off";
					}
					if($(this).val() == inputNameDlg_cross_dialogArguments[4]) {	// 기본메모함인지 체크
						deleteAble = "off";
					}
					deleteList.push($(this).val());
				});
				
				// 체크된 리스트 유무 확인
				if (deleteList.length == 0) {	
		        	alert("<spring:message code='ezMemo.t0043' />");
		            return;
		        }
				
				// 기본메모함이 선택 되었다면 종료
				if(deleteAble === "off" ) {
					//var strLangTemp = "<spring:message code='ezMemo.t0049' arguments='" + inputNameDlg_cross_dialogArguments[5].trim() + "' />"
					var strLangTemp = "<spring:message code='ezMemo.t0049' arguments='" + memoMessages.strLangMemo22 + "' />"
					alert(strLangTemp);
					return;
				}
				
				// 빈 메모함이 아니라면
				var deleted ="off";
				if(hasMemo === "off" ) {
					deleted = confirm("<spring:message code='ezMemo.t0054' />");
				}
				
				
				// 메모함이 차 있고 삭제를 원하지 않을 때
				if(deleted == false) {
					return;
				}
				
				// 메모함이 차 있고 삭제를 원할 때
				if(deleted == true) {
					$.ajax({
			    		type : "POST",
			    		dataType : "json",
			    		async : false,
			    		url : "/ezMemo/memoFolderAction.do",
			    		data : {
			    			"methodType" : "delete",
			    			"folder_ids" : deleteList.join()
			    		}, success: function() {
			    			parent.parent.parent.parent.memoFoldersInfo("delete");
			    			window.parent.parent.frames["left"].memoFolderList();
			    			memoFoldersInfo();
			    		}, error: function(err) {
			    			alert("<spring:message code='ezMemo.t0045' />");
			    		}
			        });	
					return;
				}
				
				// 삭제 수행
				if (confirm("<spring:message code='ezMemo.t0044' />")) {
					$.ajax({
			    		type : "POST",
			    		dataType : "json",
			    		async : false,
			    		url : "/ezMemo/memoFolderAction.do",
			    		data : {
			    			"methodType" : "delete",
			    			"folder_ids" : deleteList.join()
			    		}, success: function() {
			    			memoFoldersInfo();
			    			parent.parent.parent.parent.memoFoldersInfo("delete");
			    			window.parent.parent.frames["left"].memoFolderList();
			    		}, error: function(err) {
			    			alert("<spring:message code='ezMemo.t0045' />");
			    		}
			        });					
				}
	    	}
    	</script>
	</head>
		<body style="margin-left: 10px; margin-right: 10px;">
			<br/>	
    		<span class="txt">▒ <spring:message code='ezMemo.t0056' /></span>  
    		<br />
        	<span class="txt">▒ <spring:message code='ezMemo.t0057' /></span>
    		<br />
    		<span class="txt">▒ <spring:message code='ezMemo.t0058' /></span>
        	<br /><br/>
     
			<div id="mainmenu" style="width: 750px;">
			    <ul>
			        <li class="important"><span onClick="add_onclick()"><spring:message code='ezMemo.t0027' /></span></li>
			        <%-- <li style=><span onClick="modify_onclick()"><spring:message code='ezMemo.t0028' /></span></li> --%>
			        <li><span class="icon16 icon16_delete" onClick="delete_onclick()"></span></li>
			    </ul>
			</div>
        	<table style="width: 450px; height: 385px;">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 450px; height: 385px; display: inline-table;">
		                    <table class="mainlist" style="width: 100%;">
		                    	<colgroup><col width='7%' /><col width='60%' /><col width='33%' /></colgroup>
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