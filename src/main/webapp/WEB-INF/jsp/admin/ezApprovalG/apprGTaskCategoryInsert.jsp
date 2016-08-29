<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><c:out value = '${title}' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var labelcolor = "gray"
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var gRtnVal = "FALSE";
		    var gState, CateCode, CateName, CateLevel, CateDesc, CatePCode, companyID, CateName2;
		    var RetValue;
		    var ReturnFunction;
		    var reParam = new Array();
		    reParam[0] = "FALSE";
		    reParam[1] = "";
		    reParam[2] = "";
		    reParam[3] = "";
		    reParam[4] = "";
		    reParam[5] = "";
		    
		    $(document).ready(function(){
		        tbCateName.focus();

		        try {
		            RetValue = parent.taskcategoryinsert_cross_dialogArguments[0];
		            ReturnFunction = parent.taskcategoryinsert_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.taskcategoryinsert_cross_dialogArguments[0];
		                ReturnFunction = opener.taskcategoryinsert_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("tbCateCode"));
		            KeEventControl(document.getElementById("tbCateName"));
		            KeEventControl(document.getElementById("tbCateName2"));
		            KeEventControl(document.getElementById("tbCateDesc"));
		            KeEventControl(document.getElementById("tbPCateCode"));
		        }

		        if (RetValue[0] == "I") {
		            gState = "I";
		            CateCode = RetValue[1];
		            CateName = RetValue[2];
		            CateLevel = RetValue[3];
		            CateDesc = RetValue[4];
		            CatePCode = RetValue[5];
		            companyID = RetValue[6];
		            CateName2 = RetValue[7];
		        } else {
		            gState = "U";
		            CateCode = RetValue[1];
		            CateName = RetValue[2];
		            CateLevel = RetValue[3];
		            CateDesc = RetValue[4];
		            CatePCode = RetValue[5];
		            companyID = RetValue[6];
		            CateName2 = RetValue[7];
		        }
		        
		        document.getElementById("tbCateType").value = CateLevel;
		        document.getElementById("tbCateCode").value = CateCode;
		        document.getElementById("tbCateName").value = CateName;
		        document.getElementById("tbCateName2").value = CateName2;
		        document.getElementById("tbCateDesc").value = CateDesc;
		        document.getElementById("tbPCateCode").value = CatePCode;
		        document.getElementById("tbPCateCode").disabled = true;

		        if (gState == "U") {
		            document.getElementById("tbCateCode").readOnly = true;
		            document.getElementById("tbCateCode").disabled = true;
		            //document.getElementById("btnDuplicate").disabled = true;
		        }

		        if (CateLevel == "1") {
		            document.getElementById("btnSelPCode").disabled = true;
		        }
		    });
		    
		    function trim(parm_str) {
		        if (parm_str == "") {
		            return "";
		        } else {
		            return rtrim(ltrim(parm_str));
		        }
		    }
		    
		    function ltrim(parm_str) {
		        var str_temp = parm_str;
		        
		        while (str_temp.length != 0) {
		            if (str_temp.substring(0, 1) == " ") {
		                str_temp = str_temp.substring(1, str_temp.length);
		            } else {
		                return str_temp;
		            }
		        }
		        
		        return str_temp;
		    }
		    
		    function rtrim(parm_str) {
		        var str_temp = parm_str;
		        
		        while (str_temp.length != 0) {
		            int_last_blnk_pos = str_temp.lastIndexOf(" ");
		            
		            if ((str_temp.length - 1) == int_last_blnk_pos) {
		                str_temp = str_temp.substring(0, str_temp.length - 1);
		            } else {
		                return str_temp;
		            }
		        }
		        
		        return str_temp;
		    }
		    
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent) {
		        ezapralert_cross_dialogArguments[0] = pAlertContent;
		        ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		        var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
		        try { ezAPRALERT_Cross.focus(); } catch (e) { }
		    }
		    
		    function OpenAlertUI_Complete() {
		    }
		    
		    function GetTaskCategoryDuplicate() {
		        var tempCode = trim(tbCateCode.value);
		        
		        if (tempCode == "") {
		            return "NULL";
		        } else if (tempCode.length != 8) {
		            return "LENGTH";
		        }
		        
				var retVal ="";
				
				$.ajax({
					type : "POST",
		        	url : "/admin/ezApprovalG/getTaskCategoryDuplicate.do",
		        	async : false,
		        	data : {cateType : CateLevel, sCateCode : tempCode, companyID : companyID},
		        	success : function(result) {
		        		retVal = result;
		        	}
				});
				return retVal;
		    }
		    
		    function btnDuplicate_onclick() {
		        var tempValue = GetTaskCategoryDuplicate();
		        
		        if (tempValue == "NULL") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t719' />");
		        } else if (tempValue == "TRUE") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t720' />");
		        } else if (tempValue == "FALSE") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t721' />");
		        } else if (tempValue == "LENGTH") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t722' />");
		        } else {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t723' />");
		        }
		    }
		    
		    function btnDuplicateHidden_onclick() {
		        var tempValue = GetTaskCategoryDuplicate();
		        
		        if (tempValue == "NULL") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t719' />");
		            return false;
		        } else if (tempValue == "TRUE") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t720' />");
		            return false;
		        } else if (tempValue == "FALSE") {
		            return true;
		        } else if (tempValue == "LENGTH") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t722' />");
		            return false;
		        } else {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t723' />");
		            return false;
		        }
		    }
		    
		    var selecttaskcategory_cross_dialogArguments = new Array();
		    
		    function btnSelPCode_onclick() {
		        var para = new Array();
		        para[0] = parseInt(CateLevel) - 1;
		        para[1] = document.getElementById("tbPCateCode").value;
		        para[2] = companyID;

		        selecttaskcategory_cross_dialogArguments[0] = para;
		        selecttaskcategory_cross_dialogArguments[1] = btnSelPCode_onclick_Complete;

		        var SelectTaskCategory_Cross = window.open("/admin/ezApprovalG/selectTaskCategory.do", "SelectTaskCategory", GetOpenWindowfeature(340, 480));
		        try { SelectTaskCategory_Cross.focus(); } catch (e) {
		        }
		    }
		    
		    function btnSelPCode_onclick_Complete(retVal) {
		        if (retVal != "cancel" && retVal.length == 8) {
		            tbPCateCode.value = retVal;
		        }
		    }
		    
		    function btnOk_onclick() {
		        var tempCode = trim(tbCateCode.value);
		        
		        if (tempCode == "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t719' />");
		            return;
		        } else if (tempCode.length != 8) {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t724' />");
		            return;
		        }

		        if (trim(tbCateName.value) == "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t725' />");
		            return;
		        }
		        
		        if (trim(tbCateName2.value) == "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.lhj06' />");
		            return;
		        }

		        if (trim(tbCateDesc.value) == "") {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t726' />");
		            return;
		        }

		        if (gState == "I") {
		            if (!btnDuplicateHidden_onclick()) {
		                return;
		            }
		        }
		        
		        var gRtnVal = UpdateCategory();
		        
		        if (gRtnVal == "TRUE") {
		            reParam[0] = "TRUE";
		            reParam[1] = trim(tbCateName.value);
		            reParam[2] = tbCateType.value;
		            reParam[3] = trim(tbCateCode.value);
		            reParam[4] = trim(tbCateDesc.value);
		            reParam[5] = tbPCateCode.value;
		            reParam[6] = trim(tbCateName2.value);
		            ReturnFunction(reParam);
		            window.close();
		        } else {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t727' />");
		        }
		    }
		    
		    function btncancel_onclick() {
		        if (CrossYN()) {
		            ReturnFunction(reParam);
		        }
		        
		        window.close();
		    }
		    
		    function UpdateCategory() {
		    	var retVal = "";
		    	
		    	$.ajax({
					type : "POST",
		        	url : "/admin/ezApprovalG/setTaskCategory.do",
		        	async : false,
		        	data : {
		        		categoryType : document.getElementById("tbCateType").value,
		        		categoryCode : document.getElementById("tbCateCode").value,
		        		categoryName : document.getElementById("tbCateName").value,
		        		categoryName2 : document.getElementById("tbCateName").value,
		        		categoryDesc : document.getElementById("tbCateDesc").value,
		        		pCode : document.getElementById("tbPCateCode").value,
		        		companyID : companyID
		        		},
		        	success : function(result) {
		        		retVal = result;
		        	}
				});
		    	
		    	return retVal;
		    }
		</script>
	</head>
	<body>
		<h1><c:out value = '${title}' /></h1>
		<span style="color:red"><spring:message code = 'ezApprovalG.t00011' /></span>
		<table class="content">
		  <tr>
		    <th><spring:message code = 'ezApprovalG.t728' /></th>
		    <td><select id="tbCateType" name="select" style="width:85px;" disabled="disabled">
		        <OPTION value="1"><spring:message code = 'ezApprovalG.t691' /></OPTION>
		        <OPTION value="2"><spring:message code = 'ezApprovalG.t692' /></OPTION>
		        <OPTION value="3"><spring:message code = 'ezApprovalG.t693' /></OPTION>
		      </select>
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code = 'ezApprovalG.t729' /> <span style="color:red">*</span></th>
		    <td><input type="text" id="tbCateCode" name="tbCateCode" style="WIDTH:206px" maxlength="8">
		    <a class="imgbtn"><span onClick="return btnDuplicate_onclick()"><spring:message code = 'ezApprovalG.t730' /></span></a>
		
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code = 'ezApprovalG.t731' />(<spring:message code = 'ezApprovalG.t1764' />)<span style="color:red">*</span></th>
		    <td><input type="text" id="tbCateName" name="tbCateName" style="WIDTH:100%;box-sizing:border-box;-moz-box-sizing:border-box;" maxlength="10"/>
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code = 'ezApprovalG.t1762' /> <span style="color:red">*</span></th>
		    <td><input type="text" id="tbCateName2" name="tbCateName2" style="WIDTH:100%;box-sizing:border-box;-moz-box-sizing:border-box;" maxlength="100"/>
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code = 'ezApprovalG.t732' /> <span style="color:red">*</span></th>
		    <td><input type="text" id="tbCateDesc" name="tbCateDesc" style="WIDTH:100%;box-sizing:border-box;-moz-box-sizing:border-box;" maxlength="50">
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code = 'ezApprovalG.t733' /></th>
		    <td><input type="text" id="tbPCateCode"  name="tbPCateCode" style="WIDTH:206px" readonly="true">
		        <a class="imgbtn"><span id="btnSelPCode"  onClick="return btnSelPCode_onclick()"><spring:message code = 'ezApprovalG.t690' /></span></a>
		    </td>
		  </tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn"><span onClick="return btnOk_onclick()"><spring:message code = 'ezApprovalG.t413' /></span></a>
		    <a class="imgbtn"><span onClick="return btncancel_onclick()"><spring:message code = 'ezApprovalG.t414' /></span></a>
		</div>
	</body>
</html>