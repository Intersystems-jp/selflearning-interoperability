Class Start.FileBS Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

/// ファイルインバウンドアダプタの例<br> 
/// 入力ファイルには、1行1リクエストで　購入商品名,天気を調査する都市名　を記入する<br> 
///  例）<br> 
///  雪見だいふく,札幌市　<br>
///  ちくわ,豊橋市 <br>
/// 　野沢菜,長野市 <br>
/// 
Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
	set st=$$$OK
	#dim ex As %Exception.AbstractException
	try {
		// AtEndプロパティがに1が設定されない限りループしながら1行ずつ実行する
		while '(pInput.AtEnd) {
			set record=pInput.ReadLine()
			set request=##class(Start.Request).%New()
			set request.Product=$piece(record,",",1)
			set request.Area=$piece(record,",",2)		
			set st=..SendRequestAsync("Start.WeatherCheckProcess",request)
			$$$THROWONERROR(ex,st)
		}
	}
	catch ex {
		set st=ex.AsStatus()
	}
	Quit st
}

}
