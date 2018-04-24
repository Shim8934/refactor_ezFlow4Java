<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code="ezWebFolder.t282"/></title>
<!--     <meta name="CODE_LANGUAGE" content="C#"> -->
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="<spring:message code='main.lhm02' />" type="text/css">
    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
    <link rel="stylesheet" href="/js/jsTree/dist/themes/default/style.css" />
    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script type="text/javascript" src="/js/jsTree/dist/jstree.js"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    
    <script>
        var PostTreeView = null;
        var treeconfig = "";
        var ReturnFunction;
        var CancelFunction;
        var isDivPopUp = false;
        var test = [];
        
        var createId = "";
        var id = "";
        var parent = "";
        var companyFolderId = "";
	    var deptFolderId    = "";
	    var persFolderId    = "";
		var folderId="";
		var folderType = "${folderType}";
		var checkedfileList = "${fileList}";
		var checkedfolderList = "${folderList}";

		document.onselectstart = function () {
            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
                return false;
            else
                return true;
        };
        window.onload = function () {
    		$('input:radio[name=treeType]:input[value='+folderType+']').attr("checked", true);
    		folderList(folderType);
        }
        var inputNameDlg_cross_dialogArguments = new Array();
        
        function folderList(obj) {
			folderType = obj;
			$.ajax ({
				type :"POST",
				async: false,
				url  : "/ezWebFolder/folderList.do",
				data : { 
						 "folderId"   : folderId
						,"folderType" : obj
					},
				dataType: "JSON",
				success : function (data) {
					test = data.data;
					parent = data.data[0]["parent"];
		        	$.jstree.destroy();
					$('#folderTree').jstree({
						
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
						},
						'plugins': ["core","types","json_data","changed","themes"]
					});
			   		
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			});
			$("#folderTree").on("changed.jstree", function (e, data) {
				folderId = data.selected[0];
				parent = data.node.original.parent;
				console.log("changed.jstree" + new Date()); 
			});
	    }
        
        var moveCopyFolderDlg_cross_dialogArguments = [];
        function move_onclick() {
        	
        	if (!confirm("<spring:message code='ezWebFolder.t283'/>")) {
        		return;
        	}
        	
            if (folderId == "") {
                alert("<spring:message code='ezWebFolder.t261'/>");
                return;
            }
           	
            if ( parent =='#' ) {
	            alert("<spring:message code='ezWebFolder.t262'/>");
	            return;
            }
            
            $.ajax ({
            	type : "POST",
            	async : false,
            	url : "/ezWebFolder/moveTrashCan.do",
            	dataType : "json",
            	data : {
            		"fileList" : checkedfileList,
            		"folderList" : checkedfolderList,
            		"folderId" : folderId
            	},
            	succss : function (data) {
            		aler("<spring:message code='ezWebFolder.t284'/>");
            	},
            	error : function(error) {
            		alert("<spring:message code='ezWebFolder.t285'/>");
            	}
            })
            
            window.close();
            opener.refreshView();
           
        }
        
        function requestdata(event) {
            if (!event) event = window.event;
            var nodeIdx = event.nodeIdx;
            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
                nodeIdx = arguments[0].nodeIdx;
            }
//             var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, false, true)
//             PostTreeView.putchildxml(nodeIdx, childxml);
        }
        
        function returnFunction(type) {
        	folderType = type;
        	$('input:radio[name=treeType]:input[value='+folderType+']').attr("checked", true);
        }
    </script>
</head>

<body scroll="no" class="popup">
	<h1><span><spring:message code='ezWebFolder.t286'/></span></h1>
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<div style="position: absolute; top: 0px; right: 0px;">
			<input name="treeType" id="radio1" type="radio" value="C" checked style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('C');"> <span><spring:message code='ezWebFolder.t233'/></span>
			<input name="treeType" id="radio2" type="radio" value="D"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('D');"> <span><spring:message code='ezWebFolder.t234'/></span>
			<input name="treeType" id="radio3" type="radio" value="U"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('U');"> <span><spring:message code='ezWebFolder.t235'/></span>
		</div>
	</div>
	<div style="margin: 5px 10px 10px 10px; border: 1px solid #666666; min-height: 350px; height: 350px; overflow: auto;" id="folderTree"></div>
	
	<div style="margin: 0px 0px 10px 140px; position:fixed;">
      	<a class="imgbtn" onclick="move_onclick()"><span><spring:message code="ezWebFolder.t121"/></span></a>
	</div>
	<div style="margin: 0px 0px 10px 200px; position:fixed;">
		<a class="imgbtn" onclick="Window_Close();"><span onclick=""><spring:message code='ezWebFolder.t110'/></span></a>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
	<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
	    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
	</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>

