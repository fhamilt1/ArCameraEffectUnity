namespace UvPointTracking
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;

    public class UvPointTracker : MonoBehaviour
    {
        UvPointTrackerManager uvPointTrackerManager;
        public Vector2 uvPosition;
        [HideInInspector] public bool foundThisFrame = false;

        public void Awake()
        {
            uvPointTrackerManager = GameObject.FindObjectOfType<UvPointTrackerManager>();
            this.transform.SetParent(uvPointTrackerManager.meshFilter.transform);
        }

        public void OnEnable()
        {
            uvPointTrackerManager.pointsToTrack.Add(this);
        }

        public void OnDisable()
        {
            uvPointTrackerManager.pointsToTrack.Remove(this);
        }

        public void UpdatePostion (Vector3 newLocalPosition)
        {
            this.transform.localPosition = newLocalPosition;
            this.transform.localRotation = Quaternion.identity;
        }
    }
}

