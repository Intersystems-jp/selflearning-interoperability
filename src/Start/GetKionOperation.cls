Class Start.GetKionOperation Extends EnsLib.REST.Operation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// APIキーを指定します
Property appid As %String;

Parameter SETTINGS = "appid:OpenWeatherMap";

/// お天気APIを利用
/// 例）https://api.openweathermap.org/data/2.5/weather?appid=ここに正しいappidを指定&units=metric&q=長野市&lang=ja
/// https://openweathermap.org/current
/// クエリパラメータの units（units=metic は摂氏で返送）と lang（lang=ja）はコードで設定
/// クエリパラメータの q は調べる天気の地名やコード
/// 	Osakaまたは大阪市、Tokyoまたは東京都、Shinjukuまたは新宿区など
/// 	国コードでも指定可　https://ja.wikipedia.org/wiki/ISO_3166-1
/// apiidは事前に取得する必要有
/// HTTP応答の　dt には Unix UTCの時間
Method GetKion(pRequest As Start.Request, Output pResponse As Start.Response) As %Status
{
	#dim ex As %Exception.AbstractException
	#dim tHttpResponse As %Net.HttpResponse
	set st=$$$OK
	try {
		set queryparameter="?units=metric&lang=ja&q="_pRequest.Area_"&appid="_..appid
		//set queryparameter="?units=metric&lang=ja&q="_pRequest.Area_"&appid=c2d335870321c22878a9317fdb2cce5a"
		set URL=..Adapter.URL_queryparameter
		$$$TRACE(URL)
		set st=..Adapter.GetURL(URL,.tHttpResponse)

		// アダプタからエラーが返り、%Net.HttpResponseのオブジェクトが存在し
		// %Net.HttpResponseのDataプロパティがオブジェクトの場合はStreamであり、その場合にSizeが0でないときに
		// 全エラーメッセージを文字列に変換し、ステータスエラーを作成する。
		If $$$ISERR(st)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size {
			Set st=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(st)_":"_tHttpResponse.Data.Read())
		}
		$$$THROWONERROR(ex,st)
		If $IsObject(tHttpResponse) {
			set pResponse=##class(Start.Response).%New()
			//JSONオブジェクトに変換（tHttpResponse.Dataにはストリームが格納されています）
			set weatherinfo={}.%FromJSON(tHttpResponse.Data)
			set pResponse.AreaDescription=weatherinfo.weather.%Get(0).description
			set pResponse.KionMax=weatherinfo.main."temp_max"
			set pResponse.KionMin=weatherinfo.main."temp_min"
			set pResponse.Area=weatherinfo.name
			//UTC時間なので日本時間にするために9時間（9*60*60）足す
			set unixEpochFormat=weatherinfo.dt+32400
			set dt=$system.SQL.Functions.DATEADD("s",unixEpochFormat,"1970-01-01 00:00:00")
			set pResponse.AreaPublicTime=dt
		}
	}
	catch ex {
		set st=ex.AsStatus()
	}

	Quit st
}

/// UNIXエポックタイム→内部日付への変換
ClassMethod fromUnixToHorolog(unixEpochFormat) As %String
{
	// UTC時間なので日本時間に変更のため9時間足す
	/*set unixEpochFormat=unixEpochFormat+(9*60*60)
	set unixEpochInDays = unixEpochFormat\86400
	set remainderSeconds = unixEpochFormat#86400
	set epochStartDayHorolog = $zdh("01/01/1970")
	set daysSinceHorologStart = epochStartDayHorolog + unixEpochInDays
	return daysSinceHorologStart_","_remainderSeconds
	*/
	//UTC時間なので日本時間にするために9時間（9*60*60）タス
	set unixEpochFormat=unixEpochFormat+32400
	return $system.SQL.Functions.DATEADD("s",unixEpochFormat,"1970-01-01 00:00:00")
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Start.Request">
		<Method>GetKion</Method>
	</MapItem>
</MapItems>
}

}
