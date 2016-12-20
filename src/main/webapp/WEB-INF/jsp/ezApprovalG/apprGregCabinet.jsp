<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t1037'/></title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/RegCabinet_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/CabCategoryInfo_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/InitSCPopup_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>

<script ID="clientEventHandlersJS"  type="text/javascript">
	var OrderCell = "";    
   	var xmlhttp = createXMLHttpRequest();
    var pUserID = "${userInfo.id}";
    var CompanyID = "${userInfo.companyID}";
    var arr_userinfo = new Array();
    arr_userinfo[0]  = "user";
    arr_userinfo[1]  = "<c:out value = '${userInfo.id}'/>";
    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName}'/>";
    arr_userinfo[3]  = "<c:out value = '${userInfo.title}'/>";
    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";
    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName}'/>";
    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek}'/>";
    arr_userinfo[8]  = "<c:out value = '${userInfo.email}'/>";
    arr_userinfo[9]  = CompanyID;
    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1}'/>";
    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2}'/>";
    arr_userinfo[13]  = "<c:out value = '${userInfo.title1}'/>";
    arr_userinfo[14]  = "<c:out value = '${userInfo.title2}'/>";
    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1}'/>";
    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2}'/>";
    var UserLang = "${userInfo.lang}";
    var rtnVal = new Array();
     window.onload = function (){
        var ua = navigator.userAgent;
        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            KeEventControl(document.getElementById("txtTitle"));
            KeEventControl(document.getElementById("txtTitle2"));
        }
        try {
            RetValue = parent.regcabinet_cross_dialogArguments[0];
            ReturnFunction = parent.regcabinet_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.regcabinet_cross_dialogArguments[0];
                ReturnFunction = opener.regcabinet_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }

        if (RetValue != null) {
            g_InitFlag = RetValue[0];

            if (g_InitFlag == "1") {
                arrTask[0] = RetValue[1];
                arrCategory[0] = RetValue[2];
                arrCategory[2] = RetValue[3];

                SelectCategory(arrCategory[2]);
            }
        }

        rtnVal[0] = "FALSE";

        pOwnerID = arr_userinfo[1];
        pOwnerName = arr_userinfo[2];
        txtOwner.value = pOwnerName;

        g_DeptCode = arr_userinfo[4];
        g_DeptName = arr_userinfo[5];

        InitCode();
        InitCategorySelection();
        selTaskCategory_onchange();
    }
     
     var AddSpecialCatalog_Cross_dialogArguments = new Array();
     function btnAddSpecialCatalog_onclick() {
         var para = new Array();
         para[0] = g_szSCListXml;
         para[1] = g_arrSCName[0];
         para[2] = g_arrSCName[1];
         para[3] = g_arrSCName[2];
         var url = "/ezApprovalG/insSpecialList.do";
         var rtn;
         AddSpecialCatalog_Cross_dialogArguments[0] = para;
         AddSpecialCatalog_Cross_dialogArguments[1] = btnAddSpecialCatalog_onclick_Complete;
         var OpenWin;
         
             OpenWin = window.open(url, "AddSpecialCatalog_Cross", GetOpenWindowfeature(500, 435));

         try { OpenWin.focus(); } catch (e) { }
     }
     function btnAddSpecialCatalog_onclick_Complete(rtn) {
     	   DivPopUpHidden();
     	   if (rtn[0] == "TRUE") {
     	        g_szSCListXml = rtn[1];
     	    }
     }
    function TaskList_rowclick() {
        var oList = new ListView();
        oList.LoadFromID("DivTaskList");

        if (oList.GetRowCount() > 0) {
            var selnode = oList.GetSelectedRows()[0];
            if (selnode != null) {
                arrTask[0] = GetAttribute(selnode, "DATA1");
                arrTask[1] = selnode.cells[1].innerText;
                arrTask[2] = GetAttribute(selnode, "DATA3");
                arrTask[3] = GetAttribute(selnode, "DATA2");
                arrTask[4] = GetAttribute(selnode, "DATA9");
                arrTask[5] = GetAttribute(selnode, "DATA10");
                arrTask[6] = GetAttribute(selnode, "DATA11");
                arrTask[7] = GetAttribute(selnode, "DATA12");

                bDisplayFlag = GetAttribute(selnode, "DATA4");
                bSpecialFlag = GetAttribute(selnode, "DATA5");

                g_arrSCName[0] = GetAttribute(selnode, "DATA6");
                g_arrSCName[1] = GetAttribute(selnode, "DATA7");
                g_arrSCName[2] = GetAttribute(selnode, "DATA8");

                InitTaskInfo();
            }
        }
    }
    function cmdCancel_onclick() 
    {
        rtnVal[0]="FALSE";
        window.close();
    }
    function cmdConfirm_onclick()
    { 
        if(typeof(arrTask[0])=="undefined" || arrTask[0]=="" )
        {
            alert("<spring:message code='ezApprovalG.t997'/>");
        }
        else if(txtTitle.value=="")
        {
            alert("<spring:message code='ezApprovalG.t955'/>");
        }
        else if (txtTitle2.value == "")
        {
            alert("<spring:message code='ezApprovalG.t1766'/>");
        }
        else if(selRecTypeCode.value=="")
        {
            alert("<spring:message code='ezApprovalG.t1038'/>");
        }
        else
        {
            if(RegisterCabinet())
            {
                rtnVal[0]="TRUE";
                rtnVal[1]=g_CabID;
                rtnVal[2]=arrTask[0];
                rtnVal[3]=arrCategory[0];
                rtnVal[4]=arrCategory[2];
                window.close();
            }
        }
    }
    window.onunload = function () {
        if (ReturnFunction != null)
            ReturnFunction(rtnVal);
        window.returnValue = rtnVal;
    }
