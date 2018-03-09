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
<!--     <script type="text/javascript" src="/js/ezEmail/js_cross/email_tree.js"></script> -->
<!--     <script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview.htc.js"></script> -->
<!--     <script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script> -->
<!--     <script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script> -->
    
   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
    <link rel="stylesheet" href="/js/jsTree/dist/themes/default/style.css" />
    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script type="text/javascript" src="/js/jsTree/dist/jstree.min.js"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    
    <script>
        var lang = "${userinfo.lang}";
        var PostTreeView = null;
        var treeconfig = "";
        var ReturnFunction;
        var CancelFunction;
        var isDivPopUp = false;
        var isFolderManager = false;
        
        
        var companyFolderId = "";
	    var deptFolderId    = "";
	    var persFolderId    = "";
	    var userId = "<c:out value='${userId}'/>";
		var userName = "<c:out value='${userName}'/>";
		var folderId="";
		var folderType = "";
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
        	folderList('');
            try {
                ReturnFunction = parent.mail_movecopy_cross_dialogArguments[1];
                CancelFunction = parent.mail_movecopy_cross_dialogArguments[2];
                isDivPopUp = true;
            } catch (e) {
                try {
                    ReturnFunction = opener.mail_movecopy_cross_dialogArguments[1];
                    CancelFunction = opener.mail_movecopy_cross_dialogArguments[2];
                } catch (e) { }
            }
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
        function folderList(obj) {
			folderType = obj;
			$.ajax ({
				type :"POST",
				async: true,
				url  : "/ezWebFolder/folderList.do",
				data : { 
						 "folderId"   : folderId
						,"folderType" : obj
					},
				dataType: "JSON",
				success : function (data) {
// 					$("#PostTreeView2").jstree(true).settings.core.data.url ='/getstuff/@mapobj.id.toString/';
					$('#jst_propl').jstree(true).refresh();
// 		        	$('#PostTreeView2').jstree('destroy');
					$('#PostTreeView2').jstree({
						
						
						'core' : {
							'data' : data.data,
							"multiple" : false,
							'themes' : {
								"theme"      : "default",
								"dots"       : false,
								'responsive' : false,
								'variant'    : 'small',
								'stripes'    : false,
// 								'selected'	 : true
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
					})
			   		
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			});
			$("#PostTreeView2").on("changed.jstree", function (e, data) {
			   folderId =data.selected[0]; 
			   console.log("The selected nodes are:" + folderId);
			});
	    }
        
        function add_onclick() {
            if (folderId == "") {
                alert("하위폴더를 만들 폴더를 선택해주세요");
                return;
            }
            
            inputNameDlg_cross_dialogArguments[0] = folderId;
            inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
            inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
            DivPopUpShow(330, 170, "/ezWebFolder/inputNameDlg.do");
        }
        function requestdata(event) {
            if (!event) event = window.event;
            var nodeIdx = event.nodeIdx;
            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
                nodeIdx = arguments[0].nodeIdx;
            }
            var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, false, true)
            PostTreeView.putchildxml(nodeIdx, childxml);
        }
        

        
	    function add_onclick_Complete(szName) {
	    	DivPopUpHidden();
//         	folderList('');
        	$($element).jstree(true).refresh();
	        if (typeof (szName) == "undefined" || szName.trim() == "" || szName == PostTreeView.getvalue(PostTreeView.selectedIndex(), "caption")) {
	            return;
	        }
	        if (checkBadFolderName(szName)) {
	        	 
	            return;
	        }

	        var result = mail_make_folder("MODIFY", PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), "", szName);
	        
	        if (result != "OK") {
	        	if (result == "ALREADY_EXISTS") {
	        		alert("<spring:message code='ezEmail.lhm05' />");
	        	} else {
	        		alert("<spring:message code='ezEmail.t459' />");
	        	}
	        	return;
	        }
	        
	        LoadAddressTree(PostTreeView.selectedIndex());
	        EventCheck = true;
	    }
        
        
//         function btn_Copy_onclick() {
//             if (PostTreeView.selectedIndex == -1) {
//                 alert("<spring:message code='ezEmail.t536' />");
//                 return;
//             }
//             var retVal = new Array();
//             retVal["cmd"] = "COPY";
//             retVal["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
//             if (getparentnode(PostTreeView.selectedNode()) != null) {
//                 retVal["idx"] = gettopvalue(PostTreeView.selectedNode());
//             }
//             else {
//                 retVal["idx"] = PostTreeView.selectedIndex();
//             }
//             if (ReturnFunction!=null)
//             {
//                 ReturnFunction(retVal);
//                 if (!isDivPopUp)
//                     window.close();
//             }
//             else {
//                 window.returnValue = retVal;
//                 window.close();
//             }
//         }
//         function btn_Move_onclick() {
//             if (PostTreeView.selectedIndex == -1) {
//                 alert("<spring:message code='ezEmail.t537' />");
//                 return;
//             }

//             var retVal = new Array();
//             retVal["cmd"] = "MOVE";
//             retVal["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
//             if (getparentnode(PostTreeView.selectedNode()) != null) {
//                 retVal["idx"] = gettopvalue(PostTreeView.selectedNode());
//             }
//             else {
//                 retVal["idx"] = PostTreeView.selectedIndex();
//             }
//             if (ReturnFunction!=null) {
//                 ReturnFunction(retVal);
//                 if (!isDivPopUp)
//                     window.close();
//             }
//             else {
//                 window.returnValue = retVal;
//                 window.close();
//             }
//         }
    </script>
</head>
<body scroll="no" class="popup" onload="javascript:window_onload()">
    <h1>폴더관리</h1>
    <div id="close">
        <ul>
            <li><span onclick="Window_Close();"><spring:message code='ezEmail.t63' /></span></li>
        </ul>
    </div>
    <table class="content">
        <tr>
            <td class="pos1">
                <div style="border: 0px solid #B6B6B6; height: 275px; width: 240px; overflow-x: auto; overflow-y: auto; 
                background-color: #FFFFFF; padding-left: 4px; padding-top: 5px;" id="PostTreeView2">
                </div>
            </td>
            <td class="pos3">
            	<a class="imgbtn"><span onclick="add_onclick()">공 유</span></a>
            	<a class="imgbtn"><span onclick="add_onclick()">새폴더</span></a>
            	<a class="imgbtn"><span onclick="return btn_Copy_onclick()">수 정</span></a>
            	<a class="imgbtn"><span onclick="return btn_Copy_onclick()">이동/복사</span></a>
            	<a class="imgbtn"><span onclick="return btn_Copy_onclick()">삭 제</span></a>
            </td>
        </tr>
    </table>
   		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	
    <script type="text/javascript">
        selToggleList(document.getElementById("close"), "ul", "li", "0");
    </script>
    
</body>
</html>



