<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t165'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezJournal/journal_css.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezJournal/journal_script.js')}"></script>
	   	<script type="text/javascript">
	   		//트리조직도 JSON
	   		var treeContent;
	   		//선택된 사원
	   		var selectedUser;
	   		var selectedUserName;
	   		//레이어팝업의 부서 정보
	   		var lpDeptId;
	   		var lpDeptName;
	   		//레이어팝업의 오른쪽의 부서정보
	   		var lpDepts=[];
	   		var lpDeptNames=[];
	   		//오른쪽에서 없앨 부서
	   		var targetDept;
	   		//현재 레이어팝업에 선택된 유저
	   		var updateUserId;
	   		
	   		function setLpDeptId(elem){
	   			lpDeptId = $(elem).attr("targetId");
	   			lpDeptName = $("#treeview").jstree().get_node(lpDeptId).text;
	   		}
	   	
	   		var CurPage = "1";
	   		var totalPage = "";	   		
	   		
	   		function close_Click(){
	   			window.close();
	   		}
	   		
	   		/**
	   			2018-07-10 페이징 기능 추가
	   		*/
	   		var BlockSize = 10;
	    	function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
	    	}
	    	function makePageSelPage() {
		        var strtext;
	        	var PagingHTML = "";
	        	document.getElementById("tblPageRayer").innerHTML = "";
	        	strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
	        	var pageNum = CurPage;
	        	if (totalPage > 1 && pageNum != 1) {
	            	strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
	            	PagingHTML += strtext;
	        	} else {
	            	strtext = "<span class='btnimg first disabled'></span>";
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
	            	strtext = strtext + "<span class='btnimg next disabled'>\</span>";
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
	        	if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
	        	else
		            return;
	    	}
	    	function selafterBlock() {
		        var pageNum = parseInt(CurPage);
	        	pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	        	goToPageByNum(pageNum);
	    	}
	    	function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
	        	if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
	    	        return;
	    	}
	    	function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	            	CurPage = newPage;
	            	if(issearch) {
		                search_click();
	            	} else {
		                setUserList();
	            	}
	        	}
	    	}
	    	function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
	        	if (newPage > 0) {
		            CurPage = newPage;
	            	if (issearch) {
		                search_click();
	            	} else {
		                setUserList();
	            	}
	        	}
	    	}
	    	function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
	        	if (newPage <= parseInt(totalPage)) {
		            CurPage = newPage;
	            	if (issearch) {
		                search_click();
	            	} else {
		                setUserList();
	            	}
	        	}
	    	}		   		
	   		
	   		//조직도 뿌리는 펑션
	   		function setDeptList(){
				$('#treeview').on('changed.jstree', function (e, data) {
					lpDeptId = data.instance.get_node(data.selected).id;
					lpDeptName = data.instance.get_node(data.selected).text;
				  }).on('dblclick.jstree', function (e, data) {
						addDeptInLP();
				}).jstree({ 
					'core' : {'data' : treeContent, 'multiple' : false},
					'plugins': ["wholerow"],
					'themes' : {'responsive' : true}
				}).on('ready.jstree', function(e, data) {
					var offset = $(".jstree-wholerow-clicked").offset();
		   	    	var jstree = document.getElementById("treeview");
		   	        $('#treeview').animate({scrollTop : offset.top - jstree.offsetHeight / 2}, 40);
			    });
	   		}
	   		
	   		var currentNode;
	   		//부서 리스트 오른쪽에 이동!
	   		function addDeptInLP(){
	   			if($("#withChild").is(":checked")){
	   				$('#treeview').jstree('open_all');
	   				$("#"+lpDeptId).find("a").each(function(){
	   					var childrenId = $(this).parent("li").attr("id");
	   					var childrenName = $("#treeview").jstree().get_node(childrenId).text;
			   			var flag = true;
			   			for (var i = 0; i < lpDepts.length ; i++) {
							if(lpDepts[i] == childrenId){
								flag = false;
							}
						}
			   			if (flag) {
				   			if (childrenId!=opener.userDeptId && opener.userAddIds.indexOf(childrenId) == -1) {
					   			$("#lplistView .mainlist_free").append("<tr targetId=" + childrenId + " style='cursor: pointer;' class='hover'><td align='left' style='width:250px;'>" + childrenName + "</td></tr>");
					   			lpDepts.push(childrenId);
					   			lpDeptNames.push(childrenName);
							} 
			   			}
	   				});
	   			} else {
		   			var flag = true;
		   			for (var i = 0; i < lpDepts.length ; i++) {
						if(lpDepts[i] == lpDeptId){
			   				alert("<spring:message code='ezJournal.t127'/>");
							flag = false;
						}
					}
		   			if (flag) {
			   			if (lpDeptId != opener.userDeptId && opener.userAddIds.indexOf(lpDeptId) == -1) {
				   			$("#lplistView .mainlist_free").append("<tr targetId=" + lpDeptId + " style='cursor: pointer;' class='hover'><td align='left' style='width:250px;'>" + lpDeptName + "</td></tr>");
				   			lpDepts.push(lpDeptId);
				   			lpDeptNames.push(lpDeptName);
						} else {
			   				alert("<spring:message code='ezJournal.t178'/>");
						}
		   			}
	   			}
	   		}
	   		
	   		//사원 리스트 뿌리기
	   		function setUserList(key,value){
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezJournal/userList.do",
	   				data:{"key":key, "value":value, "curPage" : curPage},
	   				success: function(result){
	   					$("#orglistView").empty();
		   				$("#orglistView").html(result);
						/**
							2018-07-10 페이징 기능 추가.
						*/
		   				$("#orglistView").append("<div id='tblPageRayer' style='text-align:center;'></div>");
						totalPage = Math.ceil($("#totalCount").val() / 50 );
		   				makePageSelPage();
	   				}
	   			});
	   		}
	   		
	   		//레이어팝업의 오른쪽에 선택된 부서를 삭제
	   		function delTargetDept(){
	   			var targetDeptId = $(".selectTR").attr("targetId");
	   			if(targetDeptId){
		   		//	var targetDeptName = $(".selectTR").attr("targetName");
		   			var targetDeptName = $("#treeview").jstree().get_node(targetDeptId).text;
		   			console.log("targetDeptName:" + targetDeptName);
	   				lpDepts.splice(lpDepts.indexOf(targetDeptId), 1);
	   				lpDeptNames.splice(lpDeptNames.indexOf(targetDeptName), 1);
	   				$(".selectTR").remove();
	   			} else {
	   				alert("<spring:message code='ezJournal.t168'/>");
	   			}
	   		}
	   		
	   		//오프너의 부서 이름과 아이디 세팅
	   		function setAuthorViewDept(){
	   			opener.setDeptName(JSON.stringify(lpDepts),JSON.stringify(lpDeptNames));
	   			window.close();
	   		}
	   		
	   		$(document).ready(function(){
	   			treeContent = ${deptList};
		   		setDeptList();
		    	
	   			$(function () {
		   			$(document).on({
		   				"dblclick":function(){delTargetDept();},
		   				"click":function(){targetDept = this;
			   				$("*").removeClass("selectTR");
				   			$(this).addClass("selectTR");
		   				}
	   				},"#lplistView tr");
	   			});
	   			for (var i = 0; i < opener.deptIds.length; i++) {
	   				lpDeptId = opener.deptIds[i];
	   				lpDeptName = opener.deptNames[i];
	   				addDeptInLP();
				}
   			});
		</script>
		
		<style>
			tr.hover:hover{background:#eee; color:#fff;}
			
			.selectTR{
				background-color: #f1f8ff;
			}
		</style>
	</head>
	
	<body class="popup"> 
        <h1><spring:message code='ezJournal.t165'/></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"></span></li>
	        </ul>
	    </div>
       	<table>
            <tr>
                <td class="box" style="width: 250px; height: 455px;">
                    <div style="width: 250px; height: 455px; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
                </td>
                <td style="width: 30px; text-align: center;" rowspan="2">                            
                      <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="addDeptInLP()"><br>
                      <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="delTargetDept()">
           		</td>
                <td class="listview" style="width: 200px; height: 465px; vertical-align: top;" id="lplistView" rowspan="2">
                	<div style="width: 250px; height: 474px; overflow: auto;">
	                	<table class="mainlist_free">
						</table>
					</div>
                </td>    
            </tr>
            <tr>
            	<td class="box" style="width: 250px;padding-top:5px;padding-left:3px">
            		<div style="height:25px">
            			<div class="custom_checkbox">
	            			<input type="checkbox" id="withChild" name="withChild" style="vertical-align: middle" />
            				<label for="withChild"><spring:message code='ezJournal.t226' /></label>
						</div>
            		</div>
            	</td>
            </tr>
        </table>
        <div class="btnpositionNew">
	        <a class="imgbtn"><span onclick="setAuthorViewDept();" ><spring:message code='ezJournal.t26' /></span></a>
	    </div>
	</body>
</html>

