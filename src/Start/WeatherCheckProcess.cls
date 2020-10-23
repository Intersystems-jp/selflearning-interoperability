/// 
Class Start.WeatherCheckProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Start.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='WeatherInfo' type='Start.Response' instantiate='0' >
</property>
</context>
<sequence xend='200' yend='450' >
<call name='気象情報取得' target='Start.GetKionOperation' async='0' xpos='200' ypos='250' >
<request type='Start.Request' >
<assign property="callrequest.Area" value="request.Area" action="set" />
</request>
<response type='Start.Response' >
<assign property="context.WeatherInfo" value="callresponse" action="set" />
</response>
</call>
<call name='気象情報DB登録' target='Start.InsertOperation' async='0' xpos='200' ypos='350' >
<request type='Start.InsertRequest' >
<assign property="callrequest.WeatherInfo" value="context.WeatherInfo" action="set" />
<assign property="callrequest.Product" value="request.Product" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
