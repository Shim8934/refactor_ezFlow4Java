<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<li class="contentlayout_right receives" style="margin-top:8px;">
    <table>
        <tbody>
        <tr>
            <td class="plr20">
                <a class="btn_arrow mb5" onclick="addDistributionListByArrow();"><span class="newSubicon newSubicon010"></span></a>
                <a class="btn_arrow" onclick="deleteDistributionListByArrow();"><span class="newSubicon newSubicon009"></span></a>
            </td>
            <td class="inbox">
                <ul class="contentlayout">
                    <li class="contentlayout_none inline">
                        <h2 class="receive_tit"><span><spring:message code='ezEmail.t659' /><span id="selected-count" class="c_blue ml10">0</span> <spring:message code='common.unit.user' /></span></h2>
                    </li>
                </ul>

                <div class="border_box mb0" style="height:${param.treeHeight}px; overflow:auto;">
                    <div id="ListViewMsgTo">

                    </div>
                    <%--<table id="selected-table" class="mainlist">
                        &lt;%&ndash;<tbody>
                        <tr>
                            <td>홍길동</td>
                        </tr>
                        </tbody>&ndash;%&gt;
                    </table>--%>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</li>
