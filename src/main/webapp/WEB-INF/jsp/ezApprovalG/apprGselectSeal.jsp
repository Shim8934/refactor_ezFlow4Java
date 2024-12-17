<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t436'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AprSign_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ImageView.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var OrderCell = "";
		    var RetValues;
		    var ReturnFunction;
		    var sealType;
		    var orgSealXML;
		    var newSealXML = "";
		    
		    window.onload = function () {
		        try {
		        	sealType = parent.selectSeal_cross_dialogArguments[0]; // 관인타입(회사/부서)
		        	orgSealXML = parent.selectSeal_cross_dialogArguments[1]; // 관인 리스트 XML
		            ReturnFunction = parent.selectSeal_cross_dialogArguments[2]; // 관인선택 완료 후 동작할 함수 (Stamp_OpenUI_complete)
		            RetValues = parent.selectSeal_cross_returnValues; // 부모에게 넘길 값 배열
		        } catch (e) {
		            try {
			        	sealType = opener.selectSeal_cross_dialogArguments[0];
			        	orgSealXML = opener.selectSeal_cross_dialogArguments[1];
			            ReturnFunction = opener.selectSeal_cross_dialogArguments[2];
			            RetValues = opener.selectSeal_cross_returnValues;
		            } catch (e) {}
		        }
		        
		        // 필요하지 않은 XML 값 제거, 리스트뷰 헤더 설정 등의 관인정보 XML 가공 파트
		        newSealXML = "<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code='ezApproval.t361'/></NAME><WIDTH>140</WIDTH></HEADER></HEADERS><ROWS>";
		        
		        var sealLength = SelectNodes(orgSealXML, "ROWS/ROW").length;
		        for (var i = 0; i < sealLength; i ++) {
		        	var selectedXMLCells = GetChildNodes(SelectNodes(orgSealXML, "ROWS/ROW")[i], "CELL");
		        	
		        	newSealXML += "<ROW><CELL>";
		        	newSealXML += "<VALUE>" + MakeXMLString(getNodeText(SelectSingleNode(selectedXMLCells[0], "VALUE"))) + "</VALUE>";
		        	newSealXML += "<SNUM>" + getNodeText(SelectSingleNode(selectedXMLCells[0], "DATA1")) + "</SNUM>";
		        	newSealXML += "<IMGHREF>" + getNodeText(SelectSingleNode(selectedXMLCells[0], "DATA2")) + "</IMGHREF>";
		        	newSealXML += "<IMGWIDTH>" + getNodeText(selectedXMLCells[1]) + "</IMGWIDTH>";
		        	newSealXML += "<IMGHEIGHT>" + getNodeText(selectedXMLCells[2]) + "</IMGHEIGHT>";
		        	newSealXML += "</CELL></ROW>";
		        }
		        
		        newSealXML += "</ROWS></LISTVIEWDATA>";
		        newSealXML = loadXMLString(newSealXML);
		        
		        // 관인선택용 리스트뷰 생성
		        var pLVlist = new ListView();
		        pLVlist.SetID("listSIGNLIST");
		        pLVlist.SetMulSelectable(false);
		        pLVlist.SetRowOnClick("SIGNLIST_onfocus"); // 클릭 시 동작
		        pLVlist.DataSource(newSealXML);
		        pLVlist.DataBind("SIGNLIST");
		        
		        var listview = new ListView();
		        listview.LoadFromID("listSIGNLIST");
		        var pCurSelRow = listview.GetDataRows();
		        if (pCurSelRow) {
		            if (listview.GetDataRows().length > 0) {
		                listview.SetSelectedIndex(0); // 기본적으로 첫번째 로우를 선택
		                
	                    var tempImg = document.createElement("img");
	                    tempImg.style.width = document.getElementById("SIGNVIEW").style.width;
	                    tempImg.style.height = document.getElementById("SIGNVIEW").style.height;
	                    tempImg.setAttribute("width", document.getElementById("SIGNVIEW").style.width);
	                    tempImg.setAttribute("height", document.getElementById("SIGNVIEW").style.height);
	                    tempImg.src = listview.GetDataRows()[0].getAttribute("IMGHREF");
	                    
	                    document.getElementById("SIGNVIEW").appendChild(tempImg);
		            }
		        }
		    };
		    
			// 관인 선택 후 확인
		    var flag = true; // 이중 확인 동작을 방지하기 위한 플래그
		    function btn_ImageSave_onclick() {
		    	if (flag) {
					flag = false;
			    	var listview = new ListView();
			        listview.LoadFromID("listSIGNLIST");
			        var AprSign = listview.GetSelectedRows();
			        if (AprSign.length > 0) {
			        	RetValues[0] = AprSign[0].getAttribute("IMGHREF"); // href
			        	RetValues[1] = AprSign[0].getAttribute("IMGWIDTH"); // width
			        	RetValues[2] = AprSign[0].getAttribute("IMGHEIGHT"); // height
			        	RetValues[3] = "true"; // 선택완료 시 flag
			        	
			        	ReturnFunction(RetValues);
			        	window.close();
			        }
			        else { // 선택된 관인이 없는 경우
			            alert("<spring:message code='ezApprovalG.hsbSl03'/>");
			        }
		    	} else {
		    		return;
		    	}
		    }
		    
		    // 취소 시 동작
		    function btn_ImageCancel_onclick() {
	        	RetValues[0] = "";
	        	RetValues[1] = "";
	        	RetValues[2] = "";
	        	RetValues[3] = "false"; // 선택취소 시 flag
	        	
	            ReturnFunction(RetValues);
	            window.close();
		    }
		    
		    // 리스트뷰에서 각각의 관인을 클릭할 시 동작하는 함수
		    function SIGNLIST_onfocus() {
		        document.getElementById("SIGNVIEW").innerHTML = "";
		        var listview = new ListView();
		        listview.LoadFromID("listSIGNLIST");
		        
		        var pSignSelcur = listview.GetSelectedRows()[0];
	            var tempImg = document.createElement("img");
	            tempImg.style.width = document.getElementById("SIGNVIEW").style.width;
	            tempImg.style.height = document.getElementById("SIGNVIEW").style.height;
	            tempImg.setAttribute("width", document.getElementById("SIGNVIEW").style.width);
	            tempImg.setAttribute("height", document.getElementById("SIGNVIEW").style.height);
	            tempImg.src = pSignSelcur.getAttribute("IMGHREF");
	            document.getElementById("SIGNVIEW").appendChild(tempImg);
		    }
		    
		</script>
		<style>
			.mainlist tr th {border-top:0px}
		</style>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t436'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="return btn_ImageCancel_onclick()"></span></li>
            </ul>
        </div>		
		<table> 
		  <tr> 
		    <td><div class="listview" >
		            <div id="SIGNLIST"  style="BORDER:0;WIDTH:150px;HEIGHT:160px;overflow-x:hidden;margin:1px 1px 1px 1px;"></div>
				</div>
			  </td> 
		    <td> <div id="SIGNVIEW" class="IMAGEVIEW" style="background-color:white; margin-left:10px; BORDER:#ddd 1px solid; WIDTH:160px; HEIGHT:160px; overflow:hidden;"></div></td> 
		  </tr> 
		</table> 
		
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="btn_ImageSave" onClick="return btn_ImageSave_onclick()"><span><spring:message code='ezApprovalG.t413'/></span></a>
		</div>
	</body>
</html>
