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
        if( pathSegments < 2 )
            throw new ArgumentException("pathSegments must be at least 2");
        if( shapeSegments < 2 )
            throw new ArgumentException("pathSegments must be at least 2");

        Mesh mesh = new Mesh();

        Vector3[] verts = new Vector3[pathSegments * shapeSegments];

        Func<uint, uint, int> uvToVertIdx = (shapeSegment, pathSegment) => {
            return (int)((pathSegment * shapeSegments) + shapeSegment);
        };

        int[] tris = new int[(pathSegments-1) * (shapeSegments-1) * 6];

        float pathStep = 1.0f / (float)pathSegments;
        float shapeStep = 1.0f / (float)shapeSegments;

        for(uint pathSeg = 0; pathSeg < pathSegments; ++pathSeg)
        {
            var pathPnt = Path.ParametricSample(pathStep * (float)pathSeg);
            for(uint shapeSeg = 0; shapeSeg < shapeSegments; ++shapeSeg)
            {
                var shapePnt = Shape.ParametricSample(shapeStep * (float)shapeSeg);
                verts[uvToVertIdx(shapeSeg, pathSeg)] = pathPnt + shapePnt;
            }
        }

        for(uint pathSeg = 0; pathSeg < pathSegments - 1; ++pathSeg)
        {
            for(uint shapeSeg = 0; shapeSeg < shapeSegments - 1; ++shapeSeg)
            {
                var triIdx = uvToVertIdx(pathSeg, shapeSeg) * 6;
                // tris[triIdx] = uvToVertIdx(pathSeg, shapeSeg);
                // tris[triIdx + 1] = uvToVertIdx(pathSeg + 1, shapeSeg);
                // tris[triIdx + 2] = uvToVertIdx(pathSeg, shapeSeg + 1);

                // tris[triIdx + 3] = uvToVertIdx(pathSeg, shapeSeg + 1);
                // tris[triIdx + 4] = uvToVertIdx(pathSeg + 1, shapeSeg);
                // tris[triIdx + 5] = uvToVertIdx(pathSeg + 1, shapeSeg + 1);
            }
        }
        mesh.vertices = verts;
        mesh.triangles = tris;

        return mesh;
    }
}
