<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t20004' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };
			
		    $(document).ready(function () {
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezPersonal/getSlider.do",
		        	async : false,
		        	success : function (result) {
		        		MakeSliderList(loadXMLString(result));
		        	}
		        });
		    });
	
		    function MakeSliderList(result) {
		        XmlNode = result;
		        
		        var DocList = new ListView();
		        DocList.SetID("DocList");
		        DocList.SetMulSelectable(false);
		        DocList.SetSelectFlag(false);
		        DocList.SetRowOnClick("event_click");
		        DocList.SetRowOnDblClick("event_dbclick");
		        DocList.DataSource(XmlNode);
		        DocList.DataBind("lvDocList");
		        DocList = null;
		    }
	
		    var tempid = "";
		    var _RowObject = null;
		    function event_click(obj) {
		        tempid = document.getElementById(obj).getAttribute("DATA1");
		        _RowObject = document.getElementById(obj);
		        MakeDescription(document.getElementById(obj).getAttribute("DATA2"));
		    }
		    
		    var selectimage_dialogArguments = new Array();
		    function btn_Select() {
		        if (CrossYN()) {
		            selectimage_dialogArguments[1] = btn_Select_Complete;
		            var SelectImage = window.open("/admin/ezPersonal/selectImage.do", "SelectImage", GetOpenWindowfeature(610, 410));
		            try { SelectImage.focus(); } catch (e) {
		            }
		        }
		        else {
		            var url = "/admin/ezPersonal/selectImage.do";
		            var feature = "center:yes;status:no;dialogWidth:610px;dialogHeight:410px;edge:sunken;scroll:no" + GetShowModalPosition(610, 410);
		            feature = feature + GetShowModalPosition(610, 410);
		            window.showModalDialog(url, "", feature);
		            window.location.reload(false);
		        }
		    }
		    
		    function btn_Select_Complete() {
		        window.location.reload(false);
		    }
	
		    function sliderdelete() {
		        if (tempid == "") {
		            alert("<spring:message code = 'ezPersonal.t1022' />");
		            return;
		        }
		        if (!confirm("<spring:message code = 'ezPersonal.t00003' />"))
		            return;
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/deleteSlider.do",
		        	async : false,
		        	dataType : "text",
		        	data : {sliderID : tempid},
		        	success : function(result) {
		        		if (result == "OK") {
		        			window.location.reload(false);
		        		} else {
		        			alert("error");
		        		}
		        	}
		        });
		    }
	
		    function MakeDescription(filepath) {
		        document.getElementById("ContentDescription").innerHTML = "<IMG src = '"+filepath+"' style='width:467px;height:200px' />";
		    }
	
		    function Reload() {
		        window.location.reload(false);
		    }
		    
		    function Priority_UP() {
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            if (_RowObject == null) {
		                alert("<spring:message code = 'ezPersonal.t1022' />");
		                return;
		            }
		            
		            var ChangeRow = null;
		            for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
		                if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
		                    if (i == 0) {
		                        return;
		                    }
		                    ChangeRow = i - 1;
		                    if (event_ChangePriority(_RowObject.getAttribute("DATA1"), _RowObject.getAttribute("DATA5"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA1"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA5")))
		                    swapNodes(_RowObject, _RowObject.parentNode.childNodes.item(ChangeRow));
		                    break;
		                }
		            }
		        } else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            if (_RowObject == null) {
		                alert("<spring:message code = 'ezPersonal.t1022' />");
		                return;
		            }
		            var ChangeRow = null;
		            for (var i = 0; i < _RowObject.parentNode.children.length ; i++) {
		                if (_RowObject.parentNode.children.item(i) == _RowObject) {
		                    if (i == 0) {
		                        return;
		                    }
		                    ChangeRow = i - 1;
		                    if (event_ChangePriority(_RowObject.getAttribute("DATA1"), _RowObject.getAttribute("DATA5"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA1"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA5"))) {
		                    swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
		                    }
		                    break;
		                }
		            }
		        }
		    }
		    
		    function Priority_DOWN() {
		        if (_RowObject == null) {
		            alert("<spring:message code = 'ezPersonal.t1022' />");
		            return;
		        }
		        
		        var ChangeRow = null;
		        for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
		            if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
		                if (i == _RowObject.parentNode.childNodes.length - 1) {
		                    return;
		                }
		                ChangeRow = i + 1;
		                
		                if (event_ChangePriority(_RowObject.getAttribute("DATA1"), _RowObject.getAttribute("DATA5"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA1"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA5"))) {
		                	swapNodes(_RowObject, _RowObject.parentNode.childNodes.item(ChangeRow));
		                }
		                
		                break;
		            }
		        }
		    }
		    
		    function event_ChangePriority(A_itemid, A_priority, B_itemid, B_priority) {
		        var ret = null;
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/statusChangeSlider.do",
		        	async : false,
		        	dataType : "text",
		        	data : {aRuleID : A_itemid, aPriority : B_priority, bRuleID : B_itemid, bPriority : A_priority, mode : "P"},
		        	success : function(result) {
		        		if (result == "OK") {
		        			ret = true;
		        		} else {
		        			alert(result);
		        			
		        			ret = false;
		        		}
		        	}
		        });
		        
		        return ret;
		    }
		    
		    function swapNodes(item1, item2) {
		        var itemtmp = item1.cloneNode(1);
		        var parent = item1.parentNode;
		        item2 = parent.replaceChild(itemtmp, item2);
		        item1.setAttribute("DATA5", item2.getAttribute("DATA5"));
		        item2.setAttribute("DATA5", itemtmp.getAttribute("DATA5"));
		        parent.replaceChild(item2, item1);
		        parent.replaceChild(item1, itemtmp);
		        itemtmp = null;
		    }
	
		    function event_statuschange(check) {
		        var isUse = "";
		        
		        if(check.checked) {
		        	isUse = '1';
		        } else {
		        	isUse = '0';
		        }
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/statusChangeSlider.do",
		        	async : false,
		        	dataType : "text",
		        	data : {sliderID : check.parentElement.parentElement.getAttribute("DATA1"), isUse : isUse, mode : "U"},
		        	success : function(result) {
		        		if (result != "OK") {
		        			alert(result);
		        		}
		        	}
		        });
		    }
	
		    function event_dbclick(clickitem) {
		        if (CrossYN()) {
		            selectimage_dialogArguments[1] = btn_Select_Complete;
		            
		            var SelectImage = window.open("/admin/ezPersonal/selectImage.do?item=" + document.getElementById(clickitem).getAttribute("DATA1"), "SelectImage", GetOpenWindowfeature(610, 410));
		            try { SelectImage.focus(); } catch (e) {
		            }
		        }
		        else {
		            var url = "/admin/ezPersonal/selectImage.do?item=" + document.getElementById(clickitem).getAttribute("DATA1") + "";
		            var feature = "center:yes;status:no;dialogWidth:610px;dialogHeight:410px;edge:sunken;scroll:no" + GetShowModalPosition(610, 410);
		            feature = feature + GetShowModalPosition(610, 410);
	
		            window.showModalDialog(url, "", feature);
	
		            window.location.reload(false);
		        }
		    }
		</script>
	</head>
	<body class = "mainbody">
		<h1><spring:message code = 'ezPersonal.t20004' /></h1><br />
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;<spring:message code = 'ezPersonal.t20007' /></span><br />
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;<spring:message code = 'ezPersonal.t20008' /></span><br />
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;<spring:message code = 'ezPersonal.t20009' /></span><br />
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;<spring:message code = 'ezPersonal.t20011' /></span><br />
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;<spring:message code = 'ezPersonal.t20012' /></span><br />
		<span class="txt" style="line-height:19px">&nbsp;*
	    <img src="/images/ImgIcon/prev.gif"   height="16" style="margin-top:-3px;vertical-align:middle;text-align:center;" alt="<spring:message code = 'ezPersonal.t366' />"/><img src="/images/ImgIcon/next.gif" height="16" style="margin-top:-3px;vertical-align:middle" alt="<spring:message code = 'ezPersonal.t367' />" />
	    <spring:message code = 'ezPersonal.t20013' />
		</span>
	    <br /><br /><br />
	    <div id="mainmenu">
	    	<ul>
	        	<li><span id ="NEW" onClick="btn_Select(this)"><spring:message code = 'ezPersonal.t105' /></span></li>
				<li><span onclick="sliderdelete();"><img src="/images/ImgIcon/delete.gif"   style="margin-top:-2px;"  /><spring:message code = 'ezPersonal.t99' /></span></li>
				<li><span onclick="Reload();"><img src="/images/ImgIcon/recur.gif"    style="margin-top:-2px;"  /><spring:message code = 'ezPersonal.t20006' /></span></li>
				<li><span onclick="Priority_UP();"><img src="/images/ImgIcon/prev.gif"  style="margin-top:-2px;" alt="<spring:message code = 'ezPersonal.t366' />"/></span></li>
				<li><span onclick="Priority_DOWN();"><img src="/images/ImgIcon/next.gif"  style="margin-top:-2px;" alt="<spring:message code = 'ezPersonal.t367' />" /></span></li>
			</ul>
	    </div>
	    
		<table style="width:750px;height:385px;" border="0">
	    	<tr>
	            <td>
					<div style="border:1px solid #dbdbda;width:435px;height:385px;border-top:0px">
	                	<div id="lvDocList"></div>
	<%--                <table class="mainlist" style="width:100%;">
		                    <tr>
		                        <td style="width:8%;background-color:#F3F3F3;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;"><span><spring:message code = 'ezPersonal.t937' /></span></td>
		                        <td style="width:60%;background-color:#F3F3F3;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;"><span style="padding-left:10px;"><spring:message code = 'ezPersonal.t9' /></span></td>
		                        <td style="width:32%;background-color:#F3F3F3;text-align:center;border-bottom:2px solid #dbdbda;"><span><spring:message code = 'ezPersonal.t1024' /></span></td>
		                    </tr>
		                </table>--%>
					</div>
	            </td>
	            <td style="vertical-align:top">
	            	<div style="border:1px solid #dbdbda;width:477px;height:215px;overflow-y:auto;margin:0px 5px 5px 5px;">
	                	<div id="ContentDescription" style="margin-top:1px;margin:5px 5px 5px 5px;">
	                	</div>
	            	</div>
	            </td>
	        </tr>
		</table>
	</body>
</html>