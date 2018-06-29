var selectedCell = "";
var selectedSubCell = "";
var previousSubCell = null;
var previousCell = null;
var count = 1000;
var pageid = "";
var parentpageid = "";
var mode = "";
var editmode = "";
var bInherit = false;

function window.onload()
{
	if (editmode == "new_inherit") bInherit = true;
	if (mode == "edit") AttachEvents(main_table);
}

function load()
{
	var ret = window.showModalDialog("portalpage_search.aspx?mode=load");
	if (typeof(ret) == "undefined") return;
	
	document.location.href = "PortalPage.aspx?pageid=" + ret[0];
}

function inherit()
{
	var ret = window.showModalDialog("portalpage_search.aspx?mode=inherit");
	if (typeof(ret) == "undefined") return;
	
	document.location.href = "PortalPage.aspx?parentpageid=" + ret[0];
}

function savesub(pObject, pPageID, pParentPageID, pDisplayName)
{
	var strXML = "<DATA>";
	strXML += "<DISPLAYNAME><![CDATA[" + pDisplayName + "]]></DISPLAYNAME>"
	strXML += "<WIDTH>" + pObject.width.toString().replace("px", "").replace("100%", "-1") + "</WIDTH>";
	strXML += "<HEIGHT>" + pObject.height.toString().replace("px", "").replace("100%", "-1") + "</HEIGHT>";
	strXML += "<PARENTPAGEID>" + pParentPageID + "</PARENTPAGEID>";

	for (var i=0; i<pObject.children.item(0).children.item(0).children.length; i++)
	{
		if (pObject.children.item(0).children.item(0).children.item(i).id == "") continue;
		if (pObject.children.item(0).children.item(0).children.item(i).id.substr(0, 2) == "td")
		{
			strXML += "<CELL>";
			var td_item = pObject.children.item(0).children.item(0).children.item(i);			
			strXML += "<WIDTH>" + td_item.style.width.toString().replace("px", "") + "</WIDTH>";
			for (var j=0; j<td_item.children.item(0).children.item(0).children.length; j++)
			{
				var tdsub_item = td_item.children.item(0).children.item(0).children.item(j).children.item(0);
				
				if (tdsub_item.id == "") continue;
				
				/*
				if (previousCell != null) previousCell.style.backgroundColor = "white";
				tdsub_item.style.backgroundColor = "red";
				previousCell = tdsub_item;
				
				alert("wait");
				*/
				
				if (tdsub_item.children.length > 0 && tdsub_item.children.item(0).id.toLowerCase().substr(0, 4) != "main")
				{
					strXML += "<ROW>";
					strXML += "<TYPE>0</TYPE>";
					strXML += "<UID>" + tdsub_item.uid + "</UID>";
					strXML += "<PAGEUID>" + tdsub_item.pageuid + "</PAGEUID>";
					strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
					strXML += "<DISPLAYNAME><![CDATA[" + tdsub_item.innerText + "]]></DISPLAYNAME>"
					strXML += "<CANREMOVE>" + tdsub_item.canremove + "</CANREMOVE>";
					strXML += "<CANRESIZE>" + tdsub_item.canresize + "</CANRESIZE>";
					strXML += "<CANREPLACE>" + tdsub_item.canreplace + "</CANREPLACE>";				
					strXML += "</ROW>";
				}
				else
				{
					strXML += "<ROW>";
					strXML += "<TYPE>1</TYPE>";
					strXML += "<UID>" + tdsub_item.uid + "</UID>";
					strXML += "<PAGEUID>" + tdsub_item.pageuid + "</PAGEUID>";
					strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
					strXML += "<DISPLAYNAME><![CDATA[" + tdsub_item.pageuid + "]]></DISPLAYNAME>"
					strXML += "<CANREMOVE>" + tdsub_item.canremove + "</CANREMOVE>";
					strXML += "<CANRESIZE>" + tdsub_item.canresize + "</CANRESIZE>";
					strXML += "<CANREPLACE>" + tdsub_item.canreplace + "</CANREPLACE>";				
					strXML += "</ROW>";
					savesub(tdsub_item.children.item(0), tdsub_item.uid, "top", tdsub_item.uid);
				}
			}
			strXML += "</CELL>";
		}
	}
	strXML += "</DATA>";
	
	var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	xmlhttp.open("POST", "admin/remote/portal_SavePortalPage.aspx?pageid=" + pPageID + "&parentpageid=" + pParentPageID, false);
	xmlhttp.send(strXML);
	xmlhttp = null;
}

