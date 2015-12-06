<!DOCTYPE html>
<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.*" %>
<html>

  <head>
    <meta charset="UTF-8">
      <%
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/twitterbbc","twitterbbc","twitterbbc");
    Statement stmt = conn.createStatement();
    ResultSet rs;//DBデータ取得戻り値用変数
    int dbuprs;//DB更新用の戻り値変数
    rs = stmt.executeQuery("select * from bbc;");
    String x[] = new String[100];
    int cnt = 0;
    while(rs.next()){
      x[cnt] = rs.getString("msg");
      cnt++;
    }
    %>
    </head>

    <body>
      <p>
        <%
        for(int y = 99;y >= 0;y--){
          if(!(x[y] == null)){
            out.println(x[y] + "<br>");
          }
        }
        String f = "'あほ'";
        out.println(f);
      %>
      </p>
    </body>

  </html>
