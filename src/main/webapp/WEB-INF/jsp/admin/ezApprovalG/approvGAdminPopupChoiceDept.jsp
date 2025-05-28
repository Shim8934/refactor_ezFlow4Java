<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1678' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>	    
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">	
		var P_CompanyID = "<c:out value='${CompanyID}'/>";
	    var ReturnFunction1 = "";
	    var ReturnFunction2 = "";
	    var para = new Array();
	    var gubun = "";
	    var contCompanyID = "";
	    
	    
	    window.onload = function () {
            try {
            	gubun = opener.approval_admin_popup_choicedept_dialogArguments[0];
            	P_CompanyID = opener.approval_admin_popup_choicedept_dialogArguments[2];
            	if (gubun == "one") {
                	ReturnFunction1 = opener.approval_admin_popup_choicedept_dialogArguments[1];
            	} else {
                	ReturnFunction2 = opener.approval_admin_popup_choicedept_dialogArguments[1];            		
            	}
            } catch (e) { }
        }
	    
	    var organ_dialogArguments = new Array();
	    
	    function bt_TDeptSelect_onclick(obj) {
            organ_dialogArguments[0] = P_CompanyID;
            if (obj.id == "spanrecev") {
            	organ_dialogArguments[1] = bt_TDeptSelect_onclick_Complete;
            } else {
            	organ_dialogArguments[1] = bt_TDeptSelect_onclick_Complete_spanvdept;
            }
            var result = GetOpenWindow("/admin/ezApprovalG/apprGOrgan.do", "Organ_Cross", 400, 485, "NO");
        }
        
        function bt_TDeptSelect_onclick_Complete(retVal) {
            var Flag;
            if (typeof (retVal) != "undefined") {
                document.getElementsByName("TDeptName")[0].id = retVal[0];
                document.getElementsByName("TDeptName")[0].value = retVal[1];
                contCompanyID = retVal[2];
            }
            Flag = "TDeptName";
            getDocType(Flag);
        }
        
        function bt_TDeptSelect_onclick_Complete_spanvdept(retVal) {
            var Flag;
            if (typeof (retVal) != "undefined") {
                $("#drafterdept").val(retVal[1]);
                contCompanyID = retVal[2];
            }
            Flag = "TDeptName";
            getDocType(Flag);
        }	

        function getDocType(Flag) {
            try {
                var xmlRtn = createXmlDom();
                var Cnt, Cnt2, oOption
                var index, i, j;
                var contID = new Array();
                var name = new Array();
                var deptID = "";

                if (Flag == "SDeptName") {
                	deptID = document.getElementsByName('SDeptName')[0].id;
                } else {
                	deptID = document.getElementsByName('TDeptName')[0].id;
                }

                var result = "";
            	
            	$.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/admin/ezApprovalG/apprGMgetContInfo.do",
            		data : {
            			deptID     : deptID,
            			comID  : contCompanyID // 전체 조직도에서 선택한 회사ID를 전달
            		},
            		success: function(text){
            			result = text;
            		},
            		error : function() {
            			result = "<LISTVIEWDATA><HEADERS><HEADERS><ROWS></ROWS></LISTVIEWDATA>";
            		}
            	});

                xmlRtn = loadXMLString(result);
                
                if (Flag == "SDeptName") {
                    index = document.getElementsByName('selSContName')[0].length;

                    if (index > 0) {
                        for (i = index ; i > 0 ; i--)
                            document.getElementsByName('selSContName')[0].remove(i - 1);
                    }
                    
                    for (Cnt = 0 ; Cnt < xmlRtn.getElementsByTagName("DATA1").length; Cnt++) {
                        var nodevalue = xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue;
                        if (nodevalue != null && nodevalue != "" && nodevalue && "undefine") {
                            contID[Cnt] = xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue;
                            name[Cnt] = xmlRtn.getElementsByTagName("DATA3")[Cnt].childNodes[0].nodeValue;
                            Add_ContType1(name[Cnt], contID[Cnt]);
                        }        
                    }            
                }
                else {
                    index = document.getElementsByName('selTContName')[0].length;

                    if (index > 0) {
                        for (i = index ; i > 0 ; i--)
                            document.getElementsByName('selTContName')[0].remove(i - 1);
                    }
                    
                    for (Cnt = 0 ; Cnt < xmlRtn.getElementsByTagName("DATA1").length; Cnt++) {
                    	var nodevalue = xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue;
                        if (nodevalue != null && nodevalue != "" && nodevalue && "undefine") {
                            contID[Cnt] = xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue;
                            name[Cnt] = xmlRtn.getElementsByTagName("DATA3")[Cnt].childNodes[0].nodeValue;
                            Add_ContType2(name[Cnt], contID[Cnt]);
                        }
                    }            
                }
            } catch (e) { alert("MoveContainer.js :: getDocType()"); }
        }
        
        function Add_ContType2(Name, ID) {
            var oOption = document.createElement("OPTION");
            setNodeText(oOption, Name);
            oOption.value = ID

            var sOption = document.getElementsByName("selTContName")[0];
            if (CrossYN())
                sOption.add(oOption, null);
            else
                sOption.add(oOption);

            oOption = null;
        }
        
        /* 2020-11-30 홍승비 - 크롬 브라우저에서는 자식창의 부모창 제어 기능을 방지하므로, 자식창에서 confirm 뜨도록 처리 */
        function save_info() {

        	if (gubun == "one") {
            	if ($("select[name=selTContName]").val() != null && $("select[name=selTContName]").val() !="") {

            		para[0] = $("select[name=selTContName]").val();
            		para[1] = contCompanyID;
            	} 
	        	if(ReturnFunction1 != null) {
	        		window.opener.confirm = window.confirm;
	        		ReturnFunction1(para);
	        	}
	        	window.close();
        	} else {
            	if ($("select[name=selTContName]").val() != null && $("select[name=selTContName]").val() !="") {

            		para[0] = $("select[name=selTContName]").val();
            		para[1] = contCompanyID;
            	}
	        	if(ReturnFunction2 != null) {
	        		window.opener.confirm = window.confirm;
	        		ReturnFunction2(para);
	        	}
	        	window.close();        		
        	}
        }
	    
		</script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t1678' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <center>
	    <table class="content" style="width:95%">
	       <tr>
				<th style=" width:150px;">
	            	<spring:message code='ezApprovalG.kes05'/>
				</th>
				<td style=" width:200px;">
					<input type="text" id="TDeptName" name="TDeptName" style="WIDTH: 71%;" readonly="true" />
	        	    <a class="imgbtn imgbck" name="TDeptSelect"><span id = "spanrecev" onclick="bt_TDeptSelect_onclick(this)"><spring:message code='ezApprovalG.t105'/></span></a>
				</td>
			</tr>
			<tr>
				<th style="width:150px;">
					<spring:message code='ezApproval.t611'/>
				</th>
				<td style=" width:200px; margin-bottom: 10px;">
					<select name="selTContName" id="selTContName" style="WIDTH: 100%; height: 23px;" onchange="return bt_selTContName_onclick()"></select>
				</td>
			</tr>
	    </table>
	    </center>
	    <div class="btnpositionNew">
	        <a class="imgbtn"><span onclick="save_info()" ><spring:message code='ezSchedule.t157' /></span></a>
	    </div>
	</body>
</html>

