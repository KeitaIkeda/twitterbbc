import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;


public class api extends HttpServlet {
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
    response.setContentType("application/json;charset=UTF-8");
    PrintWriter out = response.getWriter();
    request.setCharacterEncoding("UTF-8");
    out.println("[");
    try {
      Class.forName("com.mysql.jdbc.Driver");
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/twitterbbc", "twitterbbc", "twitterbbc");
      Statement stmt = conn.createStatement();
      String sql = "select count(*) as cnt from bbc;";
      ResultSet rs = stmt.executeQuery(sql);
      rs.next();
      int cnt = rs.getInt("cnt");
      rs.close();
      if(cnt >= 30){
        sql = "select * from bbc limit 30;";
        rs = stmt.executeQuery(sql);
        int num = 0,i = 0;
        String msg = "", ip = "";
        while(rs.next()){
          num = rs.getInt("num");
          msg = rs.getString("msg");
          ip = rs.getString("ip");

          out.println("  {");
          out.println("    \"num\": \"" + num + "\",");
          out.println("    \"msg\": \"" + msg + "\",");
          out.println("    \"ip\": \"" + ip + "\"");
          i++;
          if(i == 30){
            out.println("  }");
          } else {
            out.println("  },");
          }
        }
        } else {
          sql = "select * from bbc;";
          rs = stmt.executeQuery(sql);
          int num = 0,i = 0;
          String msg = "", ip = "";
          while(rs.next()){
            num = rs.getInt("num");
            msg = rs.getString("msg");
            ip = rs.getString("ip");

            out.println("  {");
            out.println("    \"num\": \"" + num + "\",");
            out.println("    \"msg\": \"" + msg + "\",");
            out.println("    \"ip\": \"" + ip + "\"");
            i++;
            if(i == cnt){
              out.println("  }");
            } else {
              out.println("  },");
            }
          }
      }
      out.println("]");
      out.close();
      stmt.close();
      conn.close();
    } catch(ClassNotFoundException e) {
    } catch(SQLException e) {
    }
  }
}
