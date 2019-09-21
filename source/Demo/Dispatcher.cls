Class Demo.Dispatcher Extends %CSP.REST
{
Parameter USESESSIONS = 1;
XData UrlMap
{
<Routes>
  <Route Url="/message" Method="POST" Call="CreateMessage" />
  <Route Url="/messages/:n" Method="GET" Call="GetMessages" />
  <Route Url="/messages/:user/:n" Method="GET" Call="GetMessagesByUser" />
  <Route Url="/user" Method="GET" Call="Userinfo" />
 </Routes>
 }
 
 ClassMethod Userinfo() As %Status
 {
  set response = {"response":($username)}
  
  do response.%ToJSON()
  quit $$$OK
 }
 
 ClassMethod CreateMessage() As %Status
 {
  try {
  	set msg = ##class(Demo.Message).%New()
	set sc = msg.%JSONImport(%request.Content)
	if $$$ISERR(sc) throw sc 
	  
	set msg.Name = $username
	set msg.TimePosted = $zdt($zts,3)
	set sc = msg.%Save()
	if $$$ISERR(sc) throw sc
	
	set response = {"response":"OK"}
  } catch e {
  	set response = {"response":(e.DisplayString())}
  }
  
  do response.%ToJSON()
  quit $$$OK
 }
 
 ClassMethod GetMessages(n As %String) As %Status
 {
  if '(+n=n) {
  	set response = {"response":"n must be a number"}
  } else {
  	set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT TOP (?) Name,Text,TimePosted FROM Demo.Message ORDER BY TimePosted DESC",n)
  	
  	if rs.%SQLCODE {
  		set response = {"response":(rs.%SQLCODE_" "_rs.%Message)}
  	} else {
  		set response = []
  		while rs.%Next() {
  			do response.%Push({"name":(rs.Name), "time":(rs.TimePosted), "text":(rs.Text)})
  		}
  	}
  	
  	do response.%ToJSON()
  	quit $$$OK
  	
  }
 }
 
ClassMethod GetMessagesByUser(user As %String, n As %String) As %Status
 {
  if '(+n=n) {
  	set response = {"response":"n must be a number"}
  } else {
  	set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT TOP (?) Name,Text,TimePosted FROM Demo.Message where Name = ? ORDER BY TimePosted DESC",n,user)
  	
  	if rs.%SQLCODE {
  		set response = {"response":(rs.%SQLCODE_" "_rs.%Message)}
  	} else {
  		set response = []
  		while rs.%Next() {
  			do response.%Push({"name":(rs.Name), "time":(rs.TimePosted), "text":(rs.Text)})
  		}
  	}
  	
  	do response.%ToJSON()
  	quit $$$OK
  	
  }
 }
}
 