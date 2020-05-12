using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouthOverlayMaterial : MouthOverlayBase
{
    public Material faceMat;

    public override void Activate()
    {
        mouthOverlayManager.renderer_faceMesh.enabled = true;
        mouthOverlayManager.renderer_faceMesh.material = faceMat;
    }

    public override void Deactivate()
    {
        mouthOverlayManager.renderer_faceMesh.enabled = false;

    }

    public override void Hide()
    {
        mouthOverlayManager.renderer_faceMesh.enabled = false;
    }

    public override void Show()
    {
        mouthOverlayManager.renderer_faceMesh.enabled = true;
    }
}
