package shopping;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateUtils {
    // 获取当前时间戳（字符串形式）
    public static String getTimestamp() {
        return String.valueOf(System.currentTimeMillis());
    }
    
    // 获取当前日期时间（格式化）
    public static String getCurrentDateTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return LocalDateTime.now().format(formatter);
    }
}