function save()
{
	if (txtDisplayName.value == "")
	{
		alert("포탈 페이지 이름을 입력하세요.");
		txtDisplayName.focus();
		return;		
	}
	
	savesub(main_table, pageid, parentpageid, txtDisplayName.value);
	
	alert("저장했습니다.");
	document.location.href = "PortalPage.aspx?pageid=" + pageid;
}

function CheckDuplicate(pUID)
{
	for (var i=0; i<main_table.all.tags("td").length; i++)
	{
		if (main_table.all.tags("td").item(i).uid == pUID) return true;
	}
	return false;
}

function AttachEvents(pObject, pPageID)
{
	var prevpageid = "";
	var count = 0;
	
	for (var i=0; i<pObject.all.tags("td").length; i++)
	{

		if (pObject.all.tags("td").item(i).id == "") continue;

		if (pObject.all.tags("td").item(i).id.indexOf("sub") > -1)
		{
			if (prevpageid != pObject.all.tags("td").item(i).pageuid) count++;
			prevpageid = pObject.all.tags("td").item(i).pageuid;			
			pObject.all.tags("td").item(i).onclick = selectsubcell;
			pObject.all.tags("td").item(i).onkeydown = cellkeydown;
		}
		else
		{
			pObject.all.tags("td").item(i).onclick = selectcell;
			pObject.all.tags("td").item(i).onkeydown = cellkeydown
		}
	}
	
	if (count > 1) bInherit = false;
}

function selectcell()
{
	if (event.srcElement.id == "") return;
	if (event.srcElement.id.indexOf("sub") > -1) return;
	selectedCell = event.srcElement.id;
	if (previousCell != null) previousCell.style.backgroundColor = "white";
	previousCell = event.srcElement.children.item(0).children.item(0).children.item(0).children.item(0);
	previousCell.style.backgroundColor = "lightblue";
}

function selectcellTitle()
{
	event.srcElement.parentElement.parentElement.parentElement.parentElement.click();
	event.cancalBubble = true;
	event.returnValue = false;
}

function selectsubcell()
{
	var eventItem = event.srcElement;

	if (eventItem.id == "") 
	{
		eventItem = eventItem.parentElement;
	}
	selectedSubCell = eventItem.id;
	try
	{
		if (previousSubCell != null) previousSubCell.parentElement.style.backgroundColor = "white";
	} catch(e) {}

	eventItem.parentElement.style.backgroundColor = "lightgreen";
	previousSubCell = eventItem;
}

function cellkeydown()
{
	if (!event.ctrlKey)
	{
		switch(event.keyCode)
		{
			case 37:
				swaprow("left");
				break;
			case 38:
				swaprow("up");
				break;
			case 39:
				swaprow("right");
				break;
			case 40:
				swaprow("down");
				break;
			default:
				break;
		}
	}
	else
	{
		switch(event.keyCode)
		{
			case 37:
				resizecell("left");
				break;
			case 38:
				resizerow("up");
				break;
			case 39:
				resizecell("right");
				break;
			case 40:
				resizerow("down");
				break;
			default:
				break;
		}
	}
}

function GetPageID(pCell)
{
	if (typeof(pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.uid) != "undefined") return pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.uid;
	else return pageid;
}

