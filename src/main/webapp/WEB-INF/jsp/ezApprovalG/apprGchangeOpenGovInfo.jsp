<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t969'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/openGovInfo.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/InitSCPopup_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OpenAlert_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<style type="text/css">
	/* tooltip 추가*/
	.calendar_layer{width:250px; table-layout:fixed; border:1px solid #4e4e46; border-collapse:separate; border-spacing:0; overflow:hidden;}
	.calendar_layer th{margin:0; padding:8px 10px; border:0; font-size:13px; color:#383838; white-space:normal; text-align:left;word-break:break-all;}
	.calendar_layer td{margin:0; padding:0;}
	.calendar_layer .text{padding:10px; border:1px solid #e5e5e5; border-bottom:0 none; overflow:hidden;}
	.calendar_layer .text .td_list{border:0 none; overflow:hidden;}
	.calendar_layer .text .td_list td{padding:3px 0px; color:#393939;}
	.calendar_layer .btn{background:#fff; border:1px solid #e5e5e5; border-top:1px solid #dedede; padding:10px 0px 9px 0px; margin:0 auto; text-align:center;}
	.calendar_layer .btn ul{list-style:none; margin:0 25px; padding:0px 3px; overflow:hidden; text-align:center;clear:both;list-style-type:none}
	.calendar_layer .btn ul li{float:left; height:27px; line-height:27px; background:url(images/calendar/btn_calendar_l.gif) no-repeat left top; padding:0px 3px 0px 8px;}
	.calendar_layer .btn ul li span{display:inline-block; background:url(images/calendar/btn_calendar_r.gif) no-repeat right top; padding:0px 8px 0px 3px; font-weight:normal; color:#555555;}
	
</style>
<script type="text/javascript" ID="clientEventHandlersJS">
    var rtnVal = new Array();
    var g_RecordID, g_SepAttachNo, g_RecordType;
    var g_ModifyFlag;
    var g_UserID, g_UserName;
    var g_ArrPageInitFlag = new Array();
    g_ArrPageInitFlag[0]=false;
    g_ArrPageInitFlag[1]=false;
    var g_szRecInfoXml;
    var g_SCFlag;
    var g_CodeInfoXml,g_bRecAdmin;
    var RetValue;
    var ReturnFunction;
    var pDocID;
    
    //변경이 되었는지 아닌지 비교하기위한 변수
    var c_docTitle = "", c_docNo = "", c_writerName = "", c_writerDeptName = "", c_publicityCode = "", c_listOpenFlag = "", c_reason = "", c_basis = "", c_openLimitDate = "";
    var c_openFlag = "";

    var docTitle = "", docNo = "", writerName = "", writerDeptName = "", publicityCode = "", listOpenFlag = "", reason = "", basis = "", openLimitDate = "";
    var openFlag = "";
    $(function () {
    	if (document.getElementById("openGovLimitDate").checked){
    		$("#idDatepickerForOpenGov").attr('disabled',false);
    	} else {
    		$("#idDatepickerForOpenGov").attr('disabled',true);
    	}
    	
    	var today = new Date();
    	$("#idDatepickerForOpenGov").datepicker({
    		minDate: today,
            changeMonth: true,
            changeYear: true,
            autoSize: true,
            showOn: "both",
            buttonImage: "/images/ImgIcon/calendar-month.png",
            buttonImageOnly: true
        });
		
    	initdatepicker();
    });
    
    window.onload = function () {

        try {
            RetValue = parent.changeOpenGovInfo_cross_dialogArguments[0];
            ReturnFunction = parent.changeOpenGovInfo_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.changeOpenGovInfo_cross_dialogArguments[0];
                ReturnFunction = opener.changeOpenGovInfo_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }

        if (RetValue != undefined) {
            g_RecordID = RetValue[0];
            g_SepAttachNo = RetValue[1];
            g_UserID = RetValue[2];
            g_UserName = RetValue[3];
            g_bRecAdmin = RetValue[4];
            pDocID = RetValue[5];
        }

        getAttachList();
        GetRecordSimpleInfo();
        
        $("#docTitle").text(docTitle);
        $("#docNo").text(docNo);
        $("#writerName").text(writerName);
        $("#writerDeptName").text(writerDeptName);
        
        if (listOpenFlag != "") {
        	if (listOpenFlag == "Y") {
	        	document.getElementById("openListFlag").checked = true;
	        	$("#basis").hide();
	        	$("#txt_Basis").val("");
        	} else {
	        	document.getElementById("openListFlag").checked = false;
	        	$("#txt_Basis").val(basis);
        	}
        } else {
        	document.getElementById("openListFlag").checked = true;
        	$("#basis").hide();
        }
        
        if (openLimitDate != "" && openLimitDate != null) {
        	document.getElementById("openGovLimitDate").checked = true;
        	document.getElementById("idDatepickerForOpenGov").disabled = "";
        	$("#idDatepickerForOpenGov").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#idDatepickerForOpenGov").datepicker('setDate', new Date(openLimitDate));
        }
        
        rtnVal[0] = "FALSE";
    }
    
    function InitPublicCode(pCode) {
        var objCode = new String(pCode);
        if (objCode.length > 0) {
            var idx = parseInt(objCode.charAt(0));
            document.getElementsByName("rdoSecType")[idx - 1].checked = true;
			
            if (idx == "1") {
        		$("#reason").hide();		        		
	        	$("#txt_Reason").val("");
        	} else {
        		$("#reason").show();		        		
	        	$("#txt_Reason").val(reason);
        	}
            
            if (idx != 1)
            {
                if (objCode.charAt(1) == "Y")
                    selSecLevel1.checked = true;

                if (objCode.charAt(2) == "Y")
                    selSecLevel2.checked = true;

                if (objCode.charAt(3) == "Y")
                    selSecLevel3.checked = true;

                if (objCode.charAt(4) == "Y")
                    selSecLevel4.checked = true;

                if (objCode.charAt(5) == "Y")
                    selSecLevel5.checked = true;

                if (objCode.charAt(6) == "Y")
                    selSecLevel6.checked = true;

                if (objCode.charAt(7) == "Y")
                    selSecLevel7.checked = true;

                if (objCode.charAt(8) == "Y")
                    selSecLevel8.checked = true;

            }
        }
        rdoSecType_onclick("");
    }
    
    function GetRecordSimpleInfo() {
    	$.ajax({
    		type : "POST",
    		dataType : "json",
    		async : false,
    		url : "/ezApprovalG/getOpenGovInfoForUpdate.do",
    		data : {
    			docID : pDocID
    		},
    		success: function(xml){
    			docTitle = xml.openGovInfo.docTitle;
    			docNo = xml.openGovInfo.docNo;
    			writerName = xml.openGovInfo.writerName;
    			writerDeptName = xml.openGovInfo.writerDeptName;
    			publicityCode = xml.openGovInfo.publicityCode;
    			listOpenFlag = xml.openGovInfo.listOpenFlag;
    			reason = xml.openGovInfo.reason;
    			basis = xml.openGovInfo.basis;
    			openLimitDate = xml.openGovInfo.openLimitDate;
    			
    			InitPublicCode(publicityCode);
    			initdatepicker();
    		}
    	});
    }
    
    function btnReset_onclick() {
//         document.getElementById("txtChangeReason").value = "";
		window.close();
    }
    
    function btnOK_onclick() {
        if (document.getElementById("openListFlag").checked == false) {
        	if ($("#txt_Basis").val() == "") {
        		OpenAlertUI("목록비공개사유를 입력해주세요");
        		return;
        	} else {
        		basis = $("#txt_Basis").val();
        	}
        	
        	listOpenFlag = "N";
        } else {
        	listOpenFlag = "Y"; 
	        basis = "";
        }
        
        publicityCode = GetPublicCode();
        
        if (publicityCode.charAt(0) != "1") {
        	if ($("#txt_Reason").val() == "") {
        		OpenAlertUI("비공개사유를 입력해주세요");
        		return;
        	} else {
        		reason = $("#txt_Reason").val();
        	}
        }
        
        if ($("#modifyReason").val() == "") {
    		OpenAlertUI("수정 사유를 입력해주세요");
    		return;
    	} else {
    		modifyReason = $("#modifyReason").val();
    	}
        
        if ($("input:checkbox[id='openGovLimitDate']").is(":checked")) {
        	if($("#idDatepickerForOpenGov").val() == "") {
        		OpenAlertUI("열람제한일을 입력해주세요");
        	} else {
        		openLimitDate = $("#idDatepickerForOpenGov").val();
        	}
        } else {
        	openLimitDate = "";
        }
        
        if (updateOpenGovInfo() == "TRUE") {
		    // OpenAlertUI("원문정보를 변경하였습니다.", window.close);
            alert("원문정보를 변경하였습니다.");
            opener.location.reload();
            window.close();
        }
        
    }
    
    function btnClose_onclick() {
        rtnVal[0] = "FALSE";
        window.close();
    }
    
    function updateOpenGovInfo() {
        var fileOpenFlagList = "";
        
        for (var i = 0; i < document.getElementsByClassName('fileOpenFlagChk').length; i++) {
        	if (document.getElementsByClassName('fileOpenFlagChk')[i].checked) {
        		fileOpenFlagList += "Y";
        	} else {
        		fileOpenFlagList += "N";
        	}
        }
        
        $.ajax({
            type : "POST",
            dataType : "text",
            async : false,
            url : "/ezApprovalG/updateOpenGovInfo.do",
            data : {
                docID : pDocID,
                publicityCode : publicityCode,
                listOpenFlag : listOpenFlag,
                reason : reason,
                basis : basis,
                openLimitDate : openLimitDate,
                fileOpenFlagList : fileOpenFlagList,
                // 수정사유
                modifyReason : modifyReason
            },
            success: function(xml){
                rtnVal[0] = "TRUE";
            }
        });
        return rtnVal[0];
    }
    
    window.onbeforeunload = function () {
        if (ReturnFunction != null)
            ReturnFunction(rtnVal);
        else
            window.returnValue = rtnVal;
    }
    
    function initdatepicker() {
    	$("#idDatepickerForOpenGov").datepicker("option", "dateFormat", "yy-mm-dd");
//         $("#idDatepickerForOpenGov").datepicker('setDate', new Date(openLimitDate));

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
    }
    
    function showTooltip_MouseOver(obj, e) {
        var tTip = document.getElementById('tooltip');
        var tTable = document.createElement("TABLE");
        var tTr = document.createElement("TR");
        var tTh = document.createElement("TH");
        
        tTip.innerHTML = "";
        tTable.className = "calendar_layer";
        tTable.setAttribute("cellpadding", "0");
        tTable.setAttribute("cellspacing", "0");
        tTable.setAttribute("border", "0");
        tTable.setAttribute("width", "100%");
        tTh.setAttribute("scope", "col");
        tTh.style.background = "#edf4fd";
        tTh.style.border = "1px solid #d1ddec";
        
        setNodeText(tTh,obj.innerHTML);
        tTr.appendChild(tTh);
        tTable.appendChild(tTr);

        var tTr = document.createElement("TR");
        var tTd = document.createElement("TD");
        
        tTd.style.borderTop = "0px";
        tTd.style.backgroundColor = "white";
        tTd.className = "text";
        
        var sTable = document.createElement("TABLE");
        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        
        sTable.style.backgroundColor = "white";
        sTable.className = "td_list";
        sTable.setAttribute("cellpadding", "0");
        sTable.setAttribute("cellspacing", "0");
        sTable.setAttribute("border", "0");
        sTable.setAttribute("width", "100%");
        sTd.className = "individual";

        var sSpan = document.createElement("SPAN");
        sTd.appendChild(sSpan);
        
        var strHTML = "";

		switch ($(obj).prev().attr('id')) {
		case 'selSecLevel1':
			strHTML = "법률 또는 명령에 의하여 비밀로 유지되거나 비공개사항으로 규정된 항목";
			break;

		case 'selSecLevel2':
			strHTML = "공개될 경우 국가안보,국방,통일 외교관계 등 국익을 해할 우려가 있는 정보";
			break;
		case 'selSecLevel3':
			strHTML = "공개될 경우 국민의 생명,신체,재산 등 공공안전 및 이익을 해할 우려가 있는 정보";
			break;
		case 'selSecLevel4':
			strHTML = "수사,재판,범죄예방 등의 관련정보로서 공개될 경우 직무수행이 곤란하거나 형사피고인의 공정한 재판받을 권리를 침해할 우려가 있는 정보";
			break;
		case 'selSecLevel5':
			strHTML = "감사,감독,검사,시험,규제,입찰계약,기술개발,인사관리,의사결정 또는 내부검토과정에 있는 사항으로서 공개될 경우 업무수행 등에 지장을 초래할 우려가 있는 정보";
			break;
		case 'selSecLevel6':
			strHTML = "이름,주민등록번호 등에 의해 특정인을 식별할 수 있는 개인에 관한 정보";
			break;
		case 'selSecLevel7':
			strHTML = "법인,단체 또는 개인의 영업상 비밀에 관한 정보로서 공개될 경우 법인 등의 정당한 이익을 해할 우려가 있는 정보";
			break;
		case 'selSecLevel8':
			strHTML = "공개될 경우 부동산투기,매점매석 등으로 특정인에게 이익 보는 불이익을 줄 우려가 있는 정보";
			break;
		}
        
        sTd.innerHTML = "<b>" + strHTML + "</b>";
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
        tTd.appendChild(sTable);
        tTr.appendChild(tTd);
        tTable.appendChild(tTr);
            
        tTip.appendChild(tTable);
        tTip.style.left = getMouseXLocation(e) + 'px';
        tTip.style.top = getMouseYLocation(e) + 'px';
        tTip.style.visibility = 'visible';
    }
    
    function getMouseXLocation(e) {
        if (e)
            var E = e;
        else
            var E = window.event;

        if (E.clientX > 1000) {
            var tTip = document.getElementById("tooltip");
            var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
        } else {
        	var locationX = E.clientX + document.body.scrollLeft + 20;
        }

        return locationX
    }
    
    function getMouseYLocation(e) {
        if (e)
            var E = e;
        else
            var E = window.event;

        var tTip = document.getElementById("tooltip");
        if (navigator.userAgent.indexOf('Firefox') != -1) {
            if (E.clientY > 500) {
                var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
            } else {
                if (document.documentElement.scrollTop > 0) {
                    //var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
                    var locationY
                    //이벤트 발생 Y좌표보다 toolTip의 높이가 더 크면 - 메디톡스 수정
                    if (tTip.clientHeight > E.clientY) {
                        locationY = E.clientY + document.documentElement.scrollTop;
                    } else {
                        locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
                    }
                } else {
                    var locationY = E.clientY + document.documentElement.scrollTop;
                }
            }
        } else {
            if (E.clientY > 500) {
                var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
            } else {
                if (document.body.scrollTop > 0) {
                    var locationY
                    //이벤트 발생 Y좌표보다 toolTip의 높이가 더 크면 - 메디톡스 수정
                    if (tTip.clientHeight > E.clientY) {
                        locationY = E.clientY + document.body.scrollTop;
                    } else {
                        locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
                    }
                } else {
                    var locationY = E.clientY + document.body.scrollTop;
                }
            }
        }

        return locationY
    }
    
    function hideTooltip() {
        document.getElementById('tooltip').style.visibility = 'hidden';
    }
    
    function openListFlag_onClick(chk) {
    	if (chk.checked == true) {
    		$("#basis").hide();
    	} else {
    		$("#basis").show();
    	}
    }
    
    function openGovLimitDate_onClick() {
        if (document.getElementById("openGovLimitDate").checked) {
            document.getElementById("idDatepickerForOpenGov").disabled = "";
//            $(".ui-datepicker-trigger").show();
        }
        else {
            document.getElementById("idDatepickerForOpenGov").disabled = "disabled";
//            $(".ui-datepicker-trigger").hide();
        }
    }
    
    function getAttachList() {
    	$.ajax({
    		type : "POST",
    		dataType : "json",
    		async : false,
    		url : "/ezApprovalG/getAttachListForOpenGov.do",
    		data : {
    			docID : pDocID,
    			endFlag : "Y"
    		},
    		success: function(xml){
    			result = xml;
    			if (result.length > 0) {
   					var attachTr;
        			$.each(result, function(index, item) {
        				attachTr = "";
        				if (item.fileOpenFlag == "Y") {
        					attachTr = "<tr><td align='center' style='width:30px'><div class='custom_checkbox'><input onClick='fileOpenFlagChk_onClick(this)' class='fileOpenFlagChk' id='fileOpenFlagChk_" + item.sn + "' type='checkbox' checked /></div>&nbsp;</td>"
            				+ "<td style='width:30px'>" + item.sn + "</td><td style='width:350px'>" + item.fileName + "</td>"
            				+ "<td style='width:70px'>" + item.fileSize + "</td>"
            				+ "<td class='fileOpenFlag' id='fileOpenFlag_" + item.sn + "' style='width:60px'>" + "공개" + "</td></tr>";
        				} else {
        					attachTr = "<tr><td align='center' style='width:30px'><div class='custom_checkbox'><input onClick='fileOpenFlagChk_onClick(this)' class='fileOpenFlagChk' id='fileOpenFlagChk_" + item.sn + "' type='checkbox'/></div>&nbsp;</td>"
            				+ "<td style='width:30px'>" + item.sn + "</td><td style='width:350px'>" + item.fileName + "</td>"
            				+ "<td style='width:70px'>" + item.fileSize + "</td>"
            				+ "<td class='fileOpenFlag' id='fileOpenFlag_" + item.sn + "' style='width:60px'>" + "비공개" + "</td></tr>";
        				}
        				
        				$("#attachList").append(attachTr);	
        			});
        			
        			$("#attachList > tr").children("td").css({"border-bottom": "1px solid #e0e0e0", "overflow": "hidden", "text-overflow": "ellipsis", "white-space":"nowrap", "padding-left":"10px", "height":"10px"});
    			} else {
        			$("#attachList").append("<td colspan='5' align='center'>데이터가 존재하지 않습니다.</td>")
    			}
    		}
    	});
    }
    
    function fileOpenFlagChk_onClick(chk) {
    	if (chk.checked == true) {
    		chk.parentElement.parentElement.lastElementChild.textContent = "공개";
    	} else {
    		chk.parentElement.parentElement.lastElementChild.textContent = "비공개";
    	}
    }
</script>
</head>
<body class="popup">
<h1>원문공개수정</h1>
<div id="close">
    <ul>
        <li><span id="btnClose" onclick="return btnClose_onclick()"></span></li>
    </ul>
</div>
<table class="content" style="margin-top:10px;width:100%;">
  <tr>
    <th style="width:17%;padding-right:0px;min-width:90px;max-width:90px;">문서제목</th>
    <td id = "docTitle" colspan="5" style="width:80%;"></td>
  </tr>
  <tr>
    <th style="width:17%;padding-right:0px;min-width:90px;max-width:90px;">문서번호</th>
    <td id="docNo" style="width:30%"></td>
    <th style="width:10%;">기안자</th>
    <td id="writerName" style="width:10%"></td>
    <th style="width:10%">기안부서</th>
    <td id="writerDeptName" style="width:20%"></td>
  </tr>
</table>
<Div>
  <table class="content" style="margin-top:10px;width:100%;">
    <tr>
      <th style="width:16%;padding-right:5px;"><spring:message code='ezApprovalG.kes06'/> &nbsp;&nbsp;</th>
      <td style="width:85%;"><div class="custom_radio"><Input type="radio" name="rdoSecType" value="1" checked onClick="return rdoSecType_onclick(this.value)"></div>
        <span style="vertical-align:middle;"><spring:message code='ezApprovalG.t47'/></span>
        <div class="custom_radio"><Input type="radio" name="rdoSecType" value="2" onClick="return rdoSecType_onclick(this.value)"></div>
        <span style="vertical-align:middle;"><spring:message code='ezApprovalG.t150'/></span>
        <div class="custom_radio"><Input type="radio"  name="rdoSecType" value="3" onClick="return rdoSecType_onclick(this.value)"></div>
        <span style="vertical-align:middle;"><spring:message code='ezApprovalG.t988'/></span>
        <div class="custom_checkbox"><input type="checkbox" name="openListFlag" id="openListFlag" value="checkbox" onClick="openListFlag_onClick(this)"></div>
        <span>목록공개</span>
      </td>
    </tr>
    <tr id="basis">
	    <th style="width:15%;padding-right:5px;">목록비공개사유</th>
	    <td>
          	<input type="text" id="txt_Basis" name="txt_Basis" style="width: 50%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="35" />
          	* 35자 이내로 입력해주세요
	    </td>
    </tr>
    <tr>
      <th style="width:15%;"><spring:message code='ezApprovalG.t989'/></th>
        <td ><div class='custom_checkbox'><input type="checkbox" name="selSecLevel1" id="selSecLevel1" value="Y"></div>
        <span onmouseover="showTooltip_MouseOver(this);" onmouseout="hideTooltip();">1<spring:message code='ezApprovalG.t991'/></span>
        <div class='custom_checkbox'><input type="checkbox" name="selSecLevel2" id="selSecLevel2" value="Y"></div>
        <span onmouseover="showTooltip_MouseOver(this);" onmouseout="hideTooltip();">2<spring:message code='ezApprovalG.t991'/></span>
        <div class='custom_checkbox'><input type="checkbox" name="selSecLevel3" id="selSecLevel3" value="Y"></div>
        <span onmouseover="showTooltip_MouseOver(this);" onmouseout="hideTooltip();"> 3<spring:message code='ezApprovalG.t991'/></span>
        <div class='custom_checkbox'><input type="checkbox" name="selSecLevel4" id="selSecLevel4" value="Y"></div>
        <span onmouseover="showTooltip_MouseOver(this);" onmouseout="hideTooltip();">4<spring:message code='ezApprovalG.t991'/></span><br>
        <div class='custom_checkbox'><input type="checkbox" name="selSecLevel5" id="selSecLevel5" value="Y"></div>
        <span onmouseover="showTooltip_MouseOver(this);" onmouseout="hideTooltip();"> 5<spring:message code='ezApprovalG.t991'/></span>
        <div class='custom_checkbox'><input type="checkbox" name="selSecLevel6" id="selSecLevel6" value="Y"></div>
        <span onmouseover="showTooltip_MouseOver(this);" onmouseout="hideTooltip();">6<spring:message code='ezApprovalG.t991'/></span>
        <div class='custom_checkbox'><input type="checkbox" name="selSecLevel7" id="selSecLevel7" value="Y"></div>
        <span onmouseover="showTooltip_MouseOver(this);" onmouseout="hideTooltip();"> 7<spring:message code='ezApprovalG.t991'/></span>
        <div class='custom_checkbox'><input type="checkbox" name="selSecLevel8" id="selSecLevel8" value="Y"></div>
        <span onmouseover="showTooltip_MouseOver(this);" onmouseout="hideTooltip();"> 8<spring:message code='ezApprovalG.t991'/></span>
        </td>
    </tr>
    <tr id="reason">
    	<th style="width:15%;">비공개사유</th>
    	<td>
        <div style="padding-top:1px;padding-bottom:1px">
           <textarea id="txt_Reason" name="txt_Reason" style="height: 40px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;"></textarea>
        </div>
    	</td>
    </tr>
    <tr>
      <th style="width:15%;">열람제한일</th>
      <td>
        <div class='custom_checkbox'><input type="checkbox" name="openGovLimitDate" id="openGovLimitDate" value="checkbox" onclick="openGovLimitDate_onClick()"></div>
        <input readonly="readonly" id='idDatepickerForOpenGov' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
      </td>
    </tr>
  </table>
</Div>
 <div style="overflow: auto; width: 100%; height: 115px; margin-top:10px">
     <table width="100%" class="popuplist" style="margin-top: 2px;">
     <thead>
	<tr>
	<th id="lvAPRLINE_TH_0" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:30px">공개여부</th>
	<th id="lvAPRLINE_TH_1" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:30px">순번</th>
	<th id="lvAPRLINE_TH_2" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:350px">파일이름</th>
	<th id="lvAPRLINE_TH_3" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:70px">파일크기</th>
	<th id="lvAPRLINE_TH_4" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:60px">공개/비공개</th>
  	</tr>
  	</thead>
  	<tbody  id="attachList">
  	</tbody>
	</table> 
</div>
 <div style="overflow: auto; width: 100%; height: 115px; margin-top:10px">
	 <table width="100%" class="popuplist" style="margin-top: 2px;">
	     <thead>
		<tr>
		<th id="lvAPRLINE_TH_0" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:30px">수정 사유</th>
	  	</tr>
	  	</thead>
	  	<tbody>
	  	<tr>
	  	<td>
	  		<textarea id="modifyReason" name="modifyReason" style="height: 50px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;"></textarea>
  		</td>
	  	</tr>
	  	</tbody>
		</table>
 	
    <div class="btnposition btnpositionNew" style="display:block;">
      <a class="imgbtn"><span id="btnReset" onclick="return btnReset_onclick()">취소</span></a>
      <a class="imgbtn"><span id="btnOK" onclick="return btnOK_onclick()">저장</span></a>
    </div>
</div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	<div id="tooltip" style="position: absolute; visibility: hidden; z-index: 900;"></div>
</body>
</html>
