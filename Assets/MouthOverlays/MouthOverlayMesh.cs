using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouthOverlayMesh : MouthOverlayBase
{
    public GameObject[] mouthMeshArray;

    public override void Activate()
    {
        this.gameObject.SetActive(true);
        
        mouthOverlayManager.renderer_faceMesh.enabled = false;
        foreach(GameObject mouthMesh in mouthMeshArray)
        {
            mouthMesh.transform.SetParent(mouthOverlayManager.mouthTrackingPoint.transform);
            mouthMesh.transform.localPosition = Vector3.zero;
            mouthMesh.transform.localRotation = Quaternion.identity;
            mouthMesh.SetActive(true);
        }
    }

    public override void Deactivate()
    {
        this.gameObject.SetActive(false);
        
        foreach (GameObject mouthMesh in mouthMeshArray)
        {
            mouthMesh.transform.SetParent(this.transform);
            mouthMesh.SetActive(false);
        }
    }

    public override void Hide()
    {
        foreach (GameObject mouthMesh in mouthMeshArray)
        {
            mouthMesh.SetActive(false);
        }
    }

    public override void Show()
    {
        foreach (GameObject mouthMesh in mouthMeshArray)
        {
            mouthMesh.SetActive(true);
        }
    }
}