function insertrow()
{
	if (selectedCell == "")
	{
		alert("행을 추가할 열을 선택하세요.");
		return;
	}
	
	if (eval(selectedCell).children.item(0).children.item(0).children.length > 9)
	{
		alert("하나의 열에 10개 이상의 포틀릿을 추가할 수 없습니다.");
		return;
	}
	
	var ret = window.showModalDialog("portlet_search.aspx");
	if (typeof(ret) == "undefined") return;
	
	if (CheckDuplicate(ret[0]))
	{
		alert("이미 추가된 포틀릿입니다.");
		return;
	}
	
	var newrow = eval(selectedCell).children.item(0).insertRow();
	newrow.style.width = "100%";
	newrow.style.height = "100";
	var newcell = newrow.insertCell();
	newcell.id = "subtd" + GetID();
	newcell.uid = ret[0];
	newcell.pageuid = GetPageID(newcell);
	newcell.canremove = 1;
	newcell.canresize = 1;
	newcell.canreplace = 1;
	newcell.style.width = "100%";
	newcell.align = "center";
	newcell.innerHTML = "<b>" + ret[1] + "</b>";
	newcell.onclick = selectsubcell;
	newcell.onkeydown = cellkeydown;
	selectedSubCell = "";
	newcell.focus();
}

function insertcell()
{
	if (bInherit)
	{
		alert("상속받은 포탈 페이지에는 열을 추가할 수 없습니다.");
		return;
	}
	
	if (selectedCell == "")
	{
		alert("열을 삽입할 위치를 선택해주세요");
	}
	
	var newcell = document.createElement("td");
	var row = eval(selectedCell).parentElement;
	row.insertBefore(newcell, eval(selectedCell));
	
	newcell.style.width = "100px";
	newcell.vAlign = "top";
	newcell.innerHTML = "<table border=1 cellpadding=0 cellspacing=0 width=100% valign=top><tbody><TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle()'><td align=center>100px</td></TR></tbody></table>";
	newcell.id = "td" + GetID();
	newcell.onclick = selectcell;
	newcell.onkeydown = cellkeydown;
	selectedCell = "";
	selectedSubCell = "";
}

function removecell()
{
	if (bInherit)
	{
		alert("상속받은 포탈 페이지에는 열을 삭제할 수 없습니다.");
		return;
	}

	if (selectedCell == "")
	{	
		alert("삭제할 열을 선택하세요.");
		return;
	}
	
	if (selectedCell == "td0") return;
	
	if (selectedCell.substr(0,3) == "td0")
	{
		if (confirm("삽입된 페이지를 삭제하시겠습니까?"))
		{
			eval(selectedCell).parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.removeChild(eval(selectedCell).parentElement.parentElement.parentElement.parentElement.parentElement);
			selectedCell = "";
			selectedSubCell = "";
		}
		return;
	}
	
	var row = eval(selectedCell).parentElement;
	
	for (var i=0; i<row.children.length; i++)
	{
		if (row.children.item(i).id == selectedCell)
		{
			row.removeChild(row.children.item(i));
			break;
		}
	}
	selectedCell = "";
	selectedSubCell = "";
}

function removerow()
{
	if (selectedSubCell == "")
	{	
		alert("삭제할 포틀릿을 선택하세요.");
		return;
	}

	var cell = eval(selectedSubCell);
	
	if (cell.canremove != 1)
	{
		alert("삭제할 수 없는 포틀릿입니다.");
		return;
	}
	
	if (cell.pageuid != pageid)
	{
		alert("상속받은 포틀릿은 삭제할 수 없습니다.");
		return;
	}
	
	cell.parentElement.parentElement.removeChild(cell.parentElement);
	selectedSubCell = "";
	selectedCell = "";
}

