<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>

<div class="surveyCrtTt2">
	<div class="sryFirst2"></div>
	<span class="sryTxt"><c:out value="설문제목"></c:out> </span>
</div>

<div class="quesBacgr" style="height: 400px; border: 1px solid #d7d7d7;">
	
	
	<!-- <div class='quesDiv'>
	
		<div class='qstnRow'>
			<input class='questnTitle'>
			<img alt='' src='/images/ezSurvey/attach.png' class='atchImg'>
			<input type='file' class='attachFile' multiple='multiple' >
			<div id='selectBox'></div>
		</div>
		
		<div class='qstnAtt'>
			<div class='qstnFileInfo'>
				<div>
					<ul></ul>
				</div>
			</div>
			
			<div class='qstnAtt'>
				<input type='file' class='qstnFile' style='display:none;'/>
			</div>
		</div>
	</div> -->
	
	
	

	 <script type="text/javascript" src="${util.addVer('/js/ezSurvey/questionFile.js')}"></script>
</div>