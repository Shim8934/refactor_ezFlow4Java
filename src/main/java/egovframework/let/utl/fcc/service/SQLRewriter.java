package egovframework.let.utl.fcc.service;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.core.Core;
import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.core.appender.rewrite.RewritePolicy;
import org.apache.logging.log4j.core.config.plugins.Plugin;
import org.apache.logging.log4j.core.config.plugins.PluginFactory;
import org.apache.logging.log4j.core.impl.Log4jLogEvent;
import org.apache.logging.log4j.message.SimpleMessage;

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Stream;

@Plugin(name = "SQLRewriter", category = Core.CATEGORY_NAME, elementType = "rewritePolicy", printObject = true)
public class SQLRewriter implements RewritePolicy{
    private final static ConcurrentHashMap<String, String> pstmMap = new ConcurrentHashMap<>();
    private final static ConcurrentHashMap<String, String> paramMap = new ConcurrentHashMap<>();

    @Override
    public LogEvent rewrite(LogEvent event) {
        String message = event.getMessage().getFormattedMessage();

        String pstm = StringUtils.substringBefore(message, "}").trim().replace("{pstm-", "");
        message = StringUtils.substringAfter(message, "}").trim();

        if (message.startsWith("Executing Statement: ")) {
            pstmMap.put(pstm, message.replace("Executing Statement: ", "").trim());
            return null; // 이 로그 이벤트를 기록하지 않음
        } else if (message.startsWith("Parameters: ")) {
            paramMap.put(pstm, message.replace("Parameters: ", "").trim());
            return null;
        } else if (message.startsWith("Types: ")) {
            String sql = pstmMap.remove(pstm);
            String para = paramMap.remove(pstm);
            if (sql != null && para != null) {
                String query = "{pstm-" + pstm + "} Query: " + createQuery(sql, para, message.replace("Types: ", "").trim());
                return new Log4jLogEvent.Builder(event).setMessage(new SimpleMessage(query)).build();
            }
        }

        return event;
    }

    private String createQuery(String sql, String para, String types) {
        para = para.substring(0, para.length() - 1).substring(1);
        types = types.substring(0, types.length() - 1).substring(1);

        Queue<String> qQuery = Stream.of(sql.split("\\?", -1))
                .collect(LinkedList::new, LinkedList::add, LinkedList::addAll);

        Queue<String> qPara = Stream.of(para.split(",", -1))
                .map(str -> str.startsWith(" ") ? str.substring(1) : str)
                .collect(LinkedList::new, LinkedList::add, LinkedList::addAll);

        Queue<String> qTypes = Stream.of(types.split(",", -1))
                .collect(LinkedList::new, LinkedList::add, LinkedList::addAll);

        StringBuilder result = new StringBuilder();

        while(!qPara.isEmpty()) {
            String param = qPara.poll();
            boolean isNum = qTypes.poll().trim().equals("java.lang.Integer");
            result.append(qQuery.poll());
            if (isNum) {
                result.append(param);
            } else {
                result.append("'").append(param).append("'");
            }

            result.append(" /**P*/");
        }

        result.append(qQuery.poll());
        return result.toString();
    }

    @PluginFactory
    public static SQLRewriter createPolicy() {
        return new SQLRewriter();
    }
}
