namespace MouthOverlaySystem
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;
    using Recorder;

    public class MouthOverlayManager : MonoBehaviour
    {
        [SerializeField] private int indexMouthOverlay = 0;

        [SerializeField] private MouthOverlayBase[] mouthOverlays = null;

        public Renderer renderer_faceMesh;

        public UvPointTracking.UvPointTracker mouthTrackingPoint;

        [SerializeField] private AudioClip[] audioClips = null;
        [SerializeField] private int indexAudio = 0;
        [SerializeField] private AudioSource audioSource = null;

        [SerializeField] private UnityEngine.UI.Image[] overlayButtons = null;
        [SerializeField] private UnityEngine.UI.Image[] audioButtons = null;
        [SerializeField] private Color defaultColor = Color.white;
        [SerializeField] private Color selectedColor = Color.white;

        [SerializeField] private RecordManager recordManager = null;
        [SerializeField] private bool recording = false;
        [SerializeField] private UnityEngine.UI.Image recordImage = null;
        [SerializeField] private UnityEngine.UI.Image saveImage = null;


        public void ToggleRecAndSave()
        {
            if (recording)
            {
                recordManager.StopRecord();
                saveImage.gameObject.SetActive(false);
                recordImage.gameObject.SetActive(true);
                recording = false;
            }
            else
            {
                recordManager.StartRecord();
                saveImage.gameObject.SetActive(true);
                recordImage.gameObject.SetActive(false);
                recording = true;
            }
        }

        public void Start()
        {
            StartCoroutine(DelayStart());
            saveImage.gameObject.SetActive(false);
            recordImage.gameObject.SetActive(true);
        }

        IEnumerator DelayStart()
        {
            yield return new WaitForSeconds(.3f);
            SetHighlightAudio(true);
            SetHighlightOverlay(true);
        }

        public void CycleUp()
        {
            SetHighlightOverlay(false);

            ++indexMouthOverlay;
            if (indexMouthOverlay == mouthOverlays.Length)
            {
                indexMouthOverlay = 0;
            }

            SetHighlightOverlay(true);
        }

        public void CycleDown()
        {
            SetHighlightOverlay(false);

            --indexMouthOverlay;
            if (indexMouthOverlay < 0)
            {
                indexMouthOverlay = mouthOverlays.Length - 1;
            }

            SetHighlightOverlay(true);
        }

        public void CycleRight()
        {
            SetHighlightAudio(false);

            ++indexAudio;
            if (indexAudio == audioClips.Length)
            {
                indexAudio = 0;
            }

            SetHighlightAudio(true);
        }

        public void CycleLeft()
        {
            SetHighlightAudio(false);

            --indexAudio;
            if (indexAudio < 0)
            {
                indexAudio = audioClips.Length - 1;
            }

            SetHighlightAudio(true);
        }

        public void Hide()
        {
            mouthOverlays[indexMouthOverlay].Hide();
            audioSource.Stop();
        }

        public void Show()
        {
            mouthOverlays[indexMouthOverlay].Show();
            audioSource.Play();
        }

        public void SetIndexMouthOverlay(int newIndex)
        {
            SetHighlightOverlay(false);

            indexMouthOverlay = Mathf.Clamp(newIndex, 0, audioClips.Length);

            SetHighlightOverlay(true);
        }

        private void SetHighlightOverlay(bool enabled)
        {
            if (enabled)
            {
                mouthOverlays[indexMouthOverlay].Activate();
                mouthOverlays[indexMouthOverlay].Hide();

                overlayButtons[indexMouthOverlay].color = selectedColor;
            }
            else
            {
                mouthOverlays[indexMouthOverlay].Deactivate();
                overlayButtons[indexMouthOverlay].color = defaultColor;
            }
        }

        public void SetIndexSoundEffect(int newIndex)
        {
            SetHighlightAudio(false);

            indexAudio = Mathf.Clamp(newIndex, 0, audioClips.Length);
            SetHighlightAudio(true);
        }

        private void SetHighlightAudio(bool enabled)
        {
            if (enabled)
            {
                audioSource.clip = audioClips[indexAudio];
                audioButtons[indexAudio].color = selectedColor;
            }
            else
            {
                audioButtons[indexAudio].color = defaultColor;
            }
        }
    }
}
