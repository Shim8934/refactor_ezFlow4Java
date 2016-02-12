package egovframework.ezEKP.ezBoard.service;

import java.util.List;

import egovframework.ezEKP.ezBoard.vo.EzBoardVO;

public interface EzBoardService {

	List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception;

}
