package egovframework.ezEKP.ezApprovalG.dao;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzApprovalGDAO")
public class EzApprovalGDAO extends EgovAbstractDAO{

	public String aprrovalTest() throws Exception{
		return (String) select("test");
	}

}
