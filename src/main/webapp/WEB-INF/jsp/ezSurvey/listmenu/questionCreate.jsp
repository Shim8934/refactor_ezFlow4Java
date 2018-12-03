<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>

<div class="surveyCrtTt2">
	<div class="sryFirst2"></div>
	<span class="sryTxt"><c:out value="설문제목"></c:out> </span>
</div>


<div class='mtrTable'>
	<div class='mtrPart'>
	
		<div class='rowArea' style='border: 1px solid black;'>
			
			<div class='rName' style='float: left; width: 10%;'>
				<span>행</span>
			</div>
			
			<div class='rows' style='float: left; width: 90%;'>
				<div class='row'>
					<input>
					<img alt="" src="">
				</div>
				<div class='row'>
					<input>
					<img alt="" src="">
				</div>
				<div class='row'>
					<input>
					<img alt="" src="">
				</div>
			</div>
			
			<div class='rowBtn'>
				<button class='addRow'></button>
			</div>
			
		</div>
		
		<div class='colArea' style='border: 1px solid black;'>
			
			<div class='cName' style='float: left; width: 90%;'>
				<span>행</span>
			</div>
			
			<div class='cols' style="">
				<div class='col'>
					<input>
					<img alt="" src="">
				</div>
				<div class='col'>
					<input>
					<img alt="" src="">
				</div>
				<div class='col'>
					<input>
					<img alt="" src="">
				</div>
			</div>
			
			<div class='colBtn'>
				<button class='addCol'></button>
			</div>
			
		</div>
		
	</div>
</div>
<div class="quesBacgr"></div>