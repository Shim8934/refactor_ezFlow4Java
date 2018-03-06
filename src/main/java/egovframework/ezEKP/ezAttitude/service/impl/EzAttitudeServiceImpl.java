package egovframework.ezEKP.ezAttitude.service.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezAttitude.dao.EzAttitudeDAO;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzAttitudeService")
public class EzAttitudeServiceImpl implements EzAttitudeService{
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzAttitudeDAO ezAttitudeDAO;

	@Override
	public Object getAttitudeInfo(String userId, String date, String typeId,
			int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int insertAttitude(String writerId, String deptId, String startdate,
			String enddate, String starttime, String endtime, String region,
			String mobile, String bizsub, String content, String ip,
			String typeId, String companyId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<Object> getAttitudeList(String pidList, String yrmh,
			String typeId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Object> getAttitudeStatisticsList(String pidList, String yrmh,
			int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId,
			int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getWriteFormHtml(String formId, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateAttitude(String attitudeId, String startdate,
			String enddate, String starttime, String endtime, String region,
			String mobile, String bizsub, String content, String ip,
			String typeId, String companyId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteAttitude(String attitudeId, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertAttitudeApplication(String attitudeId, String writerId,
			String writerName, String writerName2, String writerTitle,
			String writerTitle2, String writerDeptId, String writerDeptName,
			String writerDeptName2, String changeDate, String changeTime,
			String content, String companyId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public String getAttitudeApplStatus(String attitudeId, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateAttitudeApplication(String attitudeId, String changeDate,
			String changeTime, String content, String companyId, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateAttitudeApplicationApproval(String attitudeId,
			String apprUserId, String apprUserName, String apprUserName2,
			String apprStatus, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deptExcelDownload(String downMode, String pidList, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<Map<String, String>> getDeptAttitudeList(String pidList,
			int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateAttitudeUserConfig(int tenantID, String userID,
			String workStartTime, String workEndTime) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertAttitudeUserConfig(int tenantID, String companyID,
			String userID, String workStartTime, String workEndTime)
			throws Exception {
		// TODO Auto-generated method stub
		
	}
}
