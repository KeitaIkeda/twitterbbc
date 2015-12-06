<!DOCTYPE html>
<%@page contentType="text/html; charset=UTF-8" %>
    <html>

    <head>
        <meta charset="UTF-8">
        <% String msg = request.getParameter("a"); %>
    </head>

    <body>
        <h1><%= msg %></h1>
    </body>

    </html>