function swaprow(pDirection)
{
	if (selectedSubCell == "")
	{	
		alert("포틀릿을 선택하세요.");
		return;
	}

	var cell = eval(selectedSubCell);

	if (cell.canreplace != 1)
	{
		alert("위치를 변경할 수 없는 포틀릿입니다.");
		return;
	}

	if (cell.pageuid != GetPageID(cell))
	{
		alert("상속받은 포틀릿은 위치를 변경할 수 없습니다.");
		return;
	}

	var obj = null;
	
	if (pDirection == "up")
	{
		if (cell.parentElement.previousSibling == null || cell.parentElement.previousSibling.children.item(0).id == "") 
		{
			if (cell.pageuid == pageid) return;
			try {
					obj = cell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.insertAdjacentElement("beforeBegin", cell.parentElement);
					obj.children.item(0).pageuid = GetPageID(obj.children.item(0));
			} catch(e) { return; }
		}
		else 
		{
			if (cell.parentElement.previousSibling.outerHTML.toLowerCase().indexOf("table") > -1)
			{
				try {
					obj = cell.parentElement.previousSibling.children.item(0).children.item(0).children.item(0).children.item(0).lastChild.children.item(0).children.item(0).insertAdjacentElement("beforeEnd", cell.parentElement);
					obj.children.item(0).pageuid = GetPageID(obj.children.item(0));
				} catch(e) { return; }
			}
			else
			{
				cell.parentElement.swapNode(cell.parentElement.previousSibling);
			}
		}
	}	
	else if (pDirection == "down")
	{
		if (cell.parentElement.nextSibling == null || cell.parentElement.nextSibling.children.item(0).id == "")
		{
			if (cell.pageuid == pageid) return;
			try {
					obj = cell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.insertAdjacentElement("afterEnd", cell.parentElement);
					obj.children.item(0).pageuid = GetPageID(obj.children.item(0));
			} catch(e) { return; }
		}
		else
		{
			if (cell.parentElement.nextSibling.outerHTML.toLowerCase().indexOf("table") > -1)
			{
				try {
					obj = cell.parentElement.nextSibling.children.item(0).children.item(0).children.item(0).children.item(0).firstChild.children.item(0).children.item(0).firstChild.insertAdjacentElement("afterEnd", cell.parentElement);
					obj.children.item(0).pageuid = GetPageID(obj.children.item(0));
				} catch(e) { return; }
			}
			else
			{
				cell.parentElement.swapNode(cell.parentElement.nextSibling);
			}

		}
	}
	else if (pDirection == "left")
	{
		if (cell.parentElement.parentElement.parentElement.parentElement.previousSibling == null) return;
		
		if (cell.parentElement.parentElement.parentElement.parentElement.previousSibling.children.item(0).children.item(0).children.length > 9)
		{
			alert("하나의 열에 10개 이상의 포틀릿을 추가할 수 없습니다.");
			return;
		}
		cell.parentElement.parentElement.parentElement.parentElement.previousSibling.children.item(0).children.item(0).appendChild(cell.parentElement);
	}
	else if (pDirection == "right")
	{
		if (cell.parentElement.parentElement.parentElement.parentElement.nextSibling == null) return;
	
		if (cell.parentElement.parentElement.parentElement.parentElement.nextSibling.children.item(0).children.item(0).children.length > 9)
		{
			alert("하나의 열에 10개 이상의 포틀릿을 추가할 수 없습니다.");
			return;
		}
		cell.parentElement.parentElement.parentElement.parentElement.nextSibling.children.item(0).children.item(0).appendChild(cell.parentElement);
	}
	cell.focus();
}

function resizecell(pDirection)
{
	if (selectedCell == "")
	{	
		alert("포틀릿을 선택하세요.");
		return;
	}
	
	if (bInherit)
	{
		alert("상속받은 포탈 페이지는 크기를 조정할 수 없습니다.");
		return;
	}

	var cell = eval(selectedCell);
	
	var curWidth = parseInt(cell.style.width.replace("px", ""));
	
	if (pDirection == "right")
	{
		curWidth += 2;
		try {
			cell.style.width = curWidth.toString();
			cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = curWidth.toString() + "px"; 
		} catch(e) {}
	}	
	else if (pDirection == "left")
	{
		curWidth -= 2;
		try {
			cell.style.width = curWidth.toString();
			cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = curWidth.toString() + "px"; 
		} catch(e) {}
	}
}

