<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>        
        <script type="text/javascript" src="/js/ezLadder/ListView_list.js"></script>
		<title><spring:message code='ezSchedule.t53'/></title>
		<script>
			var RetValue;
		    var ReturnFunction;
		    var Resultxml = "";
		    
		    window.onload = function () {
		        try {
		            RetValue = parent.ladder_overlap_dialogArguments[0];
		            ReturnFunction = parent.ladder_overlap_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.ladder_overlap_dialogArguments[0];
		                ReturnFunction = opener.ladder_overlap_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
	
		        var listview = new ListView();
		        listview.SetID("DLList");
		        listview.SetSelectFlag(false); //첫번째값 선택여부 
		        listview.SetMulSelectable(true); //멀티 선택 기능 지정 (true : 멀티선택 가능, false : 멀티선택 불가)
		        listview.SetRowOnDblClick("addAttendant_dbClick"); //로우 더블 클릭 이벤트 핸들러 지정
		        listview.DataSource(loadXMLString(document.getElementById("listviewheader").innerHTML.toUpperCase()));
		        listview.DataBind("ListViewid");
		        listview.RowDataBind("")
		        
		        getOverlapList();
		        initializeReceiverList();
		        
		        
		    }
		    
		    function getOverlapList() {
		    	console.log(RetValue);
		    	var listid = "DLList";
		    	var i = 0;
		    	var len = RetValue["id"].length;
		    	var parsingxml = "";
		    	
		    	parsingxml = "<LISTVIEWDATA2><ROWS>";
		    	for(; i < len; i++) {
		    		parsingxml += "<ROW>";
		    		parsingxml += "<CELL><VALUE><![CDATA[" + RetValue["name"][i] + "]]></VALUE>";
		    		parsingxml += "<DATA1>" + RetValue["id"][i] + "</DATA1>";
		    		parsingxml += "<DATA2><![CDATA[" + RetValue["name"][i] + "]]></DATA2>";
		    		parsingxml += "<DATA3><![CDATA[" + RetValue["name2"][i] + "]]></DATA3>";
		    		parsingxml += "<DATA4><![CDATA[" + RetValue["deptname"][i] + "]]></DATA4>";
		    		parsingxml += "<DATA5><![CDATA[" + RetValue["deptname2"][i] + "]]></DATA5></CELL>";
		    		parsingxml += "<CELL><VALUE><![CDATA[" + RetValue["deptname"][i] + "]]></VALUE></CELL>"
		    		parsingxml += "</ROW>";
		    	}
		    	parsingxml += "</ROWS></LISTVIEWDATA2>";
                Resultxml = loadXMLString(parsingxml);
                console.log(Resultxml);
        		
                var listview = new ListView();
                listview.LoadFromID(listid);

                var MaxID = 0;
                var InitTr = listview.GetDataRows();
                var MaxCntNum = 0;
                for (var j = 0  ; j < InitTr.length  ; j++) {
                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    if (MaxID < curnum) {
                        MaxID = curnum;
                        MaxCntNum = j;
                    }
                }

                var objTr = listview.AddRow(InitTr.length);
                if (MaxCntNum != 0)
                    MaxCntNum = MaxCntNum + 1;
                SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
                listview.AddDataRow(objTr, Resultxml);

                var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
                for (var y = 0; y < _tdlength; y++) {
                    document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
                    document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
                }
		    }
	
		    function initializeReceiverList() {
		        var listview = new ListView();
		        listview.SetID("DLList");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("addAttendant_dbClick");
		        listview.DataSource(Resultxml);
		        listview.RowDataBind();
		    }
		    	
		   	function addAttendant_dbClick() {
		   		
		   	}
		   	
		    function change_onClick() { // 더블클릭 펑션
		    	console.log("change_onClick");
		        var count1;
		        var selectedItemCount;
		        var selRow;
	
		        var pListViewDL = new ListView();
		        pListViewDL.LoadFromID("DLList");
	
		        var arrRows = pListViewDL.GetSelectedRows();
		        selectedItemCount = arrRows.length;
	
		        if (selectedItemCount == 0) {
		            alert("<spring:message code='ezSchedule.t54' />");
				    return;
				}
				else if (selectedItemCount > 1) {
				    alert("<spring:message code='ezSchedule.t55' />");
					    return;
					}
	
		        if (ReturnFunction != null) {
		        	console.log('return function not null');
		            var returnvalue = new Array();
		            returnvalue["id"] = GetAttribute(arrRows[0], "DATA2");
		            returnvalue["name"] = getNodeText(arrRows[0].cells[3]);
		            returnvalue["deptname"] = GetAttribute(arrRows[0], "DATA7");
		            returnvalue["name1"] = GetAttribute(arrRows[0], "DATA5");
		            returnvalue["name2"] = GetAttribute(arrRows[0], "DATA6");
		            returnvalue["deptname2"] = GetAttribute(arrRows[0], "DATA8");
		            ReturnFunction(returnvalue);
		        }
		        else {
		        	console.log('return function is null');
		            dialogArguments["id"] = GetAttribute(arrRows[0], "DATA2");
		            dialogArguments["name"] = getNodeText(arrRows[0].cells[3]);
		            dialogArguments["deptname"] = GetAttribute(arrRows[0], "DATA7");
		            dialogArguments["name1"] = GetAttribute(arrRows[0], "DATA5");
		            dialogArguments["name2"] = GetAttribute(arrRows[0], "DATA6");
		            dialogArguments["deptname2"] = GetAttribute(arrRows[0], "DATA8");
		            window.close();
		        }
		    }
	
		    function delete_onClick() {
		        if (ReturnFunction != null) {
		            var returnvalue = new Array();
		            returnvalue["recipientTDData"] = "delete";
		            ReturnFunction(returnvalue);
		            parent.DivPopUpHidden();
		        }
		        else {
		            dialogArguments["recipientTDData"] = "delete";
		            window.close();
		        }
		    }
	
		    function cancel_onClick() {
		        if (ReturnFunction != null) {
		            var returnvalue = new Array();
		            returnvalue["recipientTDData"] = "dontprocess";
		            returnvalue["name"] = "";
	
		            ReturnFunction(returnvalue);
		            parent.DivPopUpHidden();
		        }
		        else {
		            dialogArguments["recipientTDData"] = "dontprocess";
		        }
	            window.close();
		    }
		</script>
	</head>	
	<body class="popup"> 
	    <xml id="listviewheader" style="display: none"> 
	        <LISTVIEWDATA> 
	            <HEADERS> 
	                <HEADER> 
	                    <TYPE>NONE</TYPE> 
	                    <NAME>이름</NAME> 
	                    <WIDTH>100</WIDTH> 
	                    <SORTABLE>TRUE</SORTABLE> 
	                    <RESIZIBLE>FALSE</RESIZIBLE> 
	                    <MINSIZE>10</MINSIZE> 
	                    <MAXSIZE>200</MAXSIZE> 
	                    <NOWRAP>TRUE</NOWRAP>
	                </HEADER> 
	                <HEADER> 
	                    <NAME>부서</NAME> 
	                    <WIDTH>90</WIDTH>
	                </HEADER> 
	            </HEADERS>
	        </LISTVIEWDATA>
	    </xml>
		<object style="display:none" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" id="ListViewBehave" height="0px" width="0px" VIEWASTEXT> </object> 
		<h1><spring:message code='ezSchedule.t53' /></h1>
		<h2><spring:message code='ezSchedule.t58' /></h2>
		<div class="listview" style="overflow:auto;">
			<div id="ListViewid" STYLE="Width:570px; Height:195px; border:0px;overflow:auto"></div>
		</div>
		<div class="btnposition">
		    <a class="imgbtn" name="button2" onClick="change_onClick()" ><span><spring:message code='ezSchedule.t4' /></span></a>
		    <a class="imgbtn" name="button3" onClick="cancel_onClick()" ><span><spring:message code='ezSchedule.t5' /></span></a>
		</div>
	</body>
</html>