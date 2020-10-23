Class ZSelflearning.Installer
{

XData MyManifest [ XMLNamespace = INSTALLER ]
{
<Manifest>
	<Namespace Name="USER" Create="no">
		<Import File="${SRCDIR}/Start" Flags="ck" Recurse="1" />
		<Invoke Class="Ens.Director" Method="SetAutoStart" CheckStatus="true">
			<Arg Value="Start.Production"/>
		</Invoke>
	</Namespace>
</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
 #; XGL ドキュメントでこのメソッドのコードを生成する.
 Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "MyManifest")
}

/// REST用ベースURL /start の設定（ディスパッチクラス：Start.REST）と
/// SQLゲートウェイの設定 と
/// SSL構成の設定　
ClassMethod RunInstall(dir As %String) As %Status
{
	#dim ex As %Exception.AbstractException
	set status=$$$OK
	try {
		set var("SRCDIR")=dir
		set status=..setup(.var)
		$$$THROWONERROR(ex,status)
		set webName = "/start"
		set webProperties("DispatchClass") = "Start.REST"
		set webProperties("NameSpace") = "USER"
		set webProperties("Enabled") = 1
		set webProperties("AutheEnabled") = 64
		set webProperties("MatchRoles")=":%All"
		set status = ##class(Security.Applications).Create(webName, .webProperties)
		$$$THROWONERROR(ex,status)

        // JDBCを利用するSQLゲートウェイの設定
        set jdbcgw=##class(%Library.SQLConnection).%New()
        set jdbcgw.Name="IRIS1"
        set jdbcgw.URL="jdbc:IRIS://localhost:1972/USER"
        set jdbcgw.Usr="_SYSTEM"
        set jdbcgw.classpath=".:/usr/irissys/dev/java/lib/JDK18/intersystems-jdbc-3.2.0.jar"
        set jdbcgw.driver="com.intersystems.jdbc.IRISDriver"
        set jdbcgw.isJDBC=1
        set jdbcgw.pwd="SYS"
        set status=jdbcgw.%Save()
        $$$THROWONERROR(ex,status)
		// SSL構成の追加
		set status=##class(Security.SSLConfigs).Create("openweather")
        $$$THROWONERROR(ex,status)
	}
	catch ex {
		set status=ex.AsStatus()
	}
	quit status
}

}
