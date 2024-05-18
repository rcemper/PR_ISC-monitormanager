Class JK.MONMGR.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="JK.MONMGR.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Setting Target="Adapter" Name="ShutdownTimeout">20</Setting>
  <Item Name="jJKservice" Category="" ClassName="JK.MONMGR.CustomService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">30</Setting>
  </Item>
</Production>
}
}
