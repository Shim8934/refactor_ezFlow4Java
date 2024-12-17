<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t201' /></title>
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
	   		var lpDepts = [];
	   		var lpDeptNames = [];
	   		var lpAuthTypes = [];
	   		//오른쪽에서 없앨 부서
	   		var targetDept;
	   		//현재 레이어팝업에 선택된 유저
	   		var updateUserId;
	   		
	   		$(document).ready(function() {
	   			treeContent = ${deptList};
		   		setDeptList();
		    	
	   			$(function () {
		   			$(document).on({
		   				"dblclick":function(){delTargetDept(this);},
		   				"click":function(){targetDept = this;
			   				$("*").removeClass("selectTR");
				   			$(this).addClass("selectTR");
		   				}
	   				},"#lplistView tr");
	   			});
	   			
	   			try {
	   				RetValue = parent.ezattitude_dialogArguments[0];
	            } catch (e) {
	                try {
	                	RetValue = opener.ezattitude_dialogArguments[0];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            
		   		for (var i = 0; i < RetValue[0].length; i++) {
	   				lpDeptId = RetValue[0][i];
	   				lpDeptName = RetValue[1][i];
	   				lpAuthType = RetValue[2][i];
	   				
	   				addDeptInLP();
				}
   			});
	   	
	   		function close_Click() {
	   			window.close();
	   		}
	   		//조직도 뿌리는 펑션
	   		function setDeptList() {
				$('#treeview').on('changed.jstree', function (e, data) {
					lpDeptId = data.instance.get_node(data.selected).id;
					lpDeptName = data.instance.get_node(data.selected).text;
					lpAuthType = "R"; //초기값(기본값)
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
			
	   		//권한부서 리스트에 추가
	   		function addDeptInLP() {
	   			var flag = true;
	   			
	   			for (var i = 0; i < lpDepts.length; i++) {
					if (lpDepts[i] == lpDeptId) {
		   				alert("<spring:message code='ezAttitude.t203' />");
						flag = false;
					}
				}
	   			
	   			if (flag) {
		   			$("#lplistView .mainlist_free").append("<tr targetId="+lpDeptId+" targetName="+lpDeptName+" targetAuthType="+lpAuthType+" style='cursor: pointer;' class='hover'><td align='left' style='width:250px;'>"+lpDeptName+"</td></tr>");
		   			lpDepts.push(lpDeptId);
		   			lpDeptNames.push(lpDeptName);
		   			lpAuthTypes.push(lpAuthType);
	   			}
	   		}
	   		
	   		//레이어팝업의 오른쪽에 선택된 부서를 삭제
	   		function delTargetDept(elem) {
	   			var targetDeptId = $(".selectTR").attr("targetId");
	   			if (targetDeptId) {
		   			var targetDeptName = $(".selectTR").attr("targetName");
		   			var targetAuthType = $(".selectTR").attr("targetAuthType");
		   			
	   				lpDepts.splice(lpDepts.indexOf(targetDeptId), 1);
	   				lpDeptNames.splice(lpDeptNames.indexOf(targetDeptName), 1);
	   				lpAuthTypes.splice(lpAuthTypes.indexOf(targetAuthType), 1);
	   				$(".selectTR").remove();
	   			} else {
	   				alert("<spring:message code='ezAttitude.t204' />");
	   			}
	   		}
	   		
	   		//오프너의 부서 이름과 아이디 세팅
	   		function setAuthorViewDept() {
	   			opener.setDeptName(lpDepts.toString(), lpDeptNames.toString());
	   			opener.authRadioSet(lpAuthTypes.toString());
	   			window.close();
	   		}
		</script>
		
		<style>
			tr.hover:hover{background:#eee; color:#fff;}
			
			.selectTR{
				background-color: #f1f8ff;
			}
		</style>
	</head>
	
	<body class="popup">
	    <div id="menu">
			<ul id="menuTable">
				<li class="sel">
					<h1 style="padding: 0px; margin-top: -5px;"><spring:message code='ezAttitude.t201' /></h1>
				</li>
			</ul>
		</div>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"></span></li>
	        </ul>
	    </div>
       	<table>
            <tr>
                <td class="box" style="width: 250px; height: 465px;">
                    <div style="width: 250px; height: 470px; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
                </td>
                <td style="width: 30px; text-align: center;" rowspan="2">                            
                	<img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="addDeptInLP()"><br>
                	<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="delTargetDept(targetDept)">
                </td>
                <td class="listview" style="width: 200px; height: 465px; vertical-align: top;" id="lplistView" rowspan="2">
                	<div style="width: 200px; height: 100%; overflow: auto;">
	                	<table class="mainlist_free">
						</table>
					</div>
                </td>    
            </tr>
        </table>
        <div class="btnpositionNew" id="menuTable">        	
			<a class="imgbtn"><span onclick="setAuthorViewDept()"><spring:message code='main.t4008'/></span></a>			
        </div>
	</body>
</html>