namespace MouthOverlaySystem
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;

    public enum MouthOverlayType { mesh, material }
    public abstract class MouthOverlayBase : MonoBehaviour
    {
        protected MouthOverlayManager mouthOverlayManager;
        public void Awake()
        {
            mouthOverlayManager = GameObject.FindObjectOfType<MouthOverlayManager>();
            Deactivate();
            Hide();
        }

        public abstract void Activate();
        public abstract void Deactivate();
        public abstract void Hide();
        public abstract void Show();
    }
}
