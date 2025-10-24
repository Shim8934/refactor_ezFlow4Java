<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t435'/></title>
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
		    var pUserID;
		    var BaseURL;
		    var pDeptID = "<c:out value ='${userInfo.deptID}'/>";
		    var existSign = "<c:out value ='${existSign}'/>";
		    var RetValue;
		    var ReturnFunction;
		    
		    // 사인 그리기 관련 변수
            var down = false; // 마우스 클릭중인지 확인하는 플래그
            var pos = {drawable:false, x:0, y:0}; // 서명 그리기 위치 객체
            var canvas; // 서명 그리기 란 dom객체
            var ctx; // Canvas API 객체
            var signFlag = false; // 서명 여부, 아무 서명도 하지 않았는데 결재가 가능한 것을 방지
		    
		    var realOpener;
		    var isLastSaveDoc = false;
		    
		    window.onload = function () {
		        var pSingFlag = true;
		
		        try {
		            RetValue = parent.aprsign1_cross_dialogArguments[0];
		            ReturnFunction = parent.aprsign1_cross_dialogArguments[1];
		            realOpener = parent;
		        } catch (e) {
		            try {
		                RetValue = opener.aprsign1_cross_dialogArguments[0];
		                ReturnFunction = opener.aprsign1_cross_dialogArguments[1];
		                realOpener = opener;
		            } catch (e) {
		                RetValue = window.dialogArguments;
		                realOpener = window;
		            }
		        }
		        if (existSign != "Y") {
		            btn_drawToggle_onclick();
		        }
		        
		        pUserID = RetValue;
		        
		        if(realOpener && typeof realOpener.isLastSaveDoc != "undefined" && realOpener.isLastSaveDoc == true){
		            isLastSaveDoc = true;
		        }
		        
                if (pUserID == "seal") {
                    window.document.title = "<spring:message code='ezApprovalG.t436'/>";
                    btn_Save.style.display = "none";
                }
                GetImageXml(pUserID, pDeptID);
                if ("<c:out value ='${userInfoApprovalG}'/>" == "BOTH")
                    BaseURL = "/fileroot/${userInfo.tenantId}/files/upload_approval/signImgs/" + "${userInfo.id}/";
                else
                    BaseURL = "/fileroot/${userInfo.tenantId}/files/upload_approvalG/signImgs/" + "${userInfo.id}/";
                var listview = new ListView();
                listview.LoadFromID("listSIGNLIST");
                var pCurSelRow = listview.GetDataRows();
                if (pCurSelRow) {
                    if (listview.GetDataRows().length > 0) {
                        var pSignSelcur = listview.GetDataRows()[0];
                        listview.SetSelectedIndex(0);
                        if (pSignSelcur != null && trim_Cross(pSignSelcur.getAttribute("DATA1")) != "NAME") {
                            var tempImg = document.createElement("img");
                            tempImg.style.width = document.getElementById("SIGNVIEW").style.width;
                            tempImg.style.height = document.getElementById("SIGNVIEW").style.height;
                            tempImg.setAttribute("width", document.getElementById("SIGNVIEW").style.width);
                            tempImg.setAttribute("height", document.getElementById("SIGNVIEW").style.height);                 
                            tempImg.src = "/ezApprovalG/approvalGSign.do?fileName=" + pSignSelcur.getAttribute("DATA1");
                            document.getElementById("SIGNVIEW").appendChild(tempImg);
                        }
                    }
                }
                
                canvas = document.getElementById('canvas')
                ctx = canvas.getContext('2d')
                ctx.lineWidth = 2;
                
                // 태블릿 지원을 포함한 이벤트리스너
                window.document.addEventListener("pointerdown", function() { down = true; });
                window.document.addEventListener("pointerup", function() { down = false; });
                canvas.addEventListener("pointerdown", drawStart);
                canvas.addEventListener("pointermove", draw);
                canvas.addEventListener("pointerover", drawStart);
		        
		        if(isLastSaveDoc){
		            /*
		            if(document.getElementById("SIGNLIST")){
		                document.getElementById("SIGNLIST").style.display = "none";
		            }
		            if(document.getElementById("SIGNVIEW")){
		                document.getElementById("SIGNVIEW").style.display = "none";
		            }
		            */
		            if(document.getElementById("btn_ImageSave")){
		                document.getElementById("btn_ImageSave").style.display = "none";
		            }
		            if(document.getElementById("btn_draw")){
		                document.getElementById("btn_draw").style.display = "none";
		            }
		        }
		        
		    };
		    /**
		    * 글림으로된 서명을 선택해서 진행할 경우
		    */
		    var flag = true;
            async function btn_ImageSave_onclick(imageTypeFlag) {
		        if (imageTypeFlag == "DRAW" && signFlag == false) {
		            alert(strLangJIHSignDraw01);
		            return;
		        }
		        
		    	if (flag) {
					flag = false;
			    	var listview = new ListView();
			        listview.LoadFromID("listSIGNLIST");
			        var AprSign = listview.GetSelectedRows();
			        if (AprSign.length != 0) {
			            if (trim_Cross(AprSign[0].getAttribute("DATA1")) == "NAME") {
			                if (ReturnFunction != null) {
			                    ReturnFunction(AprSign[0].getAttribute("DATA1"));
			                }
			                else {
			                    parent.window.returnValue = AprSign[0].getAttribute("DATA1");
			                }
			            } else {
			                var AprSignName = AprSign[0].cells[0].innerText;
			                var AprSignURL = AprSign[0].getAttribute("DATA1");
			                var AprSignInfo = "";
			                
			                if (imageTypeFlag == "DRAW") {
                                AprSignInfo = await saveDrawSignImg();
			                } else {
                                AprSignInfo = BaseURL + AprSignURL;
			                }
			                
			                if (ReturnFunction != null) {
			                    ReturnFunction(AprSignInfo);
			                } else {
			                    window.returnValue = AprSignInfo;
			                    parent.window.close();
			                }
			            }
			        } else {
			            if (!!AprSign[0] && trim_Cross(AprSign[0].getAttribute("DATA1")) == "NAME") {
                            if (ReturnFunction != null) {
                                ReturnFunction(AprSign[0].getAttribute("DATA1"));
                            } else {
                                window.returnValue = AprSign[0].getAttribute("DATA1");
                                parent.window.close();
                            }
                        } else if (imageTypeFlag == "DRAW") {
                            var AprSignInfo = await saveDrawSignImg();
                            if (ReturnFunction != null) {
			                    ReturnFunction(AprSignInfo);
			                } else {
			                    window.returnValue = AprSignInfo;
			                    parent.window.close();
			                }
                        } else {
			                alert("<spring:message code='ezApprovalG.t437'/>");
			            }
			        }
		    	} else {
		    		return;
		    	}
		    }
		    
		    function btn_ImageCancel_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction("cancel");
		        }
		        else {
		            window.returnValue = "cancel";
		            window.close();
		        }
		    }
		    
		    function btn_Save_onclick() {
		    	if (flag) {
		    		flag = false;
			        if (ReturnFunction != null) {
			            ReturnFunction("NAME");
			        }
			        else {
			            window.returnValue = "NAME";
			            window.close();
			        }
		    	} else {
		    		return;
		    	}
		    }
		    function SIGNLIST_onfocus() {
		        document.getElementById("SIGNVIEW").innerHTML = "";
		        var listview = new ListView();
		        listview.LoadFromID("listSIGNLIST");
		        var pSignSelcur = listview.GetSelectedRows()[0];
		        if (pSignSelcur != null && trim_Cross(pSignSelcur.getAttribute("DATA1")) != "NAME") {
		            var tempImg = document.createElement("img");
		            tempImg.style.width = document.getElementById("SIGNVIEW").style.width;
		            tempImg.style.height = document.getElementById("SIGNVIEW").style.height;
		            tempImg.setAttribute("width", document.getElementById("SIGNVIEW").style.width);
		            tempImg.setAttribute("height", document.getElementById("SIGNVIEW").style.height);
		            tempImg.src = "/ezApprovalG/approvalGSign.do?fileName=" + pSignSelcur.getAttribute("DATA1");
		            document.getElementById("SIGNVIEW").appendChild(tempImg);
		        }
		    }
		    
		    function btn_drawToggle_onclick() {
		        if ($("#drawSignTab").is(':visible')) {
		            clearAll();
		        }
		    
		        $("#imageSignTab").toggle();
		        $("#drawSignTab").toggle();
		        $(".btnposition.btnpositionNew").toggle();
		        $(".btnposition.btnpositionDraw").toggle();
		    }
		    
		    // 사인 그리기 관련 메소드 시작
            function getMousePos(canvas, e) {
                var rect = canvas.getBoundingClientRect();
                pos.x = (e.clientX - rect.left) * (canvas.width / rect.width);
                pos.y = (e.clientY - rect.top) * (canvas.height / rect.height);
            }
            
            function drawStart() {
                ctx.beginPath();
            }
    
            function draw(e) {
                if (!down) { return; }
                getMousePos(canvas, e);
                ctx.lineTo(pos.x, pos.y);
                ctx.stroke();
                signFlag = true;
            }
            
            function clearAll() {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                signFlag = false;
            }
           
            function saveDrawSignImg() {
                return new Promise((resolve, reject) => {
                    canvas.toBlob((blob) => {
                        const fd = new FormData();
                        fd.append("signImg", blob);
                        
                        $.ajax({
                            type: "POST",
                            dataType: "json",
                            url: "/ezApprovalG/saveDrawSignImg.do",
                            data: fd,
                            processData: false,
                            contentType: false,
                            success: function(result) {
                                if (result.status === "ok") {
                                    resolve(result.url);
                                } else {
                                    alert(strLangJIHSignDraw02);
                                    return;
                                }
                            },
                            error: function(error) {
                                alert(strLangJIHSignDraw02);
                                console.log(error);
                                return;
                            }
                        });
                    });
                });
            }
            // 사인 그리기 메소드 끝
		</script>
		<style>
			.mainlist tr th {border-top:0px}
		</style>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t435'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="return btn_ImageCancel_onclick()"></span></li>
            </ul>
        </div>		
		<table id="imageSignTab"> 
		  <tr> 
		    <td><div class="listview" >
		            <div id="SIGNLIST"  style="BORDER:0;WIDTH:150px;HEIGHT:160px;overflow-x:hidden;margin:1px 1px 1px 1px;"></div>
				</div>
			  </td> 
		    <td> <div id="SIGNVIEW" class="IMAGEVIEW" style="background-color:white; margin-left:10px; BORDER:#ddd 1px solid; WIDTH:160px; HEIGHT:160px; overflow:hidden;"></div></td> 
		  </tr> 
		</table> 
        <div id="drawSignTab" style="display:none; text-align: center;"> 
		    <canvas id="canvas" class="canvas" width="160" height="160" style="border:#ddd 1px solid;"></canvas>
		</div> 
		
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="btn_ImageSave" onClick="return btn_ImageSave_onclick('IMAGE')"><span><spring:message code='ezApprovalG.t413'/></span></a>
			<a class="imgbtn" id="btn_Save" onClick="return btn_Save_onclick()"><span><spring:message code='ezApprovalG.t438'/></span></a>		        
			<a class="imgbtn" id="btn_draw" onClick="return btn_drawToggle_onclick()"><span><spring:message code='ezApprovalG.drawSign.jih001'/></span></a>
		</div>
        <div class="btnposition btnpositionDraw" style="display:none;">
            <a class="imgbtn" id="btn_brawClear" onClick="clearAll()"><span><spring:message code='ezApprovalG.drawSign.jih002'/></span></a>
			<a class="imgbtn" id="btn_Save" onClick="return btn_ImageSave_onclick('DRAW')"><span><spring:message code='ezApprovalG.t413'/></span></a>
			<c:if test="${existSign eq 'Y'}">		        
			    <a class="imgbtn" id="btn_draw" onClick="return btn_drawToggle_onclick()"><span><spring:message code='ezApprovalG.drawSign.jih003'/></span></a>
			</c:if>
			<c:if test="${existSign eq 'N'}">
			    <a class="imgbtn" id="btn_Save" onClick="return btn_Save_onclick()"><span><spring:message code='ezApprovalG.t438'/></span></a>
            </c:if>
		</div>
	</body>
</html>
