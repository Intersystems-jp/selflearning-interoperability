Class Start.NonAdapterBS Extends Ens.BusinessService
{

Method OnProcessInput(request As Start.Request, Output pOutput As %RegisteredObject) As %Status
{
	set st=$$$OK
	#dim ex As %Exception.AbstractException
	try {
		set st=..SendRequestAsync("Start.WeatherCheckProcess",request)
		$$$THROWONERROR(ex,st)
	}
	catch ex {
		set st=ex.AsStatus()
	}
	Quit st
}

}
