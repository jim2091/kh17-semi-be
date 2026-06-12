<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.sql.*" %>
<%
    // 메인 홈 화면의 fetch 스크립트에서 보낸 파라미터들을 받습니다.
    String action = request.getParameter("action");
    String empNo = request.getParameter("empNo"); 
    
    // 기본 결과 신호는 실패(fail)로 세팅합니다.
    String resultSignal = "fail";

    // 1. 요청 신호(action)가 'checkIn'이고, 사원 번호(empNo)가 정상적으로 수신되었을 때만 실행
    if (action != null && action.equals("checkIn") && empNo != null && !empNo.trim().isEmpty()) {
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // [중요] 본인의 데이터베이스 환경에 맞게 드라이버, URL, 계정 아이디, 비밀번호를 수정하세요!
            Class.forName("oracle.jdbc.driver.OracleDriver"); 
            String url = "jdbc:oracle:thin:@localhost:1521:xe";
            String user = "your_username";
            String password = "your_password";
            
            conn = DriverManager.getConnection(url, user, password);
            
            // 2. 받은 empNo를 조건으로 당일(오늘) 근태 기록의 상태를 '출근 중'으로, 출근시간을 현재 시스템 시간으로 변경
            String sql = "UPDATE ATTN SET ATTN_STATUS = '출근 중', ATTN_IN_TIME = SYSDATE " +
                         "WHERE EMP_NO = ? AND TRUNC(ATTN_WORK_DATE) = TRUNC(SYSDATE)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, empNo.trim()); // 공백 제거 후 쿼리에 안전하게 매핑
            
            int rows = pstmt.executeUpdate();
            
            // 3. DB에 업데이트된 행이 1개 이상 존재한다면 성공 신호(success)로 변경
            if (rows > 0) {
                resultSignal = "success";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            resultSignal = "error"; // DB 에러 발생 시 신호 변경
        } finally {
            // 자원 반납 (메모리 누수 방지)
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
    
    // HTML 태그나 공백 없이 오직 결과 키워드(success / fail / error) 하나만 메인 화면 스크립트로 리턴합니다.
    out.print(resultSignal);
%>