/////////////////////////////////////////////////////////////////////////////
// Entry point simply calls the main function.

try
{
  main(WScript.Arguments, WScript.Arguments.Count());
}
catch(e)
{
  WScript.Echo("ERROR: \"" + e.description + "\"");
}


/////////////////////////////////////////////////////////////////////////////
// Description: Parses the command line parameters and validates the usage.
//
function main(args, cArgs)
{
  // Validate the command line arguments
  if (cArgs > 1)
    return Syntax();
  if (cArgs && ("-?" == args(0) || "/?" == args(0)))
    return Syntax();

  // Connect to the AllSrv object model
  var objSession = new ActiveXObject("AllSrv.AdminSession");

  // Get the EventLog property
  var objEventLog = objSession.EventLog;

  // Get the current EventLogParams property
  var objOld = objEventLog.DBEventLog;
  if (!objOld)
    objOld = new ActiveXObject("AGC.DBParams");

  // Either set or get the property
  var str;
  if (cArgs)
  {
    // Break-out the server name and table name
    var re = /(.*)\\(.*)\\(.*)/;
    re.exec(args(0));
    if ("" == RegExp.$1 || "" == RegExp.$2 || "" == RegExp.$3)
      return Syntax();

    // Create an AGCDBParams object
    var objNew = new ActiveXObject("AGC.DBParams");

    // Format the OLEDB connection string and table name
    objNew.ConnectionString = "PROVIDER=SQLOLEDB"
      + ";Server="   + RegExp.$1
      + ";DATABASE=" + RegExp.$2
      + ";UID=sa;PWD=";
    objNew.TableName = RegExp.$3;

    // Set the new DBParams
    objEventLog.DBEventLog = objNew;

    // Format the response message
    str = "The AllSrv EventLogParams changed\n"
      + "from: \"" + objOld.ConnectionString + "\", \"" + objOld.TableName + "\"\n"
      + "to  : \"" + objNew.ConnectionString + "\", \"" + objNew.TableName + "\"";
  }
  else
  {
    // Format the response message
    str = "The current AllSrv EventLogParams are:\n"
      + "  \"" + objOld.ConnectionString + "\", \"" + objOld.TableName + "\"\n";
  }

  // Display the response message
  WScript.Echo(str);
}


/////////////////////////////////////////////////////////////////////////////
// Displays the usage syntax of this script
//
function Syntax()
{
  var str =
    "\nDisplays or changes the current AllSrv EventLog server\\database\\table\n\n"
    + "Usage:\n\n"
    + "  EventLogDB\n"
    + "  EventLogDB new_database_server\\database_name\\table_name\n\n"
    // ----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
    + "When no parameter is specified, the current AllSrv Event Log Parameters are\n"
    + "displayed.  Otherwise, the AllSrv Event Log Parameters are set based on the\n"
    + "specified strings.";
  WScript.Echo(str);
}



