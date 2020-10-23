Class Start.InsertOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method Insert(pRequest As Start.InsertRequest, Output pResponse As Ens.Response) As %Status
{
	set st=$$$OK
	#dim ex As %Exception.AbstractException
	try {
		// /* objectで更新する場合 */
		/*
		set obj=##class(Start.WeatherHistory).%New()
		set obj.Product=pRequest.Product
		set obj.Area=pRequest.WeatherInfo.Area
		set obj.AreaDescription=pRequest.WeatherInfo.AreaDescription
		set obj.AreaPuclicTime=pRequest.WeatherInfo.AreaPublicTime
		set obj.KionMin=pRequest.WeatherInfo.KionMin
		set obj.KionMax=pRequest.WeatherInfo.KionMax
		
		$$$THROWONERROR(ex,obj.%Save())
		*/
		// /* SQLで更新する場合*/
		set cols(2)=pRequest.WeatherInfo.Area
		set cols(3)=pRequest.WeatherInfo.AreaDescription
		set cols(4)=pRequest.WeatherInfo.AreaPublicTime
		set cols(6)=pRequest.WeatherInfo.KionMax
		set cols(7)=pRequest.WeatherInfo.KionMin
		set cols(8)=pRequest.Product
		&sql(insert into Start.WeatherHistory values :cols())
		if SQLCODE<0 {
			throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
		}
	}
	catch ex {
		set st=ex.AsStatus()
	}
	Quit st
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
