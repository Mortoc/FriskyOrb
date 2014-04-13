using UnityEngine;
using System;
using System.Collections.Generic;

public class LevelNameManager : MonoBehaviour
{

    [SerializeField]
    private TextAsset _levelNamesCSV;

    private string[] _descriptors;
    private string[] _firstNouns;
    private string[] _lastNouns;
    private string[] _suffixes;

    private bool _parsed = false;
    public void ParseNames()
    {
        if (_parsed)
            return;

        string[] parsedStrings = _levelNamesCSV.text.Split(',', '\n');
        List<string> descriptors = new List<string>();
        List<string> firstNouns = new List<string>();
        List<string> lastNouns = new List<string>();
        List<string> suffixes = new List<string>();

        int count = -1;
        int index = 0;
        while (count < 0)
        {
            ++index;
            string str = parsedStrings[index];
            if (str.StartsWith("\"") && str.EndsWith("\""))
            {
                count = int.Parse
                (
                    str.Substring(1, str.Length - 2)
                );
            }
        }

        Action<List<String>, int> addParsedValue = (stringList, i) =>
        {
            string val = parsedStrings[i].Trim();
            if (val.Length > 0)
            {
                if (val == "-")
                    stringList.Add("");
                else
                    stringList.Add(val);
            }
        };
        for (; index < parsedStrings.Length; ++index)
        {
            addParsedValue(descriptors, ++index);
            addParsedValue(firstNouns, ++index);
            addParsedValue(lastNouns, ++index);
            addParsedValue(suffixes, ++index);
        }
        _descriptors = descriptors.ToArray();
        _firstNouns = firstNouns.ToArray();
        _lastNouns = lastNouns.ToArray();
        _suffixes = suffixes.ToArray();

        NameCount = count;
    }

    public int NameCount { get; private set; }

    public string GetName(int levelNum)
    {
		if (NameCount == 0)
			ParseNames();

        if (levelNum > NameCount || levelNum < 0)
			throw new ArgumentOutOfRangeException(String.Format("levelNum is {0} but must be in the range [0, {1})", levelNum, NameCount));

        int suffixIdx = levelNum % _suffixes.Length;
        levelNum /= _suffixes.Length;
        
        int lastNounIdx = levelNum % _lastNouns.Length;
        levelNum /= _lastNouns.Length;

        int firstNounIdx = levelNum % _firstNouns.Length;
        levelNum /= _firstNouns.Length;

        int descriptorIdx = levelNum % _descriptors.Length;
        levelNum /= _descriptors.Length;

        string result = String.Format
        (
            "{0} {1} {2} {3}",
            _descriptors[descriptorIdx],
            _firstNouns[firstNounIdx],
            _lastNouns[lastNounIdx],
            _suffixes[suffixIdx]
        ).Trim();

        return result;
    }

    void Awake()
    {
        ParseNames();
    }
}
