<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1201'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	</head>
	<script type="text/javascript" ID="clientEventHandlersJS">
	    var ReturnFunction;
	    var approvalFlag  	= "<c:out value ='${approvalFlag}'/>";
	    //공통정보
	    var publicityCode 	= "<c:out value ='${publicityCode}'/>";	//공개여부 - G는 대민공개여부
	    var securityCode  	= "<c:out value ='${securityCode}'/>";	//보안등급
	    var urgentApproval 	= "<c:out value ='${urgentApproval}'/>";	//긴급결재
	    //G버전 전용
	    var specialRecordCode 	= "<c:out value ='${specialRecordCode}'/>";	//특수기록물
	    var securityApproval 	= "<c:out value ='${securityApproval}'/>";	//보안결재
	    var limitRange 			= "<c:out value ='${limitRange}'/>";			//공개제한부분
	    var pageNum 			= "<c:out value ='${pageNum}'/>";				//쪽수
    	var publicityYN			= ("<c:out value ='${publicityYN}'/>").trim();			//공개여부
	    //S버전 전용
	    var storagePeriod 	= "<c:out value ='${storagePeriod}'/>";	//보존기간
	    var taskCode 		= "<c:out value ='${taskCode}'/>";		//분류코드ID
	    var itemName 		= "<c:out value ='${itemName}'/>";		//분류코드명
	    //요약정보는 TEXTAREA에 직접세팅
	    
	    window.onload = function () {
	        try {
	            ReturnFunction = parent.ezdocinfog_view_cross_dialogArguments[1];
	        } catch (e) {
	            try {
	                ReturnFunction = opener.ezdocinfog_view_cross_dialogArguments[1];
	            } catch (e) {
	            }
	        }
	        
	        if(approvalFlag == "G") {
        		$(".approvalG").css("display","");
        		$(".approval").css("display","none");
        		// $("#summary_txta").css("width", "398px").css("height", "82px");
        	} else {
        		$(".approvalG").css("display","none");
        		$(".approval").css("display","");
        		// $("#summary_txta").css("width", "398px").css("height", "200px");
        	}
	        
	        setDocInfo();
	    }
	    
	    function setDocInfo() {
	    	if (approvalFlag == "G") {
	    		if (specialRecordCode != "") {
	    			var specialText = "";
	    	        if (specialRecordCode.substring(0, 1) == "Y") {
	    	            if (specialText == "")
	    	                specialText = specialText + "<spring:message code='ezApprovalG.t1211'/>";
	    	            else
	    	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t1211'/>";
	    	        }
	    	        if (specialRecordCode.substring(1, 2) == "Y") {
	    	            if (specialText == "")
	    	                specialText = specialText + "<spring:message code='ezApprovalG.t984'/>";
	    	            else
	    	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t984'/>";
	    	        }
	    	        if (specialRecordCode.substring(2, 3) == "Y") {
	    	            if (specialText == "")
	    	                specialText = specialText + "<spring:message code='ezApprovalG.t1212'/>";
	    	            else
	    	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t1212'/>";
	    	        }
	    	        if (specialRecordCode.substring(3, 4) == "Y") {
	    	            if (specialText == "")
	    	                specialText = specialText + "<spring:message code='ezApprovalG.t986'/>";
	    	            else
	    	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t986'/>";
	    	        }
	    	        if (specialRecordCode.substring(4, 5) == "Y") {
	    	            if (specialText == "")
	    	                specialText = specialText + "<spring:message code='ezApprovalG.t1207'/>";
	    	            else
	    	                specialText = specialText + ",  " + "<spring:message code='ezApprovalG.t1207'/>";
	    	        }
	    	        
	    	        $("#specialRecordCode_span").text(specialText);
	    		}
	    		
	    		if (securityCode != "") {
	    			var securityText = securityCode.substring(0, 1) + " <spring:message code='ezApprovalG.t991'/> ";
	    			
	    	        $("#securityCode_span").text(securityText);
	    		}
	    		
	    		if (publicityYN != "") {
	    			if (publicityYN == "N") {
	    				$("#publicityCode_span").text("<spring:message code='ezApprovalG.kmh05'/>");
	    			} else if (publicityYN == "B"){
	    				$("#publicityCode_span").text("<spring:message code='ezApprovalG.kmh04'/>");
	    			} else {
						$("#publicityCode_span").text("<spring:message code='ezApprovalG.kmh03'/>");
					}
	    		}
	    		
	    		if (publicityCode != "") {
	    			var typeText = "";
	    	        var classText = "";
	    	        
	    			switch (publicityCode.substring(0, 1)) {
		    			case "1":
			                typeText = "<spring:message code='ezApprovalG.t47'/>";
			                break;
			            case "2":
			                typeText = "<spring:message code='ezApprovalG.t150'/>";
			                break;
			            case "3":
			                typeText = "<spring:message code='ezApprovalG.t46'/>";
			                break;
	    			}
	    			
	    			for (var i = 1; i <= 8; i++) {
	    	            if (publicityCode.substring(i, i + 1) == "Y") {
	    	                if (classText == "")
	    	                	classText = classText + i + "<spring:message code='ezApprovalG.t151'/>";
	    	                else
	    	                	classText = classText + ",  " + i + "<spring:message code='ezApprovalG.t151'/>";
	    	            }
	    	        }
	    			
	    			$("#publicityYN_span").text(typeText);
	    			$("#publicityLevel_span").text(classText);
	    		}
	    		if (limitRange != "") {
	    			$("#limitRange_span").text(limitRange);
	    		}
	    		if (pageNum != "") {
	    			$("#pageNum_span").text(pageNum);
	    		}
	    		if (urgentApproval != "") {
	    			$("#urgentApproval_span").text(urgentApproval);
	    		}
	    		if (securityApproval != "") {
	    			$("#securityApproval_span").text(securityApproval);
	    		}
	    		/*
	    		if ($("#summary_txta").text().trim() == "") {
 	    			$("#summary_txta").attr("disabled", true);
	    		}
	    		*/
	    	} else {
	    		if (taskCode != "" && itemName != "") {
	    			$("#taskCode_span").text(taskCode + "(" + replaceEntityCodeToStr(itemName) + ")");
	    		}
	    		if (securityCode != "") {
	    			var	securityText = securityCode.substring(0, 1) + " <spring:message code='ezApprovalG.t991'/>";
	    			
	    	        $("#securityCode_span").text(securityText);
	    		}
	    		if (publicityCode != "") {
	    			if (publicityCode == "Y") {
	    				$("#publicityCode_span").text("<spring:message code='ezApprovalG.t47'/>");
	    			} else {
	    				$("#publicityCode_span").text("<spring:message code='ezApprovalG.t46'/>");
	    			}
	    		}
	    		if (urgentApproval != "") {
	    			$("#urgentApproval_span").text(urgentApproval);
	    		}
	    		if (storagePeriod != "") {
	    			$("#storagePeriod_span").text(storagePeriod);
	    		}
	    		/*
	    		if ($("#summary_txta").text().trim() == "") {
 	    			$("#summary_txta").attr("disabled", true);
	    		}
	    		*/
	    	}
	    }
	    
	    function window_close() {
	        if (ReturnFunction != null) {
	            parent.ezdocinfog_view_cross_dialogArguments[1]();
	        } else {
	            window.close();
	        }
	    }
	</script>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1201'/></h1>
		<div id="close">
			<ul>
				<li><span onClick="window_close()"></span></li>
			</ul>
		</div>
		<h2><spring:message code='ezApprovalG.t1204'/></h2>
		<table class="content">
			<tr class="approvalG">
				<th><spring:message code='ezApprovalG.t875'/></th>
				<td>
					<span id="specialRecordCode_span"></span>
				</td>
			</tr>
			<tr class="approval">
				<th><spring:message code='ezApproval.t335'/></th>
				<td>
					<span id="taskCode_span"></span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezApproval.t81'/></th>
				<td>
					<span id="securityCode_span"></span>
				</td>
			</tr>
			<tr class="approvalG">
				<th><spring:message code='ezApprovalG.kes06'/></th>
				<td>
					<span id="publicityYN_span"></span>
				</td>
			</tr>
			<tr class="approvalG">
				<th><spring:message code='ezApprovalG.t989'/></th>
				<td>
					<span id="publicityLevel_span"></span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezApproval.t82'/></th>
				<td>
					<span id="publicityCode_span"></span>
				</td>
			</tr>
			<tr class="approvalG">
				<th><spring:message code='ezApprovalG.t876'/></th>
				<td>
					<span id="limitRange_span"></span>
				</td>
			</tr>
			<tr class="approvalG">
				<th><spring:message code='ezApprovalG.t979'/></th>
				<td>
					<span id="pageNum_span"></span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezApproval.t337'/></th>
				<td>
					<span id="urgentApproval_span"></span>
				</td>
			</tr>
			<tr class="approvalG">
				<th><spring:message code='ezApprovalG.t1210'/></th>
				<td>
					<span id="securityApproval_span"></span>
				</td>
			</tr>
			<tr class="approval">
				<th><spring:message code='ezApproval.t80'/></th>
				<td>
					<span id="storagePeriod_span"></span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezApproval.t338'/></th>
				<td>
					<span id="keyword"><c:out value="${keyword}"/></span>
				</td>
			</tr>
		</table>
		<%--
		    <h2><spring:message code='ezApprovalG.t1203'/></h2>
		    <textarea id="summary_txta" style="resize:none;" readonly="readonly"><c:out value="${summary}"/></textarea>
        --%>
	</body>
</html>