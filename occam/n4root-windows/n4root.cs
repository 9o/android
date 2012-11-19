﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Windows.Forms;

namespace n4rootr
{
    class Program
    {
        //Used for executing adb/fastboot commands
        private static void sendCMD(string exe, string arg)
        {
            System.Diagnostics.Process proc = new System.Diagnostics.Process();

            proc.EnableRaisingEvents = false;
            proc.StartInfo.FileName = "./files/" + exe + ".exe";
            proc.StartInfo.Arguments = arg + " 2> nul";
            proc.StartInfo.RedirectStandardOutput = true;
            proc.StartInfo.UseShellExecute = false;
            proc.StartInfo.CreateNoWindow = true;
            proc.Start();
            proc.WaitForExit();

        }
        static void Main(string[] args)
        {
            //File checking - To avoid angering 12 year olds
            string[] essential = new string[8];
            essential[0] = "adb.exe";
            essential[1] = "AdbWinApi.dll";
            essential[2] = "AdbWinUsbApi.dll";
            essential[3] = "boot.img";
            essential[4] = "busybox";
            essential[5] = "fastboot.exe";
            essential[6] = "su";
            essential[7] = "Superuser.apk";

            foreach (string file in essential)
            {
                if (!File.Exists("./files/" + file))
                {
                    MessageBox.Show("An essential file doesn't exist. Please re-download n4root and if that doesn't work contact me (@Complex360 or cyr0s on xda)", "Fatal error");
                    System.Environment.Exit(0);
                }
            }

            Console.ForegroundColor = ConsoleColor.Cyan;
            Console.WriteLine("--------------------------------------------------------------------");
            Console.WriteLine("n4root - Nexus 4 rooting tool by cyr0s (XDA) @Complex360 (Twitter)");
			Console.Writeline("MASSIVE props to Kumouri for making this tool actually helpful :)");
            Console.WriteLine("--------------------------------------------------------------------");
            Console.ForegroundColor = ConsoleColor.DarkMagenta;
            using (System.Diagnostics.Process procc = new System.Diagnostics.Process())
            {
                procc.EnableRaisingEvents = false;
                procc.StartInfo.FileName = "./files/adb.exe";
                procc.StartInfo.Arguments = "devices";
                procc.StartInfo.RedirectStandardOutput = true;
                procc.StartInfo.UseShellExecute = false;
                procc.StartInfo.CreateNoWindow = false;
                procc.Start();
                procc.WaitForExit();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());
            }
            Console.ForegroundColor = ConsoleColor.Cyan;
            Console.WriteLine("If no devices are listed, please install Nexus 4 drivers.");
            Console.WriteLine("1)Go to Settings > Developer options\n2)Enable \"USB Debugging\" and then press [ENTER]");
            Console.ReadLine();
            Console.WriteLine("Attempting to reboot into bootloader...");

            //Process for unlocking bootloader
            sendCMD("adb", "reboot bootloader");
            Console.WriteLine("When bootloader loads press [ENTER]");
            Console.ReadLine();
            Console.WriteLine("Attempting to unlock bootloader (when a prompt appears press YES - DATA WILL BE WIPED!)");
            sendCMD("fastboot", "oem unlock");
            Console.WriteLine("When you have unlocked the bootloader, press [ENTER]");
            Console.ReadLine();
            // Reboots only seem to work through the process, not through sendCMD, so doing it here
            using (System.Diagnostics.Process procc = new System.Diagnostics.Process())
            {
                procc.EnableRaisingEvents = false;
                procc.StartInfo.FileName = "./files/fastboot.exe";
                procc.StartInfo.Arguments = "reboot";
                procc.StartInfo.RedirectStandardOutput = true;
                procc.StartInfo.UseShellExecute = false;
                procc.StartInfo.CreateNoWindow = false;
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());
            }
            Console.WriteLine("Wait for reboot, enable USB debugging once more and press [ENTER]");
            Console.ReadLine();
            sendCMD("adb", "reboot bootloader");
            Console.WriteLine("When bootloader loads press [ENTER]");
            Console.ReadLine();

            //Booting with insecure boot.img for root access to /system/
            Console.WriteLine("Booting into insecure boot.img");
            using (System.Diagnostics.Process procc = new System.Diagnostics.Process())
            {
                procc.EnableRaisingEvents = false;
                procc.StartInfo.FileName = "./files/fastboot.exe";
                procc.StartInfo.Arguments = "boot ./files/boot.img";
                procc.StartInfo.RedirectStandardOutput = true;
                procc.StartInfo.UseShellExecute = false;
                procc.StartInfo.CreateNoWindow = false;
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                // Just force the reboot so the user doesn't get confused
                procc.StartInfo.Arguments = "reboot";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());
            }
            Console.WriteLine("Good news, you're almost done! When device loads, enable USB Debugging again and press [ENTER]");
            Console.ReadLine();

            //Sort out perms for su binary, SuperUser etc
            using (System.Diagnostics.Process procc = new System.Diagnostics.Process())
            {
                procc.EnableRaisingEvents = false;
                procc.StartInfo.FileName = "./files/adb.exe";
                procc.StartInfo.Arguments = "shell mount -o remount,rw /system";
                procc.StartInfo.RedirectStandardOutput = true;
                procc.StartInfo.UseShellExecute = false;
                procc.StartInfo.CreateNoWindow = false;
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                // For some reason when I do it through the process instead of through sendCMD
                // it works and when I reboot the SU app is there.
                procc.StartInfo.Arguments = "push ./files/su /system/bin";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                procc.StartInfo.Arguments = "push ./files/Superuser.apk /system/app";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                procc.StartInfo.Arguments = "push ./files/busybox /system/xbin/";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                procc.StartInfo.Arguments = "shell chmod 06755 /system/bin/su";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                procc.StartInfo.Arguments = "shell chmod 0644 /system/app/Superuser.apk";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                procc.StartInfo.Arguments = "shell chmod 04755 /system/xbin/busybox";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                procc.StartInfo.Arguments = "shell cd /system/xbin/ && busybox --install /system/xbin/";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());

                // Have to reboot for new system apps to show up, I think...
                // It doesn't show up until a reboot on my device
                procc.StartInfo.Arguments = "reboot";
                procc.Start();
                Console.WriteLine(procc.StandardOutput.ReadToEnd());
            }
			
			//Old, broken code using sendCMD (it doesn't work, but if you can find out why then I'd love to know) 
			
            //sendCMD("adb", "shell mount -o remount,rw /system");
            //sendCMD("adb", "push ./files/su /system/bin");
            //sendCMD("adb", "push ./files/Superuser.apk /system/app");
            //sendCMD("adb", "push ./files/busybox /system/xbin/");
            //sendCMD("adb", "shell chmod 06755 /system/bin/su");
            //sendCMD("adb", "shell chmod 0644 /system/app/Superuser.apk");
            //sendCMD("adb", "shell chmod 04755 /system/xbin/busybox");
            //sendCMD("adb", "shell cd /system/xbin/ && busybox -- install /system/xbin/");
