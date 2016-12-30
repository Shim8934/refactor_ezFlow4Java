<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	    <link href="/css/ezApproval/reform.css" rel="stylesheet" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/admin/reformDesignProcessor.js"></script>
	    <script type="text/ecmascript">
	        var FormProcSpelling = "${formProcSpelling}";
	        var useReform = "${useReform}";
		    var webEditorDocument;
	        var currentControlElement = null;
	        var propertyMaxNumber = 10;
	        var eventMaxNumber = 4;
	        var kNullIndexValue = "-9753579";
	        var nextAutoID = 1;
	        var kSelectionOutlineSytle = "#00FF00 dotted medium";
		    var isIE11Mode = false;
		    var reflag = false
	        window.onload = function ()
	        { }
	        function pzFormProc_reform_FieldsAvailable() { }
	        function pzFormProc_reform_DocumentComplete() {
	            // reform
	            //if (useReform == "1") {
	                pzFormProc_reform.editor.DOM.reform_onClickHandler = reform_onClickHandler;
	                pzFormProc_reform.editor.DOM.reform_onKeyPressHandler = reform_onKeyPressHandler;
	
	                onFormDocumentLoadHandler();
	            //}
	            // reform - end
	                if (reflag == false) {
	                    reflag = true;
	                    if (parent.pReformURL != "") {
	                        pzFormProc_reform.LoadURL(parent.pReformURL);
	                    }
	                }
	        }
	        function pzFormProc_InvalidDocument() {
	            pzFormProc_reform.ShowWorkingDlg("", false);
	        }
	    </script>
		<script type="text/javascript" for="pzFormProc_reform" event="FieldsAvailable">
		    pzFormProc_reform_FieldsAvailable();
		</script>
		<script type="text/javascript" for="pzFormProc_reform" event="DocumentComplete">
		    pzFormProc_reform_DocumentComplete();
		</script>
		<script type="text/javascript" for="pzFormProc_reform" event="InvalidDocument">
		    pzFormProc_InvalidDocument();
		</script>
	</head>
	<body>
	    <!-- reform -->
	<!-- 최적화사이즈widht285px  가변가능-widht변경가능 -->
	    <div id="reform" style="position: absolute; top: 0px; right: 0px; width:285px;">
	
	<!-- section1 -->
		<div class="section border_not">
	        <a href="#" class="btn_type1" onclick="showPreview()"><span>미리보기</span></a>
	    </div>
	<!-- //section1 -->
	
	<!-- section2 -->
		<div class="section">
	       <h2 class="h2">
	      	<span class="title">데이터연동</span>
	      	 <ul class="btn_type2">
	       		<li onclick="showAddDataBindControlDialog()"><span>추가</span></li>
	       		<li onclick="showDeleteDataBindControlDialog()"><span>삭제</span></li>
	       		<li onclick="showModifyDataBindControlDialog()"><span>수정</span></li>
	      	 </ul>
	       </h2>
	       <p class="mt5"><select id="data_bind_control_list" class="sel_type1">
	       </select></p>
	  </div>
	<!-- //section2-->
	<div class="section" style="display:none;">
	    <h2 class="h2">
	        <span class="title">파일</span>
	    </h2>
	    <p class="mt5">
		    <form id="form1">
		        <input type="hidden" id="filePath" class="file_input_textbox" readonly="readonly" />
		        <input type="hidden" id="HiddenFilePath"/>
		        <input type="file" id="FileUpload" width="230" class="txtCommon"/>
		        <label id="lblUploadText" style="width: 230;"></label>
		        <input type="button" id="ButtonUpload" value="업로드" class="button black medium"/>
		    </form>
	    </p>
	</div>
	<!-- section2 -->
		<div class="section2">
	   		<ul class="html_control">
	        <li onclick="addSelectBox()"><span class="icon_box icon1"></span>List Box</li>
	        <li onclick="addTextBox()"><span class="icon_box icon2"></span>Text Box</li>
	        <li onclick="addCheckbox()"><span class="icon_box icon3"></span>Check Box</li>
	        <li onclick="addRadioButton()"><span class="icon_box icon4"></span>Radio Button</li>
	        <li onclick="addButton()"><span class="icon_box icon5"></span>Button</li>
	        <li onclick="addLabel()"><span class="icon_box icon6"></span>Label</li>
	        <li onclick="addDatePicker()"><span class="icon_box icon7"></span>Date Picker</li>
	        <li onclick="addTimePicker()"><span class="icon_box icon8"></span>Time Picker</li>
	        <li onclick="addGrid()"><span class="icon_box icon9"></span>Data Grid</li>
	        <li onclick="addHiddenControl()"><span class="icon_box icon2"></span>Hidden</li>
	        </ul>
	      	 <ul class="btn_type2">
	            <li onclick="reform_removeCurrentControl()"><span>삭제</span></li>
	            <li onclick="reform_moveCopiedNode()"><span>이동</span></li>
	            <li onclick="reform_pasteCopiedNode()"><span>복제</span></li>
	      	 </ul>       
	    </div>
	<!-- //section2-->
	<!-- section2 -->
		<div class="section">
		<h2 class="h2">
	      	<span class="title">속성</span></h2>
	      
	        <div class="box_deco">
	       		<table class="tbl_type1" border="1" cellspacing="0" >
	           	  <colgroup>
	            	<col style="width:145px">
	                <col>
	          	  </colgroup>
	            	<tr>
	                  <th id="prop1_name"></th>
	                  <td id="prop1_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop2_name"></th>
	                  <td id="prop2_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop3_name"></th>
	                  <td id="prop3_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop4_name"></th>
	                  <td id="prop4_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop5_name"></th>
	                  <td id="prop5_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop6_name"></th>
	                  <td id="prop6_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop7_name"></th>
	                  <td id="prop7_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop8_name"></th>
	                  <td id="prop8_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop9_name"></th>
	                  <td id="prop9_value"></td>
	                </tr>                                              
	            	<tr>
	                  <th id="prop10_name"></th>
	                  <td id="prop10_value"></td>
	                </tr>                                              
	            </table>
	        </div>
	  </div>
	<!-- //section2-->
	
	<!-- section2 -->
		<div class="section border_nob ">
	    <h2 class="h2">
	      	<span class="title">이벤트</span></h2>
		  <div class="box_deco">
		    <table class="tbl_type1" border="1" cellspacing="0" >
		      <colgroup>
		        <col style="width:145px">
		        <col>
	          </colgroup>
		      <tr>
		        <th id="event1_name"></th>
		        <td id="event1_value"></td>
	          </tr>
		      <tr>
		        <th id="event2_name"></th>
		        <td id="event2_value"></td>
	          </tr>
		      <tr>
		        <th id="event3_name"></th>
		        <td id="event3_value"></td>
	          </tr>
		      <tr>
		        <th id="event4_name"></th>
		        <td id="event4_value"></td>
	          </tr>	     
	        </table>
	      </div>
	    </div>
	<!-- //section2-->
	</div>
	    <table id="PreForm" style="height:0px;">
	        <tr>
	            <td valign="top" style="height:800px;">
	                <script language='JavaScript'>FormProc_ActiveX3("pzFormProc_reform", "2", "700px");</script>
	            </td>
	            <td id="rootTD"></td>
	        </tr>
	    </table> 
	<!-- //reform -->
	</body>
</html>