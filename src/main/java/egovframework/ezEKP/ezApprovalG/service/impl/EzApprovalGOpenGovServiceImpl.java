package egovframework.ezEKP.ezApprovalG.service.impl;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGOpenGovDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGOpenGovService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovCsvVO;
import kr.dogfoot.hwplib.object.HWPFile;
import kr.dogfoot.hwplib.object.bodytext.Section;
import kr.dogfoot.hwplib.object.bodytext.control.Control;
import kr.dogfoot.hwplib.object.bodytext.control.ControlTable;
import kr.dogfoot.hwplib.object.bodytext.control.ControlType;
import kr.dogfoot.hwplib.object.bodytext.control.table.Cell;
import kr.dogfoot.hwplib.object.bodytext.control.table.Row;
import kr.dogfoot.hwplib.object.bodytext.paragraph.Paragraph;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@Service
public class EzApprovalGOpenGovServiceImpl extends EgovAbstractServiceImpl implements EzApprovalGOpenGovService {

    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGOpenGovServiceImpl.class);

    @Autowired
    private Properties config;

    @Resource(name = "EzApprovalGOpenGovDAO")
    EzApprovalGOpenGovDAO ezApprovalGOpenGovDAO;

    @Override
    public String getOpenGovDocOpenFlag(String docId) throws Exception {
        logger.debug("getOpenGovDocOpenFlag started.");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("docId", docId);

        String result = ezApprovalGOpenGovDAO.getOpenGovDocOpenFlag(map);

        logger.debug("getOpenGovDocOpenFlag ended. result = " + result);

        return result;
    }

    @Override
    public String getOpenGovDocHref(String docId) throws Exception {
        logger.debug("getOpenGovDocHref started.");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("docId", docId);

        String result = ezApprovalGOpenGovDAO.getOpenGovDocHref(map);

        logger.debug("getOpenGovDocHref ended. result = " + result);

        return result;
    }

    @Override
    public String getOpenGovAttachHref(String docId, String sn) throws Exception {
        logger.debug("getOpenGovAttachHref started. docId = " + docId + ", sn = " + sn);

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("docId", docId);
        map.put("sn", sn);

        String result = ezApprovalGOpenGovDAO.getOpenGovAttachHref(map);

        logger.debug("getOpenGovAttachHref ended. result = " + result);

        return result;
    }

    @Override
    public void insertGovDocSend(String docId, String fileId) throws Exception {
        logger.debug("insertGovDocSend started.");

        String attachSn = "";
        String type = "";

        if (fileId.length() == 20) {
            attachSn = "0";
            type = "DOC";
        } else {
            attachSn = fileId.substring(20);
            type = "FILE";
        }

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("docId", docId);
        map.put("attachSn", attachSn);
        map.put("type", type);
        map.put("companyNum", config.getProperty("openGov_companyNum"));

        ezApprovalGOpenGovDAO.insertGovDocSend(map);

        logger.debug("insertGovDocSend ended.");
    }

    //scheduler
    @Override
    public List<String> getOpenGovCsv() throws Exception {
        logger.debug("getOpenGovCsv started.");

        String companyNum = config.getProperty("openGov_companyNum");
        String companyName = config.getProperty("openGov_companyName");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("companyNum", companyNum);
        map.put("companyName", companyName);

        List<ApprGOpenGovCsvVO> csvList = ezApprovalGOpenGovDAO.getOpenGovCsv(map);
        List<String> list = new ArrayList<String>();

        for (ApprGOpenGovCsvVO csv : csvList) {
            StringBuilder csvRow = new StringBuilder();
            csvRow.append(csv.getDocID() + companyNum + "|");
            csvRow.append(csv.getN2() + "|");
            csvRow.append(csv.getN3() + "|");
            csvRow.append(csv.getN4() + "|");
            csvRow.append(csv.getN5() + "|");
            csvRow.append(csv.getN6() + "|");
            csvRow.append(csv.getN7() + "|");
            csvRow.append(csv.getDocTitle() + "|");
            csvRow.append(csv.getN9() + "|");
            csvRow.append(csv.getCreateDate() + "|");
            csvRow.append(csv.getCompanyCode() + "|");
            csvRow.append(csv.getCompanyName() + "|");
            csvRow.append(csv.getWriterDeptID() + "|");
            csvRow.append(csv.getWriterDeptName() + "|");
            csvRow.append(csv.getWriterName() + "|");
            csvRow.append(csv.getN16() + "|");
            csvRow.append(csv.getDocNo() + "|");
            csvRow.append(csv.getKeepingPeriod() + "|");
            csvRow.append(csv.getPublicityCode() + "|");
            csvRow.append(csv.getBasis() + "|");
            csvRow.append(csv.getReason() + "|");
            csvRow.append(csv.getN22() + "|");
            csvRow.append(csv.getN23() + "|");
            csvRow.append(csv.getN24() + "|");
            csvRow.append(csv.getN25() + "|");
            csvRow.append(csv.getListOpenFlag() + "|");
            csvRow.append(csv.getN27() + "|");
            csvRow.append(csv.getN28() + "|");
            csvRow.append(csv.getAprMemberTitle() + "|");
            csvRow.append(csv.getAprMemberJobTitle() + "|");
            csvRow.append(csv.getOpenLimitDate() + "|");
            csvRow.append(csv.getN32() + "|");
            csvRow.append(csv.getN33() + "|");
            csvRow.append(csv.getN34() + "|");
            csvRow.append(csv.getFileList());

            list.add(csvRow.toString());
        }

        logger.debug("getOpenGovCSV ended");

        return list;
    }

    private List<String> getResendDate() throws Exception {
        logger.debug("getResendDate started.");

        List<String> list = ezApprovalGOpenGovDAO.getResendDate();

        logger.debug("getResendDate ended. list.size = " + list.size());

        return list;
    }

    @Override
    public List<String> getOpenGovResendCsv() throws Exception {
        logger.debug("getOpenGovResendCsv started.");

        List<String> resendDate = getResendDate();

        if (resendDate.size() == 0 || resendDate == null || resendDate.toString().equals("[null]")) {
            return null;
        }

        String companyNum = config.getProperty("openGov_companyNum");
        String companyName = config.getProperty("openGov_companyName");

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("companyNum", companyNum);
        map.put("companyName", companyName);
        map.put("resendDate", resendDate);

        List<ApprGOpenGovCsvVO> csvList = ezApprovalGOpenGovDAO.getOpenGovResendCsv(map);
        List<String> list = new ArrayList<String>();

        for (ApprGOpenGovCsvVO csv : csvList) {
            StringBuilder csvRow = new StringBuilder();
            csvRow.append(csv.getDocID() + config.getProperty("openGov_companyNum") + "|");
            csvRow.append(csv.getN2() + "|");
            csvRow.append(csv.getN3() + "|");
            csvRow.append(csv.getN4() + "|");
            csvRow.append(csv.getN5() + "|");
            csvRow.append(csv.getN6() + "|");
            csvRow.append(csv.getN7() + "|");
            csvRow.append(csv.getDocTitle() + "|");
            csvRow.append(csv.getN9() + "|");
            csvRow.append(csv.getCreateDate() + "|");
            csvRow.append(csv.getCompanyCode() + "|");
            csvRow.append(csv.getCompanyName() + "|");
            csvRow.append(csv.getWriterDeptID() + "|");
            csvRow.append(csv.getWriterDeptName() + "|");
            csvRow.append(csv.getWriterName() + "|");
            csvRow.append(csv.getN16() + "|");
            csvRow.append(csv.getDocNo() + "|");
            csvRow.append(csv.getKeepingPeriod() + "|");
            csvRow.append(csv.getPublicityCode() + "|");
            csvRow.append(csv.getBasis() + "|");
            csvRow.append(csv.getReason() + "|");
            csvRow.append(csv.getN22() + "|");
            csvRow.append(csv.getN23() + "|");
            csvRow.append(csv.getN24() + "|");
            csvRow.append(csv.getN25() + "|");
            csvRow.append(csv.getListOpenFlag() + "|");
            csvRow.append(csv.getN27() + "|");
            csvRow.append(csv.getN28() + "|");
            csvRow.append(csv.getAprMemberTitle() + "|");
            csvRow.append(csv.getAprMemberJobTitle() + "|");
            csvRow.append(csv.getOpenLimitDate() + "|");
            csvRow.append(csv.getN32() + "|");
            csvRow.append(csv.getN33() + "|");
            csvRow.append(csv.getN34() + "|");
            csvRow.append(csv.getFileList());

            list.add(csvRow.toString());
        }

        logger.debug("getOpenGovResendCsv ended.");

        return list;
    }

    @Override
    public void setOpenGovSendFlagToY() throws Exception {
        logger.debug("setOpenGovSendFlagToY started.");

        ezApprovalGOpenGovDAO.setOpenGovSendFlagToY();

        logger.debug("setOpenGovSendFlagToY ended.");
    }

    @Override
    public void insertTodayGovSendDocHistory() throws Exception {
        logger.debug("insertTodayGovSendDocHistory started.");

        String sn = ezApprovalGOpenGovDAO.getGovSendDocHistorySn();

        ezApprovalGOpenGovDAO.insertTodayGovSendDocHistory(sn);

        logger.debug("insertTodayGovSendDocHistory ended.");
    }

    @Override
    public void setHwpSealSignEmpty(HWPFile hwpFile) throws Exception {
        logger.debug("setHwpSealSignEmpty started");

        if (!findHwpField("sealsign", hwpFile)) {
            logger.debug("setHwpSealSignEmpty ended");
            return;
        }

        for (Section s : hwpFile.getBodyText().getSectionList()) {
            for (Paragraph p : s) {
                if (p == null || p.getControlList() == null) {
                    //return false; 2019.09.03 천성준 - 한글양식에 줄이 2이상 일때, 필드 검색중 줄이 넘어가면 false를 반환해버려서 찾으려는 필드가 존재해도 찾지 못하는 현상 수정
                    continue;
                }

                for (Control c : p.getControlList()) {
                    if (c.getType() == ControlType.Table) {
                        ControlTable ct = (ControlTable) c;

                        for (Row row : ct.getRowList()) {
                            for (Cell cell : row.getCellList()) {

                                // 문단안에 다른 표가 있을경우 한번더 탐색하도록 수정
                                for (Paragraph pp : cell.getParagraphList()) {
                                    if (pp.getControlList() != null) {
                                        for (Control cc : pp.getControlList()) {
                                            if (cc.getType() == ControlType.Table) {
                                                ControlTable ctt = (ControlTable) cc;
                                                for (Row roww : ctt.getRowList()) {
                                                    for (Cell celll : roww.getCellList()) {
                                                        if (celll.getListHeader().getFieldName() != null && celll.getListHeader().getFieldName().equals("sealsign")) {
                                                            celll.getListHeader().setWidth(0);
                                                            celll.getListHeader().setTextWidth(0);
                                                            celll.getListHeader().setFieldName("");
                                                            celll.getListHeader().setHeight(0);
                                                            celll.getListHeader().setParaCount(0);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        logger.debug("setHwpSealSignEmpty ended");
    }

    /**
     * @param fieldName
     * @param hwpFile
     * @return
     * @throws Exception 한글파일에서 필드속성 존재여부 체크
     */
    private boolean findHwpField(String fieldName, HWPFile hwpFile) throws Exception {
        logger.debug("findHwpField started");

        for (Section s : hwpFile.getBodyText().getSectionList()) {
            for (Paragraph p : s) {
                //section이 여러개 일 경우, 내부에서 리턴시켜 첫번째만 탐색하는 경우가 있어서 수정. 2019-09-25 홍대표
                ArrayList<Control> controlList = p.getControlList();
                if (controlList == null) {
                    continue;
                }

                for (Control c : controlList) {
                    if (c.getType() == ControlType.Table) {
                        ControlTable ct = (ControlTable) c;

                        for (Row row : ct.getRowList()) {
                            for (Cell cell : row.getCellList()) {

                                // 문단안에 다른 표가 있을경우 한번더 탐색하도록 수정
                                for (Paragraph pp : cell.getParagraphList()) {
                                    if (pp.getControlList() != null) {
                                        for (Control cc : pp.getControlList()) {
                                            if (cc.getType() == ControlType.Table) {
                                                ControlTable ctt = (ControlTable) cc;

                                                for (Row roww : ctt.getRowList()) {
                                                    for (Cell celll : roww.getCellList()) {
                                                        if (celll.getListHeader().getFieldName() != null && celll.getListHeader().getFieldName().equals(fieldName)) {
                                                            return true;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                if (cell.getListHeader().getFieldName() != null && cell.getListHeader().getFieldName().equals(fieldName)) {
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
        }

        logger.debug("findHwpField ended");

        return false;
    }
}