function resizerow(pDirection)
{
	if (selectedSubCell == "")
	{	
		alert("행을 선택하세요.");
		return;
	}

	var cell = eval(selectedSubCell);
	
	if (cell.canresize != 1)
	{
		alert("크기를 변경할 수 없는 포틀릿입니다.");
		return;
	}
	
	if (cell.pageuid != GetPageID(cell))
	{
		alert("상속받은 포틀릿은 크기를 변경할 수 없습니다.");
		return;
	}
	
	var curHeight = parseInt(cell.parentElement.style.height.replace("px", ""));

	if (pDirection == "up")
	{
		curHeight += 1;
		try {
			cell.parentElement.style.height = curHeight.toString();
		} catch(e) {}
	}	
	else if (pDirection == "down")
	{
		curHeight -= 1;
		try {
			cell.parentElement.style.height = curHeight.toString();
		} catch(e) {}
	}
}

function resizepage(pDirection)
{
	if (bInherit)
	{
		alert("상속받은 포탈 페이지는 크기를 조정할 수 없습니다.");
		return;
	}

	if (main_table.width == "100%" && (pDirection == "left" || pDirection == "right"))
	{
		alert("최대화 된 너비는 크기를 조절할 수 없습니다.");
		return;
	}
	if (main_table.height == "100%" && (pDirection == "up" || pDirection == "down"))
	{
		alert("최대화 된 높이는 크기를 조절할 수 없습니다.");
		return;
	}

	try
	{
		if (pDirection == "left")
		{
			main_table.width = parseInt(main_table.width.toString().replace("px", "")) - 10;
			txtWidth.value = main_table.width.toString();
		}
		if (pDirection == "right")
		{
			main_table.width = parseInt(main_table.width.toString().replace("px", "")) + 10;
			txtWidth.value = main_table.width.toString();
		}
		if (pDirection == "down")
		{
			main_table.height = parseInt(main_table.height.toString().replace("px", "")) + 10;
			txtHeight.value = main_table.height.toString();
		}
		if (pDirection == "up")
		{
			main_table.height = parseInt(main_table.height.toString().replace("px", "")) - 10;
			txtHeight.value = main_table.height.toString();
		}
	} catch(e) {}
	
}

function GetGUID()
{
	var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
	var ret = ezUtil.GetGUID();
	ret = ret.replace("{", "").replace("}", "").toLowerCase();
	ezUtil = null;
	
	return ret;
}

function GetID()
{
	return count++;
}

function preview()
{
	window.open("PortalPage.aspx?mode=view&pageid=" + pageid);
}

function OpenMaxURL(pURL)
{
	if (pURL == "") return;	
	location.href = pURL;
}

function insertpage()
{
	if (selectedCell == "")
	{
		alert("행을 추가할 열을 선택하세요.");
		return;
	}
	
	if (eval(selectedCell).children.item(0).children.item(0).children.length > 9)
	{
		alert("하나의 열에 10개 이상의 포틀릿을 추가할 수 없습니다.");
		return;
	}
	
	var strHTML = "<table id='main_table_" + GetGUID().substr(0,4) + "' border=1 cellpadding=0 cellspacing=0 width=100% height=100% style='table-layout:fixed;'>";
	strHTML += "<tr id='main_row'>";
	strHTML += "<TD id='td" + GetGUID().substr(0,4) + "' vAlign=top><table border=1 cellpadding=0 cellspacing=0 width=100% valign=top>";
	strHTML += "<TBODY><TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle()'><td align=center>*</td></TR></tbody>";
	strHTML += "</table></td></tr></table>";

	var newrow = eval(selectedCell).children.item(0).insertRow();
	newrow.style.width = "100%";
	newrow.style.height = "100";
	var newcell = newrow.insertCell();
	newcell.id = "subtd" + GetID();
	newcell.uid = GetGUID();
	newcell.pageuid = GetGUID();
	newcell.canremove = 1;
	newcell.canresize = 1;
	newcell.canreplace = 1;
	newcell.style.width = "100%";
	newcell.align = "center";	
	newcell.innerHTML = strHTML;
	selectedSubCell = "";
	newcell.focus();
	
	AttachEvents(newcell);
}

function newpage()
{
	location.href = "PortalPage.aspx";
}

