namespace UvPointTracking
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;

    public class UvPointTrackerManager : MonoBehaviour
    {
        public MeshFilter meshFilter;
        [HideInInspector] public List<UvPointTracker> pointsToTrack = new List<UvPointTracker>();
        public float allowableDistanceSquared = .001f;

        void Update()
        {
            if (meshFilter.mesh)
            {
                foreach (UvPointTracker uvPointTracker in pointsToTrack)
                {
                    uvPointTracker.foundThisFrame = false;
                }

                for (int i = 0; i < meshFilter.mesh.vertexCount; ++i)
                {
                    foreach (UvPointTracker uvPointTracker in pointsToTrack)
                    {
                        if (!uvPointTracker.foundThisFrame && (meshFilter.mesh.uv[i] - uvPointTracker.uvPosition).SqrMagnitude() < allowableDistanceSquared)
                        {
                            uvPointTracker.UpdatePostion(meshFilter.mesh.vertices[i]);
                            uvPointTracker.foundThisFrame = true;
                        }
                    }
                }
            }
        }
    }
}
