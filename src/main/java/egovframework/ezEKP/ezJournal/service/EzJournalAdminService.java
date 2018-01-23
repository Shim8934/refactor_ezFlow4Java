package egovframework.ezEKP.ezJournal.service;

import java.util.ArrayList;
import java.util.List;

import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;

public interface EzJournalAdminService {

	public List<JournaltypeVO> getJournaltypeList(String companyId, int tenantId);
	
	public String updateJournaltype(ArrayList<JournaltypeVO> journaltypeList, String companyId, int tenantId);
	
	public String insertJournaltype(String companyId, int tenantId, ArrayList<JournaltypeVO> journaltypeList);

}