</script>
</head>
<body class="popup">
<!-- <OBJECT classid="clsid:35609FBF-EE92-472F-B72A-599B70D21F9E" id="behave1" style="HEIGHT: 0px; WIDTH: 0px;"> -->
<!-- </OBJECT> -->
<!-- <OBJECT classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" id="behavelist1" style="HEIGHT: 0px; WIDTH: 0px"> -->
<!-- </OBJECT> -->
<h1><spring:message code='ezApprovalG.t1037'/></h1>
<table>
  <tr>
    <td valign="top" style="padding:3"><h2><spring:message code='ezApprovalG.t1039'/></h2>
      <table  class="content">
        <tr>
          <th><spring:message code='ezApprovalG.t592'/></th>
          <td><Select id="selTaskCategory" style="width:100%" LANGUAGE="javascript" onChange="return selTaskCategory_onchange()">
            </Select>
          </td>
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t593'/></th>
          <td><Select id="selTaskMCategory" style="width:100%" LANGUAGE="javascript" onChange="return selTaskMCategory_onchange()">
            </Select>
          </td>
        </tr>
      </table>
      <div class="listview" style="margin-top:5px" >
        <DIV id="TaskSCateList" onClick="TaskSCateList_rowclick()"> </DIV>
      </div></td>
    <td valign="top" style="padding:3"><h2><spring:message code='ezApprovalG.t1040'/></h2>
      <table >
        <tr>
          <th align="left"><a class="imgbtn"><span onClick="return btnFindTask_onclick()"><spring:message code='ezApprovalG.t1041'/></span></a></th>
        </tr>
        <tr>
          <td><div class="listview">
          <div class="listView" style="overflow:auto; border:0;Width:300px; Height:204px">
          <div id="TaskList"  onRowDblClick="" onSelDblClick="" onSelClick=""	onClick="TaskList_rowclick()"> </div>
		  </div>
            </div></td>
        </tr>
      </table></td>
    <td valign="top" style="padding:3"><h2><spring:message code='ezApprovalG.t1018'/></h2>
      <table  class="content">
        <tr>
          <th ><spring:message code='ezApprovalG.t898'/>(<spring:message code='ezApprovalG.t1764'/>)</th>
          <td ><input type="text" name="txtTitle" id="txtTitle" class="text" style="Width:100%; ">
          </td>
        </tr>
          <!-- 20130311 cpno.63-->
        <tr>
          <th ><spring:message code='ezApprovalG.t898'/>(<spring:message code='ezApprovalG.t1765'/>)</th>
          <td ><input type="text" name="txtTitle2" id="txtTitle2" class="text" style="Width:100%; ">
          </td>
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t826'/></th>
          <td><Select id="selRecTypeCode" style="width:100%">
            </Select>
          </td>
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t577'/></th>
          <td id="tdTaskName">
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t117'/></th>
          <td><Select id="selKeepPeriod" style="width:100">
            </Select>
          </td>
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t599'/></th>
          <td id="tdKeepMethod">&nbsp;</td>
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t600'/></th>
          <td id="tdKeepPlace">&nbsp;</td>
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t999'/></th>
          <td><input type="text" name="txtOwner" id="txtOwner" disabled style="Width:100%; "></td>
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t1000'/></th>
          <td><table width="100%">
              <tr>
                <td id="tdSpecialFlag">&nbsp;</td>
                <td width="70"><a class="imgbtn" name="btnAddSC" id="btnAddSC" style="display:none;"><span onClick="return btnAddSpecialCatalog_onclick()" ><spring:message code='ezApprovalG.t268'/></span></a></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <th ><spring:message code='ezApprovalG.t601'/></th>
          <td><table width="100%">
              <tr>
                <td id="tdDisplayFlag">&nbsp;</td>
                <td width="70" id="btnDisplayInfo"><a class="imgbtn"><span onClick="return btnDisplayInfo_onclick()"><spring:message code='ezApprovalG.t1042'/></span></a></td>
              </tr>
            </table></td>
        </tr>
      </table>
	  </td>
  </tr>
</table>
<div class="btnposition">
<a class="imgbtn" name="btnOK" onClick="return cmdConfirm_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
<a class="imgbtn" name="btnCancel" onClick="return cmdCancel_onclick()"><span><spring:message code='ezApprovalG.t119'/></span></a>
</div>
<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
</div>
</body>
</html>
