package egovframework.ezEKP.ezPMS.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.ProjectBoardVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzPMSGWController3 {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSGWController2.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzPMSService")
	private EzPMSService ezPMSService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject addBoard(HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards] started");
		
		JSONObject result = new JSONObject();
		
		try {
			ProjectBoardVO projectBoardVO = new ProjectBoardVO();
			projectBoardVO.setTenantId(Integer.parseInt(request.getParameter("tenantId")));
			projectBoardVO.setWriterId(request.getParameter("writerId"));
			projectBoardVO.setWriteDate(request.getParameter("writeDate"));
			projectBoardVO.setWriterName(request.getParameter("writerName"));
			projectBoardVO.setWriterName2(request.getParameter("writerName2"));
			projectBoardVO.setWriterDeptName(request.getParameter("writerDeptname"));
			projectBoardVO.setWriterDeptName2(request.getParameter("writerDeptname2"));
			projectBoardVO.setTitle(request.getParameter("title"));
			projectBoardVO.setWriteContent(request.getParameter("writeContent"));
			projectBoardVO.setWriteType(Integer.parseInt(request.getParameter("writeType")));
			projectBoardVO.setReadCount(0);
			projectBoardVO.setGroupId(Long.parseLong(request.getParameter("groupId")));
			if(!request.getParameter("taskId").equals("null")) {
				projectBoardVO.setTaskId(Long.parseLong(request.getParameter("taskId")));
			}
			projectBoardVO.setWriterPosition(request.getParameter("writerPosition"));
			projectBoardVO.setWriterPosition2(request.getParameter("writerPosition2"));
			projectBoardVO.setWriteOverview(request.getParameter("writeOverview"));
			
			ezPMSService.addBoard(projectBoardVO);
			
			result.put("status", "ok");
			result.put("code", 0);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		LOGGER.debug("ezPMS G/W [POST /rest/ezPMS/boards] ended");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPMS/boards/list", method = RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBoardList(HttpServletRequest request) {
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list] started");
		JSONObject result = new JSONObject();
		
		try {
			Long projectId = Long.parseLong(request.getParameter("projectId"));
			Long groupId = -1L;
			Long taskId = -1L;
			if(!request.getParameter("groupId").equals("null")) {
				groupId = Long.parseLong(request.getParameter("groupId"));
			} 
			if(!request.getParameter("taskId").equals("null")) {
				taskId = Long.parseLong(request.getParameter("taskId"));
			}
			List<ProjectBoardVO> boardList = ezPMSService.getBoardList(projectId, groupId, taskId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", boardList);		
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			e.printStackTrace();
		}
		LOGGER.debug("ezPMS G/W [GET /rest/ezPMS/boards/list] ended");
		return result;
	}
}
