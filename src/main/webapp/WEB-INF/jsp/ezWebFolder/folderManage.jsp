<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code='ezEmail.t535' /></title>
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
        var lang = "${userinfo.lang}";
        var PostTreeView = null;
        var treeconfig = "";
        var ReturnFunction;
        var CancelFunction;
        var isDivPopUp = false;
        var isFolderManager = false;
        var test = [];
        
        var createId = "";
        var id = "";
        var parent = "";
        var companyFolderId = "";
	    var deptFolderId    = "";
	    var persFolderId    = "";
	    var userId = "<c:out value='${userId}'/>";
		var userName = "<c:out value='${userName}'/>";
		var folderId="";
		var folderType = "${folderType}";
        if ("${isFolderManager}" == "1") {
        	isFolderManager = true;
        }
        
        document.onselectstart = function () {
            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
                return false;
            else
                return true;
        };
        function window_onload() {
    		$('input:radio[name=treeType]:input[value='+folderType+']').attr("checked", true);
        	folderList(folderType);

        }
        var inputNameDlg_cross_dialogArguments = new Array();
        function Window_Close() {
            if (ReturnFunction!=null) {
                if (!isDivPopUp)
                    window.close();
                else
                    CancelFunction();   
            }
            else
                window.close();
        }
        /*
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
			   createId = folderId != null ? data.node.original.createId : ""; 
			   parent   = data.node.original.parent; 
			   console.log("The selected nodes are:" + folderId);
			});
	    }*/
        function folderList(obj) {
	    	$('#folderTree').jstree('destroy');
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
//						upperId = data.data[0]["parent"];
					var firstNode = "#" + folderId;
					
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
							"width"       : "20",
							"margin-left" : "10"
						}
					}).on('changed.jstree', function (e, data) {
						folderId = data.selected[0]; 
						createId = folderId != null ? data.node.original.createId : ""; 
						parent   = data.node.original.parent; 
						console.log("The selected nodes are:" + folderId);
					});
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			});
	    }
        
        
        function add_onclick() {
            if (folderId == "") {
                alert("<spring:message code='ezWebFolder.t257'/>");
                return;
            }
            var functionType = "insert"; 
            inputNameDlg_cross_dialogArguments[0] = folderId;
            inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
            inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
            inputNameDlg_cross_dialogArguments[3] = functionType;
            DivPopUpShow(330, 170, "/ezWebFolder/inputNameDlg.do");
        }
        function update_onclick() {
            if (folderId == "") {
                alert("<spring:message code='ezWebFolder.t256'/>");
                return;
            }
            if (userId !=createId ) {
            	alert("<spring:message code='ezWebFolder.t258'/>");
            	
            	return;
            }else {
            }
            var functionType = "update"; 
            inputNameDlg_cross_dialogArguments[0] = folderId;
            inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
            inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
            inputNameDlg_cross_dialogArguments[3] = functionType;
            DivPopUpShow(330, 170, "/ezWebFolder/inputNameDlg.do");
        }
        var deleteFolderDlg_cross_dialogArguments = [];
        function delete_onclick() {
            if (folderId == "") {
                alert("<spring:message code='ezWebFolder.t259'/>");
                return;
            }
            if (userId !=createId ) {
            	alert("<spring:message code='ezWebFolder.t260'/>");
            	
            	return;
            }else {
            }
            deleteFolderDlg_cross_dialogArguments[0] = folderId;
            deleteFolderDlg_cross_dialogArguments[1] = add_onclick_Complete
            console.log("folderId delete_onclick function" + folderId);
            console.log("deleteFolderDlg_cross_dialogArguments delete_onclick function" + deleteFolderDlg_cross_dialogArguments[0]);
            DivPopUpShow(330, 170, "/ezWebFolder/folderDelete.do");
        }
        var moveCopyFolderDlg_cross_dialogArguments = [];
        function move_onclick() {
            if (folderId == "") {
                alert("<spring:message code='ezWebFolder.t261'/>");
                return;
            }
           	
            if ( parent =='#' ) {
	            alert("<spring:message code='ezWebFolder.t262'/>");
	            return;
            }else if (folderType == "C") {
            	for ( var i = 0 ; i <test.length; i++) {
            		if (test[i].id == parent) {
            			if(test[i].parent == '#') {
				            alert("<spring:message code='ezWebFolder.t262'/>");
				            return;
            			} 
            		}
            	}
            }
            moveCopyFolderDlg_cross_dialogArguments[0] = folderId;
            moveCopyFolderDlg_cross_dialogArguments[1] = "move";
            moveCopyFolderDlg_cross_dialogArguments[2] = returnFunction;
            console.log("folderId moveCopy_onclick function" + folderId);
            console.log("moveCopyFolderDlg_cross_dialogArguments delete_onclick function" + moveCopyFolderDlg_cross_dialogArguments[0]);
            DivPopUpShow(330, 500, "/ezWebFolder/folderMove.do");
        }
        function copy_onclick() {
            if (folderId == "") {
                alert("<spring:message code='ezWebFolder.t261'/>");
                return;
            }
           	
            moveCopyFolderDlg_cross_dialogArguments[0] = folderId;
            moveCopyFolderDlg_cross_dialogArguments[1] = "copy";
            moveCopyFolderDlg_cross_dialogArguments[2] = returnFunction;
            console.log("folderId copy_onclick function" + folderId);
            console.log("moveCopyFolderDlg_cross_dialogArguments delete_onclick function" + moveCopyFolderDlg_cross_dialogArguments[0]);
            DivPopUpShow(330, 500, "/ezWebFolder/folderMove.do");
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
        

        
	    function add_onclick_Complete(szName) {
	    	DivPopUpHidden();
        	folderList(folderType);
	    }
        function returnFunction(type) {
        	folderType = type;
        	$('input:radio[name=treeType]:input[value='+folderType+']').attr("checked", true);
        }
    </script>
</head>

<body scroll="no" class="popup" onload="javascript:window_onload()">
	<h1>폴더관리</h1>
	
	<div id="close">
		<ul>
			<li><span onclick="Window_Close();"><spring:message code='ezWebFolder.t110'/></span></li>
		</ul>
	</div>
	
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<div style="position: absolute; top: 0px; right: 0px;">
			<input name="treeType" id="radio1" type="radio" value="C" checked style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('C');"> <span><spring:message code='ezWebFolder.t233'/></span>
			<input name="treeType" id="radio2" type="radio" value="D"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('D');"> <span><spring:message code='ezWebFolder.t234'/></span>
			<input name="treeType" id="radio3" type="radio" value="U"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('U');"> <span><spring:message code='ezWebFolder.t235'/></span>
		</div>
	</div>
	<div style="margin: 5px 10px 10px 10px; border: 1px solid #666666; min-height: 350px; height: 350px; overflow: auto;" id="folderTree"></div>
	
	<div style="margin: 6px 0px 10px 140px; position:fixed; bottom: 0px;">
		<a class="imgbtn"><span onclick=""><spring:message code="ezWebFolder.t254"/></span></a>
      	<a class="imgbtn" onclick="add_onclick()"><span><spring:message code="ezWebFolder.t255"/></span></a>
      	<a class="imgbtn" onclick="update_onclick()"><span><spring:message code="ezWebFolder.t162"/></span></a>
      	<a class="imgbtn" onclick="move_onclick()"><span><spring:message code="ezWebFolder.t121"/></span></a>
      	<a class="imgbtn" onclick="copy_onclick()"><span><spring:message code="ezWebFolder.t122"/></span></a>
      	<a class="imgbtn" onclick="delete_onclick()"><span><spring:message code="ezWebFolder.t111"/></span></a>
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

