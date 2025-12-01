package ifms.common.util;

import org.apache.commons.lang3.math.NumberUtils;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public class PagingVO {

    private int listCount = 10;	//목록건수(목록내 출력건수) - default 20건
    private int pageSize = 10;	//페이징화면의 표기건수 - default 10건
    private int pageNo = 1;		//페이지번호 - default 1페이지
    private int totalCount;		//총건수
    private int startNo;		//시작번호
    private int endNo;			//종료번호
    private int startIndex;		//시작번호(페이징화면)
    private int endIndex;		//종료번호(페이징화면)
    private int lastIndex;		//마지막번호(페이징화면)
    private int prevBtnIndex;	//이전버튼 인덱스
    private int nextBtnIndex;	//다음버튼 인덱스

    public PagingVO(Map<String, Object> requestMap) {
        // 목록건수 설정
        if (StringUtils.isEmpty(requestMap.get("listCount")) == false) {
            this.listCount = NumberUtils.toInt(String.valueOf(requestMap.get("listCount")));
        }
        // 페이징 화면 건수 설정
        if (StringUtils.isEmpty(requestMap.get("pageSize")) == false) {
            this.pageSize = NumberUtils.toInt(String.valueOf(requestMap.get("pageSize")));
        }
        // 페이지 번호 설정
        if (StringUtils.isEmpty(requestMap.get("pageNo")) == false) {
            this.pageNo = NumberUtils.toInt(String.valueOf(requestMap.get("pageNo")));
        }
    }

    public int getListCount() {
        return listCount;
    }
    public void setListCount(int listCount) {
        this.listCount = listCount;
    }
    public void setListCount(String listCount) {
        if (StringUtils.isEmpty(listCount) == false) {
            this.listCount = Integer.parseInt(listCount);
        }
    }
    public int getPageSize() {
        return pageSize;
    }
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    public int getTotalCount() {
        return totalCount;
    }
    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }
    public int getPageNo() {
        return pageNo;
    }
    public void setPageNo(int pageNo) {
        //페이지번호는 1부터 시작
        if (pageNo > 0) {
            this.pageNo = pageNo;
        }
    }
    public void setPageNo(String pageNo) {
        if (StringUtils.isEmpty(pageNo) == false) {
            int iPageNo = Integer.parseInt(pageNo);
            if (iPageNo > 0) {
                this.pageNo = iPageNo;
            }
        }
    }

    public int getStartNo() {
        this.startNo = ((this.pageNo - 1) * this.listCount);
        return startNo;
    }

    public int getEndNo() {
        this.endNo = Math.min(this.startNo + this.listCount, this.totalCount);
        return endNo;
    }

    public int getStartIndex() {
        this.startIndex = ((this.pageNo - 1) / this.pageSize) * this.pageSize + 1;
        return this.startIndex;
    }

    public int getEndIndex() {
        int lastPageIndex = this.getLastIndex();
        this.endIndex = Math.min(this.startIndex + this.pageSize - 1, lastPageIndex);
        return endIndex;
    }

    public int getLastIndex() {
        this.lastIndex = (this.totalCount % this.listCount == 0) ? (this.totalCount / this.listCount) : (this.totalCount / this.listCount) + 1;
        return this.lastIndex;
    }

    public int getPrevBtnIndex() {
        int iStartIndex = this.getStartIndex();
        if (iStartIndex > 1) {
            this.prevBtnIndex = iStartIndex - 1;
        } else {
            this.prevBtnIndex = 1;
        }
        return this.prevBtnIndex;
    }

    public int getNextBtnIndex() {
        int iLastIndex = this.getLastIndex();
        int iEndIndex = this.getEndIndex();
        if (iEndIndex < iLastIndex) {
            this.nextBtnIndex = iEndIndex + 1;
        } else {
            this.nextBtnIndex = iLastIndex;
        }
        return this.nextBtnIndex;
    }

    public void setTotalCount(List<Map<String, Object>> list) {
        if(list != null && list.size() > 0) {
            Map<String, Object> m = (Map<String, Object>)list.get(0);
            this.totalCount = ((BigDecimal)m.get("totalCnt")).intValue();
        }else {
            this.totalCount = 0;
        }
    }

    @Override
    public String toString() {
        return "PagingVO [listCount=" + listCount + ", pageSize=" + pageSize + ", pageNo=" + pageNo + ", totalCount="
                + totalCount + ", startNo=" + this.getStartNo() + ", endNo=" + this.getEndNo() + ", startIndex=" + this.getStartIndex()
                + ", endIndex=" + this.getEndIndex() + ", lastIndex=" + this.getLastIndex() + ", prevBtnIndex=" + this.getPrevBtnIndex()
                + ", nextBtnIndex=" + this.getNextBtnIndex() + "]";
    }
}
