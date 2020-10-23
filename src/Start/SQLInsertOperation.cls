Class Start.SQLInsertOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method Insert(pRequest As Start.InsertRequest, Output pResponse As Ens.Response) As %Status
{
	set st=$$$OK
	#dim ex As %Exception.AbstractException
	try {
		set sql="insert into Start.WeatherHistory (Area,AreaDescription,AreaPublicTime,KionMin,KionMax,Product) values(?,?,?,?,?,?)"
		set st=..Adapter.ExecuteUpdate(.rows,sql,pRequest.WeatherInfo.Area,pRequest.WeatherInfo.AreaDescription,pRequest.WeatherInfo.AreaPublicTime,
												pRequest.WeatherInfo.KionMin,pRequest.WeatherInfo.KionMax,pRequest.Product)
		$$$THROWONERROR(ex,st)
	}
	catch ex {
		set st=ex.AsStatus()
	}
	quit st
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Start.InsertRequest"> 
		<Method>Insert</Method>
	</MapItem>
</MapItems>
}

}
