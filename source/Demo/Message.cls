Class Demo.Message Extends (%Persistent,%JSON.Adaptor)
{
Property Name As %String;
Property Text As %String(MAXLEN=140);
Property TimePosted As %TimeStamp;

Index timeIdx on TimePosted;
Index nameIdx on Name;

Storage Default
{
<Data name="MessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>User</Value>
</Value>
<Value name="3">
<Value>Text</Value>
</Value>
<Value name="4">
<Value>Time</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>TimePosted</Value>
</Value>
</Data>
<DataLocation>^Demo.MessageD</DataLocation>
<DefaultData>MessageDefaultData</DefaultData>
<IdLocation>^Demo.MessageD</IdLocation>
<IndexLocation>^Demo.MessageI</IndexLocation>
<StreamLocation>^Demo.MessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}