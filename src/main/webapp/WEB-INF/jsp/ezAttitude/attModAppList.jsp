<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
		<title>mail_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<link rel="stylesheet" type="text/css" href="/css/previewmail.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>		
		<script type="text/javascript">
		var totalAtt 		  = ${totalAtt};
		var startDate		  = "<c:out value='${startDate}'/>";
		var endDate 		  = "<c:out value='${endDate}'/>";
		var currentPage		  = ${currentPage};  		
		var totalPages 		  = ${totalPages}; 		
	    var blockSize 		  = 10;
		var g_userLang 		  = "${userLang}";
		var g_timezone 		  = "${userTimeSet}";
		var offsetMin 		  = "${offsetMin}";
		var type 			  = "all";
		var m_strColorSelect = "#edf4fd";
		var m_strColorOver = "#f4f5f5";
		var m_strColorDefault = "#ffffff";
		
		$(function () {
	        $("#Sdatepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	        $("#Edatepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	        var NowDate = utcDate2(offsetMin);
	        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Sdatepicker").datepicker('setDate', NowDate);
	        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Edatepicker").datepicker('setDate', NowDate);
	    });
	    
	    $(function () {
	        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
	            closeText: "<spring:message code='main.t3' />",
	            prevText: "<spring:message code='main.t0604' />",
	            nextText: "<spring:message code='main.t0605' />",
	            currentText: "<spring:message code='main.t0606' />",
	            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
	                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
	                       "<spring:message code='main.t0627' />"],
	            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                       "<spring:message code='main.t0627' />"],
	            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
		                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
		                       "<spring:message code='main.t0627' />"],
	            weekHeader: "Wk",
	            dateFormat: "yy-mm-dd",
	            firstDay: 0,
	            isRTL: false,
	            duration: 200,
	            showAnim: "show",
	            showMonthAfterYear: true
	        };
	        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
	    });

	    $(function() {
	    	makePageSelPage();
	    });
	    
		window.onload = function() {
			var obj = $("#search").offset();
			
			$("#layer_popup").css({
				   "position" : "absolute",
				   "top" : obj.top + $("#search").height(),
				   "left" : obj.left
				});
			
			$("#Sdatepicker").datepicker('disable');
	        $("#Edatepicker").datepicker('disable');
		}
		function makePageSelPage(){
	        var strtext;
	        var PagingHTML = "";
	        document.getElementById("tblPageRayer").innerHTML = "";
	        document.getElementById("mailBoxInfo").innerHTML = " - [" + "총"  + "<span style='color:#017BEC;'> " + totalAtt + " </span>" + "개]";
	        strtext = "<div class='pagenavi'>";
	        PagingHTML += strtext;
	        var pageNum = currentPage;
	        
	        if (totalPages > 1 && pageNum != 1) {
	            strtext = "<span class='btnimg' onClick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
	            PagingHTML += strtext;
	        }
	        else {
	            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
	            PagingHTML += strtext;
	        }
	        
	        if (totalPages > blockSize) {
	            if (pageNum > blockSize) {
	                strtext = "<span class='btnimg' onClick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + "이전" + "</span>";
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + "이전" + "</span>";
	                PagingHTML += strtext;
	            }
	        }
	        else {
	            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + "이전" + "</span>";
	            PagingHTML += strtext;
	        }
	        
	        var MaxNum;
	        var i;
	        var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1;

	        if (totalPages >= (startNum + parseInt(blockSize))) {
	            MaxNum = (startNum + parseInt(blockSize)) - 1;
	        }
	        else {
	            MaxNum = totalPages;
	        }

	        for (i = startNum; i <= MaxNum; i++) {
	            if (i == pageNum) {
	                strtext = "<span class='on'>" + i + "</span>";
	                PagingHTML += strtext;
	            }
	            else {
					strtext = "<span onClick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                PagingHTML += strtext;
	            }
	        }
	        
	        if (totalPages > blockSize) {
	        	if (totalPages >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
	        	    strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>" + "다음" + "</span>";
	        	    strtext = strtext + "<span class='btnimg' onClick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	        	}
	        	else {
	                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "다음" + "</span>";
	                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	        	}
	        }
	        else {
	            strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>" + "다음" + "</span>";
	            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	            PagingHTML += strtext;
	        }
	        
	        if (totalPages > 1 && totalPages != 1 && (totalPages != pageNum)) {
	            strtext = "<span class='btnimg' onClick='return goToPageByNum(" + totalPages + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
	            PagingHTML += strtext;
	        }
	        else {
	            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
	            PagingHTML += strtext;
	        }
	        
	        PagingHTML += "</div>";
	        td_Create1(PagingHTML);
	    }
	
	    function td_Create1(strtext) {
	        document.getElementById("tblPageRayer").innerHTML = strtext;
	    }
	    
	    function search_popup() {
	    	if ($("#layer_popup").css("display") == "none") {
	       		$("#layer_popup").css("display","block");
	       	} else {	
	       		$("#layer_popup").css("display","none");
	    	}
	    }
	    
	    function popup_close() {
	    	$("#layer_popup").css("display","none");
// 	    	date_reset();
	    }
	    
	    function att_search() {
// 	    	popup_close();
			get_att_list();
	    }
	    
	    function att_refresh() {
	    	get_att_list(currentPage);
	    }
	    
	    function get_att_list(pageNum) {
	    	ShowAttProgress();
	    	
	    	if (usepostDate) {
	            var startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        var endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

	            if (startDate > endDate) {
	                alert("시작일 보다 종료일이 빠를 수 없습니다.");
	                return;
	            }
	        }
	    	var obj = new Object();
	    	
		    obj.apprUserName = $('#appr_search').val();
		    obj.startDate = startDate;
		    obj.endDate = endDate;
			obj.pageNum = pageNum;
			obj.totalPages = totalPages;
			obj.totalAtt = totalAtt;
			obj.type = type;
			
		    $.ajax({
				type : 'get',
			    url : '/ezAttitude/getAttModAppList.do',
			    data : obj,
			    dataType : "json",
			    error: function(xhr, status, error){
			    	ajaxRunning = false;
			    },
			    success : function(json){
			    	getAttList_after(json);
			    },
				complete : function() {
					HiddenAttProgress();
				}
		    });
	    }
	    
	    function get_excelAtt_list() {
	    	ShowAttProgress();
	    	
	    	if (usepostDate) {
	            var startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        var endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

	            if (startDate > endDate) {
	                alert("시작일 보다 종료일이 빠를 수 없습니다.");
	                return;
	            }
	        }
	    	var obj = new Object();
	    	
		    obj.apprUserName = $('#appr_search').val();
		    obj.startDate = startDate;
		    obj.endDate = endDate;
		    obj.excelReq = "true";
			
		    $.ajax({
				type : 'get',
			    url : '/ezAttitude/getAttModAppList.do',
			    data : obj,
			    dataType : "json",
			    error: function(xhr, status, error){
			    	ajaxRunning = false;
			    },
			    success : function(json){
			    	getAttList_after(json, true);
			    },
				complete : function() {
					HiddenAttProgress();
				}
		    });
	    }
	    
	    function getAttList_after(data, excel) {
	    	var attList = data.list;
	    	var infoStr = "";
	    	listContentArry = new Array();
	    	
	    	if (excel == true) {
	    		$('#ExcelAttList tbody').children( 'tr:not(:first)' ).remove();
	    	} else {
	    		totalAtt = data.totalAtt;
		    	totalPages = data.totalPages;
		    	makePageSelPage();
		    	
		    	infoStr += ' - [총 <span style="color:#017BEC;">' + data.totalAtt;
		    	
		    	if (data.startDate != null && data.endDate != null) {
		    		infoStr += '</span> 개 - ';
		    		infoStr += data.startDate.substring(0,4) + '년' + 
			    	data.startDate.substring(5,7) + '월' + 
			    	data.startDate.substring(8,10) + '일~';
			    	infoStr += data.endDate.substring(0,4) + '년' + 
			    	data.endDate.substring(5,7) + '월' + 
			    	data.endDate.substring(8,10) + '일]</span>';
		    	} else {
		    		infoStr += '</span> 개]';
		    	}
		    	
		    	$("#mailBoxInfo").html(infoStr);
		    	$('#AttList tbody').children( 'tr:not(:first)' ).remove();
	    	}
	    	
	    	if (attList.length == 0) { 
	    		$('#AttList tbody').append('<tr><td colspan="7" align="center"  bgcolor="#FFFFFF">등록된 신청내역이 없습니다.</td></tr>');
	    	}
	    	for (var i = 0 ; i < attList.length; i ++) {
	    		var htmlStr = "";
	    		htmlStr += '<tr id="attList_' + (i+1) + '" class="white" onclick="event_listclick(this, event)" ondblclick="mod_detail(this)" draggable="true" style="cursor:pointer;">';
	    		if (excel == true) {
	    		} else {
	    			htmlStr += '<td style="padding:0"> <input type="checkbox" class="checkAtt"' 
	    	    	htmlStr += 'id="attCheck_' + attList[i].attitudeId + '"';
	    	    	htmlStr += 'value=' + attList[i].attitudeId ;
	    	    	htmlStr += ' onclick="event_listCheckboxclick(this)"/></td>';	
	    		}
    			htmlStr += '<td>' + (parseInt(i) + 1) + '</td>';
    			htmlStr += '<td>' + attList[i].changeDate.substring(0,10) + '</td>';
    			htmlStr += '<td>' + attList[i].apprUserName + '</td>';
    			htmlStr += '<td>' + attList[i].originDate.substring(0,19) + '</td>';
    			htmlStr += '<td>' + attList[i].changeDate.substring(11,19) + '</td>';
    			
    			if (attList[i].apprStatus == 0) {
    				htmlStr += '<td>진행</td>';	
    			}
    			if (attList[i].apprStatus == 1) {
    				htmlStr += '<td>승인</td>';	
    			}
    			if (attList[i].apprStatus == 2) {
    				htmlStr += '<td>반려</td>';	
    			}
    			
    			htmlStr += '</tr>';
    			if  (excel == true) {
    				$('#ExcelAttList tbody').append(htmlStr);
    				btnexportexcel_onclick();
    			} else {
    				$('#AttList tbody').append(htmlStr);
    			}
	    	}
	    }
	    function date_reset() {
	    	$("#Sdatepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	        $("#Edatepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	        var NowDate = utcDate2(offsetMin);
	        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Sdatepicker").datepicker('setDate', NowDate);
	        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Edatepicker").datepicker('setDate', NowDate);
	    }
	    
	    function search_keypress(evt)
		{	
	        var curevent = (typeof event == 'undefined' ? evt : event)
	        if (curevent.keyCode == "13") {
	        	att_search();
	        }
		}
	    
	    function ShowAttProgress() {
	        document.getElementById("attPanel").style.display = "";
	        document.getElementById("AttProgress").style.top = "300px";
	        document.getElementById("AttProgress").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";
	        document.getElementById("AttProgress").style.display = "";
	    }
	    
	    function HiddenAttProgress() {
	        document.getElementById("attPanel").style.display = "none";
	        document.getElementById("AttProgress").style.display = "none";
	    }
	    
	    function goToPageByNum(Value){
	    	currentPage = Value;
	        makePageSelPage();
	        get_att_list(currentPage);
	    }
	    
	    function selbeforeBlock(){
	        var pageNum = parseInt(currentPage);
	        pageNum = ((parseInt(pageNum / blockSize) - 1) * blockSize) + 1;
	        get_att_list(pageNum);
	    }
	    
	    function selbeforeBlock_one(){
	        var pageNum = parseInt(currentPage);
	        if(parseInt(pageNum - 1) > 0)
	            goToPageByNum(parseInt(pageNum - 1));
	        else
	            return;
	    }
	    
	    function selafterBlock(){
	        var pageNum = parseInt(currentPage);
	        pageNum = ((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1;
	        goToPageByNum(pageNum);
	    }
	    
	    function selafterBlock_one(){
	        var pageNum = parseInt(currentPage);
	        if(parseInt(pageNum + 1) <= totalPages)
	            goToPageByNum(parseInt(pageNum + 1));
	        else
	            return;
	    }
	    
	    var usepostDate = false;
	    function DateSearch_Click() {
	        if(usepostDate){
	            usepostDate = false;
	            $("#Sdatepicker").datepicker('disable');
	            $("#Edatepicker").datepicker('disable');
	        }
	        else {
	            usepostDate = true;
	            $("#Sdatepicker").datepicker('enable');
	            $("#Edatepicker").datepicker('enable');
	        }
	    }
	    
	    function btnexportexcel_onclick() {
            document.getElementById("saveExcelData").value = $("#ExcelAttList")[0].outerHTML;
            document.getElementById("formAgent").target = "saveExcel";
            document.getElementById("formAgent").submit();
        }
	    
	    function type_change(){
	    	type = $("input:radio[name=searchCheck]:checked").val();
	    	get_att_list();
	    }
	    
	    var PressShiftKey = false;
	    var PressCtrlKey = false;
	    function event_listOnkeyUp(event) {
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            if (!event) event = window.event;
	        }

	        switch (event.keyCode) {
	            case 16: PressShiftKey = false; break;
	            case 17: PressCtrlKey = false; break;
	            case 46:
	                if (event.shiftKey) {
	                    PressShiftKey = false;
	                }
	                else {
	                }
	                break;
	        }

	    }
	    function event_listOnkeyDown(event) {
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            if (!event) event = window.event;
	        }
	        switch (event.keyCode) {
	            case 16: PressShiftKey = true; break;
	            case 17: PressCtrlKey = true; break;
	        }
	    }
	    
	    var listContentArry = new Array();
	    var listSubContentArry = new Array();
	    var listEventCheckbox = false;
	    var listSubEventCheckbox = false;

	    function event_listclick(obj, event) {
	    	if (obj.tagName == "TD") {
	            obj = obj.parentElement;
	        }

	        if (!listEventCheckbox) {
	            if (document.getElementById("HeaderAllCheckBox").checked) {
	                var TemplistArray = new Array();
	                if (obj.getElementsByTagName("td").item(0).childNodes.item(0).checked) {
	                    for (var i = 0; i < listContentArry.length; i++) {
	                        if (obj.getAttribute("id") == listContentArry[i]) {
	                            obj.childNodes.item(0).childNodes.item(0).checked = false;
	                            obj.style.backgroundColor = m_strColorDefault;
	                        }
	                        else {
	                            TemplistArray[TemplistArray.length] = listContentArry[i];
	                        }
	                    }
	                    listContentArry = TemplistArray;
	                }
	                else {
	                    obj.childNodes.item(0).childNodes.item(0).checked = true;
	                    obj.style.backgroundColor = m_strColorSelect;
	                    listContentArry[listContentArry.length] = obj.getAttribute("id");
	                }
	            }
	            else {
	                if (!event.shiftKey && !event.ctrlKey && listContentArry.length > 0) {
	                	
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        _RowObject = document.getElementById(listContentArry[Cnt]);
							_RowObject.style.backgroundColor = m_strColorDefault;
	                        _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	                    }
	                    listContentArry = new Array();
	                }
	                if (event.shiftKey) {
	                    var SelectedPreObj = null;
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        _RowObject = document.getElementById(listContentArry[Cnt]);
	                        if (Cnt == 0){
	                            SelectedPreObj = _RowObject;	
	                        }
	                        console.log(_RowObject);
	                        _RowObject.style.backgroundColor = m_strColorDefault;
	                        _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	                    }
	                    listContentArry = new Array();
	                    _RowObject = obj;
	                    var PrelistContent;
	                    if (SelectedPreObj == null)
	                        PrelistContent = _RowObject.getAttribute("id");
	                    else
	                        PrelistContent = SelectedPreObj.getAttribute("id");
	                    var CurlistContent = obj.getAttribute("id");
	                    var PrePoint = parseInt(PrelistContent.replace("attList_", ""));
	                    var CurPoint = parseInt(CurlistContent.replace("attList_", ""));

	                    if (PrePoint < CurPoint) {
	                        for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
	                            _RowObject = document.getElementById("attList_" + Cnt);
	                            _RowObject.style.backgroundColor = m_strColorSelect;
	                            _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	                            listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
	                        }

	                    }
	                    else if (PrePoint > CurPoint) {
	                        for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
	                            _RowObject = document.getElementById("attList_" + Cnt);
	                            _RowObject.style.backgroundColor = m_strColorSelect;
	                            _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	                            listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
	                        }
	                    }
	                    else if (PrePoint == CurPoint) {
	                        if (_RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked) {
	                            _RowObject.style.backgroundColor = m_strColorDefault;
	                            _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	                            listContentArry = ArrayDelete(listContentArry, _RowObject.id);
	                        }
	                        else {
	                            _RowObject.style.backgroundColor = m_strColorSelect;
	                            _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	                            listContentArry[listContentArry.length] = GetAttribute(_RowObject, "id");
	                        }
	                    }
	                    else
	                        return;
	                }
	                else {
	                	
	                    _RowObject = obj;
	                    
	                    if (_RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked) {
	                    	
	                        _RowObject.style.backgroundColor = m_strColorDefault;
	                        _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	                        listContentArry = ArrayDelete(listContentArry, _RowObject.id);
	                    }
	                    else {
	                    	
	                        _RowObject.style.backgroundColor = m_strColorSelect;
	                        _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
	                    }
	                }
	            }
	        }
	        else
	            listEventCheckbox = false;
	    }
	    
	    function attList_del() {
	    	ShowAttProgress();
	    	
	    	var attList = $(".checkAtt:checked");
	    	var idList = "";
	    	
	    	for (var i = 0; i < attList.length; i++) {
	    		idList += attList[i].getAttribute("id").split("_")[1] + ","
	    	}
	    	
	    	var obj = new Object();
	    	
		    obj.idList = idList.slice(0,-1);
			
		    $.ajax({
				type : 'post',
			    url : '/ezAttitude/delAttModApp.do',
			    data : obj,
			    dataType : "text",
			    error: function(xhr, status, error){
			    	ajaxRunning = false;
			    	alert("삭제 중 오류 발생")
			    },
			    success : function(json){
			    	get_att_list(currentPage);
					alert("삭제되었습니다.");
			    },
				complete : function() {
					HiddenAttProgress();
				}
		    });
	    }
	    
	    function ArrayDelete(TargetArray, DeleteNodeStr) {
	        var TempArray = new Array();
	        for (var i = 0; i < TargetArray.length; i++) {
	            if (TargetArray[i] != DeleteNodeStr)
	                TempArray[TempArray.length] = TargetArray[i];
	        }
	        TargetArray = TempArray;
	        return TargetArray;
	    }
	    
	    function event_HeaderCheckBoxClick(obj) {
	    	// tr 노드들 (메일 리스트의 전체 행)
			var attNodes = $('#AttList tbody').children( 'tr:not(:first)' );
	    	
	    	// tr 노드 (하나의 행)
	    	var attNode;
	    	// tr 노드 개수
	    	var nodeCount = attNodes.length;
	    	
	        if (obj.checked) {
	        	
	            for (var i = 0; i < nodeCount; i++) {
	            	attNode = attNodes.get(i);
	            	attNode.getElementsByTagName("td").item(0).childNodes.item(0).checked = true;
	            	attNode.style.backgroundColor = m_strColorSelect;
	                //TODO: 테스트해보기 2016-06-02
	                // dhlee: modified so that existing elements aren't merged with new ones.
	                //listContentArry[listContentArry.length] = document.getElementById("MailList").childNodes.item(i).getAttribute("id");
	                listContentArry[i] = attNode.getAttribute("id");
	            }
	        } else {
	        	
	            for (var i = 0; i < nodeCount; i++) {
	            	attNode = attNodes.get(i);
	            	
	            	attNode.getElementsByTagName("td").item(0).childNodes.item(0).checked = false;
	            	attNode.style.backgroundColor = m_strColorDefault;
	            }
	            
	            listContentArry = new Array();
	        }
	    }
	    
	    function event_listCheckboxclick(obj) {
	        if (obj.checked) {
	            for (var RowCnt = 0; RowCnt < obj.parentElement.parentElement.getElementsByTagName("td").length; RowCnt++) {
	                obj.parentElement.parentElement.getElementsByTagName("td").item(RowCnt).style.backgroundColor = m_strColorSelect;
	            }
	            console.log(obj.parentElement.parentElement.getAttribute("id"));
	            listContentArry[listContentArry.length] = obj.parentElement.parentElement.getAttribute("id");
	        }
	        else {
	            var TemplistArray = new Array();
	            for (var i = 0; i < listContentArry.length; i++) {
	            	console.log(obj.parentElement.parentElement.getAttribute("id"));
	                if (obj.parentElement.parentElement.getAttribute("id") == listContentArry[i]) {
	                    for (var RowCnt = 0; RowCnt < obj.parentElement.parentElement.getElementsByTagName("td").length; RowCnt++) {
	                        obj.parentElement.parentElement.getElementsByTagName("td").item(RowCnt).style.backgroundColor = m_strColorDefault;
	                    }
	                }
	                else {
	                    TemplistArray[TemplistArray.length] = listContentArry[i];
	                }
	            }
	            listContentArry = TemplistArray;
	        }
	        listEventCheckbox = true;
	    }
	    
	    function mod_detail(t) {
	    	var pheight = window.screen.availHeight;
	        var pwidth = window.screen.availWidth;
	        var pTop = (pheight - 760) / 2;
	        var pLeft = (pwidth - 790) / 2;
			var feature = GetOpenPosition(790, 760);
			var tds =  t.getElementsByTagName("td");
			var modAttId;
			console.log(feature);
			modAttId = tds[0].getElementsByTagName("input").item(0).getAttribute("value");
			
			window.open("/ezAttitude/attModAppDetail.do?attModId=" + modAttId, "",
		 			"height = 830px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	    }
		</script>
</head>
	<body style="overflow:hidden;" id="theBody" class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);">
		<h1>근태수정현황<span id="mailBoxInfo">-신청관리현황[총 xxx개-xxxx년 xx월 xx일~xxxx년 xx월 xx일]</span>
	    </h1>	
        <div id="mainmenu">
        <ul id="tb_Parent">
          <li><span onClick="attList_del()">삭제</span></li>
          <li id="reply"><span onClick="get_excelAtt_list()">엑셀 다운로드</span></li>
          <li id="search"><span onClick="search_popup()">검색</span></li>
		  <li id="right">
			  <span style="float:right;font-weight:normal;color:black;border: none;">
		          <input name="searchCheck" id="Radio1" type="radio" value="all" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="type_change()"/><label for="Radio1">&nbsp;전체</label>
		          <input name="searchCheck" id="Radio2" type="radio" value="0" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="type_change()"/><label for="Radio2">&nbsp;진행</label>
		          <input name="searchCheck" id="Radio3" type="radio" value="1" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="type_change()"/><label for="Radio3">&nbsp;승인</label>
		          <input name="searchCheck" id="Radio4" type="radio" value="2" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="type_change()"/><label for="Radio4">&nbsp;반려</label>
		  </li> 
        </ul>
        </div>
        <div id="layer_popup" style="width:400px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
          <div class="popupwrap1" style="background-color:#ffffff; position: relative;">
            <div class="popupwrap2">
              <table style="width:100%;border-spacing:0px;border-collapse:collapse;border:none;"  class="content">
              	  <tr>
                    <th nowrap>승인자명</th>
                    <td style="width:100%;"> 
						<input id="appr_search" class="input_text" type="text" onkeydown="" onkeyup="search_keypress(event);"/>
	                </td>
                  </tr>
                  <tr>
                    <th>변경일자기간</th>
                    <td>
                    	<input type="checkbox" value="1" id="usepostdate" onclick="DateSearch_Click()"><label for="usepostdate">검색기간 사용</label>
                    	<input type="text" id="Sdatepicker" style="width:80px;text-align:center;"/> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center;"/>
	                </td>
                  </tr>
              </table>
              <div class="btnposition">
		        <a class="imgbtn" id="mailInBtn" onclick="date_reset()"><span>날짜초기화</span></a>
		        <a class="imgbtn" id="cancelBtn" onclick="att_search()"><span>검색</span></a>
		        <a class="imgbtn" id="cancelBtn" onclick="popup_close()"><span>취소</span></a>
		      </div>
            </div>
          </div>
        </div>
        <span id="MailListRayer" style="border:0px solid blue;width:500px;height:100%;vertical-align:top;overflow:hidden;" > 
            <div id="contentlist" name="contentlist" style="border:0px solid blue;height:550px;width:100%;overflow-y:auto;" onblur>
                <table class="mainlist" style="width:100%;" id="AttList" listpageCount="${mailGeneral.listCount}" curPage="1">
                	<tr> 
						<th width="20px" align="center"> <%-- <spring:message code="ezPoll.t105"/> --%>
							<input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;" onchange="javascript:event_HeaderCheckBoxClick(this)"/>
						</th> 
						<th width="60px">NO.</th> 
						<th>변경일자</th> 					
						<th width="150px">승인자</th> 
						<th width="180px">출근시각</th>
						<th width="180px">변경시각</th> 
						<th width="80px">승인상태</th> 
<%-- 						<th width="60px"><spring:message code="ezPoll.t109"/></th>			 --%>
			    	</tr>
			    	
			    	<c:forEach var="list" items="${list}" varStatus="i"> 
				        <tr id = "attList_${i.count}" class="white" draggable="true" onclick="event_listclick(this, event)" ondblclick="mod_detail(this)" style="cursor:pointer;">
							<td style="padding:0"><input type="checkbox" class="checkAtt" id="attCheck_<c:out value ="${list.attitudeId}"/>" value=<c:out value="${list.attitudeId}" /> onclick="event_listCheckboxclick(this)"/></td>
				          	<td>${i.count}</td>
				          	<c:set var="changeDate" value="${list.changeDate}"/>
				          	<c:set var="originDate" value="${list.originDate}"/>
							<td>${fn:substring(changeDate,0,10) }</td>
							<td>${list.apprUserName}</td>
							<td>${fn:substring(originDate,0,19) }</td>
							<td>${fn:substring(changeDate,11,19) }</td>
							<c:if test="${list.apprStatus == 0}">
				          		<td>진행</td>	
				          	</c:if>
				          	<c:if test="${list.apprStatus == 1}">
				          		<td>승인</td>	
				          	</c:if>
				          	<c:if test="${list.apprStatus == 2}">
				          		<td>반려</td>	
				          	</c:if>
	<%-- 		          		<c:choose> --%>
	<%-- 							<c:when test="${primary == '1'}"> --%>
	<%-- 								<td> <a id="test<c:out value ="${list.qstId}" />" style="cursor:pointer" onClick="menuQst_DetailUserInfo('${list.creator}')"> ${list.creatorName1} </a> </td> --%>
	<%-- 							</c:when> --%>
	<%-- 							<c:otherwise> --%>
	<%-- 								<td> <a id="test<c:out value ="${list.qstId}" />" style="cursor:pointer" onClick="menuQst_DetailUserInfo('${list.creator}')"> ${list.creatorName2} </a> </td> --%>
	<%-- 							</c:otherwise> --%>
	<%-- 						</c:choose>	 --%>
				        </tr>
		        </c:forEach>
		        
			    <c:if test="${list.size() == 0}"> 
			        <tr> 
						<td colspan="7" align="center"  bgcolor="#FFFFFF">등록된 신청내역이 없습니다.</td>
		       		</tr> 
		        </c:if> 
                </table>
            </div>
            <div id="tblPageRayer"  style="width:470px; margin:6px auto;"></div>
        </span>
        <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="attPanel" onclick="ContextMenuHidden();" ></div>
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="AttProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<div id ="forExcel">
		</div>
        <table class="mainlist" style="width:100%;display:none;" id="ExcelAttList">
        	<tr>
				<th width="60px">NO.</th>
				<th>변경일자</th>
				<th width="150px">승인자</th>
				<th width="180px">출근시각</th>
				<th width="180px">변경시각</th>
				<th width="80px">승인상태</th>
			</tr>
		</table>
		
		<form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezAttitude/getXlsAtt.do">
	        <input type="hidden" id="saveExcelData" name="saveExcelData" value=""/>
	        <input type="hidden" id="userAgent" name="userAgent" value=""/>
	    </form>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	</body>
</html>