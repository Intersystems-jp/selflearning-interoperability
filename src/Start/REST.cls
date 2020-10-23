/// RESTを使ってビジネスサービスを呼び出す例
Class Start.REST Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/weather/:product/:arecode" Method="GET" Call="WeatherCheck"/>

</Routes>
}

ClassMethod WeatherCheck(product As %String, areacode As %String) As %Status
{
	#dim ex As %Exception.AbstractException
	#dim %response As %CSP.Response
	set st=$$$OK
	try {
		set %response.ContentType="application/json"
		set %response.CharSet="utf-8"

		// ビジネスサービスのオブジェクト生成 ：第1引数はビジネスサービスのプロダクション登録名
		set st=##class(Ens.Director).CreateBusinessService("Start.NonAdapterBS",.BS)
		// 戻り値がエラーの場合はcatchへ移動
		$$$THROWONERROR(ex,st)

		set request=##class(Start.Request).%New()
		set request.Product=product
		set request.Area=areacode

		// ビジネスサービスに情報配信
		set st=BS.ProcessInput(request)
		// 戻り値がエラーの場合はcatchへ移動
		$$$THROWONERROR(ex,st)

		// 以下クライアントへ戻す情報
		set json={}
		set json.Message="天気情報確認：依頼しました"
		set json.Status=1
		write json.%ToJSON()
	}
	catch ex {
		set st=ex.AsStatus()
	}
	quit $$$OK
}

}
