Class Demo.Setup
{	
	XData Installer [XMLNamespace = INSTALLER]
	{
	<Manifest>
		<Var Name="pwd" Value="secure123"/>
		<Var Name="Namespace" Value="DEMO"/>
		<Var Name="BuildDir" Value="/tmp/build"/>
		<User Username="Sean" Enabled="1" PasswordVar="pwd"/>
		<User Username="Joe" Enabled="1" PasswordVar="pwd"/>
		<User Username="Sarah" Enabled="1" PasswordVar="pwd"/>
		<User Username="Alex" Enabled="1" PasswordVar="pwd"/>
		<Role Name="DemoApp" Resources="%DB_USER:RWU" />
		<Namespace Name="${Namespace}" Create="yes" Code="USER" Data="USER">
			<Configuration></Configuration>
			<CSPApplication Url="/demo" UseSessionCookie="1" Grant="DemoApp" Directory="/source/web/"/>
			<CSPApplication Url="/demo/api" CookiePath="/demo" UseSessionCookie="1" Grant="DemoApp" Directory="${INSTALLDIR}csp/demo/api" DispatchClass="Demo.Dispatcher" Recurse="1"/>
			<Import File="${BuildDir}/Demo" Recurse="1" Flags="cuk" />
			<Invoke Class="Demo.Setup" Method="GenerateData"/>
			<Invoke Class="Demo.Setup" Method="FinishSetup"/>
		</Namespace>
	</Manifest>
	}
	
	ClassMethod Setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
	{
		#; Let XGL document generate code for this method. 
		Quit ##class(%Installer.Manifest).%Generate(%compiledclass,%code, "Installer")
	}
	
	ClassMethod FinishSetup()
	{
		//grant SQL privileges to the DemoApp Role:
		do $System.SQL.GrantObjPriv("Select,Update","Demo.Message","Table","DemoApp")
		
		//%Installer won't set Dispatch Class
		new $namespace
		set $namespace="%SYS"
		set p("DispatchClass")="Demo.Dispatcher"
		do ##class(Security.Applications).Modify("/demo/api",.p)
	}
	ClassMethod GenerateData() 
	{
		do ##class(Demo.Message).%KillExtent()
		
		for user = "Sean","Joe","Sarah","Alex" {
			set n = 5+$r(10)
			for i=1:1:n {
				set msg = ##class(Demo.Message).%New()
				set msg.Name = user
				set msg.Text = "I sent a random message!"
				set time = +$h-1-$r(10)_","_$r(24*60*60-1)
				set msg.TimePosted = $zdt(time,3)
				set sc = msg.%Save()
				
				if $$$ISERR(sc) {
					do $system.OBJ.DisplayError(sc)
				}
			}
		}
	}

}