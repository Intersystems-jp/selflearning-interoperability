/// Start.WS.WebServiceBS
Class Start.WS.WebServiceBS Extends EnsLib.SOAP.Service
{

/// ウェブサービスの名前.
Parameter SERVICENAME = "WebServiceBS";

/// TODO: これを実際のSOAPネームスペースに変更します。
/// ウェブサービス用のSOAPネームスペース
Parameter NAMESPACE = "http://tempuri.org";

/// 参照されているクラスのネームスペースは WSDL に使用されます。
Parameter USECLASSNAMESPACES = 1;

/// TODO: 引数および実装を追加します。
/// CallEnsemble
/// 　第1引数：購入商品名／第2引数：エリアコード（デフォルトで長野県長野市のエリアコードを指定してます）
Method CallEnsemble(product As %String, AreCode As %Numeric = 200010) As %Status [ WebMethod ]
{
	#dim ex As %Exception.AbstractException
	set st=$$$OK
	try {
		set request=##class(Start.Request).%New()
		set request.Area=AreCode
		set request.Product=product
		set st=..SendRequestAsync("Start.WeatherCheckProcess",request)
		$$$THROWONERROR(ex,st)
	}
	catch ex {
		set st=ex.AsStatus()
		do ..ReturnMethodStatusFault(st)
	}
	Quit st
}

}
