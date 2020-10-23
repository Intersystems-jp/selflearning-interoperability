Class Start.Request Extends Ens.Request
{

Property Product As %String;

Property Area As %String;

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Product</Value>
</Value>
<Value name="2">
<Value>Area</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
