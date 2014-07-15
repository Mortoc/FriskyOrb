using UnityEngine;
using System;

public class Loft
{
    public ISpline Path { get; private set; }
    public ISpline Shape { get; private set; }

    public float Banking { get; set; }


    public Loft(ISpline path, ISpline shape)
    {
        if (path == null)
            throw new ArgumentNullException("path");
        if (shape == null)
            throw new ArgumentNullException("shape");
        
        Path = path;
        Shape = shape;
    }

    public Mesh GenerateMesh(uint pathSegments, uint shapeSegments)
    {
        throw new NotImplementedException();
    }
}
