<cfmail from="swimmeetmaster@yahoo.com" to="dsbrady_98@yahoo.com" subject="Testing" server="mail.swimmeetmaster.com" failto="scott@spidermonkeytech.com" username="swimmeetmaster@swimmeetmaster.com" password="t3@m3xtr3m3">
Test again
</cfmail>
done 2
<!---

<cfdirectory action="list" directory="C:\cfusionmx7\mail\undelivr" name="qDir">
<cfquery name="qDir2" dbtype="query">
SELECT * from qDir
order by datelastmodified desc
</cfquery>
<cffile action="read" file="c:\cfusionmx7\logs\mail.log" variable="logFile">
<cfdump var="#logfile#">
 --->
