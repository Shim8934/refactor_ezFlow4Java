<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="/css/default.css" type="text/css">
    <link rel="stylesheet" href="/css/fileExtension.css" type="text/css">
    <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
    <script type="text/javascript">

    var updateFileExList = ${fileExtension};
    // 추가 또는 삭제시 view 타입 변경되는 오류
    window.onload = function () {
        makeExtensionUL_BOXinList();

        let fViewTypeValue = window.parent.frames["stat_left"].fileExtensionViewType;
        if (fViewTypeValue == 1) {
            var obj = document.getElementById("listViewType");
            var type = "list";
            viewType(obj,type);
        }
    }
    
    function makeExtensionUL_BOXinList () {
        
        var ulElemnt = document.querySelector("#ExtensionUL_TYPE");
        
        for (var i = 0; i < updateFileExList.length; i++) {
            var item = updateFileExList[i];

            // li 태그 생성
            var liElement = document.createElement("li");
            liElement.setAttribute("_ext", item);
            liElement.setAttribute("name", "LI_EXT");

            // checkbox 생성
            var checkboxElement = document.createElement("input");
            checkboxElement.setAttribute("type", "checkbox");
            checkboxElement.setAttribute("name", "checkbox");
            checkboxElement.setAttribute("id", "checkbox" + i);
            checkboxElement.setAttribute("value", item);

            // label 생성
            var labelElement = document.createElement("label");
            labelElement.setAttribute("for", "checkbox" + i);

            // checkbox 내부에 span 추가
            var spanElement = document.createElement("span");
            spanElement.setAttribute("title", item);
            spanElement.textContent = item;

            // a 태그 생성
            var aElement = document.createElement("a");
            aElement.setAttribute("class", "imgbtn01");

            // span 태그 생성
            var spanDeleteElement = document.createElement("span");
            spanDeleteElement.setAttribute("class", "icon16 icon16_delete");
            spanDeleteElement.setAttribute('onclick', 'deleteFile(\'' + item + '\')');;
            
            labelElement.appendChild(spanElement);
            labelElement.appendChild(aElement);
            aElement.appendChild(spanDeleteElement);
            liElement.appendChild(checkboxElement);
            liElement.appendChild(labelElement);

            // li 태그를 ul 태그 안에 추가
            ulElemnt.appendChild(liElement);
        }
        
    }
    
    function viewType (thisObj, pViewType) {
        var pSelectElement = document.getElementById("ExtensionUL_TYPE");
        var fViewTypeValue = window.parent.frames["stat_left"].fileExtensionViewType;
        if (pViewType === "list") {
            pSelectElement.classList.add("ExtensionUL_LIST");
            pSelectElement.classList.remove("ExtensionUL_BOX");

            thisObj.classList.add("on");
            document.getElementById("boxViewType").classList.remove("on");

            // 추가 또는 삭제시 view 타입 변경되는 오류
            if (fViewTypeValue == 0) {
                window.parent.frames["stat_left"].fileExtensionViewType = 1;
            }
        } else if (pViewType === "box") {
            pSelectElement.classList.add("ExtensionUL_BOX");
            pSelectElement.classList.remove("ExtensionUL_LIST");
            thisObj.classList.add("on");
            document.getElementById("listViewType").classList.remove("on");

            // 추가 또는 삭제시 view 타입 변경되는 오류
            if (fViewTypeValue == 1) {
                window.parent.frames["stat_left"].fileExtensionViewType = 0;
            }
        }
    }
    // 추가 화면 취소 누를시 input 데이터 초기화 작업
    function add_close(){
        document.getElementById("qname").value = "";
    }

    function addFileExtension() {
        $("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"]'></div>").appendTo(parent.frames["stat_left"].document.body);

        var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;

        $("#addpopup").css("left", popupX);

        add_close()

        $("#addpopup").modal();
        // 추가 popup이 될때 마우스 focus를 작성란으로 focus이동
        var inputFocus = document.getElementById("qname");
        inputFocus.focus();
    }

    // 허용 첨부 확장자 추가
    function add() {
        var addValue = document.getElementById('qname').value.toLowerCase();

        if (!addValue) {
            alert("<spring:message code='ezSystem.kdh05' />");
            return;
        }

        var addList = addValue.split(',');
        var lengthExceed = "- <spring:message code='ezSystem.kdh09' />"; // 확장자 길이는 10자를 초과할 수 없습니다.
        var duplValue = "- <spring:message code='ezSystem.kdh04' />"; // 확장자 명이 이미 존재합니다.
        var lengthOk = true;
        var duplOk = true;
        
        for (var i = 0; i < addList.length; i++) {
            var trimTemp = addList[i].trim();

            if (trimTemp.length >= 10) {
                lengthExceed += '\n'+trimTemp;
                lengthOk = false;
                
            } else if (updateFileExList.indexOf(trimTemp) !== -1) {
                duplValue += '\n'+trimTemp;
                duplOk = false;
            } 
        }
        if (!lengthOk || !duplOk) {
            var message = (lengthOk ? '' : lengthExceed + '\n') + (duplOk ? '' : duplValue);
            
            alert(message.trim()); // 공백 제거
        } else {
            updateFileExList = updateFileExList.concat(addList);

            actionAjax(true, updateFileExList);
        }
    }

    function deleteFile(deleteFE) {
        if (!confirm("'"+deleteFE + "' <spring:message code='ezOrgan.t130'/>   ")) {
            return;
        }
        updateFileExList = updateFileExList.filter(function(element) {
            return element !== deleteFE;
        });

        actionAjax(false, updateFileExList);
    }

    function actionAjax(isAdd, data) {
        var msg = isAdd? "<spring:message code='ezSystem.jje17' />" : "<spring:message code='ezSystem.jje11' />";

        $.ajax({
            type : "POST",
            dataType : "text",
            url : "/admin/ezSystem/updateFileExtension.do",
            data : {
                updateFileExtension : data
            },
            success : function(message) {
                if (message == 'OK') {
                    window.location.href = "/admin/ezSystem/systemFileExtension.do"
                } else if (message == 'adminDenied') {
                    alert("<spring:message code='ezOrgan.t302' />");
                } else {
                    alert(msg);
                }
            },
            error : function(){
                alert(msg);
            },
            complete : function (){
                if (isAdd) {
                    $.modal.close();
                    add_close();
                }
            }
        });
    }

    function deleteCheckList() {
        var v = 'input[name="checkbox"]:checked';
        var selectedList = document.querySelectorAll(v);

        if (selectedList === undefined || selectedList === '' || selectedList.length === 0) {
            alert("<spring:message code='ezSystem.kdh03' />");
            return;
        }
        
        var selectedListValue = '';
        $.each(selectedList, function (index, item){
            selectedListValue += item.value+",";
            
        })
        
        selectedListValue = selectedListValue.replace(/,$/,'');
        if (!confirm("'"+selectedListValue + "' <spring:message code='ezOrgan.t130'/>   ")) {
            return;
        }
        
        $.each(selectedList, function (index, item){
            
            updateFileExList = updateFileExList.filter(function(element) {
                return element !== item.value;
            });
        })
        
        actionAjax(false, updateFileExList);
    }
    </script>
    </head>
    <body class="mainbody" style="position: relative;">
    <div class="submainWrap_calcLayout">
        <h1><spring:message code='ezSystem.x0009' /></h1>
        <div class="contentlist_layout submain_calcLayoutScroll">
            <h2>* <spring:message code='ezSystem.kdh06' /></h2>
            <div id="mainmenu">
                <ul class="mainmenu_btnUL">
                    <li class="important off" onclick="addFileExtension()"><span><spring:message code='ezTask.t135' /></span></li>
                    <li class="off" onclick="deleteCheckList()"><span class="icon16 icon16_delete"></span></li>
                    <li style="background:none;border:0px;float:right" class="off">
                        <ul class="leftViewTypeUL">
                            <li class="leftViewType on" id="boxViewType" onclick="viewType(this, 'box')">
                                <span class="leftViewType_box"></span>
                            </li>
                            <li class="leftViewType" id="listViewType" onclick="viewType(this, 'list')">
                                <span class="leftViewType_list"></span>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>

            <div id="divExtensionList">
                <ul class="ExtensionUL_BOX" id="ExtensionUL_TYPE">
                </ul>
            </div>
        </div>
    </div>

    <div id="addpopup" class="popupwrap1" style="display:none;margin-bottom:60px;">
        <div class="popupJQLayer">
            <div class="title"><spring:message code='ezSystem.kdh01' /></div>
            <div id="close">
                <ul>
                    <li><a rel="modal:close"><span onclick="add_close()"></span></a></li>
                </ul>
            </div>
            <div>
                * <spring:message code='ezSystem.kdh07' />
            </div>
            <table class="popuplist" id="addpopup_list" style="width:478px;margin:10px 0px 0px 1px;">
                <tr>
                    <th style="width:90px;height:30px"><spring:message code='ezSystem.kdh02' /></th>
                    <td><input type="text" id="qname" name="qname" class="textarea" onkeyup="if(event.keyCode ==13) add();" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="50"></td>
                </tr>
            </table>
            <div class="btnpositionLayer">
                <a class="imgbtn"><span onclick="add()" ><spring:message code='ezAddress.t173' /></span></a>
            </div>
        </div>
    </div>
    </body>
</html>
