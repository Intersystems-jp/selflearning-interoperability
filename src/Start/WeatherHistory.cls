Class Start.WeatherHistory Extends %Persistent
{

Property KionMin As %Numeric;

Property KionMax As %Numeric;

Property Area As %String;

Property AreaDescription As %String(MAXLEN = 1000);

Property AreaPublicTime As %String;

Property Product As %String;

Property CreateTimeStamp As %TimeStamp [ SqlComputeCode = { set {*}=$ZDATETIME($system.Util.UTCtoLocalWithZTIMEZONE($ZTIMESTAMP),3)
}, SqlComputed, SqlComputeOnChange = %%INSERT ];

Storage Default
{
<Data name="WeatherHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KionMin</Value>
</Value>
<Value name="3">
<Value>KionMax</Value>
</Value>
<Value name="4">
<Value>Area</Value>
</Value>
<Value name="5">
<Value>AreaDescription</Value>
</Value>
<Value name="6">
<Value>AreaPublicTime</Value>
</Value>
<Value name="7">
<Value>Product</Value>
</Value>
<Value name="8">
<Value>CreateTimeStamp</Value>
</Value>
</Data>
<DataLocation>^Start.WeatherHistoryD</DataLocation>
<DefaultData>WeatherHistoryDefaultData</DefaultData>
<IdLocation>^Start.WeatherHistoryD</IdLocation>
<IndexLocation>^Start.WeatherHistoryI</IndexLocation>
<StreamLocation>^Start.WeatherHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
