package egovframework.ezEKP.ezAttitude.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.util.CellReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import egovframework.com.cmm.EgovMessageSource;

@Component
public class ExcelCellRef {
	
	@Autowired
	EgovMessageSource msg;
	
    public String getName(Cell cell, int cellIndex) {
        int cellNum = 0;
        if(cell != null) {
            cellNum = cell.getColumnIndex();
        }
        else {
            cellNum = cellIndex;
        }

        return CellReference.convertNumToColString(cellNum);
    }

    public String getValue(Cell cell) {
        String value = "";

        if(cell == null) {
            value = "";
        }
        else {
            if( cell.getCellType() == Cell.CELL_TYPE_FORMULA ) {
                value = cell.getCellFormula();
            }
            else if( cell.getCellType() == Cell.CELL_TYPE_NUMERIC ) {
                //텍스트값으로 읽도록 CELL타입을 변경
                //value = cell.getNumericCellValue() + "";
            	if( DateUtil.isCellDateFormatted(cell)) {
    				Date date = cell.getDateCellValue();
    				value = new SimpleDateFormat("yyyy-MM-dd").format(date)+"";
    			} else {
    				cell.setCellType(Cell.CELL_TYPE_STRING);
    				value = cell.getStringCellValue() + "";
    			}
            }
            else if( cell.getCellType() == Cell.CELL_TYPE_STRING ) {
                value = cell.getStringCellValue();
            }
            else if( cell.getCellType() == Cell.CELL_TYPE_BOOLEAN ) {
                value = cell.getBooleanCellValue() + "";
            }
            else if( cell.getCellType() == Cell.CELL_TYPE_ERROR ) {
                value = cell.getErrorCellValue() + "";
            }
            else if( cell.getCellType() == Cell.CELL_TYPE_BLANK ) {
                value = "";
            }
            else { 
                value = cell.getStringCellValue();
            }
        }

        return value;
    }
    
    /**
     * 설명: null 값제거 메소드(문자 공백제거 기본)
     *
     * @param obj
     * @return String[]
     */
    public String[] removeNullString(String[] obj) {
        return removeNullString(obj, true);
    }

    /**
     * 설명: null 값제거 메소드(trimYN == true)이면 공백제거
     *
     * @param obj
     * @param trimYN
     * @return String[]
     */
    public String[] removeNullString(String[] obj, boolean trimYN) {
        String[] tempData = null;

        //값이 있으면 처리
        if (obj != null && obj.length > 0) {
            tempData = obj;
            for (int i = 0; i < tempData.length; i++) {

                if (tempData[i] == null) {
                    tempData[i] = "";
                } else {
                    if (trimYN)
                        tempData[i] = tempData[i].trim();
                }
            }
        }

        return tempData;
    }
    
    /**
     * 널 체크
     * @param String
     * @return boolean
     */
    public boolean nullCheck(String checkStr){
        if(checkStr == null || checkStr.length() == 0){
            return true;
        }
        return false;
    }
    
    /**
     * 입력글자가 최대크기 넘었는지 체크
     * @param String
     * @return boolean
     */
    public boolean byteCheck(String checkStr, int maxByte){
        int en=0;
        int ko=0;
        int etc=0;

        char[] txtChar = checkStr.toCharArray();
        for(int i=0; i < txtChar.length; i++){
            if(txtChar[i] > 'A' && txtChar[i] <= 'Z'){
                en++;
            }else if(txtChar[i] >= '\uAC00' && txtChar[i] <= '\uD7A3'){
                ko++;
                ko++;
            }else{
                etc++;
            }
        }

        int txtByte = en + ko + etc;
        if(txtByte > maxByte) {
            return true;
        }else{
            return false;
        }
    }
    
    /**
     * 정수 체크
     * @param String
     * @return boolean
     */
    public boolean intCheck(String checkStr){
        try {
            Integer.parseInt(checkStr);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 연차형식 체크
     * @param String
     * @return boolean
     */
    public boolean floatCheck(String checkStr){
    	try {
    		Float.parseFloat(checkStr);
    		return true;
    	} catch (Exception e) {
    		return false;
    	}
    }
    
    /**
     * 연차형식 체크
     * @param String
     * @return boolean
     */
    public boolean annualCheck(String checkStr){
    	int commaIdx = checkStr.lastIndexOf(".");
    	if(commaIdx != -1) {
    		String decimal = checkStr.substring(commaIdx+1);
    		if(!(decimal.equals("5") || decimal.equals("0"))) {
    			return false;
    		}
    	}
    	return true;
    }

    /**
     * NULL과 입력최대크기를 체크하여 검증메시지 생성
     * @param String
     * @return boolean
     */
    public String validateCheck(int iRow, String titleStr, String checkStr, int maxLength, String optionStr, Locale locale){
    	
        //널체크
        if(titleStr != null) {
        	if(nullCheck(checkStr)) {
        		return String.valueOf(iRow) + msg.getMessage("ezAttitude.t319", locale) + titleStr+ msg.getMessage("ezAttitude.t318", locale);
            }
        } else {
            return msg.getMessage("ezAttitude.t317", locale);
        }

        //입력최대크기
        if(!nullCheck(checkStr)){
            if(byteCheck(checkStr,maxLength)){
                return String.valueOf(iRow) + msg.getMessage("ezAttitude.t319", locale) + titleStr+ msg.getMessage("ezAttitude.t320", locale) +String.valueOf(maxLength)+ msg.getMessage("ezAttitude.t321", locale);
            }
        }

        //년도(정수) 체크
        if("1".equals(optionStr) && !nullCheck(checkStr)) {
            if(!intCheck(checkStr)) {
                return String.valueOf(iRow) + msg.getMessage("ezAttitude.t319", locale)+ titleStr+ msg.getMessage("ezAttitude.t322", locale);
            }
        }
        
        //연차체크
        if("3".equals(optionStr) && !nullCheck(checkStr)) {
        	if(!floatCheck(checkStr)) {
        		return String.valueOf(iRow) + msg.getMessage("ezAttitude.t319", locale)+ titleStr+ msg.getMessage("ezAttitude.t323", locale);
        	} else {
        		if(!annualCheck(checkStr)) {
        			return String.valueOf(iRow) + msg.getMessage("ezAttitude.t319", locale)+ titleStr+ msg.getMessage("ezAttitude.t324", locale);
        		}
        	}
        }
        
      //입사일 체크
        if("4".equals(optionStr) && !nullCheck(checkStr)) {
        	Pattern p = Pattern.compile("^(\\d+)[/|\\-|\\s]+[0|1](\\d)[/|\\-|\\s]+([0|1|2|3]\\d)$");
        	Matcher m = p.matcher(checkStr);
        	if(!m.find()) {
        		return String.valueOf(iRow) + msg.getMessage("ezAttitude.t319", locale)+ titleStr+ msg.getMessage("ezAttitude.t325", locale);
        	}
        }

        return "";
    }
    
}
