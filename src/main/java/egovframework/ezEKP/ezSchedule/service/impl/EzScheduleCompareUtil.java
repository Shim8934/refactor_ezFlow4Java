package egovframework.ezEKP.ezSchedule.service.impl;

import java.util.Comparator;

import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;

public class EzScheduleCompareUtil implements Comparator<ScheduleInfoVO>{

	@Override
	public int compare(ScheduleInfoVO o1, ScheduleInfoVO o2) {
		//1차적으로 dateType으로 ASC 정렬
		if (o1.getDateType().compareTo(o2.getDateType()) == 0) {
			//2차적으로 startDate로 ASC 정렬
			if (o1.getStartDate().compareTo(o2.getStartDate()) == 0) {
				//3차적으로 endDate로 ASC 정렬				
				if (o1.getEndDate().compareTo(o2.getEndDate()) == 0) {
					//4차적으로 title로 ASC 정렬
					return o1.getTitle().compareTo(o2.getTitle());
				} else {
					return o1.getEndDate().compareTo(o2.getEndDate());	
				}
			} else {
				return o1.getStartDate().compareTo(o2.getStartDate());
			}
		} else {
			return o1.getDateType().compareTo(o2.getDateType());
		}		
	}	
}