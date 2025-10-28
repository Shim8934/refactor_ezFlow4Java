<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/input-util.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/leftmenu-util.js')}"></script>
<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
<script type="text/javascript">
	"use strict";
	var rowContext = (function() {
		var className = {
			selected: "on",
			unselected: ""
		};

		var rowWrapElement;
		var isLocked;

		function setTable(table) {
			rowWrapElement = table;
		}

		function onRowClick(event) {
			if (isLocked) {
				return;
			}

			clearFocus();
			setSelectState(this, true);
		}

		function getSelectedRow() {
			return rowWrapElement.querySelector("tr." + className.selected);
		}

		function clearFocus() {
			var selectedRow = getSelectedRow();
			if (selectedRow) {
				selectedRow.setAttribute("class", className.unselected);
			}
		}

		function setSelectState(rowElement, isSelect) {
			rowElement.setAttribute("class", isSelect ? className.selected : className.unselected);
		}

		function setLock(bool) {
			clearFocus();
			isLocked = bool;

			if (isLocked) {
				rowWrapElement.setAttribute("data-rename_state", "1");
			} else {
				rowWrapElement.removeAttribute("data-rename_state");
			}
		}

		return {
			setTable: setTable,
			onRowClick: onRowClick,
			getSelectedRow: getSelectedRow,
			setSelectState: setSelectState,
			clearFocus: clearFocus,
			setLock: setLock
		};
	}());

	var renameContext = (function() {
		var isStarted = false;
		var session = {
			tagIdx: null,
			nameTd: null,
			previousName: null,
			input: null
		};

		function onRowDoubleClick() {
			if (isStarted) return;

			isStarted = true;
			session.tagIdx = this.id;
			session.nameTd = this.querySelector("td");
			session.previousName = session.nameTd.innerText;

			var input = session.input = document.createElement("input");
			input.id = 'rename_input';
			input.type = 'text';
			input.maxLength = 100;
			input.value = session.previousName;
			input.addEventListener("keydown", function(event) { if (event.keyCode == 13 || event.keyCode == 27) { this.blur(); } });
			input.addEventListener("blur", function(event) { onComplete(); });
			// 입력 시 특수문자 입력 못하도록 함
			inputUtil.makeNotAllowTyping(input, /[!@#$%^&()\\\/:*?"<>|'`]/g);
			// 띄어쓰기 입력 시 언더바로 치환
			inputUtil.makeReplaceTyping(input, /\s/g, '_');

			session.nameTd.innerText = '';
			session.nameTd.appendChild(input);

			input.focus();
			rowContext.setLock(true);
		}

		function onComplete() {
			var newName = session.input.value.trim();

			if (newName.trim().length == 0 || session.previousName == newName) {
				rollback();
				return;
			}

			if (!confirm("<spring:message code='ezEmail.tag.config.rename.confirm' />")) {
				rollback();
				return;
			}

			$.ajax({
				async: false,
				method: "post",
				url: "/ezEmail/setTagName.do",
				data: { tagIdx: session.tagIdx, name: newName, shareId: '${shareId}' },
				success: function(result) {
					if (result.status == "ok") {
						// 이미 존재하는 이름의 태그가 있을 때 구분
						if (result.code == 1) {
							alert(strLangTagAlreadyUse);
							rollback();
						} else {
							commit();
						}

						return;
					}

					alert(strLang321);
					rollback();
				},
				error: function() { alert(strLang321); rollback(); }
			});
		}

		function rollback() {
			session.nameTd.innerText = session.previousName;
			close();
		}

		function commit() {
			leftMenu.reloadTags();
			var renamedValue = session.input.value.trim();
			session.nameTd.innerText = renamedValue;
			session.nameTd.title = renamedValue;
			close();
		}

		function close() {
			$(session.input).remove();
			session = {};
			isStarted = false;
			rowContext.setLock(false);
		}

		return {
			onRowDoubleClick: onRowDoubleClick
		}
	})();

	window.addEventListener('load', function() {
		rowContext.setTable(document.getElementById("content"));
		<c:if test="${not empty tags}">
			attachRowsEvent();
		</c:if>
	});

	function attachRowsEvent() {
		$("#content tr")
			.on("click", rowContext.onRowClick)
			.on("dblclick", renameContext.onRowDoubleClick);
	}

	function getEnable() {
		return Boolean(document.querySelector("input[name='enable']:checked").value);
	}

	function getOrderBy() {
		return document.querySelector("input[name='orderby']:checked").value;
	}

	function getSelectedIdx() {
		var selectedTr = rowContext.getSelectedRow();
		return selectedTr ? selectedTr.id : null;
	}

	function onChangeEnable() {
		save(leftMenu.reloadWithoutSelectNode);

		if (getEnable()) {
			$(document.head.querySelector("#disable_style")).remove();
		} else {
			var disableStyle = document.createElement("style");
			disableStyle.id = "disable_style";
			disableStyle.innerHTML = ".enable_only { display: none; }";
			document.head.appendChild(disableStyle);
		}
	}

	function onChangeOrderBy() {
		save(leftMenu.reloadTags);
		reload();
	}

	function onClickDelete() {
		var tagIdx = getSelectedIdx();

		if (!tagIdx) {
			alert("<spring:message code='ezEmail.tag.config.selectplz' />");
			return;
		}

		if (!confirm("<spring:message code='ezEmail.tag.config.delete.confirm' />")) {
			return;
		}

		$.ajax({
			cache: false,
			method: "post",
			url: "/ezEmail/deleteTag.do",
			data: { tagIdx: tagIdx, shareId: '${shareId}' },
			success: function(result) {
				if (result.status == "ok") {
					leftMenu.reloadTags();
					reload();
				} else {
					alert(strLang321);
				}
			},
			error: function() { alert(strLang321); }
		});
	}

	function reload() {
		var contentDiv = $("#content");
		contentDiv.find("tr:not(:first-child)").remove();
		contentDiv.append("<tr class='non_data'><td colspan='2'><img src='/images/email/progress_img.gif' /></td></tr>");

		$.ajax({
			cache: false,
			method: "get",
			url: "/ezEmail/getUserTagList.do",
			data: { orderBy: getOrderBy(), shareId: '${shareId}' },
			success: function(result) {
				if (result.status == "error") {
					alert(strLang321);
					return;
				}

				var tags = result.data;
				contentDiv.find("tr.non_data").remove();

				if (tags.length == 0) {
					contentDiv.append("<tr class='non_data'><td colspan='2' style='text-align: center;'><spring:message code='ezEmail.tag.config.nondata' /></td></tr>");
				} else {
					tags.forEach(function(tag) {
						contentDiv.append("<tr id='" + tag.idx + "' title='" + tag.name + "'><td>" + tag.name + "</td><td>" + tag.count + "</td></tr>");
					});
					attachRowsEvent();
				}
			},
			error: function() { alert(strLang321); }
		});
	}

	function save(successCallback) {
		$.ajax({
			cache: false,
			method: "post",
			url: "/ezEmail/setTagConfig.do",
			data: { enable: getEnable(), orderBy: getOrderBy(), shareId: '${shareId}'},
			success: function(result) {
				if (result.status == "error") {
					alert(strLang321);
				}

				successCallback();
			},
			error: function() { alert(strLang321); }
		});
	}
</script>
<style>
	#order_wrapper, #order_wrapper > span > * { vertical-align: middle; }
	#order_wrapper > span > input { margin: 0px; padding: 0px; }
	label { vertical-align: middle; }
	#content { table-layout: fixed; }
	#content:not([data-rename_state]) tr:not(.non_data):nth-child(n+2):hover { background-color: #f4f5f5; }
	#content tr.on { background-color: #f1f8ff !important; }
	#content td { background-color: inherit; width: inherit; padding-left: 5px; text-overflow: ellipsis; overflow: hidden; word-break: keep-all; }
	#rename_input { width: 100%; }
	.non_data { text-align: center; }
</style>
<c:if test="${not config.enable}">
<style id='disable_style'>.enable_only { display: none; }</style>
</c:if>
</head>
<body style="margin: 0 10px;">
	<br />
	<div class="txt" style="margin-bottom:25px">
		▒ <spring:message code='ezEmail.tag.config.tip' /> 
	</div>
	<table class="content" style="width: 680px;">
		<tr>
          <th><spring:message code='ezEmail.tag.config.enable' /></th>
          <td> 
            <div class="custom_radio">
                <input type="radio" id="enable_1" name="enable" value="1" onchange="onChangeEnable();"<c:if test="${config.enable}"> checked="checked"</c:if>><label for="enable_1"><spring:message code='ezEmail.tag.config.enabled' /></label>
                <input type="radio" id="enable_2" name="enable" value="" onchange="onChangeEnable();"<c:if test="${not config.enable}"> checked="checked"</c:if>><label for="enable_2"><spring:message code='ezEmail.tag.config.disabled' /></label>
            </div>
          </td>
        </tr>
        
        <tr class="enable_only">
          <th><spring:message code='ezEmail.tag.config.orderby' /></th>
          <td>
            <div class="custom_radio">
                <input type="radio" id="orderby_1" name="orderby" value="" onchange="onChangeOrderBy();"<c:if test="${empty config.orderby}"> checked="checked"</c:if>><label for="orderby_1"><spring:message code='ezEmail.tag.config.orderby.name' /></label>
                <input type="radio" id="orderby_2" name="orderby" value="count" onchange="onChangeOrderBy();"<c:if test="${config.orderby eq 'count'}"> checked="checked"</c:if>><label for="orderby_2"><spring:message code='ezEmail.tag.config.orderby.count' /></label>
                <input type="radio" id="orderby_3" name="orderby" value="date" onchange="onChangeOrderBy();"<c:if test="${config.orderby eq 'date'}"> checked="checked"</c:if>><label for="orderby_3"><spring:message code='ezEmail.tag.config.orderby.date' /></label>
            </div>
          </td>
        </tr>
	</table>
	<br />
	<div class="enable_only">
		<h2 class="h2"><spring:message code='ezEmail.tag.config.table' /></h2>
		<span class="txt">▒ <spring:message code='ezEmail.tag.config.tip2' /></span><br />
		<span class="txt">▒ <spring:message code='ezEmail.tag.config.tip3' /></span><br />
		<span class="txt">▒ <spring:message code='ezEmail.tag.config.tip4' /></span><br />
		<br />
		<div id="mainmenu">
			<ul id="tb_Parent">
				<li onclick="onClickDelete();"><span class="icon16 icon16_delete"></span></li>
				<li onclick="reload();"><span class="icon16 icon16_refresh"></span></li>
			</ul>
		</div>
		<table id="content" class="content" style="width: 680px; margin-top: 5px">
			<colgroup>
				<col width="90">
				<col width="10">
			</colgroup>
			<tr>
				<th><spring:message code='ezEmail.tag.config.name' /></th>
				<th style="text-align: center;"><spring:message code='ezEmail.tag.config.count' /></th>
			</tr>
			<c:choose>
				<c:when test="${empty tags}">
					<tr class="non_data"><td colspan="2"><spring:message code='ezEmail.tag.config.nondata' /></td></tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${tags}" var="tag">
						<tr id="${tag.idx}">
							<td title="<c:out value='${tag.name}' />"><c:out value="${tag.name}" /></td>
							<td>${tag.count}</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</table>
	</div>
</body>
</html>