Class Start.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Start.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Start.GetKionOperation" Category="" ClassName="Start.GetKionOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="外部サイトへ気温確認を行うRESTを使ったBO" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">api.openweathermap.org</Setting>
    <Setting Target="Adapter" Name="URL">/data/2.5/weather</Setting>
    <Setting Target="Host" Name="appid"></Setting>
    <Setting Target="Adapter" Name="SSLConfig">openweather</Setting>
  </Item>
  <Item Name="Start.InsertOperation" Category="" ClassName="Start.InsertOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="外部サイトから取得した情報をDBへ登録するBO（アダプタ無し）" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Start.WeatherCheckProcess" Category="" ClassName="Start.WeatherCheckProcess" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Start.WS.WebServiceBS" Category="" ClassName="Start.WS.WebServiceBS" PoolSize="0" Enabled="true" Foreground="false" Comment="Webサービス（Webリクエスト）用BS" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="EnableStandardRequests">1</Setting>
  </Item>
  <Item Name="Start.FileBS" Category="" ClassName="Start.FileBS" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/</Setting>
    <Setting Target="Adapter" Name="FileSpec">check.txt</Setting>
  </Item>
  <Item Name="Start.SQLInsertOperation" Category="" ClassName="Start.SQLInsertOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="外部サイトから取得した情報をDBへ登録するBO（アダプタ有）" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="DSN">IRIS1</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
  </Item>
  <Item Name="Start.NonAdapterBS" Category="" ClassName="Start.NonAdapterBS" PoolSize="0" Enabled="true" Foreground="false" Comment="アダプタを使わないBS（REST／ストアドからの呼び出し用）" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.JavaGateway.Service" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
