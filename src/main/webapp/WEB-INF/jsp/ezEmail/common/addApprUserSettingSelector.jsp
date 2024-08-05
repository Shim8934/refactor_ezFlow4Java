<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:set var="title" value="${param.rightPageType eq 'approver' ? 'email.appr.approver.add.list' : 'email.appr.exception.add.list'}" />
<li class="contentlayout_right receives" style="margin-top:8px;">
    <table>
        <tbody>
        <tr>
            <td style="width: 30px; text-align: center;">
                <img onclick="addByArrow();" src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;">
	            <br>
				<img onclick="deleteByArrow();" src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;">
            </td>
            <td class="inbox">
                <ul class="contentlayout">
                    <li class="contentlayout_none inline">
                        <h2 class="receiver_tltype01">
                        	<span>
                        		<spring:message code="${title}"/>
                        		<span id="selected-count" class="c_blue ml10" style="padding: unset;">0</span> <spring:message code="common.unit.user"/>
                        	</span>
                        </h2>
                    </li>
                </ul>

                <div class="receiver_borderbox" style="height:${param.treeHeight}px; overflow:auto; width: calc(100vw - 75vw);">
                    <div id="ListViewMsgTo"></div>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</li>
