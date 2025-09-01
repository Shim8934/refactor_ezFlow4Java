package egovframework.ezEKP.ezApprovalG.task;

import java.io.File;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.FileTime;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGAdminService;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.let.utl.fcc.service.EzFAL.*;

@Component
public class EzApprovalScheduler extends EzFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzApprovalScheduler.class);

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 

	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzApprovalGAdminService")
	private EzApprovalGAdminService ezApprovalGAdminService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
	@Resource(name = "jspw")
    private String jspw;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;

	@Autowired
	private EzEmailUtil ezEmailUtil;

    @Resource(name = "EzCommonDAO")
    private EzCommonDAO ezCommonDAO;
	
	/**
	 * delete garbage files // 전자결재 대용량첨부 자동삭제기능 사용하지 않음
	 */
	@Scheduled(cron = "${config.cron.dailyApprFileManage}")
	public void dailyApprFileManage() throws Exception {
		logger.debug("dailyApprFileManage scheduler started.");
		logger.debug("dailyApprFileManage scheduler do nothing!");				
		logger.debug("dailyApprFileManage scheduler ended.");
	}
	
	@Scheduled(fixedDelayString = "${config.fixedDelay.susinScheduler}")
	public void susinScheduler() throws Exception{
		if(checkTimer()) {
			logger.debug("susinScheduler started.");
						
			if (!ezEmailScheduler.preScheduler("susinScheduler")) {
				logger.debug("susinScheduler ended.");
				return;
			}
	
            // 아직 스케쥴러 동작중 && 10회미만 (스케쥴러 동작중 서버꺼짐등 실동작 아닌경우 계속 동작 안할 경우 대비) ? return : DB 등록/업데이트
            ezCommonDAO.susinScheduleUpdate("1");
            String susinSceduleCnt = ezCommonService.getTenantConfig("susinSceduleCnt", 0);
            if(!"1".equals(susinSceduleCnt)){
                logger.debug("susinScheduler is running.");
                return;
            }
            try{
			int tryCnt = 0;
			List<HashMap<String, Object>> susinScheduleList = null;
			susinScheduleList = ezApprovalGService.susinScheduleList();
			int idx = 0;
			while(tryCnt++ < 3 && susinScheduleList != null && susinScheduleList.size() > 0) {
				try {
					for(int i = idx; i < susinScheduleList.size();) {
						ezApprovalGService.doSusinSchedule(susinScheduleList.get(i));
						susinScheduleList.remove(i);
					}
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
					idx = idx + 1 >= susinScheduleList.size() ? 0 : idx + 1;
					if(tryCnt == 3) {
						logger.debug("susinScheduler Retry 3 times failed!");
						return;
					}
					Thread.sleep(300);
				}
			}
            }finally {
                ezCommonDAO.susinScheduleUpdate("0");
            }
			logger.debug("susinScheduler ended.");
		}
	}
	
	public boolean checkTimer() throws Exception {
		boolean result = false;
		List<TenantVO> tenantList = ezCommonService.getTenantList();
		for (TenantVO tenantVO : tenantList) {
			if("Y".equals(ezCommonService.getTenantConfig("useSusinSchedulerYn", tenantVO.getTenantId()))) {
				String interval = ezCommonService.getTenantConfig("useSusinSchedulerTime", tenantVO.getTenantId());
				if(interval != null && !"".equals(interval)) {
					int intInterval = Integer.parseInt(interval);
					if(intInterval == 0 || Calendar.getInstance().get(Calendar.MINUTE) % intInterval == 0) {
						result = true;
					}
				}
			}
		}
		return result;
	}
	/**
	 * 만료된 전자결재 대용량첨부파일 삭제 함수
	 */
	private void deleteApprExpireAttach(String realPath) throws Exception {
		logger.debug("deleteApprExpireAttach started.");
		
		List<TenantVO> tenantList = ezCommonService.getTenantList();
		for (TenantVO tenantVO : tenantList) {
			logger.debug("tenantId=" + tenantVO.getTenantId());
			
			String bigSizeApprAttachDelDayStr = ezCommonService.getTenantConfig("BigSizeApprAttachDelDay", tenantVO.getTenantId());
			int bigSizeApprAttachDelDay = Integer.parseInt(bigSizeApprAttachDelDayStr);
			
			// 아직 삭제되지 않은 대용량 첨부파일 리스트를 리턴 (ISBIGATTACH = Y, ISBIGATTACHDEL = N)
			List<ApprGAttachInfoVO> aprBigAttachInfoVOList = ezApprovalGService.getBigAttachFileForDelete(tenantVO.getTenantId());
			
			for (int i = 0; i < aprBigAttachInfoVOList.size(); i++) {
				ApprGAttachInfoVO tempAprBigAttachInfoVO = aprBigAttachInfoVOList.get(i);
				EzFile file = new EzFile(realPath + tempAprBigAttachInfoVO.getAttachFileHref());
				
				if (file.exists()) { // 삭제할 파일이 존재할때만 동작
					BasicFileAttributes attrs = null;
					attrs = Files.readAttributes(file.toPath(), BasicFileAttributes.class);
					
					// 첨부파일이 서버에 저장된 실제 생성날짜를 계산
					FileTime time = attrs.creationTime();
					SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
					String fileCreatedTime = simpleDateFormat.format(new Date(time.toMillis()));
					boolean isBigFileDelDayOver = isDelDayOver(fileCreatedTime, bigSizeApprAttachDelDay);
					
					// 대용량 첨부파일의 저장기간이 만료된 경우, 자동삭제 + 대용량파일 다운로드횟수 제거 + 각 테이블의 ISBIGATTACHDEL 플래그를 'Y'로 갱신
					if (isBigFileDelDayOver == true) {
						logger.debug("expired appr file name=" + file.getName());
						if (file.delete()) {
							logger.debug(file.getName() + " is deleted.");
							// 대용량 첨부파일의 다운로드 제한 횟수 정보 삭제
							ezApprovalGService.deleteBigAttachFileDownloadCnt(tempAprBigAttachInfoVO.getDocID(), tempAprBigAttachInfoVO.getAttachFileSN(), tempAprBigAttachInfoVO.getCompanyID(), tenantVO.getTenantId());
							// 대용량 첨부파일의 삭제여부 플래그 갱신
							ezApprovalGService.updateIsBigAttachDel(tempAprBigAttachInfoVO.getDocID(), tempAprBigAttachInfoVO.getAttachFileSN(), tempAprBigAttachInfoVO.getTblName(), tempAprBigAttachInfoVO.getCompanyID(), tenantVO.getTenantId());
						}
					}
					
				}
			}
		
		}
		
		logger.debug("deleteApprExpireAttach ended.");
	}
	
	// 현재 시간(today)에서 파일의 생성일자(fileDate)를 뺀 날짜가 대용량파일의 저장기간(만료일)을 넘어간다면 true, 넘지 않는다면 false
	public boolean isDelDayOver(String fileDate, int bigSizeMailAttachDelDay) throws Exception {
		try{
			String today = EgovDateUtil.getToday("");
			int dayDiff = EgovDateUtil.getDaysDiff(fileDate, today);
			if (dayDiff > bigSizeMailAttachDelDay) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return false;
		}
	}
	
	public boolean preScheduler(String scheduler) {
		logger.debug("preScheduler started.");
		
		boolean isSchedulerServer = false;
		
		if (config.getProperty("config.Run_Scheduler").equals("YES")) {
			logger.debug("Elect scheduler server.");
			try {
				//set SchedulerServer
				String server = config.getProperty("config.SchedulerServer");
								
				String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setSchedulerServer";
				
				String schedulerParam = "scheduler=" + URLEncoder.encode(scheduler, "UTF-8");
				String serverParam = "server=" + URLEncoder.encode(server, "UTF-8");
				
				String inputParams = schedulerParam + "&" + serverParam;
				logger.debug("inputParams=" + inputParams);
				
				String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);		
				logger.debug("response=" + response);
				
				//sleep 20 seconds
				logger.debug(scheduler + " is sleeping...");
				Thread.sleep(20000);
				
				//get SchedulerServer
				requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getSchedulerServer";
				
				inputParams = schedulerParam;
				logger.debug("inputParams=" + inputParams);
				
				response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
				logger.debug("response=" + response);
				
				JSONParser parser = new JSONParser();
				JSONObject object = (JSONObject)parser.parse(response);
		        
		        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
		        	String schedulerServer = (String)object.get("result");
		        	
		        	if (schedulerServer.equals(server)) {
		        		isSchedulerServer = true;
		        		logger.debug("This is elected as a scheduler server.");
		        	} else {
		        		logger.debug("This is not elected.");
		        	}
		        } else {
		        	logger.error("Cannot get SchedulerServer.");
		        }
				
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		} else {
			logger.debug("config.Run_Scheduler property is not YES.");
		}
		
		logger.debug("preScheduler ended.");
		
		return isSchedulerServer;
	}
}
