<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.regex.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>

  <head>
    <meta charset="UTF-8">
      <meta content="width=device-width, initial-scale=1, user-scalable=no" name=viewport>
        <link href="css/common.css" rel="stylesheet" type="text/css">
        <% //POSTフォームデータ受信 "bbc"へ代入
        String bbc = null,ip = null;
        request.setCharacterEncoding("UTF-8");
        if(!(request.getParameter("bbcfm") == null)){
          bbc = request.getParameter("bbcfm");
          ip = request.getRemoteAddr();
        }
        if(!(bbc == null)){
          out.println( "<title>TwitterBBC -" + bbc + "-</title>");
        } else {
          out.println( "<title>TwitterBBC</title>");
        }
        //以下DB接続
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/twitterbbc", "twitterbbc", "twitterbbc");
        Statement stmt = conn.createStatement();
        ResultSet rs1, rs2;//DBデータ取得戻り値用変数
        int dbuprs;//DB更新用の戻り値変数
        int num = 1, num2 = 0;//汎用int変数
        rs1 = stmt.executeQuery("select * from bbc;");
        //コマンド設定未完成
        /*String regex="--.*--";
        Pattern  p = Pattern.compile(regex);
        Matcher m = null;
        String helpmsg = null;
        int helpflg = 0;
        if(!(bbc == null)){
        m = p.matcher(bbc);
      }
      */
      //以下投稿内容をデータベースへアップデート
      if(!(bbc==n ull)){//投稿があったなら
        while(rs1.next()){
          //numに最終番号の次の番号を代入
          num=r s1.getInt( "num"); num++;
        }
          //投稿日時を取得
          Calendar cal = Calendar.getInstance();
          int cal_year = cal.get(Calendar.YEAR);
          int cal_month = cal.get(Calendar.MONTH) + 1;
          int cal_day = cal.get(Calendar.DATE);
          int cal_hour = cal.get(Calendar.HOUR_OF_DAY);
          int cal_minute = cal.get(Calendar.MINUTE);
          int cal_second = cal.get(Calendar.SECOND);
          String cal_sql = cal_year + "/" + cal_month + "/" + cal_day + " " + cal_hour + ":" + cal_minute + ":" + cal_second;
          //SQL文を作成
          String upsql = "insert into bbc (num, msg, ip, date) values (" + num + ", '" + bbc + "', '" + ip + "', '" + cal_sql + "');";
          dbuprs = stmt.executeUpdate(upsql);
          rs1 = stmt.executeQuery( "select * from bbc;");
        }/*else if (!(bbc==n ull) && (bbc.equals( "--help--"))){
          helpmsg = "ヘルプを表示します。";
          helpflg=1;
        }*/
        while(rs1.next()){
          num2 = rs1.getInt("num");
        }
        int bbcnum[] = new int[num2];
        String bbcmsg[] = new String[num2];
        String bbcip[] = new String[num2];
        Timestamp bbctime[] = new Timestamp[num2];
        String bbctimestr[] = new String[num2];
        %>
          <script>
            window.onload = function () {
              document.bbc.bbcfm.focus(); //ページロード時にフォームへカーソルをフォーカス
              /*8秒ごとにリロード
              リクエストが多数発生するため手法を要件等
              */
              setTimeout(function () {
                window.location.reload(true);
              }, 10000);
            }
          </script>
        </head>

        <body>
          <div id="wrp">
            <div id="htmlfm">
              <form action="index.jsp" name="bbc">
                <input name="bbcfm" placeholder="今の気持ちは？" type="text">
                  <input formmethod="post" id="fm" type="submit" value="投稿しような"></form>
                </div>
                <article>
                  <% //投稿の有無を確認する
                  rs1=s tmt.executeQuery( "select * from bbc;");
                  boolean isExists=r s1.next();
                  if(!(isExists)){
                    out.println( "<p>まだ投稿はありません。今すぐ投稿を行って初めての投稿者になりましょう！</p>");
                  }
                  //再度データベースをすべて取得しwhile文ですべて出力
                  //要改良→新しいものから上から表示すること。→12/6 実装済
                  if(!(num2==0 )){
                    rs1=s tmt.executeQuery( "select * from bbc;");
                     int cnt=0;
                     while(rs1.next()){
                       bbcnum[cnt] = rs1.getInt("num");
                       bbcmsg[cnt] = rs1.getString("msg");
                       bbcip[cnt] = rs1.getString( "ip");
                       bbctime[cnt] = rs1.getTimestamp("date");
                       bbctimestr[cnt] = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(bbctime[cnt]); cnt++;
                     }
                     for(int y=n um2 - 1; y>= 0; y--){
                       out.println("<div class="bbc"><p>" + bbcnum[y] + " -- " + bbcmsg[y] + "<br>" + bbctimestr[y] + " from " + bbcip[y] + "</p></div>");
                     }
                   }
                   //コネクションをクローズ
                   rs1.close();
                   stmt.close();
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
                   %>
                </article>
                <footer>
                  <p>Copyright&copy;2015 Keita Ikeda All Rights Reserved</p>
                </footer>
              </div>
            </body>

          </html>
