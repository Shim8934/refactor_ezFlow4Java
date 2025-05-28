package egovframework.ezEKP.ezApprovalG.vo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import egovframework.ezEKP.ezApprovalG.type.PortletAprListType;
import egovframework.let.user.login.vo.LoginVO;

public class PortletAprInfoVO {
    private String listType;
    private String userID;
    private String deptID;
    private int querySize = 10;
    private int querySize2 = 10;
    private String orderOption;
    private String orderOption2;
    private String basicOrder = "DESC";
    private String basicOrderReverse;
    private String subQuery;
    private int subQueryLength;
    private int orderOptionLength;
    private String mineViewYN;
    private List<ApprGProxyVO> proxyList;
    private String companyID;
    private String userLang;
    private int tenantID;
    private String offSet;
    private String userIDs;
    private String listTypeFlag = "false";

    //완료문서
    private String contId;
    private String userSecCode;
    private String pStrLang;
    private String pubFlag;
    private String docNumber;
    private String docTitle;
    private String drafter;
    private String deptName;
    private String formId;
    private String formName;
    private String endDate1;
    private String endDate2;
    private String startDate;
    private String startDate2;
    private String processDate1;
    private String ivAprFlag;
    private String alFlag;
    private String processDate2;
    private String docState;
    private int pageSize3 = 0;
    private String orderOptionValue;
    private String orderOptionValue2;
    private String approvalFlag;
    private String approvUser;
    private String returnCodeName;
    private String ingCodeName;
    private String watingCodeName;
    private String endCodeName;
    private String locale;
    private String sortValue;
    private String orderOption1;
    private LoginVO userInfo = new LoginVO();
    private String url; 

    public Map<Object, Object> portletAprInfoConvertToAprMap(PortletAprInfoVO portletAprInfoVO) {
        Map<Object, Object> map = new HashMap<>();
        LoginVO userInfo = portletAprInfoVO.getUserInfo();
        map.put("v_LISTTYPE", portletAprInfoVO.getListType());
        map.put("v_USERID", userInfo.getId());
        map.put("deptID", portletAprInfoVO.getDeptID());
        map.put("v_USERIDS", portletAprInfoVO.getUserIDs());
        map.put("v_PAGESIZE", portletAprInfoVO.getQuerySize());// 시작점
        map.put("v_PAGESIZE2", portletAprInfoVO.getQuerySize2()); // 끝점
        map.put("v_ORDEROPTION", portletAprInfoVO.getOrderOption());
        map.put("v_ORDEROPTION2", portletAprInfoVO.getOrderOption2());
        map.put("v_BASICORDER", portletAprInfoVO.getBasicOrder());
        map.put("v_BASICORDER2", portletAprInfoVO.getBasicOrderReverse());
        map.put("v_SPSUBQUERY", portletAprInfoVO.getSubQuery());
        map.put("v_SPSUBQUERYLENGTH", Optional.ofNullable(portletAprInfoVO.getSubQuery()).map(String::length).orElse(0));
        map.put("v_ORDEROPTIONLENGTH", Optional.ofNullable(portletAprInfoVO.getOrderOption()).map(String::length).orElse(0));
        map.put("MineViewYN", portletAprInfoVO.getMineViewYN());
        map.put("proxyList", portletAprInfoVO.getProxyList());
        map.put("v_LISTTYPEFLAG", portletAprInfoVO.ListTypeFlag(portletAprInfoVO.getListType()));
        map.put("v_TENANTID", userInfo.getTenantId());
        map.put("companyID", userInfo.getCompanyID());

        return map;
    }

