<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezTask.t11' /></title>
		<link rel="stylesheet" href="${util.addVer('ezTask.e1', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type = "text/javascript" src="${util.addVer('/js/ezTask/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type ="text/javascript">
		    var ReturnFunction;
		    /* 2018-04-26 김민성 - RetValue, openerFlag 추가 */
		    var RetValue;
		    var openerFlag = false;

			window.onload = function() {		
			    try {
			    	RetValue = parent.checkname2_cross_dialogArguments[0];
			        ReturnFunction = parent.checkname2_cross_dialogArguments[1];
			    }
			    catch (e) {
			    	try {
		            	RetValue = opener.checkname2_cross_dialogArguments[0];
	    	            ReturnFunction = opener.checkname2_cross_dialogArguments[1];
		                openerFlag = true;
		            } catch (e) {
		                openerFlag = false;
		            }
			    }

			    initializeReceiverList();		
			}
		
			function initializeReceiverList() {
		        var xmlpara = loadXMLString(listviewheader.innerHTML.toUpperCase());
		        document.getElementById("lvtDoclist").innerHTML = "";
		        var listView = new ListView();
		        listView.SetID("DocList");
				listView.DataSource(xmlpara);
				listView.DataBind("lvtDoclist"); 
				
				SetDataSource();
			}
			
			function SetDataSource() {
			    var tempXML;
			    
			    tempXML = SelectSingleNodeNew(RetValue["addrBook"], "LISTVIEWDATA/ROWS");

			    if (tempXML == null) {
			        return;
				}

				var DocList = new ListView();                          
			    DocList.LoadFromID("DocList"); 
			    DocList.SetRowOnDblClick("change_onClick");			
			    var tempRow;
			    var currentRowNumber = 0;

			    for (var i=0; i<tempXML.childNodes.length; ++i){
			        if (tempXML.childNodes[i].nodeType == 1) {
		                tempRow = tempXML.childNodes[i];
		                var objTr = DocList.AddRow(currentRowNumber);
		                DocList.AddDataRow(objTr,tempRow); 
		                currentRowNumber++;
		            }
			    }           
			    DocList = null;	
		        }    
		        
			/* function selectuser(){
			    var SelList = new ListView();
		        SelList.LoadFromID("DocList");
		        var tr = SelList.GetSelectedRows();
		        if (tr.length == 0) {
					alert("<spring:message code='ezTask.t193' />");
					return;
				}
				if (tr.length > 1) {
					alert("<spring:message code='ezTask.t194' />");
					return;
				}
				
				var selRow = tr[0];
				
				if (ReturnFunction != null) {
				    ReturnFunction(GetAttribute(selRow,"DATA2"));
				} else {
				    dialogArguments["deptid"] = GetAttribute(selRow,"DATA2");
				    window.close();
				}
			} */

			function change_onClick() {
				var count1;
				var selectedItemCount;
				var selRow;

			    var DocList = new ListView();
			    DocList.LoadFromID("DocList");

			    var selRow = DocList.GetSelectedRows();
				selectedItemCount = selRow.length;

				if (selectedItemCount == 0) {
					alert("<spring:message code='ezTask.t12' />");
					return;
				} else if (selectedItemCount > 1) {
					alert("<spring:message code='ezTask.t13' />");
					return;
				}

			    if (ReturnFunction != null) {
			        ReturnFunction(GetAttribute(selRow[0],"DATA2"));
			        /* 18-04-26 김민성 - 부서 선택 후 창 닫기 */
			        if (openerFlag){
			            window.close();
			        }
			    } else {
			        dialogArguments["deptid"] = GetAttribute(selRow[0],"DATA2");
			        window.close();
			    }
			}

			/* function delete_onClick() {
			    if (ReturnFunction != null) {
				    ReturnFunction("delete");
				} else {
				    dialogArguments["recipientTDData"] = "delete";
				    window.close();
				}
			} */

			function cancel_onClick() {
			    if (ReturnFunction != null) {
				    ReturnFunction("dontprocess");
				    /* 18-04-26 김민성 - 부서 선택 취소시 창 닫기 */
				    if (openerFlag){
			            window.close();
			        }
				} else {
				    dialogArguments["recipientTDData"] = "dontprocess";
				    window.close();
				}
			}
		</script>
	</head>
	<body class="popup"> 
		<xml id="listviewheader" style="display:none"> 
		    <LISTVIEWDATA> 
		        <HEADERS> 
		            <HEADER> 
		                <TYPE>sNONE</TYPE> 
		                <NAME><spring:message code='ezTask.t14' /></NAME>
		                <WIDTH>100</WIDTH> 
		                <SORTABLE>TRUE</SORTABLE>
		                <RESIZIBLE>FALSE</RESIZIBLE>
		                <MINSIZE>10</MINSIZE>
		                <MAXSIZE>200</MAXSIZE>
		                <NOWRAP>TRUE</NOWRAP> 
		            </HEADER>
		            <HEADER>
		                <NAME><spring:message code='ezTask.t15' /></NAME>
		                <WIDTH>100</WIDTH>
		             </HEADER>
		             <HEADER>
		                <NAME><spring:message code='ezTask.t1006' /></NAME> 
		                <WIDTH>100</WIDTH> 
		             </HEADER>
		        </HEADERS>
		    </LISTVIEWDATA> 
		</xml> 
		<h1><spring:message code='ezTask.t15' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel_onClick()"></span></li>
            </ul>
        </div>
        <div class="listview" style="width:570px; height:195px;" >
            <div id="lvtDoclist" style="width:570px; border:0; height:195px; overflow:AUTO; " ></div>
        </div>	
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" onClick="change_onClick()" ><span><spring:message code='ezTask.t19' /></span></a>
		</div>
	</body>
</html>