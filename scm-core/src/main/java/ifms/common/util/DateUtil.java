package ifms.common.util;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;

public class DateUtil {

    /**
     * 현재날짜
     * @param pattern
     * @return
     */
    public final static String getDate(String pattern) {
        return LocalDate.now().format(DateTimeFormatter.ofPattern(pattern));
    }

    /**
     * minusYear - 이전년
     * @param d - yyyy
     * @param term - 기간
     * @return
     */
    public final static String minusYear(String d, int term) {
        return calculate(d.length(), d, term, 1);
    }

    /**
     * addYear - 이후년
     * @param d - yyyy
     * @param term - 기간
     * @return
     */
    public final static String addYear(String d, int term) {
        return calculate(d.length(), d, term, 2);
    }

    /**
     * minusMonth - 이전달
     * @param d - yyyyMM 또는 yyyyMMdd
     * @param term - 기간
     * @return
     */
    public final static String minusMonth(String d, int term) {
        return calculate(d.length(), d, term, 3);
    }

    /**
     * addMonth - 이후달
     * @param d - yyyyMM 또는 yyyyMMdd
     * @param term - 기간
     * @return
     */
    public final static String addMonth(String d, int term) {
        return calculate(d.length(), d, term, 4);
    }

    /**
     * minusDay - 이전일
     * @param d - yyyyMMdd
     * @param term - 기간
     * @return
     */
    public final static String minusDay(String d, int term) {
        return calculate(d.length(), d, term, 5);
    }

    /**
     * addDay - 이후일
     * @param d - yyyyMMdd
     * @param term - 기간
     * @return
     */
    public final static String addDay(String d, int term) {
        return calculate(d.length(), d, term, 6);
    }

    /**
     * pickerFirstDay - 날짜의 철쨋날 - yyyyMM01
     * @param d - yyyyMM 또는 yyyyMMdd
     * @param term - 기간
     * @return
     */
    public final static String pickerFirstDay(String d, int term) {
        return calculate(d.length(), d, term, 7);
    }

    /**
     * pickerLastDay - 날짜의 마지막날 - yyyyMM28, yyyyMM29, yyyyMM30, yyyyMM31 중에 하나
     * @param d - yyyyMM 또는 yyyyMMdd
     * @param term - 기간
     * @return
     */
    public final static String pickerLastDay(String d, int term) {
        return calculate(d.length(), d, term, 8);
    }

    /**
     * 날짜 계산하기
     * @param size
     * @param d
     * @param term
     * @param type
     * @return
     */
    private final static String calculate(int size, String d, int term, int type) {

        /* 날짜 길이 체크하기 */
        boolean status = true;
        switch(type) {
            case 1:														/* minusYear - 이전년 */
                if(!(size == 4 || size == 6 || size == 8)) { status = false; } break;
            case 2:														/* addYear - 이후년 */
                if(!(size == 4 || size == 6 || size == 8)) { status = false; } break;
            case 3:														/* minusMonth - 이전달 */
                if(!(size == 6 || size == 8)) { status = false; } break;
            case 4:														/* addMonth - 이후달 */
                if(!(size == 6 || size == 8)) { status = false; } break;
            case 5:														/* minusDay - 이전일 */
                if(size != 8) { status = false; } break;
            case 6:														/* addDay - 이후일 */
                if(size != 8) { status = false; } break;
            case 7:														/* pickerFirstDay - 날짜의 철쨋날 */
                if(!(size == 6 || size == 8)) { status = false; } break;
            case 8:														/* pickerLastDay - 날짜의 마지막날 */
                if(!(size == 6 || size == 8)) { status = false; } break;
        }

        /* 검증실패 */
        if(!status) {
            return d;
        }

        String pattern = "yyyy";

        int year = Integer.parseInt(d.substring(0, 4));

        int month = 1;
        if(size >= 6) {
            month = Integer.parseInt(d.substring(4, 6));
            pattern = "yyyyMM";
        }

        int date = 1;
        if(size == 8) {
            date = Integer.parseInt(d.substring(6, 8));
            pattern = "yyyyMMdd";
        }

        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, date);

        /* 날짜 계산하기 */
        switch(type) {
            case 1:				/* minusYear - 이전년 */
                cal.add(Calendar.YEAR, -term); break;
            case 2:				/* addYear - 이후년 */
                cal.add(Calendar.YEAR, term); break;
            case 3:				/* minusMonth - 이전달 */
                cal.add(Calendar.MONTH, -term); break;
            case 4:				/* addMonth - 이후달 */
                cal.add(Calendar.MONTH, term); break;
            case 5:				/* minusDay - 이전일 */
                cal.add(Calendar.DATE, -term); break;
            case 6:				/* addDay - 이후일 */
                cal.add(Calendar.DATE, term); break;
            case 7:				/* pickerFirstDay - 날짜의 철쨋날 */
                pattern = "yyyy-MM-dd";
                cal.set(year, month - 1, 1); break;
            case 8:				/* pickerLastDay - 날짜의 마지막날 */
                pattern = "yyyy-MM-dd";
                cal.set(year, month - 1, 1);
                cal.add(Calendar.MONTH, 1);
                cal.add(Calendar.DATE, -1);
                break;
        }

        SimpleDateFormat dateFormatter = new SimpleDateFormat(pattern);
        return dateFormatter.format(cal.getTime());
    }
}
