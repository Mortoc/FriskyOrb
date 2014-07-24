using UnityEngine;
using UnityEditor;

using System;
using System.Diagnostics;
using System.Collections.Generic;


public class OpenSublimeProject
{
	[MenuItem ("Tools/Open Project in Sublime %j")]
	public static void OpenProject()
	{
		var proc = new Process{
    		StartInfo = new ProcessStartInfo{
		        FileName = "subl",
		        Arguments = Application.dataPath + "/../FriskyOrb.sublime-project",
		        UseShellExecute = false,
		        RedirectStandardOutput = true,
		        CreateNoWindow = true
    		}
    	};
    	proc.Start();
		while (!proc.StandardOutput.EndOfStream) {
		    string line = proc.StandardOutput.ReadLine();
		    // do something with line
		    if( line.Length > 0 )
		    	UnityEngine.Debug.Log(line);
		}
	}

}
