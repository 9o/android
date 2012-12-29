using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace mantapatch
{
    class Program
    {
        static void Main(string[] args)
        {
		/*
		MERP - Fixes Nexus 10 bootloop and errors on factory image reset
		*/
            bool haveihelped = false;
            Console.Title = ("MERP");
            Console.WriteLine("---------------------------------------------\nMERP - Nexus 10 Factory Image Patcher\nby cyr0s (xda) @Complex360 (Twitter)\n---------------------------------------------");

            //Flash shell script
            if (File.Exists("flash-all.sh"))
            {
                Console.WriteLine("Found flash-all.sh, patching...");
                try
                {
                    //Check if already patched
                    string a = File.ReadAllText("flash-all.sh");
                    if (a.Contains("userdata.img"))
                    {
                        Console.WriteLine("flash-all.sh already patched!");
                    }
                    else
                    {
                        //If not already patch, patch.
                        File.AppendAllText("flash-all.sh", "# MERP patch - manually flash userdata and cache\nfastboot flash userdata userdata.img\nfastboot flash cache \"cache.img\"");
                        Console.ForegroundColor = ConsoleColor.Green;
                        Console.WriteLine("[+] flash-all.sh patched!");
                        Console.ForegroundColor = ConsoleColor.White;
                        haveihelped = true;
                    }
                    }
                catch (IOException)
                {
                    Console.WriteLine("IO Exception occured");
                }
            }

            //Flash batch script
            if (File.Exists("flash-all.bat"))
            {
                Console.WriteLine("Found flash-all.bat, patching...");
                try
                {
                    //Check if already patched
                    string bat = File.ReadAllText("flash-all.bat");
                    if (bat.Contains("userdata.img"))
                    {
                        Console.WriteLine("flash-all.bat already patched!");
                    }
                    else
                    {
                        //If not already patched, patch.
                        string batch = File.ReadAllText("flash-all.bat");
                        string write = batch.Replace("fastboot -w update image-mantaray-jop40c.zip", "fastboot -w update image-mantaray-jop40c.zip\n:: MERP patch - manually flash userdata and cache\nfastboot flash userdata userdata.img\nfastboot flash cache cache.img");
                        File.WriteAllText("flash-all.bat", write);
                        Console.ForegroundColor = ConsoleColor.Green;
                        Console.WriteLine("[+] flash-all.bat patched!");
                        Console.ForegroundColor = ConsoleColor.White;
                        haveihelped = true;
                    }
                }
                catch (IOException)
                {
                    Console.WriteLine("IO Exception occured");
                }

            }
            else
            {
                Console.WriteLine("No patchable files found! :(");
            }

            //Only bug the user for donations if you've done something worth donating for
            if (haveihelped)
            {
                File.WriteAllText("Read Please.txt", "Please consider donating some pennies (or more!) to me please :)\nhttp://forum.xda-developers.com/donatetome.php?u=4617809");
                Console.WriteLine("Please consider reading \"Read Please.txt\" - Or ignore it.");
            }
                Console.ReadLine();
        }
    }
}
