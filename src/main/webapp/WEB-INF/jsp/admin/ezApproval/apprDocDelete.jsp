<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<HTML>
	<HEAD>
		<title><spring:message code='ezApproval.t633'/></title>
		<link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
		<script type="text/javascript" src="/js/ezApproval/admin/DocDelete_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApproval/admin/Pagenation_Cross.js"></script>
		<SCRIPT type="text/javascript" ID="clientEventHandlersJS" >
		    var xmlhttp = createXMLHttpRequest(); 
		    var xmldoc = createXmlDom(); 
		    var Check = false, PeriodDocList;
		    var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, DocListType;
		    var NodeList2, PageSize, ListView, ScontID, CellList;
		    var ScompanyID = "";
		    var Resultxml = createXmlDom();
		    var ListIdx;
		    var listview = new ListView();
		    var listview2 = new ListView();
		    var text1 = "<spring:message code='ezApproval.t434'/>";
		    var text2 = "<spring:message code='ezApproval.t911'/>";
		    var deleteTimes = 0;
		    
		    var SearchCond = new Array();
		    var spPage = 10;
		    var pUse_Editor = "${useEditor}";
		    function window_onload() {
		        ScompanyID = document.getElementById("ListCompany").value;
		        document.getElementById('lvSDoc').innerHTML = "";
		        document.getElementById('lvTDoc').innerHTML = "";
		
		        listview.SetID("lvSDocForm");
		        listview.SetMulSelectable(true);
		        
		        listview.SetRowOnClick("lvSDoc_onSel_Click");            
		        listview.SetRowOnDblClick("lvSDoc_onSel_DBclick");       
		        listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));                            
		        listview.DataBind("lvSDoc");                        
		
		        listview2.SetID("lvTDocForm");
		        listview2.SetMulSelectable(true);
		        
		        listview2.SetRowOnDblClick("lvTDoc_onSel_DBclick");       
		        listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));                            
		        listview2.DataBind("lvTDoc");                        
		
		        
		        document.getElementsByName('SDeptName')[0].value = "";
		
		        PageSize = 300;
		        pChackYN = "FALSE";    
		    }
		
		    function lvSDoc_onSel_Changed() {
		    }
		
		    function lvSDoc_onSel_Click() {
		    }
		
		    function lvSDoc_onSel_DBclick() {
		        listview.LoadFromID("lvSDocForm");
		        listview2.LoadFromID("lvTDocForm");
		        var openLocation = "";
		        var oArrRows = listview.GetSelectedRows();
		        var length = listview.GetSelectedIndexes();
		        var DocID = GetAttribute(oArrRows[0], "DATA1");
		        var pURL = GetAttribute(oArrRows[0], "DATA2");
		        var formID = GetAttribute(oArrRows[0], "DATA6");
		        var orgDocid = GetAttribute(oArrRows[0], "DATA5");
		        if (GetAttribute(oArrRows[0], "DATA5") == "" || escape(orgDocid.replace(/ /gi, "")) == "%0A")
		            orgDocid = "";
		        else
		            orgDocid = GetAttribute(oArrRows[0], "DATA5");
		
		        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
		            openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewEnd_HWP_Cross.aspx";
		        }
		        else {
		            if (CrossYN() || pNoneActiveX == "YES") {
		                openLocation = "/myoffice/ezApproval/formContainer/contDocView_Cross.aspx";
		            }
		            else {
		                if (pUse_Editor == "")
		                    openLocation = "/myoffice/ezApproval/formContainer/contDocView.aspx";
		                else
		                    openLocation = "/myoffice/ezApproval/formContainer/contDocView_IE.aspx";
		            }
		        }
		        openLocation = openLocation + "?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL) + "&formID=" + escape(formID) + "&orgDocid=" + escape(orgDocid);
		        var result = GetOpenWindow(openLocation, "", 1000, 950, "YES");
		    }
		
		    function lvSDoc_onclick() {
		    }
		
		    function lvTDoc_onSel_Changed() {
		    }
		
		    function lvTDoc_onSel_Click() {
		    }
		
		    function lvTDoc_onSel_DBclick() {
		        del_AfterSort();
		    }
		
		    function lvTDoc_onclick() {
		    }
		
		    var organ_dialogArguments = new Array();
		    function bt_SDeptSelect_onclick() {
		        organ_dialogArguments[0] = ScompanyID;
		        organ_dialogArguments[1] = bt_SDeptSelect_onclick_Complete;
		        var result = GetOpenWindow("/admin/ezApproval/organ.do", "Organ_Cross", 290, 525, "NO");
		    }
		
		    function bt_SDeptSelect_onclick_Complete(retVal) {
		        if (retVal[0] != "") {
		            document.getElementsByName('SDeptName')[0].id = retVal[0];
		            document.getElementsByName('SDeptName')[0].value = retVal[1];
		            pChackYN == "FALSE"
		        }
		        getDocType();
		        ScontID = document.getElementsByName('selSContName')[0].value;
		        getDocList();
		    }
		
		    function bt_selSPeriod_onclick() {
		        if (document.getElementsByName('SDeptName')[0].value != "")
		            getDocList();
		    }
		
		    function bt_selSContName_onclick() {
		        if (document.getElementsByName('selSContName')[0].value != ScontID) {
		            ScontID = document.getElementsByName('selSContName')[0].value;
		            
		            pChackYN == "FALSE"
		            getDocList();
		        }
		    }
		
		    function btnIns_onclick() {
		        if (document.getElementById('DelALL').checked == false)
		            DocMove();
		    }
		
		    function btndel_onclick() {
		        del_AfterSort();
		    }
		    
		    function del_AfterSort() {
		        listview.LoadFromID("lvSDocForm");
		        listview2.LoadFromID("lvTDocForm");
		        var length = listview.GetRowCount(); 
		        var length2 = listview2.GetRowCount();  
		        var selLength = listview2.GetSelectedRows().length; 
		        var unSelLength = length2 - selLength; 
		        var unSelRows = listview2.GetUnSelectedIndexes().split(","); 
		        var count1;
		        var i = 0;
		        var xmlRtn = createXmlDom();
		
		        if (document.getElementById('DelALL').checked == false) {
		            if (length > 0 && selLength > 0) {
		                var DocID = new Array();
		                var DocName = new Array();
		                var DocNum = new Array();
		
		                
		                for (count1 = 0 ; count1 < unSelLength	; count1++) {
		                    DocID[i] = GetAttribute(listview2.GetDataRows()[unSelRows[i]], "DATA1");
		                    DocName[i] = getNodeText(listview2.GetDataRows()[unSelRows[i]].cells[1]);
		                    DocNum[i] = getNodeText(listview2.GetDataRows()[unSelRows[i]].cells[0]);
		                    i++;
		                }
		                i = 0;
		
		                
		                for (count1 = length2 - 1 ; count1 >= 0 ; count1--) {
		                    var tr = listview2.GetDataRows()[count1];
		                    listview2.DeleteRow(GetAttribute(tr, "id"));
		                }
		
		                
		                for (count1 = 0 ; count1 < unSelLength ; count1++) {
		                    var strXML = listAdd(DocNum[i], DocName[i], DocID[i]);
		                    var objTr = listview2.AddRow(i);
		                    SetAttribute(objTr, "id", "lvTDocForm" + "_TR_" + i);
		                    xmlRtn = loadXMLString(strXML);
		                    listview2.AddDataRow(objTr, xmlRtn);
		                    i++;
		                }
		            }
		            else
		                alert("<spring:message code='ezApproval.t232'/>");
		        }
		    }
		
		    function btnTotalIns_onclick() {
		        if (document.getElementById('DelALL').checked == false)
		            DocTotalMove();
		    }
		
		    function btnOK_onclick() {
		        listview2.LoadFromID("lvTDocForm");
		        var noItems = document.getElementById("lvTDocForm").rows[1].id.indexOf("TR_noItems");
		        var length = listview2.GetRowCount();

		        if (document.getElementById('DelALL').checked != true) {
		            if (noItems < 0 && length > 0 && Check == false) {
		                DocDel();
		                getDocList();
		            }
		            else
		                alert("<spring:message code='ezApproval.t634'/>");
		        }
		        else {
		            if (Check == false) {
		                DocDel();
		                getDocList();
		            }
		        }
		    }
		
		    function btnCancle_onclick() {
		        window.close();
		    }
		
		    function btn_DocYear() {
		        getDocList();
		    }
		
		    function selSContName_onchange() {
		        bt_selSContName_onclick();
		    }
		
		    
		    function changeCompID() {
		        if (ScompanyID != document.getElementById("ListCompany").value) {
		            ScompanyID = document.getElementById("ListCompany").value;
		
		            listview.LoadFromID("lvSDocForm");
		            listview2.LoadFromID("lvTDocForm");
		
		            document.getElementById('lvSDoc').innerHTML = "";
		            document.getElementById('lvTDoc').innerHTML = "";
		
		            listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
		            listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
		
		            listview.DataBind("lvSDoc");
		            listview2.DataBind("lvTDoc");
		            
		            document.getElementsByName('SDeptName').value = "";
		        }
		    }
		
		    var ezStatisticsSearch_dialogArguments = new Array();
		    function SearchCondi_onclick() {
		        ezStatisticsSearch_dialogArguments[1] = SearchCondi_onclick_Complete;
		        if (document.getElementsByName('SDeptName')[0].value == "") {
		            alert("<spring:message code='ezApproval.t345'/>");
		            return;
		        }
		        var url = "/admin/ezApproval/ezStatisticsSearch.do?ingFlag=END";
		        var result = GetOpenWindow(url, "ezStatisticsSearch", 500, 330, "NO");
		    }
		    function SearchCondi_onclick_Complete(retVal) {
		        if (retVal) {
		            pChackYN = "SEARCH";
		            for (i = 0; i < 11; i++)
		                SearchCond[i] = retVal[i];
		            getDocList();
		        }
		    }
		</script>
	</head>
	
	<body class="mainbody" onLoad="javascript:window_onload()">
		<xml id="FORMLIST" style="display:none";>
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t434'/></NAME>
		        <WIDTH>150</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t911'/></NAME>
		        <WIDTH>210</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		
		<h1><spring:message code='ezApproval.t633'/></h1>
		<span><b><spring:message code='ezApproval.t378'/></b>
              <select id="ListCompany" name="ListCompany" onchange="return changeCompID()">
    				${companySel}
			  </select>
		</span>
		<table class="content" style="margin-top:10px;width:754px">
		  <tr>
		    <th><spring:message code='ezApproval.t344'/></th>
		    <td><input type="text" name="SDeptName" style="WIDTH:150px">
		        <a class="imgbtn"  name="SDeptSelect"><span onClick="return bt_SDeptSelect_onclick()"><spring:message code='ezApproval.t344'/></span></a>
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code='ezApproval.t611'/></th>
		    <td><select id="selSContName" name="selSContName" style="WIDTH:150px" onChange="return selSContName_onchange()">
		      </select>
		    <a class="imgbtn"  name="Search"><span onClick="return SearchCondi_onclick()"><spring:message code='ezApproval.t236'/></span></a>
		  </tr>
		  <tr style="DISPLAY:none">
		    <th ><spring:message code='ezApproval.t636'/></th>
		    <td><input type="text" id="DocYear" size="4">
		      <spring:message code='ezApproval.t394'/>
		      <a class="imgbtn"  name="btn_DocYear"><span onClick="return btn_DocYear()"><spring:message code='ezApproval.t236'/></span></a>
		  <tr>
		    <th ><spring:message code='ezApproval.t637'/></th>
		    <td><select id="selSPeriod" style="WIDTH:150px" name="selSPeriod" onchange="return bt_selSPeriod_onclick()">
		        <option value="" selected><spring:message code='ezApproval.t604'/></option>
		        ${periodNode}
		      </select>
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code='ezApproval.t638'/></th>
		    <td><input type="checkbox" id="DelALL" name="DelALL">
		    </td>
		  </tr>
		</table>
		<br>
		<table>
		  <tr id="PageNum">
		  </tr>
		</table>
		<table>
		  <tr>
		    <td>
		      <div class="listview">
		        <DIV id="lvSDoc" style="BORDER:0; WIDTH: 360px; HEIGHT: 270px ; overflow-x:scroll;overflow-y:hidden"> </DIV>
		      </div></td>
		    <td style="width:30px;text-align:center"><img src="/images/arr_right.gif" style="cursor:pointer" width="16" height="16"  onClick="return btnIns_onclick()"><br>
		      <img src="/images/arr_left.gif" style="cursor:pointer" width="16" height="16"  onClick="return btndel_onclick()"><br>
		      <br>
		      <br>
		      <br><img src="/images/arr_rright.gif" style="cursor:pointer" width="16" height="16"  onClick="return btnTotalIns_onclick()"><br></td>
		    <td>
			  <div class="listview">
		      <DIV id="lvTDoc" style="BORDER:0; WIDTH: 360px;HEIGHT: 270px;overflow-x:hidden;overflow-y:auto" > </DIV></div></td>
		  </tr>
		</table>
		<div class="btnposition" style="width:754px; text-align:center;" >
		    <a class="imgbtn" onclick="btnOK_onclick()"><span><spring:message code='ezApproval.t272'/></span></a>
		</div>
	</body>
</HTML>