    public Map<String, Object> portletAprInfoConvertToEndMap(PortletAprInfoVO portletAprInfoVO) {
        Map<String, Object> map = new HashMap<>();
        LoginVO userInfo = portletAprInfoVO.getUserInfo();
        map.put("companyID", userInfo.getCompanyID());
        map.put("v_CONTID", portletAprInfoVO.getContId());
        map.put("v_CONTIDS", portletAprInfoVO.getContId() == null ? null : portletAprInfoVO.getContId().split(","));
        map.put("v_USERID", userInfo.getId());
        map.put("v_USERSECCODE", portletAprInfoVO.getUserSecCode());
        map.put("v_PSTRLANG", portletAprInfoVO.getpStrLang());
        map.put("v_PUBFLAG", portletAprInfoVO.pubFlag);
        map.put("v_SUBQUERY", portletAprInfoVO.getSubQuery());
        map.put("v_DOCNUMBER", portletAprInfoVO.getDocNumber());
        map.put("v_DOCTITLE", portletAprInfoVO.getDocTitle());
        map.put("v_DRAFTER", portletAprInfoVO.getDrafter());
        map.put("v_DEPTNAME", portletAprInfoVO.getDeptName());
        map.put("v_FORMID", portletAprInfoVO.getFormId());
        map.put("v_FORMNAME", portletAprInfoVO.getFormName());
        map.put("v_ENDDATE1", portletAprInfoVO.getEndDate1());
        map.put("v_ENDDATE2", portletAprInfoVO.getEndDate2());
        map.put("v_STARTDATE1", portletAprInfoVO.getStartDate());
        map.put("v_STARTDATE2", portletAprInfoVO.getStartDate2());
        map.put("v_PROCESSDATE1", portletAprInfoVO.getProcessDate1());
        map.put("iv_APRFLAG", portletAprInfoVO.getIvAprFlag());
        map.put("alFlag", portletAprInfoVO.getAlFlag());
        map.put("v_PROCESSDATE2", portletAprInfoVO.getProcessDate2());
        map.put("v_DOCSTATE", portletAprInfoVO.getDocState());
        map.put("v_PAGESIZE", portletAprInfoVO.getQuerySize());
        map.put("v_PAGESIZE2", portletAprInfoVO.getQuerySize2());
        map.put("v_PAGESIZE3", portletAprInfoVO.getPageSize3());
        map.put("v_ORDEROPTION", portletAprInfoVO.getOrderOption());
        map.put("v_ORDEROPTIONLENGTH", Optional.ofNullable(portletAprInfoVO.getOrderOption()).map(String::length).orElse(0));
        map.put("v_ORDEROPTIONVALUE", portletAprInfoVO.getOrderOptionValue());
        map.put("v_tmp", portletAprInfoVO.getSortValue());
        map.put("v_ORDEROPTION2", portletAprInfoVO.getOrderOption2());
        map.put("v_ORDEROPTIONLENGTH2", Optional.ofNullable(portletAprInfoVO.getOrderOption2()).map(String::length).orElse(0));
        map.put("v_ORDEROPTIONVALUE2", portletAprInfoVO.getOrderOptionValue2());
        map.put("approvalFlag", portletAprInfoVO.getApprovalFlag());
        map.put("v_LANGTYPE", userInfo.getLang());
        map.put("v_TENANTID", userInfo.getTenantId());
        map.put("v_APPROVUSER", portletAprInfoVO.getApprovUser());
        map.put("offset", portletAprInfoVO.getOffSet());
        map.put("v_H", portletAprInfoVO.getReturnCodeName());
        map.put("v_I", portletAprInfoVO.getIngCodeName());
        map.put("v_N", portletAprInfoVO.getWatingCodeName());
        map.put("v_Y", portletAprInfoVO.getEndCodeName());

        return map;
    }

    public String ListTypeFlag(String listType) {
        if (PortletAprListType.AprListType.APPR.intValue() == Integer.parseInt(listType)) {
            listTypeFlag = "true";
        }
        return listTypeFlag;
    }

    public String getListType() {
        return listType;
    }

