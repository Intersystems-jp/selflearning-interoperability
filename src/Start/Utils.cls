Class Start.Utils
{

/// ストアドプロシージャ／クラスメソッドからアダプタ無しのBSを呼ぶ例
ClassMethod CallProduction(product As %String, areacode As %String) As %Status [ SqlProc ]
{
	#dim %sqlcontext As %Library.ProcedureContext
	#dim ex As %Exception.AbstractException
	set st=$$$OK
	try {
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
	}
	catch ex {
		// ストアドプロシージャ呼び出し元へ返す情報の設定
		set %sqlcontext.%SQLCODE=ex.AsSQLCODE()
		set %sqlcontext.%Message=ex.AsSQLMessage()
		set st=ex.AsStatus()
	}
	quit st
}

}
