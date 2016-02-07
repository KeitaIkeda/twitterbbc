<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.*,java.util.regex.*,java.util.*,java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
      <meta content="width=device-width, initial-scale=1, user-scalable=no" name=viewport>
        <link href="css/common.css" rel="stylesheet" type="text/css">
          <title>TwitterBBC</title>
        <%

        //POSTフォームデータ受信 "bbc"へ代入
        String bbc = null,ip = null;
        request.setCharacterEncoding("UTF-8");
        if(!(request.getParameter("bbcfm") == null) && !(request.getParameter("bbcfm") == "")){
          bbc = request.getParameter("bbcfm");
          bbc = bbc.trim();
          bbc = bbc.replaceAll("^　*", "").replaceAll("　*$", "");
          ip = request.getRemoteAddr();
        }

        //以下DB接続
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/twitterbbc", "twitterbbc", "twitterbbc");
        Statement stmt = conn.createStatement();
        ResultSet rs1, ct1;//DBデータ取得戻り値用変数
        int dbuprs;//DB更新用の戻り値変数
        int num = 100, num2 = 0;//汎用int変数
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
      ct1 = stmt.executeQuery("select count(*) as cnt from bbc;");
      ct1.next();
      num = ct1.getInt("cnt");

      //以下投稿内容をデータベースへアップデート
      if(!(bbc == null)){//投稿があったなら
        /*現在の行数より1つ多い数字をnumカラムへ代入する役目と
        63行目からの配列宣言で投稿がないなら現在のままの行数、投稿があればDB更新後の行数となるようにしている
        */
        num = num + 1;
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
          rs1 = stmt.executeQuery("select * from bbc;");
        }/*else if (!(bbc==n ull) && (bbc.equals( "--help--"))){
          helpmsg = "ヘルプを表示します。";
          helpflg=1;
        }*/
        //内容表示用の配列を宣言。要素数は投稿の有無により変化
        int bbcnum[] = new int[num];
        String bbcmsg[] = new String[num];
        String bbcip[] = new String[num];
        Timestamp bbctime[] = new Timestamp[num];
        String bbctimestr[] = new String[num];
        String bbc_url[] = new String[num];
        %>
          <script>
            window.onload = function () {
              document.bbc.bbcfm.focus(); //ページロード時にフォームへカーソルをフォーカス
              /*8秒ごとにリロード
              リクエストが多数発生するため手法を要検討
              */
              /*setTimeout(function () {
                window.location.reload(true);
              }, 10000);*/
            }
            var fmchk = function () {
              if (document.getElementsByTagName("input")[0].value == "") {
                document.getElementsByTagName("output")[0].innerHTML = "投稿が未入力です。<br>投稿できません。";
                return false;
              } else {
                var str = document.getElementsByTagName("input")[0].value;
                str = str.replace(/&/g, '&amp;');
                str = str.replace(/</g, '&lt;');
                str = str.replace(/>/g, '&gt;');
                str = str.replace(/"/g, '&quot;');
                str = str.replace(/'/g, '&#39;');
                document.getElementsByTagName("input")[0].value = str;
              }
            }
          </script>
        </head>

        <body>
          <div id="wrp">
            <div id="htmlfm">
              <form action="index.jsp" name="bbc" onsubmit="return fmchk();">
                <input name="bbcfm" placeholder="今の気持ちは？" type="text">
                  <input formmethod="post" id="fm" type="submit" value="投稿しような"></form>
                  <div id="out">
                    <output></output>
                  </div>
                </div>
                <article>
                <%
                  //投稿の有無を確認する
                  rs1 = stmt.executeQuery("select * from bbc;");
                  boolean isExists = rs1.next();
                  if(!(isExists)){
                    out.println( "<p>まだ投稿はありません。今すぐ投稿を行って初めての投稿者になりましょう！</p>");
                  }
                  //再度データベースをすべて取得しwhile文ですべて出力
                  //要改良→新しいものから上から表示すること。→12/6 実装済
                  if(!(num==0)){
                    rs1 = stmt.executeQuery("select * from bbc;");
                     int cnt = 0;
                     while(rs1.next()){
                       bbcnum[cnt] = rs1.getInt("num");
                       bbcmsg[cnt] = rs1.getString("msg");
                       bbcip[cnt] = rs1.getString("ip");
                       bbctime[cnt] = rs1.getTimestamp("date");
                       bbctimestr[cnt] = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(bbctime[cnt]);

                       //URL抽出パターンマッチ
                       String regex = "(http://|https://){1}[\\w\\.\\-/:\\#\\?\\=\\&\\;\\%\\~\\+]+";
                       Pattern p = Pattern.compile(regex);
                       Matcher m = p.matcher(bbcmsg[cnt]);
                       for(int i = 1;m.find();i++){
                         if(i == 1){
                           bbc_url[cnt] = "<a href='" + m.group() + "' target = '_blank'>URL:" + i + "番目</a><br>";
                         } else {
                           bbc_url[cnt] += "<a href='" + m.group() + "' target = '_blank'>URL:" + i + "番目</a><br>";
                         }
                       }
                       //bbc = bbc.replaceAll("(http://|https://){1}[\\w\\.\\-/:\\#\\?\\=\\&\\;\\%\\~\\+]+", "");
                       cnt++;
                     }
                     for(int y = num - 1; y >= 0; y--){
                       if(bbc_url[y] == null){
                         out.println("<div class='bbc'><p>" + bbcnum[y] + " -- " + bbcmsg[y] + "<br>" + bbctimestr[y] + " from " + bbcip[y] + "</p></div>");
                       }else{
                         out.println("<div class='bbc'><p>" + bbcnum[y] + " -- " + bbcmsg[y] + "<br>" + bbctimestr[y] + " from " + bbcip[y] + "</p>" + bbc_url[y] + "</div>");
                       }
                     }
                   }
                   //コネクションをクローズ
                   ct1.close();
                   rs1.close();
                   stmt.close();
                   conn.close();
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
