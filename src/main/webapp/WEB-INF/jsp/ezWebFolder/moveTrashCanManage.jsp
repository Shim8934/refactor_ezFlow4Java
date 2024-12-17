<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code="ezWebFolder.t282"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/js/ezWebFolder/jsTree/dist/themes/default/style.css')}" />
    <link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/jsTree/dist/jstree.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
   	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>	
    <script>
        var PostTreeView = null;
        var treeconfig = "";
        var test = [];
        var parent = "";
		var folderId = "";
		var folderType = "<c:out value='${folderType}'/>";
		var checkedfileList = "<c:out value='${fileList}'/>";
		var checkedfolderList = "<c:out value='${folderList}'/>";
		var treeData;
		var isAdmin = "<c:out value='${isAdmin}'/>";

        window.onload = function () {
    		$('input:radio[name=treeType]:input[value='+folderType+']').attr("checked", true);
    		folderList(folderType);
        }
        
        function folderList(obj) {
			folderType = obj;
			$.ajax({
				type :"POST",
				async: true,
				url  : "/ezWebFolder/folderList.do",
				data : { 
					"folderId": folderId,
					"folderType": obj,
					"isAdmin": isAdmin
				},
				dataType: "JSON",
				success : function (data) {
					test = data.data;
					parent = data.data[0]["parent"];
		        	$.jstree.destroy();
					$('#folderTree').jstree({
						'plugins': ["core","types","json_data","themes","ui"],
						'core' : {
							"animation" : 0,
							'data' : data.data,
							"multiple" : false,
							'themes' : {
								"theme"      : "default",
								"dots"       : false,
								'responsive' : false,
								'variant'    : 'small',
								'stripes'    : false
							}
						},
						"types" : {
							"default": {
								"icon" :"/images/OrganTree_cross/fldr.gif" 
							}
						},
						"grid": {
							"width"       : "25",
							"margin-left" : "10"
						}
					}).on('loaded.jstree', function() {
						treeData = data;
						addTitle();
						firFolderId = data.data[0]["id"];
						var test = "#" + folderId;
						var elmentTest = document.getElementById(firFolderId);
						var childE = document.getElementById(firFolderId + "_anchor");
						childE.setAttribute("class", "jstree-anchor jstree-clicked");
						elmentTest.setAttribute("aria-selected", "true");
						folderId = firFolderId;
					}).on('changed.jstree', function (e, data) {
						folderId = data.selected[0];
						parent = data.node.original.parent;
					});
				},
			    error : function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			});
		}

		function move_onclick() {
        	
            if (folderId == "") {
                alert("<spring:message code='ezWebFolder.t261'/>");
                return;
            }
           	
            // 회사폴더일 경우에만 최상위폴더에 파일을 이동할 수 없도록 수정. 2020-03-24 홍대표.
            // 카이스트 커스터마이징 건으로 아래 코드 삭제                              2020-12-14 서재원.
            if ( folderType == 'C' && parent =='#') {
	            alert("<spring:message code='ezWebFolder.t293'/>");
	            return;
            } 
            
        	if (!confirm("<spring:message code='ezWebFolder.t283'/>")) {
        		return;
        	}
        	
            $.ajax ({
            	type : "POST",
            	async : false,
            	url : "/ezWebFolder/moveTrashCan.do",
            	dataType : "json",
            	data : {
            		"fileList" : checkedfileList.toString(),
            		"folderList" : checkedfolderList.toString(),
            		"folderId" : folderId
            	},
            	success : function (data) {
            		if (data.code == 0) {
	            		alert("<spring:message code='ezWebFolder.t284'/>");
	            		
	            		if (typeof opener.treeRefresh == "function") {
	            			opener.treeRefresh();
	            		}
            		} else if (data.code == 1) {
            			alert(data.reason);
            		} else if (data.code == 2) {
	            		alert("<spring:message code='ezWebFolder.t285'/>");
					} else if (data.code == 3) {
						alert("<spring:message code='ezWebFolder.t28'/>");
					} else if (data.code == 8) {
						opener.duplicateFile.process({
							workType: "trashMove",
							infoArray: data.duplicateInfoArray,
							folderId: folderId
						}, true);
					} else if(data.code == 4 && data.status == "error") {
						alert("<spring:message code='ezWebFolder.t250'/>");
					}
            	},
            	error : function(error) {
            		alert(messages.strLang7 + error);
            	}
            });
            
            window.close();
            opener.refreshView();
        }
        
		function addTitle() {
		   	var data = this.treeData;
		   	for ( var i = 0; i < data.length ; i++  ) {
		   		var dataId = data[i]["id"] + "_anchor";
		   		var folderName = data[i]["folderName1"];
		   		var childE = document.getElementById(dataId);
		   		if (childE != null){
					childE.setAttribute("title", folderName);
	    		}
	    	}
	    }
    </script>
</head>

<body scroll="no" class="popup">
	<h1><spring:message code='ezWebFolder.t286'/></h1>
	<div id="close">
        <ul>
            <li><span onclick="window.close()"></span></li>
        </ul>
    </div>
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<div style="position: absolute; top: 0px; right: 0px;">
			<input name="treeType" id="radio1" type="radio" value="C" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="folderList('C');"><label for="radio1"><span> <spring:message code='ezWebFolder.t233'/></span></label>
			<input name="treeType" id="radio2" type="radio" value="D" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="folderList('D');"><label for="radio2"><span> <spring:message code='ezWebFolder.t234'/></span></label>
			<input name="treeType" id="radio3" type="radio" value="U" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="folderList('U');"><label for="radio3"><span> <spring:message code='ezWebFolder.t235'/></span></label>
		</div>
	</div>
	<div style="margin: 0px 10px 10px 10px; border: 1px solid #ddd; min-height: 330px; height: 330px; overflow: auto; padding-top:5px" id="folderTree"></div>
	<div class="btnpositionNew">
      	<a class="imgbtn" onclick="move_onclick()"><span><spring:message code="ezWebFolder.t121"/></span></a>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
	<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
	    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
	</div>
</body>
</html>