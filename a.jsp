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
    ResultSet rs;
    int x;
    x = stmt.executeUpdate("insert into bbc (num, msg) values (4, 'テスト4');");
    rs = stmt.executeQuery("select * from bbc;");
    String msg = null, msgre = null;
    request.setCharacterEncoding("UTF-8");
    msg = request.getParameter("a");
    msgre = request.getParameter("re");
    %>
      <style>
        #fm {
          font-size: 20px;
          width: 200px;
          height: 200px;
        }

        #re {
          display: none;
        }

      </style>
    </head>

    <body>
      <form action="a.jsp">
        <input name="a" type="text">
          <input id="re" name="re" type="text" value="<%=msg %>">
            <input formmethod="post" id="fm" type="submit" value="送ろうな"></form>
            <h1>
              <% if(!(msg == null)) {
                    out.println(msg + "<br>" + msgre);
                  }
                %>
            </h1>
            <br>
              <%
                while(rs.next()){
                  int num = rs.getInt("num");
                  String msgd = rs.getString("msg");
                  out.println("<p>" + num + "は" + msgd + "</p>");
                }
                rs.close();
                stmt.close();
                %>
            </body>

          </html>
