package egovframework.ezEKP.ezBoard.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;

@Service("EzBoardService")
public class EzBoardServiceImpl implements EzBoardService {
	
	@Resource(name="EzBoardDAO")
	private EzBoardDAO ezBoardDAO;

	@Override
	public List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception{
		return ezBoardDAO.getLeft_BoardSTD(redirectBoardID);
	}

}
