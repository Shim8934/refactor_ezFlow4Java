package egovframework.ezEKP.ezSystem.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezSystem.dao.EzSystemAdminDAO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.CheckName;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;

@Service("EzSystemAdminService")
public class EzSystemAdminServiceImpl implements EzSystemAdminService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminServiceImpl.class);
	
	@Resource(name="EzSystemAdminDAO")
	EzSystemAdminDAO ezSystemAdminDAO;
	
	
	@Override
	public List<SysParamVO> getSysParam(int tenantID) {
		
		List<SysParamVO> list = ezSystemAdminDAO.getSysParam(tenantID);
		List<SysParamVO> afterList = new ArrayList<SysParamVO>();
		
		for(int i = 0; i < list.size(); i++){
			try{
				CheckName.valueOf(list.get(i).getName());
				afterList.add(list.get(i));
			}catch(IllegalArgumentException e){}
		}

		return afterList;
	}

	@Override
	public int updateSysParam(List<Map<String, Object>> list) {
		for(int i=0;i<list.size();i++){
			SysParamVO sysParamVO = new SysParamVO();
			sysParamVO.setName(list.get(i).get("name")+"");
			sysParamVO.setValue(list.get(i).get("value")+"");
			ezSystemAdminDAO.updateSysParam(sysParamVO);
		}
		return 0;
	}

}
