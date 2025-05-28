<%@ page contentType="text/html;charset=UTF-8" %>
<li id="listType1" class="contentlayout_right receives">
    <table>
        <tbody>
        <tr id="ListMsgTo">
            <td class="plr20">
                <a class="btn_arrow mb5" onclick="InsertReceiver(ListViewMsgTo)"><span class="newSubicon newSubicon010"></span></a>
                <a class="btn_arrow" onclick="DeleteReceiver(ListViewMsgTo)"><span class="newSubicon newSubicon009"></span></a>
            </td>
            <td class="inbox" style="width:100%;">
                <ul class="contentlayout">
                    <li class="contentlayout_none">
                        <h2 id="ToTitle" class="receive_tit" style="cursor: pointer;" onclick="SelectReceiverWindow(ToTitle,ListViewMsgTo)">
                            <span id="ToTitleStr"><spring:message code='ezEmail.t66'/></span>
                        </h2>
                    </li>
                </ul>
                <div class="border_box" <c:if test="${type eq 'config'}">style="height:auto;"</c:if>>
                    <div id="ListViewMsgTo" class="conts_box" onclick="SelectReceiverWindow(ToTitle,this)" ondragover="onDragEnter(event, this)" ondrop="onDrop(event, this)"
                         ondblclick="DeleteReceiver(ListViewMsgTo)">
                    </div>
                </div>
            </td>
        </tr>
        <tr id="ListMsgCC">
            <td class="plr20">
                <a class="btn_arrow mb5" onclick="InsertReceiver(ListViewMsgCC)"><span class="newSubicon newSubicon010"></span></a>
                <a class="btn_arrow" onclick="DeleteReceiver(ListViewMsgCC)"><span class="newSubicon newSubicon009"></span></a>
            </td>
            <td class="inbox">
                <ul class="contentlayout">
                    <li class="contentlayout_none">
                        <h2 id="CCTitle" class="receive_tit" style="cursor: pointer;" onclick="SelectReceiverWindow(CCTitle,ListViewMsgCC)">
                            <span><spring:message code='ezEmail.t594'/></span>
                        </h2>
                    </li>
                </ul>
                <div class="border_box">
                    <div id="ListViewMsgCC" class="conts_box" onclick="SelectReceiverWindow(CCTitle,this)" ondragover="onDragEnter(event, this)" ondrop="onDrop(event, this)"
                         ondblclick="DeleteReceiver(ListViewMsgCC)">
                    </div>
                </div>
            </td>
        </tr>
        <tr id="ListMsgBCC">
            <td class="plr20">
                <a class="btn_arrow mb5" onclick="InsertReceiver(ListViewMsgBCC)"><span class="newSubicon newSubicon010"></span></a>
                <a class="btn_arrow" onclick="DeleteReceiver(ListViewMsgBCC)"><span class="newSubicon newSubicon009"></span></a>
            </td>
            <td class="inbox">
                <ul class="contentlayout">
                    <li class="contentlayout_none">
                        <h2 id="BCCTitle" class="receive_tit" style="cursor: pointer;" onclick="SelectReceiverWindow(BCCTitle,ListViewMsgBCC)">
                            <span><spring:message code='ezEmail.t562'/></span>
                        </h2>
                    </li>
                </ul>
                <div class="border_box" style="margin-bottom:0;">
                    <div id="ListViewMsgBCC" class="conts_box" onclick="SelectReceiverWindow(BCCTitle,this)" ondragover="onDragEnter(event, this)" ondrop="onDrop(event, this)"
                         ondblclick="DeleteReceiver(ListViewMsgBCC)">
                    </div>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</li>