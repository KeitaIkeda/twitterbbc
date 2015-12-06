<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.regex.*" %><!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
      <meta content="width=device-width, initial-scale=1, user-scalable=no" name=viewport>
        <%
      //POSTフォームデータ受信"bbc"へ代入
      String bbc = null,ip = null,dbgbbc = null;;
      request.setCharacterEncoding("UTF-8");
      if(!(request.getParameter("bbcfm") == null)){
        bbc = request.getParameter("bbcfm");
        ip = request.getRemoteAddr();
        dbgbbc = bbc;
      }
      if(!(bbc == null)){
        out.println("<title>TwitterBBC -" + bbc + "-</title>");
      }else{
        out.println("<title>TwitterBBC</title>");
      }
      //以下DB接続
      Class.forName("com.mysql.jdbc.Driver");
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/twitterbbc","twitterbbc","twitterbbc");
      Statement stmt = conn.createStatement();
      ResultSet rs1, rs2;//DBデータ取得戻り値用変数
      int dbuprs;//DB更新用の戻り値変数
      int num = 1, num2 = 0;//汎用int変数
      rs1 = stmt.executeQuery("select * from bbc;");
      /*String regex = "--.*--";
      Pattern p = Pattern.compile(regex);
      Matcher m = null;
      String helpmsg = null;
      int helpflg = 0;
      if(!(bbc == null)){
        m = p.matcher(bbc);
      }*/
      if(!(bbc == null)){//投稿があったなら
        while(rs1.next()){//numに最終番号の次の番号を代入
          num = rs1.getInt("num");
          num++;
        }
        String upsql = "insert into bbc (num, msg, ip) values (" + num + ", '" + bbc + "', '" + ip + "');";
        dbuprs = stmt.executeUpdate(upsql);
        rs1 = stmt.executeQuery("select * from bbc;");
      }/* else if (!(bbc == null) && (bbc.equals("--help--"))){
        helpmsg = "ヘルプを表示します。";
        helpflg = 1;
      }*/
      while(rs1.next()){
        num2 = rs1.getInt("num");
      }
      int bbcnum[] = new int[num2];
      String bbcmsg[] = new String[num2];
      String bbcip[] = new String[num2];
      %>
      <script>
      window.onload = function(){
        document.bbc.bbcfm.focus();
      }
      </script>
      </head>

      <body>
        <form action="index.jsp" name="bbc">
          <input name="bbcfm" type="text">
            <input formmethod="post" id="fm" type="submit" value="投稿しような"></form>
            <br>
              <%
            //投稿の有無を確認する
            rs1 = stmt.executeQuery("select * from bbc;");
            boolean isExists = rs1.next();
            if(!(isExists)){
              out.println("<p>まだ投稿はありません。今すぐ投稿を行って初めての投稿者になりましょう！</p>");
            }

            /*if(helpflg == 1){
              out.println("<p>" + helpmsg + "</p>");
            }*/

            //再度データベースをすべて取得しwhile文ですべて出力
            //要改良→新しいものから上から表示すること。
            if(!(num2 == 0)){
              rs1 = stmt.executeQuery("select * from bbc;");
              int cnt = 0;
                while(rs1.next()){
                  bbcnum[cnt] = rs1.getInt("num");
                  bbcmsg[cnt] = rs1.getString("msg");
                  bbcip[cnt] = rs1.getString("ip");
                  cnt++;
                }
                for(int y = num2 - 1; y >= 0; y--){
                    out.println("<p>" + bbcnum[y] + " -- " + bbcmsg[y] + " from " + bbcip[y] + "</p>");
                    //out.println("yは" + y + "です<br>");
                }
            }

              //ページ更新対策
              String rd;
              rd = request.getParameter("rd");
              if(rd == null){
                rd = "d";
              }
              if(!(rd.equals("t"))){
                String url = "index.jsp?rd=t";
                response.sendRedirect(url);
              }
              out.println(dbgbbc);
              rs1.close();
              stmt.close();
              %>
            </body>

          </html>
