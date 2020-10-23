Class Start.InsertRequest Extends Ens.Request
{

Property Product As %String;

Property WeatherInfo As Start.Response;

Storage Default
{
<Data name="InsertRequestDefaultData">
<Subscript>"InsertRequest"</Subscript>
<Value name="1">
<Value>Product</Value>
</Value>
<Value name="2">
<Value>WeatherInfo</Value>
</Value>
</Data>
<DefaultData>InsertRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
