Class Start.Response Extends Ens.Response
{

Property KionMax As %Numeric;

Property KionMin As %Numeric;

Property Area As %String;

Property AreaDescription As %String(MAXLEN = 1000);

Property AreaPublicTime As %String;

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>KionMax</Value>
</Value>
<Value name="2">
<Value>KionMin</Value>
</Value>
<Value name="3">
<Value>Area</Value>
</Value>
<Value name="4">
<Value>AreaDescription</Value>
</Value>
<Value name="5">
<Value>AreaPublicTime</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
