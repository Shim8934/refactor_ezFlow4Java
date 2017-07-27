package egovframework.ezMobile.ezSchedule.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.org.apache.xml.internal.security.utils.Base64;

import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezMobile.ezSchedule.dao.MScheduleDAO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MScheduleService")
public class MScheduleServiceImpl extends EgovAbstractServiceImpl implements MScheduleService{
		
	@Resource(name="MScheduleDAO")
	private MScheduleDAO mScheduleDAO;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
	
	@Resource(name="EzScheduleDAO")
	private EzScheduleDAO ezScheduleDAO;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public int insertSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception {
		//본문내용 MHT 저장
		String mhtPath = commonUtil.separator + "doc";
		/*String uploadFilePath = commonUtil.separator + "uploadFile";*/
		String contentPath = defaultPath + mhtPath;
		File file = new File(contentPath);

		if (!file.exists()) {			
			file.mkdirs();
		}
		
		InputStream stream = null;
		OutputStream bos = null;		
		int sID = 0;
		
		try {
			String schedulePath = commonUtil.separator + "{" + UUID.randomUUID().toString() + "}" + ".mht";
			contentPath += schedulePath;

			byte[] ct = Base64.decode(jsonParam.get("content").toString());
			stream = new ByteArrayInputStream(ct);
			bos = new FileOutputStream(contentPath);
	
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}

			//첨부파일 카운트
			String hasattach = "N";
	
			//비서정보 카운트
			String hasattendant = "N";
			
/*			if(attendantId.getLength() > 0) {				
				hasattendant = "Y";
			}		*/	
			//일정 정보 저장
			schedulePath = mhtPath + schedulePath;
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_OWNERID", jsonParam.get("ownerId").toString());
			map.put("v_OWNERNAME", jsonParam.get("ownerName").toString());
			map.put("v_OWNERNAME2", jsonParam.get("ownerName2").toString());
			map.put("v_CREATORID", jsonParam.get("creatorId").toString());
			map.put("v_CREATORNAME", jsonParam.get("creatorName").toString());
			map.put("v_CREATORNAME2", jsonParam.get("creatorName2").toString());
			map.put("v_SCHEDULETYPE", jsonParam.get("scheduleType").toString());
			map.put("v_IMPORTANCE", jsonParam.get("importance").toString());
			map.put("v_HASATTENDANT", hasattendant);
			map.put("v_HASATTACH", hasattach);
			map.put("v_ISPUBLIC", jsonParam.get("isPublic").toString());
			map.put("v_DATETYPE", jsonParam.get("dateType").toString());
			map.put("v_STARTDATE", utcStartDate);
			map.put("v_ENDDATE", utcEndDate);
			map.put("v_REPETITION", "");
			map.put("v_TITLE", jsonParam.get("title").toString());
			map.put("v_LOCATION", jsonParam.get("location").toString());
			map.put("v_CONTENTPATH", schedulePath);
			map.put("v_TENANTID", tenantId);
			
			ezScheduleDAO.insertSchedule(map);
			
			int scheduleId = ezScheduleDAO.getCurScheduleId(null);
			
			/*//첨부파일 저장
			Map<String, Object> attachMap = new HashMap<String, Object>();
						
			for (int i=0; i < attach.getLength(); i++) {
				String[] files = attach.item(i).getTextContent().split("/");				
				String fileName = files[1];
				String filePath = files[0];
				String fileSize = files[2];
				
				filePath = uploadFilePath + commonUtil.separator + filePath;

				attachMap.put("v_SCHEDULEID", scheduleId);
				attachMap.put("v_FILENAME", fileName);
				attachMap.put("v_FILEPATH", filePath);
				attachMap.put("v_FILESIZE", fileSize);
				attachMap.put("v_TENANTID", tenantId);
				
				ezScheduleDAO.insertScheduleAttach(attachMap);
			}					
			
			//참석자 관련 데이터 저장 로직			
			for (int i=0; i < attendantId.getLength(); i++) {								
				String v_attendantId = attendantId.item(i).getTextContent();				
				String v_attendantName = attendantName.item(i).getTextContent();
				String v_attendantName2 = attendantName2.item(i).getTextContent();
				String v_attendantDeptName = attendantDeptName.item(i).getTextContent();
				String v_attendantDeptName2 = attendantDeptName2.item(i).getTextContent();
				
				insertScheduleAttendant(Integer.toString(scheduleId), v_attendantId, v_attendantName, v_attendantName2, v_attendantDeptName, v_attendantDeptName2, tenantId);
			}*/
			
			sID = scheduleId;			
		} catch (Exception e) {
			
		} finally {
			if (stream != null) stream.close();				
			if (bos != null) bos.close();
		}
		return sID;
	}	

	@Override
	public void updateSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		/*String uploadFilePath = commonUtil.separator + "uploadFile";*/
		
		//첨부파일 카운트
		String hasattach = "N";
		
		map.put("v_SCHEDULEID", jsonParam.get("scheduleId").toString());
		map.put("v_MODIFIERID", jsonParam.get("creatorId").toString());
		map.put("v_MODIFIERNAME", jsonParam.get("creatorName").toString());
		map.put("v_MODIFIERNAME2", jsonParam.get("creatorName2").toString());
		map.put("v_IMPORTANCE", jsonParam.get("importance").toString());
		map.put("v_HASATTACH", hasattach);
		map.put("v_ISPUBLIC", jsonParam.get("isPublic").toString());
		map.put("v_DATETYPE", jsonParam.get("dateType").toString());
		map.put("v_STARTDATE", utcStartDate);
		map.put("v_ENDDATE", utcEndDate);
		map.put("v_REPETITION", "");
		map.put("v_TITLE", jsonParam.get("title").toString());
		map.put("v_LOCATION", jsonParam.get("location").toString());
		map.put("v_TENANTID", tenantId);

		ezScheduleDAO.updateSchedule(map);
		
		//mht 내용 변경
		InputStream stream = null;
		OutputStream bos = null;		
		
		try {
			byte[] ct = Base64.decode(jsonParam.get("content").toString());
			stream = new ByteArrayInputStream(ct);
			bos = new FileOutputStream(defaultPath);
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch (Exception e) {
			
		} finally {
			if (stream != null) stream.close();				
			if (bos != null) bos.close();
		}
		//첨부파일 경로 삭제
		//ezScheduleDAO.deleteScheduleAttach(map);
		
		/*//첨부파일 정보 등록		
		Map<String, Object> attachMap = new HashMap<String, Object>();
					
		for (int i=0; i < attach.getLength(); i++) {
			String[] files = attach.item(i).getTextContent().split("/");				
			String fileName = files[1];
			String filePath = files[0];
			String fileSize = files[2];
			
			filePath = uploadFilePath + commonUtil.separator + filePath;

			attachMap.put("v_SCHEDULEID", scheduleid);
			attachMap.put("v_FILENAME", fileName);
			attachMap.put("v_FILEPATH", filePath);
			attachMap.put("v_FILESIZE", fileSize);
			attachMap.put("v_TENANTID", tenantId);
			
			ezScheduleDAO.insertScheduleAttach(attachMap);
		}	*/
	}

	@Override
	public void deleteSchedule(String scheduleId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		ezScheduleService.deleteSchedule(scheduleId, tenantId);				
		ezScheduleService.deleteScheduleRepe(scheduleId, tenantId);
		
		/*ezScheduleService.deleteResource(scheduleId, tenantId);*/		
	}

	@Override
	public MScheduleInfoVO scheduleInfo(String scheduleId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);		
		map.put("v_TENANTID", tenantId);
		
		return mScheduleDAO.scheduleInfo(map);
	}
	
}

