<%
Response.Write("<h1>MSXML2.ServerXMLHTTP.6.0</h1>")
Set objHttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
objHttp.open "GET", "https://howsmyssl.com/a/check", False
objHttp.Send
Response.Write objHttp.responseText 
Set objHttp = Nothing 

Response.Write("<hr>")

Response.Write("<h1>WinHttp.WinHttpRequest.5.1</h1>")
Set objHttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
objHttp.open "GET", "https://howsmyssl.com/a/check", False
objHttp.Send
Response.Write objHttp.responseText 
Set objHttp = Nothing 
%>