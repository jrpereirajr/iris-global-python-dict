Class UnitTest.jrpereira.UnitTest.jrpereira.SerializerInObjectScript Extends %UnitTest.TestCase
{

Parameter GNAME = "^testSerializerInObjectScript";

Method OnAfterOneTest(testname As %String) As %Status
{
  Set gname = ..#GNAME
  Kill @gname
  Quit $$$OK
}

Method TestSerializer()
{
  Set IrisGlobalSerializerType = ##class(%SYS.Python).Import("iris_global_serializer")
  Set employeeType = ##class(%SYS.Python).Import("employee")

  Set gname = ..#GNAME
  
  Set emp = employeeType.SalaryEmployee(10, "me", 123)
  Set emp.company = employeeType.Company("Company ABC")

  Set serializer = IrisGlobalSerializerType.IrisGlobalSerializer(gname)
  Set oid = serializer.serialize(emp)

  Do $$$AssertEquals(@gname@(oid,"class"), "<class 'employee.SalaryEmployee'>")
  Do $$$AssertEquals(@gname@(oid,"id","type"),"<class 'int'>")
  Do $$$AssertEquals(@gname@(oid,"id","value"),10)
  Do $$$AssertEquals(@gname@(oid,"name","type"),"<class 'str'>")
  Do $$$AssertEquals(@gname@(oid,"name","value"),"me")
  Do $$$AssertEquals(@gname@(oid,"note","type"),"<class 'NoneType'>")
  Do $$$AssertEquals(@gname@(oid,"note","value"),"")
  Do $$$AssertEquals(@gname@(oid,"weekly_salary","type"),"<class 'int'>")
  Do $$$AssertEquals(@gname@(oid,"weekly_salary","value"),123)
  Do $$$AssertEquals(@gname@(oid,"year_salary","type"),"<class 'int'>")
  Do $$$AssertEquals(@gname@(oid,"year_salary","value"),6396)
  Set companyOID = @gname@(oid,"company","oref")
  Do $$$AssertEquals(@gname@(oid,"company","type"),"<class 'iris_global_object.IrisGlobalObject'>")
  Do $$$AssertEquals(@gname@(companyOID,"class"),"<class 'employee.Company'>")
  Do $$$AssertEquals(@gname@(companyOID,"name","type"),"<class 'str'>")
  Do $$$AssertEquals(@gname@(companyOID,"name","value"),"Company ABC")
}

Method TestDeserializer()
{
  Set IrisGlobalSerializerType = ##class(%SYS.Python).Import("iris_global_serializer")
  Set employeeType = ##class(%SYS.Python).Import("employee")

  Set gname = ..#GNAME
  
  Set emp = employeeType.SalaryEmployee(10, "me", 123)
  Set emp.company = employeeType.Company("Company ABC")

  Set serializer = IrisGlobalSerializerType.IrisGlobalSerializer(gname)
  Set oid = serializer.serialize(emp)
  Set deserializedObj = serializer.deserialize(oid)

  Do $$$AssertEquals(deserializedObj."__repr__"(), emp."__repr__"(), "should had set/get OBJECT property")
  Do $$$AssertEquals(deserializedObj."calculate_payroll"(), emp."calculate_payroll"(), "should had set/get OBJECT property")
}

}
