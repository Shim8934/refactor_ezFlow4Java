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
      <title>근태신청현황</title>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
      <link rel="stylesheet" type="text/css" href="/css/previewmail.css">
      <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
      <link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
      <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
      <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
      <script type="text/javascript" src="/js/mouseeffect.js"></script>
      <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
      <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
      <script type="text/javascript" src="/js/Common.js"></script>
      <!-- modal -->
      <script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
      <style>
      #contentlist table.mainlist td {
             overflow : hidden;
             white-space : nowrap;
             text-overflow : ellipsis;
             cursor : pointer;
       }
       tr.hover:hover {background:#eee; color:#fff;}
      .selectTR {background-color: rgb(233, 241, 255);}
      #searchTable {
         border-top: 1px solid #e8e8e8;
         border-left: 1px solid #e8e8e8;
         border-right: 1px solid #e8e8e8;
         background-color: #fcfcfc;
      }
      #searchTable td {padding: 8px 5px;}
      </style>
      <script type="text/javascript">
      var totalAtt         = ${totalAtt};
      var startDate        = "<c:out value='${startDate}'/>";
      var endDate         = "<c:out value='${endDate}'/>";
      var currentPage        = ${currentPage};        
      var totalPages         = ${totalPages};       
       var blockSize         = 10;
       var orderCell = ""; // 정렬 명
       var orderOption = ""; // 정렬 형식(ASC, DESC)
      var g_userLang         = "${userLang}";
      var g_timezone         = "${userTimeSet}";
      var offsetMin         = "${offsetMin}";
      var type            = "0";
      var m_strColorSelect = "#edf4fd";
      var m_strColorOver = "#f4f5f5";
      var m_strColorDefault = "#ffffff";
      var adminFlag = "${adminFlag}";
      var checkAdmin = "${checkAdmin}";
      var authFlag = "${authFlag}";
      var usepostDate = false;
      
      $(function(){
         $(document).on('click', '#AttList th', function(){
            if (!($(this).find("input[type=checkbox]").length) && ($(this).attr("colname") != "NO") ) { // checkbox는 sort에서 제외
               if (!$(this).find("img").length) { // 새로운 th를 클릭한 경우
                  src = "";
                  orderOption = "";
                  orderCell = $(this).attr("colname");
               }
            
                if (orderOption == "" || orderOption == "DESC") {
                   src = '/images/etc/view-sortup.gif';
                   orderOption = "ASC";
                } else {
                   src = '/images/etc/view-sortdown.gif';
                   orderOption = "DESC";
                }
                $("#AttList th").find("img").remove();
                $(this).append("<img src='" + src + "' align='absmiddle'/>");
                
                get_att_list();
            }
         })

         if (checkAdmin == 'true') {
            authFlag = 'M';
         }
         if (authFlag == 'M') {
            
         } else {
            if (adminFlag == "true"){
               $("#appr").hide();
               $("#ret").hide();
            }
         }
      })
      
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
           console.log("${startDate}");
           console.log("${endDate}");
         if (checkAdmin == 'true') {
            $("#Sdatepicker").val("${startDate}");
             $("#Edatepicker").val("${endDate}");
             usepostDate = true;
         }
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
         if (checkAdmin == "true") {
            var infoStr = ' [총 <span style="color:#017BEC;">' + totalAtt;
             
             infoStr += '</span> 개 - ';
             infoStr += startDate.substring(0,4) + '년' + 
             startDate.substring(5,7) + '월' + 
             startDate.substring(8,10) + '일~';
             infoStr += endDate.substring(0,4) + '년' + 
             endDate.substring(5,7) + '월' + 
             endDate.substring(8,10) + '일]</span>';
             
             $("#mailBoxInfo").html(infoStr);
         }
         
         var obj = $("#search").offset();
         
         $("#layer_popup").css({
               "position" : "absolute",
               "top" : obj.top + $("#search").height(),
               "left" : obj.left
            });
         if (checkAdmin != "true") {
            $("#Sdatepicker").datepicker('disable');
              $("#Edatepicker").datepicker('disable');   
         }
      }
      function makePageSelPage(){
           var strtext;
           var PagingHTML = "";
           document.getElementById("tblPageRayer").innerHTML = "";
           document.getElementById("mailBoxInfo").innerHTML = " [" + "총"  + "<span style='color:#017BEC;'> " + totalAtt + " </span>" + "개]";
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
//           date_reset();
       }
       
       function att_search(r) {
//           popup_close();
         if (r == "refresh") {
            $("#writer_search").val("");
             $("#writerDept_search").val("");
             $("#appr_search").val("");
             if (usepostDate) {
                DateSearch_Click();
                $(usepostdate).prop("checked", false);
             }
//              $("#Radio2").prop("checked", true);
//              type = "0";
         }
         goToPageByNum("1");
       }
       
       function att_refresh() {
          get_att_list(currentPage);
       }
       
       function get_att_list(pageNum) {
          ShowAttProgress();
          
          $("#HeaderAllCheckBox").prop("checked",false);
          
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
          if (adminFlag == 'true') {
             if (checkAdmin == 'true') {
                obj.writerDeptName = writerDept_search.value;
             } else {
                obj.writerDeptId = writerDept_search.value;
                obj.writerDeptName = $("#writerDept_search option:selected").text();   
             }
             obj.writerName = $('#writer_search').val();
          }
          obj.startDate = startDate;
          obj.endDate = endDate;
         obj.pageNum = pageNum;
         obj.totalPages = totalPages;
         obj.totalAtt = totalAtt;
         obj.type = type;
         obj.orderCell = orderCell;
         obj.orderOption = orderOption;
         obj.adminFlag = adminFlag;
         obj.checkAdmin = checkAdmin;
         
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
          if (adminFlag == 'true') {
             if (checkAdmin == 'true') {
                obj.writerDeptName = writerDept_search.value;
             } else {
                obj.writerDeptId = writerDept_search.value;
                obj.writerDeptName = $("#writerDept_search option:selected").text();   
             }
             obj.writerName = $('#writer_search').val();
          }
          obj.startDate = startDate;
          obj.endDate = endDate;
         obj.totalPages = totalPages;
         obj.totalAtt = totalAtt;
         obj.type = type;
         obj.orderCell = orderCell;
         obj.orderOption = orderOption;
         obj.excelReq = "true";
         obj.adminFlag = adminFlag;
         obj.checkAdmin = checkAdmin;
          
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
             if (adminFlag == "true"){
                authFlag = data.authFlag;
                
                if(checkAdmin == 'true') {
                   authFlag = 'M'; 
                }
                
                if (authFlag == 'M') {
                  $("#appr").show();
                  $("#ret").show();
               } else {
                  $("#appr").hide();
                  $("#ret").hide();
               }
             }   
             
             totalAtt = data.totalAtt;
             totalPages = data.totalPages;
             makePageSelPage();
             
             infoStr += ' [총 <span style="color:#017BEC;">' + data.totalAtt;
             
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
          
          if (excel != true) {
             if (attList.length == 0) {
                if (adminFlag != "true") {
                   $('#AttList tbody').append('<tr><td colspan="7" align="center"  bgcolor="#FFFFFF">등록된 신청내역이 없습니다.</td></tr>');
                } else {
                   $('#AttList tbody').append('<tr><td colspan="9" align="center"  bgcolor="#FFFFFF">등록된 신청내역이 없습니다.</td></tr>');   
                }
             }
          }
          
          for (var i = 0 ; i < attList.length; i ++) {
             var htmlStr = "";
             htmlStr += '<tr id="attList_' + (i+1) + '" class="white" onclick="event_listclick(this, event)" ondblclick="mod_detail(this)" draggable="true" style="cursor:pointer;">';
             if (excel == true) {
             } else {
                htmlStr += '<td style="padding:0"> <input type="checkbox" class="checkAtt"' 
                 htmlStr += 'id="attCheck_' + attList[i].attitudeId + '_' + attList[i].applCnt +'"';
                 htmlStr += 'value="' + attList[i].attitudeId + '_' + attList[i].applCnt +'"';
                 htmlStr += 'status="' + attList[i].apprStatus + '"';
                 htmlStr += ' onclick="event_listCheckboxclick(this)"/></td>';   
             }
             htmlStr += '<td>' + (parseInt(i) + 1 + (parseInt(currentPage)-1) * 15) + '</td>';
             htmlStr += '<td>' + attList[i].originDate.substring(0,10) + '</td>';
             
             if (adminFlag == 'true') {
                htmlStr += '<td>' + attList[i].writerName + '</td>';
                htmlStr += '<td>' + attList[i].writerDeptName + '</td>';
             }
             
             htmlStr += '<td>' + attList[i].originDate.substring(11,19) + ' -> ' + attList[i].changeDate.substring(11,19) + '</td>';
             
             if (attList[i].apprStatus == 0) {
                htmlStr += '<td id="attStauts">신청</td>';   
             }
             if (attList[i].apprStatus == 1) {
                htmlStr += '<td id="attStauts">승인</td>';   
             }
             if (attList[i].apprStatus == 2) {
                htmlStr += '<td id="attStauts">반려</td>';   
             }
             if (attList[i].apprUserName == null) {
                htmlStr += '<td>' + "" + '</td>';
             } else {
                htmlStr += '<td>' + attList[i].apprUserName + '</td>';   
             }
             
             if  (excel != true) {
                htmlStr += '<td><a class="imgbtn" id="mailInBtn" onclick="getHistory(this)"><span>내역확인</span></a></td>';   
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
           
           if(!usepostDate){
               $("#Sdatepicker").datepicker('disable');
               $("#Edatepicker").datepicker('disable');
           }
           else {
               $("#Sdatepicker").datepicker('enable');
               $("#Edatepicker").datepicker('enable');
           }
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
       
       function type_set(){
          type = $("input:radio[name=searchCheck]:checked").val();
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
          
          if (attList.length == 0) {
             alert("삭제할 수정신청을 선택해주세요");
             return;
          }
          
          for (var i = 0; i < attList.length; i++) {
             idList += attList[i].getAttribute("id").split("_")[1] + ","
          }
          
          var obj = new Object();
          
          obj.idList = idList.slice(0,-1);
         
          if (confirm("정말로 삭제하시겠습니까?")) {
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
                   if (json == "error") {
                      alert("이미 처리된 항목입니다.");                      
                   } else {
                      alert("삭제되었습니다.");   
                   }
                },
               complete : function() {
                  HiddenAttProgress();
               }
             });
          } else {
             HiddenAttProgress();
          }
       }
       
      //승인
       function modApprove() {
         if (authFlag != "M") {
            alert("권한이 없습니다. 관리자에게 문의하세요");
            return;
         }
          Show