#Imago <imagotrigger@gmail.com>
# Stops Server, Stops Lobby, Replaces, Reregisters, Starts Lobby, Starts Server
#  This file is for host BETA

use strict;
use Win32::OLE;
use Win32::Process;

print "executing autoupdate shutdown...\n";

my $cmd = "C:\\Allegiance\\Server\\AutoUpdate.exe";
my $ProcessObj = "";
Win32::Process::Create($ProcessObj,
	$cmd,
	"AutoUpdate shutdown",
	0,
	NORMAL_PRIORITY_CLASS|CREATE_NEW_CONSOLE,
	"C:\\Allegiance\\Server") || die "failed to create autoupdate.exe process\n";
	
$ProcessObj->Wait(INFINITE);
sleep(6);

my $cmd = "C:\\Perl\\bin\\Perl.exe";
$ProcessObj = "";
Win32::Process::Create($ProcessObj,
	$cmd,
	"Perl Z:\\Deploy\\busy.pl",
	0,
	NORMAL_PRIORITY_CLASS|CREATE_NEW_CONSOLE,
	"C:\\Perl\\bin") || die "failed to create perl process\n";
	
$ProcessObj->Wait(INFINITE);
my $exitcode;
$ProcessObj->GetExitCode($exitcode);
if ($exitcode == 1) {
	print "Lobby is still not idle, aborting\n";
	exit 1;
}

my $sl = Win32::OLE->GetObject("WinNT://beta.alleg.net/AllLobby,service");
print "Stopping AllLobby service\n";	
$sl->Stop();
sleep(6);

if ($sl && $sl->Status == 4) {
	print "Lobby wouldn't stop!\n";
	exit 1;	
}

print "executing un regsvr32 AGC.dll...\n";

my $cmd = "regsvr32 C:\\Allegiance\\Server\\AGC.dll /u /s";
system($cmd);

sleep(12);

print "copying new objects...\n";

my $cmd = "expand Z:\\deploy\\temp\\AGC.dll C:\\Allegiance\\Server\\AGC.dll";
system($cmd);
my $cmd = "expand Z:\\deploy\\temp\\AllSrvUI.exe C:\\Allegiance\\Server\\AllSrvUI.exe";
system($cmd);
my $cmd = "expand Z:\\deploy\\temp\\AllSrv.exe C:\\Allegiance\\Server\\AllSrv.exe";
system($cmd);
my $cmd = "expand Z:\\deploy\\temp\\dbghelp.dll C:\\Allegiance\\Server\\dbghelp.dll";
system($cmd);
my $cmd = "copy Z:\\deploy\\AllLobby.exe C:\\Allegiance\\Lobby\\AllLobby.exe /Y";
system($cmd);
my $cmd = "expand Z:\\deploy\\temp\\dbghelp.dll C:\\Allegiance\\Lobby\\dbghelp.dll";
system($cmd);

print "updating autoupdate...\n";

my $cmd = "copy Z:\\deploy\\temp\\AutoUpdate.exe C:\\Allegiance\\Server\\AutoUpdate.exe /Y";
system($cmd);

print "executing regsvr32 AGC.dll...\n";

my $cmd = "regsvr32 C:\\Allegiance\\Server\\AGC.dll /s";
system($cmd);

sleep(12);

print "executing allsrv rereg...\n";

my $cmd = "C:\\Allegiance\\Server\\AllSrv.exe";
my $ProcessObj = "";
Win32::Process::Create($ProcessObj,
	$cmd,
	"AllSrv -service",
	0,
	NORMAL_PRIORITY_CLASS|CREATE_NEW_CONSOLE,
	"C:\\Allegiance\\Server") || die "failed to create allsrv.exe reregister process\n";


print "Starting Lobby service\n";	
$sl->Start();
sleep(6);

print "Starting AllSrv service\n";	
my $s = Win32::OLE->GetObject("WinNT://beta.alleg.net/AllSrv,service");
$s->Start();
sleep(12);
$s->Start();

if ($sl && $sl->Status != 4) {
	print "Lobby wouldn't start!\n";
	exit 1;	
}

exit 0;


