<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t20004' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style type="text/css">
		body {background-color : white;}
		.ui-sortable{ margin:0px; padding:0px;}
		ul .sliderList {margin:0px 15px 15px 0px;display:inline-block; border-radius:0px; vertical-align : top; background-color : #ffffff; box-sizing:border-box; border:none; box-shadow:0px 1px 5px 0px rgba(0, 0, 0, 0.20);position:relative;}
		ul .slider-header {padding:0px 0px 0px 15px;margin:0px;position: relative;cursor:move; border:none; font-size:14px; font-weight:bold; height:40px; line-height:38px; border-radius:0px; color:#393939;background-color:#2196f3; border:1px solid #2196f3; width:210px;}
		ul .slider-content {padding:5px 15px 10px 15px;clear:both; box-sizing:border-box; border-radius:0px; border:1px solid #dfe2e4; margin:-1px 0px 0px 0px; height:130px;}
		ul .slider-imagePage {padding:5px 10px 10px 15px; width:225px; height:210px;}
		ul .addSlider {border:1px dashed #aab2ba; display:inline-block; text-align:center; vertical-align : top; height:19.3em; border-radius:0px; width:225px; height: 370px; position:relative;}
		ul .addSlider:hover {cursor:pointer;}
		ul .slideIsUse {padding: 30px 0px 10px 0px;}
		.cancelNewSliderBtn span {height:25px; float:right; padding: 3px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
		.addNewSliderBttn span {height:25px; float:right; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
		.addImageBtn span {height:25px; background-color:#f4f4f4; border:1px solid #e7e7e7;  float:right; padding: 0px 9px; line-height: 23px; display:block; text-align: center; margin-top:40%; margin-right:30%}
		.sliderInfoTDadd { padding: 5px;}
	}
		</style>
		<script type="text/javascript">
			
			/*  document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };  */
			
		    $( function() {
		    	getSliderList();
		    })
		    
		    //데이터 값 부르기
		    var getSliderList = function() {
		    	$.ajax({
		        	type : "POST",
		        	dataType : "json",
		        	url : "/admin/ezPersonal/getSlider.do",
		        	async : false,
		        	success : function (result) {
		        		//MakeSliderList(loadXMLString(result));
		        		MakeSliderList(result);
		        	}
		        });
		    }
		    
		    //슬라이드 이미지 목록
		    function MakeSliderList(result) {
		    	console.log(result);
		    
		    	var sliderSn = "";
		    	var sliderID = "";
		    	var sliderImagePath = "";
		    	var sliderName = "";
		    	var sliderName2 = "";
		    	var sliderRegDate = "";
		    	var sliderURL = "";
		    	var sliderIsUse = "";
		    	var sliderHTML = "";
		    	var sliderCnt = result.length;
		    	var sliderFileName = "";
		    	
		    	for (var i = 0; i < sliderCnt; i++) {
		    		sliderSn = result[i].sn;
		    		sliderID = result[i].sliderID;
		    		sliderImagePath = result[i].imagePath;
		    		sliderName = result[i].sliderName;
		    		sliderName2 = result[i].sliderName2;
		    		sliderRegDate = result[i].regDate;
		    		sliderURL = result[i].url;
		    		sliderIsUse = result[i].isUse;
		    		
		    		sliderHTML += "<li class = 'sliderList' id = 'sliderList'>";
		    		sliderHTML += "<div class = 'slider-header'>";
		    		sliderHTML += "</div>";
		    		sliderHTML += "<dt><span class='imagePage'><IMG src ="+sliderImagePath+" style='width:225px;height:210px'/></dt>";
		    		sliderHTML += "</span>";
		    		sliderHTML += "<div class = 'slider-content'>";
		    		sliderHTML += "<table class = 'sliderInfo'><tr><td class ='sliderInfoTD'>이름    |</td>";
		    		sliderHTML += "<td class ='sliderInfoTD'>"+sliderName+"</td></tr>"
		    		sliderHTML += "<tr><td class ='sliderURL'>URL   |</td>";
		    		sliderHTML += "<td class ='sliderInfoTD'>"+sliderURL+"</td></tr>"
		    		sliderHTML += "<tr><td class ='sliderRegDate'>등록일   |</td>";
		    		sliderHTML += "<td class ='sliderInfoTD'>"+sliderRegDate+"</td></tr>"
		    		
		    		if(sliderIsUse == 1){
		    			sliderHTML += "<tr><td class= 'slideIsUse' id='slideIsUse'><label class='switch'><input type='checkbox' id='toggleButton' checked='checked')' onchange='toggleButton(this)'><span class='slider round'></label></td>";
		    		}else {
		    			sliderHTML += "<tr><td class= 'slideIsUse' id='slideIsUse'><label class='switch'><input type='checkbox' id='toggleButton' onchange='toggleButton(this)'><span class='slider round'></label></td>";
		    		}
		    		
		    		sliderHTML += "</tr></table>";
		    		sliderHTML += "</div></li>";
		    		
		    	}
		    	
		    	sliderHTML += "<li class='addSlider' id='addSlider'><div style='margin-top:97px'><img src='/images/admin/admin_portlet_plus.png' ></img></div></li>";
		    	document.getElementById("sliderContainer").innerHTML = sliderHTML;
		    	document.getElementById("addSlider").onclick = btn_Select; 
		    	
		    	for (var i = 0; i < sliderCnt; i++) {
		    		var checkbox = document.getElementById("toggleButton");
		    		var choose = checkbox.checked;
		    		var sliderId = result[i].sliderID;
		    		var sliderIsUse = result[i].isUse;
		    		
		    		if(choose){
		    			$("#sliderList").find(".slider-header").css("background-color", "##edf7ff");
		    		} else{
		    			$("#sliderList").find(".slider-header").css("background-color", "#f4f4f4").css("border", "1px solid #e7e7e7").css("color", "#b1b1b1");
		    		}
		    		
		    		
		    		event_statuschange(choose, sliderId); 
		    	}
		    
		    }
		
		    function toggleButton(check){
		    	//버튼 클릭할 때(보류)
		    	console.log($(".sliderList").find(".slider-header"));
				$(".sliderList").find(".slider-header").each(function(){
					if(check.checked){
	 		    		$(this).css("background-color", "#2196f3");
	 		    	} else{
	 		    		$(this).css("background-color", "#f4f4f4").css("border", "1px solid #e7e7e7").css("color", "#b1b1b1");
	 		    	}
		    	})
	 		    	
		    }
		    
		     var tempid = "";
		    var _RowObject = null;
		    function event_click(obj) {
		        tempid = document.getElementById(obj).getAttribute("DATA1");
		        _RowObject = document.getElementById(obj);
		        MakeDescription(document.getElementById(obj).getAttribute("DATA2"));
		    }
		    
		    var selectimage_dialogArguments = new Array();
		    //슬라이더 이미지 추가
		    function btn_Select() {
		    	$(".addSlider").remove();
		    	
		    	var sliderHTML = "";
		    	sliderHTML += "<li class = 'sliderList' id = 'sliderList'>";
		    	sliderHTML += "<div class = 'slider-header-add' style='background-color:#f4f4f4;border:1px solid #e7e7e7;color:#b1b1b1'>";
		    	sliderHTML += "<a class = 'cancelNewSliderBtn'>";
		    	sliderHTML += "<span class ='addCancel'><img src='/images/close_xBtn.png'></span></a>";
		    	sliderHTML += "<a class= 'addNewSliderBttn'>";
		    	sliderHTML += "<span class='addCancel'><img src='/images/email/popup_icon.gif' ></span></a>";
		    	sliderHTML += "</div>";
		    	sliderHTML += "<div class = 'slider-content' style='width:225px; height:210px'>";
		    	sliderHTML += "<a class ='addImageBtn'>";
		    	sliderHTML += "<span class = 'addImage' onclick='addImage()'>이미지 선택</span></a>";
		    	sliderHTML += "</div>";
		    	sliderHTML += "<table class = 'sliderInfo'><tr><td class ='sliderInfoTDadd'>한글 |   ";
		    	sliderHTML += "<input class='sliderName' data1='displayname' type='text' maxlength='50'></td></tr>";
		    	sliderHTML += "<tr><td class ='sliderInfoTDadd'>영어 |   ";
		    	sliderHTML += "<input class='sliderName2' data2='displayname2' type='text' maxlength='50'></td></tr>";
		    	sliderHTML += "<tr><td class ='sliderInfoTDadd'>URL |   ";
		    	sliderHTML += "<input class='sliderURL' data3=Url' type='text' maxlength='50'></td></tr>";
		    	sliderHTML += "</table>"
		    	sliderHTML += "</li>";
		    	
		    	document.getElementById("sliderContainer").insertAdjacentHTML('beforeend', sliderHTML);
		    	
		    	$(".cancelNewSliderBtn").on("click", addCancel);
		        if (CrossYN()) {
		            selectimage_dialogArguments[1] = btn_Select_Complete;
		            var SelectImage = window.open("/admin/ezPersonal/selectImage.do", "SelectImage", GetOpenWindowfeature(410, 750));
		            try { SelectImage.focus(); } catch (e) {
		            }
		        }
		        else {
		            var url = "/admin/ezPersonal/selectImage.do";
		            var feature = "center:yes;status:no;dialogWidth:410px;dialogHeight:750px;edge:sunken;scroll:no" + GetShowModalPosition(410, 750);
		            feature = feature + GetShowModalPosition(410, 750);
		            window.showModalDialog(url, "", feature);
		            window.location.reload(false);
		        }
		    } 
		    //슬라이드 이미지 생성 취소
		    var addCancel = function() {
		    	getSliderList();
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
	
		    /* function MakeDescription(filepath) {
		        document.getElementById("ContentDescription").innerHTML = "<IMG src = '"+filepath+"' style='width:280px;height:515px' />";
		    } */
	
		    /* function Reload() {
		        window.location.reload(false);
		    } */
		    
		    /* function Priority_UP() {
		    	if (CrossYN()) {
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
		    	} else {
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
		    	}
		    } */
		    
		    /* function Priority_DOWN() {
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
		    } */
		    
		    /* function event_ChangePriority(A_itemid, A_priority, B_itemid, B_priority) {
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
		    } */
		    
		    /* function swapNodes(item1, item2) {
		        var itemtmp = item1.cloneNode(1);
		        var parent = item1.parentNode;
		        item2 = parent.replaceChild(itemtmp, item2);
		        item1.setAttribute("DATA5", item2.getAttribute("DATA5"));
		        item2.setAttribute("DATA5", itemtmp.getAttribute("DATA5"));
		        parent.replaceChild(item2, item1);
		        parent.replaceChild(item1, itemtmp);
		        itemtmp = null;
		    } */
	
		    function event_statuschange(check, sliderId) {
		       var isUse = "";
		         
		       if(check== true) {
			      isUse = '1';
			   } else {
			      isUse = '0';
			   } 
			    
			        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/statusChangeSlider.do",
		        	async : false,
		        	dataType : "text",
		        	data : {sliderID : sliderId, isUse : isUse, mode : "U"},
		        	success : function(result) {
		        		if (result != "OK") {
		        			alert(result);
		        		}
		        	}
		        });
		    } 
	
		    /* function event_dbclick(clickitem) {
		        if (CrossYN()) {
		            selectimage_dialogArguments[1] = btn_Select_Complete;
		            
		            var SelectImage = window.open("/admin/ezPersonal/selectImage.do?item=" + document.getElementById(clickitem).getAttribute("DATA1"), "SelectImage", GetOpenWindowfeature(410, 750));
		            try { SelectImage.focus(); } catch (e) {
		            }
		        }
		        else {
		            var url = "/admin/ezPersonal/selectImage.do?item=" + document.getElementById(clickitem).getAttribute("DATA1") + "";
		            var feature = "center:yes;status:no;dialogWidth:410px;dialogHeight:750px;edge:sunken;scroll:no" + GetShowModalPosition(410, 750);
		            feature = feature + GetShowModalPosition(410, 750);
	
		            window.showModalDialog(url, "", feature);
	
		            window.location.reload(false);
		        }
		    } */
		</script>
	</head>
	<body class = "mainbody">
		<h1><spring:message code = 'ezPersonal.t20004' /></h1>
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
	        	<%-- <li class="important"><span id ="NEW" onClick="btn_Select(this)"><spring:message code = 'ezPersonal.t105' /></span></li> --%>
				<%-- <li><span onclick="sliderdelete();"><spring:message code = 'ezPersonal.t99' /></span></li> --%>
				<%-- <li><span class="icon16 icon16_refresh" onclick="Reload();"></span></li>
				<li><span onclick="Priority_UP();"><img src="/images/ImgIcon/prev.gif"  style="margin-top:-2px;" alt="<spring:message code = 'ezPersonal.t366' />"/></span></li>
				<li><span onclick="Priority_DOWN();"><img src="/images/ImgIcon/next.gif"  style="margin-top:-2px;" alt="<spring:message code = 'ezPersonal.t367' />" /></span></li> --%>
			</ul>
	    </div>
	    <ul id="sliderContainer" class="sliderContainer">
	    
	    </ul>
	   
		<%-- <table style="width:750px;height:215px;">
	    	<tr>
	            <td>
	            <!-- 18-05-10 김민성 - 관리자 > 슬라이드 이미지 테이블 크기 수정 -->
	            	<div style="border:1px solid #dbdbda;width:560px;height:530px;border-top:0px;overflow-y:auto;overflow-x:hidden">
					<!-- <div style="border:1px solid #dbdbda;width:435px;height:215px;border-top:0px;overflow-y:auto;overflow-x:hidden"> -->
	                	<%--<div id="lvDocList"></div>
	                <table class="mainlist" style="width:100%;">
		                    <tr>
		                        <td style="width:8%;background-color:#f8f8f8;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;"><span><spring:message code = 'ezPersonal.t937' /></span></td>
		                        <td style="width:60%;background-color:#f8f8f8;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;"><span style="padding-left:10px;"><spring:message code = 'ezPersonal.t9' /></span></td>
		                        <td style="width:32%;background-color:#f8f8f8;text-align:center;border-bottom:2px solid #dbdbda;"><span><spring:message code = 'ezPersonal.t1024' /></span></td>
		                    </tr>
		                </table>
					</div>
	            </td>
	            <!-- <td style="vertical-align:top">
	            	<div style="border:1px solid #dbdbda;width:295px;height:530px;overflow-y:auto;margin:0px 5px 0px 5px;">
	                	<div id="ContentDescription" style="margin-top:1px;margin:5px 5px 5px 5px;">
	                	</div>
	            	</div>
	            </td> -->
	        </tr>
		</table> --%>
		<script>
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>		
	</body>
</html>