    public void setListType(String listType) {
        this.listType = listType;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getDeptID() {
        return deptID;
    }

    public void setDeptID(String deptID) {
        this.deptID = deptID;
    }

    public int getQuerySize() {
        return querySize;
    }

    public void setQuerySize(int querySize) {
        this.querySize = querySize;
    }

    public int getQuerySize2() {
        return querySize2;
    }

    public void setQuerySize2(int querySize2) {
        this.querySize2 = querySize2;
    }

    public String getOrderOption() {
        return orderOption;
    }

    public void setOrderOption(String orderOption) {
        this.orderOption = orderOption;
    }

    public String getOrderOption2() {
        return orderOption2;
    }

    public void setOrderOption2(String orderOption2) {
        this.orderOption2 = orderOption2;
    }

    public String getBasicOrder() {
        return basicOrder;
    }

    public void setBasicOrder(String basicOrder) {
        this.basicOrder = basicOrder;
    }

    public String getBasicOrderReverse() {
        return basicOrderReverse;
    }

    public void setBasicOrderReverse(String basicOrderReverse) {
        this.basicOrderReverse = basicOrderReverse;
    }

    public String getSubQuery() {
        return subQuery;
    }

    public void setSubQuery(String subQuery) {
        this.subQuery = subQuery;
    }

    public int getSubQueryLength() {
        return subQueryLength;
    }

    public void setSubQueryLength(int subQueryLength) {
        this.subQueryLength = subQueryLength;
    }

    public int getOrderOptionLength() {
        return orderOptionLength;
    }

    public void setOrderOptionLength(int orderOptionLength) {
        this.orderOptionLength = orderOptionLength;
    }

    public String getMineViewYN() {
        return mineViewYN;
    }

    public void setMineViewYN(String mineViewYN) {
        this.mineViewYN = mineViewYN;
    }

    public List<ApprGProxyVO> getProxyList() {
        return proxyList;
    }

    public void setProxyList(List<ApprGProxyVO> proxyList) {
        this.proxyList = proxyList;
    }

    public String getCompanyID() {
        return companyID;
    }

    public void setCompanyID(String companyID) {
        this.companyID = companyID;
    }

    public String getUserLang() {
        return userLang;
    }

    public void setUserLang(String userLang) {
        this.userLang = userLang;
    }

    public int getTenantID() {
        return tenantID;
    }

    public void setTenantID(int tenantID) {
        this.tenantID = tenantID;
    }

    public String getOffSet() {
        return offSet;
    }

    public void setOffSet(String offSet) {
        this.offSet = offSet;
    }

    public String getUserIDs() {
        return userIDs;
    }

    public void setUserIDs(String userIDs) {
        this.userIDs = userIDs;
    }

    public String getListTypeFlag() {
        return listTypeFlag;
    }

    public void setListTypeFlag(String listTypeFlag) {
        this.listTypeFlag = listTypeFlag;
    }

    public String getContId() {
        return contId;
    }

    public void setContId(String contId) {
        this.contId = contId;
    }

    public String getUserSecCode() {
        return userSecCode;
    }

    public void setUserSecCode(String userSecCode) {
        this.userSecCode = userSecCode;
    }

    public String getpStrLang() {
        return pStrLang;
    }

    public void setpStrLang(String pStrLang) {
        this.pStrLang = pStrLang;
    }

    public String getPubFlag() {
        return pubFlag;
    }

    public void setPubFlag(String pubFlag) {
        this.pubFlag = pubFlag;
    }

    public String getDocNumber() {
        return docNumber;
    }

    public void setDocNumber(String docNumber) {
        this.docNumber = docNumber;
    }

    public String getDocTitle() {
        return docTitle;
    }

    public void setDocTitle(String docTitle) {
        this.docTitle = docTitle;
    }

    public String getDrafter() {
        return drafter;
    }

    public void setDrafter(String drafter) {
        this.drafter = drafter;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getFormId() {
        return formId;
    }

    public void setFormId(String formId) {
        this.formId = formId;
    }

    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    public String getEndDate1() {
        return endDate1;
    }

    public void setEndDate1(String endDate1) {
        this.endDate1 = endDate1;
    }

    public String getEndDate2() {
        return endDate2;
    }

    public void setEndDate2(String endDate2) {
        this.endDate2 = endDate2;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getStartDate2() {
        return startDate2;
    }

    public void setStartDate2(String startDate2) {
        this.startDate2 = startDate2;
    }

    public String getProcessDate1() {
        return processDate1;
    }

    public void setProcessDate1(String processDate1) {
        this.processDate1 = processDate1;
    }

    public String getIvAprFlag() {
        return ivAprFlag;
    }

    public void setIvAprFlag(String ivAprFlag) {
        this.ivAprFlag = ivAprFlag;
    }

    public String getAlFlag() {
        return alFlag;
    }

    public void setAlFlag(String alFlag) {
        this.alFlag = alFlag;
    }

    public String getProcessDate2() {
        return processDate2;
    }

    public void setProcessDate2(String processDate2) {
        this.processDate2 = processDate2;
    }

    public String getDocState() {
        return docState;
    }

    public void setDocState(String docState) {
        this.docState = docState;
    }

    public int getPageSize3() {
        return pageSize3;
    }

    public void setPageSize3(int pageSize3) {
        this.pageSize3 = pageSize3;
    }

    public String getOrderOptionValue() {
        return orderOptionValue;
    }

    public void setOrderOptionValue(String orderOptionValue) {
        this.orderOptionValue = orderOptionValue;
    }

    public String getOrderOptionValue2() {
        return orderOptionValue2;
    }

    public void setOrderOptionValue2(String orderOptionValue2) {
        this.orderOptionValue2 = orderOptionValue2;
    }

    public String getApprovalFlag() {
        return approvalFlag;
    }

    public void setApprovalFlag(String approvalFlag) {
        this.approvalFlag = approvalFlag;
    }

    public String getApprovUser() {
        return approvUser;
    }

    public void setApprovUser(String approvUser) {
        this.approvUser = approvUser;
    }

    public String getReturnCodeName() {
        return returnCodeName;
    }

    public void setReturnCodeName(String returnCodeName) {
        this.returnCodeName = returnCodeName;
    }

    public String getIngCodeName() {
        return ingCodeName;
    }

    public void setIngCodeName(String ingCodeName) {
        this.ingCodeName = ingCodeName;
    }

    public String getWatingCodeName() {
        return watingCodeName;
    }

    public void setWatingCodeName(String watingCodeName) {
        this.watingCodeName = watingCodeName;
    }

    public String getEndCodeName() {
        return endCodeName;
    }

    public void setEndCodeName(String endCodeName) {
        this.endCodeName = endCodeName;
    }

    public String getLocale() {
        return locale;
    }

    public void setLocale(String locale) {
        this.locale = locale;
    }

    public String getSortValue() {
        return sortValue;
    }

    public void setSortValue(String sortValue) {
        this.sortValue = sortValue;
    }

    public String getOrderOption1() {
        return orderOption1;
    }

    public void setOrderOption1(String orderOption1) {
        this.orderOption1 = orderOption1;
    }

    public LoginVO getUserInfo() {
        return userInfo;
    }

    public void setUserInfo(LoginVO userInfo) {
        this.userInfo = userInfo;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    public String toString() {
        return "PortletAprInfoVO{" +
                "listType='" + listType + '\'' +
                ", userID='" + userID + '\'' +
                ", deptID='" + deptID + '\'' +
                ", querySize=" + querySize +
                ", orderOption='" + orderOption + '\'' +
                ", basicOrder='" + basicOrder + '\'' +
                ", basicOrderReverse='" + basicOrderReverse + '\'' +
                ", subQuery='" + subQuery + '\'' +
                ", mineViewYN='" + mineViewYN + '\'' +
                ", companyID='" + companyID + '\'' +
                ", userLang='" + userLang + '\'' +
                ", tenantID=" + tenantID +
                ", offSet='" + offSet + '\'' +
                ", listTypeFlag='" + listTypeFlag + '\'' +
                '}';
    }
}
