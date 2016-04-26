package egovframework.ezEKP.ezApprovalG.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzApprovalGDAO")
public class EzApprovalGDAO extends EgovAbstractDAO{

	public ApprGLeftVO getListHeader(Map<String, Object> map) throws Exception{
		return (ApprGLeftVO) select("EzApprovalG.getListHeader", map);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getUseContInfo1(String deptID) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getUseContInfo1", deptID);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getUseContInfo2(String deptID) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getUseContInfo2", deptID);
	}

	@SuppressWarnings("unchecked")
	public List<ApprGLeftVO> getUseContInfo3(String deptID) throws Exception{
		return (List<ApprGLeftVO>) list("EzApprovalG.getUseContInfo3", deptID);
	}

	public ApprGLeftVO getCode2Name(Map<String, Object> map) throws Exception{
		return (ApprGLeftVO) select("EzApprovalG.getCode2Name", map);
	}

	public ApprGLeftVO getName2Code(Map<String, Object> map) throws Exception{
		return (ApprGLeftVO) select("EzApprovalG.getName2Code", map);
	}

}
