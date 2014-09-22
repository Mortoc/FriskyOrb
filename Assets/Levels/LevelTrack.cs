using UnityEngine;
using System.Collections.Generic;

namespace RtInfinity.Levels
{
    public interface ILevelTrack
    {
        /// <summary>
        /// Strategy object that is responsible for generating the mesh of a level
        /// </summary>
        ITrackGenerator Generator { get; }

        Vector3 GetSurfacePoint(float travelDist, float x);
        void UpdatePlayerPosition(float travelDist);
    }

    public class LevelTrackBase : ILevelTrack
    {

    }
}