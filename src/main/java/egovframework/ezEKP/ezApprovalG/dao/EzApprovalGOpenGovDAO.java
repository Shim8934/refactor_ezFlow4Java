package egovframework.ezEKP.ezApprovalG.dao;

import egovframework.ezEKP.ezApprovalG.vo.ApprGOpenGovCsvVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository("EzApprovalGOpenGovDAO")
public class EzApprovalGOpenGovDAO extends EgovAbstractDAO {
    public String getOpenGovDocOpenFlag(Map<String, Object> map) throws Exception {
        return (String) select("EzApprovalGOpenGov.getOpenGovDocOpenFlag", map);
    }

    public String getOpenGovDocHref(Map<String, Object> map) throws Exception {
        return (String) select("EzApprovalGOpenGov.getOpenGovDocHref", map);
    }

    public String getOpenGovAttachHref(Map<String, Object> map) throws Exception {
        return (String) select("EzApprovalGOpenGov.getOpenGovAttachHref", map);
    }

    public void insertGovDocSend(Map<String, Object> map) throws Exception {
        insert("EzApprovalGOpenGov.insertGovDocSend", map);
    }

    public void setOpenGovSendFlagToY() throws Exception {
        update("EzApprovalGOpenGov.setOpenGovSendFlagToY");
    }

    public String getGovSendDocHistorySn() throws Exception {
        return (String) select("EzApprovalGOpenGov.getGovSendDocHistorySn");
    }

    public void insertTodayGovSendDocHistory(String sn) throws Exception {
        insert("EzApprovalGOpenGov.insertTodayGovSendDocHistory", sn);
    }

    //scheduler
    @SuppressWarnings("unchecked")
	public List<ApprGOpenGovCsvVO> getOpenGovCsv(Map<String, Object> map) throws Exception {
        return (List<ApprGOpenGovCsvVO>) list("EzApprovalGOpenGov.getOpenGovCsv", map);

    }
    @SuppressWarnings("unchecked")
	public List<String> getResendDate() throws Exception {
        return (List<String>) list("EzApprovalGOpenGov.getResendDate");
    }

    @SuppressWarnings("unchecked")
	public List<ApprGOpenGovCsvVO> getOpenGovResendCsv(Map<String, Object> map) throws Exception {
        return (List<ApprGOpenGovCsvVO>) list("EzApprovalGOpenGov.getOpenGovResendCsv", map);
    }

}
