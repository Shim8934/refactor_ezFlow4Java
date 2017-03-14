<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t767'/></title>
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApprovalG/admin/MoveContainer_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/admin/Pagenation_Cross.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var xmldoc2 = createXmlDom();
	        var Check = false;
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, DocListType;
	        var NodeList2, PageSize, ListView, ScontID;
	        var P_CompanyID = "";
	        var text1 = "<spring:message code='ezApproval.t434'/>";
	        var text2 = "<spring:message code='ezApproval.t911'/>";
	        var SearchCond = new Array();
	        window.onload = function () {
	            P_CompanyID = document.getElementById("ListCompany").value;
	            document.getElementById('lvSDoc').innerHTML = "";
	            document.getElementById('lvTDoc').innerHTML = "";
	
	            listview = new ListView();
	            listview.SetID("lvSDocForm");
	            listview.SetMulSelectable(true);
	            listview.SetRowOnClick("lvSDoc_onSel_Click");            
	            listview.SetRowOnDblClick("lvSDoc_onSel_DBclick");       
	            listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));                           
	            listview.DataBind("lvSDoc");
	
	            listview2 = new ListView();
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
	            if (trim_Cross(GetAttribute(oArrRows[0], "DATA5")) == "" || escape(orgDocid.replace(/ /gi, "")) == "%0A")
	                orgDocid = "";
	            else
	                orgDocid = GetAttribute(oArrRows[0], "DATA5");
	
	            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	                openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewEnd_HWP_Cross.aspx";
	            }
	            else {
	                if (CrossYN()) {
	                    openLocation = "/admin/ezApproval/contDocView.do";
	                } else {
	                    if (pUse_Editor == "")
	                        openLocation = "/myoffice/ezApproval/formContainer/contDocView.aspx";
	                    else
	                        openLocation = "/myoffice/ezApproval/formContainer/contDocView_IE.aspx";
	                }
	            }
	            openLocation = openLocation + "?docID=" + escape(DocID) + "&docHref=" + escape(pURL) + "&formID=" + escape(formID) + "&orgDocID=" + escape(orgDocid);
	            var result = GetOpenWindow(openLocation, "", 1000, 950, "YES");
	        }
	        
	        function lvSDoc_onclick() {
	        }
	
	        function lvTDoc_onSel_Changed() {
	        }
	
	        function lvTDoc_onSel_Click() {
	        }
	
	        function lvTDoc_onSel_DBclick() {
	        }
	
	        function lvTDoc_onclick() {
	        }
	
	        var organ_dialogArguments = new Array();
	        function bt_SDeptSelect_onclick() {
	            organ_dialogArguments[0] = P_CompanyID;
	            organ_dialogArguments[1] = bt_SDeptSelect_onclick_Complete;
	            var result = GetOpenWindow("/admin/ezApprovalG/apprGOrgan.do", "Organ_Cross", 290, 525, "NO");
	        }
	
	        function bt_SDeptSelect_onclick_Complete(retVal) {
	            var Flag;
	            if (typeof (retVal) != "undefined") {
	                document.getElementsByName("SDeptName")[0].id = retVal[0];
	                document.getElementsByName("SDeptName")[0].value = retVal[1];
	                pChackYN == "FALSE"
	            }
	            Flag = "SDeptName";
	            getDocType(Flag);
	            ScontID = document.getElementsByName("selSContName")[0].value;
	
	            getDocList();
	        }
	
	        function bt_TDeptSelect_onclick() {
	            organ_dialogArguments[0] = P_CompanyID;
	            organ_dialogArguments[1] = bt_TDeptSelect_onclick_Complete;
	            var result = GetOpenWindow("organ.do", "Organ_Cross", 290, 525, "NO");
	        }
	        
	        function bt_TDeptSelect_onclick_Complete(retVal) {
	            var Flag;
	            if (typeof (retVal) != "undefined") {
	                document.getElementsByName("TDeptName")[0].id = retVal[0];
	                document.getElementsByName("TDeptName")[0].value = retVal[1];
	            }
	            Flag = "TDeptName";
	            getDocType(Flag);
	        }	
	
	        function bt_selSContName_onclick() {
	            if (document.getElementsByName("selSContName")[0].value != ScontID) {
	                ScontID = document.getElementsByName("selSContName")[0].value;
	                pChackYN == "FALSE"
	                getDocList();
	            }
	        }
	
	        function bt_selTContName_onclick() {
	
	            var TcontID = document.getElementsByName("selTContName")[0].value;
	            Check = false;
	        }
	
	        function btnIns_onclick() {
	            if (MoveALL.checked == false)
	                DocMove();
	        }	
	
	        function btndel_onclick() {
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
	
	            if (document.getElementById("MoveALL").checked == false) {
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
			    if (MoveALL.checked == false)
			        DocTotalMove();
			}
			
			function bt_OK_onclick() {
			    listview2.LoadFromID("lvTDocForm");
			    var noItems = document.getElementById("lvTDocForm").rows[1].id.indexOf("TR_noItems");
			    var length = listview2.GetRowCount();
			
			    if (MoveALL.checked != true) {
			        if (noItems < 0 && length > 0 && Check == false) {
			            if (document.getElementsByName("selTContName")[0].value == "")
			                alert("<spring:message code='ezApproval.t769'/>")
						else {
						    var Ans = confirm("<spring:message code='ezApproval.t770'/>");
						    if (Ans) {
						        ContMove();
						        getDocList();
						    }
						}
			        }
			        else
			            alert("<spring:message code='ezApproval.t634'/>");
			    }
			    else {
			        if (Check == false) {
			            if (document.getElementsByName("selTContName")[0].value == "")
			                alert("<spring:message code='ezApproval.t769'/>")
						else {
						    var Ans = confirm("<spring:message code='ezApproval.t770'/>");
						    if (Ans) {
						        ContMove();
						        getDocList();
						    }
						}
			        }
			    }
			}
			
			function bt_Cancle_onclick() {
			    window.close();
			}			
			
			function changeCompID() {
			    if (P_CompanyID != document.getElementById("ListCompany").value) {
			        P_CompanyID = document.getElementById("ListCompany").value;
			
			        lvSDoc.DataSource = FORMLIST;
			        lvTDoc.DataSource = FORMLIST;
			
			        document.getElementsByName('SDeptName').value = "";
			        document.getElementsByName('TDeptName').value = "";
			    }
			}
			
			var ezStatisticsSearch_dialogArguments = new Array();
			function SearchCondi_onclick() {
			    if (document.getElementsByName('SDeptName')[0].value == "") {
			        alert("<spring:message code='ezApproval.t345'/>");
			        return;
			    }
			
			    var url = "/admin/ezApproval/ezStatisticsSearch.do?ingFlag=END";
			    ezStatisticsSearch_dialogArguments[1] = SearchCondi_onclick_Complete;
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
	
	<body class="mainbody">
		<xml id='FORMLIST' style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezApproval.t434'/></NAME>
						<WIDTH>135</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezApproval.t911'/></NAME>
						<WIDTH>205</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
	    <h1><spring:message code='ezApproval.t771'/></h1>
	   	<span>
	   		<b><spring:message code='ezApproval.t378'/></b>
            <select id="ListCompany" name="ListCompany" onchange="return changeCompID()">
      			${companySel}
  			</select>
	    </span>
	    <table class="table_manage">
	        <tr>
	            <td>
	                <table class="content" style="width: 368px">
	                    <tr>
	                        <th><spring:message code='ezApproval.t344'/></th>
	                        <td>
	                            <input type="text" id="SDeptName" name="SDeptName" style="WIDTH: 130px" readonly="true" />
	                            <a class="imgbtn" name="SDeptSelect"><span onclick="return bt_SDeptSelect_onclick()"><spring:message code='ezApproval.t344'/></span></a>
							</td>   
	                    </tr>
	                    <tr>
	                        <th style="white-space: nowrap"><spring:message code='ezApproval.t611'/></th>
	                        <td>
	                            <select name="selSContName" style="WIDTH: 150px" onchange="return bt_selSContName_onclick()"></select>
	                            <a class="imgbtn" name="Search"><span onclick="return SearchCondi_onclick()"><spring:message code='ezApproval.t236'/></span></a>
							</td>
	                    </tr>
	                    <tr>
	                        <th style="white-space: nowrap"><spring:message code='ezApproval.t772'/></th>
	                        <td>
	                            <input type="checkbox" id="MoveALL" name="MoveALL" />
							</td>
	                    </tr>
	                </table>
	            </td>
	            <td style="width: 30px">&nbsp;</td>
	            <td style="vertical-align: bottom">
	                <table class="content" style="width: 368px">
	                    <tr>
	                        <th><spring:message code='ezApproval.t344'/></th>
	                        <td>
	                            <input type="text" name="TDeptName" style="WIDTH: 130px;" readonly="true" />
	                            <a class="imgbtn" name="TDeptSelect"><span onclick="return bt_TDeptSelect_onclick()"><spring:message code='ezApproval.t344'/></span></a>
	                        </td>    
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApproval.t611'/></th>
	                        <td>
	                            <select name="selTContName" style="WIDTH: 150px" onclick="return bt_selTContName_onclick()"></select>
							</td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <br/>
	    <table>
	        <tr id="PageNum"></tr>
	    </table>
	    <table>
	        <tr>
	            <td>
	                <div class="listview">
	                    <div id="lvSDoc" style="BORDER: 0; HEIGHT: 270px; WIDTH: 367px; overflow-x: scroll; overflow-y: hidden" onclick="lvSDoc_onclick()" onrowdblclick="lvSDoc_onSel_DBclick()" onseldblclick="lvSDoc_onSel_DBclick()" onselclick="lvSDoc_onSel_Click()" onrowclick="lvSDoc_onSel_Click()" onselchanged="lvSDoc_onSel_Changed()"></div>
	                </div>
	            </td>
	            <td style="text-align: center; width: 30px">
	                <img height="16" id="arrow_right" onclick="return  btnIns_onclick()" src="/images/arr_right.gif" style="cursor: pointer" width="16" /><br/>
	                <img height="16" id="arrow_left" onclick="return  btndel_onclick()" src="/images/arr_left.gif" style="cursor: pointer" width="16" /><br/>
	                <br/>
	                <br/>
	                <br/>
	                <img height="16" id="arrow_all" onclick="return btnTotalIns_onclick()" src="/images/arr_rright.gif" style="cursor: pointer" width="16"/>
				</td>
	            <td>
	                <div class="listview">
	                    <div id="lvTDoc" style="BORDER: 0; HEIGHT: 270px; WIDTH: 365px; overflow-x: hidden; overflow-y: auto"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition" style="width: 756px; text-align: center;">
	        <a class="imgbtn" onclick="bt_OK_onclick()"><span><spring:message code='ezApproval.t272'/></span></a>
	    </div>
	</body>
</html>